-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local shineEffect = require(shared:WaitForChild("ShineEffect"))
local rarity = require(shared:WaitForChild("Rarity"))
local eventTimer = require(shared:WaitForChild("EventTimer"))
local fourthOfJulyTemplates: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("FourthOfJulyTemplates")
local counter_Kills: Instance = fourthOfJulyTemplates:WaitForChild("Counter_Kills")
local skipButton: Instance = fourthOfJulyTemplates:WaitForChild("SkipButton")
local scriptParent: Instance = script.Parent
local scriptParentParent: Instance = scriptParent.Parent
local content: Instance = scriptParent:WaitForChild("Content")
local timer: Instance = scriptParent:WaitForChild("Timer")
local header: Instance = scriptParent:WaitForChild("Header")
local rarity2: Instance = scriptParent:FindFirstChild("Rarity")
local closeButton: Instance = scriptParent:FindFirstChild("CloseButton")
local folder: Instance = content:FindFirstChild("Folder")
local glow: Instance = folder and folder:FindFirstChild("Glow")
local color3 = Color3.fromRGB(199, 125, 255)
local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {
	{ Key = "Knife" },
	{ Key = "Finisher" },
	{ Key = "Gun", Final = true }
}

for i = 1, #t2 do
	local v32: Instance = content:WaitForChild("Quest" .. i)

	t1[i] = v32

	for iterFirst, value in {
		"StartButton",
		"ClaimOverlay",
		"ClaimedLabel",
		"SkipButton",
		"Counter",
		"Amount"
	}, nil, nil do
		local value: Instance = v32:FindFirstChild(value)

		if value and value:IsA("GuiObject") then
			value.Visible = false
		end
	end
end

local function rs(p1)
	return replicatedStorage:GetAttribute(p1)
end
local function me(p2)
	return LocalPlayer:GetAttribute(p2)
end
local function now()
	local v90: number = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")

	return v90 + (plagueTimeOffset or 0)
end
local function eventRunning()
	local v92 = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
	local n1 = v92 + (plagueTimeOffset or 0)

	v92 = false

	if replicatedStorage:GetAttribute("PlagueEnabled") == true then
		v92 = false

		if n1 >= (replicatedStorage:GetAttribute("PlagueStartAt") or math.huge) then
			local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")

			v92 = n1 < (plagueEndAt or 0)
		end
	end

	return v92
end
local function variant(p3, p4, p5)
	return rs(p3 .. p4.Key .. (if p5 then "_Purple" else ""))
end
local function chance()
	return LocalPlayer:GetAttribute("PlaguePurpleChance") or replicatedStorage:GetAttribute("PlaguePurpleChance") or 0.01
end
local function chanceText()
	return ("%g%%"):format((LocalPlayer:GetAttribute("PlaguePurpleChance") or replicatedStorage:GetAttribute("PlaguePurpleChance") or 0.01) * 100)
end
local function setText(p6, text)
	if p6 and p6:IsA("TextLabel") then
		p6.Text = text

		for iterFirst, iterSecond in p6:GetDescendants() do
			if iterSecond:IsA("TextLabel") then
				iterSecond.Text = text
			end
		end
	end
end
local function recolorSeq(p8, p9)
	local t7: {[any]: any} = {}

	for iterFirst, iterSecond in p8.Keypoints, nil, nil do
		local v108, v109, v110 = iterSecond.Value:ToHSV()

		table.insert(t7, ColorSequenceKeypoint.new(iterSecond.Time, Color3.fromHSV(p9, v109, v110)))
	end

	return ColorSequence.new(t7)
end
local function clearClones(p10)
	for iterFirst, value in {
		"RL_Counter",
		"RL_Claimed",
		"RL_Skip",
		"RL_Purple",
		"RL_PurpleFx",
		"RL_Rays"
	}, nil, nil do
		local value2 = p10:FindFirstChild(value)

		if value2 then
			value2:Destroy()
		end
	end
