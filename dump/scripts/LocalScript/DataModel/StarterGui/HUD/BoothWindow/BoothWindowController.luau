-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local boothClient = require(shared:WaitForChild("BoothClient"))
local rarity = require(shared:WaitForChild("Rarity"))
local traitText = require(shared:WaitForChild("TraitText"))
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local boothTheme = require(shared:WaitForChild("BoothTheme"))
local hoverInfoModule = require(shared:WaitForChild("HoverInfoModule"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")

local function ensureBindable(name)
	local foundChild = bindables:FindFirstChild(name)

	if foundChild == nil then
		foundChild = Instance.new("BindableEvent")
		foundChild.Name = name
		foundChild.Parent = bindables
	end

	return foundChild
end

local openBoothWindow = bindables:FindFirstChild("OpenBoothWindow")

if openBoothWindow == nil then
	openBoothWindow = Instance.new("BindableEvent")
	openBoothWindow.Name = "OpenBoothWindow"
	openBoothWindow.Parent = bindables
end

local openInventoryForTrade: Instance = bindables:WaitForChild("OpenInventoryForTrade")
local addItemToTrade: Instance = bindables:WaitForChild("AddItemToTrade")
local tradeSelectClosed: Instance = bindables:WaitForChild("TradeSelectClosed")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")

LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")

local scriptParent: Instance = script.Parent
local header: Instance = scriptParent:WaitForChild("Header")
local options: Instance = scriptParent:WaitForChild("Options")
local items: Instance = scriptParent:WaitForChild("ItemContent"):WaitForChild("Items")
local actionBar: Instance = scriptParent:WaitForChild("ActionBar")
local detailPanel: Instance = scriptParent:WaitForChild("DetailPanel")
local priceBar: Instance = detailPanel:WaitForChild("PriceBar")
local foundChild = nil
local searchBar: Instance = options:FindFirstChild("SearchBar")

if searchBar ~= nil then
	foundChild = searchBar:FindFirstChildWhichIsA("TextBox", true)
end

local textLabel: Instance = header:WaitForChild("TextLabel")
local tabHeader: Instance = options:FindFirstChild("TabHeader")
local closeButton: Instance = scriptParent:WaitForChild("CloseButton")
local unclaimButton: Instance = actionBar:WaitForChild("UnclaimButton")
local itemName: Instance = detailPanel:WaitForChild("ItemName")
local detailPanelRarity: Instance = detailPanel:WaitForChild("Rarity")
local itemTemplate: Instance = detailPanel:WaitForChild("ItemTemplate")
local exists: Instance = detailPanel:WaitForChild("Exists")
local rapLabel: Instance = detailPanel:FindFirstChild("RapLabel")
local description: Instance = detailPanel:WaitForChild("Description")
local priceBox: Instance = priceBar:WaitForChild("PriceBox")
local receiveLabel: Instance = detailPanel:WaitForChild("ReceiveLabel")
local equipButton: Instance = detailPanel:WaitForChild("EquipButton")
local deleteButton: Instance = detailPanel:WaitForChild("DeleteButton")
local t1: {[any]: any} = {
	Root = scriptParent,
	HeaderText = textLabel,
	TabHeader = tabHeader,
	SearchBox = foundChild,
	CloseButton = closeButton,
	Items = items,
	ActionBar = actionBar,
	UnclaimButton = unclaimButton,
	Panel = detailPanel,
	PName = itemName,
	PRarity = detailPanelRarity,
	PTile = itemTemplate,
	PExists = exists,
	PRap = rapLabel,
	PDesc = description,
	PPriceBar = priceBar,
	PPriceBox = priceBox,
	PReceive = receiveLabel,
	PPrimary = equipButton,
	PRemove = deleteButton
}
local v45 = hoverInfoModule.create(t1.Root)
local boothThemeFmt = boothTheme.Fmt
local boothThemePriceTag = boothTheme.PriceTag

local function notifyFail(p2)
	if not pcall(function()
		_G.Notify({ notifType = "FailNotification", errorMessage = p2 })
	end) then
		warn("[Booth] " .. p2)
	end
end
local function notifyOk(p3, p4)
	pcall(function()
		_G.Notify({ notifType = "SuccessNotification", topText = p3, bottomText = p4 })
	end)
end

local t2: {[any]: any} = {
	mode = "Owner",
	viewBoothId = nil,
	renderedSig = nil,
	searchText = "",
	pendingPick = false,
	panel = nil,
	panelTile = nil,
	buyBusy = false,
	confirmModal = nil,
	headerOwner = nil,
	headerHovered = false,
	tiles = {},
	hovers = {}
}

local function confirm(p5, p6, p7)
	if t2.confirmModal == nil then
		t2.confirmModal = bindables:FindFirstChild("ConfirmModal")
	end

	local confirmModal = t2.confirmModal

	if confirmModal == nil then
		return true
	end

	local ok, result = pcall(confirmModal.Invoke, confirmModal, { DeclineText = "Cancel", Header = p5, Body = p6, AcceptText = p7 })

	return ok and result == true
end
local function myTokens()
	return tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0
end
local function onClick(p8, p9)
	local n1 = -math.huge

	local function fire()
		local v250 = os.clock()

		if v250 - n1 < 0.15 then
			return
		end

		n1 = v250
		p9()
	end

	p8.Activated:Connect(fire)
	p8.MouseButton1Click:Connect(fire)
end
local function retextButton(p10, text)
	for _, v in ipairs(p10:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = text
		end
	end
end
local function setPanelTile(p12, p13, p14, p15, p16)
	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	local pTile = t1.PTile
	local uiFrameworkCreateItemCell = uiFramework.createItemCell
	local typeName: string = typeof(p13)
	local v115, v116 = uiFrameworkCreateItemCell(p12, {
		name = "PanelTile",
		visible = true,
		active = false,
		interactable = false,
		selectable = false,
		icon = if typeName == "string" then p13 else nil,
		parent = t1.Panel
	})

	v115.AnchorPoint = pTile.AnchorPoint
	v115.Position = pTile.Position
	v115.Size = pTile.Size
	v115.ZIndex = pTile.ZIndex + 1

	if p14 ~= nil and v116.setFinisher ~= nil then
		pcall(v116.setFinisher, v116, p14, p15)
	end

	if p16 ~= nil and p16 > 1 and v116.setStackCount ~= nil then
		pcall(v116.setStackCount, v116, p16)
	end

	t2.panelTile = v115
end
local function clearPanel()
	t2.panel = nil

	if t2.panelTile ~= nil then
		t2.panelTile:Destroy()
		t2.panelTile = nil
	end

	if t1.PPriceBox:IsFocused() then
		t1.PPriceBox:ReleaseFocus()
	end

	t1.PName.Text = ""
	t1.PRarity.Text = ""
	t1.PExists.Text = ""

	if t1.PRap ~= nil then
		t1.PRap.Text = ""
	end

	t1.PDesc.Text = ""
	t1.PReceive.Text = ""
	t1.PPriceBar.Visible = false
	t1.PPrimary.Visible = false
	t1.PRemove.Visible = false
end
local function fillPanelMeta(p17)
	local text: string = tostring(p17.Rarity or "Common")

	t1.PRarity.Text = text
	pcall(rarity.ApplyTextGradient, t1.PRarity, text)
	t1.PExists.Text = if typeof(p17.GlobalCopies) == "number" then boothThemeFmt(p17.GlobalCopies) .. " Exists" else ""

	if t1.PRap ~= nil then
		if p17.RAP == nil and p17.RapConfidence == nil then
			t1.PRap.Text = ""
		else
			local pRap = t1.PRap
			local s1

			if typeof(p17.RAP) == "number" then
				s1 = "RAP: <font color=\"" .. "#00C8FF" .. "\">" .. boothThemeFmt(p17.RAP) .. "</font>"
			elseif typeof(p17.RapEstimate) == "number" then
				s1 = "RAP: <font color=\"" .. "#00C8FF" .. "\">~" .. boothThemeFmt(p17.RapEstimate) .. "</font> (est.)"
			else
				s1 = "RAP: <font color=\"#00C8FF\">--</font>"
			end

			pRap.Text = s1
		end
	end

	t1.PDesc.Text = if typeof(p17.Description) == "string" then p17.Description else ""
end
local function updateReceive()
	local panel = t2.panel

	if panel == nil or panel.inShop or panel.mode ~= "pick" and panel.mode ~= "listing" then
		return
	end

	local numberValue: number? = tonumber(t1.PPriceBox.Text)

	if numberValue == nil or numberValue ~= numberValue or numberValue ~= math.floor(numberValue) or not (numberValue >= 1) then
		t1.PReceive.Text = "You receive: --"

		if panel.mode == "listing" then
			t1.PPrimary.Visible = false
		end

		return
	end

	local v123 = boothClient.PreviewSplit(numberValue)

	t1.PReceive.Text = ("You receive: %s"):format(boothThemeFmt(v123))

	if panel.mode == "listing" then
		t1.PPrimary.Visible = numberValue ~= panel.listing.Price and not panel.listing.InFlight
	end
end
local function showPick(p18)
	clearPanel()
	t2.panel = { mode = "pick", pick = p18 }

	local u125: boolean = p18.Kind == "Crate"
	local text: string = tostring(p18.Name or p18.ItemId or "Item")

	if u125 and (p18.Amount or 1) > 1 then
		local v127 = (" x%d"):format(p18.Amount)

		text ..= v127
	end

	traitText.Bind(t1.PName, text)
	fillPanelMeta({ Rarity = p18.Rarity })

	local text2: string = tostring(p18.Rarity or "Common")

	setPanelTile(text2, p18.Icon, p18.FinisherIcon, p18.FinisherRarity, if u125 then p18.Amount else nil)
	t1.PPriceBar.Visible = true
	t1.PPriceBox.TextEditable = true
	t1.PPriceBox.Text = ""
	t1.PReceive.Text = "You receive: --"
	retextButton(t1.PPrimary, "List")
	t1.PPrimary.Visible = true
	t1.PRemove.Visible = false
	t1.PPrimary.Position = UDim2.new(0.5, 0, t1.PPrimary.Position.Y.Scale, 0)
	task.defer(function()
		t1.PPriceBox:CaptureFocus()
	end)
	task.spawn(function()
		local v251, v252 = boothClient.Invoke("GetMeta", if u125 then { Kind = "Crate", CrateId = p18.ItemId } else { Kind = p18.Kind, InstanceId = p18.InstanceId })
		local panel = t2.panel

		if v251 and typeof(v252) == "table" and panel ~= nil and panel.pick == p18 then
			fillPanelMeta(v252)
			panel.relistIn = if typeof(v252.RelistIn) == "number" then v252.RelistIn else 0

			if typeof(v252.InShop) == "string" then
				panel.inShop = true

				if t1.PPriceBox:IsFocused() then
					t1.PPriceBox:ReleaseFocus()
				end

				t1.PPriceBox.Text = ""
				t1.PPriceBar.Visible = false
				t1.PReceive.Text = v252.InShop
				t1.PPrimary.Visible = false

				return
			end

			if panel.relistIn > 0 then
				local floored = math.floor(panel.relistIn / 60)

				t1.PReceive.Text = if floored >= 1 then ("Listable in %d min"):format(floored) else "Listable in under a minute"
				t1.PPrimary.Visible = false

				return
			end

			updateReceive()

			return
		end
	end)
end
local function showListing(p19, p20)
	clearPanel()
	t2.panel = {
		mode = if p20 then "listing" else "buy",
		listing = p19
	}

	local t3 = p19.Meta or {}
	local text: string = tostring(t3.Name or p19.ItemId)

	if p19.Kind == "Crate" and p19.Count > 1 then
		local v133 = (" x%d"):format(p19.Count)

		text ..= v133
	end

	traitText.Bind(t1.PName, text)
	fillPanelMeta(t3)

	local text3: string = tostring(t3.Rarity or "Common")

	setPanelTile(text3, t3.Icon, t3.FinisherIcon, t3.FinisherRarity, if p19.Kind == "Crate" then p19.Count else nil)
	t1.PPriceBar.Visible = true

	local pPriceBox = t1.PPriceBox
	local floored = math.floor(p19.Price)

	pPriceBox.Text = tostring(floored)

	local v137 = boothClient.PreviewSplit(p19.Price)

	if p20 then
		t1.PPriceBox.TextEditable = not p19.InFlight
		t1.PReceive.Text = ("You receive: %s"):format(boothThemeFmt(v137))
		retextButton(t1.PPrimary, "Update")
		t1.PPrimary.Visible = false
		t1.PRemove.Visible = not p19.InFlight
		t1.PPrimary.Position = UDim2.new(0.381, 0, t1.PPrimary.Position.Y.Scale, 0)

		return
	end

	t1.PPriceBox.TextEditable = false
	t1.PReceive.Text = if p19.InFlight then "Someone is buying this..." else ""
	retextButton(t1.PPrimary, "Buy")
	t1.PPrimary.Visible = not p19.InFlight
	t1.PRemove.Visible = false
	t1.PPrimary.Position = UDim2.new(0.5, 0, t1.PPrimary.Position.Y.Scale, 0)
end
local function readTypedPrice()
	local numberValue: number? = tonumber(t1.PPriceBox.Text)
	local v139 = boothClient.GetConfig()

	if numberValue == nil or numberValue ~= numberValue or numberValue ~= math.floor(numberValue) or numberValue < 1 then
		local s1: string = "Enter a whole-number price."

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = s1 })
		end) then
			warn("[Booth] Enter a whole-number price.")
		end

		return nil
	end

	if v139 == nil then
		return numberValue
	end

	if typeof(v139.MinPrice) == "number" and numberValue < v139.MinPrice then
		local v141 = ("Minimum price is %s."):format(boothThemeFmt(v139.MinPrice))

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = v141 })
		end) then
			warn("[Booth] " .. v141)
		end

		return nil
	end

	if typeof(v139.MaxPrice) == "number" and numberValue > v139.MaxPrice then
		local v142 = ("Maximum price is %s."):format(boothThemeFmt(v139.MaxPrice))

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = v142 })
		end) then
			warn("[Booth] " .. v142)
		end

		return nil
	end

	return numberValue
