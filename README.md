# ZokersModMenu v1.4.8

A comprehensive customization mod for Balatro that allows you to modify starting conditions, build custom decks, select starting jokers and vouchers, and much more. Compatible with Mika's Mod Collection for expanded joker selection.

## Features

### 🎮 Core Customization
- **Starting Money**: Adjust your starting cash from $0 to $5000
- **Starting Hands**: Set hands per round (1-25)
- **Starting Discards**: Configure discards per round (0-25)
- **Hand Size**: Customize hand size from 1-50 cards
- **Hand Levels**: Set starting level for all poker hands (1-100)
- **Free Rerolls**: Toggle unlimited shop rerolls
- **Joker Slots**: Modify joker capacity (0-100)
- **Consumable Slots**: Adjust consumable capacity (0-15)

### 🃏 Advanced Deck Builder
- **Custom Deck Creation**: Build decks with up to 104 cards
- **Enhanced Cards**: Add enhancements (Bonus, Mult, Wild, Glass, Steel, Stone, Gold, Lucky)
- **Sealed Cards**: Apply seals (Gold, Red, Blue, Purple)
- **Card Editions**: Apply editions (Foil, Holographic, Polychrome)
- **Smart Card Addition**: Cards inherit current enhancement/seal/edition settings
- **Deck Management**: Save and load custom deck configurations
- **Standard Templates**: Quick-create standard 52-card decks
- **Proper Card Format**: Uses correct Balatro card IDs (H_2, S_A, etc.)

### 🎯 Give System (NEW!)
- **Give Items During Runs**: Enable/disable giving items while playing
- **Give Money**: Add $10, $50, $100, or $1000 instantly
- **Give Cards**: Create any playing card with custom properties
  - Choose rank and suit
  - Apply any enhancement
  - Apply any seal
  - Apply any edition
  - Smart placement: Cards go to hand during rounds, deck when in shop
