-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local guiService: GuiService = game:GetService("GuiService")
local userInputService: UserInputService = game:GetService("UserInputService")
local runService: RunService = game:GetService("RunService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local gamepadSelectionHighlight: ImageLabel = Instance.new("ImageLabel")

gamepadSelectionHighlight.Name = "GamepadSelectionHighlight"
gamepadSelectionHighlight.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
gamepadSelectionHighlight.BackgroundTransparency = 0.7
gamepadSelectionHighlight.BorderSizePixel = 0
gamepadSelectionHighlight.Size = UDim2.new(1, 4, 1, 4)
gamepadSelectionHighlight.Position = UDim2.new(0, -2, 0, -2)
gamepadSelectionHighlight.ScaleType = Enum.ScaleType.Slice
gamepadSelectionHighlight.Image = ""

local uiCorner: UICorner = Instance.new("UICorner")

uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = gamepadSelectionHighlight

local uiStroke: UIStroke = Instance.new("UIStroke")

uiStroke.Color = Color3.fromRGB(100, 180, 255)
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = gamepadSelectionHighlight

local module: {[any]: any} = {}

module.__index = module

function module.new(p1)
	local object = setmetatable({}, module)

	object._scrollFrame = p1.scrollFrame
	object._windowFrame = p1.windowFrame
	object._closeButton = p1.closeButton
	object._closeFn = p1.closeFn
	object._prefix = p1.actionPrefix
	object._rows = {}
	object._active = false
	object._dpadHoldDir = 0
	object._dpadHoldEntry = nil
	object._thumbHoldDir = 0
	object._thumbHoldEntry = nil
	object._dpadAccum = 0
	object._thumbAccum = 0
	object._uisConns = {}
	object._heartbeatConn = nil
	object._bBound = false

	return object
end
function module._createProxy(_, parent)
	local gamepadProxy: TextButton = Instance.new("TextButton")

	gamepadProxy.Name = "GamepadProxy"
	gamepadProxy.Text = ""
	gamepadProxy.BackgroundTransparency = 1
	gamepadProxy.BorderSizePixel = 0
	gamepadProxy.Size = UDim2.new(1, 0, 1, 0)
	gamepadProxy.Position = UDim2.new(0, 0, 0, 0)
	gamepadProxy.ZIndex = 0
	gamepadProxy.Selectable = true
	gamepadProxy.Active = false
	gamepadProxy.Interactable = false
	gamepadProxy.SelectionImageObject = gamepadSelectionHighlight
	gamepadProxy.Parent = parent

	return gamepadProxy
end
function module.addSlider(p4, p5, p6)
	local v17 = p4:_createProxy(p5)
	local t2: {[any]: any} = { kind = "slider", frame = p5, proxy = v17, adjustSlider = p6 }

	p4:_wireActivated(t2)
	table.insert(p4._rows, t2)

	return v17
end
function module.addToggle(p7, p8, p9)
	local v22 = p7:_createProxy(p8)
	local t3: {[any]: any} = { kind = "toggle", frame = p8, proxy = v22, fireToggle = p9 }

	p7:_wireActivated(t3)
	table.insert(p7._rows, t3)

	return v22
end
function module.addButton(p10, p11, p12)
	local v27 = p10:_createProxy(p11)
	local t4: {[any]: any} = { kind = "button", frame = p11, proxy = v27, firePress = p12 }

	p10:_wireActivated(t4)
	table.insert(p10._rows, t4)

	return v27
end
function module._wireActivated(_, p14)
	p14.proxy.Activated:Connect(function()
		if p14.kind == "toggle" and p14.fireToggle then
			p14.fireToggle()
		elseif p14.kind == "button" and p14.firePress then
			p14.firePress()
		end
	end)
end
function module.rechain(p15)
	local t5: {[any]: any} = {}

	for _, v in ipairs(p15._rows) do
		if v.frame.Visible then
			table.insert(t5, v)
		end
	end

	table.sort(t5, function(p16, p17)
		return p16.frame.LayoutOrder < p17.frame.LayoutOrder
	end)

	for i, v in ipairs(t5) do
		local v37 = t5[i - 1]
		local v38 = t5[i + 1]

		v.proxy.NextSelectionUp = if v37 then v37.proxy else p15._closeButton or nil
		v.proxy.NextSelectionDown = if v38 then v38.proxy else nil
		v.proxy.NextSelectionLeft = v.proxy
		v.proxy.NextSelectionRight = v.proxy
	end

	if p15._closeButton and #t5 > 0 then
		p15._closeButton.NextSelectionDown = t5[1].proxy
		p15._closeButton.NextSelectionLeft = p15._closeButton
		p15._closeButton.NextSelectionRight = p15._closeButton
		p15._closeButton.SelectionImageObject = gamepadSelectionHighlight
	end
end
function module._getSelectedEntry(p18)
	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if not guiServiceSelectedObject then
		return nil
	end

	for _, v in ipairs(p18._rows) do
		if guiServiceSelectedObject == v.proxy then
			return v
		end
	end

	return nil
end
function module.activate(p19)
	if p19._active then
		return
	end

	p19._active = true

	for _, v in ipairs(p19._rows) do
		v.proxy.Interactable = true
	end

	p19:rechain()
	p19:_bindB()
	p19:_bindUIS()
	p19:_bindHeartbeat()

	for _, v in ipairs(p19._rows) do
		if v.frame.Visible then
			guiService.SelectedObject = v.proxy

			return
		end
	end
end
function module.deactivate(p20)
	if not p20._active then
		return
	end

	p20._active = false

	for _, v in ipairs(p20._rows) do
		v.proxy.Interactable = false
	end

	p20:_unbindB()
	p20:_unbindUIS()
	p20:_unbindHeartbeat()
	p20._dpadHoldDir = 0
	p20._dpadHoldEntry = nil
	p20._thumbHoldDir = 0
	p20._thumbHoldEntry = nil

	if guiService.SelectedObject then
		for _, v in ipairs(p20._rows) do
			if guiService.SelectedObject == v.proxy then
				guiService.SelectedObject = nil

				return
			end
		end

		return
	end
end
function module._bindB(p21)
	if p21._bBound then
		return
	end

	p21._bBound = true

	local _windowFrame = p21._windowFrame
	local _closeFn = p21._closeFn

	contextActionService:BindActionAtPriority(p21._prefix .. "_CloseB", function(_, p23, input)
		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return Enum.ContextActionResult.Pass
		end

		if not _windowFrame.Visible then
			return Enum.ContextActionResult.Pass
		end

		if p23 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Sink
		end

		if _closeFn then
			_closeFn()
		end

		return Enum.ContextActionResult.Sink
	end, false, 4000, Enum.KeyCode.ButtonB)
end
function module._unbindB(p25)
	if not p25._bBound then
		return
	end

	p25._bBound = false
	contextActionService:UnbindAction(p25._prefix .. "_CloseB")
end
function module._bindUIS(p26)
	local _windowFrame = p26._windowFrame

	table.insert(p26._uisConns, userInputService.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		if not _windowFrame.Visible then
			return
		end

		local v76 = p26:_getSelectedEntry()

		if not v76 then
		elseif input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.DPadRight then
			local n1: number = if input.KeyCode == Enum.KeyCode.DPadLeft then -1 else 1

			if v76.kind == "slider" and v76.adjustSlider then
				v76.adjustSlider(n1)
				p26._dpadHoldDir = n1
				p26._dpadHoldEntry = v76
			elseif v76.kind == "toggle" and v76.fireToggle then
				v76.fireToggle()
			end

			return
		end
	end))
	table.insert(p26._uisConns, userInputService.InputEnded:Connect(function(input: InputObject)
		if input.KeyCode == Enum.KeyCode.DPadLeft or input.KeyCode == Enum.KeyCode.DPadRight then
			p26._dpadHoldDir = 0
			p26._dpadHoldEntry = nil
		end
	end))
	table.insert(p26._uisConns, userInputService.InputChanged:Connect(function(input: InputObject)
		if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return
		end

		if not _windowFrame.Visible then
			return
		end

		local x = input.Position.X

		if math.abs(x) <= 0.5 then
			p26._thumbHoldDir = 0
			p26._thumbHoldEntry = nil

			return
		end

		local v81 = p26:_getSelectedEntry()

		if not v81 then
			p26._thumbHoldDir = 0
			p26._thumbHoldEntry = nil

			return
		end

		if v81.kind == "slider" and v81.adjustSlider then
			local n1: number = if x > 0 then 1 else -1

			if n1 ~= p26._thumbHoldDir or v81 ~= p26._thumbHoldEntry then
				v81.adjustSlider(n1)
			end

			p26._thumbHoldDir = n1
			p26._thumbHoldEntry = v81

			return
		end

		p26._thumbHoldDir = 0
		p26._thumbHoldEntry = nil
	end))
