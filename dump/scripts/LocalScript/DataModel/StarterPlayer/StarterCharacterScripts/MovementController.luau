-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local fovController = require(shared:WaitForChild("FOVController"))
local replicatedStorageShared = game.ReplicatedStorage:WaitForChild("Shared")
local crosshair = require(replicatedStorageShared:WaitForChild("Crosshair"))
local v5 = game.ReplicatedStorage:WaitForChild("Shared")
local stunModule = require(v5:WaitForChild("StunModule"))
local v7 = game.ReplicatedStorage:WaitForChild("Shared")
local parkourCamera = require(v7:WaitForChild("ParkourCamera"))
local v9 = game.ReplicatedStorage:WaitForChild("Shared")
local slowModule = require(v9:WaitForChild("SlowModule"))
local players: Players = game:GetService("Players")

game:GetService("ContextActionService")

local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(replicatedStorage:WaitForChild("Sound"))

local extensions: Instance = replicatedStorage:WaitForChild("Extensions")

require(extensions:WaitForChild("GamepadBindings"))

local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent

workspace:WaitForChild("Characters")

while scriptParent.Parent ~= workspace.Characters do
	task.wait()
end

local humanoid: Instance = scriptParent:WaitForChild("Humanoid")
local humanoidRootPart: Instance = scriptParent:WaitForChild("HumanoidRootPart")

while humanoidRootPart.Anchored do
	task.wait()
end

fovController.Pop("ads", 0.1)

local head: Instance = scriptParent:WaitForChild("Head")
local CurrentCamera: Camera = workspace.CurrentCamera
local u24 = nil
local u25 = nil
local u26: boolean = false

task.spawn(function()
	while humanoid.WalkSpeed <= game.StarterPlayer.CharacterWalkSpeed + 1 do
		task.wait()
	end

	u24 = function()
		if stunModule.IsStunned(humanoid.Parent) then
			return 4
		end

		return humanoid:GetAttribute("MatchWalkSpeed") or humanoid.WalkSpeed
	end
	u25 = function()
		if stunModule.IsStunned(humanoid.Parent) then
			return 0
		end

		return humanoid:GetAttribute("MatchJumpHeight") or humanoid.JumpHeight
	end
	u26 = true
end)

local u27: boolean = false
local beginnerTask_CrouchSlide = game.ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("BeginnerTask_CrouchSlide")
local t1: {[any]: any} = {
	Vector3.new(0, 0, 0),
	Vector3.new(0, 0, -2),
	Vector3.new(0, 0, -4),
	Vector3.new(0, 0, -6),
	Vector3.new(0, 0, -8)
}
local t2: {[any]: any} = { 1, 0.875, 0.75 }
local parkourCameraCrouch_y = parkourCamera.CROUCH_Y
local parkourCameraTween_time = parkourCamera.TWEEN_TIME

local function setParkourState(p1)
	scriptParent:SetAttribute("ParkourState", p1)
	replicatedStorage.Remotes.ParkourState:FireServer(p1)

	if p1 ~= nil and not u27 and beginnerTask_CrouchSlide then
		u27 = true
		beginnerTask_CrouchSlide:FireServer()
	end
end

local u34: boolean = false
local vectorValue = Vector3.new(0, 0, 0)
local n1 = 0
local n2 = 0
local n3 = 0
local u39 = false
local u40: boolean = false
local part = nil
local u42 = nil
local slideDown: Instance = script:FindFirstChild("SlideDown")
local slideDownLobby: Instance = script:FindFirstChild("SlideDownLobby")
local u45 = nil
local crouchIdle: Instance = script:FindFirstChild("CrouchIdle")
local crouchMove: Instance = script:FindFirstChild("CrouchMove")
local u48 = nil
local u49 = nil

local function ensureAnimator()
	local animator = humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	u42 = animator
end
local function playSlideAnim()
	if not slideDown or not slideDown:IsA("Animation") then
		return
	end

	if not u42 then
		local animator = humanoid:FindFirstChildOfClass("Animator")

		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		u42 = animator
	end

	if not u42 then
		return
	end

	if u45 then
		return
	end

	local v104 = u42
	local inMatch: any = LocalPlayer:GetAttribute("InMatch")

	u45 = v104:LoadAnimation(inMatch and slideDown or slideDownLobby)
	u45.Priority = Enum.AnimationPriority.Action
	u45:Play()
end
local function stopSlideAnim()
	if u45 then
		if u45.IsPlaying then
			u45:Stop(0.15)
		end

		u45:Destroy()
		u45 = nil
	end
end
local function loadCrouchTracksIfNeeded()
	if not u42 then
		local animator = humanoid:FindFirstChildOfClass("Animator")

		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		u42 = animator
	end

	if not u42 then
		return
	end

	if crouchIdle and crouchIdle:IsA("Animation") and not u48 then
		u48 = u42:LoadAnimation(crouchIdle)
		u48.Looped = true
		u48.Priority = Enum.AnimationPriority.Action
	end

	if crouchMove and crouchMove:IsA("Animation") and not u49 then
		u49 = u42:LoadAnimation(crouchMove)
		u49.Looped = true
		u49.Priority = Enum.AnimationPriority.Action
	end
