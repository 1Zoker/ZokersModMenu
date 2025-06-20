--- STEAMODDED HEADER
--- MOD_NAME: ZokersModMenu
--- MOD_ID: ZokersModMenu
--- MOD_AUTHOR: [Zoker]
--- MOD_DESCRIPTION: Complete game customization: Build custom decks with enhancements/seals/editions, set starting items (jokers/vouchers/tags), adjust all stats (money/hands/discards/slots), modify ante scaling, give any item during runs, unlock all content.
--- BADGE_COLOUR: 708b91
--- PREFIX: cs
--- PRIORITY: 0
--- VERSION: 2.1.1
--- RELEASE_DATE: 2025-06-16

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
    elseif SMODS.save_config then
        SMODS.save_config("ZokersModMenu", mod.config)
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
				-- Add menu key remapping
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.C, config = {align = "cl", padding = 0.05}, nodes = {
                        {n = G.UIT.T, config = {text = "Menu Key: ", scale = 0.5, colour = G.C.WHITE}},
                        {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_change_menu_key", hover = true, minw = 1.2, minh = 0.7, 
                            colour = {0.4, 0.6, 0.8, 1}, r = 0.05, outline_colour = G.C.WHITE, outline = 1}, 
                         nodes = {{n = G.UIT.T, config = {text = string.upper(mod.config.menu_key), scale = 0.5, colour = G.C.WHITE}}}}
                    }}
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
mod.config.starting_joker_edition = mod.config.starting_joker_edition or 'base'
mod.config.give_joker_edition = mod.config.give_joker_edition or 'base'
mod.config.use_custom_deck = mod.config.use_custom_deck or false
mod.config.allow_give_during_runs = mod.config.allow_give_during_runs or false
mod.config.use_starting_items = mod.config.use_starting_items or false
mod.config.ante_scaling = mod.config.ante_scaling or 1
mod.config.mod_disabled = mod.config.mod_disabled or false  -- NEW: disable option
mod.config.menu_key = mod.config.menu_key or 'c'
mod.config.came_from_modded = false
mod.config.current_modded_list = {}
-- Page tracking for navigation
mod.config.give_mod_page_joker = mod.config.give_mod_page_joker or 1
mod.config.give_mod_page_voucher = mod.config.give_mod_page_voucher or 1
mod.config.give_mod_page_tag = mod.config.give_mod_page_tag or 1
mod.config.give_mod_page_tarot = mod.config.give_mod_page_tarot or 1
mod.config.give_mod_page_planet = mod.config.give_mod_page_planet or 1
mod.config.give_mod_page_spectral = mod.config.give_mod_page_spectral or 1

-- At the top with other color definitions, update edition_colors:
local edition_colors = {
    base = {0.3, 0.3, 0.3, 1},        -- Dark grey (default)
    foil = {0.2, 0.4, 0.8, 1},        -- Blue
    holo = {0.8, 0.2, 0.2, 1},        -- Red
    polychrome = {0.8, 0.2, 0.5, 1},  -- Pink
    negative = {0.1, 0.1, 0.1, 1}     -- Black
}

-- Enhancement button colors
local enhancement_colors = {
    base = {0.3, 0.3, 0.3, 1},        -- Dark grey (default)
    m_bonus = {0.2, 0.4, 0.8, 1},     -- Blue
    m_mult = {0.8, 0.2, 0.2, 1},      -- Red
    m_wild = {0.1, 0.1, 0.1, 1},      -- Black
    m_glass = {0.6, 0.6, 0.6, 0.7},   -- Light grey/transparent
    m_steel = {0.4, 0.4, 0.4, 1},     -- Grey
    m_stone = {0.2, 0.2, 0.2, 1},     -- Dark grey
    m_gold = {0.8, 0.7, 0.2, 1},      -- Gold
    m_lucky = {0.9, 0.9, 0.5, 1}      -- Soft yellow
}

-- Seal button colors
local seal_colors = {
    none = {0.3, 0.3, 0.3, 1},        -- Base grey
    Gold = {0.8, 0.7, 0.2, 1},        -- Gold
    Red = {0.8, 0.2, 0.2, 1},         -- Red
    Blue = {0.2, 0.4, 0.8, 1},        -- Blue
    Purple = {0.6, 0.2, 0.8, 1}       -- Purple
}

-- Text input state
mod.text_input_active = false
mod.text_input_type = nil
mod.text_input_value = ""

-- Create text input dialog
local function create_text_input_dialog(title, current_value, stat_type)
    mod.text_input_active = true
    mod.text_input_type = stat_type
    mod.text_input_value = tostring(current_value)
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 6, minh = 4, colour = {0, 0, 0, 0.9}, r = 0.1, padding = 0.1},
        nodes = {
            -- Title
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = title, scale = 0.6, colour = {1, 1, 1, 1}}}}},
            
            -- Input display
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.15, minw = 4, minh = 1, colour = {0.2, 0.2, 0.2, 1}, r = 0.05, outline_colour = {0.8, 0.8, 0.8, 1}, outline = 2}, 
                 nodes = {{n = G.UIT.T, config = {text = mod.text_input_value .. "_", scale = 0.7, colour = {1, 1, 1, 1}, ref_table = mod, ref_value = "text_input_value"}}}}
            }},
            
            -- Instructions
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Type a number and press Enter", scale = 0.4, colour = {0.7, 0.7, 0.7, 1}}}}},
            
            -- Buttons
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_confirm_text_input", hover = true, minw = 2, minh = 0.8, colour = G.C.GREEN, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Confirm", scale = 0.5, colour = G.C.WHITE}}}},
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_cancel_text_input", hover = true, minw = 2, minh = 0.8, colour = G.C.RED, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Cancel", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
end

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
    'c_fool', 'c_hanged_man', 'c_hermit', 'c_heirophant', 'c_high_priestess',
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

-- Dynamic modded joker detection system
local modded_jokers_by_mod = {}
local all_modded_jokers = {}


-- Helper function to count table entries
local function table_length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- Dynamic modded voucher detection system
local modded_vouchers_by_mod = {}
local all_modded_vouchers = {}

-- Dynamic modded tag detection system
local modded_tags_by_mod = {}
local all_modded_tags = {}

local modded_other_consumables_by_mod = {}
local all_modded_other_consumables = {}

-- Function to detect all modded content
local function detect_all_modded_content()
    -- Reset all collections
    modded_jokers_by_mod = {}
    all_modded_jokers = {}
    modded_vouchers_by_mod = {}
    all_modded_vouchers = {}
    modded_tags_by_mod = {}
    all_modded_tags = {}
    modded_tarots_by_mod = {}
    all_modded_tarots = {}
    modded_planets_by_mod = {}
    all_modded_planets = {}
    modded_spectrals_by_mod = {}
    all_modded_spectrals = {}
	
	
    
    -- Create lookup tables for vanilla content
    local vanilla_joker_lookup = {}
    for _, key in ipairs(available_jokers) do
        vanilla_joker_lookup[key] = true
    end
    
    local vanilla_voucher_lookup = {}
    for _, key in ipairs(available_vouchers) do
        vanilla_voucher_lookup[key] = true
    end
    
    local vanilla_tag_lookup = {}
    for _, key in ipairs(available_tags) do
        vanilla_tag_lookup[key] = true
    end
    
    local vanilla_tarot_lookup = {}
    for _, key in ipairs(tarot_cards) do
        vanilla_tarot_lookup[key] = true
    end
    
    local vanilla_planet_lookup = {}
    for _, key in ipairs(planet_cards) do
        vanilla_planet_lookup[key] = true
    end
    
    local vanilla_spectral_lookup = {}
    for _, key in ipairs(spectral_cards) do
        vanilla_spectral_lookup[key] = true
    end
    
    -- Helper function to determine mod name with better detection
    local function determine_mod_name(key, center)
        -- Method 1: Direct mod_name in center
        if center and center.mod_name then
            return center.mod_name
        end
        
        -- Method 2: Check SMODS registrations
        if SMODS then
            -- Check various SMODS collections
            local collections = {
                {SMODS.Jokers, "Joker"},
                {SMODS.Consumables, "Consumable"},
                {SMODS.Vouchers, "Voucher"},
                {SMODS.Centers, "Center"},
                {SMODS.Tags, "Tag"}
            }
            
            for _, collection in ipairs(collections) do
                local smods_collection, type_name = collection[1], collection[2]
                if smods_collection and smods_collection[key] then
                    local item = smods_collection[key]
                    if item.mod_name then return item.mod_name end
                    if item.mod then
                        if type(item.mod) == "string" then return item.mod end
                        if type(item.mod) == "table" then
                            return item.mod.name or item.mod.id or item.mod.mod_id
                        end
                    end
                    if item.from_mod then return item.from_mod end
                end
            end
        end
        
        -- Method 3: Check loaded mods for matching prefixes
        if SMODS and SMODS.Mods then
            for mod_id, mod_data in pairs(SMODS.Mods) do
                if mod_data.prefix and key:find("^" .. mod_data.prefix .. "_") then
                    return mod_data.name or mod_id
                end
            end
        end
        
        -- Method 4: Enhanced pattern matching with known prefixes
        local prefix_patterns = {
            {"^j_mmc_", "Mika's Mod Collection"},
            {"^j_poke_", "Pokermon"},
            {"^j_jen_", "Jen's Jokers"},
            {"^j_cry_", "Cryptid"},
            {"^j_bunc_", "Bunco"},
            {"^j_oiim_", "OIIM"},
            {"^j_balatro_", "Balatro Plus"},
            {"^j_lobc_", "Lobotomy Corporation"},
            {"^j_ssj_", "Super Saiyan Jokers"},
            {"^j_food_", "Food Jokers"},
            {"^j_six_", "SixSuits"},
            {"^j_ortalab_", "Ortalab"},
            {"^v_mmc_", "Mika's Mod Collection"},
            {"^v_poke_", "Pokermon"},
            {"^v_cry_", "Cryptid"},
            {"^v_bunc_", "Bunco"},
            {"^c_mmc_", "Mika's Mod Collection"},
            {"^c_poke_", "Pokermon"},
            {"^c_cry_", "Cryptid"},
            {"^c_bunc_", "Bunco"},
            {"^tag_mmc_", "Mika's Mod Collection"},
            {"^tag_poke_", "Pokermon"},
            {"^tag_cry_", "Cryptid"},
            {"^tag_bunc_", "Bunco"},
            {"^b_mmc_", "Mika's Mod Collection"},
            {"^b_poke_", "Pokermon"},
            {"^b_cry_", "Cryptid"},
            {"^b_bunc_", "Bunco"},
            {"^p_mmc_", "Mika's Mod Collection"},
            {"^p_poke_", "Pokermon"},
            {"^p_cry_", "Cryptid"},
            {"^p_bunc_", "Bunco"},
            {"^mp_", "Multiplayer"}
        }
        
        for _, pattern in ipairs(prefix_patterns) do
            if key:find(pattern[1]) then
                return pattern[2]
            end
        end
        
        -- If we still can't determine, at least group by prefix
        local prefix = key:match("^([^_]+)_")
        if prefix and prefix ~= "j" and prefix ~= "v" and prefix ~= "c" and prefix ~= "tag" then
            return prefix:upper() .. " Mod"
        end
        
        return "Other Mods"  -- Better than "Unknown Mod"
    end
    
    -- Scan through all centers in the game
    if G.P_CENTERS then
        for key, center in pairs(G.P_CENTERS) do
            local mod_name = determine_mod_name(key, center)
            
            -- Check for modded jokers
            if center.set == 'Joker' and not vanilla_joker_lookup[key] then
                table.insert(all_modded_jokers, key)
                if not modded_jokers_by_mod[mod_name] then
                    modded_jokers_by_mod[mod_name] = {}
                end
                table.insert(modded_jokers_by_mod[mod_name], key)
                
            -- Check for modded vouchers
            elseif center.set == 'Voucher' and not vanilla_voucher_lookup[key] then
                table.insert(all_modded_vouchers, key)
                if not modded_vouchers_by_mod[mod_name] then
                    modded_vouchers_by_mod[mod_name] = {}
                end
                table.insert(modded_vouchers_by_mod[mod_name], key)
                
            -- Check for modded tarots
            elseif center.set == 'Tarot' and not vanilla_tarot_lookup[key] then
                table.insert(all_modded_tarots, key)
                if not modded_tarots_by_mod[mod_name] then
                    modded_tarots_by_mod[mod_name] = {}
                end
                table.insert(modded_tarots_by_mod[mod_name], key)
                
            -- Check for modded planets
            elseif center.set == 'Planet' and not vanilla_planet_lookup[key] then
                table.insert(all_modded_planets, key)
                if not modded_planets_by_mod[mod_name] then
                    modded_planets_by_mod[mod_name] = {}
                end
                table.insert(modded_planets_by_mod[mod_name], key)
                
            -- Check for modded spectrals
            elseif center.set == 'Spectral' and not vanilla_spectral_lookup[key] then
                table.insert(all_modded_spectrals, key)
                if not modded_spectrals_by_mod[mod_name] then
                    modded_spectrals_by_mod[mod_name] = {}
                end
                table.insert(modded_spectrals_by_mod[mod_name], key)
            end
        end
    end
    
	-- Check for other modded consumables (not tarot/planet/spectral)
    local other_consumable_types = {}
    if G.P_CENTERS then
        for key, center in pairs(G.P_CENTERS) do
            if center.set and center.set ~= 'Tarot' and center.set ~= 'Planet' and center.set ~= 'Spectral' and 
               center.set ~= 'Joker' and center.set ~= 'Voucher' and center.set ~= 'Back' and
               center.set ~= 'Enhanced' and center.set ~= 'Edition' and center.set ~= 'Seal' and
               center.consumeable then
                -- It's a modded consumable type
                local mod_name = determine_mod_name(key, center)
                local consumable_type = center.set
                
                -- Track the consumable type
                other_consumable_types[consumable_type] = true
                
                -- Initialize structures if needed
                if not modded_other_consumables_by_mod[mod_name] then
                    modded_other_consumables_by_mod[mod_name] = {}
                end
                if not modded_other_consumables_by_mod[mod_name][consumable_type] then
                    modded_other_consumables_by_mod[mod_name][consumable_type] = {}
                end
                
                -- Add to collections
                table.insert(all_modded_other_consumables, key)
                table.insert(modded_other_consumables_by_mod[mod_name][consumable_type], key)
            end
        end
    end
	
    -- Check for modded tags
    if G.P_TAGS then
        for key, tag in pairs(G.P_TAGS) do
            if not vanilla_tag_lookup[key] then
                table.insert(all_modded_tags, key)
                local mod_name = determine_mod_name(key, tag)
                if not modded_tags_by_mod[mod_name] then
                    modded_tags_by_mod[mod_name] = {}
                end
                table.insert(modded_tags_by_mod[mod_name], key)
            end
        end
    end
    
    -- Sort everything
    for mod_name, items in pairs(modded_jokers_by_mod) do table.sort(items) end
    for mod_name, items in pairs(modded_vouchers_by_mod) do table.sort(items) end
    for mod_name, items in pairs(modded_tags_by_mod) do table.sort(items) end
    for mod_name, items in pairs(modded_tarots_by_mod) do table.sort(items) end
    for mod_name, items in pairs(modded_planets_by_mod) do table.sort(items) end
    for mod_name, items in pairs(modded_spectrals_by_mod) do table.sort(items) end
    
    table.sort(all_modded_jokers)
    table.sort(all_modded_vouchers)
    table.sort(all_modded_tags)
    table.sort(all_modded_tarots)
    table.sort(all_modded_planets)
    table.sort(all_modded_spectrals)
	for mod_name, types in pairs(modded_other_consumables_by_mod) do 
        for type_name, items in pairs(types) do
            table.sort(items)
        end
    end
    table.sort(all_modded_other_consumables)
    
