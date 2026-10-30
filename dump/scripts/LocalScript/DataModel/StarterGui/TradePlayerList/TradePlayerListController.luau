-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent

scriptParent.Enabled = false

local panel: Instance = scriptParent:WaitForChild("Panel")
local content: Instance = panel:WaitForChild("Content")
local playersScrollingFrame: Instance = content:WaitForChild("PlayersScrollingFrame")
local requestsScrollingFrame: Instance = content:WaitForChild("RequestsScrollingFrame")
local closeButton: Instance = panel:WaitForChild("CloseButton")
local openEvent: Instance = scriptParent:WaitForChild("OpenEvent")
local playersTab: Instance = panel:WaitForChild("PlayersTab")
local requestsTab: Instance = panel:WaitForChild("RequestsTab")
local historyTab: Instance = panel:WaitForChild("HistoryTab")
local panelTextLabel: Instance = panel:WaitForChild("TextLabel")
local headerTextLabel: Instance = panel:WaitForChild("Header"):WaitForChild("TextLabel")
local headerTextLabelText = headerTextLabel.Text
local alert: Instance = requestsTab:WaitForChild("Alert")
local history: Instance = panel:WaitForChild("History")
local tradeHistoryTab = require(script.Parent:WaitForChild("TradeHistoryTab"))
local u20 = nil
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local windowSlide = require(shared:WaitForChild("WindowSlide"))
local gameFlags = require(shared:WaitForChild("GameFlags"))
local clanRosterUI = require(shared:WaitForChild("ClanRosterUI"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local playerRequestSend: Instance = remotes:WaitForChild("PlayerRequestSend")
local playerRequestNotify: Instance = remotes:WaitForChild("PlayerRequestNotify")
local playerRequestRespond: Instance = remotes:WaitForChild("PlayerRequestRespond")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local openInventoryForPlayer: Instance = bindables:WaitForChild("OpenInventoryForPlayer")
local tradeRequestResolved: Instance = bindables:WaitForChild("TradeRequestResolved")

local function tradeSendCooldown()
	return tonumber(playerRequestSend:GetAttribute("TradeResendCooldown")) or 60
end
local function notifyError(p1)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p1 })
	end
end
local function notifySuccess(p2)
	if _G.Notify then
		_G.Notify({
			notifType = "SuccessNotification",
			topText = "Request Sent!",
			bottomText = p2
		})
	end
end

local u37 = nil

for _, v in ipairs(playersScrollingFrame:GetChildren()) do
	if v:IsA("Frame") and v.Name == "PlayerCard_Template" then
		v.Visible = false
		u37 = v

		break
	end
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local u43: boolean = false
local n1: number = 0

local function v45()
end
local function clearRows()
	for _, v in ipairs(playersScrollingFrame:GetChildren()) do
		if v:IsA("GuiObject") and v ~= u37 and v.Name ~= "PADDINGFIX" then
			v:Destroy()
		end
	end
end
local function ensureFriendCached(player)
	local userId = player.UserId

	if t2[userId] ~= nil then
		return
	end

	if userId <= 0 then
		t2[userId] = false

		return
	end

	local ok, result = pcall(function()
		return LocalPlayer:IsFriendsWith(userId)
	end)

	t2[userId] = ok and result == true
end
local function isListable(player)
	return player ~= LocalPlayer and player.UserId > 0
end
local function getLabels(p5)
	local labelShadow = p5:FindFirstChild("LabelShadow")
	local label = labelShadow and labelShadow:FindFirstChild("Label")
	local v102 = if labelShadow and labelShadow:IsA("TextLabel") then labelShadow else nil

	if label and label:IsA("TextLabel") then
		return v102, label
	end

	return v102, nil
end

