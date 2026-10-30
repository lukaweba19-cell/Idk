-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local runService: RunService = game:GetService("RunService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local v7 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

local function stroke(parent, thickness)
	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Thickness = thickness
	uiStroke.Parent = parent
end

local t1: {[any]: any} = {}

local function shimmer(parent, p4, p5)
	parent.TextColor3 = Color3.new(1, 1, 1)

	local v21 = p4:Lerp(Color3.new(1, 1, 1), 0.75)
	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Rotation = 20

	local colorSequenceNew = ColorSequence.new

	uiGradient.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, p4),
		ColorSequenceKeypoint.new(0.4, p4),
		ColorSequenceKeypoint.new(0.5, v21),
		ColorSequenceKeypoint.new(0.6, p4),
		ColorSequenceKeypoint.new(1, p4)
	})
	uiGradient.Offset = Vector2.new(-1.3, 0)
	uiGradient.Parent = parent
	t1[uiGradient] = p5
end

runService.Heartbeat:Connect(function()
	local v24 = os.clock()

	for key, value in t1 do
		if key.Parent == nil then
			t1[key] = nil
		elseif key:FindFirstAncestorWhichIsA("ImageLabel") and key:FindFirstAncestorWhichIsA("ImageLabel").Visible then
			key.Offset = Vector2.new(-1.3 + 2.6 * ((v24 - value) % 2.2 / 2.2), 0)
		end
	end
end)

local function text(parent, name, text, textSize, layoutOrder)
	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Name = name
	textLabel.BackgroundTransparency = 1
	textLabel.AutomaticSize = Enum.AutomaticSize.X
	textLabel.Size = UDim2.fromOffset(0, textSize + 4)
	textLabel.FontFace = v7
	textLabel.TextSize = textSize
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = text
	textLabel.LayoutOrder = layoutOrder
	textLabel.ZIndex = 101

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Thickness = 2
	uiStroke.Parent = textLabel
	textLabel.Parent = parent

	return textLabel
end

local connection = nil

local function stopFollow()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end
local function placeAtMouse(p14)
	local x = p14.AbsoluteSize.X
	local y = p14.AbsoluteSize.Y
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v38 = CurrentCamera and CurrentCamera.ViewportSize.X or 1920
	local v39 = CurrentCamera and CurrentCamera.ViewportSize.Y or 1080
	local v40 = userInputService:GetMouseLocation()
	local v41 = guiService:GetGuiInset()
	local v42 = v40.X
	local n1 = v40.Y - v41.Y

	v41 = v42 + 16
	v40 = n1 + 8

	if v38 < v41 + x then
		v41 = v42 - 16 - x
	end

	if v39 < v40 + y then
		v40 = n1 - 8 - y
	end

	local uDim2FromOffset = UDim2.fromOffset
	local v45 = math.max(v41, 0)
	local v46 = math.max(v40, 0)

	p14.Position = uDim2FromOffset(v45, v46)
end

return {
	new = function(parent)
		local clone: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("HoverInfo"):Clone()

		clone.Name = "Fl8meyRewardTip"

		for iterFirst, iterSecond in clone:GetChildren() do
			if iterSecond:IsA("GuiObject") or iterSecond:IsA("UISizeConstraint") or iterSecond:IsA("UIPadding") or iterSecond:IsA("LuaSourceContainer") then
				iterSecond:Destroy()
			end
		end

		clone.AutomaticSize = Enum.AutomaticSize.XY
		clone.Size = UDim2.fromOffset(0, 0)
		clone.AnchorPoint = Vector2.new(0, 0)
		clone.Visible = false
		clone.ZIndex = 100

		local uiPadding: UIPadding = Instance.new("UIPadding")

		uiPadding.PaddingLeft = UDim.new(0, 12)
		uiPadding.PaddingRight = UDim.new(0, 12)
		uiPadding.PaddingTop = UDim.new(0, 5)
		uiPadding.PaddingBottom = UDim.new(0, 8)
		uiPadding.Parent = clone

		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 2)
		uiListLayout.Parent = clone
		clone.Parent = parent

		return clone
	end,
	fill = function(parent, p13)
		for iterFirst, iterSecond in parent:GetChildren() do
			if iterSecond:IsA("GuiObject") then
				iterSecond:Destroy()
			end
		end

		if typeof(p13.rim) == "Color3" then
			for iterFirst2, value in { "InnerStroke", "OuterStroke" }, nil, nil do
				local value = parent:FindFirstChild(value)

				if value and value:IsA("UIStroke") then
					value.Color = p13.rim
				end
			end
		end

		text(parent, "Header", p13.header, 18, 0)

		for iterFirst3, iterSecond2 in p13.rows, nil, nil do
			if iterSecond2.divider then
				local v62 = text(parent, "Divider", iterSecond2.divider, 13, iterFirst3)

				v62.TextColor3 = iterSecond2.dividerColor or Color3.new(1, 1, 1)
			else
				local row: Frame = Instance.new("Frame")

				row.Name = "Row"
				row.BackgroundTransparency = 1
				row.AutomaticSize = Enum.AutomaticSize.X
				row.Size = UDim2.fromOffset(0, 26)
				row.LayoutOrder = iterFirst3
				row.ZIndex = 101

				local uiListLayout: UIListLayout = Instance.new("UIListLayout")

				uiListLayout.FillDirection = Enum.FillDirection.Horizontal
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.Padding = UDim.new(0, 6)
				uiListLayout.Parent = row

				if iterSecond2.icon then
					local imageLabel: ImageLabel = Instance.new("ImageLabel")

					imageLabel.BackgroundTransparency = 1
					imageLabel.Image = iterSecond2.icon
					imageLabel.ScaleType = Enum.ScaleType.Fit
					imageLabel.Size = UDim2.fromOffset(26, 26)
					imageLabel.LayoutOrder = 1
					imageLabel.ZIndex = 101
					imageLabel.Parent = row
				end

				local v66 = text(row, "Text", iterSecond2.text or "", 16, 2)

				v66.Size = UDim2.fromOffset(0, 26)

				local v67 = if typeof(iterSecond2.gloss) == "Color3" then iterSecond2.gloss else nil

				if iterSecond2.rarity then
					local ok, result = pcall(rarity.GetColor, iterSecond2.rarity)

					if ok then
						v67 = result
					end
				end

				if v67 then
					shimmer(v66, v67, iterFirst3 * 0.12)
				end

				row.Parent = parent
			end
		end
	end,
	showAtMouse = function(p15)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		p15.Visible = true
		placeAtMouse(p15)
		task.defer(function()
			if p15.Visible then
				placeAtMouse(p15)
			end
		end)
		connection = userInputService.InputChanged:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseMovement and p15.Visible then
				placeAtMouse(p15)
			end
		end)
	end,
	showBeside = function(p17, p18)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v73 = p17.Parent
		local v74 = if v73 and v73:IsA("LayerCollector") then v73.AbsolutePosition else Vector2.zero

		local function place()
			local n1 = p18.AbsolutePosition - v74
			local absoluteSize = p17.AbsoluteSize
			local n2 = n1.X + p18.AbsoluteSize.X + 16

			if (if v73 and v73:IsA("LayerCollector") then v73.AbsoluteSize.X else math.huge) < n2 + absoluteSize.X then
				n2 = n1.X - 16 - absoluteSize.X
			end

			p17.Position = UDim2.fromOffset(n2, n1.Y + 8)
		end

		p17.Visible = true
		place()
		task.defer(function()
			if p17.Visible then
				place()
			end
		end)
	end,
	hide = function(p19)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if p19 then
			p19.Visible = false
		end
	end
}
