--- STEAMODDED HEADER
--- MOD_NAME: ZokersModMenu
--- MOD_ID: ZokersModMenu
--- MOD_AUTHOR: [Zoker]
--- MOD_DESCRIPTION: Complete game customization: Build custom decks with enhancements/seals/editions, set starting items (jokers/vouchers/tags), adjust all stats (money/hands/discards/slots), modify ante scaling, give any item during runs, unlock all content.
--- BADGE_COLOUR: 708b91
--- PREFIX: cs
--- PRIORITY: 0
--- VERSION: 2.0.0
--- RELEASE_DATE: 2025-06-13

----------------------------------------------
------------MOD CODE -------------------------

-- Get the mod instance with fallback for older Steamodded versions
local mod = SMODS.current_mod or SMODS.Mods and SMODS.Mods.ZokersModMenu or {}

-- Ensure mod has a config table
if not mod.config then
    mod.config = {}
end

-- Safety check for mod loading
if not mod then
    print("ZokersModMenu: Warning - mod instance not found, creating fallback")
    mod = {config = {}}
end

-- Save config function with fallback and debugging
local function save_config()
    if SMODS.save_mod_config and mod then
        SMODS.save_mod_config(mod)
        print("ZokersModMenu: Config saved via SMODS.save_mod_config. Deck size: " .. #mod.config.custom_deck)
    elseif SMODS.save_config then
        SMODS.save_config("ZokersModMenu", mod.config)
        print("ZokersModMenu: Config saved via SMODS.save_config. Deck size: " .. #mod.config.custom_deck)
    else
        print("ZokersModMenu: Warning - No save method available!")
    end
end

-- Add Steamodded config tab for opening the menu
if SMODS and SMODS.current_mod then
    SMODS.current_mod.config_tab = function()
        return {
            n = G.UIT.ROOT,
            config = {align = "cm", padding = 0.1, colour = G.C.CLEAR},
            nodes = {
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.T, config = {text = "Zoker's Mod Menu", scale = 0.8, colour = G.C.WHITE}}
                }},
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.T, config = {text = "Press 'C' in-game or click below to open", scale = 0.4, colour = G.C.WHITE}}
                }},
                {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_open_main_menu_from_config", hover = true, minw = 3, minh = 1, colour = G.C.BLUE, r = 0.1}, 
                     nodes = {{n = G.UIT.T, config = {text = "Open Mod Menu", scale = 0.5, colour = G.C.WHITE}}}}
                }},
                -- Add disable checkbox in config
                {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.C, config = {align = "cl", padding = 0.05}, nodes = {
                        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_mod_disabled_config", hover = true, minw = 0.5, minh = 0.5, 
    colour = mod.config.mod_disabled and {0.5, 0.5, 0.5, 1} or G.C.WHITE, r = 0.05, outline_colour = G.C.BLACK, outline = 1}, 
 nodes = {{n = G.UIT.T, config = {text = mod.config.mod_disabled and "✗" or "✓", scale = 0.4, colour = mod.config.mod_disabled and G.C.WHITE or G.C.BLACK}}}},
{n = G.UIT.T, config = {text = mod.config.mod_disabled and " Disabled" or " Enabled", scale = 0.5, colour = G.C.WHITE}}
                    }}
                }}
            }
        }
    end
end

-- Function to toggle mod disabled from config
G.FUNCS.cs_toggle_mod_disabled_config = function(e)
    mod.config.mod_disabled = not mod.config.mod_disabled
    save_config()
    -- Refresh the config menu
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    -- Reopen config
    G.FUNCS.options(nil, true)
    if mod.config.mod_disabled then
        print("ZokersModMenu: Mod disabled")
    else
        print("ZokersModMenu: Mod enabled")
    end
end

-- Function to open menu from Steamodded config
G.FUNCS.cs_open_main_menu_from_config = function(e)
    -- Close the Steamodded config menu first
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    
    -- Small delay to ensure smooth transition
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
            G.FUNCS.cs_open_main_menu()
            return true
        end
    }))
end

-- Ensure all values exist with defaults
mod.config.starting_money = mod.config.starting_money or 4
mod.config.starting_hands = mod.config.starting_hands or 4
mod.config.starting_discards = mod.config.starting_discards or 3
mod.config.hand_size = mod.config.hand_size or 8
mod.config.hand_levels = mod.config.hand_levels or 1
mod.config.free_rerolls = mod.config.free_rerolls or false
mod.config.joker_slots = mod.config.joker_slots or 5
mod.config.consumable_slots = mod.config.consumable_slots or 2
mod.config.custom_deck = mod.config.custom_deck or {}
mod.config.starting_jokers = mod.config.starting_jokers or {}
mod.config.starting_vouchers = mod.config.starting_vouchers or {}
mod.config.starting_tags = mod.config.starting_tags or {}
mod.config.current_deck_name = mod.config.current_deck_name or "Custom Deck"
mod.config.use_custom_stats = mod.config.use_custom_stats or false
mod.config.use_custom_deck = mod.config.use_custom_deck or false
mod.config.allow_give_during_runs = mod.config.allow_give_during_runs or false
mod.config.use_starting_items = mod.config.use_starting_items or false
mod.config.ante_scaling = mod.config.ante_scaling or 1
mod.config.mod_disabled = mod.config.mod_disabled or false  -- NEW: disable option

-- Enhanced card structure with seals, enhancements and editions - DEFINED FIRST
local function create_card_data(rank, suit, enhancement, seal, edition)
    return {
        rank = rank,
        suit = suit,
        enhancement = enhancement or 'base',
        seal = seal or 'none',
        edition = edition or 'base'
    }
end

-- Available vanilla jokers list (alphabetically sorted) - FIXED names
local available_jokers = {
    'j_8_ball', 'j_abstract', 'j_acrobat', 'j_ancient', 'j_arrowhead', 'j_astronomer',
    'j_banner', 'j_baron', 'j_baseball', 'j_blackboard', 'j_bloodstone', 'j_blue_joker',
    'j_blueprint', 'j_bootstraps', 'j_brainstorm', 'j_bull', 'j_burglar', 'j_burnt',
    'j_business', 'j_campfire', 'j_caino', 'j_card_sharp', 'j_cartomancer', 'j_castle',
    'j_cavendish', 'j_ceremonial', 'j_certificate', 'j_chaos', 'j_chicot', 'j_clever',
    'j_cloud_9', 'j_constellation', 'j_crafty', 'j_crazy', 'j_credit_card', 'j_delayed_grat',
    'j_devious', 'j_diet_cola', 'j_dna', 'j_drivers_license', 'j_droll', 'j_drunkard',
    'j_duo', 'j_dusk', 'j_egg', 'j_erosion', 'j_even_steven', 'j_faceless',
    'j_family', 'j_fibonacci', 'j_flash', 'j_flower_pot', 'j_fortune_teller', 'j_four_fingers',
    'j_gift', 'j_glass', 'j_gluttenous_joker', 'j_golden', 'j_ticket', 'j_greedy_joker',
    'j_green_joker', 'j_gros_michel', 'j_hack', 'j_half', 'j_hallucination', 'j_hanging_chad',
    'j_hiker', 'j_hit_the_road', 'j_hologram', 'j_ice_cream', 'j_idol', 'j_invisible',
    'j_joker', 'j_jolly', 'j_juggler', 'j_loyalty_card', 'j_luchador', 'j_lucky_cat',
    'j_lusty_joker', 'j_mad', 'j_madness', 'j_mail', 'j_marble', 'j_matador',
    'j_merry_andy', 'j_midas_mask', 'j_mime', 'j_misprint', 'j_mr_bones', 'j_mystic_summit',
    'j_odd_todd', 'j_onyx_agate', 'j_oops', 'j_obelisk', 'j_order', 'j_pareidolia',
    'j_perkeo', 'j_photograph', 'j_popcorn', 'j_raised_fist', 'j_ramen', 'j_red_card',
    'j_reserved_parking', 'j_ride_the_bus', 'j_riff_raff', 'j_ring_master', 'j_rocket', 'j_rough_gem',
    'j_runner', 'j_satellite', 'j_scary_face', 'j_scholar', 'j_seance', 'j_seeing_double',
    'j_selzer', 'j_shoot_the_moon', 'j_shortcut', 'j_sixth_sense', 'j_sly', 'j_smeared',
    'j_smiley', 'j_sock_and_buskin', 'j_space', 'j_splash', 'j_square', 'j_steel_joker',
    'j_stencil', 'j_stone', 'j_stuntman', 'j_supernova', 'j_superposition', 'j_swashbuckler',
    'j_throwback', 'j_to_the_moon', 'j_todo_list', 'j_trading', 'j_triboulet', 'j_tribe',
    'j_trio', 'j_troubadour', 'j_trousers', 'j_turtle_bean', 'j_vagabond', 'j_vampire',
    'j_walkie_talkie', 'j_wee', 'j_wily', 'j_wrathful_joker', 'j_yorick', 'j_zany'
}

-- Mika's Mod Collection jokers (alphabetically sorted)
local mikas_jokers = {
    'j_mmc_abbey_road', 'j_mmc_aurora_borealis', 'j_mmc_batman', 'j_mmc_blackjack', 'j_mmc_blue_moon',
    'j_mmc_bomb', 'j_mmc_broke', 'j_mmc_buy_one_get_one', 'j_mmc_camper', 'j_mmc_cheat',
    'j_mmc_cheapskate', 'j_mmc_checklist', 'j_mmc_cicero', 'j_mmc_commander', 'j_mmc_cultist',
    'j_mmc_dagonet', 'j_mmc_dawn', 'j_mmc_delayed', 'j_mmc_eye_chart', 'j_mmc_finishing_blow',
    'j_mmc_fisherman', 'j_mmc_fishing_license', 'j_mmc_football_card', 'j_mmc_glass_cannon', 'j_mmc_glue',
    'j_mmc_go_for_broke', 'j_mmc_gold_bar', 'j_mmc_grudgeful', 'j_mmc_harp_seal', 'j_mmc_historical',
    'j_mmc_horseshoe', 'j_mmc_impatient', 'j_mmc_incomplete', 'j_mmc_investor', 'j_mmc_monopolist',
    'j_mmc_mountain_climber', 'j_mmc_nebula', 'j_mmc_one_of_us', 'j_mmc_pack_a_punch', 'j_mmc_plus_one',
    'j_mmc_prime_time', 'j_mmc_printer', 'j_mmc_psychic', 'j_mmc_rigged', 'j_mmc_savings',
    'j_mmc_scoring_test', 'j_mmc_scratch_card', 'j_mmc_seal_collector', 'j_mmc_seal_steal', 'j_mmc_shackles',
    'j_mmc_showoff', 'j_mmc_sniper', 'j_mmc_special_edition', 'j_mmc_stockpiler', 'j_mmc_straight_nate',
    'j_mmc_street_fighter', 'j_mmc_student_loans', 'j_mmc_suit_alley', 'j_mmc_tax_collector', 'j_mmc_training_wheels'
}

-- Available vouchers list (alphabetically sorted)
local available_vouchers = {
    'v_antimatter', 'v_blank', 'v_clearance_sale', 'v_crystal_ball', 'v_directors_cut',
    'v_glow_up', 'v_grabber', 'v_hieroglyph', 'v_hone', 'v_illusion',
    'v_liquidation', 'v_magic_trick', 'v_money_tree', 'v_nacho_tong', 'v_observatory',
    'v_omen_globe', 'v_overstock_norm', 'v_overstock_plus', 'v_paint_brush', 'v_palette',
    'v_petroglyph', 'v_planet_merchant', 'v_planet_tycoon', 'v_recyclomancy', 'v_reroll_glut',
    'v_reroll_surplus', 'v_retcon', 'v_seed_money', 'v_tarot_merchant', 'v_tarot_tycoon',
    'v_telescope', 'v_wasteful'
}

-- Available tags list (alphabetically sorted) - BASE GAME ONLY
local available_tags = {
    'tag_boss', 'tag_buffoon', 'tag_charm', 'tag_coupon', 'tag_d_six',
    'tag_double', 'tag_economy', 'tag_ethereal', 'tag_foil', 'tag_garbage',
    'tag_handy', 'tag_holo', 'tag_investment', 'tag_juggle', 'tag_meteor', 'tag_negative',
    'tag_orbital', 'tag_polychrome', 'tag_rare', 'tag_skip', 'tag_standard', 'tag_top_up',
    'tag_uncommon', 'tag_voucher'
}

-- Tarot cards (alphabetically sorted)
local tarot_cards = {
    'c_chariot', 'c_death', 'c_devil', 'c_emperor', 'c_empress',
    'c_fool', 'c_hanged_man', 'c_hermit', 'c_hierophant', 'c_high_priestess',
    'c_judgement', 'c_justice', 'c_lovers', 'c_magician', 'c_moon',
    'c_star', 'c_strength', 'c_sun', 'c_temperance', 'c_tower',
    'c_wheel_of_fortune', 'c_world'
}

-- Planet cards (alphabetically sorted)
local planet_cards = {
    'c_ceres', 'c_earth', 'c_eris', 'c_jupiter', 'c_mars', 
    'c_mercury', 'c_neptune', 'c_planet_x', 'c_pluto', 
    'c_saturn', 'c_uranus', 'c_venus'
}

-- Spectral cards (alphabetically sorted)
local spectral_cards = {
    'c_ankh', 'c_aura', 'c_black_hole', 'c_cryptid', 'c_deja_vu',
    'c_ectoplasm', 'c_familiar', 'c_grim', 'c_hex', 'c_immolate',
    'c_incantation', 'c_medium', 'c_ouija', 'c_sigil', 'c_soul',
    'c_talisman', 'c_trance', 'c_wraith'
}

-- Function to check if Mika's Mod Collection is enabled
local function is_mikas_mod_enabled()
    -- Check if any Mika's jokers exist in the game
    if SMODS and SMODS.Jokers then
        for _, joker_key in ipairs(mikas_jokers) do
            if SMODS.Jokers[joker_key] then
                return true
            end
        end
    end
    return false
