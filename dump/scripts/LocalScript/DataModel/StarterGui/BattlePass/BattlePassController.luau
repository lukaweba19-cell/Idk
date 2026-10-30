-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer: Player = players.LocalPlayer

players = replicatedStorage:WaitForChild("Shared")

local windowBlur = require(players:WaitForChild("WindowBlur"))
local eventTimer = require(players:WaitForChild("EventTimer"))
local shineEffect = require(players:WaitForChild("ShineEffect"))
local seasonPassConfig = require(players:WaitForChild("SeasonPassConfig"))
local v11: Instance = replicatedStorage:WaitForChild("Catalogs")
local seasonPassCatalog = require(v11:WaitForChild("SeasonPassCatalog"))
local rarity = require(players:WaitForChild("Rarity"))
local seasonPassGate = require(players:WaitForChild("SeasonPassGate"))
local hoverInfoModule = require(players:WaitForChild("HoverInfoModule"))

v11 = replicatedStorage:WaitForChild("Bindables")

local activeWindowChanged: Instance = v11:WaitForChild("ActiveWindowChanged")
local showPurchaseModal: Instance = v11:WaitForChild("ShowPurchaseModal")
local seasonPass: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("SeasonPass")
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))

players = replicatedStorage:WaitForChild("UIFramework")

local giftPicker = require(players:WaitForChild("GiftPicker"))
local itemCells: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Assets"):WaitForChild("ItemCells")
local alert: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("Misc"):WaitForChild("Alert")
local seasonPassConfigTierCount = seasonPassConfig.TierCount
local scriptParent: Instance = script.Parent

scriptParent.DisplayOrder = 9

local panel: Instance = scriptParent:WaitForChild("Panel")
local closeButton: Instance = panel:WaitForChild("CloseButton")
local content: Instance = panel:WaitForChild("Content")
local canvas: Instance = content:WaitForChild("Track"):WaitForChild("Canvas")

players = content:WaitForChild("ProgressBar")

local fill = players:WaitForChild("Fill")
local levelLabel = players:WaitForChild("LevelLabel")
local xpLabel = players:WaitForChild("XpLabel")
local skipButton: Instance = content:WaitForChild("SkipButton")
local trackLine: Instance = canvas:WaitForChild("TrackLine")
local doneSegment: Instance = trackLine:WaitForChild("DoneSegment")

local t1: {[any]: any} = {
	tileName = function(p1, p2)
		if p2 == seasonPassConfigTierCount and canvas:FindFirstChild(p1 .. "Choose") then
			return p1 .. "Choose"
		end

		return p1 .. p2
	end
}

players = canvas:FindFirstChild("CurrentProgressBox")

local v36 = if players and players:IsA("Frame") then players else nil
local premiumBar: Instance = panel:WaitForChild("PremiumBar")
local buyButton: Instance = premiumBar:WaitForChild("BuyButton")
local giftButton: Instance = premiumBar:WaitForChild("GiftButton")

function t1.findArt()
	for _, v in ipairs(buyButton:GetChildren()) do
		if v:IsA("TextLabel") and v:FindFirstChildOfClass("Frame") then
			v.Name = "WasPrice"
			t1.WasPrice = v

			break
		end
	end

	for _, v in ipairs(buyButton:GetChildren()) do
		if v:IsA("TextLabel") and v.Name ~= "WasPrice" then
			t1.PriceLabel = v
			t1.PriceHome = { Position = v.Position, Size = v.Size }

			break
		end
	end

	local rarity2: Instance = premiumBar:FindFirstChild("Rarity")

	if rarity2 and rarity2:IsA("TextLabel") then
		t1.Caption = rarity2
		t1.CaptionSell = rarity2.Text
	end

	t1.CaptionOwned = "You own the <b>VIP track</b>. Gift it to a friend!"

	local vipLocked: Instance = content:FindFirstChild("VIPLocked")

	t1.VIPLocked = if vipLocked and vipLocked:IsA("GuiObject") then vipLocked else nil
	t1.PerTileLock = t1.VIPLocked == nil

	local textLabel: Instance = content:FindFirstChild("TextLabel")

	t1.Season = if textLabel and textLabel:IsA("TextLabel") then textLabel else nil
end

t1.findArt()

local premiumTrackIcon: Instance = content:WaitForChild("PremiumTrackIcon")
local icon: Instance = premiumTrackIcon:WaitForChild("Icon")

players = premiumTrackIcon:FindFirstChild("UnlockNow")

local parent = if players and players:IsA("GuiObject") then players else nil

if parent then
	parent.Active = false
end

local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u44 = nil

if parent then
	local uiScale = parent:FindFirstChildOfClass("UIScale")

	if uiScale then
		u44 = uiScale
	else
		local uiScale2: UIScale = Instance.new("UIScale")

		uiScale2.Parent = parent
		u44 = uiScale2
	end
end

local u47: boolean = false
local u48: boolean = false
local u49 = nil

local function applyUnlockFeel(p3)
	local v186 = u44

	if not v186 then
		return
	end

	if u49 then
		u49:Cancel()
		u49 = nil
	end

	local n1: number = 1

	if u48 then
		n1 = 0.94
	elseif u47 then
		n1 = 1.06
	end

	if p3 then
		v186.Scale = n1

		return
	end

	local v188: Tween = tweenService:Create(v186, tweenInfo, { Scale = n1 })

	u49 = v188
	v188:Play()
end

local timerTextLabel: Instance = panel:WaitForChild("Timer"):WaitForChild("TextLabel")
local textLabel: Instance = timerTextLabel:FindFirstChildOfClass("TextLabel")

players = content:FindFirstChild("Track_WIDE_BACKUP")

if players and players:IsA("GuiObject") then
	players.Visible = false
end

local v53 = hoverInfoModule.create(panel)

local function resolveNameLabels(p4)
	local itemName = p4:FindFirstChild("ItemName")

	if not itemName or not itemName:IsA("TextLabel") then
		local itemNameRealText = p4:FindFirstChild("ItemNameRealText")

		if itemNameRealText and itemNameRealText:IsA("TextLabel") then
			return itemNameRealText, nil
		end

		return nil, nil
	end

	local itemNameRealText = itemName:FindFirstChild("ItemNameRealText")

	if itemNameRealText and itemNameRealText:IsA("TextLabel") then
		return itemNameRealText, itemName
	end

	return itemName, nil
end

local t2: {[any]: any} = {
	Free = {},
	Premium = {}
}

t1.choiceTiles = {}

local t3: {[any]: any} = {
	Tier = 0,
	XP = 0,
	Premium = false,
	XpIntoTier = 0,
	XpForTier = 0,
	SeasonId = seasonPassConfig.CurrentSeasonId,
	Claimed = {},
	ClaimedPremium = {},
	Chosen = {},
	Challenges = {}
}
local u57: boolean = false
local u58: boolean = false
local free1: Instance = canvas:FindFirstChild("Free1")

local function ensureChild(parent, p6)
	if parent:FindFirstChild(p6) then
		return
	end

	if not free1 then
		return
	end

	local foundChild: Instance = free1:FindFirstChild(p6)

	if not foundChild then
		return
	end

	local clone: Instance = foundChild:Clone()

	clone.Parent = parent

	if clone:IsA("GuiObject") then
		clone.Visible = false
	end
end

players = canvas:FindFirstChild("Premium1")

local u61 = nil

replicatedStorage = players and players:FindFirstChild("LockedOverlay")
players = replicatedStorage and replicatedStorage:FindFirstChildOfClass("ImageLabel")

if players then
	u61 = players
end

local u62 = nil

local function wantsHouseStyle(_, _)
	return false
end
local function applyHouseStyle(parent)
	local v200 = u62

	if not v200 then
		return
	end

	if v200.Gradient then
		local uiGradient = parent:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient:Destroy()
		end

		local clone = v200.Gradient:Clone()

		clone.Parent = parent
	end

	if #v200.Strokes > 0 then
		for _, v in ipairs(parent:GetChildren()) do
			if v:IsA("UIStroke") then
				v:Destroy()
			end
		end

		for _, v in ipairs(v200.Strokes) do
			local clone = v:Clone()

			clone.Parent = parent
		end
	end

	local spikes = parent:FindFirstChild("Spikes")

	if spikes and spikes:IsA("ImageLabel") then
		if v200.SpikesColour then
			spikes.ImageColor3 = v200.SpikesColour
		end

		if v200.SpikesTransparency then
			spikes.ImageTransparency = v200.SpikesTransparency
		end
	end
end
local function ensureLockIcon(p10)
	local lockedOverlay = p10:FindFirstChild("LockedOverlay")

	if not lockedOverlay or not lockedOverlay:IsA("Frame") then
		return
	end

	if lockedOverlay:FindFirstChildOfClass("ImageLabel") then
		return
	end

	local v211 = u61

	if not v211 then
		return
	end

	local clone = v211:Clone()

	clone.Parent = lockedOverlay
end
local function ensureButton(parent)
	local claimHit = parent:FindFirstChild("ClaimHit")

	if claimHit and claimHit:IsA("ImageButton") then
		return claimHit
	end

	local claimHit: ImageButton = Instance.new("ImageButton")

	claimHit.Name = "ClaimHit"
	claimHit.BackgroundTransparency = 1
	claimHit.ImageTransparency = 1
	claimHit.Size = UDim2.fromScale(1, 1)
	claimHit.Position = UDim2.fromScale(0, 0)
	claimHit.ZIndex = 50
	claimHit.AutoButtonColor = false
	claimHit.Parent = parent

	return claimHit
end

local color3 = Color3.fromRGB(255, 214, 92)
local v68 = UDim2.fromScale(0.92, 0.26)
local v69 = UDim2.fromScale(0.5, 0.55)
local vector2 = Vector2.new(0.5, 0.5)

players = ColorSequence.new
replicatedStorage = Color3.fromRGB(201, 255, 144)

local v71 = players(replicatedStorage, Color3.fromRGB(45, 161, 0))

replicatedStorage = ColorSequence.new
players = Color3.fromRGB(205, 205, 205)

local v72 = replicatedStorage(players, Color3.fromRGB(150, 150, 150))
local color32 = Color3.fromRGB(9, 66, 0)
local color33 = Color3.fromRGB(255, 255, 255)
local color34 = Color3.fromRGB(0, 0, 0)
local color35 = Color3.fromRGB(70, 255, 40)
local v77 = UDim2.fromScale(0.5, 0.55)

local function normaliseTileLayers(p12)
	local v217, v218 = resolveNameLabels(p12)

	if v217 then
		v217.ZIndex = 6
	end

	if v218 then
		v218.ZIndex = 6
	end

	local doneWash = p12:FindFirstChild("DoneWash")

	if doneWash and doneWash:IsA("Frame") then
		doneWash.BackgroundColor3 = color34
		doneWash.BackgroundTransparency = 0.45
		doneWash.ZIndex = 5

		local uiGradient = doneWash:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient:Destroy()
		end
	end

	local doneCheck = p12:FindFirstChild("DoneCheck")

	if doneCheck and doneCheck:IsA("ImageLabel") then
		doneCheck.ZIndex = 8
	end

	local doneGlow = p12:FindFirstChild("DoneGlow")

	if doneGlow and doneGlow:IsA("ImageLabel") then
		doneGlow.ImageColor3 = color35
		doneGlow.ImageTransparency = 0.45
		doneGlow.Size = UDim2.fromScale(0.9, 0.9)
		doneGlow.AnchorPoint = Vector2.new(0.5, 0.5)
		doneGlow.Position = v77
		doneGlow.ZIndex = 7
	end
end

local u79 = nil

local function ensureClaimDot(_)
	return nil
end
local function ensureClaimGlow(parent)
	local claimGlow = parent:FindFirstChild("ClaimGlow")

	if claimGlow and claimGlow:IsA("ImageLabel") then
		return claimGlow
	end

	local v226 = parent:FindFirstChild("DoneGlow") or parent:FindFirstChild("RarityGlow")

	if not v226 or not v226:IsA("ImageLabel") then
		return nil
	end

	local clone = v226:Clone()

	clone.Name = "ClaimGlow"
	clone.ImageColor3 = color3
	clone.Size = UDim2.fromScale(1.3, 1.3)
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.ImageTransparency = 0.72
	clone.ZIndex = 2
	clone.Visible = false
	clone.Parent = parent

	return clone
end
local function ensureClaimPill(parent)
	local claimPill = parent:FindFirstChild("ClaimPill")

	if claimPill and claimPill:IsA("TextButton") then
		return claimPill
	end

	local clone: Instance = skipButton:Clone()

	clone.Name = "ClaimPill"
	clone.AnchorPoint = vector2
	clone.Position = v69
	clone.Size = v68
	clone.ZIndex = 9
	clone.Active = false
	clone.Interactable = false
	clone.Selectable = false
	clone.AutoButtonColor = false
	clone.TextTransparency = 1
	clone.Visible = false
	clone.Parent = parent

	return clone
