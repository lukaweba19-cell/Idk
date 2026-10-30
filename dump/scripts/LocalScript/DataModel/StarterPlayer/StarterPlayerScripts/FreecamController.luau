-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local mathAbs = math.abs
local mathClamp = math.clamp
local mathExp = math.exp
local mathRad = math.rad
local mathSign = math.sign
local mathSqrt = math.sqrt
local mathTan = math.tan
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local starterGui: StarterGui = game:GetService("StarterGui")
local userInputService: UserInputService = game:GetService("UserInputService")
local workspace: Workspace = game:GetService("Workspace")
local LocalPlayer: Player = players.LocalPlayer

if not LocalPlayer then
	players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = players.LocalPlayer
end

local CurrentCamera: Camera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local CurrentCamera2: Camera = workspace.CurrentCamera

	if CurrentCamera2 then
		CurrentCamera = CurrentCamera2
	end
end)

local freecam: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Freecam")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local HighValue = Enum.ContextActionPriority.High.Value
local n1 = Vector2.new(0.75, 1) * 8
local n2 = Enum.RenderPriority.Camera.Value + 5
local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p1, p2)
	local object = setmetatable({}, t1)

	object.f = p1
	object.p = p2
	object.v = p2 * 0

	return object
end
function t1.Update(p3, p4, p5)
	local n1 = p3.f * 2 * 3.141592653589793
	local v = p3.v
	local n2 = p5 - p3.p
	local v73 = mathExp(-n1 * p4)
	local n3 = p5 + (v * p4 - n2 * (n1 * p4 + 1)) * v73

	p3.p = n3
	p3.v = (n1 * p4 * (n2 * n1 - v) + v) * v73

	return n3
end
function t1.Reset(p6, p7)
	p6.p = p7
	p6.v = p7 * 0
end

local vector3 = Vector3.new()
local vector2 = Vector2.new()
local n3 = 0
local v27 = t1.new(1.5, (Vector3.new()))
local v28 = t1.new(1, Vector2.new())
local v29 = t1.new(4, 0)

local function fCurve(p8)
	return (mathExp(2 * p8) - 1) / 6.38905609893065
end
local function fDeadzone(p9)
	return (mathExp(2 * ((p9 - 0.15) / 0.85)) - 1) / 6.38905609893065
end
local function thumbstickCurve(p10)
	local v80 = mathSign(p10)
	local v81 = mathAbs(p10)
	local v82 = mathExp(2 * ((v81 - 0.15) / 0.85))
	local v83 = mathClamp((v82 - 1) / 6.38905609893065, 0, 1)

	return v80 * v83
end

local t2: {[any]: any} = {
	W = 0,
	A = 0,
	S = 0,
	D = 0,
	E = 0,
	Q = 0,
	U = 0,
	H = 0,
	J = 0,
	K = 0,
	I = 0,
	Y = 0,
	Up = 0,
	Down = 0,
	LeftShift = 0,
	RightShift = 0
}
local n4 = Vector2.new(1, 1) * 0.04908738521234052
local n5 = Vector2.new(1, 1) * 0.39269908169872414
local n6 = 1
local t3: {[any]: any} = {
	ButtonX = 0,
	ButtonY = 0,
	DPadDown = 0,
	DPadUp = 0,
	ButtonL2 = 0,
	ButtonR2 = 0,
	Thumbstick1 = Vector2.new(),
	Thumbstick2 = Vector2.new()
}
local t4: {[any]: any} = { MouseWheel = 0, Delta = Vector2.new() }

local function Keypress(_, p15, p16)
	t2[p16.KeyCode.Name] = if p15 == Enum.UserInputState.Begin then 1 else 0

	return Enum.ContextActionResult.Sink
end
local function GpButton(_, p18, p19)
	t3[p19.KeyCode.Name] = if p18 == Enum.UserInputState.Begin then 1 else 0

	return Enum.ContextActionResult.Sink
end
local function MousePan(_, _, p22)
	local delta = p22.Delta

	t4.Delta = Vector2.new(-delta.Y, -delta.X)

	return Enum.ContextActionResult.Sink
end
local function Thumb(_, _, p25)
	t3[p25.KeyCode.Name] = p25.Position

	return Enum.ContextActionResult.Sink
end
local function Trigger(_, _, p28)
	t3[p28.KeyCode.Name] = p28.Position.Z

	return Enum.ContextActionResult.Sink
end
local function MouseWheel(_, _, p31)
	t4[p31.UserInputType.Name] = -p31.Position.Z

	return Enum.ContextActionResult.Sink
end
local function Zero(p32)
	for k, v in pairs(p32) do
		p32[k] = v * 0
	end
