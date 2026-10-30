-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local knockout = game.ReplicatedStorage.FX.KillEffects.KNOCKOUT
local knockoutMesh = knockout.Mesh
local knockoutSounds = knockout.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_knockout: Folder = Instance.new("Folder")

		_fx_knockout.Name = "_FX_KNOCKOUT"
		_fx_knockout.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_knockout:Destroy()
			end
		end)
		debris:AddItem(_fx_knockout, 7)

		local function createsfx(parent, p6)
			local clone = p6:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 2.2, 0)

		local clone = knockoutMesh.Glove:Clone()
		local HumanoidRootPart = clone.HumanoidRootPart
		local partCFrame: CFrame = part.CFrame
		local v20 = CFrame.Angles(0, 0, -1.5707963267948966)

		HumanoidRootPart.CFrame = partCFrame * CFrame.new(0, 5000, 0) * v20
		clone.Parent = _fx_knockout
		debris:AddItem(clone, 3)
		clone.AnimationController.Animator:LoadAnimation(knockout.Animation):Play()
		wait(0.18)

		local clone2 = knockoutSounds.POT:Clone()

		clone2.Parent = clone.HumanoidRootPart
		clone2:Play()
		debris:AddItem(clone2, 5)
		HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3.5, 0)
		clone.Handle.EM.KO:Emit(1)
		clone.Handle.EM.Wind:Emit(1)
		wait(0.7)

		local tweenInfo = TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(HumanoidRootPart, tweenInfo, { CFrame = part.CFrame * CFrame.new(0, -10, 0) }):Play()
	end
end
