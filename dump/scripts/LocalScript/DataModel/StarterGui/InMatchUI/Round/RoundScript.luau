-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local sound = require(game.ReplicatedStorage:WaitForChild("Sound"))
local LocalPlayer: Player = players.LocalPlayer
local countdownUI = require(script:WaitForChild("CountdownUI"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local icons = require(shared:WaitForChild("Icons"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(replicatedStorageShared:WaitForChild("PlayerState"))
local v12: Instance = replicatedStorage:WaitForChild("Shared")
local botPlayers = require(v12:WaitForChild("BotPlayers"))
local v14: Instance = replicatedStorage:WaitForChild("MatchRemotes"):WaitForChild("State")
local pc = icons.Device.PC
local mobile = icons.Device.Mobile
local console = icons.Device.Console
local disconnected = icons.Device.Disconnected

Color3.fromRGB(162, 255, 148)
Color3.fromRGB(120, 255, 110)
Color3.fromRGB(255, 103, 103)
Color3.fromRGB(255, 41, 41)

local function isLobbySpectating()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u120: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u120 = lobbySpectateMatchId ~= ""
	end

	return u120
end
local function inRealMatch()
	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		if typeof(matchId) == "string" and matchId ~= "PRACTICE" then
			local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
			local u123: boolean = true

			if matchSide ~= "A" then
				u123 = matchSide == "B"
			end

			return u123
		end

		return false
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u125: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u125 = lobbySpectateMatchId ~= ""
	end

	return u125
end
local function nowSeconds()
	local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds

	if typeof(playerStateReplayPlayheadSeconds) == "number" then
		return playerStateReplayPlayheadSeconds
	end

	return workspace:GetServerTimeNow()
end
local function replayClockActive()
	return typeof(playerState.ReplayPlayheadSeconds) == "number"
end
local function headshotUrl(p1)
	if p1 < 0 then
		return "rbxassetid://127075876244307"
	end

	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p1)
end

local t1: {[any]: any} = {
	pc = pc,
	mobile = mobile,
	console = console,
	xbox = console,
	playstation = console
}

local function getDeviceIcon(p2)
	local device = p2:GetAttribute("Device")

	if typeof(device) == "string" then
		local lowerText = string.lower(device)

		return t1[lowerText] or pc
	end

	return pc
end

local object = setmetatable({}, { __mode = "k" })
local object2 = setmetatable({}, { __mode = "k" })

local function getBase(p3)
	local t5 = object[p3]

	if not t5 then
		t5 = { Size = p3.Size, Position = p3.Position }
		object[p3] = t5
	end

	return t5
end
local function popScale(p4, p5)
	local t6 = object[p4]

	if not t6 then
		t6 = { Size = p4.Size, Position = p4.Position }
		object[p4] = t6
	end

	local v136 = object2[p4]

	if v136 then
		v136:Cancel()
	end

	v136 = t6.Size
	p4.Size = UDim2.new(v136.X.Scale * (p5 + 1), v136.X.Offset, v136.Y.Scale * (p5 + 1), v136.Y.Offset)
	p4.Position = t6.Position

	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	v136 = tweenService:Create(p4, tweenInfo, { Size = t6.Size })
	object2[p4] = v136
	v136:Play()
end
local function tweenProp(p6, p7, p8)
	local v141: Tween = tweenService:Create(p6, p7, p8)

	v141:Play()

	return v141
end
local function setText(p9, text)
	if not p9 then
		return
	end

	if text == p9.Text then
		return
	end

	p9.Text = text
	popScale(p9, 0.08)
end
local function setImage(p11, image)
	if not p11 then
		return
	end

	if image == p11.Image then
		return
	end

	p11.Image = image
	popScale(p11, 0.06)
end

local u33 = nil
local foreground = nil
local top = nil
local leftSide = nil
local rightSide = nil
local state = nil
local u39 = nil
local u40 = nil
local u41 = nil
local frame = nil
local middleText = nil
local playerMatchTemplateAllyAlive = nil
local playerMatchTemplateEnemyAlive = nil
local playerMatchTemplateAllyDisconnected = nil
local dead = nil
local crown: Instance = script:WaitForChild("Crown")
local crownGradient: Instance = script:WaitForChild("CrownGradient")
local u50 = nil
local u51 = nil
local winText = nil
local roundLabel = nil
local brightGlow = nil
local u55 = nil
local u56 = nil
local matchpoint = nil
local warning2 = nil
local t2: {[any]: any} = {}
local u60 = nil
local t3: {[any]: any} = {}
local u62 = nil
local u63 = nil

local function bindUI()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return false
	end

	local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")

	if not inMatchUI then
		return false
	end

	local round: Instance = inMatchUI:FindFirstChild("Round")

	if not round or not round:IsA("Frame") then
		return false
	end

	u33 = round

	local matchStatusFrame: Instance = round:FindFirstChild("MatchStatusFrame")

	if not matchStatusFrame then
		return false
	end

	foreground = matchStatusFrame:FindFirstChild("Foreground")

	if not foreground then
		return false
	end

	top = foreground:FindFirstChild("Top")

	if not top then
		return false
	end

	leftSide = top:FindFirstChild("LeftSide")
	rightSide = top:FindFirstChild("RightSide")
	state = top:FindFirstChild("State")

	if not leftSide or not rightSide or not state then
		return false
	end

	local score1 = state:FindFirstChild("Score1")
	local score2 = state:FindFirstChild("Score2")

	u39 = score1 and score1:FindFirstChild("Value")
	u40 = score2 and score2:FindFirstChild("Value")

	local timer = state:FindFirstChild("Timer")

	u41 = timer and timer:FindFirstChild("TextLabel")

	local bottom = foreground:FindFirstChild("Bottom")

	if bottom then
		frame = bottom:FindFirstChild("Frame")
	end

	local folder = state:FindFirstChild("Folder")

	if folder then
		middleText = folder:FindFirstChild("MiddleText")
	end

	playerMatchTemplateAllyAlive = leftSide:FindFirstChild("PlayerMatchTemplateAllyAlive")
	playerMatchTemplateEnemyAlive = rightSide:FindFirstChild("PlayerMatchTemplateEnemyAlive")
	playerMatchTemplateAllyDisconnected = leftSide:FindFirstChild("PlayerMatchTemplateAllyDisconnected")

	local playerMatchTemplateEnemyDead = rightSide:FindFirstChild("PlayerMatchTemplateEnemyDead")

	if playerMatchTemplateEnemyDead then
		dead = playerMatchTemplateEnemyDead:FindFirstChild("Dead")
	end

	for _, v in ipairs({ leftSide, rightSide }) do
		for _, iterValue in ipairs(v:GetChildren()) do
			if iterValue:IsA("Frame") and iterValue.Name:find("Template") then
				iterValue.Visible = false
			end
		end
	end

	if u39 then
		u39.Text = "0"
	end

	if u40 then
		u40.Text = "0"
	end

	local roundEnded: Instance = round:FindFirstChild("RoundEnded")

	if roundEnded and roundEnded:IsA("ImageLabel") then
		u51 = roundEnded
		winText = roundEnded:FindFirstChild("WinText")
		roundLabel = roundEnded:FindFirstChild("RoundLabel")
		brightGlow = roundEnded:FindFirstChild("BrightGlow")

		for _, v in ipairs(roundEnded:GetChildren()) do
			if v:IsA("UIStroke") and v.Name == "UIStroke" then
				u55 = v

				break
			end
		end

		roundEnded.Visible = false
	end

	local warning: Instance = round:FindFirstChild("WARNING")

	if warning and warning:IsA("Frame") then
		u56 = warning
		matchpoint = warning:FindFirstChild("MATCHPOINT")
		warning2 = warning:FindFirstChild("Warning")
		warning.Visible = false
	end

	return playerMatchTemplateAllyAlive ~= nil and playerMatchTemplateEnemyAlive ~= nil
end
local function cloneCard(p13, p14)
	local v166 = p14 or "Alive"
	local v167 = if v166 == "Disconnected" then playerMatchTemplateAllyDisconnected else p13 and playerMatchTemplateAllyAlive or playerMatchTemplateEnemyAlive

	if not v167 then
		return nil
	end

	local clone = v167:Clone()

	clone.LayoutOrder = 0
	clone.Visible = true
	clone.Name = "PlayerCard"

	local headshot = clone:FindFirstChild("Headshot")
	local device = clone:FindFirstChild("Device")
	local icon = nil

	if device then
		icon = device:FindFirstChild("Icon")
	end

	local score = clone:FindFirstChild("Score")
	local level = clone:FindFirstChild("Level")
	local v174 = nil

	for _, v in ipairs(clone:GetChildren()) do
		if v.Name == "Glow" and v:IsA("ImageLabel") then
			v174 = v

			break
		end
	end

	local v177 = nil
	local v178 = nil

	if dead then
		local clone2 = dead:Clone()

		clone2.BackgroundTransparency = 1

		local icon = clone2:FindFirstChild("Icon")

		if icon then
			icon.ImageTransparency = 1
		end

		local glow = clone2:FindFirstChild("Glow")

		if glow then
			glow.ImageTransparency = 1
		end

		clone2.Parent = clone
		v177 = clone2
		v178 = icon
	end

	return {
		Owner = nil,
		Side = "A",
		LayoutOrder = 0,
		Root = clone,
		HeadShot = headshot,
		DeviceIcon = icon,
		Score = score,
		Level = level,
		Dead = v177,
		DeadIcon = v178,
		Glow = v174,
		IsAlly = p13,
		Disconnected = if v166 == "Disconnected" then true else false
	}
end
local function setCardDead(p15, p16)
	local dead = p15.Dead

	if dead then
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad)

		tweenService:Create(dead, tweenInfo, {
			BackgroundTransparency = if p16 then 0.3 else 1
		}):Play()

		local glow = dead:FindFirstChild("Glow")

		if glow then
			local tweenInfo2 = TweenInfo.new(0.22, Enum.EasingStyle.Quad)

			tweenService:Create(glow, tweenInfo2, {
				ImageTransparency = if p16 then 0 else 1
			}):Play()
		end
	end

	local deadIcon = p15.DeadIcon

	if deadIcon then
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad)

		tweenService:Create(deadIcon, tweenInfo, {
			ImageTransparency = if p16 then 0.05 else 1
		}):Play()
	end

	if p15.Glow then
		p15.Glow.Visible = not p16
	end
end
local function setCardDisconnected(p17, p18)
	if p18 then
		local deviceIcon = p17.DeviceIcon
		local image = disconnected

		if deviceIcon and image ~= deviceIcon.Image then
			deviceIcon.Image = image
			popScale(deviceIcon, 0.06)
		end

		if p17.Glow then
			p17.Glow.Visible = false
		end
	end
end
local function rebuildCardAsDisconnected(p19, parent)
	if not playerMatchTemplateAllyDisconnected then
		return nil
	end

	local owner = p19.Owner
	local side = p19.Side
	local isAlly = p19.IsAlly
	local layoutOrder = p19.Root.LayoutOrder
	local v200 = p19.Score and p19.Score.Text or "0"
	local v201 = p19.Level and p19.Level.Text or "0"
	local v202 = p19.HeadShot and p19.HeadShot.Image or ""

	if p19.Root and p19.Root.Parent then
		p19.Root:Destroy()
	end

	local v203 = cloneCard(isAlly, "Disconnected")

	if not v203 then
		return nil
	end

	v203.Owner = owner
	v203.Side = side
	v203.Root.Parent = parent
	v203.Root.LayoutOrder = layoutOrder
	v203.LayoutOrder = layoutOrder
	v203.Disconnected = true

	if v203.Score then
		v203.Score.Text = v200
	end

	if v203.Level then
		v203.Level.Text = v201
	end

	if v203.HeadShot then
		v203.HeadShot.Image = v202
	end

	local deviceIcon = v203.DeviceIcon
	local image = disconnected

	if deviceIcon and image ~= deviceIcon.Image then
		deviceIcon.Image = image
		popScale(deviceIcon, 0.06)
	end

	if v203.Glow then
		v203.Glow.Visible = false
	end

	return v203
end
local function updateCard(p21)
	local owner = p21.Owner

	if not owner then
		return
	end

	if p21.Disconnected then
		return
	end

	local headShot = p21.HeadShot
	local ownerUserId = owner.UserId
	local s1 = if ownerUserId < 0 then "rbxassetid://127075876244307" else ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(ownerUserId)

	if headShot and s1 ~= headShot.Image then
		headShot.Image = s1
		popScale(headShot, 0.06)
	end

	local matchKills = owner:GetAttribute("MatchKills")
	local score = p21.Score
	local typeName: string = typeof(matchKills)
	local text: string = tostring(typeName == "number" and matchKills or 0)

	if score and text ~= score.Text then
		score.Text = text
		popScale(score, 0.08)
	end

	local level = owner:GetAttribute("Level")
	local v216 = p21.Level
	local typeName2: string = typeof(level)
	local text2: string = tostring(typeName2 == "number" and level or 0)

	if v216 and text2 ~= v216.Text then
		v216.Text = text2
		popScale(v216, 0.08)
	end

	s1 = owner:GetAttribute("Alive") == false
	setCardDead(p21, s1)

	if not s1 then
		local deviceIcon = p21.DeviceIcon
		local device = owner:GetAttribute("Device")
		local image = if typeof(device) == "string" then t1[string.lower(device)] or pc else pc

		if deviceIcon and image ~= deviceIcon.Image then
			deviceIcon.Image = image
			popScale(deviceIcon, 0.06)
		end

		if p21.Glow then
			p21.Glow.Visible = true
		end
	end
end
local function watchPlayer(p22)
	local v223 = t2[p22]

	if not v223 then
		return
	end

	if t3[p22] then
		updateCard(v223)

		return
	end

	t3[p22] = true

	local function hook(p23)
		p22:GetAttributeChangedSignal(p23):Connect(function()
			local v541 = t2[p22]

			if not v541 then
				return
			end

			if v541.Disconnected then
				return
			end

			updateCard(v541)
			popScale(v541.Root, 0.04)

			if p23 == "MatchKills" then
				updateCrownHolder()
			end
		end)
	end

	local s1: string = "MatchKills"

	p22:GetAttributeChangedSignal("MatchKills"):Connect(function()
		local v421 = t2[p22]

		if not v421 then
			return
		end

		if v421.Disconnected then
			return
		end

		updateCard(v421)
		popScale(v421.Root, 0.04)

		if s1 == "MatchKills" then
			updateCrownHolder()
		end
	end)

	local s2: string = "Level"

	p22:GetAttributeChangedSignal("Level"):Connect(function()
		local v422 = t2[p22]

		if not v422 then
			return
		end

		if v422.Disconnected then
			return
		end

		updateCard(v422)
		popScale(v422.Root, 0.04)

		if s2 == "MatchKills" then
			updateCrownHolder()
		end
	end)

	local s3: string = "Device"

	p22:GetAttributeChangedSignal("Device"):Connect(function()
		local v423 = t2[p22]

		if not v423 then
			return
		end

		if v423.Disconnected then
			return
		end

		updateCard(v423)
		popScale(v423.Root, 0.04)

		if s3 == "MatchKills" then
			updateCrownHolder()
		end
	end)

	local s4: string = "Alive"

	p22:GetAttributeChangedSignal("Alive"):Connect(function()
		local v424 = t2[p22]

		if not v424 then
			return
		end

		if v424.Disconnected then
			return
		end

		updateCard(v424)
		popScale(v424.Root, 0.04)

		if s4 == "MatchKills" then
			updateCrownHolder()
		end
	end)
	updateCard(v223)
end
local function updateBottomBarWidth()
	if not frame or not top then
		return
	end

	task.spawn(function()
		if not frame or not frame.Parent or not top then
			return
		end

		local uiListLayout = top:FindFirstChild("UIListLayout")

		if not uiListLayout then
			return
		end

		local n1 = 0

		for _ = 1, 9 do
			runService.RenderStepped:Wait()
			n1 = uiListLayout.AbsoluteContentSize.X

			if n1 > 0 then
				break
			end
		end

		if n1 <= 0 then
			return
		end

		if not frame or not frame.Parent then
			return
		end

		local x = frame.Parent.AbsoluteSize.X

		if x <= 0 then
			return
		end

		frame.Size = UDim2.new((n1 + 8) / x, 0, 1, 0)
	end)
end

local n1 = 5
local endAt = nil
local connection = nil
local u75: boolean = false
local u76 = nil

local function getMyMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" then
		return matchId
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		return lobbySpectateMatchId
	end

	return nil
end
local function isInMyMatch(p24, p25)
	local u233: boolean = false

	if p24:GetAttribute("InMatch") == true then
		local matchId = p24:GetAttribute("MatchId")

		u233 = p25 == matchId
	end

	return u233
end
local function getSide(p26)
	local matchSide = p26:GetAttribute("MatchSide")

	if matchSide == "A" or matchSide == "B" or matchSide == "P" then
		return matchSide
	end

	return nil
end
local function getViewSideAB()
	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
	local v238 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil

	if v238 == "A" or v238 == "B" then
		return v238
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u240: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u240 = lobbySpectateMatchId ~= ""
	end

	if u240 then
		local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

		if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
			return lobbySpectateTeam
		end
	end

	local playerStateReplayViewSide = playerState.ReplayViewSide

	if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then
		return playerStateReplayViewSide
	end

	return nil
end
local function computeSortKey(player)
	local matchKills = player:GetAttribute("MatchKills")
	local typeName: string = typeof(matchKills)

	return (if player:GetAttribute("Alive") == false then 0 else 1) * 1000000000 + (typeName == "number" and matchKills or 0) * 1000000 + (1000000 - player.UserId % 1000000)
end
local function applyScoreAB(p28, p29)
	if typeof(p28) == "number" and typeof(p29) == "number" then
		u62 = p28
		u63 = p29

		local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
		local v249 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil
		local v251

		if v249 == "A" or v249 == "B" then
			v251 = v249
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
			local u252: boolean = false

			if typeof(lobbySpectateMatchId) == "string" then
				u252 = lobbySpectateMatchId ~= ""
			end

			if u252 then
				local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

				if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
					v251 = lobbySpectateTeam
				else
					local playerStateReplayViewSide = playerState.ReplayViewSide

					v251 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
				end
			else
				local playerStateReplayViewSide = playerState.ReplayViewSide

				v251 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
			end
		end

		if v251 == "B" then
			local v255 = u39
			local text: string = tostring(p29)

			if v255 and text ~= v255.Text then
				v255.Text = text
				popScale(v255, 0.08)
			end

			local v257 = u40
			local text3: string = tostring(p28)

			if not v257 then
				return
			end

			if text3 == v257.Text then
				return
			end

			v257.Text = text3
			popScale(v257, 0.08)

			return
		end

		local v259 = u39
		local text: string = tostring(p28)

		if v259 and text ~= v259.Text then
			v259.Text = text
			popScale(v259, 0.08)
		end

		local v261 = u40
		local text4: string = tostring(p29)

		if not v261 then
			return
		end

		if text4 == v261.Text then
			return
		end

		v261.Text = text4
		popScale(v261, 0.08)

		return
	end
end
local function removeCrownFromCard(p30)
	local score = p30.Score

	if not score then
		return
	end

	local crown = score:FindFirstChild("Crown")

	if crown then
		crown:Destroy()
	end

	local crownGradient = score:FindFirstChild("CrownGradient")

	if crownGradient then
		crownGradient:Destroy()
	end
end
local function applyCrownToCard(p31)
	local score = p31.Score

	if not score then
		return
	end

	if crown and not score:FindFirstChild("Crown") then
		local clone: Instance = crown:Clone()

		clone.Parent = score
	end

	if crownGradient then
		for _, v in ipairs(score:GetChildren()) do
			if v:IsA("UIGradient") and v.Name ~= "CrownGradient" then
				v.Enabled = false
			end
		end

		if not score:FindFirstChild("CrownGradient") then
			local clone: Instance = crownGradient:Clone()

			clone.Parent = score
		end
	end
end
local function restoreNormalGradient(p32)
	local score = p32.Score

	if not score then
		return
	end

	local crownGradient = score:FindFirstChild("CrownGradient")

	if crownGradient then
		crownGradient:Destroy()
	end

	for _, v in ipairs(score:GetChildren()) do
		if v:IsA("UIGradient") then
			v.Enabled = true
		end
	end
end
function updateCrownHolder()
	if not crown then
		return
	end

	local n1 = 0

	for iterKey in pairs(t2) do
		n1 += 1
	end

	if n1 <= 2 then
		if u50 then
			local score = u50.Score

			if score then
				local crown2 = score:FindFirstChild("Crown")

				if crown2 then
					crown2:Destroy()
				end

				local crownGradient = score:FindFirstChild("CrownGradient")

				if crownGradient then
					crownGradient:Destroy()
				end
			end

			restoreNormalGradient(u50)
			u50 = nil
		end

		return
	end

	n1 = nil

	local n2 = 0

	for _, v in pairs(t2) do
		local vOwner = v.Owner

		if vOwner then
			local matchKills = vOwner:GetAttribute("MatchKills")
			local v288 = typeof(matchKills) == "number" and matchKills or 0

			if n2 < v288 or v288 == n2 and n1 == nil then
				n2 = v288
				n1 = v
			end
		end
	end

	if n2 < 1 then
		if u50 then
			local v289 = u50.Score

			if v289 then
				local crown3 = v289:FindFirstChild("Crown")

				if crown3 then
					crown3:Destroy()
				end

				local crownGradient = v289:FindFirstChild("CrownGradient")

				if crownGradient then
					crownGradient:Destroy()
				end
			end

			restoreNormalGradient(u50)
			u50 = nil
		end
	elseif n1 ~= u50 then
		if u50 then
			local v292 = u50.Score

			if v292 then
				local crown4 = v292:FindFirstChild("Crown")

				if crown4 then
					crown4:Destroy()
				end

				local crownGradient = v292:FindFirstChild("CrownGradient")

				if crownGradient then
					crownGradient:Destroy()
				end
			end

			restoreNormalGradient(u50)
		end

		if n1 then
			applyCrownToCard(n1)
		end

		u50 = n1
	end
end
local function rebuildTeams()
	if not leftSide or not rightSide then
		return
	end

	local t7: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		t7[v] = true
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v299

	if typeof(matchId) == "string" then
		v299 = matchId
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v299 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	if not v299 then
		if u33 then
			u33.Visible = false
		end

		return
	end

	local t8: {[any]: any} = {}
	local t9: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		local u305: boolean = false

		if v:GetAttribute("InMatch") == true then
			local matchId2 = v:GetAttribute("MatchId")

			u305 = v299 == matchId2
		end

		if u305 then
			local matchSide = v:GetAttribute("MatchSide")
			local v308 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil

			if v308 == "A" then
				table.insert(t8, v)
			end

			if v308 == "B" then
				table.insert(t9, v)
			end
		end
	end

	for _, v in ipairs(botPlayers.GetBotProxies(v299)) do
		t7[v] = true

		local matchSide = v:GetAttribute("MatchSide")

		if matchSide == "A" then
			table.insert(t8, v)
		end

		if matchSide == "B" then
			table.insert(t9, v)
		end
	end

	table.sort(t8, function(player, player2)
		local matchKills = player:GetAttribute("MatchKills")
		local typeName: string = typeof(matchKills)
		local n1 = (if player:GetAttribute("Alive") == false then 0 else 1) * 1000000000 + (typeName == "number" and matchKills or 0) * 1000000 + (1000000 - player.UserId % 1000000)
		local matchKills2 = player2:GetAttribute("MatchKills")
		local typeName3: string = typeof(matchKills2)
		local alive = player2:GetAttribute("Alive")

		return n1 > (if alive == false then 0 else 1) * 1000000000 + (typeName3 == "number" and matchKills2 or 0) * 1000000 + (1000000 - player2.UserId % 1000000)
	end)
	table.sort(t9, function(player, player2)
		local matchKills = player:GetAttribute("MatchKills")
		local typeName: string = typeof(matchKills)
		local n1 = (if player:GetAttribute("Alive") == false then 0 else 1) * 1000000000 + (typeName == "number" and matchKills or 0) * 1000000 + (1000000 - player.UserId % 1000000)
		local matchKills3 = player2:GetAttribute("MatchKills")
		local typeName4: string = typeof(matchKills3)
		local alive = player2:GetAttribute("Alive")

		return n1 > (if alive == false then 0 else 1) * 1000000000 + (typeName4 == "number" and matchKills3 or 0) * 1000000 + (1000000 - player2.UserId % 1000000)
	end)

	local matchSide2: any = LocalPlayer:GetAttribute("MatchSide")
	local v313 = if matchSide2 == "A" or matchSide2 == "B" or matchSide2 == "P" then matchSide2 else nil
	local v315

	if v313 == "A" or v313 == "B" then
		v315 = v313
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u316: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u316 = lobbySpectateMatchId ~= ""
		end

		if u316 then
			local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

			if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
				v315 = lobbySpectateTeam
			else
				local playerStateReplayViewSide = playerState.ReplayViewSide

				v315 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
			end
		else
			local playerStateReplayViewSide = playerState.ReplayViewSide

			v315 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
		end
	end

	if u60 ~= nil and v315 ~= nil and v315 ~= u60 then
		for _, v in pairs(t2) do
			if v.Root and v.Root.Parent then
				v.Root:Destroy()
			end
		end

		table.clear(t2)
		u50 = nil
	end

	u60 = v315

	local function ensureCards(parent, p38, side, p40)
		local t10: {[any]: any} = {}

		for k, v in pairs(t2) do
			if side == v.Side and not t7[k] then
				t10[k] = true

				if not v.Disconnected then
					local v452 = rebuildCardAsDisconnected(v, parent)

					if v452 then
						t2[k] = v452

						if v == u50 then
							u50 = nil
						end
					end
				end
			end
		end

		for i, v in ipairs(p38) do
			t10[v] = true

			local v455 = t2[v]

			if not v455 then
				local v456 = cloneCard(p40)

				if not v456 then
					continue
				end

				v456.Owner = v
				v456.Side = side
				v456.Root.Parent = parent
				t2[v] = v456
				v455 = v456
				v455.Root.Visible = true
				popScale(v455.Root, 0.1)
				watchPlayer(v)
			end

			if v455.LayoutOrder == 0 then
				v455.LayoutOrder = i
			end

			if v455.Root.LayoutOrder == 0 then
				v455.Root.LayoutOrder = i
			end
		end

		for k, v in pairs(t2) do
			if side == v.Side and not t10[k] then
				if v == u50 then
					u50 = nil
				end

				t2[k] = nil

				local vRoot = v.Root
				local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad)

				tweenService:Create(vRoot, tweenInfo, {}):Play()
				task.delay(0.18, function()
					if vRoot and vRoot.Parent then
						vRoot:Destroy()
					end
				end)
			end
		end
	end

	ensureCards(leftSide, v315 == "B" and t9 or t8, if v315 == "B" then "B" else "A", true)
	ensureCards(rightSide, v315 == "B" and t8 or t9, if v315 == "B" then "A" else "B", false)

	for k, v in pairs(t2) do
		if not t7[k] then
			local vDeviceIcon = v.DeviceIcon
			local image = disconnected

			if vDeviceIcon and image ~= vDeviceIcon.Image then
				vDeviceIcon.Image = image
				popScale(vDeviceIcon, 0.06)
			end

			if v.Glow then
				v.Glow.Visible = false
			end
		end
	end

	if frame and top then
		task.spawn(function()
			if not frame or not frame.Parent or not top then
				return
			end

			local uiListLayout = top:FindFirstChild("UIListLayout")

			if not uiListLayout then
				return
			end

			local n1 = 0

			for _ = 1, 9 do
				runService.RenderStepped:Wait()
				n1 = uiListLayout.AbsoluteContentSize.X

				if n1 > 0 then
					break
				end
			end

			if n1 <= 0 then
				return
			end

			if not frame or not frame.Parent then
				return
			end

			local x = frame.Parent.AbsoluteSize.X

			if x <= 0 then
				return
			end

			frame.Size = UDim2.new((n1 + 8) / x, 0, 1, 0)
		end)
	end

	updateCrownHolder()