end

-- Dynamic prefix detection system
local detected_prefixes = {}

-- Function to detect prefixes for all mods
local function detect_mod_prefixes()
    detected_prefixes = {}
    
    -- Helper function to find COMMON STARTING PATTERNS
    local function find_common_prefixes(items)
        if #items < 2 then return {} end
        
        local prefix_counts = {}
        local word_counts = {}
        
        -- First pass: count individual words that appear at the start
        for _, item in ipairs(items) do
            -- Remove game prefixes first to analyze the mod part
            local cleaned = item:gsub("^[jvctagpb]_", "")
            
            -- Look for words at the beginning (before underscore, dash, or camelCase)
            -- Match lowercase followed by uppercase (camelCase)
            for word in cleaned:gmatch("^(%l+)[_%-A-Z]") do
                word_counts[word] = (word_counts[word] or 0) + 1
            end
            -- Also match word followed by underscore or dash
            for word in cleaned:gmatch("^(%w+)[_%-]") do
                word_counts[word] = (word_counts[word] or 0) + 1
            end
        end
        
        -- Second pass: count full prefixes (word + separator)
        for _, item in ipairs(items) do
            -- Look for complete prefixes with separators
            for len = 3, math.min(20, #item - 1) do
                local potential_prefix = item:sub(1, len)
                -- Only count if it ends with _ or -
                if potential_prefix:match("[_%-]$") then
                    prefix_counts[potential_prefix] = (prefix_counts[potential_prefix] or 0) + 1
                end
            end
        end
        
        -- Find common words (appear in at least 30% of items)
        local common_words = {}
        local threshold = math.max(2, math.floor(#items * 0.3))
        
        for word, count in pairs(word_counts) do
            if count >= threshold then
                common_words[word] = true
            end
        end
        
        -- Build final prefix list
        local valid_prefixes = {}
        local seen = {}
        
        -- Add full prefixes that are common
        for prefix, count in pairs(prefix_counts) do
            if count >= threshold and not seen[prefix] then
                table.insert(valid_prefixes, prefix)
                seen[prefix] = true
            end
        end
        
        -- Add common words as prefixes (with both _ and - variants)
        for word, _ in pairs(common_words) do
            if not seen[word .. "_"] then
                table.insert(valid_prefixes, word .. "_")
                seen[word .. "_"] = true
            end
            if not seen[word .. "-"] then
                table.insert(valid_prefixes, word .. "-")
                seen[word .. "-"] = true
            end
            -- Also add just the word for camelCase
            if not seen[word] then
                table.insert(valid_prefixes, word)
                seen[word] = true
            end
        end
        
        -- Sort by length (longest first)
        table.sort(valid_prefixes, function(a, b)
            return #a > #b
        end)
        
        return valid_prefixes
    end
    
    -- Process each mod's items
    for mod_name, jokers in pairs(modded_jokers_by_mod) do
        local prefixes = find_common_prefixes(jokers)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].joker = prefixes
        end
    end
    
    for mod_name, vouchers in pairs(modded_vouchers_by_mod) do
        local prefixes = find_common_prefixes(vouchers)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].voucher = prefixes
        end
    end
    
    for mod_name, tags in pairs(modded_tags_by_mod) do
        local prefixes = find_common_prefixes(tags)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].tag = prefixes
        end
    end
    
    for mod_name, tarots in pairs(modded_tarots_by_mod) do
        local prefixes = find_common_prefixes(tarots)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].tarot = prefixes
        end
    end
    
    for mod_name, planets in pairs(modded_planets_by_mod) do
        local prefixes = find_common_prefixes(planets)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].planet = prefixes
        end
    end
    
    for mod_name, spectrals in pairs(modded_spectrals_by_mod) do
        local prefixes = find_common_prefixes(spectrals)
        if #prefixes > 0 then
            detected_prefixes[mod_name] = detected_prefixes[mod_name] or {}
            detected_prefixes[mod_name].spectral = prefixes
        end
    end
end

-- Update the refresh function
local function refresh_modded_content()
    detect_all_modded_content()
    detect_mod_prefixes()  -- Add this line
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

-- Edition options for jokers (includes negative)
local joker_edition_options = {
    {key = 'base', name = 'Base'},
    {key = 'foil', name = 'Foil'},
    {key = 'holo', name = 'Holographic'},
    {key = 'polychrome', name = 'Polychrome'},
    {key = 'negative', name = 'Negative'}
}

-- Edition options for cards (no negative)
local card_edition_options = {
    {key = 'base', name = 'Base'},
    {key = 'foil', name = 'Foil'},
    {key = 'holo', name = 'Holographic'},
    {key = 'polychrome', name = 'Polychrome'}
}

-- Default to card editions for compatibility
local edition_options = card_edition_options


-- Function to detect and categorize all modded jokers
local function detect_modded_jokers()
    modded_jokers_by_mod = {}
    all_modded_jokers = {}
    
    -- First, create a lookup table of vanilla jokers
    local vanilla_lookup = {}
    for _, joker_key in ipairs(available_jokers) do
        vanilla_lookup[joker_key] = true
    end
    
    -- Scan through all jokers in the game
    if G.P_CENTERS then
        for key, center in pairs(G.P_CENTERS) do
            -- Check if it's a joker and not vanilla
            if center.set == 'Joker' and not vanilla_lookup[key] then
                -- It's a modded joker!
                table.insert(all_modded_jokers, key)
                
                -- Try to determine which mod it's from
                local mod_name = "Unknown Mod"
                
                -- Method 1: Check if it has mod_name in the center data
                if center.mod_name then
                    mod_name = center.mod_name
                    
                -- Method 2: Check SMODS registration
                elseif SMODS and SMODS.Jokers and SMODS.Jokers[key] then
                    if SMODS.Jokers[key].mod_name then
                        mod_name = SMODS.Jokers[key].mod_name
                    elseif SMODS.Jokers[key].mod then
                        mod_name = SMODS.Jokers[key].mod.name or SMODS.Jokers[key].mod.id or mod_name
                    end
                    
                -- Method 3: Pattern matching for known prefixes
                elseif key:find("j_mmc_") then
                    mod_name = "Mika's Mod Collection"
                elseif key:find("j_poke_") then
                    mod_name = "Pokermon"
                elseif key:find("j_jen_") then
                    mod_name = "Jen's Jokers"
                elseif key:find("j_cry_") then
                    mod_name = "Cryptid"
                -- Add more patterns as needed
                end
                
                -- Add to categorized list
                if not modded_jokers_by_mod[mod_name] then
                    modded_jokers_by_mod[mod_name] = {}
                end
                table.insert(modded_jokers_by_mod[mod_name], key)
            end
        end
    end
    
    -- Sort the jokers within each mod
    for mod_name, jokers in pairs(modded_jokers_by_mod) do
        table.sort(jokers)
    end
    
    -- Sort all modded jokers
    table.sort(all_modded_jokers)
    
    print("ZokersModMenu: Detected " .. #all_modded_jokers .. " modded jokers from " .. 
          table_length(modded_jokers_by_mod) .. " mods")
end


-- Replace the old detect_modded_jokers() call with:
detect_all_modded_content()
detect_mod_prefixes()  -- Add this line

-- Current enhancement/seal/edition selection - ensure proper initialization
mod.config.current_enhancement = mod.config.current_enhancement or 'base'
mod.config.current_seal = mod.config.current_seal or 'none'
mod.config.current_edition = mod.config.current_edition or 'base'

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
-- In Game:start_run, move the is_loaded_save check BEFORE the should_skip_animations logic:

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
    
    -- IMPORTANT: Check if this is a loaded save FIRST
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
    
    -- Skip animations during initial setup if we have starting items
    local should_skip_animations = (
        (mod.config.use_starting_items and (
            #mod.config.starting_jokers > 0 or 
            #mod.config.starting_vouchers > 0 or 
            #mod.config.starting_tags > 0
        )) or
        (mod.config.use_custom_deck and #mod.config.custom_deck > 0)
    )
    
    if should_skip_animations then
        -- Store original settings
        mod._original_gamespeed = G.SETTINGS.GAMESPEED
        mod._animation_restore_pending = true
        
        -- Set everything to instant
        G.SETTINGS.GAMESPEED = 1000  -- Super high speed
        
        print("ZokersModMenu: Skipping animations for faster setup (speed: 1000), will restore after blind selection")
    end
    
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
                    for _, joker_data in ipairs(mod.config.starting_jokers) do
                        local joker_key = type(joker_data) == "string" and joker_data or joker_data.key
                        local edition = type(joker_data) == "table" and joker_data.edition or 'base'
                        
                        if G.P_CENTERS[joker_key] then
                            local card = Card(G.jokers.T.x, G.jokers.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[joker_key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            if card then
                                -- Apply edition
                                if edition ~= 'base' then
                                    card:set_edition({[edition] = true})
                                end
                                card:add_to_deck()
                                G.jokers:emplace(card)
                                print("ZokersModMenu: Added joker " .. joker_key .. " with " .. edition .. " edition")
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

    -- Apply starting vouchers if enabled - with the fixed version
    if mod.config.use_starting_items and #mod.config.starting_vouchers > 0 then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                -- Ensure used_vouchers table exists
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                
                for _, voucher_key in ipairs(mod.config.starting_vouchers) do
                    if G.P_CENTERS[voucher_key] then
                        -- Create a temporary card to properly redeem the voucher
                        local voucher_card = Card(0, 0, G.CARD_W*0.7, G.CARD_H*0.7, nil, G.P_CENTERS[voucher_key])
                        
                        -- Set the cost to 0 BEFORE redeeming
                        voucher_card.cost = 0
                        voucher_card.ability.extra_cost = 0
                        
                        -- Store the redeem function
                        local original_redeem = voucher_card.redeem
                        
                        -- Override redeem to prevent money changes
                        voucher_card.redeem = function(self)
                            local saved_dollars = G.GAME.dollars
                            original_redeem(self)
                            G.GAME.dollars = saved_dollars
                        end
                        
                        voucher_card:redeem()
                        
                        -- Ensure it's marked as used
                        G.GAME.used_vouchers[voucher_key] = true
                        
                        -- Clean up the temporary card
                        voucher_card:remove()
                        
                        print("ZokersModMenu: Applied starting voucher " .. voucher_key)
                    end
                end
                
                -- Force UI update
                if G.GAME.ROOM then
                    G.GAME.ROOM:update_shop_text()
                end
                
                print("ZokersModMenu: Applied " .. #mod.config.starting_vouchers .. " starting vouchers")
                return true
            end
        }))
    end

    -- Restore animations after all items are applied
    if should_skip_animations then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.0,
            func = function()
                -- Don't restore here anymore - wait for blind selection
                print("ZokersModMenu: Speed restoration will happen on blind selection")
                return true
            end
        }))
    end
end

-- Fix for overstock vouchers - ensure shop slots are properly set
local ref_create_shop = create_shop
create_shop = function(dt)
    -- Ensure used_vouchers exists
    if G.GAME then
        G.GAME.used_vouchers = G.GAME.used_vouchers or {}
        
        -- Apply overstock vouchers before shop creation
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

-- Hook blind selection to restore animation speed
local ref_select_blind = G.FUNCS.select_blind
G.FUNCS.select_blind = function(e)
    -- Check if we need to restore animation speed
    if mod._animation_restore_pending and mod._original_gamespeed then
        G.SETTINGS.GAMESPEED = mod._original_gamespeed
        mod._animation_restore_pending = false
        mod._original_gamespeed = nil
        print("ZokersModMenu: Animation speed restored to " .. G.SETTINGS.GAMESPEED)
    end
    
    -- Call original function
    if ref_select_blind then
        return ref_select_blind(e)
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

-- Fix for deck display with 0 cards of any suit - More comprehensive version
-- Hook the deck viewing to prevent crashes with custom decks
local original_deck_view = G.UIDEF.deck_view_deck
if original_deck_view then
    G.UIDEF.deck_view_deck = function(unplayed_only)
        -- Safety check for custom decks with missing suits
        if G.playing_cards then
            -- Ensure all card data is valid
            for _, card in ipairs(G.playing_cards) do
                if card and not card.base then
                    card.base = card.config and card.config.center and card.config.center.base or {suit = 'S', value = 'A'}
                end
            end
        end
        
        -- Wrap the original function in error handling
        local success, result = pcall(original_deck_view, unplayed_only)
        if not success then
            print("ZokersModMenu: Deck view error caught, showing simple view")
            -- Return a simple deck display if the complex one fails
            local deck_text = "Custom Deck"
            if G.playing_cards then
                deck_text = deck_text .. ": " .. #G.playing_cards .. " cards"
            end
            
            return {
                n = G.UIT.ROOT,
                config = {align = "cm", colour = G.C.CLEAR},
                nodes = {
                    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                        {n = G.UIT.T, config = {text = deck_text, scale = 0.6, colour = G.C.WHITE}}
                    }},
                    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                        {n = G.UIT.T, config = {text = "Click cards to see details", scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                    }}
                }
            }
        end
        return result
    end
end

