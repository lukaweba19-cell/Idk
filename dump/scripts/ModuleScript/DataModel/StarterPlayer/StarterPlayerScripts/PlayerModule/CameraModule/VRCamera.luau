-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local vrService: VRService = game:GetService("VRService")

UserSettings():GetService("UserGameSettings")
require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))

local vrBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local object = setmetatable({}, vrBaseCamera)

object.__index = object

function object.new()
	local v5 = vrBaseCamera.new()
	local object2 = setmetatable(v5, object)

	object2.lastUpdate = tick()
	object2.focusOffset = CFrame.new()
	object2:Reset()

	local playerScripts: Instance = players.LocalPlayer:WaitForChild("PlayerScripts")

	object2.controlModule = require(playerScripts.PlayerModule:WaitForChild("ControlModule"))
	object2.savedAutoRotate = true

	return object2
end
function object.Reset(p1)
	p1.needsReset = true
	p1.needsBlackout = true
	p1.motionDetTime = 0
	p1.blackOutTimer = 0
	p1.lastCameraResetPosition = nil
	vrBaseCamera.Reset(p1)
end
function object.Update(p2, p3)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v12 = CurrentCamera.CFrame
	local v13 = CurrentCamera.Focus
	local LocalPlayer: Player = players.LocalPlayer

	p2:GetHumanoid()

	local currentCameraCameraSubject: Instance = CurrentCamera.CameraSubject

	if p2.lastUpdate == nil or p3 > 1 then
		p2.lastCameraTransform = nil
	end

	p2:UpdateFadeFromBlack(p3)
	p2:UpdateEdgeBlur(LocalPlayer, p3)

	local lastSubjectPosition = p2.lastSubjectPosition
	local v17 = p2:GetSubjectPosition()

	if p2.needsBlackout then
		p2:StartFadeFromBlack()

		local v18 = math.clamp(p3, 0.0001, 0.1)

		p2.blackOutTimer = p2.blackOutTimer + v18

		if p2.blackOutTimer > 0.1 and game:IsLoaded() then
			p2.needsBlackout = false
			p2.needsReset = true
		end
	end

	if v17 and LocalPlayer and CurrentCamera then
		local v19 = p2:GetVRFocus(v17, p3)

		if not p2:IsInFirstPerson() then
			if vrService.ThirdPersonFollowCamEnabled then
				local v20, v21 = p2:UpdateThirdPersonFollowTransform(p3, v12, v19, lastSubjectPosition, v17)

				v12 = v20
				v13 = v21
			else
				local v22, v23 = p2:UpdateThirdPersonComfortTransform(p3, v12, v19, lastSubjectPosition, v17)

				v12 = v22
				v13 = v23
			end
		elseif vrService.AvatarGestures then
			local v24, v25 = p2:UpdateImmersionCamera(p3, v12, v19, lastSubjectPosition, v17)

			v12 = v24
			v13 = v25
		else
			local v26, v27 = p2:UpdateFirstPersonTransform(p3, v12, v19, lastSubjectPosition, v17)

			v12 = v26
			v13 = v27
		end

		p2.lastCameraTransform = v12
		p2.lastCameraFocus = v13
	end

	p2.lastUpdate = tick()

	return v12, v13
end
function object.GetAvatarFeetWorldYValue(_)
	local cameraSubject: Instance = workspace.CurrentCamera.CameraSubject

	if not cameraSubject then
	elseif cameraSubject:IsA("Humanoid") and cameraSubject.RootPart then
		local cameraSubjectRootPart = cameraSubject.RootPart

		return cameraSubjectRootPart.Position.Y - cameraSubjectRootPart.Size.Y / 2 - cameraSubject.HipHeight
	end

	return nil
end
function object.UpdateFirstPersonTransform(p5, p6, _, p8, p9, p10)
	if p5.needsReset then
		p5:StartFadeFromBlack()
		p5.needsReset = false
	end

	if (p9 - p10).magnitude > 0.01 then
		p5:StartVREdgeBlur(players.LocalPlayer)
	end

	local p = p8.p
	local v38 = p5:GetCameraLookVector()

	v38 = Vector3.new(v38.X, 0, v38.Z).Unit

	local v39 = p5:getRotation(p6)
	local v40 = p5:CalculateNewLookVectorFromArg(v38, Vector2.new(v39, 0))
	local cFrame = CFrame.new(p - 0.5 * v40, p)

	return cFrame, p8
