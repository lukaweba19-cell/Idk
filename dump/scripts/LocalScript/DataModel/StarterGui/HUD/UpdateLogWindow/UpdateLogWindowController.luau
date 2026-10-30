-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local hud: Instance = players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local closeUpdateLog: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("CloseUpdateLog")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local updateLogData = require(shared:WaitForChild("UpdateLogData"))
local updateLogWindow: Instance = hud:WaitForChild("UpdateLogWindow")
local closeBtn: Instance = updateLogWindow:WaitForChild("CloseBtn")
local scrollingFrame: Instance = updateLogWindow:WaitForChild("Content"):WaitForChild("ScrollingFrame")
local listScrollingFrame: Instance = updateLogWindow:WaitForChild("List"):WaitForChild("ScrollingFrame")
local cell: Instance = listScrollingFrame:WaitForChild("Cell")
local cellSelected: Instance = listScrollingFrame:WaitForChild("CellSelected")

cell.Visible = false
cellSelected.Visible = false

for _, v in ipairs(scrollingFrame:GetChildren()) do
	if v:IsA("Frame") then
		v:Destroy()
	end
end

for _, v in ipairs(listScrollingFrame:GetChildren()) do
	if v:IsA("ImageButton") and v ~= cell and v ~= cellSelected then
		v:Destroy()
	end
end

local function todayDate()
	local dateText = os.date("*t")

	return string.format("%d/%d/%d", dateText.month, dateText.day, dateText.year)
end
local function makeGap(parent, layoutOrder, p3)
	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded = math.round(p3)

	gap.Size = uDim2New(1, 0, 0, rounded)
	gap.LayoutOrder = layoutOrder
	gap.Parent = parent

	return gap
end
local function getScale()
	local y = scrollingFrame.AbsoluteSize.Y

	if y <= 0 then
		return 1
	end

	return (math.clamp(y / 315, 0.55, 1.15))
