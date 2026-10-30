-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local updateGate = require(shared:WaitForChild("UpdateGate"))

return function(p1)
	local u4 = nil

	p1:RegisterType("updateKey", {
		DisplayName = "UpdateKey",
		Transform = function(p2)
			return p2
		end,
		Validate = function(p3)
			if type(p3) == "string" and #p3 ~= 0 then
				return true
			end

			return false, "Expected a non-empty string."
		end,
		Autocomplete = function(p4)
			if not u4 then
				u4 = p1.Cmdr.Util.MakeFuzzyFinder(updateGate.GetAllKeys())
			end

			return u4(p4 or "")
		end,
		Parse = function(p5)
			return p5
		end
	})
end
