# Zivi Hub Branding - Text-Based Logo

## ✅ SOLUTION: Using Text Instead of Image

**We've switched to text-based branding to avoid Roblox asset upload requirements.**
- ✅ **No image upload needed** - Works immediately
- ✅ **No moderation delays** - No waiting for Roblox approval
- ✅ **Simple & effective** - Clean minimalist look
- ✅ **Easy to customize** - Just change text in code

## Current Branding
- **Logo Text:** `"ZV"` (Zivi abbreviation)
- **Title:** Zivi Hub
- **Footer:** Version 2.5.0 BETA
- **Color Theme:** Discord Blurple (#5865F2)

## Original Logo File
`src/zivi-logo.jpg` (1370x1101 JPEG) - Kept for reference/future use

## How to Customize Text Logo

### Option 1: Change Logo Text (Quick & Easy)

1. **Edit the text:**
   - Open `src/ui/library.lua`
   - Find line 15:
     ```lua
     Library.LogoText = "ZV"
     ```
   - Change to any short text (2-4 characters recommended):
     ```lua
     Library.LogoText = "ZIVI"  -- Full name
     Library.LogoText = "🎣"     -- Emoji (if supported)
     Library.LogoText = "Z"      -- Single letter
     ```

2. **Rebuild:**
   ```bash
   npm run build
   ```

3. **Test in Roblox**

### Option 2: Use Image (Advanced - Requires Roblox Upload)

If you really want to use the image logo:

1. **Upload to Roblox:**
   - Open [Roblox Creator Dashboard](https://create.roblox.com/dashboard/creations)
   - Upload `src/zivi-logo.jpg` as Decal
   - Wait for moderation approval (1-24 hours)

2. **Get Asset ID:**
   - Copy the numeric Asset ID (e.g., `1234567890`)

3. **Update Code:**
   - Open `src/ui/library.lua`
   - Find line 74 and uncomment/modify:
     ```lua
     Image = "1234567890",  -- Your Roblox Asset ID (numbers only!)
     ```

4. **Rebuild:** `npm run build`

## Current Status
- ✅ **Text logo active:** "ZV"
- ✅ **No upload required:** Works immediately
- ✅ **Image file preserved:** Available at `src/zivi-logo.jpg` for future use

## Why Text Instead of Image?

**Technical Limitations:**
- UI library only supports Roblox Asset IDs for images
- External URLs (Imgur, Discord CDN, etc.) don't work
- Roblox upload requires moderation (1-24 hour wait)
- Text-based logo works immediately without upload

**Benefits of Text Logo:**
```lua
-- ✅ Works immediately - no upload needed
Library.LogoText = "ZV"

-- ❌ Image requires Roblox upload
Image = "132435516080103"  -- Needs Roblox Asset ID

-- ❌ External URLs don't work
Image = "https://i.imgur.com/abc.jpg"  -- Not supported
```

## Troubleshooting

### Text Logo Not Showing?
- The UI library may not support text logos in the Image parameter
- Text is shown in **Title** instead: `Title = "Zivi Hub"`
- Logo is represented by the **ZV** branding in title

### Want to Use Image?
Follow **Option 2** above to upload to Roblox and get Asset ID

## Notes
- Text logo = No upload, no waiting, works immediately
- Image logo = Better branding but requires Roblox upload
- Current setup prioritizes simplicity and immediate functionality
- Original image file kept for future use