end
local function onPrimary()
	local panel = t2.panel

	if panel == nil then
		return
	end

	if panel.mode == "pick" then
		local panelPick = panel.pick
		local v145 = readTypedPrice()

		if v145 == nil then
			return
		end

		local v146 = ("List %s for %s Trade Tokens?"):format(tostring(panelPick.Name or panelPick.ItemId or "this item"), boothThemeFmt(v145))

		if not confirm("List Item", v146, "List") then
			return
		end

		local v147, v148 = boothClient.Invoke("List", if panelPick.Kind == "Crate" then {
			Kind = "Crate",
			CrateId = panelPick.ItemId,
			Count = panelPick.Amount or 1,
			Price = v145
		} else {
			Kind = panelPick.Kind,
			InstanceId = panelPick.InstanceId,
			Price = v145
		})

		if not v147 then
			local text: string = tostring(v148 or "Couldn't list that.")

			if not pcall(function()
				_G.Notify({ notifType = "FailNotification", errorMessage = text })
			end) then
				warn("[Booth] " .. text)
			end

			return
		end

		sound:Play("UI.TradeTokensAdded", workspace)

		local v150 = ("Up for %s Trade Tokens."):format(boothThemeFmt(v145))
		local s1: string = "Listed!"

		pcall(function()
			_G.Notify({ notifType = "SuccessNotification", topText = s1, bottomText = v150 })
		end)
		clearPanel()

		return
	end

	if panel.mode == "listing" then
		local panelListing = panel.listing
		local v153 = readTypedPrice()

		if v153 == nil then
			return
		end

		if v153 == panelListing.Price then
			return
		end

		local v154, v155 = boothClient.Invoke("Reprice", panelListing.Lid, v153)

		if not v154 then
			local text: string = tostring(v155 or "Couldn't update the price.")

			if not pcall(function()
				_G.Notify({ notifType = "FailNotification", errorMessage = text })
			end) then
				warn("[Booth] " .. text)
			end

			return
		end

		sound:Play("UI.Click", workspace)

		local v157 = ("Now listed for %s Trade Tokens."):format(boothThemeFmt(v153))
		local s2: string = "Price updated"

		pcall(function()
			_G.Notify({ notifType = "SuccessNotification", topText = s2, bottomText = v157 })
		end)

		return
	end

	if panel.mode ~= "buy" then
		return
	end

	if t2.buyBusy then
		return
	end

	local v159 = panel.listing
	local price = v159.Price
	local numberValue: number? = tonumber(LocalPlayer:GetAttribute("TradeTokens"))

	if price > (numberValue or 0) then
		local v162 = ("You need %s Trade Tokens for that."):format(boothThemeFmt(price))

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = v162 })
		end) then
			warn("[Booth] " .. v162)
		end

		return
	end

	local text: string = tostring((v159.Meta or {}).Name or v159.ItemId)

	if v159.Kind == "Crate" and v159.Count > 1 then
		local v164 = (" x%d"):format(v159.Count)

		text ..= v164
	end

	local v165 = ("Buy %s for %s Trade Tokens?"):format(text, boothThemeFmt(price))

	if not confirm("Buy Item", v165, "Buy") then
		return
	end

	t2.buyBusy = true

	local v166, v167 = boothClient.Invoke("Buy", t2.viewBoothId, v159.Lid, price)

	t2.buyBusy = false

	if v166 then
		sound:Play("UI.TradeCompleted", workspace)
		clearPanel()

		return
	end

	local text4: string = tostring(v167 or "Purchase failed.")

	if not pcall(function()
		_G.Notify({ notifType = "FailNotification", errorMessage = text4 })
	end) then
		warn("[Booth] " .. text4)
	end
