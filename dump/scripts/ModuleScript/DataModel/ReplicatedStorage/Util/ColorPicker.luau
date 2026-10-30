-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local tweenService: TweenService = game:GetService("TweenService")
local guiService: GuiService = game:GetService("GuiService")
local paletteInterface = require(script:WaitForChild("PaletteInterface"))
local pickerInterface = require(script:WaitForChild("PickerInterface"))
local builtinSliders = require(script:WaitForChild("BuiltinSliders"))
local mouseMovement = require(script:WaitForChild("MouseMovement"))
local styling = require(script:WaitForChild("Styling"))
local slider = require(script:WaitForChild("Slider"))

require(script:WaitForChild("Types"))

local samples: Instance = script:WaitForChild("Samples")
local picker_mode: {[any]: any} = { CIRCLE = "Circle", SQUARE = "Square", TRIANGLE = "Triangle" }
local color_space: {[any]: any} = { HSV = 0, RGB = 1 }
local circle = picker_mode.CIRCLE
local hsv = color_space.HSV

local function deepCopy(p1)
	local t5: {[any]: any} = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t5[k] = deepCopy(v)
		else
			t5[k] = v
		end
	end

	return t5
end
local function reconcile(p2, p3)
	local v25 = deepCopy(p2)

	for k, v in pairs(p3) do
		if p2[k] == nil then
			v25[k] = if typeof(v) == "table" then deepCopy(v) else v
		elseif typeof(p2[k]) == "table" then
			v25[k] = reconcile(p2[k], v)
		end
	end

	return v25
end

local module: {[any]: any} = {}

module.__index = module
module.PICKER_MODE = picker_mode
module.COLOR_SPACE = color_space

local t4: {[any]: any} = {
	Parent = nil,
	Position = nil,
	Size = 0.6,
	TopbarEnabled = true,
	PaletteEnabled = true,
	Draggable = true,
	Resizable = true,
	DisplayOrder = 1,
	ZIndex = 1,
	TransparencyEnabled = false,
	UserCanClose = true,
	PickerMode = circle,
	ColorSpace = hsv,
	Style = {}
}

function module.new(p4)
	local object = setmetatable({}, module)

	object.Color = { Hue = 0, Saturation = 0, Value = 1, Transparency = 0 }
	object.Params = reconcile(p4 or {}, t4)
	object._sliders = {}
	object:Init()

	return object
end
function module.GetMousePos(_)
	local height = guiService.TopbarInset.Height
	local v32: Vector2 = userInputService:GetMouseLocation()
	local vector2 = Vector2.new(0, height)

	return v32 - vector2
end
function module.GetMousePosUDim(p6)
	local n1 = p6:GetMousePos() / p6.UI.AbsoluteSize

	return UDim2.fromScale(n1.X, n1.Y)
end
function module.SetHSV(p7, p8, saturation, value)
	local v40 = p7.Color
	local v41 = p7.Color

	p7.Color.Hue = p8
	v40.Saturation = saturation
	v41.Value = value
	p7:_updateColorVisuals()
	p7:_fireColorChanged()
end
function module.GetHSV(p11)
	return p11.Color.Hue, p11.Color.Saturation, p11.Color.Value
end
function module.SetColor(p12, p13)
	local v45 = p12.Color
	local v46 = p12.Color
	local v47 = p12.Color
	local hue, saturation, value = p13:ToHSV()

	v45.Hue = hue
	v46.Saturation = saturation
	v47.Value = value
	p12:_updateColorVisuals()
	p12:_fireColorChanged()
end
function module.GetColor(p14)
	return Color3.fromHSV(p14:GetHSV())
end
function module.SetTransparency(p15, p16)
	p15.Color.Transparency = p16
	p15:_updateColorVisuals()
	p15:_fireColorChanged()
end
function module.GetTransparency(p17)
	return p17.Color.Transparency
end
function module.SetVisible(p18, p19)
	p18.Instance.Visible = p19
end
function module.GetVisible(p20)
	return p20.Instance.Visible
