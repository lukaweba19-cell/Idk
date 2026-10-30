-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(script.Parent:WaitForChild("CameraUtils"))

local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local players: Players = game:GetService("Players")
local baseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local object = setmetatable({}, baseCamera)

object.__index = object

function object.new()
	local v5 = baseCamera.new()
	local object2 = setmetatable(v5, object)

	object2.cameraType = Enum.CameraType.Fixed
	object2.lastUpdate = tick()
	object2.lastDistanceToSubject = nil

	return object2
end
function object.GetModuleName(_)
	return "LegacyCamera"
end
function object.SetCameraToSubjectDistance(p2, p3)
	return baseCamera.SetCameraToSubjectDistance(p2, p3)
end
function object.Update(p4, p5)
	if not p4.cameraType then
		return nil, nil
	end

	local timestamp = tick()
	local n1 = timestamp - p4.lastUpdate
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v15 = CurrentCamera.CFrame
	local v16 = CurrentCamera.Focus
	local LocalPlayer: Player = players.LocalPlayer
	local v18 = cameraInput.getRotation(p5)

	if p4.lastUpdate == nil or n1 > 1 then
		p4.lastDistanceToSubject = nil
	end

	n1 = p4:GetSubjectPosition()

	if p4.cameraType ~= Enum.CameraType.Fixed then
		if p4.cameraType == Enum.CameraType.Attach then
			local v19 = p4:GetSubjectCFrame()
			local v20 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
			local v21, v22 = v19:ToEulerAnglesYXZ()
			local v23 = math.clamp(v20 - v18.Y, -1.3962634015954636, 1.3962634015954636)
			local cFrame = CFrame.new(v19.p)
			local v25 = CFrame.fromEulerAnglesYXZ(v23, v22, 0)

			v16 = cFrame * v25

			local cFrame2 = CFrame.new(0, 0, p4:StepZoom())

			v15 = v16 * cFrame2
		else
			if p4.cameraType ~= Enum.CameraType.Watch then
				return CurrentCamera.CFrame, CurrentCamera.Focus
			end

			if n1 and LocalPlayer and CurrentCamera then
				local v27 = nil

				if n1 == CurrentCamera.CFrame.p then
					warn("Camera cannot watch subject in same position as itself")

					return CurrentCamera.CFrame, CurrentCamera.Focus
				end

				local v28 = p4:GetHumanoid()

				if v28 and v28.RootPart then
					local n2 = n1 - CurrentCamera.CFrame.p

					v27 = n2.unit

					if p4.lastDistanceToSubject and p4.lastDistanceToSubject == p4:GetCameraToSubjectDistance() then
						p4:SetCameraToSubjectDistance(n2.magnitude)
					end
				end

				v28 = p4:GetCameraToSubjectDistance()

				local v30 = p4:CalculateNewLookVectorFromArg(v27, v18)

				v16 = CFrame.new(n1)
				v15 = CFrame.new(n1 - v28 * v30, n1)
				p4.lastDistanceToSubject = v28
			end
		end
	elseif n1 and LocalPlayer and CurrentCamera then
		local v31 = p4:GetCameraToSubjectDistance()
		local v32 = p4:CalculateNewLookVectorFromArg(nil, v18)

		v16 = CurrentCamera.Focus
		v15 = CFrame.new(CurrentCamera.CFrame.p, CurrentCamera.CFrame.p + v31 * v32)
	end

	p4.lastUpdate = timestamp

	return v15, v16
end

return object