end
local function removeListing(p21)
	local v170 = ("Take %s off your booth? It goes back to your inventory, unlocked."):format((tostring((p21.Meta or {}).Name or p21.ItemId)))

	if not confirm("Remove Listing", v170, "Remove") then
		return
	end

	local v171, v172 = boothClient.Invoke("Unlist", p21.Lid)

	if v171 then
		sound:Play("UI.Click", workspace)

		local s1: string = "Listing removed"
		local s2: string = "It's back in your inventory, unlocked."

		pcall(function()
			_G.Notify({ notifType = "SuccessNotification", topText = s1, bottomText = s2 })
		end)

		local panel = t2.panel

		if panel ~= nil and panel.listing ~= nil and panel.listing.Lid == p21.Lid then
			clearPanel()

			return
		end
	else
		local text: string = tostring(v172 or "Couldn't remove that listing.")

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = text })
		end) then
			warn("[Booth] " .. text)
		end
	end
end
local function onRemove()
	local panel = t2.panel

	if panel == nil or panel.mode ~= "listing" then
		return
	end

	removeListing(panel.listing)
end
local function clearTiles()
	hoverInfoModule.hide(v45)

	for _, v in ipairs(t2.hovers) do
		v.disconnect()
	end

	table.clear(t2.hovers)

	for _, v in ipairs(t2.tiles) do
		v:Destroy()
	end

	table.clear(t2.tiles)
