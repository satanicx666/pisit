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
