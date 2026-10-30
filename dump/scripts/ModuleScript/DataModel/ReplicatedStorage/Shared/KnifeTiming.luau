-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	MELEE_COOLDOWN = 0.33,
	MELEE_COMBO = { "Stab1", "Stab2", "Stab3", "Stab4" },
	COMBO_RESET_SEC = 1,
	HOLD_TO_THROW_SEC = 0.2,
	CHARGE_DUR = 0.5,
	THROW_COOLDOWN = 0.3,
	THROW_HIDE_SEC = 0.5,
	MAX_SPREAD = 0.3
}

function module.NextCombo(p1: number, p2, p3)
	if p2 < p3 then
		p1 = 1
	end

	local n1: number = p1 + 1

	if n1 > #module.MELEE_COMBO then
		n1 = 1
	end

	return module.MELEE_COMBO[p1], n1, p3 + module.COMBO_RESET_SEC
end
function module.ApplyAnimSpeed(p4)
	local ok, result = pcall(function()
		return p4.Animation:GetAttribute("Speed")
	end)

	if ok and typeof(result) == "number" and result > 0 and result ~= 1 then
		p4:AdjustSpeed(result)
	end
end

return module
