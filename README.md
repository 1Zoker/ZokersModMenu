# ZokersModMenu v2.0.0

The ultimate customization mod for Balatro. Modify everything: starting conditions, deck composition, items, money, ante scaling, and more. Give yourself any item during runs, build custom decks with multiple card variations, and start with any combination of jokers, vouchers, and tags.

## 🆕 What's New in v2.0.0
- **Starting Tags System**: Select any tags to start your run with
- **Mod Disable Toggle**: Enable/disable the mod from Steamodded config
- **Enhanced Deck Builder**: Support for multiple cards with different enhancements/seals/editions
- **Improved Stability**: Fixed crashes, errors, and compatibility issues
- **Better UI**: Improved checkbox styling with proper enable/disable states

## Features

### 🎮 Complete Game Customization
- **Starting Stats**: Money ($0-5000), Hands (1-25), Discards (0-25), Hand Size (1-50)
- **Poker Hands**: Set starting level for all hands (1-100)
- **Slots**: Joker slots (0-100), Consumable slots (0-15)
- **Ante Scaling**: Modify blind chip requirements (1x, 1.5x, 2x, 3x, 5x)
- **Free Rerolls**: Toggle unlimited shop rerolls

### 🃏 Advanced Deck Builder
- **Multi-Enhancement Support**: Each card can have unique enhancement/seal/edition
- **Card Properties**: 
  - Enhancements: Bonus, Mult, Wild, Glass, Steel, Stone, Gold, Lucky
  - Seals: Gold, Red, Blue, Purple
  - Editions: Foil, Holographic, Polychrome
- **Deck Templates**: Quick-create standard 52-card decks
- **Visual Feedback**: Color-coded card counts show deck composition

### 🎁 Starting Items Selection
- **Jokers**: Select up to 30 copies of any joker
- **Vouchers**: Choose any vouchers to start with
- **Tags**: Pick starting tags for strategic advantages
- **Persistent Settings**: Items apply to new runs only

### 💰 Give System (During Runs)
- **Money**: Add $10, $50, $100, $1000, or infinite money
- **Cards**: Create any playing card with custom properties
- **Jokers**: Instantly add any joker to your collection
- **Consumables**: Give yourself Tarot, Planet, or Spectral cards
- **Vouchers**: Apply voucher effects immediately
- **Tags**: Add tags during gameplay

### 🔧 Advanced Features
- **Mod Toggle**: Enable/disable from Steamodded config
- **Multiple Access**: Press 'C' or use Steamodded config menu
- **Smart Placement**: Cards go to hand/deck based on game state
- **Console Commands**: Full scripting support via F7 console
- **Unlock All**: Unlock all content without disabling achievements

## Installation

1. Ensure Steamodded 0.9.8+ is installed
2. Place `ZokersModMenu.lua` in your Balatro mods folder
3. Launch Balatro and press 'C' or go to Steamodded config

## Usage Guide

### Opening the Menu
- Press `C` anywhere in game
- Go to Steamodded config → ZokersModMenu → Open Mod Menu
- Click "Zoker's Menu" in pause menu

### Key Features
1. **Enable/Disable Mod**: Use checkbox in Steamodded config
2. **Starting Stats**: Configure all starting conditions
3. **Starting Items**: Select jokers, vouchers, and tags
4. **Build Deck**: Create custom decks with varied cards
5. **Give Items**: Enable to add items during runs

### Console Commands
```lua
cs_money(100)          -- Set starting money
cs_hands(8)            -- Set starting hands
cs_hand_size(12)       -- Set hand size
cs_add_joker('j_joker')    -- Add joker to starting items
cs_add_voucher('v_blank')  -- Add voucher
cs_add_tag('tag_charm')    -- Add starting tag
cs_unlock_all()        -- Unlock everything
## Tips & Tricks

### Efficient Deck Building
1. Set your desired enhancement/seal/edition before adding cards
2. Use the Standard 52 button for quick deck creation
3. Color coding shows card counts (Green→Gold→Orange→Red)
4. Save different deck configurations for various playstyles

### Smart Giving System
1. Enable "Give Items" in main menu before starting a run
2. Cards given in shop go to deck, during rounds go to hand
3. Use Give Money for quick cash injections
4. Give Jokers/Vouchers for instant power boosts

### Custom Deck Usage
1. Build your deck in the deck builder
2. Enable "Custom Deck" in main menu
3. Start a new run to use your custom deck
4. Your deck persists across sessions

### Menu Access
1. Press C for quick access (traditional method)
2. Use pause menu button if keyboard shortcuts don't work
3. Console command `cs_open()` always available as backup

## Version History

### v1.5.0 (Latest - 2025-06-11)
- **ADDED**: SteamModded Config as alternative menu access
- **ENHANCED**: Crash prevention system with better error handling
- **FIXED**: Metadata structure for improved mod loader compatibility
- **IMPROVED**: Error recovery for edge cases and unexpected states
- **UPDATED**: Documentation with multiple access methods

### v1.4.8 (Previous)
- Fixed menu toggle to work properly without closing other menus
- Fixed card naming format to correct Balatro format
- Fixed enhancement and seal cycling
- Improved card giving logic
- Fixed syntax errors and duplicate handlers

[See changelog.md for complete version history]

## Support

If you encounter issues:
1. Check the console for error messages (F7)
2. Verify Steamodded is properly installed
3. Ensure mod files are in the correct directory
4. Try disabling other mods to test compatibility
5. Try both C and F1 keys to open the menu

## Error Prevention (v1.5.0)
The mod now includes enhanced error handling:
- Graceful recovery from unexpected game states
- Protection against nil reference errors
- Safe fallbacks for missing dependencies
- Improved compatibility with other mods

## Credits

- **Author**: Zoker
- **Community**: Balatro modding community for testing and feedback

---

*Customize your Balatro experience like never before! 🎲*