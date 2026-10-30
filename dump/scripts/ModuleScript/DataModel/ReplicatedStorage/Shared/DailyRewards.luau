-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	CYCLE_LENGTH = 7,
	CLAIM_COOLDOWN_SEC = 57600,
	STREAK_BREAK_SEC = 172800,
	FAST_CLAIM_COOLDOWN_SEC = 10,
	FAST_STREAK_BREAK_SEC = 30
}

local function getCooldownAndStreakBreak()
	if workspace:GetAttribute("FastDailyGifts") == true then
		return module.FAST_CLAIM_COOLDOWN_SEC, module.FAST_STREAK_BREAK_SEC
	end

	return module.CLAIM_COOLDOWN_SEC, module.STREAK_BREAK_SEC
end

module.Rewards = {
	{
		Day = 1,
		Reward = { Kind = "Coins", Amount = 300 }
	},
	{
		Day = 2,
		Reward = { Kind = "Coins", Amount = 300 }
	},
	{
		Day = 3,
		Reward = { Kind = "Coins", Amount = 600 }
	},
	{
		Day = 4,
		Reward = { Kind = "Coins", Amount = 300 }
	},
	{
		Day = 5,
		Reward = { Kind = "Cases", CrateId = "RecruitCase", Amount = 1 }
	},
	{
		Day = 6,
		Reward = { Kind = "Coins", Amount = 300 }
	},
	{
		Day = 7,
		Reward = { Kind = "Cases", CrateId = "HallowsCase", Amount = 1 }
	}
}

function module.DeriveClaimState(p1, p2, p3)
	local cycle_length = module.CYCLE_LENGTH
	local v7
	local v8

	if workspace:GetAttribute("FastDailyGifts") == true then
		v7 = module.FAST_CLAIM_COOLDOWN_SEC
		v8 = module.FAST_STREAK_BREAK_SEC
	else
		v7 = module.CLAIM_COOLDOWN_SEC
		v8 = module.STREAK_BREAK_SEC
	end

	if p2 <= 0 or p1 <= 0 then
		return {
			CurrentDay = 1,
			IsClaimable = true,
			SecondsUntilClaim = 0,
			StreakReset = false
		}
	end

	local n1 = p3 - p2

	if v7 > n1 then
		return {
			IsClaimable = false,
			StreakReset = false,
			CurrentDay = p1 % cycle_length + 1,
			SecondsUntilClaim = v7 - n1
		}
	end

	if v8 > n1 then
		return {
			IsClaimable = true,
			SecondsUntilClaim = 0,
			StreakReset = false,
			CurrentDay = p1 % cycle_length + 1
		}
	end

	return {
		CurrentDay = 1,
		IsClaimable = true,
		SecondsUntilClaim = 0,
		StreakReset = true
	}
end

return module
