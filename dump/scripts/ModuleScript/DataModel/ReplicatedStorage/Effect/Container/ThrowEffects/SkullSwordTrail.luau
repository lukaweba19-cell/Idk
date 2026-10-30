-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1)
	local knife = p1.Knife

	for _, v in pairs(knife:GetDescendants()) do
		if v:IsA("BasePart") and v:GetAttribute("ThrowVisible") then
			v.Transparency = 0
		end
	end

	task.spawn(function()
		task.wait(0.005)

		for _, v in pairs(knife:GetDescendants()) do
			if v:IsA("Trail") then
				v.Enabled = true
			end
		end
	end)

	for _, v in pairs(knife:GetDescendants()) do
		if v:GetAttribute("EnableThrow") then
			v.Enabled = true
		end
	end

	knife:GetAttributeChangedSignal("Stuck"):Once(function()
		for _, v in pairs(knife:GetDescendants()) do
			if v:GetAttribute("EnableThrow") then
				v.Enabled = false
			end
		end
	end)
end