end
function module.SetPickerMode(p21, pickerMode)
	for iterFirst, iterSecond in p21.Instance:WaitForChild("Settings"):WaitForChild("PickerMode"):GetChildren() do
		iterSecond.Icon.ImageTransparency = if pickerMode == iterSecond.Name then 0 else 0.5
	end

	p21.PickerMode = pickerMode
	p21.PickerInterface:SetPickerMode(pickerMode)
	p21.PickerInterface:UpdateVisual()
end
function module._updateColorVisuals(p23)
	local backgroundColor3 = p23:GetColor()
	local middle = p23.Instance:WaitForChild("Middle")
	local colorPreview = middle:WaitForChild("ColorPreview")

	colorPreview.BackgroundColor3 = backgroundColor3
	p23.PickerInterface:UpdateVisual()

	for iterFirst, iterSecond in p23._sliders, nil, nil do
		if iterSecond:GetVisible() then
			iterSecond:UpdateVisual()
		end
	end

	local input = middle:WaitForChild("Options"):WaitForChild("Hex"):WaitForChild("Input")
	local stringFormat = string.format
	local v70 = p23:GetColor()

	input.Text = stringFormat("#%s", v70:ToHex())
end
function module.Create(p24)
	p24.UI = p24.Params.Parent or Instance.new("ScreenGui")

	if not p24.Params.Parent then
		p24.UI.Name = "COLOR_PICKER_UI"
		p24.UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		p24.UI.DisplayOrder = p24.Params.DisplayOrder
		p24.UI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	p24.Instance = samples:WaitForChild("ColorPickerSample"):Clone()
	p24.Instance.Name = "ColorPickerUI"
	p24.Instance.ZIndex = p24.Params.ZIndex
	p24.Instance.Size = if typeof(p24.Params.Size) == "UDim2" then p24.Params.Size else UDim2.fromScale(p24.Params.Size, p24.Params.Size)
	p24.Instance.Position = p24.Params.Position or p24:GetMousePosUDim()
	p24.Instance.Parent = p24.UI
	p24.Instance.Visible = true
end
function module._createSlider(p25, p26, p27, p28)
	local v76 = slider.new(p25, p26, p27, p28)

	p25._sliders[p26] = v76

	if p25.Params.Style then
		styling.stylizeSlider(v76.Instance, p25.Params.Style)
	end

	return v76
end
function module._setSliderVisible(p29, p30, p31)
	local v80 = p29._sliders[p30]

	if v80 then
		v80:SetVisible(p31)
	elseif builtinSliders[p30] and p31 then
		builtinSliders[p30](p29)
	end
end
function module._updateSliders(p32)
	local u82: boolean = p32.ColorSpace == 0

	p32:_setSliderVisible("Hue", u82)
	p32:_setSliderVisible("Saturation", u82)
	p32:_setSliderVisible("Value", u82)
	p32:_setSliderVisible("Red", not u82)
	p32:_setSliderVisible("Green", not u82)
	p32:_setSliderVisible("Blue", not u82)
end
function module.SetColorSpace(p33, p34)
	local colorSpace = p33.Instance:WaitForChild("Middle"):WaitForChild("Options"):WaitForChild("ColorSpace")

	p33.ColorSpace = p34

	for iterFirst, iterSecond in colorSpace:GetChildren() do
		iterSecond.Selection.Visible = p34 == color_space[iterSecond.Name]
	end

	p33:_updateSliders()
end
function module.UpdateBackground(p35)
	local background = p35.Instance:WaitForChild("Background")
	local n1: number = 0
	local n2: number = 1

	if p35.Params.TopbarEnabled then
		n1 -= 0.11
		n2 += 0.11
	end

	if p35.Params.TransparencyEnabled then
		n2 += 0.084
	end

	background.Position = UDim2.fromScale(0, n1)
	background.Size = UDim2.fromScale(1, n2)
