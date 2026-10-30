-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	MIN_DISPLAY_STREAK = 2,
	RESTORE_COST_TIERS = { 250, 500, 1200, 2500, 5000 }
}

function module.GetRestoreCost(p1, p2)
	if p1 < module.MIN_DISPLAY_STREAK then
		return nil
	end

	local restore_cost_tiers = module.RESTORE_COST_TIERS
	local v5 = math.min((p2 or 0) + 1, #restore_cost_tiers)

	return restore_cost_tiers[v5]
end

return module
