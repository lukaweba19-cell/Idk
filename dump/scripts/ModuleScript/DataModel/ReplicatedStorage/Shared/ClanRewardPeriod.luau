-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local updateGate = require(shared:WaitForChild("UpdateGate"))
local module: {[any]: any} = {
	UPDATE_KEY = "ClanRewardsMonthly",
	EPOCH = updateGate.CLAN_REWARDS_MONTHLY_AT,
	MIN_KILLS = 1000,
	TOP_CLANS = 5
}

function module.Active()
	if updateGate.GetCurrentTime() >= module.EPOCH then
		return "Monthly"
	end

	return "AllTime"
end
function module.IsMonthly()
	return module.Active() == "Monthly"
end
function module.NextResetAt()
	local v4 = updateGate.GetCurrentTime()

	if v4 < module.EPOCH then
		return module.EPOCH
	end

	local dateText = os.date("!*t", v4)

	v4 = dateText.month + 1

	local v6 = dateText.year

	if v4 > 12 then
		v4 = 1
		v6 += 1
	end

	local timestamp = os.time({ day = 1, hour = 0, min = 0, sec = 0, year = v6, month = v4 })
	local timestamp2 = os.time()
	local v9 = os.difftime(timestamp2, os.time(os.date("!*t", timestamp2)))

	return timestamp + v9
end
function module.SecondsUntilReset()
	local v10 = module.NextResetAt()
	local v11 = updateGate.GetCurrentTime()

	return (math.max(0, v10 - v11))
end

return module