end
local function addClone(parent, p12, name)
	local clone = p12:Clone()

	clone.Name = name
	clone.Visible = true
	clone.ZIndex = math.max(clone.ZIndex, 5)
	clone.Parent = parent

	return clone
end

local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}

local function fxFrame(name, p15, p16, zIndex)
	local frame: Frame = Instance.new("Frame")

	frame.Name = name
	frame.BackgroundTransparency = 1
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = p15
	frame.Size = UDim2.fromScale(p16, p16)
	frame.ZIndex = zIndex

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.Parent = frame

	return frame
end
local function fxImage(parent, name, image, p21, imageColor3, imageTransparency, zIndex)
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Name = name
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.ImageColor3 = imageColor3
	imageLabel.ImageTransparency = imageTransparency
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.Size = UDim2.fromScale(p21, p21)
	imageLabel.ZIndex = zIndex
	imageLabel.Parent = parent

	return imageLabel
end
local function addPurpleRays(parent, p26, p27, p28, p29)
	local v138 = fxFrame(p26, p27, p28, 2)
	local v139 = fxImage(v138, "Glow", "rbxassetid://6673021984", 1.6, color3, 0.2, 1)

	t4[v139] = 0.2
	v139 = fxImage(v138, "Rays", "rbxassetid://98423083631913", 1.8, color3, 0.3, 2)
	t3[v139] = p29
	v138.Parent = parent
end
local function setIdentity(p30, p31, p32)
	local n1: number = if p32 then 0.78 else 0.27
	local itemName = p30:FindFirstChild("ItemName")
	local attributeValue: any = replicatedStorage:GetAttribute("PlagueName_" .. p31.Key .. (if p32 then "_Purple" else ""))

	setText(itemName, attributeValue or p31.Key)

	local attributeValue2: any = replicatedStorage:GetAttribute("PlagueIcon_" .. p31.Key .. (if p32 then "_Purple" else ""))
	local imageLabel = p30:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		if typeof(attributeValue2) == "string" and attributeValue2 ~= "" then
			imageLabel.Image = attributeValue2
		end

		imageLabel.ImageColor3 = Color3.new(1, 1, 1)
		imageLabel.ZIndex = 3

		if p32 then
			addPurpleRays(p30, "RL_Rays", imageLabel.Position, 0.55, 18)
		end
	end

	for iterFirst, value in { "ItemName", "Rarity" }, nil, nil do
		local value3 = p30:FindFirstChild(value)

		if value3 and value3:IsA("GuiObject") then
			value3.ZIndex = 4
		end
	end

	local questionMark = p30:FindFirstChild("QuestionMark")

	if questionMark and questionMark:IsA("GuiObject") then
		questionMark.Visible = false
	end

	local rarity3 = p30:FindFirstChild("Rarity")

	if rarity3 and rarity3:IsA("TextLabel") then
		local text = replicatedStorage:GetAttribute("PlagueRarity_" .. p31.Key .. (if p32 then "_Purple" else "")) or "Exclusive"

		rarity3.Text = text
		pcall(rarity.ApplyTextGradient, rarity3, text)
	end

	local rarityFade = p30:FindFirstChild("RarityFade")

	if rarityFade and rarityFade:IsA("GuiObject") then
		rarityFade.BackgroundColor3 = Color3.new(1, 1, 1)

		local uiGradient = rarityFade:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Color = ColorSequence.new(Color3.fromHSV(n1, 0.75, 0.9))
		end
	end

	if p31.Final then
		for iterFirst2, iterSecond in p30:GetChildren() do
			local uIGradient = if iterSecond:IsA("UIStroke") then iterSecond:FindFirstChildOfClass("UIGradient") else nil

			if uIGradient then
				uIGradient.Color = recolorSeq(uIGradient.Color, n1)
			end
		end

		if glow and glow:IsA("ImageLabel") then
			local v159, v160, v161 = glow.ImageColor3:ToHSV()

			glow.ImageColor3 = Color3.fromHSV(n1, v160, v161)
		end
	end
