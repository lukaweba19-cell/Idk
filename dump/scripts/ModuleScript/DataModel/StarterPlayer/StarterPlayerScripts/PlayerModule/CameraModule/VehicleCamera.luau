-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = { 0, 15, 30 }
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local baseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))

require(script.Parent:WaitForChild("ZoomController"))

local vehicleCameraCore = require(script:WaitForChild("VehicleCameraCore"))
local vehicleCameraConfig = require(script:WaitForChild("VehicleCameraConfig"))
local LocalPlayer: Player = players.LocalPlayer
local cameraUtilsMap = cameraUtils.map
local cameraUtilsSpring = cameraUtils.Spring
local cameraUtilsMapClamp = cameraUtils.mapClamp
local cameraUtilsSanitizeAngle = cameraUtils.sanitizeAngle

local function pitchVelocity(p1, p2)
	local v20 = p2.XVector:Dot(p1)

	return (math.abs(v20))
end
local function yawVelocity(p3, p4)
	local v23 = p4.YVector:Dot(p3)

	return (math.abs(v23))
end

local n1: number = 0.016666666666666666

runService.Stepped:Connect(function(time: number, deltaTime: number)
	n1 = deltaTime
end)

local object = setmetatable({}, baseCamera)

object.__index = object

function object.new()
	local v26 = baseCamera.new()
	local object2 = setmetatable(v26, object)

	object2:Reset()

	return object2
end
function object.Reset(p7)
	p7.vehicleCameraCore = vehicleCameraCore.new(p7:GetSubjectCFrame())

	local cameraUtilsSpringNew = cameraUtilsSpring.new
	local v30 = math.rad(vehicleCameraConfig.pitchBaseAngle)

	p7.pitchSpring = cameraUtilsSpringNew(0, -v30)
	p7.yawSpring = cameraUtilsSpring.new(0, 0)
	p7.lastPanTick = 0

	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	assert(CurrentCamera)
	assert(currentCameraCameraSubject)
	assert(currentCameraCameraSubject:IsA("VehicleSeat"))

	local v33 = currentCameraCameraSubject:GetConnectedParts(true)
	local v34, v35 = cameraUtils.getLooseBoundingSphere(v33)

	p7.assemblyRadius = math.max(v35, 5)
	p7.assemblyOffset = currentCameraCameraSubject.CFrame:Inverse() * v34
	p7.gamepadZoomLevels = {}

	for key, value in t1 do
		table.insert(p7.gamepadZoomLevels, value * p7.assemblyRadius / 10)
	end

	p7:SetCameraToSubjectDistance(p7.gamepadZoomLevels[#p7.gamepadZoomLevels])
end
function object._StepRotation(p8, p9, p10)
	local yawSpring = p8.yawSpring
	local pitchSpring = p8.pitchSpring
	local v43 = cameraInput.getRotation(p9, true)
	local n1 = -v43.Y

	yawSpring.pos = cameraUtilsSanitizeAngle(yawSpring.pos + -v43.X)

	local v45 = math.clamp(pitchSpring.pos + n1, -1.3962634015954636, 1.3962634015954636)

	pitchSpring.pos = cameraUtilsSanitizeAngle(v45)

	if cameraInput.getRotationActivated() then
		p8.lastPanTick = os.clock()
	end

	n1 = -math.rad(vehicleCameraConfig.pitchBaseAngle)

	local v46 = math.rad(vehicleCameraConfig.pitchDeadzoneAngle)

	if os.clock() - p8.lastPanTick > vehicleCameraConfig.autocorrectDelay then
		local v47 = cameraUtilsMapClamp(p10, vehicleCameraConfig.autocorrectMinCarSpeed, vehicleCameraConfig.autocorrectMaxCarSpeed, 0, vehicleCameraConfig.autocorrectResponse)

		yawSpring.freq = v47
		pitchSpring.freq = v47

		if yawSpring.freq < 0.001 then
			yawSpring.vel = 0
		end

		if pitchSpring.freq < 0.001 then
			pitchSpring.vel = 0
		end

		local v48 = cameraUtilsSanitizeAngle(n1 - pitchSpring.pos)
		local absoluteValue = math.abs(v48)

		if v46 >= absoluteValue then
			pitchSpring.goal = pitchSpring.pos
		else
			pitchSpring.goal = n1
		end
	else
		yawSpring.freq = 0
		yawSpring.vel = 0
		pitchSpring.freq = 0
		pitchSpring.vel = 0
		pitchSpring.goal = n1
	end

	local cFrameFromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ

	v45 = pitchSpring:step(p9)

	local v51 = yawSpring:step(p9)

	return cFrameFromEulerAnglesYXZ(v45, v51, 0)
end
function object._GetThirdPersonLocalOffset(p11)
	local assemblyOffset = p11.assemblyOffset
	local vector3 = Vector3.new(0, p11.assemblyRadius * vehicleCameraConfig.verticalCenterOffset, 0)

	return assemblyOffset + vector3
end
function object._GetFirstPersonLocalOffset(p12, p13)
	local Character: Model = LocalPlayer.Character
	local v58 = Character and Character.Parent and Character:FindFirstChild("Head")

	if v58 and v58:IsA("BasePart") then
		return p13:Inverse() * v58.Position
	end

	return p12:_GetThirdPersonLocalOffset()
end
function object.Update(p14)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject
	local vehicleCameraCore = p14.vehicleCameraCore

	assert(CurrentCamera)
	assert(currentCameraCameraSubject)
	assert(currentCameraCameraSubject:IsA("VehicleSeat"))

	local v63: number = n1

	n1 = 0

	local v64 = p14:GetSubjectCFrame()
	local v65 = p14:GetSubjectVelocity()
	local v66 = p14:GetSubjectRotVelocity()
	local v67 = v65:Dot(v64.ZVector)
	local absoluteValue = math.abs(v67)
	local v69 = v64.YVector:Dot(v66)
	local absoluteValue2 = math.abs(v69)

	v69 = v64.XVector:Dot(v66)

	local absoluteValue3 = math.abs(v69)

	v66 = p14:StepZoom()
	v69 = p14:_StepRotation(v63, absoluteValue)

	local v72 = cameraUtilsMapClamp(v66, 0.5, p14.assemblyRadius, 1, 0)
	local v73 = p14:_GetThirdPersonLocalOffset()
	local v74 = p14:_GetFirstPersonLocalOffset(v64)
	local v75 = v73:Lerp(v74, v72)

	vehicleCameraCore:setTransform(v64)

	local v76 = vehicleCameraCore:step(v63, absoluteValue3, absoluteValue2, v72)

	v73 = CFrame.new(v64 * v75) * v76 * v69

	local cFrame = CFrame.new(0, 0, v66)

	return v73 * cFrame, v73
end
function object.ApplyVRTransform(_)
end

return object
