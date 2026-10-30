-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local hud: Instance = playerGui:WaitForChild("HUD")
local shopWindow: Instance = hud:WaitForChild("ShopWindow")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local showPurchaseModal: Instance = bindables:WaitForChild("ShowPurchaseModal")
local shopOpenAnalytics: Instance = remotes:WaitForChild("ShopOpenAnalytics")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")

remotes:WaitForChild("CurrencyGiftRequest")

local inventory: Instance = remotes:WaitForChild("Inventory")
local inspectItem: Instance = bindables:WaitForChild("InspectItem")
local packRequest: Instance = remotes:WaitForChild("PackRequest")
local packPush: Instance = remotes:WaitForChild("PackPush")
local packColorSelect: Instance = remotes:WaitForChild("PackColorSelect")
local redeemCode: Instance = remotes:WaitForChild("RedeemCode")
local v19: Instance = replicatedStorage:WaitForChild("Shared")
local currencyProducts = require(v19:WaitForChild("CurrencyProducts"))

v19 = replicatedStorage:WaitForChild("Shared")

local tokenProducts = require(v19:WaitForChild("TokenProducts"))

v19 = replicatedStorage:WaitForChild("Shared")

local tradingPlazaGate = require(v19:WaitForChild("TradingPlazaGate"))

v19 = replicatedStorage:WaitForChild("Shared")

local rarity = require(v19:WaitForChild("Rarity"))

v19 = replicatedStorage:WaitForChild("Shared")

local hoverInfoModule = require(v19:WaitForChild("HoverInfoModule"))

v19 = replicatedStorage:WaitForChild("Shared")

local collectibleConfig = require(v19:WaitForChild("CollectibleConfig"))

v19 = replicatedStorage:WaitForChild("Shared")

local insufficientFundsPrompt = require(v19:WaitForChild("InsufficientFundsPrompt"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))

v19 = replicatedStorage:WaitForChild("UIFramework")

local giftPicker = require(v19:WaitForChild("GiftPicker"))

v19 = replicatedStorage:WaitForChild("Shared")

local packCatalog = require(v19:WaitForChild("PackCatalog"))

v19 = replicatedStorage:WaitForChild("Shared")

local traitText = require(v19:WaitForChild("TraitText"))

v19 = replicatedStorage:WaitForChild("Shared")

local shineEffect = require(v19:WaitForChild("ShineEffect"))

v19 = replicatedStorage:WaitForChild("Shared")

local gameFlags = require(v19:WaitForChild("GameFlags"))

v19 = replicatedStorage:WaitForChild("Extensions")

local inputCategorizer = require(v19:WaitForChild("InputCategorizer"))

v19 = replicatedStorage:WaitForChild("Extensions")

local gamepadSliderController = require(v19:WaitForChild("GamepadSliderController"))
local runService: RunService = game:GetService("RunService")
local content: Instance = shopWindow:WaitForChild("Content")
local scrollingFrame: Instance = content:WaitForChild("ScrollingFrame")
local navigator: Instance = shopWindow:WaitForChild("Navigator")
local closeButton: Instance = shopWindow:WaitForChild("CloseButton")

v19 = shopWindow:WaitForChild("CoinCounter")

local casePurchase5b3: Instance = shopWindow:WaitForChild("CasePurchase5b3")
local filters1: Instance = casePurchase5b3:WaitForChild("Filters1")
local v42 = filters1:WaitForChild("CaseDisplay")
local icon: Instance = v42:WaitForChild("Icon")
local caseName: Instance = v42:WaitForChild("CaseName")
local stats: Instance = filters1:WaitForChild("Stats"):WaitForChild("Stats")
local buyButton: Instance = filters1:WaitForChild("BuyButton")
local caseItems: Instance = casePurchase5b3:WaitForChild("CaseItemsFrame"):WaitForChild("CaseItems")

v42 = casePurchase5b3:WaitForChild("Back")
casePurchase5b3:WaitForChild("CaseName")

local u48 = nil
local frame: Instance = buyButton:FindFirstChild("Frame")

if frame then
	local textLabel: Instance = frame:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		u48 = textLabel
	end
end

local textLabel: Instance = buyButton:FindFirstChild("TextLabel")
local releasePack: Instance = scrollingFrame:FindFirstChild("ReleasePack")
local starterPack: Instance = scrollingFrame:FindFirstChild("StarterPack")

frame = scrollingFrame:FindFirstChild("Premium1Bundle")

local premium2Bundle: Instance = scrollingFrame:FindFirstChild("Premium2Bundle")
local casesDivider = scrollingFrame:FindFirstChild("CasesDivider")
local cases_Row1: Instance = scrollingFrame:FindFirstChild("Cases_Row1")
local currencyDivider = scrollingFrame:FindFirstChild("CurrencyDivider")
local currencies: Instance = scrollingFrame:FindFirstChild("Currencies")
local codesDivider = scrollingFrame:FindFirstChild("CodesDivider")
local giftCodes: Instance = scrollingFrame:FindFirstChild("GiftCodes")
local tradeTokensDivider = scrollingFrame:FindFirstChild("TradeTokensDivider")
local tokenGapTop = scrollingFrame:FindFirstChild("TokenGapTop")
local tokenPackages: Instance = scrollingFrame:FindFirstChild("TokenPackages")
local tokenGapBottom = scrollingFrame:FindFirstChild("TokenGapBottom")
local t1: {[any]: any} = {
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Secret",
	"Collectible",
	"Exclusive"
}
local rarityOrder = rarity.Order
local t2: {[any]: any} = {
	NoCash = "Not enough coins!",
	NoGems = "Not enough gems!",
	SpendFailed = "Transaction failed, try again.",
	UnknownCrate = "This case doesn't exist.",
	BadCrateId = "Invalid case.",
	InventoryFull = "Your inventory is full!",
	NotReady = "Still loading, try again.",
	NoGemPrice = "This case can't be bought with gems.",
	CrateDisabled = "This case is no longer available."
}

local function friendlyError(p1)
	return t2[p1] or p1
end

local color3 = Color3.new(1, 1, 1)
local color32 = Color3.fromRGB(134, 134, 134)
local dailyEmotes = scrollingFrame:FindFirstChild("DailyEmotes")
local t3: {[any]: any} = {
	Featured = starterPack or releasePack or casesDivider,
	Daily = dailyEmotes or casesDivider,
	Cases = casesDivider,
	Currency = currencyDivider,
	Codes = codesDivider,
	Tokens = tradeTokensDivider or currencyDivider,
	MidnightBundle = frame or starterPack or casesDivider,
	NinjaBundle = premium2Bundle or starterPack or casesDivider,
	EnergyBundle = frame or starterPack or casesDivider,
	EnergyKnife = frame or starterPack or casesDivider,
	EnergyGun = frame or starterPack or casesDivider,
	EnergyFinisher = frame or starterPack or casesDivider,
	HeartKeeperBundle = premium2Bundle or starterPack or casesDivider,
	HeartKeeperKnife = premium2Bundle or starterPack or casesDivider,
	HeartKeeperGun = premium2Bundle or starterPack or casesDivider,
	HeartKeeperFinisher = premium2Bundle or starterPack or casesDivider,
	BlackCatBundle = frame or starterPack or casesDivider,
	BlackCatKnife = frame or starterPack or casesDivider,
	BlackCatGun = frame or starterPack or casesDivider,
	BlackCatFinisher = frame or starterPack or casesDivider,
	VampireBundle = premium2Bundle or starterPack or casesDivider,
	VampireKnife = premium2Bundle or starterPack or casesDivider,
	VampireGun = premium2Bundle or starterPack or casesDivider,
	VampireFinisher = premium2Bundle or starterPack or casesDivider
}
local t4: {[any]: any} = {
	{
		name = "Featured",
		anchor = starterPack or releasePack or casesDivider
	},
	{ name = "Daily", anchor = dailyEmotes or casesDivider },
	{ name = "Cases", anchor = casesDivider },
	{ name = "Currency", anchor = currencyDivider },
	{ name = "Codes", anchor = codesDivider }
}
local u74 = nil
local CrateId = nil
local n1 = 0
local u77 = nil
local v78 = hoverInfoModule.create(shopWindow)
local u79: boolean = false

uiFramework.setupCoinCounter(v19, LocalPlayer)

local function setNavActive(p2, p3)
	local v231 = if p3 then color3 else color32
	local imageLabel = p2:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.ImageColor3 = v231
	end

	local textLabel2 = p2:FindFirstChild("TextLabel")

	if textLabel2 and textLabel2:IsA("TextLabel") then
		textLabel2.TextColor3 = v231
	end
end
local function setActiveNavByName(p4)
	for _, v in ipairs(navigator:GetChildren()) do
		if v:IsA("ImageButton") and p4 == v.Name then
			if u77 and v ~= u77 then
				setNavActive(u77, false)
			end

			u77 = v
			setNavActive(v, true)
		end
	end
end
local function jumpToSection(p5: string)
	local v238 = t3[p5]

	if not v238 or not v238.Visible then
		p5 = "Featured"
		v238 = t3.Featured
	end

	if not v238 then
		return
	end

	if casePurchase5b3.Visible then
		casePurchase5b3.Visible = false
		content.Visible = true
		hoverInfoModule.hide(v78)
		CrateId = nil
	end

	local v239 = math.clamp(if p5 == "Featured" then 0 else scrollingFrame.CanvasPosition.Y + (v238.AbsolutePosition.Y - scrollingFrame.AbsolutePosition.Y), 0, scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteSize.Y)
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local vector2 = Vector2.new(0, v239)

	tweenService:Create(scrollingFrame, tweenInfo, { CanvasPosition = vector2 }):Play()
	setActiveNavByName(p5)
end

for _, v in ipairs(navigator:GetChildren()) do
	if v:IsA("ImageButton") then
		local vName = v.Name

		if t3[vName] then
			v.MouseButton1Click:Connect(function()
				jumpToSection(vName)
			end)

			if vName == "Featured" then
				u77 = v
				setNavActive(v, true)
			else
				setNavActive(v, false)
			end
		end
	end
end

scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	if casePurchase5b3.Visible then
		return
	end

	local y = scrollingFrame.AbsolutePosition.Y
	local v243 = scrollingFrame.CanvasPosition.Y
	local n1 = scrollingFrame.AbsoluteCanvasSize.Y - scrollingFrame.AbsoluteSize.Y

	if v243 <= 1 then
		setActiveNavByName("Featured")

		return
	end

	if n1 > 0 and v243 >= n1 - 2 then
		setActiveNavByName(t4[#t4].name)

		return
	end

	local v245 = t4[1].name

	for _, v in ipairs(t4) do
		local vAnchor = v.anchor

		if vAnchor and vAnchor.Parent and vAnchor.AbsolutePosition.Y - y <= 10 then
			v245 = v.name
		end
	end

	setActiveNavByName(v245)
end)

local function commaFormat(p6)
	local floored = math.floor(p6)
	local text = tostring(floored)

	repeat
		local v252, v253 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v252
	until v253 == 0

	return text
end
local function setNestedText(p7, p8, text)
	local foundChild = p7:FindFirstChild(p8)

	if foundChild and foundChild:IsA("TextLabel") then
		foundChild.Text = text

		local textLabel3 = foundChild:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.Text = text
		end
	end
end

local v88 = packCatalog.Get("ReleasePack")
local releasePackBuyButton: Instance = releasePack and releasePack:FindFirstChild("BuyButton")
local giftButton: Instance = releasePack and releasePack:FindFirstChild("GiftButton")

dailyEmotes = releasePack and releasePack:FindFirstChild("Timer")

local textLabel4 = nil

if dailyEmotes then
	textLabel4 = dailyEmotes:FindFirstChild("TextLabel")
end

if RP_StockTextLabelInner and RP_StockTextLabelInner:FindFirstChild("UIGradient") then
	task.spawn(function()
		while v259 and v259.Parent do
			local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local v261: Tween = tweenService:Create(v259, tweenInfo, { Offset = Vector2.new(0.6, 0) })

			v261:Play()
			v261.Completed:Wait()
			v259.Offset = Vector2.new(-0.6, 0)
			task.wait(1)
		end
	end)
end

local t5 = {}
local u93 = false
local u94 = nil
local t6 = {}

if releasePack then
	local n2: number = 0

	for _, v in ipairs(releasePack:GetDescendants()) do
		if v:IsA("ImageLabel") and v.Name == "Sunburst" then
			local connection = nil
			local vParent = v.Parent
			local vParentPosition = vParent.Position

			n2 += 1
			connection = runService.Heartbeat:Connect(function(deltaTime: number)
				if not v:IsDescendantOf(game) then
					connection:Disconnect()

					return
				end

				local vParent2 = v.Parent
				local scrollingFrameAbsolutePosition = scrollingFrame.AbsolutePosition
				local scrollingFrameAbsolutePositionY = scrollingFrameAbsolutePosition.Y
				local n1 = scrollingFrameAbsolutePosition.Y + scrollingFrame.AbsoluteSize.Y
				local vParent2AbsolutePosition = vParent2.AbsolutePosition
				local vParent2AbsolutePositionY = vParent2AbsolutePosition.Y
				local n5 = vParent2AbsolutePosition.Y + vParent2.AbsoluteSize.Y
				local v270 = elapsedTime()
				local n3: number = n2 * 0.1 + 0.6
				local n4: number = n2 * 0.7
				local sine = math.sin(v270 * n3 + n4)
				local sine2 = math.sin(v270 * n3 * 0.5 + n4 * 2)
				local cosine = math.cos(v270 * n3 + n4)
				local sine3 = math.sin(v270 * n3 * 0.3 + n4)
				local v277 = UDim2.fromScale(sine * 0.006 + sine2 * 0.003, cosine * 0.02 + sine3 * 0.01)

				if vParent2AbsolutePositionY >= scrollingFrameAbsolutePositionY and n1 >= n5 then
					v.Rotation = (v.Rotation + deltaTime * 15) % 360
					vParent.Rotation = math.sin(v270 * 0.8 + n4) * 2
				else
					v.Rotation = 0
					vParent.Rotation = 0
				end

				vParent.Position = vParent.Position:Lerp(vParentPosition + v277, 0.08)
			end)
		end
	end

	local uiGradient: Instance = releasePack:WaitForChild("Effect"):WaitForChild("UIGradient")
	local connection = nil

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		if not uiGradient:IsDescendantOf(game) then
			connection:Disconnect()

			return
		end

		local v279 = elapsedTime()
		local sine = math.sin(v279)

		uiGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, (sine + 1) * 0.5 * 0.6000000000000001 + 0.2)
		})
	end)

	local headerUiGradient: Instance = releasePack:WaitForChild("Header"):WaitForChild("UIGradient")
	local connection2 = nil

	connection2 = runService.Heartbeat:Connect(function(deltaTime: number)
		if not headerUiGradient:IsDescendantOf(game) then
			connection2:Disconnect()

			return
		end

		local v282 = elapsedTime()
		local sine = math.sin(v282)
		local numberSequenceNew = NumberSequence.new
		local numberSequenceKeypoint = NumberSequenceKeypoint.new(0.6, (sine + 1) * 0.5 * 0.8 + 0)

		headerUiGradient.Transparency = numberSequenceNew({
			NumberSequenceKeypoint.new(0, 0),
			numberSequenceKeypoint,
			NumberSequenceKeypoint.new(1, 1)
		})
	end)
	releasePack:WaitForChild("Stiletto").MouseButton1Click:Connect(function()
		replicatedStorage.Bindables.InspectItem:Fire({
			Kind = "Knife",
			ItemId = "GoldenStiletto",
			Name = "Golden Stiletto",
			Rarity = "Legendary"
		})
	end)
	releasePack:WaitForChild("Luger").MouseButton1Click:Connect(function()
		replicatedStorage.Bindables.InspectItem:Fire({
			Kind = "Revolver",
			ItemId = "GoldenLuger",
			Name = "Golden Luger",
			Rarity = "Legendary"
		})
	end)
end

local function formatPackTimer(p13)
	if p13 <= 0 then
		return "EXPIRED"
	end

	local floored = math.floor(p13 / 86400)
	local floored2 = math.floor(p13 % 86400 / 3600)
	local floored3 = math.floor(p13 % 3600 / 60)
	local floored4 = math.floor(p13 % 60)

	if floored > 0 then
		return floored .. "d " .. floored2 .. "h " .. floored3 .. "m " .. floored4 .. "s"
	end

	if floored2 > 0 then
		return floored2 .. "h " .. floored3 .. "m " .. floored4 .. "s"
	end

	return floored3 .. "m " .. floored4 .. "s"
end
local function refreshReleasePackUI()
	if not releasePack or not v88 then
		return
	end

	local v291 = t5[v88.Id]
	local v292 = if typeof(v291) == "number" then v291 else if v291 == true then 1 else 0
	local v293 = v88.PurchaseLimit

	u93 = packCatalog.IsExpired(v88)

	if v293 > 0 and v293 <= v292 then
		if releasePackBuyButton then
			uiFramework.setButtonDisabled(releasePackBuyButton)

			local textLabel5: Instance = releasePackBuyButton:FindFirstChild("TextLabel")

			if textLabel5 and textLabel5:IsA("TextLabel") then
				textLabel5.Text = "OWNED"

				local textLabel6: Instance = textLabel5:FindFirstChild("TextLabel")

				if textLabel6 and textLabel6:IsA("TextLabel") then
					textLabel6.Text = "OWNED"
				end
			end
		end

		if giftButton then
			uiFramework.setButtonEnabled(giftButton)
		end
	elseif not u93 then
		if releasePackBuyButton then
			uiFramework.setButtonEnabled(releasePackBuyButton)

			local text: string = if u94 then utf8.char(57346) .. " " .. commaFormat(u94) else "..."
			local textLabel7: Instance = releasePackBuyButton:FindFirstChild("TextLabel")

			if textLabel7 and textLabel7:IsA("TextLabel") then
				textLabel7.Text = text

				local textLabel8: Instance = textLabel7:FindFirstChild("TextLabel")

				if textLabel8 and textLabel8:IsA("TextLabel") then
					textLabel8.Text = text
				end
			end
		end

		if giftButton then
			uiFramework.setButtonEnabled(giftButton)
		end
	elseif releasePack then
		releasePack.Visible = false
	end

	local purchaseLimit: Instance = releasePack:FindFirstChild("PurchaseLimit")

	if purchaseLimit then
		local stringFormat = string.format
		local v301 = math.min(v292, v293)

		purchaseLimit.Text = stringFormat("Purchase limit: <font color=\"#ff5c5c\">%d/%d</font>", v301, v293)
	end
end

task.spawn(function()
	local v302
	local v303
	local v304

	while true do
		if v88 and textLabel4 then
			v302 = packCatalog.GetTimeRemaining(v88)
			v303 = textLabel4
			v304 = formatPackTimer(v302)
			v303.Text = v304

			if v302 <= 0 and not u93 then
				refreshReleasePackUI()
			end
		end

		task.wait(1)

		continue
	end
end)

if releasePackBuyButton and v88 then
	releasePackBuyButton.MouseButton1Click:Connect(function()
		if not releasePackBuyButton.Interactable then
			return
		end

		local v305 = t5[v88.Id]
		local typeName: string = typeof(v305)
		local purchaseLimit = v88.PurchaseLimit

		if purchaseLimit > 0 and purchaseLimit <= (if typeName == "number" then v305 else if v305 == true then 1 else 0) or u93 then
			return
		end

		showPurchaseModal:Fire({
			ProductId = v88.BuyProductId,
			Name = v88.DisplayName,
			RobuxPrice = u94
		})
	end)
end

if giftButton and v88 then
	giftButton.MouseButton1Click:Connect(function()
		if not giftButton.Interactable then
			return
		end

		if u93 then
			return
		end

		openGiftingMenu({
			currency = "Cash",
			amount = 0,
			productId = v88.GiftProductId,
			displayName = v88.DisplayName
		})
	end)
end

local v108 = packCatalog.Get("StarterPack")

local function starterPackExpired()
	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
	local u309: boolean = false

	if typeof(starterPackExpiresAt) == "number" then
		local timestamp = os.time()

		u309 = starterPackExpiresAt - timestamp <= 0
	end

	return u309
end

