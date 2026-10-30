-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local userInputService: UserInputService = game:GetService("UserInputService")
local players: Players = game:GetService("Players")

game:GetService("RunService")

local service = UserSettings():GetService("UserGameSettings")
local vrService: VRService = game:GetService("VRService")
local guiService: GuiService = game:GetService("GuiService")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local v9 = flagUtil.getUserFlag("UserPSSinkUnknownTouchEvents")
local v10 = flagUtil.getUserFlag("UserPSTextboxResetCameraInput")
local LocalPlayer: Player = players.LocalPlayer
local MediumValue = Enum.ContextActionPriority.Medium.Value
local n1 = Vector2.new(1, 0.77) * 0.06981317007977318 * 60
local n2 = Vector2.new(1, 0.77) * 0.008726646259971648
local n3 = Vector2.new(1, 0.77) * 0.12217304763960307
local n4 = Vector2.new(1, 0.66) * 0.017453292519943295
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local bindableEvent2: BindableEvent = Instance.new("BindableEvent")
local bindableEventEvent = bindableEvent.Event
local bindableEvent2Event = bindableEvent2.Event

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton2 then
		bindableEvent:Fire()
	end
end)
userInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		bindableEvent2:Fire()
	end
end)

local function thumbstickCurve(p5)
	local absoluteValue = math.abs(p5)
	local v67 = math.exp((absoluteValue - 0.1) / 0.9 * 2)
	local v68 = math.sign(p5)
	local v69 = math.clamp((v67 - 1) / 6.38905609893065, 0, 1)

	return v68 * v69
