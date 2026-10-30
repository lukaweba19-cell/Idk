-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local knife = p1.Knife

	task.spawn(function()
		task.wait(0.005)

		local trail = knife:FindFirstChild("Trail")
		local trail2 = knife:FindFirstChild("Trail2")

		if trail then
			trail.Enabled = true
		end

		if trail2 then
			trail2.Enabled = true
		end

		misc.EmitAll(knife)

		for _, v in pairs(knife:GetDescendants()) do
			if v:GetAttribute("EnableThrow") then
				v.Enabled = true
			end
		end

		knife:GetAttributeChangedSignal("Stuck"):Once(function()
			for _, v in pairs(knife:GetDescendants()) do
				if v:GetAttribute("EnableThrow") then
					v.Enabled = false

					if trail then
						trail.Enabled = false
					end
				end
			end
		end)
	end)
end