end
local function attachOverlay(parent, text)
	local pendingOverlay: Frame = Instance.new("Frame")

	pendingOverlay.Name = "PendingOverlay"
	pendingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	pendingOverlay.BackgroundTransparency = 0.45
	pendingOverlay.Size = UDim2.new(1, 0, 1, 0)
	pendingOverlay.BorderSizePixel = 0
	pendingOverlay.ZIndex = 8

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
	textLabel.Rotation = -12
	textLabel.Text = text
	textLabel.ZIndex = 9
	textLabel.Parent = pendingOverlay
	pendingOverlay.Parent = parent
end
local function matchesSearch(p24)
	if t2.searchText == "" then
		return true
	end

	local stringLower = string.lower
	local text: string = tostring((p24.Meta or {}).Name or p24.ItemId or "")
	local v189 = stringLower(text)
	local stringFind = string.find
	local lowerText = string.lower(t2.searchText)

	return stringFind(v189, lowerText, 1, true) ~= nil
end
local function boothSig(p25)
	return boothClient.Signature(p25)
end
local function renderBooth()
	local canvasPosition = t1.Items.CanvasPosition

	clearTiles()

	local v194 = t2.viewBoothId and boothClient.FindBooth(t2.viewBoothId) or nil

	if v194 == nil then
		t2.renderedSig = nil

		return
	end

	t2.renderedSig = boothClient.Signature(v194)

	if canvasPosition.Y > 0 then
		task.defer(function()
			if t1.Root.Visible then
				t1.Items.CanvasPosition = canvasPosition
			end
		end)
	end

	local u195: boolean = v194.OwnerUserId == LocalPlayer.UserId

	for _, v in ipairs(v194.Listings) do
		if matchesSearch(v) then
			local t4 = v.Meta or {}
			local text: string = tostring(t4.Rarity or "Common")
			local parent, v201 = uiFramework.createItemCell(text, {
				visible = true,
				active = true,
				interactable = true,
				selectable = false,
				icon = t4.Icon,
				name = tostring(t4.Name or v.ItemId),
				parent = t1.Items
			})

			parent.LayoutOrder = -math.floor(v.Price or 0)

			if t4.Finisher ~= nil and v201.setFinisher ~= nil then
				pcall(v201.setFinisher, v201, t4.FinisherIcon, t4.FinisherRarity)
			end

			boothThemePriceTag(parent, v.Price)

			if (v.Count or 1) > 1 and v201.setStackCount ~= nil then
				boothTheme.StackCount(v201, parent, v.Count)
			end

			if v.InFlight then
				attachOverlay(parent, "SELLING...")
			end

			local v202 = hoverInfoModule.bind(v45, parent, function()
				return {
					Name = tostring(t4.Name or v.ItemId),
					Rarity = text,
					GlobalCopies = if typeof(t4.GlobalCopies) == "number" then t4.GlobalCopies else nil,
					Serial = if typeof(v.Serial) == "number" then v.Serial else nil,
					MaxSupply = if typeof(t4.MaxSupply) == "number" then t4.MaxSupply else nil,
					SourceButton = parent,
					FinisherName = if typeof(t4.FinisherName) == "string" then t4.FinisherName else nil,
					FinisherIcon = if typeof(t4.FinisherIcon) == "string" then t4.FinisherIcon else nil,
					FinisherRarity = if typeof(t4.FinisherRarity) == "string" then t4.FinisherRarity else nil,
					Kind = v.Kind,
					ItemId = v.ItemId,
					RAP = if typeof(t4.RAP) == "number" then t4.RAP else nil,
					RapEstimate = if typeof(t4.RapEstimate) == "number" then t4.RapEstimate else nil,
					RapConfidence = if typeof(t4.RapConfidence) == "string" then t4.RapConfidence else nil,
					RapProjected = t4.RapProjected == true,
					Note = boothTheme.StackNote(v.Count, v.Price),
					NoteIcon = if (v.Count or 1) > 1 then boothTheme.TokenIcon() else nil
				}
			end)

			table.insert(t2.hovers, v202)

			local function v203()
				if v202.tapConsumed() then
					return
				end

				showListing(v, u195)
			end

			local n1 = -math.huge

			local function fire()
				local v255 = os.clock()

				if v255 - n1 < 0.15 then
					return
				end

				n1 = v255
				v203()
			end

			parent.Activated:Connect(fire)
			parent.MouseButton1Click:Connect(fire)

			if u195 and not v.InFlight then
				local clone = t1.CloseButton:Clone()

				clone.Name = "UnlistBadge"
				clone.AnchorPoint = Vector2.new(1, 0)
				clone.Position = UDim2.new(1.02, 0, -0.02, 0)
				clone.Size = UDim2.new(0.32, 0, 0.32, 0)
				clone.ZIndex = 10
				clone.Visible = true
				clone.Parent = parent

				local function v207()
					if v202.tapConsumed() then
						return
					end

					removeListing(v)
				end

				local n2 = -math.huge

				local function v209()
					local v256 = os.clock()

					if v256 - n2 < 0.15 then
						return
					end

					n2 = v256
					v207()
				end

				clone.Activated:Connect(v209)
				clone.MouseButton1Click:Connect(v209)
			end

			table.insert(t2.tiles, parent)
		end
	end

	if u195 and (boothClient.GetConfig() and tonumber(boothClient.GetConfig().MaxListings) or 8) > #v194.Listings then
		local v210 = boothTheme.CreateTile(t1.Items)

		v210.LayoutOrder = 1073741824

		local function v211()
			t2.pendingPick = true
			t1.Root.Visible = false
			openInventoryForTrade:Fire({ Mode = "Booth", MaxItems = 1000 })
		end

		local n3 = -math.huge

		local function v213()
			local v257 = os.clock()

			if v257 - n3 < 0.15 then
				return
			end

			n3 = v257
			v211()
		end

		v210.Activated:Connect(v213)
		v210.MouseButton1Click:Connect(v213)
		table.insert(t2.tiles, v210)
	end
