-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local fourthOfJulyTemplates: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("FourthOfJulyTemplates")
local counter_Kills: Instance = fourthOfJulyTemplates:WaitForChild("Counter_Kills")
local claimButton: Instance = fourthOfJulyTemplates:WaitForChild("ClaimOverlay"):WaitForChild("ClaimButton")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local color3 = Color3.fromRGB(234, 32, 40)
local color32 = Color3.fromRGB(185, 185, 185)
local color33 = Color3.fromRGB(70, 160, 255)
local module: {[any]: any} = {
	HUE = 0.995,
	HEX = "#ea2028",
	ICON = {
		Kills = "rbxassetid://124235179222482",
		Games = "rbxassetid://139917504241203",
		Mystery = "rbxassetid://132306510979247",
		Check = "rbxassetid://111743756635965",
		Coins = "rbxassetid://94471905923851",
		Hollow = "rbxassetid://137072570598240",
		Badge = "rbxassetid://89760006766649",
		ItemsBg = "rbxassetid://135240762967556"
	}
}

module.ICON.TileBg = "rbxassetid://99904878674512"

local color34 = Color3.fromRGB(70, 70, 70)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.93),
	NumberSequenceKeypoint.new(0.5, 0.8),
	NumberSequenceKeypoint.new(1, 0.55)
})

module.ICON.Brush = "rbxassetid://71088536784631"
Color3.fromRGB(215, 14, 30)

local function commas(p1)
	local floored = math.floor(p1)
	local text = tostring(floored)

	repeat
		local v42, v43 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v42
	until v43 == 0

	return text
end

module.commas = commas

local function setText(p2, text)
	if p2 and p2:IsA("TextLabel") then
		p2.Text = text

		for iterFirst, iterSecond in p2:GetDescendants() do
			if iterSecond:IsA("TextLabel") then
				iterSecond.Text = text
			end
		end
	end
end
local function recolorSeq(p4, p5)
	local t3: {[any]: any} = {}

	for iterFirst, iterSecond in p4.Keypoints, nil, nil do
		local v53, v54, v55 = iterSecond.Value:ToHSV()

		table.insert(t3, ColorSequenceKeypoint.new(iterSecond.Time, Color3.fromHSV(p5, v54, v55)))
	end

	return ColorSequence.new(t3)
end
local function clear(p6)
	for iterFirst, iterSecond in p6:GetChildren() do
		if string.sub(iterSecond.Name, 1, 3) == "RW_" then
			iterSecond:Destroy()
		end
	end
end

local t2: {[any]: any} = {
	"StartButton",
	"ClaimOverlay",
	"ClaimedLabel",
	"SkipButton",
	"Counter",
	"Amount",
	"ImageLabel",
	"QuestionMark",
	"Rarity"
}

local function resetSlot(parent)
	clear(parent)

	for key, value in t2 do
		local foundChild = parent:FindFirstChild(value)

		if foundChild and foundChild:IsA("GuiObject") then
			foundChild.Visible = false
		end
	end

	local rw_TileBg: ImageLabel = Instance.new("ImageLabel")

	rw_TileBg.Name = "RW_TileBg"
	rw_TileBg.BackgroundTransparency = 1
	rw_TileBg.Image = module.ICON.TileBg
	rw_TileBg.ImageColor3 = color34
	rw_TileBg.ScaleType = Enum.ScaleType.Crop
	rw_TileBg.AnchorPoint = Vector2.new(0.5, 0.5)
	rw_TileBg.Position = UDim2.fromScale(0.5, 0.4975)
	rw_TileBg.Size = UDim2.fromScale(1, 1.005)
	rw_TileBg.ZIndex = -2

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Rotation = 90
	uiGradient.Transparency = numberSequence
	uiGradient.Parent = rw_TileBg

	local uiCorner = parent:FindFirstChildOfClass("UICorner")

	if uiCorner then
		local clone = uiCorner:Clone()

		clone.Parent = rw_TileBg
	end

	rw_TileBg.Parent = parent

	local rarityFade = parent:FindFirstChild("RarityFade")

	if rarityFade and rarityFade:IsA("GuiObject") then
		rarityFade.BackgroundColor3 = Color3.new(1, 1, 1)

		local uiGradient2 = rarityFade:FindFirstChildOfClass("UIGradient")

		if uiGradient2 then
			uiGradient2.Color = ColorSequence.new(Color3.fromHSV(module.HUE, 0.8, 0.9))
		end
	end
