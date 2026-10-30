-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local httpService: HttpService = game:GetService("HttpService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(p1)
	local u4 = nil
	local u5 = nil

	local function getList()
		if u4 then
			return u4
		end

		local cmdrLists: Instance = replicatedStorage:WaitForChild("CmdrLists", 10)

		if not cmdrLists then
			return {}
		end

		local knifeSkins: Instance = cmdrLists:WaitForChild("KnifeSkins", 10)

		if not knifeSkins then
			return {}
		end

		local ok, result = pcall(function()
			return httpService:JSONDecode(knifeSkins.Value)
		end)

		if ok and type(result) == "table" then
			u4 = result

			return result
		end

		return {}
	end

	p1:RegisterType("knifeSkin", {
		DisplayName = "Knife Skin",
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
				local v15 = getList()

				u5 = makeFuzzyFinder(v15)
			end

			return u5(p4 or "")
		end,
		Parse = function(p5)
			return p5
		end
	})
end
