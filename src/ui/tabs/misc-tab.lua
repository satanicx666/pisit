--[[
    Misc Tab Module

    UI for miscellaneous features (teleport, settings).

    Usage:
        local MiscTab = require("src/ui/tabs/misc-tab")
        MiscTab.setup(tab)
]]

local Teleport = require("src/features/teleport/teleport")
local Webhook = require("src/network/webhook")
local State = require("src/core/state")

local MiscTab = {}

--[[
    Setup misc tab UI
    @param tab table - Tab object from UI library
]]
function MiscTab.setup(tab)
    -- === TELEPORT SECTION ===
    local teleportSection = tab:AddSection("🌍 Teleportation")

    -- Location Dropdown
    local locationNames = Teleport.getLocationNames()

    teleportSection:AddDropdown({
        Title = "Teleport Location",
        Options = locationNames,
        Multi = false,
        Callback = function(location)
            if location and location ~= "" then
                local success = Teleport.toLocation(location)
                if success then
                    print("[Misc Tab] Teleported to:", location)
                else
                    warn("[Misc Tab] Teleport failed:", location)
                end
            end
        end
    })

    -- Save Position Button
    teleportSection:AddButton({
        Title = "Save Position",
        Content = "Save current position",
        Callback = function()
            local success = Teleport.savePosition()
            if success then
                print("[Misc Tab] Position saved")
            else
                warn("[Misc Tab] Failed to save position")
            end
        end,
        SubTitle = "Load Position",
        SubCallback = function()
            local success = Teleport.toSavedPosition()
            if success then
                print("[Misc Tab] Teleported to saved position")
            else
                warn("[Misc Tab] No saved position found")
            end
        end
    })

    -- Clear Saved Position Button
    teleportSection:AddButton({
        Title = "Clear Saved Position",
        Content = "Delete saved position",
        Callback = function()
            Teleport.clearSavedPosition()
            print("[Misc Tab] Saved position cleared")
        end
    })

    -- === WEBHOOK SECTION ===
    local webhookSection = tab:AddSection("📡 Discord Webhook")

    local webhookUrl = ""

    -- Webhook URL Input
    webhookSection:AddInput({
        Title = "Webhook URL",
        Content = "Discord webhook URL",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(url)
            webhookUrl = url
            _G.WebhookURL = url
            print("[Misc Tab] Webhook URL saved")
        end
    })

    -- Test Webhook Button
    webhookSection:AddButton({
        Title = "Test Webhook",
        Content = "Send test message",
        Callback = function()
            if webhookUrl and webhookUrl ~= "" then
                local success = Webhook.send(webhookUrl, {
                    embeds = {{
                        title = "✅ Test Successful",
                        description = "Webhook is working correctly!",
                        color = 0x00ff00,
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    }}
                })

                if success then
                    print("[Misc Tab] Webhook test sent")
                else
                    warn("[Misc Tab] Webhook test failed")
                end
            else
                warn("[Misc Tab] Please enter webhook URL first")
            end
        end
    })

    -- === SETTINGS SECTION ===
    local settingsSection = tab:AddSection("⚙️ Settings")

    -- Theme Info (read-only for now)
    settingsSection:AddParagraph({
        Title = "Current Theme",
        Content = "Discord Dark Mode\nSimple & Modern Design"
    })

    -- Credits
    local creditsSection = tab:AddSection("ℹ️ Credits")

    creditsSection:AddParagraph({
        Title = "Zivi Hub",
        Content = [[
Version: 1.0.0 BETA
Developer: Zivi Team

Features:
• Instant Fishing
• Auto Sell
• Auto Favorite
• Teleportation
• Discord Webhooks

⚠️ Use at your own risk!
        ]]
    })

    print("[Misc Tab] Initialized")
end

return MiscTab
