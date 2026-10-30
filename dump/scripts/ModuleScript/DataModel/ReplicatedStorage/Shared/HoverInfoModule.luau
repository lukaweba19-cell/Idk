-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local textService: TextService = game:GetService("TextService")
local guiService: GuiService = game:GetService("GuiService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local collectibleSerial = require(replicatedStorageShared:WaitForChild("CollectibleSerial"))
local v9: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(v9:WaitForChild("TraitText"))
local v11: Instance = replicatedStorage:WaitForChild("Shared")
local boothTheme = require(v11:WaitForChild("BoothTheme"))
local v13: Instance = replicatedStorage:WaitForChild("Shared")
local rapClient = require(v13:WaitForChild("RapClient"))
local v15: Instance = replicatedStorage:WaitForChild("Shared")
local rapProjected = require(v15:WaitForChild("RapProjected"))
local v17: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(v17:WaitForChild("TradingPlazaGate"))
local color3 = Color3.fromRGB(214, 214, 214)

local function touchOnly()
	return userInputService.TouchEnabled and not userInputService.MouseEnabled
end

local n1 = -math.huge

local function findScreenGui(p1)
	local v42 = p1

	while v42 do
		if v42:IsA("LayerCollector") then
			return v42
		end

		v42 = v42.Parent
	end

	error("HoverInfoModule: no LayerCollector ancestor found")
end
local function buildFrame(p2, parent, p4)
	local clone = p2:Clone()

	clone.Name = if p4 then "HoverInfoCompact" else "HoverInfo"
	clone.Visible = false
	clone.ZIndex = 50

	if p4 then
		local itemExist = clone:FindFirstChild("ItemExist")
		local n1 = 0

		if itemExist and itemExist:IsA("GuiObject") then
			n1 = itemExist.Size.Y.Offset
			itemExist:Destroy()
		end

		local cloneSize = clone.Size

		clone.Size = UDim2.fromOffset(cloneSize.X.Offset, cloneSize.Y.Offset - n1)
	end

	clone.AutomaticSize = Enum.AutomaticSize.X

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("GuiObject") then
			v.ZIndex = 50
		end
	end

	clone.Parent = parent

	return clone
end

local module: {[any]: any} = {}

function module.create(p5, scale)
	local hoverInfo: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("HoverInfo")
	local v55 = p5

	while v55 do
		if v55:IsA("LayerCollector") then
			local v56 = v55

			break
		end

		v55 = v55.Parent
	end

	if not v55 then
		error("HoverInfoModule: no LayerCollector ancestor found")
		v56 = nil
	end

	local clone: Instance = hoverInfo:Clone()

	clone.Name = "HoverInfo"
	clone.Visible = false
	clone.ZIndex = 50
	clone.AutomaticSize = Enum.AutomaticSize.X

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("GuiObject") then
			v.ZIndex = 50
		end
	end

	clone.Parent = v56

	local t2: {[any]: any} = {
		activeFrame = nil,
		connection = nil,
		anchored = false,
		sticky = false,
		stickyConn = nil,
		stickyArmedAt = 0,
		rapToken = 0,
		rapAmount = nil,
		rapProjected = nil,
		frameFull = clone,
		frameCompact = buildFrame(hoverInfo, v56, true),
		screenGui = v56,
		onSurface = v56:IsA("SurfaceGui")
	}

	if scale ~= nil and scale > 0 and scale ~= 1 then
		for _, v in ipairs({ t2.frameFull, t2.frameCompact }) do
			local uiScale: UIScale = Instance.new("UIScale")

			uiScale.Scale = scale
			uiScale.Parent = v
		end
	end

	t2.rapConn = rapClient.Changed:Connect(function()
		if not tradingPlazaGate.IsTradingPlaza() then
			return
		end

		local lastData = t2.lastData
		local activeFrame = t2.activeFrame

		if lastData == nil or activeFrame == nil or activeFrame.Parent == nil or not activeFrame.Visible then
		elseif activeFrame:FindFirstChild("__RapRow") == nil then
			module.show(t2, lastData)

			return
		end
	end)

	local function isMouseOverButton()
		if not t2.sourceButton or not t2.sourceButton.Parent then
			return false
		end

		local sourceButton = t2.sourceButton
		local v196: Vector2 = userInputService:GetMouseLocation()
		local v197 = guiService:GetGuiInset()
		local x = v196.X
		local n1 = v196.Y - v197.Y
		local sourceButtonAbsolutePosition = sourceButton.AbsolutePosition
		local sourceButtonAbsoluteSize = sourceButton.AbsoluteSize

		return x >= sourceButtonAbsolutePosition.X and x <= sourceButtonAbsolutePosition.X + sourceButtonAbsoluteSize.X and n1 >= sourceButtonAbsolutePosition.Y and n1 <= sourceButtonAbsolutePosition.Y + sourceButtonAbsoluteSize.Y
	end

	local v65 = p5

	while v65 and v65 ~= v56 do
		if v65:IsA("GuiObject") then
			local v66 = v65

			v66:GetPropertyChangedSignal("Visible"):Connect(function()
				if not v66.Visible then
					module.hide(t2)
				elseif t2.activeFrame and t2.activeFrame.Visible then
					task.defer(function()
						if t2.activeFrame and t2.activeFrame.Visible and not isMouseOverButton() then
							module.hide(t2)
						end
					end)
				end
			end)
		end

		v65 = v65.Parent
	end

	v56:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not v56.Enabled then
			module.hide(t2)
		elseif t2.activeFrame and t2.activeFrame.Visible then
			task.defer(function()
				if t2.activeFrame and t2.activeFrame.Visible and not isMouseOverButton() then
					module.hide(t2)
				end
			end)
		end
	end)

	local connection = userInputService.WindowFocusReleased:Connect(function()
		if t2.sticky then
			return
		end

		module.hide(t2)
	end)

	t2.focusConns = {
		connection,
		userInputService.WindowFocused:Connect(function()
			if t2.activeFrame and t2.activeFrame.Visible and not isMouseOverButton() then
				module.hide(t2)
			end
		end)
	}

	return t2