local starterPackBuyButton: Instance = starterPack and starterPack:FindFirstChild("BuyButton")
local starterPackGiftButton: Instance = starterPack and starterPack:FindFirstChild("GiftButton")
local u112: boolean = false
local u113 = nil

dailyEmotes = starterPack and starterPack:FindFirstChild("Timer")

local v114 = if dailyEmotes then dailyEmotes:FindFirstChild("TextLabel") else nil

if starterPackGiftButton then
	starterPackGiftButton.Visible = false
end

if starterPack then
	for _, v in ipairs(starterPack:GetDescendants()) do
		if v:IsA("ImageLabel") and v.Name == "Sunburst" then
			local connection = nil

			connection = runService.Heartbeat:Connect(function(deltaTime: number)
				if not v:IsDescendantOf(game) then
					connection:Disconnect()

					return
				end

				local vParent = v.Parent
				local scrollingFrameAbsolutePosition = scrollingFrame.AbsolutePosition
				local vParentAbsolutePosition = vParent.AbsolutePosition

				if vParentAbsolutePosition.Y >= scrollingFrameAbsolutePosition.Y and scrollingFrameAbsolutePosition.Y + scrollingFrame.AbsoluteSize.Y >= vParentAbsolutePosition.Y + vParent.AbsoluteSize.Y then
					v.Rotation = (v.Rotation + deltaTime * 15) % 360

					return
				end

				v.Rotation = 0
			end)
		end
	end
end

dailyEmotes = scrollingFrame:FindFirstChild("Currencies")

local package5: Instance = dailyEmotes and dailyEmotes:FindFirstChild("Package5")

if package5 and package5:IsA("GuiObject") then
	local t7: {[any]: any} = {}

	for _, v in ipairs(package5:GetChildren()) do
		if v:IsA("ImageLabel") and v.Name == "Sunburst" then
			table.insert(t7, v)
		end
	end

	if #t7 > 0 then
		local n3: number = 0
		local u123: boolean = false
		local connection = nil

		connection = runService.Heartbeat:Connect(function(deltaTime: number)
			if not package5:IsDescendantOf(game) then
				connection:Disconnect()

				return
			end

			local v316 = shopWindow.Visible and content.Visible and package5.Visible

			if v316 then
				local y = scrollingFrame.AbsolutePosition.Y
				local v318 = package5.AbsolutePosition.Y

				v316 = y <= v318 and y + scrollingFrame.AbsoluteSize.Y >= v318 + package5.AbsoluteSize.Y
			end

			if v316 then
				u123 = true
				n3 = (n3 + deltaTime * 15) % 360

				for _, v in ipairs(t7) do
					v.Rotation = n3
				end
			elseif u123 then
				u123 = false
				n3 = 0

				for _, v in ipairs(t7) do
					v.Rotation = 0
				end
			end
		end)
	end
end

local function refreshStarterPackUI()
	if not starterPack or not v108 then
		return
	end

	local v323 = t5[v108.Id]
	local v324 = if typeof(v323) == "number" then v323 else if v323 == true then 1 else 0
	local u325: boolean = LocalPlayer:GetAttribute("OwnsPack_StarterPack") == true
	local purchaseLimit = v108.PurchaseLimit
	local u327

	if purchaseLimit > 0 then
		u327 = true

		if not (v324 >= purchaseLimit) then
			u327 = u325
		end
	else
		u327 = u325
	end

	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
	local u329: boolean = false

	if typeof(starterPackExpiresAt) == "number" then
		local timestamp = os.time()

		u329 = starterPackExpiresAt - timestamp <= 0
	end

	u112 = u329

	if u327 or u112 then
		starterPack.Visible = false
	else
		starterPack.Visible = true

		if starterPackBuyButton then
			uiFramework.setButtonEnabled(starterPackBuyButton)

			local text: string = if u113 then utf8.char(57346) .. " " .. commaFormat(u113) else "..."
			local textLabel9: Instance = starterPackBuyButton:FindFirstChild("TextLabel")

			if textLabel9 and textLabel9:IsA("TextLabel") then
				textLabel9.Text = text

				local textLabel10: Instance = textLabel9:FindFirstChild("TextLabel")

				if textLabel10 and textLabel10:IsA("TextLabel") then
					textLabel10.Text = text
				end
			end
		end
	end

	local textLabel11 = starterPack:FindFirstChild("TextLabel")

	for _, v in ipairs(starterPack:GetChildren()) do
		if v:IsA("TextLabel") and string.find(v.Text, "Purchase limit", 1, true) then
			textLabel11 = v

			break
		end
	end

	if textLabel11 and string.find(textLabel11.Text, "Purchase limit", 1, true) then
		local v337 = math.min(v324, purchaseLimit)

		if u325 then
			v337 = purchaseLimit
		end

		textLabel11.Text = string.format("Purchase limit: <font color=\"#ff5c5c\">%d/%d</font>", v337, purchaseLimit)
	end
end

if starterPackBuyButton and v108 then
	starterPackBuyButton.MouseButton1Click:Connect(function()
		if not starterPackBuyButton.Interactable then
			return
		end

		local v338 = t5[v108.Id]
		local typeName: string = typeof(v338)
		local purchaseLimit = v108.PurchaseLimit

		if purchaseLimit > 0 and purchaseLimit <= (if typeName == "number" then v338 else if v338 == true then 1 else 0) or u112 then
			return
		end

		if LocalPlayer:GetAttribute("OwnsPack_StarterPack") == true then
			return
		end

		currencyBuyRequest:FireServer(v108.BuyProductId)
	end)
end

if starterPackGiftButton and v108 then
	starterPackGiftButton.MouseButton1Click:Connect(function()
		if not starterPackGiftButton.Interactable then
			return
		end

		if u112 then
			return
		end

		openGiftingMenu({
			currency = "Cash",
			amount = 0,
			productId = v108.GiftProductId,
			displayName = v108.DisplayName
		})
	end)
end

task.spawn(function()
	local starterPackExpiresAt
	local typeName
	local timestamp
	local n1
	local v345
	local v346

	while true do
		starterPackExpiresAt = LocalPlayer:GetAttribute("StarterPackExpiresAt")
		typeName = typeof(starterPackExpiresAt)

		if typeName == "number" and v114 then
			timestamp = os.time()
			n1 = starterPackExpiresAt - timestamp
			v345 = v114
			v346 = formatPackTimer(n1)
			v345.Text = v346

			if n1 <= 0 and not u112 then
				refreshStarterPackUI()
			end
		end

		task.wait(1)

		continue
	end
end)
LocalPlayer:GetAttributeChangedSignal("StarterPackExpiresAt"):Connect(refreshStarterPackUI)
LocalPlayer:GetAttributeChangedSignal("OwnsPack_StarterPack"):Connect(function()
	refreshStarterPackUI()
end)

local t8: {[any]: any} = {}
local t9: {[any]: any} = {}
local t10: {[any]: any} = {}
local t11: {[any]: any} = {}
local t12: {[any]: any} = {}
local t13: {[any]: any} = {}
local t14: {[any]: any} = {}

for _, v in pairs(packCatalog.Packs) do
	local v135 = packCatalog.ColorGroupOf(v)

	if v135 and not t14[v135] then
		t14[v135] = v
	end
end

local function getPackPurchaseCount(p16)
	local v348 = t5[p16]

	if typeof(v348) == "number" then
		return v348
	end

	if v348 == true then
		return 1
	end

	return 0
end

dailyEmotes = function(p17, p18, p19, p20, p21)
	if not p17 then
		warn("[ShopController] Bundle frame for '" .. p18 .. "' not found in ScrollingFrame")

		return
	end

	local v354 = packCatalog.Get(p18)

	if not v354 then
		warn("[ShopController] Bundle pack '" .. p18 .. "' missing from PackCatalog")

		return
	end

	local v355 = if p19 then packCatalog.Get(p19) else nil
	local v356 = if p20 then packCatalog.Get(p20) else nil
	local v357 = if p21 then packCatalog.Get(p21) else nil
	local buyButton = p17:FindFirstChild("BuyButton")
	local giftButton = p17:FindFirstChild("GiftButton")
	local timer = p17:FindFirstChild("Timer")
	local textLabel = timer and timer:FindFirstChild("TextLabel")
	local individualBuyButtons = p17:FindFirstChild("IndividualBuyButtons")
	local knifeBuyButton = individualBuyButtons and individualBuyButtons:FindFirstChild("KnifeBuyButton")
	local gunBuyButton = individualBuyButtons and individualBuyButtons:FindFirstChild("GunBuyButton")
	local finisherBuyButton = individualBuyButtons and individualBuyButtons:FindFirstChild("FinisherBuyButton")
	local u366 = false
	local discount = p17:FindFirstChild("Discount")

	local function addComponentPrice(p22, p23)
		if p22 == nil then
			return nil
		end

		if p23 == nil then
			return p22
		end

		local v805 = t8[p23.Id]

		if typeof(v805) == "number" and not (v805 <= 0) then
			return p22 + v805
		end

		return nil
	end
	local function refreshDiscount()
		if not discount then
			return
		end

		local v806 = t8[v354.Id]
		local v807 = v355
		local v808

		if 0 == nil then
			v808 = nil
		elseif v807 == nil then
			v808 = 0
		else
			local v809 = t8[v807.Id]

			v808 = if typeof(v809) == "number" and not (v809 <= 0) then 0 + v809 else nil
		end

		local n1 = v808
		local v811 = v356
		local v812

		if n1 == nil then
			v812 = nil
		elseif v811 == nil then
			v812 = n1
		else
			local v813 = t8[v811.Id]

			v812 = if typeof(v813) == "number" and not (v813 <= 0) then n1 + v813 else nil
		end

		local n2 = v812
		local v815 = v357
		local v816

		if n2 == nil then
			v816 = nil
		elseif v815 == nil then
			v816 = n2
		else
			local v817 = t8[v815.Id]

			v816 = if typeof(v817) == "number" and not (v817 <= 0) then n2 + v817 else nil
		end

		if p17:GetAttribute("PaintedCard") then
			local red = buyButton and buyButton:FindFirstChild("Red")
			local frame = buyButton and buyButton:FindFirstChild("Frame")
			local visible: boolean = v816 ~= nil and v816 > 0 and typeof(v806) == "number" and v806 > 0 and v806 < v816

			if red and red:IsA("TextLabel") then
				red.Visible = visible

				if visible then
					red.Text = commaFormat(v816)
				end
			end

			if frame and frame:IsA("GuiObject") then
				frame.Visible = visible
			end
		end

		if typeof(v806) == "number" and v806 > 0 and v816 ~= nil and v806 < v816 then
			local rounded = math.round((1 - v806 / v816) * 100)

			if rounded >= 1 then
				local text: string = tostring(rounded) .. "% OFF!"
				local textLabel12 = discount:FindFirstChild("TextLabel")

				if textLabel12 and textLabel12:IsA("TextLabel") then
					textLabel12.Text = text

					local textLabel13 = textLabel12:FindFirstChild("TextLabel")

					if textLabel13 and textLabel13:IsA("TextLabel") then
						textLabel13.Text = text
					end
				end

				discount.Visible = true

				return
			end

			discount.Visible = false

			return
		end

		discount.Visible = false
	end
	local function refreshButton(p24, p25)
		if p24 and p25 then
			local v827 = t5[p25.Id]
			local typeName: string = typeof(v827)
			local purchaseLimit = p25.PurchaseLimit

			if purchaseLimit > 0 and (if typeName == "number" then v827 else if v827 == true then 1 else 0) >= purchaseLimit then
				uiFramework.setButtonDisabled(p24)

				local textLabel14 = p24:FindFirstChild("TextLabel")

				if textLabel14 and textLabel14:IsA("TextLabel") then
					textLabel14.Text = "OWNED"

					local textLabel15 = textLabel14:FindFirstChild("TextLabel")

					if textLabel15 and textLabel15:IsA("TextLabel") then
						textLabel15.Text = "OWNED"

						return
					end
				end
			else
				uiFramework.setButtonEnabled(p24)

				local v832 = t8[p25.Id]
				local text: string = if v832 then utf8.char(57346) .. " " .. commaFormat(v832) else "..."
				local textLabel16 = p24:FindFirstChild("TextLabel")

				if textLabel16 and textLabel16:IsA("TextLabel") then
					textLabel16.Text = text

					local textLabel17 = textLabel16:FindFirstChild("TextLabel")

					if textLabel17 and textLabel17:IsA("TextLabel") then
						textLabel17.Text = text
					end
				end
			end

			return
		end
	end
	local function refresh()
		u366 = packCatalog.IsExpired(v354)

		if u366 then
			p17.Visible = false

			return
		end

		if v354.ReleaseKey then
			if not packCatalog.IsReleased(v354) then
				p17.Visible = false

				return
			end

			p17.Visible = true
		end

		refreshButton(buyButton, v354)
		refreshButton(knifeBuyButton, v355)
		refreshButton(gunBuyButton, v356)
		refreshButton(finisherBuyButton, v357)
		refreshDiscount()

		if giftButton then
			uiFramework.setButtonEnabled(giftButton)
		end
	end

	table.insert(t9, refresh)

	local function wireBuy(p26, p27)
		if p26 and p27 then
			p26.MouseButton1Click:Connect(function()
				if not p26.Interactable then
					return
				end

				if not not u366 or not not packCatalog.IsExpired(p27) or not packCatalog.IsReleased(p27) then
					return
				end

				local purchaseLimit = p27.PurchaseLimit
				local v1254
				local t48

				if purchaseLimit > 0 then
					local v1256 = t5[p27.Id]

					if purchaseLimit <= (if typeof(v1256) == "number" then v1256 else if v1256 == true then 1 else 0) then
						return
					end

					v1254 = p27.Id
					t48 = {
						ProductId = p27.BuyProductId,
						Name = p27.DisplayName,
						RobuxPrice = t8[v1254]
					}
					showPurchaseModal:Fire(t48)

					return
				end

				v1254 = p27.Id
				t48 = {
					ProductId = p27.BuyProductId,
					Name = p27.DisplayName,
					RobuxPrice = t8[v1254]
				}
				showPurchaseModal:Fire(t48)
			end)

			return
		end
	end

	if buyButton and v354 then
		buyButton.MouseButton1Click:Connect(function()
			if not buyButton.Interactable then
				return
			end

			if not not u366 or not not packCatalog.IsExpired(v354) or not packCatalog.IsReleased(v354) then
				return
			end

			local purchaseLimit = v354.PurchaseLimit
			local v839
			local t40

			if purchaseLimit > 0 then
				local v841 = t5[v354.Id]

				if purchaseLimit <= (if typeof(v841) == "number" then v841 else if v841 == true then 1 else 0) then
					return
				end

				v839 = v354.Id
				t40 = {
					ProductId = v354.BuyProductId,
					Name = v354.DisplayName,
					RobuxPrice = t8[v839]
				}
				showPurchaseModal:Fire(t40)

				return
			end

			v839 = v354.Id
			t40 = {
				ProductId = v354.BuyProductId,
				Name = v354.DisplayName,
				RobuxPrice = t8[v839]
			}
			showPurchaseModal:Fire(t40)
		end)
	end

	if knifeBuyButton and v355 then
		knifeBuyButton.MouseButton1Click:Connect(function()
			if not knifeBuyButton.Interactable then
				return
			end

			if not not u366 or not not packCatalog.IsExpired(v355) or not packCatalog.IsReleased(v355) then
				return
			end

			local purchaseLimit = v355.PurchaseLimit
			local v843
			local t41

			if purchaseLimit > 0 then
				local v845 = t5[v355.Id]

				if purchaseLimit <= (if typeof(v845) == "number" then v845 else if v845 == true then 1 else 0) then
					return
				end

				v843 = v355.Id
				t41 = {
					ProductId = v355.BuyProductId,
					Name = v355.DisplayName,
					RobuxPrice = t8[v843]
				}
				showPurchaseModal:Fire(t41)

				return
			end

			v843 = v355.Id
			t41 = {
				ProductId = v355.BuyProductId,
				Name = v355.DisplayName,
				RobuxPrice = t8[v843]
			}
			showPurchaseModal:Fire(t41)
		end)
	end

	if gunBuyButton and v356 then
		gunBuyButton.MouseButton1Click:Connect(function()
			if not gunBuyButton.Interactable then
				return
			end

			if not not u366 or not not packCatalog.IsExpired(v356) or not packCatalog.IsReleased(v356) then
				return
			end

			local purchaseLimit = v356.PurchaseLimit
			local v847
			local t42

			if purchaseLimit > 0 then
				local v849 = t5[v356.Id]

				if purchaseLimit <= (if typeof(v849) == "number" then v849 else if v849 == true then 1 else 0) then
					return
				end

				v847 = v356.Id
				t42 = {
					ProductId = v356.BuyProductId,
					Name = v356.DisplayName,
					RobuxPrice = t8[v847]
				}
				showPurchaseModal:Fire(t42)

				return
			end

			v847 = v356.Id
			t42 = {
				ProductId = v356.BuyProductId,
				Name = v356.DisplayName,
				RobuxPrice = t8[v847]
			}
			showPurchaseModal:Fire(t42)
		end)
	end

	if finisherBuyButton and v357 then
		finisherBuyButton.MouseButton1Click:Connect(function()
			if not finisherBuyButton.Interactable then
				return
			end

			if not not u366 or not not packCatalog.IsExpired(v357) or not packCatalog.IsReleased(v357) then
				return
			end

			local purchaseLimit = v357.PurchaseLimit
			local v851
			local t43

			if purchaseLimit > 0 then
				local v853 = t5[v357.Id]

				if purchaseLimit <= (if typeof(v853) == "number" then v853 else if v853 == true then 1 else 0) then
					return
				end

				v851 = v357.Id
				t43 = {
					ProductId = v357.BuyProductId,
					Name = v357.DisplayName,
					RobuxPrice = t8[v851]
				}
				showPurchaseModal:Fire(t43)

				return
			end

			v851 = v357.Id
			t43 = {
				ProductId = v357.BuyProductId,
				Name = v357.DisplayName,
				RobuxPrice = t8[v851]
			}
			showPurchaseModal:Fire(t43)
		end)
	end

	if giftButton and v354.GiftProductId then
		giftButton.MouseButton1Click:Connect(function()
			if not giftButton.Interactable then
				return
			end

			if u366 then
				return
			end

			openGiftingMenu({
				currency = "Cash",
				amount = 0,
				productId = v354.GiftProductId,
				displayName = v354.DisplayName
			})
		end)
	end

	if textLabel then
		task.spawn(function()
			local v854 = packCatalog.IsReleased(v354)

			while p17.Parent do
				local v855 = packCatalog.GetTimeRemaining(v354)

				textLabel.Text = formatPackTimer(v855)

				if v855 <= 0 then
					if u366 then
						break
					end

					refresh()

					return
				end

				v855 = packCatalog.IsReleased(v354)

				if v854 ~= v855 then
					v854 = v855
					refresh()
				end

				task.wait(1)
			end
		end)
	end

	refresh()
end