local color3 = Color3.fromRGB(115, 115, 115)
local color32 = Color3.fromRGB(60, 60, 60)
local color33 = Color3.fromRGB(210, 210, 210)
local disabledButton: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("DisabledButton")
local colorSequence = ColorSequence.new(Color3.fromRGB(121, 121, 121))
local color34 = Color3.fromRGB(0, 0, 0)
local n2 = 0.5
local uiGradient: Instance = disabledButton:FindFirstChildOfClass("UIGradient")

if uiGradient then
	colorSequence = uiGradient.Color
end

local textLabel: Instance = disabledButton:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	color34 = textLabel.TextColor3
	n2 = textLabel.TextTransparency
end

local function wireTradeButton(p6, player)
	local labelShadow = p6:FindFirstChild("LabelShadow")
	local label = labelShadow and labelShadow:FindFirstChild("Label")
	local v107 = if labelShadow and labelShadow:IsA("TextLabel") then labelShadow else nil
	local v108 = if label and label:IsA("TextLabel") then label else nil
	local uiGradient2 = p6:FindFirstChildOfClass("UIGradient")
	local backgroundColor3 = p6.BackgroundColor3
	local v111 = if uiGradient2 then uiGradient2.Color else nil
	local v112 = v107 and v107.TextColor3 or Color3.new(0, 0, 0)
	local v113 = v108 and v108.TextColor3 or Color3.new(1, 1, 1)

	local function setTradesOffLook(p8)
		if uiGradient2 then
			uiGradient2.Enabled = not p8
		end

		p6.BackgroundColor3 = if p8 then color3 else backgroundColor3

		local text: string = if p8 then "Trades Off" else "Trade"

		if v107 then
			v107.Text = text
			v107.TextColor3 = if p8 then color32 else v112
		end

		if v108 then
			v108.Text = text
			v108.TextColor3 = if p8 then color33 else v113
		end
	end
	local function setCooldownLook(p9)
		p6.Interactable = not p9
		p6.AutoButtonColor = not p9

		if uiGradient2 and v111 then
			uiGradient2.Color = if p9 then colorSequence else v111
		end

		if v107 then
			v107.TextColor3 = if p9 then color34 else v112
			v107.TextTransparency = if p9 then n2 else 0
		end

		if v108 then
			v108.TextColor3 = v113
			v108.TextTransparency = 0
		end
	end
	local function refreshEnabled()
		local v201 = gameFlags.TradingEnabled

		if v201 then
			v201 = player:GetAttribute("TradeRequests") ~= false
		end

		local u202: boolean = not v201

		if uiGradient2 then
			uiGradient2.Enabled = not u202
		end

		p6.BackgroundColor3 = if u202 then color3 else backgroundColor3

		local text: string = if u202 then "Trades Off" else "Trade"

		if v107 then
			v107.Text = text
			v107.TextColor3 = if u202 then color32 else v112
		end

		if v108 then
			v108.Text = text
			v108.TextColor3 = if u202 then color33 else v113
		end

		if not v201 then
			p6.Interactable = false
			p6.AutoButtonColor = false

			if v107 then
				v107.TextTransparency = 0
			end

			if v108 then
				v108.TextTransparency = 0
			end

			return
		end

		local v204 = t1[player.UserId]

		u202 = v204 ~= nil and os.clock() - v204.at < v204.cd
		p6.Interactable = not u202
		p6.AutoButtonColor = not u202

		if uiGradient2 and v111 then
			uiGradient2.Color = if u202 then colorSequence else v111
		end

		if v107 then
			v107.TextColor3 = if u202 then color34 else v112
			v107.TextTransparency = if u202 then n2 else 0
		end

		if v108 then
			v108.TextColor3 = v113
			v108.TextTransparency = 0
		end
	end

	refreshEnabled()

	local v117 = t1[player.UserId]

	if v117 then
		local cd = v117.cd
		local v119 = os.clock()
		local n1 = cd - (v119 - v117.at)

		if n1 > 0 then
			task.delay(n1, function()
				local v205 = t1[player.UserId]

				if v205 and os.clock() - v205.at >= v205.cd then
					t1[player.UserId] = nil
				end

				if p6.Parent then
					refreshEnabled()
				end
			end)
		end
	end

	local v121 = player:GetAttributeChangedSignal("TradeRequests")

	table.insert(t3, v121:Connect(function()
		if p6.Parent then
			refreshEnabled()
		end
	end))
	p6.MouseButton1Click:Connect(function()
		if not p6.Interactable then
			return
		end

		local userId = player.UserId
		local v207 = os.clock()
		local numberValue: number? = tonumber(playerRequestSend:GetAttribute("TradeResendCooldown"))

		t1[userId] = { at = v207, cd = numberValue or 60 }
		refreshEnabled()

		local v209, v210, v211 = pcall(function()
			return playerRequestSend:InvokeServer({ Type = "Trade", TargetUserId = player.UserId })
		end)

		if v209 and v210 == true then
			if _G.Notify then
				_G.Notify({
					notifType = "SuccessNotification",
					topText = "Request Sent!",
					bottomText = "Sent a trade request to " .. player.DisplayName .. "."
				})
			end

			local numberValue2 = tonumber(v211)

			if not numberValue2 then
				numberValue2 = tonumber(playerRequestSend:GetAttribute("TradeResendCooldown")) or 60
			end

			t1[player.UserId] = { at = os.clock(), cd = numberValue2 }
			task.delay(numberValue2, function()
				local v226 = t1[player.UserId]

				if v226 and os.clock() - v226.at >= v226.cd then
					t1[player.UserId] = nil

					if p6.Parent then
						refreshEnabled()
					end
				end
			end)

			return
		end

		t1[player.UserId] = nil

		if p6.Parent then
			refreshEnabled()
		end

		local typeName: string = typeof(v210)

		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = typeName == "string" and v210 or "Couldn't send the trade request."
			})
		end
	end)
