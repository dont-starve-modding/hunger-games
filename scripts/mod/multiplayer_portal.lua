return function(inst)
    local x,y,z = inst:GetPosition():Get()
    -- TODO Voraussetzung ist genügend freier Raum, i.A. aber nicht der Fall
    -- TODO Gegenstände verteilen
    -- SpawnPrefab("firepit").Transform:SetPosition(x,y,z)
end
