-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))
local LocalPlayer: Player = players.LocalPlayer
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local scriptParent: Instance = script.Parent
local tokens: Instance = scriptParent:WaitForChild("Tokens")
local rarityFade: Instance = scriptParent:WaitForChild("RarityFade")
local u11 = false

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
local function computeTokenFrameVisible()
	if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
		return true
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u47

	if typeof(matchId) == "string" and matchId ~= "" then
		u47 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u47 = typeof(spectating) == "number" and spectating ~= 0
	end

	if u47 and not u11 then
		return false
	end

	if tradingPlazaGate.IsTradingPlaza() then
		return true
	end

	return (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
end

local u14

if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
	u14 = true
else
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u16

	if typeof(matchId) == "string" and matchId ~= "" then
		u16 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u16 = typeof(spectating) == "number" and spectating ~= 0
	end

	u14 = if u16 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
end

scriptParent.Visible = u14
LocalPlayer:GetAttributeChangedSignal("DebugShowTradeTokens"):Connect(function()
	local u49

	if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
		u49 = true
	else
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local u51

		if typeof(matchId) == "string" and matchId ~= "" then
			u51 = true
		else
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u51 = typeof(spectating) == "number" and spectating ~= 0
		end

		u49 = if u51 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
	end

	scriptParent.Visible = u49
end)

local currency: Instance = hud:WaitForChild("Currency")

local function reposition()
	local n1 = currency.AbsolutePosition - hud.AbsolutePosition
	local floored = math.floor(currency.AbsoluteSize.Y * 0.16 + 0.5)
	local v55 = math.max(4, floored)

	scriptParent.Position = UDim2.fromOffset(n1.X, n1.Y + currency.AbsoluteSize.Y + v55)
end

local n1 = currency.AbsolutePosition - hud.AbsolutePosition
local floored = math.floor(currency.AbsoluteSize.Y * 0.16 + 0.5)
local v22 = math.max(4, floored)

scriptParent.Position = UDim2.fromOffset(n1.X, n1.Y + currency.AbsoluteSize.Y + v22)
currency:GetPropertyChangedSignal("AbsolutePosition"):Connect(reposition)
currency:GetPropertyChangedSignal("AbsoluteSize"):Connect(reposition)

local function formatNumber(p1)
	local floored2 = math.floor(p1)
	local text = tostring(floored2)

	repeat
		local v59, v60 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v59
	until v60 == 0

	return text
end

n1 = function(p2)
	tokens.Text = formatNumber(p2)
end

local n2: number = 0
local tokensTextSize = tokens.TextSize
local tokensPosition = tokens.Position
local tokensTextColor3 = tokens.TextColor3

local function playTokenAnim(p3)
	if p3 == 0 then
		return
	end

	n2 += 1

	local v63: number = n2

	tokens.TextSize = tokensTextSize
	tokens.Position = tokensPosition
	tokens.TextColor3 = tokensTextColor3

	local v64

	if p3 > 0 then
		local color3New = Color3.new
		local v66 = math.clamp(tokensTextColor3.R + 0.25, 0, 1)
		local v67 = math.clamp(tokensTextColor3.G + 0.25, 0, 1)
		local v68 = math.clamp(tokensTextColor3.B + 0.25, 0, 1)

		v64 = color3New(v66, v67, v68)
	else
		local v69 = Color3.new
		local v70 = math.clamp(tokensTextColor3.R - 0.25, 0, 1)
		local v71 = math.clamp(tokensTextColor3.G - 0.25, 0, 1)
		local v72 = math.clamp(tokensTextColor3.B - 0.25, 0, 1)

		v64 = v69(v70, v71, v72)
	end

	local uDim2 = UDim2.new(tokensPosition.X.Scale, tokensPosition.X.Offset, tokensPosition.Y.Scale, tokensPosition.Y.Offset - 3)
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local v75: Tween = tweenService:Create(tokens, tweenInfo, { TextSize = tokensTextSize + 2, Position = uDim2, TextColor3 = v64 })
	local tweenInfo2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v77: Tween = tweenService:Create(tokens, tweenInfo2, {
		TextSize = tokensTextSize,
		Position = tokensPosition,
		TextColor3 = tokensTextColor3
	})

	rarityFade.BackgroundTransparency = 0.1

	local tweenInfo3 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(rarityFade, tweenInfo3, { BackgroundTransparency = 1 }):Play()
	v75:Play()
	v75.Completed:Connect(function()
		if n2 ~= v63 then
			return
		end

		v77:Play()
	end)
end

local tradeTokens: any = LocalPlayer:GetAttribute("TradeTokens")
local n3 = typeof(tradeTokens) == "number" and tradeTokens or 0

tokens.Text = formatNumber(n3)

local u31

if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
	u31 = true
else
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u33

	if typeof(matchId) == "string" and matchId ~= "" then
		u33 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u33 = typeof(spectating) == "number" and spectating ~= 0
	end

	u31 = if u33 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
end

scriptParent.Visible = u31
LocalPlayer:GetAttributeChangedSignal("TradeTokens"):Connect(function()
	local tradeTokens2 = LocalPlayer:GetAttribute("TradeTokens")

	if typeof(tradeTokens2) ~= "number" then
		tradeTokens2 = 0
	end

	local n1 = tradeTokens2 - n3

	n3 = tradeTokens2
	tokens.Text = formatNumber(tradeTokens2)

	local u81

	if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
		u81 = true
	else
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local u83

		if typeof(matchId) == "string" and matchId ~= "" then
			u83 = true
		else
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u83 = typeof(spectating) == "number" and spectating ~= 0
		end

		u81 = if u83 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
	end

	scriptParent.Visible = u81
	playTokenAnim(n1)
end)

local more: Instance = scriptParent:WaitForChild("More")

more.Visible = tradingPlazaGate.IsTradingPlaza()

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local openShop: Instance = bindables:WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")

more.MouseButton1Click:Connect(function()
	openShop:Fire("Tokens")
	shopOpenAnalytics:FireServer("TokensMore")
end)

local function refreshMatchVisibility()
	local u85

	if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
		u85 = true
	else
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local u87

		if typeof(matchId) == "string" and matchId ~= "" then
			u87 = true
		else
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u87 = typeof(spectating) == "number" and spectating ~= 0
		end

		u85 = if u87 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
	end

	scriptParent.Visible = u85
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshMatchVisibility)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshMatchVisibility)
bindables:WaitForChild("ToggleMatchLeaderboard").Event:Connect(function(p4)
	u11 = p4

	local u90

	if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
		u90 = true
	else
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local u92

		if typeof(matchId) == "string" and matchId ~= "" then
			u92 = true
		else
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u92 = typeof(spectating) == "number" and spectating ~= 0
		end

		u90 = if u92 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
	end

	scriptParent.Visible = u90
end)

local u40

if LocalPlayer:GetAttribute("DebugShowTradeTokens") == true then
	u40 = true
else
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u42

	if typeof(matchId) == "string" and matchId ~= "" then
		u42 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u42 = typeof(spectating) == "number" and spectating ~= 0
	end

	u40 = if u42 and not u11 then false else if tradingPlazaGate.IsTradingPlaza() then true else (tonumber(LocalPlayer:GetAttribute("TradeTokens")) or 0) > 0
end

scriptParent.Visible = u40
