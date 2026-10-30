-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v2 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserFixOrbitalCameraAzimuth")
local t1: {[any]: any} = {
	InitialDistance = 25,
	MinDistance = 10,
	MaxDistance = 100,
	InitialElevation = 35,
	MinElevation = 35,
	MaxElevation = 35,
	ReferenceAzimuth = -45,
	CWAzimuthTravel = 90,
	CCWAzimuthTravel = 90,
	UseAzimuthLimits = false
}
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local players: Players = game:GetService("Players")
local baseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local object = setmetatable({}, baseCamera)

object.__index = object

function object.new()
	local v9 = baseCamera.new()
	local object2 = setmetatable(v9, object)

	object2.lastUpdate = tick()
	object2.changedSignalConnections = {}
	object2.refAzimuthRad = nil
	object2.curAzimuthRad = nil
	object2.minAzimuthAbsoluteRad = nil
	object2.maxAzimuthAbsoluteRad = nil
	object2.useAzimuthLimits = nil
	object2.curElevationRad = nil
	object2.minElevationRad = nil
	object2.maxElevationRad = nil
	object2.curDistance = nil
	object2.minDistance = nil
	object2.maxDistance = nil
	object2.gamepadDollySpeedMultiplier = 1
	object2.lastUserPanCamera = tick()
	object2.externalProperties = {}
	object2.externalProperties.InitialDistance = 25
	object2.externalProperties.MinDistance = 10
	object2.externalProperties.MaxDistance = 100
	object2.externalProperties.InitialElevation = 35
	object2.externalProperties.MinElevation = 35
	object2.externalProperties.MaxElevation = 35
	object2.externalProperties.ReferenceAzimuth = -45
	object2.externalProperties.CWAzimuthTravel = 90
	object2.externalProperties.CCWAzimuthTravel = 90
	object2.externalProperties.UseAzimuthLimits = false
	object2:LoadNumberValueParameters()

	return object2
end
function object.LoadOrCreateNumberValueParameter(p1, name, className, p4)
	local foundChild = script:FindFirstChild(name)

	if foundChild and foundChild:IsA(className) then
		p1.externalProperties[name] = foundChild.Value
	else
		if p1.externalProperties[name] == nil then
			return
		end

		foundChild = Instance.new(className)
		foundChild.Name = name
		foundChild.Parent = script
		foundChild.Value = p1.externalProperties[name]
	end

	if p4 then
		if p1.changedSignalConnections[name] then
			p1.changedSignalConnections[name]:Disconnect()
		end

		p1.changedSignalConnections[name] = foundChild.Changed:Connect(function(p5)
			p1.externalProperties[name] = p5
			p4(p1)
		end)
	end
end
function object.SetAndBoundsCheckAzimuthValues(p6)
	local v17 = math.rad(p6.externalProperties.ReferenceAzimuth)
	local v18 = math.rad(p6.externalProperties.CWAzimuthTravel)
	local absoluteValue = math.abs(v18)

	p6.minAzimuthAbsoluteRad = v17 - absoluteValue
	v17 = math.rad(p6.externalProperties.ReferenceAzimuth)
	v18 = math.rad(p6.externalProperties.CCWAzimuthTravel)

	local absoluteValue2 = math.abs(v18)

	p6.maxAzimuthAbsoluteRad = v17 + absoluteValue2
	p6.useAzimuthLimits = p6.externalProperties.UseAzimuthLimits

	if p6.useAzimuthLimits then
		p6.curAzimuthRad = math.max(p6.curAzimuthRad, p6.minAzimuthAbsoluteRad)
		p6.curAzimuthRad = math.min(p6.curAzimuthRad, p6.maxAzimuthAbsoluteRad)
	end
end
function object.SetAndBoundsCheckElevationValues(p7)
	local v22 = math.max(p7.externalProperties.MinElevation, -80)
	local v23 = math.min(p7.externalProperties.MaxElevation, 80)
	local v24 = math.min(v22, v23)

	p7.minElevationRad = math.rad(v24)
	v24 = math.max(v22, v23)
	p7.maxElevationRad = math.rad(v24)
	p7.curElevationRad = math.max(p7.curElevationRad, p7.minElevationRad)
	p7.curElevationRad = math.min(p7.curElevationRad, p7.maxElevationRad)
end
function object.SetAndBoundsCheckDistanceValues(p8)
	p8.minDistance = p8.externalProperties.MinDistance
	p8.maxDistance = p8.externalProperties.MaxDistance
	p8.curDistance = math.max(p8.curDistance, p8.minDistance)
	p8.curDistance = math.min(p8.curDistance, p8.maxDistance)