end
local function getGamepadSelection()
	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if not guiServiceSelectedObject then
		return nil
	end

	if userInputService:GetLastInputType().Name:sub(1, 7) == "Gamepad" then
		return guiServiceSelectedObject
	end

	return nil
end
local function updatePosition(p7, p8)
	local x = p8.AbsoluteSize.X
	local y = p8.AbsoluteSize.Y
	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject
	local v74 = if not guiServiceSelectedObject then nil else if userInputService:GetLastInputType().Name:sub(1, 7) == "Gamepad" then guiServiceSelectedObject else nil

	if v74 == nil and (not not p7.anchored or not not p7.onSurface) then
		v74 = p7.sourceButton
	end

	if v74 and v74.Parent == nil then
		v74 = nil
	end

	if v74 ~= nil and not v74:IsDescendantOf(p7.screenGui) then
		v74 = nil
	end

	local n1
	local n2

	if v74 then
		local screenGui = p7.screenGui
		local n3 = v74.AbsolutePosition - screenGui.AbsolutePosition
		local absoluteSize = v74.AbsoluteSize

		n1 = n3.X + absoluteSize.X + 16
		n2 = n3.Y + 8

		if screenGui.AbsoluteSize.X < n1 + x then
			n1 = n3.X - 16 - x
		end

		if screenGui.AbsoluteSize.Y < n2 + y then
			n2 = n3.Y + absoluteSize.Y - 8 - y
		end
	else
		local CurrentCamera: Camera = workspace.CurrentCamera
		local v82 = CurrentCamera and CurrentCamera.ViewportSize.X or 1920
		local v83 = CurrentCamera and CurrentCamera.ViewportSize.Y or 1080
		local v84: Vector2 = userInputService:GetMouseLocation()
		local v85 = guiService:GetGuiInset()
		local v86 = v84.X
		local n4 = v84.Y - v85.Y

		n1 = v86 + 16
		n2 = n4 + 8

		if v82 < n1 + x then
			n1 = v86 - 16 - x
		end

		if v83 < n2 + y then
			n2 = n4 - 8 - y
		end
	end

	if n1 < 0 then
		n1 = 0
	end

	if n2 < 0 then
		n2 = 0
	end

	p8.Position = UDim2.fromOffset(n1, n2)