end
local function setTitle(p8, p9, p10, p11)
	local itemName = p8:FindFirstChild("ItemName")

	setText(itemName, p9)

	if itemName and itemName:IsA("GuiObject") then
		itemName.ZIndex = 4

		if p10 and p11 then
			itemName.Position = UDim2.fromScale(0.5, p10)
			itemName.Size = UDim2.fromScale(0.88, p11)
		end
	end
end
local function setSub(p12, text, p14, p15)
	local rarity2 = p12:FindFirstChild("Rarity")

	if not rarity2 or not rarity2:IsA("TextLabel") then
		return
	end

	for iterFirst, iterSecond in rarity2:GetChildren() do
		if iterSecond:IsA("UIGradient") then
			iterSecond:Destroy()
		end
	end

	rarity2.Visible = true
	rarity2.RichText = true
	rarity2.Text = text

	local uiStroke = rarity2:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke.Enabled = false
	end

	rarity2.TextColor3 = Color3.new(1, 1, 1)
	rarity2.TextWrapped = true
	rarity2.Position = UDim2.fromScale(0.5, p15 or 0.19)
	rarity2.Size = UDim2.fromScale(0.94, if (p14 or 1) > 1 then 0.2 else 0.115)
	rarity2.ZIndex = 4
end
local function label(parent, name, text, p19, p20, zIndex)
	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Name = name
	textLabel.BackgroundTransparency = 1
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = p19
	textLabel.Size = p20
	textLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Bold)
	textLabel.TextScaled = true
	textLabel.RichText = true
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = text
	textLabel.ZIndex = zIndex

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Thickness = 1.5
	uiStroke.Parent = textLabel
	textLabel.Parent = parent

	return textLabel
end
local function image(parent, name, p24, p25, p26, zIndex)
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Name = name
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = p24 or ""
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = p25
	imageLabel.Size = p26
	imageLabel.ZIndex = zIndex
	imageLabel.Parent = parent

	return imageLabel
end
local function unstroked(p28)
	local uiStroke = p28:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke:Destroy()
	end

	return p28
end
local function body(p29, p30, p31, p32)
	local v103 = UDim2.fromScale(0.5, p31)
	local v104 = UDim2.fromScale(0.9, p32)
	local v105 = label(p29, "RW_Body", p30, v103, v104, 4)

	v105.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.SemiBold)
	v105.TextWrapped = true

	local uiStroke = v105:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke:Destroy()
	end

	return v105
end
local function rewardHint(p33, p34)
	if not p34.rewardHint then
		return
	end

	local s1: string = "<i>" .. p34.rewardHint .. "</i>"
	local v110 = UDim2.fromScale(0.5, 0.92)
	local v111 = UDim2.fromScale(0.8, 0.08)
	local v112 = label(p33, "RW_Hint", s1, v110, v111, 4)

	v112.TextColor3 = color32

	local uiStroke = v112:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke:Destroy()
	end
end
local function hollowLogo(parent, p36, p37)
	local rw_Hollow: Frame = Instance.new("Frame")

	rw_Hollow.Name = "RW_Hollow"
	rw_Hollow.BackgroundTransparency = 1
	rw_Hollow.ClipsDescendants = true
	rw_Hollow.AnchorPoint = Vector2.new(0.5, 0)
	rw_Hollow.Position = UDim2.fromScale(0.5, p36)
	rw_Hollow.Size = UDim2.fromScale(0.95, p37)
	rw_Hollow.ZIndex = 4

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 2
	uiAspectRatioConstraint.Parent = rw_Hollow

	local logo: ImageLabel = Instance.new("ImageLabel")

	logo.Name = "Logo"
	logo.BackgroundTransparency = 1
	logo.Image = module.ICON.Hollow
	logo.ScaleType = Enum.ScaleType.Fit
	logo.AnchorPoint = Vector2.new(0.5, 0.5)
	logo.Position = UDim2.fromScale(0.5, 0.5)
	logo.Size = UDim2.fromScale(1, 2)
	logo.ZIndex = 4
	logo.Parent = rw_Hollow
	rw_Hollow.Parent = parent
