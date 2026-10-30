-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, p2)
	local widget: Frame = Instance.new("Frame")

	widget:SetAttribute("WidgetUID", p1.UID)
	widget.Name = "Widget"
	widget.BackgroundTransparency = 1
	widget.Visible = true
	widget.ZIndex = 20
	widget.Active = false
	widget.ClipsDescendants = true

	local iconButton: Frame = Instance.new("Frame")

	iconButton.Name = "IconButton"
	iconButton.Visible = true
	iconButton.ZIndex = 2
	iconButton.BorderSizePixel = 0
	iconButton.Parent = widget
	iconButton.ClipsDescendants = true
	iconButton.Active = false
	p1.deselected:Connect(function()
		iconButton.ClipsDescendants = true
		task.delay(0.2, function()
			if p1.isSelected then
				iconButton.ClipsDescendants = false
			end
		end)
	end)

	local guiService: GuiService = game:GetService("GuiService")

	p1:setBehaviour("IconButton", "BackgroundTransparency", function(p3)
		if p3 == 1 then
			return p3
		end

		return p3 * guiService.PreferredTransparency
	end)

	local janitor = p1.janitor
	local v7: RBXScriptSignal = guiService:GetPropertyChangedSignal("PreferredTransparency")

	janitor:add(v7:Connect(function()
		p1:refreshAppearance(iconButton, "BackgroundTransparency")
	end))

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner:SetAttribute("Collective", "IconCorners")
	uiCorner.Name = "UICorner"
	uiCorner.Parent = iconButton

	local parent = require(script.Parent.Menu)(p1)
	local menuUIListLayout = parent.MenuUIListLayout
	local menuGap = parent.MenuGap

	parent.Parent = iconButton

	local iconSpot: Frame = Instance.new("Frame")

	iconSpot.Name = "IconSpot"
	iconSpot.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
	iconSpot.BackgroundTransparency = 0.9
	iconSpot.Visible = true
	iconSpot.AnchorPoint = Vector2.new(0, 0.5)
	iconSpot.ZIndex = 5
	iconSpot.Parent = parent

	local clone: Instance = uiCorner:Clone()

	clone.Parent = iconSpot

	local clone2: Instance = iconSpot:Clone()

	clone2.UICorner.Name = "OverlayUICorner"
	clone2.Name = "IconOverlay"
	clone2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	clone2.ZIndex = iconSpot.ZIndex + 1
	clone2.Size = UDim2.new(1, 0, 1, 0)
	clone2.Position = UDim2.new(0, 0, 0, 0)
	clone2.AnchorPoint = Vector2.new(0, 0)
	clone2.Visible = false
	clone2.Parent = iconSpot

	local clickRegion: TextButton = Instance.new("TextButton")

	clickRegion:SetAttribute("CorrespondingIconUID", p1.UID)
	clickRegion.Name = "ClickRegion"
	clickRegion.BackgroundTransparency = 1
	clickRegion.Visible = true
	clickRegion.Text = ""
	clickRegion.ZIndex = 20
	clickRegion.Selectable = true
	clickRegion.SelectionGroup = true
	clickRegion.Parent = iconSpot
	require(script.Parent.Parent.Features.Gamepad).registerButton(clickRegion)

	local clone3: Instance = uiCorner:Clone()

	clone3.Parent = clickRegion

	local contents: Frame = Instance.new("Frame")

	contents.Name = "Contents"
	contents.BackgroundTransparency = 1
	contents.Size = UDim2.fromScale(1, 1)
	contents.Parent = iconSpot

	local contentsList: UIListLayout = Instance.new("UIListLayout")

	contentsList.Name = "ContentsList"
	contentsList.FillDirection = Enum.FillDirection.Horizontal
	contentsList.VerticalAlignment = Enum.VerticalAlignment.Center
	contentsList.SortOrder = Enum.SortOrder.LayoutOrder
	contentsList.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
	contentsList.Padding = UDim.new(0, 3)
	contentsList.Parent = contents

	local paddingLeft: Frame = Instance.new("Frame")

	paddingLeft.Name = "PaddingLeft"
	paddingLeft.LayoutOrder = 1
	paddingLeft.ZIndex = 5
	paddingLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingLeft.BackgroundTransparency = 1
	paddingLeft.BorderSizePixel = 0
	paddingLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingLeft.Parent = contents

	local paddingCenter: Frame = Instance.new("Frame")

	paddingCenter.Name = "PaddingCenter"
	paddingCenter.LayoutOrder = 3
	paddingCenter.ZIndex = 5
	paddingCenter.Size = UDim2.new(0, 0, 1, 0)
	paddingCenter.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingCenter.BackgroundTransparency = 1
	paddingCenter.BorderSizePixel = 0
	paddingCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingCenter.Parent = contents

	local paddingRight: Frame = Instance.new("Frame")

	paddingRight.Name = "PaddingRight"
	paddingRight.LayoutOrder = 5
	paddingRight.ZIndex = 5
	paddingRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingRight.BackgroundTransparency = 1
	paddingRight.BorderSizePixel = 0
	paddingRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingRight.Parent = contents

	local iconLabelContainer: Frame = Instance.new("Frame")

	iconLabelContainer.Name = "IconLabelContainer"
	iconLabelContainer.LayoutOrder = 4
	iconLabelContainer.ZIndex = 3
	iconLabelContainer.AnchorPoint = Vector2.new(0, 0.5)
	iconLabelContainer.Size = UDim2.new(0, 0, 0.5, 0)
	iconLabelContainer.BackgroundTransparency = 1
	iconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	iconLabelContainer.Parent = contents

	local iconLabel: TextLabel = Instance.new("TextLabel")
	local n1 = workspace.CurrentCamera.ViewportSize.X + 200

	iconLabel.Name = "IconLabel"
	iconLabel.LayoutOrder = 4
	iconLabel.ZIndex = 15
	iconLabel.AnchorPoint = Vector2.new(0, 0)
	iconLabel.Size = UDim2.new(0, n1, 1, 0)
	iconLabel.ClipsDescendants = false
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.fromScale(0, 0)
	iconLabel.RichText = true
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.TextXAlignment = Enum.TextXAlignment.Left
	iconLabel.Text = ""
	iconLabel.TextWrapped = true
	iconLabel.TextWrap = true
	iconLabel.TextScaled = false
	iconLabel.Active = false
	iconLabel.AutoLocalize = true
	iconLabel.Parent = iconLabelContainer

	local iconImage: ImageLabel = Instance.new("ImageLabel")

	iconImage.Name = "IconImage"
	iconImage.LayoutOrder = 2
	iconImage.ZIndex = 15
	iconImage.AnchorPoint = Vector2.new(0, 0.5)
	iconImage.Size = UDim2.new(0, 0, 0.5, 0)
	iconImage.BackgroundTransparency = 1
	iconImage.Position = UDim2.new(0, 11, 0.5, 0)
	iconImage.ScaleType = Enum.ScaleType.Stretch
	iconImage.Active = false
	iconImage.Parent = contents

	local clone4: Instance = uiCorner:Clone()

	clone4:SetAttribute("Collective", nil)
	clone4.CornerRadius = UDim.new(0, 0)
	clone4.Name = "IconImageCorner"
	clone4.Parent = iconImage

	local tweenService: TweenService = game:GetService("TweenService")
	local n2: number = 0

	local v29 = require(script.Parent.Parent.Utility).createStagger(0.01, function(_)
		task.defer(function()
			local indicator = p1.indicator
			local indicatorVisible = indicator and indicator.Visible
			local v48 = indicatorVisible or iconLabel.Text ~= ""
			local u49 = iconImage.Image ~= "" and iconImage.Image ~= nil
			local center = Enum.HorizontalAlignment.Center
			local v51 = UDim2.fromScale(1, 1)

			if u49 and not v48 then
				iconLabelContainer.Visible = false
				iconImage.Visible = true
				paddingLeft.Visible = false
				paddingCenter.Visible = false
				paddingRight.Visible = false
			elseif not u49 and v48 then
				iconLabelContainer.Visible = true
				iconImage.Visible = false
				paddingLeft.Visible = true
				paddingCenter.Visible = false
				paddingRight.Visible = true
			elseif u49 and v48 then
				iconLabelContainer.Visible = true
				iconImage.Visible = true
				paddingLeft.Visible = true
				paddingCenter.Visible = not indicatorVisible
				paddingRight.Visible = not indicatorVisible

				local left = Enum.HorizontalAlignment.Left
			end

			iconButton.Size = v51
			v51 = function(p5)
				return p5:GetAttribute("TargetWidth") or p5.AbsoluteSize.X
			end

			local offset = contentsList.Padding.Offset

			u49 = offset
			iconLabelContainer.Size = UDim2.new(0, iconLabel.TextBounds.X, iconLabel.Size.Y.Scale, 0)

			for _, v in pairs(contents:GetChildren()) do
				if v:IsA("GuiObject") and v.Visible == true then
					local targetWidth = v:GetAttribute("TargetWidth")

					u49 += (targetWidth or v.AbsoluteSize.X) + offset
				end
			end

			local minimumWidth: any = widget:GetAttribute("MinimumWidth")
			local minimumHeight: any = widget:GetAttribute("MinimumHeight")
			local borderSize: any = widget:GetAttribute("BorderSize")
			local v60 = math.clamp(u49, minimumWidth, n1)
			local n3 = 0

			u49 = #p1.menuIcons > 0 and p1.isSelected

			if u49 then
				for _, v in pairs(parent:GetChildren()) do
					if v ~= iconSpot and v:IsA("GuiObject") and v.Visible then
						local v64 = v:GetAttribute("TargetWidth") or v.AbsoluteSize.X

						n3 += v64 + menuUIListLayout.Padding.Offset
					end
				end

				if not iconSpot.Visible then
					local v65: Frame = iconSpot
					local targetWidth: any = v65:GetAttribute("TargetWidth")

					v60 -= (targetWidth or v65.AbsoluteSize.X) + menuUIListLayout.Padding.Offset * 2 + borderSize
				end

				n3 -= borderSize * 0.5
				v60 += n3 - borderSize * 0.75
			end

			menuGap.Visible = u49 and iconSpot.Visible

			local desiredWidth: any = widget:GetAttribute("DesiredWidth")

			if desiredWidth and v60 < desiredWidth then
				v60 = desiredWidth
			end

			p1.updateMenu:Fire()

			local n4 = math.max(v60 - n3, minimumWidth) - borderSize * 2
			local menuWidth = parent:GetAttribute("MenuWidth")

			u49 = menuWidth and menuWidth + n4 + menuUIListLayout.Padding.Offset + 10

			if u49 then
				local maxWidth = parent:GetAttribute("MaxWidth")

				if maxWidth then
					u49 = math.max(maxWidth, minimumWidth)
				end

				parent:SetAttribute("MenuCanvasWidth", v60)

				if u49 < v60 then
					v60 = u49
				end
			end

			local quint = Enum.EasingStyle.Quint
			local out = Enum.EasingDirection.Out
			local v73: Frame = iconSpot
			local targetWidth: any = v73:GetAttribute("TargetWidth")
			local v75 = math.max(n4, targetWidth or v73.AbsoluteSize.X, iconSpot.AbsoluteSize.X)
			local v76: Frame = widget
			local targetWidth2: any = v76:GetAttribute("TargetWidth")
			local v78 = math.max(v60, targetWidth2 or v76.AbsoluteSize.X, widget.AbsoluteSize.X)
			local tweenInfo = TweenInfo.new(v75 / 750, quint, out)
			local tweenInfo2 = TweenInfo.new(v78 / 750, quint, out)
			local uDim2 = UDim2.new(0, borderSize, 0.5, 0)
			local uDim22 = UDim2.new(0, n4, 1, -borderSize * 2)

			tweenService:Create(iconSpot, tweenInfo, { Position = uDim2, Size = uDim22 }):Play()

			local uDim23 = UDim2.new(0, n4, 1, 0)

			tweenService:Create(clickRegion, tweenInfo, { Size = uDim23 }):Play()
			v78 = UDim2.fromOffset(v60, minimumHeight)

			if minimumHeight ~= widget.Size.Y.Offset then
				widget.Size = v78
			end

			widget:SetAttribute("TargetWidth", v78.X.Offset)
			tweenService:Create(widget, tweenInfo2, { Size = v78 }):Play()
			n2 += 1

			for i = 1, tweenInfo2.Time * 100 do
				task.delay(i / 100, function()
					p2.iconChanged:Fire(p1)
				end)
			end

			task.delay(tweenInfo2.Time - 0.2, function()
				n2 -= 1
				task.defer(function()
					if n2 == 0 then
						p1.resizingComplete:Fire()
					end
				end)
			end)
			p1:updateParent()
		end)
	end)

	local u30: boolean = true

	p1:setBehaviour("IconLabel", "Text", v29)
	p1:setBehaviour("IconLabel", "FontFace", function(p6)
		if p6 == iconLabel.FontFace then
			return
		end

		task.spawn(function()
			v29()

			if u30 then
				u30 = false

				for _ = 1, 10 do
					task.wait(1)
					v29()
				end
			end
		end)
	end)

	local function updateBorderSize()
		task.defer(function()
			local borderSize: any = widget:GetAttribute("BorderSize")

			parent.Position = UDim2.new(0, if iconSpot.Visible == false then 0 else p1.alignment == "Right" and -borderSize or borderSize, 0, 0)
			menuGap.Size = UDim2.fromOffset(borderSize, 0)
			menuUIListLayout.Padding = UDim.new(0, 0)
			v29()
		end)
	end

	p1:setBehaviour("Widget", "BorderSize", updateBorderSize)
	p1:setBehaviour("IconSpot", "Visible", updateBorderSize)
	p1.startMenuUpdate:Connect(v29)
	p1.updateSize:Connect(v29)
	p1:setBehaviour("ContentsList", "HorizontalAlignment", v29)
	p1:setBehaviour("Widget", "Visible", v29)
	p1:setBehaviour("Widget", "DesiredWidth", v29)
	p1:setBehaviour("Widget", "MinimumWidth", v29)
	p1:setBehaviour("Widget", "MinimumHeight", v29)
	p1:setBehaviour("Indicator", "Visible", v29)
	p1:setBehaviour("IconImageRatio", "AspectRatio", v29)
	p1:setBehaviour("IconImage", "Image", function(p7)
		local s1 = tonumber(p7) and "http://www.roblox.com/asset/?id=" .. p7 or p7 or ""

		if s1 ~= iconImage.Image then
			v29()
		end

		return s1
	end)
	p1.alignmentChanged:Connect(function(p8: string)
		if p8 == "Center" then
			p8 = "Left"
		end

		menuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[p8]
		task.defer(function()
			local borderSize: any = widget:GetAttribute("BorderSize")

			parent.Position = UDim2.new(0, if iconSpot.Visible == false then 0 else p1.alignment == "Right" and -borderSize or borderSize, 0, 0)
			menuGap.Size = UDim2.fromOffset(borderSize, 0)
			menuUIListLayout.Padding = UDim.new(0, 0)
			v29()
		end)
	end)

	local LocalPlayer: Player = game:GetService("Players").LocalPlayer
	local localPlayerLocaleId: string = LocalPlayer.LocaleId
	local v34 = p1.janitor
	local v35: RBXScriptSignal = LocalPlayer:GetPropertyChangedSignal("LocaleId")

	v34:add(v35:Connect(function()
		task.delay(0.2, function()
			local localPlayerLocaleId2: string = LocalPlayer.LocaleId

			if localPlayerLocaleId2 ~= localPlayerLocaleId then
				localPlayerLocaleId = localPlayerLocaleId2
				p1:refresh()
				task.wait(0.5)
				p1:refresh()
			end
		end)
	end))

	local iconImageScale: NumberValue = Instance.new("NumberValue")

	iconImageScale.Name = "IconImageScale"
	iconImageScale.Parent = iconImage
	iconImageScale:GetPropertyChangedSignal("Value"):Connect(function()
		iconImage.Size = UDim2.new(iconImageScale.Value, 0, iconImageScale.Value, 0)
	end)

	local iconImageRatio: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	iconImageRatio.Name = "IconImageRatio"
	iconImageRatio.AspectType = Enum.AspectType.FitWithinMaxSize
	iconImageRatio.DominantAxis = Enum.DominantAxis.Height
	iconImageRatio.Parent = iconImage

	local iconGradient: UIGradient = Instance.new("UIGradient")

	iconGradient.Name = "IconGradient"
	iconGradient.Enabled = true
	iconGradient.Parent = iconButton

	local iconSpotGradient: UIGradient = Instance.new("UIGradient")

	iconSpotGradient.Name = "IconSpotGradient"
	iconSpotGradient.Enabled = true
	iconSpotGradient.Parent = iconSpot

	return widget
end
