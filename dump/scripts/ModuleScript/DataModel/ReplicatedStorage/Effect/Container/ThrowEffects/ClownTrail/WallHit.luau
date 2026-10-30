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

	sound:Play("WallHit." .. script.Parent.Name, cFrame)

	local clone = game.ReplicatedStorage.FX.WallHitFX.ClownWallHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	local impactbamp = clone:FindFirstChild("IMPACTBAMP")

	if impactbamp then
		impactbamp = clone.IMPACTBAMP:FindFirstChildWhichIsA("PointLight")
	end

	if impactbamp then
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

		tweenService:Create(impactbamp, tweenInfo, { Brightness = 0 }):Play()
	end
end