end

-- Enhancement, seal and edition options
local enhancement_options = {
    {key = 'base', name = 'Base'},
    {key = 'm_bonus', name = 'Bonus'},
    {key = 'm_mult', name = 'Mult'},
    {key = 'm_wild', name = 'Wild'},
    {key = 'm_glass', name = 'Glass'},
    {key = 'm_steel', name = 'Steel'},
    {key = 'm_stone', name = 'Stone'},
    {key = 'm_gold', name = 'Gold'},
    {key = 'm_lucky', name = 'Lucky'}
}

local seal_options = {
    {key = 'none', name = 'No Seal'},
    {key = 'Gold', name = 'Gold Seal'},
    {key = 'Red', name = 'Red Seal'},
    {key = 'Blue', name = 'Blue Seal'},
    {key = 'Purple', name = 'Purple Seal'}
}

local edition_options = {
    {key = 'base', name = 'Base'},
    {key = 'foil', name = 'Foil'},
    {key = 'holo', name = 'Holographic'},
    {key = 'polychrome', name = 'Polychrome'}
}

-- Current enhancement/seal/edition selection - ensure proper initialization
mod.config.current_enhancement = mod.config.current_enhancement or 'base'
mod.config.current_seal = mod.config.current_seal or 'none'
mod.config.current_edition = mod.config.current_edition or 'base'

-- Debug print current values
print("ZokersModMenu: Initial enhancement/seal/edition: " .. mod.config.current_enhancement .. "/" .. mod.config.current_seal .. "/" .. mod.config.current_edition)

-- Simple overlay creation function - IMPROVED with better tracking
local function create_overlay(content)
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    
    G.OVERLAY_MENU = UIBox{
        definition = content,
        config = {offset = {x=0,y=0}, align = 'cm', parent = G.OVERLAY}
    }
    G.OVERLAY_MENU.zokers_menu = true  -- Mark this as our menu
end

-- Function to check if our menu is open
local function is_zokers_menu_open()
    return G.OVERLAY_MENU and G.OVERLAY_MENU.zokers_menu
end

-- Function to close our menu specifically
local function close_zokers_menu()
    if is_zokers_menu_open() then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
end

-- Store reference to other menus when we open
local stored_overlay = nil

-- Convert legacy deck format to enhanced format
local function convert_legacy_deck()
    if #mod.config.custom_deck > 0 then
        local needs_conversion = false
        
        -- Check if any cards are still in old string format
        for _, card_data in ipairs(mod.config.custom_deck) do
            if type(card_data) == "string" then
                needs_conversion = true
                break
            end
        end
        
        if needs_conversion then
            local new_deck = {}
            for _, card_id in ipairs(mod.config.custom_deck) do
                if type(card_id) == "string" then
                    local rank = card_id:sub(1, 1)
                    local suit = card_id:sub(2, 2)
                    table.insert(new_deck, create_card_data(rank, suit))
                else
                    table.insert(new_deck, card_id)
                end
            end
            mod.config.custom_deck = new_deck
            save_config()
        end
    end
end

-- Track if ante scaling has been applied for this ante
mod._ante_scaled = {}

-- GAME MODIFICATION HOOKS - Apply custom stats and deck
-- Hook into game start to apply custom values
local ref_Game_start_run = Game.start_run
function Game:start_run(args)
    -- Reset deck replacement flags for new run
    mod._deck_replaced = false
    mod._deck_needs_replacement = mod.config.use_custom_deck and #mod.config.custom_deck > 0
    
    -- Reset ante scaling tracker
    mod._ante_scaled = {}
    
    -- Call original function FIRST to ensure game is properly initialized
    ref_Game_start_run(self, args)
    
    -- Check if mod is disabled
    if mod.config.mod_disabled then
        print("ZokersModMenu: Mod is disabled, not applying any settings")
        return
    end
    
    -- IMPORTANT: Only apply mod settings to NEW runs, not loaded saves
    -- Check if this is a loaded save by looking for existing round number > 1 or if we're past ante 1
    local is_loaded_save = false
    if args and args.savetext then
        is_loaded_save = true
    elseif G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante and G.GAME.round_resets.ante > 1 then
        is_loaded_save = true
    elseif G.GAME and G.GAME.round and G.GAME.round > 1 then
        is_loaded_save = true
    end
    
    -- If this is a loaded save, don't apply any mod settings
    if is_loaded_save then
        print("ZokersModMenu: Loaded save detected, not applying mod settings")
        return
    end
    
    print("ZokersModMenu: New run detected, applying mod settings")
    
    -- Apply custom deck IMMEDIATELY if enabled
    if mod.config.use_custom_deck and #mod.config.custom_deck > 0 and G.playing_cards and G.deck and not mod._deck_replaced then
        print("ZokersModMenu: Applying custom deck at run start with " .. #mod.config.custom_deck .. " cards")
        
        -- Clear existing deck
        for i = #G.playing_cards, 1, -1 do
            local card = G.playing_cards[i]
            if card then
                if G.deck.cards then
                    for j = #G.deck.cards, 1, -1 do
                        if G.deck.cards[j] == card then
                            table.remove(G.deck.cards, j)
                            break
                        end
                    end
                end
                card:remove()
            end
        end
        G.playing_cards = {}
        
        -- Create custom deck
        local cards_created = 0
        for _, card_data in ipairs(mod.config.custom_deck) do
            local rank = card_data.rank
            local suit = card_data.suit
            local enhancement = card_data.enhancement or 'base'
            local seal = card_data.seal or 'none'
            local edition = card_data.edition or 'base'
            
            -- Use correct card ID format: H_2, S_A, etc.
            local card_id = suit .. '_' .. rank
            
            if G.P_CARDS[card_id] then
                -- Create card with base center
                local card = Card(
                    G.deck.T.x, G.deck.T.y,
                    G.CARD_W, G.CARD_H,
                    G.P_CARDS[card_id],
                    G.P_CENTERS.c_base,
                    {playing_card = card_id}
                )
                
                if card then
                    -- Apply enhancement after creation if not base
                    if enhancement ~= 'base' and G.P_CENTERS[enhancement] then
                        card:set_ability(G.P_CENTERS[enhancement])
                    end
                    
                    -- Apply seal
                    if seal ~= 'none' then
                        card.seal = seal
                    end
                    
                    -- Apply edition
                    if edition ~= 'base' then
                        card:set_edition({[edition] = true})
                    end
                    
                    -- Lucky cards will be handled by the game's native logic with our hook
                    
                    -- Add to deck
                    card:add_to_deck()
                    table.insert(G.playing_cards, card)
                    G.deck:emplace(card)
                    cards_created = cards_created + 1
                end
            else
                print("ZokersModMenu: Warning - Card not found: " .. card_id)
            end
        end
        
        -- Update deck count
        if G.deck.config then
            G.deck.config.card_count = #G.playing_cards
        end
        
        -- Shuffle deck
        G.deck:shuffle('nr' .. (G.GAME.round_resets.ante or 1))
        
        mod._deck_replaced = true
        print("ZokersModMenu: Custom deck applied at run start (" .. cards_created .. " cards created, " .. #G.playing_cards .. " total)")
    end
    
    -- Apply custom starting stats if enabled
    if mod.config.use_custom_stats then
        -- Apply money immediately after run starts
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                -- Set starting money
                G.GAME.dollars = mod.config.starting_money
                
                -- Set round reset values
                if G.GAME.round_resets then
                    G.GAME.round_resets.hands = mod.config.starting_hands
                    G.GAME.round_resets.discards = mod.config.starting_discards
                    
                    -- Apply ante scaling will be handled separately
                    
                    -- Apply free rerolls is now independent
                end
                
                -- Update current hands/discards
                if G.GAME.current_round then
                    G.GAME.current_round.hands_left = mod.config.starting_hands
                    G.GAME.current_round.discards_left = mod.config.starting_discards
                end
                
                -- Set hand size
                if G.hand and G.hand.config then
                    G.hand.config.card_limit = mod.config.hand_size
                end
                
                -- Set joker slots
                if G.jokers and G.jokers.config then
                    G.jokers.config.card_limit = mod.config.joker_slots
                end
                
                -- Set consumable slots
                if G.consumeables and G.consumeables.config then
                    G.consumeables.config.card_limit = mod.config.consumable_slots
                end
                
                print("ZokersModMenu: Applied custom starting stats")
                return true
            end
        }))
    end
    
    -- Apply free rerolls independently if enabled
    if mod.config.free_rerolls then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if G.GAME.round_resets then
                    G.GAME.round_resets.reroll_cost = 0
                end
                if G.GAME.current_round then
                    G.GAME.current_round.reroll_cost = 0
                end
                print("ZokersModMenu: Free rerolls enabled")
                return true
            end
        }))
    end
    
    -- Apply hand levels after game starts (fixed to use actual levels instead of adding)
    if mod.config.use_custom_stats and mod.config.hand_levels > 1 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                if G.GAME and G.GAME.hands then
                    for hand_name, hand_data in pairs(G.GAME.hands) do
                        local target_level = mod.config.hand_levels
                        local current_level = hand_data.level
                        
                        -- Handle BigNum compatibility (Talisman mod)
                        if type(current_level) == "table" and current_level.array then
                            current_level = tonumber(tostring(current_level)) or 1
                        end
                        
                        local levels_to_add = target_level - current_level
                        
                        -- Handle BigNum result
                        if type(levels_to_add) == "table" and levels_to_add.array then
                            levels_to_add = tonumber(tostring(levels_to_add)) or 0
                        end
                        
                        if levels_to_add > 0 then
                            hand_data.level = target_level
                            hand_data.mult = hand_data.mult + (hand_data.l_mult * levels_to_add)
                            hand_data.chips = hand_data.chips + (hand_data.l_chips * levels_to_add)
                        end
                    end
                    print("ZokersModMenu: Set all hands to level " .. mod.config.hand_levels)
                end
                return true
            end
        }))
    end
    
    -- Apply starting tags if enabled
    if mod.config.use_starting_items and #mod.config.starting_tags > 0 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                for _, tag_key in ipairs(mod.config.starting_tags) do
                    if G.P_TAGS[tag_key] then
                        add_tag(Tag(tag_key))
                        print("ZokersModMenu: Added tag " .. tag_key)
                    else
                        print("ZokersModMenu: Warning - Tag not found: " .. tag_key)
                    end
                end
                print("ZokersModMenu: Added " .. #mod.config.starting_tags .. " starting tags")
                return true
            end
        }))
    end
    
    -- Apply starting jokers if enabled
    if mod.config.use_starting_items and #mod.config.starting_jokers > 0 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                if G.jokers then
                    for _, joker_key in ipairs(mod.config.starting_jokers) do
                        if G.P_CENTERS[joker_key] then
                            local card = Card(G.jokers.T.x, G.jokers.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[joker_key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            if card then
                                card:add_to_deck()
                                G.jokers:emplace(card)
                                print("ZokersModMenu: Added joker " .. joker_key)
                            end
                        else
                            print("ZokersModMenu: Warning - Joker not found: " .. joker_key)
                        end
                    end
                    print("ZokersModMenu: Added " .. #mod.config.starting_jokers .. " starting jokers")
                end
                return true
            end
        }))
    end
    
    -- Apply starting vouchers if enabled - FIXED to apply immediately
    if mod.config.use_starting_items and #mod.config.starting_vouchers > 0 then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if G.GAME and G.GAME.used_vouchers then
                    for _, voucher_key in ipairs(mod.config.starting_vouchers) do
                        if G.P_CENTERS[voucher_key] then
                            G.GAME.used_vouchers[voucher_key] = true
                            local voucher_obj = G.P_CENTERS[voucher_key]
                            
                            -- Handle paired vouchers
                            if voucher_obj.requires then
                                for _, req in ipairs(voucher_obj.requires) do
                                    G.GAME.used_vouchers[req] = true
                                end
                            end
                            
                            -- Apply immediate effects for shop-related vouchers
                            if voucher_key == "v_overstock_norm" then
                                G.GAME.shop = G.GAME.shop or {}
                                G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
                            elseif voucher_key == "v_overstock_plus" then
                                G.GAME.shop = G.GAME.shop or {}
                                G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
                            end
                            
                            -- Apply voucher effect
                            if voucher_obj.redeem then
                                local success, err = pcall(function()
                                    voucher_obj:redeem()
                                end)
                                if not success then
                                    print("Voucher redeem error: " .. tostring(err))
                                end
                            end
                        end
                    end
                    print("ZokersModMenu: Applied " .. #mod.config.starting_vouchers .. " starting vouchers")
                end
                return true
            end
        }))
    end
end

-- Hook to modify deck creation  
-- Intercept the deck initialization
local ref_Game_init_game_object = Game.init_game_object
function Game:init_game_object()
    local ret = ref_Game_init_game_object(self)
    
    -- If custom deck is enabled and mod not disabled, set flags for replacement
    if not mod.config.mod_disabled and mod.config.use_custom_deck and #mod.config.custom_deck > 0 then
        mod._deck_needs_replacement = true
        mod._deck_replaced = false
        print("ZokersModMenu: Custom deck enabled, preparing for replacement")
    end
    
    return ret
end

-- Fix for overstock vouchers - ensure shop slots are properly set
local ref_create_shop = create_shop
create_shop = function(dt)
    -- Apply overstock vouchers before shop creation
    if G.GAME and G.GAME.used_vouchers then
        local overstock_count = 0
        if G.GAME.used_vouchers["v_overstock_norm"] then overstock_count = overstock_count + 1 end
        if G.GAME.used_vouchers["v_overstock_plus"] then overstock_count = overstock_count + 1 end
        
        if overstock_count > 0 then
            G.GAME.shop = G.GAME.shop or {}
            G.GAME.shop.joker_max = 2 + overstock_count
        end
    end
    
    return ref_create_shop(dt)
