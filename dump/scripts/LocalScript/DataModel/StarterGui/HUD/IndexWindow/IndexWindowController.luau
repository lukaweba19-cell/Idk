-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local traitText = require(shared:WaitForChild("TraitText"))
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local boothTheme = require(shared:WaitForChild("BoothTheme"))
local linePlot = require(shared:WaitForChild("LinePlot"))
local hoverInfoModule = require(shared:WaitForChild("HoverInfoModule"))
local rapClient = require(shared:WaitForChild("RapClient"))
local rapProjected = require(shared:WaitForChild("RapProjected"))
local scrollListFit = require(shared:WaitForChild("ScrollListFit"))
local universe = require(shared:WaitForChild("Universe"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")

local function ensureBindable(name)
	local foundChild = bindables:FindFirstChild(name)

	if foundChild == nil then
		local bindableEvent: BindableEvent = Instance.new("BindableEvent")

		bindableEvent.Name = name
		bindableEvent.Parent = bindables
		foundChild = bindableEvent
	end

	return foundChild
end

local openItemIndex = bindables:FindFirstChild("OpenItemIndex")

if openItemIndex == nil then
	local openItemIndex2: BindableEvent = Instance.new("BindableEvent")

	openItemIndex2.Name = "OpenItemIndex"
	openItemIndex2.Parent = bindables
	openItemIndex = openItemIndex2
end

local color3 = Color3.fromRGB(134, 134, 134)
local color32 = Color3.fromRGB(255, 209, 24)
local color33 = Color3.fromRGB(134, 134, 134)
local color34 = Color3.fromRGB(250, 226, 53)
local color35 = Color3.fromRGB(255, 255, 255)
local color36 = Color3.fromRGB(196, 196, 196)
local scriptParent: Instance = script.Parent
local options: Instance = scriptParent:WaitForChild("Options")
local itemContent: Instance = scriptParent:WaitForChild("ItemContent")
local rapPane: Instance = scriptParent:WaitForChild("RapPane")
local filters: Instance = scriptParent:WaitForChild("Filters")
local favoriteButton: Instance = filters:WaitForChild("FavoriteButton")
local clone: Instance = rapPane:WaitForChild("Subtitle"):Clone()

clone.Name = "GraphLabelTemplate"
clone.Visible = false
clone.TextScaled = false
clone.Text = ""
clone.Parent = rapPane

local closeButton: Instance = scriptParent:WaitForChild("CloseButton")
local tabHeader: Instance = options:WaitForChild("TabHeader")
local textBox: Instance = options:WaitForChild("SearchBar"):WaitForChild("TextBox")
local sortChip: Instance = options:WaitForChild("SortChip")
local filterChip: Instance = options:WaitForChild("FilterChip")
local items: Instance = itemContent:WaitForChild("Items")
local title: Instance = rapPane:WaitForChild("Title")
local subtitle: Instance = rapPane:WaitForChild("Subtitle")
local empty: Instance = rapPane:WaitForChild("Empty")
local plotHost: Instance = rapPane:WaitForChild("PlotHost")
local navigator: Instance = scriptParent:WaitForChild("Navigator")
local itemName: Instance = filters:WaitForChild("ItemName")
local filtersRarity: Instance = filters:WaitForChild("Rarity")
local itemTemplate: Instance = filters:WaitForChild("ItemTemplate")
local exists: Instance = filters:WaitForChild("Exists")
local rapLabel: Instance = filters:WaitForChild("RapLabel")
local description: Instance = filters:WaitForChild("Description")
local equipButton: Instance = filters:WaitForChild("EquipButton")
local star: Instance = favoriteButton:WaitForChild("Star")
local t1: {[any]: any} = {
	Root = scriptParent,
	CloseButton = closeButton,
	TabHeader = tabHeader,
	SearchBox = textBox,
	SortChip = sortChip,
	FilterChip = filterChip,
	ItemContent = itemContent,
	Items = items,
	RapPane = rapPane,
	RapTitle = title,
	RapSubtitle = subtitle,
	RapEmpty = empty,
	PlotHost = plotHost,
	GraphLabelTemplate = clone,
	Navigator = navigator,
	Panel = filters,
	PName = itemName,
	PRarity = filtersRarity,
	PTile = itemTemplate,
	PExists = exists,
	PRap = rapLabel,
	PDesc = description,
	PPrimary = equipButton,
	PFav = favoriteButton,
	PFavStar = star
}

t1.Items.AutomaticCanvasSize = Enum.AutomaticSize.Y
t1.Items.CanvasSize = UDim2.new()
scrollListFit.bind(t1.Items)

local boothThemeFmt = boothTheme.Fmt

local function compact(p2)
	if p2 < 10000 then
		return boothThemeFmt(p2)
	end

	if p2 < 1000000 then
		return string.format("%.1fK", p2 / 1000)
	end

	return string.format("%.1fM", p2 / 1000000)
end
local function setButtonText(p3, text)
	local textLabel = p3:FindFirstChild("TextLabel")

	if not textLabel or not textLabel:IsA("TextLabel") then
		return
	end

	textLabel.Text = text

	local textLabel2 = textLabel:FindFirstChild("TextLabel")

	if textLabel2 and textLabel2:IsA("TextLabel") then
		textLabel2.Text = text
	end
end
local function onClick(p5, p6)
	local n1 = -math.huge

	local function fire()
		local v481 = os.clock()

		if v481 - n1 < 0.15 then
			return
		end

		n1 = v481
		p6()
	end

	p5.Activated:Connect(fire)
	p5.MouseButton1Click:Connect(fire)
end
local function notifyFail(p7)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(_GNotify, { notifType = "FailNotification", errorMessage = p7 })
	end
end

local t2: {[any]: any} = {
	navIndex = 1,
	sortIndex = 1,
	showIndex = 1,
	search = "",
	selected = nil,
	selectedEntry = nil,
	panelTile = nil,
	mode = "grid",
	plot = nil,
	fallbackRow = nil,
	historyToken = 0,
	openGen = 0,
	unavailable = false,
	hover = nil,
	spoof = nil,
	catalog = {},
	favorites = {},
	owned = {},
	tiles = {},
	hover = hoverInfoModule.create(t1.Root)
}

local function isOwned(p8)
	return (t2.owned[p8.Key] or 0) > 0
end
local function isFav(p9)
	return t2.favorites[p9.Key] == true
end

local u63 = nil

local function rapValue(p10)
	local v159 = u63(p10)

	if v159 == nil or typeof(v159.RAP) ~= "number" then
		return nil
	end

	return v159.RAP
end
local function hasRap(p11)
	return p11.Kind ~= "Crate"
end

local t3: {[any]: any} = {
	WINDOW_KEY = "ItemIndex",
	HISTORY_DAYS = 14,
	HISTORY_RETRY_SEC = 0.7,
	PRIME_WAIT_SEC = 3,
	REMOTE_WAIT_SEC = 20,
	MIN_COPIES = 10,
	ICON_CHECK = "rbxassetid://111743756635965",
	NAV = {
		{ Name = "All", Kind = nil, Header = "All Items" },
		{ Name = "Knives", Kind = "Knife", Header = "Knives" },
		{ Name = "Revolvers", Kind = "Revolver", Header = "Guns" },
		{ Name = "Cases", Kind = "Crate", Header = "Cases" },
		{ Name = "Finishers", Kind = "Finisher", Header = "Finishers" }
	},
	SORTS = { "Default", "Name", "Value", "Newest", "Exists" },
	SHOWS = { "All", "Owned", "Unowned", "Favorites" },
	KIND_ORDER = { Knife = 1, Revolver = 2, Crate = 3, Finisher = 4 },
	NAV_ACTIVE = Color3.new(1, 1, 1),
	NAV_INACTIVE = color3,
	FAV_ON = color32,
	FAV_OFF = color33,
	PLOT_LINE = color34,
	TEXT = color35,
	MUTED = color36,
	SPOOF_BANDS = {
		Common = { 40, 90 },
		Uncommon = { 100, 220 },
		Rare = { 250, 600 },
		Epic = { 700, 1600 },
		Legendary = { 2000, 5000 },
		Secret = { 6000, 15000 },
		Collectible = { 15000, 60000 }
	}
}

local function remote(childName)
	local v162: Instance = remotes:FindFirstChild(childName) or remotes:WaitForChild(childName, t3.REMOTE_WAIT_SEC)

	if v162 ~= nil and v162:IsA("RemoteFunction") then
		return v162
	end

	return nil
end
local function invoke(childName, ...)
	local v164 = remotes:FindFirstChild(childName) or remotes:WaitForChild(childName, t3.REMOTE_WAIT_SEC)
	local v165 = if v164 ~= nil and v164:IsA("RemoteFunction") then v164 else nil

	if v165 == nil then
		return nil
	end

	v164 = table.pack(pcall(v165.InvokeServer, v165, ...))

	if not v164[1] then
		return nil
	end

	return table.unpack(v164, 2, v164.n)
end
local function loadCatalog()
	local v166 = invoke("ItemIndex", "Catalog")

	if typeof(v166) == "table" then
		t2.catalog = v166
	end

	return #t2.catalog > 0
end
local function loadFavorites()
	local v167 = invoke("ItemIndex", "Favorites")

	if typeof(v167) == "table" then
		t2.favorites = v167
	end
end
local function loadOwned()
	local v168 = invoke("Inventory", "GetSnapshot", { Filter = "All" })

	if typeof(v168) == "table" and typeof(v168.Items) == "table" then
		local t4: {[any]: any} = {}

		for _, v in ipairs(v168.Items) do
			local v172 = if v.Kind == "Crate" then v.CrateId else v.ItemId

			if typeof(v.Kind) == "string" and typeof(v172) == "string" then
				local s1: string = v.Kind .. ":" .. v172
				local v174 = t4[s1] or 0
				local numberValue: number? = tonumber(v.Stack)
				local v176 = math.max(1, numberValue or 1)

				t4[s1] = v174 + v176
			end
		end

		t2.owned = t4

		return
	end
end
local function spoofInfoFor(p14, p15)
	local spoof_bands = t3.SPOOF_BANDS
	local text: string = tostring(p14.Rarity)
	local v181 = spoof_bands[text] or t3.SPOOF_BANDS.Uncommon
	local v182 = p15:NextInteger(3, 40)
	local v183 = p15:NextInteger(v181[1], v181[2])

	if v183 >= 1200 then
		local n1: number = if v183 >= 100000 then 5000 else if v183 >= 10000 then 500 else 100
		local floored = math.floor(v183 / n1 + 0.5)
		local v186 = math.max(1200, floored * n1)
		local v187 = p15:NextNumber(0.55, 1.3)
		local floored2 = math.floor(v186 * v187)
		local v189 = math.max(1, floored2)
		local kind = p14.Kind
		local itemId = p14.ItemId
		local timestamp = os.time()

		return {
			ValueBased = true,
			Confidence = "High",
			Kind = kind,
			ItemId = itemId,
			RAP = v186,
			MarketRAP = v189,
			N = v182,
			UpdatedAt = timestamp
		}
	end

	return {
		ValueBased = false,
		Kind = p14.Kind,
		ItemId = p14.ItemId,
		RAP = v183,
		MarketRAP = v183,
		N = v182,
		Confidence = if v182 < 8 then "Low" else "High",
		UpdatedAt = os.time()
	}
end
local function spoofHistoryFor(p16, p17, p18)
	local timestamp = os.time()
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}
	local v199 = p18:NextInteger(0, p17 // 3)
	local v200 = tonumber(p16.MarketRAP) or p16.RAP
	local v201 = p18:NextNumber(0.75, 1.25)
	local n1 = v200 * v201

	for i = 1, p17 do
		local n2 = timestamp - timestamp % 86400 - (p17 - i) * 86400

		if v199 >= i then
			table.insert(t5, { RAP = nil, N = 0, T = n2 })
		else
			local v205 = p18:NextNumber(-0.06, 0.06)
			local n3 = n1 * (1 + v205)

			n1 = n3 + (v200 - n3) * 0.2

			local v207

			if i == p17 then
				v207 = v200
			else
				local floored = math.floor(n1 + 0.5)

				v207 = math.max(1, floored)
			end

			local v209 = p18:NextInteger(0, 5)

			table.insert(t5, { T = n2, RAP = v207, N = v209 })

			for _ = 1, v209 do
				local v211 = p18:NextInteger(0, 86399)
				local v212 = p18:NextNumber(0.8, 1.2)
				local floored = math.floor(v207 * v212 + 0.5)
				local v214 = math.max(1, floored)

				table.insert(t6, { T = n2 + v211, P = v214 })
			end
		end
	end

	return {
		Kind = p16.Kind,
		ItemId = p16.ItemId,
		Days = t5,
		Points = t6,
		RAP = p16.RAP,
		MarketRAP = p16.MarketRAP,
		ValueBased = p16.ValueBased,
		N = p16.N,
		Confidence = p16.Confidence
	}
end
local function spoofRap(p19)
	local spoof = t2.spoof

	if spoof == nil or p19.Kind == "Crate" then
		return nil
	end

	local v217 = spoof.rap[p19.Key]

	if v217 == nil then
		v217 = spoofInfoFor(p19, spoof.rng)
		spoof.rap[p19.Key] = v217
	end

	return v217
end
local function spoofHistory(p20)
	local spoof = t2.spoof
	local v220

	if spoof == nil or p20.Kind == "Crate" then
		v220 = nil
	else
		local v221 = spoof.rap[p20.Key]

		if v221 == nil then
			v221 = spoofInfoFor(p20, spoof.rng)
			spoof.rap[p20.Key] = v221
		end

		v220 = v221
	end

	if v220 == nil then
		return nil
	end

	local v222 = t2.spoof
	local v223 = v222.hist[p20.Key]

	if v223 == nil then
		v223 = spoofHistoryFor(v220, v222.days, v222.rng)
		v222.hist[p20.Key] = v223
	end

	return v223
end

u63 = function(p21)
	if t2.spoof == nil then
		return rapClient.Peek(p21.Kind, p21.ItemId)
	end

	local spoof = t2.spoof

	if spoof == nil or p21.Kind == "Crate" then
		return nil
	end

	local v226 = spoof.rap[p21.Key]

	if v226 == nil then
		v226 = spoofInfoFor(p21, spoof.rng)
		spoof.rap[p21.Key] = v226
	end

	return v226
end

local function attachProjectedBadge(p22)
	local cell = p22.cell

	if cell.Parent == nil then
		return
	end

	local v229 = rapProjected.Is(u63(p22.item))

	rapProjected.SetTag(cell, v229, 0.97, if (t2.owned[p22.item.Key] or 0) > 0 then 0.28 else 0.03, 0.22, 7)
end
local function attachRapTag(p23)
	local cell = p23.cell

	if cell.Parent ~= nil then
		local v232 = rapProjected.Is(u63(p23.item))

		rapProjected.SetTag(cell, v232, 0.97, if (t2.owned[p23.item.Key] or 0) > 0 then 0.28 else 0.03, 0.22, 7)
	end

	local v233 = u63(p23.item)
	local v234 = if v233 == nil or typeof(v233.RAP) ~= "number" then nil else v233.RAP

	if v234 == nil then
		return
	end

	if p23.tag == nil or p23.tag.Parent == nil then
		p23.tag = boothTheme.PriceTag(p23.cell, v234)

		return
	end

	local textLabel = p23.tag:FindFirstChildWhichIsA("TextLabel")

	if textLabel then
		textLabel.Text = boothThemeFmt(v234)
	end
end
local function attachFavStar(p24)
	local cell = p24.cell
	local favStar = cell:FindFirstChild("FavStar")

	if t2.favorites[p24.item.Key] ~= true then
		if favStar ~= nil then
			favStar:Destroy()
		end
	elseif favStar == nil then
		local clone2 = t1.PFavStar:Clone()

		clone2.Name = "FavStar"
		clone2.Visible = true
		clone2.TextColor3 = t3.FAV_ON
		clone2.AnchorPoint = Vector2.new(0, 0)
		clone2.Position = UDim2.new(0.03, 0, 0.01, 0)
		clone2.Size = UDim2.new(0.28, 0, 0.28, 0)
		clone2.ZIndex = 7
		clone2.Parent = cell

		return
	end
end
local function attachOwnedBadge(p25)
	local cell = p25.cell
	local ownedBadge = cell:FindFirstChild("OwnedBadge")

	if not ((t2.owned[p25.item.Key] or 0) > 0) then
		if ownedBadge ~= nil then
			ownedBadge:Destroy()
		end
	elseif ownedBadge == nil then
		local ownedBadge: ImageLabel = Instance.new("ImageLabel")

		ownedBadge.Name = "OwnedBadge"
		ownedBadge.BackgroundTransparency = 1
		ownedBadge.Image = t3.ICON_CHECK
		ownedBadge.ScaleType = Enum.ScaleType.Fit
		ownedBadge.AnchorPoint = Vector2.new(1, 0)
		ownedBadge.Position = UDim2.new(0.97, 0, 0.03, 0)
		ownedBadge.Size = UDim2.new(0.22, 0, 0.22, 0)
		ownedBadge.ZIndex = 7
		ownedBadge.Parent = cell
	end

	local v244 = p25.cell

	if v244.Parent == nil then
		return
	end

	local v245 = rapProjected.Is(u63(p25.item))

	rapProjected.SetTag(v244, v245, 0.97, if (t2.owned[p25.item.Key] or 0) > 0 then 0.28 else 0.03, 0.22, 7)
end
local function clearPanelTile()
	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end
end
local function setPanelTile(p26)
	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	local pTile = t1.PTile
	local uiFrameworkCreateItemCell = uiFramework.createItemCell
	local text: string = tostring(p26.Rarity or "Common")
	local typeName: string = typeof(p26.Icon)
	local v251 = uiFrameworkCreateItemCell(text, {
		name = "PanelTile",
		visible = true,
		active = false,
		interactable = false,
		selectable = false,
		icon = if typeName == "string" then p26.Icon else nil,
		parent = t1.Panel
	})

	v251.AnchorPoint = pTile.AnchorPoint
	v251.Position = pTile.Position
	v251.Size = pTile.Size
	v251.ZIndex = pTile.ZIndex + 1
	t2.panelTile = v251
end
local function rapText(p27)
	if p27.Kind == "Crate" then
		return ""
	end

	local v253 = u63(p27)

	if v253 == nil then
		if rapClient.Warming() then
			return "Value: ..."
		end
	elseif typeof(v253.RAP) == "number" then
		local s1: string = "Value: " .. boothThemeFmt(v253.RAP)

		if v253.Confidence == "Low" then
			s1 ..= "  (low confidence)"
		end

		return s1
	end

	return "Value: --"
end
local function existsText(p28)
	local t7: {[any]: any} = {}

	if typeof(p28.GlobalCopies) == "number" and p28.GlobalCopies > 0 then
		if typeof(p28.MaxSupply) == "number" then
			local v257 = boothThemeFmt(p28.GlobalCopies)

			table.insert(t7, ("%s of %s Exist"):format(v257, boothThemeFmt(p28.MaxSupply)))
		else
			local v258 = boothThemeFmt(p28.GlobalCopies)

			table.insert(t7, v258 .. " Exist")
		end
	elseif typeof(p28.MaxSupply) == "number" then
		local v259 = boothThemeFmt(p28.MaxSupply)

		table.insert(t7, "Limited to " .. v259)
	end

	if p28.Unobtainable == true then
		table.insert(t7, "Unobtainable")
	end

	local v260 = t2.owned[p28.Key] or 0

	if v260 > 0 then
		local v261 = boothThemeFmt(v260)

		table.insert(t7, "You own " .. v261)
	end

	return table.concat(t7, "  •  ")
end
local function setFavVisual(p29)
	t1.PFavStar.TextColor3 = if p29 then t3.FAV_ON else t3.FAV_OFF
end
local function refreshPanelRap()
	local selected = t2.selected

	if selected == nil then
		return
	end

	t1.PRap.Text = rapText(selected)
end
local function showPanel(p30)
	t2.selected = p30
	t1.Panel.Visible = true

	local traitTextBind = traitText.Bind
	local pName = t1.PName
	local text: string = tostring(p30.Name)

	traitTextBind(pName, text)

	for _, v in ipairs(t1.PName:GetChildren()) do
		if v:IsA("UIGradient") and v:GetAttribute("RarityGradient") then
			v:Destroy()
		end
	end

	t1.PName.TextColor3 = rarity.Colors[p30.Rarity] or Color3.fromRGB(255, 255, 255)
	t1.PRarity.Text = if p30.Rarity == "Empty" then "Consumable" else tostring(p30.Rarity)
	t1.PRarity.TextColor3 = Color3.fromRGB(255, 255, 255)
	rarity.ApplyTextGradient(t1.PRarity, p30.Rarity)

	local v270 = existsText(p30)

	t1.PExists.Text = v270
	t1.PExists.Visible = v270 ~= ""
	t1.PRap.Text = rapText(p30)
	t1.PRap.Visible = p30.Kind ~= "Crate"
	v270 = if typeof(p30.Description) == "string" then p30.Description else ""
	t1.PDesc.Text = v270
	t1.PDesc.Visible = v270 ~= ""
	setPanelTile(p30)
	t1.PPrimary.Visible = p30.Kind ~= "Crate"

	local s1: string = if t2.mode == "rap" then "Back" else "View Value"
	local textLabel = t1.PPrimary:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = s1

		local textLabel3 = textLabel:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.Text = s1
		end
	end

	t1.PFavStar.TextColor3 = if t2.favorites[p30.Key] == true then t3.FAV_ON else t3.FAV_OFF

	if p30.Kind ~= "Crate" and u63(p30) == nil then
		rapClient.Request(p30.Kind, p30.ItemId, function(p31)
			if p31 == nil or t2.selected ~= p30 then
				return
			end

			local selected = t2.selected

			if selected ~= nil then
				t1.PRap.Text = rapText(selected)
			end

			local selectedEntry = t2.selectedEntry

			if selectedEntry ~= nil and selectedEntry.item == p30 and selectedEntry.cell.Parent ~= nil then
				attachRapTag(selectedEntry)
			end
		end)
	end
end
local function hidePanel()
	t2.selected = nil
	t2.selectedEntry = nil

	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	t1.Panel.Visible = false
end
local function matches(p32)
	local v275 = t3.NAV[t2.navIndex]

	if v275.Kind == nil or p32.Kind == v275.Kind then
		if typeof(p32.GlobalCopies) == "number" and p32.GlobalCopies < t3.MIN_COPIES and not ((t2.owned[p32.Key] or 0) > 0) then
			return false
		end

		local v276 = t3.SHOWS[t2.showIndex]

		if v276 == "Owned" and not ((t2.owned[p32.Key] or 0) > 0) then
			return false
		end

		if v276 == "Unowned" and (t2.owned[p32.Key] or 0) > 0 then
			return false
		end

		if v276 == "Favorites" and t2.favorites[p32.Key] ~= true then
			return false
		end

		if t2.search == "" then
			return true
		end

		local stringFind = string.find
		local stringLower = string.lower
		local text: string = tostring(p32.Name)
		local v280 = stringLower(text)
		local lowerText = string.lower(t2.search)

		return stringFind(v280, lowerText, 1, true) ~= nil
	end

	return false
end
local function sortName(p33)
	local stringLower = string.lower
	local text: string = tostring(p33.Name)
	local v285 = stringLower(text)

	return (string.gsub(v285, "^%b[]%s*", ""))
end
local function defaultLess(p34, p35)
	local v288 = rarity.Order[p34.Rarity] or 0
	local v289 = rarity.Order[p35.Rarity] or 0

	if v288 ~= v289 then
		return v288 > v289
	end

	v289 = t3.KIND_ORDER[p34.Kind] or 99
	v288 = t3.KIND_ORDER[p35.Kind] or 99

	if v289 ~= v288 then
		return v288 > v289
	end

	local stringLower = string.lower
	local text: string = tostring(p34.Name)
	local v292 = stringLower(text)
	local v293 = string.gsub(v292, "^%b[]%s*", "")
	local v294 = string.lower
	local text2: string = tostring(p35.Name)

	v292 = v294(text2)

	local v296 = string.gsub(v292, "^%b[]%s*", "")

	if v293 ~= v296 then
		return v293 < v296
	end

	local text3: string = tostring(p34.Key)
	local text4: string = tostring(p35.Key)

	return text3 < text4
end
local function numberLess(p36, p37)
	return function(p38, p39)
		local v487 = p36(p38)
		local v488 = p36(p39)

		if v487 == v488 then
			return (defaultLess(p38, p39))
		end

		if v487 == nil then
			return false
		end

		if v488 == nil then
			return true
		end

		if p37 then
			return v487 > v488
		end

		return v487 < v488
	end
end
local function comparator()
	local v301 = t3.SORTS[t2.sortIndex]

	if v301 == "Name" then
		return function(p40, p41)
			local stringLower = string.lower
			local text: string = tostring(p40.Name)
			local v493 = stringLower(text)
			local v494 = string.gsub(v493, "^%b[]%s*", "")
			local v495 = string.lower
			local text5: string = tostring(p41.Name)

			v493 = v495(text5)

			local v497 = string.gsub(v493, "^%b[]%s*", "")

			if v494 ~= v497 then
				return v494 < v497
			end

			return (defaultLess(p40, p41))
		end
	end

	if v301 == "Value" or v301 == "RAP" then
		local v302: (...any) -> ...any = rapValue
		local u303: boolean = true

		return function(p42, p43)
			local v500 = v302(p42)
			local v501 = v302(p43)

			if v500 == v501 then
				return (defaultLess(p42, p43))
			end

			if v500 == nil then
				return false
			end

			if v501 == nil then
				return true
			end

			if u303 then
				return v500 > v501
			end

			return v500 < v501
		end
	end

	if v301 == "Newest" then
		local function v304(p44)
			return p44.AddedAt
		end

		local u305: boolean = true

		return function(p45, p46)
			local v505 = v304(p45)
			local v506 = v304(p46)

			if v505 == v506 then
				return (defaultLess(p45, p46))
			end

			if v505 == nil then
				return false
			end

			if v506 == nil then
				return true
			end

			if u305 then
				return v505 > v506
			end

			return v505 < v506
		end
	end

	if v301 == "Exists" then
		local function v306(p47)
			return p47.GlobalCopies
		end

		local u307: boolean = false

		return function(p48, p49)
			local v510 = v306(p48)
			local v511 = v306(p49)

			if v510 == v511 then
				return (defaultLess(p48, p49))
			end

			if v510 == nil then
				return false
			end

			if v511 == nil then
				return true
			end

			if u307 then
				return v510 > v511
			end

			return v510 < v511
		end
	end

	return defaultLess
end
local function clearTiles()
	for _, v in ipairs(t2.tiles) do
		v.api:destroy()
	end

	table.clear(t2.tiles)
	t2.selectedEntry = nil
	hoverInfoModule.hide(t2.hover)
end
local function selectEntry(p50)
	if p50 == t2.selectedEntry then
		return
	end

	if t2.selectedEntry ~= nil then
		t2.selectedEntry.api:setSelected(false)
	end

	t2.selectedEntry = p50
	p50.api:setSelected(true)
	showPanel(p50.item)
end
local function renderGrid()
	local v311 = if t2.selected == nil then nil else t2.selected.Key

	clearTiles()

	local t8 = {}

	for _, v in ipairs(t2.catalog) do
		if matches(v) then
			table.insert(t8, v)
		end
	end

	local tableSort = table.sort
	local v316 = comparator()

	tableSort(t8, v316)

	for i, v in ipairs(t8) do
		local uiFrameworkCreateItemCell = uiFramework.createItemCell
		local text: string = tostring(v.Rarity or "Common")
		local v321, v322 = uiFrameworkCreateItemCell(text, {
			visible = true,
			active = true,
			interactable = true,
			selectable = true,
			icon = if typeof(v.Icon) == "string" then v.Icon else nil,
			name = "Item_" .. tostring(v.Key),
			parent = t1.Items,
			layoutOrder = i
		})
		local t9: {[any]: any} = { tag = nil, cell = v321, api = v322, item = v }

		attachOwnedBadge(t9)
		attachRapTag(t9)
		attachFavStar(t9)

		local v324 = hoverInfoModule.bind(t2.hover, v321, function()
			local v512 = u63(v)
			local text6: string = tostring(v.Name)
			local text7: string = tostring(v.Rarity)

			return {
				Name = text6,
				Rarity = text7,
				GlobalCopies = v.GlobalCopies,
				MaxSupply = v.MaxSupply,
				SourceButton = v321,
				Kind = v.Kind,
				ItemId = v.ItemId,
				RAP = if v512 == nil or typeof(v512.RAP) ~= "number" then nil else v512.RAP,
				RapConfidence = if v512 == nil or typeof(v512.Confidence) ~= "string" then nil else v512.Confidence,
				RapProjected = rapProjected.Is(v512)
			}
		end)

		local function v325()
			if v324.tapConsumed() then
				return
			end

			local v515: {[any]: any} = t9

			if t2.selectedEntry == v515 then
				return
			end

			if t2.selectedEntry ~= nil then
				t2.selectedEntry.api:setSelected(false)
			end

			t2.selectedEntry = v515
			v515.api:setSelected(true)
			showPanel(v515.item)
		end

		local n1 = -math.huge

		local function fire()
			local v516 = os.clock()

			if v516 - n1 < 0.15 then
				return
			end

			n1 = v516
			v325()
		end

		v321.Activated:Connect(fire)
		v321.MouseButton1Click:Connect(fire)
		table.insert(t2.tiles, t9)
	end

	t1.TabHeader.Text = ("%s (%d)"):format(t3.NAV[t2.navIndex].Header, #t8)
	t8 = nil

	if v311 ~= nil then
		for _, v in ipairs(t2.tiles) do
			if v311 == v.item.Key then
				t8 = v

				break
			end
		end
	end

	if t8 == nil then
		t8 = t2.tiles[1]
	end

	if t8 == nil then
		t2.selected = nil
		t2.selectedEntry = nil

		if t2.panelTile ~= nil then
			t2.panelTile:Destroy()
			t2.panelTile = nil
		end

		t1.Panel.Visible = false

		return
	end

	t2.selectedEntry = t8
	t8.api:setSelected(true)
	showPanel(t8.item)
end
local function clearPlot()
	if t2.plot ~= nil then
		t2.plot:Destroy()
		t2.plot = nil
	end
end
local function dayLabel(p51)
	local dateText = os.date("!%b", p51)
	local numberValue: number? = tonumber(os.date("!%d", p51))
	local text: string = tostring(numberValue or 0)

	return dateText .. " " .. text
end
local function niceCeil(p52)
	if p52 <= 0 then
		return 10
	end

	local v335 = math.log10(p52)
	local n1 = 10 ^ math.floor(v335)
	local n2 = p52 / n1

	return (if n2 <= 1 then 1 else if n2 <= 2 then 2 else if n2 <= 2.5 then 2.5 else if n2 <= 5 then 5 else 10) * n1
end
local function subtitleFor(p53, p54)
	local numberValue = tonumber(p53.N) or 0

	if typeof(p53.RAP) ~= "number" then
		return ("Not enough independent sales for a value yet (%d so far)"):format(numberValue)
	end

	if p53.ValueBased then
		local marketRAP = p53.MarketRAP
		local v342 = ("Value %s  •  trade based"):format(boothThemeFmt(p53.RAP))

		if typeof(marketRAP) == "number" then
			local v343 = ("  •  recent sales average %s from %d counted sale%s in the last %d days"):format(boothThemeFmt(marketRAP), numberValue, if numberValue == 1 then "" else "s", p54)

			return v342 .. v343
		end

		local v344 = ("  •  %d counted sale%s in the last %d days"):format(numberValue, if numberValue == 1 then "" else "s", p54)

		return v342 .. v344
	end

	local v345 = ("Value %s  •  price based  •  %d counted sale%s in the last %d days"):format(boothThemeFmt(p53.RAP), numberValue, if numberValue == 1 then "" else "s", p54)

	if p53.Confidence == "Low" then
		v345 ..= "  (low confidence)"
	end

	return v345
end
local function buildRapTooltip()
	local clone3: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("HoverInfo"):Clone()

	clone3.Visible = false
	clone3.AutomaticSize = Enum.AutomaticSize.X

	local itemName: Instance = clone3:FindFirstChild("ItemName")
	local itemRarity: Instance = clone3:FindFirstChild("ItemRarity")
	local itemExist: Instance = clone3:FindFirstChild("ItemExist")

	itemRarity.Visible = false

	local rapRow: Frame = Instance.new("Frame")

	rapRow.Name = "RapRow"
	rapRow.BackgroundTransparency = 1
	rapRow.AnchorPoint = Vector2.new(0.5, 0)
	rapRow.Position = UDim2.new(0.5, 0, 0, itemRarity.Position.Y.Offset)
	rapRow.Size = UDim2.new(0, 0, 0, 18)
	rapRow.AutomaticSize = Enum.AutomaticSize.X
	rapRow.ZIndex = itemRarity.ZIndex

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 4)
	uiListLayout.Parent = rapRow

	local clone4: Instance = itemRarity:Clone()

	clone4.Name = "RapWord"
	clone4.Visible = true
	clone4.Text = "Value"
	clone4.TextScaled = false
	clone4.TextSize = 15
	clone4.TextXAlignment = Enum.TextXAlignment.Left
	clone4.AutomaticSize = Enum.AutomaticSize.X
	clone4.Size = UDim2.new(0, 0, 1, 0)
	clone4.Position = UDim2.new()
	clone4.LayoutOrder = 1
	clone4.Parent = rapRow

	local tokenIcon: ImageLabel = Instance.new("ImageLabel")

	tokenIcon.Name = "TokenIcon"
	tokenIcon.BackgroundTransparency = 1
	tokenIcon.Image = boothTheme.TokenIcon()
	tokenIcon.ScaleType = Enum.ScaleType.Fit
	tokenIcon.Size = UDim2.fromOffset(16, 16)
	tokenIcon.ZIndex = itemRarity.ZIndex
	tokenIcon.LayoutOrder = 2
	tokenIcon.Parent = rapRow

	local rapAmount = boothTheme.TokenAmount(rapRow, 0, UDim2.new(0, 0, 1, 0), UDim2.new())

	rapAmount.Name = "RapAmount"
	rapAmount.TextScaled = false
	rapAmount.TextWrapped = false
	rapAmount.TextSize = 16
	rapAmount.AutomaticSize = Enum.AutomaticSize.X
	rapAmount.ZIndex = itemRarity.ZIndex
	rapAmount.LayoutOrder = 3
	rapRow.Parent = clone3

	return {
		frame = clone3,
		update = function(p55)
			local numberValue = tonumber(p55.T) or 0
			local dateText = os.date("!%b", numberValue)
			local numberValue2: number? = tonumber(os.date("!%d", numberValue))
			local text: string = tostring(numberValue2 or 0)
			local dateText2 = os.date("!%Y", numberValue)

			itemName.Text = dateText .. " " .. text .. ", " .. dateText2
			rapAmount.Text = if typeof(p55.RAP) == "number" then boothThemeFmt(p55.RAP) else "--"

			local numberValue3 = tonumber(p55.N) or 0

			itemExist.Text = ("%d Sale%s"):format(numberValue3, if numberValue3 == 1 then "" else "s")
		end
	}
end
local function buildPlot(p56)
	if t2.plot ~= nil then
		t2.plot:Destroy()
		t2.plot = nil
	end

	local days = p56.Days
	local t10: {[any]: any} = {}
	local n1 = 0
	local n2: number = 0

	for _, v in ipairs(days) do
		local v362 = if typeof(v.RAP) == "number" then v.RAP else nil

		table.insert(t10, { y = v362, data = v })

		if v362 ~= nil then
			n2 += 1
			n1 = math.max(n1, v362)
		end
	end

	local t11: {[any]: any} = {}

	if #days > 0 and typeof(p56.Points) == "table" then
		local numberValue: number? = tonumber(days[1].T)

		for _, v in ipairs(p56.Points) do
			if typeof(v) == "table" and typeof(v.T) == "number" and typeof(v.P) == "number" then
				local n3 = 1 + (v.T - (numberValue or 0)) / 86400

				if n3 >= 1 and n3 <= #days + 1 then
					local v368 = math.min(n3, #days)

					table.insert(t11, { x = v368, y = v.P })
					n1 = math.max(n1, v.P)
				end
			end
		end
	end

	if n2 == 0 and #t11 == 0 or #t10 > 100 then
		t1.RapEmpty.Visible = true

		return
	end

	t1.RapEmpty.Visible = false

	local n4 = n1 * 1.15
	local n5

	if n4 <= 0 then
		n5 = 10
	else
		local v372 = math.log10(n4)
		local n6 = 10 ^ math.floor(v372)
		local n7 = n4 / n6

		n5 = (if n7 <= 1 then 1 else if n7 <= 2 then 2 else if n7 <= 2.5 then 2.5 else if n7 <= 5 then 5 else 10) * n6
	end

	n1 = {}
	local roundedUp = math.ceil(#t10 / 5)

	n4 = math.max(1, roundedUp)

	for i = 1, #t10, n4 do
		local t = days[i].T
		local dateText = os.date("!%b", t)
		local numberValue: number? = tonumber(os.date("!%d", t))
		local text: string = tostring(numberValue or 0)

		n1[i] = dateText .. " " .. text
	end

	if n1[#t10] == nil then
		local n8 = (#t10 - 1) // n4 * n4 + 1

		if #t10 - n8 < n4 / 2 then
			n1[n8] = nil
		end

		local v381 = days[#t10].T
		local dateText3 = os.date("!%b", v381)
		local numberValue4: number? = tonumber(os.date("!%d", v381))
		local text8: string = tostring(numberValue4 or 0)

		n1[#t10] = dateText3 .. " " .. text8
	end

	n4 = math.clamp(t1.PlotHost.AbsoluteSize.Y / 220, 0.6, 1.4)

	local linePlotBuild = linePlot.build
	local plotHost = t1.PlotHost
	local v387 = UDim2.fromScale(1, 1)
	local plot_line = t3.PLOT_LINE
	local v389 = buildRapTooltip()

	local t12: {[any]: any} = {
		name = "RapPlot",
		zIndex = 3,
		yMin = 0,
		parent = plotHost,
		size = v387,
		points = t10,
		yMax = n5,
		gridlines = { n5 * 0.25, n5 * 0.5, n5 * 0.75 },
		lineColor = plot_line,
		scale = n4,
		tooltip = v389,
		pointName = function(_, p58)
			return ("Day%d"):format(p58)
		end,
		window = t1.Root
	}

	local t13: {[any]: any} = { v = n5 * 0.5 }
	local n9 = n5 * 0.5

	t13.text = if n9 < 10000 then boothThemeFmt(n9) else if n9 < 1000000 then string.format("%.1fK", n9 / 1000) else string.format("%.1fM", n9 / 1000000)

	local t14: {[any]: any} = { v = n5, text = n9 }

	n9 = if n5 < 10000 then boothThemeFmt(n5) else if n5 < 1000000 then string.format("%.1fK", n5 / 1000) else string.format("%.1fM", n5 / 1000000)
	t12.yLabels = {
		{ v = 0, text = "0" },
		t13,
		t14
	}
	t12.xLabels = n1
	t12.labelTemplate = t1.GraphLabelTemplate
	t12.labelColor = t3.MUTED
	t12.markers = t11
	t12.markerColor = Color3.fromRGB(255, 214, 92)
	t2.plot = linePlotBuild(t12)
end
local function closeRap()
	if t2.mode == "rap" then
		t2.mode = "grid"

		local v394: {[any]: any} = t2

		v394.historyToken = v394.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true

		local v395 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

		if v395 then
			if not v395:IsA("TextLabel") then
				return
			end

			v395.Text = "View Value"

			local textLabel = v395:FindFirstChild("TextLabel")

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = "View Value"
			end

			return
		end

		return
	end
end

local color37 = Color3.fromRGB(0, 200, 255)

local function setFallbackRow(p59)
	local u398 = t2.fallbackRow

	if u398 == nil then
		if p59 == nil then
			return
		end

		local rapPane = t1.RapPane
		local rapEmpty = t1.RapEmpty

		u398 = Instance.new("Frame")
		u398.Name = "FallbackRow"
		u398.BackgroundTransparency = 1
		u398.AnchorPoint = Vector2.new(0.5, 0)
		u398.Position = UDim2.fromScale(0.5, 0.565)
		u398.Size = UDim2.fromScale(0.9, 0.065)
		u398.ZIndex = rapEmpty.ZIndex

		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.Parent = u398

		local function label(name, layoutOrder)
			local textLabel: TextLabel = Instance.new("TextLabel")

			textLabel.Name = name
			textLabel.BackgroundTransparency = 1
			textLabel.FontFace = rapEmpty.FontFace
			textLabel.TextColor3 = color37
			textLabel.TextScaled = false
			textLabel.TextWrapped = false
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.AutomaticSize = Enum.AutomaticSize.X
			textLabel.Size = UDim2.fromScale(0, 1)
			textLabel.ZIndex = rapEmpty.ZIndex
			textLabel.LayoutOrder = layoutOrder

			local uiStroke = rapEmpty:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				local clone5 = uiStroke:Clone()

				clone5.Parent = textLabel
			end

			textLabel.Parent = u398

			return textLabel
		end

		label("Word", 1).Text = "Using fallback value"

		local tokenIcon: ImageLabel = Instance.new("ImageLabel")

		tokenIcon.Name = "TokenIcon"
		tokenIcon.BackgroundTransparency = 1
		tokenIcon.Image = boothTheme.TokenIcon()
		tokenIcon.ScaleType = Enum.ScaleType.Fit
		tokenIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		tokenIcon.Size = UDim2.fromScale(0.95, 0.95)
		tokenIcon.ZIndex = rapEmpty.ZIndex
		tokenIcon.LayoutOrder = 2
		tokenIcon.Parent = u398
		label("Amount", 3)

		local function fit()
			local rounded = math.round(u398.AbsoluteSize.Y * 0.8)
			local textSize = math.max(10, rounded)

			for _, v in ipairs(u398:GetChildren()) do
				if v:IsA("TextLabel") then
					v.TextSize = textSize
				end
			end
		end

		u398:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
		u398.Parent = rapPane
		fit()
		t2.fallbackRow = u398
	end

	if p59 == nil then
		u398.Visible = false

		return
	end

	local amount = u398:FindFirstChild("Amount")

	amount.Text = boothThemeFmt(p59)
	u398.Visible = true
end
local function openRap(p62)
	t2.mode = "rap"
	t1.ItemContent.Visible = false
	t1.RapPane.Visible = true

	local traitTextBind = traitText.Bind
	local rapTitle = t1.RapTitle
	local text: string = tostring(p62.Name)

	traitTextBind(rapTitle, text .. " • Value History")
	t1.RapSubtitle.Text = "Loading..."
	t1.RapEmpty.Visible = false

	local fallbackRow = t2.fallbackRow

	if fallbackRow ~= nil then
		fallbackRow.Visible = false
	end

	if t2.plot ~= nil then
		t2.plot:Destroy()
		t2.plot = nil
	end

	local textLabel = t1.PPrimary:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = "Back"

		local textLabel4 = textLabel:FindFirstChild("TextLabel")

		if textLabel4 and textLabel4:IsA("TextLabel") then
			textLabel4.Text = "Back"
		end
	end

	local v413: {[any]: any} = t2

	v413.historyToken = v413.historyToken + 1

	local historyToken = t2.historyToken

	task.spawn(function()
		local v535 = nil

		if t2.spoof == nil then
			for i = 1, 2 do
				v535 = invoke("RAP", "History", p62.Kind, p62.ItemId, t3.HISTORY_DAYS)

				if typeof(v535) == "table" then
					break
				end

				if i == 1 then
					task.wait(t3.HISTORY_RETRY_SEC)
				end
			end
		else
			local v537 = p62
			local spoof = t2.spoof
			local v539

			if spoof == nil or v537.Kind == "Crate" then
				v539 = nil
			else
				local v540 = spoof.rap[v537.Key]

				if v540 == nil then
					v540 = spoofInfoFor(v537, spoof.rng)
					spoof.rap[v537.Key] = v540
				end

				v539 = v540
			end

			if v539 == nil then
				v535 = nil
			else
				local v541 = t2.spoof
				local v542 = v541.hist[v537.Key]

				if v542 == nil then
					v542 = spoofHistoryFor(v539, v541.days, v541.rng)
					v541.hist[v537.Key] = v542
				end

				v535 = v542
			end
		end

		if historyToken ~= t2.historyToken then
			return
		end

		if typeof(v535) == "table" and typeof(v535.Days) == "table" then
			if t2.spoof == nil and (typeof(v535.RAP) == "number" or u63(p62) == nil) then
				local rapClientPut = rapClient.Put
				local kind = p62.Kind
				local itemId = p62.ItemId
				local v546 = p62.Kind
				local v547 = p62.ItemId
				local rap = v535.RAP
				local estimate = v535.Estimate
				local projected = v535.Projected
				local valueBased = v535.ValueBased
				local n = v535.N
				local confidence = v535.Confidence
				local timestamp = os.time()

				rapClientPut(kind, itemId, {
					Kind = v546,
					ItemId = v547,
					RAP = rap,
					Estimate = estimate,
					Projected = projected,
					ValueBased = valueBased,
					N = n,
					Confidence = confidence,
					UpdatedAt = timestamp
				})

				local selected = t2.selected

				if selected ~= nil then
					t1.PRap.Text = rapText(selected)
				end

				local selectedEntry = t2.selectedEntry

				if selectedEntry ~= nil and selectedEntry.item == p62 and selectedEntry.cell.Parent ~= nil then
					attachRapTag(selectedEntry)
				end
			end

			t1.RapSubtitle.Text = subtitleFor(v535, #v535.Days)
			buildPlot(v535)

			local v557 = if t1.RapEmpty.Visible and typeof(v535.RAP) ~= "number" and typeof(v535.Estimate) == "number" and v535.Estimate > 0 then v535.Estimate else nil

			setFallbackRow(v557)

			return
		end

		t1.RapSubtitle.Text = "Value history isn't available right now."
		t1.RapEmpty.Visible = true
	end)
end
local function setUnavailable(p63)
	t2.unavailable = p63

	if p63 then
		t2.mode = "grid"

		local v416: {[any]: any} = t2

		v416.historyToken = v416.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		clearTiles()
		t2.selected = nil
		t2.selectedEntry = nil

		if t2.panelTile ~= nil then
			t2.panelTile:Destroy()
			t2.panelTile = nil
		end

		t1.Panel.Visible = false
		t1.ItemContent.Visible = false
		t1.RapPane.Visible = true
		t1.RapTitle.Text = "Item Index"
		t1.RapSubtitle.Text = ""
		t1.RapEmpty.Text = "The item index isn't available right now."
		t1.RapEmpty.Visible = true

		local fallbackRow = t2.fallbackRow

		if fallbackRow ~= nil then
			fallbackRow.Visible = false
		end

		t1.TabHeader.Text = "Unavailable"

		return
	end

	t1.RapEmpty.Text = "No sale history yet"

	if t2.mode == "grid" then
		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true
	end
end
local function refreshAll(p64)
	local v419 = invoke("ItemIndex", "Catalog")

	if typeof(v419) == "table" then
		t2.catalog = v419
	end

	if p64 ~= t2.openGen or not t1.Root.Visible then
		return
	end

	if not (#t2.catalog > 0) then
		t2.unavailable = true
		t2.mode = "grid"

		local v420: {[any]: any} = t2

		v420.historyToken = v420.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		clearTiles()
		t2.selected = nil
		t2.selectedEntry = nil

		if t2.panelTile ~= nil then
			t2.panelTile:Destroy()
			t2.panelTile = nil
		end

		t1.Panel.Visible = false
		t1.ItemContent.Visible = false
		t1.RapPane.Visible = true
		t1.RapTitle.Text = "Item Index"
		t1.RapSubtitle.Text = ""
		t1.RapEmpty.Text = "The item index isn't available right now."
		t1.RapEmpty.Visible = true

		local fallbackRow = t2.fallbackRow

		if fallbackRow ~= nil then
			fallbackRow.Visible = false
		end

		t1.TabHeader.Text = "Unavailable"

		return
	end

	local v422 = invoke("ItemIndex", "Favorites")

	if typeof(v422) == "table" then
		t2.favorites = v422
	end

	loadOwned()
	rapClient.Prime()
	v419 = os.clock() + t3.PRIME_WAIT_SEC

	while true do
		if not not rapClient.Available() or not (v419 > os.clock()) then
			break
		end

		task.wait(0.1)

		if p64 ~= t2.openGen or not t1.Root.Visible then
			return
		end
	end

	if p64 ~= t2.openGen or not t1.Root.Visible then
		return
	end

	t2.unavailable = false
	t1.RapEmpty.Text = "No sale history yet"

	if t2.mode == "grid" then
		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true
	end

	renderGrid()
end
local function closeWindow()
	t1.Root.Visible = false
end
local function openWindow()
	if LocalPlayer:GetAttribute("DailyGiftsOpen") then
		return
	end

	if t1.Root.Visible then
		return
	end

	local v423: {[any]: any} = t2

	v423.openGen = v423.openGen + 1

	local openGen = t2.openGen

	t2.search = ""
	t1.SearchBox.Text = ""
	t2.mode = "grid"
	t1.RapPane.Visible = false
	t1.ItemContent.Visible = true
	t1.TabHeader.Text = "Loading..."
	t2.selected = nil
	t2.selectedEntry = nil

	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	t1.Panel.Visible = false
	t1.Root.Visible = true
	activeWindowChanged:Fire(t3.WINDOW_KEY)
	windowBlur.show(t3.WINDOW_KEY)
	task.spawn(refreshAll, openGen)
end
local function setNavActive(p65, p66)
	local v427 = if p66 then t3.NAV_ACTIVE else t3.NAV_INACTIVE
	local imageLabel = p65:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.ImageColor3 = v427
	end

	local textLabel = p65:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.TextColor3 = v427
	end
end
local function selectNav(p67)
	t2.navIndex = p67

	for i, v in ipairs(t3.NAV) do
		local vName = t1.Navigator:FindFirstChild(v.Name)

		if vName then
			setNavActive(vName, i == p67)
		end
	end
end

for i, v in ipairs(t3.NAV) do
	local vName = t1.Navigator:FindFirstChild(v.Name)

	if vName and vName:IsA("GuiButton") then
		local function v115()
			if t2.unavailable then
				return
			end

			if t2.mode == "rap" then
				t2.mode = "grid"

				local v434: {[any]: any} = t2

				v434.historyToken = v434.historyToken + 1

				if t2.plot ~= nil then
					t2.plot:Destroy()
					t2.plot = nil
				end

				t1.RapPane.Visible = false
				t1.ItemContent.Visible = true

				local v435 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

				if v435 and v435:IsA("TextLabel") then
					v435.Text = "View Value"

					local textLabel = v435:FindFirstChild("TextLabel")

					if textLabel and textLabel:IsA("TextLabel") then
						textLabel.Text = "View Value"
					end
				end
			end

			selectNav(i)
			renderGrid()
		end

		local n1 = -math.huge

		local function fire()
			local v437 = os.clock()

			if v437 - n1 < 0.15 then
				return
			end

			n1 = v437
			v115()
		end

		vName.Activated:Connect(fire)
		vName.MouseButton1Click:Connect(fire)
	end
end

selectNav(1)

local v118 = t1.SortChip

local function v119()
	if t2.unavailable then
		return
	end

	t2.sortIndex = t2.sortIndex % #t3.SORTS + 1

	local text: string = "Sort: " .. t3.SORTS[t2.sortIndex]
	local textLabel = t1.SortChip:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel5 = textLabel:FindFirstChild("TextLabel")

		if textLabel5 and textLabel5:IsA("TextLabel") then
			textLabel5.Text = text
		end
	end

	if t2.mode == "rap" then
		t2.mode = "grid"

		local v441: {[any]: any} = t2

		v441.historyToken = v441.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true

		local v442 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

		if v442 and v442:IsA("TextLabel") then
			v442.Text = "View Value"

			local textLabel6 = v442:FindFirstChild("TextLabel")

			if textLabel6 and textLabel6:IsA("TextLabel") then
				textLabel6.Text = "View Value"
			end
		end
	end

	renderGrid()
end

local n2 = -math.huge

local function v121()
	local v444 = os.clock()

	if v444 - n2 < 0.15 then
		return
	end

	n2 = v444
	v119()
end

v118.Activated:Connect(v121)
v118.MouseButton1Click:Connect(v121)

local v122 = t1.FilterChip

local function v123()
	if t2.unavailable then
		return
	end

	t2.showIndex = t2.showIndex % #t3.SHOWS + 1

	local text: string = "Show: " .. t3.SHOWS[t2.showIndex]
	local textLabel = t1.FilterChip:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel7 = textLabel:FindFirstChild("TextLabel")

		if textLabel7 and textLabel7:IsA("TextLabel") then
			textLabel7.Text = text
		end
	end

	if t2.mode == "rap" then
		t2.mode = "grid"

		local v448: {[any]: any} = t2

		v448.historyToken = v448.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true

		local v449 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

		if v449 and v449:IsA("TextLabel") then
			v449.Text = "View Value"

			local textLabel8 = v449:FindFirstChild("TextLabel")

			if textLabel8 and textLabel8:IsA("TextLabel") then
				textLabel8.Text = "View Value"
			end
		end
	end

	renderGrid()
end

local n3 = -math.huge

v121 = function()
	local v451 = os.clock()

	if v451 - n3 < 0.15 then
		return
	end

	n3 = v451
	v123()
end
v122.Activated:Connect(v121)
v122.MouseButton1Click:Connect(v121)
t1.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	t2.search = t1.SearchBox.Text

	if t1.Root.Visible and not t2.unavailable then
		if t2.mode == "rap" then
			t2.mode = "grid"

			local v452: {[any]: any} = t2

			v452.historyToken = v452.historyToken + 1

			if t2.plot ~= nil then
				t2.plot:Destroy()
				t2.plot = nil
			end

			t1.RapPane.Visible = false
			t1.ItemContent.Visible = true

			local v453 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

			if v453 and v453:IsA("TextLabel") then
				v453.Text = "View Value"

				local textLabel = v453:FindFirstChild("TextLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					textLabel.Text = "View Value"
				end
			end
		end

		renderGrid()

		return
	end
end)

local pPrimary = t1.PPrimary

local function v126()
	local selected = t2.selected

	if selected == nil then
	elseif t2.mode == "rap" then
		if t2.mode ~= "rap" then
			return
		end

		t2.mode = "grid"

		local v456: {[any]: any} = t2

		v456.historyToken = v456.historyToken + 1

		if t2.plot ~= nil then
			t2.plot:Destroy()
			t2.plot = nil
		end

		t1.RapPane.Visible = false
		t1.ItemContent.Visible = true

		local v457 = t2.selected ~= nil and t1.PPrimary:FindFirstChild("TextLabel")

		if v457 then
			if not v457:IsA("TextLabel") then
				return
			end

			v457.Text = "View Value"

			local textLabel = v457:FindFirstChild("TextLabel")

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = "View Value"

				return
			end
		end
	elseif selected.Kind ~= "Crate" then
		openRap(selected)
	end
end

local n4 = -math.huge

v121 = function()
	local v459 = os.clock()

	if v459 - n4 < 0.15 then
		return
	end

	n4 = v459
	v126()
end
pPrimary.Activated:Connect(v121)
pPrimary.MouseButton1Click:Connect(v121)

local pFav = t1.PFav

local function v129()
	local selected = t2.selected

	if selected == nil or t2.unavailable then
		return
	end

	local u461: boolean = t2.favorites[selected.Key] ~= true

	t2.favorites[selected.Key] = if u461 then true else nil
	t1.PFavStar.TextColor3 = if u461 then t3.FAV_ON else t3.FAV_OFF

	local selectedEntry = t2.selectedEntry

	if selectedEntry ~= nil and selected == selectedEntry.item and selectedEntry.cell.Parent ~= nil then
		attachFavStar(selectedEntry)
	end

	task.spawn(function()
		local v558, v559 = invoke("ItemIndex", "SetFavorite", selected.Key, u461)

		if v558 == true then
			return
		end

		t2.favorites[selected.Key] = if u461 then nil else true

		if t2.selected == selected then
			t1.PFavStar.TextColor3 = if not u461 then t3.FAV_ON else t3.FAV_OFF
		end

		local selectedEntry = t2.selectedEntry

		if selectedEntry ~= nil and selectedEntry.item == selected and selectedEntry.cell.Parent ~= nil then
			attachFavStar(selectedEntry)
		end

		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			pcall(_GNotify, {
				notifType = "FailNotification",
				errorMessage = if v559 == "TooMany" then "You can't favourite any more items." else "Couldn't update your favourites."
			})
		end
	end)
end

local n5 = -math.huge

v121 = function()
	local v463 = os.clock()

	if v463 - n5 < 0.15 then
		return
	end

	n5 = v463
	v129()
end
pFav.Activated:Connect(v121)
pFav.MouseButton1Click:Connect(v121)
openItemIndex.Event:Connect(function(p68)
	if typeof(p68) == "table" and p68.Toggle == true and t1.Root.Visible then
		t1.Root.Visible = false

		return
	end

	openWindow()
end)

local itemIndexSpoof = bindables:FindFirstChild("ItemIndexSpoof")

if itemIndexSpoof == nil then
	local itemIndexSpoof2: BindableEvent = Instance.new("BindableEvent")

	itemIndexSpoof2.Name = "ItemIndexSpoof"
	itemIndexSpoof2.Parent = bindables
	itemIndexSpoof = itemIndexSpoof2
end

itemIndexSpoof.Event:Connect(function(p69)
	if not universe.IsDev() then
	elseif typeof(p69) == "table" then
		if p69.On == true then
			local v466 = tonumber(p69.Days) or t3.HISTORY_DAYS
			local floored = math.floor(v466)

			t2.spoof = {
				days = math.clamp(floored, 1, 30),
				rng = Random.new(),
				rap = {},
				hist = {}
			}
		else
			t2.spoof = nil
		end

		for _, v in ipairs(t2.tiles) do
			if v.tag ~= nil then
				v.tag:Destroy()
				v.tag = nil
			end
		end

		if t1.Root.Visible and not t2.unavailable then
			if t2.spoof == nil then
				rapClient.Prime()
			end

			for _, v in ipairs(t2.tiles) do
				attachRapTag(v)
			end

			local selected = t2.selected

			if selected ~= nil then
				t1.PRap.Text = rapText(selected)
			end

			if t2.mode == "rap" and t2.selected ~= nil then
				openRap(t2.selected)
			end

			return
		end

		return
	end
end)
rapClient.Changed:Connect(function()
	if not t1.Root.Visible or t2.unavailable then
	elseif t2.spoof == nil then
		for _, v in ipairs(t2.tiles) do
			attachRapTag(v)
		end

		local selected = t2.selected

		if selected == nil then
			return
		end

		t1.PRap.Text = rapText(selected)

		return
	end
end)

local v133 = t1.CloseButton
local n6 = -math.huge

ensureBindable = function()
	local v476 = os.clock()

	if v476 - n6 < 0.15 then
		return
	end

	n6 = v476
	closeWindow()
end
v133.Activated:Connect(ensureBindable)
v133.MouseButton1Click:Connect(ensureBindable)
t1.Root:GetPropertyChangedSignal("Visible"):Connect(function()
	if t1.Root.Visible then
		return
	end

	local v477: {[any]: any} = t2

	v477.openGen = v477.openGen + 1
	v477 = t2
	v477.historyToken = v477.historyToken + 1

	if t2.plot ~= nil then
		t2.plot:Destroy()
		t2.plot = nil
	end

	clearTiles()
	t2.selected = nil
	t2.selectedEntry = nil

	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	t1.Panel.Visible = false
	t2.mode = "grid"
	t1.RapPane.Visible = false
	t1.ItemContent.Visible = true
	windowBlur.hide(t3.WINDOW_KEY)
end)
activeWindowChanged.Event:Connect(function(p70)
	if p70 ~= t3.WINDOW_KEY and t1.Root.Visible then
		t1.Root.Visible = false
	end
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	if t1.Root.Visible then
		t1.Root.Visible = false
	end
end)

local inventoryDirty: Instance = remotes:FindFirstChild("InventoryDirty")

if inventoryDirty and inventoryDirty:IsA("RemoteEvent") then
	inventoryDirty.OnClientEvent:Connect(function(player)
		if typeof(player) == "table" and typeof(player.UserId) == "number" and player.UserId ~= LocalPlayer.UserId then
		elseif t1.Root.Visible and not t2.unavailable then
			local openGen = t2.openGen

			task.spawn(function()
				loadOwned()

				if openGen ~= t2.openGen or not t1.Root.Visible then
					return
				end

				for _, v in ipairs(t2.tiles) do
					attachOwnedBadge(v)
				end

				if t2.selected ~= nil then
					local v564 = existsText(t2.selected)

					t1.PExists.Text = v564
					t1.PExists.Visible = v564 ~= ""
				end
			end)

			return
		end
	end)
end

t1.Root.Visible = false
t1.RapPane.Visible = false
t1.Panel.Visible = false

local text: string = "Sort: " .. t3.SORTS[1]
local textLabel = t1.SortChip:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	textLabel.Text = text

	local textLabel9 = textLabel:FindFirstChild("TextLabel")

	if textLabel9 and textLabel9:IsA("TextLabel") then
		textLabel9.Text = text
	end
end

local s2: string = "Show: " .. t3.SHOWS[1]
local textLabel10 = t1.FilterChip:FindFirstChild("TextLabel")

if textLabel10 and textLabel10:IsA("TextLabel") then
	textLabel10.Text = s2

	local textLabel11 = textLabel10:FindFirstChild("TextLabel")

	if textLabel11 and textLabel11:IsA("TextLabel") then
		textLabel11.Text = s2
	end
end

hoverInfoModule.hide(t2.hover)