end

local u60 = nil

local function makeRow(player)
	if not u37 then
		return
	end

	local clone = u37:Clone()

	clone.Name = "PlayerRow"
	clone.Visible = true

	local username = clone:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.Text = player.DisplayName
	end

	local rank = clone:FindFirstChild("Rank")

	if rank and rank:IsA("TextLabel") then
		local level = player:GetAttribute("Level")

		rank.Text = "Level " .. tostring(level or 1)
		rank.Visible = true
	end

	local playerDisplay = clone:FindFirstChild("PlayerDisplay")

	if playerDisplay and playerDisplay:IsA("ImageLabel") then
		clanRosterUI.applyAvatar(playerDisplay, player.UserId)

		local status = playerDisplay:FindFirstChild("Status")

		if status and status:IsA("GuiObject") then
			status.Visible = false
		end
	end

	local buttons = clone:FindFirstChild("Buttons")
	local inventoryButton = buttons and buttons:FindFirstChild("InventoryButton")
	local tradeButton = buttons and buttons:FindFirstChild("TradeButton")

	if inventoryButton and inventoryButton:IsA("TextButton") then
		inventoryButton.MouseButton1Click:Connect(function()
			if not inventoryButton.Interactable then
				return
			end

			if player.Parent ~= players then
				return
			end

			u60()
			openInventoryForPlayer:Fire(player)
		end)
	end

	if tradeButton and tradeButton:IsA("TextButton") then
		wireTradeButton(tradeButton, player)
	end

	clone.Parent = playersScrollingFrame