end
function module.SetPaletteVisible(p36, p37)
	if not p36.PaletteInterface then
		print("ColorPicker:SetPaletteVisible - Palette not enabled")

		return
	end

	p36.PaletteInterface:SetVisible(p37)

	local picker = p36.Instance:WaitForChild("Picker")
	local settings = p36.Instance:WaitForChild("Settings")

	picker.Visible = not p37
	settings.Visible = not p37
end
function module.GetPaletteColor(p38, p39, p40)
	if not p38.PaletteInterface then
		print("ColorPicker:GetPaletteColor - Palette not enabled")

		return
	end

	if p40 then
		return (p38.PaletteInterface:GetColor3(p39))
	end

	return (p38.PaletteInterface:GetColor(p39))
end
function module.GetPaletteColors(p41, p42)
	if not p41.PaletteInterface then
		print("ColorPicker:GetPaletteColors - Palette not enabled")

		return
	end

	if p42 then
		return (p41.PaletteInterface:GetColors3())
	end

	return (p41.PaletteInterface:GetColors())
end
function module.SetPaletteColor(p43, p44, p45)
	if not p43.PaletteInterface then
		print("ColorPicker:SetPaletteColor - Palette not enabled")

		return
	end

	p43.PaletteInterface:SetColor(p44, p45)
end
function module.SetPaletteColors(p46, p47)
	if not p46.PaletteInterface then
		print("ColorPicker:SetPaletteColors - Palette not enabled")

		return
	end

	p46.PaletteInterface:SetColors(p47)
end
function module.AddPaletteColor(p48, p49)
	if not p48.PaletteInterface then
		print("ColorPicker:AddPaletteColor - Palette not enabled")

		return
	end

	p48.PaletteInterface:AddColor(p49)
end
function module.AddPaletteColors(p50, p51)
	if not p50.PaletteInterface then
		print("ColorPicker:AddPaletteColors - Palette not enabled")

		return
	end

	for iterFirst, iterSecond in p51 do
		p50.PaletteInterface:AddColor(iterSecond)
	end
end
function module.GetPosition(p52)
	return p52.Instance.Position
end
function module.SetPosition(p53, p54)
	p53.Instance.Position = p54
end
function module.GetSize(p55)
	return p55.Instance.Size
end
function module.SetSize(p56, p57)
	p56.Instance.Size = if typeof(p57) == "number" then UDim2.fromScale(p57, p57) else p57
end
function module._fireColorChanged(p58)
	local _colorChangedEvent = p58._colorChangedEvent
	local v120 = p58:GetColor()

	_colorChangedEvent:Fire(v120, p58:GetTransparency())
