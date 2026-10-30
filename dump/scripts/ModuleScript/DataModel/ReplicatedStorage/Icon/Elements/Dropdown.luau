-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local themes = require(script.Parent.Parent.Features.Themes)

return function(p1)
	local dropdown: Frame = Instance.new("Frame")

	dropdown.Name = "Dropdown"
	dropdown.AutomaticSize = Enum.AutomaticSize.X
	dropdown.BackgroundTransparency = 1
	dropdown.BorderSizePixel = 0
	dropdown.AnchorPoint = Vector2.new(0.5, 0)
	dropdown.Position = UDim2.new(0.5, 0, 1, 10)
	dropdown.ZIndex = -2
	dropdown.ClipsDescendants = true
	dropdown.Parent = p1.widget

	local guiService: GuiService = game:GetService("GuiService")

	p1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2)
		if p2 == 1 then
			return p2
		end

		return p2 * guiService.PreferredTransparency
	end)

	local janitor = p1.janitor
	local v8: RBXScriptSignal = guiService:GetPropertyChangedSignal("PreferredTransparency")

	janitor:add(v8:Connect(function()
		p1:refreshAppearance(dropdown, "BackgroundTransparency")
	end))

	local dropdownCorner: UICorner = Instance.new("UICorner")

	dropdownCorner.Name = "DropdownCorner"
	dropdownCorner.CornerRadius = UDim.new(0, 10)
	dropdownCorner.Parent = dropdown

	local dropdownScroller: ScrollingFrame = Instance.new("ScrollingFrame")

	dropdownScroller.Name = "DropdownScroller"
	dropdownScroller.AutomaticSize = Enum.AutomaticSize.X
	dropdownScroller.BackgroundTransparency = 1
	dropdownScroller.BorderSizePixel = 0
	dropdownScroller.AnchorPoint = Vector2.new(0, 0)
	dropdownScroller.Position = UDim2.new(0, 0, 0, 0)
	dropdownScroller.ZIndex = -1
	dropdownScroller.ClipsDescendants = true
	dropdownScroller.Visible = true
	dropdownScroller.VerticalScrollBarInset = Enum.ScrollBarInset.None
	dropdownScroller.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	dropdownScroller.Active = false
	dropdownScroller.ScrollingEnabled = true
	dropdownScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	dropdownScroller.ScrollBarThickness = 5
	dropdownScroller.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	dropdownScroller.ScrollBarImageTransparency = 0.8
	dropdownScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	dropdownScroller.Selectable = false
	dropdownScroller.Active = true
	dropdownScroller.Parent = dropdown

	local dropdownSpeed: NumberValue = Instance.new("NumberValue")

	dropdownSpeed.Name = "DropdownSpeed"
	dropdownSpeed.Value = 0.07
	dropdownSpeed.Parent = dropdown

	local dropdownPadding: UIPadding = Instance.new("UIPadding")

	dropdownPadding.Name = "DropdownPadding"
	dropdownPadding.PaddingTop = UDim.new(0, 0)
	dropdownPadding.PaddingBottom = UDim.new(0, 0)
	dropdownPadding.Parent = dropdownScroller

	local dropdownList: UIListLayout = Instance.new("UIListLayout")

	dropdownList.Name = "DropdownList"
	dropdownList.FillDirection = Enum.FillDirection.Vertical
	dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	dropdownList.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	dropdownList.Parent = dropdownScroller

	local dropdownJanitor = p1.dropdownJanitor
	local iconModule = require(p1.iconModule)

	p1.dropdownChildAdded:Connect(function(p3)
		local v33, v34 = p3:modifyTheme({
			{ "Widget", "BorderSize", 0 },
			{ "IconCorners", "CornerRadius", UDim.new(0, 10) },
			{ "Widget", "MinimumWidth", 190 },
			{ "Widget", "MinimumHeight", 58 },
			{ "IconLabel", "TextSize", 20 },
			{ "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
			{ "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
			{ "Notice", "Position", UDim2.new(1, -24, 0, 5) },
			{ "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
			{ "Selection", "Size", UDim2.new(1, -0.0, 1, -0.0) },
			{ "Selection", "Position", UDim2.new(0, 0, 0, 0) }
		})

		task.defer(function()
			p3.joinJanitor:add(function()
				p3:removeModification(v34)
			end)
		end)
	end)
	p1.dropdownSet:Connect(function(p4)
		for _, v in pairs(p1.dropdownIcons) do
			iconModule.getIconByUID(v):destroy()
		end

		if type(p4) == "table" then
			for _, v in pairs(p4) do
				v:joinDropdown(p1)
			end
		end
	end)

	local function updateMaxIcons()
		local maxIcons: any = dropdown:GetAttribute("MaxIcons")

		if not maxIcons then
			return 0
		end

		local t1: {[any]: any} = {}

		for _, v in pairs(dropdownScroller:GetChildren()) do
			if v:IsA("GuiObject") and v.Visible then
				table.insert(t1, v)
			end
		end

		table.sort(t1, function(p5, p6)
			return p5.AbsolutePosition.Y < p6.AbsolutePosition.Y
		end)

		local n1 = 0
		local roundedUp = math.ceil(maxIcons)

		for i = 1, roundedUp do
			local v47 = t1[i]

			if not v47 then
				break
			end

			local v48 = v47.AbsoluteSize.Y

			if i == roundedUp and roundedUp ~= maxIcons then
				v48 *= maxIcons - roundedUp + 1
			end

			n1 += v48
		end

		return n1 + (dropdownPadding.PaddingTop.Offset + dropdownPadding.PaddingBottom.Offset)
	end

	local u17 = nil
	local u18 = nil
	local u19 = nil
	local u20 = nil

	local function getTweenInfo()
		local v49 = themes.getInstanceValue(dropdown, "MaxIcons") or 1

		if u19 and v49 == u19 and u20 then
			return u20
		end

		local tweenInfo = TweenInfo.new(dropdownSpeed.Value * v49, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		u20 = tweenInfo
		u19 = v49

		return tweenInfo
	end
	local function updateVisibility()
		local v51 = themes.getInstanceValue(dropdown, "MaxIcons") or 1
		local v52

		if u19 and v51 == u19 and u20 then
			v52 = u20
		else
			local tweenInfo = TweenInfo.new(dropdownSpeed.Value * v51, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

			u20 = tweenInfo
			u19 = v51
			v52 = tweenInfo
		end

		if u17 then
			u17:Cancel()
			u17 = nil
		end

		if u18 then
			u18:Cancel()
			u18 = nil
		end

		if p1.isSelected then
			local v54 = updateMaxIcons()

			dropdown.Visible = true
			dropdown.BackgroundTransparency = 0
			dropdown.Size = UDim2.new(0, dropdown.Size.X.Offset, 0, 0)

			local uDim2 = UDim2.new(0, dropdown.Size.X.Offset, 0, v54)

			u17 = tweenService:Create(dropdown, v52, { Size = uDim2 })
			u17:Play()
			u17.Completed:Connect(function()
				u17 = nil
			end)

			return
		end

		local uDim2 = UDim2.new(0, dropdown.Size.X.Offset, 0, 0)

		u18 = tweenService:Create(dropdown, TweenInfo.new(0), { Size = uDim2 })
		u18:Play()
		u18.Completed:Connect(function()
			u18 = nil
		end)
	end

	dropdownJanitor:add(p1.toggled:Connect(updateVisibility))
	updateVisibility()

	local function updateChildSize()
		local v57 = themes.getInstanceValue(dropdown, "MaxIcons") or 1
		local v58

		if u19 and v57 == u19 and u20 then
			v58 = u20
		else
			local tweenInfo = TweenInfo.new(dropdownSpeed.Value * v57, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

			u20 = tweenInfo
			u19 = v57
			v58 = tweenInfo
		end

		if not p1.isSelected then
			return
		end

		if u17 then
			u17:Cancel()
			u17 = nil
		end

		if u18 then
			u18:Cancel()
			u18 = nil
		end

		runService.Heartbeat:Wait()
		v57 = updateMaxIcons()

		local uDim2 = UDim2.new(0, dropdown.Size.X.Offset, 0, v57)

		u17 = tweenService:Create(dropdown, v58, { Size = uDim2 })
		u17:Play()
		u17.Completed:Connect(function()
			u17 = nil
		end)
	end

	dropdownJanitor:add(p1.toggled:Connect(updateVisibility))

	local n1: number = 0
	local u25: boolean = false

	local function updateMaxIconsListener()
		n1 += 1

		if u25 then
			return
		end

		local v61: number = n1

		u25 = true
		task.defer(function()
			u25 = false

			if n1 ~= v61 then
				updateMaxIconsListener()
			end
		end)

		local maxIcons: any = dropdown:GetAttribute("MaxIcons")

		if not maxIcons then
			return
		end

		local t2: {[any]: any} = {}

		for _, v in pairs(dropdownScroller:GetChildren()) do
			if v:IsA("GuiObject") and v.Visible then
				table.insert(t2, { v, v.AbsolutePosition.Y })
			end
		end

		table.sort(t2, function(p7, p8)
			return p7[2] < p8[2]
		end)

		local n2 = 0
		local u67: boolean = false
		local roundedUp = math.ceil(maxIcons)

		for i = 1, roundedUp do
			local v70 = t2[i]

			if not v70 then
				break
			end

			local v71 = v70[1]
			local v72 = v71.AbsoluteSize.Y
			local u73: boolean = i == roundedUp and roundedUp ~= maxIcons

			if u73 then
				v72 *= maxIcons - roundedUp + 1
			end

			n2 += v72

			if not u73 then
				local widgetUID = v71:GetAttribute("WidgetUID")
				local v75 = widgetUID

				if v75 then
					v75 = iconModule.getIconByUID(widgetUID)
				end

				if not v75 then
					continue
				end

				local v76 = nil

				if not u67 then
					u67 = true
					v76 = p1:getInstance("ClickRegion")
				end

				local v77 = v75:getInstance("ClickRegion")

				v77.NextSelectionUp = v76
			end
		end

		dropdownScroller.Size = UDim2.fromOffset(0, n2 + (dropdownPadding.PaddingTop.Offset + dropdownPadding.PaddingBottom.Offset))
	end

	local v27: RBXScriptSignal = dropdownScroller:GetPropertyChangedSignal("AbsoluteCanvasSize")

	dropdownJanitor:add(v27:Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdownScroller.ChildAdded:Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdownScroller.ChildRemoved:Connect(updateChildSize))
	dropdownJanitor:add(dropdownScroller.ChildRemoved:Connect(updateMaxIconsListener))
	v27 = dropdown:GetAttributeChangedSignal("MaxIcons")
	dropdownJanitor:add(v27:Connect(updateMaxIconsListener))
	v27 = dropdown:GetAttributeChangedSignal("MaxIcons")
	dropdownJanitor:add(v27:Connect(updateChildSize))
	dropdownJanitor:add(p1.childThemeModified:Connect(updateMaxIconsListener))
	updateMaxIconsListener()

	local function connectVisibilityListeners(p9)
		if p9:IsA("GuiObject") then
			p9:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
			p9:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
		end
	end

	for _, v in pairs(dropdownScroller:GetChildren()) do
		if v:IsA("GuiObject") then
			v:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
			v:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
		end
	end

	dropdownScroller.ChildAdded:Connect(function(child: Instance)
		runService.Heartbeat:Wait()

		if child:IsA("GuiObject") then
			child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
			child:GetPropertyChangedSignal("Size"):Connect(updateChildSize)
		end

		updateChildSize()
	end)
	dropdown.Visible = false

	return dropdown
end