local function setupBundleColors(p28, p29)
	if not p28 then
		return
	end

	local v375 = packCatalog.Get(p29)

	if not v375 or not packCatalog.HasColors(v375) then
		return
	end

	local v376 = packCatalog.ColorGroupOf(v375)

	if not v376 then
		return
	end

	local colorSelector = p28:FindFirstChild("ColorSelector")

	if not colorSelector then
		warn("[ShopController] Pack '" .. p29 .. "' declares colours but its card has no ColorSelector")

		return
	end

	t10[v376] = t10[v376] or packCatalog.DefaultColorKey(v375)

	local t19: {[any]: any} = {}

	for _, v in ipairs(v375.Colors) do
		local foundChild = colorSelector:FindFirstChild(v.Key, true)

		if foundChild and foundChild:IsA("GuiButton") then
			t19[v.Key] = foundChild
		else
			warn("[ShopController] ColorSelector on '" .. p29 .. "' has no button named '" .. v.Key .. "'")
		end
	end

	local t20: {[any]: any} = {}

	for _, v in ipairs(p28:GetDescendants()) do
		if v:IsA("ImageLabel") and (v.Name == "Knife" or v.Name == "Gun" or v.Name == "Finisher") then
			table.insert(t20, { lbl = v, kind = v.Name, default = v.Image })
		end
	end

	local foundChild2 = p28:FindFirstChild("Effect", true)
	local icon = foundChild2 and foundChild2:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		table.insert(t20, { kind = "Finisher", lbl = icon, default = icon.Image })
	end

	local function render()
		local v856 = t10[v376]
		local v857 = nil

		for _, v in ipairs(v375.Colors) do
			if v856 == v.Key then
				v857 = v
			end
		end

		for k, v in pairs(t19) do
			local u862: boolean = k == v856
			local v863 = nil

			for _, iterValue in ipairs(v375.Colors) do
				if k == iterValue.Key then
					v863 = iterValue.Swatch
				end
			end

			local orb = v:FindFirstChild("Orb")

			if orb and orb:IsA("ImageLabel") then
				orb.ImageColor3 = if u862 then Color3.new(1, 1, 1) else Color3.new(0.38, 0.38, 0.38)
				orb.ImageTransparency = if u862 then 0 else 0.15
			else
				local darkenDeselectedCover = v:FindFirstChild("DarkenDeselectedCover")

				if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
					darkenDeselectedCover.Visible = not u862
				end

				local selectRing = v:FindFirstChild("SelectRing")

				if selectRing and selectRing:IsA("UIStroke") then
					selectRing.Transparency = if u862 then 0 else 1
				end

				if v863 then
					local v869

					if u862 then
						v869 = v863:Lerp(Color3.new(1, 1, 1), 0.22)
					else
						v869 = v863
					end

					v.BackgroundColor3 = v869
				end
			end

			local glyph = v:FindFirstChild("Glyph")

			if glyph and glyph:IsA("TextLabel") then
				glyph.TextTransparency = if u862 then 0 else 0.25
			end
		end

		if v857 then
			local art = v857.Art

			for _, v in ipairs(t20) do
				v.lbl.Image = if art and art[v.kind] then art[v.kind] else v.default
			end

			local v874 = t13[v376]

			if v874 then
				v874(v857.Swatch)
			end
		end
	end

	for k, v in pairs(t19) do
		v.Activated:Connect(function()
			if not v.Interactable then
				return
			end

			local v875 = k

			if t10[v376] == v875 then
				return
			end

			t10[v376] = v875
			render()
			packColorSelect:FireServer(p29, v875)
		end)
	end

	local function reassert()
		local v876 = t10[v376]

		if v876 then
			packColorSelect:FireServer(p29, v876)
		end
	end
	local function wireReassert(p31)
		if not p31 then
			return
		end

		for _, v in ipairs({
			"BuyButton",
			"GiftButton",
			"KnifeBuyButton",
			"GunBuyButton",
			"FinisherBuyButton"
		}) do
			local v = p31:FindFirstChild(v)

			if v and v:IsA("GuiButton") then
				v.MouseButton1Click:Connect(reassert)
			end
		end
	end

	wireReassert(p28)
	wireReassert(p28:FindFirstChild("IndividualBuyButtons"))
	t11[v376] = render
	t12[p29] = function(p30)
		if p30 == t10[v376] then
			return
		end

		t10[v376] = p30
		render()
		packColorSelect:FireServer(p29, p30)
	end
	render()
end

codesDivider = scrollingFrame:FindFirstChild("MegalodonBundle")
dailyEmotes(codesDivider, "MegalodonBundle", "MegalodonKnife", "MegalodonGun")
codesDivider = scrollingFrame:FindFirstChild("MermaidBundle")
dailyEmotes(codesDivider, "MermaidBundle", "MermaidKnife", "MermaidGun")
codesDivider = function(p32, p33, p34)
	if not p32 then
		return
	end

	local v395 = packCatalog.Get(p33)
	local previewItems = v395 and v395.PreviewItems

	if v395 and previewItems then
		p32:SetAttribute("PaintedCard", true)

		local t21: {[any]: any} = {}

		for _, v in ipairs(previewItems) do
			t21[v.Kind] = v
		end

		local header = p32:FindFirstChild("Header")
		local textLabel = header and header:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = v395.DisplayName

			local textLabel18 = textLabel:FindFirstChild("TextLabel")

			if textLabel18 and textLabel18:IsA("TextLabel") then
				textLabel18.Text = v395.DisplayName
			end

			local chance = textLabel:FindFirstChild("Chance")

			if chance and chance:IsA("TextLabel") then
				chance.Text = p34 or ""
				chance.Visible = p34 ~= nil
			end
		end

		local t22: {[any]: any} = { Knife = t21.Knife, Gun = t21.Revolver, Finisher = t21.Finisher }

		for _, v in ipairs(p32:GetChildren()) do
			local v407 = t22[v.Name]

			if v407 and v:IsA("ImageLabel") and v407.Icon then
				v.Image = v407.Icon
			end
		end

		local effect = p32:FindFirstChild("Effect")
		local finisher = t21.Finisher

		if effect and finisher then
			local icon = effect:FindFirstChild("Icon")

			if icon and icon:IsA("ImageLabel") and finisher.Icon then
				icon.Image = finisher.Icon
			end

			local effectName = effect:FindFirstChild("EffectName")

			if effectName and effectName:IsA("TextLabel") then
				effectName.Text = "★ " .. tostring(finisher.Name or finisher.ItemId)
			end
		end

		local colorSelector = p32:FindFirstChild("ColorSelector")

		if colorSelector and colorSelector:IsA("GuiObject") and not packCatalog.HasColors(v395) then
			colorSelector.Visible = false
		end

		return
	end

	warn("[ShopController] paintBundleCard: '" .. p33 .. "' has no PreviewItems")
end
currencyDivider = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
casesDivider = require(currencyDivider:WaitForChild("PackVariants")).ChanceFor(packCatalog.Get("BlackCatBundle"))
currencyDivider = math.floor(casesDivider * 100 + 0.5)
codesDivider(frame, "BlackCatBundle", currencyDivider .. "% Chance: White Variant")
codesDivider(premium2Bundle, "VampireBundle", nil)
dailyEmotes(frame, "BlackCatBundle", "BlackCatKnife", "BlackCatGun", "BlackCatFinisher")
dailyEmotes(premium2Bundle, "VampireBundle", "VampireKnife", "VampireGun", "VampireFinisher")
currencyDivider = function(p35)
	if not p35 then
		return
	end

	local header = p35:FindFirstChild("Header")
	local textLabel = header and header:FindFirstChild("TextLabel")
	local v416 = textLabel

	if v416 then
		v416 = textLabel:FindFirstChild("Chance")
	end

	if v416 and v416:IsA("TextLabel") then
		traitText.Bind(v416, v416.Text)
	end
end
currencyDivider(frame)
currencyDivider(premium2Bundle)
bindables:WaitForChild("PackColorChoose").Event:Connect(function(p36, p37)
	if typeof(p36) == "string" and typeof(p37) == "string" then
		local v419 = t12[p36]

		if v419 then
			v419(p37)
		end

		return
	end
end)

local t15: {[any]: any} = {}

currencyDivider = function(parent, p39, p40)
	if not parent then
		return nil
	end

	local t23 = p40 or {}
	local u424 = t23.Animate ~= false
	local u425: boolean = t23.TitleFx ~= false
	local uiGradient = parent:FindFirstChildOfClass("UIGradient")

	if not uiGradient then
		return nil
	end

	if not parent:FindFirstChildOfClass("UIShadow") then
		local uiShadow: UIShadow = Instance.new("UIShadow")

		uiShadow.Color = Color3.new(0, 0, 0)
		uiShadow.BlurRadius = UDim.new(0.06, 0)
		uiShadow.Spread = UDim2.new(0.004, 0, 0.01, 0)
		uiShadow.Offset = UDim2.new(0, 0, 0.012, 0)
		uiShadow.Transparency = 0.35
		uiShadow.ZIndex = -1
		uiShadow.Parent = parent
	end

	local t24: {[any]: any} = {}
	local t25: {[any]: any} = {}
	local uiStroke = parent:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		table.insert(t24, uiStroke)
	end

	for _, v in ipairs(parent:GetChildren()) do
		if (v:IsA("VideoFrame") or v:IsA("ImageLabel")) and v.Size.X.Scale >= 0.9 then
			local uiStroke2 = v:FindFirstChildOfClass("UIStroke")

			if uiStroke2 then
				table.insert(t24, uiStroke2)
			end

			local uiGradient2 = v:FindFirstChildOfClass("UIGradient")

			if uiGradient2 then
				table.insert(t25, uiGradient2)
			end
		end
	end

	local u435 = nil
	local u436 = nil
	local header = parent:FindFirstChild("Header")
	local textLabel = header and header:FindFirstChild("TextLabel")
	local v439 = textLabel

	if v439 then
		v439 = textLabel:FindFirstChild("TextLabel")
	end

	if v439 and v439:IsA("TextLabel") and u425 then
		v439.TextColor3 = Color3.new(1, 1, 1)

		local uiGradient3 = v439:FindFirstChildOfClass("UIGradient")

		if not uiGradient3 then
			uiGradient3 = Instance.new("UIGradient")
			uiGradient3.Parent = v439
		end

		uiGradient3.Rotation = 0
		uiGradient3.Transparency = NumberSequence.new(0)
		uiGradient3.Offset = Vector2.new(-1, 0)
		u435 = uiGradient3

		local uiStroke3 = v439:FindFirstChildOfClass("UIStroke")

		if not uiStroke3 then
			uiStroke3 = Instance.new("UIStroke")
			uiStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			uiStroke3.Thickness = 1.5
			uiStroke3.Parent = v439
		end

		uiStroke3.Transparency = 0.6
		u436 = uiStroke3

		local tweenInfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false)
		local v443: Tween = tweenService:Create(uiGradient3, tweenInfo, { Offset = Vector2.new(1, 0) })

		v443:Play()
		table.insert(t15, v443)

		local tweenInfo2 = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

		v443 = tweenService:Create(uiStroke3, tweenInfo2, { Transparency = 0.15 })
		v443:Play()
		table.insert(t15, v443)
	elseif v439 and v439:IsA("TextLabel") then
		local uiStroke4 = v439:FindFirstChildOfClass("UIStroke")

		if uiStroke4 then
			uiStroke4.Color = Color3.new(0, 0, 0)
			uiStroke4.Transparency = 0
		end
	end

	if u424 then
		for _, v in ipairs(t24) do
			local uiGradient4 = v:FindFirstChildOfClass("UIGradient")

			if uiGradient4 then
				uiGradient4.Enabled = false
			end

			v.Transparency = 0.5

			local tweenInfo = TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			local v450: Tween = tweenService:Create(v, tweenInfo, { Transparency = 0.05 })

			v450:Play()
			table.insert(t15, v450)
		end

		if t23.Drift ~= false then
			uiGradient.Offset = Vector2.new(0, -0.3)

			local tweenInfo3 = TweenInfo.new(t23.BgTime or 2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			local v452: Tween = tweenService:Create(uiGradient, tweenInfo3, { Offset = Vector2.new(0, 0.3) })

			v452:Play()
			table.insert(t15, v452)
		end
	end

	u424 = function(p41)
		local colorSequenceNew = ColorSequence.new

		uiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, p41:Lerp(Color3.new(0, 0, 0), 0.88)),
			ColorSequenceKeypoint.new(0.34, p41:Lerp(Color3.new(0, 0, 0), 0.78)),
			ColorSequenceKeypoint.new(0.52, p41:Lerp(Color3.new(0, 0, 0), 0.22)),
			ColorSequenceKeypoint.new(0.7, p41:Lerp(Color3.new(0, 0, 0), 0.78)),
			ColorSequenceKeypoint.new(1, p41:Lerp(Color3.new(0, 0, 0), 0.88))
		})

		local v884 = ColorSequence.new
		local colorSequence = v884({
			ColorSequenceKeypoint.new(0, p41:Lerp(Color3.new(0, 0, 0), 0.55)),
			ColorSequenceKeypoint.new(0.34, p41:Lerp(Color3.new(0, 0, 0), 0.4)),
			ColorSequenceKeypoint.new(0.52, p41:Lerp(Color3.new(0, 0, 0), 0.05)),
			ColorSequenceKeypoint.new(0.7, p41:Lerp(Color3.new(0, 0, 0), 0.4)),
			ColorSequenceKeypoint.new(1, p41:Lerp(Color3.new(0, 0, 0), 0.55))
		})

		for _, v in ipairs(t25) do
			v.Color = colorSequence
		end

		for _, v in ipairs(t24) do
			v.Color = p41
		end

		if u435 then
			local v890 = u435
			local v891 = ColorSequence.new

			v890.Color = v891({
				ColorSequenceKeypoint.new(0, p41),
				ColorSequenceKeypoint.new(0.46, p41),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.54, p41),
				ColorSequenceKeypoint.new(1, p41)
			})
		end

		if u436 then
			u436.Color = p41
		end
	end
	u424(p39)

	return u424
end
shopWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	for _, v in ipairs(t15) do
		if shopWindow.Visible then
			v:Play()
		else
			v:Pause()
		end
	end
end)
casesDivider = Color3.fromRGB(215, 20, 30)
currencyDivider(premium2Bundle, casesDivider, { Animate = false, TitleFx = false })
casesDivider = Color3.fromRGB(72, 72, 80)
currencyDivider(frame, casesDivider, { Drift = false, TitleFx = false })

local function addVariantIcon(p42, p43)
	local header = p42 and p42:FindFirstChild("Header")
	local textLabel = header and header:FindFirstChild("TextLabel")
	local v459 = textLabel

	if v459 then
		v459 = textLabel:FindFirstChild("Chance")
	end

	if not v459 or not v459:IsA("TextLabel") then
		return
	end

	local v460 = v459.Position
	local v461 = UDim2.fromScale(0.04, 0)

	v459.Position = v460 + v461

	local variantIcon: ImageLabel = Instance.new("ImageLabel")

	variantIcon.Name = "VariantIcon"
	variantIcon.BackgroundTransparency = 1
	variantIcon.BorderSizePixel = 0
	variantIcon.AnchorPoint = Vector2.new(1, 0.5)
	variantIcon.Position = UDim2.new(0, -6, 0.5, 0)
	variantIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	variantIcon.Size = UDim2.fromScale(1.6, 1.6)
	variantIcon.ScaleType = Enum.ScaleType.Fit
	variantIcon.ZIndex = v459.ZIndex
	variantIcon.Image = p43[1]
	variantIcon.Parent = v459
	task.spawn(function()
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync(p43)
		end)
	end)
	task.spawn(function()
		local n1: number = 1

		while variantIcon.Parent do
			task.wait(3)
			n1 = n1 % #p43 + 1
			variantIcon.Image = p43[n1]
		end
	end)
end

for _, v in pairs(t11) do
	v()
end

local function applyPackState(p44)
	if typeof(p44) == "table" then
		if typeof(p44.OwnedPacks) == "table" then
			t5 = p44.OwnedPacks
		end

		if typeof(p44.RobuxPrices) == "table" then
			if v88 then
				local v464 = p44.RobuxPrices[v88.Id]

				if typeof(v464) == "number" and v464 > 0 then
					u94 = v464
				end
			end

			if v108 then
				local v465 = p44.RobuxPrices[v108.Id]

				if typeof(v465) == "number" and v465 > 0 then
					u113 = v465
				end
			end

			for k, v in pairs(p44.RobuxPrices) do
				if typeof(k) == "string" and typeof(v) == "number" and v > 0 then
					t8[k] = v
				end
			end
		end

		if typeof(p44.CurrencyPrices) == "table" then
			t6 = p44.CurrencyPrices

			for _, v in ipairs(currencies:GetChildren()) do
				if v:IsA("Frame") then
					local v470 = t6[v.Name]

					if v470 then
						local buyButton = v:FindFirstChild("BuyButton")

						if buyButton then
							local v472 = utf8.char(57346)
							local v473 = commaFormat(v470)
							local text: string = v472 .. " " .. v473
							local textLabel19 = buyButton:FindFirstChild("TextLabel")

							if textLabel19 and textLabel19:IsA("TextLabel") then
								textLabel19.Text = text

								local textLabel20 = textLabel19:FindFirstChild("TextLabel")

								if textLabel20 and textLabel20:IsA("TextLabel") then
									textLabel20.Text = text
								end
							end
						end
					end
				end
			end

			if tokenPackages then
				for _, v in ipairs(tokenPackages:GetChildren()) do
					if v:IsA("Frame") then
						local v479 = t6[v.Name]

						if v479 then
							local buyButton = v:FindFirstChild("BuyButton")

							if buyButton then
								local v481 = utf8.char(57346)
								local v482 = commaFormat(v479)
								local s2: string = v481 .. " " .. v482
								local textLabel21 = buyButton:FindFirstChild("TextLabel")

								if textLabel21 and textLabel21:IsA("TextLabel") then
									textLabel21.Text = s2

									local textLabel22 = textLabel21:FindFirstChild("TextLabel")

									if textLabel22 and textLabel22:IsA("TextLabel") then
										textLabel22.Text = s2
									end
								end
							end
						end
					end
				end
			end
		end

		if typeof(p44.PackColors) == "table" then
			for k, v in pairs(p44.PackColors) do
				if typeof(k) == "string" and typeof(v) == "string" then
					local v488 = t14[k]
					local v489 = if v488 then packCatalog.ResolveColorKey(v488, v) else nil

					if v489 then
						t10[k] = v489
					end
				end
			end

			for _, v in pairs(t11) do
				v()
			end
		end

		refreshReleasePackUI()
		refreshStarterPackUI()

		for _, v in ipairs(t9) do
			v()
		end

		return
	end
end

packPush.OnClientEvent:Connect(function(p45)
	applyPackState(p45)
end)
task.spawn(function()
	while true do
		if LocalPlayer:GetAttribute("DataReady") then
			break
		end

		task.wait()
	end

	local v495 = packRequest:InvokeServer("GetState")

	applyPackState(v495)
end)

function setShopInteractable(p46)
	for _, v in ipairs(navigator:GetChildren()) do
		if v:IsA("GuiButton") then
			v.Active = p46
			v.Interactable = p46
			v.Selectable = p46
		end
	end

	closeButton.Active = p46
	closeButton.Interactable = p46
	closeButton.Selectable = p46
	scrollingFrame.ScrollingEnabled = p46

	for _, v in ipairs(scrollingFrame:GetDescendants()) do
		if v:IsA("GuiButton") then
			v.Active = p46
			v.Interactable = p46
			v.Selectable = p46
		elseif v:IsA("TextBox") then
			v.Interactable = p46
			v.Selectable = p46
		end
	end

	for _, v in ipairs(casePurchase5b3:GetDescendants()) do
		if v:IsA("GuiButton") then
			v.Active = p46
			v.Interactable = p46
			v.Selectable = p46
		end
	end

	if not p46 then
		hoverInfoModule.hide(v78)
	end
end
local function recipientOwnsPack(p47, p48)
	for k, v in pairs(packCatalog.Packs) do
		if p48 == v.BuyProductId or p48 == v.GiftProductId then
			return p47:GetAttribute("OwnsPack_" .. k) == true
		end
	end

	return false
end
function openGiftingMenu(p49)
	giftPicker.Open({
		productId = p49.productId,
		displayName = p49.displayName,
		ownedBy = function(p50)
			return (recipientOwnsPack(p50, p49.productId))
		end,
		onOpen = function()
			setShopInteractable(false)
		end,
		onClose = function()
			setShopInteractable(true)
		end
	})
end
function closeGiftingMenu()
	giftPicker.Close()
end

casesDivider = replicatedStorage:WaitForChild("Shared")

local featuredCollectible = require(casesDivider:WaitForChild("FeaturedCollectible"))
local featuredCollectibleItemType = featuredCollectible.ItemType
local featuredCollectibleItemId = featuredCollectible.ItemId;

