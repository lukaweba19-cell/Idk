-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(39, 41, 48)

return function(p1)
	local parent = p1:getInstance("ClickRegion")
	local caption: CanvasGroup = Instance.new("CanvasGroup")

	caption.Name = "Caption"
	caption.AnchorPoint = Vector2.new(0.5, 0)
	caption.BackgroundTransparency = 1
	caption.BorderSizePixel = 0
	caption.GroupTransparency = 1
	caption.Position = UDim2.fromOffset(0, 0)
	caption.Visible = true
	caption.ZIndex = 30
	caption.Parent = parent

	local box: Frame = Instance.new("Frame")

	box.Name = "Box"
	box.AutomaticSize = Enum.AutomaticSize.XY
	box.BackgroundColor3 = color3
	box.Position = UDim2.fromOffset(4, 7)
	box.ZIndex = 12
	box.Parent = caption

	local header: TextLabel = Instance.new("TextLabel")

	header.Name = "Header"
	header.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	header.Text = "Caption"
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = 15
	header.TextTruncate = Enum.TextTruncate.None
	header.TextWrapped = false
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.AutomaticSize = Enum.AutomaticSize.X
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Size = UDim2.fromOffset(0, 16)
	header.ZIndex = 18
	header.Parent = box

	local layout: UIListLayout = Instance.new("UIListLayout")

	layout.Name = "Layout"
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	local captionCorner: UICorner = Instance.new("UICorner")

	captionCorner.Name = "CaptionCorner"
	captionCorner.Parent = box

	local padding: UIPadding = Instance.new("UIPadding")

	padding.Name = "Padding"
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 12)
	padding.Parent = box

	local hotkeys: Frame = Instance.new("Frame")

	hotkeys.Name = "Hotkeys"
	hotkeys.AutomaticSize = Enum.AutomaticSize.Y
	hotkeys.BackgroundTransparency = 1
	hotkeys.LayoutOrder = 3
	hotkeys.Size = UDim2.fromScale(1, 0)
	hotkeys.Visible = false
	hotkeys.Parent = box

	local layout1: UIListLayout = Instance.new("UIListLayout")

	layout1.Name = "Layout1"
	layout1.Padding = UDim.new(0, 6)
	layout1.FillDirection = Enum.FillDirection.Vertical
	layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout1.HorizontalFlex = Enum.UIFlexAlignment.None
	layout1.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	layout1.VerticalFlex = Enum.UIFlexAlignment.None
	layout1.SortOrder = Enum.SortOrder.LayoutOrder
	layout1.Parent = hotkeys

	local key1: ImageLabel = Instance.new("ImageLabel")

	key1.Name = "Key1"
	key1.Image = "rbxasset://textures/ui/Controls/key_single.png"
	key1.ImageTransparency = 0.7
	key1.ScaleType = Enum.ScaleType.Slice
	key1.SliceCenter = Rect.new(5, 5, 23, 24)
	key1.AutomaticSize = Enum.AutomaticSize.X
	key1.BackgroundTransparency = 1
	key1.LayoutOrder = 1
	key1.Size = UDim2.fromOffset(0, 30)
	key1.ZIndex = 15
	key1.Parent = hotkeys

	local inset: UIPadding = Instance.new("UIPadding")

	inset.Name = "Inset"
	inset.PaddingLeft = UDim.new(0, 8)
	inset.PaddingRight = UDim.new(0, 8)
	inset.Parent = key1

	local labelContent: TextLabel = Instance.new("TextLabel")

	labelContent.AutoLocalize = false
	labelContent.Name = "LabelContent"
	labelContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	labelContent.Text = ""
	labelContent.TextColor3 = Color3.fromRGB(189, 190, 190)
	labelContent.TextSize = 15
	labelContent.AutomaticSize = Enum.AutomaticSize.X
	labelContent.BackgroundTransparency = 1
	labelContent.Position = UDim2.fromOffset(0, -1)
	labelContent.Size = UDim2.fromScale(1, 1)
	labelContent.ZIndex = 16
	labelContent.Parent = key1

	local caret: ImageLabel = Instance.new("ImageLabel")

	caret.Name = "Caret"
	caret.Image = "rbxassetid://101906294438076"
	caret.ImageColor3 = color3
	caret.AnchorPoint = Vector2.new(0, 0.5)
	caret.BackgroundTransparency = 1
	caret.Position = UDim2.new(0, 0, 0, 4)
	caret.Size = UDim2.fromOffset(16, 8)
	caret.ZIndex = 12
	caret.Parent = caption

	local dropShadow: ImageLabel = Instance.new("ImageLabel")

	dropShadow.Visible = true
	dropShadow.Name = "DropShadow"
	dropShadow.Image = "rbxassetid://124920646932671"
	dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropShadow.ImageTransparency = 0.45
	dropShadow.ScaleType = Enum.ScaleType.Slice
	dropShadow.SliceCenter = Rect.new(12, 12, 13, 13)
	dropShadow.BackgroundTransparency = 1
	dropShadow.Position = UDim2.fromOffset(0, 5)
	dropShadow.Size = UDim2.new(1, 0, 0, 48)
	dropShadow.Parent = caption
	box:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		dropShadow.Size = UDim2.new(1, 0, 0, box.AbsoluteSize.Y + 8)
	end)

	local captionJanitor = p1.captionJanitor
	local v18, v19 = p1:clipOutside(caption)

	v19.AutomaticSize = Enum.AutomaticSize.None

	local v20 = caption:GetPropertyChangedSignal("AbsoluteSize")

	captionJanitor:add(v20:Connect(function()
		local captionAbsoluteSize: Vector2 = caption.AbsoluteSize

		v19.Size = UDim2.fromOffset(captionAbsoluteSize.X, captionAbsoluteSize.Y)
	end))

	local captionAbsoluteSize: Vector2 = caption.AbsoluteSize

	v19.Size = UDim2.fromOffset(captionAbsoluteSize.X, captionAbsoluteSize.Y)

	local u22: boolean = false
	local v23 = caption.Box.Header
	local userInputService: UserInputService = game:GetService("UserInputService")

	v20 = function(p2)
		local userInputServiceKeyboardEnabled: boolean = userInputService.KeyboardEnabled
		local text = caption:GetAttribute("CaptionText") or ""
		local u48: boolean = text == "_hotkey_"

		if not userInputServiceKeyboardEnabled and u48 then
			p1:setCaption()

			return
		end

		v23.Text = text
		v23.Visible = not u48

		if p2 then
			labelContent.Text = p2.Name
			hotkeys.Visible = true
		end

		if not userInputServiceKeyboardEnabled then
			hotkeys.Visible = false
		end
	end
	caption:GetAttributeChangedSignal("CaptionText"):Connect(v20)

	local quad = Enum.EasingStyle.Quad
	local tweenInfo = TweenInfo.new(0.2, quad, Enum.EasingDirection.In)
	local tweenInfo2 = TweenInfo.new(0.2, quad, Enum.EasingDirection.Out)
	local tweenService: TweenService = game:GetService("TweenService")
	local runService: RunService = game:GetService("RunService")

	local function getCaptionPosition(p3)
		return UDim2.new(0.5, 0, 1, if if p3 == nil then u22 else p3 then 10 else 2)
	end
	local function updatePosition(p4)
		if not u22 then
			return
		end

		local v51 = if p4 == nil then u22 else p4
		local u52: boolean = not v51
		local uDim2 = UDim2.new(0.5, 0, 1, if if u52 == nil then u22 else u52 then 10 else 2)
		local uDim22 = UDim2.new(0.5, 0, 1, if if v51 == nil then u22 else v51 then 10 else 2)

		if v51 then
			caret.Position = UDim2.fromOffset(0, caret.Position.Y.Offset)
			caption.AutomaticSize = Enum.AutomaticSize.XY
			caption.Size = UDim2.fromOffset(32, 53)
		else
			local captionAbsoluteSize: Vector2 = caption.AbsoluteSize

			caption.AutomaticSize = Enum.AutomaticSize.Y
			caption.Size = UDim2.fromOffset(captionAbsoluteSize.X, captionAbsoluteSize.Y)
		end

		local u56 = nil

		local function updateCaret()
			local n1 = parent.AbsolutePosition.X - caption.AbsolutePosition.X + parent.AbsoluteSize.X / 2 - caret.AbsoluteSize.X / 2
			local offset = caret.Position.Y.Offset
			local v70 = UDim2.fromOffset(n1, offset)

			if u56 ~= n1 then
				u56 = n1
				caret.Position = UDim2.fromOffset(0, offset)
				task.wait()
			end

			caret.Position = v70
		end

		v19.Position = uDim2
		updateCaret()

		local v58: Tween = tweenService:Create(v19, v51 and tweenInfo or tweenInfo2, { Position = uDim22 })
		local connection = runService.Heartbeat:Connect(updateCaret)

		v58:Play()
		v58.Completed:Once(function()
			connection:Disconnect()
		end)
	end

	local v32 = parent:GetPropertyChangedSignal("AbsoluteSize")

	captionJanitor:add(v32:Connect(function()
		updatePosition()
	end))
	updatePosition(false)
	captionJanitor:add(p1.toggleKeyAdded:Connect(v20))

	for k, _ in pairs(p1.bindedToggleKeys) do
		local userInputServiceKeyboardEnabled: boolean = userInputService.KeyboardEnabled
		local text = caption:GetAttribute("CaptionText") or ""
		local u37: boolean = text == "_hotkey_"

		if not userInputServiceKeyboardEnabled and u37 then
			p1:setCaption()

			break
		end

		v23.Text = text
		v23.Visible = not u37

		if k then
			labelContent.Text = k.Name
			hotkeys.Visible = true
		end

		if userInputServiceKeyboardEnabled then
			break
		end

		hotkeys.Visible = false

		break
	end

	captionJanitor:add(p1.fakeToggleKeyChanged:Connect(v20))

	local fakeToggleKey = p1.fakeToggleKey

	if fakeToggleKey then
		local keyboardEnabled: boolean = userInputService.KeyboardEnabled
		local v40 = caption:GetAttribute("CaptionText") or ""
		local u41: boolean = v40 == "_hotkey_"

		if not keyboardEnabled and u41 then
			p1:setCaption()
		else
			v23.Text = v40
			v23.Visible = not u41

			if fakeToggleKey then
				labelContent.Text = fakeToggleKey.Name
				hotkeys.Visible = true
			end

			if not keyboardEnabled then
				hotkeys.Visible = false
			end
		end
	end

	local function setCaptionEnabled(p5: boolean)
		if p5 == u22 then
			return
		end

		local joinedFrame = p1.joinedFrame

		if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
			p5 = false
		end

		u22 = p5
		tweenService:Create(caption, p5 and tweenInfo or tweenInfo2, {
			GroupTransparency = if p5 then 0 else 1
		}):Play()

		if p5 then
			v19:SetAttribute("ForceUpdate", true)
		end

		updatePosition()

		local userInputServiceKeyboardEnabled: boolean = userInputService.KeyboardEnabled
		local text = caption:GetAttribute("CaptionText") or ""
		local u64: boolean = text == "_hotkey_"

		if not userInputServiceKeyboardEnabled and u64 then
			p1:setCaption()

			return
		end

		v23.Text = text
		v23.Visible = not u64

		if not userInputServiceKeyboardEnabled then
			hotkeys.Visible = false
		end
	end

	local iconModule = require(p1.iconModule)

	captionJanitor:add(p1.stateChanged:Connect(function(p6)
		if p6 == "Viewing" then
			local iconModuleCaptionLastClosedClock = iconModule.captionLastClosedClock
			local n1 = iconModuleCaptionLastClosedClock and os.clock() - iconModuleCaptionLastClosedClock or 999

			task.delay(if n1 < 0.3 then 0 else 0.5, function()
				if p1.activeState == "Viewing" then
					setCaptionEnabled(true)
				end
			end)

			return
		end

		iconModule.captionLastClosedClock = os.clock()
		setCaptionEnabled(false)
	end))

	return caption
end