end

local v54 = UDim2.fromScale(0.5, 0.875)
local v55 = UDim2.fromScale(0.5, 0.875)
local v56 = UDim2.fromScale(0.5, 1.12)

local function setCounter(parent, p34, p35)
	local clone: Instance = counter_Kills:Clone()

	clone.Name = "RL_Counter"
	clone.Visible = true
	clone.ZIndex = math.max(clone.ZIndex, 5)
	clone.Parent = parent
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = v54

	local amount: Instance = clone:FindFirstChild("Amount")

	if amount and amount:IsA("TextLabel") then
		amount.RichText = true
		amount.Text = ("<font color=\"%s\">%d</font>/%d"):format("#9dff3a", math.min(p34, p35), p35)
	end

	local foundChild: Instance = clone:FindFirstChild("ItemName", true)

	if foundChild and foundChild:IsA("GuiObject") then
		foundChild.Visible = false
	end

	for iterFirst, iterSecond in clone:GetChildren() do
		if iterSecond:IsA("UIGradient") then
			iterSecond.Color = recolorSeq(iterSecond.Color, 0.27)
		end
	end

	local imageLabel: Instance = clone:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = "rbxassetid://118685076702166"
	end
end

local v58 = UDim2.fromScale(1, 0.44)

local function addPurpleChip(parent, p37)
	local attributeValue: any = replicatedStorage:GetAttribute("PlagueIcon_" .. p37.Key .. "_Purple")

	if typeof(attributeValue) == "string" and attributeValue ~= "" then
		addPurpleRays(parent, "RL_PurpleFx", v58, 0.4, 30)

		local v174 = fxFrame("RL_Purple", v58, 0.4, 6)

		fxImage(v174, "Icon", attributeValue, 1, Color3.new(1, 1, 1), 0, 1)

		local odds: TextLabel = Instance.new("TextLabel")

		odds.Name = "Odds"
		odds.BackgroundTransparency = 1
		odds.AnchorPoint = Vector2.new(0.5, 0.5)
		odds.Position = UDim2.fromScale(0.5, 0.98)
		odds.Size = UDim2.fromScale(1.3, 0.46)
		odds.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Bold)
		odds.TextScaled = true
		odds.TextColor3 = Color3.new(1, 1, 1)
		odds.Text = ("%g%%"):format((LocalPlayer:GetAttribute("PlaguePurpleChance") or replicatedStorage:GetAttribute("PlaguePurpleChance") or 0.01) * 100)
		odds.ZIndex = 2

		local uiGradient: UIGradient = Instance.new("UIGradient")
		local colorSequenceNew = ColorSequence.new

		uiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, color3),
			ColorSequenceKeypoint.new(0.42, color3),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.58, color3),
			ColorSequenceKeypoint.new(1, color3)
		})
		uiGradient.Parent = odds
		t5[uiGradient] = true

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Color = Color3.fromRGB(38, 6, 60)
		uiStroke.Thickness = 2
		uiStroke.Parent = odds
		odds.Parent = v174
		v174.Parent = parent

		return
	end
end
local function addSkip(parent, p39)
	local attributeValue: any = replicatedStorage:GetAttribute("PlagueSkipId_" .. p39.Key)
	local attributeValue3: any = replicatedStorage:GetAttribute("PlagueSkipPrice_" .. p39.Key)

	if typeof(attributeValue) == "number" and typeof(attributeValue3) == "number" then
		local clone: Instance = skipButton:Clone()

		clone.Name = "RL_Skip"
		clone.Visible = true
		clone.ZIndex = math.max(clone.ZIndex, 5)
		clone.Parent = parent
		clone.Position = v56

		local priceTextLabel: Instance = clone:FindFirstChild("PriceTextLabel")

		if priceTextLabel and priceTextLabel:IsA("TextLabel") then
			local v185 = utf8.char(57346)
			local text: string = tostring(attributeValue3)

			priceTextLabel.Text = v185 .. text
		end

		if clone:IsA("GuiButton") then
			clone.MouseButton1Click:Connect(function()
				marketplaceService:PromptProductPurchase(LocalPlayer, attributeValue)
			end)
		end

		return
	end