end
local function stopCrouchTracks()
	if u48 then
		u48:Stop()
		u48:Destroy()
		u48 = nil
	end

	if u49 then
		u49:Stop()
		u49:Destroy()
		u49 = nil
	end
end

local AutoRotate = nil
local u56: boolean = false

local function setSlideAutoRotateOverride(p2)
	if p2 then
		if LocalPlayer:GetAttribute("InMatch") then
			return
		end

		if u56 then
			return
		end

		AutoRotate = humanoid.AutoRotate
		u56 = true
		humanoid.AutoRotate = false

		return
	end

	if not u56 then
		return
	end

	humanoid.AutoRotate = AutoRotate ~= false
	AutoRotate = nil
	u56 = false
end

local u58: boolean = false
local n4: number = 70

local function isADS()
	return crosshair.ADS
end
local function updateTargetFOV()
	if LocalPlayer:GetAttribute("InMatch") and humanoid.WalkSpeed ~= 0 then
		local v108: boolean = u58
		local v109: boolean = u34

		if crosshair.ADS then
			v108 = false
			v109 = false
		end

		if v108 then
			fovController.Push("walk", 5, 0.2)
		else
			fovController.Pop("walk", 0.2)
		end

		if v109 then
			fovController.Push("slide", 20, 0.2)

			return
		end

		fovController.Pop("slide", 0.1)

		return
	end
end

local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true
raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin }

local raycastParams2 = RaycastParams.new()

raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
raycastParams2.IgnoreWater = true

local function raycastCollidable(p3, p4)
	local raycastParamsFilterDescendantsInstances = raycastParams.FilterDescendantsInstances

	raycastParams2.FilterDescendantsInstances = raycastParamsFilterDescendantsInstances

	for _ = 1, 5 do
		local v114 = workspace:Raycast(p3, p4, raycastParams2)

		if not v114 then
			return nil
		end

		if v114.Instance.CanCollide then
			return v114
		end

		table.insert(raycastParamsFilterDescendantsInstances, v114.Instance)
		raycastParams2.FilterDescendantsInstances = raycastParamsFilterDescendantsInstances
	end

	return nil
end
local function drawRaycast(p5, p6, p7, p8)
	local magnitude = p6.Magnitude
	local part: Part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Material = Enum.Material.Neon
	part.Color = p7 or Color3.fromRGB(255, 0, 0)
	part.Size = Vector3.new(0.15, 0.15, magnitude)

	local v121 = CFrame.lookAt(p5, p5 + p6)
	local cFrame = CFrame.new(0, 0, -magnitude / 2)

	part.CFrame = v121 * cFrame
	part.Parent = workspace
	game:GetService("Debris"):AddItem(part, p8 or 3)

	return part
end
local function sampleGround()
	local n1 = math.huge
	local u124: boolean = false
	local t5: {[any]: any} = {}

	for _, v in ipairs(t1) do
		local n2 = humanoidRootPart.CFrame * v - humanoidRootPart.Position
		local v129 = raycastCollidable(humanoidRootPart.Position, n2)
		local n3 = v129 and v129.Position - n2 * 0.01 or humanoidRootPart.Position + n2

		v129 = raycastCollidable(n3, Vector3.new(0, -15, 0))

		if v129 then
			u124 = true

			local magnitude = (n3 - v129.Position).Magnitude

			if n1 > magnitude then
				n1 = magnitude
			end

			table.insert(t5, { offset = v, position = v129.Position, dist = magnitude })
		end
	end

	if not u124 then
		return nil, nil
	end

	if #t5 >= 2 then
		local v132 = vectorValue

		if v132.Magnitude < 0.000001 then
			v132 = xzUnit(humanoidRootPart.CFrame.LookVector)
		end

		if v132.Magnitude < 0.000001 then
			v132 = Vector3.new(0, 0, -1)
		end

		local n4 = math.huge
		local n5 = -math.huge
		local position = nil
		local v136 = nil

		for _, v in ipairs(t5) do
			local v139 = v.position:Dot(v132)

			if n4 > v139 then
				n4 = v139
				v136 = v.position
			end

			if n5 < v139 then
				n5 = v139
				position = v.position
			end
		end

		if position and v136 and math.abs(position.Y - v136.Y) >= 1 then
			local unit = (position - v136).Unit
			local v141 = (Vector3.new(0, 1, 0)):Cross(v132)
			local v142 = (if v141.Magnitude < 0.000001 then Vector3.new(1, 0, 0) else v141.Unit):Cross(unit)

			if v142.Y < 0 then
				v142 = -v142
			end

			if v142.Magnitude > 0.000001 then
				return n1, v142.Unit
			end

			return n1, Vector3.new(0, 1, 0)
		end

		return n1, Vector3.new(0, 1, 0)
	end

	return n1, Vector3.new(0, 1, 0)
