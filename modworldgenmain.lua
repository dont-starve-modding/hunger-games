------------------------
----- Hunger Games -----
------------------------

local STRINGS = GLOBAL.STRINGS


----- Anpassungen --------------------------------------------------------------

-- Maximale Spieleranzahl
TUNING.MAX_SERVER_SIZE = 12

-- Stärkere Hunde
TUNING.HOUND_HEALTH = 200
TUNING.HOUND_DAMAGE = 30
TUNING.HOUND_SPEED = 11

-- Verbrauch von 75 pro Tag
TUNING.CALORIES_TINY = 10
TUNING.CALORIES_SMALL = 20
TUNING.CALORIES_MEDSMALL = 30
TUNING.CALORIES_MED = 40
TUNING.CALORIES_LARGE = 50
TUNING.CALORIES_HUGE = 60
TUNING.CALORIES_SUPERHUGE = 75

-- Kürzere Saisons
TUNING.SEASON_LENGTH_FRIENDLY_DEFAULT = 5
TUNING.SEASON_LENGTH_FRIENDLY_VERYSHORT = 1
TUNING.SEASON_LENGTH_FRIENDLY_SHORT = 4
TUNING.SEASON_LENGTH_FRIENDLY_LONG = 6
TUNING.SEASON_LENGTH_FRIENDLY_VERYLONG = 20
TUNING.SEASON_LENGTH_HARSH_DEFAULT = 4
TUNING.SEASON_LENGTH_HARSH_VERYSHORT = 1
TUNING.SEASON_LENGTH_HARSH_SHORT = 3
TUNING.SEASON_LENGTH_HARSH_LONG = 5
TUNING.SEASON_LENGTH_HARSH_VERYLONG = 20


-- TODO Nightlock berries hinzufügen


----- Host-Einstellungen -------------------------------------------------------
if GLOBAL.getmetatable(GLOBAL).__declared["GAME_MODES"] then
--if not GLOBAL.getmetatable(GLOBAL).__declared["WORLDGEN_MAIN"] then

	--- Andere Spielmodi entfernen
	-- TODO Absturz:
	--GLOBAL.GAME_MODES = { hunger_games=GLOBAL.GAME_MODES["hunger_games"] }

	--- Anzeige der Einstellungen
	--AddClassPostConstruct("widgets/serversettingstab", function(inst)
		-- TODO Warum funktioniert das nicht?
	    -- PVP ist zwangsweise eingeschaltet
		--inst.pvp.spinner.options = {
		--	{ text = STRINGS.UI.SERVERCREATIONSCREEN.ON, data = true }
		--}
		--inst.pvp.spinner:SetSelected(true)
	--end)

end


----- Kalkstein -----