end
function module.Init(p59)
	p59:Create()
	p59._colorChangedEvent = Instance.new("BindableEvent")
	p59.ColorChanged = p59._colorChangedEvent.Event
	p59._windowClosedEvent = Instance.new("BindableEvent")
	p59.WindowClosed = p59._windowClosedEvent.Event
	p59.PickerInterface = pickerInterface.new(p59, p59.Instance:WaitForChild("Picker"))

	local settings = p59.Instance:WaitForChild("Settings")
	local pickerMode = settings:WaitForChild("PickerMode")

	for iterFirst, iterSecond in pickerMode:GetChildren() do
		iterSecond:WaitForChild("Button").MouseButton1Down:Connect(function()
			p59:SetPickerMode(iterSecond.Name)
		end)
	end

	local options = p59.Instance:WaitForChild("Middle"):WaitForChild("Options")

	for iterFirst2, iterSecond2 in options:WaitForChild("ColorSpace"):GetChildren() do
		iterSecond2:WaitForChild("Button").MouseButton1Down:Connect(function()
			p59:SetColorSpace(color_space[iterSecond2.Name])
		end)
	end

	local input = options:WaitForChild("Hex"):WaitForChild("Input")

	input.FocusLost:Connect(function()
		local ok, result = pcall(function()
			return Color3.fromHex(input.Text)
		end)

		local v139 = ok and result or Color3.new(1, 1, 1)

		p59:SetColor(v139)
	end)

	if p59.Params.TopbarEnabled then
		p59.Topbar = samples:WaitForChild("Topbar"):Clone()
		p59.Topbar.Parent = p59.Instance

		if p59.Params.Draggable then
			p59._dragMouseMovement = mouseMovement.new(function(p60, p61)
				local n1 = ((p59:GetMousePos() or Vector2.zero) - p60) / p59.UI.AbsoluteSize
				local instance = p59.Instance
				local v144 = UDim2.fromScale(n1.X, n1.Y)

				instance.Position = p61 + v144
			end)
			p59.Topbar:WaitForChild("Button").MouseButton1Down:Connect(function()
				local v145 = p59:GetMousePos() or Vector2.zero

				p59._dragMouseMovement:Connect(v145, p59.Instance.Position)
			end)
		end

		if p59.Params.UserCanClose then
			local clone: Instance = samples:WaitForChild("TopbarCloseButton"):Clone()

			clone.Parent = p59.Topbar
			clone.MouseButton1Down:Connect(function()
				p59._windowClosedEvent:Fire()
				p59:Destroy()
			end)
		end
	end

	local palette = settings:WaitForChild("Palette")

	if p59.Params.PaletteEnabled then
		p59.PaletteInterface = paletteInterface.new(p59, p59.Instance:WaitForChild("Palette"))
		palette:WaitForChild("Button").MouseButton1Down:Connect(function()
			p59:SetPaletteVisible(true)
		end)
	else
		pickerMode.Position = UDim2.fromScale(0, 0.5)
		palette.Visible = false
	end

	if p59.Params.Resizable then
		local clone: Instance = samples:WaitForChild("Resize"):Clone()

		clone.Frame.BackgroundTransparency = 1
		clone.Parent = p59.Instance
		p59._resizeMovement = mouseMovement.new(function(p62, p63)
			local v148 = p59:GetMousePos()
			local absoluteSize = p59.UI.AbsoluteSize
			local v150 = math.clamp(p63.X.Scale + (v148.X - p62.X) * (absoluteSize.X / absoluteSize.Y) / p59.Instance.UIAspectRatioConstraint.AspectRatio / absoluteSize.X, 0.3, 1)

			p59.Instance.Size = UDim2.fromScale(v150, v150)
		end)

		local button: Instance = clone:WaitForChild("Button")

		button.MouseButton1Down:Connect(function()
			local v151 = p59:GetMousePos() or Vector2.zero

			p59._resizeMovement:Connect(v151, p59.Instance.Size)
		end)
		button.MouseEnter:Connect(function()
			local cloneFrame = clone.Frame
			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

			tweenService:Create(cloneFrame, tweenInfo, { BackgroundTransparency = 0.4 }):Play()
		end)
		button.MouseLeave:Connect(function()
			local cloneFrame = clone.Frame
			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

			tweenService:Create(cloneFrame, tweenInfo, { BackgroundTransparency = 1 }):Play()
		end)
	end

	if p59.Params.Style then
		styling.stylize(p59, p59.Params.Style)
	end

	p59:SetPickerMode(p59.Params.PickerMode)
	p59:SetColorSpace(p59.Params.ColorSpace)

	if p59.Params.TransparencyEnabled then
		builtinSliders.Transparency(p59)
	end

	p59:UpdateBackground()
end
function module.Destroy(p64)
	if p64._colorChangedEvent then
		p64._colorChangedEvent:Destroy()
		p64._colorChangedEvent = nil
	end

	if p64._windowClosedEvent then
		p64._windowClosedEvent:Destroy()
		p64._windowClosedEvent = nil
	end

	if p64._dragMouseMovement then
		p64._dragMouseMovement:Destroy()
	end

	if p64._resizeMovement then
		p64._resizeMovement:Destroy()
	end

	if p64.PickerInterface then
		p64.PickerInterface:Destroy()
	end

	for iterFirst, iterSecond in p64._sliders, nil, nil do
		iterSecond:Destroy()
	end

	if p64.Instance then
		p64.Instance:Destroy()
		p64.Instance = nil
	end

	if not p64.Params.Parent and p64.UI then
		p64.UI:Destroy()
		p64.UI = nil
	end
end

return module
