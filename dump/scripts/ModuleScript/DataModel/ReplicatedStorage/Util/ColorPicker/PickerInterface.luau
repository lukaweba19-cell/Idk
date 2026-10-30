-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local mouseMovement = require(script.Parent:WaitForChild("MouseMovement"))
local circle = require(script:WaitForChild("Circle"))
local square = require(script:WaitForChild("Square"))
local triangle = require(script:WaitForChild("Triangle"))
local module: {[any]: any} = {}

module.__index = module

function module.new(colorPicker, instance)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.Instance = instance
	object.PickerModes = {}
	object:Init()

	return object
end

local t2: {[any]: any} = { Circle = circle, Square = square, Triangle = triangle }

function module.GetPickerMode(p3, p4)
	if not p3.PickerModes[p4] and t2[p4] then
		p3.PickerModes[p4] = t2[p4].new(p3.ColorPicker, p3.Instance)
	end

	return p3.PickerModes[p4]
end
function module.SetPickerMode(p5, currentPickerMode)
	p5.CurrentPickerMode = currentPickerMode

	if not p5.PickerModes[currentPickerMode] and t2[currentPickerMode] then
		p5.PickerModes[currentPickerMode] = t2[currentPickerMode].new(p5.ColorPicker, p5.Instance)
	end

	p5:UpdateVisibility()
end
function module.UpdateVisibility(p7)
	for iterFirst, iterSecond in p7.PickerModes, nil, nil do
		iterSecond:SetVisible(iterFirst == p7.CurrentPickerMode)
	end
end
function module.UpdateSelectFrame(p8)
	local select = p8.Instance:WaitForChild("Select")
	local v19 = p8:GetPickerMode(p8.CurrentPickerMode)

	if v19 then
		select.Position = v19:GetPointerPositionFromColor(p8.ColorPicker:GetHSV())

		if p8.CurrentPickerMode == "Circle" then
			local v20, v21, v22 = p8.ColorPicker:GetHSV()

			select.ImageColor3 = Color3.fromHSV(1, 0, 0.4 + v22 * 0.6)

			return
		end

		select.ImageColor3 = Color3.fromHSV(1, 0, 1)

		return
	end
end
function module.UpdateVisual(p9)
	p9:UpdateSelectFrame()

	local v24 = p9:GetPickerMode(p9.CurrentPickerMode)

	if v24 and v24.UpdateVisual then
		v24:UpdateVisual()
	end
end
function module.GetRelativeMousePos(p10)
	return (p10.ColorPicker:GetMousePos() - p10.Instance.AbsolutePosition) / p10.Instance.AbsoluteSize
end
function module.Init(p11)
	p11._pickerMouseMovement = mouseMovement.new(function()
		local v28 = p11:GetPickerMode(p11.CurrentPickerMode)

		if v28 then
			p11.ColorPicker:SetHSV(v28:GetColor(p11:GetRelativeMousePos()))
		end
	end)
	p11.Instance:WaitForChild("Button").MouseButton1Down:Connect(function()
		local v29 = p11:GetPickerMode(p11.CurrentPickerMode)

		if v29 then
			if v29.MouseDown then
				v29:MouseDown(p11:GetRelativeMousePos())
			end

			p11._pickerMouseMovement:Connect()
		end
	end)
end
function module.Destroy(p12)
	p12._pickerMouseMovement:Destroy()

	if p12.Instance then
		p12.Instance:Destroy()
	end
end

return module
