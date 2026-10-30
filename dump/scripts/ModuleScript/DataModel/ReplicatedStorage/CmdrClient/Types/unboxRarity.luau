-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1)
	local t1: {[any]: any} = { "legendary", "secret", "l", "s" }
	local u3 = nil

	p1:RegisterType("unboxRarity", {
		DisplayName = "Unbox Rarity",
		Transform = function(p2)
			return p2
		end,
		Validate = function(p3)
			if type(p3) == "string" and #p3 ~= 0 then
				return true
			end

			return false, "Expected a rarity string."
		end,
		Autocomplete = function(p4)
			if not u3 then
				u3 = p1.Cmdr.Util.MakeFuzzyFinder(t1)
			end

			return u3(p4 or "")
		end,
		Parse = function(p5)
			return p5
		end
	})
end
