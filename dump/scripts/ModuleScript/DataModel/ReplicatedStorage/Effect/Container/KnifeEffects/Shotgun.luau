-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local knife = p4.Knife
	local toggle = p4.Toggle
end