end
local function brushRow(_)
end
local function strip(parent, name, p41, p42, image, text, p45)
	local clone: Instance = counter_Kills:Clone()

	clone.Name = name
	clone.Visible = true
	clone.AnchorPoint = Vector2.new(0.5, 0)
	clone.Position = UDim2.fromScale(p41, 1.177)
	clone.Size = UDim2.fromScale(p42, 0.175)
	clone.ZIndex = 5
	clone.BackgroundTransparency = 1

	local v129: boolean = p42 >= 0.9
	local amount: Instance = clone:FindFirstChild("Amount")

	if amount and amount:IsA("TextLabel") then
		amount.RichText = true
		amount.Text = text
	end

	local foundChild: Instance = clone:FindFirstChild("ItemName", true)

	if foundChild and foundChild:IsA("TextLabel") then
		foundChild.Visible = p45 ~= nil
		setText(foundChild, p45 or "")

		if p42 < 0.9 then
			foundChild.Size = UDim2.fromScale(0.88 / p42, 0.7)
		end
	end

	for iterFirst, iterSecond in clone:GetChildren() do
		if iterSecond:IsA("UIGradient") then
			iterSecond:Destroy()
		end
	end

	local imageLabel: Instance = clone:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		if image then
			imageLabel.Image = image
			imageLabel.Size = UDim2.fromScale(0.5, 0.95)

			local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			uiAspectRatioConstraint.Parent = imageLabel
		else
			imageLabel.Visible = false
		end
	end

	clone.Parent = parent

	return clone
end
local function progressText(p46, p47)
	local hex = module.HEX
	local v139 = math.min(p46, p47)
	local v140 = commas(v139)

	v139 = commas(p47)

	return ("<font color=\"%s\">%s</font>/%s"):format(hex, v140, v139)
end
local function doneStrip(p48, p49, p50)
	strip(p48, "RW_Done", 0.5, 0.996, module.ICON.Check, p49, p50)
end
local function phaseStrip(p51, p52)
	if p52.phase == "soon" then
		strip(p51, "RW_Phase", 0.5, 0.996, nil, "Starts soon", "Not yet")

		return true
	end

	if p52.phase == "over" then
		strip(p51, "RW_Phase", 0.5, 0.996, nil, "Event over", "Too late")

		return true
	end

	return false
end
local function claimButton(parent, name, p55, p56, p57)
	local clone: Instance = claimButton:Clone()

	clone.Name = name
	clone.Visible = true
	clone.AnchorPoint = Vector2.new(0.5, 0)
	clone.Position = UDim2.fromScale(p55, 1.177)
	clone.Size = UDim2.fromScale(0.47, 0.175)
	clone.ZIndex = 6

	for iterFirst, iterSecond in clone:GetChildren() do
		if iterSecond:IsA("UIGradient") then
			iterSecond.Color = recolorSeq(iterSecond.Color, module.HUE)
		end
	end

	local textLabel: Instance = clone:FindFirstChild("TextLabel")

	setText(textLabel, p56)

	if clone:IsA("GuiButton") then
		clone.MouseButton1Click:Connect(p57)
	end

	clone.Parent = parent
