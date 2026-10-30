-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local slap = game.ReplicatedStorage.FX.KillEffects.Slap
local slapMesh = slap.Mesh
local slapSounds = slap.Sounds
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
		local _fx_Slap: Folder = Instance.new("Folder")

		_fx_Slap.Name = "_FX_Slap"
		_fx_Slap.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Slap:Destroy()
			end
		end)
		debris:AddItem(_fx_Slap, 7)

		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 0, 0)

		local clone = slapMesh.Hand:Clone()
		local clonePrimaryPart = clone.PrimaryPart
		local animationController = clone:FindFirstChild("AnimationController")

		clone.Parent = _fx_Slap
		debris:AddItem(clone, 3.8)
		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(-8, 133456, 24)

		local animationTrack = animationController:LoadAnimation(slap.Animation)

		animationTrack:Play()
		animationTrack:AdjustSpeed(0.8)
		task.wait(0.25)
		clone.default.weho:Play()

		local partCFrame: CFrame = part.CFrame
		local v42 = CFrame.Angles(0, 0, -3.141592653589793)

		clonePrimaryPart.CFrame = partCFrame * v42
		spawn(function()
			task.wait(1)
			clone.default.weho2:Play()
			task.wait(0.34)
			clone.default.Sound:Play()
			clone.default.Sound1:Play()
			clone.default.Attachment.LineShock:Emit(15)
			clone.default.Attachment.Shock:Emit(28)
			clone.default.Attachment.Shockwave:Emit(10)
		end)
		task.wait(1.4)

		local part2: Part = Instance.new("Part")

		part2.Transparency = 1
		part2.CanCollide = false
		part2.CanQuery = false
		part2.CanTouch = false
		part2.Anchored = true
		part2.CFrame = part.CFrame * CFrame.new(-5, 5, 0)

		for _, v in pairs(clone:GetChildren()) do
			if v:IsA("Part") or v:IsA("MeshPart") then
				local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

				tweenService:Create(v, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
			end
		end
	end
end
