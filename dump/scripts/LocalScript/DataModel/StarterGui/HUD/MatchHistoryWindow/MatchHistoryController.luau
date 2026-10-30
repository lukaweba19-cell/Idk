-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local linePlot = require(replicatedStorageShared:WaitForChild("LinePlot"))
local hud: Instance = players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local closeMatchHistory: Instance = bindables:WaitForChild("CloseMatchHistory")
local matchHistory_Request: Instance = remotes:WaitForChild("MatchHistory_Request")
local u12 = nil
local u13 = nil
local shared: Instance = replicatedStorage:FindFirstChild("Shared")
local icons: Instance = shared and shared:FindFirstChild("Icons")

if icons then
	local ok, result = pcall(require, icons)

	if ok then
		u12 = result
	end
end

local catalogs: Instance = replicatedStorage:FindFirstChild("Catalogs")
local v19: Instance = catalogs

if v19 then
	v19 = catalogs:FindFirstChild("AbilityCatalog")
end

if v19 then
	local ok, result = pcall(require, v19)

	if ok then
		u13 = result
	end
end

local replayOpen: Instance = remotes:FindFirstChild("ReplayOpen")
local replaySave: Instance = remotes:FindFirstChild("ReplaySave")
local u24 = nil

local function confirmDialog(p1, p2, p3)
	if u24 == nil then
		u24 = bindables:WaitForChild("ConfirmModal", 5)
	end

	local v144 = u24

	if not v144 then
		return true
	end

	local ok, result = pcall(function()
		return v144:Invoke({ DeclineText = "Cancel", Header = p1, Body = p2, AcceptText = p3 })
	end)

	return ok and result == true
end
local function notify(p4)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(_GNotify, p4)
	end
end

local u27 = nil

local function noticeDialog(p5, p6)
	if u27 == nil then
		u27 = bindables:WaitForChild("NoticeModal", 5)
	end

	local v151 = u27

	if not v151 then
		return
	end

	pcall(function()
		v151:Invoke({ ButtonText = "OK", Header = p5, Body = p6 })
	end)
end

local color3 = Color3.fromRGB(46, 200, 90)
local color32 = Color3.fromRGB(196, 58, 58)
local color33 = Color3.fromRGB(150, 150, 150)

Color3.fromRGB(5, 117, 255)

local color34 = Color3.fromRGB(105, 105, 112)

Color3.fromRGB(122, 122, 128)

local color35 = Color3.fromRGB(122, 240, 158)
local color36 = Color3.fromRGB(255, 128, 128)

Color3.fromRGB(184, 184, 190)

local color37 = Color3.fromRGB(196, 196, 196)
local color38 = Color3.fromRGB(255, 255, 255)

Color3.fromRGB(255, 150, 60)
Color3.fromRGB(255, 205, 90)
Color3.fromRGB(255, 255, 255)

local matchHistoryWindow: Instance = hud:WaitForChild("MatchHistoryWindow")
local scrollingFrame: Instance = matchHistoryWindow:WaitForChild("Content"):WaitForChild("ScrollingFrame")
local list: Instance = matchHistoryWindow:WaitForChild("List")
local listScrollingFrame: Instance = list:WaitForChild("ScrollingFrame")
local templates: Instance = matchHistoryWindow:WaitForChild("Templates")
local card: Instance = templates:WaitForChild("Card")
local playerRow: Instance = templates:WaitForChild("PlayerRow")
local titleLabel: Instance = templates:WaitForChild("TitleLabel")
local subLabel: Instance = templates:WaitForChild("SubLabel")

templates:WaitForChild("StatChip")

local roundPip: Instance = templates:WaitForChild("RoundPip")
local skullChip: Instance = templates:WaitForChild("SkullChip")
local actionButton: Instance = templates:WaitForChild("ActionButton")
local iconButton: Instance = templates:WaitForChild("IconButton")
local cell: Instance = listScrollingFrame:WaitForChild("Cell")
local cellSelected: Instance = listScrollingFrame:WaitForChild("CellSelected")
local closeBtn: Instance = matchHistoryWindow:WaitForChild("CloseBtn")
local tabs: Instance = list:WaitForChild("Tabs")
local tabRecent: Instance = tabs:WaitForChild("TabRecent")
local tabSaved: Instance = tabs:WaitForChild("TabSaved")

local function setButtonText(p7, text)
	local textLabel = p7:FindFirstChild("TextLabel")

	if not textLabel or not textLabel:IsA("TextLabel") then
		return
	end

	textLabel.Text = text

	local textLabel2 = textLabel:FindFirstChild("TextLabel")

	if textLabel2 and textLabel2:IsA("TextLabel") then
		textLabel2.Text = text
	end
end

local textLabel: Instance = tabRecent:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	textLabel.Text = "RECENT"

	local textLabel3: Instance = textLabel:FindFirstChild("TextLabel")

	if textLabel3 and textLabel3:IsA("TextLabel") then
		textLabel3.Text = "RECENT"
	end
end

cell.Visible = false
cellSelected.Visible = false

for _, v in ipairs(templates:GetChildren()) do
	if v:IsA("GuiObject") then
		v.Visible = false
	end
end

local function cloneTemplate(p9)
	local clone = p9:Clone()

	clone.Visible = true

	return clone
end

scrollingFrame.CanvasSize = UDim2.new()
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

for _, v in ipairs(scrollingFrame:GetChildren()) do
	if v:IsA("GuiObject") then
		v:Destroy()
	end
end

for _, v in ipairs(listScrollingFrame:GetChildren()) do
	if (v:IsA("GuiButton") or v.Name == "CellHost") and v ~= cell and v ~= cellSelected then
		v:Destroy()
	end
end

local t1 = {}
local t2: {[any]: any} = {}
local u68 = nil
local n1 = 1
local u70: boolean = false
local u71: boolean = false
local t3 = {}
local n2 = 0
local u74: boolean = false
local u75: boolean = false
local s1 = "recent"

local function activeList()
	return s1 == "saved" and t3 or t1
end

local u78 = nil
local u79 = nil
local u80 = nil

local function markSaved(p10, p11)
	for _, v in ipairs({ t1, t3 }) do
		for _, iterValue in ipairs(v) do
			if typeof(iterValue) == "table" and p10 == iterValue.id then
				iterValue.saved = p11 or nil
			end
		end
	end
end
local function syncSavedFlags()
	local t5: {[any]: any} = {}

	for _, v in ipairs(t3) do
		if typeof(v) == "table" and typeof(v.id) == "string" then
			t5[v.id] = true
		end
	end

	local u167: boolean = false

	for _, v in ipairs(t1) do
		local v170 = typeof(v.id) == "string" and t5[v.id] or nil

		if v170 ~= v.saved then
			v.saved = v170
			u167 = true
		end
	end

	return u167
end
local function modeLabel(p12)
	local numberValue: number? = tonumber(p12)
	local floored = math.floor(numberValue or 1)
	local v174 = math.clamp(floored, 1, 4)

	return ("%dv%d"):format(v174, v174)
end
local function relativeTime(p13)
	if typeof(p13) == "number" and not (p13 <= 0) then
		local n1 = os.time() - p13

		if n1 < 60 then
			return "just now"
		end

		if n1 < 3600 then
			return ("%dm ago"):format((math.floor(n1 / 60)))
		end

		if n1 < 86400 then
			return ("%dh ago"):format((math.floor(n1 / 3600)))
		end

		return ("%dd ago"):format((math.floor(n1 / 86400)))
	end

	return ""
end
local function absoluteTime(p14)
	if typeof(p14) == "number" and not (p14 <= 0) then
		local dateText = os.date("*t", p14)

		return ("%d/%d/%d"):format(dateText.month, dateText.day, dateText.year)
	end

	return ""
end

absoluteTime = function(p15)
	if typeof(p15) == "number" and not (p15 <= 0) then
		local floored = math.floor(p15 / 60)
		local floored2 = math.floor(p15 % 60)

		if floored <= 0 then
			return ("%ds"):format(floored2)
		end

		return ("%dm %ds"):format(floored, floored2)
	end

	return nil
end

local function scoreText(p16)
	if typeof(p16.sf) == "number" and typeof(p16.sa) == "number" then
		return ("%d - %d"):format(p16.sf, p16.sa)
	end

	if p16.left then
		return "LEFT"
	end

	if p16.won then
		return "W"
	end

	return "L"
end
local function getScale()
	local y = scrollingFrame.AbsoluteSize.Y

	if y <= 0 then
		return 1
	end

	return (math.clamp(y / 315, 0.6, 1.15))
end
local function tintFade(p17, backgroundColor3, backgroundTransparency)
	local fade = p17:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.BackgroundColor3 = backgroundColor3

		if backgroundTransparency then
			fade.BackgroundTransparency = backgroundTransparency
		end
	end
end
local function makeGap(parent, layoutOrder, p22)
	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded = math.round(p22)
	local v194 = math.max(1, rounded)

	gap.Size = uDim2New(1, 0, 0, v194)
	gap.LayoutOrder = layoutOrder
	gap.Parent = parent
end
local function cloneTitle(parent, layoutOrder, text, p26, textColor3, p28)
	local clone: Instance = titleLabel:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Text = text
	clone.TextSize = math.round(p26)
	clone.Size = UDim2.new(1, 0, 0, 0)
	clone.AutomaticSize = Enum.AutomaticSize.Y

	if textColor3 then
		clone.TextColor3 = textColor3
	end

	local uIGradient = p28 and clone:FindFirstChildOfClass("UIGradient")

	if uIGradient then
		uIGradient.Enabled = false
	end

	clone.Parent = parent

	return clone
end
local function cloneSub(parent, layoutOrder, text, p32, p33)
	local clone: Instance = subLabel:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Text = text
	clone.RichText = true
	clone.TextWrapped = true
	clone.TextSize = math.round(p32)
	clone.Size = UDim2.new(1, 0, 0, 0)
	clone.AutomaticSize = Enum.AutomaticSize.Y
	clone.TextColor3 = p33 or color37
	clone.TextTransparency = 0
	clone.Parent = parent

	return clone
end
local function verticalList(parent, p35)
	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local uDimNew = UDim.new
	local rounded = math.round(p35)

	uiListLayout.Padding = uDimNew(0, rounded)
	uiListLayout.Parent = parent
