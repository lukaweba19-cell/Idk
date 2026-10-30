-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local guiService: GuiService = game:GetService("GuiService")
local v4: Instance = replicatedStorage:WaitForChild("Shared")

require(v4:WaitForChild("Rarity"))
v4 = replicatedStorage:WaitForChild("Shared")

local windowBlur = require(v4:WaitForChild("WindowBlur"))

v4 = replicatedStorage:WaitForChild("Shared")

local hoverInfoModule = require(v4:WaitForChild("HoverInfoModule"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local sound = require(replicatedStorage:WaitForChild("Sound"))

v4 = replicatedStorage:WaitForChild("Shared")

local tradeQuickChat = require(v4:WaitForChild("TradeQuickChat"))

v4 = replicatedStorage:WaitForChild("Shared")

local tradePublicFlags = require(v4:WaitForChild("TradePublicFlags"))

v4 = replicatedStorage:WaitForChild("Shared")

local boothTheme = require(v4:WaitForChild("BoothTheme"))
local LocalPlayer: Player = players.LocalPlayer

v4 = replicatedStorage:WaitForChild("Remotes")

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local tradeEvent: Instance = v4:WaitForChild("TradeEvent")
local openInventoryForTrade: Instance = bindables:WaitForChild("OpenInventoryForTrade")

v4 = bindables:WaitForChild("AddItemToTrade")

local tradeReservedChanged: Instance = bindables:WaitForChild("TradeReservedChanged")

replicatedStorage = bindables:WaitForChild("TradeSelectClosed")

local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local inspectItem: Instance = bindables:WaitForChild("InspectItem")
local tradeSessionClosed = bindables:FindFirstChild("TradeSessionClosed")
local u20

if tradeSessionClosed and tradeSessionClosed:IsA("BindableEvent") then
	u20 = tradeSessionClosed
else
	local tradeSessionClosed: BindableEvent = Instance.new("BindableEvent")

	tradeSessionClosed.Name = "TradeSessionClosed"
	tradeSessionClosed.Parent = bindables
	u20 = tradeSessionClosed
end

local function notifyFail(p1)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify({ notifType = "FailNotification", errorMessage = p1 })
		end)
	end
end

local trading: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Trading")

tradeSessionClosed = trading:WaitForChild("TradeItems")

local options: Instance = trading:WaitForChild("Options")
local v25 = tradeSessionClosed:WaitForChild("YOU")
local them: Instance = tradeSessionClosed:WaitForChild("THEM")
local yourName: Instance = v25:WaitForChild("YourName")
local traderName: Instance = them:WaitForChild("TraderName")
local status: Instance = v25:WaitForChild("STATUS")
local themStatus: Instance = them:WaitForChild("STATUS")
local avatar: Instance = v25:WaitForChild("Avatar")
local themAvatar: Instance = them:WaitForChild("Avatar")
local color3 = Color3.fromRGB(255, 255, 255)
local color32 = Color3.fromRGB(122, 240, 158)
local limit: Instance = v25:WaitForChild("LIMIT")
local themLimit: Instance = them:WaitForChild("LIMIT")
local accepted: Instance = v25:WaitForChild("Accepted")
local themAccepted: Instance = them:WaitForChild("Accepted")
local items1: Instance = v25:WaitForChild("Items1")
local themItems1: Instance = them:WaitForChild("Items1")
local plus: Instance = items1:WaitForChild("Plus")
local timer: Instance = tradeSessionClosed:WaitForChild("Timer")
local v43: Instance = timer:WaitForChild("TIMER")
local accept: Instance = options:WaitForChild("Accept")
local decline: Instance = options:WaitForChild("Decline")

tradeSessionClosed = trading:WaitForChild("CloseBtn")

local tradeTokensOffer: Instance = v25:WaitForChild("TradeTokensOffer")

v25 = them:WaitForChild("TradeTokensOffer")

local textBox: Instance = tradeTokensOffer:WaitForChild("TextBox")
local v48: Instance = v25:WaitForChild("TextBox")
local acceptTextLabel: Instance = accept:WaitForChild("TextLabel")
local textLabel: Instance = acceptTextLabel:FindFirstChild("TextLabel")
local declineTextLabel: Instance = decline:WaitForChild("TextLabel")
local textLabel2: Instance = declineTextLabel:FindFirstChild("TextLabel")

v25 = trading:WaitForChild("Summary")

local givingValue: Instance = v25:WaitForChild("GivingValue")
local amount: Instance = givingValue:WaitForChild("Amount")
local icon: Instance = givingValue:WaitForChild("Icon")
local u56 = nil
local colorSequence = ColorSequence.new(Color3.new(1, 1, 1))

local function setAmountLook(p2, textColor3)
	local uiGradient = p2:FindFirstChildOfClass("UIGradient")

	if uiGradient and u56 == nil then
		u56 = uiGradient.Color
	end

	if textColor3 then
		p2.TextColor3 = textColor3

		if uiGradient then
			uiGradient.Color = colorSequence

			return
		end
	else
		p2.TextColor3 = Color3.new(1, 1, 1)

		if uiGradient and u56 then
			uiGradient.Color = u56
		end
	end
end

local givingItems: Instance = v25:WaitForChild("GivingItems")
local givingUnpriced: Instance = v25:WaitForChild("GivingUnpriced")
local receivingValue: Instance = v25:WaitForChild("ReceivingValue")
local receivingValueAmount: Instance = receivingValue:WaitForChild("Amount")
local receivingValueIcon: Instance = receivingValue:WaitForChild("Icon")
local receivingItems: Instance = v25:WaitForChild("ReceivingItems")
local receivingUnpriced: Instance = v25:WaitForChild("ReceivingUnpriced")

v25 = function(p4)
	local amount = p4:WaitForChild("Amount")

	p4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local rounded = math.round(p4.AbsoluteSize.Y * 1.26)

		amount.TextSize = math.max(8, rounded)
	end)

	local rounded = math.round(p4.AbsoluteSize.Y * 1.26)

	amount.TextSize = math.max(8, rounded)
end
v25(givingValue)
v25(receivingValue)
v25 = trading:WaitForChild("ChatLayer")

local youBubble = v25:WaitForChild("YouBubble")
local themBubble = v25:WaitForChild("ThemBubble")
local youBubbleAvatar = youBubble:WaitForChild("Avatar")
local themBubbleAvatar = themBubble:WaitForChild("Avatar")
local youBubbleBackgroundColor3 = youBubble.BackgroundColor3
local backgroundColor3 = youBubble:FindFirstChild("Tail").BackgroundColor3
local youBubbleSize = youBubble.Size
local chatBtn: Instance = options:WaitForChild("ChatBtn")
local quickChatTray: Instance = trading:WaitForChild("QuickChatTray")
local wantPicker: Instance = trading:WaitForChild("WantPicker")
local items: Instance = wantPicker:WaitForChild("Items")
local empty: Instance = wantPicker:WaitForChild("Empty")

v25 = wantPicker:WaitForChild("CloseBtn")

