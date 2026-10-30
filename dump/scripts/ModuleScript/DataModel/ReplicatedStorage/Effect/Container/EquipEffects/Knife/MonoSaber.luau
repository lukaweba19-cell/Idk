-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("TweenService")
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)
require(game.ReplicatedStorage.Util.Misc)
require(game.ReplicatedStorage.Util.Debris)

return function(p1)
	local v2 = p1.Revolver or p1.Knife

	if (workspace.CurrentCamera.CFrame.Position - v2.Position).Magnitude < 1000 then
		local randomNumber = math.random(1, 999999999)

		v2:SetAttribute("EquipState", randomNumber)

		local function invalid()
			local equipState = v2:GetAttribute("EquipState")

			return randomNumber ~= equipState
		end

		if p1.Toggle then
			task.delay(0.4, function()
				local equipState = v2:GetAttribute("EquipState")

				if randomNumber ~= equipState then
					return
				end

				for _, v in pairs(v2:GetDescendants()) do
					if v:IsA("Beam") and v.Name == "SaberBeam" then
						v.Enabled = true
					end
				end
			end)

			return
		end

		for _, v in pairs(v2:GetDescendants()) do
			if v:IsA("Beam") and v.Name == "SaberBeam" then
				v.Enabled = false
			end
		end

		return
	end
end
