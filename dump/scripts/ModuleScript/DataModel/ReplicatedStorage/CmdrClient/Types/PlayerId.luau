-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local players: Players = game:GetService("Players")
local t1: {[any]: any} = {}

local function getUserId(p1)
	if t1[p1] then
		return t1[p1]
	end

	if players:FindFirstChild(p1) then
		t1[p1] = players[p1].UserId

		return players[p1].UserId
	end

	local ok, result = pcall(players.GetUserIdFromNameAsync, players, p1)

	if not ok then
		return nil
	end

	t1[p1] = result

	return result
end

local t2: {[any]: any} = {
	DisplayName = "Full Player Name",
	Prefixes = "# integer",
	Transform = function(p2)
		local v10 = util.MakeFuzzyFinder(players:GetPlayers())

		return p2, v10(p2)
	end,
	ValidateOnce = function(p3)
		local v12

		if t1[p3] then
			v12 = t1[p3]
		elseif players:FindFirstChild(p3) then
			t1[p3] = players[p3].UserId
			v12 = players[p3].UserId
		else
			local ok, result = pcall(players.GetUserIdFromNameAsync, players, p3)

			if not ok then
				v12 = nil
			else
				t1[p3] = result
				v12 = result
			end
		end

		return v12 ~= nil, "No player with that name could be found."
	end,
	Autocomplete = function(_, p5)
		return util.GetNames(p5)
	end,
	Parse = function(p6)
		if t1[p6] then
			return t1[p6]
		end

		if players:FindFirstChild(p6) then
			t1[p6] = players[p6].UserId

			return players[p6].UserId
		end

		local ok, result = pcall(players.GetUserIdFromNameAsync, players, p6)

		if not ok then
			return nil
		end

		t1[p6] = result

		return result
	end,
	Default = function(p7)
		return p7.Name
	end,
	ArgumentOperatorAliases = { me = ".", all = "*", others = "**", random = "?" }
}

return function(p8)
	p8:RegisterType("playerId", t2)
	p8:RegisterType("playerIds", util.MakeListableType(t2, { Prefixes = "# integers" }))
end
