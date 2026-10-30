-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local knife = p1.Knife

	knife:SetAttribute("SpinSpeedOverride", 4)
	task.spawn(function()
		task.wait(0.005)

		local trail = knife:FindFirstChild("Trail")
		local trail2 = knife:FindFirstChild("Trail2")
		local trail3 = knife:FindFirstChild("Trail3")
		local trail4 = knife.Trail3x:FindFirstChild("Trail")

		if trail then
			trail.Enabled = true
		end

		if trail2 then
			trail2.Enabled = true
		end

		if trail3 then
			trail3.Enabled = true
		end

		if trail4 then
			trail4.Enabled = true
		end

		if trail then
			trail.Enabled = true
			trail2.Enabled = true
			trail3.Enabled = true
			trail4.Enabled = true
		end

		misc.EmitAll(knife)
	end)

	for _, v in pairs(knife:GetDescendants()) do
		if v:GetAttribute("EnableThrow") then
			v.Enabled = true
		end
	end

	knife:GetAttributeChangedSignal("Stuck"):Once(function()
		knife.Orientation = knife.Orientation + Vector3.new(90, 0, 0)

		for _, v in pairs(knife:GetDescendants()) do
			if v:GetAttribute("EnableThrow") then
				v.Enabled = false
			end
		end
	end)
end