(function(p51)
	if not p51 then
		warn("[ShopController] CollectibleBundle frame not found in ScrollingFrame")

		return
	end

	if featuredCollectible.ShopCard == false then
		p51.Visible = false

		return
	end

	local copiesLeft = p51:FindFirstChild("CopiesLeft")
	local lowStockNote = p51:FindFirstChild("LowStockNote")
	local header = p51:FindFirstChild("Header")
	local buyButton = p51:FindFirstChild("BuyButton")
	local giftButton = p51:FindFirstChild("GiftButton")
	local inspectButton = p51:FindFirstChild("InspectButton")
	local effect = p51:FindFirstChild("Effect")
	local icon = effect and effect:FindFirstChild("Icon")
	local effectName = effect and effect:FindFirstChild("EffectName")

	if copiesLeft then
		copiesLeft.RichText = true
	end

	local u518 = nil
	local u519 = nil

	local function accent(p52)
		return ("<font color=\"%s\">%s</font>"):format("rgb(255, 73, 73)", p52)
	end
	local function setLowStockNote(visible)
		if lowStockNote and visible ~= lowStockNote.Visible then
			lowStockNote.Visible = visible
		end
	end
	local function setCopies(text)
		if copiesLeft and text ~= copiesLeft.Text then
			copiesLeft.Text = text
		end

		if lowStockNote and lowStockNote.Visible ~= false then
			lowStockNote.Visible = false
		end
	end
	local function renderEffectBadge()
		if not effect then
			return
		end

		local bundledFinisherLabel = u518 and u518.BundledFinisherLabel
		local bundledFinisherIcon = u518 and u518.BundledFinisherIcon

		if typeof(bundledFinisherLabel) == "string" and typeof(bundledFinisherIcon) == "string" then
			if effectName and bundledFinisherLabel ~= effectName.Text then
				effectName.Text = bundledFinisherLabel
			end

			if icon and bundledFinisherIcon ~= icon.Image then
				icon.Image = bundledFinisherIcon
			end

			effect.Visible = true

			return
		end

		effect.Visible = false
	end
	local function render()
		if not u518 then
			if copiesLeft and copiesLeft.Text ~= "Checking supply..." then
				copiesLeft.Text = "Checking supply..."
			end

			if lowStockNote and lowStockNote.Visible ~= false then
				lowStockNote.Visible = false
			end

			if buyButton then
				uiFramework.setButtonDisabled(buyButton)
			end

			if giftButton then
				uiFramework.setButtonDisabled(giftButton)
			end

			if not effect then
				return
			end

			local bundledFinisherLabel = u518 and u518.BundledFinisherLabel
			local bundledFinisherIcon = u518 and u518.BundledFinisherIcon

			if typeof(bundledFinisherLabel) == "string" and typeof(bundledFinisherIcon) == "string" then
				if effectName and bundledFinisherLabel ~= effectName.Text then
					effectName.Text = bundledFinisherLabel
				end

				if icon and bundledFinisherIcon ~= icon.Image then
					icon.Image = bundledFinisherIcon
				end

				effect.Visible = true

				return
			end

			effect.Visible = false

			return
		end

		if effect then
			local text = u518 and u518.BundledFinisherLabel
			local image = u518 and u518.BundledFinisherIcon

			if typeof(text) == "string" and typeof(image) == "string" then
				if effectName and text ~= effectName.Text then
					effectName.Text = text
				end

				if icon and image ~= icon.Image then
					icon.Image = image
				end

				effect.Visible = true
			else
				effect.Visible = false
			end
		end

		if header and typeof(u518.Name) == "string" then
			local upperText = string.upper(u518.Name)
			local textLabel23 = header:FindFirstChild("TextLabel")

			if textLabel23 and textLabel23:IsA("TextLabel") then
				textLabel23.Text = upperText

				local textLabel24 = textLabel23:FindFirstChild("TextLabel")

				if textLabel24 and textLabel24:IsA("TextLabel") then
					textLabel24.Text = upperText
				end
			end
		end

		if u518.Revealed == false then
			p51.Visible = false

			return
		end

		local v906 = u519 and math.max(0, u519 - os.clock()) or nil

		if v906 and v906 > 0 then
			local v907 = collectibleConfig.FormatCountdown(v906)

			p51.Visible = true

			local v908 = ("Unlocks In: %s"):format(accent(v907))

			if copiesLeft and v908 ~= copiesLeft.Text then
				copiesLeft.Text = v908
			end

			if lowStockNote and lowStockNote.Visible ~= false then
				lowStockNote.Visible = false
			end

			if buyButton then
				uiFramework.setButtonDisabled(buyButton)

				local textLabel25 = buyButton:FindFirstChild("TextLabel")

				if textLabel25 and textLabel25:IsA("TextLabel") then
					textLabel25.Text = v907

					local textLabel26 = textLabel25:FindFirstChild("TextLabel")

					if textLabel26 and textLabel26:IsA("TextLabel") then
						textLabel26.Text = v907
					end
				end
			end

			if giftButton then
				uiFramework.setButtonDisabled(giftButton)
			end

			return
		end

		local remaining = u518.Remaining
		local u912: boolean = false

		if typeof(remaining) == "number" then
			u912 = remaining <= 0
		end

		if u912 and not collectibleConfig.IsWithinSoldOutWindow(u518.SoldOutAt) then
			p51.Visible = false

			return
		end

		p51.Visible = true

		if u912 then
			local v913 = ("<font color=\"%s\">%s</font>"):format("rgb(255, 73, 73)", "SOLD OUT")

			if copiesLeft and v913 ~= copiesLeft.Text then
				copiesLeft.Text = v913
			end

			if lowStockNote and lowStockNote.Visible ~= false then
				lowStockNote.Visible = false
			end

			if buyButton then
				uiFramework.setButtonDisabled(buyButton)

				local textLabel27 = buyButton:FindFirstChild("TextLabel")

				if textLabel27 and textLabel27:IsA("TextLabel") then
					textLabel27.Text = "SOLD OUT"

					local textLabel28 = textLabel27:FindFirstChild("TextLabel")

					if textLabel28 and textLabel28:IsA("TextLabel") then
						textLabel28.Text = "SOLD OUT"
					end
				end
			end

			if giftButton then
				uiFramework.setButtonDisabled(giftButton)
			end

			return
		end

		if typeof(remaining) == "number" then
			local v916 = commaFormat(remaining)
			local v917 = commaFormat(u518.MaxSupply)
			local v918 = ("Copies Left: %s"):format(accent(("%s/%s"):format(v916, v917)))

			if copiesLeft and v918 ~= copiesLeft.Text then
				copiesLeft.Text = v918
			end

			if lowStockNote and lowStockNote.Visible ~= false then
				lowStockNote.Visible = false
			end

			v918 = remaining > 0 and remaining < 100

			if lowStockNote and v918 ~= lowStockNote.Visible then
				lowStockNote.Visible = v918
			end
		else
			if copiesLeft and copiesLeft.Text ~= "Checking supply..." then
				copiesLeft.Text = "Checking supply..."
			end

			if lowStockNote and lowStockNote.Visible ~= false then
				lowStockNote.Visible = false
			end
		end

		if buyButton then
			uiFramework.setButtonEnabled(buyButton)

			local robuxPrice = u518.RobuxPrice
			local s1: string = if typeof(robuxPrice) == "number" and robuxPrice > 0 then utf8.char(57346) .. " " .. commaFormat(robuxPrice) else "..."
			local textLabel29 = buyButton:FindFirstChild("TextLabel")

			if textLabel29 and textLabel29:IsA("TextLabel") then
				textLabel29.Text = s1

				local textLabel30 = textLabel29:FindFirstChild("TextLabel")

				if textLabel30 and textLabel30:IsA("TextLabel") then
					textLabel30.Text = s1
				end
			end
		end

		if giftButton then
			giftButton.Visible = u518.GiftProductId ~= nil

			if u518.GiftProductId then
				uiFramework.setButtonEnabled(giftButton)
			end
		end
	end

	local u525: boolean = false

	local function refresh()
		if u525 then
			return
		end

		u525 = true

		local v923, v924, v925 = pcall(function()
			return inventory:InvokeServer("GetCollectibleOffer", {
				ItemType = featuredCollectibleItemType,
				ItemId = featuredCollectibleItemId
			})
		end)

		u525 = false

		if v923 and v924 and typeof(v925) == "table" then
			u518 = v925

			local secondsUntilSale = v925.SecondsUntilSale

			u519 = typeof(secondsUntilSale) == "number" and secondsUntilSale > 0 and os.clock() + secondsUntilSale or nil
		end

		render()
	end

	render()
	task.spawn(refresh)
	task.spawn(function()
		while p51.Parent do
			if shopWindow.Visible then
				refresh()
			end

			task.wait(5)
		end
	end)
	task.spawn(function()
		while p51.Parent do
			if u519 then
				if os.clock() >= u519 then
					u519 = nil
					task.spawn(refresh)
				elseif shopWindow.Visible then
					render()
				end
			end

			task.wait(1)
		end
	end)
	shopWindow:GetPropertyChangedSignal("Visible"):Connect(function()
		if shopWindow.Visible then
			task.spawn(refresh)
		end
	end)

	local item = p51:FindFirstChild("Item")

	if item then
		local itemPosition = item.Position
		local n1 = math.random() * 100
		local u530: boolean = false

		runService.RenderStepped:Connect(function()
			if not shopWindow.Visible or not p51.Visible then
				if u530 then
					item.Position = itemPosition
					u530 = false
				end

				return
			end

			u530 = true

			local n2 = os.clock() * 22
			local v928 = math.noise(n2, n1)
			local v929 = math.noise(n1, n2)
			local v930 = UDim2.fromOffset(v928 * 1.5 * 2, v929 * 1.5 * 2)

			item.Position = itemPosition + v930
		end)
	end

	local weLit = p51:FindFirstChild("WeLit")

	if weLit then
		local weLitPosition = weLit.Position
		local weLitAnchorPoint = weLit.AnchorPoint
		local weLitSize = weLit.Size
		local uDim2 = UDim2.new(weLitPosition.X.Scale + weLitSize.X.Scale * (0.5 - weLitAnchorPoint.X), weLitPosition.X.Offset, weLitPosition.Y.Scale + weLitSize.Y.Scale * (0.5 - weLitAnchorPoint.Y), weLitPosition.Y.Offset)
		local u536: boolean = false

		runService.RenderStepped:Connect(function()
			if not shopWindow.Visible or not p51.Visible then
				if u536 then
					weLit.AnchorPoint = weLitAnchorPoint
					weLit.Position = weLitPosition
					weLit.Size = weLitSize
					u536 = false
				end

				return
			end

			if not u536 then
				weLit.AnchorPoint = Vector2.new(0.5, 0.5)
				weLit.Position = uDim2
				u536 = true
			end

			local v931 = os.clock()
			local n1 = math.sin(v931 * 2.2) * 0.05 + 1

			weLit.Size = UDim2.new(weLitSize.X.Scale * n1, weLitSize.X.Offset, weLitSize.Y.Scale * n1, weLitSize.Y.Offset)
		end)
	end

	local videoFrame = p51:FindFirstChild("VideoFrame")
	local uiStroke = videoFrame and videoFrame:FindFirstChildOfClass("UIStroke")
	local v539 = uiStroke

	if v539 then
		v539 = uiStroke:FindFirstChildOfClass("UIGradient")
	end

	if v539 then
		runService.RenderStepped:Connect(function()
			if not shopWindow.Visible or not p51.Visible then
				return
			end

			v539.Rotation = os.clock() * 60 % 360
		end)
	end

	if buyButton then
		buyButton.MouseButton1Click:Connect(function()
			if not buyButton.Interactable then
				return
			end

			if not u518 or typeof(u518.ProductId) ~= "number" then
				return
			end

			if gameFlags.CollectibleTokenBuyEnabled == true then
				showPurchaseModal:Fire({
					ProductId = u518.ProductId,
					Name = u518.Name or u518.ItemId,
					RobuxPrice = u518.RobuxPrice
				})

				return
			end

			currencyBuyRequest:FireServer(u518.ProductId)
		end)
	end

	if giftButton then
		giftButton.MouseButton1Click:Connect(function()
			if not giftButton.Interactable then
			elseif u518 and typeof(u518.GiftProductId) == "number" then
				openGiftingMenu({
					currency = "Cash",
					amount = 0,
					productId = u518.GiftProductId,
					displayName = u518.Name or featuredCollectibleItemId
				})

				return
			end
		end)
	end

	if inspectButton then
		inspectButton.MouseButton1Click:Connect(function()
			local v933 = u518 and u518.ItemType or featuredCollectibleItemType
			local v934 = u518 and u518.ItemId or featuredCollectibleItemId
			local name = u518 and u518.Name or v934

			if u518 and typeof(u518.BundledFinisher) == "string" then
				local v936 = u518.BundledFinisherLabel

				if typeof(v936) == "string" then
					v936 = v936:gsub("^[^%w]*", "")

					if v936 == "" then
						v936 = nil
					end
				end

				inspectItem:Fire({
					Items = {
						{
							Rarity = "Collectible",
							Kind = v933,
							ItemId = v934,
							Name = name,
							Label = if v933 == "Knife" then "KNIFE" else "GUN",
							Icon = u518.Icon
						},
						{
							Kind = "Finisher",
							Label = "FINISHER",
							ItemId = u518.BundledFinisher,
							Name = v936,
							Rarity = u518.BundledFinisherRarity,
							Icon = u518.BundledFinisherIcon
						}
					}
				})

				return
			end

			inspectItem:Fire({ Rarity = "Collectible", Kind = v933, ItemId = v934, Name = name })
		end)
	end
end)((scrollingFrame:FindFirstChild("CollectibleBundle")));
(function(p55)
	if not p55 then
		warn("[ShopController] DailyEmotes frame not found in ScrollingFrame")

		return
	end

	local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
	local shared: Instance = replicatedStorage:WaitForChild("Shared")
	local emoteShop = require(shared:WaitForChild("EmoteShop"))
	local emoteCatalog = require(shared:WaitForChild("EmoteCatalog"))
	local emotePreview = require(shared:WaitForChild("EmotePreview"))
	local emoteFlags: Instance = shared:WaitForChild("EmoteFlags")
	local LocalPlayer2: Player = players.LocalPlayer
	local cards = p55:FindFirstChild("Cards")
	local cardTemplate = cards and cards:FindFirstChild("CardTemplate")
	local countdown = p55:FindFirstChild("Countdown")

	if cards and cardTemplate then
		local t26: {[any]: any} = {}
		local t27: {[any]: any} = {}
		local t28: {[any]: any} = {}
		local t29: {[any]: any} = {}
		local n1 = -1

		local function ownedSet()
			local t44: {[any]: any} = {}
			local ownedEmotes: any = LocalPlayer2:GetAttribute("OwnedEmotes")

			if typeof(ownedEmotes) == "string" then
				for iterValue in string.gmatch(ownedEmotes, "[^,]+") do
					t44[iterValue] = true
				end
			end

			return t44
		end
		local function emotesEnabled()
			return emoteFlags:GetAttribute("EmotesEnabled") == true
		end
		local function fetchPrice(p56)
			local v941 = t26[p56]

			if v941 then
				return v941
			end

			local ok, result = pcall(function()
				return marketplaceService:GetProductInfo(p56, Enum.InfoType.Product)
			end)

			v941 = ok and typeof(result) == "table" and tonumber(result.PriceInRobux)

			if v941 then
				t26[p56] = v941

				return v941
			end

			return nil
		end
		local function clearCards()
			for _, v in ipairs(t27) do
				pcall(function()
					v:destroy()
				end)
			end

			table.clear(t27)

			for _, v in ipairs(t28) do
				v:Destroy()
			end

			table.clear(t28)
			table.clear(t29)
		end
		local function buildCard(p57, layoutOrder)
			local v950 = emoteCatalog.Get(p57)
			local v951 = emoteShop.ProductFor(p57)

			if v950 and v951 then
				local clone = cardTemplate:Clone()

				clone.Name = "Card_" .. p57
				clone.LayoutOrder = layoutOrder
				clone.Visible = true
				clone.Parent = cards
				table.insert(t28, clone)

				local v953, v954 = (rarity.Colors[v950.Rarity] or rarity.Colors.Common):ToHSV()
				local color3FromHSV = Color3.fromHSV
				local v956 = math.max(v954, 0.95)
				local v957 = color3FromHSV(v953, v956, 1)
				local rarityFade = clone:FindFirstChild("RarityFade")

				if rarityFade and rarityFade:IsA("GuiObject") then
					rarityFade.BackgroundColor3 = v957
				end

				local text = v950.Name
				local caseName = clone:FindFirstChild("CaseName")

				if caseName and caseName:IsA("TextLabel") then
					caseName.Text = text

					local textLabel31 = caseName:FindFirstChild("TextLabel")

					if textLabel31 and textLabel31:IsA("TextLabel") then
						textLabel31.Text = text
					end
				end

				local rarity2 = clone:FindFirstChild("Rarity")

				if rarity2 and rarity2:IsA("TextLabel") then
					rarity2.Text = v950.Rarity
					rarity2.TextColor3 = v957
				end

				local rig = clone:FindFirstChild("Rig")

				v957 = rig and rig:IsA("GuiObject") and emotePreview.new(rig, p57, {
					autoplay = true,
					loop = true,
					sound = false,
					watch = true,
					zindex = 3
				})

				if v957 then
					table.insert(t27, v957)
				end

				local inspectButton = clone:FindFirstChild("InspectButton")

				if inspectButton then
					inspectButton.MouseButton1Click:Connect(function()
						if not inspectButton.Interactable then
							return
						end

						replicatedStorage.Bindables.InspectItem:Fire({ Kind = "Emote", ItemId = p57, Name = v950.Name, Rarity = v950.Rarity })
					end)
				end

				local giftButton = clone:FindFirstChild("GiftButton")
				local v966 = emoteShop.GiftProductFor(p57)

				if giftButton then
					giftButton.Visible = v966 ~= nil

					if v966 then
						local u967: boolean = false

						giftButton.MouseButton1Click:Connect(function()
							if giftButton.Interactable and not u967 then
								if not emoteShop.IsOnSale(p57) then
									return
								end

								u967 = true

								local v1257, v1258, v1259 = pcall(function()
									return remotes:WaitForChild("EmoteShopIntent"):InvokeServer(p57, true)
								end)

								u967 = false

								if v1257 and v1258 == true then
									giftPicker.Open({
										productId = v966,
										displayName = v950.Name .. " Emote",
										ownedBy = function(p59)
											local ownedEmotes = p59:GetAttribute("OwnedEmotes")

											if typeof(ownedEmotes) == "string" then
												for iterValue in string.gmatch(ownedEmotes, "[^,]+") do
													if iterValue == p57 then
														return true
													end
												end

												return false
											end

											return false
										end,
										onOpen = function()
											setShopInteractable(false)
										end,
										onClose = function()
											setShopInteractable(true)
										end
									})

									return
								end

								if typeof(v1259) == "string" then
									warn("[ShopController] emote gift refused: " .. v1259)
								end

								return
							end
						end)
					end
				end

				local buyButton = clone:FindFirstChild("BuyButton")
				local u969 = nil

				local function refresh()
					if not buyButton then
						return
					end

					if ownedSet()[p57] then
						uiFramework.setButtonDisabled(buyButton)

						local textLabel32 = buyButton:FindFirstChild("TextLabel")

						if textLabel32 and textLabel32:IsA("TextLabel") then
							textLabel32.Text = "OWNED"

							local textLabel33 = textLabel32:FindFirstChild("TextLabel")

							if textLabel33 and textLabel33:IsA("TextLabel") then
								textLabel33.Text = "OWNED"

								return
							end
						end
					else
						uiFramework.setButtonEnabled(buyButton)

						local text: string = if u969 then utf8.char(57346) .. " " .. commaFormat(u969) else "..."
						local textLabel34 = buyButton:FindFirstChild("TextLabel")

						if textLabel34 and textLabel34:IsA("TextLabel") then
							textLabel34.Text = text

							local textLabel35 = textLabel34:FindFirstChild("TextLabel")

							if textLabel35 and textLabel35:IsA("TextLabel") then
								textLabel35.Text = text
							end
						end
					end
				end

				table.insert(t29, refresh)
				refresh()
				task.spawn(function()
					local v1265 = v951
					local v1266 = t26[v1265]
					local v1268

					if v1266 then
						v1268 = v1266
					else
						local ok, result = pcall(function()
							return marketplaceService:GetProductInfo(v1265, Enum.InfoType.Product)
						end)

						local v1271 = ok and typeof(result) == "table" and tonumber(result.PriceInRobux)

						if v1271 then
							t26[v1265] = v1271
							v1268 = v1271
						else
							v1268 = nil
						end
					end

					u969 = v1268

					if clone.Parent then
						refresh()
					end
				end)

				if buyButton then
					local u971: boolean = false

					buyButton.MouseButton1Click:Connect(function()
						if buyButton.Interactable and not u971 then
							if ownedSet()[p57] then
								return
							end

							if not emoteShop.IsOnSale(p57) then
								return
							end

							u971 = true

							local v1272, v1273, v1274 = pcall(function()
								return remotes:WaitForChild("EmoteShopIntent"):InvokeServer(p57)
							end)

							u971 = false

							if v1272 and v1273 == true then
								showPurchaseModal:Fire({ ProductId = v951, Name = v950.Name .. " Emote", RobuxPrice = u969 })

								return
							end

							if typeof(v1274) == "string" then
								warn("[ShopController] emote purchase refused: " .. v1274)
							end

							refresh()

							return
						end
					end)
				end

				return
			end
		end
		local function rebuild()
			clearCards()
			n1 = emoteShop.DayIndex()

			for i, v in ipairs(emoteShop.TodayIds()) do
				buildCard(v, i)
			end

			p55.Visible = emoteFlags:GetAttribute("EmotesEnabled") == true and #t28 > 0

			local daily: Instance = navigator:FindFirstChild("Daily")

			if daily and daily:IsA("GuiObject") then
				daily.Visible = p55.Visible
			end
		end

		LocalPlayer2:GetAttributeChangedSignal("OwnedEmotes"):Connect(function()
			for _, v in ipairs(t29) do
				v()
			end
		end)
		emoteFlags:GetAttributeChangedSignal("EmotesEnabled"):Connect(function()
			p55.Visible = emoteFlags:GetAttribute("EmotesEnabled") == true and #t28 > 0

			local daily: Instance = navigator:FindFirstChild("Daily")

			if daily and daily:IsA("GuiObject") then
				daily.Visible = p55.Visible
			end
		end)
		emotePreview.AvatarChanged:Connect(function()
			rebuild()
		end)
		rebuild()
		task.spawn(function()
			while p55.Parent do
				local v978 = emoteShop.SecondsToReset()

				if countdown then
					local floored = math.floor(v978 / 3600)
					local floored5 = math.floor(v978 % 3600 / 60)
					local floored6 = math.floor(v978 % 60)

					countdown.Text = string.format("New items in <font color=\"#FFC45C\"><b>%02d:%02d:%02d</b></font>", floored, floored5, floored6)
				end

				if emoteShop.DayIndex() ~= n1 then
					rebuild()
				end

				task.wait(1)
			end
		end)

		return
	end
end)((scrollingFrame:FindFirstChild("DailyEmotes")))
casesDivider = function(p60, p61)
	if not p60 then
		return
	end

	local inspectButton = p60:FindFirstChild("InspectButton")

	if not inspectButton then
		warn("[ShopController] No InspectButton on bundle frame '" .. p60.Name .. "'")

		return
	end

	local v565 = packCatalog.Get(p61)

	if not v565 then
		warn("[ShopController] Pack '" .. p61 .. "' missing from PackCatalog; inspect eye left unwired")

		return
	end

	local v566 = packCatalog.ColorGroupOf(v565)

	if not packCatalog.PreviewItemsFor(v565, v566 and t10[v566]) then
		warn("[ShopController] Pack '" .. p61 .. "' has no PreviewItems; inspect eye left unwired")

		return
	end

	inspectButton.MouseButton1Click:Connect(function()
		if not inspectButton.Interactable then
			return
		end

		local v982 = packCatalog.PreviewItemsFor(v565, v566 and t10[v566])

		if not v982 then
			return
		end

		inspectItem:Fire({ Items = v982 })
	end)