-- Also hook create_tabs to prevent the specific crash
local original_create_tabs = create_tabs
if original_create_tabs then
    create_tabs = function(args)
        -- Special handling for deck tabs
        if args and args.tabs then
            for _, tab in ipairs(args.tabs) do
                if tab.tab_definition_function then
                    local original_func = tab.tab_definition_function
                    tab.tab_definition_function = function(...)
                        local success, result = pcall(original_func, ...)
                        if not success then
                            print("ZokersModMenu: Tab function error caught")
                            return {
                                n = G.UIT.ROOT,
                                config = {align = "cm", colour = G.C.CLEAR},
                                nodes = {{
                                    n = G.UIT.T,
                                    config = {text = "Custom Deck View", scale = 0.5, colour = G.C.WHITE}
                                }}
                            }
                        end
                        return result
                    end
                end
            end
        end
        return original_create_tabs(args)
    end
end

-- Hook to ensure G.GAME.starting_deck_size exists
local ref_Game_init_game_object = Game.init_game_object
function Game:init_game_object()
    local ret = ref_Game_init_game_object(self)
    -- Ensure starting_deck_size is set
    if ret and ret.starting_deck_size == nil then
        ret.starting_deck_size = 52
    end
    return ret
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

-- Hook to ensure vouchers display in run info
local ref_get_vouchers = G.UIDEF.run_info_vouchers
G.UIDEF.run_info_vouchers = function()
    if G.GAME and G.GAME.used_vouchers then
        local voucher_nodes = {}
        local voucher_list = {}
        
        -- Collect and sort vouchers
        for voucher_key, _ in pairs(G.GAME.used_vouchers) do
            if G.P_CENTERS[voucher_key] then
                table.insert(voucher_list, voucher_key)
            end
        end
        
        -- Sort alphabetically by name
        table.sort(voucher_list, function(a, b)
            local name_a = G.P_CENTERS[a].name or a
            local name_b = G.P_CENTERS[b].name or b
            return name_a < name_b
        end)
        
        -- Create nodes for each voucher
        for _, voucher_key in ipairs(voucher_list) do
            table.insert(voucher_nodes, {
                n = G.UIT.C,
                config = {align = "cm", padding = 0.05},
                nodes = {
                    {n = G.UIT.O, config = {object = DynaText({string = G.P_CENTERS[voucher_key].name or voucher_key, colours = {G.C.WHITE}, scale = 0.4})}}
                }
            })
        end
        
        if #voucher_nodes > 0 then
            return {
                n = G.UIT.R,
                config = {align = "cm", padding = 0.05},
                nodes = voucher_nodes
            }
        end
    end
    
    -- Fallback to original function if it exists
    if ref_get_vouchers then
        return ref_get_vouchers()
    end
    
    return {n=G.UIT.R, config={align = "cm"}, nodes={}}
end

print("ZokersModMenu v2.1.0 loaded successfully!")
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_money", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 1, 0, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_hands", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.4, 0.6, 1, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_discards", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.4, 0.4, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_hand_size", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.8, 0.4, 1, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_hand_levels", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {0.2, 0.8, 0.8, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_joker_slots", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.5, 0.8, 1}, outline = 1}, 
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
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_click_consumable_slots", hover = true, minw = 2, minh = 0.8, colour = {0.1, 0.1, 0.1, 1}, r = 0.05, outline_colour = {1, 0.6, 0.2, 1}, outline = 1}, 
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
    local suit_names = {'Spad', 'Hear', 'Diam', 'Club'}
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
    for _, edition in ipairs(card_edition_options) do
        if edition.key == mod.config.current_edition then
            current_edition_name = edition.name
            break
        end
    end
    
    -- Get button colors
    local enhancement_color = enhancement_colors[mod.config.current_enhancement] or {0.3, 0.3, 0.3, 1}
    local seal_color = seal_colors[mod.config.current_seal] or {0.3, 0.3, 0.3, 1}
    local edition_color = edition_colors[mod.config.current_edition] or {0.3, 0.3, 0.3, 1}
    
    local deck_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "DECK BUILDER", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Deck info
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Deck: " .. mod.config.current_deck_name, scale = 0.5, colour = {1, 1, 1, 1}}}}},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = "Size: " .. tostring(#mod.config.custom_deck) .. "/104 cards", scale = 0.5, colour = {1, 1, 1, 1}}}}},
        
		-- Instructions
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = "Click to add, Shift+Click to remove", scale = 0.35, colour = {0.7, 0.7, 0.7, 1}}}}},
		 
		-- Instructions
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
         nodes = {{n = G.UIT.T, config = {text = "Make sure to have at least one of every suit", scale = 0.35, colour = {0.7, 0.7, 0.7, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}},
		
        -- Enhancement/Seal/Edition controls - uniform buttons
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_enhancement", hover = true, minw = 3.2, minh = 1, colour = enhancement_color, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Enhancement: " .. current_enhancement_name, scale = 0.4, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_seal", hover = true, minw = 3.2, minh = 1, colour = seal_color, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Seal: " .. current_seal_name, scale = 0.4, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_edition", hover = true, minw = 6.5, minh = 1, colour = edition_color, r = 0.1}, 
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
            
            -- Smart text sizing for deck builder
            local text_scale = 0.3
            local display_text = button_text
            
            -- For deck builder, scale down if count makes it too long
            if #display_text > 4 then
                text_scale = text_scale * (4 / #display_text)
                if text_scale < 0.2 then
                    text_scale = 0.2
                end
            end
            
            table.insert(suit_row.nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.02,
                    button = "cs_add_card",
                    ref_table = {rank = rank, suit = suit},
                    hover = true,
                    minw = 0.7,  -- Fixed width
                    minh = 0.5,  -- Fixed height
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_text, scale = text_scale, colour = G.C.WHITE}}
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


-- Get the mod name for this item
local item_mod_name = nil
if current_tab == "modded" then
    if is_joker_menu then
        item_mod_name = current_mod_tab
    elseif is_tarot_menu then
        item_mod_name = current_mod_tab
    elseif is_planet_menu then
        item_mod_name = current_mod_tab
    elseif is_spectral_menu then
        item_mod_name = current_mod_tab
    elseif is_voucher_menu then
        item_mod_name = current_mod_tab
    elseif is_tag_menu then
        item_mod_name = current_mod_tab
    end
elseif mod.config.give_type == "modded_consumable" then
    -- For modded consumables, always use the stored mod name
    item_mod_name = mod.config.current_mod_name
end

-- Helper function to format names for display
local function format_name(name, mod_name)
    if type(name) ~= "string" then
        return tostring(name)
    end
    
    local display_name = name
    
    -- First, check if this is a key and we can get the actual name from game data
    if G.P_CENTERS and G.P_CENTERS[name] and G.P_CENTERS[name].name then
        display_name = G.P_CENTERS[name].name
    elseif G.P_TAGS and G.P_TAGS[name] and G.P_TAGS[name].name then
        display_name = G.P_TAGS[name].name
    end
    
    -- Now clean the display name
    local cleaned = display_name
    
    -- First, always remove standard game prefixes from keys
    if display_name == name then
        -- This is a key, not a display name
        cleaned = cleaned:gsub("^j_", "")
        cleaned = cleaned:gsub("^v_", "")
        cleaned = cleaned:gsub("^c_", "")
        cleaned = cleaned:gsub("^tag_", "")
        cleaned = cleaned:gsub("^p_", "")
        cleaned = cleaned:gsub("^b_", "")
    end
    
    -- Use detected prefixes to clean up
    if mod_name and detected_prefixes[mod_name] then
        -- Extract mod-specific prefixes to remove
        local prefixes_to_remove = {}
        
        -- Get prefixes from detection
        for item_type, prefixes in pairs(detected_prefixes[mod_name]) do
            for _, prefix in ipairs(prefixes) do
                -- Extract the mod part (e.g., "cry_" from "j_cry_")
                local mod_part = prefix:gsub("^[jvctagpb]_", "")
                prefixes_to_remove[mod_part] = true
                prefixes_to_remove[prefix] = true
            end
        end
        
        -- Apply all prefixes
        for prefix, _ in pairs(prefixes_to_remove) do
            local old_cleaned = cleaned
            
            -- Try exact match
            cleaned = cleaned:gsub("^" .. prefix:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"), "")
            
            -- Try case variations
            if cleaned == old_cleaned then
                -- Try lowercase
                local lower_pattern = "^" .. prefix:lower():gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
                if cleaned:lower():sub(1, #prefix) == prefix:lower() then
                    cleaned = cleaned:sub(#prefix + 1)
                end
            end
        end
    end
    
    -- FALLBACK: Known common prefixes that might be missed
    local common_prefixes = {
        -- With separators
        "cry%-", "cry_", "cry ", "Cry%-", "Cry_", "Cry ",
        "garb%-", "garb_", "garb ", "Garb%-", "Garb_", "Garb ",
        "jojo%-", "jojo_", "jojo ", "Jojo%-", "Jojo_", "Jojo ",
        "mp%-", "mp_", "mp ", "Mp%-", "Mp_", "Mp ",
        "poke%-", "poke_", "poke ", "Poke%-", "Poke_", "Poke ",
        "bunc%-", "bunc_", "bunc ", "Bunc%-", "Bunc_", "Bunc ",
        "mmc%-", "mmc_", "mmc ", "Mmc%-", "Mmc_", "Mmc ",
        -- JoJo specific patterns
        "jojo_stand_", "jojo_Stand_", "Jojo_stand_", "Jojo_Stand_",
        "jojo_requiem_", "jojo_Requiem_", "Jojo_requiem_", "Jojo_Requiem_",
        "jojoStand", "JojoStand", "jojoRequiem", "JojoRequiem",
        -- Common suffixes
        " Stand", " stand", " Requiem", " requiem",
        -- Single letters that are leftovers
        "^Y ", "^G ", "^E ",
        -- Special cases
        "^cry m$", "^cry M$", "^cryptid"
    }
    
    -- Apply fallback prefixes
    for _, prefix in ipairs(common_prefixes) do
        cleaned = cleaned:gsub(prefix, "")
    end
    
    -- Clean up any remaining single letters at start
    cleaned = cleaned:gsub("^%u%s+", "")  -- Capital letter + space
    cleaned = cleaned:gsub("^%l%s+", "")  -- Lowercase letter + space
    
    -- Final cleanup
    cleaned = cleaned:gsub("_", " "):gsub("%-", " ")
    cleaned = cleaned:gsub("^%s+", ""):gsub("%s+$", "")
    
    -- If we removed everything or left with very short string, use original
    if cleaned == "" or #cleaned < 2 then
        cleaned = display_name:gsub("_", " "):gsub("%-", " ")
    end
    
    -- Capitalize if it was a key
    if display_name == name then
        cleaned = cleaned:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    end
    
    return cleaned
end

-- Helper function to sort items by their display names
local function sort_by_display_name(items, mod_name)
    -- Create a table with both key and display name
    local items_with_names = {}
    for _, item in ipairs(items) do
        local display_name = format_name(item, mod_name)
        table.insert(items_with_names, {
            key = item,
            display_name = display_name
        })
    end
    
    -- Sort by display name (case-insensitive)
    table.sort(items_with_names, function(a, b)
        -- Convert to lowercase for comparison to ensure proper alphabetical order
        local name_a = a.display_name:lower()
        local name_b = b.display_name:lower()
        
        
        return name_a < name_b
    end)
    
    -- Extract just the keys in the new order
    local sorted_items = {}
    for _, item in ipairs(items_with_names) do
        table.insert(sorted_items, item.key)
    end
    
    return sorted_items
end

-- Variable to track which joker tab is active
mod.config.active_joker_tab = mod.config.active_joker_tab or "vanilla"
mod.config.mod_page_joker = mod.config.mod_page_joker or 1
mod.config.mod_page_voucher = mod.config.mod_page_voucher or 1
mod.config.mod_page_tag = mod.config.mod_page_tag or 1
mod.config.mod_page_tarot = mod.config.mod_page_tarot or 1
mod.config.mod_page_planet = mod.config.mod_page_planet or 1
mod.config.mod_page_spectral = mod.config.mod_page_spectral or 1

-- Enhanced joker selection menu with dynamic mod detection
local function create_joker_menu()
    -- Refresh modded joker detection
    refresh_modded_content()

    -- Initialize tab tracking
    mod.config.active_joker_tab = mod.config.active_joker_tab or "vanilla"
    -- Default to first mod instead of "all"
if not mod.config.active_mod_tab or mod.config.active_mod_tab == "all" then
    for mod_name, _ in pairs(modded_jokers_by_mod) do
        mod.config.active_mod_tab = mod_name
        break
    end
end
    mod.config.joker_page = mod.config.joker_page or 1
    
    -- Determine current joker list based on active tab
local current_joker_list = available_jokers
local is_modded = false

if mod.config.active_joker_tab == "modded" then
    is_modded = true
    current_joker_list = modded_jokers_by_mod[mod.config.active_mod_tab] or {}
    -- Sort by display name for modded items
    current_joker_list = sort_by_display_name(current_joker_list, mod.config.active_mod_tab)
else
    -- Sort vanilla items too
    current_joker_list = sort_by_display_name(current_joker_list, nil)
end
    
    local current_page = mod.config.joker_page or 1
    local jokers_per_page = 20
    local start_index = (current_page - 1) * jokers_per_page + 1
    local end_index = math.min(start_index + jokers_per_page - 1, #current_joker_list)
    local total_pages = math.ceil(#current_joker_list / jokers_per_page)
    
local joker_nodes = {
    -- Title
    {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING JOKERS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
    -- Instructions
    {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
     nodes = {{n = G.UIT.T, config = {text = "Click to add, Shift+Click to remove", scale = 0.35, colour = {0.7, 0.7, 0.7, 1}}}}
    }
}

-- Edition selection
local current_edition_name = "Base"
for _, edition in ipairs(joker_edition_options) do
    if edition.key == mod.config.starting_joker_edition then
        current_edition_name = edition.name
        break
    end
end

-- Get button color based on edition
local button_color = edition_colors[mod.config.starting_joker_edition] or {0.6, 0.2, 0.8, 1}

table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_starting_joker_edition", hover = true, 
        minw = 4, minh = 0.8, colour = button_color, r = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Edition: " .. current_edition_name, scale = 0.5, colour = G.C.WHITE}}}}
}})
	

-- Always show tabs if modded jokers exist
if table_length(modded_jokers_by_mod) > 0 then
    table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
            colour = mod.config.active_joker_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_switch_to_modded", hover = true, minw = 2.5, minh = 0.8, 
            colour = mod.config.active_joker_tab == "modded" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Modded", scale = 0.5, colour = G.C.WHITE}}}}
    }})
end
    
    -- Add mod-specific tabs if viewing modded jokers
    if is_modded and table_length(modded_jokers_by_mod) > 0 then
        local mod_tabs = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
        
                
-- Individual mod tabs
        local mod_list = {}
        for mod_name, _ in pairs(modded_jokers_by_mod) do
            table.insert(mod_list, mod_name)
        end
        table.sort(mod_list)

        local mods_per_page = 5
        local start_idx = ((mod.config.mod_page_joker or 1) - 1) * mods_per_page + 1
        local end_idx = math.min(start_idx + mods_per_page - 1, #mod_list)
        local total_mod_pages = math.ceil(#mod_list / mods_per_page)

        local mod_tabs = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
        
        -- Left arrow
        if total_mod_pages > 1 then
            table.insert(mod_tabs.nodes, {
                n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                    button = "cs_prev_mod_page_joker", 
                    hover = true, minw = 0.6, minh = 0.6, 
                    colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                nodes = {{n = G.UIT.T, config = {text = "<", scale = 0.4, colour = G.C.WHITE}}}
            })
        else
            -- Spacer
            table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
        end
        
        -- Mod buttons
        for i = start_idx, end_idx do
            local mod_name = mod_list[i]
            if mod_name then
                table.insert(mod_tabs.nodes, {
                    n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                        button = "cs_switch_mod_tab", 
                        ref_table = {mod_name = mod_name},
                        hover = true, minw = 1.8, minh = 0.6, 
                        colour = mod.config.active_mod_tab == mod_name and {0.2, 0.8, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                    nodes = {{n = G.UIT.T, config = {text = string.sub(mod_name, 1, 12), scale = 0.3, colour = G.C.WHITE}}}
                })
            end
        end
        
        -- Right arrow
        if total_mod_pages > 1 then
            table.insert(mod_tabs.nodes, {
                n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                    button = "cs_next_mod_page_joker", 
                    hover = true, minw = 0.6, minh = 0.6, 
                    colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                nodes = {{n = G.UIT.T, config = {text = ">", scale = 0.4, colour = G.C.WHITE}}}
            })
        else
            -- Spacer
            table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
        end
        
        table.insert(joker_nodes, mod_tabs)
end
	

-- Info
table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
)
    
    -- Joker grid
    local joker_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(joker_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local joker_key = current_joker_list[i]
        if joker_key then
            local count = 0
            
            -- Count how many of this joker we have with current edition
            for _, selected in ipairs(mod.config.starting_jokers) do
                if type(selected) == "string" and selected == joker_key then
                    count = count + 1  -- Legacy format
                elseif type(selected) == "table" and selected.key == joker_key and selected.edition == mod.config.starting_joker_edition then
                    count = count + 1
                end
            end
            
            -- Get joker name
            local joker_name = joker_key
            if G.P_CENTERS[joker_key] and G.P_CENTERS[joker_key].name then
                joker_name = G.P_CENTERS[joker_key].name
            else
                joker_name = joker_key
            end
            
            -- Get the mod name for this joker
            local joker_mod_name = nil
            if is_modded then
                joker_mod_name = mod.config.active_mod_tab
            end
            
            -- Always format the name to remove prefixes and capitalize
            joker_name = format_name(joker_name, joker_mod_name)
            
            local display_text = joker_name
            if count > 0 then
                display_text = joker_name .. " (" .. count .. ")"
            end
            
            local button_colour = {0.4, 0.4, 0.8, 1}
            if count > 0 then
                button_colour = {0.6, 0.2, 0.8, 1}
            end
            
-- Smart text sizing
local text_scale = 0.23
local max_chars = 12
local display_name = joker_name
if count > 0 then
    -- Account for count display
    max_chars = max_chars - 3 - string.len(tostring(count))
end

-- Truncate or scale
if #display_name > max_chars then
    -- Try scaling first
    text_scale = text_scale * (max_chars / #display_name)
    if text_scale < 0.15 then
        -- If too small, truncate instead
        display_name = string.sub(display_name, 1, max_chars - 2) .. ".."
        text_scale = 0.23
    end
end

local final_text = display_name
if count > 0 then
    final_text = display_name .. " (" .. count .. ")"
end

table.insert(joker_grid.nodes[#joker_grid.nodes].nodes, {
    n = G.UIT.C,
    config = {
        align = "cm",
        padding = 0.05,
        button = "cs_toggle_joker",
        ref_table = {joker_key = joker_key},
        hover = true,
        minw = 1.6,  -- Fixed width
        minh = 0.7,  -- Fixed height
        colour = button_colour,
        r = 0.05
    },
    nodes = {
        {n = G.UIT.T, config = {text = final_text, scale = text_scale, colour = G.C.WHITE}}
    }
})
        end
    end
    
    table.insert(joker_nodes, joker_grid)
	
	-- Spacer
table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})

    
    -- Spacer
    table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
-- Navigation buttons
if total_pages > 1 then
    table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_joker_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_jokers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_joker_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
    }})
else
    table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_clear_jokers", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}}
    }})
