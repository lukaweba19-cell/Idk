-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local players: Players = game:GetService("Players")

local t1: {[any]: any} = {
	Transform = function(p1)
		return util.MakeFuzzyFinder(players:GetPlayers())(p1)
	end,
	Validate = function(p2)
		return #p2 > 0, "No player with that name could be found."
	end,
	Autocomplete = function(p3)
		return util.GetNames(p3)
	end,
	Parse = function(p4)
		return p4[1]
	end,
	Default = function(p5)
		return p5.Name
	end,
	ArgumentOperatorAliases = { me = ".", all = "*", others = "**", random = "?" }
}

return function(p6)
	p6:RegisterType("player", t1)
	p6:RegisterType("players", util.MakeListableType(t1, { Prefixes = "% teamPlayers" }))
end
