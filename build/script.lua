--[[
    ╔═══════════════════════════════════════════════════╗
    ║          Roblox FishIt Script - Bundled          ║
    ║                                                   ║
    ║  Build Date: 2025-11-16 20:04:49                        ║
    ║  Version: 2.0.0                              ║
    ║                                                   ║
    ║  ⚠️  FOR EDUCATIONAL PURPOSES ONLY               ║
    ║                                                   ║
    ╚═══════════════════════════════════════════════════╝
]]


-- ============================================
-- MODULE SYSTEM
-- ============================================

local Modules = {}
local LoadedModules = {}

-- Custom require function
local function require(moduleName)
    -- Normalize module name
    moduleName = moduleName:gsub("^src/", "")
    moduleName = moduleName:gsub("%.lua$", "")

    -- Return cached module if already loaded
    if LoadedModules[moduleName] then
        return LoadedModules[moduleName]
    end

    -- Get module function
    local moduleFunc = Modules[moduleName]
    if not moduleFunc then
        error("Module not found: " .. moduleName)
    end

    -- Execute module and cache result
    local result = moduleFunc()
    LoadedModules[moduleName] = result
    return result
end

-- ============================================
-- MODULES
-- ============================================

-- Module: core/services
Modules["core/services"] = function()
    --[[
        Services Module

        Provides access to Roblox game services.
        This is a core module that should be loaded first.

        Usage:
            local Services = require("src/core/services")
            print(Services.Players.LocalPlayer.Name)
    ]]

    local Services = {}

    -- Game services
    Services.Players = game:GetService("Players")
    Services.RunService = game:GetService("RunService")
    Services.HttpService = game:GetService("HttpService")
    Services.ReplicatedStorage = game:GetService("ReplicatedStorage")
    Services.VirtualInputManager = game:GetService("VirtualInputManager")
    Services.GuiService = game:GetService("GuiService")
    Services.CoreGui = game:GetService("CoreGui")
    Services.TeleportService = game:GetService("TeleportService")

    -- Shortcuts
    Services.RS = Services.ReplicatedStorage
    Services.VIM = Services.VirtualInputManager
    Services.Camera = workspace.CurrentCamera
    Services.LocalPlayer = Services.Players.LocalPlayer
    Services.PlayerGui = Services.LocalPlayer:WaitForChild("PlayerGui")

    -- Game-specific requires
    Services.Net = Services.RS.Packages._Index["sleitnick_net@0.2.0"].net
    Services.Replion = require(Services.RS.Packages.Replion)
    Services.FishingController = require(Services.RS.Controllers.FishingController)
    Services.TradingController = require(Services.RS.Controllers.ItemTradingController)
    Services.ItemUtility = require(Services.RS.Shared.ItemUtility)
    Services.VendorUtility = require(Services.RS.Shared.VendorUtility)
    Services.PlayerStatsUtility = require(Services.RS.Shared.PlayerStatsUtility)
    Services.Effects = require(Services.RS.Shared.Effects)
    Services.NotifierFish = require(Services.RS.Controllers.TextNotificationController)

    return Services

end

-- Module: core/constants
Modules["core/constants"] = function()
    --[[
        Constants Module

        Contains all constant values used throughout the script:
        - Fish tiers/rarities
        - Fish variants
        - Ignored events
        - Rod priority list
    ]]

    local Constants = {}

    -- Fish rarity tiers
    Constants.TIER_FISH = {
        [1] = " ",
        [2] = "Uncommon",
        [3] = "Rare",
        [4] = "Epic",
        [5] = "Legendary",
        [6] = "Mythic",
        [7] = "Secret"
    }

    -- Fish variants
    Constants.VARIANTS = {
        "Galaxy",
        "Corrupt",
        "Gemstone",
        "Ghost",
        "Lightning",
        "Fairy Dust",
        "Gold",
        "Midnight",
        "Radioactive",
        "Stone",
        "Holographic",
        "Albino",
        "Bloodmoon",
        "Sandy",
        "Acidic",
        "Color Burn",
        "Festive",
        "Frozen"
    }

    -- Events to ignore in auto-event system
    Constants.IGNORED_EVENTS = {
        Cloudy = true,
        Day = true,
        ["Increased Luck"] = true,
        Mutated = true,
        Night = true,
        Snow = true,
        ["Sparkling Cove"] = true,
        Storm = true,
        Wind = true,
        UIListLayout = true,
        ["Admin - Shocked"] = true,
        ["Admin - Super Mutated"] = true,
        Radiant = true
    }

    -- Rod priority for auto-equip (highest priority first)
    Constants.ROD_PRIORITY = {
        "Element Rod",
        "Ghostfin Rod",
        "Bambo Rod",
        "Angler Rod",
        "Ares Rod",
        "Hazmat Rod",
        "Astral Rod",
        "Midnight Rod"
    }

    -- Event position offsets (Y-axis)
    Constants.EVENT_OFFSETS = {
        ["Worm Hunt"] = 25
    }

    return Constants