end
local function renderHeader()
	local headerOwner = t2.headerOwner

	if headerOwner == nil then
		t1.HeaderText.Text = "My Booth"

		return
	end

	t1.HeaderText.Text = ("%s's Booth"):format(if t2.headerHovered and userInputService.MouseEnabled and headerOwner.Username ~= nil then "@" .. headerOwner.Username else headerOwner.Display)
end
local function renderChrome()
	local v215 = t2.viewBoothId and boothClient.FindBooth(t2.viewBoothId) or nil

	if v215 == nil then
		return
	end

	local u216: boolean = v215.OwnerUserId == LocalPlayer.UserId

	t2.mode = if u216 then "Owner" else "Buyer"

	local t5

	if u216 then
		t5 = nil
	else
		t5 = {}
		t5.Display = tostring(v215.OwnerDisplayName or v215.OwnerName or "Someone")
		t5.Username = if typeof(v215.OwnerName) == "string" and v215.OwnerName ~= "" then v215.OwnerName else nil
	end

	t2.headerOwner = t5

	local headerOwner = t2.headerOwner

	if headerOwner == nil then
		t1.HeaderText.Text = "My Booth"
	else
		t1.HeaderText.Text = ("%s's Booth"):format(if t2.headerHovered and userInputService.MouseEnabled and headerOwner.Username ~= nil then "@" .. headerOwner.Username else headerOwner.Display)
	end

	if t1.TabHeader ~= nil then
		t1.TabHeader.Text = ("Booth %s   |   Amount sold: %s"):format(tostring(v215.Id), boothThemeFmt(v215.TokensSold or 0))
	end

	t1.ActionBar.Visible = u216
