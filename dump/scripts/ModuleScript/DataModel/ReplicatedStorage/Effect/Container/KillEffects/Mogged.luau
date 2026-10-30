-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local debris = require(game.ReplicatedStorage.Util.Debris)
local mogged = game.ReplicatedStorage.FX.KillEffects.Mogged
local moggedMesh = mogged.Mesh
local moggedSounds = mogged.Sounds

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local function createsfx(parent, p6)
			local clone = p6:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		sound:Play("KillEffects.Mogged", Character.Torso)

		local clone = moggedMesh.Part.Mogged:Clone()

		clone.Parent = Character:FindFirstChild("Head")
		clone.Mogged:Emit(1)
	end
end