end
local function renderMain(p58, p59)
	resetSlot(p58)
	hollowLogo(p58, 0.03, 0.3)
	setTitle(p58, "Main Quest", 0.335, 0.115)

	local v157 = ("Play <font color=\"%s\">%d games</font> and get <font color=\"%s\">%d kills</font>"):format(module.HEX, p59.mainGames, module.HEX, p59.mainKills)

	body(p58, v157, 0.64, 0.2)
	rewardHint(p58, p59)

	if p59.main then
		strip(p58, "RW_Done", 0.5, 0.996, module.ICON.Check, "COMPLETED", "Rewards paid")

		return
	end

	local u158

	if p59.phase == "soon" then
		strip(p58, "RW_Phase", 0.5, 0.996, nil, "Starts soon", "Not yet")
		u158 = true
	elseif p59.phase == "over" then
		strip(p58, "RW_Phase", 0.5, 0.996, nil, "Event over", "Too late")
		u158 = true
	else
		u158 = false
	end

	if not u158 then
		local games = module.ICON.Games
		local mainGames = p59.mainGames
		local hex = module.HEX
		local v162 = math.min(p59.games, mainGames)
		local v163 = commas(v162)

		v162 = commas(mainGames)

		local v164 = ("<font color=\"%s\">%s</font>/%s"):format(hex, v163, v162)

		strip(p58, "RW_Games", 0.25, 0.49, games, v164, "Games")

		local kills = module.ICON.Kills
		local mainKills = p59.mainKills
		local v167 = module.HEX

		v162 = math.min(p59.kills, mainKills)
		v163 = commas(v162)
		v162 = commas(mainKills)
		v164 = ("<font color=\"%s\">%s</font>/%s"):format(v167, v163, v162)
		strip(p58, "RW_Kills", 0.75, 0.49, kills, v164, "Kills")
	end
end
local function renderSecret(parent, p61)
	resetSlot(parent)

	local itemName = parent:FindFirstChild("ItemName")

	setText(itemName, "Secret Quest")

	if itemName and itemName:IsA("GuiObject") then
		itemName.ZIndex = 4
	end

	rewardHint(parent, p61)

	if p61.secret then
		body(parent, "You found every pumpkin!", 0.55, 0.3)
		strip(parent, "RW_Done", 0.5, 0.996, module.ICON.Check, "COMPLETED", "Rewards paid")

		return
	end

	local mystery = module.ICON.Mystery
	local v172 = UDim2.fromScale(0.5, 0.52)
	local v173 = UDim2.fromScale(0.6, 0.5)
	local rw_Mystery: ImageLabel = Instance.new("ImageLabel")

	rw_Mystery.Name = "RW_Mystery"
	rw_Mystery.BackgroundTransparency = 1
	rw_Mystery.Image = mystery or ""
	rw_Mystery.ScaleType = Enum.ScaleType.Fit
	rw_Mystery.AnchorPoint = Vector2.new(0.5, 0.5)
	rw_Mystery.Position = v172
	rw_Mystery.Size = v173
	rw_Mystery.ZIndex = 3
	rw_Mystery.Parent = parent

	local u175

	if p61.phase == "soon" then
		strip(parent, "RW_Phase", 0.5, 0.996, nil, "Starts soon", "Not yet")
		u175 = true
	elseif p61.phase == "over" then
		strip(parent, "RW_Phase", 0.5, 0.996, nil, "Event over", "Too late")
		u175 = true
	else
		u175 = false
	end

	if not u175 then
		strip(parent, "RW_Secret", 0.5, 0.996, nil, "???", "...")
	end