end
local function ensureClaimScrim(parent)
	local claimScrim = parent:FindFirstChild("ClaimScrim")

	if claimScrim and claimScrim:IsA("Frame") then
		return claimScrim
	end

	local doneWash = parent:FindFirstChild("DoneWash")
	local clone

	if doneWash and doneWash:IsA("Frame") then
		clone = doneWash:Clone()
	else
		clone = Instance.new("Frame")
		clone.BorderSizePixel = 0
		clone.Size = UDim2.fromScale(1, 1)

		local uiCorner = parent:FindFirstChildOfClass("UICorner")

		if uiCorner then
			local clone2 = uiCorner:Clone()

			clone2.Parent = clone
		end
	end

	clone.Name = "ClaimScrim"
	clone.BackgroundColor3 = color34
	clone.BackgroundTransparency = 0.5
	clone.ZIndex = 5
	clone.Visible = false
	clone.Parent = parent

	return clone
end
local function findOutlineGradient(p17)
	for _, v in ipairs(p17:GetChildren()) do
		if v:IsA("UIStroke") then
			local uiGradient = v:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				return uiGradient
			end
		end
	end

	return nil
end
local function adoptRarityStrokes(parent)
	local v242 = nil

	for _, v in ipairs(canvas:GetChildren()) do
		if v ~= parent and v:IsA("Frame") and string.match(v.Name, "^Free%d+$") and findOutlineGradient(v) then
			v242 = v

			break
		end
	end

	if not v242 then
		return
	end

	for _, v in ipairs(parent:GetChildren()) do
		if v:IsA("UIStroke") then
			v:Destroy()
		end
	end

	for _, v in ipairs(v242:GetChildren()) do
		if v:IsA("UIStroke") then
			local clone = v:Clone()

			clone.Parent = parent
		end
	end

	local uiGradient = parent:FindFirstChildOfClass("UIGradient")
	local uiGradient2 = v242:FindFirstChildOfClass("UIGradient")

	if uiGradient and uiGradient2 then
		uiGradient.Rotation = uiGradient2.Rotation
	end
end

players = function(p19, p20)
	local foundChild: Instance = canvas:FindFirstChild(p19 .. p20)

	if not foundChild or not foundChild:IsA("Frame") then
		return nil
	end

	if not foundChild:FindFirstChild("DoneWash") and free1 then
		local doneWash: Instance = free1:FindFirstChild("DoneWash")

		if doneWash then
			local clone: Instance = doneWash:Clone()

			clone.Parent = foundChild

			if clone:IsA("GuiObject") then
				clone.Visible = false
			end
		end
	end

	if not foundChild:FindFirstChild("DoneCheck") and free1 then
		local doneCheck: Instance = free1:FindFirstChild("DoneCheck")

		if doneCheck then
			local clone: Instance = doneCheck:Clone()

			clone.Parent = foundChild

			if clone:IsA("GuiObject") then
				clone.Visible = false
			end
		end
	end

	if not foundChild:FindFirstChild("DoneGlow") and free1 then
		local doneGlow: Instance = free1:FindFirstChild("DoneGlow")

		if doneGlow then
			local clone: Instance = doneGlow:Clone()

			clone.Parent = foundChild

			if clone:IsA("GuiObject") then
				clone.Visible = false
			end
		end
	end

	if not foundChild:FindFirstChild("ClaimedCheck") and free1 then
		local claimedCheck: Instance = free1:FindFirstChild("ClaimedCheck")

		if claimedCheck then
			local clone: Instance = claimedCheck:Clone()

			clone.Parent = foundChild

			if clone:IsA("GuiObject") then
				clone.Visible = false
			end
		end
	end

	local lockedOverlay: Instance = foundChild:FindFirstChild("LockedOverlay")

	if lockedOverlay and lockedOverlay:IsA("Frame") and not lockedOverlay:FindFirstChildOfClass("ImageLabel") then
		local v264 = u61

		if v264 then
			local clone = v264:Clone()

			clone.Parent = lockedOverlay
		end
	end

	normaliseTileLayers(foundChild)

	if not findOutlineGradient(foundChild) then
		adoptRarityStrokes(foundChild)
	end

	local icon: Instance = foundChild:FindFirstChild("Icon")

	if icon and icon:IsA("GuiObject") then
		icon.Size = UDim2.fromScale(1.15, 1.15)
	end

	local v267, v268 = resolveNameLabels(foundChild)
	local v269 = ensureClaimGlow(foundChild)
	local v270 = ensureClaimScrim(foundChild)
	local v271 = ensureClaimPill(foundChild)
	local uiGradient: Instance = foundChild:FindFirstChildOfClass("UIGradient")
	local v273 = findOutlineGradient(foundChild)
	local spikes: Instance = foundChild:FindFirstChild("Spikes")
	local icon2: Instance = foundChild:FindFirstChild("Icon")
	local rarityGlow: Instance = foundChild:FindFirstChild("RarityGlow")
	local doneWash: Instance = foundChild:FindFirstChild("DoneWash")

	return {
		HoverName = nil,
		HoverRarity = nil,
		Frame = foundChild,
		Gradient = uiGradient,
		OutlineGradient = v273,
		Spikes = spikes,
		Icon = icon2,
		ItemName = v267,
		ItemNamePlate = v268,
		RarityGlow = rarityGlow,
		DoneWash = doneWash,
		DoneCheck = foundChild:FindFirstChild("DoneCheck") or foundChild:FindFirstChild("ClaimedCheck"),
		DoneGlow = foundChild:FindFirstChild("DoneGlow"),
		LockedOverlay = foundChild:FindFirstChild("LockedOverlay"),
		ClaimDot = nil,
		ClaimGlow = v269,
		ClaimPill = v271,
		ClaimScrim = v270,
		Button = ensureButton(foundChild),
		HouseStyled = false
	}
end

local function setVisible(p21, visible)
	if p21 and p21:IsA("GuiObject") then
		p21.Visible = visible
	end
end
local function setTileCaption(p23, _)
	if p23.ItemName then
		p23.ItemName.Text = ""
		p23.ItemName.Visible = false
	end

	if p23.ItemNamePlate then
		p23.ItemNamePlate.Text = ""
	end
end

local t4: {[any]: any} = { Free = "Common", Premium = "Legendary" }

local function rarityGradient(p25)
	local colorSequenceNew = ColorSequence.new
	local color36 = Color3.new(p25.R * 0.17392, p25.G * 0.17392, p25.B * 0.17392)

	return colorSequenceNew(color36, p25)
end

local t5: {[any]: any} = { Legendary = 0.1 }

local function rehue(p26, p27)
	if not p27 then
		return p26
	end

	local v287, v288, v289 = p26:ToHSV()

	return Color3.fromHSV(p27, v288, v289)
end
local function cardColour(p28)
	local v291 = rarity.GetColor(p28)

	return rehue(v291, t5[p28])
end

local t6: {[any]: any} = {}

local function shopRarityLook(p29)
	local v293 = t6[p29]

	if v293 then
		return v293
	end

	local foundChild: Instance = itemCells:FindFirstChild(p29 .. "Cell")

	if not foundChild then
		local v295 = ("[BattlePassController] No %sCell in UIFramework.Assets.ItemCells; "):format(p29)

		warn(v295 .. "falling back to CommonCell for the tile outline.")
		foundChild = itemCells:FindFirstChild("CommonCell")
	end

	local t10: {[any]: any} = {}

	if foundChild then
		for _, v in ipairs(foundChild:GetChildren()) do
			if v:IsA("UIStroke") then
				local uiGradient = v:FindFirstChildOfClass("UIGradient")

				if uiGradient then
					t10.outline = uiGradient.Color
				end
			elseif v:IsA("ImageLabel") and v.Name == "Spikes" then
				t10.spikes = v.ImageColor3
			end
		end
	end

	t6[p29] = t10

	return t10
end
local function paintCardLook(p30, p31, p32, p33)
	local v304 = t5[p33]

	if p30 then
		local v305 = rarity.GetColor(p33)
		local v306 = t5[p33]
		local color37

		if not v306 then
			color37 = v305
		else
			local v308, v309, v310 = v305:ToHSV()

			color37 = Color3.fromHSV(v306, v309, v310)
		end

		local colorSequenceNew = ColorSequence.new
		local color38 = Color3.new(color37.R * 0.17392, color37.G * 0.17392, color37.B * 0.17392)

		p30.Color = colorSequenceNew(color38, color37)
	end

	local v313 = shopRarityLook(p33)

	if p31 and v313.outline then
		if v304 then
			local t11: {[any]: any} = {}

			for _, v in ipairs(v313.outline.Keypoints) do
				table.insert(t11, ColorSequenceKeypoint.new(v.Time, rehue(v.Value, v304)))
			end

			p31.Color = ColorSequence.new(t11)
		else
			p31.Color = v313.outline
		end
	end

	if p32 and v313.spikes then
		local spikes = v313.spikes
		local color39

		if not v304 then
			color39 = spikes
		else
			local v319, v320, v321 = spikes:ToHSV()

			color39 = Color3.fromHSV(v304, v320, v321)
		end

		p32.ImageColor3 = color39
	end
end
local function setAmountBadge(p34, p35)
	local amount = p35 and p35.Amount
	local u325: boolean = false

	if typeof(amount) == "number" then
		u325 = true

		if p35.Type ~= "WheelTickets" then
			u325 = false

			if p35.Type == "Crate" then
				u325 = amount > 1
			end
		end
	end

	local amountBadge = p34.Frame:FindFirstChild("AmountBadge")

	if not u325 then
		if amountBadge and amountBadge:IsA("GuiObject") then
			amountBadge.Visible = false
		end

		return
	end

	local clone

	if amountBadge and amountBadge:IsA("TextLabel") then
		clone = amountBadge
	else
		local itemName = p34.ItemName

		if not itemName then
			return
		end

		clone = itemName:Clone()
		clone.Name = "AmountBadge"
		clone.AnchorPoint = Vector2.new(1, 1)
		clone.Position = UDim2.fromScale(0.97, 0.98)
		clone.Size = UDim2.fromScale(0.8, 0.34)
		clone.TextXAlignment = Enum.TextXAlignment.Right
		clone.ZIndex = 6
		clone.Parent = p34.Frame
	end

	clone.Text = "x" .. tostring(amount)
	clone.TextTransparency = 0
	clone.Visible = true
end

replicatedStorage = function(p36, p37, p38)
	local v332 = seasonPassCatalog.GetReward(t3.SeasonId, p36, p37)

	if not v332 then
		local icon = p38.Icon

		if icon and icon:IsA("GuiObject") then
			icon.Visible = false
		end

		if p38.ItemName then
			p38.ItemName.Text = ""
			p38.ItemName.Visible = false
		end

		if p38.ItemNamePlate then
			p38.ItemNamePlate.Text = ""
		end

		p38.HoverName = nil

		return
	end

	if v332.Type == "Nothing" then
		local v334 = p38.Icon

		if v334 and v334:IsA("GuiObject") then
			v334.Visible = false
		end

		local rarityGlow = p38.RarityGlow

		if rarityGlow and rarityGlow:IsA("GuiObject") then
			rarityGlow.Visible = false
		end

		if p38.ItemName then
			p38.ItemName.Text = ""
			p38.ItemName.Visible = false
		end

		if p38.ItemNamePlate then
			p38.ItemNamePlate.Text = ""
		end

		local amountBadge = p38.Frame:FindFirstChild("AmountBadge")

		if amountBadge and amountBadge:IsA("GuiObject") then
			amountBadge.Visible = false
		end

		p38.HoverName = nil

		if not p38.HouseStyled then
			paintCardLook(p38.Gradient, p38.OutlineGradient, p38.Spikes, "Common")
		end

		return
	end

	local v337 = seasonPassCatalog.GetDisplay(v332)

	if p38.Icon then
		p38.Icon.Image = v337.Icon
		p38.Icon.Visible = true
	end

	local v338 = v337.Name

	if p38.ItemName then
		p38.ItemName.Text = ""
		p38.ItemName.Visible = false
	end

	if p38.ItemNamePlate then
		p38.ItemNamePlate.Text = ""
	end

	setAmountBadge(p38, v332)

	local rarity2 = v337.Rarity
	local u340: boolean = typeof(rarity2) == "string"
	local v341 = if u340 then rarity2 else v332.Tile or "Common"
	local v342 = rarity.GetColor(v341)
	local v343 = t5[v341]
	local color310

	if not v343 then
		color310 = v342
	else
		local v345, v346, v347 = v342:ToHSV()

		color310 = Color3.fromHSV(v343, v346, v347)
	end

	if p38.RarityGlow then
		local v348 = if p38.HouseStyled then u62 else nil

		p38.RarityGlow.Visible = if p38.HouseStyled then true else u340 or v332.Tile ~= nil
		p38.RarityGlow.ImageColor3 = v348 and v348.GlowColour or color310
	end

	if p38.Gradient and not p38.HouseStyled then
		local gradient = p38.Gradient
		local colorSequenceNew = ColorSequence.new
		local color311 = Color3.new(color310.R * 0.17392, color310.G * 0.17392, color310.B * 0.17392)

		gradient.Color = colorSequenceNew(color311, color310)
	end

	p38.HoverName = v337.Name
	p38.HoverRarity = if u340 then rarity2 else "Common"

	if not p38.HouseStyled then
		paintCardLook(nil, p38.OutlineGradient, p38.Spikes, v341)
	end
end

