-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Util.Create)

local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(game.ReplicatedStorage.Effect)

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)

return function(p1)
	local cFrame = p1.CFrame
	local hitPart = p1.HitPart

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + (p1.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit.BulletHits", cFrame)
	sound:Play("WallHit.CutsomBullets.Lightning", cFrame)

	local clone = replicatedStorage.FX.BulletFX.Lightning.DefaultHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
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
