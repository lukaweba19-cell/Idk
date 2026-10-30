-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local safeSmash = game.ReplicatedStorage.FX.KillEffects.SafeSmash
local safeSmashMesh = safeSmash.Mesh
local safeSmashSounds = safeSmash.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
local v6 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v6
}

t1 = function(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end
t1 = function(p4)
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
t1 = function(parent, animationId)
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
		local _fx_SafeSmash: Folder = Instance.new("Folder")

		_fx_SafeSmash.Name = "_FX_SafeSmash"
		_fx_SafeSmash.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_SafeSmash:Destroy()
			end
		end)
		debris:AddItem(_fx_SafeSmash, 7)

		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 0, 0)
		part.CollisionGroup = "Debris"

		local clone = safeSmashMesh.Safe:Clone()

		for iterFirst, iterSecond in clone:GetDescendants() do
			if iterSecond:IsA("BasePart") then
				iterSecond.CollisionGroup = "Debris"
			end
		end

		local clonePrimaryPart = clone.PrimaryPart
		local n1 = part.CFrame.Position + Vector3.new(0, 5000, 0)
		local n2 = (workspace.CurrentCamera.CFrame.Position - n1) * Vector3.new(1, 0, 1)

		n2 = -(if n2.Magnitude > 0.001 then n2.Unit else Vector3.new(0, 0, -1))
		clonePrimaryPart.CFrame = CFrame.lookAt(n1, n1 + n2)
		clone.Parent = _fx_SafeSmash
		debris:AddItem(clone, 4)
		clone.AnimationController.Animator:LoadAnimation(safeSmash.Animation):Play()
		wait(0.18)
		n1 = part.CFrame.Position + Vector3.new(0, -0.5, 0)
		clonePrimaryPart.CFrame = CFrame.lookAt(n1, n1 + n2)
		wait(0.2)
		clone.Safe.Sound:Play()
		clone.Safe.coin:Play()
		clone.Safe.money:Play()
		wait(0.05)

		for _, v in pairs(clone.Safe.Attachment:GetChildren()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end

		wait(0.8)

		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("Part") or v:IsA("MeshPart") then
				local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

				tweenService:Create(v, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
			end
		end
	end
end
