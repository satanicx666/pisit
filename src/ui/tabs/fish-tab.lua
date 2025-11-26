--[[
    Fish Tab Module

    UI for fishing features.

    Usage:
        local FishTab = require("src/ui/tabs/fish-tab")
        FishTab.setup(tab)
]]

local InstantFish = require("src/features/fishing/instant-fish")
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

    -- Info Section
    local infoSection = tab:AddSection("Information")

    infoSection:AddParagraph({
        Title = "How to Use",
        Content = [[
1. Toggle 'Instant Fishing' to start
2. Script will auto catch fish
3. Adjust delay if needed (default: 0s)
4. Monitor stats below

WARNING: May be detected!
Use at your own risk.
        ]]
    })

    print("[Fish Tab] Initialized")
end

return FishTab
