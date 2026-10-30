-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local eagle = game.ReplicatedStorage.FX.KillEffects.Eagle
local eagleMesh = eagle.Mesh
local eagleSounds = eagle.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
local v6 = CFrame.Angles(0, 0, 0)

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
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v6
}

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Eagle: Folder = Instance.new("Folder")

		_fx_Eagle.Name = "_FX_Eagle"
		_fx_Eagle.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Eagle:Destroy()
			end
		end)
		debris:AddItem(_fx_Eagle, 7)

		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 0, 0)

		local clone = eagleMesh.Eagle:Clone()
		local clonePrimaryPart = clone.PrimaryPart
		local animationController = clone:FindFirstChild("AnimationController")

		clone.Parent = _fx_Eagle
		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(-8, 133456, 24)

		local animationTrack = animationController:LoadAnimation(eagle.Animation)

		animationTrack:Play()
		animationTrack:AdjustSpeed(0.8)
		wait(0.25)

		local v44 = clone["eagle_0002:eagle:eagle2 eagle_0002:eagle:polySurface2 eagle_000"]
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(v44, tweenInfo, { Size = Vector3.new(36.806, 5.817, 17.606) }):Play()
		spawn(function()
			wait(0.08)
			clonePrimaryPart.CFrame = part.CFrame
			clone.bw2.Sound:Play()
			wait(0.6)
			clone["eagle_0002:eagle:eagle2 eagle_0002:eagle:polySurface2 eagle_000"].Attachment.Smoke:Emit(15)
		end)
		wait(0.79)

		local torso = Character:FindFirstChild("Torso")

		if torso and clone.bw2 then
			local cFrame = clone.bw2.CFrame * t1.VictimPositionOffset * t1.VictimRotation
			local torsoCFrame = torso.CFrame

			for _, v in pairs(Character:GetChildren()) do
				if v:IsA("BasePart") then
					local v51 = torsoCFrame:ToObjectSpace(v.CFrame)

					v.CFrame = cFrame * v51
					v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end

			wait(t1.PositionSettleTime)

			if t1.CancelRagdoll then
				local v52 = cancelRagdoll(Character)
				local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					humanoidRootPart.CFrame = cFrame
				end

				playAnimation(v52, t1.AnimationId)

				if humanoidRootPart then
					local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

					weldConstraint.Part0 = humanoidRootPart
					weldConstraint.Part1 = clone.bw2
					weldConstraint.Parent = humanoidRootPart
					debris:AddItem(weldConstraint, 4)
				end
			else
				local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

				weldConstraint.Part0 = torso
				weldConstraint.Part1 = clone.bw2
				weldConstraint.Parent = torso
				debris:AddItem(weldConstraint, 4)

				for _, v in pairs(Character:GetChildren()) do
					if v:IsA("BasePart") and v.Name ~= "Torso" and v.Name ~= "HumanoidRootPart" then
						local weldConstraint2: WeldConstraint = Instance.new("WeldConstraint")

						weldConstraint2.Part0 = v
						weldConstraint2.Part1 = torso
						weldConstraint2.Parent = v
						debris:AddItem(weldConstraint2, 4)
					end
				end
			end
		end

		wait(3.3)

		for _, v in pairs(clone:GetChildren()) do
			if v:IsA("Part") or v:IsA("MeshPart") then
				local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

				tweenService:Create(v, tweenInfo2, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
			end
		end
	end
end
