------------------------
----- Hunger Games -----
------------------------

local tonumber = GLOBAL.tonumber
local TheNet = GLOBAL.TheNet
local SpawnPrefab = GLOBAL.SpawnPrefab
local function DoTaskInTime(time, task) GLOBAL.TheWorld:DoTaskInTime(time, task) end
local hunger_games = GLOBAL.GAME_MODES["hunger_games"]

local DEBUG = false -- TODO


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
local PlatformPosition = nil

--- Listet für alle Startpositionen auf, ob sie von einem Spieler besetzt sind
local platform_used = { }


----- Veränderte Spieldateien --------------------------------------------------

--- Startumgebung mit Füllhorn
AddPrefabPostInit("multiplayer_portal", function(inst)
	DoTaskInTime(0, function()
	    local x0, y, z0 = inst:GetPosition():Get()
	    -- TODO Voraussetzung ist genügend freier Raum, i.A. aber nicht der Fall
		-- Halbkreis vor dem Füllhorn
		local r = 15
		local delta = math.pi / TheNet:GetServerMaxPlayers()
		PlatformPosition = function(i)
			local phi = i * delta
			local x = x0 + r * math.sin(phi)
			local z = z0 + r * math.cos(phi)
			return x, y, z
		end
		for i = 1, TheNet:GetServerMaxPlayers() do
			platform_used[i] = false
			local x, y, z = PlatformPosition(i)
	    	SpawnPrefab("compass").Transform:SetPosition(x, y, z)
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

	-- Verstecken ermöglichen
	inst:AddComponent("hideaway")

	if GLOBAL.TheWorld.ismastersim then
	    -- Das Spiel bei Erreichen der gewünschten Spieleranzahl beginnen
	    if #TheNet:GetClientTable() >= TheNet:GetServerMaxPlayers() or DEBUG then
	        DoTaskInTime(0, BeginGame)
	    end
	end
end)


--- Charaktere auf den Startplattformen absetzen
AddComponentPostInit("playerspawner", function(inst)
	inst.SpawnAtNextLocation = function(self, inst, player)
		local i = 1
		while platform_used[i] do
			i = i + 1
		end
		platform_used[i] = true
		local x, y, z = PlatformPosition(i)
		self:SpawnAtLocation(inst, player, x, y, z)
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


--- Versteckmöglichkeit in Büschen und Bäumen
-- TODO SCHÖNER
for index, prefab in pairs({"evergreen", "twiggytree", "berrybush"}) do
	AddPrefabPostInit(prefab, function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("hideaway")
		end
	end)
end
AddAction("HIDE", "Hide", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag("player")
	and act.target.components.hideaway --and act.target:HasTag("tree")
	and not act.target:HasTag("burnt") and not act.target:HasTag("fire")
	and not act.target:HasTag("stump") then
		act.target.components.hideaway:Hide(act.doer)
		return true
	else
		return false
	end
end)
AddComponentAction("SCENE", "hideaway", function(inst, doer, actions, right)
	if right and not inst:HasTag("burnt") and not inst:HasTag("fire") and (
		   inst:HasTag("tree") and not inst:HasTag("stump")
		   or inst:HasTag("berrybush")
	) then
		table.insert(actions, GLOBAL.ACTIONS.HIDE)
	end
end)
AddStategraphState("wilson", GLOBAL.State{ name = "hide",
	tags = { "hiding", "notarget", "nomorph", "busy", "nopredict" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(20)
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline = {
		GLOBAL.TimeEvent(6 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
			inst:Hide()
			inst.DynamicShadow:Enable(false)
			inst.sg:RemoveStateTag("busy")
		end),
		GLOBAL.TimeEvent(24 * GLOBAL.FRAMES, function(inst)
			inst.sg:RemoveStateTag("nopredict")
			inst.sg:AddStateTag("idle")
		end),
	},

	onexit = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,

	ontimeout = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		if not GLOBAL.TheWorld.ismastersim then
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,
})
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.HIDE, "hide"))

----- Kalkstein -----
