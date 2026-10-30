-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local paintbrushColors = require(game.ReplicatedStorage.Shared.PaintbrushColors)

return function(p1)
	local knife = p1.Knife
	local v5 = if typeof(p1.OwnerUserId) == "number" then players:GetPlayerByUserId(p1.OwnerUserId) else nil
	local paintbrushColorsThrow_attr = paintbrushColors.THROW_ATTR
	local v7 = paintbrushColors.Current(v5) or paintbrushColors.FALLBACK

	knife:SetAttribute(paintbrushColorsThrow_attr, v7)

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
