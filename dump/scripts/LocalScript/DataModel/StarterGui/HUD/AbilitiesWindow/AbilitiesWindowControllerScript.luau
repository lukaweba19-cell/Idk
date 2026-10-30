-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")

local LocalPlayer: Player = players.LocalPlayer
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local updateGate = require(shared:WaitForChild("UpdateGate"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local insufficientFundsPrompt = require(replicatedStorageShared:WaitForChild("InsufficientFundsPrompt"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local abilities_Request: Instance = remotes:WaitForChild("Abilities_Request")
local abilities_Push: Instance = remotes:WaitForChild("Abilities_Push")
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local abilitiesWindow: Instance = hud:WaitForChild("AbilitiesWindow")
local container: Instance = abilitiesWindow:WaitForChild("Container")
local unlockedIndicator: Instance = abilitiesWindow:WaitForChild("Header"):WaitForChild("UnlockedIndicator")
local items: Instance = container:WaitForChild("Items"):WaitForChild("Items")
local t1: {[any]: any} = {}

for _, v in ipairs(items:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "ItemTemplate" then
		table.insert(t1, v)
	end
end

local filters: Instance = container:WaitForChild("Filters")
local skillName: Instance = filters:WaitForChild("SkillName")
local skillDescription: Instance = filters:WaitForChild("SkillDescription")
local itemTemplate: Instance = filters:WaitForChild("ItemTemplate")
local buyButton: Instance = filters:WaitForChild("BuyButton")
local ownedButton: Instance = filters:WaitForChild("OwnedButton")
local u28 = nil
local u29 = nil

for _, v in ipairs(buyButton:GetChildren()) do
	if v:IsA("TextLabel") and v.Name == "TextLabel" then
		u28 = v

		local textLabel = v:FindFirstChild("TextLabel")

		if not textLabel or not textLabel:IsA("TextLabel") then
			break
		end

		u29 = textLabel

		break
	end
end

local coinCounter: Instance = abilitiesWindow:WaitForChild("CoinCounter")

uiFramework.setupCoinCounter(coinCounter, LocalPlayer)

local u34 = nil
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local u38: boolean = false
local t5: {[any]: any} = {}
local t6: {[any]: any} = {}
local u41 = nil
local u42 = nil
local u43 = nil

local function buildUnlockedSet(p1)
	local t9: {[any]: any} = {}

	for _, v in ipairs(p1) do
		t9[v] = true
	end

	t2 = t9
end
local function isUnlocked(p2)
	return t2[p2] == true
end
local function safeInvoke(p3, p4)
	local ok, result = pcall(function()
		return abilities_Request:InvokeServer(p3, p4)
	end)

	if not ok then
		warn("Abilities_Request failed:", p3, result)

		return nil
	end

	return result
end
local function applyLockedLook(p5, p6)
	local cell = p5.cell
	local v94 = cell:FindFirstChild("AbilityIcon") or cell:FindFirstChild("Icon")

	if v94 and v94:IsA("ImageLabel") then
		v94.ImageTransparency = if p6 then 0.7 else 0
	end
end
local function buildFilterCell(p7, p8)
	local v97 = u42 or itemTemplate

	if not v97 or not v97.Parent then
		v97 = nil
	end

	local v98, v99 = uiFramework.createAbilityCell(p7, {
		visible = true,
		interactable = false,
		active = false,
		selectable = false,
		replaces = v97,
		parent = if not v97 then filters else nil,
		icon = p8
	})

	u42 = v98
	u43 = v99
end
local function updateFiltersDisplay(p9)
	local v101 = abilityCatalog.Get(p9)

	if not v101 then
		return
	end

	skillName.Text = v101.DisplayName
	skillDescription.Text = v101.Description or ""
	buildFilterCell(v101.Type, v101.Icon)

	local textColor3 = abilityCatalog.TYPE_COLOR[v101.Type]

	if textColor3 then
		skillName.TextColor3 = textColor3
	end
end
local function formatWithCommas(p10)
	local floored = math.floor(p10)
	local text = tostring(floored)

	repeat
		local v106, v107 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v106
	until v107 == 0

	return text
end
local function updateInteractButton(p11)
	u41 = p11

	local v109 = abilityCatalog.Get(p11)

	if not v109 then
		return
	end

	local v110 = abilityCatalog.Get(p11)

	if v110 then
		skillName.Text = v110.DisplayName
		skillDescription.Text = v110.Description or ""
		buildFilterCell(v110.Type, v110.Icon)

		local textColor3 = abilityCatalog.TYPE_COLOR[v110.Type]

		if textColor3 then
			skillName.TextColor3 = textColor3
		end
	end

	if t2[p11] == true then
		buyButton.Visible = false
		ownedButton.Visible = true

		return
	end

	buyButton.Visible = true
	ownedButton.Visible = false

	local v112 = v109.Cost or 0
	local text: string = if v112 == 0 then "FREE" else "$" .. formatWithCommas(v112)

	u28.Text = text

	if u29 then
		u29.Text = text
	end
end
local function clearList()
	for k, v in pairs(t6) do
		v.api:destroy()
		t6[k] = nil
	end
end

local u53 = nil
local t7: {[any]: any} = {}

local function clearSpacers()
	for _, v in ipairs(t7) do
		v:Destroy()
	end

	table.clear(t7)
end
local function createSpacer(layoutOrder)
	local _CategorySpacer: Frame = Instance.new("Frame")

	_CategorySpacer.Name = "_CategorySpacer"
	_CategorySpacer.BackgroundColor3 = Color3.new(1, 1, 1)
	_CategorySpacer.BackgroundTransparency = 0.92
	_CategorySpacer.BorderSizePixel = 0
	_CategorySpacer.LayoutOrder = layoutOrder
	_CategorySpacer.Visible = true
	_CategorySpacer.Size = UDim2.fromScale(0.181, 0.16)

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.09, 0)
	uiCorner.Parent = _CategorySpacer
	_CategorySpacer.Parent = items
	table.insert(t7, _CategorySpacer)

	return _CategorySpacer
end
local function buildListOnce()
	for k, v in pairs(t6) do
		v.api:destroy()
		t6[k] = nil
	end

	for _, v in ipairs(t7) do
		v:Destroy()
	end

	table.clear(t7)

	local v125 = abilityCatalog.GetAllList()
	local t10: {[any]: any} = {}

	for _, v in ipairs(v125) do
		if abilityCatalog.ShouldShowInShop(v.Id) then
			table.insert(t10, v)
		end
	end

	for _, v in ipairs(t1) do
		if v and v.Parent then
			v:Destroy()
		end
	end

	table.clear(t1)

	local n1: number = 0

	for _, v in ipairs(t10) do
		local vType = v.Type
		local v135, v136 = uiFramework.createAbilityCell(v.Type, {
			visible = true,
			active = true,
			selectable = true,
			interactable = true,
			icon = v.Icon,
			name = v.Id,
			parent = items
		})

		v135.LayoutOrder = v.SortOrder or 0

		local t11: {[any]: any} = { cell = v135, api = v136 }
		local u138: boolean = t2[v.Id] ~= true
		local cell = t11.cell
		local v140 = cell:FindFirstChild("AbilityIcon") or cell:FindFirstChild("Icon")

		if v140 and v140:IsA("ImageLabel") then
			v140.ImageTransparency = if u138 then 0.7 else 0
		end

		v135.MouseButton1Click:Connect(function()
			updateInteractButton(v.Id)

			for k, iterValue in pairs(t6) do
				iterValue.api:setSelected(k == v.Id)
			end

			u53(v.Id)
		end)
		t6[v.Id] = t11
		n1 += 1
	end

	if t10[1] then
		updateInteractButton(t10[1].Id)

		local v141 = t6[t10[1].Id]

		if v141 then
			v141.api:setSelected(true)
		end
	end
end

local alert: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("Alert")
local abilitiesButton = nil
local clone = nil
local lobbyButtons: Instance = hud:FindFirstChild("LobbyButtons")

if lobbyButtons then
	local lobbyButtons2: Instance = lobbyButtons:FindFirstChild("LobbyButtons")

	if lobbyButtons2 then
		abilitiesButton = lobbyButtons2:FindFirstChild("AbilitiesButton")
	end
end

local function flushMarkSeen()
	if #t4 == 0 then
		return
	end

	local v142 = table.clone(t4)

	table.clear(t4)
	u38 = false
	task.spawn(function()
		pcall(function()
			abilities_Request:InvokeServer("MarkSeenAffordable", { abilityIds = v142 })
		end)
	end)
end
local function getAffordableUnowned()
	local t12: {[any]: any} = {}
	local cash = LocalPlayer:GetAttribute("Cash")

	if typeof(cash) ~= "number" then
		cash = 0
	end

	for k, _ in pairs(t6) do
		if t2[k] ~= true then
			local v147 = abilityCatalog.Get(k)
			local v148 = v147 and v147.Cost or 0

			if v148 == 0 or cash >= v148 then
				t12[k] = true
			end
		end
	end

	return t12
end
local function updateLobbyAlert()
	local tutorialPhase: any = LocalPlayer:GetAttribute("TutorialPhase")
	local u150: boolean = false

	if typeof(tutorialPhase) == "number" then
		u150 = false

		if tutorialPhase > 0 then
			u150 = tutorialPhase < 2
		end
	end

	local v151 = getAffordableUnowned()
	local u152: boolean = false

	if tutorialPhase == 0 then
		for k, _ in pairs(v151) do
			if not t5[k] then
				u152 = true

				break
			end
		end
	end

	LocalPlayer:SetAttribute("ShowSkillsBubble", u152)

	local n1: number = 0

	if not u150 and not u152 then
		for k, _ in pairs(v151) do
			if not t3[k] then
				n1 += 1
			end
		end
	end

	if n1 > 0 then
		local parent = not clone and abilitiesButton and abilitiesButton:FindFirstChild("ImageLabel")

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

u53 = function(p13)
	if t3[p13] then
		return
	end

	if t2[p13] == true then
		return
	end

	t3[p13] = true
	table.insert(t4, p13)

	local v161 = t6[p13]

	if v161 and v161.api.setAlert then
		v161.api:setAlert(false)
	end

	updateLobbyAlert()

	if not u38 then
		u38 = true
		task.delay(0.5, flushMarkSeen)
	end
end

local function refreshTiles()
	local n1: number = 0
	local n2: number = 0
	local cash = LocalPlayer:GetAttribute("Cash")

	if typeof(cash) ~= "number" then
		cash = 0
	end

	for k, v in pairs(t6) do
		n2 += 1

		local u167: boolean = t2[k] == true

		if u167 then
			n1 += 1
		end

		local u168: boolean = not u167
		local vCell = v.cell
		local v170 = vCell:FindFirstChild("AbilityIcon") or vCell:FindFirstChild("Icon")

		if v170 and v170:IsA("ImageLabel") then
			v170.ImageTransparency = if u168 then 0.7 else 0
		end

		if v.api.setAlert then
			if not u167 and not t3[k] then
				local v171 = abilityCatalog.Get(k)
				local v172 = v171 and v171.Cost or 0

				v171 = true

				if v172 ~= 0 then
					v171 = cash >= v172
				end

				v.api:setAlert(v171)
			else
				v.api:setAlert(false)
			end
		end
	end

	unlockedIndicator.Text = string.format("%d/%d Unlocked", n1, n2)

	if u41 and abilityCatalog.Exists(u41) then
		updateInteractButton(u41)
	end

	updateLobbyAlert()
end
local function doPurchase(p14)
	local s1: string = "Purchase"
	local t13: {[any]: any} = { abilityId = p14 }

	local ok, result = pcall(function()
		return abilities_Request:InvokeServer(s1, t13)
	end)

	local v178

	if not ok then
		warn("Abilities_Request failed:", "Purchase", result)
		v178 = nil
	else
		v178 = result
	end

	if v178 and v178.ok == true then
	elseif v178 and v178.err then
		local v179 = abilityCatalog.Get(p14)

		insufficientFundsPrompt.HandlePurchaseError(v178.err, "Cash", v179 and v179.Cost or 0)
	end
end

buyButton.MouseButton1Click:Connect(function()
	if not u41 then
	elseif not abilityCatalog.Get(u41) then
	elseif t2[u41] ~= true then
		doPurchase(u41)
	end
end)

local function applySnapshot(p15)
	u34 = p15

	local t14: {[any]: any} = {}

	for _, v in ipairs(p15.Unlocked) do
		t14[v] = true
	end

	t2 = t14

	if typeof(p15.SeenAffordable) == "table" then
		for _, v in ipairs(p15.SeenAffordable) do
			t3[v] = true
		end
	end

	refreshTiles()
end

abilities_Push.OnClientEvent:Connect(function(p16, player)
	if p16 == "Snapshot" and typeof(player) == "table" then
		local userId = player.UserId

		if typeof(userId) == "number" and userId ~= LocalPlayer.UserId then
			return
		end

		u34 = player

		local t15: {[any]: any} = {}

		for _, v in ipairs(player.Unlocked) do
			t15[v] = true
		end

		t2 = t15

		if typeof(player.SeenAffordable) == "table" then
			for _, v in ipairs(player.SeenAffordable) do
				t3[v] = true
			end
		end

		refreshTiles()

		return
	end
end)

local s1: string = "GetSnapshot"
local v70 = nil

local ok, result = pcall(function()
	return abilities_Request:InvokeServer(s1, v70)
end)

local v73

if not ok then
	warn("Abilities_Request failed:", "GetSnapshot", result)
	v73 = nil
else
	v73 = result
end

if v73 and typeof(v73) == "table" then
	u34 = v73

	local t8: {[any]: any} = {}

	for _, v in ipairs(v73.Unlocked) do
		t8[v] = true
	end

	t2 = t8

	if typeof(v73.SeenAffordable) == "table" then
		for _, v in ipairs(v73.SeenAffordable) do
			t3[v] = true
		end
	end

	refreshTiles()
end

buildListOnce()

if u34 then
	refreshTiles()
end

LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
	refreshTiles()
end)
replicatedStorage:GetAttributeChangedSignal(updateGate.PREVIEW_OFFSET_ATTRIBUTE):Connect(function()
	buildListOnce()

	if u34 then
		refreshTiles()
	end
end)

local function shownSignature()
	local t16: {[any]: any} = {}

	for _, v in ipairs(abilityCatalog.GetAllList()) do
		if abilityCatalog.ShouldShowInShop(v.Id) then
			table.insert(t16, v.Id)
		end
	end

	return table.concat(t16, ",")
end

local u80 = shownSignature()

task.spawn(function()
	while true do
		task.wait(10)

		local v197 = shownSignature()

		if v197 ~= u80 then
			u80 = v197
			buildListOnce()

			if u34 then
				refreshTiles()
			end
		end
	end
end)
LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(function()
	updateLobbyAlert()
end)

local function notifyShopOpened()
	task.spawn(function()
		pcall(function()
			abilities_Request:InvokeServer("NotifyShopOpened")
		end)
	end)
end

if abilitiesWindow.Visible then
	task.spawn(function()
		pcall(function()
			abilities_Request:InvokeServer("NotifyShopOpened")
		end)
	end)
end

abilitiesWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if abilitiesWindow.Visible then
		task.spawn(function()
			pcall(function()
				abilities_Request:InvokeServer("NotifyShopOpened")
			end)
		end)

		local v198 = getAffordableUnowned()

		for k, _ in pairs(v198) do
			t5[k] = true
		end

		updateLobbyAlert()
	end
end)
