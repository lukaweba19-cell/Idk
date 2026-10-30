-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("UserInputService")

local guiService: GuiService = game:GetService("GuiService")

game:GetService("RunService")
game:GetService("TweenService")
game:GetService("ContextActionService")

local v4: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(v4:WaitForChild("Rarity"))

v4 = replicatedStorage:WaitForChild("Shared")

local collectibleSerial = require(v4:WaitForChild("CollectibleSerial"))

v4 = replicatedStorage:WaitForChild("Shared")

local nextItemSpoiler = require(v4:WaitForChild("NextItemSpoiler"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))

v4 = replicatedStorage:WaitForChild("Shared")

local hoverInfoModule = require(v4:WaitForChild("HoverInfoModule"))

v4 = replicatedStorage:WaitForChild("Extensions")

local inputCategorizer = require(v4:WaitForChild("InputCategorizer"))

v4 = replicatedStorage:WaitForChild("Shared")

local windowBlur = require(v4:WaitForChild("WindowBlur"))

v4 = replicatedStorage:WaitForChild("Shared")

local finisherConfig = require(v4:WaitForChild("FinisherConfig"))

v4 = replicatedStorage:WaitForChild("Shared")

local traitText = require(v4:WaitForChild("TraitText"))
local LocalPlayer: Player = players.LocalPlayer

v4 = replicatedStorage:WaitForChild("Remotes")

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local inventory: Instance = v4:WaitForChild("Inventory")

players = v4:WaitForChild("InventoryDirty")

local openCrate: Instance = bindables:WaitForChild("OpenCrate")

v4 = bindables:WaitForChild("OpenInventoryForPlayer")

local openInventoryForTrade: Instance = bindables:WaitForChild("OpenInventoryForTrade")
local addItemToTrade: Instance = bindables:WaitForChild("AddItemToTrade")
local tradeReservedChanged: Instance = bindables:WaitForChild("TradeReservedChanged")
local tradeSelectClosed: Instance = bindables:WaitForChild("TradeSelectClosed")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local v24 = replicatedStorage:WaitForChild("Extensions")
local gamepadSliderController = require(v24:WaitForChild("GamepadSliderController"))
local t1 = {}

local function tradeKey(p1, p2, p3, p4)
	local s1: string = p1 .. ":" .. p2 .. ":" .. (p3 or "none")

	if p4 == nil then
		return s1
	end

	local text: string = tostring(p4)

	return s1 .. ":#" .. text
end

local UserId = nil
local u29: boolean = false
local t2: {[any]: any} = { Knife = "Default", Revolver = "Default" }

v24 = LocalPlayer:WaitForChild("PlayerGui")

local v31 = v24:WaitForChild("HUD")
local spinner: Instance = v24:WaitForChild("Spinner")
local inventoryWindow: Instance = v31:WaitForChild("InventoryWindow")
local closeButton: Instance = inventoryWindow:WaitForChild("CloseButton")

v24 = inventoryWindow:WaitForChild("Options")

local textBox: Instance = v24:WaitForChild("SearchBar"):WaitForChild("TextBox")
local itemLimitIndicator: Instance = v24:WaitForChild("ItemLimitIndicator")
local tabHeader: Instance = v24:WaitForChild("TabHeader")
local imageLabel: Instance = v24:WaitForChild("ImageLabel")

v24:FindFirstChild("SELECTED")
v24:FindFirstChild("OFFERED")

local items: Instance = inventoryWindow:WaitForChild("ItemContent"):WaitForChild("Items")

items:FindFirstChildOfClass("UIGridLayout")
items.AutomaticCanvasSize = Enum.AutomaticSize.Y
items.CanvasSize = UDim2.new(0, 0, 0, 0)
v24 = replicatedStorage:WaitForChild("Shared")
require(v24:WaitForChild("ScrollListFit")).bind(items)

local t3: {[any]: any} = {}

for _, v in ipairs(items:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "ItemTemplate" then
		table.insert(t3, v)
	end
end

local navigator: Instance = inventoryWindow:WaitForChild("Navigator")
local t4: {[any]: any} = {
	All = "All",
	Knives = "Knives",
	Revolvers = "Revolvers",
	Cases = "Crates",
	Finishers = "Finishers",
	Emotes = "Emotes"
}
local t5: {[any]: any} = {
	All = "All",
	Knives = "Knives",
	Revolvers = "Guns",
	Cases = "Cases",
	Finishers = "Finishers",
	Emotes = "Emotes"
}
local filters: Instance = inventoryWindow:WaitForChild("Filters")

v24 = filters:FindFirstChild("NextItemSpoiler")

local itemTemplate: Instance = filters:WaitForChild("ItemTemplate")
local itemName: Instance = filters:WaitForChild("ItemName")
local equipButton: Instance = filters:WaitForChild("EquipButton")
local unequipButton: Instance = filters:WaitForChild("UnequipButton")
local disabledButton: Instance = filters:FindFirstChild("DisabledButton")
local deleteButton: Instance = filters:WaitForChild("DeleteButton")
local equipButtonPosition = equipButton.Position
local unequipButtonPosition = unequipButton.Position
local ownedButton: Instance = filters:FindFirstChild("OwnedButton")
local description: Instance = filters:FindFirstChild("Description")
local rarity2: Instance = filters:FindFirstChild("Rarity")
local exists: Instance = filters:FindFirstChild("Exists")
local u59 = nil
local u60 = nil

for _, v in ipairs(equipButton:GetChildren()) do
	if v:IsA("TextLabel") and v.Name == "TextLabel" then
		u59 = v

		local textLabel = v:FindFirstChild("TextLabel")

		if not textLabel or not textLabel:IsA("TextLabel") then
			break
		end

		u60 = textLabel

		break
	end
end

local deleteContainer: Instance = v31:WaitForChild("DeleteContainer")
local v65: Instance = deleteContainer:WaitForChild("Window")
local v66: Instance = v65:WaitForChild("ItemName")
local itemRarity: Instance = v65:WaitForChild("ItemRarity")
local v68 = v65:WaitForChild("Bar")
local v69 = v68:WaitForChild("Backing")
local bar: Instance = v69:WaitForChild("Bar")
local v71 = v69:WaitForChild("Slider")
local v72: Instance = v68:WaitForChild("Value")

v68 = v65:WaitForChild("DELETE")

local v73 = v65:WaitForChild("CANCEL")
local applyFinisher: Instance = v31:WaitForChild("ApplyFinisher")
local headerTextLabel: Instance = applyFinisher:WaitForChild("HeaderTextLabel")
local winText: Instance = applyFinisher:WaitForChild("WinText")
local apply: Instance = applyFinisher:WaitForChild("Apply")

v65 = applyFinisher:WaitForChild("Cancel")

local applyFinisherCloseButton: Instance = applyFinisher:WaitForChild("CloseButton")
local detachFinisher: Instance = v31:WaitForChild("DetachFinisher")
local detachFinisherHeaderTextLabel: Instance = detachFinisher:WaitForChild("HeaderTextLabel")
local detachFinisherWinText: Instance = detachFinisher:WaitForChild("WinText")
local priceButton: Instance = detachFinisher:WaitForChild("PriceButton")
local cancel: Instance = detachFinisher:WaitForChild("Cancel")
local detachFinisherCloseButton: Instance = detachFinisher:WaitForChild("CloseButton")
local v85 = hoverInfoModule.create(inventoryWindow)
local alert: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("Alert")
local inventoryButton = nil
local clone = nil
local lobbyButtons = v31:FindFirstChild("LobbyButtons")
local v90: Instance = lobbyButtons and lobbyButtons:FindFirstChild("LobbyButtons")

if v90 then
	inventoryButton = v90:FindFirstChild("InventoryButton")
end

local t6: {[any]: any} = {}
local t7: {[any]: any} = {}
local t8: {[any]: any} = {}
local u94: boolean = false
local s1 = "All"
local s2 = ""
local u97 = nil
local t9: {[any]: any} = {}
local u99: boolean = false
local u100: boolean = false
local s3 = "Trade"
local u102: boolean = false
local u103 = nil
local u104 = nil
local u105 = nil
local t10: {[any]: any} = {}
local u107 = nil
local u108 = nil

if v24 then
	u108 = nextItemSpoiler.Bind(v24, function()
		local v201 = u107

		if not v201 or v201.Kind ~= "Crate" or not v201.CrateId then
			return nil
		end

		local v202 = nextItemSpoiler.PeekCrate(v201.CrateId)

		if not v202 then
			return nil
		end

		v201 = nil

		if v202.FinisherName and v202.FinisherName ~= "" then
			v201 = "+ " .. v202.FinisherName
		end

		return {
			Name = v202.Name or v202.ItemId or "?",
			Rarity = v202.Rarity,
			Suffix = v201
		}
	end)
end

local u109 = nil
local u110 = nil
local Kind = nil
local ItemId = nil
local t11: {[any]: any} = {}
local n1: number = 0
local u115 = nil
local u116 = nil

local function setNestedText(p5, p6, text)
	local foundChild = p5:FindFirstChild(p6)

	if foundChild and foundChild:IsA("TextLabel") then
		foundChild.Text = text

		local textLabel = foundChild:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text
		end
	end
end

setNestedText = function()
	if UserId == nil or UserId == LocalPlayer.UserId then
		return u97
	end

	return t9[UserId]
end

local function updateLobbyBadge()
	local n1 = 0

	for iterKey in pairs(t6) do
		n1 += 1
	end

	for _, v in pairs(t7) do
		n1 += v
	end

	if n1 > 0 then
		local parent = not clone and inventoryButton and inventoryButton:FindFirstChild("ImageLabel")

		if parent then
			clone = alert:Clone()
			clone.Parent = parent
		end

		if clone then
			clone.Visible = true

			local quantity = clone:FindFirstChild("Quantity")

			if quantity then
				quantity.Text = if n1 > 99 then "!" else tostring(n1)

				return
			end
		end
	elseif clone then
		clone.Visible = false
	end
end

local t12: {[any]: any} = {}

local function updateNavAlerts()
	local v214 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]
	local t17: {[any]: any} = { Knife = 0, Revolver = 0, Crate = 0, Finisher = 0, Emote = 0 }
	local n1 = 0

	if v214 then
		for _, v in ipairs(v214.Items or {}) do
			if v.Unseen == true and not u29 then
				local vKind = v.Kind

				if not vKind or t17[vKind] == nil then
					n1 += 1
				elseif vKind == "Crate" then
					local v220 = v.UnseenCount or 1

					t17[vKind] = t17[vKind] + v220
					n1 += v220
				else
					t17[vKind] = t17[vKind] + 1
					n1 += 1
				end
			end
		end
	end

	v214 = {
		All = n1,
		Knives = t17.Knife,
		Revolvers = t17.Revolver,
		Cases = t17.Crate,
		Finishers = t17.Finisher,
		Emotes = t17.Emote
	}

	for _, v in ipairs(navigator:GetChildren()) do
		if v:IsA("ImageButton") then
			local v223 = v214[v.Name] or 0

			if v223 > 0 then
				if not t12[v.Name] then
					local clone: Instance = alert:Clone()

					clone.Parent = v
					t12[v.Name] = clone
				end

				local v225 = t12[v.Name]

				v225.Visible = true

				local quantity = v225:FindFirstChild("Quantity")

				if quantity then
					quantity.Text = if v223 > 99 then "!" else tostring(v223)
				end
			else
				local v227 = t12[v.Name]

				if v227 then
					v227.Visible = false
				end
			end
		end
	end
end

local t13: {[any]: any} = {}

local function flushMarkSeen()
	if #t8 == 0 and #t13 == 0 then
		return
	end

	local v228 = table.clone(t8)
	local v229 = table.clone(t13)

	table.clear(t8)
	table.clear(t13)
	u94 = false
	task.spawn(function()
		pcall(function()
			inventory:InvokeServer("MarkSeen", { InstanceIds = v228, CrateIds = v229 })
		end)
	end)
