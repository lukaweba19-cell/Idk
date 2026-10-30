-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(_, p2, player)
	local cFrame = nil

	if typeof(player) == "Instance" then
		if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
			return "Target player has no character."
		end

		cFrame = player.Character.HumanoidRootPart.CFrame
	elseif typeof(player) == "Vector3" then
		cFrame = CFrame.new(player)
	end

	for _, v in ipairs(p2) do
		if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			v.Character.HumanoidRootPart.CFrame = cFrame
		end
	end

	return ("Teleported %d players."):format(#p2)
end
