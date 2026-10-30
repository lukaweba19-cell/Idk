-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

t1.__index = t1

local t2: {[any]: any} = {
	"CameraMinZoomDistance",
	"CameraMaxZoomDistance",
	"CameraMode",
	"DevCameraOcclusionMode",
	"DevComputerCameraMode",
	"DevTouchCameraMode",
	"DevComputerMovementMode",
	"DevTouchMovementMode",
	"DevEnableMouseLock"
}
local t3: {[any]: any} = {
	"ComputerCameraMovementMode",
	"ComputerMovementMode",
	"ControlMode",
	"GamepadCameraSensitivity",
	"MouseSensitivity",
	"RotationType",
	"TouchCameraMovementMode",
	"TouchMovementMode"
}
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local vrService: VRService = game:GetService("VRService")
local service = UserSettings():GetService("UserGameSettings")
local commonUtils: Instance = script.Parent:WaitForChild("CommonUtils")
local connectionUtil = require(commonUtils:WaitForChild("ConnectionUtil"))
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local cameraUtils = require(script:WaitForChild("CameraUtils"))
local cameraInput = require(script:WaitForChild("CameraInput"))
local classicCamera = require(script:WaitForChild("ClassicCamera"))
local orbitalCamera = require(script:WaitForChild("OrbitalCamera"))
local legacyCamera = require(script:WaitForChild("LegacyCamera"))
local vehicleCamera = require(script:WaitForChild("VehicleCamera"))
local vrCamera = require(script:WaitForChild("VRCamera"))
local vrVehicleCamera = require(script:WaitForChild("VRVehicleCamera"))
local invisicam = require(script:WaitForChild("Invisicam"))
local poppercam = require(script:WaitForChild("Poppercam"))
local transparencyController = require(script:WaitForChild("TransparencyController"))
local mouseLockController = require(script:WaitForChild("MouseLockController"))
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}

if not players.LocalPlayer then
	return {}
end

assert(players.LocalPlayer, "Strict typing check")

local playerScripts: Instance = players.LocalPlayer:WaitForChild("PlayerScripts")

playerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
playerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
playerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
playerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
playerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
playerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
playerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)

local v27 = flagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local v28 = flagUtil.getUserFlag("UserPSFixCameraControllerReset")

function t1.new()
	local t6 = {
		activeTransparencyController = transparencyController.new(),
		connectionUtil = v30
	}
	local v30 = if v27 then connectionUtil.new() else nil
	local object = setmetatable(t6, t1)

	object.activeCameraController = nil
	object.activeOcclusionModule = nil
	object.activeMouseLockController = nil
	object.currentComputerCameraMovementMode = nil
	object.cameraSubjectChangedConn = nil
	object.cameraTypeChangedConn = nil

	for _, v in pairs(players:GetPlayers()) do
		object:OnPlayerAdded(v)
	end

	players.PlayerAdded:Connect(function(player: Player)
		object:OnPlayerAdded(player)
	end)

	if v27 then
		players.PlayerRemoving:Connect(function(player: Player)
			object:OnPlayerRemoving(player)
		end)
	end

	object.activeTransparencyController:Enable(true)
	object.activeMouseLockController = mouseLockController.new()
	assert(object.activeMouseLockController, "Strict typing check")
	t6 = object.activeMouseLockController:GetBindableToggleEvent()

	if t6 then
		t6:Connect(function()
			object:OnMouseLockToggled()
		end)
	end

	object:ActivateCameraController()
	object:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)
	object:OnCurrentCameraChanged()
	runService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(p3)
		object:Update(p3)
	end)

	for _, v in pairs(t2) do
		players.LocalPlayer:GetPropertyChangedSignal(v):Connect(function()
			object:OnLocalPlayerCameraPropertyChanged(v)
		end)
	end

	for _, v in pairs(t3) do
		service:GetPropertyChangedSignal(v):Connect(function()
			object:OnUserGameSettingsPropertyChanged(v)
		end)
	end

	game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		object:OnCurrentCameraChanged()
	end)
	userInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
		object:OnPreferredInputChanged()
	end)

	return object