end

-- Additional hook for deck initialization to ensure custom deck loads
local ref_init_game = init_game or function() end
if init_game then
    init_game = function(args)
        local ret = ref_init_game(args)
        
        -- Check if mod is disabled
        if mod.config.mod_disabled then
            return ret
        end
        
        -- Check if this is a loaded save
        local is_loaded_save = false
        if args and args.savetext then
            is_loaded_save = true
        elseif G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante and G.GAME.round_resets.ante > 1 then
            is_loaded_save = true
        end
        
        -- Don't apply custom deck to loaded saves
        if is_loaded_save then
            print("ZokersModMenu: Loaded save detected in init_game, not applying custom deck")
            return ret
        end
        
        -- Apply custom deck if enabled and not already replaced
        if mod.config.use_custom_deck and #mod.config.custom_deck > 0 and not mod._deck_replaced and G.playing_cards and G.deck then
            print("ZokersModMenu: Applying custom deck via init_game with " .. #mod.config.custom_deck .. " cards")
            
            -- Clear existing deck - including ALL instances
            local old_deck = {}
            for i = 1, #G.playing_cards do
                old_deck[i] = G.playing_cards[i]
            end
            
            G.playing_cards = {}
            if G.deck.cards then
                G.deck.cards = {}
            end
            
            -- Remove old cards
            for _, card in ipairs(old_deck) do
                if card then
                    card:remove()
                end
            end
            
            -- Create custom deck
            local cards_created = 0
            for _, card_data in ipairs(mod.config.custom_deck) do
                local rank = card_data.rank
                local suit = card_data.suit
                local enhancement = card_data.enhancement or 'base'
                local seal = card_data.seal or 'none'
                local edition = card_data.edition or 'base'
                
                -- Use correct card ID format: H_2, S_A, etc.
                local card_id = suit .. '_' .. rank
                
                if G.P_CARDS[card_id] then
                    -- Create card with base center
                    local card = Card(
                        G.deck.T.x, G.deck.T.y,
                        G.CARD_W, G.CARD_H,
                        G.P_CARDS[card_id],
                        G.P_CENTERS.c_base,
                        {playing_card = card_id}
                    )
                    
                    if card then
                        -- Apply enhancement after creation if not base
                        if enhancement ~= 'base' and G.P_CENTERS[enhancement] then
                            card:set_ability(G.P_CENTERS[enhancement])
                        end
                        
                        -- Apply seal
                        if seal ~= 'none' then
                            card.seal = seal
                        end
                        
                        -- Apply edition
                        if edition ~= 'base' then
                            card:set_edition({[edition] = true})
                        end
                        
                        -- Lucky cards will be handled by the game's native logic with our hook
                        
                        -- Add to deck
                        card:add_to_deck()
                        table.insert(G.playing_cards, card)
                        G.deck:emplace(card)
                        cards_created = cards_created + 1
                    end
                else
                    print("ZokersModMenu: Warning - Card not found: " .. card_id .. " in init_game")
                end
            end
            
            -- Update deck count
            if G.deck.config then
                G.deck.config.card_count = #G.playing_cards
            end
            
            -- Shuffle deck
            G.deck:shuffle('nr')
            
            mod._deck_replaced = true
            print("ZokersModMenu: Custom deck applied via init_game (" .. cards_created .. " cards created)")
        end
        
        return ret
    end
end

-- Hook the new round function to ensure deck is replaced
local ref_new_round = G.FUNCS.new_round or function() end
G.FUNCS.new_round = function()
    -- Replace deck if needed and not already done
    if not mod.config.mod_disabled and mod._deck_needs_replacement and not mod._deck_replaced and G.playing_cards and G.deck then
        print("ZokersModMenu: Replacing deck in new_round with " .. #mod.config.custom_deck .. " cards")
        
        -- Clear existing deck completely
        local old_deck = {}
        for i = 1, #G.playing_cards do
            old_deck[i] = G.playing_cards[i]
        end
        
        G.playing_cards = {}
        if G.deck.cards then
            G.deck.cards = {}
        end
        
        -- Remove old cards
        for _, card in ipairs(old_deck) do
            if card then
                card:remove()
            end
        end
        
        -- Create custom deck
        local cards_created = 0
        for _, card_data in ipairs(mod.config.custom_deck) do
            local rank = card_data.rank
            local suit = card_data.suit
            local enhancement = card_data.enhancement or 'base'
            local seal = card_data.seal or 'none'
            local edition = card_data.edition or 'base'
            
            -- Use correct card ID format: H_2, S_A, etc.
            local card_id = suit .. '_' .. rank
            
            if G.P_CARDS[card_id] then
                -- Create card with base center
                local card = Card(
                    G.deck.T.x, G.deck.T.y,
                    G.CARD_W, G.CARD_H,
                    G.P_CARDS[card_id],
                    G.P_CENTERS.c_base,
                    {playing_card = card_id}
                )
                
                if card then
                    -- Apply enhancement after creation if not base
                    if enhancement ~= 'base' and G.P_CENTERS[enhancement] then
                        card:set_ability(G.P_CENTERS[enhancement])
                    end
                    
                    -- Apply seal
                    if seal ~= 'none' then
                        card.seal = seal
                    end
                    
                    -- Apply edition
                    if edition ~= 'base' then
                        card:set_edition({[edition] = true})
                    end
                    
                    -- Fix for lucky cards
                    if enhancement == 'm_lucky' then
                        card.lucky_trigger = function(self)
                            return pseudorandom('lucky') < G.GAME.probabilities.normal/5
                        end
                    end
                    
                    -- Add to deck
                    card:add_to_deck()
                    table.insert(G.playing_cards, card)
                    G.deck:emplace(card)
                    cards_created = cards_created + 1
                end
            else
                print("ZokersModMenu: Warning - Card not found: " .. card_id .. " in new_round")
            end
        end
        
        -- Update deck count
        if G.deck.config then
            G.deck.config.card_count = #G.playing_cards
        end
        
        -- Shuffle deck
        G.deck:shuffle('nr' .. (G.GAME.round_resets.ante or 1))
        
        -- Update deck display
        if G.deck_preview then
            G.deck_preview:remove()
        end
        
        mod._deck_replaced = true
        mod._deck_needs_replacement = false
        print("ZokersModMenu: Replaced deck with custom deck in new_round (" .. cards_created .. " cards created)")
    end
    
    -- Call original function
    return ref_new_round()
end

-- Hook to ensure free rerolls stay free
local ref_calculate_reroll_cost = calculate_reroll_cost or G.FUNCS.calculate_reroll_cost
if ref_calculate_reroll_cost then
    calculate_reroll_cost = function(skip_increment)
        if mod.config.free_rerolls and not mod.config.mod_disabled then
            return 0
        end
        return ref_calculate_reroll_cost(skip_increment)
    end
elseif G.FUNCS.calculate_reroll_cost then
    local orig_calc = G.FUNCS.calculate_reroll_cost
    G.FUNCS.calculate_reroll_cost = function(skip_increment)
        if mod.config.free_rerolls and not mod.config.mod_disabled then
            return 0
        end
        return orig_calc(skip_increment)
    end
end

-- Hook to apply ante scaling to blind chips
local ref_get_blind_amount = get_blind_amount
get_blind_amount = function(ante)
    local base_amount = ref_get_blind_amount(ante)
    
    -- Apply custom ante scaling if enabled and mod not disabled
    if not mod.config.mod_disabled and mod.config.use_custom_stats and mod.config.ante_scaling and mod.config.ante_scaling ~= 1 then
        base_amount = base_amount * mod.config.ante_scaling
        -- Remove the print statement to avoid spam
    end
    
    return math.floor(base_amount)
end

-- Also hook the blind selection to ensure scaling is applied
local ref_set_blind = Blind.set_blind
function Blind:set_blind(blinds_choice, silent, reset)
    ref_set_blind(self, blinds_choice, silent, reset)
    
    -- Apply ante scaling after blind is set if not already applied
    if not mod.config.mod_disabled and mod.config.use_custom_stats and mod.config.ante_scaling and mod.config.ante_scaling ~= 1 and self.chips then
        -- The scaling should already be applied by get_blind_amount, but let's ensure it's correct
    end
end

-- Hook reroll button to ensure cost is 0
local ref_reroll_shop = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    if mod.config.free_rerolls and not mod.config.mod_disabled then
        -- Temporarily set reroll cost to 0
        local old_cost = G.GAME.current_round.reroll_cost
        G.GAME.current_round.reroll_cost = 0
        
        -- Call original function
        local ret = ref_reroll_shop(e)
        
        -- Keep it at 0
        G.GAME.current_round.reroll_cost = 0
        
        return ret
    end
    return ref_reroll_shop(e)
end

-- Hook game update to ensure free rerolls
local ref_Game_update = Game.update
function Game:update(dt)
    -- Call original update
    ref_Game_update(self, dt)
    
    -- Ensure free rerolls if enabled and mod not disabled
    if mod.config.free_rerolls and not mod.config.mod_disabled then
        if G.GAME and G.GAME.current_round then
            G.GAME.current_round.reroll_cost = 0
        end
        if G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.reroll_cost = 0
        end
    end
end

-- Hook the deck setup - improved to ensure custom deck loads
local ref_setup_deck = G.FUNCS.setup_deck or function() end
G.FUNCS.setup_deck = function()
    -- Call original first
    ref_setup_deck()
    
    -- If custom deck is enabled, not disabled, and we have cards
    if not mod.config.mod_disabled and mod.config.use_custom_deck and #mod.config.custom_deck > 0 and G.deck and G.playing_cards then
        print("ZokersModMenu: Setting up custom deck in setup_deck with " .. #mod.config.custom_deck .. " cards")
        
        -- Clear existing deck immediately and completely
        local old_deck = {}
        for i = 1, #G.playing_cards do
            old_deck[i] = G.playing_cards[i]
        end
        
        G.playing_cards = {}
        if G.deck.cards then
            G.deck.cards = {}
        end
        
        -- Remove old cards
        for _, card in ipairs(old_deck) do
            if card then
                card:remove()
            end
        end
        
        -- Create custom deck immediately
        local cards_created = 0
        for _, card_data in ipairs(mod.config.custom_deck) do
            local rank = card_data.rank
            local suit = card_data.suit
            local enhancement = card_data.enhancement or 'base'
            local seal = card_data.seal or 'none'
            local edition = card_data.edition or 'base'
            
            -- Use correct card ID format: H_2, S_A, etc.
            local card_id = suit .. '_' .. rank
            
            if G.P_CARDS[card_id] then
                -- Create card with base center
                local card = Card(
                    G.deck.T.x, G.deck.T.y,
                    G.CARD_W, G.CARD_H,
                    G.P_CARDS[card_id],
                    G.P_CENTERS.c_base,
                    {playing_card = card_id}
                )
                
                if card then
                    -- Apply enhancement after creation if not base
                    if enhancement ~= 'base' and G.P_CENTERS[enhancement] then
                        card:set_ability(G.P_CENTERS[enhancement])
                    end
                    
                    -- Apply seal
                    if seal ~= 'none' then
                        card.seal = seal
                    end
                    
                    -- Apply edition
                    if edition ~= 'base' then
                        card:set_edition({[edition] = true})
                    end
                    
                    -- Fix for lucky cards
                    if enhancement == 'm_lucky' then
                        card.lucky_trigger = function(self)
                            return pseudorandom('lucky') < G.GAME.probabilities.normal/5
                        end
                    end
                    
                    -- Add to deck
                    card:add_to_deck()
                    table.insert(G.playing_cards, card)
                    G.deck:emplace(card)
                    cards_created = cards_created + 1
                end
            else
                print("ZokersModMenu: Warning - Card not found: " .. card_id .. " in setup_deck")
            end
        end
        
        -- Update deck count
        if G.deck.config then
            G.deck.config.card_count = #G.playing_cards
        end
        
        -- Shuffle deck
        G.deck:shuffle('nr' .. (G.GAME.round_resets.ante or 1))
        
        -- Update deck display
        if G.deck_preview then
            G.deck_preview:remove()
        end
        
        mod._deck_replaced = true
        mod._deck_needs_replacement = false
        print("ZokersModMenu: Custom deck setup complete in setup_deck (" .. cards_created .. " cards created)")
    end
end

print("ZokersModMenu v1.5.1 loaded successfully!")
print("Press 'C' to toggle Zoker's Mod Menu")
print("ZokersModMenu: Initial deck size: " .. #mod.config.custom_deck)

-- Initialize legacy conversion
if mod and mod.config then
    convert_legacy_deck()
    print("ZokersModMenu: After legacy conversion, deck size: " .. #mod.config.custom_deck)
end

-- Main settings menu with uniform clean styling
local function create_settings_menu()
    local menu_nodes = {
        -- Title with black background
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "ZOKERS MOD MENU", scale = 1, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
        
        -- Main menu buttons - all in single column with grey-out when disabled
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = mod.config.use_custom_stats and "cs_open_money_menu" or nil, hover = mod.config.use_custom_stats, minw = 6.2, minh = 1, colour = mod.config.use_custom_stats and {0.2, 0.6, 0.8, 1} or {0.4, 0.4, 0.4, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Starting Stats", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = mod.config.use_starting_items and "cs_open_starting_items_menu" or nil, hover = mod.config.use_starting_items, minw = 6.2, minh = 1, colour = mod.config.use_starting_items and {0.8, 0.2, 0.8, 1} or {0.4, 0.4, 0.4, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Starting Items", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = mod.config.use_custom_deck and "cs_open_deck_builder" or nil, hover = mod.config.use_custom_deck, minw = 6.2, minh = 1, colour = mod.config.use_custom_deck and {0.6, 0.8, 0.2, 1} or {0.4, 0.4, 0.4, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Build Deck", scale = 0.5, colour = G.C.WHITE}}}}
        }}
    }
    
    -- Add Give button - gray out if disabled, show normally if enabled
    local give_button_colour = mod.config.allow_give_during_runs and {0.2, 0.8, 0.8, 1} or {0.4, 0.4, 0.4, 1}
    local give_button_config = {align = "cm", padding = 0.08, hover = mod.config.allow_give_during_runs, minw = 6.2, minh = 1, colour = give_button_colour, r = 0.1}
    if mod.config.allow_give_during_runs then
        give_button_config.button = "cs_open_give_item_menu"
    end
    
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = give_button_config, 
         nodes = {{n = G.UIT.T, config = {text = "Give", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    -- Spacing before toggles
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Check if we're in a run
    local in_run = G.GAME and G.STATE ~= G.STATES.MENU
    
    -- Enable/Disable options with YES/NO format - all aligned properly
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
        {n = G.UIT.T, config = {text = "Starting Stats: ", scale = 0.5, colour = {1, 1, 1, 1}}},
        in_run and {n = G.UIT.T, config = {text = mod.config.use_custom_stats and "YES" or "NO", scale = 0.5, colour = mod.config.use_custom_stats and {0.4, 1, 0.4, 1} or {1, 0.4, 0.4, 1}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_custom_stats", hover = true, minw = 0.8, minh = 0.5, colour = mod.config.use_custom_stats and {0.4, 0.8, 0.4, 1} or {0.8, 0.4, 0.4, 1}, r = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = mod.config.use_custom_stats and "YES" or "NO", scale = 0.4, colour = G.C.WHITE}}}}
    }})
    
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
        {n = G.UIT.T, config = {text = "Starting Items: ", scale = 0.5, colour = {1, 1, 1, 1}}},
        in_run and {n = G.UIT.T, config = {text = mod.config.use_starting_items and "YES" or "NO", scale = 0.5, colour = mod.config.use_starting_items and {0.4, 1, 0.4, 1} or {1, 0.4, 0.4, 1}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_starting_items", hover = true, minw = 0.8, minh = 0.5, colour = mod.config.use_starting_items and {0.4, 0.8, 0.4, 1} or {0.8, 0.4, 0.4, 1}, r = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = mod.config.use_starting_items and "YES" or "NO", scale = 0.4, colour = G.C.WHITE}}}}
    }})
    
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
        {n = G.UIT.T, config = {text = "Custom Deck: ", scale = 0.5, colour = {1, 1, 1, 1}}},
        in_run and {n = G.UIT.T, config = {text = mod.config.use_custom_deck and "YES" or "NO", scale = 0.5, colour = mod.config.use_custom_deck and {0.4, 1, 0.4, 1} or {1, 0.4, 0.4, 1}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_custom_deck", hover = true, minw = 0.8, minh = 0.5, colour = mod.config.use_custom_deck and {0.4, 0.8, 0.4, 1} or {0.8, 0.4, 0.4, 1}, r = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = mod.config.use_custom_deck and "YES" or "NO", scale = 0.4, colour = G.C.WHITE}}}}
    }})
    
    -- Give Items toggle - disable during runs
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
        {n = G.UIT.T, config = {text = "Give Items: ", scale = 0.5, colour = {1, 1, 1, 1}}},
        in_run and {n = G.UIT.T, config = {text = mod.config.allow_give_during_runs and "YES" or "NO", scale = 0.5, colour = mod.config.allow_give_during_runs and {0.4, 1, 0.4, 1} or {1, 0.4, 0.4, 1}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_give_during_runs", hover = true, minw = 0.8, minh = 0.5, colour = mod.config.allow_give_during_runs and {0.4, 0.8, 0.4, 1} or {0.8, 0.4, 0.4, 1}, r = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = mod.config.allow_give_during_runs and "YES" or "NO", scale = 0.4, colour = G.C.WHITE}}}}
    }})
    
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
        {n = G.UIT.T, config = {text = "Free Rerolls: ", scale = 0.5, colour = {1, 1, 1, 1}}},
        in_run and {n = G.UIT.T, config = {text = mod.config.free_rerolls and "YES" or "NO", scale = 0.5, colour = mod.config.free_rerolls and {0.4, 1, 0.4, 1} or {1, 0.4, 0.4, 1}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_toggle_free_rerolls_main", hover = true, minw = 0.8, minh = 0.5, colour = mod.config.free_rerolls and {0.4, 0.8, 0.4, 1} or {0.8, 0.4, 0.4, 1}, r = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = mod.config.free_rerolls and "YES" or "NO", scale = 0.4, colour = G.C.WHITE}}}}
    }})

    -- Bottom buttons - Unlock (yellow), Reset, Close
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_unlock_all", hover = true, minw = 2, minh = 1, colour = {0.8, 0.8, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Unlock", scale = 0.5, colour = G.C.WHITE}}}},
        in_run and {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 1, colour = {0.4, 0.2, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Reset", scale = 0.5, colour = {0.5, 0.5, 0.5, 1}}}}} or
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_reset_all", hover = true, minw = 2, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Reset", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_close_menu", hover = true, minw = 2, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Close", scale = 0.5, colour = G.C.WHITE}}}}
    }})

    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = menu_nodes
    }