end
local function isGrounded(p9)
	if p9 and humanoid.FloorMaterial == Enum.Material.Air then
		return false, nil
	end

	local v144, v145 = sampleGround()

	if not v144 then
		return false, nil
	end

	return v144 <= 15, v145
end

local burstSlideAttachment: Attachment = Instance.new("Attachment")

burstSlideAttachment.Name = "BurstSlideAttachment"
burstSlideAttachment.Parent = humanoidRootPart

local linearVelocity = nil

local function refreshLv()
	if linearVelocity and linearVelocity.Parent then
		linearVelocity:Destroy()
	end

	linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Name = "BurstSlideLV"
	linearVelocity.Attachment0 = burstSlideAttachment
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	linearVelocity.MaxAxesForce = Vector3.new(1, 0, 1) * humanoidRootPart.AssemblyMass * 1500
	linearVelocity.Enabled = false
	linearVelocity.Parent = humanoidRootPart
end

local driveAttachment: Attachment = Instance.new("Attachment")

driveAttachment.Name = "DriveAttachment"
driveAttachment.Parent = humanoidRootPart

local driveLV: LinearVelocity = Instance.new("LinearVelocity")

driveLV.Name = "DriveLV"
driveLV.Attachment0 = driveAttachment
driveLV.RelativeTo = Enum.ActuatorRelativeTo.World
driveLV.ForceLimitMode = Enum.ForceLimitMode.PerAxis
driveLV.MaxAxesForce = Vector3.new(0, 0, 0)
driveLV.Enabled = false
driveLV.Parent = humanoidRootPart

local u73 = nil
local portalRedirect: BindableEvent = Instance.new("BindableEvent")

portalRedirect.Name = "PortalRedirect"
portalRedirect.Parent = script
portalRedirect.Event:Connect(function(arguments)
	if typeof(arguments) == "CFrame" then
		local v147 = u73

		if v147 then
			v147.v0 = arguments:VectorToWorldSpace(v147.v0)
			driveLV.VectorVelocity = arguments:VectorToWorldSpace(driveLV.VectorVelocity)
		end

		if not u34 then
			return
		end

		if vectorValue.Magnitude > 0.000001 then
			vectorValue = arguments:VectorToWorldSpace(vectorValue)
		end

		if linearVelocity and linearVelocity.Parent and linearVelocity.Enabled then
			linearVelocity.VectorVelocity = arguments:VectorToWorldSpace(linearVelocity.VectorVelocity)
		end

		return
	end
end)

local function lerpVec(p11, p12, p13)
	return p11 + (p12 - p11) * p13
