return function(inst)
    local _speed = inst.locomotor.runspeed
    inst.locomotor.runspeed = 0
    TheWorld:DoTaskInTime(10, function()
        inst.locomotor.runspeed = _speed
		TheNet:Announce("DEBUG: Lauf!")
	end)
end
