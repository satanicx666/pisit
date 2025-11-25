--[[
    Main Entry Point

    This is the entry point for the script.
    When bundled, this file will be executed last.

    Version: 2.0.0 (Refactored)
]]

-- ============================================
-- EXECUTOR COMPATIBILITY CHECK
-- ============================================

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

-- ============================================
-- LOAD CORE MODULES
-- ============================================

local Services = require("src/core/services")
local Constants = require("src/core/constants")
local State = require("src/core/state")

-- ============================================
-- LOAD NETWORK MODULES
-- ============================================

local Events = require("src/network/events")
local Functions = require("src/network/functions")
local Webhook = require("src/network/webhook")

-- ============================================
-- LOAD UTILITY MODULES
-- ============================================

local PlayerUtils = require("src/utils/player-utils")

-- ============================================
-- LOAD FEATURE MODULES
-- ============================================

local InstantFish = require("src/features/fishing/instant-fish")
local AutoSell = require("src/features/selling/auto-sell")
local AutoFavorite = require("src/features/favorites/auto-favorite")
local Teleport = require("src/features/teleport/teleport")

-- ============================================
-- LOAD CONFIG MODULES
-- ============================================

local Locations = require("src/config/locations")

-- ============================================
-- WAIT FOR CHARACTER
-- ============================================

local LocalPlayer = Services.LocalPlayer
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
end

-- ============================================
-- INITIALIZE GLOBALS
-- ============================================

_G.Celestial = _G.Celestial or {}
_G.Celestial.DetectorCount = _G.Celestial.DetectorCount or 0
_G.Celestial.InstantCount = _G.Celestial.InstantCount or 0
_G.TierFish = Constants.TIER_FISH
_G.Variant = Constants.VARIANTS

-- ============================================
-- STARTUP MESSAGE
-- ============================================

print("╔═══════════════════════════════════════════════════╗")
print("║        Roblox FishIt Script - Refactored         ║")
print("║              Version 2.0.0 - Phase 2             ║")
print("╚═══════════════════════════════════════════════════╝")
print("")
print("✅ Core modules loaded:")
print("   - Services ✓")
print("   - Constants ✓")
print("   - State ✓")
print("")
print("✅ Network modules loaded:")
print("   - Events ✓")
print("   - Functions ✓")
print("   - Webhook ✓")
print("")
print("✅ Utility modules loaded:")
print("   - PlayerUtils ✓")
print("")
print("✅ Feature modules loaded:")
print("   - InstantFish ✓")
print("   - AutoSell ✓")
print("   - AutoFavorite ✓")
print("   - Teleport ✓")
print("")
print("✅ Config modules loaded:")
print("   - Locations ✓")
print("")
print("👤 Player:", LocalPlayer.Name)
print("🔧 Executor: Compatible")
print("")
print("⚠️  UI modules not yet implemented!")
print("📝 This is Phase 2 of refactoring (Features extracted)")
print("")
print("Next: Add UI modules to control features")
print("See CLAUDE.md for roadmap.")

-- ============================================
-- INITIALIZE AUTO TELEPORT
-- ============================================

Teleport.setupAutoTeleport()

-- ============================================
-- TODO: LOAD UI MODULES
-- ============================================

-- Phase 4: Load UI modules here when implemented

print("")
print("🎯 Script initialization complete!")
print("📌 Features available but need UI to activate")