end
local function markInstanceSeen(p8)
	local u231: boolean = false

	for _, v in ipairs(p8) do
		if t6[v] then
			t6[v] = nil
			u231 = true
		end
	end

	if u231 then
		for _, v in ipairs(p8) do
			table.insert(t8, v)
		end
	end

	updateLobbyBadge()
	updateNavAlerts()

	if #t8 > 0 and not u94 then
		u94 = true
		task.delay(0.5, flushMarkSeen)
	end
end
local function markCrateSeen(p9)
	if t7[p9] then
		t7[p9] = nil
		table.insert(t13, p9)
	end

	updateLobbyBadge()
	updateNavAlerts()

	if #t13 > 0 and not u94 then
		u94 = true
		task.delay(0.5, flushMarkSeen)
	end
end
local function setCacheFor(p10, p11)
	if p10 == LocalPlayer.UserId then
		u97 = p11

		return
	end

	t9[p10] = p11
end
local function updateCapacityLabel()
	local v239 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]
	local n1 = 0

	if v239 and v239.Items then
		for _, v in ipairs(v239.Items) do
			n1 += v.Stack
		end
	end

	itemLimitIndicator.Text = ("%d/2000 Items"):format(n1)
end
local function formatNumber(p12)
	if p12 < 10000 then
		local floored = math.floor(p12)

		return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end

	if p12 < 1000000 then
		return string.format("%.1fK", p12 / 1000)
	end

	return string.format("%.1fM", p12 / 1000000)
end
local function isDefaultItem(p13)
	local v246 = t2[p13.Kind]

	return v246 ~= nil and v246 == p13.ItemId
end
local function canTradeItem(p14)
	return p14.CanTrade == true
end
local function notifyTradeFail(p15, p16)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify({
				notifType = "FailNotification",
				topText = "Can't Add Item",
				errorMessage = p15,
				iconOverride = p16
			})
		end)
	end
end
local function fmtLockDuration(p17)
	local floored = math.floor(p17)
	local v253 = math.max(0, floored)
	local floored2 = math.floor(v253 / 60)
	local n1 = v253 % 60

	if floored2 > 0 then
		return string.format("%dm %02ds", floored2, n1)
	end

	return string.format("%ds", n1)
end
local function untradableItemMessage(p18)
	local tradeLockedUntil = p18.TradeLockedUntil

	if typeof(tradeLockedUntil) == "number" then
		local timestamp = os.time()
		local n1 = tradeLockedUntil - timestamp

		if n1 > 0 then
			local floored = math.floor(n1)
			local v261 = math.max(0, floored)
			local floored3 = math.floor(v261 / 60)
			local n2 = v261 % 60
			local formattedText

			if floored3 > 0 then
				formattedText = string.format("%dm %02ds", floored3, n2)
			else
				formattedText = string.format("%ds", n2)
			end

			return "You recently traded for this. You can trade it again in " .. formattedText .. "."
		end
	end

	if p18.FinisherUntradeable == true then
		return "Its finisher is exclusive and can't be traded. Remove the finisher first."
	end

	return "This item can't be traded."
end

v90 = replicatedStorage:WaitForChild("Shared")
lobbyButtons = require(v90:WaitForChild("RapClient"))
v90 = replicatedStorage:WaitForChild("Shared")
v24 = require(v90:WaitForChild("RapProjected"))

local t14: {[any]: any} = {
	ICON = "rbxassetid://93102830669756",
	IN_BOOTH_ICON = "rbxassetid://111291160850347",
	RapClient = lobbyButtons,
	Projected = v24
}

function t14.isProjected(p19)
	if p19.Kind == "Crate" or typeof(p19.ItemId) ~= "string" then
		return false
	end

	local rapClient = t14.RapClient

	if not rapClient.HasRap(p19.Kind) then
		return false
	end

	local v267 = rapClient.Peek(p19.Kind, p19.ItemId)

	if v267 == nil then
		rapClient.Prime()

		return false
	end

	return t14.Projected.Is(v267)
end
function t14.applyProjected(p20)
	local item = p20.item
	local cell = p20.cell
	local api = p20.api

	if cell.Parent == nil then
		return
	end

	local v272 = t14.isProjected(item)

	api:setFinisher(if v272 then nil else item.Finisher)

	local boothHoldTag = cell:FindFirstChild("BoothHoldTag")

	if boothHoldTag and boothHoldTag:IsA("GuiObject") then
		boothHoldTag.Position = UDim2.new(0.98, 0, if not v272 and item.FinisherIcon ~= nil then 0.4 else 0.02, 0)
	end

	t14.Projected.SetTag(cell, v272, 0.98, if boothHoldTag == nil then 0.02 else 0.4, 0.3, cell.ZIndex + 3)
end

t14.RapClient.Changed:Connect(function()
	for _, v in ipairs(t11) do
		t14.applyProjected(v)
	end
end)

function t14.remaining(p21)
	local boothHoldUntil = p21.BoothHoldUntil

	if typeof(boothHoldUntil) == "number" then
		local timestamp = os.time()

		return (math.max(0, boothHoldUntil - timestamp))
	end

	return 0
end
function t14.heldCount(p22)
	local boothHeldCount = p22.BoothHeldCount

	if typeof(boothHeldCount) == "number" then
		return boothHeldCount
	end

	if t14.remaining(p22) > 0 then
		return 1
	end

	return 0
end
function t14.fmtMinutes(p23)
	local roundedUp = math.ceil(p23 / 60)

	if roundedUp >= 1 then
		return (("%d min"):format(roundedUp))
	end

	return "under a minute"
end
function t14.line(p24)
	local v284 = t14.heldCount(p24)
	local v285 = t14.remaining(p24)

	if v284 <= 0 or v285 <= 0 then
		return nil
	end

	local v286 = math.max(1, p24.Stack or 1)

	if v286 <= 1 then
		return ("(listable in %s)"):format(t14.fmtMinutes(v285))
	end

	return ("(%d of %d on hold for %s)"):format(v284, v286, t14.fmtMinutes(v285))
end
function t14.note(p25)
	local v288 = t14.heldCount(p25)
	local v289 = t14.remaining(p25)

	if v288 <= 0 or v289 <= 0 then
		return nil
	end

	local v290 = math.max(1, p25.Stack or 1)

	if v290 > 1 then
		return ("%d of %d on booth hold (%s)"):format(v288, v290, t14.fmtMinutes(v289))
	end

	return ("On booth hold (%s)"):format(t14.fmtMinutes(v289))
end

v24 = replicatedStorage:WaitForChild("Shared")
t14.PackCatalog = require(v24:WaitForChild("PackCatalog"))
v24 = replicatedStorage:WaitForChild("Shared")
t14.BoothClient = require(v24:WaitForChild("BoothClient"))

function t14.shopBlock(p26)
	if p26.Kind == "Knife" or p26.Kind == "Revolver" or p26.Kind == "Finisher" then
		local v292 = t14.BoothClient.GetConfig()

		if v292 == nil or v292.BlockShopItems ~= false then
			local ok, result = pcall(t14.PackCatalog.GetShopItemSet)

			if ok and typeof(result) == "table" then
				local v295 = result[p26.Kind]

				if v295 ~= nil and typeof(p26.ItemId) == "string" and v295[p26.ItemId] == true then
					return "Item"
				end

				if p26.Kind == "Finisher" or typeof(p26.Finisher) ~= "string" or result.Finisher[p26.Finisher] ~= true then
					return nil
				end

				return "Finisher"
			end

			return nil
		end

		return nil
	end

	return nil
end
function t14.shopRemaining(p27, p28)
	local v298 = p27.Kind
	local v299 = p27.ItemId

	if p28 == "Finisher" then
		v298 = "Finisher"
		v299 = p27.Finisher
	end

	if typeof(v299) == "string" then
		local ok, result = pcall(t14.PackCatalog.ShopLeavesAt, v298, v299)

		if not ok or typeof(result) ~= "number" then
			return nil
		end

		if result == math.huge then
			return math.huge
		end

		local timestamp = os.time()

		return (math.max(0, result - timestamp))
	end

	return nil
end
function t14.fmtLong(p29)
	if p29 >= 172800 then
		return ("%d days"):format((math.floor(p29 / 86400)))
	end

	if p29 >= 7200 then
		return ("%d hours"):format((math.floor(p29 / 3600)))
	end

	return t14.fmtMinutes(p29)
end
function t14.shopNote(p30, p31)
	local s1: string = if p31 == "Finisher" then "Finisher in the shop" else "In the shop"
	local v307 = t14.shopRemaining(p30, p31)

	if v307 == nil or v307 == math.huge then
		return s1
	end

	return ("%s (%s)"):format(s1, t14.fmtLong(v307))
end
function t14.addTag(parent, p33)
	local boothHoldTag: ImageLabel = Instance.new("ImageLabel")

	boothHoldTag.Name = "BoothHoldTag"
	boothHoldTag.BackgroundTransparency = 1
	boothHoldTag.Image = t14.ICON
	boothHoldTag.ScaleType = Enum.ScaleType.Fit
	boothHoldTag.AnchorPoint = Vector2.new(1, 0)
	boothHoldTag.Position = UDim2.new(0.98, 0, if p33.FinisherIcon == nil then 0.02 else 0.4, 0)
	boothHoldTag.Size = UDim2.new(0.3, 0, 0.3, 0)
	boothHoldTag.ZIndex = parent.ZIndex + 3

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	uiAspectRatioConstraint.Parent = boothHoldTag
	boothHoldTag.Parent = parent
end
local function getFirstInstanceIdByItemId(p34, p35)
	local v314 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]

	if not v314 then
		return nil
	end

	for _, v in ipairs(v314.Items or {}) do
		if p34 == v.Kind and p35 == v.ItemId then
			local vInstanceIds = v.InstanceIds

			return vInstanceIds and vInstanceIds[1] or v.InstanceId
		end
	end

	return nil
end
local function getPredictedDefaultEquippedId(p36)
	local v319 = t2[p36]

	if not v319 then
		return nil
	end

	return (getFirstInstanceIdByItemId(p36, v319))
end
local function getEquippedInstanceIdFromCache(p37)
	local v321 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]

	if not v321 then
		return nil
	end

	for _, v in ipairs(v321.Items or {}) do
		if p37 == v.Kind and v.IsEquipped and typeof(v.InstanceId) == "string" then
			return v.InstanceId
		end
	end

	return nil
end
local function fetchSnapshot(p38)
	local t18: {[any]: any} = { Filter = p38 }

	if UserId ~= nil then
		t18.TargetUserId = UserId
	end

	local v326, v327, v328 = pcall(function()
		return inventory:InvokeServer("GetSnapshot", t18)
	end)

	if not v326 then
		warn("[InventoryUI] GetSnapshot failed")
	elseif v327 == false and v328 == "NotReady" then
	elseif typeof(v327) == "table" then
		return v327
	end

	return nil
end
local function patchEquippedInCache(p39, p40, p41)
	local v332 = p41 or LocalPlayer.UserId
	local v333 = if v332 == LocalPlayer.UserId then u97 else t9[v332]

	if not v333 then
		return
	end

	for _, v in ipairs(v333.Items or {}) do
		if p39 == v.Kind then
			v.IsEquipped = p40 ~= nil and p40 == v.InstanceId
		end
	end
end
local function serverEquip(p42, p43)
	local v338, v339, v340 = pcall(function()
		return inventory:InvokeServer("Equip", { Kind = p42, InstanceId = p43 })
	end)

	if not v338 then
		return false, "InvokeFailed"
	end

	return v339 == true, v340
end
local function serverUnequip(p44)
	local v342, v343, v344 = pcall(function()
		return inventory:InvokeServer("Unequip", { Kind = p44 })
	end)

	if not v342 then
		return false, "InvokeFailed"
	end

	return v343 == true, v344
end
local function serverApplyFinisher(p45, p46, p47)
	local v348, v349, v350 = pcall(function()
		return inventory:InvokeServer("ApplyFinisher", { FinisherInstanceId = p45, WeaponKind = p46, WeaponInstanceId = p47 })
	end)

	if not v348 then
		return false, "InvokeFailed"
	end

	return v349 == true, v350