local function refreshTile(p39, p40, p41)
	local visible: boolean = (if p39 == "Free" then t3.Claimed else t3.ClaimedPremium)[p40] == true
	local u356: boolean = p40 <= t3.Tier
	local u357: boolean = p39 == "Premium" and not t3.Premium
	local doneWash = p41.DoneWash

	if doneWash and doneWash:IsA("GuiObject") then
		doneWash.Visible = visible
	end

	local doneCheck = p41.DoneCheck

	if doneCheck and doneCheck:IsA("GuiObject") then
		doneCheck.Visible = visible
	end

	local doneGlow = p41.DoneGlow

	if doneGlow and doneGlow:IsA("GuiObject") then
		doneGlow.Visible = visible
	end

	if p41.LockedOverlay then
		p41.LockedOverlay.Position = UDim2.new(-0.0075, -1, -0.0075, -1)
		p41.LockedOverlay.Size = UDim2.new(1.015, 2, 1.015, 2)
	end

	local lockedOverlay = p41.LockedOverlay
	local u362 = u357 and t1.PerTileLock

	if lockedOverlay and lockedOverlay:IsA("GuiObject") then
		lockedOverlay.Visible = u362
	end

	local v363 = seasonPassCatalog.GetReward(t3.SeasonId, p39, p40)

	u362 = u356 and not visible and not u357 and (v363 == nil or v363.Type ~= "Nothing")
	p41.Button.Active = u362
	p41.Button.Interactable = u362

	local claimDot = p41.ClaimDot

	if claimDot and claimDot:IsA("GuiObject") then
		claimDot.Visible = u362
	end

	local claimGlow = p41.ClaimGlow

	if claimGlow and claimGlow:IsA("GuiObject") then
		claimGlow.Visible = u362
	end

	local claimScrim = p41.ClaimScrim

	if claimScrim and claimScrim:IsA("GuiObject") then
		claimScrim.Visible = u362
	end

	local claimPill = p41.ClaimPill

	if claimPill and claimPill:IsA("GuiObject") then
		claimPill.Visible = u362
	end

	if u362 and p41.ClaimPill then
		u79(p41.ClaimPill, "CLAIM")
	end

	if p41.Icon then
		p41.Icon.ImageTransparency = 0
	end

	if p41.ItemName then
		p41.ItemName.TextTransparency = 0
	end

	return u362
end

local u98 = nil
local u99 = nil
local u100 = nil
local n1 = 0
local connection = nil

local function setGlowPulse(p42)
	if p42 and not connection then
		connection = runService.Heartbeat:Connect(function()
			local v830 = os.clock()
			local imageTransparency = (math.sin(v830 * 3.9269908169872414) + 1) * 0.5 * -0.47 + 0.72

			for _, v in ipairs({ "Free", "Premium" }) do
				for i = 1, seasonPassConfigTierCount do
					local v835 = t2[v][i]
					local claimGlow = v835 and v835.ClaimGlow

					if claimGlow and claimGlow.Visible then
						claimGlow.ImageTransparency = imageTransparency
					end
				end

				local v837 = t1.choiceTiles[v]
				local glow = v837 and v837.Glow

				if glow and glow.Visible then
					glow.ImageTransparency = imageTransparency
				end
			end
		end)
	elseif not p42 and connection then
		connection:Disconnect()
		connection = nil
	end
end
local function applyLobbyCues(p43)
	if u98 then
		u98.Visible = p43 > 0

		local quantity = u98:FindFirstChild("Quantity")

		if quantity then
			quantity.Text = if p43 > 99 then "!" else tostring(p43)
		end
	end

	if u99 then
		if p43 > 0 then
			u99.Visible = true

			if not u100 then
				u100 = shineEffect.loop(u99, {
					duration = 1,
					offsetStart = Vector2.new(-1.8, 0),
					offsetEnd = Vector2.new(1.8, 0)
				})

				return
			end
		else
			if u100 then
				u100()
				u100 = nil
			end

			u99.Visible = false
		end

		return
	end
end
local function updateClaimCues(p44)
	n1 = p44

	local u372: boolean = false

	if p44 > 0 then
		u372 = u57
	end

	if u372 and not connection then
		connection = runService.Heartbeat:Connect(function()
			local v839 = os.clock()
			local imageTransparency = (math.sin(v839 * 3.9269908169872414) + 1) * 0.5 * -0.47 + 0.72

			for _, v in ipairs({ "Free", "Premium" }) do
				for i = 1, seasonPassConfigTierCount do
					local v844 = t2[v][i]
					local claimGlow = v844 and v844.ClaimGlow

					if claimGlow and claimGlow.Visible then
						claimGlow.ImageTransparency = imageTransparency
					end
				end

				local v846 = t1.choiceTiles[v]
				local glow = v846 and v846.Glow

				if glow and glow.Visible then
					glow.ImageTransparency = imageTransparency
				end
			end
		end)
	elseif not u372 and connection then
		connection:Disconnect()
		connection = nil
	end

	applyLobbyCues(p44)
end

task.spawn(function()
	local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD", 30)

	if not hud then
		return
	end

	local lobbyButtons: Instance = hud:FindFirstChild("LobbyButtons")
	local v375: Instance = lobbyButtons and lobbyButtons:FindFirstChild("LobbyButtons")
	local v376: Instance = v375

	if v376 then
		v376 = v375:FindFirstChild("SeasonPassButton")
	end

	if not v376 or not v376:IsA("ImageButton") then
		return
	end

	local imageLabel: Instance = v376:FindFirstChild("ImageLabel")

	if imageLabel then
		local clone: Instance = alert:Clone()

		clone.Name = "ClaimAlert"
		clone.Visible = false
		clone.Parent = imageLabel
		u98 = clone
	end

	local events: Instance = hud:FindFirstChild("Events")
	local v380: Instance = events

	if v380 then
		v380 = events:FindFirstChild("SeasonPass")
	end

	local shine: Instance = v380 and v380:FindFirstChild("Shine")

	if shine and shine:IsA("GuiObject") then
		local clone: Instance = shine:Clone()

		clone.Name = "ClaimShine"
		clone.ZIndex = 5
		clone.Visible = false
		clone.Parent = v376
		u99 = clone
	end

	applyLobbyCues(n1)
end)

if v36 then
	v36.Active = false
end

local t7: {[any]: any} = {}

if v36 then
	for _, v in ipairs(v36:GetChildren()) do
		if v:IsA("UIStroke") then
			for _, iterValue in ipairs(v:GetChildren()) do
				if iterValue:IsA("UIGradient") then
					table.insert(t7, iterValue)
				end
			end
		end
	end
end

local connection2 = nil

local function setHighlightSpin(p45)
	if p45 and not connection2 and #t7 > 0 then
		connection2 = runService.Heartbeat:Connect(function(deltaTime: number)
			for i = #t7, 1, -1 do
				local v850 = t7[i]

				if not v850.Parent then
					table.remove(t7, i)
				else
					local n1 = v850.Rotation + deltaTime * 75

					if n1 >= 360 then
						n1 -= 360
					end

					v850.Rotation = n1
				end
			end
		end)
	elseif not p45 and connection2 then
		connection2:Disconnect()
		connection2 = nil
	end
end
local function tierColumnCentre(p47)
	local v385 = nil
	local v386 = nil
	local v387 = t1.tileName("Free", p47)

	for _, v in ipairs({ v387, t1.tileName("Premium", p47) }) do
		local v: Instance = canvas:FindFirstChild(v)

		if v and v:IsA("GuiObject") then
			local n1 = v.Position.X.Scale - v.Size.X.Scale * v.AnchorPoint.X
			local n2 = n1 + v.Size.X.Scale

			if v385 == nil or v385 > n1 then
				v385 = n1
			end

			if v386 == nil or v386 < n2 then
				v386 = n2
			end
		end
	end

	if v385 == nil or v386 == nil then
		return nil
	end

	return (v385 + v386) * 0.5
end
local function refreshHighlight(p48)
	if not v36 then
		return
	end

	local v394 = v36
	local v395 = tierColumnCentre(p48)

	if not v395 then
		v394.Visible = false

		return
	end

	local v396 = v394.Position

	v394.Position = UDim2.new(v395 - v394.Size.X.Scale * (0.5 - v394.AnchorPoint.X), 0, v396.Y.Scale, v396.Y.Offset)
	v394.Visible = true
end
local function refreshAllTiles()
	local n2 = 0

	for _, v in ipairs({ "Free", "Premium" }) do
		for i = 1, seasonPassConfigTierCount do
			local v401 = t2[v][i]

			if v401 and refreshTile(v, i, v401) then
				n2 += 1
			end
		end
	end

	if t1.refreshChoiceTiles then
		local v402 = t1.refreshChoiceTiles()

		n2 += v402
	end

	n1 = n2

	local u403: boolean = false

	if n2 > 0 then
		u403 = u57
	end

	if u403 and not connection then
		connection = runService.Heartbeat:Connect(function()
			local v852 = os.clock()
			local imageTransparency = (math.sin(v852 * 3.9269908169872414) + 1) * 0.5 * -0.47 + 0.72

			for _, v in ipairs({ "Free", "Premium" }) do
				for i = 1, seasonPassConfigTierCount do
					local v857 = t2[v][i]
					local claimGlow = v857 and v857.ClaimGlow

					if claimGlow and claimGlow.Visible then
						claimGlow.ImageTransparency = imageTransparency
					end
				end

				local v859 = t1.choiceTiles[v]
				local glow = v859 and v859.Glow

				if glow and glow.Visible then
					glow.ImageTransparency = imageTransparency
				end
			end
		end)
	elseif not u403 and connection then
		connection:Disconnect()
		connection = nil
	end

	applyLobbyCues(n2)
end
local function commaFormat(p49)
	local floored = math.floor(p49)
	local text = tostring(floored)

	repeat
		local v407, v408 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v407
	until v408 == 0

	return text
end
local function refreshProgress()
	levelLabel.Text = string.format("Level %d", t3.Tier)

	local n1 = 0

	if t3.XpForTier > 0 then
		n1 = math.clamp(t3.XpIntoTier / t3.XpForTier, 0, 1)
	elseif t3.Tier >= seasonPassConfigTierCount then
		n1 = 1
	end

	fill.Size = UDim2.new(n1, 0, fill.Size.Y.Scale, fill.Size.Y.Offset)

	if t3.XpForTier > 0 then
		local stringFormat = string.format
		local v411 = commaFormat(t3.XpIntoTier)
		local v412 = commaFormat(t3.XpForTier)

		xpLabel.Text = stringFormat("%s/%s XP", v411, v412)

		return n1
	end

	if t3.Tier >= seasonPassConfigTierCount then
		xpLabel.Text = "MAX"

		return n1
	end

	xpLabel.Text = ""

	return n1
end
local function trackFractionAt(p50)
	local scale = trackLine.Size.X.Scale

	if scale <= 0 then
		return 0
	end

	return (math.clamp((p50 - trackLine.Position.X.Scale) / scale, 0, 1))
end
function t1.collectNodes()
	local t12: {[any]: any} = {}

	t1.Nodes = t12

	local nodes: Instance = trackLine:FindFirstChild("Nodes")

	if not nodes then
		return
	end

	for _, v in ipairs(nodes:GetChildren()) do
		if v:IsA("GuiObject") then
			table.insert(t12, v)
		end
	end

	local function isIconNode(p51)
		return p51:FindFirstChildOfClass("ImageLabel") ~= nil
	end

	table.sort(t12, function(p52, p53)
		local imageLabel = p52:FindFirstChildOfClass("ImageLabel")
		local u865: boolean = p53:FindFirstChildOfClass("ImageLabel") ~= nil

		if imageLabel ~= nil ~= u865 then
			return u865
		end

		return p52.LayoutOrder < p53.LayoutOrder
	end)

	for i, v in ipairs(t12) do
		v.LayoutOrder = i
	end

	local node_Completed: Instance = nodes:FindFirstChild("Node_Completed")
	local node2_Incomplete: Instance = nodes:FindFirstChild("Node2_Incomplete")
	local v424: Instance = node_Completed

	if v424 then
		v424 = node_Completed:FindFirstChildOfClass("UIGradient")
	end

	if node_Completed and node2_Incomplete and v424 and node_Completed:IsA("GuiObject") and node2_Incomplete:IsA("GuiObject") then
		t1.NodeDoneBg = node_Completed.BackgroundColor3
		t1.NodePendingBg = node2_Incomplete.BackgroundColor3
		t1.NodeDoneGradient = v424:Clone()
	end
end

t1.collectNodes()

function t1.nodeFor(p54)
	local v426 = t1.Nodes[p54]

	if v426 then
		return v426
	end

	local foundChild: Instance = canvas:FindFirstChild("Node" .. p54)

	if foundChild and foundChild:IsA("GuiObject") then
		return foundChild
	end

	return nil
