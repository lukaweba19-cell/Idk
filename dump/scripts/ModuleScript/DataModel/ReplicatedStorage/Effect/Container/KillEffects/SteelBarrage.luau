-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local weaponRigUtil = require(game.ReplicatedStorage.Shared.WeaponRigUtil)
local steelBarrage = game.ReplicatedStorage.FX.KillEffects.SteelBarrage
local HumanoidRootPart = steelBarrage.Mesh.Rig.HumanoidRootPart

local function findRigBall()
	local v17 = nil
	local v18 = nil

	for _, v in ipairs(HumanoidRootPart:GetChildren()) do
		if v.Name == "SteelBall" then
			if v:IsA("BasePart") then
				v17 = v
			end

			if v:IsA("Motor6D") then
				v18 = v
			end
		end
	end

	return v17, v18
end

local t1: {[any]: any} = { "KnifeRig", "KnifeRig_L", "KnifeRig_R", "RevolverRig" }

local function hideWeaponRigs(p1, p2)
	local function apply()
		for _, v in ipairs(t1) do
			local v = p1:FindFirstChild(v)

			if v and v:IsA("Model") then
				weaponRigUtil.SetRigVisible(v, false, false)
			end
		end
	end

	apply()

	local function anyVisible()
		for _, v in ipairs(t1) do
			local v = p1:FindFirstChild(v)

			if v then
				for _, iterValue in ipairs(v:GetDescendants()) do
					if iterValue:IsA("BasePart") and iterValue.LocalTransparencyModifier < 1 then
						return true
					end
				end
			end
		end

		return false
	end

	local n1: number = 0
	local connection = nil

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 += deltaTime

		if n1 >= p2 or not p1.Parent then
			connection:Disconnect()

			return
		end

		if anyVisible() then
			apply()
		end
	end)
