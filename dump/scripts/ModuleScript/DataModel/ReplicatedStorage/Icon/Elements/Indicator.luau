-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, _)
	local widget = p1.widget
	local parent = p1:getInstance("Contents")
	local indicator: Frame = Instance.new("Frame")

	indicator.Name = "Indicator"
	indicator.LayoutOrder = 9999999
	indicator.ZIndex = 6
	indicator.Size = UDim2.new(0, 42, 0, 42)
	indicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	indicator.BackgroundTransparency = 1
	indicator.Position = UDim2.new(1, 0, 0.5, 0)
	indicator.BorderSizePixel = 0
	indicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	indicator.Parent = parent

	local indicatorButton: Frame = Instance.new("Frame")

	indicatorButton.Name = "IndicatorButton"
	indicatorButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	indicatorButton.AnchorPoint = Vector2.new(0.5, 0.5)
	indicatorButton.BorderSizePixel = 0
	indicatorButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	indicatorButton.Parent = indicator

	local guiService: GuiService = game:GetService("GuiService")
	local gamepadService: GamepadService = game:GetService("GamepadService")
	local v9 = p1:getInstance("ClickRegion")

	local function selectionChanged()
		if guiService.SelectedObject == v9 then
			indicatorButton.BackgroundTransparency = 1
			indicatorButton.Position = UDim2.new(0.5, -2, 0.5, 0)
			indicatorButton.Size = UDim2.fromScale(1.2, 1.2)

			return
		end

		indicatorButton.BackgroundTransparency = 0.75
		indicatorButton.Position = UDim2.new(0.5, 2, 0.5, 0)
		indicatorButton.Size = UDim2.fromScale(1, 1)
	end

	local janitor = p1.janitor
	local v12: RBXScriptSignal = guiService:GetPropertyChangedSignal("SelectedObject")

	janitor:add(v12:Connect(selectionChanged))
	selectionChanged()

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.LayoutOrder = 2
	imageLabel.ZIndex = 15
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	imageLabel.Image = "rbxasset://textures/ui/Controls/XboxController/DPadUp@2x.png"
	imageLabel.Parent = indicatorButton

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = indicatorButton

	local userInputService: UserInputService = game:GetService("UserInputService")

	local function setIndicatorVisible(p3: boolean)
		if p3 == nil then
			p3 = indicator.Visible
		end

		if gamepadService.GamepadCursorEnabled then
			p3 = false
		end

		if p3 then
			p1:modifyTheme({ "PaddingRight", "Size", UDim2.new(0, 0, 1, 0) }, "IndicatorPadding")
		elseif indicator.Visible then
			p1:removeModification("IndicatorPadding")
		end

		p1:modifyTheme({ "Indicator", "Visible", p3 })
		p1.updateSize:Fire()
	end

	local v17 = p1.janitor
	local v18: RBXScriptSignal = gamepadService:GetPropertyChangedSignal("GamepadCursorEnabled")

	v17:add(v18:Connect(setIndicatorVisible))
	p1.indicatorSet:Connect(function(p4)
		local u22: boolean = false

		if p4 then
			imageLabel.Image = userInputService:GetImageForKeyCode(p4)
			u22 = true
		end

		setIndicatorVisible(u22)
	end)
	widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local n1 = widget.AbsoluteSize.Y * 0.96

		indicator.Size = UDim2.new(0, n1, 0, n1)
	end)

	local n1 = widget.AbsoluteSize.Y * 0.96

	indicator.Size = UDim2.new(0, n1, 0, n1)

	return indicator
end
