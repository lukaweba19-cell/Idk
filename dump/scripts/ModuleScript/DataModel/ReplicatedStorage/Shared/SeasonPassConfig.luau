-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	CurrentSeasonId = "S2",
	TierCount = 16,
	StartsAtUnix = 1792260000,
	EndsAtUnix = 1795374000
}

module.SeasonDurationDays = (module.EndsAtUnix - module.StartsAtUnix) / 86400
module.XpPerTier = {
	200,
	300,
	450,
	700,
	1000,
	1350,
	1750,
	2250,
	2800,
	3450,
	4200,
	5050,
	6000,
	6800,
	7700,
	6000
}
module.XpFromMatchExp = 0.26
module.MaxXpPerMatch = 500
module.WeeklyXpCap = 0

function module.WeekIndex(p1)
	local n1 = (p1 or os.time()) - module.StartsAtUnix

	if n1 < 0 then
		return 0
	end

	return (math.floor(n1 / 604800))
end

module.PremiumXpMultiplier = 1.2
module.PremiumRobux = 639
module.PremiumProductId = 3612436210
module.GiftPremiumProductId = 3612451670
module.PremiumCompareAtRobux = 600
module.SkipTierRobux = {
	19,
	19,
	19,
	29,
	39,
	49,
	69,
	99,
	129,
	179,
	239,
	299,
	399,
	499,
	515
}
module.SkipTierProductIds = {
	3612435650,
	3612435688,
	3612435743,
	3612435779,
	3612435811,
	3612435845,
	3612435873,
	3612435899,
	3612435946,
	3612435976,
	3612436013,
	3612436061,
	3612436085,
	3612436127,
	3612436192
}

function module.TotalXpToTier(p2)
	local floored = math.floor(p2)
	local n1 = 0

	for i = 1, math.clamp(floored, 0, module.TierCount) do
		n1 += module.XpPerTier[i] or 0
	end

	return n1
end
function module.TierForXp(p3)
	local v9 = math.max(p3 or 0, 0)
	local n1: number = 0

	while true do
		local v11 = n1 < module.TierCount and module.XpPerTier[n1 + 1]

		if not v11 or v9 < v11 then
			break
		end

		v9 -= v11
		n1 += 1
	end

	return n1
end
function module.TierProgress(p4)
	local v13 = module.TierForXp(p4)

	if v13 >= module.TierCount then
		return 0, 0
	end

	local v14 = math.max(p4 or 0, 0)
	local v15 = module.TotalXpToTier(v13)

	return v14 - v15, module.XpPerTier[v13 + 1] or 0
end
function module.SkipCostForTier(p5)
	local n1 = math.floor(p5 or 0) + 1

	if n1 < 1 or n1 > module.TierCount then
		return 0, 0
	end

	return module.SkipTierRobux[n1] or 0, module.SkipTierProductIds[n1] or 0
end
function module.TierForSkipProduct(p6)
	if type(p6) == "number" and p6 ~= 0 then
		for k, v in pairs(module.SkipTierProductIds) do
			if v == p6 then
				return k
			end
		end

		return nil
	end

	return nil
end
function module.IsSkipProduct(p7)
	return module.TierForSkipProduct(p7) ~= nil
end
function module.IsLaunched(p8)
	return (p8 or os.time()) >= module.StartsAtUnix
end
function module.IsActive(p9)
	local v24 = p9 or os.time()

	return v24 >= module.StartsAtUnix and v24 < module.EndsAtUnix
end
function module.SecondsRemaining(p10)
	local endsAtUnix = module.EndsAtUnix
	local v27 = p10 or os.time()

	return (math.max(endsAtUnix - v27, 0))
end

return module
