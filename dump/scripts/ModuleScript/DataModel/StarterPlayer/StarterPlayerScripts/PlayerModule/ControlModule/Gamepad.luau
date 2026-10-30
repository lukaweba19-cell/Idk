-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")

script.Parent.Parent:WaitForChild("CommonUtils")

local none = Enum.UserInputType.None
local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new(control_action_priority)
	local v7 = baseCharacterController.new()
	local object2 = setmetatable(v7, object)

	object2.CONTROL_ACTION_PRIORITY = control_action_priority
	object2.forwardValue = 0
	object2.backwardValue = 0
	object2.leftValue = 0
	object2.rightValue = 0
	object2.activeGamepad = none
	object2.gamepadConnectedConn = nil
	object2.gamepadDisconnectedConn = nil

	return object2
end
function object.Enable(p2, p3)
	if p3 == p2.enabled then
		return true
	end

	p2.forwardValue = 0
	p2.backwardValue = 0
	p2.leftValue = 0
	p2.rightValue = 0
	p2.moveVector = Vector3.new(0, 0, 0)
	p2.isJumping = false

	if p3 then
		p2.activeGamepad = p2:GetHighestPriorityGamepad()

		if p2.activeGamepad == none then
			return false
		end

		p2:BindContextActions()
		p2:ConnectGamepadConnectionListeners()
	else
		p2:UnbindContextActions()
		p2:DisconnectGamepadConnectionListeners()
		p2.activeGamepad = none
	end

	p2.enabled = p3

	return true
end
function object.GetHighestPriorityGamepad(_)
	local v12 = userInputService:GetConnectedGamepads()
	local v13 = none

	for _, v in pairs(v12) do
		if v.Value < v13.Value then
			v13 = v
		end
	end

	return v13
end
function object.BindContextActions(p5)
	if p5.activeGamepad == none then
		return false
	end

	contextActionService:BindActivate(p5.activeGamepad, Enum.KeyCode.ButtonR2)
	contextActionService:BindActionAtPriority("jumpAction", function(_, p7, _)
		p5.isJumping = p7 == Enum.UserInputState.Begin

		return Enum.ContextActionResult.Sink
	end, false, p5.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
	contextActionService:BindActionAtPriority("moveThumbstick", function(_, p10, input)
		if p10 == Enum.UserInputState.Cancel then
			p5.moveVector = Vector3.new(0, 0, 0)

			return Enum.ContextActionResult.Sink
		end

		if p5.activeGamepad ~= input.UserInputType then
			return Enum.ContextActionResult.Pass
		end

		if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
			return
		end

		if input.Position.magnitude > 0.2 then
			p5.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)
		else
			p5.moveVector = Vector3.new(0, 0, 0)
		end

		return Enum.ContextActionResult.Sink
	end, false, p5.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)

	return true
end
function object.UnbindContextActions(p12)
	if p12.activeGamepad ~= none then
		contextActionService:UnbindActivate(p12.activeGamepad, Enum.KeyCode.ButtonR2)
	end

	contextActionService:UnbindAction("moveThumbstick")
	contextActionService:UnbindAction("jumpAction")
end
function object.OnNewGamepadConnected(p13)
	local v19 = p13:GetHighestPriorityGamepad()

	if v19 == p13.activeGamepad then
		return
	end

	if v19 == none then
		warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
		p13:UnbindContextActions()

		return
	end

	if p13.activeGamepad ~= none then
		p13:UnbindContextActions()
	end

	p13.activeGamepad = v19
	p13:BindContextActions()
end
function object.OnCurrentGamepadDisconnected(p14)
	if p14.activeGamepad ~= none then
		contextActionService:UnbindActivate(p14.activeGamepad, Enum.KeyCode.ButtonR2)
	end

	local v21 = p14:GetHighestPriorityGamepad()

	if p14.activeGamepad ~= none and v21 == p14.activeGamepad then
		warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
		p14:UnbindContextActions()
		p14.activeGamepad = none

		return
	end

	if v21 == none then
		p14:UnbindContextActions()
		p14.activeGamepad = none

		return
	end

	p14.activeGamepad = v21
	contextActionService:BindActivate(p14.activeGamepad, Enum.KeyCode.ButtonR2)
end
function object.ConnectGamepadConnectionListeners(p15)
	p15.gamepadConnectedConn = userInputService.GamepadConnected:Connect(function(gamepadNum: Enum.UserInputType)
		p15:OnNewGamepadConnected()
	end)
	p15.gamepadDisconnectedConn = userInputService.GamepadDisconnected:Connect(function(gamepadNum: Enum.UserInputType)
		if gamepadNum == p15.activeGamepad then
			p15:OnCurrentGamepadDisconnected()
		end
	end)
end
function object.DisconnectGamepadConnectionListeners(p18)
	if p18.gamepadConnectedConn then
		p18.gamepadConnectedConn:Disconnect()
		p18.gamepadConnectedConn = nil
	end

	if p18.gamepadDisconnectedConn then
		p18.gamepadDisconnectedConn:Disconnect()
		p18.gamepadDisconnectedConn = nil
	end
end

return object
