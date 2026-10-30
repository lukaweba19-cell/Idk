-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local knife = p1.Knife

	knife:SetAttribute("SpinSpeedOverride", 0)
	task.spawn(function()
		task.wait(0.005)

		if knife:FindFirstChild("Trail") then
			knife.Trail.Enabled = true

			for _, v in pairs(knife:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = true
				end
			end
		end
	end)

	if knife:IsA("BasePart") then
		knife:GetPropertyChangedSignal("Anchored"):Connect(function()
			if knife.Anchored and knife:FindFirstChild("Trail") then
				knife.Trail.Enabled = false

				for _, v in pairs(knife:GetDescendants()) do
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end
			end
		end)
	end
end
