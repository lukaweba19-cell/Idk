-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

game:GetService("UserInputService")

local vrService: VRService = game:GetService("VRService")
local service = UserSettings():GetService("UserGameSettings")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local connectionUtil = require(commonUtils:WaitForChild("ConnectionUtil"))

require(commonUtils:WaitForChild("FlagUtil"))

local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local zoomController = require(script.Parent:WaitForChild("ZoomController"))
local cameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"))
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local cameraUI = require(script.Parent:WaitForChild("CameraUI"))
local LocalPlayer: Player = players.LocalPlayer

local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end)

local u14 = ok and result

Vector2.new(0, 0)

local t1: {[any]: any} = {
	CHARACTER_ADDED = "CHARACTER_ADDED",
	CAMERA_MODE_CHANGED = "CAMERA_MODE_CHANGED",
	CAMERA_MIN_DISTANCE_CHANGED = "CAMERA_MIN_DISTANCE_CHANGED",
	CAMERA_MAX_DISTANCE_CHANGED = "CAMERA_MAX_DISTANCE_CHANGED"
}
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local object = setmetatable({}, module)

	object._connections = connectionUtil.new()
	object.gamepadZoomLevels = { 0, 10, 20 }
	object.FIRST_PERSON_DISTANCE_THRESHOLD = 1
	object.cameraType = nil
	object.cameraMovementMode = nil
	object.lastCameraTransform = nil
	object.lastUserPanCamera = tick()
	object.humanoidRootPart = nil
	object.humanoidCache = {}
	object.lastSubject = nil
	object.lastSubjectPosition = Vector3.new(0, 5, 0)
	object.lastSubjectCFrame = CFrame.new(object.lastSubjectPosition)
	object.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)
	object.inFirstPerson = false
	object.inMouseLockedMode = false
	object.resetCameraAngle = true
	object.enabled = false
	object.cameraChangedConn = nil
	object.shouldUseVRRotation = false
	object.VRRotationIntensityAvailable = false
	object.lastVRRotationIntensityCheckTime = 0
	object.lastVRRotationTime = 0
	object.vrRotateKeyCooldown = {}
	object.cameraTranslationConstraints = Vector3.new(1, 1, 1)
	object.humanoidJumpOrigin = nil
	object.trackingHumanoid = nil
	object.cameraFrozen = false
	object.subjectStateChangedConn = nil
	object.gamepadZoomPressConnection = nil
	object.mouseLockOffset = Vector3.new(0, 0, 0)
	service:SetCameraYInvertVisible()
	service:SetGamepadCameraSensitivityVisible()

	return object
end
function module.GetModuleName(_)
	return "BaseCamera"
end
function module._setUpConfigurations(p2)
	p2._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(character: Model)
		p2:OnCharacterAdded(character)
	end))
	p2.humanoidRootPart = nil

	local _connections = p2._connections
	local v21: RBXScriptSignal = LocalPlayer:GetPropertyChangedSignal("CameraMode")

	_connections:trackConnection("CAMERA_MODE_CHANGED", v21:Connect(function()
		p2:OnPlayerCameraPropertyChange()
	end))

	local v22 = p2._connections

	v21 = LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance")
	v22:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", v21:Connect(function()
		p2:OnPlayerCameraPropertyChange()
	end))

	local v23 = p2._connections

	v21 = LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance")
	v23:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", v21:Connect(function()
		p2:OnPlayerCameraPropertyChange()
	end))
	p2:OnPlayerCameraPropertyChange()
end
function module.OnCharacterAdded(p4, _)
	p4.resetCameraAngle = p4.resetCameraAngle or p4:GetEnabled()
	p4.humanoidRootPart = nil
end
function module.GetHumanoidRootPart(p6)
	local humanoid = not p6.humanoidRootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		p6.humanoidRootPart = humanoid.RootPart
	end

	return p6.humanoidRootPart
end
function module.GetBodyPartToFollow(_, p8, _)
	local v31 = p8:GetState() == Enum.HumanoidStateType.Dead and p8.Parent

	if v31 and v31:IsA("Model") then
		return v31:FindFirstChild("Head") or p8.RootPart
	end

	return p8.RootPart
