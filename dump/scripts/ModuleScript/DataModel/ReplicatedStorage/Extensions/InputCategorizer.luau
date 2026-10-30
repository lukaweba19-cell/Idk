-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local t1: {[any]: any} = {
	KeyboardAndMouse = "KeyboardAndMouse",
	Gamepad = "Gamepad",
	Touch = "Touch",
	Unknown = "Unknown"
}
local module: {[any]: any} = {
	_initialized = false,
	InputCategory = t1,
	lastInputCategoryChanged = bindableEvent.Event,
	_lastInputCategory = t1.Unknown
}

function module.getLastInputCategory()
	return module._lastInputCategory
end
function module._setLastInputCategory(p1)
	if p1 ~= module._lastInputCategory then
		module._lastInputCategory = p1
		bindableEvent:Fire(p1)
	end
end
function module._getCategoryOfInputType(p2)
	if string.find(p2.Name, "Gamepad") then
		return t1.Gamepad
	end

	if p2 == Enum.UserInputType.Keyboard or string.find(p2.Name, "Mouse") then
		return t1.KeyboardAndMouse
	end

	if p2 == Enum.UserInputType.Touch then
		return t1.Touch
	end

	return t1.Unknown
end
function module._onInputTypeChanged(p3)
	local v8 = module._getCategoryOfInputType(p3)

	if v8 ~= t1.Unknown then
		module._setLastInputCategory(v8)
	end
end
function module._getDefaultInputCategory()
	local v9: Enum.UserInputType = userInputService:GetLastInputType()
	local v10 = module._getCategoryOfInputType(v9)

	if v10 ~= t1.Unknown then
		return v10
	end

	if userInputService.KeyboardEnabled and userInputService.MouseEnabled then
		return t1.KeyboardAndMouse
	end

	if userInputService.TouchEnabled then
		return t1.Touch
	end

	if userInputService.GamepadEnabled then
		return t1.Gamepad
	end

	return t1.Unknown
end
function module._initialize()
	assert(not module._initialized, "InputCategorizer already initialized!")
	userInputService.LastInputTypeChanged:Connect(module._onInputTypeChanged)
	module._setLastInputCategory(module._getDefaultInputCategory())
	module._initialized = true
end

module._initialize()

return module