end
casesDivider(frame, "BlackCatBundle")
casesDivider(premium2Bundle, "VampireBundle");
(function(p62, image)
	if not p62 then
		return
	end

	local userInputService: UserInputService = game:GetService("UserInputService")
	local guiService: GuiService = game:GetService("GuiService")
	local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
	local parent: Instance = playerGui
	local cardCursor: ScreenGui = Instance.new("ScreenGui")

	cardCursor.Name = "CardCursor"
	cardCursor.ResetOnSpawn = false
	cardCursor.ScreenInsets = Enum.ScreenInsets.None
	cardCursor.DisplayOrder = 10000
	cardCursor.Enabled = false
	cardCursor.Parent = parent

	local paw: ImageLabel = Instance.new("ImageLabel")

	paw.Name = "Paw"
	paw.Image = image
	paw.BackgroundTransparency = 1
	paw.AnchorPoint = Vector2.new(0.5, 0.5)
	paw.Size = UDim2.fromOffset(40, 40)
	paw.Parent = cardCursor

	local u575: boolean = false

	task.spawn(function()
		game:GetService("ContentProvider"):PreloadAsync({ paw }, function(_, p65)
			if p65 == Enum.AssetFetchStatus.Success then
				u575 = true
			end
		end)
	end)

	local u576 = false
	local u577: boolean = false
	local n1 = 0

	local function isMouse(p66)
		local u984: boolean = true

		if p66 ~= Enum.UserInputType.MouseMovement then
			u984 = true

			if p66 ~= Enum.UserInputType.MouseButton1 then
				u984 = true

				if p66 ~= Enum.UserInputType.MouseButton2 then
					u984 = true

					if p66 ~= Enum.UserInputType.MouseButton3 then
						u984 = p66 == Enum.UserInputType.MouseWheel
					end
				end
			end
		end

		return u984
	end

	local u580: boolean = userInputService.MouseEnabled
	local v581: Enum.UserInputType = userInputService:GetLastInputType()
	local u582: boolean = true

	if v581 ~= Enum.UserInputType.MouseMovement then
		u582 = true

		if v581 ~= Enum.UserInputType.MouseButton1 then
			u582 = true

			if v581 ~= Enum.UserInputType.MouseButton2 then
				u582 = true

				if v581 ~= Enum.UserInputType.MouseButton3 then
					u582 = v581 == Enum.UserInputType.MouseWheel
				end
			end
		end
	end

	if u582 then
		u580 = true
	elseif v581 == Enum.UserInputType.Touch or string.sub(v581.Name, 1, 7) == "Gamepad" then
		u580 = false
	end

	userInputService.LastInputTypeChanged:Connect(function(lastInputType: Enum.UserInputType)
		local u986: boolean = true

		if lastInputType ~= Enum.UserInputType.MouseMovement then
			u986 = true

			if lastInputType ~= Enum.UserInputType.MouseButton1 then
				u986 = true

				if lastInputType ~= Enum.UserInputType.MouseButton2 then
					u986 = true

					if lastInputType ~= Enum.UserInputType.MouseButton3 then
						u986 = lastInputType == Enum.UserInputType.MouseWheel
					end
				end
			end
		end

		if u986 then
			u580 = true
		elseif lastInputType == Enum.UserInputType.Touch or string.sub(lastInputType.Name, 1, 7) == "Gamepad" then
			u580 = false
		end
	end)

	local function setShowing(enabled)
		if enabled == u576 then
			return
		end

		u576 = enabled
		cardCursor.Enabled = enabled
		userInputService.MouseIconEnabled = not enabled
	end
	local function inLobby()
		if LocalPlayer:GetAttribute("InMatch") == true or LocalPlayer:GetAttribute("VoteToMatchTransition") == true then
			return false
		end

		local spectating: any = LocalPlayer:GetAttribute("Spectating")
		local u989: boolean = false

		if typeof(spectating) == "number" then
			u989 = false

			if spectating ~= 0 then
				u989 = spectating ~= LocalPlayer.UserId
			end
		end

		return not u989
	end
	local function shown(p69)
		while true do
			if not p69 or not p69:IsA("GuiObject") then
				break
			end

			if not p69.Visible then
				return false
			end

			p69 = p69.Parent
		end

		local u991 = false

		if p69 ~= nil then
			u991 = p69:IsA("ScreenGui") and p69.Enabled
		end

		return u991
	end
	local function buttonOf(p70, p71)
		local v994 = p70

		while v994 and v994 ~= p71 do
			if v994:IsA("GuiButton") then
				return v994
			end

			v994 = v994.Parent
		end

		return nil
	end
	local function overCard(p72)
		local absolutePosition = p62.AbsolutePosition
		local absoluteSize = p62.AbsoluteSize

		if p72.X < absolutePosition.X or p72.Y < absolutePosition.Y or p72.X > absolutePosition.X + absoluteSize.X or p72.Y > absolutePosition.Y + absoluteSize.Y then
			return false
		end

		for _, v in ipairs(parent:GetGuiObjectsAtPosition(p72.X, p72.Y)) do
			if not v:IsDescendantOf(cardCursor) then
				if v == p62 or v:IsDescendantOf(p62) then
					return true
				end

				if v.Active then
					return false
				end
			end
		end

		return false
	end
	local function looksLikePurchase(p73)
		local lowerText = string.lower(p73.Name)
		local u1002: boolean = true

		if string.find(lowerText, "buy", 1, true) == nil then
			u1002 = true

			if string.find(lowerText, "gift", 1, true) == nil then
				u1002 = string.find(lowerText, "purchase", 1, true) ~= nil
			end
		end

		return u1002
	end

	userInputService.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not shown(p62) then
			return
		end

		local v1004 = userInputService:GetMouseLocation()
		local v1005 = guiService:GetGuiInset()
		local n2 = v1004 - v1005

		v1004 = nil

		for _, v in ipairs(parent:GetGuiObjectsAtPosition(n2.X, n2.Y)) do
			if not v:IsDescendantOf(cardCursor) then
				local v1009 = v

				while v1009 and v1009 ~= nil do
					if v1009:IsA("GuiButton") then
						v1004 = v1009

						break
					end

					v1009 = v1009.Parent
				end

				if not v1009 or v1009 == nil then
					v1004 = nil
				end

				if not not v1004 or not not v.Active then
					break
				end
			end
		end

		if not v1004 then
			return
		end

		if looksLikePurchase(v1004) then
			n1 = os.clock() + 45
		end

		if v1004:IsDescendantOf(p62) then
			u577 = true
		end

		if not u577 and not (os.clock() < n1) then
			return
		end

		if u576 == false then
			return
		end

		u576 = false
		cardCursor.Enabled = false
		userInputService.MouseIconEnabled = true
	end)

	local function promptClosed()
		n1 = 0
	end

	marketplaceService.PromptProductPurchaseFinished:Connect(promptClosed)
	marketplaceService.PromptPurchaseFinished:Connect(promptClosed)
	marketplaceService.PromptGamePassPurchaseFinished:Connect(promptClosed)
	runService.RenderStepped:Connect(function()
		local u1010 = false

		if shown(p62) and u580 and u575 and not guiService.MenuIsOpen and os.clock() >= n1 and inLobby() and userInputService.MouseBehavior == Enum.MouseBehavior.Default and (not not u576 or not not userInputService.MouseIconEnabled) then
			local v1011: Vector2 = userInputService:GetMouseLocation()
			local v1012 = guiService:GetGuiInset()
			local v1013 = overCard(v1011 - v1012)

			if not v1013 then
				u577 = false
			end

			u1010 = v1013 and not u577
		end

		if u1010 ~= u576 then
			u576 = u1010
			cardCursor.Enabled = u1010
			userInputService.MouseIconEnabled = not u1010
		end

		if u576 then
			local v1014: Vector2 = userInputService:GetMouseLocation()

			paw.Position = UDim2.fromOffset(v1014.X, v1014.Y)
		end
	end)
end)(frame, "rbxassetid://131369991525019")

for _, v in ipairs(currencies:GetChildren()) do
	if v:IsA("Frame") then
		local v149 = currencyProducts[v.Name]

		if v149 then
			local header = v:FindFirstChild("Header")

			if header then
				local text: string = "$" .. commaFormat(v149.amount) .. " Coins"
				local textLabel36 = header:FindFirstChild("TextLabel")

				if textLabel36 and textLabel36:IsA("TextLabel") then
					textLabel36.Text = text

					local textLabel37 = textLabel36:FindFirstChild("TextLabel")

					if textLabel37 and textLabel37:IsA("TextLabel") then
						textLabel37.Text = text
					end
				end
			end

			header = v:FindFirstChild("TextLabel")

			if header and header:IsA("TextLabel") then
				if v149.bonus and v149.bonus > 0 then
					header.Text = commaFormat(v149.bonus) .. " bonus!"
					header.Visible = true
				else
					header.Visible = false
				end
			end

			header = v:FindFirstChild("BuyButton")

			if header then
				local v154 = t6[v.Name] or v149.robuxPrice
				local v155 = utf8.char(57346)
				local v156 = commaFormat(v154)

				v154 = v155 .. " " .. v156
				v156 = header:FindFirstChild("TextLabel")

				if v156 and v156:IsA("TextLabel") then
					v156.Text = v154

					local textLabel38 = v156:FindFirstChild("TextLabel")

					if textLabel38 and textLabel38:IsA("TextLabel") then
						textLabel38.Text = v154
					end
				end

				header.MouseButton1Click:Connect(function()
					showPurchaseModal:Fire({
						ProductId = v149.productId,
						Name = v149.displayName,
						RobuxPrice = t6[v.Name] or v149.robuxPrice
					})
				end)
			end

			header = v:FindFirstChild("GiftButton")

			if header then
				header.MouseButton1Click:Connect(function()
					openGiftingMenu(v149)
				end)
			end
		end
	end
end

casesDivider = tradingPlazaGate.IsTradingPlaza()

if tradeTokensDivider then
	tradeTokensDivider.Visible = casesDivider
end

if tokenGapTop then
	tokenGapTop.Visible = casesDivider
end

if tokenPackages then
	tokenPackages.Visible = casesDivider
end

if tokenGapBottom then
	tokenGapBottom.Visible = casesDivider
end

if tokenPackages then
	for _, v in ipairs(tokenPackages:GetChildren()) do
		if v:IsA("Frame") then
			local v160 = tokenProducts[v.Name]

			if v160 then
				local header = v:FindFirstChild("Header")

				if header then
					local s2: string = commaFormat(v160.amount) .. " Tokens"
					local textLabel39 = header:FindFirstChild("TextLabel")

					if textLabel39 and textLabel39:IsA("TextLabel") then
						textLabel39.Text = s2

						local textLabel40 = textLabel39:FindFirstChild("TextLabel")

						if textLabel40 and textLabel40:IsA("TextLabel") then
							textLabel40.Text = s2
						end
					end
				end

				header = v:FindFirstChild("TextLabel")

				if header and header:IsA("TextLabel") then
					if v160.bonus and v160.bonus > 0 then
						header.Text = commaFormat(v160.bonus) .. " bonus!"
						header.Visible = true
					else
						header.Visible = false
					end
				end

				header = v:FindFirstChild("BuyButton")

				if header then
					local v165 = t6[v.Name] or v160.robuxPrice
					local v166 = utf8.char(57346)
					local v167 = commaFormat(v165)

					v165 = v166 .. " " .. v167
					v167 = header:FindFirstChild("TextLabel")

					if v167 and v167:IsA("TextLabel") then
						v167.Text = v165

						local textLabel41 = v167:FindFirstChild("TextLabel")

						if textLabel41 and textLabel41:IsA("TextLabel") then
							textLabel41.Text = v165
						end
					end

					header.MouseButton1Click:Connect(function()
						currencyBuyRequest:FireServer(v160.productId)
					end)
				end

				header = v:FindFirstChild("GiftButton")

				if header then
					header.MouseButton1Click:Connect(function()
						openGiftingMenu(v160)
					end)
				end
			end
		end
	end
end

local clone = nil

for _, v in ipairs(caseItems:GetChildren()) do
	if v:IsA("ImageButton") and v.Name == "ItemTemplate" then
		if not clone then
			local odds = v:FindFirstChild("Odds")

			if odds and odds:IsA("Frame") then
				clone = odds:Clone()
			end
		end

		v:Destroy()
	end
end

local function tildeIfRounded(p75, p76)
	local numberValue: number? = tonumber(p76)

	if numberValue and math.abs(numberValue - p75) > 1E-9 then
		return "~" .. p76
	end

	return p76
end
local function formatItemOdds(p77)
	local n1 = p77 * 100
	local replacedText = (if n1 >= 1 then string.format("%.1f", n1) else string.format("%.2f", n1)):gsub("%.?0+$", "")

	if replacedText == "" or replacedText == "0" then
		replacedText = string.format("%.4f", n1):gsub("%.?0+$", "")
	end

	local numberValue: number? = tonumber(replacedText)
	local s1 = if numberValue and math.abs(numberValue - n1) > 1E-9 then "~" .. replacedText else replacedText

	return s1 .. "%"
end

local uiGridLayout: Instance = caseItems:FindFirstChildOfClass("UIGridLayout")
local uiPadding: Instance = caseItems:FindFirstChildOfClass("UIPadding")

if uiGridLayout then
	caseItems.AutomaticCanvasSize = Enum.AutomaticSize.None

	local function paddingY()
		if not uiPadding then
			return 0
		end

		local y = caseItems.AbsoluteSize.Y

		return uiPadding.PaddingTop.Scale * y + uiPadding.PaddingTop.Offset + (uiPadding.PaddingBottom.Scale * y + uiPadding.PaddingBottom.Offset)
	end
	local function refreshCanvas()
		local uDim2FromOffset = UDim2.fromOffset
		local n1

		if not uiPadding then
			n1 = 0
		else
			local y = caseItems.AbsoluteSize.Y

			n1 = uiPadding.PaddingTop.Scale * y + uiPadding.PaddingTop.Offset + (uiPadding.PaddingBottom.Scale * y + uiPadding.PaddingBottom.Offset)
		end

		local roundedUp = math.ceil(uiGridLayout.AbsoluteContentSize.Y + n1 + 1)

		caseItems.CanvasSize = uDim2FromOffset(0, roundedUp)
	end

	uiGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
	caseItems:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvas)
	refreshCanvas = UDim2.fromOffset

	local n4

	if not uiPadding then
		n4 = 0
	else
		local y = caseItems.AbsoluteSize.Y

		n4 = uiPadding.PaddingTop.Scale * y + uiPadding.PaddingTop.Offset + (uiPadding.PaddingBottom.Scale * y + uiPadding.PaddingBottom.Offset)
	end

	local roundedUp = math.ceil(uiGridLayout.AbsoluteContentSize.Y + n4 + 1)

	caseItems.CanvasSize = refreshCanvas(0, roundedUp)
end

local function clearCaseItems()
	for _, v in ipairs(caseItems:GetChildren()) do
		if v:IsA("ImageButton") then
			v:Destroy()
		end
	end
end

local n5: number = 0

local function stopPctSwap()
	n5 += 1