end
local function serverRemoveFinisher(p48, p49)
	local v353, v354, v355 = pcall(function()
		return inventory:InvokeServer("RemoveFinisher", { WeaponKind = p48, WeaponInstanceId = p49 })
	end)

	if not v353 then
		return false, "InvokeFailed"
	end

	return v354 == true, v355
end
local function serverOpenCrate(p50, p51)
	if spinner.Enabled and not p51 then
		return false, "AlreadySpinning", nil
	end

	local v358, v359, v360, v361 = pcall(function()
		return inventory:InvokeServer("OpenCrate", { CrateId = p50 })
	end)

	if not v358 then
		return false, "InvokeFailed", nil
	end

	if v359 == true and typeof(v361) == "table" then
		sound:Play("Misc.RollOpening", workspace)

		local v362 = t10[p50]

		openCrate:Fire({
			CrateId = p50,
			CrateName = v362 and v362.Name or p50,
			RarityOdds = v362 and v362.RarityOdds or {},
			PublicPools = v362 and v362.PublicPools or {},
			Reward = v361,
			GetRemaining = function()
				local v679 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]

				if not v679 then
					return 0
				end

				for _, v in ipairs(v679.Items or {}) do
					if v.Kind == "Crate" and v.CrateId == p50 then
						return (math.max(0, v.Stack or 0))
					end
				end

				return 0
			end,
			RequestRoll = function()
				return inventory:InvokeServer("OpenCrate", { CrateId = p50 })
			end
		})
		windowBlur.hide("LobbyPanel")
		inventoryWindow.Visible = false
	end

	return v359 == true, v360, v361
end

local u144: boolean = false
local n2 = 1
local n3 = 1
local u147 = nil

bar.AnchorPoint = Vector2.new(0, 0.5)
bar.Position = UDim2.new(0, 0, 0.5, 0)
v71.AnchorPoint = Vector2.new(0.5, 0.5)

local v148 = uiFramework.wireSlider({
	min = 1,
	max = 1,
	default = 1,
	knobPositionAxis = true,
	barContainer = v69,
	innerBar = bar,
	knob = v71,
	valueLabel = v72,
	getValue = function()
		return n3
	end,
	setValue = function(p52)
		n3 = p52
	end
})

local u149 = nil

local v150 = gamepadSliderController.new({
	actionPrefix = "DC",
	windowFrame = deleteContainer,
	closeFn = function()
		u149()
	end
})

v24 = v150:addSlider(v69, v148.adjustByDelta)
v24.NextSelectionRight = v72
v72.NextSelectionLeft = v24
v24.NextSelectionDown = v68
v72.NextSelectionDown = v68
v68.NextSelectionRight = v73
v73.NextSelectionLeft = v68
v68.NextSelectionUp = v24
v73.NextSelectionUp = v72
v24.NextSelectionLeft = v24

local function dcSetVisual(p53)
	n3 = math.clamp(p53, 1, n2)
	v148.refresh()
end
local function setInventoryInteractable(p54)
	u144 = not p54
	closeButton.Active = p54
	closeButton.Selectable = p54
	textBox.Interactable = p54
	textBox.Selectable = p54
	items.ScrollingEnabled = p54

	for _, v in ipairs(navigator:GetChildren()) do
		if v:IsA("GuiButton") then
			v.Active = p54
			v.Selectable = p54
		end
	end

	for _, v in ipairs(t11) do
		v.cell.Active = p54
		v.cell.Selectable = p54
	end

	if not p54 then
		hoverInfoModule.hide(v85)
	end
end
local function openDeleteContainer(p55)
	u147 = p55
	n2 = math.max(1, p55.Stack or 1)
	n3 = 1
	v148.setRange(1, n2, 1)
	traitText.Bind(v66, p55.Name)
	itemRarity.Visible = true
	itemRarity.Text = if p55.Rarity == "Empty" then "Consumable" else p55.Rarity
	rarity.ApplyTextGradient(itemRarity, p55.Rarity)
	v72.PlaceholderText = tostring(n2)
	v72.Text = "1"
	n3 = math.clamp(1, 1, n2)
	v148.refresh()
	deleteContainer.Visible = true
	setInventoryInteractable(false)

	if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		v150:activate()
	end
end

u149 = function()
	deleteContainer.Visible = false
	u147 = nil
	setInventoryInteractable(true)
	v150:deactivate()
end
v73.MouseButton1Click:Connect(function()
	u149()
end)

local u154 = nil
local u155 = nil
local u156 = nil
local u157 = nil
local u158 = nil
local u159 = nil

v68.MouseButton1Click:Connect(function()
	local v371 = u147

	if not v371 then
		u149()

		return
	end

	local v372 = n3
	local v373 = math.max(1, v371.Stack or 1)
	local v374 = math.clamp(v372, 1, v373)

	u149()

	local rarity2 = v371.Rarity
	local u376: boolean = true

	if not ((rarity.Order[rarity2] or 0) >= rarity.Order.Legendary) then
		u376 = v371.Unobtainable == true
	end

	v372 = u376 and bindables:WaitForChild("ConfirmModal", 5)

	if v372 then
		local lowerText = string.lower(v371.Rarity)
		local v378 = rarity.Colors[v371.Rarity] or Color3.fromRGB(255, 255, 255)
		local stringFormat = string.format
		local floored = math.floor(v378.R * 255 + 0.5)
		local floored4 = math.floor(v378.G * 255 + 0.5)
		local floored5 = math.floor(v378.B * 255 + 0.5)
		local v383 = stringFormat("#%02X%02X%02X", floored, floored4, floored5)
		local formattedText = string.format("<font color=\"%s\">%s</font>", v383, lowerText)
		local replacedText = v371.Name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

		if v372:Invoke({
			AcceptText = "Delete",
			DeclineText = "Keep",
			RichText = true,
			Destructive = true,
			Header = "Delete " .. lowerText .. " item?",
			Body = (if v374 > 1 then tostring(v374) .. "x " .. replacedText else replacedText) .. " is " .. formattedText .. " and deleting it can't be undone. Delete it anyway?"
		}) ~= true then
			return
		end
	end

	local t19: {[any]: any} = {}

	if v371.Kind == "Crate" then
		table.insert(t19, { CrateId = v371.CrateId, Kind = v371.Kind, Count = v374 })
	else
		table.insert(t19, { InstanceIds = v371.InstanceIds, Kind = v371.Kind, Count = v374 })
	end

	if v374 < (v371.Stack or 1) then
		Kind = v371.Kind
		ItemId = if v371.Kind == "Crate" then v371.CrateId else v371.ItemId
	else
		Kind = nil
		ItemId = nil
	end

	task.spawn(function()
		pcall(function()
			inventory:InvokeServer("DeleteItems", { Items = t19 })
		end)
		u154()
	end)
end)

local t15: {[any]: any} = { maxItems = 10 }
local tradeAmountContainer: Instance = v31:WaitForChild("TradeAmountContainer")

v24 = tradeAmountContainer:WaitForChild("Window")

local v162 = v24:WaitForChild("ItemName")
local v163 = v24:WaitForChild("ItemRarity")

v73 = v24:WaitForChild("Bar")
v68 = v73:WaitForChild("Backing")
v69 = v68:WaitForChild("Bar")
v31 = v68:WaitForChild("Slider")

local v164 = v73:WaitForChild("Value")

v73 = v24:WaitForChild("CONFIRM")
v71 = v24:WaitForChild("CANCEL")

local n4 = 1
local n5 = 1
local u167 = nil

v69.AnchorPoint = Vector2.new(0, 0.5)
v69.Position = UDim2.new(0, 0, 0.5, 0)
v31.AnchorPoint = Vector2.new(0.5, 0.5)

local v168 = uiFramework.wireSlider({
	min = 1,
	max = 1,
	default = 1,
	knobPositionAxis = true,
	barContainer = v68,
	innerBar = v69,
	knob = v31,
	valueLabel = v164,
	getValue = function()
		return n5
	end,
	setValue = function(p56)
		n5 = p56
	end
})

local v169 = gamepadSliderController.new({
	actionPrefix = "TA",
	windowFrame = tradeAmountContainer,
	closeFn = function()
		t15.close()
	end
})

v31 = v169:addSlider(v68, v168.adjustByDelta)
v31.NextSelectionRight = v164
v164.NextSelectionLeft = v31
v31.NextSelectionDown = v73
v164.NextSelectionDown = v73
v73.NextSelectionRight = v71
v71.NextSelectionLeft = v73
v73.NextSelectionUp = v31
v71.NextSelectionUp = v164
v31.NextSelectionLeft = v31

function t15.addableCount(p57)
	local v389 = if p57.Kind == "Crate" then p57.CrateId else p57.ItemId
	local n1 = 0

	if v389 then
		local v391: {[any]: any} = t1
		local serial = p57.Serial
		local s1: string = p57.Kind .. ":" .. v389 .. ":" .. (p57.Finisher or "none")
		local s2

		if serial == nil then
			s2 = s1
		else
			local text: string = tostring(serial)

			s2 = s1 .. ":#" .. text
		end

		n1 = v391[s2] or 0
	end

	local v396 = math.max(0, (p57.TradableCount or p57.Stack or 1) - n1)

	n1 = 0

	for _, v in pairs(t1) do
		n1 += v
	end

	local v399 = math.max(0, t15.maxItems - n1)

	return (math.min(v396, v399))
end
function t15.fireAdd(p58, p59)
	if p58.Kind == "Crate" then
		addItemToTrade:Fire({
			Kind = "Crate",
			ItemId = p58.CrateId,
			Amount = p59,
			Purpose = s3,
			Name = p58.Name,
			Rarity = p58.Rarity,
			Icon = p58.Icon
		})

		return true
	end

	local instanceIds = p58.InstanceIds
	local v403 = instanceIds and instanceIds[1] or p58.InstanceId

	if not v403 then
		return false
	end

	addItemToTrade:Fire({
		InstanceId = v403,
		ItemId = p58.ItemId,
		Kind = p58.Kind,
		Amount = p59,
		Purpose = s3,
		Name = p58.Name,
		Rarity = p58.Rarity,
		Icon = p58.Icon,
		Finisher = p58.Finisher,
		FinisherName = p58.FinisherName,
		FinisherIcon = p58.FinisherIcon,
		FinisherRarity = p58.FinisherRarity,
		Serial = p58.Serial
	})

	return true
end
function t15.open(p60, p61)
	u167 = p60
	n4 = math.max(1, p61)
	n5 = 1
	v168.setRange(1, n4, 1)
	traitText.Bind(v162, p60.Name)
	v163.Visible = true
	v163.Text = if p60.Rarity == "Empty" then "Consumable" else p60.Rarity
	rarity.ApplyTextGradient(v163, p60.Rarity)
	v164.PlaceholderText = tostring(n4)
	v164.Text = "1"
	v168.refresh()
	tradeAmountContainer.Visible = true
	setInventoryInteractable(false)

	if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		v169:activate()
	end
end
function t15.close()
	tradeAmountContainer.Visible = false
	u167 = nil
	setInventoryInteractable(true)
	v169:deactivate()
end

v71.MouseButton1Click:Connect(function()
	t15.close()
end)
v73.MouseButton1Click:Connect(function()
	local v406 = u167

	if not v406 then
		t15.close()

		return
	end

	local v407 = math.clamp(n5, 1, n4)

	t15.close()

	if t15.fireAdd(v406, v407) then
		inventoryWindow.Visible = false
		u155()
	end
end)

