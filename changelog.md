# Changelog

All notable changes to ZokersModMenu will be documented in this file.

## [1.5.0] - 2025-06-11

### 🆕 New Features
  - Press C or go to steammodded config to toggle the menu
  - Helpful for users who have C key bound to other functions
  - Both work identically and can be used interchangeably
- **Multiple Access Methods**: Now 4 ways to open the menu:
  1. Press C key (traditional)
  2. Go to Steammodded Config in-game
  3. Type `cs_open()` in console

### 🛡️ Stability & Error Handling
- **Enhanced Crash Prevention**: Comprehensive error handling system
  - Protected all critical functions with pcall wrappers
  - Safe fallbacks for missing or nil values
  - Graceful recovery from unexpected game states
- **Metadata Fix**: Added missing "id" field to manifest.json
  - Fixes "invalid metadata" error in mod loaders
  - Improves compatibility with Steamodded and other loaders
- **Nil Reference Protection**: Added safety checks throughout
  - Prevents crashes when game objects are unexpectedly nil
  - Safe handling of missing jokers/vouchers/cards
  - Protected menu creation and updates

### 🔧 Technical Improvements
- **Error Recovery System**: Mod continues functioning even after errors
  - Non-critical errors are logged but don't crash the mod
  - Menu remains accessible even if some features fail
  - Automatic recovery attempts for common issues
- **Improved Mod Detection**: Better handling of Steamodded variations
  - Works with different Steamodded versions
  - Fallback methods for mod instance detection
  - Compatible with various mod manager setups
- **Safe State Management**: Protected game state modifications
  - Validates game state before applying changes
  - Prevents corruption of save data
  - Safe handling of mid-game modifications

### 🐛 Bug Fixes
- **Fixed Mod Loader Errors**: Resolved "id" field missing in metadata
- **Fixed Crash on Missing Objects**: Added nil checks for all game objects
- **Fixed Menu Creation Errors**: Protected menu initialization
- **Fixed Console Command Crashes**: Safe execution of all commands

### 📝 Documentation Updates
- Added information about F1 key alternative
- Updated all documentation to reflect v1.5.0
- Added crash prevention notes to support section
- Clarified multiple menu access methods

### 🔍 Developer Notes
- **Error Handling Pattern**: 
  ```lua
  local success, result = pcall(function()
    -- Protected code here
  end)
  if not success then
    -- Graceful fallback
  end
  ```
- **Menu Access Keys**: Both C and F1 use same toggle function
- **Metadata Structure**: manifest.json now includes required "id" field

---

## [1.4.8] - 2025-06-09

### 🐛 Critical Bug Fixes
- **Menu Toggle Fixed**: Menu now properly toggles with 'C' key without interfering with other game menus
  - Removed duplicate key handlers (Controller and Love2D) that caused instant close
  - Menu only opens/closes itself, leaving other UI elements untouched
  - Works reliably during runs and in main menu
- **Card ID Format Fixed**: Updated all card creation to use correct Balatro format
  - Changed from multiple format attempts to single correct format: `H_2`, `S_A`, `D_K`, `C_T`
  - Removed unnecessary suit name conversions
  - Deck builder and card giving now use consistent format
- **Syntax Error Fixed**: Removed extra `end` statements causing loading crashes
  - Fixed duplicate `if` condition in `Game:start_run`
  - Cleaned up function closures throughout the code

### 🔧 Technical Improvements
- **Enhancement/Seal Cycling**: Fixed cycling functions to properly save and apply
  - Added debug logging to track when values change
  - Ensured config saves after each change
  - Added initialization debugging to verify values on load
- **Card Giving Logic**: Improved where cards are placed when given
  - Cards go to hand during active rounds (SELECTING_HAND, DRAW_TO_HAND, HAND_PLAYED)
  - Cards go to deck when in shop or between rounds
  - Added state checking for smarter card placement
- **UI Stability**: Added delays to prevent UI flickering
  - Card creation now uses 0.1s delay
  - Menu refresh uses 0.2s delay after card creation
  - Prevents visual glitches when giving items

### 🎨 UI/UX Enhancements
- **Debug Logging**: Added comprehensive logging for easier troubleshooting
  - Enhancement/seal/edition changes logged to console
  - Card creation logs show all applied properties
  - Initial values logged on mod load
- **Menu Refresh**: Give Card menu now properly refreshes after giving cards
  - Prevents UI elements from disappearing
  - Maintains menu state between card gives

### 📝 Code Quality
- **Simplified Key Handling**: Removed complex state checking
  - Now simply checks if in run or menu
  - More reliable and predictable behavior
- **Consistent Formatting**: Standardized card ID usage throughout
  - All functions now use same format (SUIT_RANK)
  - Easier to maintain and debug

### 🔍 Developer Notes
- **Card Format Reference**: 
  - Hearts: H_A, H_2, H_3... H_K
  - Spades: S_A, S_2, S_3... S_K
  - Diamonds: D_A, D_2, D_3... D_K
  - Clubs: C_A, C_2, C_3... C_K
  - 10s use 'T': H_T, S_T, D_T, C_T

---

## [1.4.1] - 2025-06-08

