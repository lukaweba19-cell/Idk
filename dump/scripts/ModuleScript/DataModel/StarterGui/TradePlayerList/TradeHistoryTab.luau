-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userService: UserService = game:GetService("UserService")
local tweenService: TweenService = game:GetService("TweenService")
local collectionService: CollectionService = game:GetService("CollectionService")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local hoverInfoModule = require(shared:WaitForChild("HoverInfoModule"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(replicatedStorageShared:WaitForChild("Rarity"))
local tradeHistory_Request: Instance = replicatedStorage:WaitForChild("Remotes"):FindFirstChild("TradeHistory_Request")
local inspectItem: Instance = replicatedStorage:WaitForChild("Bindables"):FindFirstChild("InspectItem")
local color3 = Color3.fromRGB(255, 128, 128)
local color32 = Color3.fromRGB(122, 240, 158)
local color33 = Color3.fromRGB(196, 196, 196)
local color34 = Color3.fromRGB(178, 178, 178)
local color35 = Color3.fromRGB(255, 176, 96)
local color36 = Color3.fromRGB(255, 255, 255)
local rarityOrder = rarity.Order

local function rarityGradient(p1)
	local v86 = rarity.GetColor(p1)

	if not v86 then
		return nil
	end

	local color37 = Color3.new(v86.R * 0.8, v86.G * 0.8, v86.B * 0.8)
	local color38 = Color3.new(v86.R * 0.16, v86.G * 0.16, v86.B * 0.16)
	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Color = ColorSequence.new(color37, color38)
	uiGradient.Rotation = 90

	return uiGradient
end
local function topRarity(...)
	local s1 = "Common"
	local n1 = 0

	for _, v in ipairs({ ... }) do
		if typeof(v) == "table" then
			for _, iterValue in ipairs(v) do
				local v96 = typeof(iterValue.rarity) == "string" and iterValue.rarity or "Common"
				local v97 = rarityOrder[v96] or 0

				if n1 < v97 then
					s1 = v96
					n1 = v97
				end
			end
		end
	end

	return s1
end

local u24: boolean = false
local u25 = nil
local u26 = nil
local u27 = nil
local u28 = nil
local u29 = nil
local u30 = nil
local u31 = nil
local u32 = nil
local u33 = nil
local u34 = nil
local t1 = {}
local t2: {[any]: any} = {}
local u37 = nil
local n1 = 1
local u39: boolean = false
local u40: boolean = false
local u41 = nil
local u42 = false
local t3: {[any]: any} = {}
local n2: number = 0
local t4: {[any]: any} = {}
local u46: boolean = false
local u47 = nil

local function escapeRich(p2)
	return (p2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local t5: {[any]: any} = { name = "", isSelf = true, gen = 0, id = LocalPlayer.UserId }

local function subjectLabel()
	if t5.isSelf then
		return "you"
	end

	return t5.name
end
local function withSubject(p3)
	if not t5.isSelf then
		p3.target = t5.id
	end

	return p3
end
local function detailKey(p4)
	return tostring(t5.id) .. ":" .. p4
end
local function primeLocalNames()
	for _, v in ipairs(players:GetPlayers()) do
		if t4[v.UserId] == nil then
			t4[v.UserId] = v.DisplayName
		end
	end
end
local function fetchDisplayNames(p5)
	if u46 then
		return
	end

	local t8: {[any]: any} = {}
	local t9: {[any]: any} = {}

	for _, v in ipairs(t1) do
		local numberValue = tonumber(v.other) or 0

		if numberValue > 0 and not t9[numberValue] and t4[numberValue] == nil then
			t9[numberValue] = true
			table.insert(t8, numberValue)
		end
	end

	if #t8 == 0 then
		return
	end

	u46 = true
	task.spawn(function()
		local ok, result = pcall(function()
			return userService:GetUserInfosByUserIdsAsync(t8)
		end)

		u46 = false

		if ok and typeof(result) == "table" then
			for _, v in ipairs(result) do
				local numberValue2: number? = tonumber(v.Id)

				if numberValue2 then
					t4[numberValue2] = tostring(v.DisplayName or "")
				end
			end
		else
			local text: string = tostring(result)

			warn("[TradeHistory] display name lookup failed: " .. text)
		end

		for _, v in ipairs(t8) do
			if t4[v] == nil then
				t4[v] = ""
			end
		end

		p5()
	end)
end
local function relativeTime(p6)
	if typeof(p6) == "number" and not (p6 <= 0) then
		local n1 = os.time() - p6

		if n1 < 60 then
			return "just now"
		end

		if n1 < 3600 then
			return ("%dm ago"):format((math.floor(n1 / 60)))
		end

		if n1 < 86400 then
			return ("%dh ago"):format((math.floor(n1 / 3600)))
		end

		return ("%dd ago"):format((math.floor(n1 / 86400)))
	end

	return ""
end
local function comma(p7)
	local floored = math.floor(p7)

	return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end
local function getScale()
	local y = u27.AbsoluteSize.Y

	if y <= 0 then
		return 1
	end

	return (math.clamp(y / 315, 0.6, 1.15))
end
local function rowScale()
	local y = u28.Size.Y
	local n1 = u26.AbsoluteSize.Y * y.Scale + y.Offset

	if n1 <= 0 then
		return 1
	end

	return (math.clamp(n1 / 61, 0.6, 1.15))
end
local function cloneTemplate(p8)
	local clone = p8:Clone()

	clone.Visible = true

	return clone
end
local function makeGap(parent, layoutOrder, p11)
	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded = math.round(p11)
	local v124 = math.max(1, rounded)

	gap.Size = uDim2New(1, 0, 0, v124)
	gap.LayoutOrder = layoutOrder
	gap.Parent = parent
end
local function verticalList(parent, p13)
	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local uDimNew = UDim.new
	local rounded = math.round(p13)

	uiListLayout.Padding = uDimNew(0, rounded)
	uiListLayout.Parent = parent
end
local function cloneSub(parent, layoutOrder, text, p17, p18)
	local clone = u31:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Text = text
	clone.RichText = true
	clone.TextWrapped = true
	clone.TextSize = math.round(p17)
	clone.Size = UDim2.new(1, 0, 0, 0)
	clone.AutomaticSize = Enum.AutomaticSize.Y
	clone.TextColor3 = p18 or color33
	clone.Parent = parent

	return clone
end
local function cloneDivider(parent, layoutOrder)
	local clone = u33:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Size = UDim2.new(1, 0, 0, 2)
	clone.Parent = parent
end
local function inspectable(p21)
	if not inspectItem then
		return false
	end

	local kind = p21.kind
	local u141: boolean = true

	if kind ~= "Knife" then
		u141 = true

		if kind ~= "Revolver" then
			u141 = kind == "Finisher"
		end
	end

	return u141
end
local function inspectItem2(p22)
	if not inspectItem then
		return
	end

	hoverInfoModule.hide(u34)

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local inspectHUD: Instance = playerGui and playerGui:FindFirstChild("InspectHUD")

	if inspectHUD and inspectHUD:IsA("ScreenGui") then
		local scriptParentEnabled = scriptParent.Enabled

		scriptParent.Enabled = false

		local connection = nil

		connection = inspectHUD:GetPropertyChangedSignal("Enabled"):Connect(function()
			if inspectHUD.Enabled then
				return
			end

			connection:Disconnect()

			if scriptParentEnabled then
				scriptParent.Enabled = true
			end
		end)
	end

	inspectItem:Fire({
		Kind = p22.kind,
		ItemId = p22.id,
		Name = p22.name,
		Rarity = p22.rarity,
		GlobalCopies = p22.copies,
		Serial = p22.serial,
		MaxSupply = p22.supply
	})
end
local function buildItemGrid(parent, layoutOrder, p25, p26, p27, p28)
	local items: Frame = Instance.new("Frame")

	items.Name = "Items"
	items.BackgroundTransparency = 1
	items.BorderSizePixel = 0
	items.Size = UDim2.new(1, 0, 0, 0)
	items.AutomaticSize = Enum.AutomaticSize.Y
	items.LayoutOrder = layoutOrder
	items.ZIndex = 2

	local uiGridLayout: UIGridLayout = Instance.new("UIGridLayout")

	uiGridLayout.CellSize = UDim2.fromOffset(p27, p27)

	local uDim2FromOffset = UDim2.fromOffset
	local rounded = math.round(p26 * 6)
	local rounded2 = math.round(p26 * 6)

	uiGridLayout.CellPadding = uDim2FromOffset(rounded, rounded2)
	uiGridLayout.FillDirectionMaxCells = math.max(1, p28)
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiGridLayout.Parent = items
	items.Parent = parent

	for i, v in ipairs(p25) do
		local uiFrameworkCreateItemCell = uiFramework.createItemCell
		local v161 = v.rarity or "Common"
		local vIcon = v.icon
		local v163 = ("Item%d"):format(i)
		local v164, v165 = uiFrameworkCreateItemCell(v161, {
			visible = true,
			active = true,
			selectable = true,
			icon = vIcon,
			name = v163,
			parent = items,
			layoutOrder = i
		})
		local typeName: string = typeof(v.finisher)

		v165:setFinisher(if typeName == "string" then v.finisher else nil)

		if (tonumber(v.n) or 1) > 1 then
			v165:setStackCount(v.n)
		end

		if v.failed then
			v164.ImageTransparency = 0.5

			local icon = v164:FindFirstChild("Icon")

			if icon and icon:IsA("ImageLabel") then
				icon.ImageColor3 = Color3.fromRGB(120, 120, 120)
			end
		end

		local v168 = hoverInfoModule.bind(u34, v164, function()
			return {
				Name = v.failed and tostring(v.name) .. " (not transferred)" or v.name,
				Rarity = v.rarity,
				GlobalCopies = if typeof(v.copies) == "number" then v.copies else nil,
				Serial = if typeof(v.serial) == "number" then v.serial else nil,
				MaxSupply = if typeof(v.supply) == "number" then v.supply else nil,
				SourceButton = v164,
				FinisherName = if typeof(v.finisherName) == "string" then v.finisherName else nil,
				FinisherIcon = if typeof(v.finisherIcon) == "string" then v.finisherIcon else nil,
				FinisherRarity = if typeof(v.finisherRarity) == "string" then v.finisherRarity else nil,
				Kind = if typeof(v.kind) == "string" then v.kind else nil,
				ItemId = if typeof(v.id) == "string" then v.id else nil
			}
		end)

		local u169

		if not inspectItem then
			u169 = false
		else
			local vKind = v.kind

			u169 = true

			if vKind ~= "Knife" then
				u169 = true

				if vKind ~= "Revolver" then
					u169 = vKind == "Finisher"
				end
			end
		end

		if u169 then
			v164.MouseButton1Click:Connect(function()
				if v168.tapConsumed() then
					return
				end

				inspectItem2(v)
			end)
		end
	end
end
local function buildHeadRow(parent, layoutOrder, text, _, p33, p34)
	local rounded = math.round(p34 * 22)
	local rounded3 = math.round(p34 * 26)
	local rounded4 = math.round(rounded * 1.3)
	local v180 = math.max(rounded4, rounded3)
	local head: Frame = Instance.new("Frame")

	head.Name = "Head"
	head.BackgroundTransparency = 1
	head.BorderSizePixel = 0
	head.Size = UDim2.new(1, 0, 0, v180)
	head.LayoutOrder = layoutOrder
	head.ZIndex = 2
	v180 = rounded3 * 6

	local clone = u30:Clone()

	clone.Visible = true
	clone.Name = "Heading"
	clone.Text = text
	clone.TextSize = rounded
	clone.TextColor3 = color36
	clone.FontFace = Font.new(clone.FontFace.Family, Enum.FontWeight.Bold, clone.FontFace.Style)
	clone.AutomaticSize = Enum.AutomaticSize.None
	clone.Size = if p33 > 0 then UDim2.new(1, -(v180 + math.round(p34 * 8)), 1, 0) else UDim2.new(1, 0, 1, 0)
	clone.Position = UDim2.new(0, 0, 0, 0)
	clone.TextXAlignment = Enum.TextXAlignment.Left
	clone.TextYAlignment = Enum.TextYAlignment.Center
	clone.TextWrapped = false
	clone.TextTruncate = Enum.TextTruncate.AtEnd
	clone.ZIndex = 2
	clone.Parent = head

	if p33 > 0 then
		local clone2 = u32:Clone()

		clone2.Visible = true
		clone2.Size = UDim2.fromOffset(v180, rounded3)
		clone2.AnchorPoint = Vector2.new(1, 0.5)
		clone2.Position = UDim2.new(1, 0, 0.5, 0)
		clone2.ZIndex = 3

		local tokens = clone2:FindFirstChild("Tokens")

		if tokens and tokens:IsA("TextLabel") then
			local floored = math.floor(p33)

			tokens.Text = tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end

		clone2.Parent = head
	end

	head.Parent = parent

	return layoutOrder + 1
end
local function buildSide(parent, layoutOrder, p37, p38, p39, p40, p41, p42, p43, p44, p45)
	local side: Frame = Instance.new("Frame")

	side.Name = "Side"
	side.BackgroundTransparency = 1
	side.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded = math.round(p43 * 96)

	side.Size = uDim2New(1, 0, 0, rounded)
	side.AutomaticSize = Enum.AutomaticSize.Y
	side.LayoutOrder = layoutOrder
	side.ZIndex = 2
	verticalList(side, 0)

	local v200 = buildHeadRow(side, 1, p37, p42, p39, p43)
	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local v202 = UDim2.new
	local rounded5 = math.round(p43 * 5)
	local v204 = math.max(1, rounded5)

	gap.Size = v202(1, 0, 0, v204)
	gap.LayoutOrder = v200
	gap.Parent = side

	local n1 = v200 + 1

	if #p38 > 0 then
		buildItemGrid(side, n1, p38, p43, p44, p45)
		n1 += 1
	end

	if p40 < p41 then
		local frame: Frame = Instance.new("Frame")

		frame.Name = "Gap"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0

		local v207 = UDim2.new
		local rounded6 = math.round(p43 * 4)
		local v209 = math.max(1, rounded6)

		frame.Size = v207(1, 0, 0, v209)
		frame.LayoutOrder = n1
		frame.Parent = side

		local n2 = n1 + 1
		local v211 = ("+%d more not shown"):format(p41 - p40)

		cloneSub(side, n2, v211, p43 * 13, color35)
		n1 = n2 + 1
	end

	if #p38 == 0 and p39 <= 0 then
		cloneSub(side, n1, "Nothing.", p43 * 13)

		local n3 = n1 + 1
	end

	side.Parent = parent

	return layoutOrder + 1
end
local function paneWidth()
	local x = u27.AbsoluteSize.X

	if x <= 0 then
		return 0
	end

	return x - 4 - 10 - u27.ScrollBarThickness
end
local function gridColumns(p46)
	if p46 <= 0 then
		return 1
	end

	return (math.min(5, p46))
end
local function tilePxFor(p47)
	local x = u27.AbsoluteSize.X
	local n1 = if x <= 0 then 0 else x - 4 - 10 - u27.ScrollBarThickness

	if n1 <= 0 then
		return (math.round(p47 * 52))
	end

	local rounded = math.round(p47 * 6)
	local floored = math.floor((n1 - rounded * 4) / 5)
	local rounded7 = math.round(p47 * 38)
	local rounded8 = math.round(p47 * 96)

	return (math.clamp(floored, rounded7, rounded8))
end
local function buildDetailFrame(p48, p49, p50, p51)
	local y = u27.AbsoluteSize.Y
	local n1 = if y <= 0 then 1 else math.clamp(y / 315, 0.6, 1.15)
	local detail: Frame = Instance.new("Frame")

	detail.Name = "Detail"
	detail.Size = UDim2.new(1, 0, 0, 0)
	detail.AutomaticSize = Enum.AutomaticSize.Y
	detail.BackgroundTransparency = 1
	detail.BorderSizePixel = 0
	verticalList(detail, 0)

	local uiPadding: UIPadding = Instance.new("UIPadding")

	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.PaddingLeft = UDim.new(0, 4)
	uiPadding.PaddingRight = UDim.new(0, 10)
	uiPadding.PaddingBottom = UDim.new(0, 4)
	uiPadding.Parent = detail

	local n2 = 1
	local t10 = p49 and p49.gave or p48.gave or {}
	local t11 = p49 and p49.got or p48.got or {}
	local v233 = p49 and p49.gaveTokens

	if not v233 then
		local numberValue: number? = tonumber(p48.tokens)

		v233 = math.max(0, -(numberValue or 0))
	end

	local v235 = p49 and p49.gotTokens

	if not v235 then
		local numberValue: number? = tonumber(p48.tokens)

		v235 = math.max(0, numberValue or 0)
	end

	local numberValue = tonumber(p48.gaveN) or 0
	local numberValue3 = tonumber(p48.gotN) or 0
	local v239 = p49 and numberValue

	if not v239 then
		v239 = tonumber(p48.gaveShown) or 0
	end

	local v240 = p49 and numberValue3

	if not v240 then
		v240 = tonumber(p48.gotShown) or 0
	end

	local t12: {[any]: any} = {}
	local v242 = p49 and p49.src or p48.src

	if typeof(v242) == "string" then
		local v243 = v242:upper()

		table.insert(t12, { text = v243, color = color35 })
	end

	if p49 and typeof(p49.status) == "string" then
		local v244 = p49.status:upper()

		table.insert(t12, { text = v244, color = color35 })
	end

	if p48.missing then
		table.insert(t12, {
			text = "The full record for this trade is no longer available.",
			color = color35
		})
	elseif p50 then
		table.insert(t12, { text = "Loading the full record...", color = color33 })
	elseif p51 then
		local v245 = ("Showing a preview -- the full record couldn't be loaded (%s)."):format(p51)

		table.insert(t12, { text = v245, color = color35 })
	end

	local x = u27.AbsoluteSize.X
	local n3 = if x <= 0 then 0 else x - 4 - 10 - u27.ScrollBarThickness

	v242 = if n3 <= 0 then math.round(n1 * 52) else math.clamp(math.floor((n3 - math.round(n1 * 6) * 4) / 5), math.round(n1 * 38), (math.round(n1 * 96)))

	local n4: number = #t10

	n3 = if n4 <= 0 then 1 else math.min(5, n4)

	local n5: number = #t11
	local n6

	if n5 <= 0 then
		n6 = 1
	else
		n6 = math.min(5, n5)
	end

	for _, v in ipairs(t12) do
		cloneSub(detail, n2, v.text, n1 * 13, v.color)

		local layoutOrder: number = n2 + 1
		local gap: Frame = Instance.new("Frame")

		gap.Name = "Gap"
		gap.BackgroundTransparency = 1
		gap.BorderSizePixel = 0

		local uDim2New = UDim2.new
		local rounded = math.round(n1 * 4)
		local v257 = math.max(1, rounded)

		gap.Size = uDim2New(1, 0, 0, v257)
		gap.LayoutOrder = layoutOrder
		gap.Parent = detail
		n2 = layoutOrder + 1
	end

	local v258 = ("Items %s gave"):format(if t5.isSelf then "you" else t5.name)
	local v259 = buildSide(detail, n2, v258, t10, v233, v239, numberValue, color3, n1, v242, n3)
	local frame: Frame = Instance.new("Frame")

	frame.Name = "Gap"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0

	local v261 = UDim2.new
	local rounded9 = math.round(n1 * 6)
	local v263 = math.max(1, rounded9)

	frame.Size = v261(1, 0, 0, v263)
	frame.LayoutOrder = v259
	frame.Parent = detail
	n2 = v259 + 1

	local clone = u33:Clone()

	clone.Visible = true
	clone.LayoutOrder = n2
	clone.Size = UDim2.new(1, 0, 0, 2)
	clone.Parent = detail
	v259 = n2 + 1

	local frame2: Frame = Instance.new("Frame")

	frame2.Name = "Gap"
	frame2.BackgroundTransparency = 1
	frame2.BorderSizePixel = 0

	local v266 = UDim2.new
	local rounded10 = math.round(n1 * 6)

	v263 = math.max(1, rounded10)
	frame2.Size = v266(1, 0, 0, v263)
	frame2.LayoutOrder = v259
	frame2.Parent = detail
	v258 = ("Items %s received"):format(if t5.isSelf then "you" else t5.name)
	buildSide(detail, v259 + 1, v258, t11, v235, v240, numberValue3, color32, n1, v242, n6)

	return detail
end
local function paintDetail(p52, p53, p54, p55)
	if u37 then
		u37:Destroy()
		u37 = nil
	end

	local v272 = buildDetailFrame(p52, p53, p54, p55)

	v272.Parent = u27
	u37 = v272
end

local t6: {[any]: any} = { "Username", "DisplayName", "TimeLabel", "CountLabel" }
local t7: {[any]: any} = { "Avatar", "ClockIcon" }

local function setRowFocus(p56, p57)
	local n1: number = if p57 then 0 else 0.35

	for _, v in ipairs(t6) do
		local foundChild = p56:FindFirstChild(v, true)

		if foundChild and foundChild:IsA("TextLabel") then
			foundChild.TextTransparency = n1

			local uiStroke = foundChild:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				uiStroke.Transparency = n1
			end
		end
	end

	for _, v in ipairs(t7) do
		local foundChild2 = p56:FindFirstChild(v, true)

		if foundChild2 and foundChild2:IsA("ImageLabel") then
			foundChild2.ImageTransparency = if p57 then 0 else 0.42
		end
	end
end
local function applyCellStyle(p58, p59)
	local v285 = p59 and u29 or u28

	p58.ImageColor3 = v285.ImageColor3

	local uiStroke = p58:FindFirstChild("UIStroke")
	local uiStroke2 = v285:FindFirstChild("UIStroke")

	if uiStroke and uiStroke:IsA("UIStroke") and uiStroke2 and uiStroke2:IsA("UIStroke") then
		uiStroke.Color = uiStroke2.Color
		uiStroke.Thickness = uiStroke2.Thickness
		uiStroke.Transparency = uiStroke2.Transparency
	end

	local fade = p58:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.BackgroundTransparency = if p59 then 0.72 else 1
	end

	setRowFocus(p58, p59)
end

u47 = function(p60)
	local v290 = t1[p60]

	if not v290 then
		return
	end

	n1 = p60

	for i, v in ipairs(t2) do
		applyCellStyle(v, i == p60)
	end

	n2 += 1

	local v293: number = n2

	u27.CanvasPosition = Vector2.new(0, 0)

	local id = v290.id
	local s1 = if typeof(id) == "string" then tostring(t5.id) .. ":" .. id else nil
	local v296 = if s1 then t3[s1] else nil
	local u297 = false
	local numberValue: number? = tonumber(v290.gaveShown)
	local numberValue4: number? = tonumber(v290.gaveN)

	if (numberValue or 0) >= (numberValue4 or 0) then
		u297 = false

		if (tonumber(v290.gotShown) or 0) >= (tonumber(v290.gotN) or 0) then
			u297 = (tonumber(v290.tokens) or 0) == 0
		end
	end

	if not not v296 or not not v290.missing or typeof(id) ~= "string" or not not u297 or not tradeHistory_Request then
		if u37 then
			u37:Destroy()
			u37 = nil
		end

		local v300 = buildDetailFrame(v290, v296, false, nil)

		v300.Parent = u27
		u37 = v300

		return
	end

	if u37 then
		u37:Destroy()
		u37 = nil
	end

	u297 = buildDetailFrame(v290, nil, true, nil)
	u297.Parent = u27
	u37 = u297
	task.spawn(function()
		local ok, result = pcall(function()
			local t14: {[any]: any} = { op = "detail", id = id }

			if not t5.isSelf then
				t14.target = t5.id
			end

			return tradeHistory_Request:InvokeServer(t14)
		end)

		if v293 ~= n2 then
			return
		end

		if ok and typeof(result) == "table" and result.ok and typeof(result.detail) == "table" then
			if s1 then
				t3[s1] = result.detail
			end

			local resultDetail = result.detail

			if u37 then
				u37:Destroy()
				u37 = nil
			end

			local v386 = buildDetailFrame(v290, resultDetail, false, nil)

			v386.Parent = u27
			u37 = v386

			return
		end

		local v387 = typeof(result) == "table" and typeof(result.err) == "string" and result.err or "unavailable"

		if u37 then
			u37:Destroy()
			u37 = nil
		end

		local v388 = buildDetailFrame(v290, nil, false, v387)

		v388.Parent = u27
		u37 = v388
	end)
end

local function clearList()
	for _, v in ipairs(t2) do
		local vParent = v.Parent

		if vParent and vParent.Name == "CellHost" then
			vParent:Destroy()
		else
			v:Destroy()
		end
	end

	table.clear(t2)

	local emptyMessage = u26:FindFirstChild("EmptyMessage")

	if emptyMessage then
		emptyMessage:Destroy()
	end
end
local function showMessage(text)
	clearList()

	if u37 then
		u37:Destroy()
		u37 = nil
	end

	local clone = u31:Clone()

	clone.Visible = true
	clone.Name = "EmptyMessage"
	clone.Text = text
	clone.RichText = true
	clone.TextWrapped = true
	clone.TextXAlignment = Enum.TextXAlignment.Center

	local y = u27.AbsoluteSize.Y
	local n1

	if y <= 0 then
		n1 = 1
	else
		n1 = math.clamp(y / 315, 0.6, 1.15)
	end

	clone.TextSize = math.round(n1 * 15)
	clone.TextColor3 = color33
	clone.Size = UDim2.new(1, 0, 0, 70)
	clone.Parent = u26
end
local function setMaxTextSize(p62, p63)
	local uiTextSizeConstraint = p62:FindFirstChildOfClass("UITextSizeConstraint")

	if uiTextSizeConstraint then
		local rounded = math.round(p63)

		uiTextSizeConstraint.MaxTextSize = math.max(1, rounded)
	end
end
local function paintDisplayName(p64, p65)
	local displayName = p64:FindFirstChild("DisplayName")

	if not displayName or not displayName:IsA("TextLabel") then
		return
	end

	if p65.missing then
		displayName.Text = "NO RECORD"
		displayName.TextColor3 = color35

		return
	end

	local numberValue = tonumber(p65.other) or 0
	local v317 = numberValue > 0 and t4[numberValue] or nil

	displayName.Text = v317 ~= nil and v317 ~= "" and v317 or ""
	displayName.TextColor3 = color34
end
local function buildCell(p66, layoutOrder)
	local clone = u28:Clone()

	clone.Name = ("Trade%d"):format(layoutOrder)
	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	collectionService:AddTag(clone, "BlacklistHover")

	local y = u28.Size.Y
	local n1 = u26.AbsoluteSize.Y * y.Scale + y.Offset
	local n2 = if n1 <= 0 then 1 else math.clamp(n1 / 61, 0.6, 1.15)
	local rounded = math.round(n2 * 13)
	local textSize = math.max(8, rounded)

	n1 = rarityGradient(topRarity(p66.gave, p66.got))

	if n1 then
		n1.Name = "Rarity"
		n1.Parent = clone
	end

	local avatar = clone:FindFirstChild("Avatar")

	if avatar and avatar:IsA("ImageLabel") then
		local numberValue = tonumber(p66.other) or 0

		avatar.Image = numberValue > 0 and ("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(numberValue) or ""
	end

	local username = clone:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		local otherName = p66.otherName

		username.Text = typeof(otherName) == "string" and otherName ~= "" and "@" .. otherName or "Unknown"

		local uiTextSizeConstraint = username:FindFirstChildOfClass("UITextSizeConstraint")

		if uiTextSizeConstraint then
			local rounded11 = math.round(n2 * 18)

			uiTextSizeConstraint.MaxTextSize = math.max(1, rounded11)
		end
	end

	local displayName = clone:FindFirstChild("DisplayName")
	local uITextSizeConstraint = displayName and displayName:IsA("TextLabel") and displayName:FindFirstChildOfClass("UITextSizeConstraint")

	if uITextSizeConstraint then
		local rounded12 = math.round(n2 * 16)

		uITextSizeConstraint.MaxTextSize = math.max(1, rounded12)
	end

	paintDisplayName(clone, p66)

	local foundChild = clone:FindFirstChild("TimeLabel", true)

	if foundChild and foundChild:IsA("TextLabel") then
		foundChild.Text = relativeTime(p66.at)
		foundChild.TextColor3 = color36
		foundChild.TextSize = textSize
	end

	local foundChild3 = clone:FindFirstChild("ClockIcon", true)

	if foundChild3 and foundChild3:IsA("ImageLabel") then
		foundChild3.Size = UDim2.fromOffset(textSize, textSize)
	end

	local timeRow = clone:FindFirstChild("TimeRow")

	if timeRow and timeRow:IsA("GuiObject") then
		timeRow.Size = UDim2.new(0, 0, 0, textSize)

		local uiListLayout = timeRow:FindFirstChildOfClass("UIListLayout")

		if uiListLayout then
			local uDimNew = UDim.new
			local rounded13 = math.round(n2 * 3)
			local v341 = math.max(2, rounded13)

			uiListLayout.Padding = uDimNew(0, v341)
		end
	end

	local countLabel = clone:FindFirstChild("CountLabel")

	if countLabel and countLabel:IsA("TextLabel") then
		local v343

		if typeof(p66.src) == "string" and p66.src ~= "" then
			v343 = p66.src:upper()
		else
			v343 = "TRADE"
		end

		countLabel.Text = v343
		countLabel.TextColor3 = if v343 == "TRADE" then color36 else color35

		local rounded14 = math.round(n2 * 17)

		countLabel.TextSize = math.max(10, rounded14)
	end

	local cellHost: Frame = Instance.new("Frame")

	cellHost.Name = "CellHost"
	cellHost.BackgroundTransparency = 1
	cellHost.BorderSizePixel = 0
	cellHost.Size = clone.Size
	cellHost.LayoutOrder = layoutOrder
	cellHost.ZIndex = clone.ZIndex
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.Size = UDim2.fromScale(1, 1)

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Parent = clone

	local u347: boolean = false
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

	local function scaleTo(p68, p69)
		tweenService:Create(uiScale, p69, { Scale = p68 }):Play()
	end
	local function playUISound(p70)
		local foundChild4: Instance = workspace:FindFirstChild(p70)

		if foundChild4 and foundChild4:IsA("Sound") then
			foundChild4:Play()
		end
	end

	clone.MouseButton1Click:Connect(function()
		local uiClick: Instance = workspace:FindFirstChild("UIClick")

		if uiClick and uiClick:IsA("Sound") then
			uiClick:Play()
		end

		u47(layoutOrder)
	end)
	clone.MouseEnter:Connect(function()
		u347 = true

		local uiHover: Instance = workspace:FindFirstChild("UIHover")

		if uiHover and uiHover:IsA("Sound") then
			uiHover:Play()
		end

		tweenService:Create(uiScale, tweenInfo, { Scale = 1.015 }):Play()
	end)
	clone.MouseLeave:Connect(function()
		u347 = false
		tweenService:Create(uiScale, tweenInfo, { Scale = 1 }):Play()
	end)
	clone.MouseButton1Down:Connect(function()
		tweenService:Create(uiScale, tweenInfo2, { Scale = 0.975 }):Play()
	end)
	clone.MouseButton1Up:Connect(function()
		tweenService:Create(uiScale, tweenInfo3, {
			Scale = if u347 then 1.015 else 1
		}):Play()
	end)
	clone.Parent = cellHost
	cellHost.Parent = u26

	return clone
end
local function rebuild()
	clearList()

	if #t1 ~= 0 then
		primeLocalNames()

		for i, v in ipairs(t1) do
			local v355 = buildCell(v, i)

			table.insert(t2, v355)
		end

		local v356 = u47
		local v357 = math.clamp(n1, 1, #t1)

		v356(v357)
		fetchDisplayNames(function()
			for i, v in ipairs(t2) do
				local v397 = t1[i]

				if v397 and v.Parent then
					paintDisplayName(v, v397)
				end
			end
		end)

		return
	end

	if u41 == "private" then
		local s1 = if t5.isSelf then "Your trade history is private." else ("%s's trade history is private."):format(t5.name)

		showMessage(s1)

		return
	end

	if u41 then
		local s2 = if t5.isSelf then "Couldn't load your trade history.\nTry reopening this menu." else ("Couldn't load %s's trade history.\nTry reopening this menu."):format(t5.name)

		showMessage(s2)

		return
	end

	if u40 then
		local s3 = if t5.isSelf then "No trades yet.\nEverything you trade shows up here." else ("%s hasn't traded yet."):format(t5.name)

		showMessage(s3)

		return
	end

	showMessage("Loading...")
end
local function refresh()
	if u39 then
		return
	end

	if not tradeHistory_Request then
		u41 = "no remote"
		rebuild()

		return
	end

	u39 = true

	local gen = t5.gen
	local t13: {[any]: any} = { op = "list" }

	if not t5.isSelf then
		t13.target = t5.id
	end

	task.spawn(function()
		local ok, result = pcall(function()
			return tradeHistory_Request:InvokeServer(t13)
		end)

		if gen ~= t5.gen then
			return
		end

		u39 = false

		if ok and typeof(result) == "table" and result.ok and typeof(result.entries) == "table" then
			u41 = nil
			u40 = true
			t1 = result.entries
			rebuild()

			return
		end

		local v400 = ok and typeof(result) == "table" and result.err or nil

		if v400 == "private" then
			u41 = "private"
			u40 = false
			t1 = {}
			rebuild()

			return
		end

		local text: string = tostring(v400 or result)

		warn("[TradeHistory] list request failed: " .. text)

		if not u40 then
			u41 = "request failed"
			rebuild()
		end
	end)
end

return {
	mount = function(p71)
		if u24 then
			return
		end

		u24 = true
		u25 = p71
		u26 = p71:WaitForChild("List"):WaitForChild("ScrollingFrame")
		u27 = p71:WaitForChild("Detail"):WaitForChild("ScrollingFrame")

		local templates = p71:WaitForChild("Templates")

		u30 = templates:WaitForChild("TitleLabel")
		u31 = templates:WaitForChild("SubLabel")
		u32 = templates:WaitForChild("TokenPill")
		u33 = templates:WaitForChild("Divider")

		for _, v in ipairs(templates:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Visible = false
			end
		end

		u28 = u26:WaitForChild("Cell")
		u29 = u26:WaitForChild("CellSelected")
		u28.Visible = false
		u29.Visible = false
		u27.CanvasSize = UDim2.new()
		u27.AutomaticCanvasSize = Enum.AutomaticSize.Y
		u26.AutomaticCanvasSize = Enum.AutomaticSize.Y

		for _, v in ipairs(u27:GetChildren()) do
			if v:IsA("GuiObject") then
				v:Destroy()
			end
		end

		for _, v in ipairs(u26:GetChildren()) do
			if (v:IsA("GuiButton") or v.Name == "CellHost") and v ~= u28 and v ~= u29 then
				v:Destroy()
			end
		end

		u34 = hoverInfoModule.create(p71)
	end,
	setSubject = function(p72)
		local player = p72 or LocalPlayer

		if player.UserId == t5.id then
			return
		end

		t5.id = player.UserId
		t5.name = player.DisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		t5.isSelf = player.UserId == LocalPlayer.UserId

		local v373: {[any]: any} = t5

		v373.gen = v373.gen + 1
		n2 += 1
		u39 = false
		u40 = false
		u41 = nil
		n1 = 1
		t1 = {}

		if u24 then
			clearList()

			if u37 then
				u37:Destroy()
				u37 = nil
			end

			hoverInfoModule.hide(u34)

			if u42 then
				rebuild()
			end
		end
	end,
	setVisible = function(visible)
		if not u24 then
			return
		end

		u42 = visible
		u25.Visible = visible

		if visible then
			if not u40 then
				rebuild()
			end

			refresh()

			return
		end

		hoverInfoModule.hide(u34)
	end,
	isVisible = function()
		return u42
	end
}