end

-- Money and stats adjustment menu with modern styling and ante scaling
local function create_money_menu()
    -- Get current ante scaling display
    local ante_scaling_display = mod.config.ante_scaling .. "x"
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 12.5, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "STARTING STATS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
            
            -- Money Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Money:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_money_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "money_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 1, 0, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = "$" .. tostring(mod.config.starting_money), scale = 0.5, colour = {1, 1, 0, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_money_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "money_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Hands Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Hands:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hands_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "hands_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.4, 0.6, 1, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.starting_hands), scale = 0.5, colour = {0.4, 0.6, 1, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hands_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "hands_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Discards Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Discards:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_discards_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "discards_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.4, 0.4, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.starting_discards), scale = 0.5, colour = {1, 0.4, 0.4, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_discards_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "discards_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Hand Size Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Hand Size:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hand_size_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "hand_size_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.8, 0.4, 1, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.hand_size), scale = 0.5, colour = {0.8, 0.4, 1, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hand_size_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "hand_size_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Hand Level Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Hand Levels:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hand_levels_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "hand_levels_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.2, 0.8, 0.8, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.hand_levels), scale = 0.5, colour = {0.2, 0.8, 0.8, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_hand_levels_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "hand_levels_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Joker Slots Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Joker Slots:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_slots_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "slots_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.5, 0.8, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.joker_slots), scale = 0.5, colour = {1, 0.5, 0.8, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_slots_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "slots_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Consumable Slots Row
            {n = G.UIT.R, config = {align = "cm", padding = 0.12}, nodes = {
                {n = G.UIT.C, config = {align = "cr", minw = 2.5}, 
                 nodes = {{n = G.UIT.T, config = {text = "Consumables:", scale = 0.5, colour = {1, 1, 1, 1}}}}},
                {n = G.UIT.C, config = {align = "cl", minw = 4}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_consumables_down", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.RED, r = 0.1, ref_table = {button_id = "consumables_down"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "-", scale = 0.6, colour = G.C.WHITE}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.6, 0.2, 1}, outline = 1}, 
                     nodes = {{n = G.UIT.T, config = {text = tostring(mod.config.consumable_slots), scale = 0.5, colour = {1, 0.6, 0.2, 1}}}}},
                    {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_consumables_up", hover = true, hold = true, minw = 0.8, minh = 0.8, colour = G.C.GREEN, r = 0.1, ref_table = {button_id = "consumables_up"}}, 
                     nodes = {{n = G.UIT.T, config = {text = "+", scale = 0.6, colour = G.C.WHITE}}}}
                }}
            }},
            
            -- Ante Scaling Row - compressed
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.T, config = {text = "Ante Scaling:", scale = 0.45, colour = {1, 1, 1, 1}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.03, button = "cs_ante_scale_1x", hover = true, minw = 0.9, minh = 0.6, 
                    colour = mod.config.ante_scaling == 1 and {0.2, 0.8, 0.2, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                 nodes = {{n = G.UIT.T, config = {text = "1x", scale = 0.35, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.03, button = "cs_ante_scale_1.5x", hover = true, minw = 0.9, minh = 0.6, 
                    colour = mod.config.ante_scaling == 1.5 and {0.8, 0.8, 0.2, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                 nodes = {{n = G.UIT.T, config = {text = "1.5x", scale = 0.35, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.03, button = "cs_ante_scale_2x", hover = true, minw = 0.9, minh = 0.6, 
                    colour = mod.config.ante_scaling == 2 and {0.8, 0.6, 0.2, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                 nodes = {{n = G.UIT.T, config = {text = "2x", scale = 0.35, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.03, button = "cs_ante_scale_3x", hover = true, minw = 0.9, minh = 0.6, 
                    colour = mod.config.ante_scaling == 3 and {0.8, 0.4, 0.2, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                 nodes = {{n = G.UIT.T, config = {text = "3x", scale = 0.35, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.03, button = "cs_ante_scale_5x", hover = true, minw = 0.9, minh = 0.6, 
                    colour = mod.config.ante_scaling == 5 and {0.8, 0.2, 0.2, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                 nodes = {{n = G.UIT.T, config = {text = "5x", scale = 0.35, colour = G.C.WHITE}}}}
            }},
            
            -- Bottom buttons
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_reset_money_stats", hover = true, minw = 3, minh = 1, colour = G.C.RED, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Reset", scale = 0.5, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_main", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
end

-- Ante scaling button functions
G.FUNCS.cs_ante_scale_1x = function(e)
    mod.config.ante_scaling = 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS["cs_ante_scale_1.5x"] = function(e)
    mod.config.ante_scaling = 1.5
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_ante_scale_2x = function(e)
    mod.config.ante_scaling = 2
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_ante_scale_3x = function(e)
    mod.config.ante_scaling = 3
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_ante_scale_5x = function(e)
    mod.config.ante_scaling = 5
    save_config()
    create_overlay(create_money_menu())
end

-- Deck builder with clean uniform styling
local function create_deck_builder()
    local suits = {'S', 'H', 'D', 'C'}
    local suit_names = {'Spades', 'Hearts', 'Diamonds', 'Clubs'}
    local ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}
    
    -- Get current enhancement/seal/edition display names
    local current_enhancement_name = "Base"
    for _, enh in ipairs(enhancement_options) do
        if enh.key == mod.config.current_enhancement then
            current_enhancement_name = enh.name
            break
        end
    end
    
    local current_seal_name = "No Seal"
    for _, seal in ipairs(seal_options) do
        if seal.key == mod.config.current_seal then
            current_seal_name = seal.name
            break
        end
    end
    
    local current_edition_name = "Base"
    for _, edition in ipairs(edition_options) do
        if edition.key == mod.config.current_edition then
            current_edition_name = edition.name
            break
        end
    end
    
    local deck_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "DECK BUILDER", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Deck info
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Deck: " .. mod.config.current_deck_name, scale = 0.5, colour = {1, 1, 1, 1}}}}},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = "Size: " .. tostring(#mod.config.custom_deck) .. "/104 cards", scale = 0.5, colour = {1, 1, 1, 1}}}}},
        
        -- Enhancement/Seal/Edition controls - uniform buttons
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_enhancement", hover = true, minw = 3.2, minh = 1, colour = {0.2, 0.6, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Enhancement: " .. current_enhancement_name, scale = 0.4, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_seal", hover = true, minw = 3.2, minh = 1, colour = {0.8, 0.2, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Seal: " .. current_seal_name, scale = 0.4, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_edition", hover = true, minw = 6.5, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Edition: " .. current_edition_name, scale = 0.4, colour = G.C.WHITE}}}}
        }},
        
        -- Quick actions
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_standard_deck", hover = true, minw = 3, minh = 0.9, colour = G.C.GREEN, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Standard 52", scale = 0.4, colour = G.C.WHITE}}}}
        }}
    }
    
    -- Card grid - clean and uniform
    for i, suit in ipairs(suits) do
        local suit_row = {
            n = G.UIT.R,
            config = {align = "cm", padding = 0.03},
            nodes = {
                {n = G.UIT.C, config = {align = "cm", minw = 1.2}, 
                 nodes = {{n = G.UIT.T, config = {text = suit_names[i] .. ":", scale = 0.4, colour = G.C.WHITE}}}}
            }
        }
        
        for j, rank in ipairs(ranks) do
            local count = 0
            
            -- Count cards of this rank/suit with matching properties
            for _, card_data in ipairs(mod.config.custom_deck) do
                if card_data.rank == rank and card_data.suit == suit and
                   card_data.enhancement == mod.config.current_enhancement and
                   card_data.seal == mod.config.current_seal and
                   card_data.edition == mod.config.current_edition then
                    count = count + 1
                end
            end
            
            local button_text = rank
            if count > 0 then
                button_text = rank .. "(" .. count .. ")"
            end
            
            -- Color code based on count
            local button_colour = {0.3, 0.3, 0.3, 1}
            if count > 0 then
                button_colour = G.C.GREEN
            end
            if count >= 4 then
                button_colour = {0.8, 0.6, 0.2, 1}
            end
            if count >= 6 then
                button_colour = {1, 0.5, 0.2, 1}
            end
            if count >= 8 then
                button_colour = G.C.RED
            end
            
            table.insert(suit_row.nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.02,
                    button = "cs_add_card",
                    ref_table = {rank = rank, suit = suit},
                    hover = true,
                    minw = 0.7,
                    minh = 0.5,
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = button_text, scale = 0.3, colour = G.C.WHITE}}
                }
            })
        end
        
        table.insert(deck_nodes, suit_row)
    end
    
    -- Bottom action buttons
    table.insert(deck_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.3}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_deck", hover = true, minw = 2, minh = 0.9, colour = G.C.RED, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.4, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_save_deck", hover = true, minw = 2, minh = 0.9, colour = {0.8, 0.6, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Save Deck", scale = 0.4, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_back_to_main", hover = true, minw = 2, minh = 0.9, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.4, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 12, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = deck_nodes
    }
