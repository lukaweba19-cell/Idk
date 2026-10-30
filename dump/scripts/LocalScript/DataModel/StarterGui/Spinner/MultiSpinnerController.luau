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
local hoverInfoModule = require(shared:WaitForChild("HoverInfoModule"))
local caseSpinFeel = require(shared:WaitForChild("CaseSpinFeel"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local secretReveal = require(shared:WaitForChild("SecretReveal"))
local devilsSightReveal = require(shared:WaitForChild("DevilsSightReveal"))
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local openCrateMulti: Instance = bindables:WaitForChild("OpenCrateMulti")
local caseOpenFX: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("CaseOpenFX")
local t1: {[any]: any} = {
	RecruitCase = "RegularCase",
	FoundersCase = "PremiumCase",
	SpaceCase = "SpaceCase",
	HallowsCase = "HallowsCase",
	FinishersCase = "FinishersCase"
}
local t2: {[any]: any} = {
	RecruitCase = "RegularCase",
	HallowsCase = "PremiumCase",
	FinishersCase = "FinishersCase"
}
local n1: number = 500000000
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local scriptParent: Instance = script.Parent
local hud: Instance = playerGui:WaitForChild("HUD")
local background: Instance = scriptParent:WaitForChild("Background")
local content: Instance = scriptParent:WaitForChild("Content")
local mainSpinWheel: Instance = content:WaitForChild("MainSpinWheel")
local title: Instance = content:WaitForChild("Title")
local skip: Instance = mainSpinWheel:WaitForChild("Skip")
local t3: {[any]: any} = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Secret" }
local t4: {[any]: any} = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Secret = 6,
	Collectible = 7
}
local caseSpinFeelCardHeightScale = caseSpinFeel.CardHeightScale
local caseSpinFeelCardGapPerCard = caseSpinFeel.CardGapPerCard
local caseSpinFeelCentreCardScale = caseSpinFeel.CentreCardScale
local caseSpinFeelSnapTime = caseSpinFeel.SnapTime
local u34: boolean = false
local t5: {[any]: any} = {}

local function rarityColor(p1)
	local rarityColors = rarity.Colors

	return rarityColors[p1] or rarityColors.Common
end
local function setBtnLabel(p2, text)
	local textLabel = p2:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel2 = textLabel:FindFirstChild("TextLabel")

		if textLabel2 and textLabel2:IsA("TextLabel") then
			textLabel2.Text = text
		end
	end
end
local function tween(p4, p5, p6, p7, p8, p9)
	local tweenInfo = TweenInfo.new(p5, p7 or Enum.EasingStyle.Quad, p8 or Enum.EasingDirection.Out, 0, false, p9 or 0)
	local v166: Tween = tweenService:Create(p4, tweenInfo, p6)

	v166:Play()

	return v166
end
local function onScreen(p10)
	local v168 = p10

	while v168 and not v168:IsA("LayerCollector") do
		if v168:IsA("GuiObject") and not v168.Visible then
			return false
		end

		v168 = v168.Parent
	end

	return v168 ~= nil and v168.Enabled == true
end
local function screenCentre(p11)
	local v170 = p11:FindFirstAncestorWhichIsA("LayerCollector")

	return (if v170 and v170:IsA("ScreenGui") then v170.AbsolutePosition else Vector2.zero) + p11.AbsolutePosition + p11.AbsoluteSize * 0.5
end
local function pickRarity(p12)
	local n1 = 0

	for _, v in pairs(p12) do
		if typeof(v) == "number" and v > 0 then
			n1 += v
		end
	end

	if n1 <= 0 then
		return "Common"
	end

	local randomNumber = math.random()
	local n2 = 0

	for _, v in ipairs(t3) do
		local v179 = p12[v]

		if typeof(v179) == "number" and v179 > 0 then
			n2 += v179

			if n2 >= randomNumber * n1 then
				return v
			end
		end
	end

	return "Common"
end
local function pickUniform(p13, p14)
	local v182 = p13[p14]

	if typeof(v182) == "table" and #v182 ~= 0 then
		local randomNumber = math.random(1, #v182)

		return v182[randomNumber]
	end

	return nil
end
local function fillerCard(p15)
	local t11 = p15.PublicPools or {}
	local v186 = pickRarity(p15.RarityOdds or {})
	local v187 = t11[v186]
	local v188 = if typeof(v187) == "table" and #v187 ~= 0 then v187[math.random(1, #v187)] else nil

	if not v188 then
		local n1 = 1

		for i, v in ipairs(t3) do
			if v == v186 then
				n1 = i

				break
			end
		end

		for i = 1, #t3 do
			local n2 = n1 - i
			local n3 = n1 + i
			local v195: boolean = n2 >= 1

			if v195 then
				local v196 = t11[t3[n2]]

				v188 = if typeof(v196) == "table" and #v196 ~= 0 then v196[math.random(1, #v196)] else nil
			end

			if not v195 or not v188 then
				if not (n3 <= #t3) then
					continue
				end

				local v197 = t11[t3[n3]]

				v188 = if typeof(v197) == "table" and #v197 ~= 0 then v197[math.random(1, #v197)] else nil

				if not v188 then
					continue
				end

				v186 = t3[n3]

				break
			end

			v186 = t3[n2]

			break
		end
	end

	local s1 = "rbxasset://textures/ui/GuiImagePlaceholder.png"

	v187 = "???"

	if v188 then
		if typeof(v188.Icon) == "string" and v188.Icon ~= "" then
			s1 = v188.Icon
		end

		v187 = v188.Name or v188.ItemId or "???"
	end

	if secretReveal.ShouldMask(v186) then
		s1 = secretReveal.MASK_ICON
		v187 = secretReveal.MASK_NAME
	end

	return { Rarity = v186, Icon = s1, Name = v187 }
end
local function rewardIcon(p16)
	if typeof(p16.Icon) == "string" and p16.Icon ~= "" then
		return p16.Icon
	end

	return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

local u45 = nil

local function ensureRaffle(p17, p18)
	local raffle = p17.raffle

	while p18 > #raffle do
		local v203 = fillerCard(u45)

		table.insert(raffle, v203)
	end
end

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t6: {[any]: any} = {}

for _, v in ipairs({ "BGMusic", "MusicShop", "MusicPad" }) do
	local v: Instance = workspace:FindFirstChild(v)

	if v and v:IsA("Sound") then
		table.insert(t6, v)
	end
end

local function applyMusicEQ()
	for _, v in ipairs(t6) do
		local __CaseOpenEQ = v:FindFirstChild("__CaseOpenEQ")

		if not __CaseOpenEQ then
			local __CaseOpenEQ2: EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

			__CaseOpenEQ2.Name = "__CaseOpenEQ"
			__CaseOpenEQ2.HighGain = 0
			__CaseOpenEQ2.MidGain = 0
			__CaseOpenEQ2.LowGain = 0
			__CaseOpenEQ2.Parent = v
			__CaseOpenEQ = __CaseOpenEQ2
		end

		tweenService:Create(__CaseOpenEQ, tweenInfo, { HighGain = -80, MidGain = -80, LowGain = -10 }):Play()
	end
end
local function releaseMusicEQ()
	for _, v in ipairs(t6) do
		local __CaseOpenEQ = v:FindFirstChild("__CaseOpenEQ")

		if __CaseOpenEQ then
			local v211: Tween = tweenService:Create(__CaseOpenEQ, tweenInfo, { HighGain = 0, MidGain = 0, LowGain = 0 })

			v211.Completed:Once(function()
				if __CaseOpenEQ.Parent then
					__CaseOpenEQ:Destroy()
				end
			end)
			v211:Play()
		end
	end
end

local __MultiContent: Frame = Instance.new("Frame")

__MultiContent.Name = "__MultiContent"
__MultiContent.BackgroundTransparency = 1
__MultiContent.Size = UDim2.fromScale(1, 1)
__MultiContent.ZIndex = 5
__MultiContent.Visible = false
__MultiContent.Parent = scriptParent

local rows: Frame = Instance.new("Frame")

rows.Name = "Rows"
rows.BackgroundTransparency = 1
rows.AnchorPoint = Vector2.new(0.5, 0)
rows.Position = UDim2.fromScale(0.5, 0.115)
rows.Size = UDim2.fromScale(1.05, 0.76)
rows.ZIndex = 1
rows.Parent = __MultiContent

local viewport: Frame = Instance.new("Frame")

viewport.Name = "Viewport"
viewport.BackgroundTransparency = 1
viewport.Size = UDim2.fromScale(1, 1)
viewport.ClipsDescendants = true
viewport.ZIndex = 1
viewport.Parent = rows

local fused: Frame = Instance.new("Frame")

fused.Name = "Fused"
fused.BackgroundTransparency = 1
fused.Size = UDim2.fromScale(1, 1)
fused.ZIndex = 50
fused.Parent = rows

local __Spare: Folder = Instance.new("Folder")

__Spare.Name = "__Spare"
__Spare.Parent = __MultiContent

local clone: Instance = title:Clone()

clone.Name = "MultiTitle"
clone.AnchorPoint = Vector2.new(0.5, 0)
clone.Position = UDim2.fromScale(0.5, 0.02)
clone.Size = UDim2.fromScale(1, 0.075)
clone.Visible = true
clone.ZIndex = 2
clone.Parent = __MultiContent

local clonePosition = clone.Position

local function setTitle(text)
	clone.Text = text

	local dropShadow: Instance = clone:FindFirstChild("DropShadow")

	if dropShadow and dropShadow:IsA("TextLabel") then
		dropShadow.Text = text
	end
end

local v62 = UDim2.fromScale(0.5, 0.94)
local v63 = UDim2.fromScale(0.5, 1.25)

local function sizeButton(parent, aspectRatio)
	parent.AnchorPoint = Vector2.new(0.5, 0.5)
	parent.Size = UDim2.fromScale(0.17, 0.07)
	parent.Position = v63
	parent.ZIndex = 3
	parent.Visible = false

	for _, v in ipairs(parent:GetChildren()) do
		if v:IsA("UIAspectRatioConstraint") then
			v:Destroy()
		end
	end

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = aspectRatio
	uiAspectRatioConstraint.Parent = parent
end

local clone2: Instance = skip:Clone()

clone2.Name = "MultiSkip"

local n2 = skip.Size.X.Scale * 6.4
local v67 = math.max(skip.Size.Y.Scale, 0.01)

sizeButton(clone2, n2 / v67)

local textLabel: Instance = clone2:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	textLabel.Text = "Skip"

	local textLabel3: Instance = textLabel:FindFirstChild("TextLabel")

	if textLabel3 and textLabel3:IsA("TextLabel") then
		textLabel3.Text = "Skip"
	end
end

clone2.Parent = __MultiContent

local multiBuyContainer: Instance = hud:FindFirstChild("MultiBuyContainer")
local confirm: Instance = multiBuyContainer and multiBuyContainer:FindFirstChild("CONFIRM", true)

n2 = confirm and confirm:IsA("GuiButton")

local clone3

if n2 then
	clone3 = confirm:Clone()
else
	clone3 = skip:Clone()
	clone3.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
end

clone3.Name = "ClaimAll"
sizeButton(clone3, 4.2)

local textLabel4 = clone3:FindFirstChild("TextLabel")

if textLabel4 and textLabel4:IsA("TextLabel") then
	textLabel4.Text = "Claim All"

	local textLabel5 = textLabel4:FindFirstChild("TextLabel")

	if textLabel5 and textLabel5:IsA("TextLabel") then
		textLabel5.Text = "Claim All"
	end
end

clone3.Parent = __MultiContent

local clone4: Instance = skip:Clone()

clone4.Name = "MultiOpenAgain"
sizeButton(clone4, 4.2)

local textLabel6: Instance = clone4:FindFirstChild("TextLabel")

if textLabel6 and textLabel6:IsA("TextLabel") then
	textLabel6.Text = "Open More"

	local textLabel7: Instance = textLabel6:FindFirstChild("TextLabel")

	if textLabel7 and textLabel7:IsA("TextLabel") then
		textLabel7.Text = "Open More"
	end
end

clone4.Parent = __MultiContent

local u78 = nil
local buyMore: Instance = mainSpinWheel:FindFirstChild("BuyMore")

if buyMore and buyMore:IsA("GuiButton") then
	local clone5: Instance = buyMore:Clone()

	clone5.Name = "MultiBuyMore"
	sizeButton(clone5, 4.2)

	local textLabel8: Instance = clone5:FindFirstChild("TextLabel")

	if textLabel8 and textLabel8:IsA("TextLabel") then
		textLabel8.Text = "Buy More"

		local textLabel9: Instance = textLabel8:FindFirstChild("TextLabel")

		if textLabel9 and textLabel9:IsA("TextLabel") then
			textLabel9.Text = "Buy More"
		end
	end

	clone5.Parent = __MultiContent
	u78 = clone5
end

local sound2: Sound = Instance.new("Sound")

sound2.SoundId = "rbxassetid://114157584505971"
sound2.Volume = 1
sound2.Parent = scriptParent

local n3 = 0

v67 = function(p22)
	local v220 = os.clock()

	if v220 - n3 < 0.035 then
		return
	end

	n3 = v220
	sound2.PlaybackSpeed = p22 * 0.018 + 0.94
	sound2:Play()
end

local u85 = nil

local function getHoverState()
	if not u85 then
		u85 = hoverInfoModule.create(scriptParent)
	end

	return u85
end

local u87 = nil
local vector2 = Vector2.new(0.95, 0.8)

local function getRowTemplate()
	if u87 then
		return u87
	end

	local clone6: Instance = mainSpinWheel:Clone()

	for _, v in ipairs({ "Skip", "Exit", "BuyMore", "Slash", "NextItemSpoiler" }) do
		local v2: Instance = clone6:FindFirstChild(v)

		if v2 then
			v2:Destroy()
		end
	end

	local uiAspectRatioConstraint: Instance = clone6:FindFirstChildOfClass("UIAspectRatioConstraint")

	if uiAspectRatioConstraint then
		uiAspectRatioConstraint:Destroy()
	end

	local spinner: Instance = clone6:FindFirstChild("Spinner")

	for _, v in ipairs(spinner:GetChildren()) do
		if not v:IsA("UIStroke") and not v:IsA("UIGradient") and not v:IsA("UICorner") then
			v:Destroy()
		end
	end

	spinner.ClipsDescendants = false
	vector2 = Vector2.new(spinner.Size.X.Scale, spinner.Size.Y.Scale)

	for _, v in ipairs(clone6:GetChildren()) do
		if v:IsA("GuiObject") and (v.Name == "Arrows" or v.Name == "Glow") and v.Size.Y.Scale > 0 then
			local uiAspectRatioConstraint2: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			uiAspectRatioConstraint2.AspectRatio = v.Size.X.Scale * 6.4 / v.Size.Y.Scale
			uiAspectRatioConstraint2.Parent = v
		end
	end

	clone6.Name = "MultiRow"
	clone6.AnchorPoint = Vector2.new(0.5, 0.5)
	clone6.Visible = true
	u87 = clone6

	return clone6
end

local t7: {[any]: any} = {}
local t8: {[any]: any} = {}

local function acquireCell(p23, p24)
	local v234 = t7[p23]
	local v235 = v234 and table.remove(v234)

	if v235 then
		v235.api:setIcon(p24)
		v235.scale.Scale = 1

		return v235
	end

	local parent, v237 = uiFramework.createItemCell(p23, { active = false, selectable = false, interactable = false, icon = p24 })

	parent.Name = "__MCard"
	parent.AnchorPoint = Vector2.new(0.5, 0.5)

	local uiAspectRatioConstraint = parent:FindFirstChildOfClass("UIAspectRatioConstraint")

	if uiAspectRatioConstraint then
		uiAspectRatioConstraint:Destroy()
	end

	local uiScale = parent:FindFirstChildWhichIsA("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
	end

	uiScale.Scale = 1
	uiScale.Parent = parent
	v234 = { cell = parent, api = v237, rarity = p23, scale = uiScale }
	table.insert(t8, v234)

	return v234
end
local function releaseCell(p25)
	p25.cell.Visible = false
	p25.cell.ZIndex = 1
	p25.cell.Rotation = 0
	p25.cell.Parent = __Spare

	local t12 = t7[p25.rarity]

	if not t12 then
		t12 = {}
		t7[p25.rarity] = t12
	end

	table.insert(t12, p25)
end
local function destroyPool()
	for _, v in ipairs(t8) do
		pcall(function()
			v.api:destroy()
		end)

		if v.cell.Parent then
			v.cell:Destroy()
		end
	end

	table.clear(t8)
	table.clear(t7)
end

local n4: number = 0
local s1: string = "Hidden"
local t9: {[any]: any} = {}
local t10: {[any]: any} = {}
local connection = nil
local connection2 = nil
local u101 = nil
local u102 = nil
local n5 = 0
local n6 = 0
local n7 = 0
local n8 = 1
local n9 = 5
local n10 = 3
local n11 = 1
local n12 = 0

local function rowMetrics(_)
	local v245: number = n9
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n1 = rowsAbsoluteSize.Y * 0.014
	local v248 = math.min((rowsAbsoluteSize.Y - n1 * (v245 - 1)) / v245, rowsAbsoluteSize.X / 6.4)

	return v248, n1, (rowsAbsoluteSize.Y - (v245 * v248 + (v245 - 1) * n1)) * 0.5
end
local function easeOutBack(p27)
	return (p27 - 1) ^ 3 * 2.70158 + 1 + (p27 - 1) ^ 2 * 1.70158
end
local function layoutRows(p28, p29)
	if #t9 == 0 then
		return
	end

	local v252: number = n9
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n1 = rowsAbsoluteSize.Y * 0.014
	local v255 = math.min((rowsAbsoluteSize.Y - n1 * (v252 - 1)) / v252, rowsAbsoluteSize.X / 6.4)
	local v256 = v255
	local n2 = (rowsAbsoluteSize.Y - (v252 * v255 + (v252 - 1) * n1)) * 0.5
	local x = rows.AbsoluteSize.X
	local v259 = math.min(1, (p29 or 1) * 10)

	for i, v in ipairs(t9) do
		v.homeY = n2 + (i - 1) * (v256 + n1) - n6
		v.frame.Size = UDim2.fromOffset(x, v256)

		local v262 = math.clamp((p28 - v.revealAt) / 0.35, 0, 1)
		local n3 = (v.slideFrom - 0.5) * (1 - ((v262 - 1) ^ 3 * 2.70158 + 1 + (v262 - 1) ^ 2 * 1.70158)) + 0.5

		v262 = p28 - v.thumpAt

		local n4 = if v262 >= 0 and v262 < 0.6 then math.sin(v262 * 38) * math.exp(-v262 * 8) * v256 * v.thumpAmp else 0

		v.frame.Position = UDim2.new(n3, 0, 0, v.homeY + v256 * 0.5 + n4)
		v.frame.Visible = v.revealed
		v.focus = v.focus + ((if i == n11 then 1 else 0) - v.focus) * v259

		local vFocus = v.focus

		v.rs.Scale = vFocus * 0 + 1
		v.dim.BackgroundTransparency = 1 - (1 - vFocus) * 0.35
	end
end
local function rowOnScreen(p30)
	local v267 = p30.revealed

	if v267 then
		v267 = false

		if p30.homeY + p30.frame.Size.Y.Offset > 0 then
			v267 = p30.homeY < rows.AbsoluteSize.Y
		end
	end

	return v267
end
local function finalMetrics(p31)
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n1 = caseSpinFeelCardGapPerCard * 1.4
	local v271 = math.min(rowsAbsoluteSize.X * 0.9 / (p31 + (p31 - 1) * n1 + 0.8), rowsAbsoluteSize.Y * 0.2)
	local n2 = v271 * n1
	local n3 = (p31 * v271 + (p31 - 1) * n2) / vector2.X + v271

	return v271, n2, rowsAbsoluteSize.X, v271 / (caseSpinFeelCardHeightScale * vector2.Y)
end
local function claimHome(p32)
	return UDim2.new(0.5, 0, 0, rows.AbsolutePosition.Y - __MultiContent.AbsolutePosition.Y + rows.AbsoluteSize.Y * 0.5 + p32 * 0.75)
end
local function resultTitlePos(p33)
	local __MultiContentAbsoluteSize: Vector2 = __MultiContent.AbsoluteSize
	local uiAspectRatioConstraint: Instance = mainSpinWheel:FindFirstChildOfClass("UIAspectRatioConstraint")
	local v278 = if uiAspectRatioConstraint then uiAspectRatioConstraint.AspectRatio else 6.4
	local v279 = math.min(mainSpinWheel.Size.X.Scale * __MultiContentAbsoluteSize.X, mainSpinWheel.Size.Y.Scale * __MultiContentAbsoluteSize.Y * v278)
	local n1 = title.Size.Y.Scale * __MultiContentAbsoluteSize.Y
	local v281 = math.max(4, 0.5 * __MultiContentAbsoluteSize.Y - v279 / v278 * 0.5 - (title.Position.Y.Scale * __MultiContentAbsoluteSize.Y + n1))

	return UDim2.new(0.5, 0, 0, rows.AbsolutePosition.Y - __MultiContent.AbsolutePosition.Y + rows.AbsoluteSize.Y * 0.5 - p33 * 0.5 - v281 - n1)
end
local function finalSlotCentre(p34, p35, p36, p37)
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize

	return Vector2.new(rowsAbsoluteSize.X * 0.5 + (p34 - (p35 + 1) * 0.5) * (p36 + p37), rowsAbsoluteSize.Y * 0.5)
end

local u119 = nil
local u120: boolean = false

local function againLeft(p38)
	if p38 and typeof(p38.GetRemaining) == "function" and typeof(p38.RequestMore) == "function" then
		local ok, result = pcall(p38.GetRemaining)

		if ok and typeof(result) == "number" then
			local floored = math.floor(result)

			return (math.max(0, floored))
		end

		return -1
	end

	return -1
end
local function againBatch(p39, p40)
	local typeName: string = typeof(p39.Count)
	local floored = math.floor(if typeName == "number" then p39.Count else #t10)
	local v295 = math.min(floored, p40)

	return (math.clamp(v295, 1, 10))
end
local function placeResultButtons(p41, p42)
	local uDim2 = UDim2.new(0.5, 0, 0, rows.AbsolutePosition.Y - __MultiContent.AbsolutePosition.Y + rows.AbsoluteSize.Y * 0.5 + p41 * 0.75)
	local __MultiContentAbsoluteSize: Vector2 = __MultiContent.AbsoluteSize
	local v300 = math.min(__MultiContentAbsoluteSize.Y * 0.07, __MultiContentAbsoluteSize.X * 0.17 / 4.2)

	local function place(p43, p44, p45)
		p43.AnchorPoint = Vector2.new(0.5, 0.5)

		if p42 then
			p43.Position = UDim2.new(-1, 0, p44.Y.Scale, p44.Y.Offset)

			local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, p45 or 0)

			tweenService:Create(p43, tweenInfo2, { Position = p44 }):Play()

			return
		end

		p43.Position = p44
	end

	place(clone3, uDim2, 0.1)

	local v302 = u119

	if v302 then
		local v303 = UDim2.fromOffset(0, v300 * 1.2)

		place(v302, uDim2 + v303, 0.16)
	end
end
local function showResultButtons(p46)
	clone4.Visible = false

	if u78 then
		u78.Visible = false
	end

	u119 = nil

	local v305 = u102
	local v306 = againLeft(v305)

	if v306 > 0 then
		local typeName: string = typeof(v305.Count)
		local floored = math.floor(if typeName == "number" then v305.Count else #t10)
		local v309 = math.min(floored, v306)
		local text = ("Open %d More"):format((math.clamp(v309, 1, 10)))
		local textLabel10: Instance = clone4:FindFirstChild("TextLabel")

		if textLabel10 and textLabel10:IsA("TextLabel") then
			textLabel10.Text = text

			local textLabel11: Instance = textLabel10:FindFirstChild("TextLabel")

			if textLabel11 and textLabel11:IsA("TextLabel") then
				textLabel11.Text = text
			end
		end

		u119 = clone4
	elseif v306 == 0 and u78 then
		u119 = u78
	end

	placeResultButtons(p46, true)
	clone3.Visible = true
	v306 = u119

	if v306 then
		v306.Visible = true
	end
end
local function renderRow(p47, p48)
	local v315 = p47.revealed

	if v315 then
		v315 = false

		if p47.homeY + p47.frame.Size.Y.Offset > 0 then
			v315 = p47.homeY < rows.AbsoluteSize.Y
		end
	end

	if not v315 then
		for k, v in pairs(p47.slots) do
			v.cell.Visible = false
			v.cell.ZIndex = 1
			v.cell.Rotation = 0
			v.cell.Parent = __Spare

			local t13 = t7[v.rarity]

			if not t13 then
				t13 = {}
				t7[v.rarity] = t13
			end

			table.insert(t13, v)
			p47.slots[k] = nil
		end

		return
	end

	local absoluteSize = p47.box.AbsoluteSize
	local v320 = math.max(p47.rs.Scale, 0.01)
	local n1 = absoluteSize.X / v320
	local n2 = absoluteSize.Y / v320

	if n1 <= 0 or n2 <= 0 then
		return
	end

	v320 = n2 * caseSpinFeelCardHeightScale
	n2 = v320 * (1 + caseSpinFeelCardGapPerCard)

	local n6 = n1 * 0.5
	local roundedUp = math.ceil((n6 + v320) / n2)
	local n4 = math.floor(p47.offset + 0.5) + 1
	local v326 = math.max(1, n4 - roundedUp)
	local raffle = p47.raffle

	while n4 + roundedUp + 1 > #raffle do
		local v328 = fillerCard(u45)

		table.insert(raffle, v328)
	end

	local n5 = n4 + roundedUp

	p47.hi = math.max(p47.hi, n5)

	local absoluteValue = math.abs(v320 - p47.cardSize)

	p47.cardSize = v320

	for k, v in pairs(p47.slots) do
		if v326 > k or n5 < k then
			v.cell.Visible = false
			v.cell.ZIndex = 1
			v.cell.Rotation = 0
			v.cell.Parent = __Spare

			local t14 = t7[v.rarity]

			if not t14 then
				t14 = {}
				t7[v.rarity] = t14
			end

			table.insert(t14, v)
			p47.slots[k] = nil
		end
	end

	local v334 = math.min(1, p48 * 25)

	for i = v326, n5 do
		local v336 = p47.slots[i]

		if not v336 then
			local v337 = p47.raffle[i]

			v336 = acquireCell(v337.Rarity, v337.Icon)
			v336.cell.Size = UDim2.fromOffset(v320, v320)
			v336.cell.Parent = p47.box
			v336.cell.Visible = true
			p47.slots[i] = v336
		elseif absoluteValue > 0.5 then
			v336.cell.Size = UDim2.fromOffset(v320, v320)
		end

		v336.cell.Position = UDim2.new(0, n6 + (i - 1 - p47.offset) * n2, 0.5, 0)

		if p47.phase ~= "Landed" then
			local scale = v336.scale

			scale.Scale = scale.Scale + ((if i == n4 then caseSpinFeelCentreCardScale else 1) - v336.scale.Scale) * v334
		end
	end

	if n4 ~= p47.centre then
		local u339: boolean = p47.centre < 0

		p47.centre = n4

		if not u339 and p47.phase ~= "Waiting" then
			local index = p47.index
			local v341 = os.clock()

			if v341 - n3 < 0.035 then
				return
			end

			n3 = v341
			sound2.PlaybackSpeed = index * 0.018 + 0.94
			sound2:Play()

			return
		end

		return
	end
end
local function makeRow(layoutOrder, p50)
	local clone7 = getRowTemplate():Clone()

	clone7.LayoutOrder = layoutOrder
	clone7.ZIndex = 10
	clone7.Visible = false
	clone7.Parent = viewport

	local spinner = clone7:FindFirstChild("Spinner")
	local glow = clone7:FindFirstChild("Glow")
	local v347 = clone7:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale")

	v347.Parent = clone7

	local __Dim: Frame = Instance.new("Frame")

	__Dim.Name = "__Dim"
	__Dim.BackgroundColor3 = Color3.new(0, 0, 0)
	__Dim.BackgroundTransparency = 1
	__Dim.BorderSizePixel = 0
	__Dim.Size = UDim2.fromScale(1, 1)
	__Dim.ZIndex = 30
	__Dim.Parent = clone7

	return {
		index = layoutOrder,
		frame = clone7,
		box = spinner,
		glow = glow,
		glowBase = glow and glow.ImageColor3 or nil,
		raffle = {},
		winner = 1,
		reward = p50,
		slots = {},
		cardSize = 0,
		offset = 0,
		fromOffset = 0,
		toOffset = 0,
		t0 = math.huge,
		dur = 1,
		speed = 0,
		cruise = 0,
		snapFrom = 0,
		snapT0 = 0,
		phase = "Waiting",
		centre = -1,
		preSound = false,
		built = false,
		homeY = 0,
		revealed = false,
		revealAt = math.huge,
		slideFrom = if layoutOrder % 2 == 1 then -0.6 else 1.6,
		rs = v347,
		dim = __Dim,
		thumpAt = -math.huge,
		thumpAmp = 0,
		focus = if layoutOrder == 1 then 1 else 0,
		landAt = math.huge,
		hi = 0,
		stopFrom = 0,
		stopTo = 0,
		stopT0 = 0,
		stopDur = 1,
		rushFrom = 0,
		rushTo = 0,
		rushT0 = 0,
		rushDur = 1,
		rushM0 = 0,
		preStarted = false,
		fxToken = nil,
		fxRevealPending = false,
		fxHeld = false
	}
end
local function cruiseDist(p51)
	if p51 <= 0 then
		return 0
	end

	if p51 < 0.3 then
		return p51 * 22 * p51 / 0.6
	end

	return (p51 - 0.3 + 0.15) * 22
end
local function cruiseVel(p52)
	if p52 <= 0 then
		return 0
	end

	if p52 < 0.3 then
		return p52 * 22 / 0.3
	end

	return 22
end
local function revealRow(p53, p54, p55)
	local n1 = #t9
	local v355 = n9
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n2 = rowsAbsoluteSize.Y * 0.014
	local v358 = math.min((rowsAbsoluteSize.Y - n2 * (v355 - 1)) / v355, rowsAbsoluteSize.X / 6.4)
	local n3 = (rowsAbsoluteSize.Y - (v355 * v358 + (v355 - 1) * n2)) * 0.5

	n1 = rows.AbsoluteSize.X * vector2.X
	v355 = v358 * vector2.Y * caseSpinFeelCardHeightScale

	local v360 = math.max(v355 * (1 + caseSpinFeelCardGapPerCard), 1)

	v360 = math.ceil((n1 * 0.5 + v355) / v360)
	p53.raffle = {}

	local raffle = p53.raffle

	while v360 * 2 + 4 > #raffle do
		local v362 = fillerCard(u45)

		table.insert(raffle, v362)
	end

	p53.offset = v360
	p53.fromOffset = v360
	p53.t0 = p55
	p53.revealed = true
	p53.revealAt = p54
	p53.landAt = math.max(p53.landAt, p55 + 0.3 + 1.4)
end
local function revealUpTo(p56)
	local v364 = math.min(#t9, n7 + n9 + 1)

	while v364 >= n8 do
		local v365 = t9[n8]

		n8 += 1
		v365.slideFrom = 0.5
		revealRow(v365, p56, p56)
	end
end
local function placeWinner(p57, p58)
	local v368 = math.max(p58, p57.hi + 2)
	local raffle = p57.raffle

	while v368 + 40 > #raffle do
		local v370 = fillerCard(u45)

		table.insert(raffle, v370)
	end

	local reward = p57.reward
	local v372 = secretReveal.ShouldMask(reward.Rarity)

	p57.raffle[v368] = {
		Rarity = reward.Rarity or "Common",
		Icon = if v372 then secretReveal.MASK_ICON else if typeof(reward.Icon) == "string" and reward.Icon ~= "" then reward.Icon else "rbxasset://textures/ui/GuiImagePlaceholder.png",
		Name = if v372 then secretReveal.MASK_NAME else reward.Name or reward.ItemId or "Reward"
	}
	p57.winner = v368

	return v368
end
local function beginStop(p59, p60)
	local offset = p59.offset
	local n1 = p60 - p59.t0
	local v377 = math.max(if n1 <= 0 then 0 else if n1 < 0.3 then n1 * 22 / 0.3 else 22, 1)
	local floored = math.floor(offset + v377 * 1.4 / 3 + 0.5)
	local v379 = placeWinner(p59, floored + 1)
	local randomNumber = math.random()

	n1 = v379 - 1 + (randomNumber - 0.5) * 0.3
	p59.stopFrom = offset
	p59.stopTo = n1
	p59.stopT0 = p60
	p59.stopDur = 3 * (n1 - offset) / v377
	p59.landAt = p60 + p59.stopDur
	p59.phase = "Stopping"
end
local function currentVel(p61, p62)
	if p61.phase == "Stopping" then
		local v383 = math.clamp((p62 - p61.stopT0) / p61.stopDur, 0, 1)

		return (p61.stopTo - p61.stopFrom) * 3 * (1 - v383) ^ 2 / p61.stopDur
	end

	if p61.phase == "Spinning" then
		local n1 = p62 - p61.t0

		if n1 <= 0 then
			return 0
		end

		if n1 < 0.3 then
			return n1 * 22 / 0.3
		end

		return 22
	end

	return 0
end
local function rushRow(p63, p64, p65)
	local offset = p63.offset
	local n1 = p64 - p63.t0
	local n2 = if p63.phase == "Stopping" then (p63.stopTo - p63.stopFrom) * 3 * (1 - math.clamp((p64 - p63.stopT0) / p63.stopDur, 0, 1)) ^ 2 / p63.stopDur else if p63.phase == "Spinning" then if n1 <= 0 then 0 else if n1 < 0.3 then n1 * 22 / 0.3 else 22 else 0

	n1 = if p63.phase == "Stopping" then p63.stopTo else placeWinner(p63, math.floor(offset) + 2) - 1 + (math.random() - 0.5) * 0.3

	local v391 = math.max(0.45, p65 - p64)

	if p63.phase == "Stopping" then
		local v392 = math.max(p63.stopT0 + p63.stopDur - p64, p65 - p64)

		v391 = math.min(v391, v392)
	end

	local v393 = math.max(v391, 0.08)
	local v394 = math.max(n1 - offset, 0)

	p63.rushFrom = offset
	p63.rushTo = n1
	p63.rushT0 = p64
	p63.rushDur = v393
	p63.rushM0 = math.min(n2 * v393, v394 * 3)
	p63.landAt = p64 + v393
	p63.phase = "Rushing"
end
local function updatePreSounds(p66)
	local v396 = u101

	if v396 and v396.inst and v396.inst.Parent and v396.row.phase ~= "Landed" and p66 - (v396.row.landAt + caseSpinFeelSnapTime - 3.8) >= 0 and math.abs(v396.inst.TimePosition - (p66 - (v396.row.landAt + caseSpinFeelSnapTime - 3.8))) > 0.15 then
		local inst = v396.inst

		pcall(function()
			inst.TimePosition = n1
		end)
	end

	for _, v in ipairs(t9) do
		local v400 = t5[v.reward.Rarity]

		if v400 and not v.preStarted and v.phase ~= "Landed" then
			local n1 = v.landAt + caseSpinFeelSnapTime - 3.8

			if p66 >= n1 then
				v.preStarted = true

				local v402 = t4[v.reward.Rarity] or 0
				local v403 = u101
				local u404: boolean = v403 ~= nil and not v403.handle.Destroyed and v403.row.phase ~= "Landed"

				if not u404 or not v403 or not (v402 <= v403.rank) then
					local v405

					if u404 and v403 then
						v405 = function()
							v403.handle:FadeOut(0.25)
						end
						pcall(v405)
					end

					local v406, v405 = sound:Play(v400, workspace)

					if v405 and p66 - n1 > 0.05 then
						pcall(function()
							v405.TimePosition = p66 - n1
						end)
					end

					u101 = { handle = v406, inst = v405, rank = v402, row = v }
				end
			end
		end
	end
end

local s2 = "rbxassetid://6673021984"

task.spawn(function()
	local gotItem: Instance = playerGui:WaitForChild("GotItem", 10)
	local sunburst: Instance = gotItem and gotItem:FindFirstChild("Sunburst", true)

	if sunburst and sunburst:IsA("ImageLabel") and sunburst.Image ~= "" then
		s2 = sunburst.Image
	end
end)

local function landRow(p67)
	p67.phase = "Landed"
	p67.offset = p67.winner - 1

	if secretReveal.ShouldMask(p67.reward.Rarity) then
		p67.fxHeld = true
	elseif p67.fxToken then
		caseOpenFX:FireServer("Reveal", { Token = p67.fxToken })
	else
		p67.fxRevealPending = true
	end

	local v410 = p67.reward.Rarity or "Common"
	local v411 = t4[v410] or 1
	local rarityColors = rarity.Colors
	local v413 = rarityColors[v410] or rarityColors.Common
	local v414 = math.max(p67.cardSize, 1)

	p67.thumpAt = os.clock()
	p67.thumpAmp = math.max(0, v411 - 3) * 0.012 + 0.035

	local v415 = p67.slots[p67.winner]

	if v415 then
		v415.cell.ZIndex = 6
		v415.scale.Scale = caseSpinFeelCentreCardScale

		local tweenInfo3 = TweenInfo.new(0.1, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, 0)
		local v417: Tween = tweenService:Create(v415.scale, tweenInfo3, { Scale = 1.32 })

		v417:Play()
		v417.Completed:Once(function(p68)
			if p68 == Enum.PlaybackState.Completed and v415.scale.Parent then
				local tweenInfo4 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, 0)

				tweenService:Create(v415.scale, tweenInfo4, { Scale = 1.12 }):Play()
			end
		end)
		v415.cell.Rotation = -9

		local tweenInfo5 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, 0)

		tweenService:Create(v415.cell, tweenInfo5, { Rotation = 0 }):Play()
	end

	for k, v in pairs(p67.slots) do
		if k ~= p67.winner then
			local tweenInfo6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(v.scale, tweenInfo6, { Scale = 0.84 }):Play()
		end
	end

	local __Shade: Frame = Instance.new("Frame")

	__Shade.Name = "__Shade"
	__Shade.BackgroundColor3 = Color3.new(0, 0, 0)
	__Shade.BackgroundTransparency = 1
	__Shade.BorderSizePixel = 0
	__Shade.Size = UDim2.fromScale(1, 1)
	__Shade.ZIndex = 4
	__Shade.Parent = p67.box

	local tweenInfo7 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(__Shade, tweenInfo7, { BackgroundTransparency = 0.45 }):Play()

	local __Halo: ImageLabel = Instance.new("ImageLabel")

	__Halo.Name = "__Halo"
	__Halo.BackgroundTransparency = 1
	__Halo.Image = "rbxassetid://6673021984"
	__Halo.ImageColor3 = v413
	__Halo.ImageTransparency = 1
	__Halo.AnchorPoint = Vector2.new(0.5, 0.5)
	__Halo.Position = UDim2.fromScale(0.5, 0.5)
	__Halo.Size = UDim2.fromOffset(v414 * 2.4, v414 * 2.4)
	__Halo.ZIndex = 5
	__Halo.Parent = p67.box

	local tweenInfo8 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(__Halo, tweenInfo8, { ImageTransparency = 0.25 }):Play()

	local __Burst: ImageLabel = Instance.new("ImageLabel")

	__Burst.Name = "__Burst"
	__Burst.BackgroundTransparency = 1
	__Burst.Image = s2
	__Burst.ImageColor3 = v413
	__Burst.ImageTransparency = 0.05
	__Burst.AnchorPoint = Vector2.new(0.5, 0.5)
	__Burst.Position = UDim2.fromScale(0.5, 0.5)
	__Burst.Size = UDim2.fromOffset(v414 * 1.1, v414 * 1.1)
	__Burst.ZIndex = 5
	__Burst.Parent = p67.box

	local v427 = UDim2.fromOffset(v414 * 3.4, v414 * 3.4)
	local tweenInfo9 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	local v429: Tween = tweenService:Create(__Burst, tweenInfo9, { ImageTransparency = 1, Rotation = 80, Size = v427 })

	v429:Play()
	v429.Completed:Once(function()
		__Burst:Destroy()
	end)

	local __LandFlash: Frame = Instance.new("Frame")

	__LandFlash.Name = "__LandFlash"
	__LandFlash.BackgroundColor3 = v413
	__LandFlash.BackgroundTransparency = 0.5
	__LandFlash.BorderSizePixel = 0
	__LandFlash.Size = UDim2.fromScale(1, 1)
	__LandFlash.ZIndex = 20
	__LandFlash.Parent = p67.frame

	local tweenInfo10 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	v429 = tweenService:Create(__LandFlash, tweenInfo10, { BackgroundTransparency = 1 })
	v429:Play()
	v429.Completed:Once(function()
		__LandFlash:Destroy()
	end)

	local __PullName: TextLabel = Instance.new("TextLabel")

	__PullName.Name = "__PullName"
	__PullName.BackgroundTransparency = 1
	__PullName.AnchorPoint = Vector2.new(0.5, 0.5)
	__PullName.Position = UDim2.fromScale(0.5, 0.9)
	__PullName.Size = UDim2.fromScale(0.5, 0.26)
	__PullName.FontFace = title.FontFace
	__PullName.TextScaled = true
	__PullName.TextColor3 = Color3.new(1, 1, 1)
	__PullName.Text = if secretReveal.ShouldMask(v410) then secretReveal.MASK_NAME else p67.reward.Name or p67.reward.ItemId or v410
	__PullName.ZIndex = 25

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 2
	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Parent = __PullName
	pcall(function()
		rarity.ApplyTextGradient(__PullName, v410)
	end)

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Scale = 0
	uiScale.Parent = __PullName
	__PullName.Parent = p67.frame

	local tweenInfo11 = TweenInfo.new(0.3, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, 0.05)

	tweenService:Create(uiScale, tweenInfo11, { Scale = 1 }):Play()

	if p67.glow and p67.glowBase then
		local glow = p67.glow
		local v437 = uiFramework.applyRarityColor(p67.glowBase, v410)
		local tweenInfo12 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

		tweenService:Create(glow, tweenInfo12, { ImageColor3 = v437 }):Play()
	end

	sound:Play("Misc.RollTick", workspace, nil, 0.7)
	sound:Play("Crate." .. v410, workspace, nil, nil, if v411 <= 2 then 0.5 else nil)

	if p67.index < #t9 then
		local v439: number = n4

		task.delay(0.35, function()
			if v439 ~= n4 then
				return
			end

			n11 = p67.index + 1

			local n1 = p67.index + 1 - n10
			local v709 = math.max(0, #t9 - n9)

			n7 = math.clamp(n1, 0, v709)
			revealUpTo(os.clock())
		end)
	end
end
local function stepRow(p69, p70)
	if p69.phase == "Waiting" then
		if p70 < p69.t0 then
			return
		end

		p69.phase = "Spinning"
	end

	if p69.phase == "Spinning" then
		local n1 = p70 - p69.t0

		p69.offset = p69.fromOffset + (if n1 <= 0 then 0 else if n1 < 0.3 then n1 * 22 * n1 / 0.6 else (n1 - 0.3 + 0.15) * 22)

		local v443 = math.max(10.266666666666666, p69.hi + 1 - p69.offset)

		if p70 >= p69.landAt - v443 * 3 / 22 then
			beginStop(p69, p70)

			return
		end
	elseif p69.phase == "Stopping" then
		local v444 = math.clamp((p70 - p69.stopT0) / p69.stopDur, 0, 1)

		p69.offset = p69.stopFrom + (p69.stopTo - p69.stopFrom) * (1 - (1 - v444) ^ 3)

		if v444 >= 1 then
			p69.phase = "Snapping"
			p69.snapFrom = p69.offset
			p69.snapT0 = p70

			return
		end
	elseif p69.phase == "Rushing" then
		local v445 = math.clamp((p70 - p69.rushT0) / p69.rushDur, 0, 1)
		local n2 = v445 * v445
		local n3 = v445 * v445 * v445

		p69.offset = (n3 * 2 - n2 * 3 + 1) * p69.rushFrom + (n3 - n2 * 2 + v445) * p69.rushM0 + (n3 * -2 + n2 * 3) * p69.rushTo

		if v445 >= 1 then
			p69.phase = "Snapping"
			p69.snapFrom = p69.offset
			p69.snapT0 = p70

			return
		end
	elseif p69.phase == "Snapping" then
		local v448 = math.clamp((p70 - p69.snapT0) / caseSpinFeelSnapTime, 0, 1)

		p69.offset = p69.snapFrom + (p69.winner - 1 - p69.snapFrom) * v448

		if v448 >= 1 then
			landRow(p69)
		end
	end
end

local u139 = nil

local function setScreen(enabled)
	scriptParent.Enabled = enabled
	hud.Enabled = not enabled
	LocalPlayer:SetAttribute("_SpinnerOpen", if enabled then true else nil)
end
local function clearFinals()
	for _, v in ipairs(t10) do
		if v.hover then
			pcall(function()
				v.hover.disconnect()
			end)
		end

		pcall(function()
			v.api:destroy()
		end)

		if v.cell.Parent then
			v.cell:Destroy()
		end
	end

	table.clear(t10)
end
local function closeScreen(p72, p73)
	n4 += 1
	s1 = "Hidden"

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if u85 then
		hoverInfoModule.hide(u85)
	end

	local v454 = u101

	if v454 and not v454.handle.Destroyed then
		pcall(function()
			v454.handle:FadeOut(0.3)
		end)
	end

	u101 = nil

	for _, v in ipairs(t9) do
		if v.fxToken and (v.phase ~= "Landed" or not not v.fxHeld) then
			caseOpenFX:FireServer("Reveal", { Token = v.fxToken })
		end
	end

	for _, v in ipairs(t10) do
		if v.fxToken and v.fxHeld then
			caseOpenFX:FireServer("Reveal", { Token = v.fxToken })
		end
	end

	for _, v in ipairs(t9) do
		v.frame:Destroy()
	end

	table.clear(t9)
	destroyPool()

	if p72 then
		for _, v in ipairs(t10) do
			if v.hover then
				pcall(function()
					v.hover.disconnect()
				end)
			end
		end

		table.clear(t10)
	else
		clearFinals()
	end

	for _, v in ipairs(fused:GetChildren()) do
		v:Destroy()
	end

	__MultiContent.Visible = false
	clone2.Visible = false
	clone3.Visible = false
	clone4.Visible = false

	if u78 then
		u78.Visible = false
	end

	u119 = nil
	content.Visible = true
	u102 = nil

	if p73 then
		return
	end

	local tweenInfo13 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	local v466: Tween = tweenService:Create(background, tweenInfo13, { BackgroundTransparency = 1 })

	v466:Play()
	v466.Completed:Once(function()
		if s1 == "Hidden" and background.BackgroundTransparency >= 0.99 then
			background.Visible = false
		end
	end)
	releaseMusicEQ()
	scriptParent.Enabled = false
	hud.Enabled = true
	LocalPlayer:SetAttribute("_SpinnerOpen", nil)
end
local function run(p74, p75)
	local rewards = p74.Rewards
	local v470 = math.min(#rewards, 10)

	n4 += 1

	local v471: number = n4

	s1 = "Intro"
	u102 = p74
	u45 = p74
	applyMusicEQ()
	content.Visible = false
	__MultiContent.Visible = true
	scriptParent.Enabled = true
	hud.Enabled = false
	LocalPlayer:SetAttribute("_SpinnerOpen", true)
	background.Visible = true

	if not p75 then
		background.BackgroundTransparency = 1
	end

	local tweenInfo14 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(background, tweenInfo14, { BackgroundTransparency = 0.15 }):Play()

	local v473 = ("%s  x%d"):format(p74.CrateName or p74.CrateId or "Case", v470)

	clone.Text = v473

	local dropShadow: Instance = clone:FindFirstChild("DropShadow")

	if dropShadow and dropShadow:IsA("TextLabel") then
		dropShadow.Text = v473
	end

	clone.Size = UDim2.fromScale(1, 0.075)
	clone.Position = UDim2.new(clonePosition.X.Scale, 0, -0.15, 0)

	local tweenInfo15 = TweenInfo.new(0.4, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(clone, tweenInfo15, { Position = clonePosition }):Play()
	clone3.Visible = false
	clone2.Visible = false
	clone2.Position = v63

	local textLabel12: Instance = clone2:FindFirstChild("TextLabel")

	if textLabel12 and textLabel12:IsA("TextLabel") then
		textLabel12.Text = "Skip"

		local textLabel13: Instance = textLabel12:FindFirstChild("TextLabel")

		if textLabel13 and textLabel13:IsA("TextLabel") then
			textLabel13.Text = "Skip"
		end
	end

	u34 = false
	runService.Heartbeat:Wait()

	if v471 ~= n4 then
		return
	end

	n9 = math.min(v470, 5)
	n10 = math.ceil(n9 / 2)
	n11 = 1
	n7 = 0
	n6 = 0
	v473 = math.min(v470, n7 + n9)

	local v478 = os.clock()
	local n2 = v478 + (v473 - 1) * 0.045 + 0.35

	n5 = n2
	n12 = n2 + 2.6

	for i = 1, v470 do
		local v481 = makeRow(i, rewards[i])

		v481.landAt = n12 + (i - 1) * 1
		table.insert(t9, v481)
	end

	for i = 1, v473 do
		revealRow(t9[i], v478 + (i - 1) * 0.045, n2 + (i - 1) * 0.07)
	end

	n8 = v473 + 1
	revealUpTo(v478)
	layoutRows(v478)

	local v483 = t1[p74.CrateId] or "RegularCase"

	for i, v in ipairs(t9) do
		task.delay((i - 1) * 0.3, function()
			if v471 ~= n4 then
				return
			end

			n1 += 1

			local v710: number = n1
			local crateId = p74.CrateId
			local randomNumber = math.random(1, 2147483646)

			caseOpenFX:FireServer("Begin", {
				Intro = false,
				Token = v710,
				Model = v483,
				CrateId = crateId,
				Seed = randomNumber,
				Reward = {
					Rarity = v.reward.Rarity,
					Icon = v.reward.Icon,
					Name = v.reward.Name or v.reward.ItemId
				}
			})
			v.fxToken = v710

			if v.fxRevealPending then
				task.delay(0.35, function()
					caseOpenFX:FireServer("Reveal", { Token = v710 })
				end)
			end
		end)
	end

	sound:Play("Misc.RollSlash", workspace)
	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		if v471 ~= n4 then
			return
		end

		local v714 = os.clock()

		if s1 == "Intro" and v714 >= n2 then
			s1 = "Spinning"
			clone2.Position = v63
			clone2.Visible = true

			local tweenInfo16 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(clone2, tweenInfo16, { Position = v62 }):Play()
		end

		if s1 == "Intro" or s1 == "Spinning" or s1 == "Landed" then
			local n1: number = #t9
			local v717 = n9
			local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
			local n8 = rowsAbsoluteSize.Y * 0.014
			local v720 = math.min((rowsAbsoluteSize.Y - n8 * (v717 - 1)) / v717, rowsAbsoluteSize.X / 6.4)
			local n3 = (rowsAbsoluteSize.Y - (v717 * v720 + (v717 - 1) * n8)) * 0.5

			n1 = n6

			local n10 = n7 * (v720 + n8) - n6

			n8 = math.min(1, deltaTime * 11)
			n6 = n1 + n10 * n8
			layoutRows(v714, deltaTime)

			if u34 and s1 == "Spinning" then
				local n5 = v714 - 0.12

				for _, v in ipairs(t9) do
					if not v.revealed then
						break
					end

					if v.phase == "Waiting" or v.phase == "Spinning" or v.phase == "Stopping" then
						rushRow(v, v714, n5 + 0.12)
					end

					if v.landAt < math.huge then
						n5 = math.max(n5, v.landAt)
					end
				end
			end

			local u726: boolean = true

			for _, v in ipairs(t9) do
				if v.revealed and v714 >= v.revealAt then
					v.built = true

					if s1 ~= "Intro" then
						stepRow(v, v714)
					end

					renderRow(v, deltaTime)
				end

				if v.phase ~= "Landed" then
					u726 = false
				end
			end

			updatePreSounds(v714)

			if u726 and s1 == "Spinning" then
				s1 = "Landed"
				clone2.Visible = false
				task.delay(0.6, function()
					if v471 == n4 and s1 == "Landed" then
						u139()
					end
				end)
			end

			return
		end
	end)
end
local function bindHover(p77)
	local reward = p77.reward
	local hoverInfoModuleBind = hoverInfoModule.bind

	if not u85 then
		u85 = hoverInfoModule.create(scriptParent)
	end

	p77.hover = hoverInfoModuleBind(u85, p77.cell, function()
		if s1 == "Result" then
			return {
				Name = reward.Name or reward.ItemId or "Reward",
				Rarity = reward.Rarity or "Common",
				GlobalCopies = reward.GlobalCopies,
				Serial = reward.Serial,
				MaxSupply = reward.MaxSupply,
				SourceButton = p77.cell,
				FinisherName = reward.FinisherName,
				FinisherIcon = reward.FinisherIcon,
				FinisherRarity = reward.FinisherRarity,
				Kind = reward.ItemType,
				ItemId = reward.ItemId
			}
		end

		return nil
	end)
end
local function layoutFinals(p78)
	local n1: number = #t10

	if n1 == 0 then
		return
	end

	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n2 = caseSpinFeelCardGapPerCard * 1.4
	local v493 = math.min(rowsAbsoluteSize.X * 0.9 / (n1 + (n1 - 1) * n2 + 0.8), rowsAbsoluteSize.Y * 0.2)
	local n3 = v493 * n2

	n2 = v493 / (caseSpinFeelCardHeightScale * vector2.Y)

	local n4 = (n1 * v493 + (n1 - 1) * n3) / vector2.X + v493
	local rowsAbsoluteSizeX = rowsAbsoluteSize.X
	local v497 = v493

	for i, v in ipairs(t10) do
		local absoluteSize: Vector2 = rows.AbsoluteSize
		local vector22 = Vector2.new(absoluteSize.X * 0.5 + (i - (n1 + 1) * 0.5) * (v497 + n3), absoluteSize.Y * 0.5)
		local v502 = UDim2.fromOffset(vector22.X, vector22.Y)
		local v503 = UDim2.fromOffset(v497, v497)
		local t15: {[any]: any} = { Position = v502, Size = v503 }

		if p78 then
			local tweenInfo17 = TweenInfo.new(0.42, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, (i - 1) * 0.02 or 0)

			tweenService:Create(v.cell, tweenInfo17, t15):Play()
		else
			v.cell.Position = t15.Position
			v.cell.Size = t15.Size
		end
	end
end

u139 = function()
	local v506: number = n4

	s1 = "Fusing"

	local n1: number = #t9

	if n1 == 0 then
		return
	end

	for _, v in ipairs(t9) do
		v.rs.Scale = 1
		v.dim.BackgroundTransparency = 1

		for _, iterValue in ipairs({ "__PullName", "__LandFlash" }) do
			local v2 = v.frame:FindFirstChild(iterValue)

			if v2 then
				v2:Destroy()
			end
		end

		for _, iterValue2 in ipairs({ "__Shade", "__Halo", "__Burst" }) do
			local v3 = v.box:FindFirstChild(iterValue2)

			if v3 then
				v3:Destroy()
			end
		end
	end

	local uDim2 = UDim2.new(clonePosition.X.Scale, 0, -0.15, 0)
	local tweenInfo18 = TweenInfo.new(0.2, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(clone, tweenInfo18, { Position = uDim2 }):Play()

	for _, v in ipairs(t9) do
		for k, iterValue3 in pairs(v.slots) do
			if k ~= v.winner then
				local tweenInfo19 = TweenInfo.new(0.18, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out, 0, false, 0)

				tweenService:Create(iterValue3.scale, tweenInfo19, { Scale = 0 }):Play()
			end
		end
	end

	task.wait(0.2)

	if v506 ~= n4 then
		return
	end

	local fusedAbsolutePosition: Vector2 = fused.AbsolutePosition
	local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
	local n2 = caseSpinFeelCardGapPerCard * 1.4
	local v526 = math.min(rowsAbsoluteSize.X * 0.9 / (n1 + (n1 - 1) * n2 + 0.8), rowsAbsoluteSize.Y * 0.2)
	local n3 = v526 * n2

	n2 = v526 / (caseSpinFeelCardHeightScale * vector2.Y)

	local n8 = (n1 * v526 + (n1 - 1) * n3) / vector2.X + v526
	local rowsAbsoluteSizeX = rowsAbsoluteSize.X
	local v530 = v526
	local t16: {[any]: any} = {}

	for _, v in ipairs(t9) do
		local offset = v.frame.Size.Y.Offset
		local v535 = v.revealed

		if v535 then
			v535 = false

			if v.homeY + offset > 0 then
				v535 = v.homeY < rows.AbsoluteSize.Y
			end
		end

		local v536 = v.slots[v.winner]
		local u537: boolean = not v535 or v536 == nil
		local absoluteSize: Vector2 = rows.AbsoluteSize
		local vector23 = Vector2.new(absoluteSize.X * 0.5 + (v.index - (n1 + 1) * 0.5) * (v530 + n3), absoluteSize.Y * 0.5)
		local v540 = v530

		if v536 and not u537 then
			vector23 = v536.cell.AbsolutePosition + v536.cell.AbsoluteSize * 0.5 - fusedAbsolutePosition
			v540 = v536.cell.AbsoluteSize.X
		end

		for k, iterValue4 in pairs(v.slots) do
			iterValue4.cell.Visible = false
			iterValue4.cell.ZIndex = 1
			iterValue4.cell.Rotation = 0
			iterValue4.cell.Parent = __Spare

			local t17 = t7[iterValue4.rarity]

			if not t17 then
				t17 = {}
				t7[iterValue4.rarity] = t17
			end

			table.insert(t17, iterValue4)
			v.slots[k] = nil
		end

		local vReward = v.reward
		local v545 = secretReveal.ShouldMask(vReward.Rarity)
		local uiFrameworkCreateItemCell = uiFramework.createItemCell
		local v547 = vReward.Rarity or "Common"
		local v548 = if v545 then secretReveal.MASK_ICON else if typeof(vReward.Icon) == "string" and vReward.Icon ~= "" then vReward.Icon else "rbxasset://textures/ui/GuiImagePlaceholder.png"
		local parent, v550 = uiFrameworkCreateItemCell(v547, { icon = v548 })

		parent.Name = "__Pull" .. v.index
		parent.AnchorPoint = Vector2.new(0.5, 0.5)

		local uiAspectRatioConstraint = parent:FindFirstChildOfClass("UIAspectRatioConstraint")

		if uiAspectRatioConstraint then
			uiAspectRatioConstraint:Destroy()
		end

		parent.Position = UDim2.fromOffset(vector23.X, vector23.Y)
		parent.Size = UDim2.fromOffset(v540, v540)

		local v552 = parent:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale")

		v552.Scale = 1
		v552.Parent = parent
		parent.Parent = fused

		if vReward.Finisher and vReward.Finisher ~= "" then
			pcall(function()
				v550:setFinisher(vReward.Finisher)
			end)
		end

		if u537 then
			v552.Scale = 0

			local tweenInfo20 = TweenInfo.new(0.3, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, v.index * 0.025 + 0.1 or 0)

			tweenService:Create(v552, tweenInfo20, { Scale = 1 }):Play()
		end

		table.insert(t10, {
			hover = nil,
			cell = parent,
			api = v550,
			reward = vReward,
			scale = v552,
			masked = v545,
			fxToken = v.fxToken,
			fxHeld = v.fxHeld
		})

		if v535 then
			table.insert(t16, v)
		else
			v.frame:Destroy()
		end
	end

	table.clear(t9)

	for _, v in ipairs(t16) do
		table.insert(t9, v)
	end

	if #t9 == 0 then
		return
	end

	local v556: Vector2 = rows.AbsoluteSize
	local n5 = caseSpinFeelCardGapPerCard * 1.4

	v530 = math.min(v556.X * 0.9 / (n1 + (n1 - 1) * n5 + 0.8), v556.Y * 0.2)

	local n6 = v530 * n5
	local n7 = (n1 * v530 + (n1 - 1) * n6) / vector2.X + v530

	n8 = v530 / (caseSpinFeelCardHeightScale * vector2.Y)
	v526 = rows.AbsoluteSize.Y * 0.5

	for _, v in ipairs(t9) do
		local vFrame = v.frame
		local uDim22 = UDim2.new(0.5, 0, 0, v526)
		local v564 = UDim2.fromOffset(v556.X, n8)
		local tweenInfo21 = TweenInfo.new(0.38, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.InOut or Enum.EasingDirection.Out, 0, false, 0)

		tweenService:Create(vFrame, tweenInfo21, { Position = uDim22, Size = v564 }):Play()

		for _, iterValue5 in ipairs(v.frame:GetChildren()) do
			if iterValue5.Name == "Arrows" and iterValue5:IsA("ImageLabel") then
				local tweenInfo22 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

				tweenService:Create(iterValue5, tweenInfo22, { ImageTransparency = 1 }):Play()
			end
		end
	end

	layoutFinals(true)
	sound:Play("Misc.RollSlash", workspace)
	task.wait(0.4)

	if v506 ~= n4 then
		return
	end

	local roundedUp = math.ceil(#t9 / 2)

	n3 = t9[roundedUp]

	for _, v in ipairs(t9) do
		if v ~= n3 then
			v.frame:Destroy()
		end
	end

	table.clear(t9)
	table.insert(t9, n3)
	v526 = "Common"
	n7 = false

	for _, v in ipairs(t10) do
		local v574 = v.reward.Rarity or "Common"

		if (t4[v574] or 0) > (t4[v526] or 0) then
			v526 = v574
		end

		if v.reward.Finisher and v.reward.Finisher ~= "" then
			n7 = true
		end
	end

	if n3.glow and n3.glowBase then
		n3.glow.ImageColor3 = uiFramework.applyRarityColor(n3.glowBase, v526)
	end

	local __FuseFlash: Frame = Instance.new("Frame")

	__FuseFlash.Name = "__FuseFlash"
	__FuseFlash.BackgroundColor3 = Color3.new(1, 1, 1)
	__FuseFlash.BackgroundTransparency = 0.25
	__FuseFlash.BorderSizePixel = 0
	__FuseFlash.Size = UDim2.fromScale(1, 1)
	__FuseFlash.ZIndex = 20
	__FuseFlash.Parent = n3.frame

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = __FuseFlash

	local tweenInfo23 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	local v578 = tweenService:Create(__FuseFlash, tweenInfo23, { BackgroundTransparency = 1 })

	v578:Play()
	v578.Completed:Once(function()
		__FuseFlash:Destroy()
	end)

	local v579 = n3.frame:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale")

	v579.Parent = n3.frame
	v579.Scale = 1.07

	local tweenInfo24 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(v579, tweenInfo24, { Scale = 1 }):Play()

	for i, v in ipairs(t10) do
		v.scale.Scale = 1.18

		local tweenInfo25 = TweenInfo.new(0.3, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out or Enum.EasingDirection.Out, 0, false, (i - 1) * 0.035 or 0)

		tweenService:Create(v.scale, tweenInfo25, { Scale = 1 }):Play()
	end

	if not secretReveal.ShouldMask(v526) then
		sound:Play("Crate." .. v526, workspace)
	end

	if n7 then
		sound:Play("Misc.BonusFX", workspace)
	end

	n7 = {}

	for _, v in ipairs(t10) do
		if v.masked then
			table.insert(n7, v)
		end
	end

	if #n7 > 0 then
		s1 = "Revealing"
		task.wait(0.5)

		for _, v in ipairs(n7) do
			if v506 ~= n4 then
				return
			end

			secretReveal.Play(v.reward, {
				onReveal = function()
					v.masked = false
					pcall(function()
						local vApi = v.api
						local vReward = v.reward
						local typeName: string = typeof(vReward.Icon)

						vApi:setIcon(if typeName == "string" and vReward.Icon ~= "" then vReward.Icon else "rbxasset://textures/ui/GuiImagePlaceholder.png")
					end)

					if v.fxToken and v.fxHeld then
						caseOpenFX:FireServer("Reveal", { Token = v.fxToken })
						v.fxHeld = false
					end
				end
			})
			v.scale.Scale = 1.3

			local tweenInfo26 = TweenInfo.new(0.4, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(v.scale, tweenInfo26, { Scale = 1 }):Play()
		end

		if v506 ~= n4 then
			return
		end
	end

	for _, v in ipairs(t10) do
		if devilsSightReveal.Handles(v.reward) then
			if v506 ~= n4 then
				return
			end

			s1 = "Revealing"
			devilsSightReveal.Play(v.reward, {
				onReveal = function()
					if v.fxToken and v.fxHeld then
						caseOpenFX:FireServer("Reveal", { Token = v.fxToken })
						v.fxHeld = false
					end
				end
			})
			v.scale.Scale = 1.3

			local tweenInfo27 = TweenInfo.new(0.4, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(v.scale, tweenInfo27, { Scale = 1 }):Play()
		end
	end

	if v506 ~= n4 then
		return
	end

	v578 = ("You got %d item%s!"):format(#t10, if #t10 == 1 then "" else "s")
	clone.Text = v578

	local dropShadow: Instance = clone:FindFirstChild("DropShadow")

	if dropShadow and dropShadow:IsA("TextLabel") then
		dropShadow.Text = v578
	end

	clone.Size = title.Size

	local v593 = resultTitlePos(n8)
	local tweenInfo28 = TweenInfo.new(0.4, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(clone, tweenInfo28, { Position = v593 }):Play()
	s1 = "Result"

	for _, v in ipairs(t10) do
		local v597 = v.reward
		local hoverInfoModuleBind = hoverInfoModule.bind

		if not u85 then
			u85 = hoverInfoModule.create(scriptParent)
		end

		v.hover = hoverInfoModuleBind(u85, v.cell, function()
			if s1 == "Result" then
				return {
					Name = v597.Name or v597.ItemId or "Reward",
					Rarity = v597.Rarity or "Common",
					GlobalCopies = v597.GlobalCopies,
					Serial = v597.Serial,
					MaxSupply = v597.MaxSupply,
					SourceButton = v.cell,
					FinisherName = v597.FinisherName,
					FinisherIcon = v597.FinisherIcon,
					FinisherRarity = v597.FinisherRarity,
					Kind = v597.ItemType,
					ItemId = v597.ItemId
				}
			end

			return nil
		end)
	end

	if connection2 then
		connection2:Disconnect()
	end

	connection2 = rows:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if s1 ~= "Result" or not t9[1] then
			return
		end

		local n1: number = #t10
		local rowsAbsoluteSize: Vector2 = rows.AbsoluteSize
		local n2 = caseSpinFeelCardGapPerCard * 1.4
		local v732 = math.min(rowsAbsoluteSize.X * 0.9 / (n1 + (n1 - 1) * n2 + 0.8), rowsAbsoluteSize.Y * 0.2)
		local n3 = v732 * n2
		local n4 = (n1 * v732 + (n1 - 1) * n3) / vector2.X + v732
		local n5 = v732 / (caseSpinFeelCardHeightScale * vector2.Y)

		t9[1].frame.Position = UDim2.new(0.5, 0, 0, rows.AbsoluteSize.Y * 0.5)
		t9[1].frame.Size = UDim2.fromOffset(rowsAbsoluteSize.X, n5)
		layoutFinals(false)
		placeResultButtons(n5, false)
		clone.Position = resultTitlePos(n5)
	end)
	showResultButtons(n8)
end

local function findInventoryButton()
	local lobbyButtons: Instance = hud:FindFirstChild("LobbyButtons")
	local v600: Instance = lobbyButtons and lobbyButtons:FindFirstChild("LobbyButtons")
	local v601: Instance = v600

	if v601 then
		v601 = v600:FindFirstChild("InventoryButton")
	end

	if v601 and v601:IsA("GuiObject") then
		return v601
	end

	return nil
end

local u147 = nil

local function pulseButton(parent, p80, parent2, p82)
	local uiScale = parent:FindFirstChildWhichIsA("UIScale")

	if not uiScale then
		local uiScale2: UIScale = Instance.new("UIScale")

		uiScale2.Parent = parent
		uiScale = uiScale2
	end

	local v608 = uiScale
	local v609 = math.min(p82, 10)
	local tweenInfo29 = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v611: Tween = tweenService:Create(v608, tweenInfo29, { Scale = v609 * 0.012 + 1.16 })

	u147 = v611
	v611.Completed:Once(function(p83)
		if p83 == Enum.PlaybackState.Completed and u147 == v611 then
			local tweenInfo30 = TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

			tweenService:Create(v608, tweenInfo30, { Scale = 1 }):Play()

			return
		end
	end)
	v611:Play()

	local glow = parent:FindFirstChild("Glow")

	if glow and glow:IsA("ImageLabel") then
		local __PulseBase = glow:GetAttribute("__PulseBase")

		if typeof(__PulseBase) ~= "number" then
			__PulseBase = glow.ImageTransparency
			glow:SetAttribute("__PulseBase", __PulseBase)
		end

		glow.ImageTransparency = math.max(0, __PulseBase - 0.6)

		local tweenInfo31 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

		tweenService:Create(glow, tweenInfo31, { ImageTransparency = __PulseBase }):Play()
	end

	local v615 = parent:FindFirstAncestorWhichIsA("LayerCollector")
	local n1 = (if v615 and v615:IsA("ScreenGui") then v615.AbsolutePosition else Vector2.zero) + parent.AbsolutePosition + parent.AbsoluteSize * 0.5 - parent2.AbsolutePosition

	v609 = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y)

	local __AbsorbRing: Frame = Instance.new("Frame")

	__AbsorbRing.Name = "__AbsorbRing"
	__AbsorbRing.AnchorPoint = Vector2.new(0.5, 0.5)
	__AbsorbRing.BackgroundTransparency = 1
	__AbsorbRing.Position = UDim2.fromOffset(n1.X, n1.Y)
	__AbsorbRing.Size = UDim2.fromOffset(v609 * 0.9, v609 * 0.9)
	__AbsorbRing.Parent = parent2

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = __AbsorbRing

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 4

	local rarityColors = rarity.Colors

	uiStroke.Color = rarityColors[p80] or rarityColors.Common
	uiStroke.Parent = __AbsorbRing

	local v621 = UDim2.fromOffset(v609 * 2.1, v609 * 2.1)
	local tweenInfo32 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(__AbsorbRing, tweenInfo32, { Size = v621 }):Play()

	local tweenInfo33 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
	local v624: Tween = tweenService:Create(uiStroke, tweenInfo33, { Transparency = 1, Thickness = 1 })

	v624:Play()
	v624.Completed:Once(function()
		__AbsorbRing:Destroy()
	end)
end
local function flyCell(p84, p85, p86, p87, p88)
	local cell = p84.cell
	local vector24 = Vector2.new(cell.Position.X.Offset, cell.Position.Y.Offset)
	local offset = cell.Size.X.Offset
	local n1 = math.max(p86.AbsoluteSize.X, 8) * 0.45
	local cellRotation = cell.Rotation
	local n2: number = if p85 % 2 == 0 then 14 else -14
	local tweenInfo34 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(p84.scale, tweenInfo34, { Scale = 1.12 }):Play()
	task.wait(0.08)

	local tweenInfo35 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

	tweenService:Create(p84.scale, tweenInfo35, { Scale = 1 }):Play()

	local n3: number = 0
	local connection = nil

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		if not cell.Parent then
			connection:Disconnect()

			return
		end

		n3 += deltaTime

		local v739 = math.clamp(n3 / 0.55, 0, 1)
		local v740 = p86
		local v741 = v740:FindFirstAncestorWhichIsA("LayerCollector")
		local n4 = (if v741 and v741:IsA("ScreenGui") then v741.AbsolutePosition else Vector2.zero) + v740.AbsolutePosition + v740.AbsoluteSize * 0.5 - p87.AbsolutePosition
		local vector2New = Vector2.new

		v740 = (vector24.X + n4.X) * 0.5

		local v744 = math.min(vector24.Y, n4.Y)
		local vector2 = vector2New(v740, v744 - p87.AbsoluteSize.Y * 0.22)

		v740 = v739 * v739
		v740 = vector24 * ((1 - v740) * (1 - v740)) + vector2 * ((1 - v740) * 2 * v740) + n4 * (v740 * v740)
		v744 = offset + (n1 - offset) * (1 - (1 - v739) ^ 2)
		cell.Position = UDim2.fromOffset(v740.X, v740.Y)
		cell.Size = UDim2.fromOffset(v744, v744)

		local sine = math.sin(v739 * 3.141592653589793)

		cell.Rotation = cellRotation + n2 * sine

		if v739 >= 1 then
			connection:Disconnect()
			pcall(function()
				p84.api:destroy()
			end)

			if cell.Parent then
				cell:Destroy()
			end

			p88()
		end
	end)
end
local function claimAll(p90)
	if s1 == "Result" and not u120 then
		s1 = "Claiming"
		sound:Play("UI.Click", workspace)

		if u85 then
			hoverInfoModule.hide(u85)
		end

		clone3.Visible = false
		clone4.Visible = false

		if u78 then
			u78.Visible = false
		end

		local __MultiClaimFX: ScreenGui = Instance.new("ScreenGui")

		__MultiClaimFX.Name = "__MultiClaimFX"
		__MultiClaimFX.IgnoreGuiInset = true
		__MultiClaimFX.ScreenInsets = Enum.ScreenInsets.None
		__MultiClaimFX.ResetOnSpawn = false
		__MultiClaimFX.DisplayOrder = 60
		__MultiClaimFX.Parent = playerGui
		runService.Heartbeat:Wait()

		local t18: {[any]: any} = {}

		for _, v in ipairs(t10) do
			local vCell = v.cell
			local v646 = vCell:FindFirstAncestorWhichIsA("LayerCollector")
			local n1 = (if v646 and v646:IsA("ScreenGui") then v646.AbsolutePosition else Vector2.zero) + vCell.AbsolutePosition + vCell.AbsoluteSize * 0.5 - __MultiClaimFX.AbsolutePosition
			local x = v.cell.AbsoluteSize.X

			v646 = math.max(v.scale.Scale, 0.01)

			local n2 = x / v646

			v.cell.Parent = __MultiClaimFX
			v.cell.Position = UDim2.fromOffset(n1.X, n1.Y)
			v.cell.Size = UDim2.fromOffset(n2, n2)
			v.cell.Active = false
			v.cell.Interactable = false
			table.insert(t18, v)
		end

		local u650 = u102

		if u650 then
			u650 = u102
			u650 = u650.ReturnToShopSlot
		end

		if p90 then
			local crateId = u102 and u102.CrateId

			u650 = u650 or crateId and t2[crateId] or ""
		end

		local function openShop()
			local openShop: Instance = bindables:FindFirstChild("OpenShop")

			if openShop and openShop:IsA("BindableEvent") then
				openShop:Fire("Cases", if u650 == "" then nil else u650)
			end
		end

		closeScreen(true)
		runService.Heartbeat:Wait()
		runService.Heartbeat:Wait()

		local lobbyButtons: Instance = hud:FindFirstChild("LobbyButtons")
		local v654: Instance = lobbyButtons and lobbyButtons:FindFirstChild("LobbyButtons")
		local v655: Instance = v654

		if v655 then
			v655 = v654:FindFirstChild("InventoryButton")
		end

		local v656 = if v655 and v655:IsA("GuiObject") then v655 else nil

		if v656 and onScreen(v656) then
			local n3: number = 0
			local n4: number = #t18

			for i, v in ipairs(t18) do
				task.delay((i - 1) * 0.075, function()
					flyCell(v, i, v656, __MultiClaimFX, function()
						n3 += 1
						pulseButton(v656, v.reward.Rarity or "Common", __MultiClaimFX, n3)
						sound:Play("Misc.RollTick", workspace, nil, n3 * 0.07 + 1)

						if n3 >= n4 then
							sound:Play("Misc.NotificationPositive", workspace)
							task.delay(0.5, function()
								__MultiClaimFX:Destroy()

								if not scriptParent.Enabled and LocalPlayer:GetAttribute("InMatch") ~= true then
									if typeof(u650) == "string" then
										local openShop: Instance = bindables:FindFirstChild("OpenShop")

										if openShop and openShop:IsA("BindableEvent") then
											openShop:Fire("Cases", if u650 == "" then nil else u650)

											return
										end
									else
										local openLobbyWindow: Instance = bindables:FindFirstChild("OpenLobbyWindow")

										if openLobbyWindow and openLobbyWindow:IsA("BindableEvent") then
											openLobbyWindow:Fire("Inventory")
										end
									end

									return
								end
							end)
						end
					end)
				end)
			end

			return
		end

		for _, v in ipairs(t18) do
			local tweenInfo36 = TweenInfo.new(0.25, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(v.scale, tweenInfo36, { Scale = 0 }):Play()
		end

		task.delay(0.3, function()
			__MultiClaimFX:Destroy()
		end)

		if p90 then
			local v664 = LocalPlayer:GetAttribute("InMatch") ~= true and bindables:FindFirstChild("OpenShop")

			if v664 and v664:IsA("BindableEvent") then
				v664:Fire("Cases", if u650 == "" then nil else u650)
			end
		end

		return
	end
end
local function buyMore()
	if s1 == "Result" and not u120 then
		local v665 = u102
		local crateId = v665 and v665.CrateId
		local remotes: Instance = replicatedStorage:FindFirstChild("Remotes")
		local shopOpenAnalytics: Instance = remotes and remotes:FindFirstChild("ShopOpenAnalytics")

		if shopOpenAnalytics and shopOpenAnalytics:IsA("RemoteEvent") then
			shopOpenAnalytics:FireServer("SpinnerBuyMore", v665 and v665.ReturnToShopSlot or crateId and t2[crateId] or crateId)
		end

		claimAll(true)

		return
	end
end
local function skipOne()
	if s1 == "Spinning" then
		local v669 = os.clock()
		local v670 = nil
		local n1 = -math.huge

		for _, v in ipairs(t9) do
			if v.phase == "Waiting" or v.phase == "Spinning" or v.phase == "Stopping" then
				v670 = v

				break
			end

			n1 = math.max(n1, v.landAt)
		end

		if not v670 or not v670.revealed then
			return
		end

		rushRow(v670, v669, n1 + 0.15)
		n1 = v670

		local u674: boolean = false

		for i = v670.index + 1, #t9 do
			local v676 = t9[i]

			if v676.phase == "Waiting" or v676.phase == "Spinning" then
				u674 = true

				local n2

				if v676.revealed then
					n2 = math.max(v669, v676.t0 + 0.3) + 1.4
				else
					n2 = v669 + 1.4
				end

				v676.landAt = math.max(n1.landAt + 1, n2)
			elseif v676.phase == "Stopping" then
				u674 = true
			end

			n1 = v676
		end

		if not u674 then
			clone2.Visible = false
		end

		return
	end
end

clone2.MouseButton1Click:Connect(function()
	if s1 == "Spinning" and not u34 then
		u34 = true

		local tweenInfo37 = TweenInfo.new(0.2, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out, 0, false, 0)

		tweenService:Create(clone2, tweenInfo37, { Position = v63 }):Play()
		task.delay(0.2, function()
			if u34 then
				clone2.Visible = false
			end
		end)

		return
	end
end)
clone3.MouseButton1Click:Connect(function()
	claimAll()
end)
clone4.MouseButton1Click:Connect(function()
	if s1 == "Result" and not u120 then
		local v679 = u102
		local v680 = againLeft(v679)

		if v680 <= 0 then
			return
		end

		u120 = true
		sound:Play("Misc.OpenAgain", workspace)

		local requestMore = v679.RequestMore
		local typeName: string = typeof(v679.Count)
		local floored = math.floor(if typeName == "number" then v679.Count else #t10)
		local v684 = math.min(floored, v680)
		local v685 = math.clamp(v684, 1, 10)
		local v686, v687, v688, rewards = pcall(requestMore, v685)

		u120 = false

		if s1 ~= "Result" or v679 ~= u102 then
			return
		end

		if v686 and v687 == true and typeof(rewards) == "table" and #rewards ~= 0 then
			for _, v in ipairs(rewards) do
				if typeof(v) ~= "table" or typeof(v.Rarity) ~= "string" then
					return
				end
			end

			local v692 = table.clone(v679)

			v692.Rewards = rewards
			closeScreen(false, true)
			run(v692, true)

			return
		end

		warn("[MultiSpinner] Open More failed:", if v686 then v688 else v687)
		v680 = if v686 and typeof(v688) == "string" then v688 else nil

		if v680 == "InventoryFull" then
			return
		end

		local v693 = nil

		if typeof(v679.ErrorText) == "function" then
			local ok, result = pcall(v679.ErrorText, v680)

			if ok then
				v693 = result
			end
		end

		if typeof(v693) ~= "string" then
			local t19: {[any]: any} = {
				OpenInProgress = "Already opening a case.",
				OpenCooldown = "Slow down a little!",
				ListedInBooth = "Unlist this case from your booth to open it.",
				NoneOwned = "You don't have any of this case."
			}

			v693 = t19[v680 or ""] or "Couldn't open the case, try again."
		end

		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			_GNotify({ notifType = "FailNotification", errorMessage = v693 })
		end

		return
	end
end)

if u78 then
	u78.MouseButton1Click:Connect(buyMore)
end

openCrateMulti.Event:Connect(function(p91)
	if typeof(p91) == "table" and typeof(p91.CrateId) == "string" then
		if typeof(p91.Rewards) == "table" and #p91.Rewards ~= 0 then
			if LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") ~= false then
			elseif s1 == "Hidden" and not scriptParent.Enabled then
				for _, v in ipairs(p91.Rewards) do
					if typeof(v) ~= "table" or typeof(v.Rarity) ~= "string" then
						return
					end
				end

				run(p91)

				return
			end

			return
		end

		return
	end
end)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	if LocalPlayer:GetAttribute("InMatch") == true and s1 ~= "Hidden" and s1 ~= "Claiming" then
		closeScreen()
	end
end)