end

table.insert(joker_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
    {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
}})

    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 12, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = joker_nodes
    }
end

-- Voucher selection menu with vanilla/modded tabs
local function create_voucher_menu()
    -- Refresh modded content detection
    refresh_modded_content()
    
    -- Initialize tab tracking
    mod.config.active_voucher_tab = mod.config.active_voucher_tab or "vanilla"
    mod.config.active_voucher_mod_tab = mod.config.active_voucher_mod_tab or nil
    if not mod.config.active_voucher_mod_tab then
        for mod_name, _ in pairs(modded_vouchers_by_mod) do
            mod.config.active_voucher_mod_tab = mod_name
            break
        end
    end
    mod.config.voucher_page = mod.config.voucher_page or 1
    
-- Determine current voucher list based on active tab
local current_voucher_list = available_vouchers
local is_modded = false

if mod.config.active_voucher_tab == "modded" then
    is_modded = true
    current_voucher_list = modded_vouchers_by_mod[mod.config.active_voucher_mod_tab] or {}
    -- Sort by display name
    current_voucher_list = sort_by_display_name(current_voucher_list, mod.config.active_voucher_mod_tab)
else
    -- Sort vanilla items too
    current_voucher_list = sort_by_display_name(current_voucher_list, nil)
end
    
    local current_page = mod.config.voucher_page or 1
    local vouchers_per_page = 20
    local start_index = (current_page - 1) * vouchers_per_page + 1
    local end_index = math.min(start_index + vouchers_per_page - 1, #current_voucher_list)
    local total_pages = math.ceil(#current_voucher_list / vouchers_per_page)
    
local voucher_nodes = {
    -- Title
    {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING VOUCHERS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
    
    -- Instructions
    {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
     nodes = {{n = G.UIT.T, config = {text = "Click to add/remove, Shift+Click to force remove", scale = 0.35, colour = {0.7, 0.7, 0.7, 1}}}}},

    -- Main tabs (Vanilla / Modded) - only show if modded vouchers exist
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}}
}  -- CLOSE THE TABLE HERE!
    
-- Only add tabs if modded vouchers exist
if table_length(modded_vouchers_by_mod) > 0 then
    voucher_nodes[3].nodes = {  -- Now properly modify the table AFTER it's created
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_voucher_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
            colour = mod.config.active_voucher_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_voucher_switch_to_modded", hover = true, minw = 2.5, minh = 0.8, 
            colour = mod.config.active_voucher_tab == "modded" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Modded", scale = 0.5, colour = G.C.WHITE}}}}
    }
    
    -- Add mod-specific tabs if viewing modded vouchers
    if is_modded and table_length(modded_vouchers_by_mod) > 0 then
        -- Get mod list for navigation
        local mod_list = {}
        for mod_name, _ in pairs(modded_vouchers_by_mod) do
            table.insert(mod_list, mod_name)
        end
        table.sort(mod_list)

        local mods_per_page = 5
        local start_idx = ((mod.config.mod_page_voucher or 1) - 1) * mods_per_page + 1
        local end_idx = math.min(start_idx + mods_per_page - 1, #mod_list)
        local total_mod_pages = math.ceil(#mod_list / mods_per_page)

        local mod_tabs = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
        
        -- Left arrow
        if total_mod_pages > 1 then
            table.insert(mod_tabs.nodes, {
                n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                    button = "cs_prev_mod_page_voucher", 
                    hover = true, minw = 0.6, minh = 0.6, 
                    colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                nodes = {{n = G.UIT.T, config = {text = "<", scale = 0.4, colour = G.C.WHITE}}}
            })
        else
            -- Spacer
            table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
        end
        
        -- Mod buttons
        for i = start_idx, end_idx do
            local mod_name = mod_list[i]
            if mod_name then
                -- Smart text sizing for mod tabs
                local text_scale = 0.3
                local max_chars = 12
                local display_name = mod_name
                
                if #display_name > max_chars then
                    text_scale = text_scale * (max_chars / #display_name)
                    if text_scale < 0.2 then
                        display_name = string.sub(display_name, 1, max_chars - 2) .. ".."
                        text_scale = 0.3
                    end
                end
                
                table.insert(mod_tabs.nodes, {
                    n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                        button = "cs_voucher_switch_mod_tab", 
                        ref_table = {mod_name = mod_name},
                        hover = true, minw = 1.8, minh = 0.6, 
                        colour = mod.config.active_voucher_mod_tab == mod_name and {0.2, 0.8, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                    nodes = {{n = G.UIT.T, config = {text = display_name, scale = text_scale, colour = G.C.WHITE}}}
                })
            end
        end
        
        -- Right arrow
        if total_mod_pages > 1 then
            table.insert(mod_tabs.nodes, {
                n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                    button = "cs_next_mod_page_voucher", 
                    hover = true, minw = 0.6, minh = 0.6, 
                    colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                nodes = {{n = G.UIT.T, config = {text = ">", scale = 0.4, colour = G.C.WHITE}}}
            })
        else
            -- Spacer
            table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
        end
        
        table.insert(voucher_nodes, mod_tabs)
    end
end
    
-- Info
table.insert(voucher_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
)
    
    local voucher_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(voucher_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local voucher_key = current_voucher_list[i]
        if voucher_key then
            local is_selected = false
            
            -- Check if this voucher is selected
            for _, selected in ipairs(mod.config.starting_vouchers) do
                if selected == voucher_key then
                    is_selected = true
                    break
                end
            end
            
            local voucher_name = voucher_key
            if G.P_CENTERS[voucher_key] and G.P_CENTERS[voucher_key].name then
                voucher_name = G.P_CENTERS[voucher_key].name
            else
                voucher_name = voucher_key
            end
            
            -- Get the mod name for this voucher
            local voucher_mod_name = is_modded and mod.config.active_voucher_mod_tab or nil
            
            -- Always format the name
            voucher_name = format_name(voucher_name, voucher_mod_name)
            local display_text = voucher_name
            
            -- Always use blue color for selection buttons, purple if selected
            local button_colour = {0.4, 0.4, 0.8, 1}
            if is_selected then
                button_colour = {0.6, 0.2, 0.8, 1}  -- Purple when selected
            end
            
            -- Smart text sizing for uniform buttons
            local text_scale = 0.26
            local max_chars = 15
            local display_name = voucher_name
            
            -- Truncate or scale
            if #display_name > max_chars then
                -- Try scaling first
                text_scale = text_scale * (max_chars / #display_name)
                if text_scale < 0.18 then
                    -- If too small, truncate instead
                    display_name = string.sub(display_name, 1, max_chars - 2) .. ".."
                    text_scale = 0.26
                end
            end
            
            table.insert(voucher_grid.nodes[#voucher_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = "cs_toggle_voucher",
                    ref_table = {voucher_key = voucher_key},
                    hover = true,
                    minw = 1.9,  -- Fixed width
                    minh = 0.7,  -- Fixed height
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_name, scale = text_scale, colour = G.C.WHITE}}
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

-- Tag selection menu with vanilla/modded tabs
local function create_tag_menu()
    -- Refresh modded content detection
    refresh_modded_content()
    
    -- Initialize tab tracking
    mod.config.active_tag_tab = mod.config.active_tag_tab or "vanilla"
    mod.config.active_tag_mod_tab = mod.config.active_tag_mod_tab or nil
    if not mod.config.active_tag_mod_tab then
        for mod_name, _ in pairs(modded_tags_by_mod) do
            mod.config.active_tag_mod_tab = mod_name
            break
        end
    end
    mod.config.tag_page = mod.config.tag_page or 1
    
-- Determine current tag list based on active tab
local current_tag_list = available_tags
local is_modded = false

if mod.config.active_tag_tab == "modded" then
    is_modded = true
    current_tag_list = modded_tags_by_mod[mod.config.active_tag_mod_tab] or {}
    -- Sort by display name
    current_tag_list = sort_by_display_name(current_tag_list, mod.config.active_tag_mod_tab)
else
    -- Sort vanilla items too
    current_tag_list = sort_by_display_name(current_tag_list, nil)
end
    
    local current_page = mod.config.tag_page or 1
    local tags_per_page = 20
    local start_index = (current_page - 1) * tags_per_page + 1
    local end_index = math.min(start_index + tags_per_page - 1, #current_tag_list)
    local total_pages = math.ceil(#current_tag_list / tags_per_page)
    
    local tag_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT STARTING TAGS", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        -- Instructions
    {n = G.UIT.R, config = {align = "cm", padding = 0.05}, 
     nodes = {{n = G.UIT.T, config = {text = "Click to add/remove, Shift+Click to force remove", scale = 0.35, colour = {0.7, 0.7, 0.7, 1}}}}},
        -- Main tabs (Vanilla / Modded) - only show if modded tags exist
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}}
	}
    
-- Only add tabs if modded tags exist
if table_length(modded_tags_by_mod) > 0 then
    tag_nodes[3].nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_tag_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
                colour = mod.config.active_tag_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_tag_switch_to_modded", hover = true, minw = 2.5, minh = 0.8, 
                colour = mod.config.active_tag_tab == "modded" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Modded", scale = 0.5, colour = G.C.WHITE}}}}
        }
        
        -- Add mod-specific tabs if viewing modded tags
        if is_modded and table_length(modded_tags_by_mod) > 0 then
            local mod_tabs = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
            
            local mod_count = 0
            for mod_name, _ in pairs(modded_tags_by_mod) do
                mod_count = mod_count + 1
                if mod_count <= 5 then
                    table.insert(mod_tabs.nodes, {
                        n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                            button = "cs_tag_switch_mod_tab", 
                            ref_table = {mod_name = mod_name},
                            hover = true, minw = 1.8, minh = 0.6, 
                            colour = mod.config.active_tag_mod_tab == mod_name and {0.2, 0.8, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                        nodes = {{n = G.UIT.T, config = {text = string.sub(mod_name, 1, 12), scale = 0.3, colour = G.C.WHITE}}}
                    })
                end
            end
            
            table.insert(tag_nodes, mod_tabs)
        end
    end
   
-- Info
table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Page: " .. current_page .. "/" .. total_pages, scale = 0.5, colour = {1, 1, 1, 1}}}}}
)
    
    -- Tag grid (rest remains the same)
    local tag_grid = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
    
    for i = start_index, end_index do
        if (i - start_index) % 5 == 0 then
            table.insert(tag_grid.nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.02}, nodes = {}})
        end
        
        local tag_key = current_tag_list[i]
        if tag_key then
            local is_selected = false
            
            -- Check if this tag is selected
            for _, selected in ipairs(mod.config.starting_tags) do
                if selected == tag_key then
                    is_selected = true
                    break
                end
            end
            
            local tag_name
            if G.P_TAGS[tag_key] and G.P_TAGS[tag_key].name then
                tag_name = G.P_TAGS[tag_key].name
            else
                tag_name = tag_key
            end
            
            -- Get the mod name for this tag
            local tag_mod_name = is_modded and mod.config.active_tag_mod_tab or nil
            
            -- Always format the name
            tag_name = format_name(tag_name, tag_mod_name)
            
            local button_colour = {0.4, 0.4, 0.8, 1}
            if is_selected then
                button_colour = {0.6, 0.2, 0.8, 1}
            end
            
            -- Smart text sizing for uniform buttons
            local text_scale = 0.26
            local max_chars = 15
            local display_name = tag_name
            
            -- Truncate or scale
            if #display_name > max_chars then
                -- Try scaling first
                text_scale = text_scale * (max_chars / #display_name)
                if text_scale < 0.18 then
                    -- If too small, truncate instead
                    display_name = string.sub(display_name, 1, max_chars - 2) .. ".."
                    text_scale = 0.26
                end
            end
            
            table.insert(tag_grid.nodes[#tag_grid.nodes].nodes, {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.05,
                    button = "cs_toggle_tag",
                    ref_table = {tag_key = tag_key},
                    hover = true,
                    minw = 1.9,  -- Fixed width
                    minh = 0.7,  -- Fixed height
                    colour = button_colour,
                    r = 0.05
                },
                nodes = {
                    {n = G.UIT.T, config = {text = display_name, scale = text_scale, colour = G.C.WHITE}}
                }
            })
        end
    end
    
    table.insert(tag_nodes, tag_grid)
	
    
    -- Spacer
    table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
-- Bottom buttons remain the same...
if total_pages > 1 then
    table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_tag_prev_page", hover = true, minw = 2.5, minh = 1, colour = {0.8, 0.2, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "◀ Previous", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_clear_tags", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}},
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_tag_next_page", hover = true, minw = 2.5, minh = 1, colour = {0.2, 0.8, 0.2, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Next ▶", scale = 0.5, colour = G.C.WHITE}}}}
    }})
