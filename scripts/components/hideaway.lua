------------------------
----- Hunger Games -----
------------------------

local Hideaway = Class(function(self, inst)
	self.inst = inst
end)

function Hideaway:Hide(inst)
	if inst and inst:HasTag('player') and inst.components.hunger then
		-- TODO kontinuierlich
		inst.components.sanity:DoDelta(-5)
	end
end

return Hideaway

----- Kalkstein -----
