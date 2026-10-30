-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local misc = require(game.ReplicatedStorage.Util.Misc)
local megalodon = game.ReplicatedStorage.FX.KillEffects.Megalodon
local megalodonMesh = megalodon.Mesh
local megalodonSounds = megalodon.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
local v8 = CFrame.Angles(0, 0, 0)

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
local function hideCharacter(p7)
	for _, v in pairs(p7:GetDescendants()) do
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

local t1: {[any]: any} = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v8
}

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Megalodon: Folder = Instance.new("Folder")

		_fx_Megalodon.Name = "_FX_Megalodon"
		_fx_Megalodon.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Megalodon:Destroy()
			end
		end)
		debris:AddItem(_fx_Megalodon, 7)

		local function createsfx(parent, p10)
			local clone = p10:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 0, 0)
		sound:Play("KillEffects.Megalodon", Character.PrimaryPart)

		local clone = megalodonMesh.Shark:Clone()
		local clonePrimaryPart = clone.PrimaryPart
		local animationController = clone:FindFirstChild("AnimationController")

		clone.Parent = _fx_Megalodon

		local partCFrame: CFrame = part.CFrame
		local cFrameAngles = CFrame.Angles
		local randomNumber = math.random(0, 180)
		local v52 = math.rad(randomNumber)
		local cFrame = cFrameAngles(0, v52, 0)

		clonePrimaryPart.CFrame = partCFrame * CFrame.new(0, 55555, -12) * cFrame

		local animationTrack = animationController:LoadAnimation(megalodon.Animation)

		animationTrack:Play()
		animationTrack:AdjustSpeed(0.8)
		wait(0.1)

		local v55: CFrame = part.CFrame
		local angles = CFrame.Angles
		local randomNumber2 = math.random(-360, 360)
		local v58 = math.rad(randomNumber2)
		local v59 = angles(0, v58, 0)

		clonePrimaryPart.CFrame = v55 * v59
		clonePrimaryPart.CFrame = clonePrimaryPart.CFrame * CFrame.new(0, 0, -12)
		misc.EmitAll(clone.shark.Jump)

		local torso = Character:FindFirstChild("Torso")

		if torso and clone.bw2 then
			local n1 = clone.bw2.CFrame * t1.VictimPositionOffset * t1.VictimRotation
			local torsoCFrame = torso.CFrame

			for _, v in pairs(Character:GetChildren()) do
				if v:IsA("BasePart") then
					local v65 = torsoCFrame:ToObjectSpace(v.CFrame)

					v.CFrame = n1 * v65
					v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end

			if t1.CancelRagdoll then
				local v66 = cancelRagdoll(Character)
				local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					humanoidRootPart.CFrame = n1
				end

				playAnimation(v66, t1.AnimationId)

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

		wait(1)
		misc.EmitAll(clone.shark.Land)
		wait(0.5)

		if Character and Character.Parent then
			hideCharacter(Character)
		end

		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("ParticleEmitter") and v.Enabled == true then
				v.Enabled = false
			end
		end

		for _, v in pairs(clone:GetChildren()) do
			if v:IsA("Part") or v:IsA("MeshPart") then
				local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

				tweenService:Create(v, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
			end
		end
	end
end