end
local function getNeutralXZSpeed()
	local unit = humanoid.MoveDirection.Unit
	local vector3 = Vector3.new(unit.X, 0, unit.Z)

	if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then
		return vector3 * humanoid.WalkSpeed
	end

	local v153 = (humanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Unit

	vector3 = Vector3.new(v153.X, 0, v153.Z)

	if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then
		return vector3 * humanoid.WalkSpeed
	end

	return Vector3.new(0, 0, 0)
end
function xzUnit(p14)
	local unit = Vector3.new(p14.X, 0, p14.Z).Unit

	if unit == unit and not (unit.Magnitude < 0.000001) then
		return unit
	end

	return Vector3.new(0, 0, 0)
end
local function hasDirectionalInput()
	return humanoid.MoveDirection.Magnitude > 0.05
end
local function chooseDir()
	local v156 = xzUnit(humanoidRootPart.AssemblyLinearVelocity)

	if v156.Magnitude > 0 then
		return v156
	end

	v156 = xzUnit(humanoidRootPart.CFrame.LookVector)

	if v156.Magnitude > 0 then
		return v156
	end

	return Vector3.new(0, 0, -1)
end
local function getSlopeAlongSlideSigned(p15, p16)
	local v159 = (Vector3.new(0, -1, 0)):Dot(p15)
	local n1 = Vector3.new(0, -1, 0) - p15 * v159
	local magnitude = n1.Magnitude

	if magnitude < 0.000001 then
		return 0
	end

	local v162 = (n1 / magnitude):Dot(p16)

	return (math.clamp(v162, -1, 1))
end
local function tweenCamOffset(p17)
	if not LocalPlayer:GetAttribute("InMatch") and p17 ~= 0 then
		return
	end

	local tweenInfo = TweenInfo.new(parkourCameraTween_time)

	tweenService:Create(humanoid, tweenInfo, { CameraOffset = Vector3.new(0, 1, 0) * p17 * parkourCamera.MULT }):Play()
end
local function updateCrouchAnim()
	if not u39 then
		return
	end

	loadCrouchTracksIfNeeded()

	if humanoid.MoveDirection.Magnitude > 0.05 and humanoid.WalkSpeed > 0 then
		if u48 then
			u48:Stop()
		end

		if u49 and not u49.IsPlaying then
			u49:Play()

			return
		end
	else
		if u49 then
			u49:Stop()
		end

		if u48 and not u48.IsPlaying then
			u48:Play()
		end
	end
end
local function setCrouch(p18)
	if p18 == u39 then
		if p18 then
			updateCrouchAnim()
		end

		return
	end

	u39 = p18

	local s1 = if p18 then "Crouching" else nil

	scriptParent:SetAttribute("ParkourState", s1)
	replicatedStorage.Remotes.ParkourState:FireServer(s1)

	if s1 ~= nil and not u27 and beginnerTask_CrouchSlide then
		u27 = true
		beginnerTask_CrouchSlide:FireServer()
	end

	if u39 then
		tweenCamOffset(parkourCameraCrouch_y)
		updateCrouchAnim()

		return
	end

	tweenCamOffset(0)

	if u48 then
		u48:Stop()
		u48:Destroy()
		u48 = nil
	end

	if u49 then
		u49:Stop()
		u49:Destroy()
		u49 = nil
	end
end

local n5 = 3
local n6 = 0
local t3: {[any]: any} = {}

local function updateCharges(p19)
	local n1: number = 1

	while n1 <= #t3 do
		if p19 >= t3[n1] then
			table.remove(t3, n1)
			n5 = math.min(3, n5 + 1)
		else
			n1 += 1
		end
	end

	if n5 >= 3 and #t3 == 0 then
		n6 = 0
	end
end
local function tryConsumeCharge(p20)
	updateCharges(p20)

	if n5 <= 0 then
		return false
	end

	n5 -= 1
	table.insert(t3, p20 + 3)
	table.sort(t3)
	n6 = math.min(n6 + 1, 2)

	return true
end
local function beginBurst()
	if not u26 then
		return
	end

	if u34 then
		return
	end

	if u73 then
		return
	end

	if stunModule.IsStunned(scriptParent) then
		return
	end

	if humanoid.Health <= 0 or humanoid.WalkSpeed == 0 or humanoidRootPart.Anchored then
		return
	end

	local u170

	if humanoid.FloorMaterial == Enum.Material.Air then
		u170 = false
	else
		local v171, v172 = sampleGround()

		u170 = if not v171 then false else v171 <= 15
	end

	if not u170 then
		return
	end

	u40 = false

	if u39 and u39 ~= false then
		u39 = false
		scriptParent:SetAttribute("ParkourState", nil)
		replicatedStorage.Remotes.ParkourState:FireServer(nil)

		if u39 then
			tweenCamOffset(parkourCameraCrouch_y)
			updateCrouchAnim()
		else
			tweenCamOffset(0)

			if u48 then
				u48:Stop()
				u48:Destroy()
				u48 = nil
			end

			if u49 then
				u49:Stop()
				u49:Destroy()
				u49 = nil
			end
		end
	end

	local v173 = time()

	updateCharges(v173)

	local u174

	if n5 <= 0 then
		u174 = false
	else
		n5 -= 1
		table.insert(t3, v173 + 3)
		table.sort(t3)
		n6 = math.min(n6 + 1, 2)
		u174 = true
	end

	if not u174 then
		return
	end

	part = Instance.new("Part")
	part.CanCollide = true
	part.CanTouch = false
	part.CanQuery = false
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(2, 2, 2)
	part.Transparency = 1
	part.Massless = true
	part.RootPriority = -127
	part.CFrame = head.CFrame
	part.CollisionGroup = "Characters"

	local weld: Weld = Instance.new("Weld")

	weld.Part0 = head
	weld.Part1 = part
	weld.Parent = part
	part.Parent = head
	u34 = true
	scriptParent:SetAttribute("Sliding", true)
	n1 = v173
	n3 = 0
	n2 = 24 * (t2[n6 + 1] or 1) / 0.35
	v173 = xzUnit(humanoidRootPart.AssemblyLinearVelocity)

	local v176

	if v173.Magnitude > 0 then
		v176 = v173
	else
		local v177 = xzUnit(humanoidRootPart.CFrame.LookVector)

		v176 = if v177.Magnitude > 0 then v177 else Vector3.new(0, 0, -1)
	end

	vectorValue = v176
	playSlideAnim()
	refreshLv()

	local v178 = slowModule.GetSlowMultiplier(scriptParent)
	local n4 = n2 * (v178 < 1 and v178 or 1)

	linearVelocity.VectorVelocity = Vector3.new(vectorValue.X * n4, 0, vectorValue.Z * n4)
	linearVelocity.Enabled = true
	humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + vectorValue * Vector3.new(1, 0, 1))
	tweenCamOffset(parkourCamera.SLIDE_Y)
	u58 = false

	if LocalPlayer:GetAttribute("InMatch") then
		fovController.Remove("walk")

		if not crosshair.ADS then
			fovController.Push("slide", 20, 0.2)
		end
	end

	if not LocalPlayer:GetAttribute("InMatch") and not u56 then
		AutoRotate = humanoid.AutoRotate
		u56 = true
		humanoid.AutoRotate = false
	end

	scriptParent:SetAttribute("ParkourState", "Sliding")
	replicatedStorage.Remotes.ParkourState:FireServer("Sliding")

	if not u27 and beginnerTask_CrouchSlide then
		u27 = true
		beginnerTask_CrouchSlide:FireServer()
	end