end

-- Starting Items menu that combines jokers, vouchers, and tags
local function create_starting_items_menu()
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "STARTING ITEMS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
            
            -- Stats display
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.T, config = {text = "Selected Jokers: ", scale = 0.5, colour = {1, 1, 1, 1}}},
                {n = G.UIT.T, config = {text = tostring(#mod.config.starting_jokers), scale = 0.5, colour = {1, 0.5, 0.8, 1}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                {n = G.UIT.T, config = {text = "Selected Vouchers: ", scale = 0.5, colour = {1, 1, 1, 1}}},
                {n = G.UIT.T, config = {text = tostring(#mod.config.starting_vouchers), scale = 0.5, colour = {0.4, 1, 0.4, 1}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                {n = G.UIT.T, config = {text = "Selected Tags: ", scale = 0.5, colour = {1, 1, 1, 1}}},
                {n = G.UIT.T, config = {text = tostring(#mod.config.starting_tags), scale = 0.5, colour = {1, 0.8, 0.2, 1}}}
            }},
            
            -- Spacing
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
            
            -- Menu buttons - joker button is purple, tags button is chrome/metallic
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_open_joker_menu", hover = true, minw = 6.2, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Select Jokers", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_open_voucher_menu", hover = true, minw = 6.2, minh = 1, colour = {0.8, 0.2, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Select Vouchers", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_open_tag_menu", hover = true, minw = 6.2, minh = 1, colour = {0.7, 0.7, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Select Tags", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Clear buttons
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_all_starting_items", hover = true, minw = 3, minh = 0.9, colour = G.C.RED, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.4, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_back_to_main", hover = true, minw = 3, minh = 0.9, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.4, colour = G.C.WHITE}}}}
            }}
        }
    }
end

-- Helper function to format names for display
local function format_name(name, prefix)
    -- Special case for Caino
    if name == "j_caino" then
        return "Canio"
    elseif name == "j_ticket" then
        return "Golden Ticket"
    elseif name == "j_gluttenous_joker" then
        return "Gluttonous Joker"
    end
    -- Remove prefix and underscores, then capitalize each word
    local clean_name = name:gsub(prefix, ""):gsub("_", " ")
    -- Capitalize first letter of each word
    return clean_name:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

-- Variable to track which joker tab is active
mod.config.active_joker_tab = mod.config.active_joker_tab or "vanilla"

-- Vanilla joker selection menu with tabs
local function create_joker_menu()
    mod.config.joker_page = mod.config.joker_page or 1
    mod.config.mikas_joker_page = mod.config.mikas_joker_page or 1
    
    local current_joker_list = mod.config.active_joker_tab == "mikas" and mikas_jokers or available_jokers
    local is_mikas = mod.config.active_joker_tab == "mikas"
    local current_page = is_mikas and (mod.config.mikas_joker_page or 1) or (mod.config.joker_page or 1)
    local jokers_per_page = 24
    local start_index = (current_page - 1) * jokers_per_page + 1
    local end_index = math.min(start_index + jokers_per_page - 1, #current_joker_list)
    local total_pages = math.ceil(#current_joker_list / jokers_per_page)
    
    local joker_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING JOKERS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Tab buttons - with purple color for active tab
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
                colour = mod.config.active_joker_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
        }},
        
        -- Info
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Selected: " .. tostring(#mod.config.starting_jokers) .. " | Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
    }
    
    -- Add Mika's tab if enabled
    if is_mikas_mod_enabled() then
        joker_nodes[2].nodes[2] = {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_switch_to_mikas", hover = true, minw = 2.5, minh = 0.8, 
            colour = mod.config.active_joker_tab == "mikas" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Mika's", scale = 0.5, colour = G.C.WHITE}}}}
    end
    
    local joker_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 6 == 0 then
            table.insert(joker_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local joker_key = current_joker_list[i]
        if joker_key then
            local count = 0
            
            -- Count how many of this joker we have
            for _, selected in ipairs(mod.config.starting_jokers) do
                if selected == joker_key then
                    count = count + 1
                end
            end
            
            local joker_name = format_name(joker_key, is_mikas and "j_mmc_" or "j_")
            local display_text = joker_name
            if count > 0 then
                display_text = joker_name .. " (" .. count .. ")"
            end
            
            -- Always use blue color for selection buttons, purple if selected
            local button_colour = {0.4, 0.4, 0.8, 1}
            if count > 0 then
                button_colour = {0.6, 0.2, 0.8, 1}  -- Purple when selected
            end
            
            table.insert(joker_grid.nodes[#joker_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = "cs_toggle_joker",
                    ref_table = {joker_key = joker_key},
                    hover = true,
                    minw = 1.6,
                    minh = 0.7,
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_text, scale = 0.23, colour = G.C.WHITE}}
                }
            })
        end
    end
    
    table.insert(joker_nodes, joker_grid)
    
    -- Spacer to push buttons to bottom
    table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Bottom buttons - navigation and back
    if total_pages > 1 then
        table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = is_mikas and "cs_mikas_joker_prev_page" or "cs_joker_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_jokers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = is_mikas and "cs_mikas_joker_next_page" or "cs_joker_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
        }})
        
        table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    else
        table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.3}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_clear_jokers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = joker_nodes
    }
end

-- Tab switching functions
G.FUNCS.cs_switch_to_vanilla = function(e)
    mod.config.active_joker_tab = "vanilla"
    save_config()
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_switch_to_mikas = function(e)
    mod.config.active_joker_tab = "mikas"
    save_config()
    create_overlay(create_joker_menu())
end

-- Voucher selection menu with clean styling
local function create_voucher_menu()
    mod.config.voucher_page = mod.config.voucher_page or 1
    
    local current_page = mod.config.voucher_page or 1
    local vouchers_per_page = 20
    local start_index = (current_page - 1) * vouchers_per_page + 1
    local end_index = math.min(start_index + vouchers_per_page - 1, #available_vouchers)
    local total_pages = math.ceil(#available_vouchers / vouchers_per_page)
    
    local voucher_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING VOUCHERS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Info
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Selected: " .. tostring(#mod.config.starting_vouchers) .. " | Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
    }
    
    local voucher_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(voucher_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local voucher_key = available_vouchers[i]
        if voucher_key then
            local is_selected = false
            
            -- Check if this voucher is selected
            for _, selected in ipairs(mod.config.starting_vouchers) do
                if selected == voucher_key then
                    is_selected = true
                    break
                end
            end
            
            local voucher_name = format_name(voucher_key, "v_")
            local display_text = voucher_name
            
            -- Always use blue color for selection buttons, purple if selected
            local button_colour = {0.4, 0.4, 0.8, 1}
            if is_selected then
                button_colour = {0.6, 0.2, 0.8, 1}  -- Purple when selected
            end
            
            table.insert(voucher_grid.nodes[#voucher_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = "cs_toggle_voucher",
                    ref_table = {voucher_key = voucher_key},
                    hover = true,
                    minw = 1.9,
                    minh = 0.7,
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_text, scale = 0.26, colour = G.C.WHITE}}
                }
            })
        end
    end
    
    table.insert(voucher_nodes, voucher_grid)
    
    -- Spacer to push buttons to bottom
    table.insert(voucher_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Bottom buttons - navigation and back
    if total_pages > 1 then
        table.insert(voucher_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_voucher_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_vouchers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_voucher_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
        }})
        
        table.insert(voucher_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    else
        table.insert(voucher_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.3}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_clear_vouchers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = voucher_nodes
    }
end

-- Tag selection menu
local function create_tag_menu()
    mod.config.tag_page = mod.config.tag_page or 1
    
    local current_page = mod.config.tag_page or 1
    local tags_per_page = 20
    local start_index = (current_page - 1) * tags_per_page + 1
    local end_index = math.min(start_index + tags_per_page - 1, #available_tags)
    local total_pages = math.ceil(#available_tags / tags_per_page)
    
    local tag_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING TAGS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Info
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Selected: " .. tostring(#mod.config.starting_tags) .. " | Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
    }
    
    local tag_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(tag_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local tag_key = available_tags[i]
        if tag_key then
            local is_selected = false
            
            -- Check if this tag is selected
            for _, selected in ipairs(mod.config.starting_tags) do
                if selected == tag_key then
                    is_selected = true
                    break
                end
            end
            
            local tag_name = format_name(tag_key, "tag_")
            local display_text = tag_name
            
            -- Always use blue color for selection buttons, purple if selected
            local button_colour = {0.4, 0.4, 0.8, 1}
            if is_selected then
                button_colour = {0.6, 0.2, 0.8, 1}  -- Purple when selected
            end
            
            table.insert(tag_grid.nodes[#tag_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = "cs_toggle_tag",
                    ref_table = {tag_key = tag_key},
                    hover = true,
                    minw = 1.9,
                    minh = 0.7,
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_text, scale = 0.26, colour = G.C.WHITE}}
                }
            })
        end
    end
    
    table.insert(tag_nodes, tag_grid)
    
    -- Spacer to push buttons to bottom
    table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Bottom buttons - navigation and back
    if total_pages > 1 then
        table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_tag_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_tags", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_tag_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
        }})
        
        table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    else
        table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.3}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_clear_tags", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = tag_nodes
    }
end

-- Give Item menu
local function create_give_item_menu()
    local give_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "GIVE ITEM", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Instructions
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Select item type to give", scale = 0.5, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
        
        -- Item type buttons (reordered - joker moved below card)
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money", hover = true, minw = 3, minh = 1, colour = {1, 1, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Money", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_card", hover = true, minw = 3, minh = 1, colour = {0.2, 0.6, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Card", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_joker", hover = true, minw = 3, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Joker", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_consumable", hover = true, minw = 3, minh = 1, colour = {0.8, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Consumable", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_voucher", hover = true, minw = 3, minh = 1, colour = {0.8, 0.2, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Voucher", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_tag", hover = true, minw = 3, minh = 1, colour = {0.7, 0.7, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Tag", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
        
        -- Back button
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_main", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
        }}
    }
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = give_nodes
    }
end

-- Money giving menu with gradient colors
local function create_give_money_menu()
    -- Define gradient colors from green to blue
    local gradient_colors = {
        {0.2, 0.8, 0.2, 1},    -- Green
        {0.2, 0.75, 0.35, 1},  -- Green-Teal
        {0.2, 0.7, 0.5, 1},    -- Teal
        {0.2, 0.6, 0.65, 1},   -- Teal-Blue
        {0.2, 0.5, 0.8, 1}     -- Blue
    }
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "GIVE MONEY", scale = 0.8, colour = {1, 1, 1, 1}}}}},
            
            -- Current money display
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Current: $" .. (G.GAME and G.GAME.dollars or 0), scale = 0.5, colour = {1, 1, 0, 1}}}}},
            
            -- Spacing
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
            
            -- Money amount buttons with gradient
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money_10", hover = true, minw = 3, minh = 1, colour = gradient_colors[1], r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Give $10", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money_50", hover = true, minw = 3, minh = 1, colour = gradient_colors[2], r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Give $50", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money_100", hover = true, minw = 3, minh = 1, colour = gradient_colors[3], r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Give $100", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money_1000", hover = true, minw = 3, minh = 1, colour = gradient_colors[4], r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Give $1000", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_money_infinite", hover = true, minw = 3, minh = 1, colour = gradient_colors[5], r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Infinite Money", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Spacing
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
            
            -- Bottom buttons
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_reset_money_to_zero", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Reset", scale = 0.5, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_give", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
end

-- Consumable type selection
local function create_consumable_type_menu()
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "SELECT CONSUMABLE TYPE", scale = 0.8, colour = {1, 1, 1, 1}}}}},
            
            -- Spacing
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
            
            -- Consumable types
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_tarot", hover = true, minw = 3, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Tarot", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_planet", hover = true, minw = 3, minh = 1, colour = {0.2, 0.6, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Planet", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_spectral", hover = true, minw = 3, minh = 1, colour = {0.4, 0.8, 0.4, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Spectral", scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Spacing
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
            
            -- Back button
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_give", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
end

-- Store current card configuration
mod.config.give_card_rank = mod.config.give_card_rank or 'A'
mod.config.give_card_suit = mod.config.give_card_suit or 'S'
mod.config.give_card_enhancement = mod.config.give_card_enhancement or 'base'
mod.config.give_card_seal = mod.config.give_card_seal or 'none'
mod.config.give_card_edition = mod.config.give_card_edition or 'base'

