--[[
    Fish Tab Module

    UI for fishing features.

    Usage:
        local FishTab = require("src/ui/tabs/fish-tab")
        FishTab.setup(tab)
]]

local InstantFish = require("src/features/fishing/instant-fish")
local LegitFish = require("src/features/fishing/legit-fish")
local BlatantFish = require("src/features/fishing/blatant-fish")
local State = require("src/core/state")

local FishTab = {}

--[[
    Setup fish tab UI
    @param tab table - Tab object from UI library
]]
function FishTab.setup(tab)
    -- Fishing Features Section
    local fishingSection = tab:AddSection("Instant Fishing")

    -- Instant Fishing Toggle
    fishingSection:AddToggle({
        Title = "Instant Fishing",
        Content = "Auto catch fish instantly (bypasses minigame)",
        Default = false,
        Callback = function(enabled)
            if enabled then
                InstantFish.start()
                print("[Fish Tab] Instant fishing started")
            else
                InstantFish.stop()
                print("[Fish Tab] Instant fishing stopped")
            end
        end
    })

    -- Delay Complete Input
    fishingSection:AddInput({
        Title = "Complete Delay",
        Content = "Delay after catching (seconds)",
        Value = tostring(_G.DelayComplete or 0),
        Callback = function(value)
            local delay = tonumber(value)
            if delay and delay >= 0 then
                _G.DelayComplete = delay
                print("[Fish Tab] Complete delay set to:", delay)
            end
        end
    })

    -- Fishing Stats Section
    local statsSection = tab:AddSection("Fishing Stats")

    local statsLabel = statsSection:AddParagraph({
        Title = "Statistics",
        Content = "Fish Count: 0\nStatus: Idle"
    })

    -- Update stats periodically
    task.spawn(function()
        while true do
            task.wait(2)

            if InstantFish.isRunning() then
                local count = InstantFish.getFishCount()
                local startCount = _G.Celestial.InstantCount or 0
                local caught = count - startCount

                statsLabel:SetContent(string.format(
                    "Fish Count: %d\nCaught: %d\nStatus: Fishing",
                    count, caught
                ))
            else
                local count = InstantFish.getFishCount()
                statsLabel:SetContent(string.format(
                    "Fish Count: %d\nStatus: Idle",
                    count
                ))
            end
        end
    end)

    -- Legit Fishing Section
    local legitSection = tab:AddSection("Legit Fishing")

    -- Auto Shake Toggle
    legitSection:AddToggle({
        Title = "Auto Shake",
        Content = "Spam click during fishing (works with legit mode)",
        Default = false,
        Callback = function(enabled)
            State.autoShake = enabled
            if enabled then
                LegitFish.startAutoShake()
                print("[Fish Tab] Auto shake enabled")
            else
                LegitFish.stopAutoShake()
                print("[Fish Tab] Auto shake disabled")
            end
        end
    })

    -- Shake Delay Input
    legitSection:AddInput({
        Title = "Shake Delay",
        Content = "Delay between clicks (seconds)",
        Value = "0",
        Callback = function(value)
            LegitFish.setShakeDelay(value)
        end
    })

    -- Blatant Fishing Section
    local blatantSection = tab:AddSection("Blatant Fishing")

    -- Blatant Mode Dropdown
    blatantSection:AddDropdown({
        Title = "Blatant Mode",
        Options = {"Fast", "Random Result"},
        Multi = false,
        Callback = function(mode)
            BlatantFish.setMode(mode)
            print("[Fish Tab] Blatant mode:", mode)
        end
    })

    -- Reel Delay Input
    blatantSection:AddInput({
        Title = "Reel Delay",
        Content = "Delay between catches (seconds)",
        Value = "0.5",
        Callback = function(value)
            BlatantFish.setReelDelay(value)
        end
    })

    -- Blatant Fishing Toggle
    blatantSection:AddToggle({
        Title = "Enable Blatant Fishing",
        Content = "Aggressive fishing method (HIGH DETECTION RISK)",
        Default = false,
        Callback = function(enabled)
            if enabled then
                BlatantFish.start()
                print("[Fish Tab] Blatant fishing started")
            else
                BlatantFish.stop()
                print("[Fish Tab] Blatant fishing stopped")
            end
        end
    })

    -- Recovery Button
    blatantSection:AddButton({
        Title = "Recovery Fishing",
        Content = "Cancel stuck fishing state",
        Callback = function()
            BlatantFish.recovery()
            print("[Fish Tab] Recovery executed")
        end
    })

    -- Info Section
    local infoSection = tab:AddSection("Information")

    infoSection:AddParagraph({
        Title = "Fishing Modes",
        Content = [[
INSTANT FISHING:
- Bypasses minigame completely
- Fast and efficient
- Medium detection risk

LEGIT FISHING:
- Uses game's normal fishing
- Auto Shake: spam clicks
- Lower detection risk

BLATANT FISHING:
- Aggressive method
- Fast mode: Fastest possible
- Random Result: Slight delay
- HIGH DETECTION RISK

WARNING: All methods risk ban!
Use at your own risk.
        ]]
    })

    print("[Fish Tab] Initialized")
end

return FishTab
