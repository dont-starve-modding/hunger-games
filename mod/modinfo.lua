-- This information tells other players more about the mod
name = "Custom Game Mode!"
description = "Don't Hunger"

author = "s1m13, sebadur"
version = "1.1"

forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

---- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

--This lets the clients know that they need to download the mod before they can join a server that is using it.
all_clients_require_mod = true

--This lets the game know that this mod doesn't need to be listed in the server's mod listing
client_only_mod = false

--Let the mod system know that this mod is functional with Don't Starve Together
dst_compatible = true

--These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {"custom", "gamemode", "game mode"}

game_modes =
{
    {
        name = "hunger_games",
        label = "Hunger Games",
        description = "HUNGER GAMES! Custom Spawn point, Revival, your Rules!",
        settings =
        {
            spawn_mode = "scatter",
            ghost_enable = true,
            portal_rez = false,
            reset_time = nil,
			ban_rez = true,
			ghost_sanity_drain = true
        }
    }
}

configuration_options =
{
    {
        name = "spawn_mode",
        label = "Spawn Mode",
		hover = "Select if everybody spawns at the portal or at a random place.",
        options =
        {
            {description = "At Portal", data = "fixed"},
            {description = "Random", data = "scatter"},
        },
        default = "fixed",
    },
	{
        name = "ghost_enable",
        label = "Ghost Enabled",
		hover = "Select if you become a ghost when you die, otherwise you'll make a new character.",
        options =
        {
            {description = "Yeah", data = true},
            {description = "Nah", data = false},
        },
        default = true,
    }


}
