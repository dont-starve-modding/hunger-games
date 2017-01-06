------------------------
----- Hunger Games -----
------------------------

local tonumber = GLOBAL.tonumber
local TheNet = GLOBAL.TheNet
local SpawnPrefab = GLOBAL.SpawnPrefab
local function DoTaskInTime(time, task) GLOBAL.TheWorld:DoTaskInTime(time, task) end
local hunger_games = GLOBAL.GAME_MODES["hunger_games"]

local DEBUG = true -- TODO


----- Optionen -----------------------------------------------------------------

--- Unveränderlich
hunger_games.resource_renewal = false
hunger_games.ghost_sanity_drain = false
hunger_games.portal_rez = false
hunger_games.reset_time = nil
hunger_games.invalid_recipes = { "lifeinjector", "resurrectionstatue", "reviver" }

--- Einstellungen
hunger_games.waiting_time = GetModConfigData("waiting_time")
hunger_games.ghost_enabled = GetModConfigData("ghost_enabled")
hunger_games.fancy_option = GetModConfigData("fancy_option")


----- Allgemein ----------------------------------------------------------------

--- Liste aller Methoden, die bei Beginn des Spiels ausgeführt werden sollen
local on_begin = { }

--- Das Spiel beginnt in t Sekunden
local function BeginGame(t)
    t = tonumber(t) or 10
    if t <= 0 then
        for index, task in pairs(on_begin) do task() end
    else
        TheNet:Announce(t)
        DoTaskInTime(1, function() BeginGame(t-1) end)
    end
end

--- Ein Spieler hat gewonnen, die Partie wird beendet
local function EndGame()
    TheNet:Announce("The game is over!")
end


--- Positionen der Startplattformen
local platform_position = { }


----- Veränderte Spieldateien --------------------------------------------------

--- Startumgebung mit Füllhorn
AddPrefabPostInit("multiplayer_portal", function(inst)
	DoTaskInTime(0, function()
	    local x0,y,z0 = inst:GetPosition():Get()
	    -- TODO Voraussetzung ist genügend freier Raum, i.A. aber nicht der Fall
		-- Halbkreis vor dem Füllhorn
		local r = 15
		local delta = math.pi / TheNet:GetServerMaxPlayers()
		for phi = delta, math.pi, delta do
			local x = x0 + r * math.cos(phi)
			local z = z0 + r * math.sin(phi)
			table.insert(platform_position, {x,y,z})
	    	SpawnPrefab("flower").Transform:SetPosition(x,y,z)
		end
	end)
end)


--- Verhalten der Charaktere
AddPlayerPostInit(function(inst)
    -- Figur bleibt beim Ausloggen bestehen
    inst.OnDespawn = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.components.locomotor:StopMoving()
        inst.components.locomotor:Clear()
    end

	-- Keine Spielerindikatoren
	inst:AddTag("noplayerindicator")

    -- Den Spieler vor Beginn einfrieren
    inst.components.health:SetInvincible(true)
    inst.components.hunger:Pause()
    local _speed = inst.components.locomotor.runspeed
    inst.components.locomotor.runspeed = 0
    table.insert(on_begin, function()
        inst.components.health:SetInvincible(false)
        inst.components.hunger:Resume()
        inst.components.locomotor.runspeed = _speed
	end)

    -- Das Spiel bei Erreichen der gewünschten Spieleranzahl beginnen
    if #TheNet:GetClientTable() >= TheNet:GetServerMaxPlayers() or DEBUG then
        DoTaskInTime(0, BeginGame)
    end
end)


--- Charaktere auf den Startplattformen absetzen
AddComponentPostInit("playerspawner", function(inst)
	inst.GetNextSpawnPosition = function()
		return table.remove(platform_position)
	end
end)


--- Zeit vor Beginn anhalten
AddComponentPostInit("clock", function(inst)
    local _OnUpdate = inst.OnUpdate
    inst.OnUpdate = nil
    inst.LongUpdate = nil
    table.insert(on_begin, function()
        inst.OnUpdate = _OnUpdate
        inst.LongUpdate = _OnUpdate
    end)
end)


----- Kalkstein -----