end
local function buildContentFrame(p4)
	local y = scrollingFrame.AbsoluteSize.Y
	local n1 = if y <= 0 then 1 else math.clamp(y / 315, 0.55, 1.15)
	local frame: Frame = Instance.new("Frame")

	frame.Name = p4.name
	frame.AnchorPoint = Vector2.new(0, 0)
	frame.Position = UDim2.fromScale(0, 0)
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Visible = false

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.Padding = UDim.new(0, 0)
	uiListLayout.Parent = frame

	local uiPadding: UIPadding = Instance.new("UIPadding")

	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.PaddingLeft = UDim.new(0, 4)
	uiPadding.PaddingRight = UDim.new(0, 12)
	uiPadding.Parent = frame

	if p4.headerImage and p4.headerImage ~= "" then
		local headerImage: ImageLabel = Instance.new("ImageLabel")

		headerImage.Name = "HeaderImage"
		headerImage.Size = UDim2.new(1, 0, 1, 0)
		headerImage.BackgroundColor3 = Color3.new(0, 0, 0)
		headerImage.BorderSizePixel = 0
		headerImage.LayoutOrder = -99999
		headerImage.ScaleType = Enum.ScaleType.Stretch
		headerImage.Image = p4.headerImage

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(0.05, 0)
		uiCorner.Parent = headerImage

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Color = Color3.fromRGB(173, 173, 173)
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.52
		uiStroke.Parent = headerImage
		headerImage.Parent = frame

		local function syncHeight()
			local x = headerImage.AbsoluteSize.X

			if x > 0 then
				local floored = math.floor(x / 3.8)

				if math.abs(headerImage.AbsoluteSize.Y - floored) > 0.5 then
					headerImage.Size = UDim2.new(headerImage.Size.X.Scale, headerImage.Size.X.Offset, 0, floored)
				end
			end
		end

		headerImage:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)
		task.defer(syncHeight)
	end

	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded = math.round(n1 * 10)

	gap.Size = uDim2New(1, 0, 0, rounded)
	gap.LayoutOrder = 0
	gap.Parent = frame

	local updateName: TextLabel = Instance.new("TextLabel")

	updateName.Name = "UpdateName"
	updateName.Size = UDim2.new(0.95, -16, 0, 0)
	updateName.AutomaticSize = Enum.AutomaticSize.Y
	updateName.BackgroundTransparency = 1
	updateName.BorderSizePixel = 0
	updateName.LayoutOrder = 1
	updateName.Text = p4.name
	updateName.TextColor3 = Color3.new(1, 1, 1)
	updateName.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
	updateName.TextSize = math.round(n1 * 32)
	updateName.TextWrapped = true
	updateName.TextXAlignment = Enum.TextXAlignment.Left
	updateName.TextYAlignment = Enum.TextYAlignment.Top

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Thickness = 2
	uiStroke.Parent = updateName

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Rotation = 90

	local colorSequenceNew = ColorSequence.new

	uiGradient.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.525, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(0.537, Color3.new(0.6549, 0.6549, 0.6549)),
		ColorSequenceKeypoint.new(0.854, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
	})
	uiGradient.Parent = updateName
	updateName.Parent = frame

	local frame2: Frame = Instance.new("Frame")

	frame2.Name = "Gap"
	frame2.BackgroundTransparency = 1
	frame2.BorderSizePixel = 0

	local v57 = UDim2.new
	local rounded2 = math.round(n1 * 2)

	frame2.Size = v57(1, 0, 0, rounded2)
	frame2.LayoutOrder = 2
	frame2.Parent = frame

	local dateLabel: TextLabel = Instance.new("TextLabel")

	dateLabel.Name = "DateLabel"
	dateLabel.Size = UDim2.new(0.95, -16, 0, 0)
	dateLabel.AutomaticSize = Enum.AutomaticSize.Y
	dateLabel.BackgroundTransparency = 1
	dateLabel.BorderSizePixel = 0
	dateLabel.LayoutOrder = 3

	local v60 = p4.date

	if not v60 then
		local dateText = os.date("*t")

		v60 = string.format("%d/%d/%d", dateText.month, dateText.day, dateText.year)
	end

	dateLabel.Text = "From the Development Team @ " .. v60
	dateLabel.TextColor3 = Color3.new(1, 1, 1)
	dateLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	dateLabel.TextSize = math.round(n1 * 14)
	dateLabel.TextWrapped = true
	dateLabel.TextTransparency = 0.5
	dateLabel.TextXAlignment = Enum.TextXAlignment.Left
	dateLabel.TextYAlignment = Enum.TextYAlignment.Top
	dateLabel.Parent = frame

	local frame3: Frame = Instance.new("Frame")

	frame3.Name = "Gap"
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0

	local v63 = UDim2.new
	local rounded3 = math.round(n1 * 14)

	frame3.Size = v63(1, 0, 0, rounded3)
	frame3.LayoutOrder = 4
	frame3.Parent = frame

	local n2: number = 5

	for i, v in ipairs(p4.paragraphs) do
		if i > 1 then
			local frame4: Frame = Instance.new("Frame")

			frame4.Name = "Gap"
			frame4.BackgroundTransparency = 1
			frame4.BorderSizePixel = 0

			local v69 = UDim2.new
			local rounded4 = math.round(n1 * 8)

			frame4.Size = v69(1, 0, 0, rounded4)
			frame4.LayoutOrder = n2
			frame4.Parent = frame
			n2 += 1
		end

		local textLabel: TextLabel = Instance.new("TextLabel")

		textLabel.Name = "Paragraph" .. i
		textLabel.Size = UDim2.new(1, -16, 0, 0)
		textLabel.AutomaticSize = Enum.AutomaticSize.Y
		textLabel.BackgroundTransparency = 1
		textLabel.BorderSizePixel = 0
		textLabel.LayoutOrder = n2
		n2 += 1
		textLabel.Text = v
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		textLabel.TextSize = math.round(n1 * 16)
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.RichText = true
		textLabel.Parent = frame
	end

	local frame5: Frame = Instance.new("Frame")

	frame5.Name = "Gap"
	frame5.BackgroundTransparency = 1
	frame5.BorderSizePixel = 0

	local v73 = UDim2.new
	local rounded5 = math.round(n1 * 24)

	frame5.Size = v73(1, 0, 0, rounded5)
	frame5.LayoutOrder = 99999
	frame5.Parent = frame

	return frame
end

local t1: {[any]: any} = {}
local u22 = nil
local u23 = nil

