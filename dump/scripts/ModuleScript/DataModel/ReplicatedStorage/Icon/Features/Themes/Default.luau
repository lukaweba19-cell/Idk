-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = { "IconCorners", "CornerRadius", UDim.new(1, 0) }
local t2: {[any]: any} = { "Selection", "Size", UDim2.new(1, 0, 1, 1) }
local t3: {[any]: any} = { "Selection", "Position", UDim2.new(0, 0, 0, 0) }
local colorSequenceNew = ColorSequence.new
local t4: {[any]: any} = {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(86, 86, 86))
}
local v6 = UDim2.fromOffset(0, 0)
local color3 = Color3.fromRGB(18, 18, 21)
local t5: {[any]: any} = { "IconImageCorner", "CornerRadius", UDim.new(0, 0), "Deselected" }
local color32 = Color3.fromRGB(255, 255, 255)
local v10 = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local t6: {[any]: any} = {
	"ContentsList",
	"HorizontalAlignment",
	Enum.HorizontalAlignment.Center,
	"Deselected"
}
local color33 = Color3.fromRGB(18, 18, 21)
local t7: {[any]: any} = { "Notice", "Position", UDim2.new(1, -12, 0, -1), "Deselected" }
local t8: {[any]: any} = { "Notice", "Size", UDim2.new(0, 20, 0, 20), "Deselected" }
local t9: {[any]: any} = { "PaddingLeft", "Size", UDim2.new(0, 9, 1, 0), "Deselected" }
local t10: {[any]: any} = { "PaddingRight", "Size", UDim2.new(0, 11, 1, 0), "Deselected" }
local color34 = Color3.fromRGB(255, 255, 255)
local v18 = ColorSequence.new
local color35 = Color3.fromRGB(96, 98, 100)
local colorSequence = v18(color35, Color3.fromRGB(77, 78, 80))

return {
	t1,
	{ "Selection", "RotationSpeed", 1 },
	t2,
	t3,
	{ "SelectionGradient", "Color", colorSequenceNew(t4) },
	{ "IconImage", "Image", "", "Deselected" },
	{ "IconLabel", "Text", "", "Deselected" },
	{ "IconLabel", "Position", v6, "Deselected" },
	{ "Widget", "DesiredWidth", 44, "Deselected" },
	{ "Widget", "MinimumWidth", 44, "Deselected" },
	{ "Widget", "MinimumHeight", 44, "Deselected" },
	{ "Widget", "BorderSize", 4, "Deselected" },
	{ "IconButton", "BackgroundColor3", color3, "Deselected" },
	{ "IconButton", "BackgroundTransparency", 0.08, "Deselected" },
	{ "IconImageScale", "Value", 0.5, "Deselected" },
	t5,
	{ "IconImage", "ImageColor3", color32, "Deselected" },
	{ "IconImage", "ImageTransparency", 0, "Deselected" },
	{ "IconImageRatio", "AspectRatio", 1, "Deselected" },
	{ "IconLabel", "FontFace", v10, "Deselected" },
	{ "IconLabel", "TextSize", 16, "Deselected" },
	{ "IconSpot", "BackgroundTransparency", 1, "Deselected" },
	{ "IconOverlay", "BackgroundTransparency", 0.85, "Deselected" },
	{ "IconSpotGradient", "Enabled", false, "Deselected" },
	{ "IconGradient", "Enabled", false, "Deselected" },
	{ "ClickRegion", "Active", true, "Deselected" },
	{ "Menu", "Active", false, "Deselected" },
	t6,
	{ "Dropdown", "BackgroundColor3", color33, "Deselected" },
	{ "Dropdown", "BackgroundTransparency", 0.08, "Deselected" },
	{ "Dropdown", "MaxIcons", 4.5, "Deselected" },
	{ "Menu", "MaxIcons", 4, "Deselected" },
	t7,
	t8,
	{ "NoticeLabel", "TextSize", 13, "Deselected" },
	t9,
	t10,
	{ "IconSpot", "BackgroundTransparency", 0.7, "Selected" },
	{ "IconSpot", "BackgroundColor3", color34, "Selected" },
	{ "IconSpotGradient", "Enabled", true, "Selected" },
	{ "IconSpotGradient", "Rotation", 45, "Selected" },
	{ "IconSpotGradient", "Color", colorSequence, "Selected" }
}
