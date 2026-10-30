-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)

return function(p1)
	local t1: {[any]: any} = {
		Transform = function(p2)
			return util.MakeFuzzyFinder(p1:GetCommandNames())(p2)
		end,
		Validate = function(p3)
			return #p3 > 0, "No command with that name could be found."
		end,
		Autocomplete = function(p4)
			return p4
		end,
		Parse = function(p5)
			return p5[1]
		end
	}

	p1:RegisterType("command", t1)
	p1:RegisterType("commands", util.MakeListableType(t1))
end
