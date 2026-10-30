-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")

return function(p1)
	local cFrame = p1.CFrame

	if (workspace.CurrentCamera.CFrame.Position - cFrame.Position).Magnitude > 1000 + (p1.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit.CustomBullets.Kitty", cFrame)

	local clone = game.ReplicatedStorage.FX.BulletFX.Kitty.DefaultHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("PointLight") then
			local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

			tweenService:Create(v, tweenInfo, { Brightness = 0 }):Play()
		end
	end
end