end
function object.UpdateImmersionCamera(p11, p12, _, _, _, p16)
	local v48 = p11:GetSubjectCFrame()
	local CurrentCamera: Camera = workspace.CurrentCamera
	local Character: Model = players.LocalPlayer.Character
	local v51 = p11:GetHumanoid()

	if not v51 then
		return CurrentCamera.CFrame, CurrentCamera.Focus
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return CurrentCamera.CFrame, CurrentCamera.Focus
	end

	p11.characterOrientation = humanoidRootPart:FindFirstChild("CharacterAlignOrientation")

	if not p11.characterOrientation then
		local rootAttachment: Instance = humanoidRootPart:FindFirstChild("RootAttachment")

		if not rootAttachment then
			return
		end

		p11.characterOrientation = Instance.new("AlignOrientation")
		p11.characterOrientation.Name = "CharacterAlignOrientation"
		p11.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
		p11.characterOrientation.Attachment0 = rootAttachment
		p11.characterOrientation.RigidityEnabled = true
		p11.characterOrientation.Parent = humanoidRootPart
	end

	if p11.characterOrientation.Enabled == false then
		p11.characterOrientation.Enabled = true
	end

	local v54

	if p11.needsReset then
		p11.needsReset = false
		p11.savedAutoRotate = v51.AutoRotate
		v51.AutoRotate = false

		if p11.NoRecenter then
			p11.NoRecenter = false
			vrService:RecenterUserHeadCFrame()
		end

		p11:StartFadeFromBlack()
		v54 = v48
	elseif v51.Sit then
		v54 = v48

		if (v54.Position - CurrentCamera.CFrame.Position).Magnitude > 0.01 then
			p11:StartVREdgeBlur(players.LocalPlayer)
		end
	else
		local v55 = p11.controlModule:GetEstimatedVRTorsoFrame()

		p11.characterOrientation.CFrame = CurrentCamera.CFrame * v55

		if p11.controlModule.inputMoveVector.Magnitude > 0 then
			p11.motionDetTime = 0.1
		end

		if p11.controlModule.inputMoveVector.Magnitude > 0 or p11.motionDetTime > 0 then
			p11.motionDetTime = p11.motionDetTime - p12
			p11:StartVREdgeBlur(players.LocalPlayer)

			local v56: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
			local HumanoidRootPart = Character.HumanoidRootPart
			local n1 = CurrentCamera.CFrame * (v56.Rotation + v56.Position * CurrentCamera.HeadScale)
			local cFrame = CFrame.new(0, -0.7 * HumanoidRootPart.Size.Y / 2, 0)
			local lookVector = HumanoidRootPart.CFrame.LookVector
			local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
			local n2 = p16 - (n1 * cFrame - vector3.Unit * HumanoidRootPart.Size.Y * 0.125).Position + CurrentCamera.CFrame.Position
			local vector32 = Vector3.new(n2.X, p16.Y, n2.Z)

			v54 = CurrentCamera.CFrame.Rotation + vector32
		else
			local rotation = CurrentCamera.CFrame.Rotation
			local vector3 = Vector3.new(CurrentCamera.CFrame.Position.X, p16.Y, CurrentCamera.CFrame.Position.Z)

			v54 = rotation + vector3
		end

		local v66 = p11:getRotation(p12)

		if math.abs(v66) > 0 then
			local v67 = vrService:GetUserCFrame(Enum.UserCFrame.Head)

			v67 = v67.Rotation + v67.Position * CurrentCamera.HeadScale

			local n3 = v54 * v67
			local cFrame = CFrame.new(n3.Position)
			local cFrameAngles = CFrame.Angles
			local v71 = math.rad(v66 * 90)
			local v72 = cFrameAngles(0, -v71, 0)
			local n4 = cFrame * v72 * n3.Rotation
			local v74 = v67:Inverse()

			v54 = n4 * v74
		end
	end

	return v54, v54 * CFrame.new(0, 0, -0.5)
