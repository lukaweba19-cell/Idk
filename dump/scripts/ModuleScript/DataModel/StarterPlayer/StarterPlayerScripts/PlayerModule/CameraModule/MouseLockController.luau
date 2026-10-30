-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local MediumValue = Enum.ContextActionPriority.Medium.Value
local players: Players = game:GetService("Players")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local userInputService: UserInputService = game:GetService("UserInputService")
local gameSettings = UserSettings().GameSettings
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local v9 = flagUtil.getUserFlag("UserFixStuckShiftLock")
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local object = setmetatable({}, module)

	object.isMouseLocked = false
	object.savedMouseCursor = nil
	object.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }
	object.mouseLockToggledEvent = Instance.new("BindableEvent")

	local boundKeys = script:FindFirstChild("BoundKeys")

	if not boundKeys or not boundKeys:IsA("StringValue") then
		if boundKeys then
			boundKeys:Destroy()
		end

		boundKeys = Instance.new("StringValue")
		assert(boundKeys, "")
		boundKeys.Name = "BoundKeys"
		boundKeys.Value = "LeftShift,RightShift"
		boundKeys.Parent = script
	end

	if boundKeys then
		boundKeys.Changed:Connect(function(p1)
			object:OnBoundKeysObjectChanged(p1)
		end)
		object:OnBoundKeysObjectChanged(boundKeys.Value)
	end

	gameSettings.Changed:Connect(function(p2)
		if p2 == "ControlMode" or p2 == "ComputerMovementMode" then
			object:UpdateMouseLockAvailability()
		end
	end)
	players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
		object:UpdateMouseLockAvailability()
	end)
	players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
		object:UpdateMouseLockAvailability()
	end)
	userInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
		object:UpdateMouseLockAvailability()
	end)
	object:UpdateMouseLockAvailability()

	return object
end
function module.GetIsMouseLocked(p3)
	return p3.isMouseLocked
end
function module.GetBindableToggleEvent(p4)
	return p4.mouseLockToggledEvent.Event
end
function module.GetMouseLockOffset(_)
	return Vector3.new(1.75, 0, 0)
end
function module.UpdateMouseLockAvailability(p6)
	local u17: boolean = userInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and players.LocalPlayer.DevEnableMouseLock and gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and gameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and players.LocalPlayer.DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable

	if u17 ~= p6.enabled then
		p6:EnableMouseLock(u17)
	end
end
function module.OnBoundKeysObjectChanged(p7, p8)
	p7.boundKeys = {}

	for iterValue in string.gmatch(p8, "[^%s,]+") do
		for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
			if iterValue == v.Name then
				p7.boundKeys[#p7.boundKeys + 1] = v

				break
			end
		end
	end

	p7:UnbindContextActions()
	p7:BindContextActions()
end
function module.OnMouseLockToggled(p9)
	p9.isMouseLocked = not p9.isMouseLocked

	if p9.isMouseLocked then
		local cursorImage: Instance = script:FindFirstChild("CursorImage")

		if cursorImage and cursorImage:IsA("StringValue") and cursorImage.Value then
			cameraUtils.setMouseIconOverride(cursorImage.Value)
		else
			if cursorImage then
				cursorImage:Destroy()
			end

			local cursorImage: StringValue = Instance.new("StringValue")

			assert(cursorImage, "")
			cursorImage.Name = "CursorImage"
			cursorImage.Value = "rbxasset://textures/MouseLockedCursor.png"
			cursorImage.Parent = script
			cameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
		end
	else
		cameraUtils.restoreMouseIcon()
	end

	p9.mouseLockToggledEvent:Fire()
end
function module.DoMouseLockSwitch(p10, _, p12, _)
	if p12 == Enum.UserInputState.Begin then
		p10:OnMouseLockToggled()

		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end
function module.BindContextActions(p14)
	contextActionService:BindActionAtPriority("MouseLockSwitchAction", function(p15, p16, p17)
		return p14:DoMouseLockSwitch(p15, p16, p17)
	end, false, MediumValue, unpack(p14.boundKeys))
end
function module.UnbindContextActions(_)
	contextActionService:UnbindAction("MouseLockSwitchAction")
end
function module.IsMouseLocked(p19)
	return p19.enabled and p19.isMouseLocked
end
function module.EnableMouseLock(p20, p21)
	if p21 ~= p20.enabled then
		p20.enabled = p21

		if p20.enabled then
			p20:BindContextActions()

			return
		end

		cameraUtils.restoreMouseIcon()
		p20:UnbindContextActions()

		if not v9 then
			if p20.isMouseLocked then
				p20.mouseLockToggledEvent:Fire()
			end

			p20.isMouseLocked = false
		elseif p20.isMouseLocked then
			p20.isMouseLocked = false
			p20.mouseLockToggledEvent:Fire()

			return
		end

		return
	end
end

return module