end

-- Module: core/state
Modules["core/state"] = function()
    --[[
        State Module

        Global state management for the script.
        Contains all runtime state and configuration.

        Usage:
            local State = require("src/core/state")
            State.autoInstant = true
    ]]

    local Services = require("src/core/services")
    local Constants = require("src/core/constants")

    local State = {
        -- Fishing
        autoInstant = false,
        canFish = true,
        Instant = false,
        CancelWaitTime = 3,
        ResetTimer = 0.5,
        hasTriggeredBug = false,
        lastFishTime = 0,
        fishConnected = false,
        lastCancelTime = 0,
        hasFishingEffect = false,

        -- Selling
        autoSellEnabled = false,
        sellMode = "Delay",  -- "Delay" or "Count"
        sellDelay = 60,
        inputSellCount = 50,

        -- Favorites
        autoFavEnabled = false,
        selectedName = {},
        selectedRarity = {},
        selectedVariant = {},

        -- Events
        autoEventActive = false,
        selectedEvents = {},
        autoWeather = false,
        curCF = nil,
        origCF = nil,
        offs = Constants.EVENT_OFFSETS,
        ignore = Constants.IGNORED_EVENTS,

        -- Position
        savedCFrame = nil,
        flt = false,
        con = nil,

        -- Rods & Baits
        rodDataList = {},
        rodDisplayNames = {},
        baitDataList = {},
        baitDisplayNames = {},
        selectedRodId = nil,
        selectedBaitId = nil,
        rods = {},
        baits = {},
        weathers = {},

        -- Player references
        player = Services.LocalPlayer,
        stats = Services.LocalPlayer:WaitForChild("leaderstats"),
        caught = Services.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Caught"),
        char = Services.LocalPlayer.Character or Services.LocalPlayer.CharacterAdded:Wait(),
        vim = Services.VIM,
        cam = Services.Camera,

        -- Trading
        trade = {
            selectedPlayer = nil,
            selectedItem = nil,
            tradeAmount = 1,
            targetCoins = 0,
            trading = false,
            awaiting = false,
            lastResult = nil,
            successCount = 0,
            failCount = 0,
            totalToTrade = 0,
            sentCoins = 0,
            successCoins = 0,
            failCoins = 0,
            totalReceived = 0,
            currentGrouped = {},
            TotemActive = false
        },

        -- Notifications
        notifConnections = {},
        defaultHandlers = {},
        disabledCons = {},
        CEvent = true,

        -- Misc
        lcc = 0,
        lastState = nil
    }

    return State

end

-- Module: network/events
Modules["network/events"] = function()
    --[[
        Network Events Module

        Remote Events for client-server communication.
        All FireServer() calls use these events.

        Usage:
            local Events = require("src/network/events")
            Events.REFishDone:FireServer()
    ]]

    local Services = require("src/core/services")
    local Net = Services.Net

    local Events = {
        -- Cutscene events
        RECutscene = Net["RE/ReplicateCutscene"],
        REStop = Net["RE/StopCutscene"],

        -- Favorite events
        REFav = Net["RE/FavoriteItem"],
        REFavChg = Net["RE/FavoriteStateChanged"],

        -- Fishing events
        REFishDone = Net["RE/FishingCompleted"],
        REFishGot = Net["RE/FishCaught"],
        REPlayFishEffect = Net["RE/PlayFishingEffect"],
        FishingMinigameChanged = Net["RE/FishingMinigameChanged"],
        FishingStopped = Net["RE/FishingStopped"],

        -- Equipment events
        REEquip = Net["RE/EquipToolFromHotbar"],
        REEquipItem = Net["RE/EquipItem"],

        -- Enchanting events
        REAltar = Net["RE/ActivateEnchantingAltar"],
        REAltar2 = Net["RE/ActivateSecondEnchantingAltar"],

        -- Notification events
        RENotify = Net["RE/TextNotification"],
        REObtainedNewFishNotification = Net["RE/ObtainedNewFishNotification"],
        RETextEffect = Net["RE/ReplicateTextEffect"],

        -- Event rewards
        REEvReward = Net["RE/ClaimEventReward"],

        -- Totem
        Totem = Net["RE/SpawnTotem"],

        -- Oxygen (unreliable event)
        UpdateOxygen = Net["URE/UpdateOxygen"]
    }

    return Events

end

