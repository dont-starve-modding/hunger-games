return function(inst)
    -- Maximale Spieleranzahl
    inst.MAX_SERVER_SIZE = 12

    -- Stärkere Hunde
    inst.HOUND_HEALTH = 200
    inst.HOUND_DAMAGE = 30
    inst.HOUND_SPEED = 11

    -- Verbrauch von 75 pro Tag
    inst.CALORIES_TINY = 10
    inst.CALORIES_SMALL = 20
    inst.CALORIES_MEDSMALL = 30
    inst.CALORIES_MED = 40
    inst.CALORIES_LARGE = 50
    inst.CALORIES_HUGE = 60
    inst.CALORIES_SUPERHUGE = 75

    -- Kürzere Saisons
    inst.SEASON_LENGTH_FRIENDLY_DEFAULT = 5
    inst.SEASON_LENGTH_FRIENDLY_VERYSHORT = 1
    inst.SEASON_LENGTH_FRIENDLY_SHORT = 4
    inst.SEASON_LENGTH_FRIENDLY_LONG = 6
    inst.SEASON_LENGTH_FRIENDLY_VERYLONG = 20
    inst.SEASON_LENGTH_HARSH_DEFAULT = 4
    inst.SEASON_LENGTH_HARSH_VERYSHORT = 1
    inst.SEASON_LENGTH_HARSH_SHORT = 3
    inst.SEASON_LENGTH_HARSH_LONG = 5
    inst.SEASON_LENGTH_HARSH_VERYLONG = 20
end
