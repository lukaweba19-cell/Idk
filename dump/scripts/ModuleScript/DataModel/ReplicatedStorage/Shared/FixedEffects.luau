-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local httpService: HttpService = game:GetService("HttpService")

local function attrFor(p1)
	return p1 .. "FixedEffectsJSON"
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

return {
	KNIFE = "Knife",
	REVOLVER = "Revolver",
	Publish = function(p2, p3)
		local ok, result = pcall(function()
			return httpService:JSONEncode(p3)
		end)

		if not ok then
			warn("[FixedEffects] Could not encode map for", p2)

			return
		end

		script:SetAttribute(p2 .. "FixedEffectsJSON", result)
	end,
	For = function(p4, p5)
		if typeof(p5) == "string" and p5 ~= "" then
			local attributeValue: any = script:GetAttribute(p4 .. "FixedEffectsJSON")

			if typeof(attributeValue) == "string" and attributeValue ~= "" then
				if attributeValue ~= t2[p4] then
					local ok, result = pcall(function()
						return httpService:JSONDecode(attributeValue)
					end)

					t1[p4] = ok and typeof(result) == "table" and result or {}
					t2[p4] = attributeValue
				end

				local v15 = t1[p4][p5]

				return typeof(v15) == "string" and v15 ~= "" and v15 or "Default"
			end

			return "Default"
		end

		return "Default"
	end
}
