-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	Name = "rapprojected",
	Description = "MD [DEV] only: force the projected (possibly overvalued) RAP glyph on your cached RAP data. rapprojected on [kind itemId] | rapprojected off.",
	Group = "Admin",
	Args = {
		{ Type = "string", Name = "action", Description = "on | off" },
		{
			Type = "string",
			Name = "kind",
			Description = "on: Knife | Revolver | Finisher (default: every cached item)",
			Optional = true
		},
		{
			Type = "string",
			Name = "itemId",
			Description = "on: the catalog ItemId to stamp",
			Optional = true
		}
	},
	ClientRun = function(_, p2, p3, p4)
		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		if not require(shared:WaitForChild("Universe")).IsDev() then
			return "rapprojected only runs in the MD [DEV] universe."
		end

		local lowerText = string.lower(p2 or "")

		if lowerText == "on" or lowerText == "off" then
			local rapClient = require(shared:WaitForChild("RapClient"))

			if lowerText == "off" then
				rapClient.DebugForceProjected(false)

				return "Projected stamp cleared; RAP cache re-primed with real verdicts."
			end

			local v9 = if p3 == nil or p3 == "" then nil else p3
			local v10 = if p4 == nil or p4 == "" then nil else p4

			if v9 ~= nil ~= (v10 ~= nil) then
				return "Give both kind and itemId, or neither."
			end

			local v11 = rapClient.DebugForceProjected(true, v9, v10)

			if v11 ~= 0 then
				return ("Stamped %d cached item%s as projected. `rapprojected off` restores real verdicts."):format(v11, if v11 == 1 then "" else "s")
			end

			if v9 == nil then
				return "RAP cache is empty -- open the inventory or index first, then retry."
			end

			return (("%s:%s isn't in the RAP cache yet -- hover it or open the index, then retry."):format(v9, v10))
		end

		return "usage: rapprojected on [kind itemId] | rapprojected off"
	end
}
