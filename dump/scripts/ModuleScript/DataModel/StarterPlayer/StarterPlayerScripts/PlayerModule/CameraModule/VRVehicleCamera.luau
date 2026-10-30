-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)

local u3 = ok and result
local t1: {[any]: any} = { 0, 30 }
local service = UserSettings():GetService("UserGameSettings")
local vrBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))

require(script.Parent:WaitForChild("VehicleCamera"))

local v9 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local v10 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local vrService: VRService = game:GetService("VRService")
local LocalPlayer: Player = players.LocalPlayer
local cameraUtilsSpring = cameraUtils.Spring
local cameraUtilsMapClamp = cameraUtils.mapClamp
local cameraUtilsSanitizeAngle = cameraUtils.sanitizeAngle

local function pitchVelocity(p1, p2)
	local v24 = p2.XVector:Dot(p1)

	return (math.abs(v24))
end
local function yawVelocity(p3, p4)
	local v27 = p4.YVector:Dot(p3)

	return (math.abs(v27))
end

local n1: number = 0.016666666666666666
local object = setmetatable({}, vrBaseCamera)

object.__index = object

function object.new()
	local v28 = vrBaseCamera.new()
	local object2 = setmetatable(v28, object)

	object2:Reset()
	runService.Stepped:Connect(function(time: number, deltaTime: number)
		n1 = deltaTime
	end)

	return object2
