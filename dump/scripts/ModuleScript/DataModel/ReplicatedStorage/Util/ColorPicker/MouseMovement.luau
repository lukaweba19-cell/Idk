-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local module: {[any]: any} = {}

module.__index = module

function module.new(callbackFunc)
	local object = setmetatable({}, module)

	object.CallbackFunc = callbackFunc
	object.Connected = false

	return object
end
function module.Connect(p2, ...)
	if p2.Connected then
		return
	end

	p2.Connected = true
	p2.CallbackFunc(...)

	local t2: {[any]: any} = { ... }

	p2._mouseMovement = userInputService.InputChanged:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			p2.CallbackFunc(table.unpack(t2))
		end
	end)
	p2._mouseUp = userInputService.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if p2.DisconnectCallback then
				p2.DisconnectCallback()
			end

			p2:Disconnect()
		end
	end)
end
function module.Disconnect(p5)
	p5.Connected = false

	if p5._mouseMovement then
		p5._mouseMovement:Disconnect()
		p5._mouseMovement = nil
	end

	if p5._mouseUp then
		p5._mouseUp:Disconnect()
		p5._mouseUp = nil
	end
end
function module.OnDisconnect(p6, disconnectCallback)
	p6.DisconnectCallback = disconnectCallback
end
function module.Destroy(p8)
	p8:Disconnect()
end

return module