else
    table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_clear_tags", hover = true, minw = 2.5, minh = 1, colour = G.C.RED, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Clear All", scale = 0.5, colour = G.C.WHITE}}}}
    }})
end

table.insert(tag_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
    {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_starting_items", hover = true, minw = 2.5, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
     nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
}})
    
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
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_consumable", hover = true, minw = 3, minh = 1, colour = {0.8, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Consumable", scale = 0.5, colour = G.C.WHITE}}}}
        }},
        
        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_joker", hover = true, minw = 3, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Joker", scale = 0.5, colour = G.C.WHITE}}}}
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
			
            -- Always show modded button if any modded consumables exist
            (table_length(modded_other_consumables_by_mod) > 0 or
             table_length(modded_tarots_by_mod) > 0 or
             table_length(modded_planets_by_mod) > 0 or
             table_length(modded_spectrals_by_mod) > 0) and {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_modded_consumable", hover = true, minw = 3, minh = 1, colour = {0.8, 0.5, 0.2, 1}, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Modded", scale = 0.5, colour = G.C.WHITE}}}}
            }} or nil,
            
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
    for _, edition in ipairs(card_edition_options) do
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
    
-- Get button colors
    local give_enhancement_color = enhancement_colors[mod.config.give_card_enhancement] or {0.3, 0.3, 0.3, 1}
    local give_seal_color = seal_colors[mod.config.give_card_seal] or {0.3, 0.3, 0.3, 1}
    local give_edition_color = edition_colors[mod.config.give_card_edition] or {0.3, 0.3, 0.3, 1}
    
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
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_enhancement", hover = true, minw = 4, minh = 1, colour = give_enhancement_color, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Enhancement: " .. current_enhancement_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Seal selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_seal", hover = true, minw = 4, minh = 1, colour = give_seal_color, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Seal: " .. current_seal_name, scale = 0.5, colour = G.C.WHITE}}}}
            }},
            
            -- Edition selection
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.05, button = "cs_cycle_give_edition", hover = true, minw = 4, minh = 1, colour = give_edition_color, r = 0.1}, 
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

-- Generic card selection menu for giving items with full modded support
local function create_card_selection_menu(card_list, title, give_function_name)
    mod.config.give_page = mod.config.give_page or 1
    
    -- Special handling for different menu types
    local is_joker_menu = (give_function_name == "cs_instant_give_joker")
    local is_tarot_menu = (give_function_name == "cs_instant_give_card" and mod.config.give_type == "tarot")
    local is_planet_menu = (give_function_name == "cs_instant_give_card" and mod.config.give_type == "planet")
    local is_spectral_menu = (give_function_name == "cs_instant_give_card" and mod.config.give_type == "spectral")
    local is_voucher_menu = (give_function_name == "cs_instant_give_voucher")
    local is_tag_menu = (give_function_name == "cs_instant_give_tag")
    
    local actual_card_list = card_list
    local show_tabs = false
    local tab_type = nil
    local current_tab = "vanilla"
    local current_mod_tab = nil
    local modded_items_by_mod = {}
    
    -- Refresh modded content
    refresh_modded_content()
    
    -- Handle different card types
    if is_joker_menu then
        tab_type = "joker"
        mod.config.give_joker_tab = mod.config.give_joker_tab or "vanilla"
        mod.config.give_mod_tab = mod.config.give_mod_tab or nil
        if not mod.config.give_mod_tab then
            for mod_name, _ in pairs(modded_jokers_by_mod) do
                mod.config.give_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_joker_tab
        current_mod_tab = mod.config.give_mod_tab
        modded_items_by_mod = modded_jokers_by_mod
        show_tabs = table_length(modded_jokers_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = available_jokers
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_jokers_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
        
    elseif is_tarot_menu then
        tab_type = "tarot"
        mod.config.give_tarot_tab = mod.config.give_tarot_tab or "vanilla"
        mod.config.give_tarot_mod_tab = mod.config.give_tarot_mod_tab or nil
        if not mod.config.give_tarot_mod_tab then
            for mod_name, _ in pairs(modded_tarots_by_mod) do
                mod.config.give_tarot_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_tarot_tab
        current_mod_tab = mod.config.give_tarot_mod_tab
        modded_items_by_mod = modded_tarots_by_mod
        show_tabs = table_length(modded_tarots_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = tarot_cards
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_tarots_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
        
    elseif is_planet_menu then
        tab_type = "planet"
        mod.config.give_planet_tab = mod.config.give_planet_tab or "vanilla"
        mod.config.give_planet_mod_tab = mod.config.give_planet_mod_tab or nil
        if not mod.config.give_planet_mod_tab then
            for mod_name, _ in pairs(modded_planets_by_mod) do
                mod.config.give_planet_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_planet_tab
        current_mod_tab = mod.config.give_planet_mod_tab
        modded_items_by_mod = modded_planets_by_mod
        show_tabs = table_length(modded_planets_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = planet_cards
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_planets_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
        
    elseif is_spectral_menu then
        tab_type = "spectral"
        mod.config.give_spectral_tab = mod.config.give_spectral_tab or "vanilla"
        mod.config.give_spectral_mod_tab = mod.config.give_spectral_mod_tab or nil
        if not mod.config.give_spectral_mod_tab then
            for mod_name, _ in pairs(modded_spectrals_by_mod) do
                mod.config.give_spectral_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_spectral_tab
        current_mod_tab = mod.config.give_spectral_mod_tab
        modded_items_by_mod = modded_spectrals_by_mod
        show_tabs = table_length(modded_spectrals_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = spectral_cards
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_spectrals_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
        
    elseif is_voucher_menu then
        tab_type = "voucher"
        mod.config.give_voucher_tab = mod.config.give_voucher_tab or "vanilla"
        mod.config.give_voucher_mod_tab = mod.config.give_voucher_mod_tab or nil
        if not mod.config.give_voucher_mod_tab then
            for mod_name, _ in pairs(modded_vouchers_by_mod) do
                mod.config.give_voucher_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_voucher_tab
        current_mod_tab = mod.config.give_voucher_mod_tab
        modded_items_by_mod = modded_vouchers_by_mod
        show_tabs = table_length(modded_vouchers_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = available_vouchers
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_vouchers_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
        
    elseif is_tag_menu then
        tab_type = "tag"
        mod.config.give_tag_tab = mod.config.give_tag_tab or "vanilla"
        mod.config.give_tag_mod_tab = mod.config.give_tag_mod_tab or nil
        if not mod.config.give_tag_mod_tab then
            for mod_name, _ in pairs(modded_tags_by_mod) do
                mod.config.give_tag_mod_tab = mod_name
                break
            end
        end
        current_tab = mod.config.give_tag_tab
        current_mod_tab = mod.config.give_tag_mod_tab
        modded_items_by_mod = modded_tags_by_mod
        show_tabs = table_length(modded_tags_by_mod) > 0
        
        if current_tab == "vanilla" then
            actual_card_list = available_tags
            actual_card_list = sort_by_display_name(actual_card_list, nil)
        else
            actual_card_list = modded_tags_by_mod[current_mod_tab] or {}
            actual_card_list = sort_by_display_name(actual_card_list, current_mod_tab)
        end
    end
    
    local current_page = mod.config.give_page or 1
    local cards_per_page = 20
    local start_index = (current_page - 1) * cards_per_page + 1
    local end_index = math.min(start_index + cards_per_page - 1, #actual_card_list)
    local total_pages = math.ceil(#actual_card_list / cards_per_page)
    
    local card_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = title, scale = 0.8, colour = {1, 1, 1, 1}}}}},
    }
	
	-- Add edition selection for joker menu (above tabs)
if is_joker_menu then
    local current_edition_name = "Base"
    for _, edition in ipairs(joker_edition_options) do
        if edition.key == mod.config.give_joker_edition then
            current_edition_name = edition.name
            break
        end
    end
    
    -- Get button color based on edition
    local button_color = edition_colors[mod.config.give_joker_edition] or {0.6, 0.2, 0.8, 1}
    
    table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_cycle_give_joker_edition", hover = true, 
            minw = 4, minh = 0.8, colour = button_color, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Edition: " .. current_edition_name, scale = 0.5, colour = G.C.WHITE}}}}
    }})
end
    
    -- Add tabs if needed
    if show_tabs and tab_type then
        -- Main tabs (Vanilla / Modded)
        table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_" .. tab_type .. "_switch_to_vanilla", hover = true, minw = 2.5, minh = 0.8, 
                colour = current_tab == "vanilla" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Vanilla", scale = 0.5, colour = G.C.WHITE}}}},
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_" .. tab_type .. "_switch_to_modded", hover = true, minw = 2.5, minh = 0.8, 
                colour = current_tab == "modded" and {0.6, 0.2, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Modded", scale = 0.5, colour = G.C.WHITE}}}}
        }})
        
                -- Add mod-specific tabs if viewing modded items
        if current_tab == "modded" and table_length(modded_items_by_mod) > 0 then
            -- Get mod list for navigation
            local mod_list = {}
            for mod_name, _ in pairs(modded_items_by_mod) do
                table.insert(mod_list, mod_name)
            end
            table.sort(mod_list)

            -- Determine which page variable to use based on tab type
            local page_var_name = "give_mod_page_" .. tab_type
            mod.config[page_var_name] = mod.config[page_var_name] or 1
            
            local mods_per_page = 5
            local start_idx = ((mod.config[page_var_name] or 1) - 1) * mods_per_page + 1
            local end_idx = math.min(start_idx + mods_per_page - 1, #mod_list)
            local total_mod_pages = math.ceil(#mod_list / mods_per_page)

            local mod_tabs = {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}}
            
            -- Left arrow
            if total_mod_pages > 1 then
                table.insert(mod_tabs.nodes, {
                    n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                        button = "cs_give_prev_mod_page_" .. tab_type, 
                        hover = true, minw = 0.6, minh = 0.6, 
                        colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                    nodes = {{n = G.UIT.T, config = {text = "<", scale = 0.4, colour = G.C.WHITE}}}
                })
            else
                -- Spacer
                table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
            end
            
            -- Mod buttons
            for i = start_idx, end_idx do
                local mod_name = mod_list[i]
                if mod_name then
                    table.insert(mod_tabs.nodes, {
                        n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                            button = "cs_give_" .. tab_type .. "_switch_mod_tab", 
                            ref_table = {mod_name = mod_name},
                            hover = true, minw = 1.8, minh = 0.6, 
                            colour = current_mod_tab == mod_name and {0.2, 0.8, 0.8, 1} or {0.3, 0.3, 0.3, 1}, r = 0.08}, 
                        nodes = {{n = G.UIT.T, config = {text = string.sub(mod_name, 1, 12), scale = 0.3, colour = G.C.WHITE}}}
                    })
                end
            end
            
            -- Right arrow
            if total_mod_pages > 1 then
                table.insert(mod_tabs.nodes, {
                    n = G.UIT.C, config = {align = "cm", padding = 0.04, 
                        button = "cs_give_next_mod_page_" .. tab_type, 
                        hover = true, minw = 0.6, minh = 0.6, 
                        colour = {0.4, 0.4, 0.4, 1}, r = 0.08}, 
                    nodes = {{n = G.UIT.T, config = {text = ">", scale = 0.4, colour = G.C.WHITE}}}
                })
            else
                -- Spacer
                table.insert(mod_tabs.nodes, {n = G.UIT.C, config = {align = "cm", minw = 0.6, minh = 0.6}, nodes = {}})
            end
            
            table.insert(card_nodes, mod_tabs)
        end
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
        
        local card_key = actual_card_list[i]
        if card_key then
            -- Format name based on type
            local card_name
            local center_or_tag = nil
            
            if give_function_name == "cs_instant_give_card" then
                center_or_tag = G.P_CENTERS[card_key]
            elseif give_function_name == "cs_instant_give_voucher" then
                center_or_tag = G.P_CENTERS[card_key]
            elseif give_function_name == "cs_instant_give_joker" then
                center_or_tag = G.P_CENTERS[card_key]
            elseif give_function_name == "cs_instant_give_tag" then
                center_or_tag = G.P_TAGS[card_key]
            end
            
