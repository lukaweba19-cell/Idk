-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local function toPolar(p1)
	return math.atan2(p1.Y, p1.X), p1.Magnitude
end
function module.new(colorPicker, parentContainer)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.ParentContainer = parentContainer
	object:Init()

	return object
end
function module.Init(p4)
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Size = UDim2.fromScale(1, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxassetid://91671058647239"
	imageLabel.Parent = p4.ParentContainer
	p4.Instance = imageLabel
	p4:SetVisible(false)
end
function module.SetVisible(p5, p6)
	p5.Instance.Visible = p6
end
function module.GetColor(p7, p8)
	local n1 = Vector2.new(0.5, 0.5) - p8
	local v14 = math.atan2(n1.Y, n1.X)
	local magnitude = n1.Magnitude
	local v16 = math.clamp((v14 + 3.141592653589793) / 6.283185307179586, 0, 1)

	v14 = math.clamp(magnitude * 2, 0, 1)

	return v16, v14, p7.ColorPicker.Color.Value
end
function module.GetPointerPositionFromColor(_, p10, p11, _)
	local n1 = p10 * 3.141592653589793 * 2
	local uDim2FromScale = UDim2.fromScale
	local cosine = math.cos(n1)
	local sine = math.sin(n1)

	return uDim2FromScale(0.5 + cosine / 2 * p11, 0.5 + sine / 2 * p11)
end

return module