end
local function clearRapRow(p9)
	local __RapRow = p9:FindFirstChild("__RapRow")

	if __RapRow then
		__RapRow:Destroy()
	end
end
local function baselineY(p10)
	local itemExist = p10:FindFirstChild("ItemExist")
	local itemRarity = p10:FindFirstChild("ItemRarity")

	if itemExist and itemExist.Visible then
		return itemExist.Position.Y.Offset + itemExist.Size.Y.Offset
	end

	if itemRarity and itemRarity.Visible then
		return itemRarity.Position.Y.Offset + itemRarity.Size.Y.Offset
	end

	return 66
end
local function wantsRap(p11)
	if not rapClient.Unlocked() then
		return false
	end

	if typeof(p11.RAP) == "number" then
		return true
	end

	if not rapClient.HasRap(p11.Kind) then
	elseif typeof(p11.ItemId) == "string" and p11.ItemId ~= "" then
		if rapClient.Peek(p11.Kind, p11.ItemId) == nil then
			return rapClient.Available()
		end

		return true
	end

	return false
end
local function applyRapRow(p12, parent, p14, p15)
	local __RapRow = parent:FindFirstChild("__RapRow")

	if __RapRow then
		__RapRow:Destroy()
	end

	p12.rapAmount = nil
	p12.rapProjected = nil

	if not tradingPlazaGate.IsTradingPlaza() then
		return 0
	end

	if rapClient.HasRap(p14.Kind) and typeof(p14.ItemId) == "string" and typeof(p14.RAP) ~= "number" then
		rapClient.Prime()
	end

	if not wantsRap(p14) then
		return 0
	end

	local itemRarity = parent:FindFirstChild("ItemRarity")

	if itemRarity == nil then
		return 0
	end

	local v99 = if typeof(p14.RAP) == "number" then p14.RAP else nil
	local v100 = p14.RapConfidence
	local v101 = if typeof(p14.RapEstimate) == "number" then p14.RapEstimate else nil
	local v102 = rapProjected.Enabled() and p14.RapProjected == true

	if v99 == nil then
		local v103 = rapClient.Peek(p14.Kind, p14.ItemId)

		if v103 ~= nil then
			if typeof(v103.RAP) == "number" then
				v99 = v103.RAP
			end

			local valueBased = v103.ValueBased

			if v101 == nil and typeof(v103.Estimate) == "number" then
				v101 = v103.Estimate
			end

			v100 = v100 or v103.Confidence

			if rapProjected.Is(v103) then
				v102 = true
			end
		end
	end

	p12.rapProjected = v102

	local __RapRow: Frame = Instance.new("Frame")

	__RapRow.Name = "__RapRow"
	__RapRow.BackgroundTransparency = 1
	__RapRow.AnchorPoint = Vector2.new(0.5, 0)
	__RapRow.Position = UDim2.new(0.5, 0, 0, p15 + 3)
	__RapRow.Size = UDim2.new(0, 0, 0, 20)
	__RapRow.AutomaticSize = Enum.AutomaticSize.X
	__RapRow.ZIndex = 50

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 4)
	uiListLayout.Parent = __RapRow

	local clone = itemRarity:Clone()

	clone.Name = "Word"

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("UIGradient") then
			v:Destroy()
		end
	end

	clone.Visible = true
	clone.Text = "Value"
	clone.TextScaled = false
	clone.TextSize = 14
	clone.TextColor3 = color3
	clone.BackgroundTransparency = 1
	clone.TextXAlignment = Enum.TextXAlignment.Left
	clone.AutomaticSize = Enum.AutomaticSize.X
	clone.AnchorPoint = Vector2.new(0, 0)
	clone.Size = UDim2.new(0, 0, 1, 0)
	clone.Position = UDim2.new()
	clone.LayoutOrder = 1
	clone.ZIndex = 50
	clone.Parent = __RapRow

	local v110 = boothTheme.TokenIcon()

	if v110 ~= "" then
		local tokenIcon: ImageLabel = Instance.new("ImageLabel")

		tokenIcon.Name = "TokenIcon"
		tokenIcon.BackgroundTransparency = 1
		tokenIcon.Image = v110
		tokenIcon.ScaleType = Enum.ScaleType.Fit
		tokenIcon.Size = UDim2.fromOffset(15, 15)
		tokenIcon.LayoutOrder = 2
		tokenIcon.ZIndex = 50
		tokenIcon.Parent = __RapRow
	end

	v110 = boothTheme.TokenAmount(__RapRow, v99 or 0, UDim2.new(0, 0, 1, 0), UDim2.new())
	v110.Name = "Amount"
	v110.TextScaled = false
	v110.TextWrapped = false
	v110.TextSize = 15
	v110.AutomaticSize = Enum.AutomaticSize.X
	v110.AnchorPoint = Vector2.new(0, 0)
	v110.LayoutOrder = 3
	v110.ZIndex = 50

	if v99 == nil then
		if v101 == nil then
			v110.Text = "--"
		else
			v110.Text = "~" .. boothTheme.Fmt(v101)
			v110.TextTransparency = 0.35
			clone.TextTransparency = 0.35
		end
	end

	if v100 == "Low" then
		v110.TextTransparency = 0.35
		clone.TextTransparency = 0.35
	end

	__RapRow.Parent = parent
	p12.rapAmount = v110

	if v99 == nil then
		local rapToken = p12.rapToken

		rapClient.Request(p14.Kind, p14.ItemId, function(p16)
			if p12.rapToken ~= rapToken then
				return
			end

			local rapAmount = p12.rapAmount

			if rapAmount == nil or rapAmount.Parent == nil then
				return
			end

			if p16 ~= nil and rapProjected.Is(p16) and p12.rapProjected ~= true and p12.lastData ~= nil and p12.activeFrame ~= nil and p12.activeFrame.Visible then
				module.show(p12, p12.lastData)

				return
			end

			if p16 ~= nil and typeof(p16.RAP) == "number" then
				rapAmount.Text = boothTheme.Fmt(p16.RAP)
				rapAmount.TextTransparency = if p16.Confidence == "Low" then 0.35 else 0
			elseif p16 == nil or typeof(p16.Estimate) ~= "number" then
				rapAmount.Text = "--"
			else
				rapAmount.Text = "~" .. boothTheme.Fmt(p16.Estimate)
				rapAmount.TextTransparency = 0.35
			end

			local activeFrame = p12.activeFrame

			if activeFrame ~= nil and activeFrame.Visible then
				updatePosition(p12, activeFrame)
			end
		end)
	end

	return 25