end
function object.Reset(p7)
	p7.vehicleCameraCore = v9.new(p7:GetSubjectCFrame())

	if u3 then
		p7.pitchSpring = cameraUtilsSpring.new(0, 0)
	else
		local cameraUtilsSpringNew = cameraUtilsSpring.new
		local v32 = math.rad(v10.pitchBaseAngle)

		p7.pitchSpring = cameraUtilsSpringNew(0, -v32)
	end

	p7.yawSpring = cameraUtilsSpring.new(0, 0)

	if u3 then
		p7.lastPanTick = 0
		p7.currentDriftAngle = 0
		p7.needsReset = true
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	assert(CurrentCamera, "VRVehicleCamera initialization error")
	assert(currentCameraCameraSubject)
	assert(currentCameraCameraSubject:IsA("VehicleSeat"))

	local v35 = currentCameraCameraSubject:GetConnectedParts(true)
	local v36, v37 = cameraUtils.getLooseBoundingSphere(v35)

	p7.assemblyRadius = math.max(v37, 5)
	p7.assemblyOffset = currentCameraCameraSubject.CFrame:Inverse() * v36
	p7.gamepadZoomLevels = {}

	for key, value in t1 do
		table.insert(p7.gamepadZoomLevels, value * p7.headScale * p7.assemblyRadius / 10)
	end

	p7.lastCameraFocus = nil
	p7:SetCameraToSubjectDistance(p7.gamepadZoomLevels[#p7.gamepadZoomLevels])
end
function object._StepRotation(p8, p9, p10)
	local yawSpring = p8.yawSpring
	local pitchSpring = p8.pitchSpring
	local v45 = p8:getRotation(p9)

	yawSpring.pos = cameraUtilsSanitizeAngle(yawSpring.pos + -v45)

	local v46 = math.clamp(pitchSpring.pos, -1.3962634015954636, 1.3962634015954636)

	pitchSpring.pos = cameraUtilsSanitizeAngle(v46)

	if cameraInput.getRotationActivated() then
		p8.lastPanTick = os.clock()
	end

	local v47 = math.rad(v10.pitchDeadzoneAngle)

	if os.clock() - p8.lastPanTick > v10.autocorrectDelay then
		local v48 = cameraUtilsMapClamp(p10, v10.autocorrectMinCarSpeed, v10.autocorrectMaxCarSpeed, 0, v10.autocorrectResponse)

		yawSpring.freq = v48
		pitchSpring.freq = v48

		if yawSpring.freq < 0.001 then
			yawSpring.vel = 0
		end

		if pitchSpring.freq < 0.001 then
			pitchSpring.vel = 0
		end

		local v49 = cameraUtilsSanitizeAngle(0 - pitchSpring.pos)
		local absoluteValue = math.abs(v49)

		if v47 >= absoluteValue then
			pitchSpring.goal = pitchSpring.pos
		else
			pitchSpring.goal = 0
		end
	else
		yawSpring.freq = 0
		yawSpring.vel = 0
		pitchSpring.freq = 0
		pitchSpring.vel = 0
		pitchSpring.goal = 0
	end

	local cFrameFromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ

	v46 = pitchSpring:step(p9)

	local v52 = yawSpring:step(p9)

	return cFrameFromEulerAnglesYXZ(v46, v52, 0)
end
function object._GetThirdPersonLocalOffset(p11)
	local assemblyOffset = p11.assemblyOffset
	local vector3 = Vector3.new(0, p11.assemblyRadius * v10.verticalCenterOffset, 0)

	return assemblyOffset + vector3
end
function object._GetFirstPersonLocalOffset(p12, p13)
	local Character: Model = LocalPlayer.Character
	local v59 = Character and Character.Parent and Character:FindFirstChild("Head")

	if v59 and v59:IsA("BasePart") then
		return p13:Inverse() * v59.Position
	end

	return p12:_GetThirdPersonLocalOffset()
end
function object.Update(p14)
	if u3 then
		local v61: number = n1

		n1 = 0
		p14:UpdateFadeFromBlack(v61)
		p14:UpdateEdgeBlur(LocalPlayer, v61)

		if vrService.ThirdPersonFollowCamEnabled then
			local v62, v63 = p14:UpdateStepRotation(v61)

			return v62, v63
		end

		local v64, v65 = p14:UpdateComfortCamera(v61)

		return v64, v65
	end

	return p14:UpdateComfortCamera()
end
function object.addDrift(p15, p16, p17)
	local function NormalizeAngle(p18)
		local n1 = (p18 + 12.566370614359172) % 6.283185307179586

		if n1 > 3.141592653589793 then
			n1 -= 6.283185307179586
		end

		return n1
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local v71 = p15:GetCameraToSubjectDistance()
	local v72 = p15:GetSubjectVelocity()
	local v73 = p15:GetSubjectCFrame()
	local playerScripts: Instance = LocalPlayer:WaitForChild("PlayerScripts")

	require(playerScripts.PlayerModule:WaitForChild("ControlModule"))

	if v72.Magnitude > 0.1 then
		local v75: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
		local n1 = CurrentCamera.CFrame * (v75.Rotation + v75.Position * CurrentCamera.HeadScale)
		local v77, v78, v79 = n1:ToEulerAnglesYXZ()
		local v80, v81, v82 = v73:ToEulerAnglesYXZ()
		local n2 = (v78 - p15.currentDriftAngle + 12.566370614359172) % 6.283185307179586

		if n2 > 3.141592653589793 then
			n2 -= 6.283185307179586
		end

		local n3 = (v81 - p15.currentDriftAngle + 12.566370614359172) % 6.283185307179586

		if n3 > 3.141592653589793 then
			n3 -= 6.283185307179586
		end

		local v85 = math.min(n3, n2)
		local v86 = math.max(n3, n2)

		n2 = 0

		if v85 > 0 then
			n2 = v85
		elseif v86 < 0 then
			n2 = v86
		end

		p15.currentDriftAngle = n2 + p15.currentDriftAngle

		local lookVector = CFrame.fromEulerAnglesYXZ(0, p15.currentDriftAngle, 0).LookVector
		local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

		vector3 = CFrame.new(CurrentCamera.CFrame.Position + (p17.Position - vector3.Unit * v71) - n1.Position)
		p16 = p16:Lerp(vector3 * CurrentCamera.CFrame.Rotation, 0.01)
	end

	return p16, p17
end
function object.UpdateRotationCamera(p19, p20)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject
	local vehicleCameraCore = p19.vehicleCameraCore

	assert(CurrentCamera)
	assert(currentCameraCameraSubject)
	assert(currentCameraCameraSubject:IsA("VehicleSeat"))

	local v94 = p19:GetSubjectCFrame()
	local v95 = p19:GetSubjectVelocity()
	local v96 = p19:GetSubjectRotVelocity()
	local v97 = v95:Dot(v94.ZVector)
	local absoluteValue = math.abs(v97)
	local v99 = v94.YVector:Dot(v96)
	local absoluteValue2 = math.abs(v99)
	local v101 = v94.XVector:Dot(v96)
	local absoluteValue3 = math.abs(v101)

	v96 = p19:GetCameraToSubjectDistance()
	v101 = cameraUtilsMapClamp(v96, 0.5, p19.assemblyRadius, 1, 0)

	local v103 = p19:_GetThirdPersonLocalOffset()
	local v104 = p19:_GetFirstPersonLocalOffset(v94)
	local v105 = v103:Lerp(v104, v101)

	vehicleCameraCore:setTransform(v94)

	local v106 = vehicleCameraCore:step(p20, absoluteValue3, absoluteValue2, v101)
	local v107 = p19:_StepRotation(p20, absoluteValue)

	v101 = p19:GetVRFocus(v94 * v105, p20) * v106 * v107

	local cFrame = CFrame.new(0, 0, v96)

	if v95.Magnitude > 0.1 then
		p19:StartVREdgeBlur(LocalPlayer)
	end

	return v101 * cFrame, v101
end
function object.UpdateStepRotation(p21, p22)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local lastSubjectCFrame = p21.lastSubjectCFrame
	local v113 = p21:GetSubjectCFrame()
	local v114 = p21:GetSubjectVelocity()
	local v115 = p21:GetCameraToSubjectDistance()
	local v116 = cameraUtilsMapClamp(v115, 0.5, p21.assemblyRadius, 1, 0)
	local v117 = p21:_GetThirdPersonLocalOffset()
	local v118 = p21:_GetFirstPersonLocalOffset(v113)
	local v119 = v117:Lerp(v118, v116)
	local v120 = p21:GetVRFocus(v113 * v119, p22)
	local v121 = p21:GetVRFocus(lastSubjectCFrame * v119, p22)
	local v122 = v120:ToWorldSpace(v121:ToObjectSpace(CurrentCamera.CFrame))
	local v123, v124 = p21:addDrift(v122, v120)
	local v125 = v123

	v120 = v124
	v119 = p21:getRotation(p22)

	if math.abs(v119) > 0 then
		local v126 = v120:ToObjectSpace(v125)
		local v127 = CFrame.Angles(0, -v119, 0)
		local n1 = v120 * v127 * v126

		if not service.VRSmoothRotationEnabled then
			local v129 = vrService:GetUserCFrame(Enum.UserCFrame.Head)

			v129 = v129.Rotation + v129.Position * CurrentCamera.HeadScale

			local n2 = v120 * v113.Rotation
			local v131 = n2:ToObjectSpace(v125 * v129)
			local v132 = Vector3.new(v131.X, 0, v131.Z).Unit:Dot(Vector3.new(0, 0, 1))

			v131 = math.acos(v132)

			local v133 = n2:ToObjectSpace(n1 * v129)

			if v131 > math.acos((Vector3.new(v133.X, 0, v133.Z).Unit:Dot(Vector3.new(0, 0, 1)))) then
				if v119 < 0 then
					v131 *= -1
				end

				local v134 = CFrame.Angles(0, -v131, 0)

				n1 = v120 * v134 * v126
			end
		end

		v125 = n1
	end

	if v114.Magnitude > 0.1 then
		p21:StartVREdgeBlur(LocalPlayer)
	end

	if p21.needsReset then
		p21.needsReset = false
		vrService:RecenterUserHeadCFrame()
		p21:StartFadeFromBlack()
		p21:ResetZoom()
	end

	if p21.recentered then
		local n3 = v120 * v113.Rotation
		local cFrame = CFrame.new(0, 0, v115)

		v125 = n3 * cFrame
		p21.recentered = false
	end

	local cFrame = CFrame.new(0, 0, -v115)

	return v125, v125 * cFrame
end
function object.UpdateComfortCamera(p23, p24: number)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject
	local vehicleCameraCore = p23.vehicleCameraCore

	assert(CurrentCamera)
	assert(currentCameraCameraSubject)
	assert(currentCameraCameraSubject:IsA("VehicleSeat"))

	if not u3 then
		p24 = n1
		n1 = 0
	end

	local v143 = p23:GetSubjectCFrame()
	local v144 = p23:GetSubjectVelocity()
	local v145 = p23:GetSubjectRotVelocity()
	local v146 = v144:Dot(v143.ZVector)

	math.abs(v146)
	v146 = v143.YVector:Dot(v145)

	local absoluteValue = math.abs(v146)
	local v148 = v143.XVector:Dot(v145)
	local absoluteValue4 = math.abs(v148)

	v145 = p23:StepZoom()
	v148 = cameraUtilsMapClamp(v145, 0.5, p23.assemblyRadius, 1, 0)

	local v150 = p23:_GetThirdPersonLocalOffset()
	local v151 = p23:_GetFirstPersonLocalOffset(v143)
	local v152 = v150:Lerp(v151, v148)

	vehicleCameraCore:setTransform(v143)
	v151 = vehicleCameraCore:step(p24, absoluteValue4, absoluteValue, v148)

	if not u3 then
		p23:UpdateFadeFromBlack(p24)
	end

	local n2
	local cFrame2

	if not p23:IsInFirstPerson() then
		n2 = CFrame.new(v143 * v152) * v151

		local cFrame = CFrame.new(0, 0, v145)

		cFrame2 = n2 * cFrame

		if not p23.lastCameraFocus then
			p23.lastCameraFocus = n2
			p23.needsReset = true
		end

		local n3 = n2.Position - CurrentCamera.CFrame.Position

		if n3.Unit:Dot(CurrentCamera.CFrame.LookVector) > 0.56 and n3.magnitude < 200 and not p23.needsReset then
			n2 = p23.lastCameraFocus

			local p = n2.p
			local v159 = p23:GetCameraLookVector()
			local vector3 = Vector3.new(v159.X, 0, v159.Z)

			vector3 = p23:CalculateNewLookVectorFromArg(vector3.Unit, Vector2.new(0, 0))
			cFrame2 = CFrame.new(p - v145 * vector3, p)
		else
			p23.lastCameraFocus = p23:GetVRFocus(v143.Position, p24)
			p23.needsReset = false
			p23:StartFadeFromBlack()
			p23:ResetZoom()
		end

		if not u3 then
			p23:UpdateEdgeBlur(LocalPlayer, p24)

			return cFrame2, n2
		end
	else
		local vector3 = Vector3.new(v151.LookVector.X, 0, v151.LookVector.Z)
		local cFrame = CFrame.new(v151.Position, vector3.Unit)

		n2 = CFrame.new(v143 * v152) * cFrame

		local cFrame3 = CFrame.new(0, 0, v145)

		cFrame2 = n2 * cFrame3

		if not u3 then
			p23:StartVREdgeBlur(LocalPlayer)
		elseif v144.Magnitude > 0.1 then
			p23:StartVREdgeBlur(LocalPlayer)

			return cFrame2, n2
		end
	end

	return cFrame2, n2
end

return object
