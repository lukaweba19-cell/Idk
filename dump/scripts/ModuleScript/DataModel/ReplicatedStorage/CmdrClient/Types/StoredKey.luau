-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local t1: {[any]: any} = { "^%a[%w_]*$", "^%$%a[%w_]*$", "^%.%a[%w_]*$", "^%$%.%a[%w_]*$" }

return function(p1)
	local t2: {[any]: any} = {
		Autocomplete = function(p2)
			local makeFuzzyFinder = p1.Cmdr.Util.MakeFuzzyFinder
			local dictionaryKeys = p1.Cmdr.Util.DictionaryKeys
			local t3 = p1:GetStore("vars_used") or {}

			return makeFuzzyFinder(dictionaryKeys(t3))(p2)
		end,
		Validate = function(p3)
			for _, v in ipairs(t1) do
				if p3:match(v) then
					return true
				end
			end

			return false, "Key names must start with an optional modifier: . $ or $. and must begin with a letter."
		end,
		Parse = function(p4)
			return p4
		end
	}

	p1:RegisterType("storedKey", t2)
	p1:RegisterType("storedKeys", util.MakeListableType(t2))
end