end
local function stopTimerLoop()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	endAt = nil
end
local function startTimerLoop()
	if connection then
		connection:Disconnect()
	end

	local u326: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

	connection = runService.RenderStepped:Connect(function()
		if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u326 then
			if connection then
				connection:Disconnect()
				connection = nil
			end

			endAt = nil

			return
		end

		if not u41 or not endAt then
			if u41 then
				u41.Text = "--:--"
			end

			return
		end

		local v465 = endAt
		local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
		local v467 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
		local v468 = math.max(0, v465 - v467)
		local floored = math.floor(v468 + 0.999)
		local stringFormat = string.format
		local floored2 = math.floor(floored / 60)

		v468 = stringFormat("%d:%02d", floored2, floored % 60)

		if u41.Text ~= v468 then
			u41.Text = v468

			if floored <= 10 then
				popScale(u41, 0.08)
			end
		end
	end)
end
local function setRulesText()
	if middleText then
		middleText.Text = ("FIRST TO %d WINS"):format(n1)
	end
end

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo4 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local color3 = Color3.fromRGB(124, 255, 133)
local color32 = Color3.fromRGB(73, 255, 88)
local color33 = Color3.fromRGB(56, 255, 79)
local color34 = Color3.fromRGB(255, 99, 99)
local color35 = Color3.fromRGB(255, 39, 39)
local color36 = Color3.fromRGB(255, 78, 78)
local color37 = Color3.fromRGB(200, 200, 200)
local color38 = Color3.fromRGB(220, 220, 220)
local color39 = Color3.fromRGB(180, 180, 180)
local color310 = Color3.fromRGB(255, 215, 0)
local color311 = Color3.fromRGB(255, 230, 50)
local color312 = Color3.fromRGB(255, 200, 0)
local u106: boolean = false
local n2: number = 0
local u108 = nil
local u109 = nil