end
local function refreshAll()
	renderChrome()
	renderBooth()
end
local function closeWindow()
	t1.Root.Visible = false
end
local function openWindow(p26)
	if boothClient.FindBooth(p26) == nil then
		local s1: string = "That booth isn't available."

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = s1 })
		end) then
			warn("[Booth] That booth isn't available.")
		end

		return
	end

	t2.viewBoothId = p26
	t2.searchText = ""

	if t1.SearchBox ~= nil then
		t1.SearchBox.Text = ""
	end

	boothClient.RefreshConfig()
	renderChrome()
	renderBooth()
	t1.Root.Visible = true
	activeWindowChanged:Fire("Booth")
	windowBlur.show("Booth")
end

openBoothWindow.Event:Connect(function(p27)
	if typeof(p27) == "table" and typeof(p27.BoothId) == "string" then
		openWindow(p27.BoothId)

		if p27.Create == true and t1.Root.Visible and t2.mode == "Owner" then
			t2.pendingPick = true
			t1.Root.Visible = false
			openInventoryForTrade:Fire({ Mode = "Booth", MaxItems = 1000 })
		elseif typeof(p27.Lid) == "string" and t1.Root.Visible then
			local v222 = boothClient.FindBooth(p27.BoothId)

			if v222 == nil then
				return
			end

			local u223: boolean = v222.OwnerUserId == LocalPlayer.UserId

			for _, v in ipairs(v222.Listings or {}) do
				if v.Lid == p27.Lid then
					showListing(v, u223)

					if not not u223 or not not v.InFlight then
						break
					end

					task.spawn(onPrimary)

					return
				end
			end

			return
		end

		return
	end
end)

