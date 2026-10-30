-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local util = game.ReplicatedStorage:WaitForChild("Util")
local spring2 = require(util:WaitForChild("Spring2"))
local module: {[any]: any} = {}

module.__newindex = module

local function getPosition(p1, p2)
	if p1 == Vector2.new(0, 1) then
		return UDim2.new(0.5, 0, 0.5, p2)
	end

	if p1 == Vector2.new(1, 0) then
		return UDim2.new(0.5, p2, 0.5, 0)
	end

	if p1 == Vector2.new(0, -1) then
		return UDim2.new(0.5, 0, 0.5, -p2)
	end

	if p1 == Vector2.new(-1, 0) then
		return UDim2.new(0.5, -p2, 0.5, 0)
	end
end
local function cancelVisTweens(p3)
	local visTweens = p3.visTweens

	if not visTweens then
		return
	end

	for _, v in ipairs(visTweens) do
		v:Cancel()
	end

	table.clear(visTweens)
end
function module.create(parent)
	local t2: {[any]: any} = {}

	for i = 1, 4 do
		local vector2 = nil
		local vector22 = nil

		if i == 1 then
			vector2 = Vector2.new(0, 1)
			vector22 = Vector2.new(0.5, 0)
		elseif i == 2 then
			vector2 = Vector2.new(1, 0)
			vector22 = Vector2.new(0, 0.5)
		elseif i == 3 then
			vector2 = Vector2.new(0, -1)
			vector22 = Vector2.new(0.5, 1)
		elseif i == 4 then
			vector2 = Vector2.new(-1, 0)
			vector22 = Vector2.new(1, 0.5)
		end

		local u18: boolean = vector2.X ~= 0
		local frame: Frame = Instance.new("Frame")

		frame.Size = UDim2.fromOffset(if u18 then 18 else 2, if u18 then 2 else 18)
		frame.AnchorPoint = vector22
		frame.Position = getPosition(vector2, 9)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		frame.Visible = false

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Name = "UIStroke"
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Thickness = 2
		uiStroke.Transparency = 0.7
		uiStroke.Parent = frame
		frame.Parent = parent
		table.insert(t2, { instance = frame, direction = vector2 })
	end

	local v21 = spring2.new(9)

	v21.Damper = 1.1
	v21.Speed = 20

	local object = setmetatable({
		length = 18,
		width = 2,
		minSpread = 9,
		gapScale = 1,
		lineTransparency = 0,
		strokeThickness = 2,
		strokeTransparency = 0.7,
		frames = t2,
		spring = v21,
		container = parent,
		visTweens = {},
		lineColor = Color3.new(1, 1, 1),
		strokeColor = Color3.new(0, 0, 0)
	}, { __index = module })

	module.Current = object

	return object
end
function module.update(p5, p6, p7)
	local n1 = p5.minSpread * (p5.gapScale or 1)

	p5.spring.Target = n1 + p6 * (100 - n1)
	p5.spring:TimeSkip(p7)

	local v27 = p5.spring.Position

	if n1 >= p5.spring.Target and math.abs(v27 - p5.spring.Target) <= 0.1 then
		p5.spring:TimeSkip(10)
	end

	for iterFirst, iterSecond in p5.frames, nil, nil do
		iterSecond.instance.Position = getPosition(iterSecond.direction, v27)
	end
end
function module.setVisibleAnimated(p8, p9)
	cancelVisTweens(p8)

	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	for iterFirst, iterSecond in p8.frames, nil, nil do
		local instance = iterSecond.instance
		local u36: boolean = iterSecond.direction.X ~= 0
		local uDim2 = UDim2.new(0, u36 and p8.length or p8.width, 0, u36 and p8.width or p8.length)
		local uDim22 = UDim2.new(0, if u36 then 0 else p8.width, 0, u36 and p8.width or 0)
		local lineTransparency = p8.lineTransparency
		local strokeTransparency = p8.strokeTransparency

		if p9 then
			instance.Size = uDim22
			instance.BackgroundTransparency = 1
			instance.UIStroke.Transparency = 1
		else
			instance.Size = uDim2
			instance.BackgroundTransparency = lineTransparency
			instance.UIStroke.Transparency = strokeTransparency
		end

		local v41: Tween = tweenService:Create(instance, tweenInfo, {
			Size = p9 and uDim2 or uDim22,
			BackgroundTransparency = p9 and lineTransparency or 1
		})
		local v42: Tween = tweenService:Create(instance.UIStroke, tweenInfo, { Transparency = p9 and strokeTransparency or 1 })

		table.insert(p8.visTweens, v41)
		table.insert(p8.visTweens, v42)
		v41:Play()
		v42:Play()
	end
end
function module.setVisible(p10, p11)
	for iterFirst, iterSecond in p10.frames, nil, nil do
		iterSecond.instance.Visible = p11
	end
end
function module.applyVisibleState(p12, p13)
	cancelVisTweens(p12)

	for iterFirst, iterSecond in p12.frames, nil, nil do
		local instance = iterSecond.instance
		local u52: boolean = iterSecond.direction.X ~= 0

		if p13 then
			instance.Size = UDim2.new(0, u52 and p12.length or p12.width, 0, u52 and p12.width or p12.length)
			instance.BackgroundTransparency = p12.lineTransparency
			instance.UIStroke.Transparency = p12.strokeThickness > 0 and p12.strokeTransparency or 1
		else
			instance.Size = UDim2.new(0, if u52 then 0 else p12.width, 0, u52 and p12.width or 0)
			instance.BackgroundTransparency = 1
			instance.UIStroke.Transparency = 1
		end
	end
end
function module.applyStyle(p14, p15)
	cancelVisTweens(p14)
	p14.length = math.max(p15.LineLength or p14.length, 1)
	p14.width = math.max(p15.LineWidth or p14.width, 1)
	p14.minSpread = math.max(p15.LineDistance or p14.minSpread, 0)
	p14.lineColor = p15.LineColor or p14.lineColor
	p14.lineTransparency = math.clamp((p15.LineTransparency or 0) / 100, 0, 1)
	p14.strokeColor = p15.StrokeColor or p14.strokeColor
	p14.strokeThickness = math.max(p15.StrokeThickness or 0, 0)
	p14.strokeTransparency = math.clamp((p15.StrokeTransparency or 0) / 100, 0, 1)

	for iterFirst, iterSecond in p14.frames, nil, nil do
		local instance = iterSecond.instance
		local u58: boolean = iterSecond.direction.X ~= 0

		instance.Size = UDim2.new(0, u58 and p14.length or p14.width, 0, u58 and p14.width or p14.length)
		instance.BackgroundColor3 = p14.lineColor
		instance.BackgroundTransparency = p14.lineTransparency

		local uiStroke = instance:FindFirstChild("UIStroke")

		if uiStroke then
			uiStroke.Color = p14.strokeColor
			uiStroke.Thickness = p14.strokeThickness
			uiStroke.Transparency = p14.strokeThickness > 0 and p14.strokeTransparency or 1
		end

		instance.Position = getPosition(iterSecond.direction, p14.minSpread)
	end

	if p14.container and p14.container:IsA("GuiObject") then
		p14.container.Rotation = p15.CrosshairRotation or 0
	end
end

return module
