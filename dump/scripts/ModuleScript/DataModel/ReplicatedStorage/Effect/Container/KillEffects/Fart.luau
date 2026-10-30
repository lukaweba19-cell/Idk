-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local debris = require(game.ReplicatedStorage.Util.Debris)
local fart = game.ReplicatedStorage.FX.KillEffects.Fart
local fartMesh = fart.Mesh
local fartSounds = fart.Sounds

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

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 2.2, 0)
		sound:Play("KillEffects.Fart", Character.Torso)

		local clone = fartMesh.Part.Attachment:Clone()

		clone.Parent = Character:FindFirstChild("Torso")
		clone.Fart:Emit(25)
		debris:AddItem(clone, 2.5)
	end
end