local function buildFilterPreviewCell(p62)
	local v409 = u115 or itemTemplate

	if not v409 or not v409.Parent then
		v409 = nil
	end

	local v410, v411 = uiFramework.createItemCell(p62, {
		visible = true,
		active = false,
		interactable = true,
		selectable = false,
		inspectable = true,
		replaces = v409,
		parent = if not v409 then filters else nil
	})

	u115 = v410
	u116 = v411

	local v412 = v411:getInspectButton()

	if v412 then
		v412.Active = true
		v412.Interactable = true
		v412.MouseButton1Click:Connect(function()
			if u144 then
				return
			end

			local v682 = u107

			if not v682 then
			elseif v682.Kind == "Knife" or v682.Kind == "Revolver" or v682.Kind == "Finisher" or v682.Kind == "Emote" then
				bindables.InspectItem:Fire({
					Kind = v682.Kind,
					ItemId = v682.ItemId,
					Name = v682.Name,
					Rarity = v682.Rarity,
					GlobalCopies = v682.GlobalCopies,
					Serial = v682.Serial,
					MaxSupply = v682.MaxSupply
				})

				return
			end
		end)
	end
end
local function setEquipButtonText(text)
	if u59 then
		u59.Text = text
	end

	if u60 then
		u60.Text = text
	end
end
local function updateFiltersPanel(p64)
	if not p64 then
		filters.Visible = false

		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		require(shared:WaitForChild("EmotePreview")).stop()

		if u108 then
			u108:Refresh()
		end

		return
	end

	filters.Visible = true

	if u108 then
		u108:Refresh()
	end

	traitText.Bind(itemName, p64.Name)

	for _, v in ipairs(itemName:GetChildren()) do
		if v:IsA("UIGradient") and v:GetAttribute("RarityGradient") then
			v:Destroy()
		end
	end

	itemName.TextColor3 = rarity.Colors[p64.Rarity] or Color3.fromRGB(255, 255, 255)

	if rarity2 then
		rarity2.Visible = true
		rarity2.Text = if p64.Rarity == "Empty" then "Consumable" else p64.Rarity
		rarity2.TextColor3 = Color3.fromRGB(255, 255, 255)
		rarity.ApplyTextGradient(rarity2, p64.Rarity)
	end

	if exists then
		local text = collectibleSerial.Format(p64.Serial, p64.MaxSupply)

		if text then
			exists.Text = text
			exists.Visible = true
		elseif p64.GlobalCopies and p64.GlobalCopies > 0 then
			exists.Text = formatNumber(p64.GlobalCopies) .. " Exist"
			exists.Visible = true
		else
			exists.Visible = false
		end
	end

	local openXButton: Instance = filters:FindFirstChild("OpenXButton")
	local v420 = math.min(p64.Stack or 1, 10)
	local u421: boolean = false

	if openXButton ~= nil then
		u421 = false

		if p64.Kind == "Crate" then
			u421 = false

			if (p64.Stack or 1) > 2 then
				u421 = not u102 and not u100 and not u29

				if u421 then
					u421 = LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") == false
				end
			end
		end
	end

	if description then
		local v422 = p64.FinisherName and p64.FinisherName ~= ""
		local v423 = p64.Description and p64.Description ~= ""
		local v424 = t14.line(p64)
		local u425 = true

		if p64.Serial == nil then
			u425 = p64.GlobalCopies and p64.GlobalCopies > 0
		end

		if not v422 and not v423 and not v424 then
			description.Visible = false
			description.Size = UDim2.new(0.9, 0, 0.12, 0)
			description.Position = UDim2.new(0.495052814, 0, 0.707835284, 0)
		else
			if not u421 then
				if u425 then
					description.Size = UDim2.new(0.9, 0, 0.19, 0)
					description.Position = UDim2.new(0.495, 0, 0.74, 0)
				else
					description.Size = UDim2.new(0.9, 0, 0.24, 0)
					description.Position = UDim2.new(0.495, 0, 0.71, 0)
				end
			elseif u425 then
				description.Size = UDim2.new(0.9, 0, 0.08, 0)
				description.Position = UDim2.new(0.495, 0, 0.685, 0)
			else
				description.Size = UDim2.new(0.9, 0, 0.14, 0)
				description.Position = UDim2.new(0.495, 0, 0.655, 0)
			end

			description.TextScaled = false
			description.TextWrapped = true
			description.RichText = true

			local descriptionAbsoluteSize = description.AbsoluteSize
			local floored = math.floor(descriptionAbsoluteSize.Y * 0.35)
			local textSize = math.clamp(floored, 8, 100)
			local v429 = textSize

			if v423 then
				local textService: TextService = game:GetService("TextService")
				local v431 = description.Font

				if v431 == Enum.Font.Unknown then
					v431 = Enum.Font.GothamBold
				end

				local v432 = descriptionAbsoluteSize.Y

				if v422 then
					local v433: Vector2 = textService:GetTextSize("★ " .. p64.FinisherName, textSize, v431, Vector2.new(descriptionAbsoluteSize.X, math.huge))

					v432 -= v433.Y
				end

				while v429 > 8 and not (v432 >= textService:GetTextSize(p64.Description, v429, v431, Vector2.new(descriptionAbsoluteSize.X, math.huge)).Y) do
					v429 -= 1
				end
			end

			local s1: string = ""

			if v422 then
				s1 = "<font size=\"" .. textSize .. "\"><b>★</b> " .. p64.FinisherName .. "</font>"
			end

			if v423 then
				if s1 ~= "" then
					s1 ..= "\n"
				end

				s1 = s1 .. "<font size=\"" .. v429 .. "\">" .. p64.Description .. "</font>"
			end

			if v424 then
				if s1 ~= "" then
					s1 ..= "\n"
				end

				s1 = s1 .. "<font size=\"" .. v429 .. "\" color=\"#FFC45C\">" .. v424 .. "</font>"
			end

			description.Text = s1
			description.TextSize = textSize
			description.Visible = true
		end
	end

	buildFilterPreviewCell(p64.Rarity)

	local icon = u115 and u115:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.Image = p64.Icon
	end

	local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
	local emotePreview = require(replicatedStorageShared:WaitForChild("EmotePreview"))

	if p64.Kind == "Emote" and u115 then
		emotePreview.show(u115, p64.ItemId)
	else
		emotePreview.stop()
	end

	if u116 then
		u116:setFinisher(p64.Finisher)
	end

	if u115 then
		local finisherRemoveOverlay = u115:FindFirstChild("FinisherRemoveOverlay")

		if finisherRemoveOverlay then
			finisherRemoveOverlay:Destroy()
		end

		local u439

		if p64.Kind == "Knife" then
			u439 = false

			if p64.Finisher ~= nil then
				u439 = false

				if p64.Finisher ~= "" then
					u439 = not p64.FinisherLocked and not u100 and not u29 and not u102
				end
			end
		else
			u439 = p64.Kind == "Revolver" and p64.Finisher ~= nil and p64.Finisher ~= "" and not p64.FinisherLocked and not u100 and not u29 and not u102
		end

		if u439 then
			local v440 = u116 and u116:getFinisherTag()

			if v440 then
				v440.Visible = false
			end

			local finisherRemoveOverlay: ImageButton = Instance.new("ImageButton")

			finisherRemoveOverlay.Name = "FinisherRemoveOverlay"
			finisherRemoveOverlay.BackgroundTransparency = 1
			finisherRemoveOverlay.ImageTransparency = 1
			finisherRemoveOverlay.Size = UDim2.new(0.4, 0, 0.4, 0)
			finisherRemoveOverlay.Position = UDim2.new(1, 0, 0, 0)
			finisherRemoveOverlay.AnchorPoint = Vector2.new(1, 0)
			finisherRemoveOverlay.ZIndex = 7
			finisherRemoveOverlay.Active = true
			finisherRemoveOverlay.Selectable = true
			finisherRemoveOverlay.AutoButtonColor = false
			finisherRemoveOverlay.Parent = u115

			local x: ImageLabel = Instance.new("ImageLabel")

			x.Name = "X"
			x.BackgroundTransparency = 1
			x.Image = "rbxassetid://121896102463775"
			x.Size = UDim2.new(0.7, 0, 0.7, 0)
			x.Position = UDim2.new(0.5, 0, 0.5, 0)
			x.AnchorPoint = Vector2.new(0.5, 0.5)
			x.ZIndex = 8
			x.Parent = finisherRemoveOverlay
			finisherRemoveOverlay.MouseButton1Click:Connect(function()
				if u144 then
					return
				end

				local v683 = u107

				if not v683 then
				elseif (v683.Kind == "Knife" or v683.Kind == "Revolver") and v683.Finisher and v683.Finisher ~= "" and not v683.FinisherLocked then
					u159(v683)
				end
			end)
		end
	end

	local u443: boolean = true

	if p64.Kind ~= "Knife" then
		u443 = true

		if p64.Kind ~= "Revolver" then
			u443 = true

			if p64.Kind ~= "Finisher" then
				u443 = p64.Kind == "Emote"
			end
		end
	end

	local v444 = u116 and u116:getInspectButton()

	if v444 then
		v444.Visible = u443
	end

	u443 = p64.Kind == "Crate"

	local v445 = t2[p64.Kind]

	v444 = v445 ~= nil and v445 == p64.ItemId

	if v444 then
		v444 = p64.IsEquipped
	end

	if u102 then
		equipButton.Visible = true

		if u59 then
			u59.Text = "Cancel"
		end

		if u60 then
			u60.Text = "Cancel"
		end

		unequipButton.Visible = false

		if disabledButton then
			disabledButton.Visible = false
		end

		deleteButton.Visible = false
	elseif u100 or u29 then
		equipButton.Visible = false
		unequipButton.Visible = false

		if disabledButton then
			disabledButton.Visible = false
		end

		deleteButton.Visible = false
	else
		local u446: boolean = true

		if p64.Kind ~= "Knife" then
			u446 = true

			if p64.Kind ~= "Revolver" then
				u446 = u443
			end
		end

		if v444 and u446 then
			equipButton.Visible = false
			unequipButton.Visible = false

			if disabledButton then
				disabledButton.Visible = true
			end
		elseif u446 then
			if u443 then
				equipButton.Visible = true
				unequipButton.Visible = false

				if disabledButton then
					disabledButton.Visible = false
				end

				if u59 then
					u59.Text = "Open"
				end

				if u60 then
					u60.Text = "Open"
				end
			elseif p64.IsEquipped then
				equipButton.Visible = false
				unequipButton.Visible = true

				if disabledButton then
					disabledButton.Visible = false
				end
			else
				equipButton.Visible = true
				unequipButton.Visible = false

				if disabledButton then
					disabledButton.Visible = false
				end

				if u59 then
					u59.Text = "Equip"
				end

				if u60 then
					u60.Text = "Equip"
				end
			end
		elseif p64.Kind == "Emote" then
			if p64.IsEquipped then
				equipButton.Visible = false
				unequipButton.Visible = true
			else
				equipButton.Visible = true
				unequipButton.Visible = false

				if u59 then
					u59.Text = "Equip"
				end

				if u60 then
					u60.Text = "Equip"
				end
			end

			if disabledButton then
				disabledButton.Visible = false
			end
		elseif p64.Kind == "Finisher" then
			equipButton.Visible = true
			unequipButton.Visible = false

			if disabledButton then
				disabledButton.Visible = false
			end

			if u59 then
				u59.Text = "Apply"
			end

			if u60 then
				u60.Text = "Apply"
			end
		else
			equipButton.Visible = false
			unequipButton.Visible = false

			if disabledButton then
				disabledButton.Visible = false
			end
		end

		local v447 = t2[p64.Kind]

		u446 = (v447 == nil or v447 ~= p64.ItemId) and p64.Undeletable ~= true
		deleteButton.Visible = u446

		if u446 then
			equipButton.Position = equipButtonPosition
			unequipButton.Position = unequipButtonPosition
		else
			equipButton.Position = UDim2.new(0.5, 0, equipButtonPosition.Y.Scale, equipButtonPosition.Y.Offset)
			unequipButton.Position = UDim2.new(0.5, 0, unequipButtonPosition.Y.Scale, unequipButtonPosition.Y.Offset)
		end
	end

	if ownedButton then
		ownedButton.Visible = false
	end

	if openXButton then
		openXButton.Visible = u421

		if u421 then
			local s2: string = "Open " .. tostring(v420)
			local textLabel: Instance = openXButton:FindFirstChild("TextLabel")

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = s2

				local textLabel2: Instance = textLabel:FindFirstChild("TextLabel")

				if textLabel2 and textLabel2:IsA("TextLabel") then
					textLabel2.Text = s2
				end
			end

			openXButton.Position = UDim2.new(equipButton.Position.X.Scale, equipButton.Position.X.Offset, openXButton.Position.Y.Scale, openXButton.Position.Y.Offset)
			openXButton.Size = equipButton.Size

			if u59 then
				u59.Text = "Open 1"
			end

			if u60 then
				u60.Text = "Open 1"
			end
		end
	end
