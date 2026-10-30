-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local tweenService: TweenService = game:GetService("TweenService")

return function(p1)
	local cFrame = p1.CFrame

	if (workspace.CurrentCamera.CFrame.Position - cFrame.Position).Magnitude > 1000 + (p1.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit." .. script.Parent.Name, cFrame, nil, nil, nil, 0.2)

	local clone = game.ReplicatedStorage.FX.WallHitFX.DusekkarWallHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	debris:AddItem(clone, 2)
	misc.EmitAll(clone)

	local impactbamp = clone:FindFirstChild("IMPACTBAMP")
	local pointLight = impactbamp and impactbamp:FindFirstChildWhichIsA("PointLight")

	if pointLight then
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	end
end
