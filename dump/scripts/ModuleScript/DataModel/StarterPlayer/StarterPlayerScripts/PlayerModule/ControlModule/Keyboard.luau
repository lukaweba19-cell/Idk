-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")

game:GetService("ContextActionService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

script.Parent.Parent:WaitForChild("CommonUtils")

local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local vector3 = Vector3.new()
local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new(control_action_priority)
	local v9 = baseCharacterController.new()
	local object2 = setmetatable(v9, object)

	object2.CONTROL_ACTION_PRIORITY = control_action_priority
	object2.forwardValue = 0
	object2.backwardValue = 0
	object2.leftValue = 0
	object2.rightValue = 0
	object2.jumpEnabled = true

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
	p2.moveVector = vector3
	p2.jumpRequested = false
	p2:UpdateJump()

	if p3 then
		p2:BindContextActions()
		p2:ConnectFocusEventListeners()
	else
		p2._connectionUtil:disconnectAll()
	end

	p2.enabled = p3

	return true
end
function object.UpdateMovement(p4, p5)
	if p5 == Enum.UserInputState.Cancel then
		p4.moveVector = vector3

		return
	end

	p4.moveVector = Vector3.new(p4.leftValue + p4.rightValue, 0, p4.forwardValue + p4.backwardValue)
end
function object.UpdateJump(p6)
	p6.isJumping = p6.jumpRequested
end
function object.BindContextActions(p7)
	local function v17(p8, _)
		p7.forwardValue = if p8 == Enum.UserInputState.Begin then -1 else 0
		p7:UpdateMovement(p8)

		return Enum.ContextActionResult.Pass
	end
	local function v18(p10, _)
		p7.backwardValue = if p10 == Enum.UserInputState.Begin then 1 else 0
		p7:UpdateMovement(p10)

		return Enum.ContextActionResult.Pass
	end
	local function v19(p12, _)
		p7.leftValue = if p12 == Enum.UserInputState.Begin then -1 else 0
		p7:UpdateMovement(p12)

		return Enum.ContextActionResult.Pass
	end
	local function v20(p14, _)
		p7.rightValue = if p14 == Enum.UserInputState.Begin then 1 else 0
		p7:UpdateMovement(p14)

		return Enum.ContextActionResult.Pass
	end
	local function v21(p16, _)
		p7.jumpRequested = p7.jumpEnabled and p16 == Enum.UserInputState.Begin
		p7:UpdateJump()

		return Enum.ContextActionResult.Pass
	end

	local t1: {[any]: any} = {
		priority = p7.CONTROL_ACTION_PRIORITY,
		result = Enum.ContextActionResult.Pass
	}

	inputMap.bind("MoveForward", v17, t1)
	inputMap.bind("MoveBackward", v18, t1)
	inputMap.bind("MoveLeft", v19, t1)
	inputMap.bind("MoveRight", v20, t1)
	inputMap.bind("Jump", v21, t1)
	p7._connectionUtil:trackBoundFunction("moveForwardAction", function()
		inputMap.unbind("MoveForward", v17)
	end)
	p7._connectionUtil:trackBoundFunction("moveBackwardAction", function()
		inputMap.unbind("MoveBackward", v18)
	end)
	p7._connectionUtil:trackBoundFunction("moveLeftAction", function()
		inputMap.unbind("MoveLeft", v19)
	end)
	p7._connectionUtil:trackBoundFunction("moveRightAction", function()
		inputMap.unbind("MoveRight", v20)
	end)
	p7._connectionUtil:trackBoundFunction("jumpAction", function()
		inputMap.unbind("Jump", v21)
	end)
end
function object.ConnectFocusEventListeners(p18)
	local function onFocusReleased()
		p18.moveVector = vector3
		p18.forwardValue = 0
		p18.backwardValue = 0
		p18.leftValue = 0
		p18.rightValue = 0
		p18.jumpRequested = false
		p18:UpdateJump()
	end

	p18._connectionUtil:trackConnection("textBoxFocusReleased", userInputService.TextBoxFocusReleased:Connect(onFocusReleased))
	p18._connectionUtil:trackConnection("textBoxFocused", userInputService.TextBoxFocused:Connect(function(textboxFocused: TextBox)
		p18.jumpRequested = false
		p18:UpdateJump()
	end))
	p18._connectionUtil:trackConnection("windowFocusReleased", userInputService.WindowFocused:Connect(onFocusReleased))
end

return object
