-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)

game:GetService("TweenService")

return function(p1)
	local knife = p1.Knife

	knife:SetAttribute("SpinSpeedOverride", 7)
	task.spawn(function()
		task.wait(0.005)

		for _, v in ipairs({ "Trail1", "Trail2" }) do
			local v = knife:FindFirstChild(v)
			local trail = v and v:FindFirstChild("Trail")

			if trail then
				trail.Enabled = true
			end
		end

		misc.EmitAll(knife)
	end)

	for _, v in pairs(knife:GetDescendants()) do
		if v:GetAttribute("EnableThrow") then
			v.Enabled = true
		end
	end

	knife:GetAttributeChangedSignal("Stuck"):Once(function()
		for _, v in pairs(knife:GetDescendants()) do
			if v:GetAttribute("EnableThrow") then
				v:Destroy()
			end
		end
	end)
end
