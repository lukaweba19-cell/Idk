-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)

return function(p1)
	local v5 = p1.Position

	sound:Play("WallHit.Ricochet", v5)

	local clone = game.ReplicatedStorage.FX.WallHitFX.Ricochet:Clone()

	clone.CFrame = CFrame.new(v5)
	clone.Parent = workspace.Bin
	debris:AddItem(clone, 1.15)
	misc.EmitAll(clone)
end