end
local function GetFocusDistance(p33)
	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize
	local n1 = mathTan(n3 / 2) * 2
	local n2 = currentCameraViewportSize.X / currentCameraViewportSize.Y * n1
	local rightVector = p33.RightVector
	local upVector = p33.UpVector
	local lookVector = p33.LookVector
	local vector32 = Vector3.new()
	local n7 = 512

	for i = 0, 1, 0.5 do
		for j = 0, 1, 0.5 do
			local n4 = rightVector * ((i - 0.5) * n2) - upVector * ((j - 0.5) * n1) + lookVector
			local n5 = p33.Position + n4 * 0.1
			local n6 = n4.Unit * n7
			local v120 = workspace:Raycast(n5, n6)

			v120 = ((v120 and v120.Position or n5 + n6) - n5).Magnitude

			if n7 > v120 then
				n7 = v120
				vector32 = n4.Unit
			end
		end
	end

	return lookVector:Dot(vector32) * n7
end

local t5: {[any]: any} = {
	Vel = function(p11)
		n6 = mathClamp(n6 + p11 * (t2.Up - t2.Down) * 0.75, 0.01, 4)

		local v122 = thumbstickCurve(t3.Thumbstick1.X)
		local v123 = thumbstickCurve(t3.ButtonR2)
		local v124 = thumbstickCurve(t3.ButtonL2)
		local vector33 = Vector3.new(v122, v123 - v124, thumbstickCurve(-t3.Thumbstick1.Y))
		local vector34 = Vector3.new(t2.D - t2.A + t2.K - t2.H, t2.E - t2.Q + t2.I - t2.Y, t2.S - t2.W + t2.J - t2.U)

		v122 = userInputService:IsKeyDown(Enum.KeyCode.LeftShift) or userInputService:IsKeyDown(Enum.KeyCode.RightShift)

		return (vector33 * Vector3.new(1, 1, 1) + vector34 * Vector3.new(1, 1, 1)) * (n6 * (if v122 then 0.25 else 1))
	end,
	Pan = function(_)
		local vector2New = Vector2.new
		local v129 = thumbstickCurve(t3.Thumbstick2.Y)
		local vector2 = vector2New(v129, thumbstickCurve(-t3.Thumbstick2.X))
		local n1 = t4.Delta * n4

		t4.Delta = Vector2.new()

		return vector2 * n5 + n1
	end,
	Fov = function(_)
		local n1 = (t3.ButtonX - t3.ButtonY) * 0.25
		local n2 = t4.MouseWheel * 1

		t4.MouseWheel = 0

		return n1 + n2
	end,
	StartCapture = function()
		contextActionService:BindActionAtPriority("FreecamMD_Keyboard", Keypress, false, HighValue, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down)
		contextActionService:BindActionAtPriority("FreecamMD_MousePan", MousePan, false, HighValue, Enum.UserInputType.MouseMovement)
		contextActionService:BindActionAtPriority("FreecamMD_MouseWheel", MouseWheel, false, HighValue, Enum.UserInputType.MouseWheel)
		contextActionService:BindActionAtPriority("FreecamMD_GamepadButton", GpButton, false, HighValue, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
		contextActionService:BindActionAtPriority("FreecamMD_GamepadTrigger", Trigger, false, HighValue, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
		contextActionService:BindActionAtPriority("FreecamMD_GamepadThumbstick", Thumb, false, HighValue, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
	end,
	StopCapture = function()
		n6 = 1

		local v135: {[any]: any} = t3

		for k, v in pairs(v135) do
			v135[k] = v * 0
		end

		v135 = t2

		for k, v in pairs(v135) do
			v135[k] = v * 0
		end

		v135 = t4

		for k, v in pairs(v135) do
			v135[k] = v * 0
		end

		contextActionService:UnbindAction("FreecamMD_Keyboard")
		contextActionService:UnbindAction("FreecamMD_MousePan")
		contextActionService:UnbindAction("FreecamMD_MouseWheel")
		contextActionService:UnbindAction("FreecamMD_GamepadButton")
		contextActionService:UnbindAction("FreecamMD_GamepadTrigger")
		contextActionService:UnbindAction("FreecamMD_GamepadThumbstick")
		inputMap.reconcile()
	end
}

local function StepFreecam(p34)
	local v143 = v27:Update(p34, t5.Vel(p34))
	local v144 = v28:Update(p34, t5.Pan(p34))
	local v145 = v29:Update(p34, t5.Fov(p34))
	local v146 = mathRad(n3 / 2)
	local v147 = mathTan(v146)
	local v148 = mathSqrt(0.7002075382097097 / v147)

	n3 = mathClamp(n3 + v145 * 300 * (p34 / v148), 1, 120)
	vector2 += v144 * n1 * (p34 / v148)

	local vector2New = Vector2.new

	v147 = mathClamp(vector2.X, -1.5707963267948966, 1.5707963267948966)
	vector2 = vector2New(v147, vector2.Y % 6.283185307179586)

	local cFrame = CFrame.new(vector3)

	v146 = CFrame.fromOrientation(vector2.X, vector2.Y, 0)

	local cFrame2 = CFrame.new(v143 * Vector3.new(64, 64, 64) * p34)

	v148 = cFrame * v146 * cFrame2
	vector3 = v148.Position
	CurrentCamera.CFrame = v148

	local v152: Camera = CurrentCamera
	local cFrameNew = CFrame.new
	local v154 = GetFocusDistance(v148)

	v146 = cFrameNew(0, 0, -v154)
	v152.Focus = v148 * v146
	CurrentCamera.FieldOfView = n3
end

local MouseBehavior = nil
local MouseIconEnabled = nil
local CameraType = nil
local Focus = nil
local CFrame = nil
local FieldOfView = nil
local t6: {[any]: any} = {}
local t7: {[any]: any} = { Backpack = true, Chat = true, Health = true, PlayerList = true }
local t8: {[any]: any} = { BadgesNotificationsActive = true, PointsNotificationsActive = true }
local u58: boolean = false

local t9: {[any]: any} = {
	Push = function()
		for iterKey in pairs(t7) do
			t7[iterKey] = starterGui:GetCoreGuiEnabled(Enum.CoreGuiType[iterKey])
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType[iterKey], false)
		end

		for iterKey2 in pairs(t8) do
			local ok, result = pcall(starterGui.GetCore, starterGui, iterKey2)

			if ok then
				t8[iterKey2] = result
			end

			pcall(starterGui.SetCore, starterGui, iterKey2, false)
		end

		t6 = {}
		local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if playerGui then
			for iterFirst, iterSecond in playerGui:GetChildren() do
				if iterSecond:IsA("ScreenGui") and iterSecond.Enabled and not iterSecond.Name:lower():find("cmdr") and iterSecond.Name ~= "Notifications" then
					t6[#t6 + 1] = iterSecond
					iterSecond.Enabled = false
				end
			end
		end

		FieldOfView = CurrentCamera.FieldOfView
		CameraType = CurrentCamera.CameraType
		CFrame = CurrentCamera.CFrame
		Focus = CurrentCamera.Focus
		CurrentCamera.FieldOfView = 70
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		MouseIconEnabled = userInputService.MouseIconEnabled
		MouseBehavior = userInputService.MouseBehavior
		userInputService.MouseIconEnabled = false
		userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	end,
	Pop = function()
		for k, v in pairs(t7) do
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v)
		end

		for k, v in pairs(t8) do
			pcall(starterGui.SetCore, starterGui, k, v)
		end

		for key, value in t6 do
			if value.Parent then
				value.Enabled = true
			end
		end

		t6 = {}
		CurrentCamera.FieldOfView = FieldOfView or 70
		CurrentCamera.CameraType = CameraType or Enum.CameraType.Custom

		if CFrame then
			CurrentCamera.CFrame = CFrame
		end

		if Focus then
			CurrentCamera.Focus = Focus
		end

		FieldOfView = nil
		CameraType = nil
		CFrame = nil
		Focus = nil

		if MouseIconEnabled ~= nil then
			userInputService.MouseIconEnabled = MouseIconEnabled
		end

		if MouseBehavior ~= nil then
			userInputService.MouseBehavior = MouseBehavior
		end

		MouseIconEnabled = nil
		MouseBehavior = nil
	end
}

local function StartFreecam()
	if u58 then
		return
	end

	u58 = true
	LocalPlayer:SetAttribute("FreecamActive", true)

	local currentCameraCFrame: CFrame = CurrentCamera.CFrame

	vector2 = Vector2.new(currentCameraCFrame:ToEulerAnglesYXZ())
	vector3 = currentCameraCFrame.Position
	n3 = CurrentCamera.FieldOfView
	v27:Reset((Vector3.new()))
	v28:Reset(Vector2.new())
	v29:Reset(0)
	t9.Push()
	runService:BindToRenderStep("FreecamMD", n2, StepFreecam)
	t5.StartCapture()
end
local function StopFreecam()
	if not u58 then
		return
	end

	u58 = false
	LocalPlayer:SetAttribute("FreecamActive", false)
	t5.StopCapture()
	pcall(function()
		runService:UnbindFromRenderStep("FreecamMD")
	end)
	t9.Pop()
end
local function ToggleFreecam()
	if u58 then
		StopFreecam()

		return
	end

	StartFreecam()
end

freecam.OnClientEvent:Connect(function(p35)
	if p35 ~= nil then
		if p35 then
			StartFreecam()

			return
		end

		StopFreecam()

		return
	end

	if u58 then
		StopFreecam()

		return
	end

	StartFreecam()
end)