-- Try to get the name from the game data first
if center_or_tag and center_or_tag.name then
    card_name = center_or_tag.name
else
    card_name = card_key
end

-- Get the mod name for this item
local item_mod_name = nil
if current_tab == "modded" then
    if is_joker_menu then
        item_mod_name = current_mod_tab
    elseif is_tarot_menu then
        item_mod_name = current_mod_tab
    elseif is_planet_menu then
        item_mod_name = current_mod_tab
    elseif is_spectral_menu then
        item_mod_name = current_mod_tab
    elseif is_voucher_menu then
        item_mod_name = current_mod_tab
    elseif is_tag_menu then
        item_mod_name = current_mod_tab
    end
elseif mod.config.give_type == "modded_consumable" then
    -- For modded consumables, always use the stored mod name
    item_mod_name = mod.config.current_mod_name
end

-- Format the name
card_name = format_name(card_name, item_mod_name)
            
            -- Always use blue color for give menus
            local button_colour = {0.4, 0.4, 0.8, 1}
            
-- Smart text sizing for uniform buttons
local text_scale = 0.26
local max_chars = 15
local display_name = card_name

-- Truncate or scale
if #display_name > max_chars then
    -- Try scaling first
    text_scale = text_scale * (max_chars / #display_name)
    if text_scale < 0.18 then
        -- If too small, truncate instead
        display_name = string.sub(display_name, 1, max_chars - 2) .. ".."
        text_scale = 0.26
    end
end

table.insert(card_grid.nodes[#card_grid.nodes].nodes, {
    n = G.UIT.C,
    config = {
        align = "cm",
        padding = 0.05,
        button = give_function_name,
        ref_table = {card_key = card_key},
        hover = true,
        minw = 1.9,  -- Fixed width
        minh = 0.7,  -- Fixed height
        colour = button_colour,
        r = 0.05
    },
    nodes = {
        {n = G.UIT.T, config = {text = display_name, scale = text_scale, colour = G.C.WHITE}}
    }
})
        end
    end
    
    table.insert(card_nodes, card_grid)
	
    
    -- Spacer to push buttons to bottom
    table.insert(card_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {}})
    
    -- Bottom navigation buttons
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
-- Text input click handlers
G.FUNCS.cs_click_money = function(e)
    create_overlay(create_text_input_dialog("Enter Starting Money", mod.config.starting_money, "money"))
end

G.FUNCS.cs_click_hands = function(e)
    create_overlay(create_text_input_dialog("Enter Starting Hands", mod.config.starting_hands, "hands"))
end

G.FUNCS.cs_click_discards = function(e)
    create_overlay(create_text_input_dialog("Enter Starting Discards", mod.config.starting_discards, "discards"))
end

G.FUNCS.cs_click_hand_size = function(e)
    create_overlay(create_text_input_dialog("Enter Hand Size", mod.config.hand_size, "hand_size"))
end

G.FUNCS.cs_click_hand_levels = function(e)
    create_overlay(create_text_input_dialog("Enter Hand Levels", mod.config.hand_levels, "hand_levels"))
end

G.FUNCS.cs_click_joker_slots = function(e)
    create_overlay(create_text_input_dialog("Enter Joker Slots", mod.config.joker_slots, "joker_slots"))
end

G.FUNCS.cs_click_consumable_slots = function(e)
    create_overlay(create_text_input_dialog("Enter Consumable Slots", mod.config.consumable_slots, "consumable_slots"))
end

-- Text input confirmation
G.FUNCS.cs_confirm_text_input = function(e)
    local value = tonumber(mod.text_input_value)
    
    if value and value >= 0 then
        -- Apply the value based on type
        if mod.text_input_type == "money" then
            mod.config.starting_money = math.floor(value)
        elseif mod.text_input_type == "hands" then
            mod.config.starting_hands = math.floor(value)
        elseif mod.text_input_type == "discards" then
            mod.config.starting_discards = math.floor(value)
        elseif mod.text_input_type == "hand_size" then
            mod.config.hand_size = math.floor(value)
        elseif mod.text_input_type == "hand_levels" then
            mod.config.hand_levels = math.max(1, math.floor(value))
        elseif mod.text_input_type == "joker_slots" then
            mod.config.joker_slots = math.floor(value)
        elseif mod.text_input_type == "consumable_slots" then
            mod.config.consumable_slots = math.floor(value)
        end
        
        save_config()
    end
    
    mod.text_input_active = false
    mod.text_input_type = nil
    mod.text_input_value = ""
    create_overlay(create_money_menu())
end

G.FUNCS.cs_cancel_text_input = function(e)
    mod.text_input_active = false
    mod.text_input_type = nil
    mod.text_input_value = ""
    create_overlay(create_money_menu())
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
    if current_index > #card_edition_options then
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

G.FUNCS.cs_give_consumable = function(e)
    -- Force refresh modded content
    refresh_modded_content()
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

-- Modded consumable selection menu
local function create_modded_consumable_menu()
    -- Refresh content
    refresh_modded_content()
    
    local menu_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT MODDED CONSUMABLE TYPE", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
    }
    
    -- Check what types we have
    local has_tarots = table_length(modded_tarots_by_mod) > 0
    local has_planets = table_length(modded_planets_by_mod) > 0
    local has_spectrals = table_length(modded_spectrals_by_mod) > 0
    local has_other = table_length(modded_other_consumables_by_mod) > 0
    
    if has_tarots then
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_modded_tarot", hover = true, minw = 3, minh = 1, colour = {0.6, 0.2, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Modded Tarots", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    if has_planets then
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_modded_planet", hover = true, minw = 3, minh = 1, colour = {0.2, 0.6, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Modded Planets", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    if has_spectrals then
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_modded_spectral", hover = true, minw = 3, minh = 1, colour = {0.4, 0.8, 0.4, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Modded Spectrals", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    if has_other then
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_give_modded_other", hover = true, minw = 3, minh = 1, colour = {0.8, 0.5, 0.2, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Other Modded", scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    -- Back button
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}})
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_consumable_type", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = menu_nodes
    }
end

-- Function to show consumable types for a specific mod
local function create_modded_consumable_types_menu(mod_name)
    local menu_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = mod_name:upper(), scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
    }
    
    -- Check what types this mod has
    local has_types = false
    
    -- ONLY show other consumable types (NOT tarot/planet/spectral)
    if modded_other_consumables_by_mod[mod_name] then
        for type_name, items in pairs(modded_other_consumables_by_mod[mod_name]) do
            if #items > 0 then
                has_types = true
                -- Remove duplicates
                local seen = {}
                local unique_items = {}
                for _, item in ipairs(items) do
                    if not seen[item] then
                        seen[item] = true
                        table.insert(unique_items, item)
                    end
                end
                
                -- Format the type name for display
                local display_type_name = type_name:gsub("_", " "):gsub("^%l", string.upper)
                
                table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_select_modded_type", 
                        ref_table = {mod_name = mod_name, type_name = type_name, type_key = "other", items = unique_items},
                        hover = true, minw = 3, minh = 1, colour = {0.8, 0.5, 0.2, 1}, r = 0.1}, 
                     nodes = {{n = G.UIT.T, config = {text = display_type_name, scale = 0.5, colour = G.C.WHITE}}}}
                }})
            end
        end
    end
    
    if not has_types then
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.T, config = {text = "No special consumables found", scale = 0.5, colour = {0.5, 0.5, 0.5, 1}}}
        }})
    end
    
    -- Back button - goes back to mod list
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}})
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_consumable_type", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = menu_nodes
    }
end

-- Function to list mods with consumables
local function create_modded_consumable_mod_list()
    local menu_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT MOD", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
    }
    
    -- Combine all mods that have any type of modded consumables
    local all_mods = {}
    
    -- Add mods with other consumables
    for mod_name, _ in pairs(modded_other_consumables_by_mod) do
        all_mods[mod_name] = true
    end
    
    -- Add mods with modded tarots/planets/spectrals
    for mod_name, _ in pairs(modded_tarots_by_mod) do
        all_mods[mod_name] = true
    end
    for mod_name, _ in pairs(modded_planets_by_mod) do
        all_mods[mod_name] = true
    end
    for mod_name, _ in pairs(modded_spectrals_by_mod) do
        all_mods[mod_name] = true
    end
    
    -- Sort mod names
    local sorted_mods = {}
    for mod_name, _ in pairs(all_mods) do
        table.insert(sorted_mods, mod_name)
    end
    table.sort(sorted_mods)
    
    -- Create buttons for each mod
    for _, mod_name in ipairs(sorted_mods) do
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_select_modded_consumable_mod", 
                ref_table = {mod_name = mod_name},
                hover = true, minw = 3, minh = 1, colour = {0.6, 0.4, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = mod_name, scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    -- Back button - FIXED to go back to consumable type menu
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}})
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_consumable_type", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = menu_nodes
    }
end

G.FUNCS.cs_give_modded_tarot = function(e)
    mod.config.give_tarot_tab = "modded"
    mod.config.give_type = "tarot"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}, "SELECT MODDED TAROT", "cs_instant_give_card"))
end

G.FUNCS.cs_give_modded_planet = function(e)
    mod.config.give_planet_tab = "modded"
    mod.config.give_type = "planet"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}, "SELECT MODDED PLANET", "cs_instant_give_card"))
end

G.FUNCS.cs_give_modded_spectral = function(e)
    mod.config.give_spectral_tab = "modded"
    mod.config.give_type = "spectral"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}, "SELECT MODDED SPECTRAL", "cs_instant_give_card"))
end

-- Function to list mods with consumables
local function create_modded_consumable_mod_list()
    local menu_nodes = {
        -- Title
        {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "SELECT MOD", scale = 0.8, colour = {1, 1, 1, 1}}}}},
        
        -- Spacing
        {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}},
    }
    
    -- Combine all mods that have any type of modded consumables
    local all_mods = {}
    
    -- Add mods with other consumables
    for mod_name, _ in pairs(modded_other_consumables_by_mod) do
        all_mods[mod_name] = true
    end
    
    -- Add mods with modded tarots/planets/spectrals
    for mod_name, _ in pairs(modded_tarots_by_mod) do
        all_mods[mod_name] = true
    end
    for mod_name, _ in pairs(modded_planets_by_mod) do
        all_mods[mod_name] = true
    end
    for mod_name, _ in pairs(modded_spectrals_by_mod) do
        all_mods[mod_name] = true
    end
    
    -- Sort mod names
    local sorted_mods = {}
    for mod_name, _ in pairs(all_mods) do
        table.insert(sorted_mods, mod_name)
    end
    table.sort(sorted_mods)
    
    -- Create buttons for each mod
    for _, mod_name in ipairs(sorted_mods) do
        table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.08, button = "cs_select_modded_consumable_mod", 
                ref_table = {mod_name = mod_name},
                hover = true, minw = 3, minh = 1, colour = {0.6, 0.4, 0.8, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = mod_name, scale = 0.5, colour = G.C.WHITE}}}}
        }})
    end
    
    -- Back button - FIXED to go back to consumable type menu
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.15}, nodes = {}})
    table.insert(menu_nodes, {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_back_to_consumable_type", hover = true, minw = 3, minh = 1, colour = {0.6, 0.6, 0.6, 1}, r = 0.1}, 
         nodes = {{n = G.UIT.T, config = {text = "Back", scale = 0.5, colour = G.C.WHITE}}}}
    }})
    
    return {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 8, minh = 10, colour = {0, 0, 0, 0.8}, r = 0.1, padding = 0.1},
        nodes = menu_nodes
    }
end

-- When clicking "Modded" in consumable type menu
G.FUNCS.cs_give_modded_consumable = function(e)
    create_overlay(create_modded_consumable_mod_list())
end

-- When selecting a mod, show consumable types for that mod
G.FUNCS.cs_select_modded_consumable_mod = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        -- Store where we came from
        mod.config.came_from_modded = true
        create_overlay(create_modded_consumable_types_menu(mod_name))
    end
end

G.FUNCS.cs_select_modded_type = function(e)
    local mod_name = e.config.ref_table.mod_name
    local type_name = e.config.ref_table.type_name
    local type_key = e.config.ref_table.type_key
    local items = e.config.ref_table.items
    
    local title = "SELECT " .. type_name:upper()
    
    -- Store these for back button navigation
    mod.config.give_type = "modded_consumable"
    mod.config.current_mod_name = mod_name
    mod.config.current_type_name = type_name
    mod.config.came_from_modded = true
    
    -- Process the items list ONCE
    local seen = {}
    local unique_items = {}
    for _, item in ipairs(items or {}) do
        if not seen[item] then
            seen[item] = true
            table.insert(unique_items, item)
        end
    end
    
    -- Sort by display name
    local sorted_items = sort_by_display_name(unique_items, mod_name)
    
    -- Store the processed list for pagination
    mod.config.current_modded_list = sorted_items
    
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(sorted_items, title, "cs_instant_give_card"))
end

G.FUNCS.cs_give_voucher = function(e)
    mod.config.current_give_list = available_vouchers
    mod.config.give_type = "voucher"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_vouchers, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