end
local function runPctSwap(p78, list)
	n5 += 1

	local v607: number = n5
	local a = p78:FindFirstChild("A")
	local b = p78:FindFirstChild("B")

	if a and b then
		a.Position = UDim2.fromScale(0.5, 0.5)
		b.Position = UDim2.fromScale(0.5, 1.5)
		a.Text = list[1]
		b.Text = list[2] or list[1]

		if #list < 2 then
			return
		end

		task.spawn(function()
			local v1015 = a
			local v1016 = b
			local n1: number = 1

			while true do
				task.wait(3)

				if n5 ~= v607 then
					break
				end

				if not p78.Parent or not p78:IsDescendantOf(game) then
					return
				end

				n1 += 1
				v1016.Text = list[(n1 - 1) % #list + 1]
				v1016.Position = UDim2.fromScale(0.5, 1.5)

				local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local v1019 = UDim2.fromScale(0.5, -0.5)

				tweenService:Create(v1015, tweenInfo, { Position = v1019 }):Play()
				v1019 = UDim2.fromScale(0.5, 0.5)
				tweenService:Create(v1016, tweenInfo, { Position = v1019 }):Play()
				task.wait(0.35)

				if n5 ~= v607 then
					return
				end

				local v1020 = v1016

				v1016 = v1015
				v1015 = v1020
			end
		end)

		return
	end
end
local function formatPct(p80)
	local floored = math.floor(p80)

	if p80 == floored then
		local floored7 = math.floor(p80)

		return tostring(floored7) .. "%"
	end

	local formattedText = string.format("%.1f", p80)
	local numberValue: number? = tonumber(formattedText)
	local s1 = if numberValue and math.abs(numberValue - p80) > 1E-9 then "~" .. formattedText else formattedText

	return s1 .. "%"
end
local function updateStats(p81, p82)
	local n1 = 0

	for _, v in pairs(p81) do
		if typeof(v) == "number" and v > 0 then
			n1 += v
		end
	end

	n5 += 1

	for _, v in ipairs(stats:GetChildren()) do
		if v:IsA("Frame") then
			local v623 = p81[v.Name] or 0
			local n2 = if n1 > 0 then v623 / n1 * 100 else 0
			local pctSwap = v:FindFirstChild("PctSwap")

			if not pctSwap then
				local percentage = v:FindFirstChild("Percentage")

				if percentage then
					if v623 <= 0 then
						v.Visible = false
					else
						v.Visible = true

						local floored = math.floor(n2)
						local s1

						if n2 == floored then
							local floored8 = math.floor(n2)

							s1 = tostring(floored8) .. "%"
						else
							local formattedText = string.format("%.1f", n2)
							local numberValue: number? = tonumber(formattedText)
							local s2 = if numberValue and math.abs(numberValue - n2) > 1E-9 then "~" .. formattedText else formattedText

							s1 = s2 .. "%"
						end

						percentage.Text = s1
					end
				end
			elseif not p82 then
				v.Visible = false
			else
				v.Visible = true

				if p82.SoldOut then
					runPctSwap(pctSwap, { "SOLD OUT" })
				else
					local t30: {[any]: any} = {}

					if typeof(p82.Remaining) == "number" and typeof(p82.Total) == "number" then
						table.insert(t30, ("%d/%d"):format(p82.Remaining, p82.Total))
					end

					if n2 > 0 then
						local floored = math.floor(n2)
						local s3

						if n2 == floored then
							local floored9 = math.floor(n2)

							s3 = tostring(floored9) .. "%"
						else
							local formattedText = string.format("%.1f", n2)
							local numberValue: number? = tonumber(formattedText)
							local s4 = if numberValue and math.abs(numberValue - n2) > 1E-9 then "~" .. formattedText else formattedText

							s3 = s4 .. "%"
						end

						table.insert(t30, s3)
					end

					if #t30 == 0 then
						v.Visible = false
					else
						runPctSwap(pctSwap, t30)
					end
				end
			end
		end
	end
end

local n6 = 1
local u189: boolean = false
local multiBuyButton: Instance = filters1:WaitForChild("MultiBuyButton")

local function setCaption(p83, text)
	if not p83 then
		return
	end

	if p83:IsA("TextLabel") then
		p83.Text = text
	end

	local v642 = if p83:IsA("TextLabel") then p83 else p83:FindFirstChild("TextLabel")

	if v642 and v642:IsA("TextLabel") then
		v642.Text = text

		local textLabel42 = v642:FindFirstChild("TextLabel")

		if textLabel42 and textLabel42:IsA("TextLabel") then
			textLabel42.Text = text
		end
	end
end
local function refreshBuyLabels()
	local n2: number = n1 * n6

	if u48 then
		u48.Text = commaFormat(n2)
	end

	local v645 = commaFormat(n2)

	setCaption(textLabel, "$" .. v645)

	local text: string = tostring(n6)

	setCaption(multiBuyButton, text .. "x")
end
local function u193(p85)
	CrateId = p85.CrateId
	n1 = p85.Price or 0
	caseName.Text = p85.Name

	if p85.Icon then
		icon.Image = p85.Icon
	end

	n6 = 1

	local n3 = n1 * n6

	if u48 then
		u48.Text = commaFormat(n3)
	end

	local v649 = commaFormat(n3)

	setCaption(textLabel, "$" .. v649)

	local text: string = tostring(n6)

	setCaption(multiBuyButton, text .. "x")
	updateStats(p85.RarityOdds or {}, p85.Collectible)
	clearCaseItems()
	hoverInfoModule.hide(v78)

	local u651 = nil
	local s1 = ""

	local function poolsSignature(p86)
		local t45: {[any]: any} = {}

		if typeof(p86) == "table" then
			for k, v in pairs(p86) do
				if typeof(v) == "table" then
					for _, iterValue in ipairs(v) do
						local text2: string = tostring(k)
						local text3: string = tostring(iterValue.ItemType)
						local text4: string = tostring(iterValue.ItemId)
						local text5: string = tostring(iterValue.Odds)

						table.insert(t45, ("%s|%s:%s=%s"):format(text2, text3, text4, text5))
					end
				end
			end
		end

		table.sort(t45)

		return table.concat(t45, ",")
	end
	local function paintSupply(parent, p88)
		parent:SetAttribute("OddsNote", if p88.Curved == true and p88.SoldOut ~= true then "Odds get rarer as copies are claimed" else nil)

		local supply = parent:FindFirstChild("Supply")
		local maxSupply = p88.MaxSupply
		local remaining = p88.Remaining
		local text = if p88.SoldOut == true then "SOLD OUT" else if typeof(maxSupply) == "number" and typeof(remaining) == "number" then ("%s/%s"):format(commaFormat(remaining), (commaFormat(maxSupply))) else nil

		if not text or not clone then
			if supply then
				supply:Destroy()
			end

			return
		end

		if not supply then
			local clone2 = clone:Clone()

			clone2.Name = "Supply"
			clone2.AnchorPoint = Vector2.new(1, 0)
			clone2.Position = UDim2.fromScale(1, 0.065)
			clone2.Size = UDim2.fromScale(0.8, clone2.Size.Y.Scale)
			clone2.Visible = true
			clone2.Parent = parent
			supply = clone2
		end

		local textLabel43 = supply:FindFirstChildWhichIsA("TextLabel")

		if textLabel43 then
			textLabel43.Text = text
		end

		local icon = parent:FindFirstChild("Icon")

		if icon and icon:IsA("ImageLabel") then
			icon.ImageTransparency = if p88.SoldOut == true then 0.55 else 0
		end
	end

	local n2 = (tonumber(casePurchase5b3:GetAttribute("CaseViewSeq")) or 0) + 1

	casePurchase5b3:SetAttribute("CaseViewSeq", n2)
	v649 = function(p89)
		local u1041: boolean = true

		if p89 == CrateId then
			u1041 = casePurchase5b3:GetAttribute("CaseViewSeq") ~= n2
		end

		return u1041
	end
	task.spawn(function()
		local crateId = p85.CrateId

		while true do
			local ok, result = pcall(function()
				return { inventory:InvokeServer("GetCaseView", { CrateId = crateId }) }
			end)

			if not ok then
				break
			end

			local u1045: boolean = true

			if crateId == CrateId then
				u1045 = casePurchase5b3:GetAttribute("CaseViewSeq") ~= n2
			end

			if u1045 then
				break
			end

			local v1046 = result[1] == true and result[2] or nil

			if typeof(v1046) ~= "table" or crateId ~= v1046.CrateId then
				return
			end

			updateStats(v1046.RarityOdds or p85.RarityOdds or {}, v1046.Collectible)

			local v1047 = u651

			if v1047 and typeof(v1046.PublicPools) == "table" and poolsSignature(v1046.PublicPools) ~= s1 then
				v1047(v1046.PublicPools)
			elseif typeof(v1046.Collectible) == "table" and typeof(v1046.Collectible.Items) == "table" then
				for _, v in ipairs(v1046.Collectible.Items) do
					local text6: string = tostring(v.ItemType)
					local text7: string = tostring(v.ItemId)

					for _, iterValue in ipairs(caseItems:GetChildren()) do
						local collectibleKey = iterValue:GetAttribute("CollectibleKey")

						if text6 .. ":" .. text7 == collectibleKey then
							paintSupply(iterValue, v)
						end
					end
				end
			end

			if not v1046.Collectible then
				return
			end

			task.wait(5)

			if not casePurchase5b3.Visible then
				return
			end

			u1045 = true

			if crateId == CrateId then
				u1045 = casePurchase5b3:GetAttribute("CaseViewSeq") ~= n2
			end

			if u1045 then
				return
			end
		end
	end)
	u651 = function(p90)
		local s2

		clearCaseItems()
		hoverInfoModule.hide(v78)
		s1 = poolsSignature(p90)

		for _, v in ipairs(t1) do
			local v1059 = p90[v]

			if v ~= "Secret" or v1059 and #v1059 ~= 0 then
				if v1059 then
					for _, iterValue in ipairs(v1059) do
						local v1062 = iterValue.Rarity or v
						local parent, v1064 = uiFramework.createItemCell(v1062, {
							visible = true,
							active = true,
							interactable = true,
							selectable = true,
							icon = iterValue.Icon,
							parent = caseItems
						})

						parent.LayoutOrder = rarityOrder[v1062] or 0
						parent.Name = iterValue.ItemId or "item"

						if v == "Collectible" then
							local text8: string = tostring(iterValue.ItemType)
							local text9: string = tostring(iterValue.ItemId)

							parent:SetAttribute("CollectibleKey", text8 .. ":" .. text9)
							paintSupply(parent, iterValue)
						end

						local u1067: boolean = v == "Secret"

						if clone and typeof(iterValue.Odds) == "number" and iterValue.Odds > 0 then
							local clone2 = clone:Clone()
							local textLabel44 = clone2:FindFirstChildWhichIsA("TextLabel")

							if textLabel44 and v == "Collectible" then
								local floored = math.floor(1 / iterValue.Odds + 0.5)
								local text10

								if floored >= 1000000 then
									local stringFormat = string.format
									local floored10 = math.floor(floored / 100000 + 0.5)

									text10 = stringFormat("%gM", floored10 / 10)
								elseif floored >= 1000 then
									local v1074 = string.format
									local floored11 = math.floor(floored / 100 + 0.5)

									text10 = v1074("%gK", floored11 / 10)
								else
									text10 = tostring(floored)
								end

								textLabel44.Text = "1 in " .. text10
							elseif textLabel44 then
								textLabel44.Text = formatItemOdds(iterValue.Odds)
							end

							clone2.Visible = true
							clone2.Parent = parent
						end

						if u1067 then
							local icon = parent:FindFirstChild("Icon")

							if icon and icon:IsA("ImageLabel") then
								icon.ImageColor3 = Color3.new(0, 0, 0)
							end

							local glow = parent:FindFirstChild("Glow")

							if glow and glow:IsA("ImageLabel") then
								glow.ImageColor3 = Color3.new(1, 1, 1)
								glow.Visible = true
							end
						end

						s2 = iterValue.Name or iterValue.ItemId or "?"

						local u1078 = nil

						if not u1067 then
							if iterValue.ItemType == "Knife" or iterValue.ItemType == "Revolver" then
								u1078 = iterValue.ItemType
							elseif iterValue.ItemType == "Finisher" or iterValue.ItemType == "KillEffect" then
								u1078 = "Finisher"
							end
						end

						local v1079 = hoverInfoModule.bind(v78, parent, function()
							if u189 then
								return nil
							end

							local v1277 = u1078
							local oddsNote = parent:GetAttribute("OddsNote")
							local t49: {[any]: any} = {
								Name = s2,
								Rarity = v1062,
								SourceButton = parent,
								Kind = v1277,
								Note = oddsNote,
								ItemId = v1277
							}

							v1277 = if u1078 == nil or typeof(iterValue.ItemId) ~= "string" then nil else iterValue.ItemId

							return t49
						end)

						if not u1067 then
							if iterValue.ItemType == "Knife" or iterValue.ItemType == "Revolver" then
								parent.MouseButton1Click:Connect(function()
									if v1079.tapConsumed() then
										return
									end

									if u189 then
										return
									end

									inspectItem:Fire({
										Kind = iterValue.ItemType,
										ItemId = iterValue.ItemId,
										Name = iterValue.Name or iterValue.ItemId or "?",
										Rarity = v1062
									})
								end)
							elseif iterValue.ItemType == "Finisher" or iterValue.ItemType == "KillEffect" then
								parent.MouseButton1Click:Connect(function()
									if v1079.tapConsumed() then
										return
									end

									if u189 then
										return
									end

									inspectItem:Fire({
										Kind = "Finisher",
										ItemId = iterValue.ItemId,
										Name = iterValue.Name or iterValue.ItemId or "?",
										Rarity = v1062
									})
								end)
							end
						end
					end
				end
			elseif p85.SecretPossible then
				local v1080, v1081 = uiFramework.createItemCell("Secret", {
					icon = "rbxassetid://12905962634",
					visible = true,
					active = true,
					interactable = true,
					selectable = false,
					parent = caseItems
				})

				v1080.LayoutOrder = rarityOrder.Secret
				v1080.Name = "Secret_?"
				hoverInfoModule.bind(v78, v1080, function()
					if u189 then
						return nil
					end

					return { Name = "???", Rarity = "Secret", SourceButton = v1080 }
				end)
			end
		end
	end
	u651(p85.PublicPools or {})
	content.Visible = false
	casePurchase5b3.Visible = true
end

buyButton.MouseButton1Click:Connect(function()
	if u189 then
		return
	end

	if not CrateId then
		return
	end

	local v656 = CrateId
	local v657: number = n6
	local n2 = n1 * v657

	task.spawn(function()
		local u1082 = nil

		local ok, result = pcall(function()
			u1082 = { inventory:InvokeServer("PurchaseCrate", { CrateId = v656, Count = v657 }) }
		end)

		local v1085: string = if u1082 then tostring(u1082[2] or result) else tostring(result)

		if not insufficientFundsPrompt.HandlePurchaseError(v1085, "Cash", n2) then
			_G.Notify({ notifType = "FailNotification", errorMessage = t2[v1085] or v1085 })
		end
	end)
end)
v42.MouseButton1Click:Connect(function()
	if u189 then
		return
	end

	casePurchase5b3.Visible = false
	content.Visible = true
	hoverInfoModule.hide(v78)
	CrateId = nil
end)

local multiBuyContainer: Instance = hud:WaitForChild("MultiBuyContainer")

casesDivider = multiBuyContainer:WaitForChild("Window")

local itemName = casesDivider:WaitForChild("ItemName")
local total = casesDivider:WaitForChild("Total")

tokenGapBottom = casesDivider:WaitForChild("Bar")
tokenGapTop = tokenGapBottom:WaitForChild("Backing")
tradeTokensDivider = tokenGapTop:WaitForChild("Bar")
v42 = tokenGapTop:WaitForChild("Slider")

local v197 = tokenGapBottom:WaitForChild("Value")
local confirm = casesDivider:WaitForChild("CONFIRM")

tokenGapBottom = casesDivider:WaitForChild("CANCEL")

local n7 = 1

tradeTokensDivider.AnchorPoint = Vector2.new(0, 0.5)
tradeTokensDivider.Position = UDim2.new(0, 0, 0.5, 0)
v42.AnchorPoint = Vector2.new(0.5, 0.5)

local v200 = uiFramework.wireSlider({
	min = 1,
	max = 1,
	default = 1,
	knobPositionAxis = true,
	barContainer = tokenGapTop,
	innerBar = tradeTokensDivider,
	knob = v42,
	valueLabel = v197,
	getValue = function()
		return n7
	end,
	setValue = function(p91)
		n7 = p91
	end,
	onChange = function()
		if multiBuyContainer:GetAttribute("OpenMax") then
			total.Text = ("%d owned"):format(multiBuyContainer:GetAttribute("OpenOwned") or 0)

			return
		end

		total.Text = "$" .. commaFormat(n1 * n7)
	end
})

local u201 = nil

local v202 = gamepadSliderController.new({
	actionPrefix = "MB",
	windowFrame = multiBuyContainer,
	closeFn = function()
		u201()
	end
})

v42 = v202:addSlider(tokenGapTop, v200.adjustByDelta)
v42.NextSelectionRight = v197
v197.NextSelectionLeft = v42
v42.NextSelectionDown = confirm
v197.NextSelectionDown = confirm
confirm.NextSelectionRight = tokenGapBottom
tokenGapBottom.NextSelectionLeft = confirm
confirm.NextSelectionUp = v42
tokenGapBottom.NextSelectionUp = v197
v42.NextSelectionLeft = v42

local t16: {[any]: any} = {}
local ScrollingEnabled = nil

local function setCaseScreenInteractable(p92)
	u189 = not p92

	if not p92 then
		table.clear(t16)

		local function lock(p93)
			t16[p93] = {
				Active = p93.Active,
				Interactable = p93.Interactable,
				Selectable = p93.Selectable
			}
			p93.Active = false
			p93.Interactable = false
			p93.Selectable = false
		end

		for _, v in ipairs(casePurchase5b3:GetDescendants()) do
			if v:IsA("GuiButton") then
				t16[v] = {
					Active = v.Active,
					Interactable = v.Interactable,
					Selectable = v.Selectable
				}
				v.Active = false
				v.Interactable = false
				v.Selectable = false
			end
		end

		for _, v in ipairs(navigator:GetChildren()) do
			if v:IsA("GuiButton") then
				t16[v] = {
					Active = v.Active,
					Interactable = v.Interactable,
					Selectable = v.Selectable
				}
				v.Active = false
				v.Interactable = false
				v.Selectable = false
			end
		end

		local v666: Instance = closeButton

		t16[v666] = {
			Active = v666.Active,
			Interactable = v666.Interactable,
			Selectable = v666.Selectable
		}
		v666.Active = false
		v666.Interactable = false
		v666.Selectable = false
		ScrollingEnabled = caseItems.ScrollingEnabled
		caseItems.ScrollingEnabled = false
		hoverInfoModule.hide(v78)

		return
	end

	for k, v in pairs(t16) do
		if k.Parent then
			k.Active = v.Active
			k.Interactable = v.Interactable
			k.Selectable = v.Selectable
		end
	end

	table.clear(t16)

	if ScrollingEnabled ~= nil then
		caseItems.ScrollingEnabled = ScrollingEnabled
		ScrollingEnabled = nil
	end
end
local function openMultiBuy()
	if u189 then
		return
	end

	if not CrateId then
		return
	end

	local cash: any = LocalPlayer:GetAttribute("Cash")
	local v670 = if n1 > 0 and typeof(cash) == "number" then math.floor(cash / n1) else 100
	local v671 = math.clamp(v670, 10, 100)

	v670 = n6

	local openMax: any = multiBuyContainer:GetAttribute("OpenMax")

	if typeof(openMax) == "number" then
		v671 = openMax
		v670 = multiBuyContainer:GetAttribute("OpenCount") or 1
	end

	n7 = math.clamp(v670, 1, v671)
	v200.setRange(1, v671, 1)
	v200.refresh()
	itemName.Text = caseName.Text
	v197.PlaceholderText = tostring(v671)
	v197.Text = tostring(n7)

	if multiBuyContainer:GetAttribute("OpenMax") then
		total.Text = ("%d owned"):format(multiBuyContainer:GetAttribute("OpenOwned") or 0)
	else
		total.Text = "$" .. commaFormat(n1 * n7)
	end

	multiBuyContainer.Visible = true
	setCaseScreenInteractable(false)

	if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		v202:activate()
	end
end

u201 = function()
	if not multiBuyContainer.Visible then
		return
	end

	multiBuyContainer.Visible = false
	u189 = false

	for k, v in pairs(t16) do
		if k.Parent then
			k.Active = v.Active
			k.Interactable = v.Interactable
			k.Selectable = v.Selectable
		end
	end

	table.clear(t16)

	if ScrollingEnabled ~= nil then
		caseItems.ScrollingEnabled = ScrollingEnabled
		ScrollingEnabled = nil
	end

	v202:deactivate()
	multiBuyContainer:SetAttribute("OpenMax", nil)
end
multiBuyButton.MouseButton1Click:Connect(openMultiBuy)
confirm.MouseButton1Click:Connect(function()
	if multiBuyContainer:GetAttribute("OpenMax") then
		multiBuyContainer:SetAttribute("OpenCount", n7)
	else
		n6 = n7

		local n2 = n1 * n6

		if u48 then
			u48.Text = commaFormat(n2)
		end

		local v676 = commaFormat(n2)

		setCaption(textLabel, "$" .. v676)

		local text: string = tostring(n6)

		setCaption(multiBuyButton, text .. "x")
	end

	u201()
end)
tokenGapBottom.MouseButton1Click:Connect(u201)
casePurchase5b3:GetPropertyChangedSignal("Visible"):Connect(function()
	if not casePurchase5b3.Visible then
		u201()
	end
end)
shopWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if not shopWindow.Visible then
		u201()
	end
end)