-- Give Card menu for selecting card properties
local function create_give_card_menu()
    local suits = {'S', 'H', 'D', 'C'}
    local suit_names = {'Spades', 'Hearts', 'Diamonds', 'Clubs'}
    local ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}
    
    -- Get current enhancement/seal/edition display names
    local current_enhancement_name = "Base"
    for _, enh in ipairs(enhancement_options) do
        if enh.key == mod.config.give_card_enhancement then
            current_enhancement_name = enh.name
            break
        end
    end
    
    local current_seal_name = "No Seal"
    for _, seal in ipairs(seal_options) do
        if seal.key == mod.config.give_card_seal then
            current_seal_name = seal.name
            break
        end
    end
    
    local current_edition_name = "Base"
    for _, edition in ipairs(edition_options) do
        if edition.key == mod.config.give_card_edition then
            current_edition_name = edition.name
            break
        end
    end
    
    -- Get current suit name
    local current_suit_name = "Spades"
    for i, s in ipairs(suits) do
        if s == mod.config.give_card_suit then
            current_suit_name = suit_names[i]
            break
        end
    end
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 10, minh = 12, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "GIVE CARD", scale = 0.8, colour = {1, 1, 1, 1}}}}},
            
            -- Current selection display
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Current: " .. mod.config.give_card_rank .. " of " .. current_suit_name, scale = 0.5, colour = {1, 1, 1, 1}}}}},
            
            -- Rank selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_rank", hover = true, minw = 4, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Rank: " .. mod.config.give_card_rank, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Suit selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_suit", hover = true, minw = 4, minh = 1, colour = {0.8, 0.2, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Suit: " .. current_suit_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Enhancement selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_enhancement", hover = true, minw = 4, minh = 1, colour = {0.2, 0.6, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Enhancement: " .. current_enhancement_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Seal selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_seal", hover = true, minw = 4, minh = 1, colour = {0.8, 0.6, 0.2, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Seal: " .. current_seal_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Edition selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_edition", hover = true, minw = 4, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Edition: " .. current_edition_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Give button
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_give_configured_card", hover = true, minw = 4, minh = 1.2, colour = G.C.GREEN, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Give Card", scale = 0.6, colour = G.C.WHITE}}}}
            }},
            
            -- Back button
            {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_give", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
end

-- Generic card selection menu for giving items
local function create_card_selection_menu(card_list, title, give_function_name)
    mod.config.give_page = mod.config.give_page or 1
    
    local current_page = mod.config.give_page or 1
    local cards_per_page = 20
    local start_index = (current_page - 1) * cards_per_page + 1
    local end_index = math.min(start_index + cards_per_page - 1, #card_list)
    local total_pages = math.ceil(#card_list / cards_per_page)
    
    -- Check if we're showing jokers and if Mika's is enabled
    local is_joker_menu = (give_function_name == "cs_instant_give_joker")
    local show_tabs = is_joker_menu and is_mikas_mod_enabled()
    
    local card_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = title, scale = 0.8, colour = {1, 1, 1, 1}}}}},
    }
    
    -- Add tabs if this is joker menu and Mika's is enabled
    if show_tabs then
        table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
                colour = mod.config.give_joker_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_switch_to_mikas", hover = true, minw = 2.5, minh = 0.8, 
                colour = mod.config.give_joker_tab == "mikas" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Mika's", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    -- Info
    table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
    )
    
    -- Card grid
    local card_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(card_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local card_key = card_list[i]
        if card_key then
            -- Format name based on type
            local card_name
            if give_function_name == "cs_instant_give_card" then
                card_name = format_name(card_key, "c_")
            elseif give_function_name == "cs_instant_give_voucher" then
                card_name = format_name(card_key, "v_")
            elseif give_function_name == "cs_instant_give_joker" then
                -- Check if it's a Mika's joker
                local is_mikas = card_key:find("j_mmc_") ~= nil
                card_name = format_name(card_key, is_mikas and "j_mmc_" or "j_")
            elseif give_function_name == "cs_instant_give_tag" then
                card_name = format_name(card_key, "tag_")
            else
                card_name = card_key
            end
            
            -- Always use blue color for give menus
            local button_colour = {0.4, 0.4, 0.8, 1}
            
            table.insert(card_grid.nodes[#card_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = give_function_name,
                    ref_table = {card_key = card_key},
                    hover = true,
                    minw = 1.9,
                    minh = 0.7,
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = card_name, scale = 0.26, colour = G.C.WHITE}}
                }
            })
        end
    end
    
    table.insert(card_nodes, card_grid)
    
    -- Spacer to push buttons to bottom
    table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Bottom navigation buttons - always at bottom
    if total_pages > 1 then
        table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_give_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_give_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_consumable_type", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = card_nodes
    }
end

-- Clear all starting items function
G.FUNCS.cs_clear_all_starting_items = function(e)
    mod.config.starting_jokers = {}
    mod.config.starting_vouchers = {}
    mod.config.starting_tags = {}
    save_config()
    create_overlay(create_starting_items_menu())
    print("Cleared all starting items")
end

-- Button Functions
G.FUNCS.cs_open_main_menu = function(e)
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_open_money_menu = function(e)
    create_overlay(create_money_menu())
end

G.FUNCS.cs_open_deck_builder = function(e)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_open_starting_items_menu = function(e)
    create_overlay(create_starting_items_menu())
end

G.FUNCS.cs_open_joker_menu = function(e)
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_open_voucher_menu = function(e)
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_open_tag_menu = function(e)
    create_overlay(create_tag_menu())
end

G.FUNCS.cs_open_give_item_menu = function(e)
    create_overlay(create_give_item_menu())
end

G.FUNCS.cs_back_to_main = function(e)
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_close_menu = function(e)
    close_zokers_menu()
end

-- Give money functions - updated to NOT close menu and with more 9's for infinite
G.FUNCS.cs_give_money = function(e)
    create_overlay(create_give_money_menu())
end

G.FUNCS.cs_give_money_10 = function(e)
    if G.GAME then
        G.GAME.dollars = (G.GAME.dollars or 0) + 10
        print("Given: $10 (Total: $" .. G.GAME.dollars .. ")")
        create_overlay(create_give_money_menu()) -- Refresh to show new total
    end
end

G.FUNCS.cs_give_money_50 = function(e)
    if G.GAME then
        G.GAME.dollars = (G.GAME.dollars or 0) + 50
        print("Given: $50 (Total: $" .. G.GAME.dollars .. ")")
        create_overlay(create_give_money_menu())
    end
end

G.FUNCS.cs_give_money_100 = function(e)
    if G.GAME then
        G.GAME.dollars = (G.GAME.dollars or 0) + 100
        print("Given: $100 (Total: $" .. G.GAME.dollars .. ")")
        create_overlay(create_give_money_menu())
    end
end

G.FUNCS.cs_give_money_1000 = function(e)
    if G.GAME then
        G.GAME.dollars = (G.GAME.dollars or 0) + 1000
        print("Given: $1000 (Total: $" .. G.GAME.dollars .. ")")
        create_overlay(create_give_money_menu())
    end
end

G.FUNCS.cs_give_money_infinite = function(e)
    if G.GAME then
        G.GAME.dollars = 99999999999999999  -- Added three more 9's
        print("Given: Infinite Money ($99999999999999999)")
        create_overlay(create_give_money_menu())
    end
end

G.FUNCS.cs_reset_money_to_zero = function(e)
    if G.GAME then
        G.GAME.dollars = 0
        print("Money reset to $0")
        create_overlay(create_give_money_menu())
    end
end

G.FUNCS.cs_back_to_starting_items = function(e)
    create_overlay(create_starting_items_menu())
end

-- Reset money & stats to defaults
G.FUNCS.cs_reset_money_stats = function(e)
    mod.config.starting_money = 4
    mod.config.starting_hands = 4
    mod.config.starting_discards = 3
    mod.config.hand_size = 8
    mod.config.hand_levels = 1
    mod.config.joker_slots = 5
    mod.config.consumable_slots = 2
    mod.config.ante_scaling = 1
    save_config()
    create_overlay(create_money_menu())
    print("Starting Stats reset to defaults")
end

-- Give card functions
G.FUNCS.cs_give_card = function(e)
    create_overlay(create_give_card_menu())
end

-- Card property cycling functions
G.FUNCS.cs_cycle_give_rank = function(e)
    local ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}
    local current_index = 1
    for i, rank in ipairs(ranks) do
        if rank == mod.config.give_card_rank then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #ranks then
        current_index = 1
    end
    
    mod.config.give_card_rank = ranks[current_index]
    create_overlay(create_give_card_menu())
end

G.FUNCS.cs_cycle_give_suit = function(e)
    local suits = {'S', 'H', 'D', 'C'}
    local current_index = 1
    for i, suit in ipairs(suits) do
        if suit == mod.config.give_card_suit then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #suits then
        current_index = 1
    end
    
    mod.config.give_card_suit = suits[current_index]
    create_overlay(create_give_card_menu())
end

G.FUNCS.cs_cycle_give_enhancement = function(e)
    local current_index = 1
    for i, enh in ipairs(enhancement_options) do
        if enh.key == mod.config.give_card_enhancement then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #enhancement_options then
        current_index = 1
    end
    
    mod.config.give_card_enhancement = enhancement_options[current_index].key
    create_overlay(create_give_card_menu())
end

G.FUNCS.cs_cycle_give_seal = function(e)
    local current_index = 1
    for i, seal in ipairs(seal_options) do
        if seal.key == mod.config.give_card_seal then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #seal_options then
        current_index = 1
    end
    
    mod.config.give_card_seal = seal_options[current_index].key
    create_overlay(create_give_card_menu())
end

G.FUNCS.cs_cycle_give_edition = function(e)
    local current_index = 1
    for i, edition in ipairs(edition_options) do
        if edition.key == mod.config.give_card_edition then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #edition_options then
        current_index = 1
    end
    
    mod.config.give_card_edition = edition_options[current_index].key
    create_overlay(create_give_card_menu())
end

-- FIXED give configured card function - with lucky card fix
G.FUNCS.cs_give_configured_card = function(e)
    -- Ensure we're in a state where we can give cards
    if not G.STATE or G.STATE == G.STATES.MENU then
        print("Error: Cannot give cards from menu, must be in a run")
        return
    end
    
    if not G.playing_cards then
        G.playing_cards = {}
    end
    
    -- Use correct card ID format: H_2, S_A, etc.
    local card_id = mod.config.give_card_suit .. '_' .. mod.config.give_card_rank
    
    if not G.P_CARDS[card_id] then
        print("Error: Card not found - " .. card_id)
        return
    end
    
    -- Create card event with slight delay to prevent UI issues
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function()
            -- Check if we're in shop or not in an active hand
            local in_shop = G.STATE == G.STATES.SHOP
            local not_in_round = G.STATE ~= G.STATES.SELECTING_HAND and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.HAND_PLAYED
            
            -- Determine where to create the card
            local create_area = G.deck
            local add_to_hand = false
            
            -- Only add to hand if we're in an active round (not shop, not between rounds)
            if not in_shop and not not_in_round and G.hand and G.hand.config and #G.hand.cards < G.hand.config.card_limit then
                create_area = G.hand
                add_to_hand = true
            end
            
            -- Create card with base center
            local card = Card(
                create_area.T.x + create_area.T.w/2,
                create_area.T.y,
                G.CARD_W, G.CARD_H,
                G.P_CARDS[card_id],
                G.P_CENTERS.c_base,
                {playing_card = card_id}
            )
            
            if card then
                -- Apply enhancement after creation if not base
                if mod.config.give_card_enhancement and mod.config.give_card_enhancement ~= 'base' and G.P_CENTERS[mod.config.give_card_enhancement] then
                    card:set_ability(G.P_CENTERS[mod.config.give_card_enhancement])
                end
                
                -- Apply seal if not none
                if mod.config.give_card_seal and mod.config.give_card_seal ~= 'none' then
                    card.seal = mod.config.give_card_seal
                end
                
                -- Apply edition if not base
                if mod.config.give_card_edition and mod.config.give_card_edition ~= 'base' then
                    card:set_edition({[mod.config.give_card_edition] = true})
                end
                
                -- Lucky cards will be handled by the game's native logic with our hook
                
                -- Add to playing cards list
                card:add_to_deck()
                table.insert(G.playing_cards, card)
                
                -- Add to appropriate area
                if add_to_hand then
                    G.hand:emplace(card)
                else
                    G.deck:emplace(card)
                end
                
                -- Update deck display
                if G.deck and G.deck.config then
                    G.deck.config.card_count = #G.playing_cards
                end
                
                -- Draw card effect
                card:start_materialize()
                
                -- Get suit name for display
                local suit_map = {S = 'Spades', H = 'Hearts', D = 'Diamonds', C = 'Clubs'}
                local suit_name = suit_map[mod.config.give_card_suit] or mod.config.give_card_suit
                
                print("Given card: " .. mod.config.give_card_rank .. " of " .. suit_name .. 
                      " with " .. (mod.config.give_card_enhancement or "base") .. " enhancement, " .. 
                      (mod.config.give_card_seal or "no") .. " seal, and " ..
                      (mod.config.give_card_edition or "base") .. " edition")
                print("Added to: " .. (add_to_hand and "hand" or "deck"))
                print("Total cards: " .. #G.playing_cards)
            else
                print("Error: Failed to create card")
            end
            
            -- Refresh the menu after a small delay to prevent UI issues
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    create_overlay(create_give_card_menu())
                    return true
                end
            }))
            
            return true
        end
    }))
end

-- Give joker tab switching
mod.config.give_joker_tab = mod.config.give_joker_tab or "vanilla"

