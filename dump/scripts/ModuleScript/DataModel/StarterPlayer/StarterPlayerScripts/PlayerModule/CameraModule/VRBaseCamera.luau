-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)

local u3 = ok and result
local vrService: VRService = game:GetService("VRService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local lighting: Lighting = game:GetService("Lighting")
local runService: RunService = game:GetService("RunService")
local service = UserSettings():GetService("UserGameSettings")
local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local zoomController = require(script.Parent:WaitForChild("ZoomController"))
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")

require(commonUtils:WaitForChild("FlagUtil"))

local baseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local object = setmetatable({}, baseCamera)

object.__index = object

function object.new()
	local v14 = baseCamera.new()
	local object2 = setmetatable(v14, object)

	object2.gamepadZoomLevels = { 0, 7 }
	object2.headScale = 1
	object2:SetCameraToSubjectDistance(7)
	object2.VRFadeResetTimer = 0
	object2.VREdgeBlurTimer = 0
	object2.gamepadResetConnection = nil
	object2.needsReset = true
	object2.recentered = false
	object2:Reset()

	return object2
end
function object.Reset(p1)
	p1.stepRotateTimeout = 0
end
function object.GetModuleName(_)
	return "VRBaseCamera"
end
function object.GamepadZoomPress(p3)
	baseCamera.GamepadZoomPress(p3)
	p3:GamepadReset()
	p3:ResetZoom()
end
function object.GamepadReset(p4)
	p4.stepRotateTimeout = 0
	p4.needsReset = true
end
function object.ResetZoom(p5)
	zoomController.SetZoomParameters(p5.currentSubjectDistance, 0)
	zoomController.ReleaseSpring()
end
function object.OnEnabledChanged(p6)
	baseCamera.OnEnabledChanged(p6)

	if p6.enabled then
		p6.gamepadResetConnection = cameraInput.gamepadReset:Connect(function()
			p6:GamepadReset()
		end)
		p6.thirdPersonOptionChanged = vrService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function()
			if u3 then
				p6:Reset()

				return
			end

			if not p6:IsInFirstPerson() then
				p6:Reset()
			end
		end)
		p6.vrRecentered = vrService.UserCFrameChanged:Connect(function(type: Enum.UserCFrame, _: CFrame)
			if type == Enum.UserCFrame.Floor then
				p6.recentered = true
			end
		end)

		return
	end

	if p6.inFirstPerson then
		p6:GamepadZoomPress()
	end

	if p6.thirdPersonOptionChanged then
		p6.thirdPersonOptionChanged:Disconnect()
		p6.thirdPersonOptionChanged = nil
	end

	if p6.vrRecentered then
		p6.vrRecentered:Disconnect()
		p6.vrRecentered = nil
	end

	if p6.cameraHeadScaleChangedConn then
		p6.cameraHeadScaleChangedConn:Disconnect()
		p6.cameraHeadScaleChangedConn = nil
	end

	if p6.gamepadResetConnection then
		p6.gamepadResetConnection:Disconnect()
		p6.gamepadResetConnection = nil
	end

	p6.VREdgeBlurTimer = 0
	p6:UpdateEdgeBlur(LocalPlayer, 1)

	local vrFade: Instance = lighting:FindFirstChild("VRFade")

	if vrFade then
		vrFade.Brightness = 0
	end
end
function object.OnCurrentCameraChanged(p9)
	baseCamera.OnCurrentCameraChanged(p9)

	if p9.cameraHeadScaleChangedConn then
		p9.cameraHeadScaleChangedConn:Disconnect()
		p9.cameraHeadScaleChangedConn = nil
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		p9.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function()
			p9:OnHeadScaleChanged()
		end)
		p9:OnHeadScaleChanged()
	end