end
function module.GetSubjectCFrame(p10)
	local v33 = p10.lastSubjectCFrame
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if not currentCameraCameraSubject then
		return v33
	end

	if currentCameraCameraSubject:IsA("Humanoid") then
		local u36: boolean = currentCameraCameraSubject:GetState() == Enum.HumanoidStateType.Dead
		local v37 = currentCameraCameraSubject.CameraOffset

		if p10:GetIsMouseLocked() then
			v37 = Vector3.new()
		end

		local v38 = currentCameraCameraSubject.RootPart

		if u36 and currentCameraCameraSubject.Parent and currentCameraCameraSubject.Parent:IsA("Model") then
			v38 = currentCameraCameraSubject.Parent:FindFirstChild("Head") or v38
		end

		if v38 and v38:IsA("BasePart") then
			local vectorValue

			if currentCameraCameraSubject.RigType ~= Enum.HumanoidRigType.R15 then
				vectorValue = Vector3.new(0, 1.5, 0)
			elseif currentCameraCameraSubject.AutomaticScalingEnabled then
				vectorValue = Vector3.new(0, 1.5, 0)

				local currentCameraCameraSubjectRootPart = currentCameraCameraSubject.RootPart

				if v38 == currentCameraCameraSubjectRootPart then
					local vector3 = Vector3.new(0, (currentCameraCameraSubjectRootPart.Size.Y - 2) / 2, 0)

					vectorValue += vector3
				end
			else
				vectorValue = Vector3.new(0, 2, 0)
			end

			if u36 then
				vectorValue = Vector3.new(0, 0, 0)
			end

			local v42 = v38.CFrame
			local cFrame = CFrame.new(vectorValue + v37)

			v33 = v42 * cFrame
		end
	elseif currentCameraCameraSubject:IsA("BasePart") then
		v33 = currentCameraCameraSubject.CFrame
	elseif currentCameraCameraSubject:IsA("Model") then
		v33 = if currentCameraCameraSubject.PrimaryPart then currentCameraCameraSubject:GetPrimaryPartCFrame() else CFrame.new()
	end

	if v33 then
		p10.lastSubjectCFrame = v33
	end

	return v33
end
function module.GetSubjectVelocity(_)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if not currentCameraCameraSubject then
		return Vector3.new(0, 0, 0)
	end

	if currentCameraCameraSubject:IsA("BasePart") then
		return currentCameraCameraSubject.Velocity
	end

	if currentCameraCameraSubject:IsA("Humanoid") then
		local currentCameraCameraSubjectRootPart = currentCameraCameraSubject.RootPart

		if currentCameraCameraSubjectRootPart then
			return currentCameraCameraSubjectRootPart.Velocity
		end
	else
		local v48 = currentCameraCameraSubject:IsA("Model") and currentCameraCameraSubject.PrimaryPart

		if v48 then
			return v48.Velocity
		end
	end

	return Vector3.new(0, 0, 0)
end
function module.GetSubjectRotVelocity(_)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if not currentCameraCameraSubject then
		return Vector3.new(0, 0, 0)
	end

	if currentCameraCameraSubject:IsA("BasePart") then
		return currentCameraCameraSubject.RotVelocity
	end

	if currentCameraCameraSubject:IsA("Humanoid") then
		local currentCameraCameraSubjectRootPart = currentCameraCameraSubject.RootPart

		if currentCameraCameraSubjectRootPart then
			return currentCameraCameraSubjectRootPart.RotVelocity
		end
	else
		local v53 = currentCameraCameraSubject:IsA("Model") and currentCameraCameraSubject.PrimaryPart

		if v53 then
			return v53.RotVelocity
		end
	end

	return Vector3.new(0, 0, 0)
