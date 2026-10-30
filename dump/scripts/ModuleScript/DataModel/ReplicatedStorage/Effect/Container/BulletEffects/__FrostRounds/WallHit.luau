-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Util.Create)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local effect = require(game.ReplicatedStorage.Effect)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)

return function(p1)
	local cFrame = p1.CFrame
	local v9 = p1.Scale or 1.75
	local hitPart = p1.HitPart

	if typeof(p1.Position) == "Vector3" and typeof(p1.Normal) == "Vector3" then
		effect.new("RevolverEffects.FrostIce"):replicate({ Position = p1.Position, Normal = p1.Normal })
	end

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + v9 * 10 then
		return
	end

	sound:Play("WallHit.BulletHits", cFrame)

	local clone = replicatedStorage.FX.BulletFX.Ice.DefaultHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin

	local pointLight = clone:FindFirstChildWhichIsA("PointLight")
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	local color3 = Color3.new(1, 1, 1)

	if hitPart then
		color3 = hitPart.Color
	end

	for _, v in pairs(clone:GetDescendants()) do
		if v.Name == "COLOR" then
			v.Color = ColorSequence.new(color3)
		end
	end
end