end
function module._unbindUIS(p30)
	for _, v in ipairs(p30._uisConns) do
		v:Disconnect()
	end

	table.clear(p30._uisConns)
end
function module._bindHeartbeat(p31)
	if p31._heartbeatConn then
		return
	end

	local _windowFrame = p31._windowFrame

	p31._heartbeatConn = runService.Heartbeat:Connect(function(deltaTime: number)
		if not _windowFrame.Visible then
			return
		end

		if p31._dpadHoldDir == 0 or not p31._dpadHoldEntry or not p31._dpadHoldEntry.adjustSlider then
			p31._dpadAccum = 0
		else
			local v84 = p31

			v84._dpadAccum = v84._dpadAccum + deltaTime * 8

			while p31._dpadAccum >= 1 do
				local v85 = p31

				v85._dpadAccum = v85._dpadAccum - 1
				p31._dpadHoldEntry.adjustSlider(p31._dpadHoldDir)
			end
		end

		if p31._thumbHoldDir ~= 0 and p31._thumbHoldEntry and p31._thumbHoldEntry.adjustSlider then
			local ok, result = pcall(function()
				return userInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
			end)

			if ok then
				local n1 = 0

				for _, v in ipairs(result) do
					if v.KeyCode == Enum.KeyCode.Thumbstick1 then
						n1 = v.Position.X

						break
					end
				end

				if math.abs(n1) <= 0.5 then
					p31._thumbHoldDir = 0
					p31._thumbHoldEntry = nil
					p31._thumbAccum = 0

					return
				end

				local v91 = p31

				v91._thumbAccum = v91._thumbAccum + deltaTime * 24

				while p31._thumbAccum >= 1 do
					local v92 = p31

					v92._thumbAccum = v92._thumbAccum - 1
					p31._thumbHoldEntry.adjustSlider(p31._thumbHoldDir)
				end
			end
		else
			p31._thumbAccum = 0
		end
	end)
end
function module._unbindHeartbeat(p33)
	if p33._heartbeatConn then
		p33._heartbeatConn:Disconnect()
		p33._heartbeatConn = nil
	end
end
function module.getSelectionImage(_)
	return gamepadSelectionHighlight
end
function module.getProxy(p35, p36)
	for _, v in ipairs(p35._rows) do
		if p36 == v.frame then
			return v.proxy
		end
	end

	return nil
end

return module