end
function t1.paintNode(parent, enabled)
	if parent:FindFirstChildOfClass("ImageLabel") then
		return
	end

	local nodeDoneBg = t1.NodeDoneBg
	local nodePendingBg = t1.NodePendingBg
	local nodeDoneGradient = t1.NodeDoneGradient

	if nodeDoneBg and nodePendingBg and nodeDoneGradient then
		parent.BackgroundColor3 = if enabled then nodeDoneBg else nodePendingBg

		local nodeFill = parent:FindFirstChild("NodeFill")

		if not nodeFill or not nodeFill:IsA("UIGradient") then
			local uiGradient = parent:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				uiGradient:Destroy()
			end

			local clone = nodeDoneGradient:Clone()

			clone.Name = "NodeFill"
			clone.Parent = parent
			nodeFill = clone
		end

		nodeFill.Enabled = enabled

		return
	end

	local uiGradient = parent:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		uiGradient.Color = if enabled then v71 else v72
	end

	local rarity3 = parent:FindFirstChild("Rarity")

	if rarity3 and rarity3:IsA("TextLabel") then
		rarity3.TextColor3 = if enabled then color32 else color33
	end
end
local function nodeCentreX(p57)
	local foundChild: Instance = canvas:FindFirstChild("Node" .. p57)

	if foundChild and foundChild:IsA("GuiObject") then
		return foundChild.Position.X.Scale
	end

	return (tierColumnCentre(p57))
end
local function refreshTrack(p58)
	local v441 = math.clamp(t3.Tier, 1, seasonPassConfigTierCount)

	refreshHighlight(v441)

	for i = 1, seasonPassConfigTierCount do
		local v443 = t1.nodeFor(i)

		if v443 then
			t1.paintNode(v443, i <= t3.Tier)
		end
	end

	if t3.Tier < 1 then
		doneSegment.Size = UDim2.new(0, 0, doneSegment.Size.Y.Scale, doneSegment.Size.Y.Offset)

		return
	end

	local tier = t3.Tier
	local foundChild: Instance = canvas:FindFirstChild("Node" .. tier)
	local v446 = if foundChild and foundChild:IsA("GuiObject") then foundChild.Position.X.Scale else tierColumnCentre(tier)

	if not v446 then
		return
	end

	local scale = trackLine.Size.X.Scale

	v441 = if scale <= 0 then 0 else math.clamp((v446 - trackLine.Position.X.Scale) / scale, 0, 1)

	if t3.Tier < seasonPassConfigTierCount then
		local n1 = t3.Tier + 1
		local foundChild2: Instance = canvas:FindFirstChild("Node" .. n1)
		local v450 = if foundChild2 and foundChild2:IsA("GuiObject") then foundChild2.Position.X.Scale else tierColumnCentre(n1)

		if v450 then
			local v451 = trackLine.Size.X.Scale
			local n2

			if v451 <= 0 then
				n2 = 0
			else
				n2 = math.clamp((v450 - trackLine.Position.X.Scale) / v451, 0, 1)
			end

			v441 += (n2 - v441) * p58
		end
	end

	local uDim2New = UDim2.new
	local v454 = math.clamp(v441, 0, 1)

	doneSegment.Size = uDim2New(v454, 0, doneSegment.Size.Y.Scale, doneSegment.Size.Y.Offset)
end

u79 = function(p59, text)
	p59.Text = text

	local v457 = nil

	for _, v in ipairs(p59:GetChildren()) do
		if v:IsA("TextLabel") and v.Name ~= "WasPrice" then
			v457 = v

			break
		end
	end

	if v457 then
		v457.Text = text

		local textLabel2 = v457:FindFirstChildOfClass("TextLabel")

		if textLabel2 then
			textLabel2.Text = text
		end
	end
end

local v121 = utf8.char(57346)

skipButton.TextTransparency = 1
buyButton.TextTransparency = 1

local numberValue = nil

local function refreshPremiumBar()
	local premium = t3.Premium

	premiumBar.Visible = true

	if seasonPassConfig.PremiumProductId == 0 then
		u79(buyButton, "SOON")
		buyButton.Interactable = false
	elseif premium then
		u79(buyButton, "OWNED")
		uiFramework.setButtonDisabled(buyButton)
	else
		local v462 = numberValue
		local v463 = u79
		local v464

		if v462 then
			local stringFormat = string.format
			local v466 = commaFormat(v462)

			v464 = stringFormat("%s%s", v121, v466)
		else
			v464 = "BUY"
		end

		v463(buyButton, v464)
		uiFramework.setButtonEnabled(buyButton)
	end

	icon.Interactable = buyButton.Interactable

	if parent then
		parent.Visible = buyButton.Interactable
		u47 = false
		u48 = false

		local v467 = u44

		if v467 then
			if u49 then
				u49:Cancel()
				u49 = nil
			end

			local n1: number = 1

			if u48 then
				n1 = 0.94
			elseif u47 then
				n1 = 1.06
			end

			v467.Scale = n1
		end
	end

	giftButton.Visible = seasonPassConfig.GiftPremiumProductId ~= 0

	local v469, v470 = seasonPassConfig.SkipCostForTier(t3.Tier)
	local visible: boolean = v470 ~= 0 and t3.Tier < seasonPassConfigTierCount

	skipButton.Visible = visible

	if visible then
		u79(skipButton, string.format("Skip 1  (%s%d)", v121, v469))
	end

	if t1.VIPLocked then
		t1.VIPLocked.Visible = not premium
	end

	local wasPrice = t1.WasPrice

	if wasPrice then
		local seasonPassConfigPremiumCompareAtRobux = seasonPassConfig.PremiumCompareAtRobux
		local v474 = numberValue
		local u475: boolean = not premium

		if u475 then
			u475 = false

			if seasonPassConfigPremiumCompareAtRobux ~= nil then
				u475 = false

				if v474 ~= nil then
					u475 = v474 < seasonPassConfigPremiumCompareAtRobux
				end
			end
		end

		wasPrice.Visible = u475

		if u475 then
			wasPrice.Text = commaFormat(seasonPassConfigPremiumCompareAtRobux)
		end
	end

	local priceLabel = t1.PriceLabel

	if priceLabel and t1.PriceHome then
		local priceHome = t1.PriceHome

		priceLabel.Position = if not wasPrice or not wasPrice.Visible then UDim2.new(0.5, 0, priceHome.Position.Y.Scale, priceHome.Position.Y.Offset) else priceHome.Position
	end

	if t1.Caption then
		t1.Caption.Text = if premium then t1.CaptionOwned else t1.CaptionSell
	end
end

task.spawn(function()
	if seasonPassConfig.PremiumProductId == 0 then
		return
	end

	local ok, result = pcall(function()
		return marketplaceService:GetProductInfo(seasonPassConfig.PremiumProductId, Enum.InfoType.Product)
	end)

	if ok and typeof(result) == "table" then
		numberValue = tonumber(result.PriceInRobux)
	end

	if numberValue then
		refreshPremiumBar()
	end
end)

local function refreshAll()
	refreshAllTiles()

	local v480 = refreshProgress()

	refreshTrack(v480)
	refreshPremiumBar()
end
local function applyState(p61)
	if type(p61) == "table" then
		t3.SeasonId = p61.SeasonId or seasonPassConfig.CurrentSeasonId
		t3.Tier = p61.Tier or 0
		t3.XP = p61.XP or 0
		t3.Premium = p61.Premium == true
		t3.XpIntoTier = p61.XpIntoTier or 0
		t3.XpForTier = p61.XpForTier or 0
		t3.Claimed = {}

		for _, v in ipairs(p61.Claimed or {}) do
			t3.Claimed[v] = true
		end

		t3.ClaimedPremium = {}

		for _, v in ipairs(p61.ClaimedPremium or {}) do
			t3.ClaimedPremium[v] = true
		end

		t3.Chosen = if type(p61.Chosen) == "table" then p61.Chosen else {}
		t3.Challenges = if type(p61.Challenges) == "table" then p61.Challenges else {}

		local v486 = seasonPassCatalog.Get(t3.SeasonId)

		if t1.Season and v486 then
			t1.Season.Text = v486.Name
		end

		refreshAllTiles()

		local v487 = refreshProgress()

		refreshTrack(v487)
		refreshPremiumBar()

		return
	end
end

local t8: {[any]: any} = {
	SOUND_ID = 92629765145489,
	VOLUME = 0.6,
	CLICK_ID = 104385763277326,
	CLICK_VOLUME = 0.5,
	PITCH_STEP = 0.02,
	FLY_TIME = 0.45,
	HOLD = 1.5,
	SHAKE_TIME = 0.6,
	CARD_SCREEN_H = 0.3,
	DIM = 0.3,
	SKIP_GRACE = 0.2,
	SKIP_OUT = 0.2,
	RAYS_ID = "rbxassetid://124664870005841",
	GLOW_ID = "rbxassetid://108477348741825",
	streak = 0,
	gen = 0,
	nextSound = 1,
	nextClick = 1,
	KEEP = {
		UICorner = true,
		UIStroke = true,
		UIGradient = true,
		Icon = true,
		Spikes = true,
		RarityGlow = true,
		AmountBadge = true
	},
	made = {},
	sounds = {},
	clicks = {},
	rng = Random.new()
}

for _, v in ipairs({
	{ t8.sounds, t8.SOUND_ID, "ClaimRevealSfx", 4 },
	{ t8.clicks, t8.CLICK_ID, "ClaimClickSfx", 2 }
}) do
	for i = 1, v[4] do
		local sound: Sound = Instance.new("Sound")

		sound.Name = v[3] .. i
		sound.SoundId = "rbxassetid://" .. v[2]
		sound.Parent = scriptParent
		table.insert(v[1], sound)
	end
end

function t8.fire(p62, p63, p64, playbackSpeed)
	local v492 = t8[p63]
	local v493 = p62[v492]

	t8[p63] = v492 % #p62 + 1

	local sfxVolume: any = game:GetService("SoundService"):GetAttribute("SFXVolume")
	local typeName: string = typeof(sfxVolume)

	v493.Volume = p64 * (if typeName == "number" then sfxVolume else 1)
	v493.PlaybackSpeed = playbackSpeed
	v493.TimePosition = 0
	v493:Play()
end
function t8.playSound()
	local n1 = 1 + t8.streak * t8.PITCH_STEP
	local v497: {[any]: any} = t8

	v497.streak = v497.streak + 1
	t8.fire(t8.sounds, "nextSound", t8.VOLUME, n1)
end
function t8.playClick()
	t8.fire(t8.clicks, "nextClick", t8.CLICK_VOLUME, 1)
end
function t8.tween(p66, p67, p68, p69, p70)
	local tweenInfo2 = TweenInfo.new(p67, p69 or Enum.EasingStyle.Quad, p70 or Enum.EasingDirection.Out)
	local v504: Tween = tweenService:Create(p66, tweenInfo2, p68)

	v504:Play()

	return v504
end
function t8.new(className, p72, parent)
	local v508 = Instance.new(className)

	for k, v in pairs(p72) do
		v508[k] = v
	end

	v508.Parent = parent
	table.insert(t8.made, v508)

	return v508
end
function t8.overlay()
	local root = t8.root

	if root and root.Parent then
		return root
	end

	local claimReveal: Frame = Instance.new("Frame")

	claimReveal.Name = "ClaimReveal"
	claimReveal.BackgroundTransparency = 1
	claimReveal.Size = UDim2.fromScale(1, 1)
	claimReveal.ZIndex = 100
	claimReveal.Visible = false
	claimReveal.Parent = scriptParent

	local dim: TextButton = Instance.new("TextButton")

	dim.Name = "Dim"
	dim.Text = ""
	dim.AutoButtonColor = false
	dim.Selectable = false
	dim:AddTag("BlacklistHover")
	dim.BackgroundColor3 = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 1
	dim.BorderSizePixel = 0
	dim.Position = UDim2.fromOffset(0, -80)
	dim.Size = UDim2.new(1, 0, 1, 80)
	dim.ZIndex = 1
	dim.Parent = claimReveal
	dim.Activated:Connect(function()
		t8.skip()
	end)
	t8.root = claimReveal
	t8.dim = dim

	return claimReveal
end
function t8.skip()
	if os.clock() - (t8.startedAt or 0) < t8.SKIP_GRACE then
		return
	end

	t8.skipNow = true
end
function t8.clear()
	local v514: {[any]: any} = t8

	v514.gen = v514.gen + 1

	if t8.spin then
		t8.spin:Disconnect()
		t8.spin = nil
	end

	for _, v in ipairs(t8.made) do
		v:Destroy()
	end

	table.clear(t8.made)
end
function t8.reset()
	t8.clear()
	t8.streak = 0

	if t8.dim then
		t8.dim.BackgroundTransparency = 1
	end

	if t8.root then
		t8.root.Visible = false
	end
end
function t8.tileFor(p74, p75)
	local v519 = t2[p74][p75]

	if v519 then
		return v519.Frame
	end

	local foundChild: Instance = canvas:FindFirstChild(p74 .. "Choose")

	if foundChild and foundChild:IsA("GuiObject") then
		return foundChild
	end

	return nil