local v75 = t1.CloseButton
local n1 = -math.huge

local function fire()
	local v226 = os.clock()

	if v226 - n1 < 0.15 then
		return
	end

	n1 = v226
	closeWindow()
end

v75.Activated:Connect(fire)
v75.MouseButton1Click:Connect(fire)
t1.HeaderText.MouseEnter:Connect(function()
	t2.headerHovered = true

	local headerOwner = t2.headerOwner

	if headerOwner == nil then
		t1.HeaderText.Text = "My Booth"

		return
	end

	t1.HeaderText.Text = ("%s's Booth"):format(if t2.headerHovered and userInputService.MouseEnabled and headerOwner.Username ~= nil then "@" .. headerOwner.Username else headerOwner.Display)
end)
t1.HeaderText.MouseLeave:Connect(function()
	t2.headerHovered = false

	local headerOwner = t2.headerOwner

	if headerOwner == nil then
		t1.HeaderText.Text = "My Booth"

		return
	end

	t1.HeaderText.Text = ("%s's Booth"):format(if t2.headerHovered and userInputService.MouseEnabled and headerOwner.Username ~= nil then "@" .. headerOwner.Username else headerOwner.Display)
end)
t1.Root:GetPropertyChangedSignal("Visible"):Connect(function()
	if not t1.Root.Visible then
		clearTiles()
		clearPanel()
		windowBlur.hide("Booth")
		t2.headerHovered = false
	end
end)
activeWindowChanged.Event:Connect(function(p28)
	if p28 ~= "Booth" and t1.Root.Visible then
		t1.Root.Visible = false
	end
end)
boothClient.Changed:Connect(function()
	if not t1.Root.Visible then
		return
	end

	local v230 = t2.viewBoothId and boothClient.FindBooth(t2.viewBoothId) or nil

	if v230 == nil or v230.OwnerUserId == nil then
		local s1: string = "That booth closed."

		if not pcall(function()
			_G.Notify({ notifType = "FailNotification", errorMessage = s1 })
		end) then
			warn("[Booth] That booth closed.")
		end

		t1.Root.Visible = false

		return
	end

	if boothClient.Signature(v230) ~= t2.renderedSig then
		renderChrome()
		renderBooth()
	else
		renderChrome()
	end

	local panel = t2.panel

	if panel == nil or panel.listing == nil then
		return
	end

	local v233 = nil

	for _, v in ipairs(v230.Listings) do
		if v.Lid == panel.listing.Lid then
			v233 = v
		end
	end

	if v233 == nil then
		clearPanel()

		return
	end

	if v233.Price == panel.listing.Price and (v233.InFlight or false) == (panel.listing.InFlight or false) then
		panel.listing = v233

		return
	end

	showListing(v233, t2.mode == "Owner")
end)

