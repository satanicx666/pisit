--[[
    Auto Tab Module

    UI for automation features (sell, favorite).

    Usage:
        local AutoTab = require("src/ui/tabs/auto-tab")
        AutoTab.setup(tab)
]]

local AutoSell = require("src/features/selling/auto-sell")
local AutoFavorite = require("src/features/favorites/auto-favorite")
local State = require("src/core/state")
local Constants = require("src/core/constants")

local AutoTab = {}

-- Fish names list (will be populated)
local fishNames = {}

--[[
    Get all fish names from game
    @return table - Array of fish names
]]
local function getFishNames()
    if #fishNames > 0 then
        return fishNames
    end

    local Services = require("src/core/services")
    local items = Services.RS:WaitForChild("Items")

    for _, item in ipairs(items:GetChildren()) do
        if item:IsA("ModuleScript") then
            local success, result = pcall(require, item)
            if success and result.Data and result.Data.Type == "Fish" then
                table.insert(fishNames, result.Data.Name)
            end
        end
    end

    table.sort(fishNames)
    return fishNames
end

--[[
    Setup auto tab UI
    @param tab table - Tab object from UI library
]]
function AutoTab.setup(tab)
    -- === AUTO SELL SECTION ===
    local sellSection = tab:AddSection("💰 Auto Sell")

    -- Sell Mode Dropdown
    sellSection:AddDropdown({
        Title = "Sell Mode",
        Options = {"Delay", "Count"},
        Multi = false,
        Default = "Delay",
        Callback = function(mode)
            AutoSell.setMode(mode)
            print("[Auto Tab] Sell mode:", mode)
        end
    })

    -- Delay Input
    sellSection:AddInput({
        Title = "Sell Delay (seconds)",
        Content = "Sell every X seconds",
        Value = "60",
        Callback = function(value)
            local delay = tonumber(value)
            if delay and delay >= 1 then
                AutoSell.setDelay(delay)
                print("[Auto Tab] Sell delay:", delay)
            end
        end
    })

    -- Count Input
    sellSection:AddInput({
        Title = "Sell Count",
        Content = "Sell when fish count reaches X",
        Value = "50",
        Callback = function(value)
            local count = tonumber(value)
            if count and count >= 1 then
                AutoSell.setCount(count)
                print("[Auto Tab] Sell count:", count)
            end
        end
    })

    -- Auto Sell Toggle
    sellSection:AddToggle({
        Title = "Enable Auto Sell",
        Content = "Automatically sell fish",
        Default = false,
        Callback = function(enabled)
            if enabled then
                AutoSell.start()
                print("[Auto Tab] Auto sell started")
            else
                AutoSell.stop()
                print("[Auto Tab] Auto sell stopped")
            end
        end
    })

    -- === AUTO FAVORITE SECTION ===
    local favSection = tab:AddSection("⭐ Auto Favorite")

    -- Fish Name Dropdown
    favSection:AddDropdown({
        Title = "Favorite by Name",
        Options = getFishNames(),
        Multi = true,
        Callback = function(selected)
            AutoFavorite.setNames(selected)
            print("[Auto Tab] Favorite names:", #selected, "selected")
        end
    })

    -- Rarity Dropdown
    favSection:AddDropdown({
        Title = "Favorite by Rarity",
        Options = {
            "Uncommon",
            "Rare",
            "Epic",
            "Legendary",
            "Mythic",
            "Secret"
        },
        Multi = true,
        Callback = function(selected)
            AutoFavorite.setRarities(selected)
            print("[Auto Tab] Favorite rarities:", #selected, "selected")
        end
    })

    -- Variant Dropdown
    favSection:AddDropdown({
        Title = "Favorite by Variant",
        Content = "Only works with Name filter",
        Options = Constants.VARIANTS,
        Multi = true,
        Callback = function(selected)
            AutoFavorite.setVariants(selected)
            print("[Auto Tab] Favorite variants:", #selected, "selected")
        end
    })

    -- Auto Favorite Toggle
    favSection:AddToggle({
        Title = "Enable Auto Favorite",
        Content = "Auto favorite matching fish",
        Default = false,
        Callback = function(enabled)
            if enabled then
                AutoFavorite.start()
                print("[Auto Tab] Auto favorite started")
            else
                AutoFavorite.stop()
                print("[Auto Tab] Auto favorite stopped")
            end
        end
    })

    -- Unfavorite All Button
    favSection:AddButton({
        Title = "Unfavorite All Fish",
        Content = "Remove favorite from all fish",
        Callback = function()
            AutoFavorite.unfavoriteAll()
            print("[Auto Tab] All fish unfavorited")
        end
    })

    print("[Auto Tab] Initialized")
end

return AutoTab