end
function t1.GetCameraMovementModeFromSettings(_)
	if players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
		return cameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
	end

	local v39
	local v40

	if userInputService.PreferredInput == Enum.PreferredInput.Touch then
		v39 = cameraUtils.ConvertCameraModeEnumToStandard(players.LocalPlayer.DevTouchCameraMode)
		v40 = cameraUtils.ConvertCameraModeEnumToStandard(service.TouchCameraMovementMode)
	else
		v39 = cameraUtils.ConvertCameraModeEnumToStandard(players.LocalPlayer.DevComputerCameraMode)
		v40 = cameraUtils.ConvertCameraModeEnumToStandard(service.ComputerCameraMovementMode)
	end

	if v39 == Enum.DevComputerCameraMovementMode.UserChoice then
		return v40
	end

	return v39
end
function t1.ActivateOcclusionModule(p5, p6)
	local v43

	if p6 == Enum.DevCameraOcclusionMode.Zoom then
		v43 = poppercam
	else
		if p6 ~= Enum.DevCameraOcclusionMode.Invisicam then
			warn("CameraScript ActivateOcclusionModule called with unsupported mode")

			return
		end

		v43 = invisicam
	end

	p5.occlusionMode = p6

	if p5.activeOcclusionModule and p6 == p5.activeOcclusionModule:GetOcclusionMode() then
		if not p5.activeOcclusionModule:GetEnabled() then
			p5.activeOcclusionModule:Enable(true)
		end

		return
	end

	local activeOcclusionModule = p5.activeOcclusionModule

	p5.activeOcclusionModule = t5[v43]

	if not p5.activeOcclusionModule then
		p5.activeOcclusionModule = v43.new()

		if p5.activeOcclusionModule then
			t5[v43] = p5.activeOcclusionModule
		end
	end

	if p5.activeOcclusionModule then
		local v45 = p5.activeOcclusionModule:GetOcclusionMode()

		if p6 ~= v45 then
			local v46 = p5.activeOcclusionModule:GetOcclusionMode()

			warn("CameraScript ActivateOcclusionModule mismatch: ", v46, "~=", p6)
		end

		if activeOcclusionModule then
			if activeOcclusionModule ~= p5.activeOcclusionModule then
				activeOcclusionModule:Enable(false)
			else
				warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
			end
		end

		if p6 ~= Enum.DevCameraOcclusionMode.Invisicam then
			for _, v in pairs(players:GetPlayers()) do
				if v and v.Character then
					p5.activeOcclusionModule:CharacterAdded(v.Character, v)
				end
			end

			p5.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
		elseif players.LocalPlayer.Character then
			p5.activeOcclusionModule:CharacterAdded(players.LocalPlayer.Character, players.LocalPlayer)
		end

		p5.activeOcclusionModule:Enable(true)
	end
end
function t1.ShouldUseVehicleCamera(p7)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return false
	end

	local currentCameraCameraType: Enum.CameraType = CurrentCamera.CameraType
	local currentCameraCameraSubject: Instance = CurrentCamera.CameraSubject
	local u53: boolean = true

	if currentCameraCameraType ~= Enum.CameraType.Custom then
		u53 = currentCameraCameraType == Enum.CameraType.Follow
	end

	return (currentCameraCameraSubject and currentCameraCameraSubject:IsA("VehicleSeat") or false) and u53 and p7.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