end
local function setDone(parent, p41)
	local clone: Instance = counter_Kills:Clone()

	clone.Name = "RL_Claimed"
	clone.Visible = true
	clone.ZIndex = math.max(clone.ZIndex, 5)
	clone.Parent = parent
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = v55

	local amount: Instance = clone:FindFirstChild("Amount")

	if amount and amount:IsA("TextLabel") then
		amount.RichText = false
		amount.Text = if p41 then "PURPLE!" else "UNLOCKED"
	end

	local foundChild: Instance = clone:FindFirstChild("ItemName", true)

	if foundChild and foundChild:IsA("GuiObject") then
		foundChild.Visible = false
	end

	for iterFirst, iterSecond in clone:GetChildren() do
		if iterSecond:IsA("UIGradient") then
			iterSecond.Color = recolorSeq(iterSecond.Color, if p41 then 0.78 else 0.27)
		end
	end

	local imageLabel: Instance = clone:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = "rbxassetid://111743756635965"
	end
end
local function currentRung()
	for key, value in t2 do
		if LocalPlayer:GetAttribute("PlagueGot_" .. value.Key) == nil then
			return key
		end
	end

	return nil
end
local function renderSlot(p42)
	local v198 = t2[p42]
	local v199 = t1[p42]

	clearClones(v199)

	local attributeValue: any = LocalPlayer:GetAttribute("PlagueGot_" .. v198.Key)
	local u201: boolean = attributeValue == "Purple"

	setIdentity(v199, v198, u201)

	if attributeValue == nil then
		local plagueKills: any = LocalPlayer:GetAttribute("PlagueKills")
		local attributeValue4: any = replicatedStorage:GetAttribute("PlagueAt_" .. v198.Key)

		setCounter(v199, plagueKills or 0, attributeValue4 or 0)
		addPurpleChip(v199, v198)

		local v204: boolean = false
		local v205

		for key, value in t2 do
			if LocalPlayer:GetAttribute("PlagueGot_" .. value.Key) == nil then
				v205 = key
				v204 = true

				break
			end
		end

		if not v204 then
			v205 = nil
		end

		if v205 == p42 then
			local v208: number = workspace:GetServerTimeNow()
			local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
			local n1 = v208 + (plagueTimeOffset or 0)
			local u211: boolean = false

			if replicatedStorage:GetAttribute("PlagueEnabled") == true then
				u211 = false

				if n1 >= (replicatedStorage:GetAttribute("PlagueStartAt") or math.huge) then
					local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")

					u211 = n1 < (plagueEndAt or 0)
				end
			end

			if u211 then
				addSkip(v199, v198)
			end
		end

		return
	end

	setDone(v199, u201)