end
local function doRender()
	n1 += 1

	local v132: number = n1
	local t6: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer and v.UserId > 0 then
			table.insert(t6, v)
		end
	end

	for _, v in ipairs(t6) do
		local vUserId = v.UserId

		if t2[vUserId] == nil then
			if vUserId <= 0 then
				t2[vUserId] = false
			else
				local ok, result = pcall(function()
					return LocalPlayer:IsFriendsWith(vUserId)
				end)

				t2[vUserId] = ok and result == true
			end
		end
	end

	if v132 ~= n1 then
		return
	end

	table.sort(t6, function(player, player2)
		local u216: boolean = t2[player.UserId] == true

		if u216 ~= (t2[player2.UserId] == true) then
			return u216
		end

		local lowerText = player.DisplayName:lower()
		local lowerText2 = player2.DisplayName:lower()

		return lowerText < lowerText2
	end)
	clearRows()

	for _, v in ipairs(t6) do
		if v.Parent == players then
			if v ~= LocalPlayer and v.UserId > 0 then
				makeRow(v)
			end
		end
	end
end
local function u63()
	task.spawn(doRender)
end

local u64 = nil

for _, v in ipairs(requestsScrollingFrame:GetChildren()) do
	if v:IsA("Frame") and v.Name == "RequestCard_Template" then
		v.Visible = false
		u64 = v

		break
	end
end

local t4: {[any]: any} = {}
local t5: {[any]: any} = {}
local s1 = "Players"
local u70 = nil
local u71 = nil
local panelTextLabelText = panelTextLabel.Text

local function updateBadge()
	local n1: number = 0

	for iterKey in pairs(t5) do
		n1 += 1
	end

	alert.Visible = n1 > 0

	local quantity: Instance = alert:FindFirstChild("Quantity")

	if quantity and quantity:IsA("TextLabel") then
		quantity.Text = if n1 > 99 then "!" else tostring(n1)
	end
end
local function removeEntry(p13)
	if not t4[p13] then
		return
	end

	t4[p13] = nil
	t5[p13] = nil
	updateBadge()

	if scriptParent.Enabled and s1 == "Requests" then
		u71()
	end
end
local function clearRequestRows()
	for _, v in ipairs(requestsScrollingFrame:GetChildren()) do
		if v:IsA("GuiObject") and v ~= u64 and v.Name ~= "PADDINGFIX" then
			v:Destroy()
		end
	end
end
local function makeRequestRow(p14)
	if not u64 then
		return
	end

	local clone = u64:Clone()

	clone.Name = "RequestRow"
	clone.Visible = true

	local username = clone:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.Text = p14.FromName
	end

	local playerDisplay = clone:FindFirstChild("PlayerDisplay")

	if playerDisplay and playerDisplay:IsA("ImageLabel") then
		clanRosterUI.applyAvatar(playerDisplay, p14.FromUserId)

		local status = playerDisplay:FindFirstChild("Status")

		if status and status:IsA("GuiObject") then
			status.Visible = false
		end
	end

	local buttons = clone:FindFirstChild("Buttons")
	local acceptButton = buttons and buttons:FindFirstChild("AcceptButton")
	local declineButton = buttons and buttons:FindFirstChild("DeclineButton")

	if acceptButton and acceptButton:IsA("TextButton") then
		acceptButton.MouseButton1Click:Connect(function()
			u70(p14.Token, true)
		end)
	end

	if declineButton and declineButton:IsA("TextButton") then
		declineButton.MouseButton1Click:Connect(function()
			u70(p14.Token, false)
		end)
	end

	clone.Parent = requestsScrollingFrame
end

u71 = function()
	clearRequestRows()

	local t7: {[any]: any} = {}

	for _, v in pairs(t4) do
		table.insert(t7, v)
	end

	table.sort(t7, function(p15, p16)
		return p15.ReceivedAt > p16.ReceivedAt
	end)

	for _, v in ipairs(t7) do
		makeRequestRow(v)
	end
end
u70 = function(p17, p18)
	if not t4[p17] then
		return
	end

	playerRequestRespond:FireServer(p17, p18)

	if t4[p17] then
		t4[p17] = nil
		t5[p17] = nil
		updateBadge()

		if scriptParent.Enabled and s1 == "Requests" then
			u71()
		end
	end

	tradeRequestResolved:Fire(p17, p18)