G.FUNCS.cs_give_joker = function(e)
    -- Force refresh modded content before opening
    refresh_modded_content()
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
    -- Check where we came from
    if mod.config.came_from_modded then
        -- We're in a modded consumable submenu, go back to mod list
        mod.config.came_from_modded = false
        create_overlay(create_modded_consumable_mod_list())
    elseif mod.config.give_type == "modded_consumable" then
        -- We're in the modded consumable mod list, go back to consumable type menu
        create_overlay(create_consumable_type_menu())
    elseif mod.config.give_type == "joker" or mod.config.give_type == "voucher" or mod.config.give_type == "tag" then
        -- These come directly from give item menu
        create_overlay(create_give_item_menu())
    else
        -- Regular consumables go back to consumable type menu
        create_overlay(create_consumable_type_menu())
    end
end

-- Instant give voucher
G.FUNCS.cs_instant_give_voucher = function(e)
    local voucher_key = e.config.ref_table and e.config.ref_table.card_key
    
    if not voucher_key then
        print("Error: No voucher key provided")
        return
    end
    
    -- Check if we're in a valid state
    if not G.STATE or G.STATE == G.STATES.MENU then
        print("Error: Cannot give vouchers from menu, must be in a run")
        return
    end
    
    if G.P_CENTERS[voucher_key] then
        -- Ensure used_vouchers exists
        G.GAME.used_vouchers = G.GAME.used_vouchers or {}
        
        -- Create event to properly give the voucher
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                -- Store current money BEFORE creating card
                local saved_money = G.GAME.dollars
                
                -- Create a temporary voucher card
                local voucher_card = Card(
                    G.play and G.play.T.x or 0,
                    G.play and G.play.T.y or 0,
                    G.CARD_W*0.7,
                    G.CARD_H*0.7,
                    nil,
                    G.P_CENTERS[voucher_key],
                    {bypass_discovery_center = true, bypass_discovery_ui = true}
                )
                
                if voucher_card then
                    -- Set cost to 0 BEFORE redeeming
                    voucher_card.cost = 0
                    
                    -- Use the game's native redeem function
                    voucher_card:redeem()
                    
                    -- Force restore the money to original amount
                    G.GAME.dollars = saved_money
                    
                    -- Ensure it's marked as used
                    G.GAME.used_vouchers[voucher_key] = true
                    
                    -- Handle paired vouchers
                    local voucher_obj = G.P_CENTERS[voucher_key]
                    if voucher_obj.requires then
                        for _, req in ipairs(voucher_obj.requires) do
                            G.GAME.used_vouchers[req] = true
                        end
                    end
                    
                    -- Show the voucher card briefly
                    voucher_card:juice_up(0.3, 0.5)
                    
                    -- Remove the card after a delay
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            voucher_card:start_dissolve()
                            return true
                        end
                    }))
                    
                    -- Update shop text if in shop
                    if G.GAME.ROOM and G.STATE == G.STATES.SHOP then
                        G.GAME.ROOM:update_shop_text()
                    end
                    
                    -- Play sound effect
                    play_sound('card1', 1.2, 0.4)
                    
                    print("Given voucher: " .. voucher_key .. "")
                else
                    print("Error: Failed to create voucher card")
                end
                return true
            end
        }))
    else
        print("Error: Voucher not found - " .. voucher_key)
    end
end

-- In cs_instant_give_joker function, after creating the joker, add:
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
                -- Apply edition
                if mod.config.give_joker_edition and mod.config.give_joker_edition ~= 'base' then
                    joker:set_edition({[mod.config.give_joker_edition] = true})
                    -- REMOVED: Manual slot increase for negative - game handles this automatically
                end
                
                -- Add to deck first
                joker:add_to_deck()
                G.jokers:emplace(joker)
                
                -- Start materialize effect
                joker:start_materialize()
                
                print("Given joker: " .. joker_key .. " with " .. (mod.config.give_joker_edition or "base") .. " edition")
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
    -- Determine current list
    local current_joker_list = available_jokers
    if mod.config.active_joker_tab == "modded" then
        current_joker_list = modded_jokers_by_mod[mod.config.active_mod_tab] or {}
    end
    
    local jokers_per_page = 20
    local total_pages = math.ceil(#current_joker_list / jokers_per_page)
    
    mod.config.joker_page = math.min(total_pages, (mod.config.joker_page or 1) + 1)
    create_overlay(create_joker_menu())
end

-- Instant give consumable - add this after cs_instant_give_tag
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
    
    if not G.consumeables then
        print("Error: Consumables area not available")
        return
    end
    
    if not G.P_CENTERS[card_key] then
        print("Error: Card center not found - " .. card_key)
        return
    end
    
    -- Create card with event to ensure proper timing
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local card = Card(
                G.consumeables.T.x + G.consumeables.T.w/2,
                G.consumeables.T.y,
                G.CARD_W,
                G.CARD_H,
                nil,
                G.P_CENTERS[card_key],
                {bypass_discovery_center = true, bypass_discovery_ui = true}
            )
            
            if card then
                card:add_to_deck()
                G.consumeables:emplace(card)
                
                -- Start materialize effect
                card:start_materialize()
                
                -- Play sound
                play_sound('card1', 1.2, 0.4)
                
                print("Given consumable: " .. card_key)
            else
                print("Error: Failed to create consumable card")
            end
            return true
        end
    }))
end

-- Tab switching functions
G.FUNCS.cs_switch_to_vanilla = function(e)
    mod.config.active_joker_tab = "vanilla"
    mod.config.joker_page = 1
    save_config()
    create_overlay(create_joker_menu())
end

-- Switch to modded jokers tab
G.FUNCS.cs_switch_to_modded = function(e)
    mod.config.active_joker_tab = "modded"
    mod.config.joker_page = 1
    save_config()
    create_overlay(create_joker_menu())
end

-- Switch between mod tabs
G.FUNCS.cs_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.active_mod_tab = mod_name
        mod.config.joker_page = 1
        save_config()
        create_overlay(create_joker_menu())
    end
end

-- Mod page navigation functions
G.FUNCS.cs_prev_mod_page_joker = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_jokers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_joker = math.max(1, (mod.config.mod_page_joker or 1) - 1)
    save_config()
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_next_mod_page_joker = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_jokers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_joker = math.min(total_pages, (mod.config.mod_page_joker or 1) + 1)
    save_config()
    create_overlay(create_joker_menu())
end

-- Mod page navigation for vouchers
G.FUNCS.cs_prev_mod_page_voucher = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_vouchers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_voucher = math.max(1, (mod.config.mod_page_voucher or 1) - 1)
    save_config()
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_next_mod_page_voucher = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_vouchers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_voucher = math.min(total_pages, (mod.config.mod_page_voucher or 1) + 1)
    save_config()
    create_overlay(create_voucher_menu())
end

-- Mod page navigation for tags
G.FUNCS.cs_prev_mod_page_tag = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tags_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_tag = math.max(1, (mod.config.mod_page_tag or 1) - 1)
    save_config()
    create_overlay(create_tag_menu())
end

G.FUNCS.cs_next_mod_page_tag = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tags_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.mod_page_tag = math.min(total_pages, (mod.config.mod_page_tag or 1) + 1)
    save_config()
    create_overlay(create_tag_menu())
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

-- Voucher tab switching for starting items menu
G.FUNCS.cs_voucher_switch_to_vanilla = function(e)
    mod.config.active_voucher_tab = "vanilla"
    mod.config.voucher_page = 1
    save_config()
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_voucher_switch_to_modded = function(e)
    mod.config.active_voucher_tab = "modded"
    mod.config.voucher_page = 1
    save_config()
    create_overlay(create_voucher_menu())
end

G.FUNCS.cs_voucher_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.active_voucher_mod_tab = mod_name
        mod.config.voucher_page = 1
        save_config()
        create_overlay(create_voucher_menu())
    end
end

-- Tag tab switching for starting items menu
G.FUNCS.cs_tag_switch_to_vanilla = function(e)
    mod.config.active_tag_tab = "vanilla"
    mod.config.tag_page = 1
    save_config()
    create_overlay(create_tag_menu())
end

G.FUNCS.cs_tag_switch_to_modded = function(e)
    mod.config.active_tag_tab = "modded"
    mod.config.tag_page = 1
    save_config()
    create_overlay(create_tag_menu())
end

G.FUNCS.cs_tag_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.active_tag_mod_tab = mod_name
        mod.config.tag_page = 1
        save_config()
        create_overlay(create_tag_menu())
    end
end

-- Give joker tab switching
G.FUNCS.cs_give_switch_to_vanilla = function(e)
    mod.config.give_joker_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_switch_to_modded = function(e)
    mod.config.give_joker_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(all_modded_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_jokers_by_mod[mod_name], "SELECT JOKER", "cs_instant_give_joker"))
    end
end

-- Give joker tab switching (with joker in name)
G.FUNCS.cs_give_joker_switch_to_vanilla = function(e)
    mod.config.give_joker_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_jokers, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_joker_switch_to_modded = function(e)
    mod.config.give_joker_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_jokers_by_mod[mod.config.give_mod_tab] or {}, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_joker_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_jokers_by_mod[mod_name], "SELECT JOKER", "cs_instant_give_joker"))
    end
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

-- Tarot tab switching
G.FUNCS.cs_give_tarot_switch_to_vanilla = function(e)
    mod.config.give_tarot_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(tarot_cards, "SELECT TAROT CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_tarot_switch_to_modded = function(e)
    mod.config.give_tarot_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}, "SELECT TAROT CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_tarot_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_tarot_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_tarots_by_mod[mod_name], "SELECT TAROT CARD", "cs_instant_give_card"))
    end
end

-- Planet tab switching
G.FUNCS.cs_give_planet_switch_to_vanilla = function(e)
    mod.config.give_planet_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(planet_cards, "SELECT PLANET CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_planet_switch_to_modded = function(e)
    mod.config.give_planet_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}, "SELECT PLANET CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_planet_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_planet_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_planets_by_mod[mod_name], "SELECT PLANET CARD", "cs_instant_give_card"))
    end
end

-- Spectral tab switching
G.FUNCS.cs_give_spectral_switch_to_vanilla = function(e)
    mod.config.give_spectral_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(spectral_cards, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_spectral_switch_to_modded = function(e)
    mod.config.give_spectral_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_spectral_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_spectral_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_spectrals_by_mod[mod_name], "SELECT SPECTRAL CARD", "cs_instant_give_card"))
    end
end

-- Voucher tab switching (for give menu)
G.FUNCS.cs_give_voucher_switch_to_vanilla = function(e)
    mod.config.give_voucher_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_vouchers, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

G.FUNCS.cs_give_voucher_switch_to_modded = function(e)
    mod.config.give_voucher_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_vouchers_by_mod[mod.config.give_voucher_mod_tab] or {}, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

G.FUNCS.cs_give_voucher_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_voucher_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_vouchers_by_mod[mod_name], "SELECT VOUCHER", "cs_instant_give_voucher"))
    end
end

-- Tag tab switching (for give menu)
G.FUNCS.cs_give_tag_switch_to_vanilla = function(e)
    mod.config.give_tag_tab = "vanilla"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(available_tags, "SELECT TAG", "cs_instant_give_tag"))
end

G.FUNCS.cs_give_tag_switch_to_modded = function(e)
    mod.config.give_tag_tab = "modded"
    mod.config.give_page = 1
    create_overlay(create_card_selection_menu(modded_tags_by_mod[mod.config.give_tag_mod_tab] or {}, "SELECT TAG", "cs_instant_give_tag"))
end

G.FUNCS.cs_give_tag_switch_mod_tab = function(e)
    local mod_name = e.config.ref_table and e.config.ref_table.mod_name
    if mod_name then
        mod.config.give_tag_mod_tab = mod_name
        mod.config.give_page = 1
        create_overlay(create_card_selection_menu(modded_tags_by_mod[mod_name], "SELECT TAG", "cs_instant_give_tag"))
    end
end