end
function module.StepZoom(p13)
	local currentSubjectDistance = p13.currentSubjectDistance
	local v56 = cameraInput.getZoomDelta()

	if math.abs(v56) > 0 then
		local v57 = if v56 > 0 then math.max(currentSubjectDistance + v56 * (currentSubjectDistance * 0.5 + 1), p13.FIRST_PERSON_DISTANCE_THRESHOLD) else math.max((currentSubjectDistance + v56) / (1 - v56 * 0.5), 0.5)

		if v57 < p13.FIRST_PERSON_DISTANCE_THRESHOLD then
			v57 = 0.5
		end

		p13:SetCameraToSubjectDistance(v57)
	end

	return zoomController.GetZoomRadius()
end
function module.GetSubjectPosition(p14)
	local v59 = p14.lastSubjectPosition
	local CurrentCamera: Camera = game.Workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if currentCameraCameraSubject then
		if currentCameraCameraSubject:IsA("Humanoid") then
			local u62: boolean = currentCameraCameraSubject:GetState() == Enum.HumanoidStateType.Dead
			local v63 = currentCameraCameraSubject.CameraOffset

			if p14:GetIsMouseLocked() then
				v63 = Vector3.new()
			end

			local v64 = currentCameraCameraSubject.RootPart

			if u62 and currentCameraCameraSubject.Parent and currentCameraCameraSubject.Parent:IsA("Model") then
				v64 = currentCameraCameraSubject.Parent:FindFirstChild("Head") or v64
			end

			if v64 and v64:IsA("BasePart") then
				local vectorValue

				if currentCameraCameraSubject.RigType ~= Enum.HumanoidRigType.R15 then
					vectorValue = Vector3.new(0, 1.5, 0)
				elseif currentCameraCameraSubject.AutomaticScalingEnabled then
					vectorValue = Vector3.new(0, 1.5, 0)

					if v64 == currentCameraCameraSubject.RootPart then
						local vector3 = Vector3.new(0, currentCameraCameraSubject.RootPart.Size.Y / 2 - 1, 0)

						vectorValue += vector3
					end
				else
					vectorValue = Vector3.new(0, 2, 0)
				end

				if u62 then
					vectorValue = Vector3.new(0, 0, 0)
				end

				local p = v64.CFrame.p
				local v68 = v64.CFrame:vectorToWorldSpace(vectorValue + v63)

				v59 = p + v68
			end
		elseif currentCameraCameraSubject:IsA("VehicleSeat") then
			local v69 = currentCameraCameraSubject.CFrame.p
			local v70 = currentCameraCameraSubject.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))

			v59 = v69 + v70
		elseif currentCameraCameraSubject:IsA("SkateboardPlatform") then
			v59 = currentCameraCameraSubject.CFrame.p + Vector3.new(0, 5, 0)
		elseif currentCameraCameraSubject:IsA("BasePart") then
			v59 = currentCameraCameraSubject.CFrame.p
		elseif currentCameraCameraSubject:IsA("Model") then
			if currentCameraCameraSubject.PrimaryPart then
				v59 = currentCameraCameraSubject:GetPrimaryPartCFrame().p
			else
				v59 = currentCameraCameraSubject:GetModelCFrame().p
			end
		end

		p14.lastSubject = currentCameraCameraSubject
		p14.lastSubjectPosition = v59

		return v59
	end

	return nil
end
function module.OnCurrentCameraChanged(p15)
	if p15.cameraSubjectChangedConn then
		p15.cameraSubjectChangedConn:Disconnect()
		p15.cameraSubjectChangedConn = nil
	end

	local CurrentCamera: Camera = game.Workspace.CurrentCamera

	if CurrentCamera then
		p15.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
			p15:OnNewCameraSubject()
		end)
		p15:OnNewCameraSubject()
	end
end
function module.OnPlayerCameraPropertyChange(p16)
	p16:SetCameraToSubjectDistance(p16.currentSubjectDistance)
end
function module.InputTranslationToCameraAngleChange(_, p18, p19)
	return p18 * p19
