--[[
    Main Window Module

    Creates and manages the main UI window with all tabs.

    Usage:
        local MainWindow = require("src/ui/main-window")
        MainWindow.create()
]]

local Library = require("src/ui/library")
local FishTab = require("src/ui/tabs/fish-tab")
local TradeTab = require("src/ui/tabs/trade-tab")
local TeleportTab = require("src/ui/tabs/teleport-tab")
local WebhookTab = require("src/ui/tabs/webhook-tab")
local MiscTab = require("src/ui/tabs/misc-tab")

local MainWindow = {}

-- Window instance
local window = nil
local tabs = {}

--[[
    Create main window with all tabs
    @return table - Window object
]]
function MainWindow.create()
    if window then
        warn("[MainWindow] Window already exists")
        return window
    end

    -- Create window
    window = Library.createWindow()

    if not window then
        error("[MainWindow] Failed to create window")
    end

    -- Create tabs
    tabs.fish = window:AddTab({
        Name = "Fishing",
        Icon = "rbxassetid://97167558235554"  -- Fish icon
    })

    tabs.trade = window:AddTab({
        Name = "Trading",
        Icon = "rbxassetid://114581487428395"  -- Trade icon
    })

    tabs.teleport = window:AddTab({
        Name = "Teleport & Position",
        Icon = "rbxassetid://18648122722"  -- Teleport icon
    })

    tabs.webhook = window:AddTab({
        Name = "Webhook",
        Icon = "rbxassetid://137601480983962"  -- Webhook icon
    })

    tabs.misc = window:AddTab({
        Name = "Misc",
        Icon = "rbxassetid://6034509993"  -- Settings icon
    })

    -- Setup tabs
    FishTab.setup(tabs.fish)
    TradeTab.setup(tabs.trade)
    TeleportTab.setup(tabs.teleport)
    WebhookTab.setup(tabs.webhook)
    MiscTab.setup(tabs.misc)

    print("[MainWindow] All tabs initialized")

    return window
end

--[[
    Get window instance
    @return table - Window object or nil
]]
function MainWindow.getWindow()
    return window
end

--[[
    Get tab by name
    @param tabName string - Tab name
    @return table - Tab object or nil
]]
function MainWindow.getTab(tabName)
    return tabs[tabName:lower()]
end

--[[
    Destroy window
]]
function MainWindow.destroy()
    if window then
        -- Clean up if library supports it
        window = nil
        tabs = {}
    end
end

return MainWindow