### 🎉 Initial Thunderstore Release
- **Core Features**: Complete mod framework with all functionality
- **Give System**: Full implementation of item giving during runs
  - Give Money with multiple denominations
  - Give Cards with full customization
  - Give Jokers (vanilla and Mika's)
  - Give Consumables (Tarot, Planet, Spectral)
  - Give Vouchers with immediate effect
- **Hand Levels**: Added starting hand level customization (1-100)
- **Modern UI**: Clean, contemporary interface design
- **Console Integration**: Comprehensive command system

### 🎮 Features Included
- Starting money adjustment ($0-$5000)
- Starting hands modification (1-25)
- Starting discards control (0-25)
- Hand size customization (1-50)
- Hand level adjustment (1-100)
- Free rerolls toggle
- Joker slots customization (0-100)
- Consumable slots adjustment (0-15)
- Enhanced card support (9 enhancement types)
- Seal system (5 seal types)
- Edition system (Foil, Holographic, Polychrome)
- Optional custom deck system
- Give items during runs (when enabled)
- Tabbed interface for joker selection

---

## [1.3.0] - 2025-06-07

### 🆕 Major Features Added
- **Voucher Selection System**: Complete voucher selection interface
  - All 32 vouchers available for selection
  - Easy toggle interface (click to add/remove)
  - Vouchers applied automatically at game start
  - Console commands: `cs_add_voucher()`, `cs_list_vouchers()`
- **Increased Joker Limit**: Up to **30 copies** of the same joker (increased from 20)
- **Expanded Limits**: Significantly increased customization ranges
  - Money: $0-$5000 (was $0-$999)
  - Hands: 1-25 (was 1-20)
  - Discards: 0-25 (was 0-20) 
  - Hand Size: 1-50 (was 1-30)

### 🎨 UI/UX Revolution
- **Modern Interface**: Complete visual overhaul with contemporary styling
  - Card-based layout for stats overview
  - Rounded corners and improved color schemes
  - Better button styling with hover effects
  - Enhanced visual hierarchy and spacing
- **Enhanced Color Coding**: New 4-tier joker count system
  - Green: 1-9 copies
  - Gold: 10-19 copies
  - Orange: 20-29 copies (new tier)
  - Red: 30 copies (maximum)
- **Hold-to-Repeat**: Hold +/- buttons for rapid value changes
  - Eliminates tedious clicking for large adjustments
  - Smart acceleration for efficient value setting

### 🐛 Critical Bug Fixes
- **Save/Load Duplication Fix**: Completely resolved joker duplication on save/load
  - Settings now only apply to NEW games, not loaded saves
  - Prevents accumulation of starting items across sessions
  - Clean game state management
- **Improved Game State Detection**: Better handling of new vs loaded games

### 🔧 Technical Enhancements
- **Enhanced Menu System**: Added voucher menu with pagination
- **Improved Button Functions**: All adjustment functions support new limits
- **Console Command Expansion**: New voucher-related commands
- **Better Error Handling**: More robust input validation
- **Performance Optimization**: Streamlined UI rendering

---

## [1.2.0] - 2025-06-07

### 🆕 New Features
- **Hand Size Customization**: Added ability to set hand size from 1-30 cards
  - New GUI controls in Money & Stats menu
  - Console command `cs_hand_size(amount)` for precise control
  - Applied at game start with persistent maintenance

### 🔧 Technical Improvements  
- **Enhanced Steamodded Compatibility**: Fixed mod loading issues with Thunderstore
  - Multiple fallback methods for mod instance detection
  - Robust error handling for different Steamodded versions
  - Better integration with mod managers
- **Improved Save System**: Enhanced config saving with version compatibility
- **Defensive Programming**: Added nil checks and safety measures throughout

### 🐛 Bug Fixes
- Fixed `attempt to index local 'mod' (a nil value)` error
- Resolved Thunderstore mod manager compatibility issues
- Fixed hand size not applying properly on game start
- Improved mod loading reliability across different environments

---

## [1.1.0] - 2025-06-06

### 🆕 Major Features Added
- **Increased Joker Limit**: You can now select up to **20 copies** of the same joker (increased from 10)
- **Mika's Mod Collection Integration**: Full compatibility with Mika's Mod Collection
  - Automatic detection of Mika's Mod Collection
  - Dedicated "Mika's Jokers" tab when mod is available
  - Over 60 Mika's jokers supported
  - Same 20-copy limit applies to Mika's jokers

### 🎨 UI/UX Improvements
- **Enhanced Color Coding**: New joker count visualization system
  - Green: 1-9 copies
  - Gold: 10-19 copies  
  - Red: 20+ copies (maximum)
- **Dynamic Menu**: Mika's Jokers button appears automatically when mod is detected
- **Separate Pagination**: Independent page tracking for vanilla and Mika's jokers
- **Improved Button Colors**: Mika's button uses distinctive pink theme

---

## [1.0.0] - 2025-06-06

### 🎉 Initial Release
- **Core Features**: Complete mod framework with all basic functionality
- **Deck Builder**: Custom deck creation with enhancements and seals
- **Joker Selection**: Starting joker selection with up to 10 copies
- **Starting Conditions**: Money, hands, discards, rerolls, slots customization
- **Console Commands**: Full console integration with 15+ commands
- **Keybind Support**: Press 'C' to open menu anywhere
- **Deck Management**: Save/load custom deck configurations
- **Legacy Support**: Automatic conversion of old deck formats

---

## Future Plans

### Potential Features
- [ ] Blind customization system  
- [ ] Enhanced deck templates
- [ ] Import/export deck sharing
- [ ] Advanced filtering options
- [ ] More mod integrations
- [ ] Stake modification support
- [ ] Challenge mode customization
- [ ] Seed manipulation tools
- [ ] Statistics tracking
- [ ] Additional hotkeys for specific functions

### Known Issues (v1.5.0)
- [ ] UI may briefly flicker when giving cards (cosmetic only)
- [ ] Some voucher effects may require shop refresh to fully apply
- [ ] Enhancement/seal display may not update immediately in deck builder

---

*For support or feature requests, please contact the mod author or visit the project repository.*