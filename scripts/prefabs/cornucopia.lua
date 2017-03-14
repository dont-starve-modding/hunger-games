------------------------
----- Hunger Games -----
------------------------

local Assets = {
	Asset("ANIM", "anim/cornucopia.zip") -- neonix
}

local function MakeCornucopia(anims)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("cornucopia")
    inst.AnimState:SetBuild("cornucopia")
	inst.AnimState:PlayAnimation("idle", true)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if TheWorld.ismastersim then
	    inst:AddComponent("inspectable")
	    MakeSnowCovered(inst)
	end

    return inst
end

STRINGS.NAMES.CORNUCOPIA = "Cornucopia"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CORNUCOPIA = "Beware the death."

return Prefab("cornucopia", MakeCornucopia, Assets)

----- Kalkstein -----