local t17: {[any]: any} = {
	RegularCase = "RecruitCase",
	PremiumCase = "HallowsCase",
	FinishersCase = "FinishersCase"
}

local function populateCases()
	if not u74 then
		return
	end

	local t31: {[any]: any} = {}

	for _, v in ipairs(u74) do
		t31[v.CrateId] = v
	end

	for k, v in pairs(t17) do
		local k: Instance = cases_Row1:FindFirstChild(k)

		if k then
			local v684 = t31[v]

			if v684 then
				local caseIcon: Instance = k:FindFirstChild("CaseIcon")

				if caseIcon and v684.Icon then
					caseIcon.Image = v684.Icon
				end

				local caseName: Instance = k:FindFirstChild("CaseName")

				if caseName then
					caseName.Text = v684.Name

					local caseName2: Instance = caseName:FindFirstChild("CaseName")

					if caseName2 and caseName2:IsA("TextLabel") then
						caseName2.Text = v684.Name
					end
				end

				local price: Instance = k:FindFirstChild("Price")
				local v689 = commaFormat(v684.Price or 0)

				setCaption(price, "$" .. v689)

				local buyButton: Instance = k:FindFirstChild("BuyButton")

				if buyButton then
					buyButton.MouseButton1Click:Connect(function()
						u193(v684)
					end)
				end
			end
		end
	end

	local premiumCase: Instance = cases_Row1:FindFirstChild("PremiumCase")
	local premiumCaseCaseIcon: Instance = premiumCase and premiumCase:FindFirstChild("CaseIcon")

	if premiumCaseCaseIcon then
		local premiumCaseCaseIconPosition = premiumCaseCaseIcon.Position
		local connection = nil

		connection = runService.Heartbeat:Connect(function()
			if not premiumCaseCaseIcon:IsDescendantOf(game) then
				connection:Disconnect()

				return
			end

			local scrollingFrameAbsolutePosition = scrollingFrame.AbsolutePosition
			local scrollingFrameAbsoluteSize = scrollingFrame.AbsoluteSize
			local premiumCaseAbsolutePosition = premiumCase.AbsolutePosition
			local n1 = scrollingFrameAbsoluteSize.Y * 0.13

			if premiumCaseAbsolutePosition.Y >= scrollingFrameAbsolutePosition.Y - n1 and premiumCaseAbsolutePosition.Y + premiumCase.AbsoluteSize.Y <= scrollingFrameAbsolutePosition.Y + scrollingFrameAbsoluteSize.Y + n1 then
				local v1091 = elapsedTime()
				local sine = math.sin(v1091 * 0.8)
				local sine4 = math.sin(v1091 * 0.4)
				local cosine = math.cos(v1091 * 0.8)
				local sine5 = math.sin(v1091 * 0.35)

				premiumCaseCaseIcon.Rotation = math.sin(v1091 * 0.7) * 2.5

				local v1096 = UDim2.fromScale(sine * 0.008 + sine4 * 0.004, cosine * 0.018 + sine5 * 0.009)

				premiumCaseCaseIcon.Position = premiumCaseCaseIcon.Position:Lerp(premiumCaseCaseIconPosition + v1096, 0.08)

				return
			end

			premiumCaseCaseIcon.Rotation = 0
			premiumCaseCaseIcon.Position = premiumCaseCaseIconPosition
		end)
	end
end

v42 = cases_Row1:FindFirstChild("PremiumCase")
tokenGapBottom = v42 and v42:FindFirstChild("Shine")

if tokenGapBottom then
	shineEffect.loop(tokenGapBottom, {
		duration = 1,
		offsetStart = Vector2.new(-1.8, 0),
		offsetEnd = Vector2.new(1.8, 0)
	})
end

bindables:WaitForChild("OpenShop").Event:Connect(function(p94, p95)
	if not p94 then
		return
	end

	u79 = true
	jumpToSection(p94)

	if p95 and t17[p95] and u74 then
		local v697 = t17[p95]

		for _, v in ipairs(u74) do
			if v697 == v.CrateId then
				task.defer(function()
					u193(v)
				end)

				return
			end
		end

		return
	end
end);
(function()
	local description: Instance = filters1:FindFirstChild("Description")
	local openButton: Instance = filters1:FindFirstChild("OpenButton")
	local openCountButton: Instance = filters1:FindFirstChild("OpenCountButton")
	local openHeader: Instance = filters1:FindFirstChild("OpenHeader")
	local u704: boolean = false

	if openButton ~= nil then
		u704 = openButton:IsA("GuiButton")

		if u704 then
			u704 = false

			if openCountButton ~= nil then
				u704 = openCountButton:IsA("GuiButton")

				if u704 then
					u704 = false

					if openHeader ~= nil then
						u704 = openHeader:IsA("TextLabel")
					end
				end
			end
		end
	end

	local shared: Instance = replicatedStorage:WaitForChild("Shared")
	local windowBlur = require(shared:WaitForChild("WindowBlur"))
	local sound = require(replicatedStorage:WaitForChild("Sound"))
	local openCrate: Instance = bindables:WaitForChild("OpenCrate")
	local openCrateMulti: Instance = bindables:WaitForChild("OpenCrateMulti")
	local spinner: Instance = playerGui:WaitForChild("Spinner")
	local t32: {[any]: any} = {
		OpenInProgress = "Already opening a case.",
		OpenCooldown = "Slow down a little!",
		ListedInBooth = "Unlist this case from your booth to open it.",
		MultiOpenRestricted = "Open your cases from the inventory.",
		NoneOwned = "You don't have any of this case.",
		OpenFailed = "Couldn't open the case, try again."
	}
	local u712 = nil
	local n2 = 1
	local t33: {[any]: any} = {}
	local t34: {[any]: any} = {}
	local u716: boolean = false
	local u717: boolean = false
	local traitPill: Instance = filters1:FindFirstChild("TraitPill")
	local traitAura: Instance = filters1:FindFirstChild("TraitAura")
	local traitTooltip: Instance = casePurchase5b3:FindFirstChild("TraitTooltip")
	local v721: Instance = traitPill and traitPill:FindFirstChild("Text")
	local icon: Instance = traitPill and traitPill:FindFirstChild("Icon")
	local hit: Instance = traitPill and traitPill:FindFirstChild("Hit")
	local fill: Instance = traitPill and traitPill:FindFirstChild("Fill")
	local traitPillUiStroke: Instance = traitPill and traitPill:FindFirstChildOfClass("UIStroke")
	local strokeGradient: Instance = traitPillUiStroke and traitPillUiStroke:FindFirstChild("StrokeGradient")
	local v727 = if fill and fill:IsA("UIGradient") then fill.Color else nil
	local v728 = if strokeGradient and strokeGradient:IsA("UIGradient") then strokeGradient.Color else nil
	local t35: {[any]: any} = {}

	if traitAura then
		for _, v in ipairs(traitAura:GetChildren()) do
			local uiStroke = v:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				table.insert(t35, uiStroke)
			end
		end
	end

	local v733 = if t35[1] then t35[1].Color else nil

	local function hexColor(p96)
		local ok, result = pcall(Color3.fromHex, p96)

		if ok then
			return result
		end

		return nil
	end
	local function tintPill(p97)
		local color33 = Color3.new(0, 0, 0)

		if fill and fill:IsA("UIGradient") and v727 then
			local v1103

			if p97 then
				local colorSequenceNew = ColorSequence.new

				v1103 = colorSequenceNew({
					ColorSequenceKeypoint.new(0, p97:Lerp(color33, 0.65)),
					ColorSequenceKeypoint.new(0.5, p97:Lerp(color33, 0.15)),
					ColorSequenceKeypoint.new(1, p97:Lerp(color33, 0.6))
				})
			else
				v1103 = v727
			end

			fill.Color = v1103
		end

		if strokeGradient and strokeGradient:IsA("UIGradient") and v728 then
			local v1106

			if p97 then
				local v1107 = ColorSequence.new

				v1106 = v1107({
					ColorSequenceKeypoint.new(0, p97:Lerp(Color3.new(1, 1, 1), 0.3)),
					ColorSequenceKeypoint.new(0.25, p97),
					ColorSequenceKeypoint.new(0.5, (Color3.new(1, 1, 1))),
					ColorSequenceKeypoint.new(0.75, p97),
					ColorSequenceKeypoint.new(1, p97:Lerp(Color3.new(1, 1, 1), 0.3))
				})
			else
				v1106 = v728
			end

			strokeGradient.Color = v1106
		end

		for _, v in ipairs(t35) do
			if p97 then
				v.Color = p97
			elseif v733 then
				v.Color = v733
			end
		end
	end

	local t36: {[any]: any} = {}
	local u737 = nil

	local function stopPillFx()
		for _, v in ipairs(t36) do
			v:Cancel()
		end

		table.clear(t36)

		if u737 then
			u737()
			u737 = nil
		end
	end
	local function startPillFx()
		stopPillFx()

		if strokeGradient and strokeGradient:IsA("UIGradient") then
			strokeGradient.Rotation = 0

			local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
			local v1113: Tween = tweenService:Create(strokeGradient, tweenInfo, { Rotation = 360 })

			v1113:Play()
			table.insert(t36, v1113)
		end

		for _, v in ipairs(t35) do
			local vParent = v.Parent
			local transparency = vParent and vParent:GetAttribute("BaseTransparency")
			local thickness = vParent and vParent:GetAttribute("BaseThickness")

			if typeof(transparency) == "number" and typeof(thickness) == "number" then
				v.Transparency = transparency
				v.Thickness = thickness

				local tweenInfo = TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
				local v1120 = math.min(0.97, transparency + 0.1)
				local v1121: Tween = tweenService:Create(v, tweenInfo, { Transparency = v1120, Thickness = thickness * 1.12 })

				v1121:Play()
				table.insert(t36, v1121)
			end
		end

		local shine: Instance = v721 and v721:FindFirstChild("Shine")

		if shine then
			u737 = shineEffect.loop(shine, { duration = 1, interval = 3 })
		end
	end

	local u740 = nil

	local function hideTip()
		if traitTooltip and traitTooltip:IsA("GuiObject") then
			traitTooltip.Visible = false
		end
	end
	local function buildTip(p98)
		u740 = p98

		if not traitTooltip or not traitTooltip:IsA("GuiObject") then
			return
		end

		local header: Instance = traitTooltip:FindFirstChild("Header")
		local rowTemplate: Instance = traitTooltip:FindFirstChild("RowTemplate")

		for _, v in ipairs(traitTooltip:GetChildren()) do
			if v.Name == "Row" then
				v:Destroy()
			end
		end

		local t46 = if typeof(p98.Rolls) == "table" then p98.Rolls else {}
		local n1: number = #t46 * 0.062 + 0.13

		traitTooltip.Size = UDim2.new(traitTooltip.Size.X, UDim.new(n1, 0))

		if header and header:IsA("TextLabel") then
			local v1130 = if typeof(p98.Color) == "string" then p98.Color else "#C77DFF"
			local v1131 = if typeof(p98.Title) == "string" then p98.Title else p98.Name
			local s1: string = if typeof(p98.Tiers) == "table" and #p98.Tiers > 0 then table.concat(p98.Tiers, " or ") .. " " else ""
			local n2 = p98.Chance * 100
			local floored = math.floor(n2)
			local s2

			if n2 == floored then
				local floored12 = math.floor(n2)

				s2 = tostring(floored12) .. "%"
			else
				local formattedText = string.format("%.1f", n2)
				local numberValue: number? = tonumber(formattedText)
				local s3 = if numberValue and math.abs(numberValue - n2) > 1E-9 then "~" .. formattedText else formattedText

				s2 = s3 .. "%"
			end

			header.Text = ("Each %sweapon has a %s chance of rolling a <font color=\"%s\">%s</font>!"):format(s1, s2, v1130, v1131)
			header.Size = UDim2.new(header.Size.X, UDim.new(0.13 / n1, 0))
		end

		if rowTemplate and rowTemplate:IsA("GuiObject") then
			for i, v in ipairs(t46) do
				local clone: Instance = rowTemplate:Clone()

				clone.Name = "Row"
				clone.Visible = true
				clone.Size = UDim2.fromScale(1, 0.062 / n1)
				clone.Position = UDim2.fromScale(0, (0.13 + (i - 1) * 0.062) / n1)

				local icon: Instance = clone:FindFirstChild("Icon")

				if icon and icon:IsA("ImageLabel") then
					icon.Image = v.Icon or ""
				end

				local itemName: Instance = clone:FindFirstChild("ItemName")

				if itemName and itemName:IsA("TextLabel") then
					itemName.Text = v.Name or "?"
					itemName.TextColor3 = rarity.Colors[v.Rarity] or Color3.new(1, 1, 1)
				end

				local odds: Instance = clone:FindFirstChild("Odds")

				if odds and odds:IsA("TextLabel") then
					odds.Text = formatItemOdds(v.Odds or 0)
				end

				clone.Parent = traitTooltip
			end
		end
	end
	local function showTip()
		if not u740 or not traitTooltip or not traitTooltip:IsA("GuiObject") or not traitPill or not traitPill.Visible then
			return
		end

		local casePurchase5b3AbsolutePosition = casePurchase5b3.AbsolutePosition
		local casePurchase5b3AbsoluteSize = casePurchase5b3.AbsoluteSize

		if casePurchase5b3AbsoluteSize.X <= 0 or casePurchase5b3AbsoluteSize.Y <= 0 then
			return
		end

		traitTooltip.Position = UDim2.fromScale((filters1.AbsolutePosition.X + filters1.AbsoluteSize.X + 6 - casePurchase5b3AbsolutePosition.X) / casePurchase5b3AbsoluteSize.X, (traitPill.AbsolutePosition.Y + traitPill.AbsoluteSize.Y / 2 - casePurchase5b3AbsolutePosition.Y) / casePurchase5b3AbsoluteSize.Y)
		traitTooltip.Visible = true
	end

	if hit and hit:IsA("GuiButton") and traitPill then
		local userInputService: UserInputService = game:GetService("UserInputService")

		local function touchOnly()
			return userInputService.TouchEnabled and not userInputService.MouseEnabled
		end

		hit.MouseEnter:Connect(function()
			if not userInputService.TouchEnabled or not not userInputService.MouseEnabled then
				showTip()
			end
		end)
		hit.MouseLeave:Connect(function()
			if (not userInputService.TouchEnabled or not not userInputService.MouseEnabled) and traitTooltip and traitTooltip:IsA("GuiObject") then
				traitTooltip.Visible = false
			end
		end)
		hit.Activated:Connect(function()
			if not userInputService.TouchEnabled or not not userInputService.MouseEnabled then
				return
			end

			if not traitTooltip or not traitTooltip:IsA("GuiObject") or not traitTooltip.Visible then
				showTip()
			elseif traitTooltip and traitTooltip:IsA("GuiObject") then
				traitTooltip.Visible = false

				return
			end
		end)
		userInputService.InputBegan:Connect(function(input: InputObject)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if not traitTooltip or not traitTooltip:IsA("GuiObject") or not traitTooltip.Visible then
				return
			end

			local inputPosition: Vector3 = input.Position
			local traitPillAbsolutePosition = traitPill.AbsolutePosition
			local traitPillAbsoluteSize = traitPill.AbsoluteSize

			if (inputPosition.X < traitPillAbsolutePosition.X or inputPosition.X > traitPillAbsolutePosition.X + traitPillAbsoluteSize.X or inputPosition.Y < traitPillAbsolutePosition.Y or inputPosition.Y > traitPillAbsolutePosition.Y + traitPillAbsoluteSize.Y) and traitTooltip and traitTooltip:IsA("GuiObject") then
				traitTooltip.Visible = false
			end
		end)
	end

	casePurchase5b3:GetPropertyChangedSignal("Visible"):Connect(function()
		if not casePurchase5b3.Visible then
			if traitTooltip and traitTooltip:IsA("GuiObject") then
				traitTooltip.Visible = false
			end

			stopPillFx()
		end
	end)

	local function describe(p100)
		local v1153 = if typeof(p100.Traits) == "table" then p100.Traits[1] else nil
		local v1154 = traitPill and traitPill:IsA("GuiObject") and v721 and v721:IsA("TextLabel")

		if traitTooltip and traitTooltip:IsA("GuiObject") then
			traitTooltip.Visible = false
		end

		if v1153 and v1154 then
			local v1155

			if typeof(v1153.Color) == "string" then
				local ok, result = pcall(Color3.fromHex, v1153.Color)

				v1155 = if ok then result else nil
			else
				v1155 = nil
			end

			tintPill(v1155)

			local v1158 = v1153.Name
			local n1 = v1153.Chance * 100
			local floored = math.floor(n1)
			local s1

			if n1 == floored then
				local floored13 = math.floor(n1)

				s1 = tostring(floored13) .. "%"
			else
				local formattedText = string.format("%.1f", n1)
				local numberValue: number? = tonumber(formattedText)
				local s2 = if numberValue and math.abs(numberValue - n1) > 1E-9 then "~" .. formattedText else formattedText

				s1 = s2 .. "%"
			end

			v721.Text = ("<b>%s</b> %s"):format(v1158, s1)

			local u1166: boolean = false

			if typeof(v1153.Icon) == "string" then
				u1166 = false

				if icon ~= nil then
					u1166 = icon:IsA("ImageLabel")
				end
			end

			if icon and icon:IsA("ImageLabel") then
				icon.Visible = u1166

				if u1166 then
					icon.Image = v1153.Icon
				end
			end

			v721.Position = UDim2.fromScale(if u1166 then 0.555 else 0.5, 0.5)
			v721.Size = UDim2.fromScale(if u1166 then 0.8 else 0.9, 0.72)
			traitPill.Visible = true

			if traitAura and traitAura:IsA("GuiObject") then
				traitAura.Visible = true
			end

			buildTip(v1153)
			startPillFx()

			if description then
				description.Visible = false

				return
			end
		else
			stopPillFx()
			u740 = nil

			if traitPill and traitPill:IsA("GuiObject") then
				traitPill.Visible = false
			end

			if traitAura and traitAura:IsA("GuiObject") then
				traitAura.Visible = false
			end

			if description and description:IsA("TextLabel") then
				description.Text = p100.Description or ""
				description.Visible = true
			end
		end
	end
	local function isRestricted()
		return LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") ~= false
	end
	local function maxOpen()
		return (math.min(u712 or 0, 10))
	end
	local function setEnabled(p101, p102)
		if p102 then
			uiFramework.setButtonEnabled(p101)

			return
		end

		uiFramework.setButtonDisabled(p101)
	end
	local function refreshRow()
		if not u704 then
			return
		end

		local v1169 = math.min(u712 or 0, 10)
		local v1170 = if CrateId then t33[CrateId] else nil

		if v1170 then
			n2 = v1170
		end

		if u712 ~= nil and v1169 < n2 then
			n2 = math.max(1, v1169)
		end

		openHeader.Text = if u712 == nil then "OPEN" else ("OPEN  <font color=\"%s\">%d owned</font>"):format(if u712 > 0 then "#8BE04E" else "#9A9A9A", u712)
		setCaption(openButton, ("Open %d"):format(n2))
		setCaption(openCountButton, ("%dx"):format(n2))

		if u189 then
			return
		end

		local v1171: Instance = openButton

		if v1169 >= 1 then
			uiFramework.setButtonEnabled(v1171)
		else
			uiFramework.setButtonDisabled(v1171)
		end

		v1171 = openCountButton

		if v1169 >= 2 then
			uiFramework.setButtonEnabled(v1171)

			return
		end

		uiFramework.setButtonDisabled(v1171)
	end

	local buyHeader: Instance = filters1:FindFirstChild("BuyHeader")
	local t37: {[any]: any} = { buyButton, multiBuyButton }

	if buyHeader and buyHeader:IsA("GuiObject") then
		table.insert(t37, buyHeader)
	end

	local t38: {[any]: any} = {}

	for _, v in ipairs(t37) do
		t38[v] = v.Position.Y
	end

	local function lowerY(p103)
		if p103 ~= buyHeader then
			if openButton then
				return openButton.Position.Y
			end
		elseif openHeader then
			return openHeader.Position.Y
		end

		return nil
	end
	local function applyVisibility()
		local v1173: boolean = u704

		if v1173 then
			v1173 = LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") == false
		end

		u716 = v1173

		if u704 then
			openButton.Visible = u716
			openCountButton.Visible = u716
			openHeader.Visible = u716
		end

		for _, v in ipairs(t37) do
			v.Position = UDim2.new(v.Position.X, if u716 then t38[v] else (if v == buyHeader then if openHeader then openHeader.Position.Y else nil else if openButton then openButton.Position.Y else nil) or t38[v])
		end
	end

	applyVisibility()
	LocalPlayer:GetAttributeChangedSignal("ArePaidRandomItemsRestricted"):Connect(applyVisibility)
	applyVisibility = function(p104)
		local v1177, v1178, v1179 = pcall(function()
			return inventory:InvokeServer("GetCaseView", { CrateId = p104 })
		end)

		if v1177 and v1178 == true and typeof(v1179) == "table" and typeof(v1179.Owned) == "number" then
			return v1179.Owned
		end

		return nil
	end

	local function refreshOwned()
		if not u704 then
			return
		end

		local v1180 = CrateId

		if not v1180 then
			return
		end

		task.spawn(function()
			local v1280 = v1180

			local v1281, v1282, v1283 = pcall(function()
				return inventory:InvokeServer("GetCaseView", { CrateId = v1280 })
			end)

			local v1284 = if v1281 and v1282 == true and typeof(v1283) == "table" and typeof(v1283.Owned) == "number" then v1283.Owned else nil

			if CrateId ~= v1180 then
				return
			end

			u712 = v1284
			refreshRow()
		end)
	end

	local v759: (...any) -> ...any = u193

	u193 = function(p105)
		u712 = nil
		n2 = t33[p105.CrateId] or 1
		v759(p105)

		local v1182 = t34[p105.CrateId]

		if v1182 then
			n6 = v1182

			local n3 = n1 * n6

			if u48 then
				u48.Text = commaFormat(n3)
			end

			local v1184 = commaFormat(n3)

			setCaption(textLabel, "$" .. v1184)

			local text: string = tostring(n6)

			setCaption(multiBuyButton, text .. "x")
		end

		describe(p105)
		refreshRow()

		if not u704 then
			return
		end

		local v1186 = CrateId

		if not v1186 then
			return
		end

		task.spawn(function()
			local v1285 = v1186

			local v1286, v1287, v1288 = pcall(function()
				return inventory:InvokeServer("GetCaseView", { CrateId = v1285 })
			end)

			local v1289 = if v1286 and v1287 == true and typeof(v1288) == "table" and typeof(v1288.Owned) == "number" then v1288.Owned else nil

			if CrateId ~= v1186 then
				return
			end

			u712 = v1289
			refreshRow()
		end)
	end
	confirm.MouseButton1Click:Connect(function()
		local v1187 = CrateId

		task.defer(function()
			if v1187 and v1187 == CrateId then
				t34[v1187] = n6
			end
		end)
	end)
	buyButton.MouseButton1Click:Connect(function()
		if CrateId and not u189 then
			t34[CrateId] = n6
		end
	end)

	if not u704 then
		return
	end

	LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
		if not casePurchase5b3.Visible or u717 then
			return
		end

		if not u704 then
			return
		end

		local v1188 = CrateId

		if not v1188 then
			return
		end

		task.spawn(function()
			local v1290 = v1188

			local v1291, v1292, v1293 = pcall(function()
				return inventory:InvokeServer("GetCaseView", { CrateId = v1290 })
			end)

			local v1294 = if v1291 and v1292 == true and typeof(v1293) == "table" and typeof(v1293.Owned) == "number" then v1293.Owned else nil

			if CrateId ~= v1188 then
				return
			end

			u712 = v1294
			refreshRow()
		end)
	end)
	multiBuyContainer:GetPropertyChangedSignal("Visible"):Connect(function()
		if not multiBuyContainer.Visible then
			task.defer(refreshRow)
		end
	end)

	local function notifyFail(p106)
		_G.Notify({ notifType = "FailNotification", errorMessage = p106 })
	end
	local function publicCrate(p107)
		for _, v in ipairs(u74 or {}) do
			if p107 == v.CrateId then
				return v
			end
		end

		return nil
	end
	local function shopSlotFor(p108)
		for k, v in pairs(t17) do
			if v == p108 then
				return k
			end
		end

		return nil
	end
	local function runOpen(p109, p110)
		local v1198, v1199, v1200 = pcall(function()
			return inventory:InvokeServer("GetCaseView", { CrateId = p109 })
		end)

		local v1201 = if v1198 and v1199 == true and typeof(v1200) == "table" and typeof(v1200.Owned) == "number" then v1200.Owned else nil

		if v1201 == nil then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = t2.NotReady or "NotReady"
			})

			return
		end

		u712 = v1201

		if v1201 < 1 then
			return
		end

		local count = math.min(p110, v1201, 10)
		local v1203, v1204, v1205 = ipairs(u74 or {})
		local v1206: boolean = false
		local v1207

		for iterFirst, iterSecond in v1203, v1204, v1205 do
			if p109 == iterSecond.CrateId then
				v1207 = iterSecond
				v1206 = true

				break
			end
		end

		if not v1206 then
			v1207 = nil
		end

		local function openFailed(p111)
			if p111 == "InventoryFull" then
				return
			end

			local v1296 = p111 or "OpenFailed"

			_G.Notify({
				notifType = "FailNotification",
				errorMessage = t32[p111 or ""] or t2[v1296] or v1296
			})
		end

		if count ~= 1 then
			local v1211, v1212, v1213, v1214 = pcall(function()
				return inventory:InvokeServer("OpenCrateMulti", { Source = "Shop", CrateId = p109, Count = count })
			end)

			if v1211 and v1212 == true then
				u1215 = typeof
				u1215 = u1215(v1214)

				if u1215 == "table" then
					u1215 = #v1214
				end

				if u1215 == "table" and u1215 ~= 0 then
					u1215 = math.max
					u1215 = u1215(0, v1201 - #v1214)
					u712 = u1215
					sound:Play("Misc.RollOpening", workspace)

					local t47: {[any]: any} = {
						CrateId = p109,
						CrateName = v1207 and v1207.Name or p109,
						RarityOdds = v1207 and v1207.RarityOdds or {},
						PublicPools = v1207 and v1207.PublicPools or {},
						Rewards = v1214
					}
					local v1217, v1218, v1219 = pairs(t17)
					local v1220: boolean = false
					local v1221

					for iterFirst2, iterSecond2 in v1217, v1218, v1219 do
						if iterSecond2 == p109 then
							v1221 = iterFirst2
							v1220 = true

							break
						end
					end

					if not v1220 then
						v1221 = nil
					end

					t47.ReturnToShopSlot = v1221
					t47.Count = count

					function t47.GetRemaining()
						return u1215
					end
					function t47.RequestMore(p112)
						local v1298, v1299, v1300 = inventory:InvokeServer("OpenCrateMulti", { Source = "Shop", CrateId = p109, Count = p112 })

						if v1298 == true and typeof(v1300) == "table" then
							u1215 = math.max(0, u1215 - #v1300)
						end

						return v1298, v1299, v1300
					end
					function t47.ErrorText(p113)
						local v1302 = p113 or "OpenFailed"

						return t32[p113 or ""] or t2[v1302] or v1302
					end

					openCrateMulti:Fire(t47)
					windowBlur.hide("LobbyPanel")
					shopWindow.Visible = false

					return
				end
			end

			u1215 = if v1211 then v1213 else nil

			if u1215 == "InventoryFull" then
				return
			end

			local v1224 = u1215 or "OpenFailed"

			_G.Notify({
				notifType = "FailNotification",
				errorMessage = t32[u1215 or ""] or t2[v1224] or v1224
			})

			return
		end

		local v1225, v1226, v1227, v1228 = pcall(function()
			return inventory:InvokeServer("OpenCrate", { Source = "Shop", CrateId = p109 })
		end)

		if not v1225 or v1226 ~= true or typeof(v1228) ~= "table" then
			local v1229 = if v1225 then v1227 else nil

			if v1229 == "InventoryFull" then
				return
			end

			local v1230 = v1229 or "OpenFailed"

			_G.Notify({
				notifType = "FailNotification",
				errorMessage = t32[v1229 or ""] or t2[v1230] or v1230
			})

			return
		end

		local u1215 = math.max(0, v1201 - 1)

		u712 = u1215
		sound:Play("Misc.RollOpening", workspace)
		openCrate:Fire({
			CrateId = p109,
			CrateName = v1207 and v1207.Name or p109,
			RarityOdds = v1207 and v1207.RarityOdds or {},
			PublicPools = v1207 and v1207.PublicPools or {},
			Reward = v1228,
			GetRemaining = function()
				return u1215
			end,
			RequestRoll = function()
				local v1303, v1304, v1305 = inventory:InvokeServer("OpenCrate", { Source = "Shop", CrateId = p109 })

				if v1303 == true then
					u1215 = math.max(0, u1215 - 1)
				end

				return v1303, v1304, v1305
			end
		})
		windowBlur.hide("LobbyPanel")
		shopWindow.Visible = false
	end

	openButton.MouseButton1Click:Connect(function()
		if not not u717 or not not u189 or not u716 then
			return
		end

		local v1231 = CrateId

		if v1231 and LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") == false and not spinner.Enabled and not (math.min(u712 or 0, 10) < 1) then
			u717 = true

			local ok, result = pcall(runOpen, v1231, n2)

			u717 = false

			if not ok then
				warn("[ShopController] shop open failed:", result)
			end

			refreshRow()

			return
		end
	end)
	multiBuyContainer:GetAttributeChangedSignal("OpenCount"):Connect(function()
		local openCount: any = multiBuyContainer:GetAttribute("OpenCount")

		if typeof(openCount) == "number" then
			if CrateId then
				t33[CrateId] = openCount
			end

			if openCount ~= n2 then
				n2 = openCount
				refreshRow()
			end
		end
	end)
	openCountButton.MouseButton1Click:Connect(function()
		if not not u717 or not not u189 or not u716 then
			return
		end

		local v1235 = math.min(u712 or 0, 10)

		if v1235 < 2 then
			return
		end

		multiBuyContainer:SetAttribute("OpenOwned", u712 or 0)
		multiBuyContainer:SetAttribute("OpenCount", (if CrateId then t33[CrateId] else nil) or n2)
		multiBuyContainer:SetAttribute("OpenMax", v1235)
		openMultiBuy()

		if not multiBuyContainer.Visible then
			multiBuyContainer:SetAttribute("OpenMax", nil)
		end
	end)
end)()
task.spawn(function()
	local shopPromptPart: Instance = workspace:WaitForChild("Lobby"):WaitForChild("ShopPromptPart", 15)

	if not shopPromptPart then
		return
	end

	local shopPrompt: Instance = shopPromptPart:WaitForChild("ShopPrompt", 5)

	if not shopPrompt or not shopPrompt:IsA("ProximityPrompt") then
		return
	end

	shopPrompt.Triggered:Connect(function(p114)
		if p114 ~= LocalPlayer then
			return
		end

		bindables.OpenShop:Fire("Cases")
		shopOpenAnalytics:FireServer("ShopPrompt")
	end)
end)
game:GetService("GroupService")
tokenGapBottom = giftCodes:FindFirstChild("CodeBar")

local textBox = tokenGapBottom and tokenGapBottom:FindFirstChild("TextBox")
local redeemButton: Instance = giftCodes:FindFirstChild("RedeemButton")
local u211: boolean = false
local u212 = false

local function setRedeemButtonText(text)
	if not redeemButton then
		return
	end

	local textLabel45: Instance = redeemButton:FindFirstChild("TextLabel")

	if textLabel45 and textLabel45:IsA("TextLabel") then
		textLabel45.Text = text

		local textLabel46: Instance = textLabel45:FindFirstChild("TextLabel")

		if textLabel46 and textLabel46:IsA("TextLabel") then
			textLabel46.Text = text
		end
	end
end

if redeemButton and textBox then
	task.spawn(function()
		local ok, result = pcall(function()
			return LocalPlayer:IsInGroupAsync(43252617)
		end)

		if ok then
			u212 = result
		end

		if u212 then
			if not redeemButton then
				return
			end

			local textLabel47: Instance = redeemButton:FindFirstChild("TextLabel")

			if textLabel47 and textLabel47:IsA("TextLabel") then
				textLabel47.Text = "Redeem"

				local textLabel48: Instance = textLabel47:FindFirstChild("TextLabel")

				if textLabel48 and textLabel48:IsA("TextLabel") then
					textLabel48.Text = "Redeem"

					return
				end
			end
		else
			if not redeemButton then
				return
			end

			local textLabel49: Instance = redeemButton:FindFirstChild("TextLabel")

			if textLabel49 and textLabel49:IsA("TextLabel") then
				textLabel49.Text = "Join"

				local textLabel50: Instance = textLabel49:FindFirstChild("TextLabel")

				if textLabel50 and textLabel50:IsA("TextLabel") then
					textLabel50.Text = "Join"
				end
			end
		end
	end)

	local function doRedeem()
		if u211 then
			return
		end

		if not u212 then
			u211 = true
			task.spawn(function()
				hud.LikeGameIndicator.Visible = true
				hud.BlackBackground2.Visible = true

				local ok, result = pcall(function()
					game:GetService("GroupService"):PromptJoinAsync(43252617)
				end)

				hud.BlackBackground2.Visible = false

				if not ok then
					warn(result)
				end

				for _ = 1, 3 do
					task.wait(1)

					local u1240 = false

					local ok2, result2 = pcall(function()
						return LocalPlayer:IsInGroupAsync(43252617)
					end)

					if ok2 then
						u1240 = result2
					end

					if u1240 then
						if redeemButton then
							local textLabel51: Instance = redeemButton:FindFirstChild("TextLabel")

							if textLabel51 and textLabel51:IsA("TextLabel") then
								textLabel51.Text = "Like Game"

								local textLabel52: Instance = textLabel51:FindFirstChild("TextLabel")

								if textLabel52 and textLabel52:IsA("TextLabel") then
									textLabel52.Text = "Like Game"
								end
							end
						end

						task.wait(6)
						u212 = true

						if not redeemButton then
							break
						end

						local textLabel53: Instance = redeemButton:FindFirstChild("TextLabel")

						if not textLabel53 or not textLabel53:IsA("TextLabel") then
							break
						end

						textLabel53.Text = "Redeem"

						local textLabel54: Instance = textLabel53:FindFirstChild("TextLabel")

						if not textLabel54 or not textLabel54:IsA("TextLabel") then
							break
						end

						textLabel54.Text = "Redeem"

						break
					end
				end

				u211 = false
				hud.LikeGameIndicator.Visible = false
			end)

			return
		end

		if (LocalPlayer:GetAttribute("Level") or 1) < 5 then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = "You must be level 5 to redeem codes!"
			})

			return
		end

		local textBoxText = textBox.Text

		if textBoxText == "" then
			return
		end

		u211 = true
		task.spawn(function()
			local ok, result = pcall(function()
				return redeemCode:InvokeServer(textBoxText)
			end)

			if not ok or typeof(result) ~= "table" then
				_G.Notify({
					notifType = "FailNotification",
					errorMessage = "Failed to redeem code."
				})
			elseif result.ok then
				textBox.Text = ""
				_G.Notify({ notifType = "SuccessNotification", topText = "Code Redeemed!" })
			else
				local _GNotify = _G.Notify
				local text: string = tostring(result.err)

				_GNotify({ notifType = "FailNotification", errorMessage = text })
			end

			u211 = false
		end)
	end

	redeemButton.MouseButton1Click:Connect(doRedeem)
	textBox.FocusLost:Connect(function(p116)
		if p116 then
			doRedeem()
		end
	end)
