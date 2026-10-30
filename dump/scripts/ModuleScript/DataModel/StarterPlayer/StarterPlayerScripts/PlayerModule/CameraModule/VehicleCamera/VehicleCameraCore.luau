-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local cameraUtils = require(script.Parent.Parent.CameraUtils)
local vehicleCameraConfig = require(script.Parent.VehicleCameraConfig)
local cameraUtilsMap = cameraUtils.map
local cameraUtilsMapClamp = cameraUtils.mapClamp
local cameraUtilsSanitizeAngle = cameraUtils.sanitizeAngle

local function getYaw(p1)
	local v13, v14 = p1:toEulerAnglesYXZ()

	return cameraUtilsSanitizeAngle(v14)
end
local function getPitch(p2)
	local v16 = p2:toEulerAnglesYXZ()

	return cameraUtilsSanitizeAngle(v16)
end
local function stepSpringAxis(p3, p4, p5, p6, p7)
	local v22 = cameraUtilsSanitizeAngle(p6 - p5)
	local v23 = math.exp(-p4 * p3)

	return cameraUtilsSanitizeAngle((v22 * (1 + p4 * p3) + p7 * p3) * v23 + p5), (p7 * (1 - p4 * p3) - v22 * (p4 * p4 * p3)) * v23
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p8, p9, p10)
	return (setmetatable({ fRising = p8, fFalling = p9, g = p10, p = p10, v = p10 * 0 }, t1))
end
function t1.step(p11, p12)
	local g = p11.g
	local v = p11.v
	local n1 = 6.283185307179586 * (v > 0 and p11.fRising or p11.fFalling)
	local n2 = p11.p - g
	local v33 = math.exp(-n1 * p12)
	local n3 = (n2 * (1 + n1 * p12) + v * p12) * v33 + g

	p11.p = n3
	p11.v = (v * (1 - n1 * p12) - n2 * (n1 * n1 * p12)) * v33

	return n3
end

local t2: {[any]: any} = {}

t2.__index = t2

function t2.new(p13)
	local typeName: string = typeof(p13)

	assert(typeName == "CFrame")

	local v37, v38 = p13:toEulerAnglesYXZ()
	local v39 = cameraUtilsSanitizeAngle(v38)
	local v40, v41 = p13:toEulerAnglesYXZ()
	local v42 = cameraUtilsSanitizeAngle(v41)
	local v43 = p13:toEulerAnglesYXZ()
	local v44 = cameraUtilsSanitizeAngle(v43)

	v43 = p13:toEulerAnglesYXZ()

	local v45 = cameraUtilsSanitizeAngle(v43)
	local v46 = t1.new(vehicleCameraConfig.yawReponseDampingRising, vehicleCameraConfig.yawResponseDampingFalling, 0)
	local v47 = t1.new(vehicleCameraConfig.pitchReponseDampingRising, vehicleCameraConfig.pitchResponseDampingFalling, 0)

	return (setmetatable({
		yawV = 0,
		pitchV = 0,
		yawG = v39,
		yawP = v42,
		pitchG = v44,
		pitchP = v45,
		fSpringYaw = v46,
		fSpringPitch = v47
	}, t2))
end
function t2.setGoal(p14, p15)
	local typeName: string = typeof(p15)

	assert(typeName == "CFrame")

	local v51, v52 = p15:toEulerAnglesYXZ()

	p14.yawG = cameraUtilsSanitizeAngle(v52)

	local v53 = p15:toEulerAnglesYXZ()

	p14.pitchG = cameraUtilsSanitizeAngle(v53)
end
function t2.getCFrame(p16)
	return CFrame.fromEulerAnglesYXZ(p16.pitchP, p16.yawP, 0)
end
function t2.step(p17, p18, p19, p20, p21)
	local typeName: string = typeof(p18)

	assert(typeName == "number")

	local typeName2: string = typeof(p20)

	assert(typeName2 == "number")

	local typeName3: string = typeof(p19)

	assert(typeName3 == "number")

	local typeName4: string = typeof(p21)

	assert(typeName4 == "number")

	local fSpringYaw = p17.fSpringYaw
	local fSpringPitch = p17.fSpringPitch
	local v66 = cameraUtilsMap(p21, 0, 1, p20, 0)
	local v67 = math.rad(vehicleCameraConfig.cutoffMinAngularVelYaw)
	local v68 = math.rad(vehicleCameraConfig.cutoffMaxAngularVelYaw)

	fSpringYaw.g = cameraUtilsMapClamp(v66, v67, v68, 1, 0)
	v66 = cameraUtilsMap(p21, 0, 1, p19, 0)
	v67 = math.rad(vehicleCameraConfig.cutoffMinAngularVelPitch)
	v68 = math.rad(vehicleCameraConfig.cutoffMaxAngularVelPitch)
	fSpringPitch.g = cameraUtilsMapClamp(v66, v67, v68, 1, 0)
	v66 = 6.283185307179586 * vehicleCameraConfig.yawStiffness
	v67 = fSpringYaw:step(p18)

	local n1 = 6.283185307179586 * vehicleCameraConfig.pitchStiffness
	local v70 = fSpringPitch:step(p18)
	local v71 = cameraUtilsMap(p21, 0, 1, 1, vehicleCameraConfig.firstPersonResponseMul)
	local n2 = n1 * v70 * v71

	v71 = cameraUtilsMap(p21, 0, 1, 1, vehicleCameraConfig.firstPersonResponseMul)

	local n3 = v66 * v67 * v71
	local yawG = p17.yawG
	local yawV = p17.yawV
	local v76 = cameraUtilsSanitizeAngle(p17.yawP - yawG)
	local v77 = math.exp(-n3 * p18)

	p17.yawP = cameraUtilsSanitizeAngle((v76 * (1 + n3 * p18) + yawV * p18) * v77 + yawG)
	p17.yawV = (yawV * (1 - n3 * p18) - v76 * (n3 * n3 * p18)) * v77

	local pitchG = p17.pitchG
	local pitchV = p17.pitchV

	n3 = cameraUtilsSanitizeAngle(p17.pitchP - pitchG)
	v77 = math.exp(-n2 * p18)
	p17.pitchP = cameraUtilsSanitizeAngle((n3 * (1 + n2 * p18) + pitchV * p18) * v77 + pitchG)
	p17.pitchV = (pitchV * (1 - n2 * p18) - n3 * (n2 * n2 * p18)) * v77

	return p17:getCFrame()
end

local module: {[any]: any} = {}

module.__index = module

function module.new(p22)
	local v81 = t2.new(p22)

	return (setmetatable({ vrs = v81 }, module))
end
function module.step(p23, p24, p25, p26, p27)
	return p23.vrs:step(p24, p25, p26, p27)
end
function module.setTransform(p28, p29)
	p28.vrs:setGoal(p29)
end

return module