end

local function markRequestsSeen()
	if next(t5) ~= nil then
		table.clear(t5)
	end

	updateBadge()
end
local function historySubtitle()
	local v164 = u20

	if v164 == nil or v164 == LocalPlayer then
		return "Your trade history"
	end

	return v164.DisplayName .. "'s trade history"
end
local function switchTab(p19)
	s1 = p19

	local visible: boolean = p19 == "Requests"
	local u167: boolean = p19 == "History"
	local u168: boolean = u20 ~= nil

	content.Visible = not u167
	playersScrollingFrame.Visible = not visible and not u167
	requestsScrollingFrame.Visible = visible
	tradeHistoryTab.setVisible(u167)

	local function setCover(p20, p21)
		local darkenDeselectedCover = p20:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not p21
		end
	end

	local darkenDeselectedCover: Instance = playersTab:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not not visible or not not u167
	end

	local darkenDeselectedCover2: Instance = requestsTab:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover2 and darkenDeselectedCover2:IsA("GuiObject") then
		darkenDeselectedCover2.Visible = not visible
	end

	local darkenDeselectedCover3: Instance = historyTab:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover3 and darkenDeselectedCover3:IsA("GuiObject") then
		darkenDeselectedCover3.Visible = not u167
	end

	playersTab.Visible = not u168
	requestsTab.Visible = not u168
	historyTab.Visible = not u168 and true
	headerTextLabel.Text = if u168 then "HISTORY" else headerTextLabelText
	panelTextLabel.Visible = u168 or not u167
	setCover = u20
	panelTextLabel.Text = if u168 then if setCover == nil or setCover == LocalPlayer then "Your trade history" else setCover.DisplayName .. "'s trade history" else if u167 then "" else if visible then "Trade requests players have sent you!" else panelTextLabelText

	if visible then
		u71()

		if next(t5) ~= nil then
			table.clear(t5)
		end

		updateBadge()
	end
end
local function openRoster()
	if u43 then
		u63()

		return
	end

	u43 = true
	u63()
	table.insert(t3, players.PlayerAdded:Connect(function()
		if u43 then
			u63()
		end
	end))
	table.insert(t3, players.PlayerRemoving:Connect(function()
		if u43 then
			task.defer(u63)
		end
	end))
end
local function closeRoster()
	u43 = false

	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	table.clear(t3)
end

local panelPosition = panel.Position
local v83 = windowSlide.closedPosFor(panelPosition)
local u84 = nil
local u85: boolean = false

local function cancelSlide()
	if u84 then
		u84:Cancel()
		u84 = nil
	end
end
local function openWindow(p22)
	if u84 then
		u84:Cancel()
		u84 = nil
	end

	local v176: boolean = u85

	if not u85 then
		u85 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		pcall(function()
			windowBlur.show("TradePlayerList")
		end)
	end

	activeWindowChanged:Fire("TradePlayerList")
	scriptParent.Enabled = true

	if not v176 then
		u84 = windowSlide.slideIn(panel, panelPosition, v83)
	else
		panel.Visible = true
	end

	u20 = p22
	tradeHistoryTab.setSubject(p22)

	if p22 then
		u43 = false

		for _, v in ipairs(t3) do
			v:Disconnect()
		end

		table.clear(t3)
		switchTab("History")

		return
	end

	openRoster()
	switchTab("Players")
end
local function openTPL()
	openWindow(nil)
end

u60 = function()
	u43 = false

	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	table.clear(t3)
	u20 = nil

	if not u85 then
		return
	end

	u85 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v183 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v183)
	pcall(function()
		windowBlur.hide("TradePlayerList")
	end)

	if u84 then
		u84:Cancel()
		u84 = nil
	end

	u84 = windowSlide.slideOut(panel, v83, function()
		if not u85 then
			scriptParent.Enabled = false
			panel.Position = panelPosition
		end
	end)