end
local function renderStatus()
	if not rarity2 then
		return
	end

	local v213: number = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
	local n1 = v213 + (plagueTimeOffset or 0)
	local u216: boolean = false

	if replicatedStorage:GetAttribute("PlagueEnabled") == true then
		u216 = false

		if n1 >= (replicatedStorage:GetAttribute("PlagueStartAt") or math.huge) then
			local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")

			u216 = n1 < (plagueEndAt or 0)
		end
	end

	local s1

	if not u216 then
		local v219: number = workspace:GetServerTimeNow()
		local plagueTimeOffset2: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
		local plagueStartAt: any = replicatedStorage:GetAttribute("PlagueStartAt")

		s1 = if v219 + (plagueTimeOffset2 or 0) < (plagueStartAt or 0) then "The plague hasn't started yet." else "The plague is over."
	else
		local plagueRound: any = LocalPlayer:GetAttribute("PlagueRound")
		local v223 = LocalPlayer:GetAttribute("PlaguePurpleChance") or replicatedStorage:GetAttribute("PlaguePurpleChance") or 0.01
		local plaguePurpleMax: any = replicatedStorage:GetAttribute("PlaguePurpleMax")
		local v225 = ("<font color=\"%s\">ROUND %d</font> · "):format("#9dff3a", plagueRound or 1)
		local v226 = LocalPlayer:GetAttribute("PlaguePurpleChance") or replicatedStorage:GetAttribute("PlaguePurpleChance") or 0.01
		local v227 = ("Each reward has a <font color=\"%s\">%s chance</font> to be <font color=\"%s\">Purple</font>!"):format("#c77dff", ("%g%%"):format(v226 * 100), "#c77dff")

		s1 = v225 .. v227 .. (if v223 < (plaguePurpleMax or 0) then " Odds rise every round." else "")
	end

	rarity2.RichText = true
	rarity2.Text = s1
end
local function renderTimer()
	local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")
	local v229: number = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
	local n1 = (plagueEndAt or 0) - (v229 + (plagueTimeOffset or 0))
	local textLabel: Instance = timer:FindFirstChild("TextLabel")
	local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

	setText(textLabel, s1)
end
local function renderHeader()
	local imageLabel: Instance = header:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = "rbxassetid://83328195943307"
	end
end

local u67: boolean = false

runService.Heartbeat:Connect(function(deltaTime: number)
	if not u67 then
		return
	end

	local v236 = os.clock()

	for key, value in t3 do
		if key.Parent then
			key.Rotation = (key.Rotation + value * deltaTime) % 360
		else
			t3[key] = nil
		end
	end

	for key2, value2 in t4 do
		if key2.Parent then
			local sine = math.sin(v236 * 2.5)

			key2.ImageTransparency = value2 + (sine * 0.5 + 0.5) * 0.2
		else
			t4[key2] = nil
		end
	end

	for iterValue in t5 do
		if iterValue.Parent then
			iterValue.Offset = Vector2.new(v236 * 1.2 % 3 - 1.5, 0)
		else
			t5[iterValue] = nil
		end
	end
end)

local function renderAll()
	for i = 1, #t2 do
		renderSlot(i)
	end

	renderStatus()

	local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")
	local v245: number = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
	local n1 = (plagueEndAt or 0) - (v245 + (plagueTimeOffset or 0))
	local textLabel: Instance = timer:FindFirstChild("TextLabel")
	local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

	setText(textLabel, s1)

	local imageLabel: Instance = header:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = "rbxassetid://83328195943307"
	end
end

local u69 = nil

task.spawn(function()
	local hud: Instance = playerGui:WaitForChild("HUD", 10)
	local blackBackground2: Instance = hud and hud:FindFirstChild("BlackBackground2")

	if blackBackground2 and blackBackground2:IsA("GuiObject") then
		u69 = blackBackground2
	end
end)

local u70 = nil
local u71 = nil

local function ensurePopScale()
	if u70 and u70.Parent == scriptParent then
		return u70
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Parent = scriptParent
	u70 = popScale

	return popScale
end

local u73 = nil

local function hideBoard()
	local leaderboardServiceUI: Instance = playerGui:FindFirstChild("LeaderboardServiceUI")

	if leaderboardServiceUI and leaderboardServiceUI:IsA("ScreenGui") and leaderboardServiceUI.Enabled then
		leaderboardServiceUI.Enabled = false
		u73 = leaderboardServiceUI
	end
end
local function restoreBoard()
	if u73 and u73.Parent then
		u73.Enabled = true
	end

	u73 = nil