end
local function clearFinisherSection(p17)
	local __FinisherSep = p17:FindFirstChild("__FinisherSep")

	if __FinisherSep then
		__FinisherSep:Destroy()
	end

	local __FinisherName = p17:FindFirstChild("__FinisherName")

	if __FinisherName then
		__FinisherName:Destroy()
	end

	local __FinisherIcon = p17:FindFirstChild("__FinisherIcon")

	if __FinisherIcon then
		__FinisherIcon:Destroy()
	end
end
local function applyFinisherSection(parent, p19, p20)
	clearFinisherSection(parent)

	if p19.FinisherName and p19.FinisherName ~= "" then
		local textColor3 = rarity.GetColor(p19.FinisherRarity or "Common")
		local __FinisherSep: Frame = Instance.new("Frame")

		__FinisherSep.Name = "__FinisherSep"
		__FinisherSep.Size = UDim2.new(1, -4, 0, 1)
		__FinisherSep.Position = UDim2.new(0, 2, 0, p20 + 4)
		__FinisherSep.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
		__FinisherSep.BackgroundTransparency = 0.4
		__FinisherSep.BorderSizePixel = 0
		__FinisherSep.ZIndex = 50
		__FinisherSep.Parent = parent

		local __FinisherName: TextLabel = Instance.new("TextLabel")

		__FinisherName.Name = "__FinisherName"
		__FinisherName.Size = UDim2.new(1, 0, 0, 16)
		__FinisherName.Position = UDim2.new(0, 0, 0, p20 + 8)
		__FinisherName.BackgroundTransparency = 1
		traitText.Bind(__FinisherName, p19.FinisherName)
		__FinisherName.TextColor3 = textColor3
		__FinisherName.TextSize = 13
		__FinisherName.Font = Enum.Font.GothamBold
		__FinisherName.TextXAlignment = Enum.TextXAlignment.Center
		__FinisherName.ZIndex = 50
		__FinisherName.Parent = parent
		rarity.ApplyTextGradient(__FinisherName, p19.FinisherRarity or "Common")

		local __FinisherIcon: ImageLabel = Instance.new("ImageLabel")

		__FinisherIcon.Name = "__FinisherIcon"
		__FinisherIcon.Size = UDim2.fromOffset(72, 72)
		__FinisherIcon.Position = UDim2.new(0.5, -36, 0, p20 + 26)
		__FinisherIcon.BackgroundTransparency = 1
		__FinisherIcon.Image = p19.FinisherIcon or ""
		__FinisherIcon.ScaleType = Enum.ScaleType.Fit
		__FinisherIcon.ZIndex = 50
		__FinisherIcon.Parent = parent

		return 100
	end

	return 0
