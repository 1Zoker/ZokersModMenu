# Console Usage Guide - ZokersModMenu v1.5.0

This guide will teach you how to use the developer console to access ZokersModMenu's powerful command system.

## 🎯 Quick Start

### Step 1: Open the Console
1. **Launch Balatro** and get to any screen (main menu, in-game, etc.)
2. Use alternative mod to access console like debugplus
3. A **debug plus window** should appear at the bottom of the screen
4. You should see a **cursor** ready for input

### Step 2: Type Your First Command
1. **Click in the console** to make sure it's active
2. **Type**: `cs_show()`
3. **Press Enter**
4. You should see your current ZokersModMenu settings displayed!

### Step 3: Try Changing Something
1. **Type**: `cs_money(100)`
2. **Press Enter**
3. **Type**: `cs_hand_size(12)`
4. **Press Enter**
5. **Type**: `cs_show()`
6. **Press Enter**
7. Notice how your starting money is now $100 and hand size is 12!

## 🆕 New in v1.5.0: Multiple Menu Access Methods

You can now open the mod menu in multiple ways:
- **Press C** - Traditional quick access key
- **Go to Config in mods** - New alternative route
- **Pause Menu Button** - Click "Zoker's Menu" in pause menu
- **Console Command** - Type `cs_open()` in console

All methods work identically - use whichever is most convenient!

## 🖥️ Console Basics


### Console Interface
```
[Console appears as a dark overlay at bottom of screen]
> [cursor here - you can type]
```

### How to Use Commands
1. **Type the command exactly** as shown in this guide
2. **Press Enter** to execute
3. **Watch for feedback** - the console will show results
4. **Type new commands** on the next line

### Common Issues & v1.5.0 Fixes
- **Console won't open**: Try different key combinations, ensure game is in focus
- **Commands don't work**: Check spelling - they're case sensitive!
- **Text too small**: Some systems have small console text - this is normal
- **Console disappears**: Press F7 again to reopen it
- **Crashes/Errors**: v1.5.0 includes enhanced error handling - most errors won't crash the mod

## 🎮 Essential Commands

### Basic Settings
```lua
-- View all current settings
cs_show()

-- Set starting money to $500 (0-5000)
cs_money(500)

-- Set starting hands to 8 (1-25)
cs_hands(8)

-- Set starting discards to 6 (0-25)
cs_discards(6)

-- Set hand size to 15 cards (1-50)
cs_hand_size(15)

-- Set all poker hands to level 3 (1-100)
cs_hand_levels(3)

-- Enable free rerolls
cs_free_rerolls(true)

-- Disable free rerolls
cs_free_rerolls(false)
```

### Joker & Slot Management
```lua
-- Set joker slots to 8
cs_slots(8)

-- Set consumable slots to 4
cs_consumables(4)

-- Add a joker to starting selection (up to 30 copies!)
cs_add_joker('credit_card')

-- List all available jokers
cs_list_jokers()
```

### Voucher Management
```lua
-- Add a voucher to starting selection
cs_add_voucher('overstock_norm')

-- Add multiple vouchers
cs_add_voucher('crystal_ball')
cs_add_voucher('telescope')

-- List all available vouchers
cs_list_vouchers()
```

### Deck Management
```lua
-- Name your current deck
cs_name_deck('My Awesome Deck')

-- Save the current deck
cs_save_current_deck()

-- Load a previously saved deck
cs_load_deck('My Awesome Deck')

-- Enable your custom deck for the next game
cs_enable_custom_deck()

-- Go back to using the default deck
cs_disable_custom_deck()

-- Remove a specific card (Ace of Spades)
cs_remove_card('AS')
```

### Utility Commands
```lua
-- Open the main menu (same as pressing 'C' or 'F1')
cs_open()

-- Show all current settings
cs_show()
```

## 📋 Command Reference

### Money Management
| Command | Description | Example |
|---------|-------------|---------|
| `cs_money(amount)` | Set starting money (0-5000) | `cs_money(1000)` |

### Game Stats
| Command | Description | Example |
|---------|-------------|---------|
| `cs_hands(amount)` | Set starting hands (1-25) | `cs_hands(10)` |
| `cs_discards(amount)` | Set starting discards (0-25) | `cs_discards(8)` |
| `cs_hand_size(amount)` | Set hand size (1-50) | `cs_hand_size(15)` |
| `cs_hand_levels(amount)` | Set poker hand levels (1-100) | `cs_hand_levels(5)` |
| `cs_free_rerolls(true/false)` | Toggle free rerolls | `cs_free_rerolls(true)` |

### Slots & Capacity
| Command | Description | Example |
|---------|-------------|---------|
| `cs_slots(amount)` | Set joker slots (0-100) | `cs_slots(10)` |
| `cs_consumables(amount)` | Set consumable slots (0-15) | `cs_consumables(5)` |

### Joker Selection (UP TO 30 COPIES!)
| Command | Description | Example |
|---------|-------------|---------|
| `cs_add_joker('name')` | Add a joker to starting selection | `cs_add_joker('mime')` |
| `cs_list_jokers()` | Show all available jokers | `cs_list_jokers()` |

### Voucher Selection
| Command | Description | Example |
|---------|-------------|---------|
| `cs_add_voucher('name')` | Add voucher to starting selection | `cs_add_voucher('overstock_norm')` |
| `cs_list_vouchers()` | Show all available vouchers | `cs_list_vouchers()` |

### Deck Building
| Command | Description | Example |
|---------|-------------|---------|
| `cs_name_deck('name')` | Name current deck | `cs_name_deck('Glass Deck')` |
| `cs_save_current_deck()` | Save current deck | `cs_save_current_deck()` |
| `cs_load_deck('name')` | Load saved deck | `cs_load_deck('Glass Deck')` |
| `cs_enable_custom_deck()` | Enable custom deck for games | `cs_enable_custom_deck()` |
| `cs_disable_custom_deck()` | Use default deck | `cs_disabl