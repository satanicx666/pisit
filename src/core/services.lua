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

-- Shortcuts
Services.RS = Services.ReplicatedStorage
Services.VIM = Services.VirtualInputManager
Services.Camera = workspace.CurrentCamera
Services.LocalPlayer = Services.Players.LocalPlayer
Services.PlayerGui = Services.LocalPlayer:WaitForChild("PlayerGui")

return Services