end
local function endBurst(p21)
	if not u34 then
		return
	end

	if part then
		part:Destroy()
	end

	u34 = false
	scriptParent:SetAttribute("Sliding", false)
	tweenCamOffset(0)
	linearVelocity:Destroy()

	local v181 = humanoid.MoveDirection.Unit

	if v181 ~= v181 or v181.Magnitude < 0.000001 then
		local linearVelocityVectorVelocity = linearVelocity.VectorVelocity

		v181 = if linearVelocityVectorVelocity == linearVelocityVectorVelocity and linearVelocityVectorVelocity.Magnitude > 0.000001 then linearVelocityVectorVelocity.Unit else xzUnit(humanoidRootPart.CFrame.LookVector)
	end

	if not p21 then
		local assemblyLinearVelocity = v181 * (linearVelocity.VectorVelocity.Magnitude + 12) + humanoidRootPart.AssemblyLinearVelocity * Vector3.new(0, 1, 0)

		if assemblyLinearVelocity == assemblyLinearVelocity then
			humanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
		end
	end

	if u45 then
		if u45.IsPlaying then
			u45:Stop(0.15)
		end

		u45:Destroy()
		u45 = nil
	end

	vectorValue = Vector3.new(0, 0, 0)
	n2 = 0

	if LocalPlayer:GetAttribute("InMatch") and not crosshair.ADS then
		fovController.Pop("slide", 0.2)
	end

	updateTargetFOV()

	if u56 then
		humanoid.AutoRotate = AutoRotate ~= false
		AutoRotate = nil
		u56 = false
	end

	scriptParent:SetAttribute("ParkourState", nil)
	replicatedStorage.Remotes.ParkourState:FireServer(nil)
end
local function inputXZVelocity()
	local humanoidMoveDirection = humanoid.MoveDirection
	local vector3 = Vector3.new(humanoidMoveDirection.X, 0, humanoidMoveDirection.Z)

	if vector3.Magnitude < 0.001 then
		return Vector3.new(0, 0, 0)
	end

	return vector3.Unit * humanoid.WalkSpeed
end
local function stopDrive()
	if not u73 then
		return
	end

	u73 = nil
	driveLV.Enabled = false
end
local function startDrive(p22, p23, p24, p25)
	if u34 then
		endBurst(true)
	end

	local vector3 = Vector3.new(p23.X, 0, p23.Z)

	if vector3 == vector3 and not (vector3.Magnitude < 0.001) and not (p24 <= 0) then
		driveLV.MaxAxesForce = (if p25 then Vector3.new(1, 1, 1) else Vector3.new(1, 0, 1)) * humanoidRootPart.AssemblyMass * 2500
		driveLV.VectorVelocity = vector3
		driveLV.Enabled = true

		local v191 = time()
		u73 = { mode = p22, v0 = vector3, t0 = v191, dur = p24 }

		return
	end
end
local function updateDrive(p26)
	local v193 = u73

	if not v193 then
	elseif (p26 - v193.t0) / v193.dur >= 1 then
		if u73 then
			u73 = nil
			driveLV.Enabled = false
		end

		if v193.mode == "hold" then
			local n1 = v193.v0.Unit * humanoid.WalkSpeed

			if n1 == n1 then
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(n1.X, humanoidRootPart.AssemblyLinearVelocity.Y, n1.Z)
			end
		end
	elseif v193.mode == "launch" then
		local n2 = p26 - v193.t0

		if not (n2 >= 0.12) or humanoid.FloorMaterial == Enum.Material.Air or not (humanoidRootPart.AssemblyLinearVelocity.Y <= 0) then
			local v0 = v193.v0
			local v197 = math.exp(-2 * n2)
			local humanoidMoveDirection = humanoid.MoveDirection
			local vector3 = Vector3.new(humanoidMoveDirection.X, 0, humanoidMoveDirection.Z)

			driveLV.VectorVelocity = v0 * v197 + (if vector3.Magnitude < 0.001 then Vector3.new(0, 0, 0) else vector3.Unit * humanoid.WalkSpeed) * 0.5

			return
		end

		if not u73 then
			return
		end

		u73 = nil
		driveLV.Enabled = false

		return
	end
end

local knockback: BindableEvent = Instance.new("BindableEvent")

knockback.Name = "Knockback"
knockback.Parent = script
knockback.Event:Connect(function(arguments)
	if typeof(arguments) == "Vector3" then
		if arguments ~= arguments then
			return
		end

		if arguments.Magnitude < 0.001 then
			return
		end

		if humanoid.Health <= 0 then
			return
		end

		if humanoidRootPart.Anchored then
			return
		end

		if u34 then
			endBurst(true)
		end

		local humanoidRootPartAssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

		if arguments.Y > 0 then
			local v202 = humanoid:GetState()

			if v202 == Enum.HumanoidStateType.Running or v202 == Enum.HumanoidStateType.RunningNoPhysics then
				humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end

			local v203 = math.max(humanoidRootPartAssemblyLinearVelocity.Y, 0)

			v202 = math.min(v203 + arguments.Y, 80)
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(humanoidRootPartAssemblyLinearVelocity.X, v202, humanoidRootPartAssemblyLinearVelocity.Z)
		elseif arguments.Y < 0 then
			local vector3 = Vector3.new(0, arguments.Y, 0)

			humanoidRootPart.AssemblyLinearVelocity = humanoidRootPartAssemblyLinearVelocity + vector3
		end

		local vector3 = Vector3.new(humanoidRootPartAssemblyLinearVelocity.X + arguments.X, 0, humanoidRootPartAssemblyLinearVelocity.Z + arguments.Z)

		if vector3.Magnitude > 110 then
			vector3 = vector3.Unit * 110
		end

		startDrive("launch", vector3, 0.36)

		return
	end
end)