- **Give Jokers**: Instantly add any joker (vanilla or Mika's)
- **Give Consumables**: Add Tarot, Planet, or Spectral cards
- **Give Vouchers**: Apply any voucher effect immediately

### 🃏 Joker Selection
- **Starting Jokers**: Choose up to **30 copies** of any joker
- **Vanilla Jokers**: All base game jokers available
- **Mika's Integration**: Automatic detection and support for Mika's Mod Collection jokers
- **Smart UI**: Color-coded selection (Green: 1-9, Gold: 10-19, Orange: 20-29, Red: 30)
- **Tabbed Interface**: Separate tabs for vanilla and Mika's jokers

### 🎫 Voucher Selection
- **Starting Vouchers**: Select any vouchers to start with
- **All Vouchers Available**: Choose from 32 different vouchers
- **Easy Toggle**: Click to add/remove vouchers
- **Persistent Selection**: Vouchers are applied to new games only

### 🔧 Advanced Features
- **Modern UI**: Clean interface with contemporary styling
- **Non-Intrusive Toggle**: Press 'C' to open/close without affecting other menus
- **Hold-to-Repeat**: Hold +/- buttons for fast value changes
- **Optional Custom Decks**: Custom decks are disabled by default - enable when ready
- **No Save Duplication**: Fixed bug where jokers would duplicate on save/load
- **New Game Only**: Settings only apply to new games, not loaded saves
- **Legacy Conversion**: Automatically converts old deck formats
- **Console Commands**: Full console integration for precise control
- **Persistent Storage**: Save deck configurations and settings

## Installation

### Requirements
- **Steamodded**: Version 0.9.8 or higher (auto-installed via dependency)
- **Optional**: Mika's Mod Collection (for expanded joker selection)

### Steps
1. Download the mod files
2. Place `ZokersModMenu.lua` in your Balatro mods folder
3. If using Lovely injector, include the `lovely.toml` file
4. Launch Balatro and enjoy!

## Usage

### Opening the Menu
- **Keybind**: Press `C` anywhere in the game (won't close other menus!)
- **Pause Menu**: Click "Zoker's Menu" button in pause menu
- **Console**: Type `cs_open()` in the developer console (F7)

### Navigation
- **Starting Stats**: Adjust starting conditions and slots
- **Starting Items**: Select starting jokers and vouchers
- **Build Deck**: Create and customize your deck
- **Give**: Give yourself items during runs (when enabled)
- **Console**: Access quick commands

### Menu Controls
- **Toggle Features**: Click YES/NO buttons to enable/disable features
- **During Runs**: Some options are locked during active runs
- **Hold Buttons**: Hold +/- for rapid value changes
- **Tab Navigation**: Click tabs to switch between sections

### Console Commands

#### Basic Configuration
```lua
cs_money(100)          -- Set starting money to $100 (0-5000)
cs_hands(8)            -- Set starting hands to 8 (1-25)
cs_discards(6)         -- Set starting discards to 6 (0-25)
cs_hand_size(12)       -- Set hand size to 12 cards (1-50)
cs_hand_levels(3)      -- Set all poker hands to level 3 (1-100)
cs_free_rerolls(true)  -- Enable free rerolls
cs_slots(10)           -- Set joker slots to 10
cs_consumables(5)      -- Set consumable slots to 5
```

#### Joker & Voucher Management
```lua
cs_add_joker('credit_card')      -- Add Credit Card joker
cs_add_voucher('overstock_norm') -- Add Overstock voucher
cs_list_jokers()                 -- List all available jokers
cs_list_vouchers()               -- List all available vouchers
cs_show()                        -- Show current settings
```

#### Deck Management
```lua
cs_name_deck('My Deck')       -- Name current deck
cs_save_current_deck()        -- Save current deck
cs_load_deck('My Deck')       -- Load saved deck
cs_enable_custom_deck()       -- Enable custom deck for games
cs_disable_custom_deck()      -- Use default deck
cs_remove_card('AS')          -- Remove Ace of Spades
```

#### Utility
```lua
cs_open()     -- Open the mod menu
cs_show()     -- Display all current settings
```

## Compatibility

### Mika's Mod Collection Integration
When Mika's Mod Collection is detected, ZokersModMenu automatically:
- Adds a "Mika's" tab to the joker selection menu
- Includes all Mika's jokers in the selection pool
- Maintains the same 30-copy limit for Mika's jokers
- Provides seamless integration with existing functionality

### Known Issues
- UI may briefly flicker when giving cards (cosmetic only)
- Some voucher effects may require a shop refresh to fully apply

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

## Version History

### v1.4.8 (Latest - 2025-06-09)
- **FIXED**: Menu toggle now works properly without closing other menus
- **FIXED**: Card naming format updated to correct Balatro format (H_2, S_A, etc.)
- **FIXED**: Enhancement and seal cycling now properly saves and applies
- **IMPROVED**: Card giving logic - cards go to deck when in shop/between rounds
- **IMPROVED**: Give Card menu now refreshes properly after giving cards
- **ADDED**: Debug logging for enhancement/seal/edition changes
- **ADDED**: Small delays to prevent UI flickering when giving cards
- **FIXED**: Removed duplicate keyboard handlers causing instant menu close
- **FIXED**: Extra 'end' statements causing loading errors

### v1.4.1 (Previous)
- Initial Thunderstore release with core features
- Full deck builder with enhancements, seals, and editions
- Starting stats customization
- Joker and voucher selection systems
- Give item functionality
- Console command integration

## Support

If you encounter issues:
1. Check the console for error messages (F7)
2. Verify Steamodded is properly installed
3. Ensure mod files are in the correct directory
4. Try disabling other mods to test compatibility

## Credits

- **Author**: Zoker
- **Special Thanks**: Mika (Mikadoe) for the amazing Mika's Mod Collection
- **Community**: Balatro modding community for testing and feedback

---

*Customize your Balatro experience like never before! 🎲*