end
local function cloneCard(parent, layoutOrder, backgroundColor3, p39)
	local clone: Instance = card:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Size = UDim2.new(1, 0, 0, 0)
	clone.AutomaticSize = Enum.AutomaticSize.Y

	local fade: Instance = clone:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.BackgroundColor3 = backgroundColor3
	end

	local body: Frame = Instance.new("Frame")

	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Size = UDim2.new(1, 0, 0, 0)
	body.AutomaticSize = Enum.AutomaticSize.Y
	body.ZIndex = 2
	verticalList(body, p39 * 4)

	local uiPadding: UIPadding = Instance.new("UIPadding")
	local rounded = math.round(p39 * 10)

	uiPadding.PaddingTop = UDim.new(0, rounded)
	uiPadding.PaddingBottom = UDim.new(0, rounded)
	uiPadding.PaddingLeft = UDim.new(0, rounded)
	uiPadding.PaddingRight = UDim.new(0, rounded)
	uiPadding.Parent = body
	body.Parent = clone
	clone.Parent = parent

	return clone, body
end

local color39 = Color3.fromRGB(56, 178, 95)
local color310 = Color3.fromRGB(205, 62, 62)

local function escapeRich(p40)
	return (tostring(p40 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end
local function findMVP(p41)
	local v225 = nil

	for _, v in ipairs(p41) do
		if typeof(v.k) == "number" and v.k > 0 then
			if v225 == nil or v225.k < v.k or v.k == v225.k and ((v225.d or 0) > (v.d or 0) or (v.d or 0) == (v225.d or 0) and (v225.a or 0) < (v.a or 0)) then
				v225 = v
			end
		end
	end

	return v225
end
local function deviceIcon(p42)
	if typeof(p42) ~= "string" or p42 == "" then
	elseif u12 and typeof(u12.Device) == "table" then
		local v229 = u12.Device[p42]

		if not v229 then
			local device = u12.Device
			local lowerText = string.lower(p42)

			v229 = device[lowerText]
		end

		return typeof(v229) == "string" and v229 ~= "" and v229 or nil
	end

	return nil
end
local function abilityIcon(p43)
	if typeof(p43) ~= "string" or p43 == "" then
	elseif u13 and typeof(u13.Get) == "function" then
		local ok, result = pcall(u13.Get, p43)

		if ok and typeof(result) == "table" then
			local resultIcon = result.Icon

			return typeof(resultIcon) == "string" and resultIcon ~= "" and resultIcon or nil
		end

		return nil
	end

	return nil
end

local t4: {[any]: any} = {}

local function buildRow(parent, layoutOrder, p46, p47, p48, _)
	local clone: Instance = playerRow:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder

	local uDim2New = UDim2.new
	local rounded = math.round(p47 * 46)

	clone.Size = uDim2New(1, 0, 0, rounded)

	local uiCorner: Instance = clone:FindFirstChildOfClass("UICorner")

	if uiCorner then
		uiCorner.CornerRadius = UDim.new(0, 0)
	end

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("UIStroke") then
			v:Destroy()
		end
	end

	clone.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	clone.BackgroundTransparency = 1

	local backgroundColor3 = p46.t == 1 and color39 or color310
	local fade: Instance = clone:FindFirstChild("Fade")

	if fade and fade:IsA("Frame") then
		fade.AnchorPoint = Vector2.new(0.5, 0.5)
		fade.Position = UDim2.fromScale(0.5, 0.5)
		fade.Size = UDim2.fromScale(1, 1)
		fade.BackgroundColor3 = backgroundColor3
		fade.BackgroundTransparency = if p46.me then 0.02 else 0.08
		fade.ZIndex = 0

		local uiCorner2: Instance = fade:FindFirstChildOfClass("UICorner")

		if uiCorner2 then
			uiCorner2.CornerRadius = UDim.new(0, 0)
		end

		local uiGradient: Instance = fade:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Rotation = 90

			local v252 = p46.me and NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 0.18)
			})

			if not v252 then
				v252 = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(1, 0.3)
				})
			end

			uiGradient.Transparency = v252
		end
	end

	local textScrim: Frame = Instance.new("Frame")

	textScrim.Name = "TextScrim"
	textScrim.BorderSizePixel = 0
	textScrim.BackgroundColor3 = Color3.new(0, 0, 0)
	textScrim.BackgroundTransparency = 0
	textScrim.AnchorPoint = Vector2.new(0.5, 0.5)
	textScrim.Position = UDim2.fromScale(0.5, 0.5)
	textScrim.Size = UDim2.fromScale(1, 1)
	textScrim.ZIndex = 1

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Rotation = 0
	uiGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(0.45, 0.85),
		NumberSequenceKeypoint.new(1, 1)
	})
	uiGradient.Parent = textScrim
	textScrim.Parent = clone

	local avatar: Instance = clone:FindFirstChild("Avatar")

	if avatar and avatar:IsA("ImageLabel") then
		avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48"):format((math.max(1, p46.u or 1)))
		avatar.ZIndex = 2
		pcall(function()
			local uiShadow: UIShadow = Instance.new("UIShadow")

			uiShadow.BlurRadius = UDim.new(0, 15)
			uiShadow.Transparency = 0.65
			pcall(function()
				uiShadow.Color = Color3.new(0, 0, 0)
			end)
			pcall(function()
				uiShadow.Color3 = Color3.new(0, 0, 0)
			end)
			uiShadow.Parent = avatar
		end)
	end

	local username: Instance = clone:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.RichText = true
		username.Text = tostring(p46.n or "Unknown" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		username.TextTruncate = Enum.TextTruncate.AtEnd
		username.ZIndex = 2
		username.TextColor3 = Color3.new(1, 1, 1)

		local uiGradient2: Instance = username:FindFirstChildOfClass("UIGradient")

		if uiGradient2 then
			uiGradient2.Enabled = false
		end

		if p48 then
			local crown: ImageLabel = Instance.new("ImageLabel")

			crown.Name = "Crown"
			crown.BackgroundTransparency = 1
			crown.Image = "rbxassetid://124892577221956"
			crown.ImageColor3 = Color3.fromRGB(255, 183, 67)
			crown.ScaleType = Enum.ScaleType.Fit
			crown.SizeConstraint = Enum.SizeConstraint.RelativeYY
			crown.AnchorPoint = Vector2.new(0, 0.5)
			crown.Size = UDim2.fromScale(0.85, 0.85)
			crown.ZIndex = 3
			username:GetPropertyChangedSignal("TextBounds"):Connect(function()
				local uDim2New = UDim2.new
				local rounded2 = math.round(username.TextBounds.X + p47 * 6)

				crown.Position = uDim2New(0, rounded2, 0.5, 0)
			end)

			local v259 = UDim2.new
			local rounded3 = math.round(username.TextBounds.X + p47 * 6)

			crown.Position = v259(0, rounded3, 0.5, 0)
			crown.Parent = username
		end
	end

	local role_Rank: Instance = clone:FindFirstChild("Role_Rank")

	if role_Rank and role_Rank:IsA("TextLabel") then
		role_Rank.Text = if p46.me then "You" else if p46.t == 1 then "Teammate" else "Opponent"
		role_Rank.TextColor3 = p46.me and color38 or color37
		role_Rank.TextTransparency = if p46.me then 0 else 0.15
		role_Rank.ZIndex = 2

		local numberValue: number? = tonumber(p46.u)
		local floored = math.floor(numberValue or 0)

		if floored > 0 then
			local v264 = t4[floored]

			if v264 then
				role_Rank.Text = "@" .. v264
			else
				task.spawn(function()
					local ok, result = pcall(players.GetNameFromUserIdAsync, players, floored)

					if ok and typeof(result) == "string" and result ~= "" then
						t4[floored] = result

						if role_Rank.Parent then
							role_Rank.Text = "@" .. result
						end
					end
				end)
			end
		end
	end

	local function squareIcon(name, image, imageTransparency)
		local imageLabel: ImageLabel = Instance.new("ImageLabel")

		imageLabel.Name = name
		imageLabel.BackgroundTransparency = 1
		imageLabel.BorderSizePixel = 0
		imageLabel.Image = image
		imageLabel.ImageTransparency = imageTransparency
		imageLabel.ScaleType = Enum.ScaleType.Fit
		imageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
		imageLabel.Size = UDim2.fromScale(0.62, 0.62)
		imageLabel.ZIndex = 2

		return imageLabel
	end

	local contributions: Instance = clone:FindFirstChild("Contributions")

	if contributions and contributions:IsA("GuiObject") then
		for _, v in ipairs(contributions:GetChildren()) do
			v:Destroy()
		end

		contributions.BackgroundTransparency = 1
		contributions.AnchorPoint = Vector2.new(0, 0.5)
		contributions.Position = UDim2.fromScale(0.54, 0.5)
		contributions.Size = UDim2.fromScale(0.12, 1)

		local v269 = deviceIcon(p46.dv)

		if v269 then
			local v270 = squareIcon("Device", v269, 0.25)

			v270.AnchorPoint = Vector2.new(0, 0.5)
			v270.Position = UDim2.fromScale(0, 0.5)
			v270.Parent = contributions
		end
	end

	local skills: Frame = Instance.new("Frame")

	skills.Name = "Skills"
	skills.BackgroundTransparency = 1
	skills.BorderSizePixel = 0
	skills.AnchorPoint = Vector2.new(0, 0.5)
	skills.Position = UDim2.fromScale(0.66, 0.5)
	skills.Size = UDim2.fromScale(0.15999999999999992, 1)
	skills.ZIndex = 2

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

	local uDimNew = UDim.new
	local rounded4 = math.round(p47 * 3)

	uiListLayout.Padding = uDimNew(0, rounded4)
	uiListLayout.Parent = skills

	if typeof(p46.ab) == "table" then
		local n1: number = 0

		for _, v in ipairs(p46.ab) do
			local v278 = abilityIcon(v)

			if v278 then
				n1 += 1

				local v279 = squareIcon("Skill" .. n1, v278, 0)

				v279.LayoutOrder = n1
				v279.Parent = skills
			end
		end
	end

	skills.Parent = clone

	local rank: Instance = clone:FindFirstChild("Rank")

	if rank and rank:IsA("TextLabel") then
		rank.Visible = true
		rank.AnchorPoint = Vector2.new(1, 0.5)
		rank.Position = UDim2.fromScale(0.97, 0.5)
		rank.Size = UDim2.fromScale(0.15, 0.42)
		rank.TextXAlignment = Enum.TextXAlignment.Right
		rank.RichText = true
		rank.ZIndex = 2

		if typeof(p46.k) == "number" then
			rank.Text = ("<b>%d</b>/%d/%d"):format(p46.k, p46.d or 0, p46.a or 0)
			rank.TextColor3 = color38
			rank.TextTransparency = if p46.me then 0 else 0.12
		else
			rank.Text = "--"
			rank.TextColor3 = Color3.fromRGB(230, 230, 230)
			rank.TextTransparency = 0.35
		end
	end

	clone.Parent = parent
end
local function buildScoreHeader(parent, layoutOrder, p55)
	local scoreHeader: Frame = Instance.new("Frame")

	scoreHeader.Name = "ScoreHeader"
	scoreHeader.BorderSizePixel = 0
	scoreHeader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	scoreHeader.BackgroundTransparency = 0.25

	local uDim2New = UDim2.new
	local rounded = math.round(p55 * 22)

	scoreHeader.Size = uDim2New(1, 0, 0, rounded)
	scoreHeader.LayoutOrder = layoutOrder
	scoreHeader.ZIndex = 2

	local function caption(name, p57, p58, p59)
		local clone: Instance = subLabel:Clone()

		clone.Visible = true
		clone.Name = name
		clone.Text = name
		clone.TextSize = math.round(p55 * 11)
		clone.FontFace = Font.new(clone.FontFace.Family, Enum.FontWeight.ExtraBold, clone.FontFace.Style)
		clone.TextColor3 = Color3.fromRGB(215, 215, 215)
		clone.TextTransparency = 0
		clone.TextXAlignment = p58 == 1 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
		clone.AutomaticSize = Enum.AutomaticSize.None
		clone.AnchorPoint = Vector2.new(p58, 0.5)
		clone.Position = UDim2.fromScale(p57, 0.5)
		clone.Size = UDim2.fromScale(p59, 1)
		clone.ZIndex = 3
		clone.Parent = scoreHeader
	end

	caption("PLAYER", 0.12, 0, 0.3)
	caption("DEVICE", 0.54, 0, 0.11)
	caption("SKILLS", 0.66, 0, 0.13)
	caption("K/D/A", 0.97, 1, 0.15)
	scoreHeader.Parent = parent
end
local function buildScoreboardCard(parent, layoutOrder, p62, p63, p64)
	if #p62 == 0 and #p63 == 0 then
		return layoutOrder
	end

	local clone: Instance = card:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.Size = UDim2.new(1, 0, 0, 0)
	clone.AutomaticSize = Enum.AutomaticSize.Y
	clone.ClipsDescendants = true

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("UIStroke") then
			v:Destroy()
		end
	end

	local n1 = layoutOrder + 1
	local fade: Instance = clone:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.Visible = false
	end

	local body: Frame = Instance.new("Frame")

	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Size = UDim2.new(1, 0, 0, 0)
	body.AutomaticSize = Enum.AutomaticSize.Y
	body.ZIndex = 2

	local rounded = math.round(p64 * 5)

	verticalList(body, rounded)
	body.Parent = clone
	clone.Parent = parent
	buildScoreHeader(body, 1, p64)

	local t6: {[any]: any} = {}

	for _, v in ipairs(p62) do
		table.insert(t6, v)
	end

	for _, v in ipairs(p63) do
		table.insert(t6, v)
	end

	local v305 = findMVP(t6)

	for i, v in ipairs(t6) do
		buildRow(body, i + 1, v, p64, v305 ~= nil and v.u == v305.u, i == #t6)
	end

	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded5 = math.round(p64 * 10)
	local v311 = math.max(1, rounded5)

	gap.Size = uDim2New(1, 0, 0, v311)
	gap.LayoutOrder = n1
	gap.Parent = parent

	return n1 + 1
end
local function buildRoundStrip(parent, layoutOrder, p67, p68)
	local roundStrip: Frame = Instance.new("Frame")

	roundStrip.Name = "RoundStrip"
	roundStrip.BackgroundTransparency = 1
	roundStrip.BorderSizePixel = 0
	roundStrip.Size = UDim2.new(1, 0, 0, 0)
	roundStrip.AutomaticSize = Enum.AutomaticSize.Y
	roundStrip.LayoutOrder = layoutOrder
	roundStrip.ZIndex = 2

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

	local uDimNew = UDim.new
	local rounded = math.round(p68 * 6)

	uiListLayout.Padding = uDimNew(0, rounded)
	uiListLayout.Wraps = true
	uiListLayout.Parent = roundStrip

	local rounded6 = math.round(p68 * 32)

	for i, v in ipairs(p67) do
		local frame: Frame = Instance.new("Frame")

		frame.Name = ("Round%d"):format(i)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Size = UDim2.new(0, rounded6, 0, 0)
		frame.AutomaticSize = Enum.AutomaticSize.Y
		frame.LayoutOrder = i
		frame.ZIndex = 2
		verticalList(frame, p68 * 5)

		local clone: Instance = roundPip:Clone()

		clone.Visible = true
		clone.LayoutOrder = 1
		clone.Size = UDim2.new(1, 0, 0, rounded6)

		if v.w == true then
			local backgroundColor3 = color3
			local fade: Instance = clone:FindFirstChild("Fade")

			if fade and fade:IsA("GuiObject") then
				fade.BackgroundColor3 = backgroundColor3
				fade.BackgroundTransparency = 0.05
			end
		elseif v.w == false then
			local v327 = color32
			local fade: Instance = clone:FindFirstChild("Fade")

			if fade and fade:IsA("GuiObject") then
				fade.BackgroundColor3 = v327
				fade.BackgroundTransparency = 0.05
			end
		else
			local v329 = color33
			local fade: Instance = clone:FindFirstChild("Fade")

			if fade and fade:IsA("GuiObject") then
				fade.BackgroundColor3 = v329
				fade.BackgroundTransparency = 0.15
			end
		end

		local fade: Instance = clone:FindFirstChild("Fade")

		if fade and fade:IsA("GuiObject") then
			fade.AnchorPoint = Vector2.new(0.5, 0.5)
			fade.Position = UDim2.fromScale(0.5, 0.5)
			fade.Size = UDim2.fromScale(1, 1)

			local uiGradient: Instance = fade:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				uiGradient.Rotation = 90
				uiGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
				uiGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(1, 0.45)
				})
			end
		end

		local num: Instance = clone:FindFirstChild("Num")

		if num and num:IsA("TextLabel") then
			num.Text = tostring(i)
			num.FontFace = Font.new(num.FontFace.Family, Enum.FontWeight.ExtraBold, num.FontFace.Style)
		end

		clone.Parent = frame

		local numberValue: number? = tonumber(v.k)
		local killBadge: ImageLabel = Instance.new("ImageLabel")

		killBadge.Name = "KillBadge"
		killBadge.BackgroundTransparency = 1
		killBadge.BorderSizePixel = 0
		killBadge.Image = "rbxassetid://86008352981886"
		killBadge.ImageColor3 = Color3.fromRGB(66, 66, 66)
		killBadge.ScaleType = Enum.ScaleType.Fit
		killBadge.LayoutOrder = 2

		local uDim2New = UDim2.new
		local rounded7 = math.round(p68 * 22)

		killBadge.Size = uDim2New(1, 0, 0, rounded7)
		killBadge.ZIndex = 2

		local clone2: Instance = skullChip:Clone()

		clone2.Visible = true
		clone2.Name = "Count"
		clone2.RichText = false
		clone2.AutomaticSize = Enum.AutomaticSize.None
		clone2.TextWrapped = false
		clone2.Text = tostring(numberValue or 0)
		clone2.TextSize = math.round(p68 * 13)
		clone2.TextTransparency = 0
		clone2.TextColor3 = color38
		clone2.TextXAlignment = Enum.TextXAlignment.Center
		clone2.FontFace = Font.new(clone2.FontFace.Family, Enum.FontWeight.ExtraBold, clone2.FontFace.Style)
		clone2.AnchorPoint = Vector2.new(0.5, 0.5)
		clone2.Position = UDim2.fromScale(0.5, 0.5)
		clone2.Size = UDim2.fromScale(1, 1)
		clone2.ZIndex = 3
		pcall(function()
			local uiShadow: UIShadow = Instance.new("UIShadow")

			uiShadow.BlurRadius = UDim.new(0, 20)
			uiShadow.Transparency = 0.5
			pcall(function()
				uiShadow.Color = Color3.fromRGB(66, 66, 66)
			end)
			pcall(function()
				uiShadow.Color3 = Color3.fromRGB(66, 66, 66)
			end)
			uiShadow.Parent = clone2
		end)

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		uiStroke.Thickness = 0.12
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Parent = clone2
		clone2.Parent = killBadge
		killBadge.Parent = frame
		frame.Parent = roundStrip
	end

	roundStrip.Parent = parent
