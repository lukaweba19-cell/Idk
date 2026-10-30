-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

t1.__index = t1

local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local workspace: Workspace = game:GetService("Workspace")
local service = UserSettings():GetService("UserGameSettings")
local vrService: VRService = game:GetService("VRService")

script.Parent:WaitForChild("CommonUtils")

local keyboard = require(script:WaitForChild("Keyboard"))
local gamepad = require(script:WaitForChild("Gamepad"))
local dynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))

local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)

local u14 = ok and result
local touchThumbstick = require(script:WaitForChild("TouchThumbstick"))
local clickToMoveController = require(script:WaitForChild("ClickToMoveController"))
local touchJump = require(script:WaitForChild("TouchJump"))
local vehicleController = require(script:WaitForChild("VehicleController"))
local MediumValue = Enum.ContextActionPriority.Medium.Value
local dPad = Enum.TouchMovementMode.DPad
local v21 = Enum.DevTouchMovementMode.DPad
local thumbpad = Enum.TouchMovementMode.Thumbpad
local v23 = Enum.DevTouchMovementMode.Thumbpad
local thumbstick = Enum.TouchMovementMode.Thumbstick
local v25 = Enum.DevTouchMovementMode.Thumbstick
local v26 = Enum.TouchMovementMode.DynamicThumbstick
local v27 = Enum.DevTouchMovementMode.DynamicThumbstick
local clickToMove = Enum.TouchMovementMode.ClickToMove
local v29 = Enum.DevTouchMovementMode.ClickToMove
local default = Enum.TouchMovementMode.Default
local v31 = Enum.ComputerMovementMode.Default
local keyboardMouse = Enum.ComputerMovementMode.KeyboardMouse
local v33 = Enum.DevComputerMovementMode.KeyboardMouse
local scriptable = Enum.DevComputerMovementMode.Scriptable
local v35 = Enum.ComputerMovementMode.ClickToMove
local v36 = Enum.DevComputerMovementMode.ClickToMove

function t1.new()
	local object = setmetatable({}, t1)

	object.controllers = {}
	object.activeControlModule = nil
	object.activeController = nil
	object.touchJumpController = nil
	object.moveFunction = players.LocalPlayer.Move
	object.humanoid = nil
	object.controlsEnabled = true
	object.humanoidSeatedConn = nil
	object.vehicleController = nil
	object.touchControlFrame = nil
	object.currentTorsoAngle = 0
	object.inputMoveVector = Vector3.new(0, 0, 0)
	object.vehicleController = vehicleController.new(MediumValue)
	players.LocalPlayer.CharacterAdded:Connect(function(character: Model)
		object:OnCharacterAdded(character)
	end)
	players.LocalPlayer.CharacterRemoving:Connect(function(character: Model)
		object:OnCharacterRemoving(character)
	end)

	if players.LocalPlayer.Character then
		object:OnCharacterAdded(players.LocalPlayer.Character)
	end

	runService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p3)
		object:OnRenderStepped(p3)
	end)
	service:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
		object:UpdateMovementMode()
	end)
	players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
		object:UpdateMovementMode()
	end)
	service:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function()
		object:UpdateMovementMode()
	end)
	players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
		object:UpdateMovementMode()
	end)
	object.playerGui = nil
	object.touchGui = nil
	object.playerGuiAddedConn = nil
	guiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function()
		object:UpdateMovementMode()
		object:UpdateActiveControlModuleEnabled()
	end)
	userInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
		object:UpdateMovementMode()
	end)
	object.playerGui = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not object.playerGui then
		object.playerGuiAddedConn = players.LocalPlayer.ChildAdded:Connect(function(child: Instance)
			if child:IsA("PlayerGui") then
				object.playerGui = child
				object.playerGuiAddedConn:Disconnect()
				object.playerGuiAddedConn = nil
				object:UpdateMovementMode()
			end
		end)
	end

	object:UpdateMovementMode()

	return object
end
function t1.GetMoveVector(p5)
	if p5.activeController then
		return p5.activeController:GetMoveVector()
	end

	return Vector3.new(0, 0, 0)
end
local function NormalizeAngle(p6)
	local n1 = (p6 + 12.566370614359172) % 6.283185307179586

	if n1 > 3.141592653589793 then
		n1 -= 6.283185307179586
	end

	return n1
end
local function AverageAngle(p7, p8)
	local n1 = (p8 - p7 + 12.566370614359172) % 6.283185307179586

	if n1 > 3.141592653589793 then
		n1 -= 6.283185307179586
	end

	local n2 = (p7 + n1 / 2 + 12.566370614359172) % 6.283185307179586

	if n2 > 3.141592653589793 then
		n2 -= 6.283185307179586
	end

	return n2