end

u155 = function()
	if u110 then
		u110:setSelected(false)
	end

	u107 = nil
	u109 = nil
	u110 = nil
	filters.Visible = false

	local shared: Instance = replicatedStorage:WaitForChild("Shared")

	require(shared:WaitForChild("EmotePreview")).stop()

	if u108 then
		u108:Refresh()
	end

	hoverInfoModule.hide(v85)
end

local function selectItem(p65)
	if u144 then
		return
	end

	if u102 then
		local item = p65.item
		local v454 = (item.Kind == "Knife" or item.Kind == "Revolver") and (item.Finisher == nil or item.Finisher == "" or item.Soulbound ~= nil and item.Finisher == item.Soulbound) and u103

		if v454 then
			u158(v454, item)
		end

		return
	end

	if u100 then
		local v455 = p65.item

		if p65.cell:GetAttribute("InBoothOnly") == true then
			local s1: string = "That item is listed in your booth. Unlist it first to " .. (if s3 == "Booth" then "list it again." else "trade it.")
			local _GNotify = _G.Notify

			if typeof(_GNotify) == "function" then
				local v458 = nil

				pcall(function()
					_GNotify({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = s1,
						iconOverride = v458
					})
				end)
			end

			return
		end

		if p65.cell:GetAttribute("FinisherLocked") == true then
			local v459 = ("%s has an exclusive finisher attached. Remove it to %s."):format(tostring(v455.Name), if s3 == "Booth" then "list the item" else "trade the item")
			local finisherIcon = v455.FinisherIcon
			local notify = _G.Notify

			if typeof(notify) == "function" then
				pcall(function()
					notify({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = v459,
						iconOverride = finisherIcon
					})
				end)
			end

			return
		end

		local inShop = p65.cell:GetAttribute("InShop")

		if inShop == "Item" then
			local v463 = t14.shopRemaining(v455, "Item")
			local v464 = if v463 == nil or v463 == math.huge then ("%s is in the shop right now, so it can't be listed."):format((tostring(v455.Name))) else ("%s is in the shop. You can list it in %s."):format(tostring(v455.Name), t14.fmtLong(v463))
			local v465 = _G.Notify

			if typeof(v465) == "function" then
				local v466 = nil

				pcall(function()
					v465({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = v464,
						iconOverride = v466
					})
				end)
			end

			return
		end

		if inShop == "Finisher" then
			local v467 = ("%s is in the shop right now. Remove it to list this."):format((tostring(v455.FinisherName or "Its finisher")))
			local v468 = v455.FinisherIcon
			local v469 = _G.Notify

			if typeof(v469) == "function" then
				pcall(function()
					v469({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = v467,
						iconOverride = v468
					})
				end)
			end

			return
		end

		if (s3 == "Trade" or s3 == "Booth") and v455.CanTrade ~= true then
			local tradeLockedUntil = v455.TradeLockedUntil
			local s2

			if typeof(tradeLockedUntil) == "number" then
				local timestamp = os.time()
				local n1 = tradeLockedUntil - timestamp

				if n1 > 0 then
					local floored = math.floor(n1)
					local v475 = math.max(0, floored)
					local floored6 = math.floor(v475 / 60)
					local n2 = v475 % 60
					local formattedText

					if floored6 > 0 then
						formattedText = string.format("%dm %02ds", floored6, n2)
					else
						formattedText = string.format("%ds", n2)
					end

					s2 = "You recently traded for this. You can trade it again in " .. formattedText .. "."
				else
					s2 = if v455.FinisherUntradeable == true then "Its finisher is exclusive and can't be traded. Remove the finisher first." else "This item can't be traded."
				end
			else
				s2 = if v455.FinisherUntradeable == true then "Its finisher is exclusive and can't be traded. Remove the finisher first." else "This item can't be traded."
			end

			local v479 = _G.Notify

			if typeof(v479) == "function" then
				local v480 = nil

				pcall(function()
					v479({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = s2,
						iconOverride = v480
					})
				end)
			end

			return
		end

		if s3 == "Booth" then
			local v481 = t14.remaining(v455)

			if v481 > 0 and math.max(1, v455.Stack or 1) <= t14.heldCount(v455) then
				local s5: string = "You recently received this item, so it's on booth hold. You can list it in " .. t14.fmtMinutes(v481) .. "."
				local v483 = _G.Notify

				if typeof(v483) == "function" then
					local v484 = nil

					pcall(function()
						v483({
							notifType = "FailNotification",
							topText = "Can't Add Item",
							errorMessage = s5,
							iconOverride = v484
						})
					end)
				end

				return
			end
		end

		local v485 = t15.addableCount(v455)

		if v485 <= 0 then
			local v486 = _G.Notify

			if typeof(v486) == "function" then
				local s4: string = "You can't add any more of that item."
				local v488 = nil

				pcall(function()
					v486({
						notifType = "FailNotification",
						topText = "Can't Add Item",
						errorMessage = s4,
						iconOverride = v488
					})
				end)
			end

			return
		end

		if s3 == "Booth" and v455.Kind ~= "Crate" then
			if t15.fireAdd(v455, 1) then
				inventoryWindow.Visible = false
				u155()
			end

			return
		end

		if v485 > 1 then
			t15.open(v455, v485)

			return
		end

		if t15.fireAdd(v455, 1) then
			inventoryWindow.Visible = false
			u155()
		end

		return
	end

	if u109 == p65.cell then
		return
	end

	if u110 then
		u110:setSelected(false)
	end

	u107 = p65.item
	u109 = p65.cell
	u110 = p65.api
	p65.api:setSelected(true)
	updateFiltersPanel(p65.item)
end
local function rebuildCrateLookup(p66)
	table.clear(t10)

	for _, v in ipairs(p66.Crates or {}) do
		t10[v.CrateId] = v
	end
end
local function matchesFilter(p67, p68)
	if p68 == "All" then
		return true
	end

	if p68 == "Knives" then
		return p67.Kind == "Knife"
	end

	if p68 == "Revolvers" then
		return p67.Kind == "Revolver"
	end

	if p68 == "Crates" then
		return p67.Kind == "Crate"
	end

	if p68 == "Finishers" then
		return p67.Kind == "Finisher"
	end

	if p68 == "Emotes" then
		return p67.Kind == "Emote"
	end

	return true
end
local function matchesSearch(p69, p70)
	if p70 == "" then
		return true
	end

	local stringFind = string.find
	local lowerText = string.lower(p69.Name)
	local lowerText2 = string.lower(p70)

	return stringFind(lowerText, lowerText2, 1, true) ~= nil
end
local function clearRendered()
	for _, v in ipairs(t11) do
		v.api:destroy()
	end

	table.clear(t11)
	n1 = 0
end
local function renderItem(p71)
	n1 += 1

	local v502 = t3[n1]

	if v502 and not v502.Parent then
		v502 = nil
	end

	local parent, v504 = uiFramework.createItemCell(p71.Rarity, {
		visible = true,
		active = true,
		interactable = true,
		selectable = true,
		icon = p71.Icon,
		name = "Item_" .. p71.Name,
		replaces = v502,
		parent = if not v502 then items else nil
	})

	if u100 and s3 == "Booth" and t14.heldCount(p71) > 0 then
		t14.addTag(parent, p71)
	end

	v502 = if p71.Kind == "Crate" then p71.CrateId else p71.ItemId

	local n2 = 0

	if v502 then
		local v506: {[any]: any} = t1
		local serial = p71.Serial
		local s1: string = p71.Kind .. ":" .. v502 .. ":" .. (p71.Finisher or "none")
		local s2

		if serial == nil then
			s2 = s1
		else
			local text: string = tostring(serial)

			s2 = s1 .. ":#" .. text
		end

		n2 = v506[s2] or 0
	end

	local v511 = if u100 then math.max(0, (p71.TradableCount or p71.Stack) - n2) else p71.Stack

	if u100 and v511 <= 0 then
		local v512 = p71.InBoothCount or 0

		if not (v512 > 0) and p71.FinisherUntradeable ~= true then
			v504:destroy()
			n1 -= 1

			return
		end

		if v512 > 0 then
			v511 = v512
			parent:SetAttribute("InBoothOnly", true)
		else
			v511 = p71.Stack or 1
			parent:SetAttribute("FinisherLocked", true)
		end

		local inBoothDim: Frame = Instance.new("Frame")

		inBoothDim.Name = "InBoothDim"
		inBoothDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		inBoothDim.BackgroundTransparency = 0.3
		inBoothDim.BorderSizePixel = 0
		inBoothDim.Size = UDim2.new(1, 0, 1, 0)
		inBoothDim.ZIndex = parent.ZIndex + 4

		local uiCorner = parent:FindFirstChildOfClass("UICorner")

		if uiCorner then
			local clone = uiCorner:Clone()

			clone.Parent = inBoothDim
		end

		inBoothDim.Parent = parent
	end

	v504:setStackCount(v511)

	if u100 and s3 == "Booth" and parent:GetAttribute("InBoothOnly") ~= true and parent:GetAttribute("FinisherLocked") ~= true then
		local v516 = t14.shopBlock(p71)

		if v516 ~= nil then
			parent:SetAttribute("InShop", v516)

			if parent:FindFirstChild("BoothHoldTag") == nil then
				t14.addTag(parent, p71)
			end
		end
	end

	v504:setEquipped(p71.IsEquipped)

	if p71.IsEquipped then
		v504:setEquippedStyle(true)
	end

	v504:setFinisher(p71.Finisher)
	n2 = p71.Unseen == true and not u29
	v511 = p71.UnseenCount or 0

	if n2 then
		if p71.Kind == "Crate" and p71.CrateId then
			t7[p71.CrateId] = v511
		elseif p71.InstanceIds then
			local v517 = math.max(1, v511)

			for i = 1, math.min(v517, #p71.InstanceIds) do
				t6[p71.InstanceIds[i]] = true
			end
		end
	end

	v504:setAlert(n2, if n2 and v511 > 1 then v511 else nil)

	local v519 = hoverInfoModule.bind(v85, parent, function()
		if u144 then
			return nil
		end

		local t24: {[any]: any} = {
			Name = p71.Name,
			Rarity = p71.Rarity,
			GlobalCopies = p71.GlobalCopies,
			Serial = p71.Serial,
			MaxSupply = p71.MaxSupply,
			SourceButton = parent,
			FinisherName = p71.FinisherName,
			FinisherIcon = p71.FinisherIcon,
			FinisherRarity = p71.FinisherRarity,
			Kind = p71.Kind,
			ItemId = p71.ItemId,
			Note = if parent:GetAttribute("InBoothOnly") == true then "In your booth" else if parent:GetAttribute("FinisherLocked") == true then "Exclusive finisher attached" else if parent:GetAttribute("InShop") == nil then if t14.note(p71) == nil then if p71.Soulbound == nil then nil else ("%s %s taken with %s"):format(tostring(p71.SoulKills or 0):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""), if p71.SoulKills == 1 then "soul" else "souls", p71.SoulboundName or "its Soulbound finisher") else t14.note(p71) else t14.shopNote(p71, parent:GetAttribute("InShop"))
		}
		local v685

		if parent:GetAttribute("InBoothOnly") == true then
			v685 = t14.IN_BOOTH_ICON
		elseif parent:GetAttribute("FinisherLocked") == true then
			v685 = p71.FinisherIcon
		elseif parent:GetAttribute("InShop") == nil then
			v685 = if t14.note(p71) == nil then nil else t14.ICON
		else
			v685 = t14.ICON
		end

		t24.NoteIcon = v685

		return t24
	end, function()
		if p71.Unseen and not u29 then
			p71.Unseen = false
			v504:setAlert(false)

			if p71.Kind == "Crate" and p71.CrateId then
				local crateId = p71.CrateId

				if t7[crateId] then
					t7[crateId] = nil
					table.insert(t13, crateId)
				end

				updateLobbyBadge()
				updateNavAlerts()

				if #t13 > 0 and not u94 then
					u94 = true
					task.delay(0.5, flushMarkSeen)

					return
				end
			elseif p71.InstanceIds then
				markInstanceSeen(p71.InstanceIds)
			end

			return
		end
	end)

	local t20: {[any]: any} = { cell = parent, api = v504, item = p71 }

	t14.applyProjected(t20)
	parent.MouseButton1Click:Connect(function()
		if v519.tapConsumed() then
			return
		end

		if u144 then
			return
		end

		if p71.Unseen and not u29 then
			p71.Unseen = false
			v504:setAlert(false)

			if p71.Kind == "Crate" and p71.CrateId then
				local crateId = p71.CrateId

				if t7[crateId] then
					t7[crateId] = nil
					table.insert(t13, crateId)
				end

				updateLobbyBadge()
				updateNavAlerts()

				if #t13 > 0 and not u94 then
					u94 = true
					task.delay(0.5, flushMarkSeen)
				end
			elseif p71.InstanceIds then
				markInstanceSeen(p71.InstanceIds)
			end
		end

		selectItem(t20)
	end)

	if u144 then
		parent.Active = false
	end

	table.insert(t11, t20)