G.FUNCS.cs_give_switch_to_vanilla = function(e)
    mod.config.give_joker_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_switch_to_mikas = function(e)
    mod.config.give_joker_tab = "mikas"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(mikas_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

-- Toggle functions
G.FUNCS.cs_toggle_custom_stats = function(e)
    mod.config.use_custom_stats = not mod.config.use_custom_stats
    save_config()
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_toggle_custom_deck = function(e)
    mod.config.use_custom_deck = not mod.config.use_custom_deck
    save_config()
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_toggle_free_rerolls_main = function(e)
    mod.config.free_rerolls = not mod.config.free_rerolls
    save_config()
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_toggle_give_during_runs = function(e)
    mod.config.allow_give_during_runs = not mod.config.allow_give_during_runs
    save_config()
    create_overlay(create_settings_menu())
end

G.FUNCS.cs_toggle_starting_items = function(e)
    mod.config.use_starting_items = not mod.config.use_starting_items
    save_config()
    create_overlay(create_settings_menu())
end

-- Reset function
G.FUNCS.cs_reset_all = function(e)
    -- Don't allow reset during runs
    local in_run = G.GAME and G.STATE ~= G.STATES.MENU
    if in_run then
        print("Cannot reset settings during a run")
        return
    end
    
    -- Reset to defaults
    mod.config.starting_money = 4
    mod.config.starting_hands = 4
    mod.config.starting_discards = 3
    mod.config.hand_size = 8
    mod.config.hand_levels = 1
    mod.config.free_rerolls = false
    mod.config.joker_slots = 5
    mod.config.consumable_slots = 2
    mod.config.custom_deck = {}
    mod.config.starting_jokers = {}
    mod.config.starting_vouchers = {}
    mod.config.starting_tags = {}
    mod.config.use_custom_stats = false
    mod.config.use_custom_deck = false
    mod.config.use_starting_items = false
    mod.config.allow_give_during_runs = false
    mod.config.ante_scaling = 1
    mod.config.mod_disabled = false
    save_config()
    create_overlay(create_settings_menu())
    print("ZokersModMenu: All settings reset to defaults")
end

-- Give item functions
G.FUNCS.cs_give_consumable = function(e)
    create_overlay(create_consumable_type_menu())
end

G.FUNCS.cs_give_tarot = function(e)
    mod.config.current_give_list = tarot_cards
    mod.config.give_type = "tarot"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(tarot_cards, "SELECT TAROT CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_planet = function(e)
    mod.config.current_give_list = planet_cards
    mod.config.give_type = "planet"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(planet_cards, "SELECT PLANET CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_spectral = function(e)
    mod.config.current_give_list = spectral_cards
    mod.config.give_type = "spectral"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(spectral_cards, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_voucher = function(e)
    mod.config.current_give_list = available_vouchers
    mod.config.give_type = "voucher"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_vouchers, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

G.FUNCS.cs_give_joker = function(e)
    mod.config.give_joker_tab = "vanilla"
    mod.config.give_type = "joker"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_tag = function(e)
    mod.config.current_give_list = available_tags
    mod.config.give_type = "tag"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_tags, "SELECT TAG", "cs_instant_give_tag"))
end

G.FUNCS.cs_back_to_give = function(e)
    create_overlay(create_give_item_menu())
end

G.FUNCS.cs_back_to_consumable_type = function(e)
    if mod.config.give_type == "joker" or mod.config.give_type == "voucher" or mod.config.give_type == "tag" then
        create_overlay(create_give_item_menu())
    else
        create_overlay(create_consumable_type_menu())
    end
end

-- FIXED instant give functions
G.FUNCS.cs_instant_give_card = function(e)
    local card_key = e.config.ref_table and e.config.ref_table.card_key
    
    if not card_key then
        print("Error: No card key provided")
        return
    end
    
    -- Check if we're in a valid state
    if not G.STATE or G.STATE == G.STATES.MENU then
        print("Error: Cannot give consumables from menu, must be in a run")
        return
    end
    
    if G.consumeables and G.P_CENTERS and G.P_CENTERS[card_key] then
        local center = G.P_CENTERS[card_key]
        
        -- Create consumable with event
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                local card = Card(
                    G.consumeables.T.x + G.consumeables.T.w/2,
                    G.consumeables.T.y,
                    G.CARD_W, G.CARD_H,
                    nil,
                    center,
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                
                if card then
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    card:start_materialize()
                    print("Given: " .. card_key)
                else
                    print("Error: Failed to create consumable")
                end
                return true
            end
        }))
    else
        print("Error: Center not found for " .. (card_key or "nil"))
    end
end

-- FIXED instant give voucher - handle nil ante_scaling and avoid crashes
G.FUNCS.cs_instant_give_voucher = function(e)
    local voucher_key = e.config.ref_table and e.config.ref_table.card_key
    
    if not voucher_key then
        print("Error: No voucher key provided")
        return
    end
    
    if G.P_CENTERS[voucher_key] then
        -- Force add to used vouchers
        G.GAME.used_vouchers = G.GAME.used_vouchers or {}
        G.GAME.used_vouchers[voucher_key] = true
        
        local voucher_obj = G.P_CENTERS[voucher_key]
        
        -- Handle paired vouchers
        if voucher_obj.requires then
            for _, req in ipairs(voucher_obj.requires) do
                G.GAME.used_vouchers[req] = true
            end
        end
        
        -- Direct voucher effect application
        if voucher_key == "v_grabber" then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            print("Applied Grabber - Extra joker slot (now " .. G.jokers.config.card_limit .. ")")
        elseif voucher_key == "v_nacho_tong" then
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            print("Applied Nacho Tong - Extra joker slot (now " .. G.jokers.config.card_limit .. ")")
        elseif voucher_key == "v_wasteful" then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            print("Applied Wasteful - Extra consumable slot (now " .. G.consumeables.config.card_limit .. ")")
        elseif voucher_key == "v_recyclomancy" then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            print("Applied Recyclomancy - Extra consumable slot (now " .. G.consumeables.config.card_limit .. ")")
        elseif voucher_key == "v_overstock_norm" then
            G.GAME.shop = G.GAME.shop or {}
            G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
            print("Applied Overstock - Extra shop slot")
        elseif voucher_key == "v_overstock_plus" then
            G.GAME.shop = G.GAME.shop or {}
            G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
            print("Applied Overstock+ - Extra shop slot")
        elseif voucher_key == "v_seed_money" then
            G.GAME.interest_cap = (G.GAME.interest_cap or 25) + 25
            print("Applied Seed Money - Interest cap raised to " .. G.GAME.interest_cap)
        elseif voucher_key == "v_money_tree" then
            G.GAME.interest_cap = math.max(50, (G.GAME.interest_cap or 25))
            G.GAME.interest_amount = (G.GAME.interest_amount or 1) + 1
            print("Applied Money Tree - Interest improved")
        elseif voucher_key == "v_blank" then
            G.GAME.modifiers = G.GAME.modifiers or {}
            G.GAME.modifiers.sell_cost = (G.GAME.modifiers.sell_cost or 0) + 1
            print("Applied Blank - Increased sell values")
        elseif voucher_key == "v_antimatter" then
            G.GAME.modifiers = G.GAME.modifiers or {}
            G.GAME.modifiers.sell_cost = (G.GAME.modifiers.sell_cost or 0) + 1
            print("Applied Antimatter - Increased sell values")
        elseif voucher_key == "v_magic_trick" then
            G.hand.config.card_limit = G.hand.config.card_limit + 1
            print("Applied Magic Trick - Can hold 1 more card")
        elseif voucher_key == "v_illusion" then
            G.hand.config.highlighted_limit = math.max(G.hand.config.highlighted_limit or 5, 5)
            print("Applied Illusion - Increased playing card limit")
        elseif voucher_key == "v_hieroglyph" then
            if G.GAME.round_resets then
                G.GAME.round_resets.ante_scaling = (G.GAME.round_resets.ante_scaling or 1) - 2
                print("Applied Hieroglyph - Reduced ante scaling")
            else
                print("Warning: Could not apply Hieroglyph - round_resets not ready")
            end
        elseif voucher_key == "v_petroglyph" then
            if G.GAME.round_resets then
                G.GAME.round_resets.ante_scaling = (G.GAME.round_resets.ante_scaling or 1) - 2
                print("Applied Petroglyph - Reduced ante scaling")
            else
                print("Warning: Could not apply Petroglyph - round_resets not ready")
            end
        elseif voucher_key == "v_directors_cut" then
            G.GAME.round_resets.reroll_cost = math.max(0, (G.GAME.round_resets.reroll_cost or 5) - 1)
            print("Applied Director's Cut - Reroll cost -$1")
        elseif voucher_key == "v_paint_brush" then
            G.hand.config.card_limit = G.hand.config.card_limit + 1
            print("Applied Paint Brush - +1 hand size")
        elseif voucher_key == "v_palette" then
            G.hand.config.card_limit = G.hand.config.card_limit + 1
            print("Applied Palette - +1 hand size")
        elseif voucher_key == "v_clearance_sale" then
            G.GAME.modifiers = G.GAME.modifiers or {}
            G.GAME.modifiers.base_cost_mult = 0.75
            print("Applied Clearance Sale - All items 25% off")
        elseif voucher_key == "v_liquidation" then
            G.GAME.modifiers = G.GAME.modifiers or {}
            G.GAME.modifiers.base_cost_mult = 0.5
            print("Applied Liquidation - All items 50% off")
        elseif voucher_key == "v_reroll_surplus" then
            G.GAME.round_resets.reroll_cost = math.max(0, (G.GAME.round_resets.reroll_cost or 5) - 2)
            print("Applied Reroll Surplus - Base reroll cost -$2")
        elseif voucher_key == "v_reroll_glut" then
            G.GAME.round_resets.reroll_cost = math.max(0, (G.GAME.round_resets.reroll_cost or 5) - 2)
            print("Applied Reroll Glut - Base reroll cost -$2")
        elseif voucher_key == "v_crystal_ball" then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            print("Applied Crystal Ball - +1 consumable slot")
        elseif voucher_key == "v_omen_globe" then
            G.GAME.modifiers = G.GAME.modifiers or {}
            G.GAME.modifiers.enable_spectral_in_shop = true
            print("Applied Omen Globe - Spectral packs may appear in shop")
        elseif voucher_key == "v_observatory" then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            if G.GAME.consumeable_edition_rate then
                G.GAME.consumeable_edition_rate = G.GAME.consumeable_edition_rate + 2
            end
            print("Applied Observatory - Planet cards have x2 chance for edition")
        end
        
        -- Try redeem method for any other effects
        if voucher_obj.redeem then
            local success, err = pcall(function()
                voucher_obj:redeem()
            end)
            if not success then
                print("Voucher redeem error for " .. voucher_key .. ": " .. tostring(err))
            end
        end
        
        print("Given voucher: " .. voucher_key)
    end
end

-- FIXED instant give joker - improved functionality with proper error checking
G.FUNCS.cs_instant_give_joker = function(e)
    local joker_key = e.config.ref_table and e.config.ref_table.card_key
    
    if not joker_key then
        print("Error: No joker key provided in ref_table")
        return
    end
    
    -- Check if we're in a valid state
    if not G.STATE or G.STATE == G.STATES.MENU then
        print("Error: Cannot give jokers from menu, must be in a run")
        return
    end
    
    if not G.jokers then
        print("Error: Jokers area not available")
        return
    end
    
    if not G.P_CENTERS or not G.P_CENTERS[joker_key] then
        print("Error: Joker center not found for " .. tostring(joker_key))
        return
    end
    
    local center = G.P_CENTERS[joker_key]
    
    -- Create joker with event to ensure proper timing
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local joker = Card(
                G.jokers.T.x + G.jokers.T.w/2,
                G.jokers.T.y,
                G.CARD_W, G.CARD_H,
                nil,
                center,
                {bypass_discovery_center = true, bypass_discovery_ui = true}
            )
            
            if joker then
                -- Add to deck first
                joker:add_to_deck()
                G.jokers:emplace(joker)
                
                -- Start materialize effect
                joker:start_materialize()
                
                print("Given joker: " .. joker_key)
            else
                print("Error: Failed to create joker")
            end
            return true
        end
    }))
end

-- Give tag function
G.FUNCS.cs_instant_give_tag = function(e)
    local tag_key = e.config.ref_table and e.config.ref_table.card_key
    
    if not tag_key then
        print("Error: No tag key provided")
        return
    end
    
    -- Check if we're in a valid state
    if not G.STATE or G.STATE == G.STATES.MENU then
        print("Error: Cannot give tags from menu, must be in a run")
        return
    end
    
    if G.P_TAGS and G.P_TAGS[tag_key] then
        add_tag(Tag(tag_key))
        print("Given tag: " .. tag_key)
    else
        print("Error: Tag not found - " .. tag_key)
    end
end