end
local function adjustTouchPitchSensitivity(p6)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return p6
	end

	local v72 = CurrentCamera.CFrame:ToEulerAnglesYXZ()

	if p6.Y * v72 >= 0 then
		return p6
	end

	local absoluteValue = math.abs(v72)

	return Vector2.new(1, (1 - (absoluteValue * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25) * p6
end
local function isInDynamicThumbstickArea(p7)
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local touchGui: Instance = playerGui and playerGui:FindFirstChild("TouchGui")
	local v77 = touchGui

	if v77 then
		v77 = touchGui:FindFirstChild("TouchControlFrame")
	end

	local dynamicThumbstickFrame: Instance = v77 and v77:FindFirstChild("DynamicThumbstickFrame")

	if not dynamicThumbstickFrame then
		return false
	end

	if not touchGui.Enabled then
		return false
	end

	local dynamicThumbstickFrameAbsolutePosition = dynamicThumbstickFrame.AbsolutePosition

	v77 = dynamicThumbstickFrameAbsolutePosition + dynamicThumbstickFrame.AbsoluteSize

	return p7.X >= dynamicThumbstickFrameAbsolutePosition.X and p7.Y >= dynamicThumbstickFrameAbsolutePosition.Y and p7.X <= v77.X and p7.Y <= v77.Y
end

local t1: {[any]: any} = {}
local n5 = 0

local function incPanInputCount()
	n5 = math.max(0, n5 + 1)
end
local function decPanInputCount()
	n5 = math.max(0, n5 - 1)
end
local function resetPanInputCount()
	n5 = 0
end

local t2: {[any]: any} = { Thumbstick2 = Vector2.new() }
local t3: {[any]: any} = { Left = 0, Right = 0, I = 0, O = 0 }
local t4: {[any]: any} = { Wheel = 0, Pinch = 0, Movement = Vector2.new(), Pan = Vector2.new() }
local t5: {[any]: any} = { Pinch = 0, Move = Vector2.new() }
local bindableEvent3: BindableEvent = Instance.new("BindableEvent")
local module: {[any]: any} = { gamepadZoomPress = bindableEvent3.Event }
local v35 = vrService.VREnabled and Instance.new("BindableEvent") or nil

if vrService.VREnabled then
	module.gamepadReset = v35.Event
end

function module.getRotationActivated()
	local u80: boolean = true

	if not (n5 > 0) then
		u80 = t2.Thumbstick2.Magnitude > 0
	end

	return u80
end
function module.getRotation(p8, p9)
	local vector2 = Vector2.new(1, service:GetCameraYInvertValue())
	local n5 = Vector2.new(t3.Right - t3.Left, 0) * p8
	local n6 = t2.Thumbstick2 * service.GamepadCameraSensitivity * p8
	local movement = t4.Movement
	local pan = t4.Pan
	local v88 = adjustTouchPitchSensitivity(t5.Move)

	if p9 then
		n5 = Vector2.new()
	end

	return (n5 * 2.0943951023931953 + n6 * n1 + movement * n2 + pan * n3 + v88 * n4) * vector2
end
function module.getZoomDelta()
	return (t3.O - t3.I) * 0.1 + (-t4.Wheel + t4.Pinch) * 1 + -t5.Pinch * 0.04
end
local function thumbstick(_, _, input)
	local inputPosition = input.Position
	local KeyCodeName = input.KeyCode.Name
	local vector2New = Vector2.new
	local v95 = thumbstickCurve(inputPosition.X)
	local v96 = thumbstickCurve(inputPosition.Y)

	t2[KeyCodeName] = vector2New(v95, -v96)

	return Enum.ContextActionResult.Pass
end
local function mouseMovement(p13)
	local delta = p13.Delta

	t4.Movement = Vector2.new(delta.X, delta.Y)
end
local function mouseWheel(_, _, p16)
	t4.Wheel = p16.Position.Z

	return Enum.ContextActionResult.Pass
end
local function keypress(_, p18, p19)
	t3[p19.KeyCode.Name] = if p18 == Enum.UserInputState.Begin then 1 else 0
end
local function gamepadZoomPress(_, p21, _)
	if p21 == Enum.UserInputState.Begin then
		bindableEvent3:Fire()
	end
end
local function gamepadReset(_, p24, _)
	if p24 == Enum.UserInputState.Begin then
		v35:Fire()
	end
end
local function resetInputDevices()
	for _, v in pairs({ t2, t3, t4, t5 }) do
		for k, iterValue in pairs(v) do
			if type(iterValue) == "boolean" then
				v[k] = false
			else
				v[k] = v[k] * 0
			end
		end
	end

	n5 = 0
end

local u43 = nil
local u44 = nil
local u45 = nil
local u46 = nil
local t7: {[any]: any} = {}
local u48 = nil
local u49 = nil

u43 = function(input, p27)
	assert(input.UserInputType == Enum.UserInputType.Touch)
	assert(input.UserInputState == Enum.UserInputState.Begin)

	if u48 == nil and isInDynamicThumbstickArea(input.Position) and not p27 then
		u48 = input

		return
	end

	if not p27 then
		n5 = math.max(0, n5 + 1)
	end

	t7[input] = p27
end
u45 = function(input, _)
	assert(input.UserInputType == Enum.UserInputType.Touch)
	assert(input.UserInputState == Enum.UserInputState.End)

	if input == u48 then
		u48 = nil
	end

	if t7[input] == false then
		u49 = nil
		n5 = math.max(0, n5 - 1)
	end

	t7[input] = nil
end
u44 = function(input, p31)
	assert(input.UserInputType == Enum.UserInputType.Touch)
	assert(input.UserInputState == Enum.UserInputState.Change)

	if input == u48 then
		return
	end

	if t7[input] == nil then
		if v9 then
			t7[input] = true
		else
			t7[input] = p31
		end
	end

	local t8: {[any]: any} = {}

	for k, v in pairs(t7) do
		if not v then
			table.insert(t8, k)
		end
	end

	if #t8 == 1 and t7[input] == false then
		local delta = input.Delta
		local v125: {[any]: any} = t5
		local move = v125.Move
		local vector2 = Vector2.new(delta.X, delta.Y)

		v125.Move = move + vector2
	end

	if #t8 == 2 then
		local magnitude = (t8[1].Position - t8[2].Position).Magnitude

		if u49 then
			local v129: {[any]: any} = t5

			v129.Pinch = v129.Pinch + (magnitude - u49)
		end

		u49 = magnitude

		return
	end

	u49 = nil
end
u46 = function()
	t7 = {}
	u48 = nil
	u49 = nil
	n5 = 0
end

local function pointerAction(wheel, pan, p34, p35)
	if not p35 then
		t4.Wheel = wheel
		t4.Pan = pan
		t4.Pinch = -p34
	end
end
local function inputBegan(input, p37)
	if input.UserInputType == Enum.UserInputType.Touch then
		u43(input, p37)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 and not p37 then
		n5 = math.max(0, n5 + 1)
	end
end
local function inputChanged(input, p39)
	if input.UserInputType == Enum.UserInputType.Touch then
		u44(input, p39)
	elseif input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta

		t4.Movement = Vector2.new(delta.X, delta.Y)
	end
end
local function inputEnded(input, p41)
	if input.UserInputType == Enum.UserInputType.Touch then
		u45(input, p41)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		n5 = math.max(0, n5 - 1)
	end
end

local u54 = false

function module.setInputEnabled(p42)
	if p42 == u54 then
		return
	end

	u54 = p42
	resetInputDevices()
	u46()

	if u54 then
		contextActionService:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, MediumValue, Enum.KeyCode.Thumbstick2)
		contextActionService:BindActionAtPriority("RbxCameraKeypress", keypress, false, MediumValue, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O)

		if vrService.VREnabled then
			contextActionService:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3)
		end

		contextActionService:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3)
		table.insert(t1, userInputService.InputBegan:Connect(inputBegan))
		table.insert(t1, userInputService.InputChanged:Connect(inputChanged))
		table.insert(t1, userInputService.InputEnded:Connect(inputEnded))
		table.insert(t1, userInputService.PointerAction:Connect(pointerAction))
		table.insert(t1, guiService.MenuOpened:connect(u46))

		return
	end

	contextActionService:UnbindAction("RbxCameraThumbstick")
	contextActionService:UnbindAction("RbxCameraMouseMove")
	contextActionService:UnbindAction("RbxCameraMouseWheel")
	contextActionService:UnbindAction("RbxCameraKeypress")
	contextActionService:UnbindAction("RbxCameraGamepadZoom")

	if vrService.VREnabled then
		contextActionService:UnbindAction("RbxCameraGamepadReset")
	end

	for _, v in pairs(t1) do
		v:Disconnect()
	end

	t1 = {}
