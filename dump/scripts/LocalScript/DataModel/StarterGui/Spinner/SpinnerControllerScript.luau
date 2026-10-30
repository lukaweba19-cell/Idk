-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local collectibleSerial = require(replicatedStorageShared:WaitForChild("CollectibleSerial"))
local v10: Instance = replicatedStorage:WaitForChild("Shared")
local nextItemSpoiler = require(v10:WaitForChild("NextItemSpoiler"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local v13: Instance = replicatedStorage:WaitForChild("Shared")
local caseStripSeq = require(v13:WaitForChild("CaseStripSeq"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local spr = require(util:WaitForChild("spr"))
local v18: Instance = replicatedStorage:WaitForChild("Shared")
local caseSpinFeel = require(v18:WaitForChild("CaseSpinFeel"))
local v20: Instance = replicatedStorage:WaitForChild("Shared")
local secretReveal = require(v20:WaitForChild("SecretReveal"))
local v22: Instance = replicatedStorage:WaitForChild("Shared")
local devilsSightReveal = require(v22:WaitForChild("DevilsSightReveal"))
local caseOpenFX: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("CaseOpenFX")
local t1: {[any]: any} = {
	RecruitCase = "RegularCase",
	FoundersCase = "PremiumCase",
	SpaceCase = "SpaceCase",
	HallowsCase = "HallowsCase",
	FinishersCase = "FinishersCase"
}
local n1: number = 0
local u27 = nil
local rarityColors = rarity.Colors

local function rarityColor(p1)
	return rarityColors[p1] or rarityColors.Common
end
local function formatNumber(p2)
	if p2 < 10000 then
		local floored = math.floor(p2)

		return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end

	if p2 < 1000000 then
		return string.format("%.1fK", p2 / 1000)
	end

	return string.format("%.1fM", p2 / 1000000)
end

local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local spinner: Instance = playerGui:WaitForChild("Spinner")
local hud: Instance = playerGui:WaitForChild("HUD")
local background: Instance = spinner:WaitForChild("Background")
local content: Instance = spinner:WaitForChild("Content")
local mainSpinWheel: Instance = content:WaitForChild("MainSpinWheel")
local nextItemSpoiler2: Instance = mainSpinWheel:FindFirstChild("NextItemSpoiler")
local mainSpinWheelSpinner: Instance = mainSpinWheel:WaitForChild("Spinner")
local skip: Instance = mainSpinWheel:WaitForChild("Skip")
local exit: Instance = mainSpinWheel:WaitForChild("Exit")
local buyMore: Instance = mainSpinWheel:WaitForChild("BuyMore")

buyMore.Visible = false

local title: Instance = content:WaitForChild("Title")
local slash: Instance = mainSpinWheel:WaitForChild("Slash")
local arrows: Instance = mainSpinWheel:WaitForChild("Arrows")

local function setBtnLabel(p3, text)
	local textLabel = p3:FindFirstChild("TextLabel")

	if textLabel then
		textLabel.Text = text

		for _, v in ipairs(textLabel:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end
	end
end

local gotItem: Instance = playerGui:WaitForChild("GotItem")
local gotItemContent: Instance = gotItem:WaitForChild("Content")
local got: Instance = gotItemContent:WaitForChild("Got")
local spikes: Instance = got:WaitForChild("Spikes")

got:WaitForChild("Icon")

local itemName: Instance = got:WaitForChild("ItemName")
local itemRarity: Instance = got:WaitForChild("ItemRarity")
local itemExist: Instance = got:WaitForChild("ItemExist")

got:FindFirstChildOfClass("UIStroke")

local close: Instance = gotItemContent:WaitForChild("Close")
local sunburst: Instance = gotItemContent:WaitForChild("Sunburst")
local sunburstImageColor3 = sunburst.ImageColor3
local ImageColor3 = nil
local glow: Instance = gotItemContent:FindFirstChild("Glow")

if glow and glow:IsA("ImageLabel") then
	ImageColor3 = glow.ImageColor3
end

local tapToClose: TextButton = Instance.new("TextButton")

tapToClose.Name = "TapToClose"
tapToClose.Text = ""
tapToClose.BackgroundTransparency = 1
tapToClose.Size = UDim2.fromScale(1, 1)
tapToClose.Position = UDim2.fromScale(0.5, 0.5)
tapToClose.AnchorPoint = Vector2.new(0.5, 0.5)
tapToClose.ZIndex = 99
tapToClose.Visible = false
tapToClose.Parent = gotItemContent
gotItem.Enabled = false

local connection = nil
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u62 = nil

local function showDarkBG()
	if u62 then
		u62:Cancel()
	end

	background.BackgroundTransparency = 1
	background.Visible = true
	u62 = tweenService:Create(background, tweenInfo, { BackgroundTransparency = 0.15 })
	u62:Play()
end
local function hideDarkBG()
	if u62 then
		u62:Cancel()
	end

	u62 = tweenService:Create(background, tweenInfo2, { BackgroundTransparency = 1 })
	u62:Play()
	u62.Completed:Once(function()
		if background.BackgroundTransparency >= 0.99 then
			background.Visible = false
		end
	end)
end
local function startRaysSpin()
	if connection then
		connection:Disconnect()
	end

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		sunburst.Rotation = sunburst.Rotation + 15 * deltaTime
	end)
end
local function stopRaysSpin()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	sunburst.Rotation = 0
end

local caseSpinFeelSpringDamping = caseSpinFeel.SpringDamping
local caseSpinFeelSpringFrequency = caseSpinFeel.SpringFrequency
local caseSpinFeelSkipDamping = caseSpinFeel.SkipDamping
local caseSpinFeelSkipFrequency = caseSpinFeel.SkipFrequency
local caseSpinFeelSnapTime = caseSpinFeel.SnapTime
local caseSpinFeelCentreCardScale = caseSpinFeel.CentreCardScale
local caseSpinFeelCentrePulseIn = caseSpinFeel.CentrePulseIn
local caseSpinFeelCentrePulseOut = caseSpinFeel.CentrePulseOut
local s1 = "Hidden"
local u76 = nil
local u77 = nil

if nextItemSpoiler2 then
	u77 = nextItemSpoiler.Bind(nextItemSpoiler2, function()
		local v143 = u76

		if not v143 or not v143.CrateId then
			return nil
		end

		local v144 = nextItemSpoiler.PeekCrate(v143.CrateId)

		if not v144 then
			return nil
		end

		v143 = nil

		if v144.FinisherName and v144.FinisherName ~= "" then
			v143 = "+ " .. v144.FinisherName
		end

		return {
			Name = v144.Name or v144.ItemId or "?",
			Rarity = v144.Rarity,
			Suffix = v143
		}
	end)
end

local u78 = nil
local u79: boolean = false
local u80: boolean = false
local n2: number = 0
local u82: boolean = false
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local n3 = -1
local __SpinnerSpringProxy: NumberValue = Instance.new("NumberValue")

__SpinnerSpringProxy.Name = "__SpinnerSpringProxy"
__SpinnerSpringProxy.Value = 0
__SpinnerSpringProxy.Parent = mainSpinWheelSpinner

local connection2 = nil
local sound2: Sound = Instance.new("Sound")

sound2.SoundId = "rbxassetid://114157584505971"
sound2.Volume = 1
sound2.Parent = spinner

local function pickRarity(p6)
	local n1 = 0

	for _, v in pairs(p6) do
		if typeof(v) == "number" and v > 0 then
			n1 += v
		end
	end

	if n1 <= 0 then
		return "Common"
	end

	local randomNumber = math.random()
	local n2 = 0

	for _, v in ipairs({ "Common", "Uncommon", "Rare", "Epic", "Legendary", "Secret" }) do
		local v153 = p6[v]

		if typeof(v153) == "number" and v153 > 0 then
			n2 += v153

			if n2 >= randomNumber * n1 then
				return v
			end
		end
	end

	return "Common"
end
local function pickUniform(p7, p8)
	local v156 = p7[p8]

	if typeof(v156) == "table" and #v156 ~= 0 then
		local randomNumber = math.random(1, #v156)

		return v156[randomNumber]
	end

	return nil
end
local function findEntry(p9, p10)
	local v160 = pickRarity(p10)
	local v161 = p9[v160]
	local v162 = if typeof(v161) == "table" and #v161 ~= 0 then v161[math.random(1, #v161)] else nil

	if not v162 then
		local t9: {[any]: any} = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Secret" }
		local n1 = 1

		for i, v in ipairs(t9) do
			if v == v160 then
				n1 = i

				break
			end
		end

		for i = 1, #t9 do
			local n2 = n1 - i
			local n3 = n1 + i
			local v170: boolean = n2 >= 1

			if v170 then
				local v171 = p9[t9[n2]]

				v162 = if typeof(v171) == "table" and #v171 ~= 0 then v171[math.random(1, #v171)] else nil
			end

			if not v170 or not v162 then
				if not (n3 <= #t9) then
					continue
				end

				local v172 = p9[t9[n3]]

				v162 = if typeof(v172) == "table" and #v172 ~= 0 then v172[math.random(1, #v172)] else nil

				if not v162 then
					continue
				end

				v160 = t9[n3]

				break
			end

			v160 = t9[n2]

			break
		end
	end

	local s1 = "rbxasset://textures/ui/GuiImagePlaceholder.png"

	v161 = "???"

	if v162 then
		if typeof(v162.Icon) == "string" and v162.Icon ~= "" then
			s1 = v162.Icon
		end

		v161 = v162.Name or v162.ItemId or "???"
	end

	return v160, s1, v161
end
local function buildRaffle(p11, p12, p13)
	table.clear(t2)

	local randomNumber = math.random(60, 110)
	local n1 = randomNumber + 1

	for _ = 1, randomNumber do
		local v180, v181, name = findEntry(p11.PublicPools, p11.RarityOdds)

		table.insert(t2, { IsWinner = false, Rarity = v180, Icon = v181, Name = name })
	end

	local s1 = "rbxasset://textures/ui/GuiImagePlaceholder.png"

	if typeof(p12.Icon) == "string" and p12.Icon ~= "" then
		s1 = p12.Icon
	end

	table.insert(t2, {
		IsWinner = true,
		Rarity = p12.Rarity,
		Icon = s1,
		Name = p12.Name or p12.ItemId or "Reward"
	})

	for _ = 1, 6 do
		local v185, v186, v187 = findEntry(p11.PublicPools, p11.RarityOdds)

		table.insert(t2, { IsWinner = false, Rarity = v185, Icon = v186, Name = v187 })
	end

	local crateId = p11.CrateId

	if typeof(crateId) == "string" and typeof(p13) == "number" then
		local v189 = caseStripSeq.Neighbourhood(crateId, p13)

		if v189 then
			for k, v in pairs(v189) do
				local v192 = t2[n1 + k]

				if v192 and not v192.IsWinner then
					v192.Rarity = v.Rarity
					v192.Icon = v.Icon
					v192.Name = v.Name
				end
			end
		end
	end

	for _, v in ipairs(t2) do
		if secretReveal.ShouldMask(v.Rarity) then
			v.Icon = secretReveal.MASK_ICON
			v.Name = secretReveal.MASK_NAME
		end
	end

	return n1
end

local caseSpinFeelCardHeightScale = caseSpinFeel.CardHeightScale
local n4 = caseSpinFeel.CardGapPerCard * caseSpinFeelCardHeightScale / 7.6

local function getCardWidth()
	return mainSpinWheelSpinner.AbsoluteSize.Y * caseSpinFeelCardHeightScale
end
local function getCardSpacing()
	return mainSpinWheelSpinner.AbsoluteSize.X * n4
end
local function getCardStride()
	return mainSpinWheelSpinner.AbsoluteSize.Y * caseSpinFeelCardHeightScale + mainSpinWheelSpinner.AbsoluteSize.X * n4
end
local function arrowCenterFraction()
	return arrows.AbsolutePosition.X + arrows.AbsoluteSize.X * 0.5 - mainSpinWheelSpinner.AbsolutePosition.X
end

local frame = nil

local function ensureCardPool()
	for _, v in ipairs(mainSpinWheelSpinner:GetChildren()) do
		if v.Name == "ItemTemplate" and v:IsA("GuiObject") then
			v.Visible = false
		end
	end

	if frame then
		return
	end

	local uiListLayout: Instance = mainSpinWheelSpinner:FindFirstChildOfClass("UIListLayout")

	if uiListLayout then
		uiListLayout.Parent = nil
	end

	frame = Instance.new("Frame")
	frame.Name = "__VirtualStrip"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.ClipsDescendants = false
	frame.Parent = mainSpinWheelSpinner

	local uiListLayout2: UIListLayout = Instance.new("UIListLayout")

	uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(n4, 0)
	uiListLayout2.Parent = frame

	for i = 1, 12 do
		local parent = uiFramework.createItemCell("Common", { icon = "rbxasset://textures/ui/GuiImagePlaceholder.png" })

		parent.Name = "__VCard"
		parent.LayoutOrder = i
		parent.Size = UDim2.fromScale(1, caseSpinFeelCardHeightScale)
		parent.AnchorPoint = Vector2.new(0, 0)
		parent.Visible = false
		parent.Parent = frame

		local uiAspectRatioConstraint = parent:FindFirstChildOfClass("UIAspectRatioConstraint")

		if not uiAspectRatioConstraint then
			uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint.Parent = parent
		end

		uiAspectRatioConstraint.AspectRatio = 1
		uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height

		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Scale = 1
		uiScale.Parent = parent
		t4[parent] = uiScale
		table.insert(t3, parent)
	end
end
local function renderVirtualList(p14)
	if frame and #t3 ~= 0 and #t2 ~= 0 then
		local v204 = t3[1].AbsoluteSize.X

		if v204 <= 0 then
			v204 = mainSpinWheelSpinner.AbsoluteSize.Y * caseSpinFeelCardHeightScale

			if v204 <= 0 then
				return
			end
		end

		local n1 = v204 + mainSpinWheelSpinner.AbsoluteSize.X * n4

		frame.Position = UDim2.new(0, arrows.AbsolutePosition.X + arrows.AbsoluteSize.X * 0.5 - mainSpinWheelSpinner.AbsolutePosition.X - p14 % n1 - 5 * n1 - v204 * 0.5, 0, 0)

		local n2 = math.floor(p14 / n1 + 0.5) + 1
		local floored = math.floor(p14 / n1)

		for i, v in ipairs(t3) do
			local n5 = floored - 6 + 1 + i

			if n5 < 1 or n5 > #t2 then
				v.Visible = false
			else
				v.Visible = true

				if v:GetAttribute("__DataIndex") ~= n5 then
					v:SetAttribute("__DataIndex", n5)

					local v211 = t2[n5]
					local v212 = t4[v]

					t4[v] = nil
					v212 = uiFramework.createItemCell(v211.Rarity, { icon = v211.Icon })
					v212.Name = "__VCard"
					v212.LayoutOrder = i
					v212.Size = UDim2.fromScale(1, caseSpinFeelCardHeightScale)
					v212.AnchorPoint = Vector2.new(0, 0)
					v212.Visible = true
					v212:SetAttribute("__DataIndex", n5)
					v212:SetAttribute("__DisplayName", v211.Name)

					local uiAspectRatioConstraint = v212:FindFirstChildOfClass("UIAspectRatioConstraint")

					if not uiAspectRatioConstraint then
						uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
						uiAspectRatioConstraint.Parent = v212
					end

					uiAspectRatioConstraint.AspectRatio = 1
					uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height

					local uiScale = v212:FindFirstChildWhichIsA("UIScale")

					if not uiScale then
						uiScale = Instance.new("UIScale")
					end

					uiScale.Scale = if n5 == n2 then caseSpinFeelCentreCardScale else 1
					uiScale.Parent = v212
					t4[v212] = uiScale
					v:Destroy()
					v212.Parent = frame
					t3[i] = v212
					v = v212
				end

				local v215 = t4[v]

				if v215 then
					if n5 ~= n2 then
						if v215.Scale > 1.001 then
							tweenService:Create(v215, caseSpinFeelCentrePulseOut, { Scale = 1 }):Play()
						end
					elseif v215.Scale < caseSpinFeelCentreCardScale - 0.001 then
						tweenService:Create(v215, caseSpinFeelCentrePulseIn, { Scale = caseSpinFeelCentreCardScale }):Play()
					end
				end
			end
		end

		if n2 ~= n3 then
			n3 = n2
			sound2:Play()

			local v216 = t2[n2]

			if v216 then
				title.Text = v216.Name

				local dropShadow: Instance = title:FindFirstChild("DropShadow")

				if dropShadow then
					dropShadow.Text = v216.Name
				end
			end
		end

		return
	end
end
local function cleanupVirtualList()
	for _, v in ipairs(t3) do
		v:Destroy()
	end

	table.clear(t3)
	table.clear(t4)
	n3 = -1

	if frame then
		frame:Destroy()
		frame = nil
	end

	if not mainSpinWheelSpinner:FindFirstChildOfClass("UIListLayout") then
		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0.02, 0)
		uiListLayout.Parent = mainSpinWheelSpinner
	end

	for _, v in ipairs(mainSpinWheelSpinner:GetChildren()) do
		if v.Name == "ItemTemplate" and v:IsA("GuiObject") then
			v.Visible = true
		end
	end
end

local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t5: {[any]: any} = { HighGain = -80, MidGain = -80, LowGain = -10 }
local t6: {[any]: any} = { HighGain = 0, MidGain = 0, LowGain = 0 }
local t7: {[any]: any} = {}

for _, v in ipairs({ "BGMusic", "MusicShop", "MusicPad" }) do
	local v: Instance = workspace:FindFirstChild(v)

	if v and v:IsA("Sound") then
		table.insert(t7, v)
	end
end

local function applyMusicEQ()
	for _, v in ipairs(t7) do
		local __CaseOpenEQ = v:FindFirstChild("__CaseOpenEQ")

		if not __CaseOpenEQ then
			__CaseOpenEQ = Instance.new("EqualizerSoundEffect")
			__CaseOpenEQ.Name = "__CaseOpenEQ"
			__CaseOpenEQ.HighGain = 0
			__CaseOpenEQ.MidGain = 0
			__CaseOpenEQ.LowGain = 0
			__CaseOpenEQ.Parent = v
		end

		tweenService:Create(__CaseOpenEQ, tweenInfo3, t5):Play()
	end
end
local function releaseMusicEQ()
	for _, v in ipairs(t7) do
		local __CaseOpenEQ = v:FindFirstChild("__CaseOpenEQ")

		if __CaseOpenEQ then
			local v229: Tween = tweenService:Create(__CaseOpenEQ, tweenInfo3, t6)

			v229.Completed:Once(function()
				if __CaseOpenEQ and __CaseOpenEQ.Parent then
					__CaseOpenEQ:Destroy()
				end
			end)
			v229:Play()
		end
	end
end

local u113 = nil
local u114 = nil
local u115 = nil

local function showGotItem(p15)
	if u27 then
		caseOpenFX:FireServer("Reveal", { Token = u27 })
		u27 = nil
	end

	local text = p15.Rarity or "Common"
	local v232 = p15.Name or p15.ItemId or "Reward"
	local v233 = typeof(p15.Icon) == "string" and p15.Icon ~= "" and p15.Icon or ""
	local __RarityCell: Instance = got:FindFirstChild("__RarityCell")

	if __RarityCell then
		__RarityCell:Destroy()
	end

	for _, v in ipairs(got:GetChildren()) do
		if v:IsA("UIStroke") or v:IsA("UIGradient") then
			v.Enabled = false
		elseif v.Name == "Spikes" or v.Name == "Icon" then
			v.Visible = false
		end
	end

	got.BackgroundTransparency = 1

	local v237 = uiFramework.createItemCell(text, { icon = v233 })

	v237.Name = "__RarityCell"
	v237.Size = UDim2.fromScale(1, 1)
	v237.Position = UDim2.fromScale(0, 0)
	v237.AnchorPoint = Vector2.new(0, 0)
	v237.ZIndex = 1
	v237.Parent = got

	local __FinisherBonusCell: Instance = gotItemContent:FindFirstChild("__FinisherBonusCell")

	if __FinisherBonusCell then
		__FinisherBonusCell:Destroy()
	end

	local __FinisherBonusTitleLabel: Instance = gotItemContent:FindFirstChild("__FinisherBonusTitleLabel")
	local __FinisherBonusLabel: Instance = gotItemContent:FindFirstChild("__FinisherBonusLabel")

	if p15.Finisher and p15.Finisher ~= "" then
		local parent, v242 = uiFramework.createItemCell(p15.FinisherRarity or "Common", { icon = p15.FinisherIcon or "" })

		parent.Name = "__FinisherBonusCell"
		parent.Size = UDim2.fromScale(0.22, 0.22)
		parent.Position = UDim2.fromScale(0.74, 0.5)
		parent.AnchorPoint = Vector2.new(0.5, 0.5)
		parent.ZIndex = 5
		parent.Parent = gotItemContent

		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Scale = 0
		uiScale.Parent = parent
		task.delay(0.3, function()
			local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			tweenService:Create(uiScale, tweenInfo4, { Scale = 1 }):Play()
		end)

		if __FinisherBonusTitleLabel then
			__FinisherBonusTitleLabel.Visible = true
			__FinisherBonusTitleLabel.Text = if p15.BonusIsWeapon then "Weapon:" else "Kill Effect:"
		end

		if __FinisherBonusLabel then
			__FinisherBonusLabel.Text = p15.FinisherName or p15.Finisher or ""
			rarity.ApplyTextGradient(__FinisherBonusLabel, p15.FinisherRarity or "Common")
			__FinisherBonusLabel.Visible = true
		end
	else
		if __FinisherBonusTitleLabel then
			__FinisherBonusTitleLabel.Visible = false
		end

		if __FinisherBonusLabel then
			__FinisherBonusLabel.Visible = false
		end
	end

	itemName.ZIndex = 10
	itemName.Text = v232
	itemRarity.ZIndex = 10
	itemRarity.Text = text

	local v244 = rarityColors[text] or rarityColors.Common

	itemRarity.BackgroundColor3 = v244
	itemRarity.TextColor3 = v244
	itemExist.ZIndex = 10
	v237 = collectibleSerial.Format(p15.Serial, p15.MaxSupply)

	local globalCopies = p15.GlobalCopies

	if v237 then
		itemExist.Text = v237
		itemExist.Visible = true
	elseif typeof(globalCopies) == "number" and globalCopies > 0 then
		itemExist.Text = formatNumber(globalCopies) .. " exist"
		itemExist.Visible = true
	else
		itemExist.Visible = false
	end

	sunburst.ImageColor3 = uiFramework.applyRarityColor(sunburstImageColor3, text)

	local glow2: Instance = gotItemContent:FindFirstChild("Glow")

	if glow2 then
		glow2.ImageColor3 = uiFramework.applyRarityColor(ImageColor3, text)
	end

	spikes.ImageColor3 = v244

	if not p15.__SkipGotSting then
		sound:Play("Crate." .. text, workspace)
	end

	local finisherRarity = p15.FinisherRarity

	if p15.Finisher and typeof(finisherRarity) == "string" then
		local t10: {[any]: any} = {
			Common = 1,
			Uncommon = 1.05,
			Rare = 1.1,
			Epic = 1.15,
			Legendary = 1.2,
			Secret = 1.5,
			Exclusive = 1.5
		}

		sound:Play("Misc.BonusFX", workspace, nil, t10[finisherRarity] or 1)
	end

	close.Visible = false
	tapToClose.Visible = false
	gotItemContent.BackgroundTransparency = 1
	gotItem.Enabled = true
	title.Visible = false

	local tweenInfo5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(gotItemContent, tweenInfo5, { BackgroundTransparency = 0.2 }):Play()

	local uiScale = got:FindFirstChildOfClass("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = got
	end

	uiScale.Scale = 0.4

	local tweenInfo6 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(uiScale, tweenInfo6, { Scale = 1 }):Play()

	if connection then
		connection:Disconnect()
	end

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		sunburst.Rotation = sunburst.Rotation + 15 * deltaTime
	end)

	if u113 then
		task.cancel(u113)
	end

	u113 = task.defer(function()
		close.Visible = true
		tapToClose.Visible = true
	end)
end
local function u117()
	tapToClose.Visible = false
	close.Visible = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	sunburst.Rotation = 0

	local __FinisherBonusCell: Instance = gotItemContent:FindFirstChild("__FinisherBonusCell")

	if __FinisherBonusCell then
		__FinisherBonusCell:Destroy()
	end

	local __FinisherBonusTitleLabel: Instance = gotItemContent:FindFirstChild("__FinisherBonusTitleLabel")

	if __FinisherBonusTitleLabel then
		__FinisherBonusTitleLabel.Visible = false
	end

	local __FinisherBonusLabel: Instance = gotItemContent:FindFirstChild("__FinisherBonusLabel")

	if __FinisherBonusLabel then
		__FinisherBonusLabel.Visible = false
	end

	if u113 then
		task.cancel(u113)
		u113 = nil
	end

	if not u115 then
		u115 = got.Position
	end

	local tweenInfo7 = TweenInfo.new(0.175, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local v256 = u115
	local v257 = UDim2.fromScale(0, 1)
	local v258: Tween = tweenService:Create(got, tweenInfo7, { Position = v256 + v257 })
	local tweenInfo8 = TweenInfo.new(0.175, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v260: Tween = tweenService:Create(gotItemContent, tweenInfo8, { BackgroundTransparency = 1 })

	v258:Play()
	v260:Play()
	v258.Completed:Once(function()
		gotItem.Enabled = false
		title.Visible = true
		got.Position = u115

		if u114 then
			u114()
		end
	end)
end

tapToClose.MouseButton1Click:Connect(function()
	u117()
end)

local function setSpinnerScreen(enabled)
	spinner.Enabled = enabled
	hud.Enabled = not enabled
	LocalPlayer:SetAttribute("_SpinnerOpen", if enabled then true else nil)
end
local function setMode(p18, p19)
	s1 = p18

	if nextItemSpoiler2 and s1 ~= "Result" then
		nextItemSpoiler2.Visible = false
	end

	if s1 == "Hidden" then
		spinner.Enabled = false
		hud.Enabled = true
		LocalPlayer:SetAttribute("_SpinnerOpen", nil)

		if not p19 then
			hideDarkBG()
		end

		return
	end

	spinner.Enabled = true
	hud.Enabled = false
	LocalPlayer:SetAttribute("_SpinnerOpen", true)

	if not p19 then
		showDarkBG()
	end

	if s1 == "Spinning" then
		setBtnLabel(skip, "Skip")
		skip.Visible = true
		exit.Visible = false
		buyMore.Visible = false
	elseif s1 == "Result" then
		skip.Visible = false
		exit.Visible = false
		buyMore.Visible = false
	end
end

u114 = function()
	if s1 ~= "Result" then
		return
	end

	if u79 then
		closeSpinner()

		return
	end

	local n1 = 0
	local v265 = u76

	if v265 and v265.GetRemaining then
		local ok, result = pcall(v265.GetRemaining)

		if ok and typeof(result) == "number" then
			local floored = math.floor(result)

			n1 = math.max(0, floored)
		end
	end

	if n1 > 0 and v265 ~= nil and v265.RequestRoll ~= nil then
		setBtnLabel(skip, string.format("Open Again (x%d)", n1))
		skip.Visible = true
		buyMore.Visible = false

		if u77 then
			u77:Refresh()
		end
	else
		skip.Visible = false
		buyMore.Visible = true
	end

	exit.Visible = true
end

function closeSpinner(p20, p21)
	n2 += 1

	if not p21 and u82 then
		u82 = false
		releaseMusicEQ()
	end

	u117()
	spr.stop(__SpinnerSpringProxy)

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	cleanupVirtualList()
	table.clear(t2)
	u76 = nil
	u78 = nil
	u80 = false
	u79 = false
	u27 = nil
	setMode("Hidden", p20)
end

local mainSpinWheelPosition = mainSpinWheel.Position
local titlePosition = title.Position
local skipPosition = skip.Position
local caseSpinFeelIntroRiseTime = caseSpinFeel.IntroRiseTime
local caseSpinFeelIntroSlashTime = caseSpinFeel.IntroSlashTime
local caseSpinFeelIntroButtonSwoopTime = caseSpinFeel.IntroButtonSwoopTime

local function playIntroAnimation()
	skip.Visible = false
	exit.Visible = false
	slash.Visible = false
	buyMore.Visible = false
	background.BackgroundTransparency = 1
	background.Visible = true

	local tweenInfo9 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(background, tweenInfo9, { BackgroundTransparency = 0.15 }):Play()
	mainSpinWheel.Position = UDim2.new(mainSpinWheelPosition.X.Scale, 0, 1.5, 0)

	local tweenInfo10 = TweenInfo.new(caseSpinFeelIntroRiseTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(mainSpinWheel, tweenInfo10, { Position = mainSpinWheelPosition }):Play()
	title.Position = UDim2.new(titlePosition.X.Scale, 0, -0.2, 0)

	local tweenInfo11 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(title, tweenInfo11, { Position = titlePosition }):Play()
	task.wait(caseSpinFeelIntroRiseTime)
	slash.Visible = true
	slash.Position = UDim2.new(-0.3, 0, -0.022, 0)
	slash.ImageTransparency = 0

	local tweenInfo12 = TweenInfo.new(caseSpinFeelIntroSlashTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local v275: Tween = tweenService:Create(slash, tweenInfo12, { Position = UDim2.new(1.3, 0, -0.022, 0) })

	v275:Play()
	sound:Play("Misc.RollSlash", workspace)
	v275.Completed:Wait()
	slash.Visible = false
	setBtnLabel(skip, "Skip")
	skip.Position = UDim2.new(-1, 0, skipPosition.Y.Scale, 0)
	skip.Visible = true

	local tweenInfo13 = TweenInfo.new(caseSpinFeelIntroButtonSwoopTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(skip, tweenInfo13, { Position = skipPosition }):Play()
	exit.Visible = false
	task.wait(caseSpinFeelIntroButtonSwoopTime)
end

local u127: boolean = false

local function runSpin(p22, p23, p24)
	if not u82 then
		u82 = true
		applyMusicEQ()
	end

	n2 += 1

	local v280: number = n2

	u80 = false
	n3 = -1
	u76 = p22
	u78 = p23

	local randomNumber = math.random(1, 2147483646)
	local crateId = p22.CrateId

	if typeof(crateId) == "string" and not u79 then
		n1 += 1
		u27 = n1
		caseOpenFX:FireServer("Begin", {
			Token = u27,
			Model = t1[crateId] or "RegularCase",
			Intro = not p24,
			CrateId = crateId,
			Seed = randomNumber,
			Reward = { Rarity = p23.Rarity, Icon = p23.Icon, Name = p23.Name or p23.ItemId }
		})
	else
		u27 = nil
	end

	spr.stop(__SpinnerSpringProxy)

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	local dropShadow: Instance = title:FindFirstChild("DropShadow")

	title.Text = p22.CrateName or p22.CrateId or "Spinner"

	if dropShadow then
		dropShadow.Text = title.Text
	end

	s1 = "Spinning"
	spinner.Enabled = true
	hud.Enabled = false
	LocalPlayer:SetAttribute("_SpinnerOpen", true)

	local v284 = buildRaffle(p22, p23, randomNumber)

	ensureCardPool()
	__SpinnerSpringProxy.Value = 0
	task.defer(function()
		if #t2 > 0 then
			local n1 = mainSpinWheelSpinner.AbsoluteSize.Y * caseSpinFeelCardHeightScale + mainSpinWheelSpinner.AbsoluteSize.X * n4
			local value = if n1 > 0 then n1 * 6 else 0

			__SpinnerSpringProxy.Value = value
			renderVirtualList(value)
			title.Text = p22.CrateName or p22.CrateId or "Spinner"

			if dropShadow then
				dropShadow.Text = title.Text
			end
		end
	end)

	if not p24 then
		playIntroAnimation()
	else
		setBtnLabel(skip, "Skip")
		skip.Visible = true
		exit.Visible = false
	end

	if v280 ~= n2 then
		return
	end

	for _ = 1, 3 do
		runService.Heartbeat:Wait()
	end

	local n6 = mainSpinWheelSpinner.AbsoluteSize.Y * caseSpinFeelCardHeightScale + mainSpinWheelSpinner.AbsoluteSize.X * n4
	local randomNumber2 = math.random()
	local value = n6 * 6
	local n7 = (v284 - 1) * n6 + (randomNumber2 - 0.5) * n6 * 0.3

	__SpinnerSpringProxy.Value = value
	renderVirtualList(value)

	local u290: boolean = false
	local u291 = nil
	local u292: boolean = false
	local n8 = value
	local n5: number = 0

	spr.target(__SpinnerSpringProxy, caseSpinFeelSpringDamping, caseSpinFeelSpringFrequency, { Value = n7 })

	local function doFinalSnap()
		if u292 then
			return
		end

		u292 = true
		spr.stop(__SpinnerSpringProxy)

		local value = (v284 - 1) * n6
		local tweenInfo14 = TweenInfo.new(caseSpinFeelSnapTime, Enum.EasingStyle.Linear)
		local v331: Tween = tweenService:Create(__SpinnerSpringProxy, tweenInfo14, { Value = value })

		v331:Play()

		local connection = runService.Heartbeat:Connect(function()
			renderVirtualList(__SpinnerSpringProxy.Value)
		end)

		v331.Completed:Once(function()
			if connection then
				connection:Disconnect()
			end

			renderVirtualList(value)

			if v280 ~= n2 then
				return
			end

			local text = p23.Name or p23.ItemId or "Reward"

			if devilsSightReveal.Handles(p23) then
				skip.Visible = false

				if u291 and not u291.Destroyed then
					u291:FadeOut(0.4)
					u291 = nil
				end

				task.spawn(function()
					devilsSightReveal.Play(p23, {
						onReveal = function()
							if u27 then
								caseOpenFX:FireServer("Reveal", { Token = u27 })
								u27 = nil
							end
						end
					})

					if v280 ~= n2 then
						return
					end

					title.Text = text

					if dropShadow then
						dropShadow.Text = text
					end

					setMode("Result")

					if u114 then
						u114()
					end
				end)

				return
			end

			if secretReveal.ShouldMask(p23.Rarity) then
				title.Text = secretReveal.MASK_NAME

				if dropShadow then
					dropShadow.Text = title.Text
				end

				skip.Visible = false

				if u291 and not u291.Destroyed then
					u291:FadeOut(0.4)
					u291 = nil
				end

				task.spawn(function()
					secretReveal.Play(p23, {
						onReveal = function()
							if u27 then
								caseOpenFX:FireServer("Reveal", { Token = u27 })
								u27 = nil
							end
						end
					})

					if v280 ~= n2 then
						return
					end

					title.Text = text

					if dropShadow then
						dropShadow.Text = text
					end

					setMode("Result")

					if u114 then
						u114()
					end
				end)

				return
			end

			title.Text = text

			if dropShadow then
				dropShadow.Text = text
			end

			setMode("Result")
			showGotItem(p23)
		end)
	end

	connection2 = runService.Heartbeat:Connect(function(deltaTime: number)
		if v280 ~= n2 then
			return
		end

		if u292 then
			return
		end

		n5 += deltaTime

		if u80 then
			u80 = false
			skip.Visible = false

			if u291 and not u291.Destroyed then
				u291:FadeOut(0.45)
				u291 = nil
			end

			spr.target(__SpinnerSpringProxy, caseSpinFeelSkipDamping, caseSpinFeelSkipFrequency, { Value = n7 })
			task.delay(0.175, function()
				if v280 ~= n2 then
					return
				end

				doFinalSnap()
			end)
		end

		local __SpinnerSpringProxyValue: number = __SpinnerSpringProxy.Value

		renderVirtualList(__SpinnerSpringProxyValue)

		if not u290 and math.abs(n7 - value) > 0 and math.abs(n7 - __SpinnerSpringProxyValue) / math.abs(n7 - value) < 0.015 then
			u290 = true

			if p23.Rarity == "Legendary" then
				u291 = sound:Play("Misc.PreLegendary", workspace)
			elseif p23.Rarity == "Secret" then
				u291 = sound:Play("Misc.PreSecret", workspace)
			end
		end

		local absoluteValue = math.abs(__SpinnerSpringProxyValue - n8)
		local v336 = math.max(deltaTime, 0.001)

		n8 = __SpinnerSpringProxyValue

		local absoluteValue2 = math.abs(__SpinnerSpringProxyValue - n7)

		if n5 > 1.5 and absoluteValue2 < n6 * 1.5 and absoluteValue / v336 < 8 then
			doFinalSnap()
		elseif n5 > 10 then
			warn("[Spinner] Timeout — forcing snap")
			doFinalSnap()

			return
		end
	end)
end

skip.MouseButton1Click:Connect(function()
	if s1 == "Hidden" then
		return
	end

	if s1 == "Spinning" then
		u80 = true
		skip.Visible = false

		return
	end

	if s1 ~= "Result" then
		return
	end

	if u127 then
		return
	end

	if gotItem.Enabled then
		tapToClose.Visible = false
		close.Visible = false

		if connection then
			connection:Disconnect()
			connection = nil
		end

		sunburst.Rotation = 0

		if u113 then
			task.cancel(u113)
			u113 = nil
		end

		gotItem.Enabled = false
		title.Visible = true

		if u115 then
			got.Position = u115
		end
	end

	local v296 = u76

	if not v296 or not v296.RequestRoll then
		return
	end

	local n1 = 0

	if v296.GetRemaining then
		local ok, result = pcall(v296.GetRemaining)

		if ok and typeof(result) == "number" then
			local floored = math.floor(result)

			n1 = math.max(0, floored)
		end
	end

	if n1 <= 0 then
		skip.Visible = false

		return
	end

	sound:Play("Misc.OpenAgain", workspace)
	u127 = true
	s1 = "Spinning"

	if nextItemSpoiler2 and s1 ~= "Result" then
		nextItemSpoiler2.Visible = false
	end

	if s1 == "Hidden" then
		spinner.Enabled = false
		hud.Enabled = true
		LocalPlayer:SetAttribute("_SpinnerOpen", nil)
	else
		spinner.Enabled = true
		hud.Enabled = false
		LocalPlayer:SetAttribute("_SpinnerOpen", true)

		if s1 == "Spinning" then
			setBtnLabel(skip, "Skip")
			skip.Visible = true
			exit.Visible = false
			buyMore.Visible = false
		elseif s1 == "Result" then
			skip.Visible = false
			exit.Visible = false
			buyMore.Visible = false
		end
	end

	title.Text = v296.CrateName or v296.CrateId or "Spinner"

	local dropShadow: Instance = title:FindFirstChild("DropShadow")

	if dropShadow then
		dropShadow.Text = title.Text
	end

	task.wait(0.05)
	n1 = function()
		local v338, v339, v340, v341 = pcall(function()
			return v296.RequestRoll()
		end)

		if not v338 then
			return false, "InvokeFailed", nil
		end

		return v339 == true, v340, v341
	end

	local v302, v303, v304, v305 = pcall(function()
		return v296.RequestRoll()
	end)

	local u306
	local s3
	local v308

	if not v302 then
		u306 = false
		s3 = "InvokeFailed"
		v308 = nil
	else
		u306 = v303 == true
		s3 = v304
		v308 = v305
	end

	local u309 = u306
	local v310 = s3
	local v311 = v308

	if not u309 and v310 ~= "NoRequestRoll" then
		task.wait(0.15)

		local v312, v313, v314, v315 = pcall(function()
			return v296.RequestRoll()
		end)

		local u316
		local s2
		local v318

		if not v312 then
			u316 = false
			s2 = "InvokeFailed"
			v318 = nil
		else
			u316 = v313 == true
			s2 = v314
			v318 = v315
		end

		u309 = u316
		v310 = s2
		v311 = v318
	end

	if u309 and typeof(v311) == "table" then
		closeSpinner(true, true)
		u127 = false
		runSpin(v296, v311, true)

		return
	end

	warn("[CrateSpinner] OpenAgain failed:", v310)
	u127 = false
	setMode("Result")
end)
exit.MouseButton1Click:Connect(function()
	if s1 == "Hidden" or s1 == "Spinning" then
		return
	end

	closeSpinner()
end)
background.Visible = false
background.BackgroundTransparency = 1
setMode("Hidden")
spinner.Enabled = false

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local openCrate: Instance = bindables:WaitForChild("OpenCrate")
local openShop: Instance = bindables:WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")
local t8: {[any]: any} = {
	RecruitCase = "RegularCase",
	HallowsCase = "PremiumCase",
	FinishersCase = "FinishersCase"
}

buyMore.MouseButton1Click:Connect(function()
	local v319 = u76
	local crateId = v319 and v319.CrateId

	v319 = crateId and t8[crateId]
	closeSpinner()
	shopOpenAnalytics:FireServer("SpinnerBuyMore", v319 or crateId)

	if v319 then
		openShop:Fire("Cases", v319)

		return
	end

	openShop:Fire("Cases")
end)
openCrate.Event:Connect(function(p26)
	if typeof(p26) == "table" then
		if typeof(p26.CrateId) == "string" then
			if typeof(p26.Reward) == "table" then
				local reward = p26.Reward

				if typeof(reward.Rarity) == "string" then
					if typeof(reward.ItemType) == "string" then
						if typeof(reward.ItemId) == "string" then
							u79 = p26.AutoCloseAfterReveal == true
							runSpin(p26, reward)

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end

		return
	end
end)

local showGotItem2: Instance = bindables:FindFirstChild("ShowGotItem")

if showGotItem2 then
	showGotItem2.Event:Connect(function(p27)
		if typeof(p27) == "table" then
			showGotItem(p27)

			return
		end
	end)
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	if LocalPlayer:GetAttribute("InMatch") == true and spinner.Enabled then
		closeSpinner()
	end
end)
