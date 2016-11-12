------------------------
----- Hunger Games -----
------------------------

local require = GLOBAL.require
local hunger_games = GLOBAL.GAME_MODES["hunger_games"]


----- Optionen -----------------------------------------------------------------

-- Unveränderlich
hunger_games.portal_rez = false
hunger_games.invalid_recipes = { "reviver", "lifeinjector", "amulet", "resurrections" }
hunger_games.ghost_sanity_drain = false

-- Einstellungen
hunger_games.waiting_time = GetModConfigData("waiting_time")
hunger_games.fancy_option = GetModConfigData("fancy_option")


----- Veränderte Spieldateien --------------------------------------------------
AddPrefabPostInit("multiplayer_portal", require("mod/multiplayer_portal"))
AddPrefabPostInit("wilson", require("mod/player_common"))
