-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local teams: Teams = game:GetService("Teams")
local util = require(script.Parent.Parent.Shared.Util)

local t1: {[any]: any} = {
	Transform = function(p1)
		return util.MakeFuzzyFinder(teams:GetTeams())(p1)
	end,
	Validate = function(p2)
		return #p2 > 0, "No team with that name could be found."
	end,
	Autocomplete = function(p3)
		return util.GetNames(p3)
	end,
	Parse = function(p4)
		return p4[1]
	end
}

local t2: {[any]: any} = {
	Listable = true,
	Transform = t1.Transform,
	Validate = t1.Validate,
	Autocomplete = t1.Autocomplete,
	Parse = function(p5)
		return p5[1]:GetPlayers()
	end
}

local t3: {[any]: any} = {
	Transform = t1.Transform,
	Validate = t1.Validate,
	Autocomplete = t1.Autocomplete,
	Parse = function(p6)
		return p6[1].TeamColor
	end
}

return function(p7)
	p7:RegisterType("team", t1)
	p7:RegisterType("teams", util.MakeListableType(t1))
	p7:RegisterType("teamPlayers", t2)
	p7:RegisterType("teamColor", t3)
	p7:RegisterType("teamColors", util.MakeListableType(t3))
end
