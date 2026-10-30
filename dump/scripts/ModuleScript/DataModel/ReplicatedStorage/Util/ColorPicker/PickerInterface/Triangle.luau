-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local function heightToTriangleHeight(p1)
	return p1 / 0.8660254037844386 - 0.0669872981077807
end
function module.new(colorPicker, parentContainer)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.ParentContainer = parentContainer
	object:Init()

	return object
end
function module.Init(p4)
	local frame: Frame = Instance.new("Frame")

	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = p4.ParentContainer

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.fromScale(1, 1)
	imageLabel.Image = "rbxassetid://119614645478849"
	imageLabel.ImageColor3 = Color3.new(1, 0, 0)
	imageLabel.ZIndex = 1
	imageLabel.Parent = frame

	local imageLabel2: ImageLabel = Instance.new("ImageLabel")

	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Size = UDim2.fromScale(1, 1)
	imageLabel2.Image = "rbxassetid://114393129271758"
	imageLabel2.ImageColor3 = Color3.new(1, 1, 1)
	imageLabel2.ZIndex = 2
	imageLabel2.Parent = frame

	local imageLabel3: ImageLabel = Instance.new("ImageLabel")

	imageLabel3.BackgroundTransparency = 1
	imageLabel3.Size = UDim2.fromScale(1, 1)
	imageLabel3.Image = "rbxassetid://90395096352510"
	imageLabel3.ImageColor3 = Color3.new(1, 1, 1)
	imageLabel3.ZIndex = 3
	imageLabel3.Parent = frame
	p4.Instance = frame
	p4.ColorImage = imageLabel
	p4:SetVisible(false)
end
function module.SetVisible(p5, p6)
	p5.Instance.Visible = p6
end

local t2: {[any]: any} = { Vector2.new(0.5, 0), Vector2.new(0, 1), (Vector2.new(1, 1)) }

function module.GetColor(p7, p8)
	local x = p8.X
	local v18 = math.clamp(p8.Y / 0.8660254037844386 - 0.0669872981077807, 0, 1)
	local v19 = math.clamp(x, 0.5 - v18 / 2, v18 / 2 + 0.5)
	local v20 = t2[1]
	local v21 = t2[2]
	local v22 = t2[3]
	local n1 = ((v21.Y - v22.Y) * (v19 - v22.X) + (v22.X - v21.X) * (v18 - v22.Y)) / ((v21.Y - v22.Y) * (v20.X - v22.X) + (v22.X - v21.X) * (v20.Y - v22.Y))
	local n2 = ((v22.Y - v20.Y) * (v19 - v22.X) + (v20.X - v22.X) * (v18 - v22.Y)) / ((v21.Y - v22.Y) * (v20.X - v22.X) + (v22.X - v21.X) * (v20.Y - v22.Y))
	local v25 = math.clamp(n1, 0, 1)
	local v26 = math.clamp(n2, 0, 1)

	v22 = math.clamp(1 - n1 - n2, 0, 1)

	local color3 = Color3.fromHSV(p7.ColorPicker.Color.Hue, 1, 1)
	local color32 = Color3.new(v25 * color3.R + v26 * 0 + v22 * 1, v25 * color3.G + v26 * 0 + v22 * 1, v25 * color3.B + v26 * 0 + v22 * 1)
	local v29, v30, v31 = color32:ToHSV()

	return p7.ColorPicker.Color.Hue, v30, v31
end
function module.GetPointerPositionFromColor(_, _, p11, p12)
	local v36 = Vector2.new(0.5, 0):Lerp(Vector2.new(1, 1), 1 - p11):Lerp(Vector2.new(0, 1), 1 - p12)

	return UDim2.fromScale(v36.X, 0.0669872981077807 + v36.Y * 0.8660254037844386)
end
function module.UpdateVisual(p13)
	p13.ColorImage.ImageColor3 = Color3.fromHSV(p13.ColorPicker.Color.Hue, 1, 1)
end

return module
