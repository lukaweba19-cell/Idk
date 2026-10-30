-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(_)
	local selectionContainer: Frame = Instance.new("Frame")

	selectionContainer.Name = "SelectionContainer"
	selectionContainer.Visible = false

	local selection: Frame = Instance.new("Frame")

	selection.Name = "Selection"
	selection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	selection.BackgroundTransparency = 1
	selection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	selection.BorderSizePixel = 0
	selection.Parent = selectionContainer

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Name = "UIStroke"
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 3
	uiStroke.Parent = selection

	local selectionGradient: UIGradient = Instance.new("UIGradient")

	selectionGradient.Name = "SelectionGradient"
	selectionGradient.Parent = uiStroke

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner:SetAttribute("Collective", "IconCorners")
	uiCorner.Name = "UICorner"
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = selection

	local runService: RunService = game:GetService("RunService")
	local guiService: GuiService = game:GetService("GuiService")
	local n1 = 1

	selection:GetAttributeChangedSignal("RotationSpeed"):Connect(function()
		n1 = selection:GetAttribute("RotationSpeed")
	end)
	runService.Heartbeat:Connect(function()
		if not guiService.SelectedObject then
			return
		end

		selectionGradient.Rotation = os.clock() * n1 * 100 % 360
	end)

	return selectionContainer
end