local phraseTemplate: Instance = quickChatTray:WaitForChild("PhraseTemplate")

items1.AutomaticCanvasSize = Enum.AutomaticSize.Y
items1.CanvasSize = UDim2.new(0, 0, 0, 0)
themItems1.AutomaticCanvasSize = Enum.AutomaticSize.Y
themItems1.CanvasSize = UDim2.new(0, 0, 0, 0)

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

for _, v in ipairs(items1:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "ItemTemplate" then
		table.insert(t1, v)
	end
end

for _, v in ipairs(themItems1:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "ItemTemplate" then
		table.insert(t2, v)
	end
end

local v85 = hoverInfoModule.create(trading)
local SessionId = nil
local text = nil
local n1 = 10
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local u93: boolean = false
local u94: boolean = false
local n2 = 0
local n3 = 0
local u97: boolean = false
local u98: boolean = false
local u99: boolean = false
local u100 = nil
local u101: boolean = false
local t7: {[any]: any} = {}
local n4: number = 0
local u104: boolean = false
local u105: boolean = false

local function showTradeBlur()
	if u105 then
		return
	end

	u105 = true
	windowBlur.show("Trade")
end
local function hideTradeBlur()
	if not u105 then
		return
	end

	u105 = false
	windowBlur.hide("Trade")
end

local t8: {[any]: any} = {}
local t9: {[any]: any} = {}
local t10: {[any]: any} = {}

local function tradeKey(p5, p6, p7, p8)
	local s1: string = p5 .. ":" .. p6 .. ":" .. (p7 or "none")

	if p8 == nil then
		return s1
	end

	local text: string = tostring(p8)

	return s1 .. ":#" .. text
end
local function rebuildReservedFromMyOffer()
	table.clear(t10)

	for _, v in pairs(t3) do
		local vSerial = v.Serial
		local s1: string = v.Kind .. ":" .. v.ItemId .. ":" .. (v.Finisher or "none")
		local s2: string = if vSerial == nil then s1 else s1 .. ":#" .. tostring(vSerial)

		t10[s2] = (t10[s2] or 0) + (v.Count or 0)
	end
end
local function offerTotal(p9)
	local n1 = 0

	for _, v in pairs(p9) do
		n1 += v.Count
	end

	return n1
end
local function shouldShowAdd()
	if u98 then
		return false
	end

	if u93 then
		return false
	end

	local n2 = 0

	for _, v in pairs(t3) do
		n2 += v.Count
	end

	return n2 < n1
end
local function setAcceptBtnText(text)
	acceptTextLabel.Text = text

	if textLabel then
		textLabel.Text = text
	end
end
local function setDeclineBtnText(text)
	declineTextLabel.Text = text

	if textLabel2 then
		textLabel2.Text = text
	end
end
local function setStatusLook(p12, enabled)
	local enableDeciding = p12:FindFirstChild("EnableDeciding")
	local enableAccepted = p12:FindFirstChild("EnableAccepted")

	if enableDeciding then
		enableDeciding.Enabled = not enabled
	end

	if enableAccepted then
		enableAccepted.Enabled = enabled
	end

	p12.Text = if enabled then "ACCEPTED" else "WAITING..."
end
local function setReadyUI()
	accepted.Visible = u93
	themAccepted.Visible = u94

	local v200 = status
	local v201: boolean = u93
	local enableDeciding: Instance = v200:FindFirstChild("EnableDeciding")
	local enableAccepted: Instance = v200:FindFirstChild("EnableAccepted")

	if enableDeciding then
		enableDeciding.Enabled = not v201
	end

	if enableAccepted then
		enableAccepted.Enabled = v201
	end

	v200.Text = if v201 then "ACCEPTED" else "WAITING..."
	v200 = themStatus
	v201 = u94

	local enableDeciding2: Instance = v200:FindFirstChild("EnableDeciding")
	local enableAccepted2: Instance = v200:FindFirstChild("EnableAccepted")

	if enableDeciding2 then
		enableDeciding2.Enabled = not v201
	end

	if enableAccepted2 then
		enableAccepted2.Enabled = v201
	end

	v200.Text = if v201 then "ACCEPTED" else "WAITING..."
	yourName.TextColor3 = if u93 then color32 else color3
	traderName.TextColor3 = if u94 then color32 else color3
	accept.Active = not u93
	accept.Interactable = not u93
	accept.Visible = not u93
	acceptTextLabel.Text = "Accept"

	if textLabel then
		textLabel.Text = "Accept"
	end

	decline.Active = true
	decline.Interactable = true
	v200 = if u93 then "Cancel" else "Decline"
	declineTextLabel.Text = v200

	if textLabel2 then
		textLabel2.Text = v200
	end
end
local function syncOrder(p14, p15)
	local t14: {[any]: any} = {}

	for _, v in ipairs(p14) do
		if p15[v] then
			table.insert(t14, v)
		end
	end

	for iterKey in pairs(p15) do
		local u212: boolean = false

		for _, v in ipairs(t14) do
			if v == iterKey then
				u212 = true

				break
			end
		end

		if not u212 then
			table.insert(t14, iterKey)
		end
	end

	return t14
end
local function clearRendered(p16)
	for _, v in ipairs(p16) do
		v.api:destroy()
	end

	table.clear(p16)
end
local function renderOffer(p17, p18, p19, p20, p21, p22, p23)
	clearRendered(p21)
	p23.idx = 0

	local n1: number = 0

	for _, v in ipairs(p19) do
		local v228 = p18[v]

		if v228 then
			n1 += 1

			local t15 = v228.Meta or {}
			local v230 = typeof(t15.Rarity) == "string" and t15.Rarity or "Common"
			local v231 = if typeof(t15.Icon) == "string" then t15.Icon else nil

			p23.idx = p23.idx + 1

			local v232 = p22[p23.idx]

			if v232 and not v232.Parent then
				v232 = nil
			end

			local v233, v234 = uiFramework.createItemCell(v230, {
				visible = true,
				active = true,
				selectable = true,
				icon = v231,
				name = "TradeItem_" .. v,
				replaces = v232,
				parent = if not v232 then p17 else nil,
				layoutOrder = n1
			})
			local typeName: string = typeof(t15.Finisher)

			v234:setFinisher(if typeName == "string" then t15.Finisher else nil)
			v234:setStackCount(v228.Count or 1)

			local v236 = typeof(t15.Name) == "string" and t15.Name or v228.ItemId
			local u237 = nil

			v233.MouseButton1Click:Connect(function()
				if u237 ~= nil and u237.tapConsumed() then
					return
				end

				hoverInfoModule.hide(v85)

				if p20 and not u93 then
					tradeEvent:FireServer("RemoveItem", v, v228.Count or 1)
				elseif v228.Kind == "Knife" or v228.Kind == "Revolver" then
					if typeof(v228.InspectInstanceId) == "string" then
						inspectItem:Fire({
							Kind = v228.Kind,
							ItemId = v228.ItemId,
							Name = v236,
							Rarity = v230,
							GlobalCopies = t15.GlobalCopies,
							Serial = v228.Serial,
							MaxSupply = t15.MaxSupply
						})

						return
					end
				elseif v228.Kind == "Finisher" then
					inspectItem:Fire({ Kind = "Finisher", ItemId = v228.ItemId, Name = v236, Rarity = v230 })
				end
			end)
			u237 = hoverInfoModule.bind(v85, v233, function()
				return {
					Name = v236,
					Rarity = v230,
					GlobalCopies = if typeof(t15.GlobalCopies) == "number" then t15.GlobalCopies else nil,
					Serial = if typeof(v228.Serial) == "number" then v228.Serial else nil,
					MaxSupply = if typeof(t15.MaxSupply) == "number" then t15.MaxSupply else nil,
					SourceButton = v233,
					FinisherName = if typeof(t15.FinisherName) == "string" then t15.FinisherName else nil,
					FinisherIcon = if typeof(t15.FinisherIcon) == "string" then t15.FinisherIcon else nil,
					FinisherRarity = if typeof(t15.FinisherRarity) == "string" then t15.FinisherRarity else nil,
					Kind = v228.Kind,
					ItemId = v228.ItemId
				}
			end)
			table.insert(p21, { cell = v233, api = v234, itemKey = v })
		end
	end

	for i = p23.idx + 1, #p22 do
		local v239 = p22[i]

		if v239 and v239.Parent then
			v239.Visible = false
		end
	end
end

local t11: {[any]: any} = { idx = 0 }
local t12: {[any]: any} = { idx = 0 }

local function refreshNames()
	yourName.Text = LocalPlayer.DisplayName .. "'s Offer"

	local localPlayerUserId = LocalPlayer.UserId

	youBubbleAvatar.Image = if localPlayerUserId <= 0 then "" else ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(localPlayerUserId)
	avatar.Image = youBubbleAvatar.Image

	if text then
		local numberValue: number? = tonumber(text)
		local player: Player = players:GetPlayerByUserId(numberValue or 0)

		traderName.Text = if player then player.DisplayName .. "'s Offer" else "Other's Offer"

		local numberValue2 = tonumber(text) or 0
		local s1

		if numberValue2 <= 0 then
			s1 = ""
		else
			s1 = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(numberValue2)
		end

		themBubbleAvatar.Image = s1
		themAvatar.Image = themBubbleAvatar.Image
	end
end
local function comma(p25)
	local floored = math.floor(p25)

	return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

local u126 = nil

local function describeCount(p26)
	if p26 == 1 then
		return "1 item"
	end

	local floored = math.floor(p26)

	return tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " items"
end
local function describeUnpriced(p27, p28)
	if p28 > 0 then
		p27.Text = tostring(p28) .. " unpriced"
		p27.Visible = true

		return
	end

	p27.Text = ""
	p27.Visible = false
end
local function refreshSummary()
	local v251 = u126 and u126[tostring(LocalPlayer.UserId)] or nil
	local v252 = u126 and text and u126[text] or nil
	local n1 = 0

	for _, v in pairs(t3) do
		n1 += v.Count
	end

	local n2 = 0

	for _, v in pairs(t4) do
		n2 += v.Count
	end

	givingItems.Text = if n1 == 1 then "1 item" else tostring((math.floor(n1))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " items"
	receivingItems.Text = if n2 == 1 then "1 item" else tostring((math.floor(n2))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " items"

	local v259: Instance = givingUnpriced
	local v260 = v251 and v251.Unvalued or 0

	if v260 > 0 then
		v259.Text = tostring(v260) .. " unpriced"
		v259.Visible = true
	else
		v259.Text = ""
		v259.Visible = false
	end

	v259 = receivingUnpriced
	v260 = v252 and v252.Unvalued or 0

	if v260 > 0 then
		v259.Text = tostring(v260) .. " unpriced"
		v259.Visible = true
	else
		v259.Text = ""
		v259.Visible = false
	end

	local v261: boolean = false

	if v251 == nil or v252 == nil then
		amount.Text = "--"
		receivingValueAmount.Text = "--"
		icon.Visible = false
		receivingValueIcon.Visible = false
		v261 = true
	end

	local numberValue
	local floored
	local replacedText
	local numberValue3
	local floored2

	if not v261 then
		icon.Visible = true
		receivingValueIcon.Visible = true
		numberValue = tonumber(v251.Estimated)
		floored = math.floor(v251.Rap)
		replacedText = tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		amount.Text = (if (numberValue or 0) > 0 then "~" else "") .. replacedText
		numberValue3 = tonumber(v252.Estimated)
		floored2 = math.floor(v252.Rap)
		floored2 = tostring(floored2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		receivingValueAmount.Text = (if (numberValue3 or 0) > 0 then "~" else "") .. floored2
	end

	v259 = amount

	local uiGradient: Instance = v259:FindFirstChildOfClass("UIGradient")

	if uiGradient and u56 == nil then
		u56 = uiGradient.Color
	end

	v259.TextColor3 = Color3.new(1, 1, 1)

	if uiGradient and u56 then
		uiGradient.Color = u56
	end

	v259 = receivingValueAmount

	local uiGradient2: Instance = v259:FindFirstChildOfClass("UIGradient")

	if uiGradient2 and u56 == nil then
		u56 = uiGradient2.Color
	end

	v259.TextColor3 = Color3.new(1, 1, 1)

	if uiGradient2 and u56 then
		uiGradient2.Color = u56
	end
end
local function refreshTokens()
	if not textBox:IsFocused() then
		textBox.Text = tostring(n2)
	end

	v48.Text = tostring(n3)
	textBox.TextEditable = not u93
end
local function captureTradeSelection()
	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if not guiServiceSelectedObject then
		return nil, nil, nil
	end

	for i, v in ipairs(t8) do
		if guiServiceSelectedObject == v.cell then
			return "you", v.itemKey, i
		end
	end

	for i, v in ipairs(t9) do
		if guiServiceSelectedObject == v.cell then
			return "them", v.itemKey, i
		end
	end

	return nil, nil, nil
end
local function restoreTradeSelection(p29, p30, p31)
	if not p29 then
		return
	end

	local v282: {[any]: any} = if p29 == "you" then t8 else t9

	if p30 then
		for _, v in ipairs(v282) do
			if p30 == v.itemKey then
				guiService.SelectedObject = v.cell

				return
			end
		end
	end

	if #v282 > 0 then
		local v285 = math.clamp(p31 or 1, 1, #v282)

		guiService.SelectedObject = v282[v285].cell

		return
	end

	if p29 == "you" and plus.Visible then
		guiService.SelectedObject = plus

		return
	end

	if accept.Visible then
		guiService.SelectedObject = accept

		return
	end

	guiService.SelectedObject = decline
end
local function refreshUI()
	hoverInfoModule.hide(v85)

	local v286, v287, v288 = captureTradeSelection()

	refreshNames()
	t5 = syncOrder(t5, t3)
	t6 = syncOrder(t6, t4)
	renderOffer(items1, t3, t5, true, t8, t1, t11)
	renderOffer(themItems1, t4, t6, false, t9, t2, t12)

	local u290

	if u98 or u93 then
		u290 = false
	else
		local n4 = 0

		for _, v in pairs(t3) do
			n4 += v.Count
		end

		u290 = n4 < n1
	end

	plus.Visible = u290

	local n5 = 0

	for _, v in pairs(t3) do
		n5 += v.Count
	end

	local text: string = tostring(n5)
	local text2: string = tostring(n1)

	limit.Text = text .. "/" .. text2
	n5 = 0

	for _, v in pairs(t4) do
		n5 += v.Count
	end

	local text3: string = tostring(n5)
	local text4: string = tostring(n1)

	themLimit.Text = text3 .. "/" .. text4

	if not textBox:IsFocused() then
		textBox.Text = tostring(n2)
	end

	v48.Text = tostring(n3)
	textBox.TextEditable = not u93
	refreshSummary()
	setReadyUI()
	restoreTradeSelection(v286, v287, v288)
end

local u134 = tradePublicFlags.QuickChatEnabled()
local u135 = tradePublicFlags.RapSummaryEnabled()
local tradeQuickChatBucket_max = tradeQuickChat.BUCKET_MAX
local u137 = os.clock()
local n5: number = 0
local u139: boolean = false
local u140 = false
local t13: {[any]: any} = {}
local u142 = nil
local n6: number = 0
local n7: number = 0

local function chatBudget()
	local v302 = os.clock()

	tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v302 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
	u137 = v302

	return tradeQuickChatBucket_max
end
local function canSendChat()
	if not u134 then
		return false
	end

	if not SessionId then
		return false
	end

	if n5 >= tradeQuickChat.SESSION_MAX then
		return false
	end

	local v303 = os.clock()

	tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v303 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
	u137 = v303

	return tradeQuickChatBucket_max >= 1
end
local function refreshTrayEnabled()
	local u304

	if not u134 or not SessionId or n5 >= tradeQuickChat.SESSION_MAX then
		u304 = false
	else
		local v305 = os.clock()

		tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v305 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
		u137 = v305
		u304 = tradeQuickChatBucket_max >= 1
	end

	for _, v in ipairs(t13) do
		v.Interactable = u304
		v.AutoButtonColor = u304

		local emoteImage = v:FindFirstChild("EmoteImage")

		if emoteImage and emoteImage:IsA("ImageLabel") then
			emoteImage.ImageTransparency = if u304 then 0 else 0.6
		end

		local textLabel3 = v:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.TextTransparency = if u304 then 0 else 0.6

			local textLabel4 = textLabel3:FindFirstChild("TextLabel")

			if textLabel4 and textLabel4:IsA("TextLabel") then
				textLabel4.TextTransparency = if u304 then 0 else 0.6
			end
		end
	end
end
local function setTrayOpen(p32)
	u140 = p32 and u134 and SessionId ~= nil
	quickChatTray.Visible = u140

	if not u140 then
		return
	end

	refreshTrayEnabled()
	task.spawn(function()
		while u140 do
			task.wait(0.25)

			if not u140 then
				break
			end

			refreshTrayEnabled()
		end
	end)
end

local tweenService: TweenService = game:GetService("TweenService")

local function popBubble(parent)
	local uiScale = parent:FindFirstChildOfClass("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = parent
	end

	local popSfx = parent:FindFirstChild("PopSfx")

	if not popSfx then
		popSfx = Instance.new("Sound")
		popSfx.Name = "PopSfx"
		popSfx.SoundId = "rbxassetid://132948338000932"
		popSfx.Volume = 0.6
		popSfx.Parent = parent
	end

	local n1 = 0.28 + math.random() * 0.12

	uiScale.Scale = 0.3 + math.random() * 0.2
	parent.Rotation = (math.random() - 0.5) * 8

	local tweenInfo = TweenInfo.new(n1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(uiScale, tweenInfo, { Scale = 1 }):Play()

	local tweenInfo2 = TweenInfo.new(n1 + 0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

	tweenService:Create(parent, tweenInfo2, { Rotation = 0 }):Play()
	popSfx.PlaybackSpeed = 0.9 + math.random() * 0.25
	popSfx:Play()
end
local function flashBubble(p34, p35, image, p37, p38)
	local v323 = if p34 then youBubble else themBubble
	local text = v323:FindFirstChild("Text")
	local wantIcon = v323:FindFirstChild("WantIcon")
	local tail = v323:FindFirstChild("Tail")

	v323.BackgroundColor3 = p38 or youBubbleBackgroundColor3

	if tail and tail:IsA("Frame") then
		tail.BackgroundColor3 = p38 or backgroundColor3
	end

	v323.Size = youBubbleSize

	if text and text:IsA("TextLabel") then
		text.TextScaled = true
		text.TextWrapped = true
	end

	if not text or not text:IsA("TextLabel") or not wantIcon or not wantIcon:IsA("ImageLabel") then
		if text and text:IsA("TextLabel") then
			text.Visible = true
			text.Text = p35
		end
	elseif p37 == "chat" then
		wantIcon.Visible = false

		local n1 = youBubbleSize.Y.Scale * (v323.Parent and v323.Parent.AbsoluteSize.Y or 0) + youBubbleSize.Y.Offset
		local floored = math.floor(n1 * 0.18)
		local v329 = math.max(6, floored)

		text.Visible = true
		text.TextScaled = false
		text.TextWrapped = true

		local floored3 = math.floor(n1 * 0.42)

		text.TextSize = math.max(12, floored3)
		text.AnchorPoint = Vector2.new(0.5, 0.5)
		text.Position = UDim2.new(0.5, 0, 0.5, 0)
		text.Size = UDim2.new(0.78, 0, 0, 0)
		text.Text = p35

		local roundedUp = math.ceil(text.TextBounds.Y)
		local v332 = math.max(n1, roundedUp + v329 * 2)

		v323.Size = UDim2.new(youBubbleSize.X.Scale, youBubbleSize.X.Offset, 0, v332)
		text.Size = UDim2.new(0.78, 0, 0, roundedUp)
	elseif p37 == "image" and image then
		text.Visible = false
		wantIcon.Image = image
		wantIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		wantIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		wantIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
		wantIcon.Visible = true
	elseif p37 == "want" and image then
		text.Visible = true
		text.Text = p35
		text.AnchorPoint = Vector2.new(0, 0.5)
		text.Position = UDim2.new(0.06, 0, 0.5, 0)
		text.Size = UDim2.new(0.56, 0, 0.6, 0)
		wantIcon.Image = image
		wantIcon.AnchorPoint = Vector2.new(1, 0.5)
		wantIcon.Position = UDim2.new(0.94, 0, 0.5, 0)
		wantIcon.Size = UDim2.new(0.78, 0, 0.78, 0)
		wantIcon.Visible = true
	else
		text.Visible = true
		text.Text = p35
		text.AnchorPoint = Vector2.new(0.5, 0.5)
		text.Position = UDim2.new(0.5, 0, 0.5, 0)
		text.Size = UDim2.new(0.86, 0, 0.6, 0)
		wantIcon.Visible = false
	end

	v323.Visible = true
	popBubble(v323)

	local u333

	if p34 then
		n6 += 1
		u333 = n6
	else
		n7 += 1
		u333 = n7
	end

	local tradeQuickChatBubble_seconds = tradeQuickChat.BUBBLE_SECONDS
	local v335 = if p37 == "chat" then math.min(4, #p35 * 0.05) else 0

	task.delay(tradeQuickChatBubble_seconds + v335, function()
		if (if p34 then n6 else n7) == u333 then
			v323.Visible = false
		end
	end)
end
local function showPhrase(p39, p40, p41)
	if p40.Image then
		flashBubble(p39, p40.Text, p40.Image, "image", p40.BubbleColor)

		return
	end

	if p40.Want and p41 then
		flashBubble(p39, p40.Text, p41, "want", nil)

		return
	end

	flashBubble(p39, p40.Text, nil, nil, nil)
end

game:GetService("TextChatService").MessageReceived:Connect(function(textChatMessage: TextChatMessage)
	if not SessionId or not u99 then
		return
	end

	if textChatMessage.Status ~= Enum.TextChatMessageStatus.Success then
		return
	end

	local textChannel: TextChannel = textChatMessage.TextChannel

	if not textChannel then
		return
	end

	local v341: string = textChannel.Name
	local u342: boolean = true

	if v341 ~= "Lobby" then
		u342 = true

		if v341:sub(1, 6) ~= "Match_" then
			u342 = v341 == "RBXGeneral"
		end
	end

	if not u342 then
		return
	end

	local textSource: TextSource = textChatMessage.TextSource

	if not textSource then
		return
	end

	u342 = textSource.UserId == LocalPlayer.UserId

	if not u342 and tostring(textSource.UserId) ~= tostring(text) then
		return
	end

	if not u342 and u139 then
		return
	end

	v341 = textChatMessage.Text

	if typeof(v341) == "string" and v341 ~= "" then
		local v344 = utf8.len(v341) and utf8.len(v341) > 120 and utf8.offset(v341, 120)

		if v344 then
			v341 = v341:sub(1, v344 - 1) .. "…"
		end

		flashBubble(u342, v341, nil, "chat", nil)

		return
	end
end)

local function demoPartnerReply()
	n4 += 1

	local v345: number = n4

	task.delay(0.9, function()
		if not u98 or n4 ~= v345 then
			return
		end

		if u139 then
			return
		end

		local t18: {[any]: any} = {}

		for _, v in ipairs(tradeQuickChat.Phrases) do
			if v.Retired ~= true and v.Want ~= true then
				table.insert(t18, v)
			end
		end

		local mathRandom = math.random
		local v491 = math.max(1, #t18)
		local v492 = mathRandom(1, v491)
		local v493 = t18[v492]

		if v493 then
			showPhrase(false, v493)
		end
	end)
end
local function clearWantItems()
	for _, v in ipairs(t7) do
		pcall(function()
			v:destroy()
		end)
	end

	table.clear(t7)
end
local function closeWantPicker()
	u101 = false
	wantPicker.Visible = false
	clearWantItems()
end
local function sendWant(p43)
	local u349

	if not u134 or not SessionId or n5 >= tradeQuickChat.SESSION_MAX then
		u349 = false
	else
		local v350 = os.clock()

		tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v350 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
		u137 = v350
		u349 = tradeQuickChatBucket_max >= 1
	end

	if not u349 then
		refreshTrayEnabled()

		return
	end

	tradeQuickChatBucket_max -= 1
	n5 += 1
	u101 = false
	wantPicker.Visible = false
	clearWantItems()
	sound:Play("UI.Click", workspace)

	if u98 then
		local typeName = typeof(p43.Meta)

		typeName = if p43.Kind == "Tokens" then boothTheme.TokenIcon() else (typeName == "table" and p43.Meta or {}).Icon

		local v352 = tradeQuickChat.Get(tradeQuickChat.WANT_ID)

		showPhrase(true, v352, typeName)
		n4 += 1

		local v353: number = n4

		task.delay(0.9, function()
			if not u98 or n4 ~= v353 then
				return
			end

			if u139 then
				return
			end

			local t19: {[any]: any} = {}

			for _, v in ipairs(tradeQuickChat.Phrases) do
				if v.Retired ~= true and v.Want ~= true then
					table.insert(t19, v)
				end
			end

			local mathRandom = math.random
			local v498 = math.max(1, #t19)
			local v499 = mathRandom(1, v498)
			local v500 = t19[v499]

			if v500 then
				showPhrase(false, v500)
			end
		end)

		return
	end

	tradeEvent:FireServer("QuickChat", tradeQuickChat.WANT_ID, { Kind = p43.Kind, ItemId = p43.ItemId })
end
local function renderWantItems(p44)
	clearWantItems()

	if not u101 then
		return
	end

	empty.Visible = false

	local v355 = boothTheme.TokenIcon()
	local v356, v357 = uiFramework.createItemCell("Common", {
		name = "WantTokens",
		layoutOrder = 0,
		visible = true,
		active = true,
		selectable = true,
		icon = if v355 == "" then nil else v355,
		parent = items
	})

	v356.MouseButton1Click:Connect(function()
		sendWant({ Kind = "Tokens", ItemId = "Tokens" })
	end)
	table.insert(t7, v357)

	for i, v in ipairs(p44) do
		local t16 = typeof(v.Meta) == "table" and v.Meta or {}
		local uiFrameworkCreateItemCell = uiFramework.createItemCell
		local v362 = t16.Rarity or "Common"
		local icon = t16.Icon
		local v364 = ("Want%d"):format(i)
		local v365, v366 = uiFrameworkCreateItemCell(v362, {
			visible = true,
			active = true,
			selectable = true,
			icon = icon,
			name = v364,
			parent = items,
			layoutOrder = i
		})

		if (tonumber(v.Count) or 1) > 1 and v366.setStackCount then
			v366:setStackCount(v.Count)
		end

		v365.MouseButton1Click:Connect(function()
			sendWant(v)
		end)
		table.insert(t7, v366)
	end
end
local function openWantPicker()
	if not SessionId then
		return
	end

	local u367

	if not u134 or not SessionId or n5 >= tradeQuickChat.SESSION_MAX then
		u367 = false
	else
		local v368 = os.clock()

		tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v368 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
		u137 = v368
		u367 = tradeQuickChatBucket_max >= 1
	end

	if not u367 then
		refreshTrayEnabled()

		return
	end

	u140 = false
	quickChatTray.Visible = false
	u101 = true
	wantPicker.Visible = true
	clearWantItems()
	empty.Text = "Loading..."
	empty.Visible = true

	if u98 then
		renderWantItems(u100 or {})

		return
	end

	tradeEvent:FireServer("PartnerInventory")
end

v25.MouseButton1Click:Connect(function()
	sound:Play("UI.Click", workspace)
	u101 = false
	wantPicker.Visible = false
	clearWantItems()
end)

local function sendQuickChat(p45)
	local u370

	if not u134 or not SessionId or n5 >= tradeQuickChat.SESSION_MAX then
		u370 = false
	else
		local v371 = os.clock()

		tradeQuickChatBucket_max = math.min(tradeQuickChat.BUCKET_MAX, tradeQuickChatBucket_max + (v371 - u137) / tradeQuickChat.BUCKET_REGEN_SEC)
		u137 = v371
		u370 = tradeQuickChatBucket_max >= 1
	end

	if not u370 then
		refreshTrayEnabled()

		return
	end

	tradeQuickChatBucket_max -= 1
	n5 += 1
	u140 = false
	quickChatTray.Visible = u140

	if u98 then
		local v372 = tradeQuickChat.Get(p45)

		if v372 then
			showPhrase(true, v372)
		end

		n4 += 1

		local v373: number = n4

		task.delay(0.9, function()
			if not u98 or n4 ~= v373 then
				return
			end

			if u139 then
				return
			end

			local t20: {[any]: any} = {}

			for _, v in ipairs(tradeQuickChat.Phrases) do
				if v.Retired ~= true and v.Want ~= true then
					table.insert(t20, v)
				end
			end

			local mathRandom = math.random
			local v505 = math.max(1, #t20)
			local v506 = mathRandom(1, v505)
			local v507 = t20[v506]

			if v507 then
				showPhrase(false, v507)
			end
		end)

		return
	end

	tradeEvent:FireServer("QuickChat", p45)
end
local function refreshMuteCell()
	local v374 = u142

	if v374 == nil then
		return
	end

	local text: string = if u139 then "Unmute" else "Mute"
	local textLabel5 = v374:FindFirstChild("TextLabel")

	if textLabel5 and textLabel5:IsA("TextLabel") then
		textLabel5.Text = text

		local textLabel6 = textLabel5:FindFirstChild("TextLabel")

		if textLabel6 and textLabel6:IsA("TextLabel") then
			textLabel6.Text = text
		end
	end

	local uiGradient = v374:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local v379

		if u139 then
			local colorSequenceNew = ColorSequence.new
			local color33 = Color3.fromRGB(236, 128, 120)

			v379 = colorSequenceNew(color33, Color3.fromRGB(140, 34, 30))
		else
			local v382 = ColorSequence.new
			local color34 = Color3.fromRGB(132, 141, 160)

			v379 = v382(color34, Color3.fromRGB(44, 50, 64))
		end

		uiGradient.Color = v379
	end
end
local function resetQuickChat()
	u140 = false
	quickChatTray.Visible = u140
	u101 = false
	wantPicker.Visible = false
	clearWantItems()
	youBubble.Visible = false
	themBubble.Visible = false
	u99 = false
	n6 += 1
	n7 += 1
	tradeQuickChatBucket_max = tradeQuickChat.BUCKET_MAX
	u137 = os.clock()
	n5 = 0
	u139 = false
	refreshMuteCell()
	themBubbleAvatar.Image = ""
	themAvatar.Image = ""
end
local function resetUI()
	local v384: boolean = u97

	SessionId = nil
	text = nil
	n1 = 10
	t3 = {}
	t4 = {}
	t5 = {}
	t6 = {}
	u93 = false
	u94 = false
	n2 = 0
	n3 = 0
	u97 = false
	u98 = false
	n4 += 1
	timer.Visible = false
	trading.Visible = false

	if u105 then
		u105 = false
		windowBlur.hide("Trade")
	end

	accepted.Visible = false
	themAccepted.Visible = false
	plus.Visible = true
	accept.Visible = true
	declineTextLabel.Text = "Decline"

	if textLabel2 then
		textLabel2.Text = "Decline"
	end

	textBox.Text = "0"
	textBox.TextEditable = true
	v48.Text = "0"
	hoverInfoModule.hide(v85)
	u126 = nil
	u140 = false
	quickChatTray.Visible = u140
	u101 = false
	wantPicker.Visible = false
	clearWantItems()
	youBubble.Visible = false
	themBubble.Visible = false
	u99 = false
	n6 += 1
	n7 += 1
	tradeQuickChatBucket_max = tradeQuickChat.BUCKET_MAX
	u137 = os.clock()
	n5 = 0
	u139 = false
	refreshMuteCell()
	themBubbleAvatar.Image = ""
	themAvatar.Image = ""

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(trading) then
		guiService.SelectedObject = nil
	end

	clearRendered(t8)
	clearRendered(t9)
	table.clear(t10)
	tradeReservedChanged:Fire(t10)

	local v386 = u104 and bindables:FindFirstChild("ConfirmModalCancel")

	if v386 and v386:IsA("BindableEvent") then
		v386:Fire()
	end

	if v384 then
		u20:Fire()
	end
end
local function applyState(p46)
	local u388: boolean = SessionId == p46.SessionId
	local n5 = 0

	for _, v in pairs(t3) do
		n5 += v.Count
	end

	local n6 = 0

	for _, v in pairs(t4) do
		n6 += v.Count
	end

	local v395: number = n2
	local v396: number = n3

	SessionId = p46.SessionId
	text = tostring(p46.OtherUserId)
	n1 = p46.MaxItems or 10

	local text5: string = tostring(LocalPlayer.UserId)
	local text6: string = tostring(p46.OtherUserId)

	t3 = p46.Offers[text5] or {}
	t4 = p46.Offers[text6] or {}
	u93 = p46.Ready[text5] == true
	u94 = p46.Ready[text6] == true

	local tokens = p46.Tokens

	n2 = typeof(tokens) == "table" and typeof(tokens[text5]) == "number" and tokens[text5] or 0
	n3 = typeof(tokens) == "table" and typeof(tokens[text6]) == "number" and tokens[text6] or 0
	u126 = if typeof(p46.Values) == "table" then p46.Values else nil
	u98 = p46.Demo == true
	u99 = p46.LiveChat == true
	u100 = if typeof(p46.DemoInventory) == "table" then p46.DemoInventory else nil

	if u388 then
		local n7 = 0

		for _, v in pairs(t3) do
			n7 += v.Count
		end

		local n4 = 0

		for _, v in pairs(t4) do
			n4 += v.Count
		end

		if n5 + n6 < n7 + n4 then
			sound:Play("UI.TradeItemAdded", workspace)
		end

		if v395 < n2 or v396 < n3 then
			sound:Play("UI.TradeTokensAdded", workspace)
		end
	end

	if not u97 then
		trading.Visible = true
		activeWindowChanged:Fire("Trade")

		if not u105 then
			u105 = true
			windowBlur.show("Trade")
		end
	end

	if u93 then
		hoverInfoModule.hide(v85)
	end

	refreshUI()
	rebuildReservedFromMyOffer()
	tradeReservedChanged:Fire(t10)
end
local function u164(p47)
	if typeof(p47) == "table" then
		local action = p47.Action

		if action == "Init" or action == "State" then
			if typeof(p47.State) == "table" then
				applyState(p47.State)
			end

			return
		end

		if action == "Countdown" then
			if typeof(p47.Value) == "number" then
				timer.Visible = true
				v43.Text = tostring(p47.Value)
				sound:Play("UI.TradeCountdown", workspace)
			end

			return
		end

		if action == "CountdownStop" then
			timer.Visible = false

			return
		end

		if action == "LockIn" then
			timer.Visible = true
			v43.Text = ""

			return
		end

		if action ~= "PartnerInventory" then
			if action == "QuickChat" then
				if not u134 then
					return
				end

				if not SessionId then
					return
				end

				local v408 = tradeQuickChat.Get(p47.Id)

				if v408 == nil then
					return
				end

				local text: string = tostring(p47.From)
				local text7: string = tostring(LocalPlayer.UserId)
				local u411: boolean = text == text7

				if not u411 and u139 then
					return
				end

				local Icon = nil

				if v408.Want then
					local want = p47.Want

					if typeof(want) ~= "table" then
						return
					end

					if want.Kind == "Tokens" then
						Icon = boothTheme.TokenIcon()

						if Icon == "" then
							return
						end
					else
						if typeof(want.Icon) ~= "string" then
							return
						end

						Icon = want.Icon
					end
				end

				showPhrase(u411, v408, Icon)

				if not u411 then
					sound:Play("UI.Click", workspace)
				end
			elseif action == "Close" then
				if SessionId then
					if p47.Reason == "Completed" then
						sound:Play("UI.TradeCompleted", workspace)
					elseif p47.Reason == "Failed" then
						sound:Play("UI.TradeDeclined", workspace)
					elseif p47.Reason ~= "Settling" then
						sound:Play("UI.TradeDeclined", workspace)

						local _GNotify = _G.Notify

						if typeof(_GNotify) == "function" then
							local s1: string = "Trade cancelled."

							pcall(function()
								_GNotify({ notifType = "FailNotification", errorMessage = s1 })
							end)
						end
					end
				end

				resetUI()

				return
			end

			return
		end

		if not u101 then
			return
		end

		local typeName: string = typeof(p47.Items)

		renderWantItems(if typeName == "table" then p47.Items else {})

		return
	end
end

tradeEvent.OnClientEvent:Connect(u164)

local function existScore(p48)
	local n1 = 0
	local v419 = nil
	local n2 = 0

	for _, v in pairs(p48) do
		local vMeta = v.Meta
		local v424 = if vMeta then vMeta.GlobalCopies else nil

		if typeof(v424) == "number" and v424 > 0 then
			n1 += (v.Count or 1) / v424

			if v419 == nil or v419 > v424 then
				v419 = v424
			end
		else
			n2 += v.Count or 1
		end
	end

	return n1, v419, n2
end
local function tradeSeemsUnfair()
	local v425, v426 = existScore(t3)

	if v425 <= 0 then
		return false
	end

	if v426 == nil or v426 > 1000 then
		return false
	end

	local v427, v428, v429 = existScore(t4)

	if v429 > 0 then
		return false
	end

	return v425 >= v427 * 3
end

u164 = nil

local function invokeConfirm(p49)
	if u164 == nil then
		u164 = bindables:WaitForChild("ConfirmModal", 5)
	end

	local v431 = u164

	if v431 == nil then
		return true
	end

	local ok, result = pcall(function()
		return v431:Invoke(p49)
	end)

	if ok then
		return result == true
	end

	return true
end

plus.MouseButton1Click:Connect(function()
	if not SessionId then
		return
	end

	if u93 then
		return
	end

	local u435

	if u98 or u93 then
		u435 = false
	else
		local n2 = 0

		for _, v in pairs(t3) do
			n2 += v.Count
		end

		u435 = n2 < n1
	end

	if not u435 then
		return
	end

	u97 = true
	trading.Visible = false
	hoverInfoModule.hide(v85)
	openInventoryForTrade:Fire({ SessionId = SessionId, MaxItems = n1, Reserved = t10 })
end)
v4.Event:Connect(function(p50)
	if not SessionId then
	elseif u93 then
	elseif typeof(p50) == "table" then
		if typeof(p50.Purpose) == "string" and p50.Purpose ~= "Trade" then
			return
		end

		local kind = p50.Kind
		local v440 = p50.Amount

		if typeof(v440) ~= "number" then
			v440 = 1
		end

		if kind == "Crate" then
			tradeEvent:FireServer("AddItem", { Kind = "Crate", ItemId = p50.ItemId, Amount = v440 })
		else
			local instanceId = p50.InstanceId

			if typeof(instanceId) ~= "string" then
				return
			end

			tradeEvent:FireServer("AddItem", instanceId, v440)
		end

		u97 = false
		trading.Visible = true
		refreshUI()

		return
	end
end)
accept.MouseButton1Click:Connect(function()
	if not SessionId then
		return
	end

	if u93 then
		return
	end

	if u104 then
		return
	end

	local v442, v443 = existScore(t3)
	local u444

	if v442 <= 0 or v443 == nil or v443 > 1000 then
		u444 = false
	else
		local v445, v446, v447 = existScore(t4)

		u444 = if v447 > 0 then false else v442 >= v445 * 3
	end

	if u444 then
		u104 = true

		local v448 = SessionId
		local t17: {[any]: any} = {
			Header = "Trade Unfair?",
			Body = "Your items seem to be much rarer than theirs. Are you sure you want to continue?",
			AcceptText = "Trade Anyway",
			DeclineText = "Cancel"
		}

		if u164 == nil then
			u164 = bindables:WaitForChild("ConfirmModal", 5)
		end

		local v450 = u164
		local u452

		if v450 == nil then
			u452 = true
		else
			local ok, result = pcall(function()
				return v450:Invoke(t17)
			end)

			u452 = if ok then result == true else true
		end

		u104 = false

		if not u452 then
			return
		end

		if v448 ~= SessionId or u93 then
			return
		end
	end

	if u98 then
		u93 = true
		refreshUI()

		return
	end

	tradeEvent:FireServer("SetReady", true)
	hoverInfoModule.hide(v85)
end)
decline.MouseButton1Click:Connect(function()
	if not SessionId then
		return
	end

	if not u93 then
		tradeEvent:FireServer("Close")
		sound:Play("UI.TradeDeclined", workspace)
		resetUI()

		return
	end

	if u98 then
		u93 = false
		refreshUI()

		return
	end

	tradeEvent:FireServer("SetReady", false)
end)
textBox.FocusLost:Connect(function()
	if not SessionId then
		textBox.Text = "0"

		return
	end

	local numberValue: number? = tonumber(textBox.Text)

	if typeof(numberValue) == "number" and numberValue == numberValue and not (numberValue < 0) then
		local floored = math.floor(numberValue)
		local numberValue4 = tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0

		if floored > numberValue4 then
			local s1: string = "You only have " .. tostring(numberValue4) .. " Trade Tokens."
			local _GNotify = _G.Notify

			if typeof(_GNotify) == "function" then
				pcall(function()
					_GNotify({ notifType = "FailNotification", errorMessage = s1 })
				end)
			end

			floored = numberValue4
		end

		if not u93 and floored ~= n2 then
			if floored > n2 then
				sound:Play("UI.TradeTokensAdded", workspace)
			end

			n2 = floored
			textBox.Text = tostring(floored)
			tradeEvent:FireServer("SetTokens", floored)

			return
		end

		textBox.Text = tostring(n2)

		return
	end

	textBox.Text = tostring(n2)
end)
chatBtn.MouseButton1Click:Connect(function()
	if not SessionId then
		return
	end

	if not u134 then
		return
	end

	sound:Play("UI.Click", workspace)

	if u101 then
		u101 = false
		wantPicker.Visible = false
		clearWantItems()

		return
	end

	u140 = not u140 and u134 and SessionId ~= nil
	quickChatTray.Visible = u140

	if not u140 then
		return
	end

	refreshTrayEnabled()
	task.spawn(function()
		while u140 do
			task.wait(0.25)

			if not u140 then
				break
			end

			refreshTrayEnabled()
		end
	end)
end)
tradeSessionClosed.MouseButton1Click:Connect(function()
	if SessionId then
		tradeEvent:FireServer("Close")
		sound:Play("UI.TradeDeclined", workspace)
	end

	resetUI()
end)
replicatedStorage.Event:Connect(function()
	u97 = false

	if SessionId then
		if not trading.Visible then
			trading.Visible = true
			activeWindowChanged:Fire("Trade")

			if not u105 then
				u105 = true
				windowBlur.show("Trade")
			end
		end

		refreshUI()
	end
end);
(function()
	for _, v in ipairs(t13) do
		v:Destroy()
	end

	table.clear(t13)

	if u142 then
		u142:Destroy()
		u142 = nil
	end

	local n1: number = 0

	for _, v in ipairs(tradeQuickChat.Categories) do
		for _, iterValue in ipairs(tradeQuickChat.InCategory(v)) do
			n1 += 1

			local clone: Instance = phraseTemplate:Clone()

			clone.Name = "Phrase_" .. tostring(iterValue.Id)
			clone.Visible = true
			clone.LayoutOrder = if iterValue.Want then 0 else n1

			local textLabel7: Instance = clone:FindFirstChild("TextLabel")

			if iterValue.Image and textLabel7 and textLabel7:IsA("TextLabel") then
				textLabel7.Visible = false

				local emoteImage: ImageLabel = Instance.new("ImageLabel")

				emoteImage.Name = "EmoteImage"
				emoteImage.BackgroundTransparency = 1
				emoteImage.BorderSizePixel = 0
				emoteImage.Image = iterValue.Image
				emoteImage.ScaleType = Enum.ScaleType.Fit
				emoteImage.AnchorPoint = Vector2.new(0.5, 0.5)
				emoteImage.Position = UDim2.new(0.5, 0, 0.5, 0)
				emoteImage.Size = UDim2.new(0.72, 0, 0.72, 0)
				emoteImage.ZIndex = clone.ZIndex + 2

				local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

				uiAspectRatioConstraint.AspectRatio = 1
				uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
				uiAspectRatioConstraint.Parent = emoteImage
				emoteImage.Parent = clone

				local uiGradient: Instance = clone:FindFirstChildOfClass("UIGradient")
				local bubbleColor = iterValue.BubbleColor

				if uiGradient and typeof(bubbleColor) == "Color3" then
					local colorSequenceNew = ColorSequence.new
					local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, bubbleColor)

					uiGradient.Color = colorSequenceNew({
						colorSequenceKeypoint,
						ColorSequenceKeypoint.new(1, Color3.new(bubbleColor.R * 0.55, bubbleColor.G * 0.55, bubbleColor.B * 0.55))
					})
				end
			elseif textLabel7 and textLabel7:IsA("TextLabel") then
				textLabel7.Text = iterValue.Text

				local textLabel8: Instance = textLabel7:FindFirstChild("TextLabel")

				if textLabel8 and textLabel8:IsA("TextLabel") then
					textLabel8.Text = iterValue.Text
				end

				local u476: boolean = not iterValue.Text:find("[%a%d]")

				if u476 then
					u476 = iterValue.Text:find("[\128-\255]") ~= nil
				end

				if u476 then
					textLabel7.TextTransparency = 1
				end
			end

			local v477 = iterValue.Id

			if iterValue.Want then
				local uiGradient: Instance = clone:FindFirstChildOfClass("UIGradient")

				if uiGradient then
					local v479 = ColorSequence.new
					local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 200, 90))

					uiGradient.Color = v479({
						colorSequenceKeypoint,
						ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 110, 45))
					})
				end

				if textLabel7 and textLabel7:IsA("TextLabel") then
					textLabel7.Text = "I want..."

					local textLabel9: Instance = textLabel7:FindFirstChild("TextLabel")

					if textLabel9 and textLabel9:IsA("TextLabel") then
						textLabel9.Text = "I want..."
					end
				end

				clone.MouseButton1Click:Connect(function()
					sound:Play("UI.Click", workspace)
					openWantPicker()
				end)
			else
				clone.MouseButton1Click:Connect(function()
					sendQuickChat(v477)
				end)
			end

			clone.Parent = quickChatTray
			table.insert(t13, clone)
		end
	end
end)()
quickChatTray.Visible = false;
(function()
	youBubble.Visible = false
	themBubble.Visible = false
end)()
youBubbleAvatar.Image = (function(userId)
	if userId <= 0 then
		return ""
	end

	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(userId)
end)(LocalPlayer.UserId)
avatar.Image = youBubbleAvatar.Image
themBubbleAvatar.Image = ""
themAvatar.Image = ""
v25 = function()
	u134 = tradePublicFlags.QuickChatEnabled()
	chatBtn.Visible = u134

	if not u134 then
		u140 = false
		quickChatTray.Visible = u140
		youBubble.Visible = false
		themBubble.Visible = false
	end
end
tradeSessionClosed = function()
	u135 = tradePublicFlags.RapSummaryEnabled()
	givingValue.Visible = u135
	receivingValue.Visible = u135
end
v25()
tradeSessionClosed()
tradePublicFlags.OnChanged("QuickChatEnabled", v25)
tradePublicFlags.OnChanged("RapSummaryEnabled", tradeSessionClosed)
plus.LayoutOrder = 9999
plus.Active = true
plus.Selectable = true
trading.Visible = false
timer.Visible = false
textBox.Text = "0"
v48.Text = "0"
accepted.Visible = false
themAccepted.Visible = false
activeWindowChanged.Event:Connect(function(p51)
	if p51 ~= "Trade" and SessionId then
		tradeEvent:FireServer("Close")
		sound:Play("UI.TradeDeclined", workspace)

		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			local s1: string = "Trade cancelled."

			pcall(function()
				_GNotify({ notifType = "FailNotification", errorMessage = s1 })
			end)
		end

		resetUI()
	end
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	if SessionId then
		tradeEvent:FireServer("Close")
		resetUI()
	end
end)