end
function object.UpdateThirdPersonComfortTransform(p17, p18, p19, p20, p21, p22)
	local v81 = p17:GetCameraToSubjectDistance()

	if v81 < 0.5 then
		v81 = 0.5
	end

	if p21 == nil or p17.lastCameraFocus == nil then
		return p19, p20
	end

	local LocalPlayer: Player = players.LocalPlayer
	local v83 = p17.controlModule:GetMoveVector()
	local u84: boolean = true

	if not ((p21 - p22).magnitude > 0.01) then
		u84 = v83.magnitude > 0.01
	end

	if u84 then
		p17.motionDetTime = 0.1
	end

	p17.motionDetTime = p17.motionDetTime - p18

	if p17.motionDetTime > 0 then
		u84 = true
	end

	if u84 and not p17.needsReset then
		local lastCameraFocus = p17.lastCameraFocus

		p17.VRCameraFocusFrozen = true

		return p19, lastCameraFocus
	end

	v83 = true

	if p17.lastCameraResetPosition ~= nil then
		v83 = (p22 - p17.lastCameraResetPosition).Magnitude > 1
	end

	local v86 = p17:getRotation(p18)

	if math.abs(v86) > 0 then
		local v87 = p20:ToObjectSpace(p19)
		local v88 = CFrame.Angles(0, -v86, 0)

		p19 = p20 * v88 * v87
	end

	if p17.VRCameraFocusFrozen and v83 or p17.needsReset then
		vrService:RecenterUserHeadCFrame()
		p17.VRCameraFocusFrozen = false
		p17.needsReset = false
		p17.lastCameraResetPosition = p22
		p17:ResetZoom()
		p17:StartFadeFromBlack()

		local v89 = p17:GetHumanoid()
		local v90 = v89.Torso and v89.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
		local vector3 = Vector3.new(v90.X, 0, v90.Z)

		v90 = p20.Position - vector3 * v81

		local vector33 = Vector3.new(p20.Position.X, v90.Y, p20.Position.Z)

		p19 = CFrame.new(v90, vector33)
	end

	return p19, p20
end
function object.UpdateThirdPersonFollowTransform(p23, p24, _, _, p27, p28)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v100 = p23:GetCameraToSubjectDistance()
	local v101 = p23:GetVRFocus(p28, p24)

	if p23.needsReset then
		p23.needsReset = false
		vrService:RecenterUserHeadCFrame()
		p23:ResetZoom()
		p23:StartFadeFromBlack()
	end

	if p23.recentered then
		local v102 = p23:GetSubjectCFrame()

		if not v102 then
			return CurrentCamera.CFrame, CurrentCamera.Focus
		end

		local n1 = v101 * v102.Rotation
		local cFrame = CFrame.new(0, 0, v100)
		local n2 = n1 * cFrame

		p23.focusOffset = v101:ToObjectSpace(n2)
		p23.recentered = false

		return n2, v101
	end

	local v106 = v101:ToWorldSpace(p23.focusOffset)
	local LocalPlayer: Player = players.LocalPlayer
	local controlModule = p23.controlModule
	local v109 = controlModule:GetMoveVector()
	local v111

	if (p27 - p28).magnitude > 0.01 or v109.magnitude > 0 then
		local v112 = controlModule:GetEstimatedVRTorsoFrame()
		local n3 = CurrentCamera.CFrame * (v112.Rotation + v112.Position * CurrentCamera.HeadScale)
		local lookVector = n3.LookVector
		local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

		vector3 = CFrame.new(CurrentCamera.CFrame.Position + (v101.Position - vector3.Unit * v100) - n3.Position)
		v111 = v106:Lerp(vector3 * v106.Rotation, 0.01)
	else
		v111 = v106
	end

	v109 = p23:getRotation(p24)

	if math.abs(v109) > 0 then
		local v115 = v101:ToObjectSpace(v111)
		local v116 = CFrame.Angles(0, -v109, 0)

		v111 = v101 * v116 * v115
	end

	p23.focusOffset = v101:ToObjectSpace(v111)

	local cFrame = CFrame.new(0, 0, -v100)
	local n4 = v111 * cFrame

	if (n4.Position - CurrentCamera.Focus.Position).Magnitude > 0.01 then
		p23:StartVREdgeBlur(players.LocalPlayer)
	end

	return v111, n4
end
function object.LeaveFirstPerson(p29)
	vrBaseCamera.LeaveFirstPerson(p29)
	p29.needsReset = true

	if p29.VRBlur then
		p29.VRBlur.Visible = false
	end

	if p29.characterOrientation then
		p29.characterOrientation.Enabled = false
	end

	local v120 = p29:GetHumanoid()

	if v120 then
		v120.AutoRotate = p29.savedAutoRotate
	end
end

return object
