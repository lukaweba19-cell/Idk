-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local abilityCatalog = require(replicatedStorage.Catalogs:WaitForChild("AbilityCatalog"))

return function(p1)
	local function getList()
		local v6 = abilityCatalog.GetAll()
		local t1: {[any]: any} = {}

		for iterKey in pairs(v6) do
			table.insert(t1, iterKey)
		end

		table.sort(t1)

		return t1
	end

	local u5 = nil

	p1:RegisterType("ability", {
		DisplayName = "Ability",
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
			if not u5 then
				local makeFuzzyFinder = p1.Cmdr.Util.MakeFuzzyFinder
				local v13 = getList()

				u5 = makeFuzzyFinder(v13)
			end

			return u5(p4 or "")
		end,
		Parse = function(p5)
			return p5
		end
	})
end