end
function object.OnHeadScaleChanged(p10)
	local headScale: number = workspace.CurrentCamera.HeadScale

	for iterFirst, iterSecond in p10.gamepadZoomLevels, nil, nil do
		p10.gamepadZoomLevels[iterFirst] = iterSecond * headScale / p10.headScale
	end

	local v29 = p10:GetCameraToSubjectDistance()

	p10:SetCameraToSubjectDistance(v29 * headScale / p10.headScale)
	p10.headScale = headScale
end
function object.GetVRFocus(p11, p12, p13)
	local v33 = p11.lastCameraFocus or p12
	local x = p11.cameraTranslationConstraints.x
	local v35 = math.min(1, p11.cameraTranslationConstraints.y + p13)

	p11.cameraTranslationConstraints = Vector3.new(x, v35, p11.cameraTranslationConstraints.z)
	v35 = p11:GetCameraHeight()

	local vector3 = Vector3.new(0, v35, 0)
	local cFrameNew = CFrame.new
	local vector32 = Vector3.new(p12.x, v33.y, p12.z)

	return (cFrameNew(vector32:Lerp(p12 + vector3, p11.cameraTranslationConstraints.y)))
end
function object.StartFadeFromBlack(p14)
	if service.VignetteEnabled == false then
		return
	end

	local vrFade = lighting:FindFirstChild("VRFade")

	if not vrFade then
		vrFade = Instance.new("ColorCorrectionEffect")
		vrFade.Name = "VRFade"
		vrFade.Parent = lighting
	end

	vrFade.Brightness = -1
	p14.VRFadeResetTimer = 0.1
end
function object.UpdateFadeFromBlack(p15, p16)
	local vrFade: Instance = lighting:FindFirstChild("VRFade")

	if p15.VRFadeResetTimer > 0 then
		p15.VRFadeResetTimer = math.max(p15.VRFadeResetTimer - p16, 0)

		local vrFade2: Instance = lighting:FindFirstChild("VRFade")

		if vrFade2 and vrFade2.Brightness < 0 then
			vrFade2.Brightness = math.min(vrFade2.Brightness + p16 * 10, 0)

			return
		end
	elseif vrFade then
		vrFade.Brightness = 0
	end
end
function object.StartVREdgeBlur(p17, p18)
	if service.VignetteEnabled == false then
		return
	end

	local vrBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart")

	if not vrBlurPart then
		vrBlurPart = Instance.new("Part")
		vrBlurPart.Name = "VRBlurPart"
		vrBlurPart.Parent = workspace.CurrentCamera
		vrBlurPart.CanTouch = false
		vrBlurPart.CanCollide = false
		vrBlurPart.CanQuery = false
		vrBlurPart.Anchored = true
		vrBlurPart.Size = Vector3.new(0.44, 0.47, 1)
		vrBlurPart.Transparency = 1
		vrBlurPart.CastShadow = false
		runService.RenderStepped:Connect(function(deltaTime: number)
			local v75: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
			local v76: CFrame = workspace.CurrentCamera.CFrame
			local cFrame = CFrame.new(v75.p * workspace.CurrentCamera.HeadScale)
			local n1 = v76 * (cFrame * (v75 - v75.p))
			local v79 = vrBlurPart
			local v80 = CFrame.Angles(0, 3.141592653589793, 0)

			v79.CFrame = n1 * v80 + n1.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
			vrBlurPart.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale
		end)
	end

	local vrBlurScreen = p18.PlayerGui:FindFirstChild("VRBlurScreen")
	local vrBlur = nil

	if vrBlurScreen then
		vrBlur = vrBlurScreen:FindFirstChild("VRBlur")
	end

	if not vrBlur then
		if not vrBlurScreen then
			vrBlurScreen = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
		end

		vrBlurScreen.Name = "VRBlurScreen"
		vrBlurScreen.Parent = p18.PlayerGui
		vrBlurScreen.Adornee = vrBlurPart
		vrBlur = Instance.new("ImageLabel")
		vrBlur.Name = "VRBlur"
		vrBlur.Parent = vrBlurScreen
		vrBlur.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
		vrBlur.AnchorPoint = Vector2.new(0.5, 0.5)
		vrBlur.Position = UDim2.new(0.5, 0, 0.5, 0)
		vrBlur.Size = UDim2.fromScale(workspace.CurrentCamera.ViewportSize.X * 2.3 / 512, workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512)
		vrBlur.BackgroundTransparency = 1
		vrBlur.Active = true
		vrBlur.ScaleType = Enum.ScaleType.Stretch
	end

	vrBlur.Visible = true
	vrBlur.ImageTransparency = 0
	p17.VREdgeBlurTimer = 0.14