end
local function clearNote(p21)
	local note = p21:FindFirstChild("Note")

	if note then
		note:Destroy()
	end

	for _, v in ipairs(p21:GetChildren()) do
		if v.Name == "NoteSpacer" then
			v:Destroy()
		end
	end
end
local function noteSpacer(parent, p23)
	local noteSpacer: Frame = Instance.new("Frame")

	noteSpacer.Name = "NoteSpacer"
	noteSpacer.BackgroundTransparency = 1
	noteSpacer.BorderSizePixel = 0
	noteSpacer.Position = UDim2.new(0, 0, 0, 0)
	noteSpacer.Size = UDim2.new(0, p23 + 16, 0, 1)
	noteSpacer.ZIndex = 1
	noteSpacer.Parent = parent
end
local function clearProjectedLine(p24)
	local projectedLine = p24:FindFirstChild("ProjectedLine")

	if projectedLine then
		projectedLine:Destroy()
	end

	for _, v in ipairs(p24:GetChildren()) do
		if v.Name == "ProjectedSpacer" then
			v:Destroy()
		end
	end
end
local function applyProjectedLine(parent, p26, p27)
	clearProjectedLine(parent)

	if not p26 then
		return 0
	end

	local gothamMedium = Enum.Font.GothamMedium
	local textSize: Vector2 = textService:GetTextSize(rapProjected.TEXT, 13, gothamMedium, Vector2.new(4096, 18))
	local n1 = math.ceil(textSize.X) + 2
	local n2 = n1 + 20
	local projectedLine: Frame = Instance.new("Frame")

	projectedLine.Name = "ProjectedLine"
	projectedLine.BackgroundTransparency = 1
	projectedLine.AnchorPoint = Vector2.new(0.5, 0)
	projectedLine.Position = UDim2.new(0.5, 0, 0, p27 + 1)
	projectedLine.Size = UDim2.new(0, n2, 0, 18)
	projectedLine.ZIndex = 50

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.Padding = UDim.new(0, 4)
	uiListLayout.Parent = projectedLine

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = rapProjected.ICON
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.Size = UDim2.fromOffset(16, 16)
	imageLabel.LayoutOrder = 1
	imageLabel.ZIndex = 50
	imageLabel.Parent = projectedLine

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.BackgroundTransparency = 1
	textLabel.Font = gothamMedium
	textLabel.TextSize = 13
	textLabel.TextColor3 = rapProjected.COLOR
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextWrapped = false
	textLabel.Text = rapProjected.TEXT
	textLabel.Size = UDim2.new(0, n1, 1, 0)
	textLabel.LayoutOrder = 2
	textLabel.ZIndex = 50
	textLabel.Parent = projectedLine
	projectedLine.Parent = parent

	local projectedSpacer: Frame = Instance.new("Frame")

	projectedSpacer.Name = "ProjectedSpacer"
	projectedSpacer.BackgroundTransparency = 1
	projectedSpacer.BorderSizePixel = 0
	projectedSpacer.Size = UDim2.new(0, n2 + 16, 0, 1)
	projectedSpacer.ZIndex = 1
	projectedSpacer.Parent = parent

	return 20