if t1.SearchBox ~= nil then
	t1.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		t2.searchText = t1.SearchBox.Text

		if t1.Root.Visible then
			renderBooth()
		end
	end)
end

addItemToTrade.Event:Connect(function(p29)
	if not t2.pendingPick then
	elseif typeof(p29) == "table" and p29.Purpose == "Booth" then
		t2.pendingPick = false

		if t2.viewBoothId ~= nil then
			openWindow(t2.viewBoothId)
		end

		if t1.Root.Visible then
			showPick(p29)
		end

		return
	end
end)
tradeSelectClosed.Event:Connect(function()
	if t2.pendingPick then
		t2.pendingPick = false

		if t2.viewBoothId ~= nil then
			openBoothWindow:Fire({ BoothId = t2.viewBoothId })
		end
	end
end)
t1.PPriceBox:GetPropertyChangedSignal("Text"):Connect(function()
	local pPriceBox = t1.PPriceBox
	local replacedText = pPriceBox.Text:gsub("%D", "")
	local v239 = boothClient.GetConfig()
	local v240 = if v239 == nil or typeof(v239.MaxPrice) ~= "number" then 100000000 else v239.MaxPrice

	v239 = replacedText

	local numberValue: number? = tonumber(replacedText)

	if numberValue ~= nil and v240 < numberValue then
		v239 = tostring(v240)
	end

	if v239 ~= pPriceBox.Text then
		pPriceBox.Text = v239
		pPriceBox.CursorPosition = #v239 + 1
	end
end)
t1.PPriceBox:GetPropertyChangedSignal("Text"):Connect(updateReceive)

local pPrimary = t1.PPrimary
local n2 = -math.huge

local function v80()
	local v242 = os.clock()

	if v242 - n2 < 0.15 then
		return
	end

	n2 = v242
	onPrimary()
end

pPrimary.Activated:Connect(v80)
pPrimary.MouseButton1Click:Connect(v80)

local pRemove = t1.PRemove
local n3 = -math.huge

local function v83()
	local v243 = os.clock()

	if v243 - n3 < 0.15 then
		return
	end

	n3 = v243
	onRemove()
end

pRemove.Activated:Connect(v83)
pRemove.MouseButton1Click:Connect(v83)
clearPanel()

local v84 = t1.UnclaimButton

local function v85()
	if not confirm("Unclaim Booth", "Pack up your stand? Your listings stay saved and come back next time you claim a booth.", "Unclaim") then
		return
	end

	local v244, v245 = boothClient.Invoke("Release")

	if v244 then
		sound:Play("UI.Click", workspace)

		local s1: string = "Booth unclaimed"
		local s2: string = "Your listings are saved for next time."

		pcall(function()
			_G.Notify({ notifType = "SuccessNotification", topText = s1, bottomText = s2 })
		end)
		t1.Root.Visible = false

		return
	end

	local text: string = tostring(v245 or "Couldn't unclaim.")

	if not pcall(function()
		_G.Notify({ notifType = "FailNotification", errorMessage = text })
	end) then
		warn("[Booth] " .. text)
	end
end

local n4 = -math.huge

local function v87()
	local v249 = os.clock()

	if v249 - n4 < 0.15 then
		return
	end

	n4 = v249
	v85()
end

v84.Activated:Connect(v87)
v84.MouseButton1Click:Connect(v87)
