-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("../mod/attributes")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../pkg/Shake")
local t1: {[any]: any} = {}
local cFrameIdentity = CFrame.identity

local function updateCamera()
	if #t1 == 0 then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if not runService:IsRunning() then
		local currentCameraCFrame: CFrame = CurrentCamera.CFrame
		local v13 = cFrameIdentity:Inverse()

		CurrentCamera.CFrame = currentCameraCFrame * v13

		local v14: CFrame = CurrentCamera.CFrame
		local v15, v16 = v14:ToOrientation()
		local cFrame = CFrame.new(v14.Position)
		local v18 = CFrame.fromOrientation(v15, v16, 0)

		CurrentCamera.CFrame = cFrame * v18
	end

	local vectorValue = Vector3.new(0, 0, 0)
	local v20 = CFrame.identity
	local t2 = {}

	for key, value in t1 do
		if not value.done then
			vectorValue += value.pos

			local v24 = CFrame.Angles(value.rot.x, value.rot.y, value.rot.z)

			v20 *= v24
			table.insert(t2, value)
		end
	end

	t1 = t2
	t2 = CFrame.new(vectorValue) * v20

	if not runService:IsRunning() then
		cFrameIdentity = t2
	end

	CurrentCamera.CFrame = CurrentCamera.CFrame * t2
end

local connection = nil
local CFrame2 = nil

return {
	init = function()
		if connection then
			return
		end

		if runService:IsRunning() then
			connection = runService.Heartbeat:Connect(function()
				if not CFrame2 then
					return
				end

				workspace.CurrentCamera.CFrame = CFrame2
			end)
		end

		runService:BindToRenderStep("forge_updateCameraShake", Enum.RenderPriority.Last.Value + 1, updateCamera)
	end,
	deinit = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		runService:UnbindFromRenderStep("forge_updateCameraShake")
	end,
	emit = function(p1, p2)
		local v27 = v2.get(p1, "EmitDelay", 0)
		local v28 = v2.get(p1, "EmitDuration", 0)
		local v29 = v2.get(p1, "Falloff", 30)
		local amplitude = v2.get(p1, "Amplitude", 2.5)
		local frequency = v2.get(p1, "Frequency", 0.2)
		local fadeInTime = v2.get(p1, "FadeInTime", 0.3)
		local fadeOutTime = v2.get(p1, "FadeOutTime", 2)
		local sustainTime = v2.get(p1, "SustainTime", 1)
		local positionInfluence = v2.get(p1, "PositionInfluence", Vector3.new(1, 1, 1))
		local rotationInfluence = v2.get(p1, "RotationInfluence", Vector3.new(0.2, 0.2, 0.2))
		local v37 = v2.get(p1, "Speed_Start", 1)
		local v38 = v2.get(p1, "Speed_End", 1)
		local sustain: boolean = v28 > 0
		local v40 = v5.new()

		v40.Sustain = sustain
		v40.Amplitude = amplitude
		v40.Frequency = frequency
		v40.FadeInTime = fadeInTime
		v40.FadeOutTime = fadeOutTime
		v40.SustainTime = sustainTime
		v40.PositionInfluence = positionInfluence
		v40.RotationInfluence = rotationInfluence

		local n1 = 1
		local n2 = 0

		function v40.TimeFunction()
			return n2
		end

		if v37 ~= v38 then
			local fromParams = v3.fromParams
			local v44 = v2.get(p1, "Speed_Curve", v4.default_bezier)
			local v45 = v2.get(p1, "Speed_Duration", 0.1)

			local v46 = fromParams(v44, v45, function(p3, p4)
				n1 = v4.lerp(v37, v38, p3)

				return p4
			end)

			table.insert(p2, v46)
		end

		table.insert(p2, runService.RenderStepped:Connect(function(deltaTime: number)
			n2 += deltaTime * n1
		end))

		local t3: {[any]: any} = { done = false, pos = Vector3.new(0, 0, 0), rot = Vector3.new(0, 0, 0) }

		task.wait(v27)
		table.insert(t1, t3)

		local v48 = coroutine.running()
		local v49 = v5.NextRenderName()

		v40:BindToRenderStep(v49, v4.RENDER_PRIORITY + p2.depth, function(p6, p7, p8)
			local CurrentCamera: Camera = workspace.CurrentCamera

			CFrame2 = CurrentCamera.CFrame

			local v57 = p1:FindFirstAncestorOfClass("Attachment") or p1:FindFirstAncestorWhichIsA("BasePart")

			if v57 then
				local v58 = v4.getTransformedOriginExtents(v57)

				v58 = 1 - math.clamp((CurrentCamera.CFrame.Position - (v58 and v58.Position or v57.Position)).Magnitude / v29, 0, 1)
				p6 *= v58
				p7 *= v58
			end

			t3.pos = p6
			t3.rot = p7
			t3.done = p8

			if p8 then
				CFrame2 = nil
				task.spawn(v48)
			end
		end)
		v40:Start()

		if sustain then
			task.wait(v28)
			v40:StopSustain()
		end

		if not t3.done then
			coroutine.yield()
		end
	end
}