end
local function applyNote(parent, p29, p30)
	clearNote(parent)

	if typeof(p29.Note) == "string" and p29.Note ~= "" then
		local gothamMedium = Enum.Font.GothamMedium
		local textSize: Vector2 = textService:GetTextSize(p29.Note, 13, gothamMedium, Vector2.new(4096, 18))
		local n1 = math.ceil(textSize.X) + 2
		local textLabel: TextLabel = Instance.new("TextLabel")

		textLabel.Name = "Note"
		textLabel.BackgroundTransparency = 1
		textLabel.Font = gothamMedium
		textLabel.TextSize = 13
		textLabel.TextColor3 = Color3.fromRGB(255, 196, 92)
		textLabel.TextXAlignment = Enum.TextXAlignment.Center
		textLabel.AnchorPoint = Vector2.new(0.5, 0)
		textLabel.Position = UDim2.new(0.5, 0, 0, p30 + 3)
		textLabel.Size = UDim2.new(0, n1, 0, 18)
		textLabel.TextWrapped = false
		textLabel.Text = p29.Note
		textLabel.ZIndex = 50
		textLabel.Parent = parent

		if typeof(p29.NoteIcon) == "string" and p29.NoteIcon ~= "" then
			local note: Frame = Instance.new("Frame")

			note.Name = "Note"
			note.BackgroundTransparency = 1
			note.AnchorPoint = Vector2.new(0.5, 0)
			note.Position = UDim2.new(0.5, 0, 0, p30 + 3)
			note.Size = UDim2.new(0, n1 + 20, 0, 18)
			note.ZIndex = 50

			local uiListLayout: UIListLayout = Instance.new("UIListLayout")

			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 4)
			uiListLayout.Parent = note

			local imageLabel: ImageLabel = Instance.new("ImageLabel")

			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = p29.NoteIcon
			imageLabel.ScaleType = Enum.ScaleType.Fit
			imageLabel.Size = UDim2.fromOffset(16, 16)
			imageLabel.LayoutOrder = 1
			imageLabel.ZIndex = 50
			imageLabel.Parent = note
			textLabel.Name = "NoteText"
			textLabel.AnchorPoint = Vector2.new(0, 0)
			textLabel.Position = UDim2.new()
			textLabel.Size = UDim2.new(0, n1, 1, 0)
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.LayoutOrder = 2
			textLabel.Parent = note
			note.Parent = parent
			noteSpacer(parent, n1 + 20)
		else
			noteSpacer(parent, n1)
		end

		return 22
	end

	return 0
