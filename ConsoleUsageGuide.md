# Console Usage Guide - ZokersModMenu v1.4.8

This guide will teach you how to use the developer console to access ZokersModMenu's powerful command system.

## 🎯 Quick Start

### Step 1: Open the Console
1. **Launch Balatro** and get to any screen (main menu, in-game, etc.)
2. **Press the F7 key** on your keyboard
3. A **dark console window** should appear at the bottom of the screen
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

## 🖥️ Console Basics

### How to Open Console
- **Primary Method**: Press `F7` key
- **Alternative**: Some systems use `Shift + F7` or `Ctrl + F7`
- **If F7 doesn't work**: Try `~` (tilde) key or `` ` `` (backtick)

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

### Common Issues
- **Console won't open**: Try different key combinations, ensure game is in focus
- **Commands don't work**: Check spelling - they're case sensitive!
- **Text too small**: Some systems have small console text - this is normal
- **Console disappears**: Press F7 again to reopen it

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

-- Set all poker hands to level 3 (NEW! 1-100)
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
-- Open the main menu (same as pressing 'C')
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
| `cs_disable_custom_deck()` | Use default deck | `cs_disable_custom_deck()` |
| `cs_remove_card('card')` | Remove card from deck | `cs_remove_card('KH')` |

### Information
| Command | Description | Example |
|---------|-------------|---------|
| `cs_show()` | Display all current settings | `cs_show()` |
| `cs_open()` | Open the main menu | `cs_open()` |

## 🎯 Practical Examples

### Example 1: Quick Setup for High Stakes
```lua
-- Open console (F7) and type these commands:
cs_money(2000)         -- Start with lots of money
cs_hands(8)            -- More hands per round
cs_discards(8)         -- More discards per round
cs_hand_size(15)       -- Bigger hand size
cs_hand_levels(3)      -- All hands start at level 3
cs_free_rerolls(true)  -- Free shop rerolls
cs_slots(12)           -- More joker slots
cs_show()              -- Check your settings
```

### Example 2: Building a Glass Card Deck
```lua
-- First, use the GUI to build your deck with glass cards
-- Then save it:
cs_name_deck('Glass Strategy')
cs_save_current_deck()
cs_enable_custom_deck()
-- Start a new game to use your glass deck!
```

### Example 3: Adding Multiple Jokers (UP TO 30 EACH!)
```lua
-- Add several jokers for a strong start:
cs_add_joker('credit_card')
cs_add_joker('blueprint')
cs_add_joker('brainstorm')
cs_add_joker('mime')
-- You can add the same joker multiple times!
cs_add_joker('credit_card')  -- Now you have 2 Credit Cards
cs_show()  -- Check how many jokers you have selected
```

### Example 4: Voucher Power Setup
```lua
-- Add powerful vouchers for a strong start:
cs_add_voucher('overstock_norm')  -- More cards in shop
cs_add_voucher('crystal_ball')    -- +1 consumable slot
cs_add_voucher('telescope')       -- Planet cards give hand levels
cs_add_voucher('seed_money')      -- Interest cap +$25
cs_list_vouchers()               -- See all available vouchers
```

### Example 5: Extreme Challenge Setup
```lua
-- Create an extreme starting setup:
cs_money(5000)          -- Maximum money
cs_hands(25)            -- Maximum hands
cs_discards(25)         -- Maximum discards  
cs_hand_size(50)        -- Maximum hand size
cs_hand_levels(10)      -- High starting hand levels
cs_slots(20)            -- Lots of joker slots
cs_free_rerolls(true)   -- Free rerolls
-- Add your favorite jokers and vouchers
cs_add_joker('blueprint')
cs_add_voucher('overstock_plus')
```

### Example 6: Deck Management
```lua
-- Save multiple deck configurations:
cs_name_deck('Flush Deck')
cs_save_current_deck()

-- Build a different deck in GUI, then:
cs_name_deck('Straight Deck')
cs_save_current_deck()

-- Load decks later:
cs_load_deck('Flush Deck')
cs_enable_custom_deck()
```

## 🔤 Card Notation

When using `cs_remove_card()`, use this format:
- **Rank + Suit**: `'AS'` = Ace of Spades
- **Ranks**: A, 2, 3, 4, 5, 6, 7, 8, 9, T, J, Q, K
- **Suits**: S (Spades), H (Hearts), D (Diamonds), C (Clubs)

**Examples**:
- `cs_remove_card('KH')` - King of Hearts
- `cs_remove_card('2D')` - Two of Diamonds  
- `cs_remove_card('TS')` - Ten of Spades

## 🎮 Joker Names

Use these exact names with `cs_add_joker()`:

### Popular Jokers
```lua
cs_add_joker('credit_card')    -- Credit Card
cs_add_joker('blueprint')      -- Blueprint
cs_add_joker('brainstorm')     -- Brainstorm
cs_add_joker('mime')           -- Mime
cs_add_joker('vampire')        -- Vampire
cs_add_joker('baron')          -- Baron
cs_add_joker('half')           -- Half Joker
```

### Mika's Jokers (if installed)
```lua
cs_add_joker('prime_time')     -- Prime Time
cs_add_joker('batman')         -- Batman
cs_add_joker('cultist')        -- Cultist
cs_add_joker('fisherman')      -- The Fisherman
```

**Tip**: Use `cs_list_jokers()` to see all available joker names!

## 🆘 Troubleshooting

### Console Won't Open
1. **Try different keys**: F7, Shift+F7, Ctrl+F7, ~, `
2. **Check game focus**: Click on the game window first
3. **Update Steamodded**: Ensure you have the latest version
4. **Restart game**: Sometimes helps with console issues

### Commands Not Working
1. **Check spelling**: Commands are case-sensitive
2. **Use exact format**: Include parentheses and quotes where shown
3. **Check numbers**: Values must be within specified ranges
4. **Try cs_show()**: Test if console is working at all

### Common Error Messages
- **"function not found"**: Check command spelling
- **"invalid amount"**: Number is outside allowed range
- **"joker not found"**: Check joker name with `cs_list_jokers()`
- **"deck not found"**: Check saved deck names

### v1.4.8 Specific Notes
- **Menu Toggle**: Press C to open/close without affecting other menus
- **Card Format**: Deck builder now uses correct card IDs (H_2, S_A, etc.)
- **Enhancement/Seal**: These now properly save and apply to cards
- **Give Cards**: Cards go to hand during rounds, deck when in shop

### Getting Help
1. **Type `cs_show()`**: See current settings
2. **Type `cs_list_jokers()`**: See available jokers
3. **Type `cs_list_vouchers()`**: See available vouchers
4. **Check this guide**: Reference command examples
5. **Use the GUI**: Menu system (Press 'C') is always available

---

**Remember**: The console is powerful but the GUI (Press 'C') is often easier for beginners! Use whatever method you prefer. 🎯