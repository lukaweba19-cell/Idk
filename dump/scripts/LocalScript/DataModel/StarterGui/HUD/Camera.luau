-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("GuiService")

local service = UserSettings():GetService("UserGameSettings")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local crosshair = require(shared:WaitForChild("Crosshair"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(replicatedStorageShared:WaitForChild("ViewedPlayer"))
local v10: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(v10:WaitForChild("PlayerState"))
local v12: Instance = replicatedStorage:WaitForChild("Shared")
local thirdPerson = require(v12:WaitForChild("ThirdPerson"))
local v14: Instance = replicatedStorage:WaitForChild("Shared")
local viewmodelArms = require(v14:WaitForChild("ViewmodelArms"))
local v16: Instance = replicatedStorage:WaitForChild("Shared")
local parkourCamera = require(v16:WaitForChild("ParkourCamera"))
local spring2 = require(replicatedStorage.Util.Spring2)
local spring = require(script:WaitForChild("spring"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local spectateCam: Instance = remotes:WaitForChild("SpectateCam")

remotes:WaitForChild("ThirdPerson").OnClientEvent:Connect(function(p1)
	if p1 == nil then
		thirdPerson.Toggle()

		return
	end

	thirdPerson.SetEnabled(p1)
end)

local LocalPlayer: Player = players.LocalPlayer
local CurrentCamera: Camera = workspace.CurrentCamera
local n1 = 0
local n2 = 0
local n3 = 0
local v27 = spring2.new(Vector3.new(0, 0, 0))

v27.Damper = 1
v27.Speed = 15

local Character = LocalPlayer.Character

if not Character then
	Character = LocalPlayer.CharacterAdded
	Character = Character:Wait()
end

local head = Character:WaitForChild("Head")
local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local humanoid = Character:WaitForChild("Humanoid")
local u32: boolean = false

humanoid.Died:Once(function()
	u32 = true
end)

local viewedPlayerGetSpecTargetUserId = viewedPlayer.GetSpecTargetUserId

local function getPlayerByUserId(p2)
	for _, v in ipairs(players:GetPlayers()) do
		if p2 == v.UserId then
			return v
		end
	end

	return nil
end
local function refreshSpectateCursor()
	local v109 = viewedPlayerGetSpecTargetUserId()
	local v110: boolean = u32

	if v110 then
		v110 = LocalPlayer:GetAttribute("InMatch") == true
	end

	if v109 == nil and not v110 then
		LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", nil)

		return
	end

	LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", true)
end

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshSpectateCursor)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(refreshSpectateCursor)

if viewedPlayerGetSpecTargetUserId() == nil and not u32 then
	LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", nil)
else
	LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", true)
end

local t1: {[any]: any} = {}

local function clearCamBuf(p3)
	if p3 then
		t1[p3] = nil

		return
	end

	table.clear(t1)
end
local function pushSample(p4, p5, p6, p7)
	local t3 = t1[p4]

	if not t3 then
		t3 = {}
		t1[p4] = t3
	end

	local n1: number = #t3

	if n1 > 0 then
		local v118 = t3[n1]

		if p5 <= v118.t then
			p5 = v118.t + 0.004166666666666667
		end
	end

	t3[#t3 + 1] = { t = p5, cf = p6, root = p7 }

	if #t3 > 60 then
		table.remove(t3, 1)
	end
end
local function sampleSpectate(p8, p9)
	local v121 = t1[p8]

	if not v121 or #v121 == 0 then
		return nil, nil
	end

	if #v121 == 1 then
		return v121[1].cf, v121[1].root
	end

	local n1 = p9 - 0.12

	while #v121 >= 2 and n1 >= v121[2].t do
		table.remove(v121, 1)
	end

	if #v121 == 1 then
		return v121[1].cf, v121[1].root
	end

	local v123 = v121[1]
	local v124 = v121[2]

	v121 = v124.t - v123.t

	if v121 <= 0.000001 then
		return v124.cf, v124.root
	end

	local v125 = math.clamp((n1 - v123.t) / v121, 0, 1)

	return v123.cf:Lerp(v124.cf, v125), v123.root:Lerp(v124.root, v125)
end

local u40 = nil

spectateCam.OnClientEvent:Connect(function(p10, p11, p12, _)
	local v130 = os.clock()

	pushSample(p10, v130, p11, p12)
end)

local function _applyDirectBasePart(p14, p15)
	p14.LocalTransparencyModifier = if p15 then 1 else 0

	local decal = p14:FindFirstChildWhichIsA("Decal")

	if decal then
		decal.LocalTransparencyModifier = if p15 then 1 else 0
	end
end
local function _applyAccessoryDescendant(p16, p17)
	if p16:IsA("BasePart") then
		p16.LocalTransparencyModifier = if p17 then 1 else 0

		return
	end

	if p16:IsA("ParticleEmitter") or p16:IsA("Sparkles") or p16:IsA("Fire") or p16:IsA("Smoke") then
		p16.Enabled = not p17
	end
end
local function _applyAccessory(p18, p19)
	for _, v in ipairs(p18:GetDescendants()) do
		_applyAccessoryDescendant(v, p19)
	end
end

local t2: {[any]: any} = {}

local function _disposeHideTracker(p20)
	local v141 = t2[p20]

	if not v141 then
		return
	end

	v141.childAddedConn:Disconnect()

	for _, v in pairs(v141.accDescConns) do
		v:Disconnect()
	end

	v141.ancestryConn:Disconnect()
	t2[p20] = nil
end
local function _hookAccessoryAdditionsHidden(p21, p22)
	if p21.accDescConns[p22] then
		return
	end

	p21.accDescConns[p22] = p22.DescendantAdded:Connect(function(p23)
		_applyAccessoryDescendant(p23, true)
	end)
end
local function applyLocalFirstPersonTransparency(p24, p25)
	local u148: boolean = not p25

	for _, v in ipairs(p24:GetChildren()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = if u148 then 1 else 0

			local decal = v:FindFirstChildWhichIsA("Decal")

			if decal then
				decal.LocalTransparencyModifier = if u148 then 1 else 0
			end
		elseif v:IsA("Accessory") then
			for _, iterValue in ipairs(v:GetDescendants()) do
				_applyAccessoryDescendant(iterValue, u148)
			end
		end
	end

	if not u148 then
		_disposeHideTracker(p24)
	elseif not t2[p24] then
		local t4: {[any]: any} = {
			childAddedConn = nil,
			ancestryConn = nil,
			char = p24,
			accDescConns = {}
		}

		t4.childAddedConn = p24.ChildAdded:Connect(function(p26)
			if p26:IsA("BasePart") then
				p26.LocalTransparencyModifier = 1

				local decal = p26:FindFirstChildWhichIsA("Decal")

				if decal then
					decal.LocalTransparencyModifier = 1

					return
				end
			elseif p26:IsA("Accessory") then
				for _, v in ipairs(p26:GetDescendants()) do
					_applyAccessoryDescendant(v, true)
				end

				local v415: {[any]: any} = t4

				if v415.accDescConns[p26] then
					return
				end

				v415.accDescConns[p26] = p26.DescendantAdded:Connect(function(p23)
					_applyAccessoryDescendant(p23, true)
				end)
			end
		end)

		for _, v in ipairs(p24:GetChildren()) do
			if v:IsA("Accessory") and not t4.accDescConns[v] then
				t4.accDescConns[v] = v.DescendantAdded:Connect(function(p23)
					_applyAccessoryDescendant(p23, true)
				end)
			end
		end

		t4.ancestryConn = p24.AncestryChanged:Connect(function(_, p28)
			if p28 == nil then
				_disposeHideTracker(p24)
			end
		end)
		t2[p24] = t4

		return
	end
end

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local v157 = viewedPlayerGetSpecTargetUserId()

	if v157 then
		local v158, v159, v160 = ipairs(players:GetPlayers())
		local v161: boolean = false
		local v162

		for iterFirst, iterSecond in v158, v159, v160 do
			if v157 == iterSecond.UserId then
				v162 = iterSecond
				v161 = true

				break
			end
		end

		if not v161 then
			v162 = nil
		end

		local character = v162 and v162.Character

		if character then
			applyLocalFirstPersonTransparency(character, false)
		end
	end
end)

local function getYawFromCFrame(p29)
	local v167, v168, v169 = p29:ToOrientation()

	return (math.deg(v168))
end
local function smoothApproach(p30, p31, p32)
	local v173 = math.clamp(p32, 0, 1)

	return p30 + (p31 - p30) * v173
end

smoothApproach = function(p33, p34)
	return (p34 - p33 + 180) % 360 - 180
end

local function clampPitch(p35, p36, p37)
	return (math.clamp(p35, p36, p37))
end

local portalRedirect: Instance = script:FindFirstChild("PortalRedirect")
local v52

if portalRedirect and portalRedirect:IsA("BindableEvent") then
	v52 = portalRedirect
else
	local portalRedirect: BindableEvent = Instance.new("BindableEvent")

	portalRedirect.Name = "PortalRedirect"
	portalRedirect.Parent = script
	v52 = portalRedirect
end

v52.Event:Connect(function(p38, p39)
	local v181

	if typeof(p38) == "CFrame" then
		local v182, v183, v184 = p38:ToOrientation()

		v181 = math.deg(v183)
	else
		if typeof(p38) ~= "number" then
			return
		end

		v181 = p38
	end

	if v181 ~= v181 then
		return
	end

	n3 = if p39 then v181 % 360 else (n3 + v181) % 360
	n1 = n3
end)

local vector2 = Vector2.new(1, 0.77)

local function thumbstickCurve(p40)
	local absoluteValue = math.abs(p40)
	local v187 = math.exp((absoluteValue - 0.1) / 0.9 * 2)
	local v188 = math.sign(p40)
	local v189 = math.clamp((v187 - 1) / 6.38905609893065, 0, 1)

	return v188 * v189
end
local function handleLookInput(p41, p42, p43)
	local n1 = 0.015

	if p43 == Enum.UserInputType.Touch then
		local mobileSensitivity: any = LocalPlayer:GetAttribute("MobileSensitivity")
		local typeName: string = typeof(mobileSensitivity)

		n1 *= typeName == "number" and mobileSensitivity or 1
	end

	if crosshair.ADS then
		local scopedSensitivity: any = LocalPlayer:GetAttribute("ScopedSensitivity")
		local typeName: string = typeof(scopedSensitivity)

		n1 *= typeName == "number" and scopedSensitivity or 0.75
	end

	local n4 = p41.Magnitude > 0 and p41 / math.max(p42, 0.004166666666666667) or Vector2.new(0, 0)

	n2 = math.clamp(n2 - n4.Y * n1, -75, 75)
	n3 = (n3 - n4.X * n1) % 360

	local vector3 = Vector3.new(-n4.X, -n4.Y, 0)

	v27:Impulse(vector3 * 0.005)
end
local function ensureAlign(parent)
	local cameraAlignOrientation = parent:FindFirstChild("CameraAlignOrientation")

	if cameraAlignOrientation then
		return cameraAlignOrientation
	end

	local cameraAlignAttachment: Attachment = Instance.new("Attachment")

	cameraAlignAttachment.Name = "CameraAlignAttachment"
	cameraAlignAttachment.Parent = parent

	local cameraAlignOrientation: AlignOrientation = Instance.new("AlignOrientation")

	cameraAlignOrientation.Name = "CameraAlignOrientation"
	cameraAlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	cameraAlignOrientation.Attachment0 = cameraAlignAttachment
	cameraAlignOrientation.RigidityEnabled = false
	cameraAlignOrientation.MaxTorque = 50000
	cameraAlignOrientation.Responsiveness = 30
	cameraAlignOrientation.Enabled = true
	cameraAlignOrientation.Parent = parent

	return cameraAlignOrientation
end
local function spawnCamera(p45)
	local CurrentCamera2: Camera = workspace.CurrentCamera
	local currentCamera2CFrame: CFrame = CurrentCamera2.CFrame
	local currentCamera2CFramePosition = currentCamera2CFrame.Position
	local currentCamera2CFrameLookVector = currentCamera2CFrame.LookVector
	local vector3 = Vector3.new(currentCamera2CFrameLookVector.X, 0, currentCamera2CFrameLookVector.Z)

	if vector3.Magnitude < 0.000001 then
		vector3 = Vector3.new(0, 0, -1)
	end

	local vector3Unit = vector3.Unit
	local v211 = math.asin(currentCamera2CFrameLookVector.Y)
	local unit = Vector3.new(p45.LookVector.X, 0, p45.LookVector.Z).Unit
	local cosine = math.cos(v211)
	local vector32 = Vector3.new(unit.X * cosine, -0.3, unit.Z * cosine)

	CurrentCamera2.CFrame = CFrame.lookAt(currentCamera2CFramePosition, currentCamera2CFramePosition + vector32)
end

local humanoidRootPartCFrame = humanoidRootPart.CFrame
local v60, v61, v62 = humanoidRootPartCFrame:ToOrientation()
local v63 = math.deg(v61)

n1 = v63
n3 = v63

local n4 = 0

n2 = 0

local n5: number = 0
local n6: number = 0

spawnCamera(humanoidRootPartCFrame)

local function onCharacterAdded(p46)
	local head2 = p46:WaitForChild("Head")
	local humanoidRootPart2 = p46:WaitForChild("HumanoidRootPart")
	local humanoid2 = p46:WaitForChild("Humanoid")

	if p46 ~= LocalPlayer.Character then
		return
	end

	Character = p46
	head = head2
	humanoidRootPart = humanoidRootPart2
	humanoid = humanoid2
	CurrentCamera.CameraSubject = humanoid
	LocalPlayer:SetAttribute("VoteToMatchTransition", nil)

	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local u220: boolean = false

	if typeof(spectating) == "number" then
		u220 = false

		if spectating ~= 0 then
			u220 = spectating ~= LocalPlayer.UserId
		end
	end

	local inMatch: any = LocalPlayer:GetAttribute("InMatch")

	if not u220 and inMatch ~= true then
		userInputService.MouseBehavior = Enum.MouseBehavior.Default
		userInputService.MouseIconEnabled = true
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		CurrentCamera.CameraType = Enum.CameraType.Custom
	end

	local humanoidRootPartCFrame = humanoidRootPart.CFrame
	local v223, v224, v225 = humanoidRootPartCFrame:ToOrientation()
	local v226 = math.deg(v224)

	n1 = v226
	n3 = v226
	n4 = 0
	n2 = 0
	n5 = 0
	n6 = 0
	table.clear(t1)
	u40 = nil
	head:SetAttribute("DeathCamStartedAt", nil)
	head:SetAttribute("DeathCamFocusX", nil)
	head:SetAttribute("DeathCamFocusY", nil)
	head:SetAttribute("DeathCamFocusZ", nil)
	head:SetAttribute("DeathCamStartX", nil)
	head:SetAttribute("DeathCamStartY", nil)
	head:SetAttribute("DeathCamStartZ", nil)
	head:SetAttribute("DeathCamBackX", nil)
	head:SetAttribute("DeathCamBackZ", nil)
	spawnCamera(humanoidRootPartCFrame)
	u32 = false

	local v227 = viewedPlayerGetSpecTargetUserId()
	local v228: boolean = u32

	if v228 then
		v228 = LocalPlayer:GetAttribute("InMatch") == true
	end

	if v227 == nil and not v228 then
		LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", nil)
	else
		LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", true)
	end

	humanoid.Died:Once(function()
		u32 = true

		local v418 = viewedPlayerGetSpecTargetUserId()
		local v419: boolean = u32

		if v419 then
			v419 = LocalPlayer:GetAttribute("InMatch") == true
		end

		if v418 == nil and not v419 then
			LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", nil)

			return
		end

		LocalPlayer:SetAttribute("MouseUnlockedKeepCrosshair", true)
	end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

local Character2: Model = LocalPlayer.Character

if Character2 and Character2 ~= Character then
	task.spawn(onCharacterAdded, Character2)
end

local u69 = nil

onCharacterAdded = function()
	local v229 = userInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

	for _, v in ipairs(v229) do
		if v.KeyCode == Enum.KeyCode.Thumbstick2 then
			warn("Thumbstick2set")

			if LocalPlayer.UserId < 0 then
				warn("thumbstick2 broken hack")
			else
				u69 = v
			end
		end
	end
end
userInputService.GamepadConnected:Connect(onCharacterAdded)

if userInputService.GamepadEnabled then
	onCharacterAdded()
end

userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	elseif input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Thumbstick2 then
		local n1 = Vector2.new(input.Delta.X, input.Delta.Y) * 0.4 * (CurrentCamera.FieldOfView / 90)

		if input.UserInputType == Enum.UserInputType.Touch then
			n1 *= 2
		end

		if input.KeyCode == Enum.KeyCode.Thumbstick2 then
			return
		end

		handleLookInput(n1, 0.016666666666666666, input.UserInputType)

		return
	end
end)

local u70 = nil
local u71 = nil
local cFrame = CFrame.new()
local cFrame2 = CFrame.new()
local u74 = spring.create()
local u75 = spring.create()
local n7 = 0
local n8 = math.sqrt(u74.Force / u74.Mass) * 2
local n9 = u74.Damping / n8
local speed = u74.Speed

local function clearRig()
	if u70 then
		local v235 = u70

		if v235.neck then
			v235.neck.C0 = v235.defaultNeckC0
			v235.neck.C1 = v235.defaultNeckC1
		end

		if v235.leftShoulder then
			v235.leftShoulder.C0 = v235.defaultLeftC0
			v235.leftShoulder.C1 = v235.defaultLeftC1
		end

		if v235.rightShoulder then
			v235.rightShoulder.C0 = v235.defaultRightC0
			v235.rightShoulder.C1 = v235.defaultRightC1
		end

		pcall(function()
			v235.leftArm.LocalTransparencyModifier = 0
			v235.rightArm.LocalTransparencyModifier = 0
		end)
	end

	u70 = nil
	u71 = nil
	n7 = 0
end
local function makeCharacterProxy(character, p50)
	return {
		UserId = p50,
		Character = character,
		GetAttribute = function(_, p52)
			return character:GetAttribute(p52)
		end,
		GetAttributeChangedSignal = function(_, p54)
			return character:GetAttributeChangedSignal(p54)
		end,
		IsA = function(_, p56)
			return p56 == "Player"
		end
	}
end
local function tryBindRig(p57, character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local head = character:FindFirstChild("Head")
	local torso = character:FindFirstChild("Torso")
	local foundChild = character:FindFirstChild("Left Arm")
	local foundChild2 = character:FindFirstChild("Right Arm")

	if humanoidRootPart and humanoid and head and torso and foundChild and foundChild2 then
		local neck = torso:FindFirstChild("Neck")
		local foundChild3 = torso:FindFirstChild("Left Shoulder")
		local foundChild4 = torso:FindFirstChild("Right Shoulder")

		if neck and foundChild3 and foundChild4 then
			return {
				player = p57,
				character = character,
				root = humanoidRootPart,
				humanoid = humanoid,
				head = head,
				torso = torso,
				leftArm = foundChild,
				rightArm = foundChild2,
				neck = neck,
				leftShoulder = foundChild3,
				rightShoulder = foundChild4,
				defaultNeckC0 = neck.C0,
				defaultLeftC0 = foundChild3.C0,
				defaultRightC0 = foundChild4.C0,
				defaultNeckC1 = neck.C1,
				defaultLeftC1 = foundChild3.C1,
				defaultRightC1 = foundChild4.C1
			}
		end

		return nil
	end

	return nil
end
local function rigIsAlwaysTwoHanded(p59, p60)
	local foundChild5 = nil

	if p60 == "Revolver" then
		foundChild5 = "RevolverRig"
	elseif p60 == "Knife" then
		foundChild5 = "KnifeRig"
	end

	if not foundChild5 then
		return false
	end

	local foundChild = p59:FindFirstChild(foundChild5)

	foundChild5 = foundChild

	if foundChild5 then
		foundChild5 = foundChild:FindFirstChild("AlwaysTwoHanded", true)
	end

	local u253 = false

	if foundChild5 ~= nil then
		u253 = foundChild5:IsA("BoolValue") and foundChild5.Value == true
	end

	return u253
end
local function setArmTransparencyForRig(p61, p62)
	if p61.humanoid.Health <= 0 then
		p61.leftArm.LocalTransparencyModifier = 0
		p61.rightArm.LocalTransparencyModifier = 0

		return
	end

	if crosshair.IsFullOverlayScope(crosshair.ADS) then
		p61.leftArm.LocalTransparencyModifier = 1
		p61.rightArm.LocalTransparencyModifier = 1

		return
	end

	local tool = p61.character:FindFirstChildWhichIsA("Tool")
	local v257 = nil

	if not tool then
		if p61.character:GetAttribute("EnableRevolverRig") == true then
			v257 = "Revolver"
		elseif p61.character:GetAttribute("EnableKnifeRig") == true then
			v257 = "Knife"
		end
	end

	if not tool and not v257 then
		p61.leftArm.LocalTransparencyModifier = p62 or 1
		p61.rightArm.LocalTransparencyModifier = p62 or 1

		return
	end

	local v258 = tool and tool.Name or v257

	v257 = crosshair.TwoHanded or crosshair.ADS

	if not tool and not v257 then
		v257 = rigIsAlwaysTwoHanded(p61.character, v258)
	end

	if v257 and (v258 == "Revolver" or v258 == "Knife") then
		p61.leftArm.LocalTransparencyModifier = n7
		p61.rightArm.LocalTransparencyModifier = n7

		return
	end

	p61.leftArm.LocalTransparencyModifier = 1
	p61.rightArm.LocalTransparencyModifier = n7
end
local function cameraIsFirstPerson()
	local playerStateCameraFirstPerson = playerState.CameraFirstPerson

	if playerStateCameraFirstPerson == nil then
		local CurrentCamera3: Camera = workspace.CurrentCamera

		if not CurrentCamera3 then
			return false
		end

		return (CurrentCamera3.CFrame.Position - CurrentCamera3.Focus.Position).Magnitude <= 1
	end

	return playerStateCameraFirstPerson
end
local function thirdPersonCFrame(p63)
	local v262 = p63.Position
	local n1 = v262 - p63.LookVector * thirdPerson.Distance + p63.RightVector * thirdPerson.Shoulder + Vector3.new(0, 1, 0) * thirdPerson.Height
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin }
	raycastParams.IgnoreWater = true

	local n2 = n1
	local v266 = workspace:Raycast(v262, n1 - v262, raycastParams)

	if v266 then
		n2 = v266.Position + (v262 - n1).Unit * thirdPerson.SurfacePad
	end

	v266 = n2 - v262

	local magnitude = v266.Magnitude

	if magnitude < thirdPerson.MinDistance then
		n2 = v262 + (magnitude > 0.001 and v266.Unit or -p63.LookVector) * thirdPerson.MinDistance
	end

	return CFrame.lookAt(n2, v262 + p63.LookVector * 500, p63.UpVector)
end
local function inFirstPersonForTarget(p64, p65, p66)
	if p65.Health <= 0 then
		return false
	end

	if p66 then
		local playerStateCameraFirstPerson = playerState.CameraFirstPerson

		if playerStateCameraFirstPerson == nil then
			local CurrentCamera4: Camera = workspace.CurrentCamera

			if not CurrentCamera4 then
				return false
			end

			return (CurrentCamera4.CFrame.Position - CurrentCamera4.Focus.Position).Magnitude <= 1
		end

		return playerStateCameraFirstPerson
	end

	local u273: boolean = false

	if p64:GetAttribute("InMatch") == true then
		local cameraFirstPerson = playerState.CameraFirstPerson

		if cameraFirstPerson == nil then
			local CurrentCamera5: Camera = workspace.CurrentCamera

			if not CurrentCamera5 then
				return false
			end

			u273 = (CurrentCamera5.CFrame.Position - CurrentCamera5.Focus.Position).Magnitude <= 1

			return u273
		end

		return cameraFirstPerson
	end

	return u273
end

local u88 = os.clock()
local u89: boolean = true
local u90 = nil

local function setCharVisible(p67, p68)
	if not p67 then
		return
	end

	applyLocalFirstPersonTransparency(p67, p68)
end

local u92 = nil
local u93: boolean = false
local u94: boolean = false
local u95 = nil
local u96 = nil
local n10 = 0
local v98 = spring2.new(0)

v98.Damper = 0.8
v98.Speed = 18

local v99 = spring2.new(0)

v99.Damper = parkourCamera.SLIDE_SPRING_DAMPER
v99.Speed = parkourCamera.SLIDE_SPRING_SPEED

local n11 = 0

runService:BindToRenderStep("CameraMover", Enum.RenderPriority.Camera.Value + 1, function(_)
	local v279 = os.clock()
	local n9 = v279 - u88

	u88 = v279

	if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		return
	end

	if playerState.ReplayActive then
		return
	end

	v279 = viewedPlayerGetSpecTargetUserId()

	if v279 then
		local v281, v282, v283 = ipairs(players:GetPlayers())
		local v284: boolean = false
		local v285

		for iterFirst, iterSecond in v281, v282, v283 do
			if v279 == iterSecond.UserId then
				v285 = iterSecond
				v284 = true

				break
			end
		end

		if not v284 then
			v285 = nil
		end

		u92 = v285 and v285.Character or nil
	else
		u92 = nil
	end

	if u92 ~= u90 then
		local v288 = u90

		if v288 then
			applyLocalFirstPersonTransparency(v288, true)
		end

		if u95 then
			u95:Disconnect()
			u95 = nil
		end

		if u96 then
			u96:Disconnect()
			u96 = nil
		end

		u94 = false
		v288 = u92

		if v288 then
			applyLocalFirstPersonTransparency(v288, false)
		end

		v288 = u92 and u92.Parent and u92:FindFirstChildOfClass("Humanoid")

		if v288 then
			if v288.Health <= 0 then
				u94 = true

				local v289 = u92

				if v289 then
					applyLocalFirstPersonTransparency(v289, true)
				end
			else
				u95 = v288.Died:Once(function()
					u94 = true

					if u92 then
						applyLocalFirstPersonTransparency(u92, true)
					end
				end)
				u96 = u92.AncestryChanged:Once(function(_, p71)
					if p71 == nil then
						u94 = true

						if u92 then
							applyLocalFirstPersonTransparency(u92, true)
						end
					end
				end)
			end
		end

		u90 = u92
		u40 = nil
	end

	if not v279 and u90 then
		applyLocalFirstPersonTransparency(u90, true)

		if u95 then
			u95:Disconnect()
			u95 = nil
		end

		if u96 then
			u96:Disconnect()
			u96 = nil
		end

		u94 = false
		u92 = nil
		u90 = nil
		table.clear(t1)
		u40 = nil
	end

	u93 = v279 ~= nil

	local inMatch: any = LocalPlayer:GetAttribute("InMatch")
	local u291: boolean = LocalPlayer:GetAttribute("VoteToMatchTransition") == true
	local v292 = u93 or inMatch == true or u291
	local u293 = v292 ~= u89

	u89 = v292

	if not v292 then
		if u293 then
			userInputService.MouseBehavior = Enum.MouseBehavior.Default
			userInputService.MouseIconEnabled = true
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
			CurrentCamera.CameraType = Enum.CameraType.Custom
			CurrentCamera.CameraSubject = Character:FindFirstChildOfClass("Humanoid")
			LocalPlayer.CameraMinZoomDistance = 14
			LocalPlayer.CameraMaxZoomDistance = 100
			task.delay(0.1, function()
				LocalPlayer.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance
				LocalPlayer.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
			end)
			clearRig()
			table.clear(t1)
			u40 = nil
		end

		return
	end

	v292 = LocalPlayer:GetAttribute("FreecamActive") == true
	u293 = thirdPerson.IsEnabled() and not u93 and not u32 and not v292
	applyLocalFirstPersonTransparency(Character, v292 or u93 or u32 or u293)

	if u93 and u92 and not u94 then
		applyLocalFirstPersonTransparency(u92, false)
	end

	local v294 = Enum.MouseBehavior.LockCenter
	local u295: boolean = false

	if (LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0 then
		v294 = Enum.MouseBehavior.Default
		u295 = true
	end

	if LocalPlayer:GetAttribute("MouseUnlockedKeepCrosshair") then
		v294 = Enum.MouseBehavior.Default
		u295 = true
	end

	if v294 ~= userInputService.MouseBehavior then
		userInputService.MouseBehavior = v294
	end

	if u295 ~= userInputService.MouseIconEnabled then
		userInputService.MouseIconEnabled = u295
	end

	u295 = u32 and not u93 or u93 and u94
	v292 = head

	local v296 = u93 and u94 and u92 and u92:FindFirstChild("Head")

	if v296 then
		v292 = v296
	end

	if u295 then
		ensureAlign(humanoidRootPart).Enabled = false
		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local deathCamStartedAt = v292:GetAttribute("DeathCamStartedAt")

		if typeof(deathCamStartedAt) ~= "number" then
			local timestamp = tick()

			v292:SetAttribute("DeathCamStartedAt", timestamp)

			local v299 = v292.Position

			v292:SetAttribute("DeathCamFocusX", v299.X)
			v292:SetAttribute("DeathCamFocusY", v299.Y)
			v292:SetAttribute("DeathCamFocusZ", v299.Z)

			local n12 = CurrentCamera.CFrame.Position - v299
			local vector3 = Vector3.new(n12.X, 0, n12.Z)
			local v302

			if vector3.Magnitude > 0.001 then
				v302 = vector3.Unit
			else
				local vector33 = Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)

				v302 = vector33.Magnitude > 0.001 and -vector33.Unit or Vector3.new(0, 0, 1)
			end

			v292:SetAttribute("DeathCamBackX", v302.X)
			v292:SetAttribute("DeathCamBackZ", v302.Z)

			local n13 = v299 + v302 * 8 + Vector3.new(0, 5, 0)

			v292:SetAttribute("DeathCamStartX", n13.X)
			v292:SetAttribute("DeathCamStartY", n13.Y)
			v292:SetAttribute("DeathCamStartZ", n13.Z)
		end

		local deathCamFocusX = v292:GetAttribute("DeathCamFocusX")
		local deathCamFocusY = v292:GetAttribute("DeathCamFocusY")
		local vector3 = Vector3.new(deathCamFocusX, deathCamFocusY, v292:GetAttribute("DeathCamFocusZ"))
		local deathCamStartX = v292:GetAttribute("DeathCamStartX")
		local deathCamStartY = v292:GetAttribute("DeathCamStartY")
		local vector34 = Vector3.new(deathCamStartX, deathCamStartY, v292:GetAttribute("DeathCamStartZ"))
		local deathCamBackX = v292:GetAttribute("DeathCamBackX")
		local vector35 = Vector3.new(deathCamBackX, 0, v292:GetAttribute("DeathCamBackZ"))
		local timestamp = tick()
		local deathCamStartedAt2 = v292:GetAttribute("DeathCamStartedAt")
		local v315 = math.clamp((timestamp - deathCamStartedAt2) / 3, 0, 1)
		local v316 = vector34:Lerp(vector3 + (vector35.Magnitude > 0.001 and vector35.Unit or Vector3.new(0, 0, 1)) * (v315 * 12.5 + 7.5) + Vector3.new(0, 5, 0), v315)
		local v317 = v292.Position
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin }
		raycastParams.IgnoreWater = true

		local n14 = v316 - v317
		local v320 = v317

		if n14.Magnitude > 0.001 then
			v320 = v317 + n14.Unit * 0.75
		end

		n14 = workspace:Raycast(v320, v316 - v320, raycastParams)
		v315 = v316

		if n14 then
			v315 = n14.Position + n14.Normal * 0.5
		end

		if v315.Y < vector3.Y then
			v315 = Vector3.new(v315.X, vector3.Y, v315.Z)
		end

		v316 = CFrame.lookAt(v315, v317)

		local v321 = math.exp(-10 * n9)

		CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v316, 1 - v321)
		CurrentCamera.Focus = CFrame.new(v317)

		return
	end

	if u291 then
		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		return
	end

	CurrentCamera.CameraType = Enum.CameraType.Scriptable

	if service.RotationType ~= Enum.RotationType.MovementRelative then
		service.RotationType = Enum.RotationType.MovementRelative
	end

	LocalPlayer.CameraMode = if u293 then Enum.CameraMode.Classic else Enum.CameraMode.LockFirstPerson

	if u93 then
		local v322, cFrame = sampleSpectate(v279, os.clock())

		if v322 then
			CurrentCamera.CFrame = v322
			CurrentCamera.Focus = v322
		end

		local v324 = u92

		if v324 then
			v324 = u92:FindFirstChild("HumanoidRootPart")
		end

		if v324 and cFrame then
			v324.CFrame = cFrame
		end

		u40 = cFrame

		return
	end

	if u69 then
		local v325 = u69.Position
		local x = v325.X
		local absoluteValue = math.abs(x)

		absoluteValue = math.exp((absoluteValue - 0.1) / 0.9 * 2)

		local v328 = math.sign(x)
		local v329 = math.clamp((absoluteValue - 1) / 6.38905609893065, 0, 1)
		local n15 = v328 * v329
		local y = v325.Y
		local absoluteValue2 = math.abs(y)
		local v333 = math.exp((absoluteValue2 - 0.1) / 0.9 * 2)
		local v334 = math.sign(y)
		local v335 = math.clamp((v333 - 1) / 6.38905609893065, 0, 1)
		local n16 = v334 * v335

		if math.abs(n15) > 0 or math.abs(n16) > 0 then
			local serviceGamepadCameraSensitivity = service.GamepadCameraSensitivity
			local n7 = 1

			if crosshair.ADS then
				local scopedSensitivity: any = LocalPlayer:GetAttribute("ScopedSensitivity")

				n7 = typeof(scopedSensitivity) == "number" and scopedSensitivity or 0.75
			end

			local n8 = n15 * 4.1887902047863905 * vector2.X * serviceGamepadCameraSensitivity * n7 * n9
			local v341 = n2
			local v342 = math.deg(n16 * 4.1887902047863905 * vector2.Y * serviceGamepadCameraSensitivity * n7 * n9)

			n2 = math.clamp(v341 + v342, -75, 75)
			v341 = n3
			v342 = math.deg(n8)
			n3 = (v341 - v342) % 360

			local vector3 = Vector3.new(-n15, -n16, 0)

			v27:Impulse(vector3 * 0.02)
		end
	end

	n1 = n3
	n4 = n2
	n5 = n6
	v296 = 0

	if humanoidRootPart:FindFirstChild("BurstSlideLV") then
		local v344 = math.clamp((humanoidRootPart.BurstSlideLV.VectorVelocity * Vector3.new(1, 0, 1)).Magnitude / 42, 0, 1)

		v296 *= v344
	end

	local v345 = humanoidRootPart.Parent

	if v345 then
		v345 = humanoidRootPart.Parent:GetAttribute("ParkourState") == "Sliding"
	end

	v98.Target = v345 and v296 or 0
	v99.Target = if v345 then 1 else 0
	n11 = viewmodelArms.StepAdsAlpha(n11, if crosshair.ADS then 1 else 0, n9)
	viewmodelArms.AdsCorrection(humanoidRootPart.Parent, n11)
	v345 = humanoidRootPart.Position + humanoidRootPart.CFrame.UpVector * parkourCamera.EYE_HEIGHT

	local v346 = math.clamp(n4 + v27.Position.Y, -89, 89)
	local v347 = math.rad(v346)
	local v348 = math.rad(n1)
	local v349 = math.rad(n5 + v27.Position.X * 0.5 + v98.Position * (1 - n11))

	LocalPlayer.PlayerGui.Cursor.CenterDot.Rotation = -v98.Position * (1 - n11)

	local cFrame3 = CFrame.new(v345 + (humanoid.CameraOffset - Vector3.new(0, 1, 0) * v99.Position * parkourCamera.SLIDE_EXTRA_Y))
	local v351 = CFrame.Angles(0, v348, 0)
	local v352 = CFrame.Angles(v347, 0, 0)
	local v353 = CFrame.Angles(0, 0, v349)

	v346 = cFrame3 * v351 * v352 * v353

	local v354 = u293 and thirdPersonCFrame(v346) or v346

	thirdPerson.PublishEye(v346)
	CurrentCamera.CFrame = v354
	CurrentCamera.Focus = u293 and CFrame.new(v346.Position) or v354

	if humanoid.AutoRotate then
		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + v346.LookVector * Vector3.new(1, 0, 1))

		local v355 = ensureAlign(humanoidRootPart)

		v355.CFrame = humanoidRootPart.CFrame
	end

	n10 += n9

	if n10 >= 0.03333333333333333 then
		n10 -= 0.03333333333333333
		spectateCam:FireServer(v346, humanoidRootPart.CFrame, os.clock())
	end
end)

local n12 = 0
local n13 = 0
local n14 = 0
local n15 = 0

runService:BindToRenderStep("FirstPersonArms", Enum.RenderPriority.Camera.Value + 2, function(p72)
	local v357 = viewedPlayerGetSpecTargetUserId()
	local u358: boolean = v357 ~= nil
	local v359 = LocalPlayer

	if u358 and v357 then
		local v360, v361, v362 = ipairs(players:GetPlayers())
		local v363: boolean = false
		local v364

		for iterFirst, iterSecond in v360, v361, v362 do
			if v357 == iterSecond.UserId then
				v364 = iterSecond
				v363 = true

				break
			end
		end

		if not v363 then
			v364 = nil
		end

		if v364 then
			v359 = v364
		else
			local v367 = viewedPlayer.GetCharacter()

			if not v367 or v367 == LocalPlayer.Character then
				if u71 ~= nil then
					clearRig()
				end

				return
			end

			v359 = makeCharacterProxy(v367, v357)
		end
	end

	local Character3 = v359.Character

	if not Character3 then
		if u71 ~= nil then
			clearRig()
		end

		return
	end

	if u71 ~= v359.UserId or u70 and Character3 ~= u70.character then
		clearRig()

		local v369 = tryBindRig(v359, Character3)

		if not v369 then
			return
		end

		u70 = v369
		u71 = v359.UserId
		cFrame = CFrame.new()
		cFrame2 = CFrame.new()
		u74 = spring.create()
		u75 = spring.create()
	end

	v357 = u70

	if not v357 then
		return
	end

	local freecamActive: any = LocalPlayer:GetAttribute("FreecamActive")
	local u371

	if v357.humanoid.Health <= 0 then
		u371 = false
	elseif u358 then
		local playerStateCameraFirstPerson = playerState.CameraFirstPerson
		local CurrentCamera6: Camera = workspace.CurrentCamera

		u371 = if playerStateCameraFirstPerson == nil then if not CurrentCamera6 then false else (CurrentCamera6.CFrame.Position - CurrentCamera6.Focus.Position).Magnitude <= 1 else playerStateCameraFirstPerson
	else
		u371 = false

		if v359:GetAttribute("InMatch") == true then
			local cameraFirstPerson = playerState.CameraFirstPerson
			local CurrentCamera7: Camera = workspace.CurrentCamera

			u371 = if cameraFirstPerson == nil then if not CurrentCamera7 then false else (CurrentCamera7.CFrame.Position - CurrentCamera7.Focus.Position).Magnitude <= 1 else cameraFirstPerson
		end
	end

	if u371 and freecamActive ~= true then
		local v377
		local u379

		if playerState.ReplayActive then
			local assemblyLinearVelocity = v357.root.AssemblyLinearVelocity
			local vector3 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
			local v382: number = n15
			local n1 = vector3.Magnitude - n15
			local v383 = math.exp(-p72 / 0.08)

			n15 = v382 + n1 * (1 - v383)
			v377 = n15
			u379 = v377 > 2
		else
			v377 = v357.humanoid.WalkSpeed
			u379 = v357.humanoid.MoveDirection.Magnitude > 0
		end

		local v384 = p72

		if playerState.ReplayActive then
			v384 = p72 * (playerState.ReplayTimeScale or 1)
		end

		n14 += v384 * (v377 / 19 * 1.5)

		if n14 > 6.283185307179586 then
			n14 -= 6.283185307179586
		end

		v384 = function(p73, p74)
			return math.sin(n14 * p73) * p74
		end

		local v385 = userInputService:GetMouseDelta()

		if u358 then
			v385 = Vector2.new(0, 0)
		end

		n12 = viewmodelArms.StepAdsAlpha(n12, if crosshair.ADS then 1 else 0, p72)

		local n2 = if v357.character:GetAttribute("ParkourState") == "Sliding" then 1 else 0

		if n2 > n13 then
			n13 = math.min(n13 + p72 * 10, n2)
		elseif n2 < n13 then
			n13 = math.max(n13 - p72 * 10, n2)
		end

		n2 = viewmodelArms.AdsCorrection(v357.character, n12)

		local sine = math.sin(n14 * 10)
		local sine2 = math.sin(n14 * 5)
		local vector3 = Vector3.new(sine * 4, sine2 * 4, 0)
		local v390 = u74
		local vector36 = Vector3.new(v385.X / 420, v385.Y / 420)

		v390:shove(vector36)

		if script:GetAttribute("WalkCycle") == true then
			cFrame2 = u75:update(p72) * (1 - n12 * 0.98) * (1 - n13 * 0.98)

			if cFrame2.Magnitude < 0.003 then
				cFrame2 = Vector3.new()
			end
		else
			cFrame2 = Vector3.new()
		end

		if script:GetAttribute("ViewmodelSway") == true then
			local n3 = (1 - n12 * 0.98) * (1 - n13 * 0.33)

			u74.Damping = n8 * (n9 + (1 - n9) * n12)
			u74.Speed = speed + (10 - speed) * n12

			local v393 = u74
			local v394 = math.min(p72, 0.1)
			local v395 = v393:update(v394)

			if v395.Magnitude < 0.002 and u74.Velocity.Magnitude < 0.01 then
				u74.Position = Vector3.new(0, 0, 0)
				u74.Velocity = Vector3.new(0, 0, 0)
				v395 = Vector3.new(0, 0, 0)
			end

			cFrame = v395 * n3
		else
			cFrame = Vector3.new()
		end

		local cFrame4 = CFrame.new(cFrame2.Y, cFrame2.X, cFrame2.Z)

		if u379 then
			u75:shove(vector3 * p72)
		else
			u75:shove((Vector3.new()))
		end

		n7 = script:GetAttribute("ArmTransparency") or 0

		local v397, v398, v399 = v357.torso.CFrame:ToEulerAnglesYXZ()
		local v400 = v398

		if not u358 then
			local v401, v402, v403 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

			v400 = v402
		elseif u40 then
			local v404, v405, v406 = u40:ToOrientation()

			v400 = v405
		end

		local viewmodelOffset = script:GetAttribute("ViewmodelOffset")

		if not viewmodelOffset then
			viewmodelOffset = Vector3.new()
		end

		local v408 = viewmodelArms.AdsLift(viewmodelOffset, n12)

		v408 = viewmodelArms.HoldCFrame({
			cameraCF = CurrentCamera.CFrame,
			torsoY = v400,
			torsoZ = v399,
			viewmodelOffset = v408,
			sway = cFrame,
			movement = cFrame4,
			adsCorrection = n2
		})

		local u409: boolean = v357.character:FindFirstChild("Revolver") ~= nil

		if not v357.character:FindFirstChildWhichIsA("Tool") then
			u409 = v357.character:GetAttribute("EnableRevolverRig") == true
		end

		viewmodelArms.Pose(v357, v408, viewmodelArms.ArmsWidth(v357.character, u409))
		setArmTransparencyForRig(v357)

		return
	end

	n7 = 0
	v357.neck.C1 = v357.defaultNeckC1
	v357.leftShoulder.C1 = v357.defaultLeftC1
	v357.rightShoulder.C1 = v357.defaultRightC1
	v357.neck.C0 = v357.defaultNeckC0
	v357.leftShoulder.C0 = v357.defaultLeftC0
	v357.rightShoulder.C0 = v357.defaultRightC0
	v357.rightArm.Size = Vector3.new(1, 2, 1)
	v357.leftArm.LocalTransparencyModifier = 0
	v357.rightArm.LocalTransparencyModifier = 0
end)