local function cleanSlideClones()
	if not u51 then
		return
	end

	for iterFirst, iterSecond in u51:GetChildren() do
		if iterSecond:GetAttribute("_SlideClone") then
			iterSecond:Destroy()
		end
	end
end
local function resetTextLabels()
	cleanSlideClones()

	if winText and u108 then
		winText.Position = u108
	end

	if roundLabel and u109 then
		roundLabel.Position = u109
	end
end
local function slideSwapText(p41, text, textColor3, p44, p45, p46)
	local v335 = p45 or -1
	local v336 = p46 or p41.Position
	local clone = p41:Clone()

	clone:SetAttribute("_SlideClone", true)
	clone.Text = text
	clone.TextColor3 = textColor3
	clone.Position = UDim2.new(v336.X.Scale + 1 * -v335, v336.X.Offset, v336.Y.Scale, v336.Y.Offset)
	clone.Parent = p41.Parent

	local tweenInfo6 = TweenInfo.new(p44, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local uDim2 = UDim2.new(v336.X.Scale + 1 * v335, v336.X.Offset, v336.Y.Scale, v336.Y.Offset)
	local v340: Tween = tweenService:Create(p41, tweenInfo6, { Position = uDim2 })

	v340:Play()

	local v341: Tween = tweenService:Create(clone, tweenInfo6, { Position = v336 })

	v341:Play()
	v341.Completed:Once(function()
		v340:Pause()
		v340:Destroy()
		p41.Text = text
		p41.TextColor3 = textColor3
		p41.Position = v336
		clone:Destroy()
	end)
end

local t4: {[any]: any} = {
	win = { glow = color3, text = color32, thin = color33 },
	lose = { glow = color34, text = color35, thin = color36 },
	draw = { glow = color37, text = color38, thin = color39 },
	ace = { glow = color310, text = color311, thin = color312 }
}

local function showRoundWin(p47, _, _, p50, p51)
	if not u51 then
		return
	end

	u106 = false
	n2 += 1

	local v347: number = n2

	if not u108 and winText then
		u108 = winText.Position
	end

	if not u109 and roundLabel then
		u109 = roundLabel.Position
	end

	cleanSlideClones()

	if winText and u108 then
		winText.Position = u108
	end

	if roundLabel and u109 then
		roundLabel.Position = u109
	end

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
	local v349 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil
	local v351

	if v349 == "A" or v349 == "B" then
		v351 = v349
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u352: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u352 = lobbySpectateMatchId ~= ""
		end

		if u352 then
			local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

			if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
				v351 = lobbySpectateTeam
			else
				local playerStateReplayViewSide = playerState.ReplayViewSide

				v351 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
			end
		else
			local playerStateReplayViewSide = playerState.ReplayViewSide

			v351 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
		end
	end

	local u355: boolean = p47 == v351
	local u356: boolean = p47 == "Draw"
	local u357: boolean = p51 ~= nil
	local v358 = u356 and t4.draw or u355 and t4.win or t4.lose
	local v359 = u357 and t4.ace or v358

	if winText then
		if u357 then
			winText.Text = "ACE!"
		elseif u356 then
			winText.Text = "DRAW"
		elseif u355 then
			winText.Text = "WIN"
		else
			winText.Text = "LOSS"
		end

		winText.TextColor3 = v359.text
	end

	if roundLabel then
		if u357 then
			roundLabel.Text = p51.acePlayerName
		else
			roundLabel.Text = "ROUND " .. tostring(p50)
		end
	end

	if brightGlow then
		brightGlow.ImageColor3 = v359.glow
	end

	if u55 then
		u55.Color = v359.thin
	end

	if u357 then
		sound:Play("Misc.AceRound", workspace)
	elseif u356 then
		sound:Play("Misc.DrawRound", workspace)
	elseif u355 then
		sound:Play("Misc.WinRound", workspace)
	else
		sound:Play("Misc.LoseRound", workspace)
	end

	u51.Visible = true

	local uiScale = u51:FindFirstChildOfClass("UIScale")

	if uiScale then
		uiScale.Scale = 0
		tweenService:Create(uiScale, tweenInfo, { Scale = 1 }):Play()
	end

	if u357 and brightGlow then
		brightGlow.ImageTransparency = 0

		local v361 = brightGlow
		local tweenInfo7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v361, tweenInfo7, { ImageTransparency = 0.78 }):Play()
	end

	if u357 and winText then
		local clone = winText:Clone()

		clone.Name = "AceTextPop"
		clone.Size = winText.Size
		clone.Position = winText.Position
		clone.AnchorPoint = winText.AnchorPoint
		clone.BackgroundTransparency = 1
		clone.ZIndex = winText.ZIndex + 1
		clone.TextColor3 = Color3.fromRGB(255, 255, 255)

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("UIGradient") or v:IsA("UIStroke") then
				v:Destroy()
			end
		end

		local shineGradient: UIGradient = Instance.new("UIGradient")

		shineGradient.Name = "ShineGradient"
		shineGradient.Rotation = 20

		local colorSequenceNew = ColorSequence.new
		local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 30))
		local colorSequenceKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 230, 120))
		local colorSequenceKeypoint3 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
		local colorSequenceKeypoint4 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 230, 120))

		shineGradient.Color = colorSequenceNew({
			colorSequenceKeypoint,
			colorSequenceKeypoint2,
			colorSequenceKeypoint3,
			colorSequenceKeypoint4,
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 190, 30))
		})
		shineGradient.Offset = Vector2.new(-1.3, 0)
		shineGradient.Parent = clone

		local glowStroke: UIStroke = Instance.new("UIStroke")

		glowStroke.Name = "GlowStroke"
		glowStroke.Color = Color3.fromRGB(255, 220, 80)
		glowStroke.Thickness = 3
		glowStroke.Transparency = 0
		glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		glowStroke.LineJoinMode = Enum.LineJoinMode.Round
		glowStroke.Parent = clone

		local uiScale2: UIScale = Instance.new("UIScale")

		uiScale2.Scale = 1
		uiScale2.Parent = clone
		clone.Parent = winText.Parent

		local tweenInfo8 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenInfo9 = TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

		tweenService:Create(uiScale2, tweenInfo8, { Scale = 3 }):Play()
		tweenService:Create(clone, tweenInfo8, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
		tweenService:Create(shineGradient, tweenInfo9, { Offset = Vector2.new(1.3, 0) }):Play()
		tweenService:Create(glowStroke, tweenInfo8, { Thickness = 12, Transparency = 1 }):Play()
		task.delay(0.7, function()
			if clone then
				clone:Destroy()
			end
		end)
	end

	if u357 and u51 then
		local aceSpeedLines: Frame = Instance.new("Frame")

		aceSpeedLines.Name = "AceSpeedLines"
		aceSpeedLines.Size = UDim2.fromScale(1, 1)
		aceSpeedLines.Position = UDim2.fromScale(0, 0)
		aceSpeedLines.BackgroundTransparency = 1
		aceSpeedLines.BorderSizePixel = 0
		aceSpeedLines.ClipsDescendants = true
		aceSpeedLines.ZIndex = math.max(1, (winText and winText.ZIndex or 2) - 1)
		aceSpeedLines.Parent = u51

		local text = t4.ace.text
		local random = Random.new()

		for i = 1, 22 do
			local u380: boolean = i % 2 == 0
			local speedLine: Frame = Instance.new("Frame")

			speedLine.Name = "SpeedLine"
			speedLine.BorderSizePixel = 0
			speedLine.BackgroundColor3 = text
			speedLine.BackgroundTransparency = random:NextNumber(0.1, 0.4)
			speedLine.AnchorPoint = Vector2.new(0.5, 0.5)

			local uDim2FromOffset = UDim2.fromOffset
			local v383 = random:NextInteger(80, 220)

			speedLine.Size = uDim2FromOffset(v383, random:NextInteger(3, 8))

			local v384 = random:NextNumber(0.05, 0.95)
			local n1: number = if u380 then 1.15 else -0.15

			speedLine.Position = UDim2.new(if u380 then -0.15 else 1.15, 0, v384, 0)
			speedLine.ZIndex = aceSpeedLines.ZIndex
			speedLine.Parent = aceSpeedLines

			local v386 = random:NextNumber(0.35, 0.5)
			local v387 = random:NextNumber(0, 0.12)
			local tweenInfo10 = TweenInfo.new(v386, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

			task.delay(v387, function()
				if not speedLine.Parent then
					return
				end

				local uDim2 = UDim2.new(n1, 0, v384, 0)

				tweenService:Create(speedLine, tweenInfo10, { Position = uDim2 }):Play()
				task.delay(v386 * 0.55, function()
					if not speedLine.Parent then
						return
					end

					local tweenInfo11 = TweenInfo.new(v386 * 0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					tweenService:Create(speedLine, tweenInfo11, { BackgroundTransparency = 1 }):Play()
				end)
			end)
		end

		task.delay(0.7, function()
			if aceSpeedLines then
				aceSpeedLines:Destroy()
			end
		end)
	end

	if u357 then
		u106 = true
		task.delay(1.75, function()
			if not u106 then
				return
			end

			if n2 ~= v347 then
				return
			end

			if u356 then
				sound:Play("Misc.DrawRound", workspace)
			elseif u355 then
				sound:Play("Misc.WinRound", workspace)
			else
				sound:Play("Misc.LoseRound", workspace)
			end

			local tweenInfo12 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

			if brightGlow then
				tweenService:Create(brightGlow, tweenInfo12, { ImageColor3 = v358.glow }):Play()
			end

			if u55 then
				tweenService:Create(u55, tweenInfo12, { Color = v358.thin }):Play()
			end

			if brightGlow then
				brightGlow.ImageTransparency = 0.2

				local v474 = brightGlow
				local tweenInfo13 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(v474, tweenInfo13, { ImageTransparency = 0.78 }):Play()
			end

			local s1: string = if u356 then "DRAW" else if u355 then "WIN" else "LOSS"
			local text: string = tostring(p50)

			if winText then
				slideSwapText(winText, s1, v358.text, 0.35, -1, u108)
			end

			if roundLabel then
				slideSwapText(roundLabel, "ROUND " .. text, roundLabel.TextColor3, 0.35, 1, u109)
			end
		end)
	end
end
local function hideRoundWin()
	u106 = false
	n2 += 1

	if not u51 or not u51.Visible then
		return
	end

	local uiScale = u51:FindFirstChildOfClass("UIScale")

	if uiScale then
		local v390: Tween = tweenService:Create(uiScale, tweenInfo3, { Scale = 0 })

		v390:Play()
		v390.Completed:Once(function()
			u51.Visible = false
			cleanSlideClones()
			cleanSlideClones()

			if winText and u108 then
				winText.Position = u108
			end

			if roundLabel and u109 then
				roundLabel.Position = u109
			end
		end)

		return
	end

	u51.Visible = false
	cleanSlideClones()
	cleanSlideClones()

	if winText and u108 then
		winText.Position = u108
	end

	if roundLabel and u109 then
		roundLabel.Position = u109
	end
end
local function showWarning(p52, p53)
	if not u56 then
		return
	end

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
	local v394 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil
	local v396

	if v394 == "A" or v394 == "B" then
		v396 = v394
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u397: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u397 = lobbySpectateMatchId ~= ""
		end

		if u397 then
			local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

			if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
				v396 = lobbySpectateTeam
			else
				local playerStateReplayViewSide = playerState.ReplayViewSide

				v396 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
			end
		else
			local playerStateReplayViewSide = playerState.ReplayViewSide

			v396 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
		end
	end

	local s1: string = if v396 == "A" then "B" else "A"
	local v401 = v396 == "A" and p52

	if not v401 then
		v401 = false

		if v396 == "B" then
			v401 = p53
		end
	end

	local v402 = s1 == "A" and p52

	if not v402 then
		v402 = false

		if s1 == "B" then
			v402 = p53
		end
	end

	if matchpoint then
		matchpoint.Text = "MATCH POINT"
	end

	if warning2 then
		if v401 and v402 then
			warning2.Text = "BOTH TEAMS AT MATCH POINT!"
		elseif v401 then
			warning2.Text = "YOU NEED 1 POINT TO WIN!"
		else
			warning2.Text = "ENEMY NEEDS 1 POINT TO WIN!"
		end
	end

	u56.Visible = true

	local uiScale = u56:FindFirstChildOfClass("UIScale")

	if uiScale then
		uiScale.Scale = 0
		tweenService:Create(uiScale, tweenInfo4, { Scale = 1 }):Play()
	end
end
local function hideWarning()
	if not u56 or not u56.Visible then
		return
	end

	local uiScale = u56:FindFirstChildOfClass("UIScale")

	if uiScale then
		local v405: Tween = tweenService:Create(uiScale, tweenInfo5, { Scale = 0 })

		v405:Play()
		v405.Completed:Once(function()
			u56.Visible = false
		end)

		return
	end

	u56.Visible = false
end
local function onState(p54, p55, p56, p57)
	task.spawn(function()
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v479

		if typeof(matchId) == "string" then
			v479 = matchId
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v479 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
		end

		if not p56 and (not v479 or v479 ~= p54) then
		elseif typeof(p55) == "table" then
			local t = p55.t
			local v482 = typeof(p57) == "number" and p57

			if not v482 then
				local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds

				v482 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
			end

			if t == "MatchStarted" then
				if u33 then
					u33.Visible = true
				end

				hideRoundWin()
				hideWarning()
				u62 = 0
				u63 = 0
				u62 = 0
				u63 = 0

				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
				local v485 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil
				local v487

				if v485 == "A" or v485 == "B" then
					v487 = v485
				else
					local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
					local u488: boolean = false

					if typeof(lobbySpectateMatchId) == "string" then
						u488 = lobbySpectateMatchId ~= ""
					end

					if u488 then
						local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

						if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
							v487 = lobbySpectateTeam
						else
							local playerStateReplayViewSide = playerState.ReplayViewSide

							v487 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
						end
					else
						local playerStateReplayViewSide = playerState.ReplayViewSide

						v487 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
					end
				end

				if v487 == "B" then
					local v491 = u39
					local text: string = tostring(0)

					if v491 and text ~= v491.Text then
						v491.Text = text
						popScale(v491, 0.08)
					end

					local v493 = u40
					local text5: string = tostring(0)

					if v493 and text5 ~= v493.Text then
						v493.Text = text5
						popScale(v493, 0.08)
					end
				else
					local v495 = u39
					local text: string = tostring(0)

					if v495 and text ~= v495.Text then
						v495.Text = text
						popScale(v495, 0.08)
					end

					local v497 = u40
					local text6: string = tostring(0)

					if v497 and text6 ~= v497.Text then
						v497.Text = text6
						popScale(v497, 0.08)
					end
				end

				u75 = false

				local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

				if playerGui then
					for _, v in ipairs(playerGui:GetChildren()) do
						if v.Name == "KnifeCountdownUI" then
							v:Destroy()
						end
					end
				end

				u76 = nil
				rebuildTeams()
			elseif t == "RoundLoading" then
				u75 = false
				hideRoundWin()

				local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

				if playerGui then
					for _, v in ipairs(playerGui:GetChildren()) do
						if v.Name == "KnifeCountdownUI" then
							v:Destroy()
						end
					end
				end

				u76 = nil

				if p55.scoreA and p55.scoreB then
					applyScoreAB(p55.scoreA, p55.scoreB)
				end

				rebuildTeams()
			elseif t == "SkillSelect" then
				endAt = v482 + ((p55.seconds or 1) + 3)

				if connection then
					connection:Disconnect()
				end

				local u505: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

				connection = runService.RenderStepped:Connect(function()
					if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u505 then
						if connection then
							connection:Disconnect()
							connection = nil
						end

						endAt = nil

						return
					end

					if not u41 or not endAt then
						if u41 then
							u41.Text = "--:--"
						end

						return
					end

					local v543 = endAt
					local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
					local v545 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
					local v546 = math.max(0, v543 - v545)
					local floored = math.floor(v546 + 0.999)
					local stringFormat = string.format
					local floored3 = math.floor(floored / 60)

					v546 = stringFormat("%d:%02d", floored3, floored % 60)

					if u41.Text ~= v546 then
						u41.Text = v546

						if floored <= 10 then
							popScale(u41, 0.08)
						end
					end
				end)
				rebuildTeams()
			elseif t == "Countdown" then
				hideWarning()
				rebuildTeams()
			elseif t == "CountdownTick" then
				if not u75 then
					u75 = true

					local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

					if playerGui then
						for _, v in ipairs(playerGui:GetChildren()) do
							if v.Name == "KnifeCountdownUI" then
								v:Destroy()
							end
						end
					end

					u76 = nil
					task.spawn(function()
						u76 = countdownUI.play(function()
							u76 = nil
						end)
					end)
				end

				if u41 and typeof(p55.left) == "number" and p55.left <= 3 then
					popScale(u41, 0.12)
				end
			elseif t == "RoundLive" then
				local v509 = typeof(p55.roundSeconds) == "number" and p55.roundSeconds or 180

				endAt = p57 == nil and typeof(p55.serverEndTime) == "number" and p55.serverEndTime or nil or v482 + v509

				if endAt < v482 - 1 then
					endAt = v482 + v509
				end

				if connection then
					connection:Disconnect()
				end

				local u510: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

				connection = runService.RenderStepped:Connect(function()
					if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u510 then
						if connection then
							connection:Disconnect()
							connection = nil
						end

						endAt = nil

						return
					end

					if not u41 or not endAt then
						if u41 then
							u41.Text = "--:--"
						end

						return
					end

					local v550 = endAt
					local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
					local v552 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
					local v553 = math.max(0, v550 - v552)
					local floored = math.floor(v553 + 0.999)
					local stringFormat = string.format
					local floored4 = math.floor(floored / 60)

					v553 = stringFormat("%d:%02d", floored4, floored % 60)

					if u41.Text ~= v553 then
						u41.Text = v553

						if floored <= 10 then
							popScale(u41, 0.08)
						end
					end
				end)
				rebuildTeams()
			elseif t == "RoundEnded" then
				u75 = false

				if typeof(p55.scoreA) == "number" and typeof(p55.scoreB) == "number" then
					applyScoreAB(p55.scoreA, p55.scoreB)
				end

				if u39 then
					popScale(u39, 0.12)
				end

				if u40 then
					popScale(u40, 0.12)
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				endAt = nil

				local t11 = nil

				if p55.ace and p55.acePlayerName then
					t11 = { acePlayerName = p55.acePlayerName }
				end

				showRoundWin(p55.winner or "Draw", p55.scoreA or 0, p55.scoreB or 0, p55.round or 1, t11)
				task.delay(if t11 then 5.25 else 3.25, function()
					hideRoundWin()
				end)
			elseif t == "MatchPointWarning" then
				showWarning(p55.matchPointA == true, p55.matchPointB == true)
			elseif t == "MatchEnded" then
				u75 = false
				hideRoundWin()
				hideWarning()
				task.delay(0.2, function()
					if LocalPlayer:GetAttribute("InMatch") ~= true then
						local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
						local u558: boolean = false

						if typeof(lobbySpectateMatchId) == "string" then
							u558 = lobbySpectateMatchId ~= ""
						end

						if not u558 and u33 then
							u33.Visible = false
						end
					end
				end)

				if connection then
					connection:Disconnect()
					connection = nil
				end

				endAt = nil
			elseif t == "ReplaySync" then
				if u33 then
					u33.Visible = true
				end

				hideRoundWin()
				hideWarning()
				u75 = false

				local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

				if playerGui then
					for _, v in ipairs(playerGui:GetChildren()) do
						if v.Name == "KnifeCountdownUI" then
							v:Destroy()
						end
					end
				end

				u76 = nil
				u62 = p55.scoreA or 0
				u63 = p55.scoreB or 0
				applyScoreAB(u62, u63)

				if typeof(p55.endAt) == "number" then
					endAt = p55.endAt

					if connection then
						connection:Disconnect()
					end

					local u515: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

					connection = runService.RenderStepped:Connect(function()
						if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u515 then
							if connection then
								connection:Disconnect()
								connection = nil
							end

							endAt = nil

							return
						end

						if not u41 or not endAt then
							if u41 then
								u41.Text = "--:--"
							end

							return
						end

						local v559 = endAt
						local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
						local v561 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
						local v562 = math.max(0, v559 - v561)
						local floored = math.floor(v562 + 0.999)
						local stringFormat = string.format
						local floored5 = math.floor(floored / 60)

						v562 = stringFormat("%d:%02d", floored5, floored % 60)

						if u41.Text ~= v562 then
							u41.Text = v562

							if floored <= 10 then
								popScale(u41, 0.08)
							end
						end
					end)
				else
					if connection then
						connection:Disconnect()
						connection = nil
					end

					endAt = nil

					if u41 then
						local numberValue: number? = tonumber(p55.frozenLeft)
						local floored = math.floor((numberValue or 0) + 0.999)
						local v518 = u41
						local stringFormat = string.format
						local floored6 = math.floor(floored / 60)

						v518.Text = stringFormat("%d:%02d", floored6, floored % 60)
					end
				end

				rebuildTeams()
			end

			if typeof(p55.roundsToWin) == "number" then
				n1 = p55.roundsToWin

				if middleText then
					middleText.Text = ("FIRST TO %d WINS"):format(n1)
				end
			end

			return
		end
	end)
end

task.spawn(function()
	local u410 = false

	for _ = 1, 120 do
		u410 = bindUI()

		if u410 then
			break
		end

		task.wait(0.1)
	end

	if not u410 then
		warn("RoundHud: HUD.Round not found")

		return
	end

	if u33 then
		u33.Visible = inRealMatch()
	end

	if middleText then
		middleText.Text = ("FIRST TO %d WINS"):format(n1)
	end

	u410 = function()
		local visible = inRealMatch()

		if u33 then
			u33.Visible = visible
		end

		if visible then
			rebuildTeams()

			local v522

			if typeof(playerState.ReplayPlayheadSeconds) ~= "number" then
				local matchId: any = LocalPlayer:GetAttribute("MatchId")

				if typeof(matchId) == "string" then
					v522 = matchId
				else
					local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

					v522 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
				end

				if not v522 then
					v522 = nil
				end
			else
				v522 = nil
			end

			if v522 then
				local activeMatches: Instance = replicatedStorage:FindFirstChild("ActiveMatches")
				local v526: Instance = activeMatches and activeMatches:FindFirstChild(v522)

				if v526 then
					local scoreA: any = v526:GetAttribute("ScoreA")
					local scoreB: any = v526:GetAttribute("ScoreB")

					if typeof(scoreA) == "number" then
						u62 = scoreA
					end

					if typeof(scoreB) == "number" then
						u63 = scoreB
					end

					local roundEndTime: any = v526:GetAttribute("RoundEndTime")

					if typeof(roundEndTime) == "number" and roundEndTime > workspace:GetServerTimeNow() then
						endAt = roundEndTime

						if connection then
							connection:Disconnect()
						end

						local u530: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

						connection = runService.RenderStepped:Connect(function()
							if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u530 then
								if connection then
									connection:Disconnect()
									connection = nil
								end

								endAt = nil

								return
							end

							if not u41 or not endAt then
								if u41 then
									u41.Text = "--:--"
								end

								return
							end

							local v566 = endAt
							local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
							local v568 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
							local v569 = math.max(0, v566 - v568)
							local floored = math.floor(v569 + 0.999)
							local stringFormat = string.format
							local floored7 = math.floor(floored / 60)

							v569 = stringFormat("%d:%02d", floored7, floored % 60)

							if u41.Text ~= v569 then
								u41.Text = v569

								if floored <= 10 then
									popScale(u41, 0.08)
								end
							end
						end)
					end
				end
			end

			if u62 == nil then
				u62 = 0
			end

			if u63 == nil then
				u63 = 0
			end

			applyScoreAB(u62, u63)

			return
		end

		u62 = nil
		u63 = nil

		if connection then
			connection:Disconnect()
			connection = nil
		end

		endAt = nil

		for _, v in pairs(t2) do
			if v.Root and v.Root.Parent then
				v.Root:Destroy()
			end
		end

		table.clear(t2)
		u50 = nil
		u60 = nil
	end
	LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(u410)
	LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(u410)
	LocalPlayer:GetAttributeChangedSignal("MatchSide"):Connect(u410)
	LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(u410)
	LocalPlayer:GetAttributeChangedSignal("LobbySpectateTeam"):Connect(u410)

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer then
			v:GetAttributeChangedSignal("MatchId"):Connect(rebuildTeams)
			v:GetAttributeChangedSignal("InMatch"):Connect(rebuildTeams)
			v:GetAttributeChangedSignal("MatchSide"):Connect(rebuildTeams)
		end
	end

	players.PlayerAdded:Connect(function(player: Player)
		player:GetAttributeChangedSignal("MatchId"):Connect(rebuildTeams)
		player:GetAttributeChangedSignal("InMatch"):Connect(rebuildTeams)
		player:GetAttributeChangedSignal("MatchSide"):Connect(rebuildTeams)
	end)
	players.PlayerRemoving:Connect(function()
		rebuildTeams()
	end)
	v14.OnClientEvent:Connect(onState)

	local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
	local replayMatchState: Instance = bindables and bindables:FindFirstChild("ReplayMatchState")

	if replayMatchState and replayMatchState:IsA("BindableEvent") then
		replayMatchState.Event:Connect(function(p59, p60)
			local u536: boolean = true
			local s1: string = ""

			task.spawn(function()
				local matchId: any = LocalPlayer:GetAttribute("MatchId")
				local v574

				if typeof(matchId) == "string" then
					v574 = matchId
				else
					local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

					v574 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
				end

				if not u536 and (not v574 or v574 ~= s1) then
				elseif typeof(p59) == "table" then
					local t = p59.t
					local v577 = typeof(p60) == "number" and p60

					if not v577 then
						local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds

						v577 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
					end

					if t == "MatchStarted" then
						if u33 then
							u33.Visible = true
						end

						hideRoundWin()
						hideWarning()
						u62 = 0
						u63 = 0
						u62 = 0
						u63 = 0

						local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
						local v580 = if matchSide == "A" or matchSide == "B" or matchSide == "P" then matchSide else nil
						local v582

						if v580 == "A" or v580 == "B" then
							v582 = v580
						else
							local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
							local u583: boolean = false

							if typeof(lobbySpectateMatchId) == "string" then
								u583 = lobbySpectateMatchId ~= ""
							end

							if u583 then
								local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

								if lobbySpectateTeam == "A" or lobbySpectateTeam == "B" then
									v582 = lobbySpectateTeam
								else
									local playerStateReplayViewSide = playerState.ReplayViewSide

									v582 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
								end
							else
								local playerStateReplayViewSide = playerState.ReplayViewSide

								v582 = if playerStateReplayViewSide == "A" or playerStateReplayViewSide == "B" then playerStateReplayViewSide else nil
							end
						end

						if v582 == "B" then
							local v586 = u39
							local text: string = tostring(0)

							if v586 and text ~= v586.Text then
								v586.Text = text
								popScale(v586, 0.08)
							end

							local v588 = u40
							local text7: string = tostring(0)

							if v588 and text7 ~= v588.Text then
								v588.Text = text7
								popScale(v588, 0.08)
							end
						else
							local v590 = u39
							local text: string = tostring(0)

							if v590 and text ~= v590.Text then
								v590.Text = text
								popScale(v590, 0.08)
							end

							local v592 = u40
							local text8: string = tostring(0)

							if v592 and text8 ~= v592.Text then
								v592.Text = text8
								popScale(v592, 0.08)
							end
						end

						u75 = false

						local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

						if playerGui then
							for _, v in ipairs(playerGui:GetChildren()) do
								if v.Name == "KnifeCountdownUI" then
									v:Destroy()
								end
							end
						end

						u76 = nil
						rebuildTeams()
					elseif t == "RoundLoading" then
						u75 = false
						hideRoundWin()

						local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

						if playerGui then
							for _, v in ipairs(playerGui:GetChildren()) do
								if v.Name == "KnifeCountdownUI" then
									v:Destroy()
								end
							end
						end

						u76 = nil

						if p59.scoreA and p59.scoreB then
							applyScoreAB(p59.scoreA, p59.scoreB)
						end

						rebuildTeams()
					elseif t == "SkillSelect" then
						endAt = v577 + ((p59.seconds or 1) + 3)

						if connection then
							connection:Disconnect()
						end

						local u600: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

						connection = runService.RenderStepped:Connect(function()
							if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u600 then
								if connection then
									connection:Disconnect()
									connection = nil
								end

								endAt = nil

								return
							end

							if not u41 or not endAt then
								if u41 then
									u41.Text = "--:--"
								end

								return
							end

							local v617 = endAt
							local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
							local v619 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
							local v620 = math.max(0, v617 - v619)
							local floored = math.floor(v620 + 0.999)
							local stringFormat = string.format
							local floored8 = math.floor(floored / 60)

							v620 = stringFormat("%d:%02d", floored8, floored % 60)

							if u41.Text ~= v620 then
								u41.Text = v620

								if floored <= 10 then
									popScale(u41, 0.08)
								end
							end
						end)
						rebuildTeams()
					elseif t == "Countdown" then
						hideWarning()
						rebuildTeams()
					elseif t == "CountdownTick" then
						if not u75 then
							u75 = true

							local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

							if playerGui then
								for _, v in ipairs(playerGui:GetChildren()) do
									if v.Name == "KnifeCountdownUI" then
										v:Destroy()
									end
								end
							end

							u76 = nil
							task.spawn(function()
								u76 = countdownUI.play(function()
									u76 = nil
								end)
							end)
						end

						if u41 and typeof(p59.left) == "number" and p59.left <= 3 then
							popScale(u41, 0.12)
						end
					elseif t == "RoundLive" then
						local v604 = typeof(p59.roundSeconds) == "number" and p59.roundSeconds or 180

						endAt = p60 == nil and typeof(p59.serverEndTime) == "number" and p59.serverEndTime or nil or v577 + v604

						if endAt < v577 - 1 then
							endAt = v577 + v604
						end

						if connection then
							connection:Disconnect()
						end

						local u605: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

						connection = runService.RenderStepped:Connect(function()
							if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u605 then
								if connection then
									connection:Disconnect()
									connection = nil
								end

								endAt = nil

								return
							end

							if not u41 or not endAt then
								if u41 then
									u41.Text = "--:--"
								end

								return
							end

							local v624 = endAt
							local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
							local v626 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
							local v627 = math.max(0, v624 - v626)
							local floored = math.floor(v627 + 0.999)
							local stringFormat = string.format
							local floored9 = math.floor(floored / 60)

							v627 = stringFormat("%d:%02d", floored9, floored % 60)

							if u41.Text ~= v627 then
								u41.Text = v627

								if floored <= 10 then
									popScale(u41, 0.08)
								end
							end
						end)
						rebuildTeams()
					elseif t == "RoundEnded" then
						u75 = false

						if typeof(p59.scoreA) == "number" and typeof(p59.scoreB) == "number" then
							applyScoreAB(p59.scoreA, p59.scoreB)
						end

						if u39 then
							popScale(u39, 0.12)
						end

						if u40 then
							popScale(u40, 0.12)
						end

						if connection then
							connection:Disconnect()
							connection = nil
						end

						endAt = nil

						local t12 = nil

						if p59.ace and p59.acePlayerName then
							t12 = { acePlayerName = p59.acePlayerName }
						end

						showRoundWin(p59.winner or "Draw", p59.scoreA or 0, p59.scoreB or 0, p59.round or 1, t12)
						task.delay(if t12 then 5.25 else 3.25, function()
							hideRoundWin()
						end)
					elseif t == "MatchPointWarning" then
						showWarning(p59.matchPointA == true, p59.matchPointB == true)
					elseif t == "MatchEnded" then
						u75 = false
						hideRoundWin()
						hideWarning()
						task.delay(0.2, function()
							if LocalPlayer:GetAttribute("InMatch") ~= true then
								local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
								local u558: boolean = false

								if typeof(lobbySpectateMatchId) == "string" then
									u558 = lobbySpectateMatchId ~= ""
								end

								if not u558 and u33 then
									u33.Visible = false
								end
							end
						end)

						if connection then
							connection:Disconnect()
							connection = nil
						end

						endAt = nil
					elseif t == "ReplaySync" then
						if u33 then
							u33.Visible = true
						end

						hideRoundWin()
						hideWarning()
						u75 = false

						local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

						if playerGui then
							for _, v in ipairs(playerGui:GetChildren()) do
								if v.Name == "KnifeCountdownUI" then
									v:Destroy()
								end
							end
						end

						u76 = nil
						u62 = p59.scoreA or 0
						u63 = p59.scoreB or 0
						applyScoreAB(u62, u63)

						if typeof(p59.endAt) == "number" then
							endAt = p59.endAt

							if connection then
								connection:Disconnect()
							end

							local u610: boolean = typeof(playerState.ReplayPlayheadSeconds) == "number"

							connection = runService.RenderStepped:Connect(function()
								if typeof(playerState.ReplayPlayheadSeconds) == "number" ~= u610 then
									if connection then
										connection:Disconnect()
										connection = nil
									end

									endAt = nil

									return
								end

								if not u41 or not endAt then
									if u41 then
										u41.Text = "--:--"
									end

									return
								end

								local v631 = endAt
								local playerStateReplayPlayheadSeconds = playerState.ReplayPlayheadSeconds
								local v633 = if typeof(playerStateReplayPlayheadSeconds) == "number" then playerStateReplayPlayheadSeconds else workspace:GetServerTimeNow()
								local v634 = math.max(0, v631 - v633)
								local floored = math.floor(v634 + 0.999)
								local stringFormat = string.format
								local floored10 = math.floor(floored / 60)

								v634 = stringFormat("%d:%02d", floored10, floored % 60)

								if u41.Text ~= v634 then
									u41.Text = v634

									if floored <= 10 then
										popScale(u41, 0.08)
									end
								end
							end)
						else
							if connection then
								connection:Disconnect()
								connection = nil
							end

							endAt = nil

							if u41 then
								local numberValue: number? = tonumber(p59.frozenLeft)
								local floored = math.floor((numberValue or 0) + 0.999)
								local v613 = u41
								local stringFormat = string.format
								local floored11 = math.floor(floored / 60)

								v613.Text = stringFormat("%d:%02d", floored11, floored % 60)
							end
						end

						rebuildTeams()
					end

					if typeof(p59.roundsToWin) == "number" then
						n1 = p59.roundsToWin

						if middleText then
							middleText.Text = ("FIRST TO %d WINS"):format(n1)
						end
					end

					return
				end
			end)
		end)
	end

	u410()
end)
task.spawn(function()
	local activeMatches: Instance = replicatedStorage:WaitForChild("ActiveMatches", 10)

	if not activeMatches then
		return
	end

	local function watchMatchNode(p61)
		p61.ChildAdded:Connect(function(p62)
			if p62.Name == "Bots" then
				task.wait(0.2)
				rebuildTeams()
			end
		end)

		local bots = p61:FindFirstChild("Bots")

		if bots then
			task.wait(0.2)
			rebuildTeams()
			bots.ChildAdded:Connect(function()
				task.wait(0.2)
				rebuildTeams()
			end)
		end
	end

	for _, v in ipairs(activeMatches:GetChildren()) do
		if v:IsA("Folder") then
			watchMatchNode(v)
		end
	end

	activeMatches.ChildAdded:Connect(function(p63: Instance)
		if p63:IsA("Folder") then
			watchMatchNode(p63)
		end
	end)
end)