end
local function u179(p72)
	s1 = p72
	table.clear(t6)

	local u522: boolean = false
	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject then
		for _, v in ipairs(t11) do
			if guiServiceSelectedObject == v.cell then
				u522 = true

				break
			end
		end
	end

	local v526 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]

	if not v526 then
		clearRendered()
		u155()

		if u522 then
			guiService.SelectedObject = nil
		end

		updateLobbyBadge()
		updateNavAlerts()

		return
	end

	table.clear(t7)

	if not u29 then
		for _, v in ipairs(v526.Items or {}) do
			if v.Unseen == true then
				if v.Kind == "Crate" and v.CrateId then
					t7[v.CrateId] = v.UnseenCount or 1
				elseif v.InstanceIds then
					local v529 = math.max(1, v.UnseenCount or 1)

					for i = 1, math.min(v529, #v.InstanceIds) do
						t6[v.InstanceIds[i]] = true
					end
				end
			end
		end
	end

	rebuildCrateLookup(v526)

	local v531 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]
	local n2 = 0

	if v531 and v531.Items then
		for _, v in ipairs(v531.Items) do
			n2 += v.Stack
		end
	end

	itemLimitIndicator.Text = ("%d/2000 Items"):format(n2)

	local kind = u107 and u107.Kind
	local v536 = u107

	if v536 then
		v536 = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
	end

	local finisher = u107 and u107.Finisher

	clearRendered()
	u155()

	local t21: {[any]: any} = {}

	for _, v in ipairs(v526.Items or {}) do
		if u102 then
			local u541

			if v.Kind == "Knife" then
				u541 = true

				if v.Finisher ~= nil then
					u541 = true

					if v.Finisher ~= "" then
						u541 = false

						if v.Soulbound ~= nil then
							u541 = v.Finisher == v.Soulbound
						end
					end
				end
			else
				u541 = false

				if v.Kind == "Revolver" then
					u541 = true

					if v.Finisher ~= nil then
						u541 = true

						if v.Finisher ~= "" then
							u541 = false

							if v.Soulbound ~= nil then
								u541 = v.Finisher == v.Soulbound
							end
						end
					end
				end
			end

			if u541 and (if s2 == "" then true else string.find(string.lower(v.Name), string.lower(s2), 1, true) ~= nil) then
				table.insert(t21, v)
			end
		elseif (if p72 == "All" then true else if p72 == "Knives" then v.Kind == "Knife" else if p72 == "Revolvers" then v.Kind == "Revolver" else if p72 == "Crates" then v.Kind == "Crate" else if p72 == "Finishers" then v.Kind == "Finisher" else if p72 == "Emotes" then v.Kind == "Emote" else true) and (if s2 == "" then true else string.find(string.lower(v.Name), string.lower(s2), 1, true) ~= nil) then
			table.insert(t21, v)
		end
	end

	local t22: {[any]: any} = { Knife = 1, Revolver = 2, Crate = 3, Finisher = 4, Emote = 5 }

	table.sort(t21, function(p73, p74)
		local v690 = p73.IsEquipped and p73.Kind ~= "Emote"

		if v690 ~= (p74.IsEquipped and p74.Kind ~= "Emote") then
			return v690
		end

		local v691 = rarity.Order[p73.Rarity] or 0

		v690 = rarity.Order[p74.Rarity] or 0

		if v691 ~= v690 then
			return v690 < v691
		end

		v691 = t22[p73.Kind] or 99
		v690 = t22[p74.Kind] or 99

		if v691 ~= v690 then
			return v690 > v691
		end

		if p73.Name ~= p74.Name then
			return p73.Name < p74.Name
		end

		return (p74.FinisherRarity and rarity.Order[p74.FinisherRarity] or 0) < (p73.FinisherRarity and rarity.Order[p73.FinisherRarity] or 0)
	end)

	for _, v in ipairs(t21) do
		renderItem(v)
	end

	for i = n1 + 1, #t3 do
		local v546 = t3[i]

		if v546 and v546.Parent then
			v546.Visible = false
		end
	end

	if u102 then
		if u103 then
			updateFiltersPanel(u103)
		else
			filters.Visible = false
		end

		if u522 then
			guiService.SelectedObject = if #t11 > 0 then t11[1].cell else nil
		end

		updateLobbyBadge()
		updateNavAlerts()

		return
	end

	local v547 = nil

	if Kind and ItemId then
		for _, v in ipairs(t11) do
			local vItem = v.item

			if vItem.Kind == Kind and (if vItem.Kind == "Crate" then vItem.CrateId else vItem.ItemId) == ItemId then
				v547 = v

				break
			end
		end

		Kind = nil
		ItemId = nil
	elseif kind and v536 then
		for _, v in ipairs(t11) do
			local v553 = v.item

			if kind == v553.Kind and (if v553.Kind == "Crate" then v553.CrateId else v553.ItemId) == v536 and finisher == v553.Finisher then
				v547 = v

				break
			end
		end
	end

	if v547 then
		u107 = v547.item
		u109 = v547.cell
		u110 = v547.api
		v547.api:setSelected(true)
		updateFiltersPanel(v547.item)
	elseif #t11 > 0 then
		local v554 = t11[1]

		u107 = v554.item
		u109 = v554.cell
		u110 = v554.api
		v554.api:setSelected(true)
		updateFiltersPanel(v554.item)
	else
		filters.Visible = false
	end

	if u522 then
		if v547 then
			guiService.SelectedObject = v547.cell
		elseif #t11 > 0 then
			guiService.SelectedObject = t11[1].cell
		else
			guiService.SelectedObject = nil
		end
	end

	updateLobbyBadge()
	updateNavAlerts()
end
local function optimisticSetEquipped(p75, p76)
	if u107 then
		Kind = u107.Kind
		ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
	end

	patchEquippedInCache(p75, p76)
	u179(s1)
end

local u181 = nil
local color3 = Color3.new(1, 1, 1)
local color32 = Color3.fromRGB(134, 134, 134)

local function setNavActive(p77, p78)
	local v559 = if p78 then color3 else color32
	local imageLabel = p77:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.ImageColor3 = v559
	end

	local textLabel = p77:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.TextColor3 = v559
	end
end;

