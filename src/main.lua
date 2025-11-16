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
