-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local mouseMovement = require(script.Parent:WaitForChild("MouseMovement"))
local samples: Instance = script.Parent:WaitForChild("Samples")
local module: {[any]: any} = {}

module.__index = module

function module.new(colorPicker, title, layoutOrder, maxValue)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.LayoutOrder = layoutOrder
	object.Title = title
	object.MaxValue = maxValue
	object:Init()

	return object
end
function module.UpdateVisual(p5)
	if p5.GetValue then
		local v10 = p5.GetValue()
		local select = p5.Instance:WaitForChild("Slider"):WaitForChild("Select")

		select.Position = UDim2.fromScale(v10, 0.5)

		local textBox = p5.Instance:WaitForChild("Input"):WaitForChild("TextBox")

		textBox.Text = math.round(v10 * p5.MaxValue)
	end

	if p5.OnValueChanged then
		p5.OnValueChanged()
	end
end
function module.SetVisible(p6, p7)
	if p7 then
		p6:UpdateVisual()
	end

	p6.Instance.Visible = p7
end
function module.GetVisible(p8)
	return p8.Instance.Visible
end
function module.Create(p9)
	local clone: Instance = samples:WaitForChild("SliderSample"):Clone()

	clone.Parent = p9.ColorPicker.Instance:WaitForChild("Sliders")
	clone.Name = tostring(p9.LayoutOrder)

	return clone
end
function module.Init(p10)
	p10.Instance = p10:Create()

	local slider = p10.Instance:WaitForChild("Slider")

	p10._mouseMovement = mouseMovement.new(function()
		local v22 = p10.ColorPicker:GetMousePos()
		local v23 = math.clamp((v22.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)

		if p10.OnManualChange then
			p10.OnManualChange(v23)
			p10.ColorPicker:_updateColorVisuals()
			p10.ColorPicker:_fireColorChanged()
		end
	end)
	slider:WaitForChild("Button").MouseButton1Down:Connect(function()
		p10._mouseMovement:Connect()
	end)

	local textBox = p10.Instance:WaitForChild("Input"):WaitForChild("TextBox")

	textBox.FocusLost:Connect(function()
		local numberValue: number? = tonumber(textBox.Text)
		local v25 = math.clamp((numberValue or 0) / p10.MaxValue, 0, 1)

		if p10.OnManualChange then
			p10.OnManualChange(v25)
			p10.ColorPicker:_updateColorVisuals()
			p10.ColorPicker:_fireColorChanged()
		end
	end)
end
function module.Destroy(p11)
	p11._mouseMovement:Destroy()

	if p11.Instance then
		p11.Instance:Destroy()
	end
end

return module