end
function t1.ActivateCameraController(p8)
	local cameraType: Enum.CameraType = workspace.CurrentCamera.CameraType
	local v56 = p8:GetCameraMovementModeFromSettings()
	local v57 = nil

	if cameraType == Enum.CameraType.Scriptable then
		if p8.activeCameraController then
			p8.activeCameraController:Enable(false)
			p8.activeCameraController = nil
		end

		return
	end

	if cameraType == Enum.CameraType.Custom then
		v56 = p8:GetCameraMovementModeFromSettings()
	elseif cameraType == Enum.CameraType.Track then
		v56 = Enum.ComputerCameraMovementMode.Classic
	elseif cameraType == Enum.CameraType.Follow then
		v56 = Enum.ComputerCameraMovementMode.Follow
	elseif cameraType == Enum.CameraType.Orbital then
		v56 = Enum.ComputerCameraMovementMode.Orbital
	elseif cameraType == Enum.CameraType.Attach or cameraType == Enum.CameraType.Watch or cameraType == Enum.CameraType.Fixed then
		v57 = legacyCamera
	else
		warn("CameraScript encountered an unhandled Camera.CameraType value: ", cameraType)
	end

	if not v57 then
		if vrService.VREnabled then
			v57 = vrCamera
		elseif v56 == Enum.ComputerCameraMovementMode.Classic or v56 == Enum.ComputerCameraMovementMode.Follow or v56 == Enum.ComputerCameraMovementMode.Default or v56 == Enum.ComputerCameraMovementMode.CameraToggle then
			v57 = classicCamera
		else
			if v56 ~= Enum.ComputerCameraMovementMode.Orbital then
				warn("ActivateCameraController did not select a module.")

				return
			end

			v57 = orbitalCamera
		end
	end

	if p8:ShouldUseVehicleCamera() then
		v57 = if vrService.VREnabled then vrVehicleCamera else vehicleCamera
	end

	local v58

	if not t4[v57] then
		v58 = v57.new()
		t4[v57] = v58
	else
		v58 = t4[v57]

		if not v28 then
			if v58.Reset then
				v58:Reset()
			end
		elseif v58.Reset and v58 ~= p8.activeCameraController then
			v58:Reset()
		end
	end

	if not p8.activeCameraController then
		if v58 ~= nil then
			p8.activeCameraController = v58
			assert(p8.activeCameraController, "Strict typing check")
			p8.activeCameraController:Enable(true)
		end
	elseif v58 ~= p8.activeCameraController then
		p8.activeCameraController:Enable(false)
		p8.activeCameraController = v58
		p8.activeCameraController:Enable(true)
	elseif not p8.activeCameraController:GetEnabled() then
		p8.activeCameraController:Enable(true)
	end

	if p8.activeCameraController then
		p8.activeCameraController:SetCameraMovementMode(v56)
		p8.activeCameraController:SetCameraType(cameraType)
	end
end
function t1.OnCameraSubjectChanged(p9)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v61 = if CurrentCamera then CurrentCamera.CameraSubject else nil

	if p9.activeTransparencyController then
		p9.activeTransparencyController:SetSubject(v61)
	end

	if p9.activeOcclusionModule then
		p9.activeOcclusionModule:OnCameraSubjectChanged(v61)
	end

	p9:ActivateCameraController()
end
function t1.OnCameraTypeChanged(p10, p11)
	if p11 == Enum.CameraType.Scriptable and userInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		cameraUtils.restoreMouseBehavior()
	end

	p10:ActivateCameraController()
end
function t1.OnCurrentCameraChanged(p12)
	local CurrentCamera: Camera = game.Workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	if p12.cameraSubjectChangedConn then
		p12.cameraSubjectChangedConn:Disconnect()
	end

	if p12.cameraTypeChangedConn then
		p12.cameraTypeChangedConn:Disconnect()
	end

	p12.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		p12:OnCameraSubjectChanged()
	end)
	p12.cameraTypeChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
		p12:OnCameraTypeChanged(CurrentCamera.CameraType)
	end)
	p12:OnCameraSubjectChanged()
	p12:OnCameraTypeChanged(CurrentCamera.CameraType)