end
function module.getInputEnabled()
	return u54
end
function module.resetInputForFrameEnd()
	t4.Movement = Vector2.new()
	t5.Move = Vector2.new()
	t5.Pinch = 0
	t4.Wheel = 0
	t4.Pan = Vector2.new()
	t4.Pinch = 0
end

userInputService.WindowFocused:Connect(resetInputDevices)
userInputService.WindowFocusReleased:Connect(resetInputDevices)

if v10 then
	userInputService.TextBoxFocusReleased:Connect(resetInputDevices)
end

local u55: boolean = false
local u56 = false
local n6 = 0

function module.getHoldPan()
	return u55
end
function module.getTogglePan()
	return u56
end
function module.getPanning()
	return u56 or u55
end
function module.setTogglePan(p43)
	u56 = p43
end

local u58: boolean = false
local connection = nil
local connection2 = nil

function module.enableCameraToggleInput()
	if u58 then
		return
	end

	u58 = true
	u55 = false
	u56 = false

	if connection then
		connection:Disconnect()
	end

	if connection2 then
		connection2:Disconnect()
	end

	connection = bindableEventEvent:Connect(function()
		u55 = true
		n6 = tick()
	end)
	connection2 = bindableEvent2Event:Connect(function()
		u55 = false

		if tick() - n6 < 0.3 and (not not u56 or userInputService:GetMouseDelta().Magnitude < 2) then
			u56 = not u56
		end
	end)
end
function module.disableCameraToggleInput()
	if not u58 then
		return
	end

	u58 = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end
end

return module
