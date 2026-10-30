-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local eagle = game.ReplicatedStorage.FX.KillEffects.Eagle
local eagleMesh = eagle.Mesh
local eagleSounds = eagle.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
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
		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		Instance.new("Part")
		Character:FindFirstChild("HumanoidRootPart")
		createsfx = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		if createsfx then
			sound:Play("KillEffects.Shrink", createsfx)
		end

		local numberValue: NumberValue = Instance.new("NumberValue")

		numberValue.Value = Character:GetScale()

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v38: Tween = tweenService:Create(numberValue, tweenInfo, { Value = 0.01 })

		v38.Completed:Connect(function()
			numberValue:Destroy()
		end)
		v38:Play()
		numberValue:GetPropertyChangedSignal("Value"):Connect(function()
			Character:ScaleTo(numberValue.Value)
		end)
	end
end