end
closeButton.MouseButton1Click:Connect(function()
	u60()
end)
openEvent.OnClientEvent:Connect(openTPL)
_G.OpenTradePlayerList = openTPL

function _G.ToggleTradePlayerList()
	if u85 then
		u60()

		return
	end

	openWindow(nil)
end

local openTradeHistoryForPlayer: Instance = bindables:WaitForChild("OpenTradeHistoryForPlayer", 10)

if openTradeHistoryForPlayer and openTradeHistoryForPlayer:IsA("BindableEvent") then
	openTradeHistoryForPlayer.Event:Connect(function(p23)
		if typeof(p23) ~= "Instance" or not p23:IsA("Player") then
			return
		end

		if p23.Parent ~= players then
			return
		end

		openWindow(p23)
	end)
else
	warn("[TradePlayerList] Bindables.OpenTradeHistoryForPlayer missing -- the PlayerCard History option has nothing to open")
end

activeWindowChanged.Event:Connect(function(p24)
	if p24 ~= "TradePlayerList" and scriptParent.Enabled then
		u60()
	end
end)
playersTab.MouseButton1Click:Connect(function()
	switchTab("Players")
end)
requestsTab.MouseButton1Click:Connect(function()
	switchTab("Requests")
end)
historyTab.MouseButton1Click:Connect(function()
	switchTab("History")
end)
tradeHistoryTab.mount(history)
playerRequestNotify.OnClientEvent:Connect(function(p25)
	if typeof(p25) ~= "table" then
	elseif p25.Type == "Trade" then
		local token = p25.Token

		if typeof(token) ~= "string" then
			return
		end

		if not gameFlags.TradingEnabled then
			return
		end

		if LocalPlayer:GetAttribute("TradeRequests") == false then
			return
		end

		local v188 = t4[token]

		if v188 then
			v188.ReceivedAt = os.clock()

			if not scriptParent.Enabled or s1 ~= "Requests" then
				t5[token] = true
			end

			updateBadge()

			if scriptParent.Enabled and s1 == "Requests" then
				u71()
			end

			return
		end

		local numberValue = tonumber(p25.ExpiresIn) or 7.5
		local numberValue3: number? = tonumber(p25.FromUserId)

		t4[token] = {
			Token = token,
			FromUserId = numberValue3 or 0,
			FromName = if typeof(p25.FromName) == "string" then p25.FromName else "Player",
			ReceivedAt = os.clock(),
			ExpiresAt = os.clock() + numberValue
		}

		if not scriptParent.Enabled or s1 ~= "Requests" then
			t5[token] = true
		end

		updateBadge()

		if scriptParent.Enabled and s1 == "Requests" then
			u71()
		end

		task.delay(numberValue, function()
			local v224 = t4[token]

			if v224 and os.clock() >= v224.ExpiresAt - 0.05 then
				local v225 = token

				if not t4[v225] then
					return
				end

				t4[v225] = nil
				t5[v225] = nil
				updateBadge()

				if scriptParent.Enabled and s1 == "Requests" then
					u71()
				end

				return
			end
		end)

		return
	end
end)
players.PlayerRemoving:Connect(function(player: Player)
	local t8: {[any]: any} = {}

	for k, v in pairs(t4) do
		if v.FromUserId == player.UserId then
			table.insert(t8, k)
		end
	end

	for _, v in ipairs(t8) do
		if t4[v] then
			t4[v] = nil
			t5[v] = nil
			updateBadge()

			if scriptParent.Enabled and s1 == "Requests" then
				u71()
			end
		end
	end
end)
tradeRequestResolved.Event:Connect(function(p27)
	if typeof(p27) ~= "string" then
		return
	end

	if not t4[p27] then
		return
	end

	t4[p27] = nil
	t5[p27] = nil
	updateBadge()

	if scriptParent.Enabled and s1 == "Requests" then
		u71()
	end
end)
updateBadge()
