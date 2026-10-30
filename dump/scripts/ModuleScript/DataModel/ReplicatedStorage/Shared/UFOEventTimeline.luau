-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	ATTR = "UFOEventAt",
	LEAD_SECONDS = 300,
	START = Vector3.new(24.163, -2084.536, 185.154),
	HOVER = Vector3.new(8.82, -2123.076, -495.824),
	PRE_ROLL = 3,
	FLY_IN = 14,
	BEAM_GROW = 1.5,
	DROP = 8,
	HOLD = 1.5,
	BEAM_SHRINK = 1.2,
	FLY_OUT = 10
}

module.ARRIVE_AT = module.PRE_ROLL + module.FLY_IN
module.STRAFE = 0.5
module.STRAFE_CHARGE_AT = module.PRE_ROLL + 5
module.STRAFE_READY_AT = module.PRE_ROLL + 7
module.SHOT_AT = { module.PRE_ROLL + 8.5, module.PRE_ROLL + 9.3, module.PRE_ROLL + 10.1 }
module.ULTRA_PREP_AT = module.PRE_ROLL + 11
module.ULTRA_FIRE_DELAY = 1.5
module.ALIEN_AT = module.ULTRA_PREP_AT + module.ULTRA_FIRE_DELAY
module.ALIEN_LIFETIME = 3600
module.BEAM_AT = module.ARRIVE_AT + module.STRAFE
module.SHOW_AT = module.BEAM_AT + module.BEAM_GROW
module.LANDED_AT = module.SHOW_AT + module.DROP
module.LEAVE_AT = module.LANDED_AT + module.HOLD + module.BEAM_SHRINK
module.TOTAL = module.LEAVE_AT + module.FLY_OUT

function module.Elapsed(p1)
	local attributeValue = p1:GetAttribute(module.ATTR)

	if typeof(attributeValue) == "number" then
		return workspace:GetServerTimeNow() - attributeValue
	end

	return nil
end
function module.Hiding(p2)
	local v5 = module.Elapsed(p2)

	return v5 ~= nil and v5 >= 0 and v5 < module.SHOW_AT
end

return module
