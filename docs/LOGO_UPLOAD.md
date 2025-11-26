# Zivi Hub Logo Upload Instructions

## ⚠️ IMPORTANT: UI Library Limitation

**The UI library ONLY supports Roblox Asset IDs (numbers only).**
- ❌ External URLs (Imgur, Discord CDN, etc.) **DO NOT WORK**
- ❌ Data URIs / Base64 encoded images **DO NOT WORK**
- ✅ **ONLY Roblox uploaded assets work** (e.g., `132435516080103`)

## Current Logo Location
`src/zivi-logo.jpg` (1370x1101 JPEG)

## How to Update the Logo in Script

### Required Method: Upload to Roblox as Asset

**Step-by-Step Guide:**

1. **Upload to Roblox:**
   - Open [Roblox Creator Dashboard](https://create.roblox.com/dashboard/creations)
   - OR use Roblox Studio: Toolbox → Create → Decal
   - Upload `src/zivi-logo.jpg`
   - Name it: "Zivi Hub Logo"

2. **Wait for Moderation:**
   - Roblox will review the image (usually 1-24 hours)
   - You'll get an email when approved
   - Check status at [Creator Dashboard](https://create.roblox.com/dashboard/creations)

3. **Get Asset ID:**
   - Once approved, click on the uploaded asset
   - Copy the Asset ID number (e.g., `1234567890`)
   - It's a **number only**, no prefix needed

4. **Update Code:**
   - Open `src/ui/library.lua`
   - Find line 23:
     ```lua
     Library.LogoAssetId = "132435516080103"
     ```
   - Replace with YOUR Asset ID (numbers only):
     ```lua
     Library.LogoAssetId = "1234567890"  -- Your actual asset ID
     ```

5. **Rebuild:**
   ```bash
   npm run build
   ```

6. **Test:**
   - Load the script in Roblox
   - Check if your Zivi logo appears in the UI window

### Alternative: Use Existing Roblox Asset

If you find an existing Roblox asset/decal that matches the Zivi logo, you can use its Asset ID directly.

## Current Status
- Logo file: ✅ Present at `src/zivi-logo.jpg`
- Logo placeholder: ⚠️ Set to `132435516080103` (default placeholder)
- **Action Required**: Upload logo to Roblox and update `Library.LogoAssetId`

## Why Imgur Doesn't Work

The UI library's Window function expects a **Roblox Asset ID** for the `Image` parameter:
```lua
-- This is what the library expects:
Image = "132435516080103"  -- ✅ Roblox Asset ID (numbers only)

-- These DO NOT work:
Image = "https://i.imgur.com/abc.jpg"  -- ❌ External URL
Image = "rbxassetid://12345"           -- ❌ Has prefix (only for Icons!)
Image = "data:image/jpeg;base64,..."   -- ❌ Data URI
```

**Only Icons** support `rbxassetid://` prefix. **Window Images** need numbers only.

## Troubleshooting

### Logo Not Showing?
1. **Check Asset ID is correct** - Must be numbers only
2. **Verify asset is approved** - Check Roblox Creator Dashboard
3. **Check asset type** - Must be Decal or Image, not Model
4. **Rebuild script** - Run `npm run build` after changes
5. **Clear cache** - Restart Roblox if needed

### Moderation Rejected?
- Ensure logo doesn't violate Roblox ToS
- Try uploading at different resolution
- Remove any text/branding that might be flagged

## Notes
- Logo should be square or 4:3 ratio for best display
- Current logo is 1370x1101 (approximately 5:4 ratio)
- Roblox compresses images automatically
- Free to upload (no Robux required for decals)