end
local function open()
	if u67 then
		return
	end

	u67 = true

	local leaderboardServiceUI: Instance = playerGui:FindFirstChild("LeaderboardServiceUI")

	if leaderboardServiceUI and leaderboardServiceUI:IsA("ScreenGui") and leaderboardServiceUI.Enabled then
		leaderboardServiceUI.Enabled = false
		u73 = leaderboardServiceUI
	end

	for i = 1, #t2 do
		renderSlot(i)
	end

	renderStatus()

	local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")
	local v258: number = workspace:GetServerTimeNow()
	local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
	local n1 = (plagueEndAt or 0) - (v258 + (plagueTimeOffset or 0))
	local textLabel: Instance = timer:FindFirstChild("TextLabel")
	local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

	setText(textLabel, s1)

	local imageLabel: Instance = header:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = "rbxassetid://83328195943307"
	end

	local v264

	if u70 and u70.Parent == scriptParent then
		v264 = u70
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Parent = scriptParent
		u70 = popScale
		v264 = popScale
	end

	v264.Scale = 0.85
	scriptParent.Visible = true

	if u69 then
		u69.Visible = true
	end

	if u71 then
		u71:Cancel()
	end

	u71 = tweenService:Create(v264, tweenInfo, { Scale = 1 })
	u71:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("Plague")
	activeWindowChanged:Fire("Plague")
	task.spawn(function()
		while u67 do
			task.wait(1)

			if u67 then
				renderStatus()

				local plagueEndAt2: any = replicatedStorage:GetAttribute("PlagueEndAt")
				local v305: number = workspace:GetServerTimeNow()
				local plagueTimeOffset3: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
				local n1 = (plagueEndAt2 or 0) - (v305 + (plagueTimeOffset3 or 0))
				local textLabel2: Instance = timer:FindFirstChild("TextLabel")
				local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

				setText(textLabel2, s1)
			end
		end
	end)
end
local function close()
	if not u67 then
		return
	end

	u67 = false

	if u73 and u73.Parent then
		u73.Enabled = true
	end

	u73 = nil

	local v267

	if u70 and u70.Parent == scriptParent then
		v267 = u70
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Parent = scriptParent
		u70 = popScale
		v267 = popScale
	end

	if u71 then
		u71:Cancel()
	end

	local v269: Tween = tweenService:Create(v267, tweenInfo2, { Scale = 0.92 })

	u71 = v269
	v269:Play()
	v269.Completed:Once(function()
		if not u67 then
			scriptParent.Visible = false

			if u69 then
				u69.Visible = false
			end

			v267.Scale = 1
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v271 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v271)
	windowBlur.hide("Plague")
end

scriptParent.Visible = false
activeWindowChanged.Event:Connect(function(p44)
	if p44 ~= "Plague" and u67 then
		close()
	end
end)

if closeButton and (not not closeButton:IsA("ImageButton") or not not closeButton:IsA("TextButton")) then
	closeButton.MouseButton1Click:Connect(close)
end

local t6: {[any]: any} = { "PlagueKills", "PlagueRound", "PlaguePurpleChance" }

for key, value2 in t2 do
	table.insert(t6, "PlagueGot_" .. value2.Key)
end

for key2, value3 in t6 do
	LocalPlayer:GetAttributeChangedSignal(value3):Connect(function()
		if u67 then
			for i = 1, #t2 do
				renderSlot(i)
			end

			renderStatus()

			local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")
			local v275: number = workspace:GetServerTimeNow()
			local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
			local n1 = (plagueEndAt or 0) - (v275 + (plagueTimeOffset or 0))
			local textLabel: Instance = timer:FindFirstChild("TextLabel")
			local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

			setText(textLabel, s1)

			local imageLabel: Instance = header:FindFirstChild("ImageLabel")

			if imageLabel and imageLabel:IsA("ImageLabel") then
				imageLabel.Image = "rbxassetid://83328195943307"
			end
		end
	end)
end