end
local function comma(p69)
	local floored = math.floor(p69)
	local v342 = math.max(0, floored)
	local v343 = tostring(v342):reverse():gsub("(%d%d%d)", "%1,"):reverse()

	if v343:sub(1, 1) == "," then
		v343 = v343:sub(2)
	end

	return v343
end
local function buildHighlights(parent, p71, p72, p73)
	local board = p72.board

	if typeof(board) ~= "table" or #board == 0 then
		return p71
	end

	if p72.left then
		return p71
	end

	local u349 = p72.won == true
	local t7: {[any]: any} = {}
	local t8 = {}

	for _, v in ipairs(board) do
		if typeof(v.sk) == "number" and v.sk >= 2 then
			table.insert(v.t == 1 == u349 and t8 or t7, v)
		end
	end

	u349 = function(p74)
		table.sort(p74, function(p75, p76)
			return (p75.sk or 0) > (p76.sk or 0)
		end)
	end
	table.sort(t7, function(p75, p76)
		return (p75.sk or 0) > (p76.sk or 0)
	end)
	table.sort(t8, function(p75, p76)
		return (p75.sk or 0) > (p76.sk or 0)
	end)

	local t9: {[any]: any} = {}

	local function add(p77, p78, p79)
		if #t9 >= 4 then
			return
		end

		table.insert(t9, { icon = p77, text = p78, color = p79 })
	end

	for _, v in ipairs(t7) do
		local replacedText = tostring(v.n or "Unknown" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		local v359 = comma(v.sk)
		local v360 = ("<b>%s</b> lost a <font color=\"#FF963C\">%s</font> streak"):format(replacedText, v359)

		if not (#t9 >= 4) then
			table.insert(t9, { icon = "rbxassetid://118556890438958", text = v360, color = color37 })
		end
	end

	for _, v in ipairs(t8) do
		local replacedText2 = tostring(v.n or "Unknown" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		local v364 = comma(v.sk + 1)
		local v365 = ("<b>%s</b> extended to <font color=\"#FF963C\">%s</font>"):format(replacedText2, v364)

		if not (#t9 >= 4) then
			table.insert(t9, { icon = "rbxassetid://118556890438958", text = v365, color = color37 })
		end
	end

	t8 = findMVP(board)

	if t8 then
		local v366 = ("<b>%s</b> was the <font color=\"#FFCD5A\">MVP</font>"):format((tostring(t8.n or "Unknown" or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))

		if not (#t9 >= 4) then
			table.insert(t9, { icon = "rbxassetid://134564953812512", text = v366, color = color37 })
		end
	end

	if #t9 == 0 then
		return p71
	end

	local v367, v368 = cloneCard(parent, p71, color34, p73)
	local layoutOrder = p71 + 1

	cloneTitle(v368, 1, "MATCH HIGHLIGHTS", p73 * 17, color38, true)

	for i, v in ipairs(t9) do
		local highlight: Frame = Instance.new("Frame")

		highlight.Name = "Highlight"
		highlight.BackgroundTransparency = 1
		highlight.BorderSizePixel = 0
		highlight.Size = UDim2.new(1, 0, 0, 0)
		highlight.AutomaticSize = Enum.AutomaticSize.Y
		highlight.LayoutOrder = i + 1
		highlight.ZIndex = 2

		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local uDimNew = UDim.new
		local rounded = math.round(p73 * 6)

		uiListLayout.Padding = uDimNew(0, rounded)
		uiListLayout.Parent = highlight

		local icon: ImageLabel = Instance.new("ImageLabel")

		icon.Name = "Icon"
		icon.BackgroundTransparency = 1
		icon.BorderSizePixel = 0
		icon.Image = v.icon
		icon.ScaleType = Enum.ScaleType.Fit

		local uDim2FromOffset = UDim2.fromOffset
		local rounded8 = math.round(p73 * 16)
		local rounded9 = math.round(p73 * 16)

		icon.Size = uDim2FromOffset(rounded8, rounded9)
		icon.LayoutOrder = 1
		icon.ZIndex = 2
		icon.Parent = highlight

		local clone: Instance = subLabel:Clone()

		clone.Visible = true
		clone.Name = "Line"
		clone.RichText = true
		clone.TextWrapped = false
		clone.AutomaticSize = Enum.AutomaticSize.XY
		clone.Size = UDim2.fromOffset(0, 0)
		clone.TextSize = math.round(p73 * 13)
		clone.TextColor3 = v.color
		clone.TextTransparency = 0
		clone.Text = v.text
		clone.LayoutOrder = 2
		clone.ZIndex = 2
		clone.Parent = highlight
		highlight.Parent = v368
	end

	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local uDim2New = UDim2.new
	local rounded10 = math.round(p73 * 10)
	local v384 = math.max(1, rounded10)

	gap.Size = uDim2New(1, 0, 0, v384)
	gap.LayoutOrder = layoutOrder
	gap.Parent = parent

	return layoutOrder + 1
end
local function raceWinChance(p80, p81, p82)
	if p82 <= 0 then
		return 0.5
	end

	if p80 >= p82 then
		return 1
	end

	if p81 >= p82 then
		return 0
	end

	local n1 = p82 - p80
	local n2 = 0
	local n3 = 0.5 ^ n1

	for i = 0, p82 - p81 - 1 do
		n2 += n3
		n3 = n3 * 0.5 * (n1 + i) / (i + 1)
	end

	return (math.clamp(n2, 0, 1))
end
local function roundsToWin(p83)
	if typeof(p83.rtw) == "number" and p83.rtw >= 1 then
		return (math.floor(p83.rtw))
	end

	if not p83.left then
		local numberValue: number? = tonumber(p83.sf)
		local numberValue2: number? = tonumber(p83.sa)

		if numberValue and numberValue2 then
			local v395 = math.max(numberValue, numberValue2)

			if v395 >= 1 then
				return (math.floor(v395))
			end

			return 5
		end

		return 5
	end

	return 5
end
local function buildMomentum(parent, p85, p86, p87)
	if p86.left then
		local v400, v401 = cloneCard(parent, p85, color34, p87)
		local layoutOrder = p85 + 1

		cloneTitle(v401, 1, "MATCH MOMENTUM", p87 * 17, color38, true)

		local unavailable: Frame = Instance.new("Frame")

		unavailable.Name = "Unavailable"
		unavailable.BackgroundTransparency = 1
		unavailable.BorderSizePixel = 0

		local uDim2New = UDim2.new
		local rounded = math.round(p87 * 48)

		unavailable.Size = uDim2New(1, 0, 0, rounded)
		unavailable.LayoutOrder = 2
		unavailable.ZIndex = 2

		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local uDimNew = UDim.new
		local rounded11 = math.round(p87 * 8)

		uiListLayout.Padding = uDimNew(0, rounded11)
		uiListLayout.Parent = unavailable

		local disconnect: ImageLabel = Instance.new("ImageLabel")

		disconnect.Name = "Disconnect"
		disconnect.BackgroundTransparency = 1
		disconnect.Image = "rbxassetid://106793670482037"
		disconnect.ScaleType = Enum.ScaleType.Fit

		local uDim2FromOffset = UDim2.fromOffset
		local rounded12 = math.round(p87 * 28)
		local rounded13 = math.round(p87 * 28)

		disconnect.Size = uDim2FromOffset(rounded12, rounded13)
		disconnect.LayoutOrder = 1
		disconnect.ZIndex = 2
		disconnect.Parent = unavailable

		local clone: Instance = subLabel:Clone()

		clone.Visible = true
		clone.Name = "Label"
		clone.AutomaticSize = Enum.AutomaticSize.XY
		clone.Size = UDim2.fromOffset(0, 0)
		clone.TextWrapped = false
		clone.TextSize = math.round(p87 * 15)
		clone.TextColor3 = color37
		clone.TextTransparency = 0
		clone.Text = "Unavailable"
		clone.LayoutOrder = 2
		clone.ZIndex = 2
		clone.Parent = unavailable
		unavailable.Parent = v401

		local gap: Frame = Instance.new("Frame")

		gap.Name = "Gap"
		gap.BackgroundTransparency = 1
		gap.BorderSizePixel = 0

		local v415 = UDim2.new
		local rounded14 = math.round(p87 * 10)
		local v417 = math.max(1, rounded14)

		gap.Size = v415(1, 0, 0, v417)
		gap.LayoutOrder = layoutOrder
		gap.Parent = parent

		return layoutOrder + 1
	end

	local rounds = p86.rounds

	if typeof(rounds) == "table" and not (#rounds < 2) then
		local v419 = roundsToWin(p86)

		if not v419 then
			return p85
		end

		local t10: {[any]: any} = { { r = 0, a = 0, b = 0, p = raceWinChance(0, 0, v419) } }
		local n2: number = 0
		local n3 = 0

		for i, v in ipairs(rounds) do
			if v.w == true then
				n2 += 1
			elseif v.w == false then
				n3 += 1
			end

			local v425 = raceWinChance(n2, n3, v419)

			table.insert(t10, { r = i, a = n2, b = n3, p = v425 })
		end

		if #t10 < 2 then
			return p85
		end

		if #t10 > 100 then
			return p85
		end

		n3 = p86.won == true and color3 or color32

		local v426, v427 = cloneCard(parent, p85, color34, p87)
		local n4 = p85 + 1

		cloneTitle(v427, 1, "MATCH MOMENTUM", p87 * 17, color38, true)

		local t11: {[any]: any} = {}

		for i, v in ipairs(t10) do
			t11[i] = { y = v.p, data = v }
		end

		local linePlotBuild = linePlot.build
		local v433 = UDim2.new
		local rounded = math.round(p87 * 104)
		local uDim2 = v433(1, 0, 0, rounded)

		linePlotBuild({
			name = "Plot",
			layoutOrder = 2,
			zIndex = 2,
			yMin = 0,
			yMax = 1,
			emphasisGridline = 0.5,
			parent = v427,
			size = uDim2,
			points = t11,
			gridlines = { 0.25, 0.5, 0.75 },
			lineColor = n3,
			scale = p87,
			tipTemplate = subLabel,
			tipLines = {
				{ size = 13, color = color38 },
				{ size = 12, color = color37 },
				{ size = 12, color = n3 }
			},
			formatTip = function(p88)
				local s1 = if p88.r == 0 then "Start" else ("Round %d"):format(p88.r)
				local v688 = ("Win chance: <b>%d%%</b>"):format((math.round(p88.p * 100)))

				return { s1, v688, ("%d - %d"):format(p88.a, p88.b) }
			end,
			pointName = function(p89)
				return ("Pt%d"):format(p89.r)
			end,
			clipTo = scrollingFrame,
			window = matchHistoryWindow
		})

		local frame: Frame = Instance.new("Frame")

		frame.Name = "Gap"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0

		local v437 = UDim2.new
		local rounded15 = math.round(p87 * 10)
		local v439 = math.max(1, rounded15)

		frame.Size = v437(1, 0, 0, v439)
		frame.LayoutOrder = n4
		frame.Parent = parent

		return n4 + 1
	end

	return p85
end
local function disableButton(p90, p91, p92)
	local uiGradient = p90:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local colorSequenceNew = ColorSequence.new

		uiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
			ColorSequenceKeypoint.new(0.09, Color3.fromRGB(88, 88, 88)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52))
		})
	end

	if p91 and p91:IsA("TextLabel") then
		p91.TextColor3 = Color3.fromRGB(30, 30, 30)
	end

	if p92 and p92:IsA("TextLabel") then
		p92.TextColor3 = Color3.fromRGB(190, 190, 190)
	end

	p90.Active = false
	p90.AutoButtonColor = false
end
local function tintButton(p93, p94, p95, p96, textColor3)
	local uiGradient = p93:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local colorSequenceNew = ColorSequence.new

		uiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, p94),
			ColorSequenceKeypoint.new(0.09, p95),
			ColorSequenceKeypoint.new(1, p96)
		})
	end

	local v452 = textColor3 and p93:FindFirstChild("TextLabel")

	if v452 and v452:IsA("TextLabel") then
		v452.TextColor3 = textColor3
	end
end

local color311 = Color3.fromRGB(214, 240, 210)
local color312 = Color3.fromRGB(96, 214, 110)
local color313 = Color3.fromRGB(22, 122, 48)
local color314 = Color3.fromRGB(10, 74, 34)
local color315 = Color3.fromRGB(245, 210, 210)
local color316 = Color3.fromRGB(226, 88, 88)
local color317 = Color3.fromRGB(132, 24, 24)
local color318 = Color3.fromRGB(84, 12, 12)
local color319 = Color3.fromRGB(239, 235, 204)
local color320 = Color3.fromRGB(250, 226, 53)
local color321 = Color3.fromRGB(223, 152, 0)
local color322 = Color3.fromRGB(126, 84, 0)

local function buildReplayButton(parent, layoutOrder, p100, _)
	local clone: Instance = actionButton:Clone()

	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.Size = UDim2.new(1, 0, 1, 0)

	if p100.won ~= true then
		tintButton(clone, color315, color316, color317, color318)
	end

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("UIStroke") and math.round(v.Color.R * 255) == 8 and math.round(v.Color.G * 255) == 46 and math.round(v.Color.B * 255) == 22 then
			v.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			v.Thickness = 0.065
		end
	end

	local u460: boolean = p100.replay == true and typeof(p100.id) == "string"
	local textLabel4: Instance = clone:FindFirstChild("TextLabel")
	local textLabel: Instance = textLabel4 and textLabel4:FindFirstChild("TextLabel")

	local function setText(text)
		if textLabel4 and textLabel4:IsA("TextLabel") then
			textLabel4.Text = text
		end

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text
		end
	end

	if textLabel4 and textLabel4:IsA("TextLabel") then
		textLabel4.TextTransparency = 1
	end

	if textLabel and textLabel:IsA("TextLabel") then
		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		uiStroke.Thickness = 0.16
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Transparency = 0.25
		uiStroke.Parent = textLabel
	end

	if not u460 then
		if textLabel4 and textLabel4:IsA("TextLabel") then
			textLabel4.Text = "REPLAY UNAVAILABLE"
		end

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = "REPLAY UNAVAILABLE"
		end

		disableButton(clone, textLabel4, textLabel)
		clone.Parent = parent

		return
	end

	if textLabel4 and textLabel4:IsA("TextLabel") then
		textLabel4.Text = "▶ WATCH REPLAY"
	end

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = "▶ WATCH REPLAY"
	end

	local u465: boolean = false

	clone.MouseButton1Click:Connect(function()
		if u465 then
			return
		end

		if not replayOpen then
			if textLabel4 and textLabel4:IsA("TextLabel") then
				textLabel4.Text = "REPLAY UNAVAILABLE"
			end

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = "REPLAY UNAVAILABLE"
			end

			return
		end

		u465 = true

		if textLabel4 and textLabel4:IsA("TextLabel") then
			textLabel4.Text = "OPENING..."
		end

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = "OPENING..."
		end

		replayOpen:FireServer(p100.id)
		closeMatchHistory:Fire()
	end)
	clone.Parent = parent
end
local function invokeSave(p103, p104)
	local v468: Instance = replaySave

	if not v468 then
		return nil
	end

	local ok, result = pcall(function()
		return v468:InvokeServer(p103, p104)
	end)

	if not ok then
		local text: string = tostring(result)

		warn("[MatchHistory] ReplaySave." .. p103 .. " failed: " .. text)

		return nil
	end

	return typeof(result) == "table" and result or nil
end
local function buildSaveButton(parent, p106, p107)
	if replaySave and typeof(p106.id) == "string" then
		local u475: boolean = s1 == "saved"
		local u476: boolean = u475 or p106.saved == true

		if not u476 and p106.replay ~= true then
			return nil
		end

		local clone: Instance = iconButton:Clone()

		clone.Visible = true
		clone.Size = UDim2.new(1, 0, 1, 0)

		local icon: Instance = clone:FindFirstChild("Icon")
		local iconShadow: Instance = clone:FindFirstChild("IconShadow")

		local function setIcon(image, imageColor3)
			if icon and icon:IsA("ImageLabel") then
				icon.Image = image
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.Image = image
				iconShadow.ImageColor3 = imageColor3
			end
		end

		if u475 then
			tintButton(clone, color315, color316, color317)

			local imageColor3 = color318

			if icon and icon:IsA("ImageLabel") then
				icon.Image = "rbxassetid://116299202975980"
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.Image = "rbxassetid://116299202975980"
				iconShadow.ImageColor3 = imageColor3
			end
		elseif u476 then
			tintButton(clone, color319, color320, color321)

			local v482 = color322

			if icon and icon:IsA("ImageLabel") then
				icon.Image = "rbxassetid://111743756635965"
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.Image = "rbxassetid://111743756635965"
				iconShadow.ImageColor3 = v482
			end
		elseif p106.won == true then
			tintButton(clone, color311, color312, color313)

			local v483 = color314

			if icon and icon:IsA("ImageLabel") then
				icon.Image = "rbxassetid://92864977669472"
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.Image = "rbxassetid://92864977669472"
				iconShadow.ImageColor3 = v483
			end
		else
			tintButton(clone, color315, color316, color317)

			local v484 = color318

			if icon and icon:IsA("ImageLabel") then
				icon.Image = "rbxassetid://92864977669472"
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.Image = "rbxassetid://92864977669472"
				iconShadow.ImageColor3 = v484
			end
		end

		if iconShadow and iconShadow:IsA("ImageLabel") then
			iconShadow.ImageTransparency = 0.7
		end

		if not u475 and not u476 and n2 <= 0 and u75 then
			disableButton(clone, nil, nil)

			if icon and icon:IsA("ImageLabel") then
				icon.ImageColor3 = Color3.fromRGB(190, 190, 190)
			end

			if iconShadow and iconShadow:IsA("ImageLabel") then
				iconShadow.ImageColor3 = Color3.fromRGB(30, 30, 30)
			end

			clone.Parent = parent

			return clone
		end

		local u485: boolean = false

		clone.MouseButton1Click:Connect(function()
			if u485 then
				return
			end

			u485 = true
			task.spawn(function()
				local s1: string = if not u475 and not u476 then "save" else "unsave"

				if s1 == "unsave" then
					local v718 = ("Remove the %s replay from your saved list? You can save it again later only while the match is still in your recent history."):format(p106.map ~= "" and tostring(p106.map) or "this match")

					if u24 == nil then
						u24 = bindables:WaitForChild("ConfirmModal", 5)
					end

					local v719 = u24
					local u721

					if not v719 then
						u721 = true
					else
						local s2: string = "Delete saved replay?"
						local s3: string = "Delete"

						local ok, result = pcall(function()
							return v719:Invoke({ DeclineText = "Cancel", Header = s2, Body = v718, AcceptText = s3 })
						end)

						u721 = ok and result == true
					end

					if not u721 then
						u485 = false

						return
					end
				elseif n2 > 0 and #t3 >= n2 then
					local v725 = ("You must delete a saved replay before you can save any more. You've used all %d slots."):format(n2)

					if u27 == nil then
						u27 = bindables:WaitForChild("NoticeModal", 5)
					end

					local v726 = u27

					if v726 then
						local s4: string = "Saved replays full"

						pcall(function()
							v726:Invoke({ ButtonText = "OK", Header = s4, Body = v725 })
						end)
					end

					u485 = false

					return
				end

				local v728 = invokeSave(s1, p106.id)

				if v728 and v728.ok == true then
					if typeof(v728.cap) == "number" then
						n2 = v728.cap
					end

					markSaved(p106.id, s1 == "save")

					local s5 = ""

					if typeof(v728.count) == "number" and typeof(v728.cap) == "number" and v728.cap > 0 then
						s5 = ("  •  %d/%d saved"):format(v728.count, v728.cap)
					end

					local t16: {[any]: any} = {
						notifType = "SuccessNotification",
						topText = if s1 == "save" then "Replay Saved!" else "Replay Deleted"
					}
					local v731 = p106.map ~= "" and tostring(p106.map) or "Match"

					t16.bottomText = v731 .. s5

					local _GNotify = _G.Notify

					if typeof(_GNotify) == "function" then
						pcall(_GNotify, t16)
					end

					if s1 == "unsave" then
						for i = #t3, 1, -1 do
							local v734 = t3[i]

							if typeof(v734) == "table" and v734.id == p106.id then
								table.remove(t3, i)
							end
						end

						u80()
					end

					u79(true)
					p107()

					return
				end

				local v735 = v728 and typeof(v728.err) == "string" and v728.err or "Something went wrong."
				local t17: {[any]: any} = {
					notifType = "FailNotification",
					topText = if s1 == "save" then "Couldn't Save Replay" else "Couldn't Delete Replay",
					errorMessage = v735
				}
				local notify = _G.Notify

				if typeof(notify) == "function" then
					pcall(notify, t17)
				end

				u485 = false
			end)
		end)
		clone.Parent = parent

		return clone
	end

	return nil
end
local function buildActionRow(parent, layoutOrder, p112, p113, p114)
	local rounded = math.round(p113 * 34)
	local actionRow: Frame = Instance.new("Frame")

	actionRow.Name = "ActionRow"
	actionRow.BackgroundTransparency = 1
	actionRow.BorderSizePixel = 0
	actionRow.Size = UDim2.new(1, 0, 0, rounded)
	actionRow.LayoutOrder = layoutOrder
	actionRow.ZIndex = 2

	local rounded16 = math.round(p113 * 10)
	local iconSlot: Frame = Instance.new("Frame")

	iconSlot.Name = "IconSlot"
	iconSlot.BackgroundTransparency = 1
	iconSlot.BorderSizePixel = 0
	iconSlot.AnchorPoint = Vector2.new(1, 0)
	iconSlot.Position = UDim2.fromScale(1, 0)
	iconSlot.Size = UDim2.new(0, rounded, 1, 0)
	iconSlot.ZIndex = 3
	iconSlot.Parent = actionRow

	if not buildSaveButton(iconSlot, p112, p114) then
		iconSlot:Destroy()

		local replaySlot: Frame = Instance.new("Frame")

		replaySlot.Name = "ReplaySlot"
		replaySlot.BackgroundTransparency = 1
		replaySlot.BorderSizePixel = 0
		replaySlot.Size = UDim2.new(1, 0, 1, 0)
		replaySlot.ZIndex = 2
		replaySlot.Parent = actionRow
		buildReplayButton(replaySlot, 1, p112, p113)
		actionRow.Parent = parent

		return
	end

	local frame: Frame = Instance.new("Frame")

	frame.Name = "ReplaySlot"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, -(rounded + rounded16), 1, 0)
	frame.ZIndex = 2
	frame.Parent = actionRow
	buildReplayButton(frame, 1, p112, p113)
	actionRow.Parent = parent