local dash: BindableEvent = Instance.new("BindableEvent")

dash.Name = "Dash"
dash.Parent = script
dash.Event:Connect(function(arguments, p29)
	if typeof(arguments) ~= "number" or typeof(p29) ~= "number" then
		return
	end

	if humanoid.Health <= 0 or humanoidRootPart.Anchored then
		return
	end

	local humanoidMoveDirection = humanoid.MoveDirection
	local vector3 = Vector3.new(humanoidMoveDirection.X, 0, humanoidMoveDirection.Z)

	if vector3.Magnitude < 0.001 then
		vector3 = humanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
	end

	if vector3.Magnitude < 0.001 then
		return
	end

	local vector3Unit = vector3.Unit
	local v211, v212 = sampleGround()

	startDrive("hold", vector3Unit * arguments, p29, not (if not v211 then false else v211 <= 15))
end)

local rewind: BindableEvent = Instance.new("BindableEvent")

rewind.Name = "Rewind"
rewind.Parent = script
rewind.Event:Connect(function()
	if u34 then
		endBurst(true)
	end

	if not u73 then
		return
	end

	u73 = nil
	driveLV.Enabled = false
end)

local function onAction(p30, _)
	if p30 == Enum.UserInputState.Begin then
		local u215

		if humanoid.FloorMaterial == Enum.Material.Air then
			u215 = false
		else
			local v216, v217 = sampleGround()

			u215 = if not v216 then false else v216 <= 15
		end

		if not u215 then
			local x = humanoidRootPart.AssemblyLinearVelocity.X
			local v219 = math.min(humanoidRootPart.AssemblyLinearVelocity.Y, 9)

			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(x, v219, humanoidRootPart.AssemblyLinearVelocity.Z)

			return
		end

		if not u34 and not (humanoid.MoveDirection.Magnitude > 0.05) then
			if stunModule.IsStunned(scriptParent) then
				return Enum.ContextActionResult.Sink
			end

			u40 = true

			if u39 == true then
				updateCrouchAnim()
			else
				u39 = true
				scriptParent:SetAttribute("ParkourState", "Crouching")
				replicatedStorage.Remotes.ParkourState:FireServer("Crouching")

				if not u27 and beginnerTask_CrouchSlide then
					u27 = true
					beginnerTask_CrouchSlide:FireServer()
				end

				if u39 then
					tweenCamOffset(parkourCameraCrouch_y)
					updateCrouchAnim()
				else
					tweenCamOffset(0)

					if u48 then
						u48:Stop()
						u48:Destroy()
						u48 = nil
					end

					if u49 then
						u49:Stop()
						u49:Destroy()
						u49 = nil
					end
				end
			end

			return Enum.ContextActionResult.Sink
		end

		if u26 then
			beginBurst()
		else
			u40 = true

			if u39 == true then
				updateCrouchAnim()
			else
				u39 = true
				scriptParent:SetAttribute("ParkourState", "Crouching")
				replicatedStorage.Remotes.ParkourState:FireServer("Crouching")

				if not u27 and beginnerTask_CrouchSlide then
					u27 = true
					beginnerTask_CrouchSlide:FireServer()
				end

				if u39 then
					tweenCamOffset(parkourCameraCrouch_y)
					updateCrouchAnim()
				else
					tweenCamOffset(0)

					if u48 then
						u48:Stop()
						u48:Destroy()
						u48 = nil
					end

					if u49 then
						u49:Stop()
						u49:Destroy()
						u49 = nil
					end
				end
			end
		end

		return Enum.ContextActionResult.Sink
	end

	if p30 == Enum.UserInputState.End or p30 == Enum.UserInputState.Cancel then
		u40 = false

		if u39 and u39 ~= false then
			u39 = false
			scriptParent:SetAttribute("ParkourState", nil)
			replicatedStorage.Remotes.ParkourState:FireServer(nil)

			if u39 then
				tweenCamOffset(parkourCameraCrouch_y)
				updateCrouchAnim()
			else
				tweenCamOffset(0)

				if u48 then
					u48:Stop()
					u48:Destroy()
					u48 = nil
				end

				if u49 then
					u49:Stop()
					u49:Destroy()
					u49 = nil
				end
			end
		end

		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Sink
end