replicatedStorage.AttributeChanged:Connect(function(attribute: string)
	if u67 and string.sub(attribute, 1, 6) == "Plague" then
		for i = 1, #t2 do
			renderSlot(i)
		end

		renderStatus()

		local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")
		local v284: number = workspace:GetServerTimeNow()
		local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")
		local n1 = (plagueEndAt or 0) - (v284 + (plagueTimeOffset or 0))
		local textLabel: Instance = timer:FindFirstChild("TextLabel")
		local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

		setText(textLabel, s1)

		local imageLabel: Instance = header:FindFirstChild("ImageLabel")

		if imageLabel and imageLabel:IsA("ImageLabel") then
			imageLabel.Image = "rbxassetid://83328195943307"
		end
	end
end)

local plague_Open: BindableEvent = Instance.new("BindableEvent")

plague_Open.Name = "Plague_Open"
plague_Open.Parent = scriptParent
plague_Open.Event:Connect(function()
	if u67 then
		close()

		return
	end

	open()
end)

local events: Instance = scriptParentParent:FindFirstChild("Events")
local v85: Instance = events

if v85 then
	v85 = events:FindFirstChild("Plague")
end

if v85 and v85:IsA("GuiButton") then
	v85.MouseButton1Click:Connect(function()
		if u67 then
			close()

			return
		end

		open()
	end)

	local shine: Instance = v85:FindFirstChild("Shine")

	if shine then
		shineEffect.loop(shine, {
			duration = 1,
			offsetStart = Vector2.new(-1.8, 0),
			offsetEnd = Vector2.new(1.8, 0)
		})
	end

	if v85:IsA("ImageButton") then
		v85.Image = "rbxassetid://83328195943307"
		v85.HoverImage = "rbxassetid://83328195943307"
	end

	local countdown: Instance = v85:FindFirstChild("Countdown")

	if countdown and countdown:IsA("TextLabel") then
		eventTimer.driveLabel(countdown, function()
			local plagueEndAt: any = replicatedStorage:GetAttribute("PlagueEndAt")

			if typeof(plagueEndAt) == "number" then
				local plagueTimeOffset: any = replicatedStorage:GetAttribute("PlagueTimeOffset")

				return plagueEndAt - (plagueTimeOffset or 0)
			end

			return nil
		end, {
			redInFinalDay = true,
			onUpdate = function()
				v85.Visible = false
			end
		})
	end

	task.spawn(function()
		local v292
		local plagueTimeOffset
		local n1
		local u295
		local plagueEnabled
		local plagueEndAt

		while true do
			v85.Visible = false

			if u67 then
				v292 = workspace:GetServerTimeNow()
				plagueTimeOffset = replicatedStorage:GetAttribute("PlagueTimeOffset")
				n1 = v292 + (plagueTimeOffset or 0)
				u295 = false
				plagueEnabled = replicatedStorage:GetAttribute("PlagueEnabled")

				if plagueEnabled == true then
					u295 = false

					if n1 >= (replicatedStorage:GetAttribute("PlagueStartAt") or math.huge) then
						plagueEndAt = replicatedStorage:GetAttribute("PlagueEndAt")
						u295 = n1 < (plagueEndAt or 0)
					end
				end

				if not u295 and replicatedStorage:GetAttribute("PlagueEnabled") ~= true then
					close()
				end
			end

			task.wait(1)

			continue
		end
	end)
end

task.spawn(function()
	local v298
	local lobby
	local v300
	local v301
	local foundChild
	local v303

	v298 = nil

	while true do
		lobby = workspace:FindFirstChild("Lobby")
		v300 = lobby and lobby:FindFirstChild("PlagueDoctor") or workspace:FindFirstChild("PlagueDoctor")
		v301 = v300

		if v301 then
			foundChild = v300:FindFirstChildWhichIsA("ProximityPrompt", true)
			v301 = foundChild
		end

		if v301 and v301 ~= v298 then
			v298 = v301
			v303 = function(p46)
				if p46 == LocalPlayer and not u67 then
					open()
				end
			end
			v301.Triggered:Connect(v303)
		end

		task.wait(5)

		continue
	end
end)
