name = "Hunger Games"
description = "A last man standing survival mode."
priority = 100

author = "dont-starve-mods"
version = "1.0"
version_compatible = "1.0"
api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

standalone = true
all_clients_require_mod = true
client_only_mod = false
dst_compatible = true

server_filter_tags = { "hunger games", "hunger-games", "hungergames", "pvp", "vs", "versus" }

game_modes = {
    {
        name = "hunger_games",
        label = "Hunger Games",
        description = "You have to survive as a tribute in the Hunger Games.",
        settings = {
            waiting_time = 300,
            fancy_option = false
        }
    }
}

configuration_options = {
    {
        name = "waiting_time",
        label = "Waiting Time",
		hover = "Choose the time to wait until starting the game. New players can't connect once the game is running.",
        options = {
            { description = "5 s", data = 5 },
            { description = "10 s", data = 10 },
            { description = "15 s", data = 15 },
            { description = "20 s", data = 20 },
            { description = "30 s", data = 30 },
            { description = "40 s", data = 40 },
            { description = "50 s", data = 50 },
            { description = "1 min", data = 60 },
            { description = "2 min", data = 120 },
            { description = "3 min", data = 180 },
            { description = "4 min", data = 240 },
            { description = "5 min", data = 300 },
            { description = "10 min", data = 600 },
            { description = "15 min", data = 900 },
            { description = "20 min", data = 1200 }
        },
        default = 300
    },
	{
        name = "fancy_option",
        label = "Fancy",
		hover = "How knows?",
        options = {
            {description = "Better Not", data = false},
            {description = "Yes, Please", data = true}
        },
        default = false
    }
}