inputMap.bind("Crouch", onAction, { result = Enum.ContextActionResult.Sink })
scriptParent:GetAttributeChangedSignal("MobileSlide"):Connect(function()
	local mobileSlide: any = scriptParent:GetAttribute("MobileSlide")

	if mobileSlide == true then
		inputMap.fire("Crouch", Enum.UserInputState.Begin)
	elseif mobileSlide == false then
		inputMap.fire("Crouch", Enum.UserInputState.End)
	end
end)
humanoid.StateChanged:Connect(function()
	if not u39 then
	elseif humanoid:GetState() == Enum.HumanoidStateType.Jumping then
		u40 = false

		if u39 == false then
			return
		end

		u39 = false
		scriptParent:SetAttribute("ParkourState", nil)
		replicatedStorage.Remotes.ParkourState:FireServer(nil)

		if u39 then
			tweenCamOffset(parkourCameraCrouch_y)
			updateCrouchAnim()

			return
		end

		tweenCamOffset(0)

		if u48 then
			u48:Stop()
			u48:Destroy()
			u48 = nil
		end

		if u49 then
			u49:Stop()
			u49:Destroy()
			u49 = nil
		end

		return
	end
end)

local collectionService: CollectionService = game:GetService("CollectionService")
local t4: {[any]: any} = {}

local function frostIceUnder()
	for iterFirst, iterSecond in collectionService:GetTagged("FrostIce") do
		if iterSecond:IsA("BasePart") and iterSecond.Parent and not (iterSecond.CFrame.UpVector.Y < 0.55) and not (iterSecond.Size.Y * 0.5 > iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).Y) and not (iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).Y > iterSecond.Size.Y * 0.5 + 5) and not (iterSecond.Size.X * 0.5 < 0.001) and not (iterSecond.Size.Z * 0.5 < 0.001) and iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).X / (iterSecond.Size.X * 0.5) * (iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).X / (iterSecond.Size.X * 0.5)) + iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).Z / (iterSecond.Size.Z * 0.5) * (iterSecond.CFrame:PointToObjectSpace(humanoidRootPart.Position).Z / (iterSecond.Size.Z * 0.5)) <= 1 then
			return iterSecond
		end
	end

	return nil
end

