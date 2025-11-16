--[[
    ╔═══════════════════════════════════════════════════╗
    ║          Roblox FishIt Script - Bundled          ║
    ║                                                   ║
    ║  Build Date: 2025-11-16 19:43:54                        ║
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

    -- Shortcuts
    Services.RS = Services.ReplicatedStorage
    Services.VIM = Services.VirtualInputManager
    Services.Camera = workspace.CurrentCamera
    Services.LocalPlayer = Services.Players.LocalPlayer
    Services.PlayerGui = Services.LocalPlayer:WaitForChild("PlayerGui")

    return Services

end

-- Module: main
Modules["main"] = function()
    --[[
        Main Entry Point

        This is the entry point for the script.
        When bundled, this file will be executed last.

        Build Date: Will be replaced by bundler
        Version: 2.0.0
    ]]

    -- Load core services
    local Services = require("src/core/services")

    -- Check executor compatibility
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

    -- Wait for character
    local LocalPlayer = Services.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        print("[INFO] Waiting for character...")
        LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
    end

    -- Initialize
    print("╔═══════════════════════════════════════════════════╗")
    print("║        Roblox FishIt Script - Modular Demo       ║")
    print("╚═══════════════════════════════════════════════════╝")
    print("")
    print("[INFO] Script loaded successfully!")
    print("[INFO] Player:", LocalPlayer.Name)
    print("[INFO] Executor:", httpRequest and "Compatible" or "Not supported")
    print("")
    print("📦 This is a demo of the modular build system.")
    print("📝 See CLAUDE.md for full refactoring roadmap.")
    print("")

    -- Example: Access services
    print("✅ Services loaded:")
    print("   - Players:", Services.Players)
    print("   - RunService:", Services.RunService)
    print("   - HttpService:", Services.HttpService)

    -- Placeholder for future modules
    print("")
    print("⚠️  To add more features, follow the steps in CLAUDE.md")
    print("   Phase 1: Core modules")
    print("   Phase 2: Network layer")
    print("   Phase 3: Features")
    print("   Phase 4: UI")

end


-- ============================================
-- ENTRY POINT
-- ============================================

-- Execute main module
require("main")
