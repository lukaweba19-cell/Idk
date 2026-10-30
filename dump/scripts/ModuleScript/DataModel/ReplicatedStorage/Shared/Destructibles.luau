-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	RespawnSeconds = 5,
	RebroadcastCooldown = 4.5,
	GetHitKind = function(p1)
		if not p1 or not p1:IsA("BasePart") then
			return "none"
		end

		if p1.Name == "__Glass" then
			return "glass"
		end

		local v3 = p1.Parent

		if v3 and v3.Name == "Target" then
			return "targetModel"
		end

		if v3 and v3.Name == "Balloon" then
			return "balloon"
		end

		if v3 and v3.Name == "Monitor" then
			return "monitor"
		end

		if v3 and v3.Name == "PumpkinFR" then
			return "pumpkin"
		end

		if p1.Name == "Target" then
			return "targetPart"
		end

		if p1.Name == "PlayerBarrier" then
			return "playerBarrier"
		end

		return "none"
	end
}

function module.IsDestructible(p2)
	return module.GetHitKind(p2) ~= "none"
end
function module.AddToIgnore(p3, p4, p5)
	if not p4 then
		return
	end

	local v8 = p5 or module.GetHitKind(p4)

	if p4.Parent and (v8 == "targetModel" or v8 == "pumpkin") then
		table.insert(p3, p4.Parent)

		return
	end

	table.insert(p3, p4)
end

return module
