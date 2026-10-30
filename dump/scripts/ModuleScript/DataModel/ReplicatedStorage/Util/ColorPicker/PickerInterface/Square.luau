-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

function module.new(colorPicker, parentContainer)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.ParentContainer = parentContainer
	object:Init()

	return object
end
function module.Init(p3)
	local canvasGroup: CanvasGroup = Instance.new("CanvasGroup")

	canvasGroup.BackgroundTransparency = 0
	canvasGroup.BackgroundColor3 = Color3.new(1, 1, 1)
	canvasGroup.Size = UDim2.fromScale(1, 1)
	canvasGroup.Parent = p3.ParentContainer

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.032, 0)
	uiCorner.Parent = canvasGroup

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
	uiGradient.Parent = canvasGroup

	local frame: Frame = Instance.new("Frame")

	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = canvasGroup

	local uiGradient2: UIGradient = Instance.new("UIGradient")

	uiGradient2.Color = ColorSequence.new(Color3.new(0, 0, 0))
	uiGradient2.Rotation = -90
	uiGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	uiGradient2.Parent = frame
	p3.Instance = canvasGroup
	p3.Gradient = uiGradient
	p3:SetVisible(false)
end
function module.SetVisible(p4, p5)
	p4.Instance.Visible = p5
end
function module.GetColor(p6, p7)
	local hue = p6.ColorPicker.Color.Hue
	local v16 = math.clamp(p7.X, 0, 1)
	local v17 = math.clamp(1 - p7.Y, 0, 1)

	return hue, v16, v17
end
function module.GetPointerPositionFromColor(_, _, p10, p11)
	return UDim2.fromScale(p10, 1 - p11)
end
function module.UpdateVisual(p12)
	local gradient = p12.Gradient
	local colorSequenceNew = ColorSequence.new
	local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1))

	gradient.Color = colorSequenceNew({
		colorSequenceKeypoint,
		ColorSequenceKeypoint.new(1, Color3.fromHSV(p12.ColorPicker.Color.Hue, 1, 1))
	})
end

return module