end
local function applyStyle(p31, p32)
	local itemName = p31:FindFirstChild("ItemName")
	local itemRarity = p31:FindFirstChild("ItemRarity")
	local backgroundColor3 = rarity.GetColor(p32.Rarity)

	if itemName then
		traitText.Bind(itemName, p32.Name)
	end

	if itemRarity then
		itemRarity.Text = if p32.Rarity == "Empty" then "Consumable" else p32.Rarity
		itemRarity.BackgroundColor3 = backgroundColor3
		rarity.ApplyTextGradient(itemRarity, p32.Rarity)

		local uiStrokeBorder = itemRarity:FindFirstChild("UIStrokeBorder")

		if uiStrokeBorder and uiStrokeBorder:IsA("UIStroke") then
			uiStrokeBorder.Color = backgroundColor3:Lerp(Color3.new(), 0.3)
		end
	end

	local innerStroke = p31:FindFirstChild("InnerStroke")

	if innerStroke and innerStroke:IsA("UIStroke") then
		innerStroke.Color = backgroundColor3
	end

	local outerStroke = p31:FindFirstChild("OuterStroke")

	if outerStroke and outerStroke:IsA("UIStroke") then
		outerStroke.Color = backgroundColor3
	end
end
local function formatNumber(p33)
	if p33 < 10000 then
		local floored = math.floor(p33)

		return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end

	if p33 < 1000000 then
		return string.format("%.1fK", p33 / 1000)
	end

	return string.format("%.1fM", p33 / 1000000)
end
function module.show(p34, p35)
	p34.frameFull.Visible = false
	p34.frameCompact.Visible = false

	local v169 = collectibleSerial.Format(p35.Serial, p35.MaxSupply)
	local u170: boolean = true

	if v169 == nil then
		u170 = typeof(p35.GlobalCopies) == "number"
	end

	local u171

	if u170 then
		u171 = p34.frameFull

		local itemExist = u171:FindFirstChild("ItemExist")

		if itemExist then
			local v173 = v169

			if not v173 then
				v173 = formatNumber(p35.GlobalCopies) .. " Exist"
			end

			itemExist.Text = v173
			itemExist.Visible = true
		end
	else
		u171 = p34.frameCompact
	end

	p34.activeFrame = u171
	p34.sourceButton = p35.SourceButton
	p34.lastData = p35
	p34.anchored = p35.Anchor == true
	p34.rapToken = p34.rapToken + 1
	applyStyle(u171, p35)
	v169 = baselineY(u171)

	local v174 = applyRapRow(p34, u171, p35, v169)
	local v175 = applyProjectedLine(u171, p34.rapProjected == true, v169 + v174)
	local v176 = applyFinisherSection(u171, p35, v169 + v174 + v175)
	local v177 = applyNote(u171, p35, v169 + v174 + v175 + v176)

	u171.Size = UDim2.new(0, 0, 0, (if u170 then 72 else 49) + v174 + v175 + v176 + v177)
	updatePosition(p34, u171)
	u171.Visible = true
	task.defer(function()
		if p34.activeFrame == u171 and u171.Visible then
			updatePosition(p34, u171)
		end
	end)

	if p34.connection then
		p34.connection:Disconnect()
	end

	p34.connection = userInputService.InputChanged:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if p34.sourceButton then
				if not p34.sourceButton.Parent or not p34.sourceButton.Visible then
					module.hide(p34)

					return
				end

				local v206 = p34.sourceButton.Parent

				while v206 do
					if v206:IsA("GuiObject") and not v206.Visible then
						module.hide(p34)

						return
					end

					if v206:IsA("LayerCollector") then
						break
					end

					v206 = v206.Parent
				end
			end

			updatePosition(p34, u171)

			return
		end
	end)
