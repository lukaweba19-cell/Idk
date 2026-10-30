-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local epicDuck = game.ReplicatedStorage.FX.KillEffects.EpicDuck
local epicDuckMesh = epicDuck.Mesh
local epicDuckSounds = epicDuck.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)

require(game.ReplicatedStorage.Util.Misc)

local v7 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v7
}

t1 = function(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local function hideCharacter(p4)
	for _, v in pairs(p4:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") then
				v.Enabled = false
			elseif not v:IsA("BillboardGui") and not v:IsA("SurfaceGui") then
				if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				end
			else
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end
end

v7 = function(parent, animationId)
	if not parent then
		return nil
	end

	local animator = parent:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = parent
	end

	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = animationId

	local animationTrack = animator:LoadAnimation(animation)

	animationTrack:Play()

	return animationTrack
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Mermaid: Folder = Instance.new("Folder")

		_fx_Mermaid.Name = "_FX_Mermaid"
		_fx_Mermaid.Parent = workspace.Bin

		if Character and Character.Parent then
			hideCharacter(Character)
		end

		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Mermaid:Destroy()
			end
		end)
		debris:AddItem(_fx_Mermaid, 7)

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")

		local v27 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		if not v27 then
			return
		end

		v27.Anchored = true

		local cFrame = Character.Torso.CFrame

		part.CFrame = CFrame.new(cFrame.p, cFrame.p - cFrame.LookVector * Vector3.new(1, 0, 1))

		local clone = epicDuckMesh.EpicDuck:Clone()

		for iterFirst, iterSecond in clone:GetDescendants() do
			if iterSecond:IsA("BasePart") then
				iterSecond.CollisionGroup = "Debris"
			end
		end

		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(0, 5000, 0)
		task.delay(0.033, function()
			if not clonePrimaryPart.Parent then
				return
			end

			local CFramePosition = workspace.CurrentCamera.CFrame.Position
			local v38 = part.CFrame.Position
			local vector3 = Vector3.new(CFramePosition.X, v38.Y, CFramePosition.Z)

			if (vector3 - v38).Magnitude < 0.01 then
				local partCFrame: CFrame = part.CFrame
				local v41 = CFrame.Angles(0, 3.141592653589793, 0)

				clonePrimaryPart.CFrame = partCFrame * v41

				return
			end

			clonePrimaryPart.CFrame = CFrame.lookAt(v38, vector3)
		end)

		local cloneDuck = clone.Duck
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(cloneDuck, tweenInfo, { Size = Vector3.new(6.793, 7.235, 9.794) }):Play()

		local v35 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.Duck1", v35)
		sound:Play("KillEffects.Duck2", v35)
		clone.Parent = _fx_Mermaid
		debris:AddItem(clone, 4)

		local animationTrack = clone.AnimationController.Animator:LoadAnimation(epicDuck.Animation)

		animationTrack:Play()
		task.spawn(function()
			task.wait(1.5)

			local cloneDuck = clone.Duck
			local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			tweenService:Create(cloneDuck, tweenInfo2, { Size = Vector3.new(0, 0, 0) }):Play()
			task.wait(0.3)
			clone:Destroy()
		end)

		return
	end
end
