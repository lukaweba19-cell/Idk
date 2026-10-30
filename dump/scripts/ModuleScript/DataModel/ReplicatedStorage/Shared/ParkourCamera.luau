-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	CROUCH_Y = -1.1,
	SLIDE_Y = -1,
	MULT = 1.2,
	TWEEN_TIME = 0.15,
	SLIDE_EXTRA_Y = 0.65,
	SLIDE_SPRING_DAMPER = 0.8,
	SLIDE_SPRING_SPEED = 18,
	EYE_HEIGHT = 1.6
}

function module.TotalOffsetY(p1)
	if p1 == "Crouching" then
		return module.CROUCH_Y * module.MULT
	end

	if p1 == "Sliding" then
		return module.SLIDE_Y * module.MULT - module.SLIDE_EXTRA_Y
	end

	return 0
end

return module