(function()
	local openXButton: Instance = filters:FindFirstChild("OpenXButton")

	if not openXButton or not openXButton:IsA("GuiButton") then
		return
	end

	openXButton.MouseButton1Click:Connect(function()
		if not not u144 or not openXButton.Visible then
			return
		end

		local v692 = u107

		if not v692 or v692.Kind ~= "Crate" or not v692.CrateId then
			return
		end

		if LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") ~= false then
			return
		end

		if spinner.Enabled then
			return
		end

		local crateId = v692.CrateId
		local v694 = math.min(v692.Stack or 1, 10)

		if v694 < 2 then
			return
		end

		u144 = true

		local v695, v696, v697, v698 = pcall(function()
			return inventory:InvokeServer("OpenCrateMulti", { CrateId = crateId, Count = v694 })
		end)

		u144 = false

		if v695 and v696 == true and typeof(v698) == "table" and #v698 ~= 0 then
			sound:Play("Misc.RollOpening", workspace)

			local v699 = t10[crateId]
			local u700 = math.max(0, (v692.Stack or 1) - #v698)
			local openCrateMulti: Instance = replicatedStorage:WaitForChild("Bindables"):FindFirstChild("OpenCrateMulti")

			if openCrateMulti and openCrateMulti:IsA("BindableEvent") then
				openCrateMulti:Fire({
					CrateId = crateId,
					CrateName = v699 and v699.Name or crateId,
					RarityOdds = v699 and v699.RarityOdds or {},
					PublicPools = v699 and v699.PublicPools or {},
					Rewards = v698,
					Count = v694,
					GetRemaining = function()
						return u700
					end,
					RequestMore = function(p79)
						local v749, v750, v751 = inventory:InvokeServer("OpenCrateMulti", { CrateId = crateId, Count = p79 })

						if v749 == true and typeof(v751) == "table" then
							u700 = math.max(0, u700 - #v751)
						end

						return v749, v750, v751
					end
				})
			end

			windowBlur.hide("LobbyPanel")
			inventoryWindow.Visible = false

			return
		end

		warn("[InventoryUI] OpenCrateMulti failed", if v695 then v697 else v696)
	end)
end)()
equipButton.MouseButton1Click:Connect(function()
	if u144 then
		return
	end

	if u102 then
		u157()

		return
	end

	local v563 = u107

	if not v563 then
		return
	end

	if v563.Kind == "Finisher" then
		u156(v563)

		return
	end

	if v563.Kind == "Emote" then
		local instanceIds = v563.InstanceIds
		local v565 = instanceIds and instanceIds[1] or v563.InstanceId
		local emoteAssign: Instance = replicatedStorage:WaitForChild("Bindables"):FindFirstChild("EmoteAssign")

		if v565 and emoteAssign and emoteAssign:IsA("BindableEvent") then
			emoteAssign:Fire({ InstanceId = v565, ItemId = v563.ItemId, Name = v563.Name })
		end

		return
	end

	if v563.Kind == "Crate" then
		local crateId = v563.CrateId

		if not crateId then
			return
		end

		u144 = true

		local v568, v569 = serverOpenCrate(crateId)

		u144 = false

		if not v568 then
			warn("[InventoryUI] OpenCrate failed", v569)
		end

		return
	end

	local v570 = v563.InstanceIds
	local v571 = v570 and v570[1] or v563.InstanceId

	if not v571 then
		return
	end

	local kind = v563.Kind
	local v573 = getEquippedInstanceIdFromCache(kind)
	local u574

	if v563.IsEquipped then
		local v575 = t2[kind]

		if not v575 then
			u574 = nil
		else
			u574 = getFirstInstanceIdByItemId(kind, v575)
		end
	else
		u574 = v571
	end

	if u107 then
		Kind = u107.Kind
		ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
	end

	patchEquippedInCache(kind, u574)
	u179(s1)
	task.spawn(function()
		if u574 == nil then
			local v702 = kind

			local v703, v704, v705 = pcall(function()
				return inventory:InvokeServer("Unequip", { Kind = v702 })
			end)

			local u707

			if not v703 then
				u707 = false
			else
				u707 = v704 == true
			end

			if not u707 then
				if u107 then
					Kind = u107.Kind
					ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
				end

				patchEquippedInCache(kind, v573)
				u179(s1)

				return
			end
		else
			local v708 = kind
			local v709 = u574

			local v710, v711, v712 = pcall(function()
				return inventory:InvokeServer("Equip", { Kind = v708, InstanceId = v709 })
			end)

			local u714

			if not v710 then
				u714 = false
			else
				u714 = v711 == true
			end

			if not u714 then
				if u107 then
					Kind = u107.Kind
					ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
				end

				patchEquippedInCache(kind, v573)
				u179(s1)
			end
		end
	end)
end)
unequipButton.MouseButton1Click:Connect(function()
	local v576 = u107

	if v576 and v576.Kind == "Emote" then
		local numberValue: number? = tonumber(v576.EmoteSlot)

		if numberValue then
			task.spawn(function()
				local shared: Instance = replicatedStorage:WaitForChild("Shared")

				require(shared:WaitForChild("EmoteClient")).Unequip(numberValue)
			end)
		end

		return
	end

	if u144 then
		return
	end

	v576 = u107

	if not v576 then
		return
	end

	if (not v576.InstanceIds or not v576.InstanceIds[1]) and not v576.InstanceId then
		return
	end

	local kind = v576.Kind
	local v579 = getEquippedInstanceIdFromCache(kind)
	local v580 = t2[kind]

	v576 = if not v580 then nil else getFirstInstanceIdByItemId(kind, v580)

	if u107 then
		Kind = u107.Kind
		ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
	end

	patchEquippedInCache(kind, v576)
	u179(s1)
	task.spawn(function()
		local v716 = kind

		local v717, v718, v719 = pcall(function()
			return inventory:InvokeServer("Unequip", { Kind = v716 })
		end)

		local u721

		if not v717 then
			u721 = false
		else
			u721 = v718 == true
		end

		if not u721 then
			if u107 then
				Kind = u107.Kind
				ItemId = if u107.Kind == "Crate" then u107.CrateId else u107.ItemId
			end

			patchEquippedInCache(kind, v579)
			u179(s1)
		end
	end)
end)
deleteButton.MouseButton1Click:Connect(function()
	if u144 then
		return
	end

	if not u107 then
		return
	end

	local v581 = u107
	local v582 = t2[v581.Kind]

	if v582 ~= nil and v582 == v581.ItemId then
		return
	end

	if u107.Serial == nil then
		if u107.Undeletable == true then
			local _GNotify = _G.Notify

			if typeof(_GNotify) == "function" then
				pcall(function()
					_GNotify({
						notifType = "FailNotification",
						topText = "Can't Delete",
						errorMessage = "That item can't be deleted."
					})
				end)
			end

			return
		end

		if deleteContainer.Visible then
			u149()

			return
		end

		openDeleteContainer(u107)

		return
	end

	local notify = _G.Notify

	if typeof(notify) == "function" then
		pcall(function()
			notify({
				notifType = "FailNotification",
				topText = "Can't Delete",
				errorMessage = "Collectible items cannot be deleted."
			})
		end)
	end
end)

local function pushFail(p80)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify({ notifType = "FailNotification", errorMessage = p80 })
		end)
	end
end
local function friendlyFinisherError(p81)
	if p81 == "CollectibleFinisherLocked" then
		return "Cannot take finishers off of collectibles!"
	end

	if p81 == "SoulboundFinisherLocked" then
		return "Soulbound finishers can't be removed. Apply another finisher over it instead."
	end

	if p81 == "WeaponHasFinisher" then
		return "That weapon already has a finisher."
	end

	if p81 == "NoCash" then
		return "Not enough coins to detach that finisher."
	end

	if p81 == "InventoryFull" then
		return "Your inventory is full."
	end

	if p81 == "NoFinisher" then
		return "That weapon has no finisher to remove."
	end

	if p81 == "WeaponNotOwned" or p81 == "FinisherNotOwned" then
		return "You don't own that item."
	end

	if p81 == "ListedInBooth" then
		return "That item is listed in your booth. Unlist it first."
	end

	return "Something went wrong. Please try again."
end
local function notifyFinisherError(p82)
	local s1: string = if p82 == "CollectibleFinisherLocked" then "Cannot take finishers off of collectibles!" else if p82 == "SoulboundFinisherLocked" then "Soulbound finishers can't be removed. Apply another finisher over it instead." else if p82 == "WeaponHasFinisher" then "That weapon already has a finisher." else if p82 == "NoCash" then "Not enough coins to detach that finisher." else if p82 == "InventoryFull" then "Your inventory is full." else if p82 == "NoFinisher" then "That weapon has no finisher to remove." else if p82 == "WeaponNotOwned" or p82 == "FinisherNotOwned" then "You don't own that item." else if p82 == "ListedInBooth" then "That item is listed in your booth. Unlist it first." else "Something went wrong. Please try again."
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify({ notifType = "FailNotification", errorMessage = s1 })
		end)
	end
end
local function setDialogButtonText(p83, text)
	local textLabel = p83:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel3 = textLabel:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.Text = text
		end
	end
end

local t16: {[any]: any} = {}

local function setDialogCell(p85, p86, p87, p88, p89)
	local foundChild = p86:FindFirstChild(if p87 == "left" then "LegendaryCell" else "RareCell")

	if not foundChild or not foundChild:IsA("GuiObject") then
		return
	end

	foundChild.Visible = false

	local t23 = t16[p85]

	if not t23 then
		t23 = {}
		t16[p85] = t23
	end

	local v602 = t23[p87]

	if v602 then
		pcall(function()
			v602:destroy()
		end)
		t23[p87] = nil
	end

	local parent, v604 = uiFramework.createItemCell(p89 or "Common", {
		interactable = false,
		selectable = false,
		active = false,
		parent = p86,
		name = if p87 == "left" then "DynFinisherCell" else "DynWeaponCell",
		size = foundChild.Size,
		position = foundChild.Position,
		anchorPoint = foundChild.AnchorPoint,
		layoutOrder = if p87 == "left" then -1 else 999
	})
	local icon = parent:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.Image = p88 or ""
	end

	local v606 = p87 == "left" and foundChild:FindFirstChild("ImageLabel")

	if v606 and v606:IsA("ImageLabel") then
		local clone = v606:Clone()

		clone.Parent = parent
	end

	t23[p87] = v604
end
local function setDialogIcons(p90, p91, p92, p93, p94)
	local winstreakStat = p90:FindFirstChild("WinstreakStat")

	if not winstreakStat then
		return
	end

	setDialogCell(p90, winstreakStat, "left", p91, p92)
	setDialogCell(p90, winstreakStat, "right", p93, p94)
end

v31 = function()
	u104 = nil
	applyFinisher.Visible = false
	setInventoryInteractable(true)
end
u158 = function(p95, p96)
	u104 = { finisher = p95, weapon = p96 }
	headerTextLabel.Text = "Apply Finisher?"
	winText.Text = string.format("Put %s on your %s? You can detach it later for $%d.", p95.Name, p96.Name, finisherConfig.RemoveCost)

	local textLabel: Instance = apply:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = "Apply"

		local textLabel4: Instance = textLabel:FindFirstChild("TextLabel")

		if textLabel4 and textLabel4:IsA("TextLabel") then
			textLabel4.Text = "Apply"
		end
	end

	local v618: Instance = applyFinisher
	local icon = p95.Icon
	local rarity = p95.Rarity
	local v621 = p96.Icon
	local v622 = p96.Rarity
	local winstreakStat: Instance = v618:FindFirstChild("WinstreakStat")

	if winstreakStat then
		setDialogCell(v618, winstreakStat, "left", icon, rarity)
		setDialogCell(v618, winstreakStat, "right", v621, v622)
	end

	applyFinisher.Visible = true
	setInventoryInteractable(false)
end
apply.MouseButton1Click:Connect(function()
	local v624 = u104

	if not v624 then
		return
	end

	local finisher = v624.finisher
	local weapon = v624.weapon

	u104 = nil
	applyFinisher.Visible = false
	u102 = false
	u103 = nil
	setInventoryInteractable(true)

	local finisherInstanceIds = finisher.InstanceIds
	local v628 = finisherInstanceIds and finisherInstanceIds[1] or finisher.InstanceId
	local weaponInstanceIds = weapon.InstanceIds
	local v630 = weaponInstanceIds and weaponInstanceIds[1] or weapon.InstanceId

	if v628 and v630 then
		Kind = weapon.Kind
		ItemId = weapon.ItemId
		task.spawn(function()
			local v722 = v628
			local weaponKind = weapon.Kind
			local v724 = v630

			local v725, v726, v727 = pcall(function()
				return inventory:InvokeServer("ApplyFinisher", {
					FinisherInstanceId = v722,
					WeaponKind = weaponKind,
					WeaponInstanceId = v724
				})
			end)

			local u728
			local s1

			if not v725 then
				u728 = false
				s1 = "InvokeFailed"
			else
				u728 = v726 == true
				s1 = v727
			end

			if u728 then
				sound:Play("UI.FinisherApply", workspace)
			else
				local s2: string = if s1 == "CollectibleFinisherLocked" then "Cannot take finishers off of collectibles!" else if s1 == "SoulboundFinisherLocked" then "Soulbound finishers can't be removed. Apply another finisher over it instead." else if s1 == "WeaponHasFinisher" then "That weapon already has a finisher." else if s1 == "NoCash" then "Not enough coins to detach that finisher." else if s1 == "InventoryFull" then "Your inventory is full." else if s1 == "NoFinisher" then "That weapon has no finisher to remove." else if s1 == "WeaponNotOwned" or s1 == "FinisherNotOwned" then "You don't own that item." else if s1 == "ListedInBooth" then "That item is listed in your booth. Unlist it first." else "Something went wrong. Please try again."
				local _GNotify = _G.Notify

				if typeof(_GNotify) == "function" then
					pcall(function()
						_GNotify({ notifType = "FailNotification", errorMessage = s2 })
					end)
				end
			end

			u154()
		end)
		u179(s1)

		return
	end

	u179(s1)
end)
v65.MouseButton1Click:Connect(v31)
applyFinisherCloseButton.MouseButton1Click:Connect(v31)
v31 = function()
	u105 = nil
	detachFinisher.Visible = false
	setInventoryInteractable(true)
end
u159 = function(p97)
	u105 = p97
	detachFinisherHeaderTextLabel.Text = "Detach Finisher?"
	detachFinisherWinText.Text = string.format("Remove %s from your %s? It returns to your inventory.", p97.FinisherName or "this finisher", p97.Name)

	local text: string = "$" .. tostring(finisherConfig.RemoveCost)
	local textLabel: Instance = priceButton:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel5: Instance = textLabel:FindFirstChild("TextLabel")

		if textLabel5 and textLabel5:IsA("TextLabel") then
			textLabel5.Text = text
		end
	end

	local v635: Instance = detachFinisher
	local finisherIcon = p97.FinisherIcon
	local finisherRarity = p97.FinisherRarity
	local icon = p97.Icon
	local rarity = p97.Rarity
	local winstreakStat: Instance = v635:FindFirstChild("WinstreakStat")

	if winstreakStat then
		setDialogCell(v635, winstreakStat, "left", finisherIcon, finisherRarity)
		setDialogCell(v635, winstreakStat, "right", icon, rarity)
	end

	detachFinisher.Visible = true
	setInventoryInteractable(false)