-- Navigation functions for joker pages
G.FUNCS.cs_joker_prev_page = function(e)
    mod.config.joker_page = math.max(1, (mod.config.joker_page or 1) - 1)
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_joker_next_page = function(e)
    local total_pages = math.ceil(#available_jokers / 24)
    mod.config.joker_page = math.min(total_pages, (mod.config.joker_page or 1) + 1)
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_mikas_joker_prev_page = function(e)
    mod.config.mikas_joker_page = math.max(1, (mod.config.mikas_joker_page or 1) - 1)
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_mikas_joker_next_page = function(e)
    local total_pages = math.ceil(#mikas_jokers / 24)
    mod.config.mikas_joker_page = math.min(total_pages, (mod.config.mikas_joker_page or 1) + 1)
    create_overlay(create_joker_menu())
end

-- Navigation functions for voucher pages
G.FUNCS.cs_voucher_prev_page = function(e)
    mod.config.voucher_page = math.max(1, (mod.config.voucher_page or 1) - 1)
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_voucher_next_page = function(e)
    local total_pages = math.ceil(#available_vouchers / 20)
    mod.config.voucher_page = math.min(total_pages, (mod.config.voucher_page or 1) + 1)
    create_overlay(create_voucher_menu())
end

-- Navigation functions for tag pages
G.FUNCS.cs_tag_prev_page = function(e)
    mod.config.tag_page = math.max(1, (mod.config.tag_page or 1) - 1)
    create_overlay(create_tag_menu())
end

G.FUNCS.cs_tag_next_page = function(e)
    local total_pages = math.ceil(#available_tags / 20)
    mod.config.tag_page = math.min(total_pages, (mod.config.tag_page or 1) + 1)
    create_overlay(create_tag_menu())
end

-- Navigation functions for give item pages
G.FUNCS.cs_give_prev_page = function(e)
    mod.config.give_page = math.max(1, (mod.config.give_page or 1) - 1)
    
    -- Recreate the appropriate menu based on current type
    if mod.config.give_type == "joker" then
        local current_list = mod.config.give_joker_tab == "mikas" and mikas_jokers or available_jokers
        create_overlay(create_card_selection_menu(current_list, "SELECT JOKER", "cs_instant_give_joker"))
    elseif mod.config.give_type == "tarot" then
        create_overlay(create_card_selection_menu(tarot_cards, "SELECT TAROT CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "planet" then
        create_overlay(create_card_selection_menu(planet_cards, "SELECT PLANET CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "spectral" then
        create_overlay(create_card_selection_menu(spectral_cards, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "voucher" then
        create_overlay(create_card_selection_menu(available_vouchers, "SELECT VOUCHER", "cs_instant_give_voucher"))
    elseif mod.config.give_type == "tag" then
        create_overlay(create_card_selection_menu(available_tags, "SELECT TAG", "cs_instant_give_tag"))
    end
end

G.FUNCS.cs_give_next_page = function(e)
    local total_pages = 1
    
    -- Calculate total pages based on current type
    if mod.config.give_type == "joker" then
        local current_list = mod.config.give_joker_tab == "mikas" and mikas_jokers or available_jokers
        total_pages = math.ceil(#current_list / 20)
    elseif mod.config.give_type == "tarot" then
        total_pages = math.ceil(#tarot_cards / 20)
    elseif mod.config.give_type == "planet" then
        total_pages = math.ceil(#planet_cards / 20)
    elseif mod.config.give_type == "spectral" then
        total_pages = math.ceil(#spectral_cards / 20)
    elseif mod.config.give_type == "voucher" then
        total_pages = math.ceil(#available_vouchers / 20)
    elseif mod.config.give_type == "tag" then
        total_pages = math.ceil(#available_tags / 20)
    end
    
    mod.config.give_page = math.min(total_pages, (mod.config.give_page or 1) + 1)
    
    -- Recreate the appropriate menu
    if mod.config.give_type == "joker" then
        local current_list = mod.config.give_joker_tab == "mikas" and mikas_jokers or available_jokers
        create_overlay(create_card_selection_menu(current_list, "SELECT JOKER", "cs_instant_give_joker"))
    elseif mod.config.give_type == "tarot" then
        create_overlay(create_card_selection_menu(tarot_cards, "SELECT TAROT CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "planet" then
        create_overlay(create_card_selection_menu(planet_cards, "SELECT PLANET CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "spectral" then
        create_overlay(create_card_selection_menu(spectral_cards, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "voucher" then
        create_overlay(create_card_selection_menu(available_vouchers, "SELECT VOUCHER", "cs_instant_give_voucher"))
    elseif mod.config.give_type == "tag" then
        create_overlay(create_card_selection_menu(available_tags, "SELECT TAG", "cs_instant_give_tag"))
    end
end

-- Toggle joker selection
G.FUNCS.cs_toggle_joker = function(e)
    local joker_key = e.config.ref_table.joker_key
    
    -- Add to starting jokers (allows multiples)
    table.insert(mod.config.starting_jokers, joker_key)
    save_config()
    create_overlay(create_joker_menu())
end

-- Toggle voucher selection
G.FUNCS.cs_toggle_voucher = function(e)
    local voucher_key = e.config.ref_table.voucher_key
    local found = false
    local index_to_remove = nil
    
    -- Check if already selected
    for i, selected in ipairs(mod.config.starting_vouchers) do
        if selected == voucher_key then
            found = true
            index_to_remove = i
            break
        end
    end
    
    if found then
        -- Remove if already selected
        table.remove(mod.config.starting_vouchers, index_to_remove)
    else
        -- Add if not selected
        table.insert(mod.config.starting_vouchers, voucher_key)
    end
    
    save_config()
    create_overlay(create_voucher_menu())
end

-- Toggle tag selection
G.FUNCS.cs_toggle_tag = function(e)
    local tag_key = e.config.ref_table.tag_key
    local found = false
    local index_to_remove = nil
    
    -- Check if already selected
    for i, selected in ipairs(mod.config.starting_tags) do
        if selected == tag_key then
            found = true
            index_to_remove = i
            break
        end
    end
    
    if found then
        -- Remove if already selected
        table.remove(mod.config.starting_tags, index_to_remove)
    else
        -- Add if not selected
        table.insert(mod.config.starting_tags, tag_key)
    end
    
    save_config()
    create_overlay(create_tag_menu())
end

-- Clear functions
G.FUNCS.cs_clear_jokers = function(e)
    mod.config.starting_jokers = {}
    save_config()
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_clear_vouchers = function(e)
    mod.config.starting_vouchers = {}
    save_config()
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_clear_tags = function(e)
    mod.config.starting_tags = {}
    save_config()
    create_overlay(create_tag_menu())
end

-- Money & Stats adjustment functions
G.FUNCS.cs_money_down = function(e)
    mod.config.starting_money = math.max(0, mod.config.starting_money - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_money_up = function(e)
    mod.config.starting_money = mod.config.starting_money + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hands_down = function(e)
    mod.config.starting_hands = math.max(0, mod.config.starting_hands - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hands_up = function(e)
    mod.config.starting_hands = mod.config.starting_hands + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_discards_down = function(e)
    mod.config.starting_discards = math.max(0, mod.config.starting_discards - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_discards_up = function(e)
    mod.config.starting_discards = mod.config.starting_discards + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hand_size_down = function(e)
    mod.config.hand_size = math.max(0, mod.config.hand_size - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hand_size_up = function(e)
    mod.config.hand_size = mod.config.hand_size + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hand_levels_down = function(e)
    mod.config.hand_levels = math.max(1, mod.config.hand_levels - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_hand_levels_up = function(e)
    mod.config.hand_levels = mod.config.hand_levels + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_slots_down = function(e)
    mod.config.joker_slots = math.max(0, mod.config.joker_slots - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_slots_up = function(e)
    mod.config.joker_slots = mod.config.joker_slots + 1
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_consumables_down = function(e)
    mod.config.consumable_slots = math.max(0, mod.config.consumable_slots - 1)
    save_config()
    create_overlay(create_money_menu())
end

G.FUNCS.cs_consumables_up = function(e)
    mod.config.consumable_slots = mod.config.consumable_slots + 1
    save_config()
    create_overlay(create_money_menu())
end

-- Deck builder functions
G.FUNCS.cs_add_card = function(e)
    local rank = e.config.ref_table.rank
    local suit = e.config.ref_table.suit
    
    -- Add card with current enhancement/seal/edition regardless of existing cards
    local card_data = create_card_data(
        rank, 
        suit, 
        mod.config.current_enhancement,
        mod.config.current_seal,
        mod.config.current_edition
    )
    
    table.insert(mod.config.custom_deck, card_data)
    
    -- IMMEDIATELY save config
    save_config()
    print("ZokersModMenu: Added card " .. rank .. suit .. " to deck. Total: " .. #mod.config.custom_deck)
    print("With enhancement: " .. mod.config.current_enhancement .. ", seal: " .. mod.config.current_seal .. ", edition: " .. mod.config.current_edition)
    
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_clear_deck = function(e)
    mod.config.custom_deck = {}
    save_config()
    print("ZokersModMenu: Cleared deck. Total: " .. #mod.config.custom_deck)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_standard_deck = function(e)
    mod.config.custom_deck = {}
    local suits = {'S', 'H', 'D', 'C'}
    local ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}
    
    -- Use current enhancement/seal/edition settings
    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            table.insert(mod.config.custom_deck, create_card_data(
                rank, 
                suit,
                mod.config.current_enhancement,
                mod.config.current_seal,
                mod.config.current_edition
            ))
        end
    end
    
    save_config()
    print("ZokersModMenu: Created standard 52-card deck with current settings. Total: " .. #mod.config.custom_deck)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_save_deck = function(e)
    save_config()
    print("ZokersModMenu: Deck saved with " .. #mod.config.custom_deck .. " cards")
end

-- Enhancement/Seal/Edition cycling
G.FUNCS.cs_cycle_enhancement = function(e)
    local current_index = 1
    for i, enh in ipairs(enhancement_options) do
        if enh.key == mod.config.current_enhancement then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #enhancement_options then
        current_index = 1
    end
    
    mod.config.current_enhancement = enhancement_options[current_index].key
    save_config()
    print("Enhancement changed to: " .. mod.config.current_enhancement)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_cycle_seal = function(e)
    local current_index = 1
    for i, seal in ipairs(seal_options) do
        if seal.key == mod.config.current_seal then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #seal_options then
        current_index = 1
    end
    
    mod.config.current_seal = seal_options[current_index].key
    save_config()
    print("Seal changed to: " .. mod.config.current_seal)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_cycle_edition = function(e)
    local current_index = 1
    for i, edition in ipairs(edition_options) do
        if edition.key == mod.config.current_edition then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #edition_options then
        current_index = 1
    end
    
    mod.config.current_edition = edition_options[current_index].key
    save_config()
    print("Edition changed to: " .. mod.config.current_edition)
    create_overlay(create_deck_builder())
end

-- Unlock all function - IMPROVED to unlock everything
G.FUNCS.cs_unlock_all = function(e)
    -- Unlock all jokers
    for k, v in pairs(G.P_CENTERS) do
        if v.set and (v.set == 'Joker' or v.set == 'Tarot' or v.set == 'Planet' or 
                      v.set == 'Spectral' or v.set == 'Voucher' or v.set == 'Booster' or
                      v.set == 'Edition' or v.set == 'Enhanced' or v.set == 'Seal') then
            v.discovered = true
            v.alerted = true
            if v.unlock_condition then
                v.unlock_condition.met = true
            end
        end
    end
    
    -- Unlock all consumables
    if G.P_CENTERS then
        for k, v in pairs(G.P_CENTERS) do
            if v.consumeable then
                v.discovered = true
                v.alerted = true
            end
        end
    end
    
    -- Unlock all decks
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Back' then
            v.alerted = true
            v.discovered = true
            v.unlocked = true
            if v.unlock_condition then
                v.unlock_condition.met = true
                v.unlock_condition.discovered = true
            end
        end
    end
    
    -- Unlock all stakes
    if G.P_CENTER_POOLS and G.P_CENTER_POOLS.Stake then
        for k, v in pairs(G.P_CENTER_POOLS.Stake) do
            v.discovered = true
            v.alerted = true
            v.unlocked = true
            if v.unlock_condition then
                v.unlock_condition.met = true
            end
        end
    end
    
    -- Alternative stake unlock method
    if G.P_STAKES then
        for i = 1, 8 do
            G.P_STAKES[i] = G.P_STAKES[i] or {}
            G.P_STAKES[i].unlocked = true
            G.P_STAKES[i].discovered = true
            G.P_STAKES[i].alerted = true
        end
    end
    
    -- Unlock all blinds
    for k, v in pairs(G.P_BLINDS) do
        v.discovered = true
        v.alerted = true
        v.unlocked = true
    end
    
    -- Unlock all tags
    for k, v in pairs(G.P_TAGS) do
        v.discovered = true
        v.alerted = true
        v.unlocked = true
    end
    
    -- Unlock all cards (playing cards)
    if G.P_CARDS then
        for k, v in pairs(G.P_CARDS) do
            v.discovered = true
            v.alerted = true
        end
    end
    
    -- Unlock modded content if present
    if SMODS then
        -- Unlock modded jokers
        if SMODS.Jokers then
            for k, v in pairs(SMODS.Jokers) do
                if v.discovered ~= nil then v.discovered = true end
                if v.alerted ~= nil then v.alerted = true end
                if v.unlocked ~= nil then v.unlocked = true end
            end
        end
        
        -- Unlock modded consumables  
        if SMODS.Consumables then
            for k, v in pairs(SMODS.Consumables) do
                if v.discovered ~= nil then v.discovered = true end
                if v.alerted ~= nil then v.alerted = true end
            end
        end
        
        -- Unlock modded vouchers
        if SMODS.Vouchers then
            for k, v in pairs(SMODS.Vouchers) do
                if v.discovered ~= nil then v.discovered = true end
                if v.alerted ~= nil then v.alerted = true end
            end
        end
        
        -- Unlock modded decks
        if SMODS.Backs then
            for k, v in pairs(SMODS.Backs) do
                if v.discovered ~= nil then v.discovered = true end
                if v.alerted ~= nil then v.alerted = true end
                if v.unlocked ~= nil then v.unlocked = true end
            end
        end
    end
    
    -- Save progress
    if G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
        G:save_progress()
    end
    
    print("ZokersModMenu: Unlocked all jokers, cards, tags, vouchers, stakes, decks, consumables, and enabled challenges")
end

-- Hook to add menu button to pause menu
local ref_set_pause_menu = G.FUNCS.set_pause_menu
G.FUNCS.set_pause_menu = function(e)
    ref_set_pause_menu(e)
    
    -- Add button to pause menu
    if G.STAGE == G.STAGES.RUN then
        -- Find the options button and add our button after it
        local pause_menu = G.OVERLAY_MENU
        if pause_menu and pause_menu.definition and pause_menu.definition.nodes then
            for i, node in ipairs(pause_menu.definition.nodes) do
                if node.nodes then
                    -- Insert our button before the last button (usually "Quit Run")
                    table.insert(node.nodes, #node.nodes, {
                        n = G.UIT.R,
                        config = {align = "cm", padding = 0.1},
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = {
                                    align = "cm",
                                    padding = 0.1,
                                    button = "cs_open_main_menu",
                                    hover = true,
                                    minw = 2.5,
                                    minh = 0.6,
                                    colour = G.C.BLUE,
                                    r = 0.1
                                },
                                nodes = {
                                    {n = G.UIT.T, config = {text = "Zoker's Menu", scale = 0.5, colour = G.C.WHITE}}
                                }
                            }
                        }
                    })
                    break
                end
            end
        end
    end
end

-- Keyboard shortcut handling - FIXED to not interfere with other menus
local ref_Controller_key_press = Controller.key_press
function Controller:key_press(key)
    -- Call original function first
    local ret = ref_Controller_key_press(self, key)
    
    -- Check if 'c' key was pressed and we're not typing in a text field
    if key == 'c' and not (G.CONTROLLER and G.CONTROLLER.text_input_hook) then
        -- Always allow during runs or in menu
        if G.STAGE == G.STAGES.RUN or G.STATE == G.STATES.MENU then
            -- TOGGLE our specific menu ONLY
            if is_zokers_menu_open() then
                -- Close ONLY our menu
                close_zokers_menu()
                print("ZokersModMenu: Menu closed")
            else
                -- Open our menu WITHOUT closing others
                G.FUNCS.cs_open_main_menu()
                print("ZokersModMenu: Menu opened")
            end
        end
    end
    
    return ret
end