end
local function flashLight(parent, p5)
	local pointLight: PointLight = Instance.new("PointLight")

	pointLight.Range = p5.Range
	pointLight.Color = p5.Color
	pointLight.Brightness = 0
	pointLight.Shadows = false
	pointLight.Parent = parent

	local tweenInfo = TweenInfo.new(p5.Up, Enum.EasingStyle.Linear)
	local v31: Tween = tweenService:Create(pointLight, tweenInfo, { Brightness = p5.Brightness })

	v31.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p5.Down, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(pointLight, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v31:Play()
	debris:AddItem(pointLight, p5.Up + p5.Down + 0.1)
end
local function cancelRagdoll(p6)
	local torso = p6:FindFirstChild("Torso")

	if torso then
		for _, v in ipairs({ "Left Hip", "Left Shoulder", "Neck", "Right Shoulder", "Right Hip" }) do
			local v = torso:FindFirstChild(v)

			if v then
				v.Enabled = true
			end
		end
	end

	local humanoidRootPart = p6:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		local rootJoint = humanoidRootPart:FindFirstChild("RootJoint")

		if rootJoint then
			rootJoint.Enabled = true
		end
	end

	for _, v in ipairs(p6:GetDescendants()) do
		if v:IsA("BallSocketConstraint") or v:IsA("Attachment") and string.sub(v.Name, 1, 7) == "TorsoTo" then
			v:Destroy()
		end
	end
end
local function hideCharacter(p7)
	for _, v in ipairs(p7:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end
end

local t2: {[any]: any} = {
	RootHeight = 3,
	FreezeAt = 2.717,
	FlingBack = 55,
	FlingUp = 60,
	TumbleRate = 9,
	MaxFlight = 3,
	LandHeight = 1,
	BallFade = 0.25,
	CleanupAfter = 8,
	Timeline = {
		{ t = 0.05, vfx = "FirstHit" },
		{ t = 0.85, vfx = "SecondHit" },
		{ t = 1.033, vfx = "ThirdHit" },
		{ t = 1.267, vfx = "FourthHit" },
		{ t = 1.467, vfx = "FifthHit" },
		{ t = 1.583, vfx = "GroundSpin" },
		{ t = 2.2, vfx = "RingsIn" },
		{ t = 2.717, vfx = "BLAST" }
	},
	HitFlash = {
		Range = 6,
		Brightness = 8,
		Up = 0.02,
		Down = 0.08,
		Color = Color3.new(1, 1, 1)
	},
	BlastFlash = {
		Range = 12,
		Brightness = 12,
		Up = 0.02,
		Down = 0.12,
		Color = Color3.new(1, 1, 1)
	}
}

local function uprightRootCFrame(p8, p9)
	local torso = p8:FindFirstChild("Torso")
	local v47 = torso and torso.Position or p9.Position
	local lookVector = p9.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

	if vector3.Magnitude < 0.05 then
		vector3 = Vector3.new(0, 0, -1)
	end

	local vector3Unit = vector3.Unit
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local filterDescendantsInstances: {[any]: any} = { p8 }

	if workspace:FindFirstChild("Bin") then
		table.insert(filterDescendantsInstances, workspace.Bin)
	end

	raycastParams.FilterDescendantsInstances = filterDescendantsInstances

	local v53 = v47.Y
	local v54 = workspace:Raycast(v47 + Vector3.new(0, 4, 0), Vector3.new(0, -20, 0), raycastParams)

	if v54 then
		v53 = v54.Position.Y + t2.RootHeight
	end

	local vector32 = Vector3.new(v47.X, v53, v47.Z)

	return CFrame.lookAt(vector32, vector32 + vector3Unit)
end

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude >= 1000 then
		return
	end

	local humanoid = Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if humanoid and humanoidRootPart then
		local v60, v61 = findRigBall()

		if v60 and v61 then
			hideWeaponRigs(Character, t2.CleanupAfter)
			cancelRagdoll(Character)

			local cFrame = uprightRootCFrame(Character, humanoidRootPart)

			humanoidRootPart.Anchored = true
			humanoidRootPart.CFrame = cFrame

			for _, v in ipairs(Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end

			local clone = v60:Clone()

			clone.Name = "SteelBall"
			clone.Anchored = false
			clone.CanCollide = false
			clone.CanTouch = false
			clone.CanQuery = false
			clone.Massless = true

			local n1 = humanoidRootPart.CFrame * v61.C0
			local v67 = v61.C1:Inverse()

			clone.CFrame = n1 * v67
			clone.Parent = humanoidRootPart

			local steelBall: Motor6D = Instance.new("Motor6D")

			steelBall.Name = "SteelBall"
			steelBall.C0 = v61.C0
			steelBall.C1 = v61.C1
			steelBall.Part0 = humanoidRootPart
			steelBall.Part1 = clone
			steelBall.Parent = humanoidRootPart

			local clone2 = HumanoidRootPart.VFX:Clone()

			clone2.Parent = humanoidRootPart

			local animator = humanoid:FindFirstChildOfClass("Animator")

			if not animator then
				animator = Instance.new("Animator")
				animator.Parent = humanoid
			end

			local animationTrack = animator:LoadAnimation(steelBarrage.Animation)

			animationTrack.Priority = Enum.AnimationPriority.Action4
			animationTrack.Looped = false
			animationTrack:Play(0)

			local torso = Character:FindFirstChild("Torso")

			sound:Play("KillEffects.SteelBarrage", torso or humanoidRootPart)

			for _, v in ipairs(t2.Timeline) do
				task.delay(v.t, function()
					if not clone2.Parent then
						return
					end

					local vvfx = clone2:FindFirstChild(v.vfx)

					if vvfx then
						forgeVFX.emit(vvfx)

						if v.vfx == "BLAST" then
							flashLight(vvfx, t2.BlastFlash)

							return
						end

						if string.sub(v.vfx, -3) == "Hit" then
							flashLight(vvfx, t2.HitFlash)
						end

						return
					end
				end)
			end

			task.delay(t2.FreezeAt, function()
				if not Character.Parent or not humanoidRootPart.Parent then
					return
				end

				if animationTrack.IsPlaying then
					animationTrack.TimePosition = math.min(t2.FreezeAt, animationTrack.Length)
					animationTrack:AdjustSpeed(0)
				end

				if clone.Parent then
					local cloneCFrame = clone.CFrame

					steelBall:Destroy()
					clone.Anchored = true
					clone.CFrame = cloneCFrame

					for _, v in ipairs(clone:GetDescendants()) do
						if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
							v.Enabled = false
						end
					end

					local tweenInfo = TweenInfo.new(t2.BallFade)

					tweenService:Create(clone, tweenInfo, { Transparency = 1 }):Play()
				end

				local humanoidRootPartCFrame = humanoidRootPart.CFrame
				local humanoidRootPartCFrameLookVector = humanoidRootPartCFrame.LookVector
				local vector3 = Vector3.new(humanoidRootPartCFrameLookVector.X, 0, humanoidRootPartCFrameLookVector.Z)

				if vector3.Magnitude < 0.05 then
					vector3 = Vector3.new(0, 0, -1)
				end

				local vector3Unit = vector3.Unit
				local v94 = CFrame.lookAt(Vector3.new(0, 0, 0), vector3Unit)
				local humanoidRootPartCFramePosition = humanoidRootPartCFrame.Position
				local n1 = -vector3Unit * t2.FlingBack
				local vector33 = Vector3.new(0, t2.FlingUp, 0)
				local n2 = n1 + vector33
				local n3 = 0
				local n4: number = 0
				local raycastParams = RaycastParams.new()

				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local filterDescendantsInstances: {[any]: any} = { Character }

				if workspace:FindFirstChild("Bin") then
					table.insert(filterDescendantsInstances, workspace.Bin)
				end

				raycastParams.FilterDescendantsInstances = filterDescendantsInstances

				local connection = nil

				connection = runService.Heartbeat:Connect(function(deltaTime: number)
					if not Character.Parent or not humanoidRootPart.Parent then
						connection:Disconnect()

						return
					end

					n4 += deltaTime

					local v105 = n2
					local vector34 = Vector3.new(0, -workspace.Gravity, 0)

					n2 = v105 + vector34 * deltaTime
					v105 = n2 * deltaTime

					local u107: boolean = false
					local v108 = n2.Y < 0 and workspace:Raycast(humanoidRootPartCFramePosition, v105 + Vector3.new(0, -t2.LandHeight, 0), raycastParams)

					if v108 then
						local v109 = v108.Position
						local vector35 = Vector3.new(0, t2.LandHeight, 0)

						humanoidRootPartCFramePosition = v109 + vector35
						u107 = true
					end

					if not u107 then
						humanoidRootPartCFramePosition += v105
						n3 += t2.TumbleRate * deltaTime
					end

					local cFrame = CFrame.new(humanoidRootPartCFramePosition)
					local v112 = CFrame.Angles(n3, 0, 0)

					humanoidRootPart.CFrame = cFrame * v94 * v112

					if u107 or n4 >= t2.MaxFlight then
						connection:Disconnect()
					end
				end)
			end)
			debris:AddItem(clone, t2.CleanupAfter)
			debris:AddItem(steelBall, t2.CleanupAfter)
			debris:AddItem(clone2, t2.CleanupAfter)

			return
		end

		warn("[SteelBarrage] rig is missing HumanoidRootPart.SteelBall (MeshPart and/or Motor6D)")

		return
	end
end