end
function t1.GetEstimatedVRTorsoFrame(p9)
	local v50: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
	local v51, v52, v53 = v50:ToEulerAnglesYXZ()
	local n1 = -v52

	if not vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or not vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
		p9.currentTorsoAngle = n1
	else
		local v55 = vrService:GetUserCFrame(Enum.UserCFrame.LeftHand)
		local v56: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.RightHand)
		local n2 = v50.Position - v55.Position

		v55 = v50.Position - v56.Position

		local n3 = -math.atan2(n2.X, n2.Z)
		local n4 = (-math.atan2(v55.X, v55.Z) - n3 + 12.566370614359172) % 6.283185307179586

		if n4 > 3.141592653589793 then
			n4 -= 6.283185307179586
		end

		v55 = (n3 + n4 / 2 + 12.566370614359172) % 6.283185307179586

		if v55 > 3.141592653589793 then
			v55 -= 6.283185307179586
		end

		n2 = (n1 - p9.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

		if n2 > 3.141592653589793 then
			n2 -= 6.283185307179586
		end

		n3 = (v55 - p9.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

		if n3 > 3.141592653589793 then
			n3 -= 6.283185307179586
		end

		if not (n3 > -1.5707963267948966) or not (n3 < 1.5707963267948966) then
			n3 = n2
		end

		v55 = math.min(n3, n2)
		n4 = math.max(n3, n2)
		n2 = 0

		if v55 > 0 then
			n2 = v55
		elseif n4 < 0 then
			n2 = n4
		end

		p9.currentTorsoAngle = n2 + p9.currentTorsoAngle
	end

	local cFrame = CFrame.new(v50.Position)
	local v61 = CFrame.fromEulerAnglesYXZ(0, -p9.currentTorsoAngle, 0)

	return cFrame * v61
end
function t1.GetActiveController(p10)
	return p10.activeController
end
function t1.UpdateActiveControlModuleEnabled(p11)
	local function v64()
		p11.activeController:Enable(false)

		if p11.touchJumpController then
			p11.touchJumpController:Enable(false)
		end

		if p11.moveFunction then
			p11.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
		end
	end

	if not p11.activeController then
		return
	end

	if not p11.controlsEnabled then
		p11.activeController:Enable(false)

		if p11.touchJumpController then
			p11.touchJumpController:Enable(false)
		end

		if p11.moveFunction then
			p11.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
		end

		return
	end

	if not guiService.TouchControlsEnabled and userInputService.PreferredInput == Enum.PreferredInput.Touch and (p11.activeControlModule == clickToMoveController or p11.activeControlModule == touchThumbstick or p11.activeControlModule == dynamicThumbstick) then
		p11.activeController:Enable(false)

		if p11.touchJumpController then
			p11.touchJumpController:Enable(false)
		end

		if p11.moveFunction then
			p11.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
		end

		return
	end;

	(function()
		if p11.touchControlFrame and userInputService.PreferredInput == Enum.PreferredInput.Touch and (p11.activeControlModule == clickToMoveController or p11.activeControlModule == touchThumbstick or p11.activeControlModule == dynamicThumbstick) then
			if not p11.controllers[touchJump] then
				p11.controllers[touchJump] = touchJump.new()
			end

			p11.touchJumpController = p11.controllers[touchJump]
			p11.touchJumpController:Enable(true, p11.touchControlFrame)
		elseif p11.touchJumpController then
			p11.touchJumpController:Enable(false)
		end

		if p11.activeControlModule == clickToMoveController then
			p11.activeController:Enable(true, players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, p11.touchJumpController)

			return
		end

		if p11.touchControlFrame then
			p11.activeController:Enable(true, p11.touchControlFrame)

			return
		end

		p11.activeController:Enable(true)
	end)()
end
function t1.Enable(p12, p13: boolean)
	if p13 == nil then
		p13 = true
	end

	if p13 == p12.controlsEnabled then
		return
	end

	p12.controlsEnabled = p13

	if not p12.activeController then
		return
	end

	p12:UpdateActiveControlModuleEnabled()
end
function t1.Disable(p14)
	p14:Enable(false)
end

local t2: {[any]: any} = {
	[dPad] = dynamicThumbstick,
	[v21] = dynamicThumbstick,
	[thumbpad] = dynamicThumbstick,
	[v23] = dynamicThumbstick,
	[thumbstick] = touchThumbstick,
	[v25] = touchThumbstick,
	[v26] = dynamicThumbstick,
	[v27] = dynamicThumbstick,
	[clickToMove] = clickToMoveController,
	[v29] = clickToMoveController,
	[default] = dynamicThumbstick,
	[v31] = keyboard,
	[keyboardMouse] = keyboard,
	[v33] = keyboard,
	[scriptable] = nil,
	[v35] = clickToMoveController,
	[v36] = clickToMoveController
}

function t1.SelectComputerMovementModule(_)
	if not userInputService.KeyboardEnabled and not userInputService.GamepadEnabled then
		return nil, false
	end

	local v69 = nil
	local devComputerMovementMode: Enum.DevComputerMovementMode = players.LocalPlayer.DevComputerMovementMode

	if devComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
		if userInputService.PreferredInput == Enum.PreferredInput.Gamepad then
			v69 = gamepad
		elseif userInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
			v69 = keyboard
		end

		if service.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v69 == keyboard then
			v69 = clickToMoveController
		end
	else
		v69 = t2[devComputerMovementMode]

		if not v69 and devComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
			warn("No character control module is associated with DevComputerMovementMode ", devComputerMovementMode)
		end
	end

	if v69 then
		return v69, true
	end

	if devComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
		return nil, true
	end

	return nil, false
end
function t1.SelectTouchModule(_)
	local devTouchMovementMode: Enum.DevTouchMovementMode = players.LocalPlayer.DevTouchMovementMode
	local v73

	if devTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
		v73 = t2[service.TouchMovementMode]
	else
		if devTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
			return nil, true
		end

		v73 = t2[devTouchMovementMode]
	end

	return v73, true
end
local function getGamepadRightThumbstickPosition()
	local v74 = userInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

	for _, v in pairs(v74) do
		if v.KeyCode == Enum.KeyCode.Thumbstick2 then
			return v.Position
		end
	end

	return Vector3.new(0, 0, 0)
end
function t1.calculateRawMoveVector(p17, p18, p19)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return p19
	end

	local v81 = CurrentCamera.CFrame

	if vrService.VREnabled and p18.RootPart then
		vrService:GetUserCFrame(Enum.UserCFrame.Head)

		local v82 = p17:GetEstimatedVRTorsoFrame()

		v81 = if (CurrentCamera.Focus.Position - v81.Position).Magnitude < 3 then v81 * v82 else CurrentCamera.CFrame * (v82.Rotation + v82.Position * CurrentCamera.HeadScale)
	end

	if p18:GetState() ~= Enum.HumanoidStateType.Swimming then
		local v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94 = v81:GetComponents()
		local v95
		local v96

		if v91 < 1 and v91 > -1 then
			v95 = v94
			v96 = v88
		else
			v95 = v86

			local v97 = math.sign(v91)

			v96 = -v87 * v97
		end

		local squareRoot = math.sqrt(v95 * v95 + v96 * v96)
		local vector3 = Vector3.new((v95 * p19.X + v96 * p19.Z) / squareRoot, 0, (v95 * p19.Z - v96 * p19.X) / squareRoot)

		return vector3
	end

	if vrService.VREnabled then
		local vector3 = Vector3.new(p19.X, 0, p19.Z)

		if vector3.Magnitude < 0.01 then
			return Vector3.new(0, 0, 0)
		end

		local n1 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
		local v102 = math.atan2(-vector3.X, -vector3.Z)
		local v103, v104, v105 = v81:ToEulerAnglesYXZ()

		return CFrame.fromEulerAnglesYXZ(n1, v102 + v104, 0).LookVector
	end

	return v81:VectorToWorldSpace(p19)
end
function t1.OnRenderStepped(p20, p21)
	if p20.activeController and p20.activeController.enabled and p20.humanoid then
		local v108 = p20.activeController:GetMoveVector()
		local v109 = p20.activeController:IsMoveVectorCameraRelative()
		local v110 = p20:GetClickToMoveController()

		if p20.activeController == v110 then
			v110:OnRenderStepped(p21)
		elseif v108.magnitude > 0 then
			v110:CleanupPath()
		else
			v110:OnRenderStepped(p21)
			v108 = v110:GetMoveVector()
			v109 = v110:IsMoveVectorCameraRelative()
		end

		if p20.vehicleController then
			local v111, v112 = p20.vehicleController:Update(v108, v109, p20.activeControlModule == gamepad)

			v108 = v111
		end

		if v109 then
			v108 = p20:calculateRawMoveVector(p20.humanoid, v108)
		end

		p20.inputMoveVector = v108

		if vrService.VREnabled then
			v108 = p20:updateVRMoveVector(v108)
		end

		p20.moveFunction(players.LocalPlayer, v108, false)
		p20.humanoid.Jump = p20.activeController:GetIsJumping() or p20.touchJumpController and p20.touchJumpController:GetIsJumping()
	end
end
function t1.updateVRMoveVector(p22, p23)
	local CurrentCamera = workspace.CurrentCamera

	if p23.Magnitude == 0 and (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude < 5 and true and vrService.AvatarGestures and p22.humanoid and not p22.humanoid.Sit then
		local v116: CFrame = vrService:GetUserCFrame(Enum.UserCFrame.Head)
		local n1 = CurrentCamera.CFrame * (v116.Rotation + v116.Position * CurrentCamera.HeadScale)
		local cFrame = CFrame.new(0, -0.7 * p22.humanoid.RootPart.Size.Y / 2, 0)
		local n2 = (n1 * cFrame).Position - p22.humanoid.RootPart.CFrame.Position
		local vector3 = Vector3.new(n2.x, 0, n2.z)

		return vector3
	end

	return p23
end
function t1.OnHumanoidSeated(p24, p25, p26)
	if p25 then
		if p26 and p26:IsA("VehicleSeat") then
			if not p24.vehicleController then
				p24.vehicleController = p24.vehicleController.new(MediumValue)
			end

			p24.vehicleController:Enable(true, p26)

			return
		end
	elseif p24.vehicleController then
		p24.vehicleController:Enable(false, p26)
	end
end
function t1.OnCharacterAdded(p27, character)
	p27.humanoid = character:FindFirstChildOfClass("Humanoid")

	while not p27.humanoid do
		character.ChildAdded:wait()
		p27.humanoid = character:FindFirstChildOfClass("Humanoid")
	end

	if p27.humanoidSeatedConn then
		p27.humanoidSeatedConn:Disconnect()
		p27.humanoidSeatedConn = nil
	end

	p27.humanoidSeatedConn = p27.humanoid.Seated:Connect(function(p29, p30)
		p27:OnHumanoidSeated(p29, p30)
	end)
	p27:UpdateMovementMode()
end
function t1.OnCharacterRemoving(p31, _)
	p31.humanoid = nil
	p31:UpdateMovementMode()
end
function t1.UpdateTouchGuiVisibility(p33)
	local v129 = p33.humanoid and guiService.TouchControlsEnabled and userInputService.PreferredInput == Enum.PreferredInput.Touch

	if v129 and not p33.touchGui then
		p33:CreateTouchGuiContainer()
	end

	if p33.touchGui then
		p33.touchGui.Enabled = not not v129
	end
end
function t1.SwitchToController(p34, p35)
	if not p35 then
		if p34.activeController then
			p34.activeController:Enable(false)
		end

		p34.activeController = nil
		p34.activeControlModule = nil

		return
	end

	if not p34.controllers[p35] then
		p34.controllers[p35] = p35.new(MediumValue)
	end

	if p34.activeController ~= p34.controllers[p35] then
		if p34.activeController then
			p34.activeController:Enable(false)
		end

		p34.activeController = p34.controllers[p35]
		p34.activeControlModule = p35
		p34:UpdateActiveControlModuleEnabled()
	end
end
function t1.UpdateMovementMode(p36)
	p36:UpdateTouchGuiVisibility()

	if userInputService.PreferredInput == Enum.PreferredInput.Touch then
		local v133, v134 = p36:SelectTouchModule()

		if v134 and p36.touchControlFrame then
			p36:SwitchToController(v133)

			return
		end
	else
		local v135 = p36:SelectComputerMovementModule()

		p36:SwitchToController(v135)
	end
end
function t1.CreateTouchGuiContainer(p37)
	if not p37.playerGui then
		return
	end

	if p37.touchGui then
		p37.touchGui:Destroy()
	end

	p37.touchGui = Instance.new("ScreenGui")
	p37.touchGui.Name = "TouchGui"
	p37.touchGui.ResetOnSpawn = false
	p37.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	if u14 then
		p37.touchGui.ClipToDeviceSafeArea = false
	end

	p37.touchControlFrame = Instance.new("Frame")
	p37.touchControlFrame.Name = "TouchControlFrame"
	p37.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
	p37.touchControlFrame.BackgroundTransparency = 1
	p37.touchControlFrame.Parent = p37.touchGui
	p37.touchGui.Parent = p37.playerGui
end
function t1.GetClickToMoveController(p38)
	if not p38.controllers[clickToMoveController] then
		p38.controllers[clickToMoveController] = clickToMoveController.new(MediumValue)
	end

	return p38.controllers[clickToMoveController]
end

return t1.new()