end
function module.GamepadZoomPress(p20)
	local v78 = p20:GetCameraToSubjectDistance()
	local v79 = LocalPlayer.CameraMaxZoomDistance

	for i = #p20.gamepadZoomLevels, 1, -1 do
		local v81 = p20.gamepadZoomLevels[i]

		if not (v79 < v81) then
			if v81 < LocalPlayer.CameraMinZoomDistance then
				v81 = LocalPlayer.CameraMinZoomDistance

				if u14 and v79 == v81 then
					break
				end
			end

			if not u14 and v79 == v81 then
				break
			end

			if v78 > v81 + (v79 - v81) / 2 then
				p20:SetCameraToSubjectDistance(v81)

				return
			end

			v79 = v81
		end
	end

	p20:SetCameraToSubjectDistance(p20.gamepadZoomLevels[#p20.gamepadZoomLevels])
end
function module.Enable(p21, p22)
	if p22 ~= p21.enabled then
		p21.enabled = p22
		p21:OnEnabledChanged()
	end
end
function module.OnEnabledChanged(p23)
	if p23.enabled then
		p23:_setUpConfigurations()
		cameraInput.setInputEnabled(true)
		p23.gamepadZoomPressConnection = cameraInput.gamepadZoomPress:Connect(function()
			p23:GamepadZoomPress()
		end)

		if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
			p23.currentSubjectDistance = 0.5

			if not p23.inFirstPerson then
				p23:EnterFirstPerson()
			end
		end

		if p23.cameraChangedConn then
			p23.cameraChangedConn:Disconnect()
			p23.cameraChangedConn = nil
		end

		p23.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			p23:OnCurrentCameraChanged()
		end)
		p23:OnCurrentCameraChanged()

		return
	end

	p23._connections:disconnectAll()
	cameraInput.setInputEnabled(false)

	if p23.gamepadZoomPressConnection then
		p23.gamepadZoomPressConnection:Disconnect()
		p23.gamepadZoomPressConnection = nil
	end

	p23:Cleanup()
end
function module.GetEnabled(p24)
	return p24.enabled
end
function module.Cleanup(p25)
	if p25.subjectStateChangedConn then
		p25.subjectStateChangedConn:Disconnect()
		p25.subjectStateChangedConn = nil
	end

	if p25.cameraChangedConn then
		p25.cameraChangedConn:Disconnect()
		p25.cameraChangedConn = nil
	end

	p25.lastCameraTransform = nil
	p25.lastSubjectCFrame = nil
	cameraUtils.restoreMouseBehavior()
end
function module.UpdateMouseBehavior(p26)
	if p26.isCameraToggle and service.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
		cameraUI.setCameraModeToastEnabled(true)
		cameraInput.enableCameraToggleInput()
		cameraToggleStateController(p26.inFirstPerson)

		return
	end

	cameraUI.setCameraModeToastEnabled(false)
	cameraInput.disableCameraToggleInput()

	if not p26.inFirstPerson and not p26.inMouseLockedMode then
		cameraUtils.restoreRotationType()

		if cameraInput.getRotationActivated() then
			cameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)

			return
		end

		cameraUtils.restoreMouseBehavior()

		return
	end

	cameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
	cameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
end
function module.UpdateForDistancePropertyChange(p27)
	p27:SetCameraToSubjectDistance(p27.currentSubjectDistance)
end
function module.SetCameraToSubjectDistance(p28, p29)
	local currentSubjectDistance = p28.currentSubjectDistance

	if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
		p28.currentSubjectDistance = 0.5

		if not p28.inFirstPerson then
			p28:EnterFirstPerson()
		end
	else
		local v92 = math.clamp(p29, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance)

		if v92 < 1 then
			p28.currentSubjectDistance = 0.5

			if not p28.inFirstPerson then
				p28:EnterFirstPerson()
			end
		else
			p28.currentSubjectDistance = v92

			if p28.inFirstPerson then
				p28:LeaveFirstPerson()
			end
		end
	end

	local zoomControllerSetZoomParameters = zoomController.SetZoomParameters
	local v94 = p28.currentSubjectDistance
	local v95 = math.sign(p29 - currentSubjectDistance)

	zoomControllerSetZoomParameters(v94, v95)

	return p28.currentSubjectDistance
