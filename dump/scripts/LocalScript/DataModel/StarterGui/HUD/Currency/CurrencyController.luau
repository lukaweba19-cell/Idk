-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("UserInputService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local currency: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Currency")
local currencyCash: Instance = currency:WaitForChild("Cash")
local currencyPosition = currency.Position

if LocalPlayer:GetAttribute("HasSpecialTasks") == true then
	currency.Position = UDim2.new(currencyPosition.X.Scale, currencyPosition.X.Offset, 0.837, 0)
else
	currency.Position = currencyPosition
end

LocalPlayer:GetAttributeChangedSignal("HasSpecialTasks"):Connect(function()
	if LocalPlayer:GetAttribute("HasSpecialTasks") == true then
		currency.Position = UDim2.new(currencyPosition.X.Scale, currencyPosition.X.Offset, 0.837, 0)

		return
	end

	currency.Position = currencyPosition
end)

local more: Instance = currency:WaitForChild("More")
local rarityFade: Instance = currency:WaitForChild("RarityFade")

local function formatNumber(p1)
	local floored = math.floor(p1)
	local text = tostring(floored)

	repeat
		local v30, v31 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v30
	until v31 == 0

	return text
end

local n1: number = 0
local currencyCashTextSize = currencyCash.TextSize
local currencyCashPosition = currencyCash.Position
local currencyCashTextColor3 = currencyCash.TextColor3

local function setCashText(p2)
	currencyCash.Text = "$" .. formatNumber(p2)
end
local function playCashAnim(p3)
	if p3 == 0 then
		return
	end

	n1 += 1

	local v34: number = n1

	currencyCash.TextSize = currencyCashTextSize
	currencyCash.Position = currencyCashPosition
	currencyCash.TextColor3 = currencyCashTextColor3

	local v35

	if p3 > 0 then
		local color3New = Color3.new
		local v37 = math.clamp(currencyCashTextColor3.R + 0.25, 0, 1)
		local v38 = math.clamp(currencyCashTextColor3.G + 0.25, 0, 1)
		local v39 = math.clamp(currencyCashTextColor3.B + 0.25, 0, 1)

		v35 = color3New(v37, v38, v39)
	else
		local v40 = Color3.new
		local v41 = math.clamp(currencyCashTextColor3.R - 0.25, 0, 1)
		local v42 = math.clamp(currencyCashTextColor3.G - 0.25, 0, 1)
		local v43 = math.clamp(currencyCashTextColor3.B - 0.25, 0, 1)

		v35 = v40(v41, v42, v43)
	end

	local uDim2 = UDim2.new(currencyCashPosition.X.Scale, currencyCashPosition.X.Offset, currencyCashPosition.Y.Scale, currencyCashPosition.Y.Offset - 3)
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local v46: Tween = tweenService:Create(currencyCash, tweenInfo, {
		TextSize = currencyCashTextSize + 2,
		Position = uDim2,
		TextColor3 = v35
	})
	local tweenInfo2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v48: Tween = tweenService:Create(currencyCash, tweenInfo2, {
		TextSize = currencyCashTextSize,
		Position = currencyCashPosition,
		TextColor3 = currencyCashTextColor3
	})

	rarityFade.BackgroundTransparency = 0.1

	local tweenInfo3 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(rarityFade, tweenInfo3, { BackgroundTransparency = 1 }):Play()
	v46:Play()
	v46.Completed:Connect(function()
		if n1 ~= v34 then
			return
		end

		v48:Play()
	end)
end

local cash: any = LocalPlayer:GetAttribute("Cash")
local n2 = typeof(cash) == "number" and cash or 0

currencyCash.Text = "$" .. formatNumber(n2)
LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
	local cash2 = LocalPlayer:GetAttribute("Cash")

	if typeof(cash2) ~= "number" then
		cash2 = 0
	end

	local n1 = cash2 - n2

	n2 = cash2
	currencyCash.Text = "$" .. formatNumber(cash2)
	playCashAnim(n1)
end)

local openShop: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables"):WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")

more.MouseButton1Click:Connect(function()
	openShop:Fire("Currency")
	shopOpenAnalytics:FireServer("CurrencyMore")
end)

local u21 = false

local function isInRealMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" then
		return true
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return true
	end

	return false
end
local function refreshMatchVisibility()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u55

	if typeof(matchId) == "string" and matchId ~= "" then
		u55 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u55 = typeof(spectating) == "number" and spectating ~= 0
	end

	if u55 then
		currency.Visible = u21

		return
	end

	currency.Visible = true
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshMatchVisibility)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshMatchVisibility)
replicatedStorage:WaitForChild("Bindables"):WaitForChild("ToggleMatchLeaderboard").Event:Connect(function(p4)
	u21 = p4

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u59

	if typeof(matchId) == "string" and matchId ~= "" then
		u59 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u59 = typeof(spectating) == "number" and spectating ~= 0
	end

	if u59 then
		currency.Visible = u21

		return
	end

	currency.Visible = true
end)

local matchId: any = LocalPlayer:GetAttribute("MatchId")
local u25

if typeof(matchId) == "string" and matchId ~= "" then
	u25 = true
else
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	u25 = typeof(spectating) == "number" and spectating ~= 0
end

if u25 then
	currency.Visible = u21
else
	currency.Visible = true
end
