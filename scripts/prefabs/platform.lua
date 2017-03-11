------------------------
----- Hunger Games -----
------------------------

local Assets = {
	Asset("ANIM", "anim/platform.zip") -- neonix
}

local function MakePlatform(anims)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("platform")
    inst.AnimState:SetBuild("platform")
	inst.AnimState:PlayAnimation("idle", true)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if TheWorld.ismastersim then
	    inst:AddComponent("inspectable")
	    MakeSnowCovered(inst)
	end

    return inst
end

STRINGS.NAMES.PLATFORM = "Platform"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PLATFORM = "The beginning of everything."

return Prefab("platform", MakePlatform, Assets)

----- Kalkstein -----