end
function module.SetCameraType(p30, p31)
	p30.cameraType = p31
end
function module.GetCameraType(p32)
	return p32.cameraType
end
function module.SetCameraMovementMode(p33, p34)
	p33.cameraMovementMode = p34
end
function module.GetCameraMovementMode(p35)
	return p35.cameraMovementMode
end
function module.SetIsMouseLocked(p36, p37)
	p36.inMouseLockedMode = p37
end
function module.GetIsMouseLocked(p38)
	return p38.inMouseLockedMode
end
function module.SetMouseLockOffset(p39, p40)
	p39.mouseLockOffset = p40
end
function module.GetMouseLockOffset(p41)
	return p41.mouseLockOffset
end
function module.InFirstPerson(p42)
	return p42.inFirstPerson
end
function module.EnterFirstPerson(p43)
	p43.inFirstPerson = true
	p43:UpdateMouseBehavior()
end
function module.LeaveFirstPerson(p44)
	p44.inFirstPerson = false
	p44:UpdateMouseBehavior()
end
function module.GetCameraToSubjectDistance(p45)
	return p45.currentSubjectDistance
end
function module.GetMeasuredDistanceToFocus(_)
	local CurrentCamera: Camera = game.Workspace.CurrentCamera

	if CurrentCamera then
		return (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude
	end

	return nil
end
function module.GetCameraLookVector(_)
	return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end
function module.CalculateNewLookCFrameFromArg(p48, p49, p50)
	local v118 = p49 or p48:GetCameraLookVector()
	local v119 = math.asin(v118.Y)
	local v120 = math.clamp(p50.Y, v119 + -1.3962634015954636, v119 + 1.3962634015954636)
	local vector2 = Vector2.new(p50.X, v120)
	local cFrame = CFrame.new(Vector3.new(0, 0, 0), v118)
	local v123 = CFrame.Angles(0, -vector2.X, 0)
	local v124 = CFrame.Angles(-vector2.Y, 0, 0)

	return v123 * cFrame * v124
end
function module.CalculateNewLookVectorFromArg(p51, p52, p53)
	return p51:CalculateNewLookCFrameFromArg(p52, p53).LookVector
end
function module.CalculateNewLookVectorVRFromArg(p54, p55)
	local unit = ((p54:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
	local vector2 = Vector2.new(p55.X, 0)
	local cFrame = CFrame.new(Vector3.new(0, 0, 0), unit)
	local v133 = CFrame.Angles(0, -vector2.X, 0)
	local v134 = CFrame.Angles(-vector2.Y, 0, 0)

	return ((v133 * cFrame * v134).LookVector * Vector3.new(1, 0, 1)).unit
end
function module.GetHumanoid(p56)
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character

	if localPlayerCharacter then
		local v137 = p56.humanoidCache[LocalPlayer]

		if v137 and localPlayerCharacter == v137.Parent then
			return v137
		end

		p56.humanoidCache[LocalPlayer] = nil

		local humanoid = localPlayerCharacter:FindFirstChildOfClass("Humanoid")

		if humanoid then
			p56.humanoidCache[LocalPlayer] = humanoid
		end

		return humanoid
	end

	return nil
end
function module.GetHumanoidPartToFollow(_, p58, p59)
	if p59 == Enum.HumanoidStateType.Dead then
		local v142 = p58.Parent

		if v142 then
			return v142:FindFirstChild("Head") or p58.Torso
		end

		return p58.Torso
	end

	return p58.Torso
end
function module.OnNewCameraSubject(p60)
	if p60.subjectStateChangedConn then
		p60.subjectStateChangedConn:Disconnect()
		p60.subjectStateChangedConn = nil
	end
end
function module.IsInFirstPerson(p61)
	return p61.inFirstPerson
end
function module.Update(_, _)
	error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end
function module.GetCameraHeight(p64)
	if vrService.VREnabled and not p64.inFirstPerson then
		return 0.25881904510252074 * p64.currentSubjectDistance
	end

	return 0
end

return module