end
local function buildDetailFrame(p115)
	local y = scrollingFrame.AbsoluteSize.Y
	local n1 = if y <= 0 then 1 else math.clamp(y / 315, 0.6, 1.15)
	local detail: Frame = Instance.new("Frame")

	detail.Name = "Detail"
	detail.Size = UDim2.new(1, 0, 0, 0)
	detail.AutomaticSize = Enum.AutomaticSize.Y
	detail.BackgroundTransparency = 1
	detail.BorderSizePixel = 0
	verticalList(detail, 0)

	local uiPadding: UIPadding = Instance.new("UIPadding")

	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.PaddingLeft = UDim.new(0, 4)
	uiPadding.PaddingRight = UDim.new(0, 10)
	uiPadding.PaddingBottom = UDim.new(0, 12)
	uiPadding.Parent = detail

	local u502: boolean = p115.won == true
	local u503: boolean = p115.left == true
	local parent, v505 = cloneCard(detail, 1, u502 and color3 or color32, n1)
	local layoutOrder: number = 1 + 1

	if typeof(p115.mapImg) == "string" and p115.mapImg ~= "" then
		local clone = cell.MapImage:Clone()

		clone.Name = "Banner"
		clone.Visible = true
		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Position = UDim2.fromScale(0.5, 0.5)
		clone.Size = UDim2.fromScale(1, 1)
		clone.Image = p115.mapImg
		clone.ScaleType = Enum.ScaleType.Crop
		clone.ImageTransparency = 0
		clone.ImageColor3 = Color3.fromRGB(110, 110, 110)
		clone.BackgroundTransparency = 1

		local uiGradient = clone:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Transparency = NumberSequence.new(0)
		end

		clone.ZIndex = 1
		clone.Parent = parent
	end

	local fade = parent:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.AnchorPoint = Vector2.new(0.5, 0.5)
		fade.Position = UDim2.fromScale(0.5, 0.5)
		fade.Size = UDim2.fromScale(1, 1)
		fade.ZIndex = 2
		fade.BackgroundTransparency = 0.05

		local uiGradient = fade:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Rotation = 90

			local colorSequenceNew = ColorSequence.new

			uiGradient.Color = colorSequenceNew({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.65, Color3.fromRGB(10, 10, 10)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			})
			uiGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.14),
				NumberSequenceKeypoint.new(0.5, 0.42),
				NumberSequenceKeypoint.new(1, 0.22)
			})
		end
	end

	local modeCorner: Frame = Instance.new("Frame")

	modeCorner.Name = "ModeCorner"
	modeCorner.BackgroundTransparency = 1
	modeCorner.BorderSizePixel = 0
	modeCorner.AnchorPoint = Vector2.new(1, 0)

	local uDim2New = UDim2.new
	local rounded = math.round(n1 * 12)
	local rounded17 = math.round(n1 * 10)

	modeCorner.Position = uDim2New(1, -rounded, 0, rounded17)
	modeCorner.AutomaticSize = Enum.AutomaticSize.XY
	modeCorner.Size = UDim2.fromOffset(0, 0)
	modeCorner.ZIndex = 3

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local uDimNew = UDim.new
	local rounded18 = math.round(n1 * 2)

	uiListLayout.Padding = uDimNew(0, rounded18)
	uiListLayout.Parent = modeCorner

	local clone: Instance = titleLabel:Clone()

	clone.Visible = true
	clone.Name = "Mode"
	clone.LayoutOrder = 1
	clone.AutomaticSize = Enum.AutomaticSize.XY
	clone.Size = UDim2.fromOffset(0, 0)
	clone.TextWrapped = false
	clone.TextSize = math.round(n1 * 19)

	local numberValue: number? = tonumber(p115.mode)
	local floored = math.floor(numberValue or 1)
	local v522 = math.clamp(floored, 1, 4)

	clone.Text = ("%dv%d"):format(v522, v522)
	clone.TextColor3 = Color3.new(1, 1, 1)
	clone.FontFace = Font.new(clone.FontFace.Family, Enum.FontWeight.Heavy, clone.FontFace.Style)

	local uiGradient: Instance = clone:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		uiGradient.Enabled = false
	end

	clone.ZIndex = 3

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	uiStroke.Thickness = 0.09
	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Parent = clone
	clone.Parent = modeCorner

	if p115.map ~= "" then
		local clone3: Instance = subLabel:Clone()

		clone3.Visible = true
		clone3.Name = "Map"
		clone3.LayoutOrder = 2
		clone3.AutomaticSize = Enum.AutomaticSize.XY
		clone3.Size = UDim2.fromOffset(0, 0)
		clone3.TextWrapped = false
		clone3.TextSize = math.round(n1 * 13)
		clone3.TextColor3 = color38
		clone3.TextTransparency = 0
		clone3.Text = tostring(p115.map)
		clone3.FontFace = Font.new(clone3.FontFace.Family, Enum.FontWeight.Bold, clone3.FontFace.Style)
		clone3.ZIndex = 3

		local uiStroke2: UIStroke = Instance.new("UIStroke")

		uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		uiStroke2.Thickness = 0.09
		uiStroke2.Color = Color3.new(0, 0, 0)
		uiStroke2.Parent = clone3
		clone3.Parent = modeCorner
	end

	modeCorner.Parent = parent

	local s1: string = if u503 then "RAGE QUIT" else if u502 then "VICTORY" else "DEFEAT"
	local s2 = s1

	if not u503 and typeof(p115.sf) == "number" and typeof(p115.sa) == "number" then
		s2 = ("%s  %d - %d"):format(s1, p115.sf, p115.sa)
	end

	local clone4

	if u503 then
		local v531 = ColorSequence.new
		local colorSequence = v531({
			ColorSequenceKeypoint.new(0, color315),
			ColorSequenceKeypoint.new(0.09, color316),
			ColorSequenceKeypoint.new(1, color317)
		})
		local headline: Frame = Instance.new("Frame")

		headline.Name = "Headline"
		headline.BackgroundTransparency = 1
		headline.BorderSizePixel = 0
		headline.Size = UDim2.new(1, 0, 0, 0)
		headline.AutomaticSize = Enum.AutomaticSize.Y
		headline.LayoutOrder = 1
		headline.ZIndex = 2

		local uiListLayout2: UIListLayout = Instance.new("UIListLayout")

		uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center

		local v535 = UDim.new
		local rounded19 = math.round(n1 * 8)

		uiListLayout2.Padding = v535(0, rounded19)
		uiListLayout2.Parent = headline
		clone4 = titleLabel:Clone()
		clone4.Visible = true
		clone4.LayoutOrder = 1
		clone4.Text = s2
		clone4.TextSize = math.round(n1 * 34)
		clone4.AutomaticSize = Enum.AutomaticSize.XY
		clone4.Size = UDim2.new(0, 0, 0, 0)
		clone4.TextXAlignment = Enum.TextXAlignment.Left
		clone4.TextColor3 = Color3.new(1, 1, 1)
		clone4.ZIndex = 2

		local uiGradient3 = clone4:FindFirstChildOfClass("UIGradient")

		if not uiGradient3 then
			uiGradient3 = Instance.new("UIGradient")
			uiGradient3.Parent = clone4
		end

		uiGradient3.Color = colorSequence
		uiGradient3.Rotation = 90
		clone4.Parent = headline

		local skull: ImageLabel = Instance.new("ImageLabel")

		skull.Name = "Skull"
		skull.BackgroundTransparency = 1
		skull.BorderSizePixel = 0
		skull.Image = "rbxassetid://88818475782370"
		skull.ImageColor3 = Color3.new(1, 1, 1)
		skull.ScaleType = Enum.ScaleType.Fit

		local uDim2FromOffset = UDim2.fromOffset
		local rounded20 = math.round(n1 * 36)
		local rounded21 = math.round(n1 * 36)

		skull.Size = uDim2FromOffset(rounded20, rounded21)
		skull.LayoutOrder = 2
		skull.ZIndex = 2

		local uiGradient4: UIGradient = Instance.new("UIGradient")

		uiGradient4.Color = colorSequence
		uiGradient4.Rotation = 90
		uiGradient4.Parent = skull
		skull.Parent = headline
		headline.Parent = v505
	else
		local textColor3 = u502 and color35 or color36

		clone4 = titleLabel:Clone()
		clone4.Visible = true
		clone4.LayoutOrder = 1
		clone4.Text = s2
		clone4.TextSize = math.round(n1 * 34)
		clone4.Size = UDim2.new(1, 0, 0, 0)
		clone4.AutomaticSize = Enum.AutomaticSize.Y

		if textColor3 then
			clone4.TextColor3 = textColor3
		end

		clone4.Parent = v505
		clone4.TextXAlignment = Enum.TextXAlignment.Left
	end

	local uiStroke3: UIStroke = Instance.new("UIStroke")

	uiStroke3.Color = Color3.fromRGB(0, 0, 0)
	uiStroke3.Transparency = 0.35

	local rounded22 = math.round(n1 * 3)

	uiStroke3.Thickness = math.max(2, rounded22)
	uiStroke3.Parent = clone4

	local n3: number = 1 + 1
	local v547 = nil

	if typeof(p115.board) == "table" then
		for _, v in ipairs(p115.board) do
			if v.me then
				v547 = v

				break
			end
		end
	end

	if v547 and typeof(v547.k) == "number" then
		local v550 = ("Kills: <b>%d</b>    Deaths: <b>%d</b>    Assists: <b>%d</b>"):format(v547.k, v547.d or 0, v547.a or 0)

		cloneSub(v505, n3, v550, n1 * 14.5, color38)
		n3 += 1
	end

	local gap: Frame = Instance.new("Frame")

	gap.Name = "Gap"
	gap.BackgroundTransparency = 1
	gap.BorderSizePixel = 0

	local v552 = UDim2.new
	local rounded23 = math.round(n1 * 8)
	local v554 = math.max(1, rounded23)

	gap.Size = v552(1, 0, 0, v554)
	gap.LayoutOrder = n3
	gap.Parent = v505

	local n4: number = n3 + 1

	buildActionRow(v505, n4, p115, n1, function()
		u78()
	end)
	n3 = n4 + 1

	local frame: Frame = Instance.new("Frame")

	frame.Name = "Gap"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0

	local v557 = UDim2.new
	local rounded24 = math.round(n1 * 10)

	v554 = math.max(1, rounded24)
	frame.Size = v557(1, 0, 0, v554)
	frame.LayoutOrder = layoutOrder
	frame.Parent = detail

	local n5 = layoutOrder + 1

	if typeof(p115.board) == "table" and #p115.board > 0 then
		local t12: {[any]: any} = {}
		local t13: {[any]: any} = {}

		for _, v in ipairs(p115.board) do
			if v.t == 2 then
				table.insert(t13, v)
			else
				table.insert(t12, v)
			end
		end

		local function byKills(p116)
			table.sort(p116, function(p117, p118)
				local numberValue3: number? = tonumber(p117.k)
				local numberValue4: number? = tonumber(p118.k)

				return (numberValue3 or -1) > (numberValue4 or -1)
			end)
		end

		table.sort(t12, function(p117, p118)
			local numberValue3: number? = tonumber(p117.k)
			local numberValue4: number? = tonumber(p118.k)

			return (numberValue3 or -1) > (numberValue4 or -1)
		end)
		table.sort(t13, function(p117, p118)
			local numberValue3: number? = tonumber(p117.k)
			local numberValue4: number? = tonumber(p118.k)

			return (numberValue3 or -1) > (numberValue4 or -1)
		end)
		n5 = buildScoreboardCard(detail, n5, t12, t13, n1)
	end

	if typeof(p115.rounds) == "table" and #p115.rounds > 0 then
		local v565, v566 = cloneCard(detail, n5, color34, n1)
		local n6 = n5 + 1

		cloneTitle(v566, 1, "ROUNDS", n1 * 17, color38, true)
		buildRoundStrip(v566, 2, p115.rounds, n1)

		local frame2: Frame = Instance.new("Frame")

		frame2.Name = "Gap"
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0

		local v569 = UDim2.new
		local rounded25 = math.round(n1 * 10)
		local v571 = math.max(1, rounded25)

		frame2.Size = v569(1, 0, 0, v571)
		frame2.LayoutOrder = n6
		frame2.Parent = detail
		n5 = n6 + 1
	end

	local v572 = buildMomentum(detail, n5, p115, n1)

	n5 = buildHighlights(detail, v572, p115, n1)

	if p115.legacy then
		cloneSub(detail, n5, "Round-by-round detail wasn't recorded for matches played before this update.", n1 * 13, Color3.fromRGB(150, 150, 150))

		local n7 = n5 + 1
	elseif p115.saved and typeof(p115.board) ~= "table" then
		cloneSub(detail, n5, "This match has aged out of your recent history, so only the summary was kept. The replay itself is saved and still playable.", n1 * 13, Color3.fromRGB(150, 150, 150))

		local n8 = n5 + 1
	end

	return detail
