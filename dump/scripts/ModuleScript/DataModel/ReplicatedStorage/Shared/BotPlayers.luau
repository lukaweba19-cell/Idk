-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

t2.__index = t2

function t2.new(p1)
	local object = setmetatable({}, t2)

	object._folder = p1
	object.UserId = p1:GetAttribute("UserId") or -1
	object.DisplayName = p1:GetAttribute("DisplayName") or "Bot"
	object.Name = p1:GetAttribute("BotName") or "Bot"
	object.Team = nil
	object.Parent = players
	object.Character = nil
	object.Archivable = true
	object._attrSignals = {}
	object.AttributeChanged = p1.AttributeChanged

	return object
end
function t2.GetAttribute(p2, p3)
	return p2._folder:GetAttribute(p3)
end
function t2.SetAttribute(_, _, _)
end
function t2.GetAttributeChangedSignal(p7, p8)
	return p7._folder:GetAttributeChangedSignal(p8)
end
function t2.GetPropertyChangedSignal(p9, p10)
	return p9._folder:GetAttributeChangedSignal(p10)
end
function t2.IsA(_, p12)
	return p12 == "Player"
end
function t2.FindFirstChildOfClass(_, _)
	return nil
end
function t2.GetRankInGroup(_, _)
	return 0
end
local function getBotsFolder(p17)
	local activeMatches: Instance = replicatedStorage:FindFirstChild("ActiveMatches")

	if not activeMatches then
		return nil
	end

	local foundChild: Instance = activeMatches:FindFirstChild(p17)

	if not foundChild then
		return nil
	end

	return (foundChild:FindFirstChild("Bots"))
end

local t3: {[any]: any} = {}
local t4: {[any]: any} = {}

local module: {[any]: any} = {
	SetOverride = function(p18, p19)
		t3[p18] = p19
	end,
	SetMatchNode = function(p20, p21)
		t4[p20] = p21
	end,
	GetMatchNode = function(p22)
		local v34 = t4[p22]

		if v34 then
			return v34
		end

		local activeMatches: Instance = replicatedStorage:FindFirstChild("ActiveMatches")

		if not activeMatches then
			return nil
		end

		return activeMatches:FindFirstChild(p22)
	end,
	IsLiveMatch = function(p23)
		local activeMatches: Instance = replicatedStorage:FindFirstChild("ActiveMatches")

		if not activeMatches then
			return false
		end

		return activeMatches:FindFirstChild(p23) ~= nil
	end,
	NewProxy = function(p24)
		return t2.new(p24)
	end,
	GetBotProxies = function(p25)
		local v40 = t3[p25]

		if v40 then
			return v40
		end

		local activeMatches: Instance = replicatedStorage:FindFirstChild("ActiveMatches")
		local v42

		if not activeMatches then
			v42 = nil
		else
			local foundChild: Instance = activeMatches:FindFirstChild(p25)

			v42 = if not foundChild then nil else foundChild:FindFirstChild("Bots")
		end

		if not v42 then
			return {}
		end

		local t6 = t1[p25]

		if not t6 then
			t6 = {}
			t1[p25] = t6
		end

		local t7: {[any]: any} = {}

		for _, v in ipairs(v42:GetChildren()) do
			if v:IsA("Folder") then
				t7[v.Name] = v
			end
		end

		for i = #t6, 1, -1 do
			if not t7[t6[i].Name] then
				table.remove(t6, i)
			end
		end

		local t8: {[any]: any} = {}

		for _, v in ipairs(t6) do
			t8[v.Name] = true
		end

		for k, v in pairs(t7) do
			if not t8[k] then
				local v54 = t2.new(v)

				table.insert(t6, v54)
			end
		end

		return t6
	end
}

function module.GetMatchParticipants(p26)
	local t9: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		local matchId = v:GetAttribute("MatchId")

		if p26 == matchId then
			table.insert(t9, v)
		end
	end

	for _, v in ipairs(module.GetBotProxies(p26)) do
		table.insert(t9, v)
	end

	return t9
end
function module.IsBotProxy(p27)
	return getmetatable(p27) == t2
end
function module.GetBotProxiesForSide(p28, p29)
	local t10: {[any]: any} = {}

	for _, v in ipairs(module.GetBotProxies(p28)) do
		local matchSide = v:GetAttribute("MatchSide")

		if p29 == matchSide then
			table.insert(t10, v)
		end
	end

	return t10
end

return module
