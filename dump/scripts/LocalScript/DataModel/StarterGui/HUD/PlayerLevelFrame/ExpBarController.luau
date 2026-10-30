-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local playerLevelFrame: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("PlayerLevelFrame")
local levelBarFrame: Instance = playerLevelFrame:WaitForChild("LevelBarFrame")
local levelBarFrameCurrentLevel: Instance = levelBarFrame:WaitForChild("CurrentLevel")
local currentLevel: Instance = levelBarFrameCurrentLevel:FindFirstChild("CurrentLevel")
local levelBarFrameNextLevel: Instance = levelBarFrame:WaitForChild("NextLevel")
local nextLevel: Instance = levelBarFrameNextLevel:FindFirstChild("NextLevel")
local barFill: Instance = levelBarFrame:WaitForChild("BarBacking"):WaitForChild("BarFill")
local playerLevelFrameExp: Instance = playerLevelFrame:WaitForChild("Exp")
local exp: Instance = playerLevelFrameExp:FindFirstChild("Exp")
local reward: Instance = playerLevelFrame:FindFirstChild("Reward")
local quantityCounter: Instance = reward and reward:FindFirstChild("QuantityCounter")

local function _levelUpCoinReward(p1)
	local floored = math.floor(p1)
	local v28 = math.max(1, floored)
	local n1

	if v28 <= 20 then
		n1 = math.max(0, v28 - 2) / 18 * 300 + 300
	elseif v28 <= 50 then
		n1 = (v28 - 20) / 30 * 800 + 800
	elseif v28 <= 75 then
		n1 = (v28 - 50) / 25 * 1200 + 1600
	else
		n1 = math.min(1, (v28 - 75) / 25) * 2000 + 2800
	end

	local floored2 = math.floor(n1 / 10 + 0.5)

	return (math.min(floored2 * 10, 3200))
end
local function formatReward(p2)
	return (tostring(p2))
end

local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u18 = nil

local function setTextPair(p3, p4, text)
	p3.Text = text

	if p4 then
		p4.Text = text
	end
end
local function animateBar(p6)
	local v36 = math.clamp(p6, 0, 1)
	local uDim2 = UDim2.new(v36, v36 * -4, 1, -4)

	if u18 then
		u18:Cancel()
	end

	u18 = tweenService:Create(barFill, tweenInfo, { Size = uDim2 })
	u18:Play()
end
local function refresh()
	local level: any = LocalPlayer:GetAttribute("Level")
	local exp2: any = LocalPlayer:GetAttribute("Exp")
	local maxExp: any = LocalPlayer:GetAttribute("MaxExp")
	local n1 = typeof(level) == "number" and level or 0
	local n2 = typeof(exp2) == "number" and exp2 or 0
	local n3 = typeof(maxExp) == "number" and maxExp > 0 and maxExp or 1
	local v44: Instance = currentLevel
	local v45 = ("Lv. %d"):format(n1)

	levelBarFrameCurrentLevel.Text = v45

	if v44 then
		v44.Text = v45
	end

	v44 = nextLevel
	v45 = ("Lv. %d"):format(n1 + 1)
	levelBarFrameNextLevel.Text = v45

	if v44 then
		v44.Text = v45
	end

	v44 = exp
	v45 = ("%d / %d XP (%.0f%%)"):format(n2, n3, n2 / n3 * 100)
	playerLevelFrameExp.Text = v45

	if v44 then
		v44.Text = v45
	end

	animateBar(n2 / n3)

	if quantityCounter then
		local v46 = _levelUpCoinReward(n1 + 1)

		quantityCounter.Text = tostring(v46)
	end
end

LocalPlayer:GetAttributeChangedSignal("Exp"):Connect(refresh)
LocalPlayer:GetAttributeChangedSignal("MaxExp"):Connect(refresh)
LocalPlayer:GetAttributeChangedSignal("Level"):Connect(refresh)
refresh()
refresh = function()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
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
	local u50

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
		u50 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u50 = typeof(spectating) == "number" and spectating ~= 0
	end

	playerLevelFrame.Visible = not u50
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshMatchVisibility)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshMatchVisibility)

local matchId: any = LocalPlayer:GetAttribute("MatchId")
local u24

if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
	u24 = true
else
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	u24 = typeof(spectating) == "number" and spectating ~= 0
end

playerLevelFrame.Visible = not u24
