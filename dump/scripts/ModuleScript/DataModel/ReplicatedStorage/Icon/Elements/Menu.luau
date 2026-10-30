-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1)
	local menu: ScrollingFrame = Instance.new("ScrollingFrame")

	menu.Name = "Menu"
	menu.BackgroundTransparency = 1
	menu.Visible = true
	menu.ZIndex = 1
	menu.Size = UDim2.fromScale(1, 1)
	menu.ClipsDescendants = true
	menu.TopImage = ""
	menu.BottomImage = ""
	menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	menu.CanvasSize = UDim2.new(0, 0, 1, -1)
	menu.ScrollingEnabled = true
	menu.ScrollingDirection = Enum.ScrollingDirection.X
	menu.ZIndex = 20
	menu.ScrollBarThickness = 3
	menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	menu.ScrollBarImageTransparency = 0.8
	menu.BorderSizePixel = 0
	menu.Selectable = false

	local iconModule = require(p1.iconModule)
	local clone = iconModule.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()

	clone.Name = "MenuUIListLayout"
	clone.VerticalAlignment = Enum.VerticalAlignment.Center
	clone.Parent = menu

	local menuGap: Frame = Instance.new("Frame")

	menuGap.Name = "MenuGap"
	menuGap.BackgroundTransparency = 1
	menuGap.Visible = false
	menuGap.AnchorPoint = Vector2.new(0, 0.5)
	menuGap.ZIndex = 5
	menuGap.Parent = menu

	local u6: boolean = false
	local themes = require(script.Parent.Parent.Features.Themes)

	p1.menuChildAdded:Connect(function()
		local menuJanitor = p1.menuJanitor

		if u6 then
			if #p1.menuIcons <= 0 then
				menuJanitor:clean()
				u6 = false
			end

			return
		end

		u6 = true
		menuJanitor:add(p1.toggled:Connect(function()
			if #p1.menuIcons > 0 then
				p1.updateSize:Fire()
			end
		end))

		local v9, v10 = p1:modifyTheme({ { "Menu", "Active", true } })

		task.defer(function()
			menuJanitor:add(function()
				p1:removeModification(v10)
			end)
		end)

		local x = menu.AbsoluteCanvasSize.X

		local function rightAlignCanvas()
			if p1.alignment == "Right" then
				local x2 = menu.AbsoluteCanvasSize.X
				local n1 = x - x2

				x = x2
				menu.CanvasPosition = Vector2.new(menu.CanvasPosition.X - n1, 0)
			end
		end

		menuJanitor:add(p1.selected:Connect(rightAlignCanvas))

		local v13 = menu:GetPropertyChangedSignal("AbsoluteCanvasSize")

		menuJanitor:add(v13:Connect(rightAlignCanvas))
		rightAlignCanvas = p1:getStateGroup()

		local v14 = themes.getThemeValue(rightAlignCanvas, "IconImage", "Image", "Deselected")
		local v15 = themes.getThemeValue(rightAlignCanvas, "IconImage", "Image", "Selected")

		if v14 == v15 then
			local v16 = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal)

			p1:removeModificationWith("IconLabel", "Text", "Viewing")
			p1:removeModificationWith("IconLabel", "Image", "Viewing")
			p1:modifyTheme({
				{ "IconLabel", "FontFace", v16, "Selected" },
				{ "IconLabel", "Text", "X", "Selected" },
				{ "IconLabel", "TextSize", 20, "Selected" },
				{ "IconLabel", "TextStrokeTransparency", 0.8, "Selected" },
				{ "IconImage", "Image", "", "Selected" }
			})
		end

		local v17 = p1:getInstance("MenuGap")

		menuJanitor:add(p1.alignmentChanged:Connect(function()
			local n1: number = -99999
			local n2: number = -99998

			if p1.alignment == "Right" then
				n1 = 99999
				n2 = 99998
			end

			p1:modifyTheme({ "IconSpot", "LayoutOrder", n1 })
			v17.LayoutOrder = n2
		end))
		v13 = -99999

		local n1 = -99998

		if p1.alignment == "Right" then
			v13 = 99999
			n1 = 99998
		end

		p1:modifyTheme({ "IconSpot", "LayoutOrder", v13 })
		v17.LayoutOrder = n1
		menu:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function()
			local menuCanvasWidth: any = menu:GetAttribute("MenuCanvasWidth")
			local y = menu.CanvasSize.Y

			menu.CanvasSize = UDim2.new(0, menuCanvasWidth, y.Scale, y.Offset)
		end)
		menuJanitor:add(p1.updateMenu:Connect(function()
			local maxIcons: any = menu:GetAttribute("MaxIcons")

			if not maxIcons then
				return
			end

			local t1: {[any]: any} = {}

			for _, v in pairs(menu:GetChildren()) do
				if v:GetAttribute("WidgetUID") and v.Visible then
					table.insert(t1, { v, v.AbsolutePosition.X })
				end
			end

			table.sort(t1, function(p2, p3)
				return p2[2] < p3[2]
			end)

			local n1 = 0

			for i = 1, maxIcons do
				local v37 = t1[i]

				if not v37 then
					break
				end

				n1 += v37[1].AbsoluteSize.X + clone.Padding.Offset
			end

			menu:SetAttribute("MenuWidth", n1)
		end))

		local function startMenuUpdate()
			task.delay(0.1, function()
				p1.startMenuUpdate:Fire()
			end)
		end

		menuJanitor:add(menu.ChildAdded:Connect(startMenuUpdate))
		menuJanitor:add(menu.ChildRemoved:Connect(startMenuUpdate))
		n1 = menu:GetAttributeChangedSignal("MaxIcons")
		menuJanitor:add(n1:Connect(startMenuUpdate))
		n1 = menu:GetAttributeChangedSignal("MaxWidth")
		menuJanitor:add(n1:Connect(startMenuUpdate))
		task.delay(0.1, function()
			p1.startMenuUpdate:Fire()
		end)
	end)
	p1.menuSet:Connect(function(p4)
		for _, v in pairs(p1.menuIcons) do
			iconModule.getIconByUID(v):destroy()
		end

		if type(p4) == "table" then
			for _, v in pairs(p4) do
				v:joinMenu(p1)
			end
		end
	end)

	return menu
end
