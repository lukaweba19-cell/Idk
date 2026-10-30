-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local teleportService: TeleportService = game:GetService("TeleportService")

return function(p1, p2, p3, p4)
	local t1 = p2 or { p1.Executor }

	if p3 <= 0 then
		return "Invalid place ID"
	end

	if p4 == "-" then
		return "Invalid job ID"
	end

	p1:Reply("Commencing teleport...")

	if p4 then
		for _, v in ipairs(t1) do
			teleportService:TeleportToPlaceInstance(p3, p4, v)
		end
	else
		teleportService:TeleportAsync(p3, t1)
	end

	return "Teleported."
end