end

giftPicker.Close()
casePurchase5b3.Visible = false
content.Visible = true
task.spawn(function()
	local u777 = nil

	local ok, result = pcall(function()
		u777 = { inventory:InvokeServer("GetCrateCatalog") }
	end)

	warn("[ShopController] Crate catalog fetch failed:", result)
	populateCases()
end)

for _, v in ipairs(scrollingFrame:GetChildren()) do
	if v:IsA("GuiObject") then
		local foundChild: Instance = scrollingFrame:FindFirstChild(v.Name .. "Gap")

		if foundChild and foundChild:IsA("GuiObject") then
			foundChild.Visible = v.Visible
			v:GetPropertyChangedSignal("Visible"):Connect(function()
				foundChild.Visible = v.Visible
			end)
		end
	end
end

local t18: {[any]: any} = {}

for _, v in pairs(scrollingFrame:GetDescendants()) do
	if v:IsA("VideoFrame") and v.Parent and v.Parent:IsA("GuiObject") then
		local videoId = v:GetAttribute("VideoId")

		if typeof(videoId) == "string" and videoId ~= "" and videoId ~= v.Video then
			v.Video = videoId
		end

		table.insert(t18, { card = v.Parent, video = v })
	end
end

local function isEffectivelyVisible(p117)
	local v781 = p117

	while v781 and v781 ~= scrollingFrame do
		if v781:IsA("GuiObject") and not v781.Visible then
			return false
		end

		v781 = v781.Parent
	end

	return v781 == scrollingFrame
end
local function visibleFraction(p118)
	if not isEffectivelyVisible(p118) then
		return 0
	end

	local scrollingFrameAbsolutePosition = scrollingFrame.AbsolutePosition
	local scrollingFrameAbsoluteSize = scrollingFrame.AbsoluteSize
	local absolutePosition = p118.AbsolutePosition
	local absoluteSize = p118.AbsoluteSize
	local v787 = math.min(scrollingFrameAbsolutePosition.X + scrollingFrameAbsoluteSize.X, absolutePosition.X + absoluteSize.X)
	local v788 = math.max(scrollingFrameAbsolutePosition.X, absolutePosition.X)
	local n1 = v787 - v788

	v788 = math.min(scrollingFrameAbsolutePosition.Y + scrollingFrameAbsoluteSize.Y, absolutePosition.Y + absoluteSize.Y)

	local v790 = math.max(scrollingFrameAbsolutePosition.Y, absolutePosition.Y)

	v787 = v788 - v790

	if n1 <= 0 or v787 <= 0 then
		return 0
	end

	local n2 = absoluteSize.X * absoluteSize.Y

	if n2 <= 0 then
		return 0
	end

	return n1 * v787 / n2
end

tokenGapBottom = function()
	if not shopWindow.Visible then
		for key, value in t18 do
			value.video.Playing = false
			value.video.Parent = nil
		end

		return
	end

	if #t18 <= 2 then
		for key2, value2 in t18 do
			value2.video.Parent = value2.card
			value2.video.Playing = true
		end

		return
	end

	local t39: {[any]: any} = {}

	for key3, value3 in t18 do
		local v799 = visibleFraction(value3.card)

		table.insert(t39, { entry = value3, area = v799 })
	end

	table.sort(t39, function(p119, p120)
		if p119.area ~= p120.area then
			return p119.area > p120.area
		end

		return p119.entry.card.LayoutOrder < p120.entry.card.LayoutOrder
	end)

	for i, v in ipairs(t39) do
		local video = v.entry.video

		if v.area <= 0 then
			video.Playing = false
		else
			video.Parent = v.entry.card
			video.Playing = i <= 2
		end
	end
end
shopWindow:GetPropertyChangedSignal("Visible"):Connect(tokenGapBottom)
scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(tokenGapBottom)
scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(tokenGapBottom)

for key, value in t18 do
	local v226 = value.card

	while v226 and v226 ~= scrollingFrame do
		if v226:IsA("GuiObject") then
			v226:GetPropertyChangedSignal("Visible"):Connect(tokenGapBottom)
		end

		v226 = v226.Parent
	end
end

tokenGapBottom()

local function resetToTopCategory()
	if casePurchase5b3.Visible then
		casePurchase5b3.Visible = false
		content.Visible = true
		hoverInfoModule.hide(v78)
		CrateId = nil
	end

	scrollingFrame.CanvasPosition = Vector2.new(0, 0)
	setActiveNavByName("Featured")
end

shopWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if not shopWindow.Visible then
		return
	end

	if u79 then
		u79 = false

		return
	end

	if casePurchase5b3.Visible then
		casePurchase5b3.Visible = false
		content.Visible = true
		hoverInfoModule.hide(v78)
		CrateId = nil
	end

	scrollingFrame.CanvasPosition = Vector2.new(0, 0)
	setActiveNavByName("Featured")
end)
