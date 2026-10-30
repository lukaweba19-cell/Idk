-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local cFrame = p4.CFrame

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + (p4.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit." .. script.Parent.Name, cFrame, nil, nil, nil, 0.3)

	local clone = game.ReplicatedStorage.FX.WallHitFX.IceWallHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	debris:AddItem(clone, 1)

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end

	local pointLight = clone.IMPACTBAMP.PointLight
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
end