end
function t8.bump(p76, scale)
	local icon = p76 and p76:FindFirstChild("Icon")

	if not icon or not icon:IsA("GuiObject") then
		return
	end

	local claimBump = icon:FindFirstChild("ClaimBump")

	if not claimBump or not claimBump:IsA("UIScale") then
		claimBump = Instance.new("UIScale")
		claimBump.Name = "ClaimBump"
		claimBump.Parent = icon
	end

	claimBump.Scale = scale
	t8.tween(claimBump, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
end
function t8.resolve(p78, p79, p80, p81)
	local v529 = seasonPassCatalog.GetReward(t3.SeasonId, p78, p79)

	if not v529 then
		return nil
	end

	local v530 = v529

	if v529.Type == "Choice" and p80 and v529.Options then
		v530 = v529.Options[p80] or v529
	end

	local v531 = seasonPassCatalog.GetDisplay(v530)
	local u532: boolean = v530.Type == "Finisher" and v530.Id == nil
	local v533 = v531.Name
	local v534 = v531.Icon
	local v535 = v531.Rarity

	if p81 and (not not u532 or not v533) then
		v533 = p81.Name or v533
		v534 = p81.Icon or v534
		v535 = p81.Rarity or v535
	end

	v531 = typeof(v535) == "string"

	local t13: {[any]: any} = {
		rolled = u532,
		name = v533 or "",
		icon = v534 or "",
		look = if v531 then v535 else v529.Tile or "Common",
		faceLook = v529.Tile or "Common",
		subtitle = v537
	}
	local v537 = if v531 then string.upper(v535) else nil

	return t13
end
function t8.paint(p82, image, p84)
	local icon = p82:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.Image = image
		icon.Visible = true
	end

	local uiGradient = p82:FindFirstChildOfClass("UIGradient")
	local v543 = findOutlineGradient(p82)
	local spikes = p82:FindFirstChild("Spikes")

	paintCardLook(uiGradient, v543, spikes, p84)

	local rarityGlow = p82:FindFirstChild("RarityGlow")

	if rarityGlow and rarityGlow:IsA("ImageLabel") then
		rarityGlow.Visible = true

		local v546 = rarity.GetColor(p84)
		local v547 = t5[p84]
		local color312

		if not v547 then
			color312 = v546
		else
			local v549, v550, v551 = v546:ToHSV()

			color312 = Color3.fromHSV(v547, v550, v551)
		end

		rarityGlow.ImageColor3 = color312
	end

	local amountBadge = p82:FindFirstChild("AmountBadge")

	if amountBadge then
		amountBadge:Destroy()
	end
end
function t8.label(p85, text, p87, p88)
	local clone

	if p85 then
		clone = p85:Clone()

		for _, v in ipairs(clone:GetChildren()) do
			if not v:IsA("UIStroke") then
				v:Destroy()
			end
		end
	else
		clone = Instance.new("TextLabel")
		clone.Font = Enum.Font.GothamBlack
		clone.TextColor3 = Color3.new(1, 1, 1)

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Thickness = math.max(2, p87 * 0.07)
		uiStroke.Parent = clone
	end

	clone.Name = "RevealText"
	clone.Text = text
	clone.RichText = false
	clone.TextScaled = true
	clone.BackgroundTransparency = 1
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Size = UDim2.fromOffset(p88, p87)
	clone.Rotation = 0
	clone.Visible = true
	clone.TextTransparency = 0
	clone.ZIndex = 12

	local uiStroke = clone:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		if uiStroke.StrokeSizingMode == Enum.StrokeSizingMode.ScaledSize then
			uiStroke.Thickness = math.max(uiStroke.Thickness, 0.12)
		end

		uiStroke.Transparency = 0
	end

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Scale = 0
	uiScale.Parent = clone

	return clone
end
function t8.impact(p89, p90, p91, p92, p93)
	local new = t8.new
	local v569 = UDim2.fromScale(1, 1)
	local parent = new("Frame", {
		Name = "Flash",
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 50,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = v569
	}, p90)
	local uiCorner = p90:FindFirstChildOfClass("UICorner")

	if uiCorner then
		local clone = uiCorner:Clone()

		clone.Parent = parent
	end

	t8.tween(parent, 0.4, { BackgroundTransparency = 1 })

	local v573 = t8.new
	local v574 = UDim2.fromOffset(p91.X, p91.Y)
	local v575 = UDim2.fromOffset(p92.X, p92.Y)
	local v576 = v573("Frame", {
		Name = "Ring",
		BackgroundTransparency = 1,
		ZIndex = 6,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = v574,
		Size = v575
	}, p89)

	t8.new("UICorner", { CornerRadius = UDim.new(0.08, 0) }, v576)

	local v577 = t8.new
	local v578 = p93:Lerp(Color3.new(1, 1, 1), 0.5)
	local v579 = math.max(3, p92.Y * 0.03)
	local v580 = v577("UIStroke", { Transparency = 0, Color = v578, Thickness = v579 }, v576)
	local tween = t8.tween
	local v582 = UDim2.fromOffset(p92.X * 1.9, p92.Y * 1.9)

	tween(v576, 0.55, { Size = v582 }, Enum.EasingStyle.Quart)
	t8.tween(v580, 0.55, { Transparency = 1, Thickness = 1 }, Enum.EasingStyle.Quart)

	local rng = t8.rng

	for i = 1, 14 do
		local v585 = rng:NextNumber(-0.25, 0.25)
		local n1 = i / 14 * 3.141592653589793 * 2 + v585
		local vector2New = Vector2.new
		local cosine = math.cos(n1)
		local sine = math.sin(n1)
		local v590 = vector2New(cosine, sine)

		n1 = p91 + v590 * p92.Y * 0.35

		local n2 = v590 * p92.Y
		local v592 = rng:NextNumber(0.75, 1.3)

		v585 = p91 + n2 * v592

		local y = p92.Y
		local v594 = rng:NextNumber(0.03, 0.06)

		v590 = math.max(5, y * v594)

		local v595 = t8.new("Frame", {
			Name = "Sparkle",
			BorderSizePixel = 0,
			Rotation = 45,
			ZIndex = 12,
			BackgroundColor3 = if i % 3 == 0 then p93:Lerp(Color3.new(1, 1, 1), 0.3) else Color3.new(1, 1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(n1.X, n1.Y),
			Size = UDim2.fromOffset(v590, v590)
		}, p89)
		local v596 = t8.tween
		local v597 = rng:NextNumber(0.45, 0.75)
		local v598 = UDim2.fromOffset(v585.X, v585.Y)
		local v599 = UDim2.fromOffset(0, 0)
		local v600 = rng:NextNumber(120, 300)

		v596(v595, v597, { Position = v598, Size = v599, Rotation = 45 + v600 }, Enum.EasingStyle.Quart)
	end
end
function t8.play(p94, p95, p96, p97)
	local v605 = t8.resolve(p94, p95, p96, p97)

	if not v605 then
		return
	end

	local v606 = t2[p94][p95]
	local v607 = t2[p94][seasonPassConfigTierCount - 1]
	local v608 = if v606 then v606.Frame else if v607 then v607.Frame else nil
	local v609 = t8.tileFor(p94, p95) or v608

	if v608 and v609 then
		t8.clear()

		local gen = t8.gen

		t8.skipNow = false
		t8.startedAt = os.clock()

		local parent = t8.overlay()

		parent.Visible = true

		local absolutePosition = parent.AbsolutePosition
		local absoluteSize = parent.AbsoluteSize
		local v614 = v609.AbsoluteSize
		local n1 = v609.AbsolutePosition + v614 / 2 - absolutePosition
		local v616 = math.clamp(absoluteSize.Y * t8.CARD_SCREEN_H, 120, 320)
		local v617 = math.max(v614.Y, 1)
		local n2 = v616 / v617

		v617 = panel.AbsolutePosition + panel.AbsoluteSize / 2 - absolutePosition

		local vector22 = Vector2.new(v617.X, v617.Y - v616 * 0.15)
		local clone = v608:Clone()

		for _, v in ipairs(clone:GetChildren()) do
			if not t8.KEEP[v.Name] then
				v:Destroy()
			end
		end

		if not v606 then
			t8.paint(clone, v605.icon, v605.look)
		end

		clone.Name = "RevealCard"
		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Position = UDim2.fromOffset(n1.X, n1.Y)
		clone.Size = UDim2.fromOffset(v614.X, v614.Y)
		clone.Rotation = -10
		clone.ZIndex = 10
		clone.Visible = true
		clone.Parent = parent
		table.insert(t8.made, clone)

		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Parent = clone
		t8.tween(t8.dim, 0.25, { BackgroundTransparency = t8.DIM })

		local v624 = if v605.rolled then v605.faceLook else v605.look
		local v625 = rarity.GetColor(v624)
		local v626 = t5[v624]
		local color313

		if not v626 then
			color313 = v625
		else
			local v628, v629, v630 = v625:ToHSV()

			color313 = Color3.fromHSV(v626, v629, v630)
		end

		v624 = function(name, p99, p100, p101, p102)
			local new = t8.new
			local v872 = UDim2.fromOffset(vector22.X, vector22.Y)
			local v873 = UDim2.fromOffset(p100 * 0.5, p100 * 0.5)

			return new("ImageLabel", {
				ImageTransparency = 1,
				BackgroundTransparency = 1,
				Name = name,
				Image = p99,
				ImageColor3 = p102,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = v872,
				Size = v873,
				ZIndex = p101
			}, parent)
		end

		local n3 = v616 * 3.2
		local n4 = v616 * 2.3
		local v633 = v624("Rays", t8.RAYS_ID, n3, 3, color313)
		local v634 = v624("RaysInner", t8.RAYS_ID, n3 * 0.7, 4, Color3.new(1, 1, 1))
		local v635 = v624("Glow", t8.GLOW_ID, n4, 5, color313)
		local u636 = os.clock()
		local u637: boolean = false

		t8.spin = runService.RenderStepped:Connect(function(deltaTime: number)
			local v875 = v633

			v875.Rotation = v875.Rotation + deltaTime * 28
			v875 = v634
			v875.Rotation = v875.Rotation - deltaTime * 16

			if u637 then
				local n1 = os.clock() - u636
				local uDim2FromOffset = UDim2.fromOffset
				local vector22X = vector22.X
				local vector22Y = vector22.Y
				local sine = math.sin(n1 * 2.6)

				clone.Position = uDim2FromOffset(vector22X, vector22Y + sine * v616 * 0.015)
				v635.ImageTransparency = math.sin(n1 * 3.4) * 0.12 + 0.15
			end
		end)
		task.delay(0.12, function()
			if t8.gen ~= gen then
				return
			end

			local tween = t8.tween
			local v882 = UDim2.fromOffset(n3, n3)

			tween(v633, 0.4, { ImageTransparency = 0.25, Size = v882 }, Enum.EasingStyle.Back)

			local v883 = t8.tween

			v882 = UDim2.fromOffset(n3 * 0.7, n3 * 0.7)
			v883(v634, 0.4, { ImageTransparency = 0.7, Size = v882 }, Enum.EasingStyle.Back)

			local v884 = t8.tween

			v882 = UDim2.fromOffset(n4, n4)
			v884(v635, 0.4, { ImageTransparency = 0.15, Size = v882 }, Enum.EasingStyle.Back)
		end)

		local tween = t8.tween
		local fly_time = t8.FLY_TIME
		local v640 = UDim2.fromOffset(vector22.X, vector22.Y)

		tween(clone, fly_time, { Position = v640 }, Enum.EasingStyle.Quart)
		t8.tween(clone, t8.FLY_TIME + 0.15, { Rotation = 0 }, Enum.EasingStyle.Back)
		t8.tween(uiScale, t8.FLY_TIME + 0.1, { Scale = n2 }, Enum.EasingStyle.Back)

		if not v605.rolled then
			t8.playSound()
		end

		v624 = v606 or v607

		local itemName = v624 and v624.ItemName

		v624 = math.clamp(absoluteSize.Y * 0.065, 26, 60)

		local v642 = math.min(absoluteSize.X * 0.85, 760)
		local n5 = vector22.Y + v616 / 2 + v624 * 0.75
		local v644 = t8.label(itemName, v605.name, v624, v642)

		v644.Position = UDim2.fromOffset(vector22.X, n5)
		v644.Parent = parent
		table.insert(t8.made, v644)
		rarity.ApplyTextGradient(v644, v605.look)

		local u645 = nil

		if v605.subtitle then
			local n6 = v624 * 0.5
			local v647 = t8.label(itemName, v605.subtitle, n6, v642)

			v647.Position = UDim2.fromOffset(vector22.X, n5 + v624 * 0.5 + n6 * 0.7)

			local look = v605.look
			local v649 = rarity.GetColor(look)
			local v650 = t5[look]
			local color314

			if not v650 then
				color314 = v649
			else
				local v652, v653, v654 = v649:ToHSV()

				color314 = Color3.fromHSV(v650, v653, v654)
			end

			v647.TextColor3 = color314:Lerp(Color3.new(1, 1, 1), 0.3)
			v647.Parent = parent
			table.insert(t8.made, v647)
			u645 = v647
		end

		task.spawn(function()
			local function alive()
				return t8.gen == gen
			end
			local function waitOrSkip(p104)
				local v958 = os.clock()

				while true do
					local v959 = os.clock()

					if not (v958 + p104 > v959) then
						break
					end

					if t8.gen ~= gen or t8.skipNow then
						return true
					end

					runService.RenderStepped:Wait()
				end

				return false
			end

			local v887 = waitOrSkip(t8.FLY_TIME)

			if t8.gen ~= gen then
				return
			end

			if v605.rolled then
				local v888 = os.clock()

				while not v887 and os.clock() - v888 < t8.SHAKE_TIME do
					if t8.gen ~= gen then
						return
					end

					if t8.skipNow then
						break
					end

					local n3 = (os.clock() - v888) / t8.SHAKE_TIME
					local v890 = os.clock()

					clone.Rotation = math.sin(v890 * 55) * (2 + 7 * n3)
					uiScale.Scale = n2 * (1 + 0.05 * n3)
					runService.RenderStepped:Wait()
				end

				clone.Rotation = 0

				local tween = t8.tween
				local v892 = UDim2.fromOffset(0, v614.Y)

				tween(clone, 0.1, { Size = v892 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Wait()

				if t8.gen ~= gen then
					return
				end

				t8.paint(clone, v605.icon, v605.look)

				local look = v605.look
				local v894 = rarity.GetColor(look)
				local v895 = t5[look]
				local color315

				if not v895 then
					color315 = v894
				else
					local v897, v898, v899 = v894:ToHSV()

					color315 = Color3.fromHSV(v895, v898, v899)
				end

				v633.ImageColor3 = color315
				v635.ImageColor3 = color315

				local v900 = t8.tween
				local v901 = UDim2.fromOffset(v614.X, v614.Y)

				v900(clone, 0.24, { Size = v901 }, Enum.EasingStyle.Back)
				t8.tween(uiScale, 0.24, { Scale = n2 }, Enum.EasingStyle.Back)
				t8.playSound()
				t8.skipNow = false
				t8.startedAt = os.clock()
				v887 = false
			end

			if not v887 then
				local impact = t8.impact
				local vector23 = Vector2.new(v614.X * n2, v616)

				impact(parent, clone, vector22, vector23, cardColour(v605.look))

				local v904 = t8.tween
				local uiScale3 = v644:FindFirstChildOfClass("UIScale")

				v904(uiScale3, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)

				if u645 then
					task.delay(0.08, function()
						if t8.gen == gen then
							local tween = t8.tween
							local uiScale4 = u645:FindFirstChildOfClass("UIScale")

							tween(uiScale4, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
						end
					end)
				end

				u636 = os.clock()
				u637 = true
				v887 = waitOrSkip(t8.HOLD)

				if t8.gen ~= gen then
					return
				end

				u637 = false
			end

			waitOrSkip = if v887 then t8.SKIP_OUT else 0.38
			v887 = n1

			if v609.Parent then
				v887 = v609.AbsolutePosition + v609.AbsoluteSize / 2 - parent.AbsolutePosition
			end

			local v906 = t8.tween
			local v907 = UDim2.fromOffset(v887.X, v887.Y)

			v906(clone, waitOrSkip, { Rotation = 8, Position = v907 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			t8.tween(uiScale, waitOrSkip, { Scale = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			for _, v in ipairs({ v633, v634, v635 }) do
				t8.tween(v, waitOrSkip * 0.8, { ImageTransparency = 1 })
			end

			for _, v in ipairs({ v644, u645 }) do
				if v then
					t8.tween(v, waitOrSkip * 0.65, { TextTransparency = 1 })

					local uiStroke = v:FindFirstChildOfClass("UIStroke")

					if uiStroke then
						t8.tween(uiStroke, waitOrSkip * 0.65, { Transparency = 1 })
					end
				end
			end

			t8.tween(t8.dim, waitOrSkip, { BackgroundTransparency = 1 })
			task.wait(waitOrSkip)

			if t8.gen ~= gen then
				return
			end

			t8.bump(v609, 1.3)
			t8.clear()
			parent.Visible = false
		end)

		return
	end
end
local function requestClaim(p105, p106, p107, p108)
	if u58 then
		return false
	end

	u58 = true

	local bump = t8.bump
	local v660 = t8.tileFor(p105, p106)

	bump(v660, 0.85)
	t8.playClick()
	task.spawn(function()
		local v913, v914, v915 = pcall(function()
			return seasonPass:InvokeServer("Claim", p105, p106, p107, true)
		end)

		u58 = false

		if v913 and v914 then
			local play = t8.play
			local typeName: string = typeof(v915)
			local ok, result = pcall(play, p105, p106, p107, if typeName == "table" then v915 else nil)

			if not ok then
				local text: string = tostring(result)

				warn("[BattlePassController] claim reveal failed: " .. text)
			end

			(if p105 == "Free" then t3.Claimed else t3.ClaimedPremium)[p106] = true
			refreshAllTiles()

			local v921 = refreshProgress()

			refreshTrack(v921)
			refreshPremiumBar()
		end

		local ok, result = pcall(function()
			return seasonPass:InvokeServer("GetState")
		end)

		if ok and result then
			applyState(result)
		end

		if p108 then
			p108(v913 and v914 == true)
		end
	end)

	return true
end

if not seasonPassCatalog.AwaitDisplay(15) then
	warn("[BattlePassController] display projection never arrived -- tiles will show raw ids. Check that SeasonPassService.Start ran and published it.")
end

local function showTileHover(p109)
	if not u57 then
		return
	end

	local hoverName = p109.HoverName

	if hoverName and hoverName ~= "" then
		hoverInfoModule.show(v53, {
			Name = hoverName,
			Rarity = p109.HoverRarity or "Common",
			SourceButton = p109.Button
		})

		return
	end
end

for _, v in ipairs({ "Free", "Premium" }) do
	for i = 1, seasonPassConfigTierCount do
		local v136 = players(v, i)

		if v136 then
			t2[v][i] = v136
			replicatedStorage(v, i, v136)

			local s1 = v
			local n2: number = i
			local u139 = nil

			v136.Button.MouseButton1Click:Connect(function()
				if not v136.Button.Interactable then
					return
				end

				if u139 ~= nil and u139.tapConsumed() then
					return
				end

				requestClaim(s1, n2)
			end)
			u139 = hoverInfoModule.bind(v53, v136.Frame, function()
				if not u57 then
					return nil
				end

				local hoverName = v136.HoverName

				if hoverName and hoverName ~= "" then
					return {
						Name = hoverName,
						Rarity = v136.HoverRarity or "Common",
						SourceButton = v136.Button
					}
				end

				return nil
			end)
			v136.Button.SelectionGained:Connect(function()
				showTileHover(v136)
			end)
			v136.Button.SelectionLost:Connect(function()
				hoverInfoModule.hide(v53)
			end)
		end
	end
end

for i = 1, seasonPassConfigTierCount do
	local v141 = t1.nodeFor(i)
	local v142 = v141

	if v142 then
		v142 = v141:FindFirstChild("Rarity")
	end

	if v142 and v142:IsA("TextLabel") then
		v142.Text = tostring(i)
	end
end

t1.ConfirmWindow = 4
t1.TitlePreview = "The Grand Prize"
t1.TitleClaim = ""
t1.Cards = {}
t1.PickTrack = nil
t1.Armed = nil
t1.ArmedAt = 0
t1.PickBusy = false

function t1.optionById(p110, p111)
	for _, v in ipairs(p110.Options or {}) do
		if p111 == v.Id then
			return v
		end
	end

	return nil
end
function t1.challenge(p112)
	local v669 = t3.Challenges[p112 .. seasonPassConfigTierCount]
	local v670 = if type(v669) == "table" then tonumber(v669.Goal) else nil

	if v670 and not (v670 <= 0) then
		local numberValue: number? = tonumber(v669.Kills)

		return math.min(numberValue or 0, v670), v670
	end

	return nil, nil
end
function t1.challengeNote(p113)
	local v673, v674 = t1.challenge(p113)

	if not v674 then
		return nil
	end

	if (if p113 == "Free" then t3.Claimed else t3.ClaimedPremium)[seasonPassConfigTierCount] then
		return nil
	end

	if t3.Tier < seasonPassConfigTierCount then
		return string.format("Reach Lv %d, then get %d kills to unlock", seasonPassConfigTierCount, v674)
	end

	if v673 < v674 then
		return string.format("Get %d kills to unlock: %d/%d", v674, v673, v674)
	end

	return "Challenge complete!"
end
function t1.choiceStatus(p114)
	if (if p114 == "Free" then t3.Claimed else t3.ClaimedPremium)[seasonPassConfigTierCount] then
		return false, "Claimed"
	end

	if p114 == "Premium" and not t3.Premium then
		return false, "VIP Only"
	end

	if t3.Tier < seasonPassConfigTierCount then
		return false, string.format("Reach Lv %d", seasonPassConfigTierCount)
	end

	local v676, v677 = t1.challenge(p114)

	if v677 and v676 < v677 then
		return false, string.format("%d/%d Kills", v676, v677)
	end

	return true, nil
end
function t1.renderPicker()
	local pickTrack = t1.PickTrack

	if not pickTrack then
		return
	end

	local v679 = seasonPassCatalog.GetReward(t3.SeasonId, pickTrack, seasonPassConfigTierCount)
	local v680 = if v679 and v679.Type == "Choice" then v679.Options else nil
	local v681, v682 = t1.choiceStatus(pickTrack)

	for i, v in ipairs(t1.Cards) do
		local v685 = v680 and v680[i]

		v.Root.Visible = v685 ~= nil

		if v685 then
			local v686 = seasonPassCatalog.GetDisplay(v685).Name

			if v.Name then
				v.Name.Text = v686
			end

			if v.NameShadow then
				v.NameShadow.Text = v686
			end

			local vButton = v.Button

			if vButton then
				if t1.PickBusy then
					u79(vButton, "...")
					uiFramework.setButtonDisabled(vButton)
				elseif v681 then
					u79(vButton, if i == t1.Armed then "Confirm" else "Select")
					uiFramework.setButtonEnabled(vButton)
				else
					u79(vButton, v682 or "Locked")
					uiFramework.setButtonDisabled(vButton)
				end
			end
		end
	end

	if t1.Kicker then
		t1.Kicker.Visible = v681
	end

	if t1.Title then
		t1.Title.Text = if v681 then t1.TitleClaim else t1.challengeNote(pickTrack) or t1.TitlePreview
	end
end
function t1.openPicker(pickTrack)
	local picker = t1.Picker

	if not picker or not u57 then
		return
	end

	t1.PickTrack = pickTrack
	t1.Armed = nil
	t1.renderPicker()
	hoverInfoModule.hide(v53)
	panel.Visible = false
	picker.Visible = true
end
function t1.closePicker()
	local picker = t1.Picker

	if picker and t1.PickTrack ~= nil then
		picker.Visible = false
		t1.PickTrack = nil
		t1.Armed = nil

		if u57 then
			panel.Visible = true
		end

		return
	end
end
function t1.pressCard(armed)
	local pickTrack = t1.PickTrack

	if pickTrack and not t1.PickBusy then
		if not t1.choiceStatus(pickTrack) then
			return
		end

		if armed == t1.Armed and not (os.clock() - t1.ArmedAt > t1.ConfirmWindow) then
			t1.Armed = nil
			t1.PickBusy = true
			t1.renderPicker()

			if not requestClaim(pickTrack, seasonPassConfigTierCount, armed, function(p117)
				t1.PickBusy = false

				if p117 then
					t1.closePicker()

					return
				end

				t1.renderPicker()
			end) then
				t1.PickBusy = false
				t1.renderPicker()
			end

			return
		end

		t1.Armed = armed
		t1.ArmedAt = os.clock()

		local armedAt = t1.ArmedAt

		t1.renderPicker()
		task.delay(t1.ConfirmWindow, function()
			if t1.Armed == armed and t1.ArmedAt == armedAt then
				t1.Armed = nil
				t1.renderPicker()
			end
		end)

		return
	end
end
function t1.buildPicker()
	local parent: Instance = scriptParent:FindFirstChild("GrandPrize") or scriptParent:FindFirstChild("Frame")

	if not parent or not parent:IsA("GuiObject") then
		return
	end

	t1.Picker = parent
	parent.Visible = false

	for i, v in ipairs({ "LeftSide", "RightSide" }) do
		local v: Instance = parent:FindFirstChild(v)

		if v and v:IsA("GuiObject") then
			local weaponName: Instance = v:FindFirstChild("WeaponName")
			local name = if weaponName and weaponName:IsA("TextLabel") then weaponName else nil
			local selectButton: Instance = v:FindFirstChild("SelectButton")
			local t14: {[any]: any} = {
				Root = v,
				Name = name,
				NameShadow = if name then name:FindFirstChildOfClass("TextLabel") else nil,
				Button = if selectButton and selectButton:IsA("TextButton") then selectButton else nil
			}

			t1.Cards[i] = t14

			if t14.Button then
				t14.Button.MouseButton1Click:Connect(function()
					t1.pressCard(i)
				end)
			end
		end
	end

	local header: Instance = parent:FindFirstChild("Header")

	if header then
		for _, v in ipairs(header:GetChildren()) do
			if v:IsA("TextLabel") then
				local stringFind = string.find
				local lowerText = string.lower(v.Text)

				if stringFind(lowerText, "congrat", 1, true) then
					t1.Kicker = v
				else
					t1.Title = v
					t1.TitleClaim = v.Text
				end
			end
		end
	end

	local clone: Instance = closeButton:Clone()

	clone.Name = "PickerClose"
	clone.AnchorPoint = Vector2.new(1, 0)
	clone.Position = UDim2.fromScale(0.97, 0.04)
	clone.Size = UDim2.fromScale(0.04, 0.08)
	clone.ZIndex = 60
	clone.Parent = parent
	clone.MouseButton1Click:Connect(t1.closePicker)
end

t1.buildPicker()
t1.PRIZE_BG = Color3.new(0.2, 0.2, 0.2)
t1.PRIZE_RAYS_T = 0.45
t1.RAINBOW_RIM_DPS = 60
t1.RAINBOW_BODY_DPS = 30
t1.RAYS_DPS = 18
t1.SpinGradients = {}
t1.SpinRays = {}
t1.Spin = nil

function t1.buildChoiceTiles()
	for _, v in ipairs({ "Free", "Premium" }) do
		local foundChild: Instance = canvas:FindFirstChild(v .. "Choose")

		if foundChild and foundChild:IsA("Frame") then
			if not foundChild:FindFirstChild("ClaimedCheck") and free1 then
				local claimedCheck: Instance = free1:FindFirstChild("ClaimedCheck")

				if claimedCheck then
					local clone: Instance = claimedCheck:Clone()

					clone.Parent = foundChild

					if clone:IsA("GuiObject") then
						clone.Visible = false
					end
				end
			end

			local icon: Instance = foundChild:FindFirstChild("Icon")
			local v714 = if icon and icon:IsA("ImageLabel") then icon else nil

			if v714 then
				v714.Size = UDim2.fromScale(1, 1)
			end

			local selectPrize: Instance = foundChild:FindFirstChild("SelectPrize")
			local lockedOverlay: Instance = foundChild:FindFirstChild("LockedOverlay")
			local claimedCheck: Instance = foundChild:FindFirstChild("ClaimedCheck")
			local t15: {[any]: any} = {
				Frame = foundChild,
				Icon = v714,
				MysteryImage = if v714 then v714.Image else "",
				Mystery = if v714 then v714:FindFirstChildOfClass("TextLabel") else nil,
				Select = if selectPrize and selectPrize:IsA("GuiButton") then selectPrize else nil,
				LockedOverlay = if lockedOverlay and lockedOverlay:IsA("GuiObject") then lockedOverlay else nil,
				Check = if claimedCheck and claimedCheck:IsA("ImageLabel") then claimedCheck else nil,
				Glow = ensureClaimGlow(foundChild),
				Sunburst = foundChild:FindFirstChild("Sunburst")
			}

			t1.choiceTiles[v] = t15

			local v719 = seasonPassCatalog.GetReward(t3.SeasonId, v, seasonPassConfigTierCount)

			if v719 and v719.Type ~= "Choice" and v719.Type ~= "Nothing" then
				local v720 = seasonPassCatalog.GetDisplay(v719).Rarity or v719.Tile or "Common"
				local uiGradient: Instance = foundChild:FindFirstChildOfClass("UIGradient")
				local v722 = findOutlineGradient(foundChild)
				local spikes: Instance = foundChild:FindFirstChild("Spikes")

				paintCardLook(uiGradient, v722, spikes, v720)

				local rarityGlow: Instance = foundChild:FindFirstChild("RarityGlow")

				if rarityGlow and rarityGlow:IsA("ImageLabel") then
					local v725 = rarity.GetColor(v720)
					local v726 = t5[v720]
					local color316

					if not v726 then
						color316 = v725
					else
						local v728, v729, v730 = v725:ToHSV()

						color316 = Color3.fromHSV(v726, v729, v730)
					end

					rarityGlow.ImageColor3 = color316
					rarityGlow.Visible = true
				end

				local sunburst = t15.Sunburst

				if sunburst and sunburst:IsA("GuiObject") then
					sunburst.Visible = false
				end

				t15.Sunburst = nil
				t15.Pill = ensureClaimPill(foundChild)
				t15.Scrim = ensureClaimScrim(foundChild)
				v720 = ensureButton(foundChild)
				v720.Active = false
				v720.Interactable = false
				t15.Hit = v720
				v720.MouseButton1Click:Connect(function()
					if t1.choiceStatus(v) then
						requestClaim(v, seasonPassConfigTierCount)
					end
				end)
			elseif v719 and v719.Type == "Choice" then
				if v714 then
					t15.MysteryImage = seasonPassCatalog.GetDisplay(v719).Icon
					v714.Image = t15.MysteryImage
					v714.ImageColor3 = Color3.new(1, 1, 1)
				end

				local mystery = t15.Mystery

				if mystery and mystery:IsA("GuiObject") then
					mystery.Visible = false
				end

				t15.Mystery = nil
				foundChild.BackgroundColor3 = t1.PRIZE_BG

				if t15.Sunburst then
					t15.Sunburst.ImageTransparency = t1.PRIZE_RAYS_T
				end

				local uiGradient: Instance = foundChild:FindFirstChildOfClass("UIGradient")

				if uiGradient then
					table.insert(t1.SpinGradients, { g = uiGradient, dps = t1.RAINBOW_BODY_DPS })
				end

				local t16: {[any]: any} = { (findOutlineGradient(foundChild)) }
				local v735 = t15.LockedOverlay

				if v735 and v735:IsA("Frame") then
					local v736 = findOutlineGradient(v735)

					table.insert(t16, v736)
				end

				for _, iterValue in ipairs(t16) do
					table.insert(t1.SpinGradients, { g = iterValue, dps = t1.RAINBOW_RIM_DPS })
				end
			end

			if t15.Select then
				t15.Select.Active = true
				t15.Select.Interactable = true
				t15.Select.MouseButton1Click:Connect(function()
					local v925 = seasonPassCatalog.GetReward(t3.SeasonId, v, seasonPassConfigTierCount)

					if v925 and v925.Type ~= "Choice" then
						if t1.choiceStatus(v) then
							requestClaim(v, seasonPassConfigTierCount)
						end

						return
					end

					t1.openPicker(v)
				end)
			end

			hoverInfoModule.bind(v53, foundChild, function()
				if not u57 then
					return nil
				end

				local v926 = seasonPassCatalog.GetReward(t3.SeasonId, v, seasonPassConfigTierCount)

				if not v926 then
					return nil
				end

				local v927 = t3.Chosen[v .. seasonPassConfigTierCount]
				local v928 = if v927 then t1.optionById(v926, v927) else nil

				v927 = seasonPassCatalog.GetDisplay(v928 or v926)

				local name = v927.Name
				local v930 = v927.Rarity or "Common"
				local v931 = t1.challengeNote(v)

				return { Name = name, Rarity = v930, Note = v931 }
			end)
		end
	end
end

t1.buildChoiceTiles()

for _, v in ipairs(scriptParent:GetDescendants()) do
	if v.Name == "Sunburst" and v:IsA("GuiObject") then
		table.insert(t1.SpinRays, v)
	end
end

function t1.setPrizeSpin(p118)
	if p118 and not t1.Spin and (#t1.SpinGradients > 0 or #t1.SpinRays > 0) then
		t1.Spin = runService.Heartbeat:Connect(function(deltaTime: number)
			for _, v in ipairs(t1.SpinGradients) do
				if v.g.Parent then
					v.g.Rotation = (v.g.Rotation + v.dps * deltaTime) % 360
				end
			end

			local n1 = t1.RAYS_DPS * deltaTime

			for _, v in ipairs(t1.SpinRays) do
				if v.Visible and v.Parent then
					v.Rotation = (v.Rotation + n1) % 360
				end
			end
		end)
	elseif not p118 and t1.Spin then
		t1.Spin:Disconnect()
		t1.Spin = nil
	end
end
function t1.refreshChoiceTiles()
	local n1: number = 0

	for k, v in pairs(t1.choiceTiles) do
		local v743 = seasonPassCatalog.GetReward(t3.SeasonId, k, seasonPassConfigTierCount)
		local u744: boolean = v743 ~= nil and v743.Type == "Choice"
		local u745: boolean = v743 ~= nil and not u744 and v743.Type ~= "Nothing"
		local visible: boolean = (if k == "Free" then t3.Claimed else t3.ClaimedPremium)[seasonPassConfigTierCount] == true
		local u747: boolean = k == "Premium" and not t3.Premium
		local u748 = (u744 or u745) and t1.choiceStatus(k)
		local v749, v750 = t1.challenge(k)
		local v751 = if u744 and not visible and not u747 and v750 and t3.Tier >= seasonPassConfigTierCount and v749 < v750 then string.format("%d/%d", v749, v750) else nil
		local v752 = t3.Chosen[k .. seasonPassConfigTierCount]
		local v753 = if u744 and visible and v752 then t1.optionById(v743, v752) else nil

		v752 = if u745 then v743 else v753

		if v.Icon then
			local vIcon = v.Icon
			local v755

			if v752 then
				v755 = seasonPassCatalog.GetDisplay(v752).Icon
			else
				v755 = v.MysteryImage
			end

			vIcon.Image = v755
		end

		local vMystery = v.Mystery
		local u757 = v752 == nil

		if vMystery and vMystery:IsA("GuiObject") then
			vMystery.Visible = u757
		end

		local vSunburst = v.Sunburst

		u757 = v753 == nil

		if vSunburst and vSunburst:IsA("GuiObject") then
			vSunburst.Visible = u757
		end

		local vCheck = v.Check

		if vCheck and vCheck:IsA("GuiObject") then
			vCheck.Visible = visible
		end

		local vLockedOverlay = v.LockedOverlay

		if vLockedOverlay and vLockedOverlay:IsA("GuiObject") then
			vLockedOverlay.Visible = u747
		end

		local vGlow = v.Glow

		if vGlow and vGlow:IsA("GuiObject") then
			vGlow.Visible = u748
		end

		local vSelect = v.Select

		u757 = if u745 then u748 and v.Pill == nil else u744 and not visible

		if vSelect and vSelect:IsA("GuiObject") then
			vSelect.Visible = u757
		end

		v752 = u745 and u748

		local vScrim = v.Scrim

		if vScrim and vScrim:IsA("GuiObject") then
			vScrim.Visible = v752
		end

		local vPill = v.Pill

		if vPill and vPill:IsA("GuiObject") then
			vPill.Visible = v752
		end

		if v752 and v.Pill then
			u79(v.Pill, "CLAIM")
		end

		if v.Hit then
			v.Hit.Active = v752
			v.Hit.Interactable = v752
		end

		if v.Select then
			for _, iterValue in ipairs(v.Select:GetDescendants()) do
				if iterValue:IsA("TextLabel") then
					iterValue.Text = if u745 then "Claim" else v751 or "Select"
				end
			end
		end

		if u748 then
			n1 += 1
		end
	end

	t1.renderPicker()

	return n1
end

local t9: {[any]: any} = {
	duration = 1,
	offsetStart = Vector2.new(-1.8, 0),
	offsetEnd = Vector2.new(1.8, 0)
}
local uiGradient: Instance = premiumBar:FindFirstChildOfClass("UIGradient")

replicatedStorage = premiumBar:FindFirstChild("Spikes")

local v147 = if replicatedStorage and replicatedStorage:IsA("ImageLabel") then replicatedStorage else nil
local u148 = Vector2.zero

if uiGradient then
	local v149 = math.rad(uiGradient.Rotation)
	local vector2New = Vector2.new
	local cosine = math.cos(v149)
	local sine = math.sin(v149)

	u148 = vector2New(cosine, sine)
end

local connection3 = nil
local u154 = nil
local u155 = nil
local n3 = 0
local u157: boolean = false
local u158 = nil
local u159 = nil
local n4: number = 0

local function setGoldDrift(p120)
	if p120 and not connection3 and uiGradient then
		local v768: Instance = uiGradient

		connection3 = runService.Heartbeat:Connect(function()
			local v938 = os.clock()
			local sine = math.sin(v938 * 0.966643893412244)

			v768.Offset = u148 * (sine * 0.12)
		end)
	elseif not p120 and connection3 then
		connection3:Disconnect()
		connection3 = nil

		local v769: Instance = uiGradient

		if v769 then
			v769.Offset = Vector2.zero
		end
	end
end
local function prepareStripes()
	if u157 then
		return
	end

	u157 = true

	local v770 = v147

	if not v770 or v770.ScaleType ~= Enum.ScaleType.Tile then
	elseif v770.Size.X.Offset == 0 and v770.Position.X.Offset == 0 and v770.TileSize.X.Offset == 0 then
		local scale = v770.Size.X.Scale
		local v772 = v770.TileSize.X.Scale

		if scale <= 0 or v772 <= 0 then
			return
		end

		local n1 = v772 * scale
		local n2 = n1 * 1
		local n4 = scale + n2

		v770.AnchorPoint = Vector2.new(0, v770.AnchorPoint.Y)
		v770.Size = UDim2.new(n4, 0, v770.Size.Y.Scale, v770.Size.Y.Offset)
		v770.TileSize = UDim2.new(n1 / n4, 0, v770.TileSize.Y.Scale, v770.TileSize.Y.Offset)
		v770.Position = UDim2.new(-n2, 0, v770.Position.Y.Scale, v770.Position.Y.Offset)
		n3 = -n2
		u155 = n2

		return
	end
end
local function cancelStripeTween()
	if u154 then
		u154:Cancel()
		u154 = nil
	end
end
local function parkStripes()
	local v776 = v147

	if v776 and u155 then
		v776.Position = UDim2.new(n3, 0, v776.Position.Y.Scale, v776.Position.Y.Offset)
	end
end
local function runStripeDrift(p121)
	local v778 = v147
	local v779 = u155

	if v778 and v779 then
		local v780 = v778
		local v781 = v779

		task.spawn(function()
			while n4 == p121 do
				task.wait(4.5)

				if n4 ~= p121 or not v780:IsDescendantOf(game) then
					return
				end

				local tweenInfo3 = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				local uDim2 = UDim2.new(n3 + v781, 0, v780.Position.Y.Scale, v780.Position.Y.Offset)
				local v942 = tweenService:Create(v780, tweenInfo3, { Position = uDim2 })

				u154 = v942
				v942:Play()
				v942.Completed:Wait()

				if n4 ~= p121 then
					return
				end

				u154 = nil
				v942 = v147

				if v942 and u155 then
					v942.Position = UDim2.new(n3, 0, v942.Position.Y.Scale, v942.Position.Y.Offset)
				end
			end
		end)

		return
	end
end
local function refreshAmbience()
	if u154 then
		u154:Cancel()
		u154 = nil
	end

	n4 += 1

	local v782: number = n4
	local v783 = u57 and buyButton.Interactable

	setGoldDrift(v783)

	if v783 then
		prepareStripes()

		local v784 = v147
		local v785 = u155

		if v784 and v785 then
			local v786 = v784
			local v787 = v785

			task.spawn(function()
				while n4 == v782 do
					task.wait(4.5)

					if n4 ~= v782 or not v786:IsDescendantOf(game) then
						return
					end

					local tweenInfo4 = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
					local uDim2 = UDim2.new(n3 + v787, 0, v786.Position.Y.Scale, v786.Position.Y.Offset)
					local v945 = tweenService:Create(v786, tweenInfo4, { Position = uDim2 })

					u154 = v945
					v945:Play()
					v945.Completed:Wait()

					if n4 ~= v782 then
						return
					end

					u154 = nil
					v945 = v147

					if v945 and u155 then
						v945.Position = UDim2.new(n3, 0, v945.Position.Y.Scale, v945.Position.Y.Offset)
					end
				end
			end)
		end
	else
		local v788 = v147

		if v788 and u155 then
			v788.Position = UDim2.new(n3, 0, v788.Position.Y.Scale, v788.Position.Y.Offset)
		end
	end

	if u158 then
		if u57 then
			u158.Visible = true

			if not u159 then
				u159 = shineEffect.loop(u158, t9)
			end
		else
			if u159 then
				u159()
				u159 = nil
			end

			u158.Visible = false
		end
	end

	setHighlightSpin(u57)
	t1.setPrizeSpin(u57)
end

buyButton:GetPropertyChangedSignal("Interactable"):Connect(refreshAmbience)
task.spawn(function()
	local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD", 30)

	if not hud then
		return
	end

	local events: Instance = hud:FindFirstChild("Events")
	local seasonPass: Instance = events and events:FindFirstChild("SeasonPass")
	local v792: Instance = seasonPass

	if v792 then
		v792 = seasonPass:FindFirstChild("Shine")
	end

	if not v792 or not v792:IsA("GuiObject") then
		return
	end

	local clone: Instance = v792:Clone()

	clone.Name = "PlateShine"
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.Size = UDim2.fromScale(1, 1)
	clone.ZIndex = 4
	clone.Active = false
	clone.Visible = false

	local uiGradient3: Instance = clone:FindFirstChildOfClass("UIGradient")

	if uiGradient3 then
		uiGradient3.Offset = t9.offsetStart
	end

	clone.Parent = premiumTrackIcon
	u158 = clone
	refreshAmbience()
end)

local tweenInfo5 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local panelPosition = panel.Position
local uDim2 = UDim2.new(panelPosition.X.Scale, panelPosition.X.Offset, panelPosition.Y.Scale + 1, panelPosition.Y.Offset)
local u171 = nil

replicatedStorage = panel:FindFirstChildOfClass("UIScale")

if replicatedStorage then
	replicatedStorage.Scale = 1
end

local function cancelActiveTween()
	if u171 then
		u171:Cancel()
		u171 = nil
	end
end
local function open()
	if u57 then
		return
	end

	u57 = true
	refreshAmbience()

	local ok, result = pcall(function()
		return seasonPass:InvokeServer("GetState")
	end)

	if ok and result then
		applyState(result)
	end

	if u171 then
		u171:Cancel()
		u171 = nil
	end

	panel.Position = uDim2
	panel.Visible = true

	local v797: Tween = tweenService:Create(panel, tweenInfo5, { Position = panelPosition })

	u171 = v797
	v797:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("BattlePass")
	activeWindowChanged:Fire("BattlePass")
end
local function close()
	if not u57 then
		return
	end

	u57 = false
	t8.reset()

	local v799 = n1

	n1 = v799

	local u800: boolean = false

	if v799 > 0 then
		u800 = u57
	end

	if u800 and not connection then
		connection = runService.Heartbeat:Connect(function()
			local v946 = os.clock()
			local imageTransparency = (math.sin(v946 * 3.9269908169872414) + 1) * 0.5 * -0.47 + 0.72

			for _, v in ipairs({ "Free", "Premium" }) do
				for i = 1, seasonPassConfigTierCount do
					local v951 = t2[v][i]
					local claimGlow = v951 and v951.ClaimGlow

					if claimGlow and claimGlow.Visible then
						claimGlow.ImageTransparency = imageTransparency
					end
				end

				local v953 = t1.choiceTiles[v]
				local glow = v953 and v953.Glow

				if glow and glow.Visible then
					glow.ImageTransparency = imageTransparency
				end
			end
		end)
	elseif not u800 and connection then
		connection:Disconnect()
		connection = nil
	end

	applyLobbyCues(v799)
	refreshAmbience()

	if giftPicker.IsOpen() then
		giftPicker.Close()
	end

	t1.closePicker()
	hoverInfoModule.hide(v53)

	if u171 then
		u171:Cancel()
		u171 = nil
	end

	v799 = tweenService:Create(panel, tweenInfo6, { Position = uDim2 })
	u171 = v799
	v799:Play()
	v799.Completed:Once(function()
		if not u57 then
			panel.Visible = false
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v802 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v802)
	windowBlur.hide("BattlePass")
end

panel.Visible = false
panel.Position = uDim2
activeWindowChanged.Event:Connect(function(p122)
	if p122 ~= "BattlePass" and u57 then
		close()
	end
end)
closeButton.MouseButton1Click:Connect(function()
	if u57 then
		close()
	end
end)
t1.LastPremiumPrompt = 0

local function requestPremium(p123)
	if not p123.Interactable then
		return
	end

	if t3.Premium then
		return
	end

	if seasonPassConfig.PremiumProductId == 0 then
		return
	end

	if os.clock() - t1.LastPremiumPrompt < 0.5 then
		return
	end

	t1.LastPremiumPrompt = os.clock()
	showPurchaseModal:Fire({
		Name = "Premium Pass",
		ProductId = seasonPassConfig.PremiumProductId,
		RobuxPrice = numberValue
	})
end

buyButton.MouseButton1Click:Connect(function()
	requestPremium(buyButton)
end)
icon.MouseButton1Click:Connect(function()
	requestPremium(icon)
end)

if parent then
	icon.MouseEnter:Connect(function()
		if not icon.Interactable then
			return
		end

		u47 = true
		applyUnlockFeel()
	end)
	icon.MouseLeave:Connect(function()
		u47 = false
		u48 = false
		applyUnlockFeel()
	end)
	icon.MouseButton1Down:Connect(function()
		if not icon.Interactable then
			return
		end

		u48 = true
		applyUnlockFeel()
	end)
	icon.MouseButton1Up:Connect(function()
		u48 = false
		applyUnlockFeel()
	end)
end

if parent and parent:IsA("GuiButton") then
	parent.MouseButton1Click:Connect(function()
		requestPremium(icon)
	end)
end

giftButton.Visible = false
giftButton.MouseButton1Click:Connect(function()
	if seasonPassConfig.GiftPremiumProductId == 0 then
		return
	end

	giftPicker.Open({
		displayName = "Premium Pass",
		productId = seasonPassConfig.GiftPremiumProductId,
		ownedBy = function(p124)
			return p124:GetAttribute("SeasonPassPremium") == true
		end,
		onOpen = function()
			panel.Visible = false
		end,
		onClose = function()
			if u57 then
				panel.Visible = true
			end
		end
	})
end)
skipButton.MouseButton1Click:Connect(function()
	if t3.Tier >= seasonPassConfigTierCount then
		return
	end

	local v805, v806 = seasonPassConfig.SkipCostForTier(t3.Tier)

	if v806 == 0 then
		return
	end

	local formattedText = string.format("Skip to Tier %d", t3.Tier + 1)

	showPurchaseModal:Fire({ ProductId = v806, Name = formattedText })
end)
LocalPlayer:GetAttributeChangedSignal("SeasonPassTier"):Connect(function()
	t3.Tier = LocalPlayer:GetAttribute("SeasonPassTier") or t3.Tier

	if u57 then
		local ok, result = pcall(function()
			return seasonPass:InvokeServer("GetState")
		end)

		if ok and result then
			applyState(result)

			return
		end
	else
		refreshAllTiles()

		local v810 = refreshProgress()

		refreshTrack(v810)
		refreshPremiumBar()
	end
end)
LocalPlayer:GetAttributeChangedSignal("SeasonPassXP"):Connect(function()
	t3.XP = LocalPlayer:GetAttribute("SeasonPassXP") or t3.XP

	local xpIntoTier, xpForTier = seasonPassConfig.TierProgress(t3.XP)

	t3.XpIntoTier = xpIntoTier
	t3.XpForTier = xpForTier
	refreshProgress()
end)
LocalPlayer:GetAttributeChangedSignal("SeasonPassPremium"):Connect(function()
	t3.Premium = LocalPlayer:GetAttribute("SeasonPassPremium") == true

	local ok, result = pcall(function()
		return seasonPass:InvokeServer("GetState")
	end)

	if ok and result then
		applyState(result)
	end
end)
LocalPlayer:GetAttributeChangedSignal("SeasonPassChallengeKills"):Connect(function()
	local seasonPassChallengeKey: any = LocalPlayer:GetAttribute("SeasonPassChallengeKey")
	local v816 = if type(seasonPassChallengeKey) == "string" then t3.Challenges[seasonPassChallengeKey] else nil

	if type(v816) == "table" then
		v816.Kills = LocalPlayer:GetAttribute("SeasonPassChallengeKills") or v816.Kills
		v816.Goal = LocalPlayer:GetAttribute("SeasonPassChallengeGoal") or v816.Goal
	end

	if u57 then
		local ok, result = pcall(function()
			return seasonPass:InvokeServer("GetState")
		end)

		if ok and result then
			applyState(result)

			return
		end
	else
		refreshAllTiles()

		local v819 = refreshProgress()

		refreshTrack(v819)
		refreshPremiumBar()
	end
end)
eventTimer.driveLabel(timerTextLabel, function()
	return seasonPassConfig.EndsAtUnix
end, {
	onUpdate = function(_, _)
		if textLabel then
			textLabel.Text = timerTextLabel.Text
		end
	end
})
v11:WaitForChild("ToggleSeasonPass").Event:Connect(function()
	if not seasonPassGate.IsEnabled() then
		return
	end

	if u57 then
		close()

		return
	end

	open()
end)
task.spawn(function()
	local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD", 30)
	local v823: Instance = hud

	if v823 then
		v823 = hud:FindFirstChild("Events")
	end

	local seasonPass: Instance = v823 and v823:FindFirstChild("SeasonPass")

	if seasonPass and (not not seasonPass:IsA("ImageButton") or not not seasonPass:IsA("TextButton")) then
		local v825 = seasonPassGate.IsEnabled()

		seasonPass.Visible = v825 and false

		if not v825 and u57 then
			close()
		end

		seasonPassGate.Changed():Connect(function()
			local v956 = seasonPassGate.IsEnabled()

			seasonPass.Visible = v956 and false

			if not v956 and u57 then
				close()
			end
		end)
		seasonPass.MouseButton1Click:Connect(function()
			if not seasonPassGate.IsEnabled() then
				return
			end

			if u57 then
				close()

				return
			end

			open()
		end)

		local shine: Instance = seasonPass:FindFirstChild("Shine")

		if shine then
			shineEffect.loop(shine, {
				duration = 1,
				offsetStart = Vector2.new(-1.8, 0),
				offsetEnd = Vector2.new(1.8, 0)
			})
		end

		local countdown: Instance = seasonPass:FindFirstChild("Countdown")

		if countdown and countdown:IsA("TextLabel") then
			eventTimer.driveLabel(countdown, function()
				return seasonPassConfig.EndsAtUnix
			end)
		end

		return
	end
end);
(function()
	local ok, result = pcall(function()
		return seasonPass:InvokeServer("GetState")
	end)

	if ok and result then
		applyState(result)
	end
end)()
