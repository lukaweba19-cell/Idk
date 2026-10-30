-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local n1 = 0
local v2 = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v4 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserFixCameraFPError")
local players: Players = game:GetService("Players")
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local baseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local object = setmetatable({}, baseCamera)

object.__index = object

function object.new()
	local v10 = baseCamera.new()
	local object2 = setmetatable(v10, object)

	object2.isFollowCamera = false
	object2.isCameraToggle = false
	object2.lastUpdate = tick()
	object2.cameraToggleSpring = cameraUtils.Spring.new(5, 0)

	return object2
end
function object.GetCameraToggleOffset(p1, p2)
	if p1.isCameraToggle then
		local currentSubjectDistance = p1.currentSubjectDistance

		if cameraInput.getTogglePan() then
			local cameraToggleSpring = p1.cameraToggleSpring
			local v16 = cameraUtils.map(currentSubjectDistance, 0.5, p1.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1)

			cameraToggleSpring.goal = math.clamp(v16, 0, 1)
		else
			p1.cameraToggleSpring.goal = 0
		end

		local v17 = cameraUtils.map(currentSubjectDistance, 0.5, 64, 0, 1)
		local v18 = math.clamp(v17, 0, 1)
		local v19 = p1.cameraToggleSpring:step(p2)
		local vector3 = Vector3.new(0, v19 * (v18 + 1), 0)

		return vector3
	end

	return (Vector3.new())
end
function object.SetCameraMovementMode(p3, p4)
	baseCamera.SetCameraMovementMode(p3, p4)
	p3.isFollowCamera = p4 == Enum.ComputerCameraMovementMode.Follow
	p3.isCameraToggle = p4 == Enum.ComputerCameraMovementMode.CameraToggle
end
function object.Update(p5, p6)
	local timestamp = tick()
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v27 = CurrentCamera.CFrame
	local v28 = CurrentCamera.Focus
	local v29 = nil

	if p5.resetCameraAngle then
		local v30 = p5:GetHumanoidRootPart()

		v29 = if v30 then (v30.CFrame * v2).lookVector else v2.lookVector
		p5.resetCameraAngle = false
	end

	local LocalPlayer: Player = players.LocalPlayer
	local v32 = p5:GetHumanoid()
	local currentCameraCameraSubject: Instance = CurrentCamera.CameraSubject
	local v34 = currentCameraCameraSubject and currentCameraCameraSubject:IsA("VehicleSeat")
	local v35 = currentCameraCameraSubject and currentCameraCameraSubject:IsA("SkateboardPlatform")
	local v36 = v32

	if v36 then
		v36 = v32:GetState() == Enum.HumanoidStateType.Climbing
	end

	if p5.lastUpdate == nil or p6 > 1 then
		p5.lastCameraTransform = nil
	end

	local v37 = cameraInput.getRotation(p6)

	p5:StepZoom()

	local v38 = p5:GetCameraHeight()

	if v37 ~= Vector2.new() then
		n1 = 0
		p5.lastUserPanCamera = tick()
	end

	local u39: boolean = timestamp - p5.lastUserPanCamera < 2
	local v40 = p5:GetSubjectPosition()

	if v40 and LocalPlayer and CurrentCamera then
		local v41 = p5:GetCameraToSubjectDistance()

		if v41 < 0.5 then
			v41 = 0.5
		end

		if p5:GetIsMouseLocked() and not p5:IsInFirstPerson() then
			local v42 = p5:CalculateNewLookCFrameFromArg(v29, v37)
			local v43 = p5:GetMouseLockOffset()

			if v32 then
				v43 += v32.CameraOffset
			end

			local n3 = v43.X * v42.RightVector + v43.Y * v42.UpVector + v43.Z * v42.LookVector

			if cameraUtils.IsFiniteVector3(n3) then
				v40 += n3
			end
		elseif v37 == Vector2.new() and p5.lastCameraTransform then
			local v45 = p5:IsInFirstPerson()

			if (not not v34 or not not v35 or not not p5.isFollowCamera and not not v36) and not not p5.lastUpdate and v32 and v32.Torso then
				if not v45 then
					if not u39 then
						local lookVector = v32.Torso.CFrame.lookVector

						n1 = math.clamp(n1 + 3.839724354387525 * p6, 0, 4.363323129985824)

						local v47 = math.clamp(n1 * p6, 0, 1)

						if p5:IsInFirstPerson() and (not p5.isFollowCamera or not p5.isClimbing) then
							v47 = 1
						end

						local v48 = cameraUtils.GetAngleBetweenXZVectors(lookVector, p5:GetCameraLookVector())

						if cameraUtils.IsFinite(v48) and math.abs(v48) > 0.0001 then
							local vector2 = Vector2.new(v48 * v47, 0)

							v37 += vector2
						end
					end
				elseif p5.lastSubjectCFrame and (not not v34 or not not v35) and not not currentCameraCameraSubject:IsA("BasePart") then
					local n2 = -cameraUtils.GetAngleBetweenXZVectors(p5.lastSubjectCFrame.lookVector, currentCameraCameraSubject.CFrame.lookVector)

					if cameraUtils.IsFinite(n2) then
						local vector2 = Vector2.new(n2, 0)

						v37 += vector2
					end

					n1 = 0
				end
			elseif p5.isFollowCamera and not v45 and not u39 then
				local v52 = cameraUtils.GetAngleBetweenXZVectors(-(p5.lastCameraTransform.p - v40), p5:GetCameraLookVector())

				if cameraUtils.IsFinite(v52) and math.abs(v52) > 0.0001 and math.abs(v52) > 0.4 * p6 then
					local vector2 = Vector2.new(v52, 0)

					v37 += vector2
				end
			end
		end

		local cFrame
		local v55

		if not p5.isFollowCamera then
			cFrame = CFrame.new(v40)

			local cFrameP = cFrame.p
			local v57 = p5:CalculateNewLookVectorFromArg(v29, v37)

			v55 = if v4 then CFrame.lookAlong(cFrameP - v41 * v57, v57) else CFrame.new(cFrameP - v41 * v57, cFrameP)
		else
			local v58 = p5:CalculateNewLookVectorFromArg(v29, v37)

			cFrame = CFrame.new(v40)
			v55 = if v4 then CFrame.lookAlong(cFrame.p - v41 * v58, v58) else CFrame.new(cFrame.p - v41 * v58, cFrame.p) + Vector3.new(0, v38, 0)
		end

		v41 = p5:GetCameraToggleOffset(p6)
		v28 = cFrame + v41
		v27 = v55 + v41
		p5.lastCameraTransform = v27
		p5.lastCameraFocus = v28

		if not v34 and not v35 or not currentCameraCameraSubject:IsA("BasePart") then
			p5.lastSubjectCFrame = nil
		else
			p5.lastSubjectCFrame = currentCameraCameraSubject.CFrame
		end
	end

	p5.lastUpdate = timestamp

	return v27, v28
end

return object