end
local function renderElite(parent, p63, p64)
	resetSlot(parent)

	local itemName = parent:FindFirstChild("ItemName")

	setText(itemName, "Elite Quest")

	if itemName and itemName:IsA("GuiObject") then
		itemName.ZIndex = 4
	end

	rewardHint(parent, p63)

	local v180 = if p63.elite then p63.items[p63.elite] else nil

	if v180 then
		local icon = v180.icon
		local v182 = UDim2.fromScale(0.5, 0.5)
		local v183 = UDim2.fromScale(0.8, 0.5)
		local rw_Claimed: ImageLabel = Instance.new("ImageLabel")

		rw_Claimed.Name = "RW_Claimed"
		rw_Claimed.BackgroundTransparency = 1
		rw_Claimed.Image = icon or ""
		rw_Claimed.ScaleType = Enum.ScaleType.Fit
		rw_Claimed.AnchorPoint = Vector2.new(0.5, 0.5)
		rw_Claimed.Position = v182
		rw_Claimed.Size = v183
		rw_Claimed.ZIndex = 3
		rw_Claimed.Parent = parent
		body(parent, v180.name .. (if p63.elite == "Knife" then " Knife" else " Gun") .. " claimed!", 0.8, 0.1)
		strip(parent, "RW_Done", 0.5, 0.996, module.ICON.Check, "CLAIMED", "Elite reward")

		return
	end

	v180 = p63.kills >= p63.eliteKills

	local itemsBg = module.ICON.ItemsBg
	local v186 = UDim2.fromScale(0.5, 0.4975)
	local v187 = UDim2.fromScale(1, 1.005)
	local rw_ItemsBg: ImageLabel = Instance.new("ImageLabel")

	rw_ItemsBg.Name = "RW_ItemsBg"
	rw_ItemsBg.BackgroundTransparency = 1
	rw_ItemsBg.Image = itemsBg or ""
	rw_ItemsBg.ScaleType = Enum.ScaleType.Fit
	rw_ItemsBg.AnchorPoint = Vector2.new(0.5, 0.5)
	rw_ItemsBg.Position = v186
	rw_ItemsBg.Size = v187
	rw_ItemsBg.ZIndex = 2
	rw_ItemsBg.Parent = parent
	rw_ItemsBg.ScaleType = Enum.ScaleType.Crop
	rw_ItemsBg.ImageTransparency = 0.78

	local uiCorner = parent:FindFirstChildOfClass("UICorner")

	if uiCorner then
		local clone = uiCorner:Clone()

		clone.Parent = rw_ItemsBg
	end

	local v191 = commas(p63.eliteKills)
	local v192 = UDim2.fromScale(0.5, 0.46)
	local v193 = UDim2.fromScale(0.85, 0.26)
	local v194 = label(parent, "RW_Goal", v191, v192, v193, 4)
	local uiStroke = v194:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke:Destroy()
	end

	v194.TextColor3 = color3
	v193 = UDim2.fromScale(0.5, 0.64)

	local v196 = UDim2.fromScale(0.5, 0.1)
	local uiStroke2 = label(parent, "RW_GoalUnit", "KILLS", v193, v196, 4):FindFirstChildOfClass("UIStroke")

	if uiStroke2 then
		uiStroke2:Destroy()
	end

	if v180 then
		for index, value in { "Knife", "Gun" }, nil, nil do
			claimButton(parent, "RW_Claim" .. value, if index == 1 then 0.25 else 0.75, if p63.claiming then "..." else if value == p63.confirm then "Sure?" else value, function()
				p64(value)
			end)
		end

		local v200 = UDim2.fromScale(0.5, 1.117)
		local v201 = UDim2.fromScale(0.95, 0.1)

		label(parent, "RW_PickCaption", "<i>Choose one, it's permanent</i>", v200, v201, 4)

		return
	end

	local u202

	if p63.phase == "soon" then
		strip(parent, "RW_Phase", 0.5, 0.996, nil, "Starts soon", "Not yet")
		u202 = true
	elseif p63.phase == "over" then
		strip(parent, "RW_Phase", 0.5, 0.996, nil, "Event over", "Too late")
		u202 = true
	else
		u202 = false
	end

	if not u202 then
		local kills = module.ICON.Kills
		local eliteKills = p63.eliteKills
		local hex = module.HEX
		local v206 = math.min(p63.kills, eliteKills)
		local v207 = commas(v206)

		v206 = commas(eliteKills)

		local v208 = ("<font color=\"%s\">%s</font>/%s"):format(hex, v207, v206)

		strip(parent, "RW_Kills", 0.5, 0.996, kills, v208, "Complete Kills")
	end
end
function module.render(p65, p66, p67)
	local content = p65:FindFirstChild("Content")

	if not content then
		return
	end

	local quest1 = content:FindFirstChild("Quest1")
	local quest2 = content:FindFirstChild("Quest2")
	local quest3 = content:FindFirstChild("Quest3")

	if quest1 then
		renderMain(quest1, p66)
	end

	if quest2 then
		renderSecret(quest2, p66)
	end

	if quest3 then
		renderElite(quest3, p66, p67)
	end