local function applyCellStyle(p5, p6, visible)
	local v78 = p6 and cellSelected or cell
	local uiStroke = p5:FindFirstChildOfClass("UIStroke")
	local uiStroke2 = v78:FindFirstChildOfClass("UIStroke")

	if uiStroke and uiStroke2 then
		uiStroke.Color = uiStroke2.Color
		uiStroke.Transparency = uiStroke2.Transparency
		uiStroke.Thickness = uiStroke2.Thickness
	end

	local headerImage = p5:FindFirstChild("HeaderImage")
	local headerImage2 = v78:FindFirstChild("HeaderImage")

	if headerImage then
		headerImage.Visible = visible

		if visible and headerImage2 then
			local uiGradient = headerImage:FindFirstChildOfClass("UIGradient")
			local uiGradient2 = headerImage2:FindFirstChildOfClass("UIGradient")

			if uiGradient and uiGradient2 then
				uiGradient.Color = uiGradient2.Color
				uiGradient.Transparency = uiGradient2.Transparency
				uiGradient.Rotation = uiGradient2.Rotation
			end
		end
	end
end
local function rebuildContent()
	if u23 then
		u23:Destroy()
		u23 = nil
	end

	if not u22 then
		return
	end

	local v85 = t1[u22]

	if v85 then
		u23 = buildContentFrame(v85.entry)
		u23.Visible = true
		u23.Parent = scrollingFrame
	end
end
local function selectIndex(p8)
	if p8 == u22 then
		return
	end

	u22 = p8

	if u23 then
		u23:Destroy()
		u23 = nil
	end

	if u22 then
		local v87 = t1[u22]

		if v87 then
			u23 = buildContentFrame(v87.entry)
			u23.Visible = true
			u23.Parent = scrollingFrame
		end
	end

	for i, v in ipairs(t1) do
		applyCellStyle(v.button, i == p8, v.hasHeader)
	end

	scrollingFrame.CanvasPosition = Vector2.new(0, 0)
end
local function buildCells()
	for _, v in ipairs(t1) do
		v.button:Destroy()
	end

	table.clear(t1)
	u22 = nil

	for i, v in ipairs(updateLogData.GetVisible()) do
		local u94: boolean = v.headerImage ~= nil and v.headerImage ~= ""
		local clone: Instance = cell:Clone()

		clone.Name = "Cell_" .. v.name
		clone.Visible = true
		clone.LayoutOrder = i

		local headerImage: Instance = clone:FindFirstChild("HeaderImage")

		if headerImage then
			headerImage.Image = u94 and v.headerImage or ""
		end

		local updateName: Instance = clone:FindFirstChild("UpdateName")

		if updateName then
			updateName.Text = v.name
		end

		local dateLabel: Instance = clone:FindFirstChild("DateLabel")

		if dateLabel then
			local v99 = v.date

			if not v99 then
				local dateText = os.date("*t")

				v99 = string.format("%d/%d/%d", dateText.month, dateText.day, dateText.year)
			end

			dateLabel.Text = v99
		end

		clone.Parent = listScrollingFrame
		table.insert(t1, { button = clone, entry = v, hasHeader = u94 })
		clone.MouseButton1Click:Connect(function()
			selectIndex(i)
		end)
	end

	if #t1 > 0 then
		selectIndex(1)
	end
end

buildCells()

local function shownSignature()
	local t2: {[any]: any} = {}

	for _, v in ipairs(updateLogData.GetVisible()) do
		local text: string = tostring(v.id)

		table.insert(t2, text)
	end

	return table.concat(t2, ",")
end

local u29 = shownSignature()

task.spawn(function()
	while true do
		task.wait(10)

		local v105 = shownSignature()

		if v105 ~= u29 then
			u29 = v105
			buildCells()
		end
	end
end)

local n1: number = 0

scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	n1 += 1

	local v106: number = n1
	local scrollingFrameAbsoluteSize = scrollingFrame.AbsoluteSize

	task.wait(0.5)

	if v106 ~= n1 then
		return
	end

	if scrollingFrameAbsoluteSize ~= scrollingFrame.AbsoluteSize then
		return
	end

	if u23 then
		u23:Destroy()
		u23 = nil
	end

	if not u22 then
		return
	end

	local v108 = t1[u22]

	if v108 then
		u23 = buildContentFrame(v108.entry)
		u23.Visible = true
		u23.Parent = scrollingFrame
	end
end)
closeBtn.MouseButton1Click:Connect(function()
	closeUpdateLog:Fire()
end)
