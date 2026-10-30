-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local teleportService: TeleportService = game:GetService("TeleportService")

return function(_, p2, p3)
	local v5 = p3 or "PlaceIdJobId"

	local v6, v7, v8, v9, v10 = pcall(function()
		return teleportService:GetPlayerPlaceInstanceAsync(p2)
	end)

	if not v6 or v8 and #v8 > 0 then
		if v5 == "PlaceIdJobId" then
			return "0 -"
		end

		if v5 == "PlaceId" then
			return "0"
		end

		if v5 == "JobId" then
			return "-"
		end
	end

	if v5 == "PlaceIdJobId" then
		return v9 .. " " .. v10
	end

	if v5 == "PlaceId" then
		return (tostring(v9))
	end

	if v5 == "JobId" then
		return (tostring(v10))
	end
end