end

local color35 = Color3.fromRGB(255, 196, 40)

local function currencyRows(p68, p69, p70, p71)
	if p69 > 0 then
		local coins = module.ICON.Coins
		local v221 = commas(p69)

		table.insert(p68, { icon = coins, text = v221 .. " Coins", gloss = color35 })
	end

	if p70 > 0 then
		local t4: {[any]: any} = { icon = p71, text = s1, gloss = color3 }
		local s1: string = if p70 == 1 then "1 Wheel Ticket" else p70 .. " Wheel Tickets"

		table.insert(p68, t4)
	end
end
local function itemRow(p72, p73)
	return {
		icon = p72.icon,
		text = p72.name .. " " .. p73,
		rarity = p72.rarity or "Legendary"
	}
end
function module.rewardsFor(p74, p75)
	local t5: {[any]: any} = {}
	local v229 = p74 == 1 and p75.main or p74 == 2 and p75.secret

	if not v229 then
		v229 = false

		if p74 == 3 then
			v229 = p75.elite ~= nil
		end
	end

	if p74 == 1 then
		if p75.mainKnife then
			local mainKnife = p75.mainKnife

			table.insert(t5, {
				icon = mainKnife.icon,
				text = mainKnife.name .. " " .. "Knife",
				rarity = mainKnife.rarity or "Legendary"
			})
		end

		table.insert(t5, { text = "The Hollow Badge", icon = module.ICON.Badge, gloss = color33 })
		currencyRows(t5, p75.mainCoins, p75.mainTickets, p75.ticketIcon)
	elseif p74 == 2 then
		if p75.secretEmote then
			local secretEmote = p75.secretEmote

			table.insert(t5, {
				icon = secretEmote.icon,
				text = secretEmote.name .. " " .. "Emote",
				rarity = secretEmote.rarity or "Legendary"
			})
		end

		if p75.secretFinisher then
			local secretFinisher = p75.secretFinisher

			table.insert(t5, {
				icon = secretFinisher.icon,
				text = secretFinisher.name .. " " .. "Finisher",
				rarity = secretFinisher.rarity or "Legendary"
			})
		end

		currencyRows(t5, p75.secretCoins, p75.secretTickets, p75.ticketIcon)

		if #t5 == 0 then
			table.insert(t5, { text = "???", icon = module.ICON.Mystery, gloss = color32 })
		end
	else
		local knife = p75.items.Knife

		table.insert(t5, {
			icon = knife.icon,
			text = knife.name .. " " .. "Knife",
			rarity = knife.rarity or "Legendary"
		})
		table.insert(t5, { divider = "OR", dividerColor = color3 })

		local gun = p75.items.Gun

		table.insert(t5, {
			icon = gun.icon,
			text = gun.name .. " " .. "Gun",
			rarity = gun.rarity or "Legendary"
		})

		if p75.eliteFinisher or p75.eliteCoins > 0 or p75.eliteTickets > 0 then
			table.insert(t5, { divider = "PLUS", dividerColor = color32 })

			if p75.eliteFinisher then
				local eliteFinisher = p75.eliteFinisher

				table.insert(t5, {
					icon = eliteFinisher.icon,
					text = eliteFinisher.name .. " " .. "Finisher (built in)",
					rarity = eliteFinisher.rarity or "Legendary"
				})
			end

			currencyRows(t5, p75.eliteCoins, p75.eliteTickets, p75.ticketIcon)
		end
	end

	local v236 = color3
	local v237 = if p74 == 3 then p75.items.Knife else if p74 == 2 then p75.secretEmote or p75.secretFinisher else p75.mainKnife

	if v237 then
		local ok, result = pcall(rarity.GetColor, v237.rarity or "Legendary")

		if ok then
			v236 = result
		end
	end

	return {
		header = if v229 then "Rewards (received)" else "Rewards",
		rim = v236,
		rows = t5
	}
end

return module
