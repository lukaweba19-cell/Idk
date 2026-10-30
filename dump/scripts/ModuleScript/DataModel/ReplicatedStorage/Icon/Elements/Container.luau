-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local u1: boolean = false
local n1 = 0

return function(p1)
	local guiService: GuiService = game:GetService("GuiService")
	local players: Players = game:GetService("Players")
	local userInputService: UserInputService = game:GetService("UserInputService")
	local v7 = require(script.Parent.Parent.Packages.GoodSignal).new()
	local u8 = guiService:GetGuiInset()
	local n5 = 0
	local n2: number = 0
	local n3: number = 0
	local n4: number = 0
	local u13: boolean = false
	local u14: boolean = false

	local function checkInset(p2)
		local height = guiService.TopbarInset.Height
		local u32: boolean = height <= 36

		u13 = guiService:IsTenFootInterface()
		u14 = userInputService.VREnabled
		p1.isOldTopbar = u32
		n4 += 1

		if height == 0 and p2 == nil then
			task.defer(function()
				task.wait(8)
				checkInset("ForceConvertToOld")
			end)
		elseif n4 == 1 then
			task.delay(5, function()
				players.LocalPlayer:WaitForChild("PlayerGui")

				if n4 == 1 then
					checkInset()
				end
			end)
		end

		if p1.isOldTopbar and not u13 and not u14 and u1 == false and (height ~= 0 or p2 == "ForceConvertToOld") then
			u1 = true
			task.defer(function()
				local classic = require(script.Parent.Parent.Features.Themes.Classic)

				p1.modifyBaseTheme(classic)
				guiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
					if guiService.MenuIsOpen then
						p1.setTopbarEnabled(false, true)

						return
					end

					p1.setTopbarEnabled()
				end)

				if guiService.MenuIsOpen then
					p1.setTopbarEnabled(false, true)

					return
				end

				p1.setTopbarEnabled()
			end)
		end

		u8 = guiService:GetGuiInset()
		n5 = if u32 then 12 else u8.Y - 50
		n2 = if u32 then 2 else 0
		n3 = -2

		if u13 then
			n5 = 10
			n2 = 0
		end

		if guiService.TopbarInset.Height == 0 and not u1 then
			n2 += 13
			n3 = 50
		end

		v7:Fire(u8)

		local y = u8.Y

		if y ~= n1 then
			n1 = y
			task.defer(function()
				p1.insetHeightChanged:Fire(y)
			end)
		end
	end

	guiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset)
	checkInset("FirstTime")

	local topbarStandard: ScreenGui = Instance.new("ScreenGui")

	v7:Connect(function()
		topbarStandard:SetAttribute("StartInset", n5)
	end)
	topbarStandard.Name = "TopbarStandard"
	topbarStandard.Enabled = true
	topbarStandard.DisplayOrder = p1.baseDisplayOrder
	topbarStandard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	topbarStandard.IgnoreGuiInset = true
	topbarStandard.ResetOnSpawn = false
	topbarStandard.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets

	local topbarStandardName: string = topbarStandard.Name

	p1.baseDisplayOrderChanged:Connect(function()
		topbarStandard.DisplayOrder = p1.baseDisplayOrder
	end)

	local holders: Frame = Instance.new("Frame")

	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	v7:Connect(function()
		local v34 = if u13 then UDim2.new(1, 0, 0, if u14 then 36 else 56) else UDim2.new(1, 0, 1, n3)

		holders.Position = UDim2.new(0, 0, 0, n2)
		holders.Size = v34
	end)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Parent = topbarStandard

	local clone: Instance = topbarStandard:Clone()
	local cloneHolders = clone.Holders

	clone.Name = "TopbarCentered"
	clone.DisplayOrder = p1.baseDisplayOrder
	clone.ScreenInsets = Enum.ScreenInsets.None
	p1.baseDisplayOrderChanged:Connect(function()
		clone.DisplayOrder = p1.baseDisplayOrder
	end)

	local cloneName: string = clone.Name

	v7:Connect(function()
		cloneHolders.Size = UDim2.new(1, 0, 0, guiService.TopbarInset.Height + n3)
	end)
	cloneHolders.Size = UDim2.new(1, 0, 0, guiService.TopbarInset.Height + n3)

	local clone2: Instance = topbarStandard:Clone()

	clone2.Name = clone2.Name .. "Clipped"
	clone2.DisplayOrder = p1.baseDisplayOrder + 1
	p1.baseDisplayOrderChanged:Connect(function()
		clone2.DisplayOrder = p1.baseDisplayOrder + 1
	end)

	local clone2Name: string = clone2.Name
	local clone3: Instance = clone:Clone()

	clone3.Name = clone3.Name .. "Clipped"
	clone3.DisplayOrder = p1.baseDisplayOrder + 1
	p1.baseDisplayOrderChanged:Connect(function()
		clone3.DisplayOrder = p1.baseDisplayOrder + 1
	end)

	local clone3Name: string = clone3.Name
	local left: ScrollingFrame = Instance.new("ScrollingFrame")

	left:SetAttribute("IsAHolder", true)
	left.Name = "Left"
	v7:Connect(function()
		left.Position = UDim2.fromOffset(n5, 0)
	end)
	left.Size = UDim2.new(1, -24, 1, 0)
	left.BackgroundTransparency = 1
	left.Visible = true
	left.ZIndex = 1
	left.Active = false
	left.ClipsDescendants = true
	left.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	left.CanvasSize = UDim2.new(0, 0, 1, -1)
	left.AutomaticCanvasSize = Enum.AutomaticSize.X
	left.ScrollingDirection = Enum.ScrollingDirection.X
	left.ScrollBarThickness = 0
	left.BorderSizePixel = 0
	left.Selectable = false
	left.ScrollingEnabled = false
	left.ElasticBehavior = Enum.ElasticBehavior.Never
	left.Parent = holders

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	v7:Connect(function()
		uiListLayout.Padding = UDim.new(0, n5)
	end)
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.Parent = left

	local clone4: Instance = left:Clone()

	v7:Connect(function()
		clone4.UIListLayout.Padding = UDim.new(0, n5)
	end)
	clone4.ScrollingEnabled = false
	clone4.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	clone4.Name = "Center"
	clone4.Parent = cloneHolders

	local clone5: Instance = left:Clone()

	v7:Connect(function()
		clone5.UIListLayout.Padding = UDim.new(0, n5)
	end)
	clone5.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	clone5.Name = "Right"
	clone5.AnchorPoint = Vector2.new(1, 0)
	clone5.Position = UDim2.new(1, -12, 0, 0)
	clone5.Parent = holders
	v7:Fire(u8)

	return {
		[topbarStandardName] = topbarStandard,
		[cloneName] = clone,
		[clone2Name] = clone2,
		[clone3Name] = clone3
	}
end