end
function object.LoadNumberValueParameters(p9)
	p9:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil)
	p9:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil)
	p9:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", if v2 then p9.SetAndBoundsCheckAzimuthValues else p9.SetAndBoundsCheckAzimuthValue)
	p9:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p9.SetAndBoundsCheckAzimuthValues)
	p9:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p9.SetAndBoundsCheckAzimuthValues)
	p9:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p9.SetAndBoundsCheckElevationValues)
	p9:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p9.SetAndBoundsCheckElevationValues)
	p9:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p9.SetAndBoundsCheckDistanceValues)
	p9:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p9.SetAndBoundsCheckDistanceValues)
	p9:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p9.SetAndBoundsCheckAzimuthValues)
	p9.curAzimuthRad = math.rad(p9.externalProperties.ReferenceAzimuth)
	p9.curElevationRad = math.rad(p9.externalProperties.InitialElevation)
	p9.curDistance = p9.externalProperties.InitialDistance
	p9:SetAndBoundsCheckAzimuthValues()
	p9:SetAndBoundsCheckElevationValues()
	p9:SetAndBoundsCheckDistanceValues()
end
function object.GetModuleName(_)
	return "OrbitalCamera"
end
function object.SetInitialOrientation(p11, p12)
	if not p12 or not p12.RootPart then
		warn("OrbitalCamera could not set initial orientation due to missing humanoid")

		return
	end

	assert(p12.RootPart, "")

	local unit = (p12.RootPart.CFrame.LookVector - Vector3.new(0, 0.23, 0)).Unit
	local v31 = cameraUtils.GetAngleBetweenXZVectors(unit, p11:GetCameraLookVector())
	local v32 = p11:GetCameraLookVector()
	local v33 = math.asin(v32.Y)

	v32 = math.asin(unit.Y)

	if not cameraUtils.IsFinite(v31) then
	end

	if not cameraUtils.IsFinite(v33 - v32) then
	end
end
function object.GetCameraToSubjectDistance(p13)
	return p13.curDistance
end
function object.SetCameraToSubjectDistance(p14, p15)
	if players.LocalPlayer then
		p14.currentSubjectDistance = math.clamp(p15, p14.minDistance, p14.maxDistance)
		p14.currentSubjectDistance = math.max(p14.currentSubjectDistance, p14.FIRST_PERSON_DISTANCE_THRESHOLD)
	end

	p14.inFirstPerson = false
	p14:UpdateMouseBehavior()

	return p14.currentSubjectDistance
end
function object.CalculateNewLookVector(p16, p17, p18)
	local v40 = p17 or p16:GetCameraLookVector()
	local v41 = math.asin(v40.Y)
	local v42 = math.clamp(p18.Y, v41 - 1.3962634015954636, v41 - -1.3962634015954636)
	local vector2 = Vector2.new(p18.X, v42)
	local cFrame = CFrame.new(Vector3.new(0, 0, 0), v40)
	local v45 = CFrame.Angles(0, -vector2.X, 0)
	local v46 = CFrame.Angles(-vector2.Y, 0, 0)

	return (v45 * cFrame * v46).LookVector
end
function object.Update(p19, p20)
	local timestamp = tick()
	local n1 = timestamp - p19.lastUpdate
	local v51 = cameraInput.getRotation(p20)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v53 = CurrentCamera.CFrame
	local v54 = CurrentCamera.Focus
	local LocalPlayer: Player = players.LocalPlayer
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject
	local v57 = currentCameraCameraSubject and currentCameraCameraSubject:IsA("VehicleSeat")
	local v58 = currentCameraCameraSubject and currentCameraCameraSubject:IsA("SkateboardPlatform")

	if p19.lastUpdate == nil or n1 > 1 then
		p19.lastCameraTransform = nil
	end

	if v51 ~= Vector2.new() then
		p19.lastUserPanCamera = tick()
	end

	local v59 = p19:GetSubjectPosition()

	if v59 and LocalPlayer and CurrentCamera then
		if p19.gamepadDollySpeedMultiplier ~= 1 then
			p19:SetCameraToSubjectDistance(p19.currentSubjectDistance * p19.gamepadDollySpeedMultiplier)
		end

		v54 = CFrame.new(v59)

		local v60 = cameraInput.getRotation(p20)

		p19.curAzimuthRad = p19.curAzimuthRad - v60.X

		if p19.useAzimuthLimits then
			p19.curAzimuthRad = math.clamp(p19.curAzimuthRad, p19.minAzimuthAbsoluteRad, p19.maxAzimuthAbsoluteRad)
		else
			p19.curAzimuthRad = p19.curAzimuthRad ~= 0 and math.sign(p19.curAzimuthRad) * (math.abs(p19.curAzimuthRad) % 6.283185307179586) or 0
		end

		p19.curElevationRad = math.clamp(p19.curElevationRad + v60.Y, p19.minElevationRad, p19.maxElevationRad)

		local currentSubjectDistance = p19.currentSubjectDistance
		local v62 = CFrame.fromEulerAnglesYXZ(-p19.curElevationRad, p19.curAzimuthRad, 0)

		v53 = CFrame.new(v59 + currentSubjectDistance * (v62 * Vector3.new(0, 0, 1)), v59)
		p19.lastCameraTransform = v53
		p19.lastCameraFocus = v54

		if not v57 and not v58 or not currentCameraCameraSubject:IsA("BasePart") then
			p19.lastSubjectCFrame = nil
		else
			p19.lastSubjectCFrame = currentCameraCameraSubject.CFrame
		end
	end

	p19.lastUpdate = timestamp

	return v53, v54
end

return object