-- Module: network/functions
Modules["network/functions"] = function()
    --[[
        Network Functions Module

        Remote Functions for client-server request-response communication.
        All InvokeServer() calls use these functions.

        Usage:
            local Functions = require("src/network/functions")
            local success = Functions.ChargeRod:InvokeServer(timestamp)
    ]]

    local Services = require("src/core/services")
    local Net = Services.Net

    local Functions = {
        -- Trading
        Trade = Net["RF/InitiateTrade"],

        -- Shop/Purchase
        BuyRod = Net["RF/PurchaseFishingRod"],
        BuyBait = Net["RF/PurchaseBait"],
        BuyWeather = Net["RF/PurchaseWeatherEvent"],

        -- Fishing
        ChargeRod = Net["RF/ChargeFishingRod"],
        StartMini = Net["RF/RequestFishingMinigameStarted"],
        UpdateRadar = Net["RF/UpdateFishingRadar"],
        Cancel = Net["RF/CancelFishingInputs"],
        Done = Net["RF/RequestFishingMinigameStarted"],

        -- Dialogue
        Dialogue = Net["RF/SpecialDialogueEvent"]
    }

    return Functions

end

-- Module: network/webhook
Modules["network/webhook"] = function()
    --[[
        Webhook Module

        Discord webhook integration for notifications.

        Usage:
            local Webhook = require("src/network/webhook")
            Webhook.sendFishCaught(url, "Megalodon", "Mythic", "Galaxy")
    ]]

    local Services = require("src/core/services")

    local Webhook = {}

    -- Initialize httpRequest based on executor
    Webhook.httpRequest = syn and syn.request
        or http and http.request
        or http_request
        or fluxus and fluxus.request
        or request

    --[[
        Send generic webhook
        @param url string - Discord webhook URL
        @param data table - Webhook payload
        @return boolean - Success status
    ]]
    function Webhook.send(url, data)
        if not Webhook.httpRequest then
            warn("[Webhook] HTTP request not supported by executor")
            return false
        end

        local success = pcall(function()
            Webhook.httpRequest({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = Services.HttpService:JSONEncode(data)
            })
        end)

        return success
    end

    --[[
        Send fish caught notification
        @param webhookUrl string - Discord webhook URL
        @param fishName string - Name of fish
        @param rarity string - Fish rarity
        @param variant string - Fish variant (optional)
    ]]
    function Webhook.sendFishCaught(webhookUrl, fishName, rarity, variant)
        local embed = {
            embeds = {{
                title = "🎣 Fish Caught!",
                description = string.format("**%s**\nRarity: %s\nVariant: %s",
                    fishName, rarity, variant or "None"),
                color = 0x00ff00,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }

        return Webhook.send(webhookUrl, embed)
    end

    --[[
        Send disconnect notification
        @param webhookUrl string - Discord webhook URL
        @param reason string - Disconnect reason
        @param customName string - Custom player name (optional)
    ]]
    function Webhook.sendDisconnect(webhookUrl, reason, customName)
        local embed = {
            content = _G.DiscordMention or "",
            embeds = {{
                title = "⚠️ Disconnected",
                description = string.format("**%s** disconnected\nReason: %s",
                    customName or "Player", reason),
                color = 0xff0000,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }

        return Webhook.send(webhookUrl, embed)
    end

    --[[
        Send trade notification
        @param webhookUrl string - Discord webhook URL
        @param itemName string - Item traded
        @param targetPlayer string - Player traded with
        @param success boolean - Trade success status
    ]]
    function Webhook.sendTrade(webhookUrl, itemName, targetPlayer, success)
        local color = success and 0x00ff00 or 0xff0000
        local title = success and "✅ Trade Success" or "❌ Trade Failed"

        local embed = {
            embeds = {{
                title = title,
                description = string.format("Item: **%s**\nPlayer: **%s**",
                    itemName, targetPlayer),
                color = color,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }

        return Webhook.send(webhookUrl, embed)
    end

    return Webhook

end

-- Module: utils/player-utils
Modules["utils/player-utils"] = function()
    --[[
        Player Utilities Module

        Helper functions for player operations.

        Usage:
            local PlayerUtils = require("src/utils/player-utils")
            PlayerUtils.teleport(character, Vector3.new(0, 10, 0))
    ]]

    local Services = require("src/core/services")

    local PlayerUtils = {}

    --[[
        Get HumanoidRootPart from character
        @param character Model - Character model
        @return BasePart - HumanoidRootPart or first BasePart
    ]]
    function PlayerUtils.getHumanoidRootPart(character)
        return character and (
            character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChildWhichIsA("BasePart")
        )
    end

    --[[
        Teleport character to position
        @param character Model - Character to teleport
        @param position Vector3 - Target position
    ]]
    function PlayerUtils.teleport(character, position)
        local hrp = PlayerUtils.getHumanoidRootPart(character)
        if hrp then
            hrp.CFrame = CFrame.new(position)
        end
    end

    --[[
        Set all parts in character to anchored
        @param character Model - Character model
        @param anchored boolean - Anchored state
    ]]
    function PlayerUtils.setAnchored(character, anchored)
        if not character then return end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = anchored
            end
        end
    end

    --[[
        Get list of player names (excluding self)
        @param excludeSelf boolean - Whether to exclude local player
        @return table - Array of player names
    ]]
    function PlayerUtils.getPlayers(excludeSelf)
        local players = {}

        for _, player in ipairs(Services.Players:GetPlayers()) do
            if not excludeSelf or player ~= Services.LocalPlayer then
                table.insert(players, player.Name)
            end
        end

        return players
    end

    --[[
        Create floating platform under character (for anti-fall)
        @param character Model - Character model
        @param hrp BasePart - HumanoidRootPart
        @param enabled boolean - Enable/disable floating
        @return Part - The floating part (if enabled)
        @return RBXScriptConnection - Heartbeat connection (if enabled)
    ]]
    function PlayerUtils.createFloatPart(character, hrp, enabled)
        if not enabled then
            local floatPart = character:FindFirstChild("FloatPart")
            if floatPart then
                floatPart:Destroy()
            end
            return nil, nil
        end

        local floatPart = character:FindFirstChild("FloatPart") or Instance.new("Part")
        floatPart.Name = "FloatPart"
        floatPart.Size = Vector3.new(3, 0.2, 3)
        floatPart.Transparency = 1
        floatPart.Anchored = true
        floatPart.CanCollide = true
        floatPart.Parent = character

        local connection = Services.RunService.Heartbeat:Connect(function()
            if character and hrp and floatPart then
                floatPart.CFrame = hrp.CFrame * CFrame.new(0, -3.1, 0)
            end
        end)

        return floatPart, connection
    end

    return PlayerUtils

end

-- Module: main
Modules["main"] = function()
    --[[
        Main Entry Point

        This is the entry point for the script.
        When bundled, this file will be executed last.

        Version: 2.0.0 (Refactored)
    ]]

    -- ============================================
    -- EXECUTOR COMPATIBILITY CHECK
    -- ============================================

    local httpRequest = syn and syn.request
        or http and http.request
        or http_request
        or fluxus and fluxus.request
        or request

    if not httpRequest then
        warn("[ERROR] Executor not supported - HTTP requests required")
        return
    end

    _G.httpRequest = httpRequest

    -- ============================================
    -- LOAD CORE MODULES
    -- ============================================

    local Services = require("src/core/services")
    local Constants = require("src/core/constants")
    local State = require("src/core/state")

    -- ============================================
    -- LOAD NETWORK MODULES
    -- ============================================

    local Events = require("src/network/events")
    local Functions = require("src/network/functions")
    local Webhook = require("src/network/webhook")

    -- ============================================
    -- LOAD UTILITY MODULES
    -- ============================================

    local PlayerUtils = require("src/utils/player-utils")

    -- ============================================
    -- WAIT FOR CHARACTER
    -- ============================================

    local LocalPlayer = Services.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
    end

    -- ============================================
    -- INITIALIZE GLOBALS
    -- ============================================

    _G.Celestial = _G.Celestial or {}
    _G.Celestial.DetectorCount = _G.Celestial.DetectorCount or 0
    _G.Celestial.InstantCount = _G.Celestial.InstantCount or 0
    _G.TierFish = Constants.TIER_FISH
    _G.Variant = Constants.VARIANTS

    -- ============================================
    -- STARTUP MESSAGE
    -- ============================================

    print("╔═══════════════════════════════════════════════════╗")
    print("║        Roblox FishIt Script - Refactored         ║")
    print("║                  Version 2.0.0                    ║")
    print("╚═══════════════════════════════════════════════════╝")
    print("")
    print("✅ Core modules loaded:")
    print("   - Services ✓")
    print("   - Constants ✓")
    print("   - State ✓")
    print("")
    print("✅ Network modules loaded:")
    print("   - Events ✓")
    print("   - Functions ✓")
    print("   - Webhook ✓")
    print("")
    print("✅ Utility modules loaded:")
    print("   - PlayerUtils ✓")
    print("")
    print("👤 Player:", LocalPlayer.Name)
    print("🔧 Executor: Compatible")
    print("")
    print("⚠️  Feature modules not yet implemented!")
    print("📝 This is Phase 1 of refactoring (Core + Network)")
    print("")
    print("Next: Add feature modules (fishing, selling, trading, etc.)")
    print("See CLAUDE.md for roadmap.")

    -- ============================================
    -- TODO: LOAD FEATURE MODULES
    -- ============================================

    -- Phase 3: Load feature modules here when implemented

    -- ============================================
    -- TODO: LOAD UI MODULES
    -- ============================================

    -- Phase 4: Load UI modules here when implemented

    print("")
    print("🎯 Script initialization complete!")

end


-- ============================================
-- ENTRY POINT
-- ============================================

-- Execute main module
require("main")