runService.Heartbeat:Connect(function(deltaTime: number)
	if humanoid.Health <= 0 then
		return
	end

	updateDrive(time())

	if stunModule.IsStunned(scriptParent) then
		if u73 and u73.mode == "hold" and u73 then
			u73 = nil
			driveLV.Enabled = false
		end

		if u34 then
			endBurst()
		end

		if u39 then
			u40 = false

			if u39 ~= false then
				u39 = false
				scriptParent:SetAttribute("ParkourState", nil)
				replicatedStorage.Remotes.ParkourState:FireServer(nil)

				if u39 then
					tweenCamOffset(parkourCameraCrouch_y)
					updateCrouchAnim()
				else
					tweenCamOffset(0)

					if u48 then
						u48:Stop()
						u48:Destroy()
						u48 = nil
					end

					if u49 then
						u49:Stop()
						u49:Destroy()
						u49 = nil
					end
				end
			end
		end
	end

	local v224 = time()

	updateCharges(v224)

	local u225: boolean = humanoid.MoveDirection.Magnitude > 0.1 and not u34

	if u225 ~= u58 then
		u58 = u225
		updateTargetFOV()
	end

	if u26 then
		if u39 then
			humanoid.WalkSpeed = 11.5
		else
			local v226 = u24()
			local speedBoost: any = humanoid:GetAttribute("SpeedBoost")
			local emoteSpeedMult: any = humanoid:GetAttribute("EmoteSpeedMult")

			humanoid.WalkSpeed = (v226 + (speedBoost or 0)) * (emoteSpeedMult or 1)
		end

		local v229 = slowModule.GetSlowMultiplier(scriptParent)

		if v229 < 1 then
			humanoid.WalkSpeed = humanoid.WalkSpeed * v229
		end

		humanoid.JumpHeight = u25()
	end

	if not u34 then
		if next(t4) then
			table.clear(t4)
		end

		if u40 then
			if u39 == true then
				updateCrouchAnim()
			else
				u39 = true
				scriptParent:SetAttribute("ParkourState", "Crouching")
				replicatedStorage.Remotes.ParkourState:FireServer("Crouching")

				if not u27 and beginnerTask_CrouchSlide then
					u27 = true
					beginnerTask_CrouchSlide:FireServer()
				end

				if u39 then
					tweenCamOffset(parkourCameraCrouch_y)
					updateCrouchAnim()
				else
					tweenCamOffset(0)

					if u48 then
						u48:Stop()
						u48:Destroy()
						u48 = nil
					end

					if u49 then
						u49:Stop()
						u49:Destroy()
						u49 = nil
					end
				end
			end

			updateCrouchAnim()

			return
		end

		if not u39 then
			return
		end

		if u39 == false then
			return
		end

		u39 = false
		scriptParent:SetAttribute("ParkourState", nil)
		replicatedStorage.Remotes.ParkourState:FireServer(nil)

		if u39 then
			tweenCamOffset(parkourCameraCrouch_y)
			updateCrouchAnim()

			return
		end

		tweenCamOffset(0)

		if u48 then
			u48:Stop()
			u48:Destroy()
			u48 = nil
		end

		if u49 then
			u49:Stop()
			u49:Destroy()
			u49 = nil
		end

		return
	end

	local n4 = v224 - n1
	local v231, v232 = sampleGround()
	local u233
	local v234

	if not v231 then
		u233 = false
		v234 = nil
	else
		u233 = v231 <= 15
		v234 = v232
	end

	if not u233 then
		if humanoidRootPart.AssemblyLinearVelocity.Y > 10 then
			endBurst()

			return
		end

		n1 += deltaTime * 0.98
	end

	if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
		endBurst()

		return
	end

	if n4 >= 0.8 then
		local humanoidRootPartAssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
		local unit = humanoid.MoveDirection.Unit
		local vector3 = Vector3.new(unit.X, 0, unit.Z)
		local v238

		if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then
			v238 = vector3 * humanoid.WalkSpeed
		else
			local v239 = (humanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Unit

			vector3 = Vector3.new(v239.X, 0, v239.Z)
			v238 = if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then vector3 * humanoid.WalkSpeed else Vector3.new(0, 0, 0)
		end

		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(v238.X, humanoidRootPartAssemblyLinearVelocity.Y, v238.Z)
		endBurst()

		return
	end

	local v240 = if u233 then frostIceUnder() else nil
	local u241: boolean = v240 ~= nil
	local u242 = false

	if v234 then
		local v243 = vectorValue
		local v244 = (Vector3.new(0, -1, 0)):Dot(v234)
		local n5 = Vector3.new(0, -1, 0) - v234 * v244
		local magnitude = n5.Magnitude
		local n6 = if magnitude < 0.000001 then 0 else math.clamp((n5 / magnitude):Dot(v243), -1, 1)

		if n6 > 0.05 then
			u242 = true
			n3 += n6 * 16 * deltaTime
			n3 = math.min(n3, 28)

			local v248 = linearVelocity.VectorVelocity.Unit

			if v248 ~= v248 then
				v248 = humanoidRootPart.CFrame.LookVector
			end

			if not raycastCollidable(humanoidRootPart.Position, v248 * 6) then
				n1 += deltaTime * n6 * 0.98
			end
		elseif not u241 then
			n3 = math.max(0, n3 - 24 * deltaTime)
		end
	elseif not u241 then
		n3 = math.max(0, n3 - 24 * deltaTime)
	end

	if v240 and not t4[v240] then
		t4[v240] = true
		n3 = math.min(n3 + 16, 28)
		n1 = math.min(n1 + 0.3, v224)
	end

	if u241 then
		if n3 < 24 then
			n3 = math.min(n3 + 42 * deltaTime, 24)
		end

		if not u242 then
			n1 += deltaTime * 0.3
		end
	end

	u242 = n2 + n3
	v240 = slowModule.GetSlowMultiplier(scriptParent)

	if v240 < 1 then
		u242 *= v240
	end

	local v249 = math.min(n4 / 0.35, 1)

	v240 = Vector3.new(vectorValue.X * u242, 0, vectorValue.Z * u242) * (1 - v249 * 0.35)

	if n4 <= 0.35 then
		linearVelocity.VectorVelocity = v240

		return
	end

	v249 = math.clamp((n4 - 0.35) / 0.45, 0, 1)

	local v250 = humanoid.MoveDirection.Unit
	local vector3 = Vector3.new(v250.X, 0, v250.Z)
	local v252

	if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then
		v252 = vector3 * humanoid.WalkSpeed
	else
		local v253 = (humanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Unit

		vector3 = Vector3.new(v253.X, 0, v253.Z)
		v252 = if vector3 == vector3 and not (vector3.Magnitude < 0.000001) then vector3 * humanoid.WalkSpeed else Vector3.new(0, 0, 0)
	end

	linearVelocity.VectorVelocity = v240 + (v252 - v240) * (1 - (1 - v249) ^ 1.5)
end)
humanoid.Died:Connect(function()
	if u73 then
		u73 = nil
		driveLV.Enabled = false
	end

	endBurst(true)
	u40 = false

	if u39 ~= false then
		u39 = false
		scriptParent:SetAttribute("ParkourState", nil)
		replicatedStorage.Remotes.ParkourState:FireServer(nil)

		if u39 then
			tweenCamOffset(parkourCameraCrouch_y)
			updateCrouchAnim()
		else
			tweenCamOffset(0)

			if u48 then
				u48:Stop()
				u48:Destroy()
				u48 = nil
			end

			if u49 then
				u49:Stop()
				u49:Destroy()
				u49 = nil
			end
		end
	end

	if u56 then
		humanoid.AutoRotate = AutoRotate ~= false
		AutoRotate = nil
		u56 = false
	end

	u58 = false
	n4 = 70
	fovController.Pop("walk", 0)
	fovController.Pop("slide", 0)
	inputMap.unbind("Crouch", onAction)
end)
