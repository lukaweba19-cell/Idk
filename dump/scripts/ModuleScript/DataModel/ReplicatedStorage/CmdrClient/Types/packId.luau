-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local packCatalog = require(replicatedStorage.Shared:WaitForChild("PackCatalog"))

return function(p1)
	local function getList()
		local t1: {[any]: any} = {}

		for iterKey in pairs(packCatalog.Packs) do
			table.insert(t1, iterKey)
		end

		table.sort(t1)

		return t1
	end

	p1:RegisterType("packId", {
		DisplayName = "Pack",
		Transform = function(p2)
			return p2
		end,
		Validate = function(p3)
			if type(p3) == "string" and #p3 ~= 0 then
				if packCatalog.Get(p3) == nil then
					return false, ("'%s' is not a pack in PackCatalog."):format(p3)
				end

				return true
			end

			return false, "Expected a non-empty string."
		end,
		Autocomplete = function(p4)
			local makeFuzzyFinder = p1.Cmdr.Util.MakeFuzzyFinder
			local v11 = getList()

			return makeFuzzyFinder(v11)(p4 or "")
		end,
		Parse = function(p5)
			return p5
		end
	})
end
