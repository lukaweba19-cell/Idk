-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local universe = require(script.Parent:WaitForChild("Universe"))
local module: {[any]: any} = {
	PREVIEW_OFFSET_ATTRIBUTE = "UpdateGate_PreviewOffset",
	UNRELEASED_PREVIEW_OFFSET = math.huge,
	PREVIEW_LEAD_SECONDS = 5,
	UPDATES = {
		Checkpoint = { ReleaseAt = 0 },
		Dash = { ReleaseAt = 0 },
		HalloweenBundles = { ReleaseAt = 0 },
		FrostRounds = {
			ReleaseAt = 1779469200,
			EventId = "1028268750018839186",
			TestEventId = "2439480659375424161"
		},
		Event2 = {
			ReleaseAt = 1780074000,
			EventId = "1879387983212315185",
			SignImage = 102039883917978
		},
		Event3 = {
			ReleaseAt = 1780678800,
			EventId = "4419567158217015868",
			SignImage = 107778755991148
		},
		Event4 = {
			ReleaseAt = 1781292600,
			EventId = "546333140046709329",
			SignImage = 70966778100352
		},
		Event5 = {
			ReleaseAt = 1783256400,
			EventId = "4226699955697484428",
			SignImage = 136605453307660
		},
		Event6 = {
			ReleaseAt = 1785081600,
			EventId = "1420475032328602264",
			SignImage = 96761344345961
		},
		Event7 = {
			ReleaseAt = 1785704400,
			EventId = "8297123901230678667",
			SignImage = 138715074192017
		},
		Event8 = {
			ReleaseAt = 1786903200,
			EventId = "405083951699460743",
			SignImage = 73731028686962
		},
		Event9 = {
			ReleaseAt = 1788112800,
			EventId = "5874283424767935045",
			SignImage = 84804732315779
		},
		Event10 = {
			ReleaseAt = 1788804000,
			EventId = "1803208408703304447",
			SignImage = 122784903335439
		},
		ClanRewardsMonthly = { ReleaseAt = 1788220800 }
	},
	DevGameId = universe.DEV_GAME_ID,
	RealGameId = universe.LIVE_GAME_ID,
	STATS_TRACKING_EPOCH = 1781292600,
	FINISHER_EXIST_COUNTS_AT = 1783515600,
	CLAN_REWARDS_MONTHLY_AT = 1788220800
}

function module.GetPreviewOffset()
	local attributeValue: any = replicatedStorage:GetAttribute(module.PREVIEW_OFFSET_ATTRIBUTE)

	return typeof(attributeValue) == "number" and attributeValue or 0
end
function module.GetCurrentTime()
	local timestamp = os.time()
	local v7 = module.GetPreviewOffset()

	return timestamp + v7
end
function module.Get(p1)
	return module.UPDATES[p1]
end
function module.ResolveEventId(p2)
	if game.GameId == module.DevGameId and p2.TestEventId then
		return p2.TestEventId
	end

	return p2.EventId
end
function module.IsReleased(p3)
	local v11 = module.UPDATES[p3]

	if not v11 then
		return true
	end

	return module.GetCurrentTime() >= v11.ReleaseAt
end
function module.GetAllKeys()
	local t2: {[any]: any} = {}

	for iterKey in pairs(module.UPDATES) do
		table.insert(t2, iterKey)
	end

	table.sort(t2)

	return t2
end
function module.SetPreviewOffset(p4)
	replicatedStorage:SetAttribute(module.PREVIEW_OFFSET_ATTRIBUTE, p4)

	return p4
end
function module.PreviewUpdate(p5)
	local v16 = module.UPDATES[p5]

	if not v16 then
		return nil, nil
	end

	if v16.ReleaseAt == math.huge then
		module.SetPreviewOffset(module.UNRELEASED_PREVIEW_OFFSET)

		return module.UNRELEASED_PREVIEW_OFFSET, "unreleased"
	end

	local n1 = v16.ReleaseAt - module.PREVIEW_LEAD_SECONDS
	local timestamp = os.time()

	v16 = n1 - timestamp

	if v16 < 0 then
		v16 = 0
	end

	module.SetPreviewOffset(v16)

	return v16, "transition"
end

if runService:IsServer() then
	require(game.ServerStorage.ConfigService).handleConfigUpdate("Event5ReleaseAt", function(releaseAt)
		local event5 = module.UPDATES.Event5

		if event5 and typeof(releaseAt) == "number" then
			warn(("[UpdateGate] Event5.ReleaseAt overridden via ConfigService: %d"):format(releaseAt))
			event5.ReleaseAt = releaseAt
		end
	end)
end

return module
