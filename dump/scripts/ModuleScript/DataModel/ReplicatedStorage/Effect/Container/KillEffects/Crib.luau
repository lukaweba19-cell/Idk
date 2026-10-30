-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local crib = game.ReplicatedStorage.FX.KillEffects.Crib
local cribMesh = crib.Mesh
local cribSounds = crib.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
local v6 = CFrame.Angles(0, 3.141592653589793, 0)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end
local function cancelRagdoll(p4)
	local humanoid = p4:FindFirstChild("Humanoid")
	local torso = p4:FindFirstChild("Torso")

	if humanoid and torso then
		for _, v in pairs({ "Left Hip", "Left Shoulder", "Neck", "Right Shoulder", "Right Hip" }) do
			local v = torso:FindFirstChild(v)

			if v then
				v.Enabled = true
			end
		end

		local humanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			local rootJoint = humanoidRootPart:FindFirstChild("RootJoint")

			if rootJoint then
				rootJoint.Enabled = true
			end
		end

		for _, v in pairs(p4:GetDescendants()) do
			if v:IsA("BallSocketConstraint") then
				v:Destroy()
			end
		end

		for _, v in pairs({
			"TorsoToHead0",
			"TorsoToHead1",
			"TorsoToRightArm0",
			"TorsoToRightArm1",
			"TorsoToLeftArm0",
			"TorsoToLeftArm1",
			"TorsoToRightLeg0",
			"TorsoToRightLeg1",
			"TorsoToLeftLeg0",
			"TorsoToLeftLeg1"
		}) do
			for _, iterValue in pairs(p4:GetDescendants()) do
				if iterValue:IsA("Attachment") and v == iterValue.Name then
					iterValue:Destroy()
				end
			end
		end

		humanoid.AutoRotate = true
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

		return humanoid
	end
end
local function playAnimation(parent, animationId)
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

local t1: {[any]: any} = {
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, -0.5, 0),
	VictimRotation = v6
}

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Crib: Folder = Instance.new("Folder")

		_fx_Crib.Name = "_FX_Crib"
		_fx_Crib.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Crib:Destroy()
			end
		end)
		debris:AddItem(_fx_Crib, 7)

		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")

		local v40 = Character.Torso.CFrame
		local cFrame = CFrame.new(v40.p, v40.p + v40.LookVector * Vector3.new(1, 0, 1))
		local v42 = CFrame.Angles(0, -1.5707963267948966, 0)
		local v43 = CFrame.Angles(0, 3.141592653589793, 0)

		part.CFrame = cFrame * v42 * v43

		local clone = cribMesh.Crib:Clone()
		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(0, -8, 0)
		clone.Parent = _fx_Crib
		debris:AddItem(clone, 6)

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(clonePrimaryPart, tweenInfo, { CFrame = part.CFrame * CFrame.new(0, -0.5, 0) }):Play()
		task.wait(0.5)

		if not _fx_Crib:IsDescendantOf(workspace) then
			return
		end

		clone.Union.Sound:Play()
		clone.Union.Sound1:Play()
		clone.Union.Attachment.ParticleEmitter.Enabled = true

		local torso = Character:FindFirstChild("Torso")

		if torso and clone.mat then
			local n1 = clone.mat.CFrame * t1.VictimPositionOffset * t1.VictimRotation
			local v49 = cancelRagdoll(Character)

			Character:PivotTo(n1)

			for _, v in pairs(Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end

			playAnimation(v49, t1.AnimationId).Looped = true
			n1 = Character:FindFirstChild("HumanoidRootPart") or torso

			if n1 then
				local weld: Weld = Instance.new("Weld")

				weld.Part0 = n1
				weld.Part1 = clone.mat
				weld.C0 = t1.VictimPositionOffset * t1.VictimRotation
				weld.Parent = clone.mat
			end
		end

		task.wait(4)

		if not _fx_Crib:IsDescendantOf(workspace) then
			return
		end

		clone.Union.Attachment.ParticleEmitter.Enabled = false

		local sound1 = clone.Union.Sound1
		local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(sound1, tweenInfo2, { Volume = 0 }):Play()

		local sound = clone.Union.Sound
		local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(sound, tweenInfo3, { Volume = 0 }):Play()

		local tweenInfo4 = TweenInfo.new(1.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(clonePrimaryPart, tweenInfo4, { CFrame = part.CFrame * CFrame.new(0, -15, 0) }):Play()

		return
	end
end
