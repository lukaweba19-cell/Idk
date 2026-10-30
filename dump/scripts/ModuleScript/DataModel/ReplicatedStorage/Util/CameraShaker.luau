-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local debugProfilebegin = debug.profilebegin
local debugProfileend = debug.profileend
local cFrameNew = CFrame.new
local cFrameAngles = CFrame.Angles
local mathRad = math.rad
local vector3 = Vector3.new()
local cameraShakeInstance = require(script.CameraShakeInstance)
local cameraShakeInstanceCameraShakeState = cameraShakeInstance.CameraShakeState

module.CameraShakeInstance = cameraShakeInstance
module.Presets = require(script.CameraShakePresets)

function module.new(p1, p2)
	local typeName: string = type(p1)

	assert(typeName == "number", "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")

	local typeName2: string = type(p2)

	assert(typeName2 == "function", "Callback must be a function")

	return (setmetatable({
		_running = false,
		_renderName = "CameraShaker",
		_renderPriority = p1,
		_posAddShake = vector3,
		_rotAddShake = vector3,
		_camShakeInstances = {},
		_removeInstances = {},
		_callback = p2
	}, module))
end
function module.Start(p3)
	if p3._running then
		return
	end

	p3._running = true

	local _callback = p3._callback

	game:GetService("RunService"):BindToRenderStep(p3._renderName, p3._renderPriority, function(_)
		local v71 = p3._lastValue or CFrame.new()

		_callback(v71)
	end)
	p3._task = task.spawn(function()
		while p3._running do
			local v72 = task.wait(0.016666666666666666)

			debugProfilebegin("CameraShakerUpdate")

			local ok, result = pcall(function()
				p3._lastValue = p3:Update(v72)
			end)

			if not ok then
				warn("[CAMERA SHAKER]", result)
			end

			debugProfileend()
		end
	end)
end
function module.Stop(p5)
	if not p5._running then
		return
	end

	game:GetService("RunService"):UnbindFromRenderStep(p5._renderName)
	p5._running = false
	pcall(task.cancel, p5._task)
end
function module.StopSustained(p6, p7)
	for _, v in pairs(p6._camShakeInstances) do
		if v.fadeOutDuration == 0 then
			local v22 = math.max(p7 or v.fadeInDuration or 0, 0.008333333333333333)

			v:StartFadeOut(v22)
		end
	end
end

local CurrentCamera: Camera = workspace.CurrentCamera

function module.Update(p8, p9)
	local v25 = vector3
	local v26 = vector3
	local _camShakeInstances = p8._camShakeInstances
	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize
	local v29 = math.clamp(currentCameraViewportSize.Magnitude / 1000, 0.33, 1)
	local v30 = math.clamp(2 - currentCameraViewportSize.X / currentCameraViewportSize.Y / 1.9, 0.5, 1)

	for i = 1, #_camShakeInstances do
		local v32 = _camShakeInstances[i]
		local v33 = v32:GetState()

		if v33 == cameraShakeInstanceCameraShakeState.Inactive and v32.DeleteOnInactive then
			p8._removeInstances[#p8._removeInstances + 1] = i
		elseif v33 ~= cameraShakeInstanceCameraShakeState.Inactive then
			local v34 = v32:UpdateShake(p9)

			v25 += v34 * v32.PositionInfluence * v29
			v34 = v32:UpdateShake(p9)
			v26 += v34 * v32.RotationInfluence * v30
		end
	end

	for i = #p8._removeInstances, 1, -1 do
		table.remove(_camShakeInstances, p8._removeInstances[i])
		p8._removeInstances[i] = nil
	end

	local v36 = cFrameNew(v25)
	local v37 = mathRad(v26.Y)
	local v38 = cFrameAngles(0, v37, 0)
	local v39 = mathRad(v26.X)

	v37 = mathRad(v26.Z)

	local v40 = cFrameAngles(v39, 0, v37)

	return v36 * v38 * v40
end
function module.Shake(p10, p11, p12)
	if typeof(p11) == "string" then
		p11 = module.Presets[p11]
	end

	local v44 = p12 or 1
	local u45 = false

	if type(p11) == "table" then
		u45 = p11._camShakeInstance
	end

	assert(u45, "ShakeInstance must be of type CameraShakeInstance")
	p11.Magnitude = p11.Magnitude * v44
	p11.Roughness = p11.Roughness * v44
	p11.fadeOutDuration = p11.fadeOutDuration * v44
	p11.fadeInDuration = p11.fadeInDuration * v44
	p10._camShakeInstances[#p10._camShakeInstances + 1] = p11

	return p11
end
function module.ShakeSustain(p13, p14, p15)
	local v49 = p15 or 1
	local u50 = false

	if type(p14) == "table" then
		u50 = p14._camShakeInstance
	end

	assert(u50, "ShakeInstance must be of type CameraShakeInstance")
	p14.Magnitude = p14.Magnitude * v49
	p14.Roughness = p14.Roughness * v49
	p14.fadeOutDuration = p14.fadeOutDuration * v49
	p14.fadeInDuration = p14.fadeInDuration * v49
	p13._camShakeInstances[#p13._camShakeInstances + 1] = p14
	p14:StartFadeIn(p14.fadeInDuration)

	return p14
end
function module.ShakeOnce(p16, p17, p18, p19, p20, p21, p22, p23)
	local v59 = p23 or 1
	local v60 = cameraShakeInstance.new(p17 * v59, p18 * v59, p19 * v59, p20 * v59)

	v60.PositionInfluence = typeof(p21) == "Vector3" and p21 or Vector3.new(0.15, 0.15, 0.15)
	v60.RotationInfluence = typeof(p22) == "Vector3" and p22 or Vector3.new(1, 1, 1)
	p16._camShakeInstances[#p16._camShakeInstances + 1] = v60

	return v60
end
function module.StartShake(p24, p25, p26, p27, p28, p29, p30)
	local v68 = p30 or 1
	local v69 = cameraShakeInstance.new(p25 * v68, p26 * v68, p27 * v68)

	v69.PositionInfluence = typeof(p28) == "Vector3" and p28 or Vector3.new(0.15, 0.15, 0.15)
	v69.RotationInfluence = typeof(p29) == "Vector3" and p29 or Vector3.new(1, 1, 1)
	v69:StartFadeIn(p27)
	p24._camShakeInstances[#p24._camShakeInstances + 1] = v69

	return v69
end

return module
