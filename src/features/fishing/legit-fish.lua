-- src/features/fishing/legit-fish.lua
-- Legit fishing with auto shake (follows game mechanics)

local Services = require("src/core/services")
local State = require("src/core/state")

local LegitFish = {}

-- Auto shake delay
State.shakeDelay = 0

-- Auto shake enabled flag
State.autoShake = false

-- Start auto shake (spam click during fishing)
function LegitFish.startAutoShake()
    if not State.autoShake then
        return
    end

    -- Disable click effect GUI
    local clickEffect = Services.PlayerGui:FindFirstChild("!!! Click Effect")
    if clickEffect then
        clickEffect.Enabled = false
    end

    task.spawn(function()
        while State.autoShake do
            pcall(function()
                if Services.FishingController then
                    Services.FishingController:RequestFishingMinigameClick()
                end
            end)
            task.wait(State.shakeDelay)
        end

        -- Re-enable click effect when stopped
        if clickEffect then
            clickEffect.Enabled = true
        end
    end)

    print("[Legit Fish] Auto shake started (delay:", State.shakeDelay, ")")
end

-- Stop auto shake
function LegitFish.stopAutoShake()
    State.autoShake = false

    -- Re-enable click effect
    local clickEffect = Services.PlayerGui:FindFirstChild("!!! Click Effect")
    if clickEffect then
        clickEffect.Enabled = true
    end

    print("[Legit Fish] Auto shake stopped")
end

-- Set shake delay
function LegitFish.setShakeDelay(delay)
    local delayNum = tonumber(delay)
    if delayNum and delayNum >= 0 then
        State.shakeDelay = delayNum
        print("[Legit Fish] Shake delay set to:", delayNum)
        return true
    end
    return false
end

-- Start legit fishing (using FishingController)
function LegitFish.start()
    if State.legitFishing then
        return
    end

    State.legitFishing = true

    task.spawn(function()
        while State.legitFishing do
            -- Let the game's normal fishing controller handle the fishing
            -- This just keeps the loop alive for monitoring
            task.wait(1)
        end
    end)

    print("[Legit Fish] Legit fishing started")
end

-- Stop legit fishing
function LegitFish.stop()
    State.legitFishing = false
    print("[Legit Fish] Legit fishing stopped")
end

return LegitFish