end
local function applyCellStyle(p119, p120)
	local v577 = p120 and cellSelected or cell

	p119.ImageColor3 = v577.ImageColor3
	p119.BackgroundColor3 = v577.BackgroundColor3
	p119.BackgroundTransparency = v577.BackgroundTransparency
	p119:SetAttribute("Selected", p120)

	local uiStroke = p119:FindFirstChild("UIStroke")

	if uiStroke and uiStroke:IsA("UIStroke") then
		uiStroke.LineJoinMode = Enum.LineJoinMode.Bevel
		uiStroke.Thickness = if p120 then 0.11 else 0.02
		uiStroke.Color = p120 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(173, 173, 173)
		uiStroke.Transparency = if p120 then 0 else 0.52
	end

	local fade = p119:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.BackgroundTransparency = if p120 then 0 else 0.08

		local uiGradient = fade:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypointNew = ColorSequenceKeypoint.new
			local v583 = p120 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)

			uiGradient.Color = colorSequenceNew({
				colorSequenceKeypointNew(0, v583),
				ColorSequenceKeypoint.new(0.65, Color3.fromRGB(10, 10, 10)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
			})
		end
	end
end
local function selectIndex(p121)
	local v585 = s1 == "saved" and t3 or t1

	if not v585[p121] then
		return
	end

	n1 = p121

	for i, v in ipairs(t2) do
		applyCellStyle(v, i == p121)
	end

	if u68 then
		u68:Destroy()
		u68 = nil
	end

	local v588 = buildDetailFrame(v585[p121])

	v588.Parent = scrollingFrame
	u68 = v588
	scrollingFrame.CanvasPosition = Vector2.new(0, 0)
end
local function clearList()
	for _, v in ipairs(t2) do
		local vParent = v.Parent

		if vParent and vParent.Name == "CellHost" then
			vParent:Destroy()
		else
			v:Destroy()
		end
	end

	table.clear(t2)

	local emptyMessage: Instance = listScrollingFrame:FindFirstChild("EmptyMessage")

	if emptyMessage then
		emptyMessage:Destroy()
	end
end
local function showMessage(text)
	clearList()

	if u68 then
		u68:Destroy()
		u68 = nil
	end

	local clone: Instance = subLabel:Clone()

	clone.Visible = true
	clone.Name = "EmptyMessage"
	clone.Text = text
	clone.RichText = true
	clone.TextWrapped = true
	clone.TextXAlignment = Enum.TextXAlignment.Center

	local y = scrollingFrame.AbsoluteSize.Y
	local n1

	if y <= 0 then
		n1 = 1
	else
		n1 = math.clamp(y / 315, 0.6, 1.15)
	end

	clone.TextSize = math.round(n1 * 15)
	clone.TextColor3 = color37
	clone.TextTransparency = 0
	clone.Size = UDim2.new(1, 0, 0, 70)
	clone.Parent = listScrollingFrame
end
local function buildCell(p123, layoutOrder)
	local clone: Instance = cell:Clone()

	clone.Name = ("Match%d"):format(layoutOrder)
	clone.Visible = true
	clone.LayoutOrder = layoutOrder
	collectionService:AddTag(clone, "BlacklistHover")

	local u600: boolean = p123.won == true
	local u601: boolean = p123.left == true
	local backgroundColor3 = u600 and color3 or color32
	local fade: Instance = clone:FindFirstChild("Fade")

	if fade and fade:IsA("GuiObject") then
		fade.BackgroundColor3 = backgroundColor3
	end

	local fade2: Instance = clone:FindFirstChild("Fade")
	local fade2UiGradient: Instance = fade2 and fade2:FindFirstChildOfClass("UIGradient")

	if fade2UiGradient then
		fade2UiGradient.Rotation = 90

		local colorSequenceNew = ColorSequence.new

		fade2UiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.65, Color3.fromRGB(10, 10, 10)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		})
		fade2UiGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.16),
			NumberSequenceKeypoint.new(0.5, 0.44),
			NumberSequenceKeypoint.new(1, 0.24)
		})
	end

	local mapImage: Instance = clone:FindFirstChild("MapImage")

	if mapImage and mapImage:IsA("ImageLabel") then
		if typeof(p123.mapImg) == "string" and p123.mapImg ~= "" then
			mapImage.Visible = true
			mapImage.Image = p123.mapImg
			mapImage.ScaleType = Enum.ScaleType.Crop
			mapImage.ImageTransparency = 0
			mapImage.ImageColor3 = Color3.fromRGB(110, 110, 110)
			mapImage.BackgroundTransparency = 1

			local uiGradient: Instance = mapImage:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				uiGradient.Transparency = NumberSequence.new(0)
			end
		else
			mapImage.Visible = false
			mapImage.Image = ""
			mapImage.BackgroundTransparency = 1
		end
	end

	local title: Instance = clone:FindFirstChild("Title")

	if title and title:IsA("TextLabel") then
		title.Text = p123.map ~= "" and tostring(p123.map) or "Unknown Map"
		title.TextTruncate = Enum.TextTruncate.AtEnd
		title.FontFace = Font.new(title.FontFace.Family, Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
		title.TextColor3 = Color3.new(1, 1, 1)

		local uiGradient: Instance = title:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Enabled = false
		end
	end

	local subtitle: Instance = clone:FindFirstChild("Subtitle")

	if subtitle and subtitle:IsA("TextLabel") then
		local t14: {[any]: any} = { modeLabel(p123.mode) }

		if p123.bots then
			table.insert(t14, "Bots")
		end

		table.insert(t14, relativeTime(p123.at))

		local dur = p123.dur
		local v614

		if typeof(dur) == "number" and not (dur <= 0) then
			local floored = math.floor(dur / 60)
			local floored3 = math.floor(dur % 60)

			v614 = if floored <= 0 then ("%ds"):format(floored3) else ("%dm %ds"):format(floored, floored3)
		else
			v614 = nil
		end

		if v614 then
			table.insert(t14, v614)
		end

		subtitle.Text = table.concat(t14, "   ")
		subtitle.FontFace = Font.new(subtitle.FontFace.Family, Enum.FontWeight.Bold, subtitle.FontFace.Style)
	end

	local scoreLabel: Instance = clone:FindFirstChild("ScoreLabel")

	if scoreLabel and scoreLabel:IsA("TextLabel") then
		scoreLabel.Text = if typeof(p123.sf) == "number" and typeof(p123.sa) == "number" then ("%d - %d"):format(p123.sf, p123.sa) else if p123.left then "LEFT" else if p123.won then "W" else "L"
		scoreLabel.TextColor3 = u600 and color35 or color36
		scoreLabel.FontFace = Font.new(scoreLabel.FontFace.Family, scoreLabel.FontFace.Weight, Enum.FontStyle.Italic)

		local uiStroke: Instance = scoreLabel:FindFirstChildOfClass("UIStroke")

		if uiStroke then
			uiStroke.Thickness = 0.09
		end

		pcall(function()
			local uiShadow: UIShadow = Instance.new("UIShadow")

			uiShadow.BlurRadius = UDim.new(0.5, 10)
			uiShadow.Offset = UDim2.new(0.2, 0, 0, 0)
			uiShadow.Transparency = 0.5
			pcall(function()
				uiShadow.Color = Color3.new(0, 0, 0)
			end)
			pcall(function()
				uiShadow.Color3 = Color3.new(0, 0, 0)
			end)
			uiShadow.Parent = scoreLabel
		end)

		local u619: boolean = false

		if typeof(p123.sf) == "number" then
			u619 = typeof(p123.sa) == "number"
		end

		if u601 or u619 then
			scoreLabel.Position = UDim2.fromScale(0.95, 0.34)
			scoreLabel.Size = UDim2.fromScale(0.3, 0.42)

			local clone5: Instance = scoreLabel:Clone()

			clone5.Name = "ResultLabel"
			clone5.Text = if u601 then "LEFT" else if u600 then "WIN" else "LOSS"
			clone5.TextXAlignment = Enum.TextXAlignment.Center
			clone5.Position = UDim2.fromScale(0.95, 0.72)
			clone5.Size = UDim2.fromScale(0.18, 0.26)
			clone5.Parent = clone
		end

		if u601 then
			scoreLabel.Text = ""

			local disconnectIcon: ImageLabel = Instance.new("ImageLabel")

			disconnectIcon.Name = "DisconnectIcon"
			disconnectIcon.BackgroundTransparency = 1
			disconnectIcon.Image = "rbxassetid://106793670482037"
			disconnectIcon.ScaleType = Enum.ScaleType.Fit
			disconnectIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
			disconnectIcon.AnchorPoint = Vector2.new(1, 0.5)
			disconnectIcon.Position = UDim2.fromScale(0.93, 0.36)
			disconnectIcon.Size = UDim2.fromScale(0.42, 0.42)
			disconnectIcon.ZIndex = 3
			disconnectIcon.Parent = clone
		end
	end

	local cellHost: Frame = Instance.new("Frame")

	cellHost.Name = "CellHost"
	cellHost.BackgroundTransparency = 1
	cellHost.BorderSizePixel = 0
	cellHost.Size = clone.Size
	cellHost.LayoutOrder = layoutOrder
	cellHost.ZIndex = clone.ZIndex
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = UDim2.fromScale(0.5, 0.5)
	clone.Size = UDim2.fromScale(1, 1)

	local uiStroke: Instance = clone:FindFirstChild("UIStroke")
	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Parent = clone

	local u625: boolean = false
	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

	local function scaleTo(p125, p126)
		tweenService:Create(uiScale, p126, { Scale = p125 }):Play()
	end
	local function playUISound(p127)
		local foundChild: Instance = workspace:FindFirstChild(p127)

		if foundChild and foundChild:IsA("Sound") then
			foundChild:Play()
		end
	end

	clone.MouseButton1Click:Connect(function()
		local uiClick: Instance = workspace:FindFirstChild("UIClick")

		if uiClick and uiClick:IsA("Sound") then
			uiClick:Play()
		end

		selectIndex(layoutOrder)
	end)
	clone.MouseEnter:Connect(function()
		u625 = true

		local uiHover: Instance = workspace:FindFirstChild("UIHover")

		if uiHover and uiHover:IsA("Sound") then
			uiHover:Play()
		end

		tweenService:Create(uiScale, tweenInfo, { Scale = 1.015 }):Play()

		if uiStroke and uiStroke:IsA("UIStroke") and clone:GetAttribute("Selected") ~= true then
			uiStroke.Transparency = 0.15
		end
	end)
	clone.MouseLeave:Connect(function()
		u625 = false
		tweenService:Create(uiScale, tweenInfo, { Scale = 1 }):Play()

		if uiStroke and uiStroke:IsA("UIStroke") and clone:GetAttribute("Selected") ~= true then
			uiStroke.Transparency = 0.52
		end
	end)
	clone.MouseButton1Down:Connect(function()
		tweenService:Create(uiScale, tweenInfo2, { Scale = 0.975 }):Play()
	end)
	clone.MouseButton1Up:Connect(function()
		tweenService:Create(uiScale, tweenInfo3, {
			Scale = if u625 then 1.015 else 1
		}):Play()
	end)
	clone.Parent = cellHost
	cellHost.Parent = listScrollingFrame

	return clone
end

u78 = function()
	clearList()

	local v631 = s1 == "saved" and t3 or t1

	if #v631 ~= 0 then
		for i, v in ipairs(v631) do
			local v634 = buildCell(v, i)

			table.insert(t2, v634)
		end

		local v635 = math.clamp(n1, 1, #v631)

		selectIndex(v635)

		return
	end

	if s1 == "saved" then
		showMessage(if u75 then "No saved replays.\nOpen a match in RECENT and hit the save icon to keep it forever." else "Loading...")

		return
	end

	showMessage("No matches yet.\nPlay a duel and it'll show up here.")
end

local function refresh()
	if u70 then
		return
	end

	u70 = true
	task.spawn(function()
		local ok, result = pcall(function()
			return matchHistory_Request:InvokeServer()
		end)

		u70 = false

		if not ok then
			local text: string = tostring(result)

			warn("[MatchHistory] request failed: " .. text)

			if not u71 then
				showMessage("Couldn't load match history.\nTry reopening this menu.")
			end

			return
		end

		u71 = true
		t1 = typeof(result) == "table" and result or {}
		u78()
		u79(true)
	end)
end

u80 = function()
	if n2 > 0 then
		local text = ("SAVED (%d/%d)"):format(#t3, n2)
		local textLabel5: Instance = tabSaved:FindFirstChild("TextLabel")

		if textLabel5 then
			if not textLabel5:IsA("TextLabel") then
				return
			end

			textLabel5.Text = text

			local textLabel6: Instance = textLabel5:FindFirstChild("TextLabel")

			if textLabel6 and textLabel6:IsA("TextLabel") then
				textLabel6.Text = text

				return
			end
		end
	else
		local textLabel7: Instance = tabSaved:FindFirstChild("TextLabel")

		if textLabel7 then
			if not textLabel7:IsA("TextLabel") then
				return
			end

			textLabel7.Text = "SAVED"

			local textLabel8: Instance = textLabel7:FindFirstChild("TextLabel")

			if textLabel8 and textLabel8:IsA("TextLabel") then
				textLabel8.Text = "SAVED"
			end
		end
	end
end
u79 = function(p128)
	if not replaySave then
		u75 = true
		u80()

		if s1 == "saved" then
			u78()
		end

		return
	end

	if u74 then
		return
	end

	if u75 and not p128 then
		return
	end

	u74 = true
	task.spawn(function()
		local v708 = invokeSave("list", "")

		u74 = false

		if v708 and v708.ok == true then
			u75 = true

			if typeof(v708.cap) == "number" then
				n2 = v708.cap
			end

			local t15 = typeof(v708.saved) == "table" and v708.saved or {}

			for _, v in ipairs(t15) do
				v.saved = true

				if typeof(v.id) == "string" then
					for _, iterValue in ipairs(t1) do
						if iterValue.id == v.id then
							v.a = iterValue.a
							v.side = iterValue.side
							v.dur = iterValue.dur
							v.rounds = iterValue.rounds
							v.board = iterValue.board
							v.legacy = iterValue.legacy

							break
						end
					end
				end
			end

			t3 = t15
			t15 = syncSavedFlags()
			u80()

			if s1 == "saved" or t15 then
				u78()
			end
		elseif not u75 and s1 == "saved" then
			showMessage("Couldn't load saved replays.\nTry reopening this menu.")
		end
	end)
end

local function applyTabStyle()
	local function style(p129, p130)
		local darkenDeselectedCover = p129:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not p130
		end
	end

	local u643: boolean = s1 == "recent"
	local darkenDeselectedCover: Instance = tabRecent:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not u643
	end

	u643 = s1 == "saved"

	local darkenDeselectedCover2: Instance = tabSaved:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover2 and darkenDeselectedCover2:IsA("GuiObject") then
		darkenDeselectedCover2.Visible = not u643
	end
end
local function setTab(p131)
	if p131 == s1 then
		return
	end

	s1 = p131
	n1 = 1

	local function style(p129, p130)
		local darkenDeselectedCover = p129:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not p130
		end
	end

	local u648: boolean = s1 == "recent"
	local darkenDeselectedCover: Instance = tabRecent:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not u648
	end

	u648 = s1 == "saved"

	local darkenDeselectedCover3: Instance = tabSaved:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover3 and darkenDeselectedCover3:IsA("GuiObject") then
		darkenDeselectedCover3.Visible = not u648
	end

	u78()

	if p131 == "saved" then
		u79()
	end
end

tabRecent.MouseButton1Click:Connect(function()
	if s1 == "recent" then
		return
	end

	s1 = "recent"
	n1 = 1

	local function style(p129, p130)
		local darkenDeselectedCover = p129:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not p130
		end
	end

	local u652: boolean = s1 == "recent"
	local darkenDeselectedCover: Instance = tabRecent:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not u652
	end

	u652 = s1 == "saved"

	local darkenDeselectedCover4: Instance = tabSaved:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover4 and darkenDeselectedCover4:IsA("GuiObject") then
		darkenDeselectedCover4.Visible = not u652
	end

	u78()
end)
tabSaved.MouseButton1Click:Connect(function()
	if s1 == "saved" then
		return
	end

	s1 = "saved"
	n1 = 1

	local function style(p129, p130)
		local darkenDeselectedCover = p129:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not p130
		end
	end

	local u656: boolean = s1 == "recent"
	local darkenDeselectedCover: Instance = tabRecent:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not u656
	end

	u656 = s1 == "saved"

	local darkenDeselectedCover5: Instance = tabSaved:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover5 and darkenDeselectedCover5:IsA("GuiObject") then
		darkenDeselectedCover5.Visible = not u656
	end

	u78()
	u79()
end)

local function style(p129, p130)
	local darkenDeselectedCover = p129:FindFirstChild("DarkenDeselectedCover")

	if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
		darkenDeselectedCover.Visible = not p130
	end
end

local u138: boolean = s1 == "recent"
local darkenDeselectedCover: Instance = tabRecent:FindFirstChild("DarkenDeselectedCover")

if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
	darkenDeselectedCover.Visible = not u138
end

u138 = s1 == "saved"

local darkenDeselectedCover6: Instance = tabSaved:FindFirstChild("DarkenDeselectedCover")

if darkenDeselectedCover6 and darkenDeselectedCover6:IsA("GuiObject") then
	darkenDeselectedCover6.Visible = not u138
end

u80()
closeBtn.MouseButton1Click:Connect(function()
	closeMatchHistory:Fire()
end)
matchHistoryWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if not matchHistoryWindow.Visible then
		return
	end

	if u70 then
		return
	end

	u70 = true
	task.spawn(function()
		local ok, result = pcall(function()
			return matchHistory_Request:InvokeServer()
		end)

		u70 = false

		if not ok then
			local text: string = tostring(result)

			warn("[MatchHistory] request failed: " .. text)

			if not u71 then
				showMessage("Couldn't load match history.\nTry reopening this menu.")
			end

			return
		end

		u71 = true
		t1 = typeof(result) == "table" and result or {}
		u78()
		u79(true)
	end)
end)

if matchHistoryWindow.Visible and not u70 then
	u70 = true
	task.spawn(function()
		local ok, result = pcall(function()
			return matchHistory_Request:InvokeServer()
		end)

		u70 = false

		if not ok then
			local text: string = tostring(result)

			warn("[MatchHistory] request failed: " .. text)

			if not u71 then
				showMessage("Couldn't load match history.\nTry reopening this menu.")
			end

			return
		end

		u71 = true
		t1 = typeof(result) == "table" and result or {}
		u78()
		u79(true)
	end)
end