end
function t1.OnLocalPlayerCameraPropertyChanged(p13, p14)
	if p14 == "CameraMode" then
		if players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
			if players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
				p13:ActivateCameraController()

				return
			end

			warn("Unhandled value for property player.CameraMode: ", players.LocalPlayer.CameraMode)

			return
		end

		if not p13.activeCameraController or p13.activeCameraController:GetModuleName() ~= "ClassicCamera" then
			p13:ActivateCameraController()
		end

		if p13.activeCameraController then
			p13.activeCameraController:UpdateForDistancePropertyChange()

			return
		end
	else
		if p14 == "DevComputerCameraMode" or p14 == "DevTouchCameraMode" then
			p13:ActivateCameraController()

			return
		end

		if p14 == "DevCameraOcclusionMode" then
			p13:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)

			return
		end

		if p14 ~= "CameraMinZoomDistance" and p14 ~= "CameraMaxZoomDistance" then
			if p14 == "DevTouchMovementMode" then
				return
			end

			if p14 == "DevComputerMovementMode" then
				return
			end
		elseif p13.activeCameraController then
			p13.activeCameraController:UpdateForDistancePropertyChange()

			return
		end
	end
end
function t1.OnUserGameSettingsPropertyChanged(p15, p16)
	if p16 == "ComputerCameraMovementMode" or p16 == "TouchCameraMovementMode" then
		p15:ActivateCameraController()
	end
end
function t1.OnPreferredInputChanged(p17)
	p17:ActivateCameraController()
end
function t1.Update(p18, p19)
	if p18.activeCameraController then
		p18.activeCameraController:UpdateMouseBehavior()

		local v73, v74 = p18.activeCameraController:Update(p19)

		if p18.activeOcclusionModule then
			local v75, v76 = p18.activeOcclusionModule:Update(p19, v73, v74)

			v73 = v75
			v74 = v76
		end

		local CurrentCamera: Camera = game.Workspace.CurrentCamera

		CurrentCamera.CFrame = v73
		CurrentCamera.Focus = v74

		if p18.activeTransparencyController then
			p18.activeTransparencyController:Update(p19)
		end

		if cameraInput.getInputEnabled() then
			cameraInput.resetInputForFrameEnd()
		end
	end
end
function t1.OnCharacterAdded(p20, p21, p22)
	if p20.activeOcclusionModule then
		p20.activeOcclusionModule:CharacterAdded(p21, p22)
	end
end
function t1.OnCharacterRemoving(p23, p24, p25)
	if p23.activeOcclusionModule then
		p23.activeOcclusionModule:CharacterRemoving(p24, p25)
	end
end
function t1.OnPlayerAdded(p26, player)
	if not v27 then
		player.CharacterAdded:Connect(function(p30)
			p26:OnCharacterAdded(p30, player)
		end)
		player.CharacterRemoving:Connect(function(p31)
			p26:OnCharacterRemoving(p31, player)
		end)
	elseif p26.connectionUtil then
		local connectionUtil = p26.connectionUtil
		local v87 = ("%*CharacterAdded"):format(player.UserId)

		connectionUtil:trackConnection(v87, player.CharacterAdded:Connect(function(p28)
			p26:OnCharacterAdded(p28, player)
		end))

		local v88 = p26.connectionUtil

		v87 = ("%*CharacterRemoving"):format(player.UserId)
		v88:trackConnection(v87, player.CharacterRemoving:Connect(function(p29)
			p26:OnCharacterRemoving(p29, player)
		end))

		return
	end
end
function t1.OnPlayerRemoving(p32, player)
	if p32.connectionUtil then
		local connectionUtil = p32.connectionUtil
		local v92 = ("%*CharacterAdded"):format(player.UserId)

		connectionUtil:disconnect(v92)

		local v93 = p32.connectionUtil

		v92 = ("%*CharacterRemoving"):format(player.UserId)
		v93:disconnect(v92)
	end
end
function t1.OnMouseLockToggled(p34)
	if p34.activeMouseLockController and p34.activeCameraController then
		p34.activeCameraController:SetIsMouseLocked(v95)
		p34.activeCameraController:SetMouseLockOffset(v96)
	end
end

t1.new()

return {}
