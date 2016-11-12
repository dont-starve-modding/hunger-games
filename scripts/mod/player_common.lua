local function OnDespawn(inst)
    if inst.components.playercontroller ~= nil then
        inst.components.playercontroller:Enable(false)
    end
    inst.components.locomotor:StopMoving()
    inst.components.locomotor:Clear()
end

return function(inst)
    inst.OnDespawn = OnDespawn
end
