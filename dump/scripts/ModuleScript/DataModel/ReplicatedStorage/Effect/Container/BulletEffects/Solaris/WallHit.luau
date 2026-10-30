-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Util.Create)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(game.ReplicatedStorage.Effect)

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local cFrame = p4.CFrame
	local hitPart = p4.HitPart

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + (p4.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit.CustomBullets.SolarisTrail", cFrame)

	local clone = replicatedStorage.FX.BulletFX.Solaris.DefaultHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	local color3 = Color3.new(1, 1, 1)

	if hitPart then
		color3 = hitPart.Color
	end

	local pointLight = clone.IMPACTBAMP.PointLight
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()

	for _, v in pairs(clone:GetDescendants()) do
		if v.Name == "COLOR" then
			v.Color = ColorSequence.new(color3)
		end
	end
end