end
function module.hide(p37)
	if p37.activeFrame then
		clearFinisherSection(p37.activeFrame)

		local __RapRow = p37.activeFrame:FindFirstChild("__RapRow")

		if __RapRow then
			__RapRow:Destroy()
		end

		clearProjectedLine(p37.activeFrame)
		p37.activeFrame.Visible = false
		p37.activeFrame = nil
	end

	clearFinisherSection(p37.frameFull)
	clearFinisherSection(p37.frameCompact)

	local __RapRow = p37.frameFull:FindFirstChild("__RapRow")

	if __RapRow then
		__RapRow:Destroy()
	end

	local __RapRow2 = p37.frameCompact:FindFirstChild("__RapRow")

	if __RapRow2 then
		__RapRow2:Destroy()
	end

	clearProjectedLine(p37.frameFull)
	clearProjectedLine(p37.frameCompact)
	p37.frameFull.Visible = false
	p37.frameCompact.Visible = false
	p37.rapAmount = nil
	p37.lastData = nil
	p37.anchored = false
	p37.sticky = false

	if p37.stickyConn then
		p37.stickyConn:Disconnect()
		p37.stickyConn = nil
	end

	if p37.connection then
		p37.connection:Disconnect()
		p37.connection = nil
	end
end
function module.destroy(p38)
	module.hide(p38)

	if p38.rapConn then
		p38.rapConn:Disconnect()
		p38.rapConn = nil
	end

	if p38.focusConns then
		for _, v in ipairs(p38.focusConns) do
			v:Disconnect()
		end

		p38.focusConns = nil
	end

	if p38.frameFull.Parent ~= nil then
		p38.frameFull:Destroy()
	end

	if p38.frameCompact.Parent ~= nil then
		p38.frameCompact:Destroy()
	end
end
local function armStickyDismiss(p39)
	if p39.stickyConn then
		p39.stickyConn:Disconnect()
	end

	p39.stickyArmedAt = os.clock()
	p39.stickyConn = userInputService.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if os.clock() - p39.stickyArmedAt < 0.15 then
				return
			end

			n1 = os.clock()
			module.hide(p39)

			return
		end
	end)
end
function module.bind(p41, p42, p43, p44)
	local t3: {[any]: any} = {}
	local u191: boolean = false

	local function raise(p45)
		local v209 = p43()

		if v209 == nil then
			return
		end

		if v209.SourceButton == nil then
			v209.SourceButton = p42
		end

		if p45 then
			v209.Anchor = true
		end

		module.show(p41, v209)

		if p44 then
			p44(p45)
		end
	end

	if not userInputService.TouchEnabled or not not userInputService.MouseEnabled then
		table.insert(t3, p42.MouseEnter:Connect(function()
			if p41.sticky then
				return
			end

			local v210 = p43()

			if v210 == nil then
				return
			end

			if v210.SourceButton == nil then
				v210.SourceButton = p42
			end

			module.show(p41, v210)

			if p44 then
				p44(false)
			end
		end))
		table.insert(t3, p42.MouseLeave:Connect(function()
			if p41.sticky then
				return
			end

			module.hide(p41)
		end))
	end

	table.insert(t3, p42.SelectionGained:Connect(function()
		if p41.sticky then
			return
		end

		local v211 = p43()

		if v211 == nil then
			return
		end

		if v211.SourceButton == nil then
			v211.SourceButton = p42
		end

		module.show(p41, v211)

		if p44 then
			p44(false)
		end
	end))
	table.insert(t3, p42.SelectionLost:Connect(function()
		if p41.sticky then
			return
		end

		module.hide(p41)
	end))
	table.insert(t3, p42.TouchLongPress:Connect(function(_, p47)
		if p47 ~= Enum.UserInputState.Begin then
			return
		end

		u191 = true

		local v214 = p43()

		if v214 ~= nil then
			if v214.SourceButton == nil then
				v214.SourceButton = p42
			end

			v214.Anchor = true
			module.show(p41, v214)

			if p44 then
				p44(true)
			end
		end

		p41.sticky = true
		armStickyDismiss(p41)
	end))

	return {
		tapConsumed = function()
			if u191 then
				u191 = false

				return true
			end

			return os.clock() - n1 < 0.4
		end,
		disconnect = function()
			for _, v in ipairs(t3) do
				v:Disconnect()
			end

			table.clear(t3)
		end
	}
end

return module
