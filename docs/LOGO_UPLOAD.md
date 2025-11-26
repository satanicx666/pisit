# Zivi Hub Logo Upload Instructions

## Current Logo Location
`src/zivi-logo.jpg` (1370x1101 JPEG)

## How to Update the Logo in Script

### Method 1: Upload to Imgur (Recommended)
1. Go to [imgur.com](https://imgur.com)
2. Upload `src/zivi-logo.jpg`
3. Right-click the uploaded image → "Copy image address"
4. Open `src/ui/library.lua`
5. Update line 19:
   ```lua
   Library.LogoAssetId = "YOUR_IMGUR_DIRECT_URL"
   ```
6. Rebuild: `npm run build`

### Method 2: Upload to Roblox as Asset
1. Open Roblox Studio
2. Toolbox → Create → Decal
3. Upload `src/zivi-logo.jpg`
4. Wait for moderation approval (may take time)
5. Get the Asset ID from the uploaded decal
6. Open `src/ui/library.lua`
7. Update line 19:
   ```lua
   Library.LogoAssetId = "rbxassetid://YOUR_ASSET_ID"
   ```
8. Rebuild: `npm run build`

### Method 3: Use Base64 Encoded Data URI (Not Recommended)
This method embeds the image directly but increases script size significantly.

## Current Status
- Logo file: ✅ Present at `src/zivi-logo.jpg`
- Logo placeholder: ✅ Set to `132435516080103` (default)
- **Action Required**: Upload logo and update `Library.LogoAssetId`

## Quick Test
After updating the logo asset ID:
1. Run `npm run build`
2. Load script in Roblox executor
3. Check if Zivi logo appears in UI window

## Notes
- The UI library may have limitations on external images
- If external URLs don't work, Roblox asset upload is required
- Logo should be square or 4:3 ratio for best display
- Current logo is 1370x1101 (approximately 5:4 ratio)