end
function object.UpdateEdgeBlur(p20, p21, p22)
	local vrBlurScreen = p21.PlayerGui:FindFirstChild("VRBlurScreen")
	local vrBlur = nil

	if vrBlurScreen then
		vrBlur = vrBlurScreen:FindFirstChild("VRBlur")
	end

	if vrBlur then
		if p20.VREdgeBlurTimer > 0 then
			p20.VREdgeBlurTimer = p20.VREdgeBlurTimer - p22

			local vrBlurScreen2 = p21.PlayerGui:FindFirstChild("VRBlurScreen")
			local vrBlurScreen2VrBlur = vrBlurScreen2 and vrBlurScreen2:FindFirstChild("VRBlur")

			if vrBlurScreen2VrBlur then
				vrBlurScreen2VrBlur.ImageTransparency = 1 - math.clamp(p20.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142

				return
			end
		else
			vrBlur.Visible = false
		end

		return
	end
end
function object.GetCameraHeight(p23)
	if not p23.inFirstPerson then
		return 0.25881904510252074 * p23.currentSubjectDistance
	end

	return 0
end
function object.GetSubjectCFrame(p24)
	local v59 = baseCamera.GetSubjectCFrame(p24)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if not currentCameraCameraSubject then
		return v59
	end

	if currentCameraCameraSubject:IsA("Humanoid") and currentCameraCameraSubject:GetState() == Enum.HumanoidStateType.Dead and currentCameraCameraSubject == p24.lastSubject then
		v59 = p24.lastSubjectCFrame
	end

	if v59 then
		p24.lastSubjectCFrame = v59
	end

	return v59
end
function object.GetSubjectPosition(p25)
	local v63 = baseCamera.GetSubjectPosition(p25)
	local CurrentCamera: Camera = game.Workspace.CurrentCamera
	local currentCameraCameraSubject = CurrentCamera and CurrentCamera.CameraSubject

	if currentCameraCameraSubject then
		if currentCameraCameraSubject:IsA("Humanoid") then
			if currentCameraCameraSubject:GetState() == Enum.HumanoidStateType.Dead and currentCameraCameraSubject == p25.lastSubject then
				v63 = p25.lastSubjectPosition
			end
		elseif currentCameraCameraSubject:IsA("VehicleSeat") then
			local p = currentCameraCameraSubject.CFrame.p
			local v67 = currentCameraCameraSubject.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0))

			v63 = p + v67
		end

		p25.lastSubjectPosition = v63

		return v63
	end

	return nil
end
function object.getRotation(p26, p27)
	local v70 = cameraInput.getRotation(p27)

	if service.VRSmoothRotationEnabled then
		return v70.X
	end

	if math.abs(v70.X) > 0.03 then
		if p26.stepRotateTimeout > 0 then
			p26.stepRotateTimeout = p26.stepRotateTimeout - p27
		end

		if p26.stepRotateTimeout <= 0 then
			local n1: number = 1

			if v70.X < 0 then
				n1 = -1
			end

			p26:StartFadeFromBlack()
			p26.stepRotateTimeout = 0.25

			return n1 * 0.5235987755982988
		end
	elseif math.abs(v70.X) < 0.02 then
		p26.stepRotateTimeout = 0
	end

	return 0
end

return object