-- Navigation functions for give item pages
G.FUNCS.cs_give_prev_page = function(e)
    mod.config.give_page = math.max(1, (mod.config.give_page or 1) - 1)
    
    -- Recreate the appropriate menu based on current type
    if mod.config.give_type == "joker" then
        local current_list = available_jokers
        if mod.config.give_joker_tab == "modded" then
            current_list = modded_jokers_by_mod[mod.config.give_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT JOKER", "cs_instant_give_joker"))
    elseif mod.config.give_type == "tarot" then
        local current_list = tarot_cards
        if mod.config.give_tarot_tab == "modded" then
            current_list = modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT TAROT CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "planet" then
        local current_list = planet_cards
        if mod.config.give_planet_tab == "modded" then
            current_list = modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT PLANET CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "spectral" then
        local current_list = spectral_cards
        if mod.config.give_spectral_tab == "modded" then
            current_list = modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "voucher" then
        local current_list = available_vouchers
        if mod.config.give_voucher_tab == "modded" then
            current_list = modded_vouchers_by_mod[mod.config.give_voucher_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT VOUCHER", "cs_instant_give_voucher"))
    elseif mod.config.give_type == "tag" then
        local current_list = available_tags
        if mod.config.give_tag_tab == "modded" then
            current_list = modded_tags_by_mod[mod.config.give_tag_mod_tab] or {}
        end
        create_overlay(create_card_selection_menu(current_list, "SELECT TAG", "cs_instant_give_tag"))
	elseif mod.config.give_type == "modded_consumable" then
        -- Use the stored list
        local current_list = mod.config.current_modded_list or {}
        create_overlay(create_card_selection_menu(current_list, "SELECT " .. (mod.config.current_type_name or "ITEM"), "cs_instant_give_card"))
    end
end

-- Give menu mod navigation for jokers
G.FUNCS.cs_give_prev_mod_page_joker = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_jokers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_joker = math.max(1, (mod.config.give_mod_page_joker or 1) - 1)
    create_overlay(create_card_selection_menu(modded_jokers_by_mod[mod.config.give_mod_tab] or {}, "SELECT JOKER", "cs_instant_give_joker"))
end

G.FUNCS.cs_give_next_mod_page_joker = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_jokers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_joker = math.min(total_pages, (mod.config.give_mod_page_joker or 1) + 1)
    create_overlay(create_card_selection_menu(modded_jokers_by_mod[mod.config.give_mod_tab] or {}, "SELECT JOKER", "cs_instant_give_joker"))
end

-- Give menu mod navigation for vouchers
G.FUNCS.cs_give_prev_mod_page_voucher = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_vouchers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_voucher = math.max(1, (mod.config.give_mod_page_voucher or 1) - 1)
    create_overlay(create_card_selection_menu(modded_vouchers_by_mod[mod.config.give_voucher_mod_tab] or {}, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

G.FUNCS.cs_give_next_mod_page_voucher = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_vouchers_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_voucher = math.min(total_pages, (mod.config.give_mod_page_voucher or 1) + 1)
    create_overlay(create_card_selection_menu(modded_vouchers_by_mod[mod.config.give_voucher_mod_tab] or {}, "SELECT VOUCHER", "cs_instant_give_voucher"))
end

-- Give menu mod navigation for tags
G.FUNCS.cs_give_prev_mod_page_tag = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tags_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_tag = math.max(1, (mod.config.give_mod_page_tag or 1) - 1)
    create_overlay(create_card_selection_menu(modded_tags_by_mod[mod.config.give_tag_mod_tab] or {}, "SELECT TAG", "cs_instant_give_tag"))
end

G.FUNCS.cs_give_next_mod_page_tag = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tags_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_tag = math.min(total_pages, (mod.config.give_mod_page_tag or 1) + 1)
    create_overlay(create_card_selection_menu(modded_tags_by_mod[mod.config.give_tag_mod_tab] or {}, "SELECT TAG", "cs_instant_give_tag"))
end

-- Give menu mod navigation for tarots
G.FUNCS.cs_give_prev_mod_page_tarot = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tarots_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_tarot = math.max(1, (mod.config.give_mod_page_tarot or 1) - 1)
    create_overlay(create_card_selection_menu(modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}, "SELECT TAROT CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_next_mod_page_tarot = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_tarots_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_tarot = math.min(total_pages, (mod.config.give_mod_page_tarot or 1) + 1)
    create_overlay(create_card_selection_menu(modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}, "SELECT TAROT CARD", "cs_instant_give_card"))
end

-- Give menu mod navigation for planets
G.FUNCS.cs_give_prev_mod_page_planet = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_planets_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_planet = math.max(1, (mod.config.give_mod_page_planet or 1) - 1)
    create_overlay(create_card_selection_menu(modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}, "SELECT PLANET CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_next_mod_page_planet = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_planets_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_planet = math.min(total_pages, (mod.config.give_mod_page_planet or 1) + 1)
    create_overlay(create_card_selection_menu(modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}, "SELECT PLANET CARD", "cs_instant_give_card"))
end

-- Give menu mod navigation for spectrals
G.FUNCS.cs_give_prev_mod_page_spectral = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_spectrals_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_spectral = math.max(1, (mod.config.give_mod_page_spectral or 1) - 1)
    create_overlay(create_card_selection_menu(modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_next_mod_page_spectral = function(e)
    local mod_list = {}
    for mod_name, _ in pairs(modded_spectrals_by_mod) do
        table.insert(mod_list, mod_name)
    end
    local total_pages = math.ceil(#mod_list / 5)
    
    mod.config.give_mod_page_spectral = math.min(total_pages, (mod.config.give_mod_page_spectral or 1) + 1)
    create_overlay(create_card_selection_menu(modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
end

G.FUNCS.cs_give_next_page = function(e)
    local total_pages = 1
    local current_list = nil
    
    -- Calculate total pages based on current type
    if mod.config.give_type == "joker" then
        if mod.config.give_joker_tab == "modded" then
            current_list = modded_jokers_by_mod[mod.config.give_mod_tab] or {}
        else
            current_list = available_jokers
        end
    elseif mod.config.give_type == "tarot" then
        if mod.config.give_tarot_tab == "modded" then
            current_list = modded_tarots_by_mod[mod.config.give_tarot_mod_tab] or {}
        else
            current_list = tarot_cards
        end
    elseif mod.config.give_type == "planet" then
        if mod.config.give_planet_tab == "modded" then
            current_list = modded_planets_by_mod[mod.config.give_planet_mod_tab] or {}
        else
            current_list = planet_cards
        end
    elseif mod.config.give_type == "spectral" then
        if mod.config.give_spectral_tab == "modded" then
            current_list = modded_spectrals_by_mod[mod.config.give_spectral_mod_tab] or {}
        else
            current_list = spectral_cards
        end
    elseif mod.config.give_type == "voucher" then
        if mod.config.give_voucher_tab == "modded" then
            current_list = modded_vouchers_by_mod[mod.config.give_voucher_mod_tab] or {}
        else
            current_list = available_vouchers
        end
    elseif mod.config.give_type == "tag" then
        if mod.config.give_tag_tab == "modded" then
            current_list = modded_tags_by_mod[mod.config.give_tag_mod_tab] or {}
        else
            current_list = available_tags
        end
    elseif mod.config.give_type == "modded_consumable" then
        -- Use the stored list
        current_list = mod.config.current_modded_list or {}
        end
    
    if current_list then
        total_pages = math.ceil(#current_list / 20)
    end
    
    mod.config.give_page = math.min(total_pages, (mod.config.give_page or 1) + 1)
    
    -- Recreate the appropriate menu
    if mod.config.give_type == "joker" then
        create_overlay(create_card_selection_menu(current_list, "SELECT JOKER", "cs_instant_give_joker"))
    elseif mod.config.give_type == "tarot" then
        create_overlay(create_card_selection_menu(current_list, "SELECT TAROT CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "planet" then
        create_overlay(create_card_selection_menu(current_list, "SELECT PLANET CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "spectral" then
        create_overlay(create_card_selection_menu(current_list, "SELECT SPECTRAL CARD", "cs_instant_give_card"))
    elseif mod.config.give_type == "voucher" then
        create_overlay(create_card_selection_menu(current_list, "SELECT VOUCHER", "cs_instant_give_voucher"))
    elseif mod.config.give_type == "tag" then
        create_overlay(create_card_selection_menu(current_list, "SELECT TAG", "cs_instant_give_tag"))
    elseif mod.config.give_type == "modded_consumable" then
        create_overlay(create_card_selection_menu(current_list, "SELECT " .. (mod.config.current_type_name or "ITEM"), "cs_instant_give_card"))
	end
end

-- Toggle joker selection (with shift-click to remove)
G.FUNCS.cs_toggle_joker = function(e)
    local joker_key = e.config.ref_table.joker_key
    
    -- Check if shift is held
    if G.CONTROLLER and G.CONTROLLER.held_keys and G.CONTROLLER.held_keys.lshift then
        -- Shift-click: Remove one instance
        for i = #mod.config.starting_jokers, 1, -1 do
            if type(mod.config.starting_jokers[i]) == "string" and mod.config.starting_jokers[i] == joker_key then
                table.remove(mod.config.starting_jokers, i)
                break
            elseif type(mod.config.starting_jokers[i]) == "table" and mod.config.starting_jokers[i].key == joker_key and 
                   mod.config.starting_jokers[i].edition == mod.config.starting_joker_edition then
                table.remove(mod.config.starting_jokers, i)
                break
            end
        end
    else
        -- Normal click: Add with edition
        table.insert(mod.config.starting_jokers, {
            key = joker_key,
            edition = mod.config.starting_joker_edition
        })
    end
    
    save_config()
    create_overlay(create_joker_menu())
end

-- Toggle voucher selection (with shift-click to remove)
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
    
    -- Check if shift is held
    if G.CONTROLLER and G.CONTROLLER.held_keys and G.CONTROLLER.held_keys.lshift then
        -- Shift-click: Always remove if found
        if found then
            table.remove(mod.config.starting_vouchers, index_to_remove)
        end
    else
        -- Normal click: Toggle
        if found then
            table.remove(mod.config.starting_vouchers, index_to_remove)
        else
            table.insert(mod.config.starting_vouchers, voucher_key)
        end
    end
    
    save_config()
    create_overlay(create_voucher_menu())
end

-- Toggle tag selection (with shift-click to remove)
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
    
    -- Check if shift is held
    if G.CONTROLLER and G.CONTROLLER.held_keys and G.CONTROLLER.held_keys.lshift then
        -- Shift-click: Always remove if found
        if found then
            table.remove(mod.config.starting_tags, index_to_remove)
        end
    else
        -- Normal click: Toggle
        if found then
            table.remove(mod.config.starting_tags, index_to_remove)
        else
            table.insert(mod.config.starting_tags, tag_key)
        end
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
    
    -- Check if shift+left-click (remove card)
    if G.CONTROLLER and G.CONTROLLER.held_keys and G.CONTROLLER.held_keys.lshift then
        -- Find and remove the last matching card
        for i = #mod.config.custom_deck, 1, -1 do
            local card = mod.config.custom_deck[i]
            if card.rank == rank and card.suit == suit and
               card.enhancement == mod.config.current_enhancement and
               card.seal == mod.config.current_seal and
               card.edition == mod.config.current_edition then
                table.remove(mod.config.custom_deck, i)
                print("ZokersModMenu: Removed card " .. rank .. suit .. " from deck. Total: " .. #mod.config.custom_deck)
                break
            end
        end
    else
        -- Normal click: Add card
        local card_data = create_card_data(
            rank, 
            suit, 
            mod.config.current_enhancement,
            mod.config.current_seal,
            mod.config.current_edition
        )
        
        table.insert(mod.config.custom_deck, card_data)
        print("ZokersModMenu: Added card " .. rank .. suit .. " to deck. Total: " .. #mod.config.custom_deck)
        print("With enhancement: " .. mod.config.current_enhancement .. ", seal: " .. mod.config.current_seal .. ", edition: " .. mod.config.current_edition)
    end
    
    -- IMMEDIATELY save config
    save_config()
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
    for i, edition in ipairs(card_edition_options) do
        if edition.key == mod.config.current_edition then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #card_edition_options then
        current_index = 1
    end
    
    mod.config.current_edition = card_edition_options[current_index].key
    save_config()
    print("Edition changed to: " .. mod.config.current_edition)
    create_overlay(create_deck_builder())
end

G.FUNCS.cs_cycle_starting_joker_edition = function(e)
    local current_index = 1
    for i, edition in ipairs(joker_edition_options) do
        if edition.key == mod.config.starting_joker_edition then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #joker_edition_options then
        current_index = 1
    end
    
    mod.config.starting_joker_edition = joker_edition_options[current_index].key
    save_config()
    create_overlay(create_joker_menu())
end

G.FUNCS.cs_cycle_give_joker_edition = function(e)
    local current_index = 1
    for i, edition in ipairs(joker_edition_options) do
        if edition.key == mod.config.give_joker_edition then
            current_index = i
            break
        end
    end
    
    current_index = current_index + 1
    if current_index > #joker_edition_options then
        current_index = 1
    end
    
    mod.config.give_joker_edition = joker_edition_options[current_index].key
    save_config()
    -- Recreate the appropriate give menu
    create_overlay(create_card_selection_menu(
        mod.config.give_joker_tab == "vanilla" and available_jokers or modded_jokers_by_mod[mod.config.give_mod_tab] or {},
        "SELECT JOKER", 
        "cs_instant_give_joker"
    ))
end

-- Add menu key remapping functions
G.FUNCS.cs_change_menu_key = function(e)
    -- Create key capture dialog
    local key_dialog = {
        n = G.UIT.ROOT,
        config = {align = "cm", minw = 6, minh = 4, colour = {0, 0, 0, 0.9}, r = 0.1, padding = 0.1},
        nodes = {
            {n = G.UIT.R, config = {align = "cm", padding = 0.2, colour = {0, 0, 0, 1}, r = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "PRESS NEW KEY", scale = 0.6, colour = {1, 1, 1, 1}}}}},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Press any key to set as menu key", scale = 0.4, colour = {0.7, 0.7, 0.7, 1}}}}},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.1}, 
             nodes = {{n = G.UIT.T, config = {text = "Current: " .. string.upper(mod.config.menu_key), scale = 0.4, colour = {1, 1, 0, 1}}}}},
            
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, button = "cs_cancel_key_change", hover = true, minw = 2, minh = 0.8, colour = G.C.RED, r = 0.1}, 
                 nodes = {{n = G.UIT.T, config = {text = "Cancel", scale = 0.5, colour = G.C.WHITE}}}}
            }}
        }
    }
    
    mod._capturing_key = true
    create_overlay(key_dialog)
end

G.FUNCS.cs_cancel_key_change = function(e)
    mod._capturing_key = false
    -- Return to config menu
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    G.FUNCS.options(nil, true)
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
    -- Handle key capture mode
    if mod._capturing_key then
        -- Don't capture special keys
        local invalid_keys = {
            'escape', 'return', 'kpenter', 'space', 'tab', 'backspace',
            'lshift', 'rshift', 'lctrl', 'rctrl', 'lalt', 'ralt',
            'up', 'down', 'left', 'right'
        }
        
        local is_invalid = false
        for _, invalid_key in ipairs(invalid_keys) do
            if key == invalid_key then
                is_invalid = true
                break
            end
        end
        
        if not is_invalid and string.len(key) > 0 then
            mod.config.menu_key = key
            save_config()
            mod._capturing_key = false
            
            -- Return to config menu
            if G.OVERLAY_MENU then
                G.OVERLAY_MENU:remove()
                G.OVERLAY_MENU = nil
            end
            G.FUNCS.options(nil, true)
            
            print("ZokersModMenu: Menu key changed to: " .. string.upper(key))
        end
        return
    end
    
    -- Handle text input mode
    if mod.text_input_active then
        if key == 'return' or key == 'kpenter' then
            G.FUNCS.cs_confirm_text_input()
            return
        elseif key == 'escape' then
            G.FUNCS.cs_cancel_text_input()
            return
        elseif key == 'backspace' then
            if #mod.text_input_value > 0 then
                mod.text_input_value = string.sub(mod.text_input_value, 1, -2)
                -- Force UI update if possible
                if G.OVERLAY_MENU then
                    create_overlay(create_text_input_dialog(
                        G.OVERLAY_MENU.definition.nodes[1].nodes[1].config.text,
                        mod.text_input_value,
                        mod.text_input_type
                    ))
                end
            end
            return
        elseif string.len(key) == 1 and tonumber(key) then
            -- Only allow numeric input
            mod.text_input_value = mod.text_input_value .. key
            -- Force UI update
            if G.OVERLAY_MENU then
                create_overlay(create_text_input_dialog(
                    G.OVERLAY_MENU.definition.nodes[1].nodes[1].config.text,
                    mod.text_input_value,
                    mod.text_input_type
                ))
            end
            return
        end
    end
    
    -- Call original function first
    local ret = ref_Controller_key_press(self, key)
    
    -- Check if the configured key was pressed
    if key == mod.config.menu_key and not (G.CONTROLLER and G.CONTROLLER.text_input_hook) and not mod.text_input_active then
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