end
priceButton.MouseButton1Click:Connect(function()
	local v641 = u105

	if not v641 then
		return
	end

	u105 = nil
	detachFinisher.Visible = false
	setInventoryInteractable(true)

	local instanceIds = v641.InstanceIds
	local v643 = instanceIds and instanceIds[1] or v641.InstanceId

	if not v643 then
		u179(s1)

		return
	end

	Kind = v641.Kind
	ItemId = v641.ItemId
	task.spawn(function()
		local kind = v641.Kind
		local v733 = v643

		local v734, v735, v736 = pcall(function()
			return inventory:InvokeServer("RemoveFinisher", { WeaponKind = kind, WeaponInstanceId = v733 })
		end)

		local u737
		local s1

		if not v734 then
			u737 = false
			s1 = "InvokeFailed"
		else
			u737 = v735 == true
			s1 = v736
		end

		if u737 then
			sound:Play("UI.FinisherDetach", workspace)
		else
			local s2: string = if s1 == "CollectibleFinisherLocked" then "Cannot take finishers off of collectibles!" else if s1 == "SoulboundFinisherLocked" then "Soulbound finishers can't be removed. Apply another finisher over it instead." else if s1 == "WeaponHasFinisher" then "That weapon already has a finisher." else if s1 == "NoCash" then "Not enough coins to detach that finisher." else if s1 == "InventoryFull" then "Your inventory is full." else if s1 == "NoFinisher" then "That weapon has no finisher to remove." else if s1 == "WeaponNotOwned" or s1 == "FinisherNotOwned" then "You don't own that item." else if s1 == "ListedInBooth" then "That item is listed in your booth. Unlist it first." else "Something went wrong. Please try again."
			local _GNotify = _G.Notify

			if typeof(_GNotify) == "function" then
				pcall(function()
					_GNotify({ notifType = "FailNotification", errorMessage = s2 })
				end)
			end
		end

		u154()
	end)
	u179(s1)
end)
cancel.MouseButton1Click:Connect(v31)
detachFinisherCloseButton.MouseButton1Click:Connect(v31)
u156 = function(p98)
	local v645 = if UserId == nil or UserId == LocalPlayer.UserId then u97 else t9[UserId]
	local u646: boolean = false

	if v645 then
		for _, v in ipairs(v645.Items or {}) do
			if (v.Kind == "Knife" or v.Kind == "Revolver") and (v.Finisher == nil or v.Finisher == "" or v.Soulbound ~= nil and v.Finisher == v.Soulbound) then
				u646 = true

				break
			end
		end
	end

	if not u646 then
		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			local s2: string = "No eligible weapons — all your weapons already have a finisher."

			pcall(function()
				_GNotify({ notifType = "FailNotification", errorMessage = s2 })
			end)
		end

		return
	end

	u103 = p98
	u102 = true
	tabHeader.Text = "Select a weapon"
	u179(s1)
end
u157 = function()
	if not u102 then
		return
	end

	u102 = false
	u103 = nil
	u104 = nil

	if u181 then
		tabHeader.Text = t5[u181.Name] or u181.Name
	end

	u179(s1)
end
textBox:GetPropertyChangedSignal("Text"):Connect(function()
	s2 = textBox.Text
	u179(s1)
end)

local u192: boolean = false
local u193: boolean = false

u154 = function()
	if u192 then
		return
	end

	u192 = true
	task.defer(function()
		u192 = false

		if u99 then
			u193 = true

			return
		end

		u99 = true
		task.spawn(function()
			local v752 = fetchSnapshot("All")

			if v752 then
				local v753 = UserId or LocalPlayer.UserId

				if v753 == LocalPlayer.UserId then
					u97 = v752
				else
					t9[v753] = v752
				end

				if inventoryWindow.Visible then
					u179(s1)
				end

				if not u29 then
					table.clear(t6)
					table.clear(t7)

					for _, v in ipairs(v752.Items or {}) do
						if v.Unseen == true then
							if v.Kind == "Crate" and v.CrateId then
								t7[v.CrateId] = v.UnseenCount or 1
							elseif v.InstanceIds then
								local v756 = math.max(1, v.UnseenCount or 1)

								for i = 1, math.min(v756, #v.InstanceIds) do
									t6[v.InstanceIds[i]] = true
								end
							end
						end
					end

					updateLobbyBadge()
					updateNavAlerts()
				end
			end

			u99 = false

			if u193 then
				u193 = false
				u154()
			end
		end)
	end)
end
players.OnClientEvent:Connect(function(player)
	if typeof(player) == "table" and typeof(player.UserId) == "number" and (UserId or LocalPlayer.UserId) ~= player.UserId then
		return
	end

	u154()
end);
(function()
	local soulKillsRev: any = LocalPlayer:GetAttribute("SoulKillsRev")

	inventoryWindow:GetPropertyChangedSignal("Visible"):Connect(function()
		if not inventoryWindow.Visible then
			return
		end

		local soulKillsRev2: any = LocalPlayer:GetAttribute("SoulKillsRev")

		if soulKillsRev2 ~= soulKillsRev then
			soulKillsRev = soulKillsRev2
			u154()
		end
	end)
end)()
openInventoryForTrade.Event:Connect(function(p100)
	u100 = true
	s3 = if typeof(p100) == "table" and typeof(p100.Mode) == "string" then p100.Mode else "Trade"
	t15.maxItems = 10

	if typeof(p100) == "table" and typeof(p100.MaxItems) == "number" and p100.MaxItems == p100.MaxItems then
		local floored = math.floor(p100.MaxItems)

		t15.maxItems = math.max(1, floored)
	end

	UserId = LocalPlayer.UserId
	u29 = false
	inventoryWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	inventoryWindow.Visible = true
	windowBlur.show("InventoryForTrade")
	u154()
end)
tradeReservedChanged.Event:Connect(function(p101)
	if typeof(p101) == "table" then
		t1 = p101
	end
end)
v31 = bindables:FindFirstChild("TradeSessionClosed")

if not v31 or not v31:IsA("BindableEvent") then
	local tradeSessionClosed: BindableEvent = Instance.new("BindableEvent")

	tradeSessionClosed.Name = "TradeSessionClosed"
	tradeSessionClosed.Parent = bindables
	v31 = tradeSessionClosed
end

v31.Event:Connect(function()
	if u100 and inventoryWindow.Visible then
		inventoryWindow.Visible = false
	end
end)
v4.Event:Connect(function(player)
	local v657 = nil

	if typeof(player) == "Instance" and player:IsA("Player") then
		v657 = player.UserId
	elseif typeof(player) == "number" then
		v657 = player
	end

	if not v657 then
		return
	end

	UserId = v657
	u29 = v657 ~= LocalPlayer.UserId
	inventoryWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	inventoryWindow.Visible = true
	windowBlur.show("InventoryForPlayer")
	activeWindowChanged:Fire("InventoryForPlayer")
	u154()
end)
activeWindowChanged.Event:Connect(function(p103)
	if p103 ~= "InventoryForPlayer" and UserId ~= nil and not u100 and inventoryWindow.Visible then
		inventoryWindow.Visible = false
	end
end)
inventoryWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if inventoryWindow.Visible then
		u179(s1)

		return
	end

	local v659: boolean = u100

	u100 = false
	s3 = "Trade"
	u102 = false
	u103 = nil
	u104 = nil
	u105 = nil
	applyFinisher.Visible = false
	detachFinisher.Visible = false
	u149()
	t15.close()
	UserId = nil
	u29 = false
	u155()

	if v659 then
		tradeSelectClosed:Fire()
	end

	windowBlur.hide("InventoryForTrade")
	windowBlur.hide("InventoryForPlayer")
end)
closeButton.MouseButton1Click:Connect(function()
	if u144 then
	elseif u100 or u29 then
		inventoryWindow.Visible = false
		windowBlur.hide("InventoryForTrade")
		windowBlur.hide("InventoryForPlayer")
	end
end);
(function()
	for _, v in ipairs(navigator:GetChildren()) do
		if v:IsA("ImageButton") and t4[v.Name] then
			v.MouseButton1Click:Connect(function()
				if u144 then
					return
				end

				if u102 then
					u157()
				end

				if u181 then
					setNavActive(u181, false)
				end

				u181 = v
				setNavActive(v, true)
				tabHeader.Text = t5[v.Name] or v.Name

				local imageLabel2 = v:FindFirstChild("ImageLabel")

				if imageLabel2 and imageLabel2:IsA("ImageLabel") then
					imageLabel.Image = imageLabel2.Image
				end

				u179(v743)
			end)

			if v.Name == "All" then
				u181 = v
				setNavActive(v, true)
				tabHeader.Text = t5[v.Name] or v.Name

				local imageLabel2 = v:FindFirstChild("ImageLabel")

				if imageLabel2 and imageLabel2:IsA("ImageLabel") then
					imageLabel.Image = imageLabel2.Image
				end
			else
				setNavActive(v, false)
			end
		end
	end
end)()
filters.Visible = false
hoverInfoModule.hide(v85)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	if inventoryWindow.Visible then
		inventoryWindow.Visible = false
	end
end)
task.spawn(function()
	local v663

	while true do
		v663 = fetchSnapshot("All")

		if v663 then
			break
		end

		task.wait()
	end

	u97 = v663
	u179("All")
end)
task.defer(function()
	local emoteFlags: Instance = replicatedStorage:WaitForChild("Shared"):WaitForChild("EmoteFlags")
	local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):FindFirstChild("ShopOpenAnalytics")
	local v666 = uiFramework.createItemCell("Uncommon", {
		icon = "rbxassetid://74537175036926",
		name = "ShopPlusTile",
		visible = false,
		active = true,
		interactable = true,
		selectable = true,
		parent = items
	})

	v666.LayoutOrder = 999999998

	local uiGradient = v666:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local colorSequenceNew = ColorSequence.new
		local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 215, 100))

		uiGradient.Color = colorSequenceNew({
			colorSequenceKeypoint,
			ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 150, 65))
		})
	end

	local spikes = v666:FindFirstChild("Spikes")

	if spikes and spikes:IsA("GuiObject") then
		spikes.Visible = false
	end

	for _, v in ipairs(v666:GetChildren()) do
		if v:IsA("UIStroke") and v.Name ~= "UIStrokeOuter" then
			v.Color = Color3.fromRGB(255, 255, 255)

			for _, iterValue in ipairs(v:GetChildren()) do
				if iterValue:IsA("UIGradient") then
					iterValue:Destroy()
				end
			end
		end
	end

	local icon = v666:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		icon.Size = UDim2.fromScale(0.5, 0.5)
		icon.Position = UDim2.fromScale(0.5, 0.5)
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
	end

	local function sectionFor()
		local v744 = u181

		if not v744 then
		elseif not u100 and not u29 and not u102 then
			if v744.Name == "Cases" then
				return "Cases"
			end

			if v744.Name == "Emotes" and emoteFlags:GetAttribute("EmotesEnabled") == true then
				return "Daily"
			end

			return nil
		end

		return nil
	end
	local function sync()
		local v745 = u181

		v666.Visible = (if not v745 then nil else if not u100 and not u29 and not u102 then if v745.Name == "Cases" then "Cases" else if v745.Name == "Emotes" and emoteFlags:GetAttribute("EmotesEnabled") == true then "Daily" else nil else nil) ~= nil
	end

	tabHeader:GetPropertyChangedSignal("Text"):Connect(sync)
	inventoryWindow:GetPropertyChangedSignal("Visible"):Connect(function()
		task.defer(sync)
	end)
	emoteFlags:GetAttributeChangedSignal("EmotesEnabled"):Connect(sync)

	local v678 = u181

	v666.Visible = (if not v678 then nil else if not u100 and not u29 and not u102 then if v678.Name == "Cases" then "Cases" else if v678.Name == "Emotes" and emoteFlags:GetAttribute("EmotesEnabled") == true then "Daily" else nil else nil) ~= nil
	v666.MouseButton1Click:Connect(function()
		if u144 then
			return
		end

		local v746 = u181
		local v747 = if not v746 then nil else if not u100 and not u29 and not u102 then if v746.Name == "Cases" then "Cases" else if v746.Name == "Emotes" and emoteFlags:GetAttribute("EmotesEnabled") == true then "Daily" else nil else nil

		if not v747 then
			return
		end

		bindables.OpenShop:Fire(v747)

		if shopOpenAnalytics and shopOpenAnalytics:IsA("RemoteEvent") then
			pcall(function()
				shopOpenAnalytics:FireServer("InventoryPlus")
			end)
		end
	end)
end)
