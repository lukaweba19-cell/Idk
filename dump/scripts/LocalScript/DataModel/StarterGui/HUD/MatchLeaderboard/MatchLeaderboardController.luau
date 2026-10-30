-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local icons = require(shared:WaitForChild("Icons"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local botPlayers = require(replicatedStorageShared:WaitForChild("BotPlayers"))
local v12: Instance = replicatedStorage:WaitForChild("Shared")
local guiSpace = require(v12:WaitForChild("GuiSpace"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local scriptParent: Instance = script.Parent
local v17: boolean = scriptParent:IsA("CanvasGroup")

assert(v17, "MatchLeaderboard root must be a CanvasGroup")

local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")

if not bindables then
	local bindables2: Instance = remotes:FindFirstChild("Bindables")

	if bindables2 then
		bindables = bindables2
	end
end

assert(bindables, "Couldn't find Bindables (ReplicatedStorage.Bindables or ReplicatedStorage.Remotes.Bindables)")

local toggleMatchLeaderboard: Instance = bindables:WaitForChild("ToggleMatchLeaderboard")
local u22 = nil

task.spawn(function()
	local scoreboardMenu: Instance = script.Parent.Parent:WaitForChild("ScoreboardMenu", 20)

	if not scoreboardMenu then
		return
	end

	local scoreboardMenuController: Instance = scoreboardMenu:WaitForChild("ScoreboardMenuController", 20)

	if not scoreboardMenuController then
		return
	end

	u22 = scoreboardMenuController:WaitForChild("OpenScoreboardMenu", 20)
end)

local playerContainer: Instance = scriptParent:WaitForChild("PlayerContainer")
local userFrame: Instance = playerContainer:WaitForChild("UserFrame")
local mapInfo: Instance = scriptParent:WaitForChild("MapInfo")
local identifier: Instance = mapInfo:WaitForChild("Identifier")
local spectators: Instance = mapInfo:WaitForChild("Spectators")
local amount: Instance = spectators:WaitForChild("Frame"):WaitForChild("Amount")

spectators.Visible = false

local blackBackground3: Instance = scriptParent.Parent:WaitForChild("BlackBackground3")

userFrame.Visible = false
playerContainer.Selectable = false
playerContainer.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
playerContainer.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
playerContainer.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
playerContainer.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

local t1: {[any]: any} = {}
local u31: boolean = false
local n1: number = 0
local n2: number = 0
local u34: boolean = false

local function getRealMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" then
		return matchId
	end

	return nil
end
local function getLobbySpectateMatchId()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		return lobbySpectateMatchId
	end

	return nil
end
local function isLobbySpectating()
	local u96: boolean = false
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if (if typeof(matchId) == "string" and matchId ~= "" then matchId else nil) == nil then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		u96 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) ~= nil
	end

	return u96
end
local function getSpectateTargetMatchId()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		local player: Player = players:GetPlayerByUserId(spectating)

		if not player then
			return nil
		end

		local matchId: any = player:GetAttribute("MatchId")

		if typeof(matchId) == "string" and matchId ~= "" then
			return matchId
		end

		return nil
	end

	return nil
end
local function getEffectiveMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v103 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v103 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v103 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	return v103
end
local function countLobbySpectators(p1)
	if not p1 then
		return 0
	end

	local n1: number = 0

	for _, v in ipairs(players:GetPlayers()) do
		local lobbySpectateMatchId = v:GetAttribute("LobbySpectateMatchId")

		if p1 == lobbySpectateMatchId then
			n1 += 1
		end
	end

	return n1
end
local function updateSpectatorCount(p2)
	if p2 and p2 ~= "PRACTICE" then
		if not botPlayers.IsLiveMatch(p2) then
			spectators.Visible = false

			return
		end

		local v111 = countLobbySpectators(p2)

		if v111 > 0 then
			amount.Text = tostring(v111)
			spectators.Visible = true

			return
		end

		spectators.Visible = false

		return
	end

	spectators.Visible = false
end
local function avatarThumb(p3, p4)
	local v114 = p4 or 420

	if p3 < 0 then
		return "rbxassetid://127075876244307"
	end

	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d"):format(p3, v114, v114)
end
local function sameMatch(p5, p6)
	return p5 ~= nil and p6 ~= nil and p5 == p6
end
local function safeFind(p7, p8)
	local v119 = p7

	for _, v in ipairs(p8) do
		if not v119 then
			return nil
		end

		v119 = v119:FindFirstChild(v)
	end

	return v119
end
local function clamp01(p9)
	if p9 < 0 then
		return 0
	end

	if p9 > 1 then
		return 1
	end

	return p9
end
local function darken(p10, p11)
	local v125 = p11
	local n1 = if v125 < 0 then 0 else if v125 > 1 then 1 else v125

	return Color3.new(p10.R * n1, p10.G * n1, p10.B * n1)
end
local function baseRowColorForPlayer(player)
	if player == LocalPlayer then
		return Color3.fromRGB(255, 255, 255)
	end

	local u128: boolean = false
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if (if typeof(matchId) == "string" and matchId ~= "" then matchId else nil) == nil then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		u128 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) ~= nil
	end

	if u128 then
		local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")
		local matchSide = player:GetAttribute("MatchSide")

		if typeof(lobbySpectateTeam) == "string" and typeof(matchSide) == "string" and lobbySpectateTeam ~= "" and matchSide ~= "" then
			if matchSide == lobbySpectateTeam then
				return Color3.fromRGB(80, 220, 120)
			end

			return Color3.fromRGB(235, 90, 90)
		end
	end

	if player:GetAttribute("MatchId") == "PRACTICE" then
		return Color3.fromRGB(80, 220, 120)
	end

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
	local matchSide2 = player:GetAttribute("MatchSide")

	if typeof(matchSide) == "string" and typeof(matchSide2) == "string" and matchSide == matchSide2 then
		return Color3.fromRGB(80, 220, 120)
	end

	if typeof(matchSide) == "string" and typeof(matchSide2) == "string" then
		return Color3.fromRGB(235, 90, 90)
	end

	if player.Team == nil or LocalPlayer.Team == nil or player.Team ~= LocalPlayer.Team then
		return Color3.fromRGB(235, 90, 90)
	end

	return Color3.fromRGB(80, 220, 120)
end
local function setRowBaseColor(p13, p14)
	p13.lastBaseColor = p14

	if p13.disconnected then
		local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

		p13.frame.BackgroundColor3 = Color3.new(p14.R * n1, p14.G * n1, p14.B * n1)

		return
	end

	p13.frame.BackgroundColor3 = p14
end
local function setPingVisual(p15, p16)
	if p16 == nil then
		if p15.pingFrame then
			p15.pingFrame.Visible = true
		end

		if p15.pingImage then
			p15.pingImage.Visible = false
		end

		if p15.statsPing then
			p15.statsPing.Visible = true
			p15.statsPing.Text = "--"
		end

		return
	end

	if p15.pingFrame then
		p15.pingFrame.Visible = true
	end

	if p15.pingImage then
		p15.pingImage.Visible = true
	end

	if p15.statsPing then
		p15.statsPing.Visible = true
		p15.statsPing.Text = string.format("%d ms", p16)
	end

	if p15.pingGrad1Bar and p15.pingGrad2Bars then
		if p16 >= 180 then
			p15.pingGrad1Bar.Enabled = true
			p15.pingGrad2Bars.Enabled = false

			return
		end

		if p16 >= 100 then
			p15.pingGrad1Bar.Enabled = false
			p15.pingGrad2Bars.Enabled = true

			return
		end

		p15.pingGrad1Bar.Enabled = false
		p15.pingGrad2Bars.Enabled = false

		return
	end
end
local function fmtInt(p17)
	if typeof(p17) == "number" then
		return (math.floor(p17 + 0.5))
	end

	return 0
end
local function fmtDevice(p18)
	if typeof(p18) == "string" then
		return p18
	end

	if p18 == nil then
		return "?"
	end

	return (tostring(p18))
end
local function optInt(p19)
	if typeof(p19) == "number" then
		return (math.floor(p19 + 0.5))
	end

	return nil
end
local function optDevice(p20)
	if p20 == nil then
		return nil
	end

	if typeof(p20) == "string" then
		return p20
	end

	if p20 == nil then
		return "?"
	end

	return (tostring(p20))
end
local function menuIsOpen()
	return LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true
end
local function boardIsFocused()
	return LocalPlayer:GetAttribute("ScoreboardFocused") == true
end
local function removeRow(p21)
	local v145 = t1[p21]

	if not v145 then
		return
	end

	if v145.frame and v145.frame.Parent then
		v145.frame:Destroy()
	end

	t1[p21] = nil
end
local function updateRowTexts(p22)
	if p22.statsKD then
		p22.statsKD.Text = string.format("%d / %d / %d", p22.lastKills, p22.lastDeaths, p22.lastAssists)
	end

	if not p22.statsDevice or p22.disconnected then
		return
	end

	if p22.lastDevice == nil then
		p22.statsDevice.Visible = false

		return
	end

	local v147 = p22.lastDevice or "PC"

	p22.statsDevice.Visible = true
	p22.statsDevice.Image = icons.Device[v147] or icons.Device.PC or ""
end
local function renderIdentifier(p23)
	local infoIdentifier = p23.infoIdentifier

	if not infoIdentifier then
		return
	end

	local s1 = "Unknown"
	local s2 = ""

	if p23.player then
		s1 = p23.player.DisplayName
		s2 = p23.player.Name
	else
		if p23.cachedDisplayName and p23.cachedDisplayName ~= "" then
			s1 = p23.cachedDisplayName
		end

		if p23.cachedName and p23.cachedName ~= "" then
			s2 = p23.cachedName
		end
	end

	local v152 = s1

	if p23.hovered and s2 ~= "" then
		v152 = "@" .. s2
	end

	infoIdentifier.Text = if p23.disconnected then v152 .. " (Disconnected)" else v152
end
local function setDisconnected(p24, p25)
	p24.disconnected = p25
	renderIdentifier(p24)

	if p24.statsDevice then
		if p25 then
			p24.statsDevice.Visible = true
			p24.statsDevice.Image = icons.Device.Disconnected or icons.Device.disconnected or ""
		elseif p24.player then
			local device = p24.player:GetAttribute("Device")
			local text

			if device == nil then
				text = nil
			elseif typeof(device) == "string" then
				text = device
			elseif device == nil then
				text = "?"
			else
				text = tostring(device)
			end

			p24.lastDevice = text
			updateRowTexts(p24)
		end
	end

	local lastBaseColor = p24.lastBaseColor

	p24.lastBaseColor = lastBaseColor

	if p24.disconnected then
		local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

		p24.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n1, lastBaseColor.G * n1, lastBaseColor.B * n1)

		return
	end

	p24.frame.BackgroundColor3 = lastBaseColor
end
local function sortAndLayout()
	if not u34 then
		return
	end

	u34 = false

	local t2: {[any]: any} = {}

	for _, v in pairs(t1) do
		if v.inSameMatch then
			table.insert(t2, v)
		end
	end

	table.sort(t2, function(p26, p27)
		if p26.lastKills ~= p27.lastKills then
			return p26.lastKills > p27.lastKills
		end

		if p26.lastAssists ~= p27.lastAssists then
			return p26.lastAssists > p27.lastAssists
		end

		if p26.lastDeaths ~= p27.lastDeaths then
			return p26.lastDeaths < p27.lastDeaths
		end

		local v345 = p26.player and p26.player.DisplayName or tostring(p26.userId)
		local v346 = p27.player and p27.player.DisplayName or tostring(p27.userId)

		return v345 < v346
	end)

	for i, v in ipairs(t2) do
		v.frame.LayoutOrder = i
	end
end
local function createRowForPlayer(player)
	local clone: Instance = userFrame:Clone()

	clone.Name = ("UserFrame_%d"):format(player.UserId)
	clone.Visible = true
	clone.Selectable = true
	clone.Parent = playerContainer

	local v166 = safeFind(clone, { "Info", "Identifier" })
	local v167 = safeFind(clone, { "Info", "Avatar" })
	local v168 = safeFind(clone, { "Stats", "KD" })
	local v169 = safeFind(clone, { "Stats", "Device" })
	local v170 = safeFind(clone, { "Stats", "Ping" })
	local kd = v170 and v170:FindFirstChild("KD")
	local imageLabel = v170 and v170:FindFirstChild("ImageLabel")
	local uiGradient1Bar = nil
	local uiGradient2Bars = nil

	if imageLabel then
		uiGradient1Bar = imageLabel:FindFirstChild("UIGradient1Bar")
		uiGradient2Bars = imageLabel:FindFirstChild("UIGradient2Bars")
	end

	if v167 then
		local userId = player.UserId
		local v176 = nil or 420
		local s1

		if userId < 0 then
			s1 = "rbxassetid://127075876244307"
		else
			s1 = ("rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d"):format(userId, v176, v176)
		end

		v167.Image = s1
	end

	local playerUserId = player.UserId
	local color3 = Color3.fromRGB(255, 255, 255)
	local t3: {[any]: any} = {
		lastPingMs = nil,
		lastDevice = nil,
		lastKills = 0,
		lastDeaths = 0,
		lastAssists = 0,
		inSameMatch = false,
		disconnected = false,
		hovered = false,
		player = player,
		userId = playerUserId,
		frame = clone,
		infoIdentifier = v166,
		statsKD = v168,
		statsDevice = v169,
		statsPing = kd,
		pingFrame = v170,
		pingImage = imageLabel,
		pingGrad1Bar = uiGradient1Bar,
		pingGrad2Bars = uiGradient2Bars,
		lastBaseColor = color3,
		cachedDisplayName = player.DisplayName,
		cachedName = player.Name
	}
	local matchId = player:GetAttribute("MatchId")

	t3.cachedMatchId = typeof(matchId) == "string" and matchId ~= "" and matchId or nil

	local device = player:GetAttribute("Device")

	t3.lastDevice = if device == nil then nil else if typeof(device) == "string" then device else if device == nil then "?" else tostring(device)

	local ping = player:GetAttribute("Ping")

	t3.lastPingMs = if typeof(ping) == "number" then math.floor(ping + 0.5) else nil

	local matchKills = player:GetAttribute("MatchKills")

	t3.lastKills = if typeof(matchKills) == "number" then math.floor(matchKills + 0.5) else 0

	local matchDeaths = player:GetAttribute("MatchDeaths")

	t3.lastDeaths = if typeof(matchDeaths) == "number" then math.floor(matchDeaths + 0.5) else 0

	local matchAssists = player:GetAttribute("MatchAssists")

	t3.lastAssists = if typeof(matchAssists) == "number" then math.floor(matchAssists + 0.5) else 0
	renderIdentifier(t3)
	updateRowTexts(t3)
	setPingVisual(t3, t3.lastPingMs)

	local v187 = baseRowColorForPlayer(player)

	t3.lastBaseColor = v187

	if t3.disconnected then
		local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

		t3.frame.BackgroundColor3 = Color3.new(v187.R * n1, v187.G * n1, v187.B * n1)
	else
		t3.frame.BackgroundColor3 = v187
	end

	clone.Activated:Connect(function(input)
		if not u22 then
			return
		end

		local vector2 = nil

		if typeof(input) == "Instance" and input:IsA("InputObject") and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			vector2 = Vector2.new(input.Position.X, input.Position.Y)
		end

		u22:Fire({
			RowFrame = clone,
			ClickPosition = vector2,
			UserId = player.UserId,
			DisplayName = t3.cachedDisplayName ~= "" and t3.cachedDisplayName or player.DisplayName,
			Username = t3.cachedName ~= "" and t3.cachedName or player.Name,
			IsBot = if player.UserId < 0 then true else false
		})
	end)

	return t3
end
local function recomputeRowMembership(p30)
	if p30.player then
		p30.cachedDisplayName = p30.player.DisplayName
		p30.cachedName = p30.player.Name

		local matchId = p30.player:GetAttribute("MatchId")

		p30.cachedMatchId = typeof(matchId) == "string" and matchId ~= "" and matchId or nil

		local matchId2: any = LocalPlayer:GetAttribute("MatchId")
		local v192 = if typeof(matchId2) == "string" and matchId2 ~= "" then matchId2 else nil

		if not v192 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v192 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
		end

		local u194: boolean = v192 ~= nil and matchId ~= nil and v192 == matchId

		p30.inSameMatch = u194
		p30.frame.Visible = u194

		if u194 then
			local v195 = baseRowColorForPlayer(p30.player)

			p30.lastBaseColor = v195

			if p30.disconnected then
				local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

				p30.frame.BackgroundColor3 = Color3.new(v195.R * n1, v195.G * n1, v195.B * n1)
			else
				p30.frame.BackgroundColor3 = v195
			end

			u34 = true
		end

		return
	end

	if p30.disconnected then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v198 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

		if not v198 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v198 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
		end

		local cachedMatchId = p30.cachedMatchId
		local u201: boolean = v198 ~= nil and cachedMatchId ~= nil and v198 == cachedMatchId

		p30.inSameMatch = u201
		p30.frame.Visible = u201

		return
	end

	p30.inSameMatch = false
	p30.frame.Visible = false
end
local function ensureRow(player)
	local v203 = t1[player.UserId]

	if v203 then
		v203.player = player

		return v203
	end

	v203 = createRowForPlayer(player)
	t1[player.UserId] = v203
	recomputeRowMembership(v203)

	return v203
end
local function onPlayerAttrsChanged(p32, p33, p34)
	if p34 == "MatchId" then
		recomputeRowMembership(p33)

		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v208 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

		if not v208 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v208 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
		end

		scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v208 ~= nil
	elseif p34 ~= "MatchSide" then
		if p34 == "MatchKills" then
			local matchKills = p32:GetAttribute("MatchKills")
			local floored

			if typeof(matchKills) == "number" then
				floored = math.floor(matchKills + 0.5)
			else
				floored = 0
			end

			p33.lastKills = floored
			updateRowTexts(p33)
			u34 = true
		elseif p34 == "MatchAssists" then
			local matchAssists = p32:GetAttribute("MatchAssists")
			local floored

			if typeof(matchAssists) == "number" then
				floored = math.floor(matchAssists + 0.5)
			else
				floored = 0
			end

			p33.lastAssists = floored
			updateRowTexts(p33)
			u34 = true
		elseif p34 == "MatchDeaths" then
			local matchDeaths = p32:GetAttribute("MatchDeaths")
			local floored

			if typeof(matchDeaths) == "number" then
				floored = math.floor(matchDeaths + 0.5)
			else
				floored = 0
			end

			p33.lastDeaths = floored
			updateRowTexts(p33)
			u34 = true
		elseif p34 == "Device" then
			local device = p32:GetAttribute("Device")
			local text

			if device == nil then
				text = nil
			elseif typeof(device) == "string" then
				text = device
			elseif device == nil then
				text = "?"
			else
				text = tostring(device)
			end

			p33.lastDevice = text
			updateRowTexts(p33)
		elseif p34 == "Ping" then
			local ping = p32:GetAttribute("Ping")
			local floored

			if typeof(ping) == "number" then
				floored = math.floor(ping + 0.5)
			else
				floored = nil
			end

			p33.lastPingMs = floored
		end
	elseif p33.inSameMatch and p33.player then
		local v220 = baseRowColorForPlayer(p33.player)

		p33.lastBaseColor = v220

		if p33.disconnected then
			local n4: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

			p33.frame.BackgroundColor3 = Color3.new(v220.R * n4, v220.G * n4, v220.B * n4)

			return
		end

		p33.frame.BackgroundColor3 = v220

		return
	end
end

local object = setmetatable({}, { __mode = "k" })

local function wireSignals(p35)
	if object[p35] then
		return
	end

	object[p35] = true
	p35.AttributeChanged:Connect(function(p36)
		local v350 = t1[p35.UserId]

		if v350 and v350.player == p35 then
			onPlayerAttrsChanged(p35, v350, p36)

			return
		end
	end)
	p35:GetPropertyChangedSignal("Team"):Connect(function()
		local v351 = t1[p35.UserId]

		if not v351 or v351.player ~= p35 then
		elseif v351.inSameMatch then
			local v352 = baseRowColorForPlayer(p35)

			v351.lastBaseColor = v352

			if v351.disconnected then
				local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

				v351.frame.BackgroundColor3 = Color3.new(v352.R * n1, v352.G * n1, v352.B * n1)

				return
			end

			v351.frame.BackgroundColor3 = v352

			return
		end
	end)
end
local function bindRow(p37, p38)
	p37.player = p38
	p37.cachedDisplayName = p38.DisplayName
	p37.cachedName = p38.Name

	local matchId = p38:GetAttribute("MatchId")

	p37.cachedMatchId = typeof(matchId) == "string" and matchId ~= "" and matchId or nil

	local matchKills = p38:GetAttribute("MatchKills")

	p37.lastKills = if typeof(matchKills) == "number" then math.floor(matchKills + 0.5) else 0

	local matchDeaths = p38:GetAttribute("MatchDeaths")

	p37.lastDeaths = if typeof(matchDeaths) == "number" then math.floor(matchDeaths + 0.5) else 0

	local matchAssists = p38:GetAttribute("MatchAssists")

	p37.lastAssists = if typeof(matchAssists) == "number" then math.floor(matchAssists + 0.5) else 0

	local device = p38:GetAttribute("Device")

	p37.lastDevice = if device == nil then nil else if typeof(device) == "string" then device else if device == nil then "?" else tostring(device)

	local ping = p38:GetAttribute("Ping")

	p37.lastPingMs = if typeof(ping) == "number" then math.floor(ping + 0.5) else nil
	wireSignals(p38)
	p37.disconnected = false
	renderIdentifier(p37)

	if p37.statsDevice and p37.player then
		local device2 = p37.player:GetAttribute("Device")
		local text

		if device2 == nil then
			text = nil
		elseif typeof(device2) == "string" then
			text = device2
		elseif device2 == nil then
			text = "?"
		else
			text = tostring(device2)
		end

		p37.lastDevice = text
		updateRowTexts(p37)
	end

	local lastBaseColor = p37.lastBaseColor

	p37.lastBaseColor = lastBaseColor

	if p37.disconnected then
		local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

		p37.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n1, lastBaseColor.G * n1, lastBaseColor.B * n1)
	else
		p37.frame.BackgroundColor3 = lastBaseColor
	end

	updateRowTexts(p37)
	setPingVisual(p37, p37.lastPingMs)
	u34 = true
end
local function wirePlayer(player)
	local v236 = t1[player.UserId]

	if v236 then
		v236.player = player
	else
		v236 = createRowForPlayer(player)
		t1[player.UserId] = v236
		recomputeRowMembership(v236)
	end

	if v236.player ~= nil then
		v236.cachedDisplayName = player.DisplayName
		v236.cachedName = player.Name
		v236.disconnected = false
		renderIdentifier(v236)

		if v236.statsDevice and v236.player then
			local device = v236.player:GetAttribute("Device")
			local text

			if device == nil then
				text = nil
			elseif typeof(device) == "string" then
				text = device
			elseif device == nil then
				text = "?"
			else
				text = tostring(device)
			end

			v236.lastDevice = text
			updateRowTexts(v236)
		end

		local lastBaseColor = v236.lastBaseColor

		v236.lastBaseColor = lastBaseColor

		if v236.disconnected then
			local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

			v236.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n1, lastBaseColor.G * n1, lastBaseColor.B * n1)
		else
			v236.frame.BackgroundColor3 = lastBaseColor
		end
	end

	wireSignals(player)
end

toggleMatchLeaderboard.Event:Connect(function(p40)
	u31 = p40 == true

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v243 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v243 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v243 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v243 ~= nil
end)
LocalPlayer:GetAttributeChangedSignal("ScoreboardMenuOpen"):Connect(function()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v246 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v246 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v246 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v246 ~= nil
end)

local u69: boolean = false
local connection = nil

local function topSelectableRow()
	local v248 = nil
	local n1 = math.huge

	for _, v in pairs(t1) do
		local vFrame = v.frame

		if v.inSameMatch and vFrame.Visible and vFrame.Parent ~= nil and n1 > vFrame.LayoutOrder then
			n1 = vFrame.LayoutOrder
			v248 = vFrame
		end
	end

	return v248
end
local function unfocusBoard()
	if LocalPlayer:GetAttribute("ScoreboardFocused") ~= true then
		return
	end

	LocalPlayer:SetAttribute("ScoreboardFocused", nil)

	if connection then
		connection:Disconnect()
		connection = nil
	end

	contextActionService:UnbindAction("MatchLeaderboard_FocusCloseB")

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(playerContainer) then
		guiService.SelectedObject = nil
	end

	if u69 then
		u69 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local v255 = math.max((mouseUnlocked or 0) - 1, 0)

		LocalPlayer:SetAttribute("MouseUnlocked", v255)
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v257 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v257 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v257 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v257 ~= nil
end
local function focusBoard()
	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v260 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v260 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v260 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	if v260 == nil then
		return
	end

	sortAndLayout()
	v260 = topSelectableRow()

	if not v260 then
		return
	end

	LocalPlayer:SetAttribute("ScoreboardFocused", true)

	if not u69 then
		u69 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	end

	local matchId3: any = LocalPlayer:GetAttribute("MatchId")
	local v264 = if typeof(matchId3) == "string" and matchId3 ~= "" then matchId3 else nil

	if not v264 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v264 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v264 ~= nil
	guiService.SelectedObject = v260
	contextActionService:BindActionAtPriority("MatchLeaderboard_FocusCloseB", function(_, p42, input)
		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return Enum.ContextActionResult.Pass
		end

		if LocalPlayer:GetAttribute("ScoreboardFocused") ~= true then
			return Enum.ContextActionResult.Pass
		end

		if p42 == Enum.UserInputState.Begin then
			unfocusBoard()
		end

		return Enum.ContextActionResult.Sink
	end, false, 4500, Enum.KeyCode.ButtonB)
	connection = guiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
		if guiService.SelectedObject == nil then
			task.defer(function()
				if LocalPlayer:GetAttribute("ScoreboardFocused") ~= true then
				elseif guiService.SelectedObject == nil then
					guiService.SelectedObject = topSelectableRow()

					return
				end
			end)

			return
		end
	end)
end

contextActionService:BindActionAtPriority("MatchLeaderboard_Focus", function(_, p45, input)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
		return Enum.ContextActionResult.Pass
	end

	if p45 ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end

	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		unfocusBoard()

		return Enum.ContextActionResult.Sink
	end

	focusBoard()

	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end, false, 3000, gamepadBindings.ScoreboardFocus)
LocalPlayer.CharacterAdded:Connect(unfocusBoard)
LocalPlayer.CharacterRemoving:Connect(unfocusBoard)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(unfocusBoard)

local function getMatchNode(p47)
	return botPlayers.GetMatchNode(p47)
end
local function updateMapInfo()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v271 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v271 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v271 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	if not v271 then
		identifier.Text = ""
		spectators.Visible = false

		return
	end

	if v271 == "PRACTICE" then
		identifier.Text = "Practice"
		spectators.Visible = false

		return
	end

	if not v271 or v271 == "PRACTICE" or not botPlayers.IsLiveMatch(v271) then
		spectators.Visible = false
	else
		local v273 = countLobbySpectators(v271)

		if v273 > 0 then
			amount.Text = tostring(v273)
			spectators.Visible = true
		else
			spectators.Visible = false
		end
	end

	local v274 = botPlayers.GetMatchNode(v271)

	v271 = 1

	local s1 = ""

	if v274 then
		local teamSize = v274:GetAttribute("TeamSize")

		if typeof(teamSize) == "number" and teamSize > 0 then
			v271 = teamSize
		end

		local mapName = v274:GetAttribute("MapName")

		if typeof(mapName) == "string" and mapName ~= "" then
			s1 = mapName
		end
	end

	v274 = v271 .. "v" .. v271

	if s1 == "" then
		identifier.Text = v274

		return
	end

	identifier.Text = v274 .. " - " .. s1
end
local function refreshEffectiveContext()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v279 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v279 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v279 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	local t4 = {}

	for k, v in pairs(t1) do
		if v.disconnected and v.player == nil then
			local vCachedMatchId = v.cachedMatchId

			if v279 == nil or vCachedMatchId == nil or v279 ~= vCachedMatchId then
				table.insert(t4, k)
			else
				recomputeRowMembership(v)
			end
		else
			if v.player ~= nil and botPlayers.IsBotProxy(v.player) then
				local matchId4 = v.player:GetAttribute("MatchId")

				if v279 == nil or matchId4 == nil or v279 ~= matchId4 then
					local player: Player = players:GetPlayerByUserId(k)

					if not player then
						table.insert(t4, k)

						continue
					end

					bindRow(v, player)
				end
			end

			recomputeRowMembership(v)

			if v.inSameMatch and v.player then
				local v287 = baseRowColorForPlayer(v.player)

				v.lastBaseColor = v287

				if v.disconnected then
					local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

					v.frame.BackgroundColor3 = Color3.new(v287.R * n1, v287.G * n1, v287.B * n1)
				else
					v.frame.BackgroundColor3 = v287
				end
			end
		end
	end

	for _, v in ipairs(t4) do
		local v291 = t1[v]

		if v291 then
			if v291.frame and v291.frame.Parent then
				v291.frame:Destroy()
			end

			t1[v] = nil
		end
	end

	updateMapInfo()

	local matchId5: any = LocalPlayer:GetAttribute("MatchId")

	t4 = if typeof(matchId5) == "string" and matchId5 ~= "" then matchId5 else nil

	if not t4 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		t4 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	if t4 then
		for _, v in ipairs(botPlayers.GetBotProxies(t4)) do
			local v296 = t1[v.UserId]

			if not v296 then
				local v297 = t1[v.UserId]

				if v297 then
					v297.player = v
				else
					v297 = createRowForPlayer(v)
					t1[v.UserId] = v297
					recomputeRowMembership(v297)
				end

				if v297.player ~= nil then
					v297.cachedDisplayName = v.DisplayName
					v297.cachedName = v.Name
					v297.disconnected = false
					renderIdentifier(v297)

					if v297.statsDevice and v297.player then
						local device = v297.player:GetAttribute("Device")
						local text

						if device == nil then
							text = nil
						elseif typeof(device) == "string" then
							text = device
						elseif device == nil then
							text = "?"
						else
							text = tostring(device)
						end

						v297.lastDevice = text
						updateRowTexts(v297)
					end

					local lastBaseColor = v297.lastBaseColor

					v297.lastBaseColor = lastBaseColor

					if v297.disconnected then
						local n2: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

						v297.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n2, lastBaseColor.G * n2, lastBaseColor.B * n2)
					else
						v297.frame.BackgroundColor3 = lastBaseColor
					end
				end

				wireSignals(v)
			elseif v ~= v296.player then
				bindRow(v296, v)
			end

			v296 = t1[v.UserId]

			if v296 then
				recomputeRowMembership(v296)
			end
		end
	end

	local matchId6: any = LocalPlayer:GetAttribute("MatchId")

	t4 = if typeof(matchId6) == "string" and matchId6 ~= "" then matchId6 else nil

	if not t4 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		t4 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and t4 ~= nil
	u34 = true
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v305 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

	if not v305 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v305 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
	end

	if v305 == nil then
		unfocusBoard()
		scriptParent.Visible = false
	end

	refreshEffectiveContext()
end)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(refreshEffectiveContext)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateTeam"):Connect(refreshEffectiveContext)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshEffectiveContext)

for _, v in ipairs(players:GetPlayers()) do
	local v79 = t1[v.UserId]

	if v79 then
		v79.player = v
	else
		v79 = createRowForPlayer(v)
		t1[v.UserId] = v79
		recomputeRowMembership(v79)
	end

	if v79.player ~= nil then
		v79.cachedDisplayName = v.DisplayName
		v79.cachedName = v.Name
		v79.disconnected = false
		renderIdentifier(v79)

		if v79.statsDevice and v79.player then
			local device = v79.player:GetAttribute("Device")
			local text

			if device == nil then
				text = nil
			elseif typeof(device) == "string" then
				text = device
			elseif device == nil then
				text = "?"
			else
				text = tostring(device)
			end

			v79.lastDevice = text
			updateRowTexts(v79)
		end

		local lastBaseColor = v79.lastBaseColor

		v79.lastBaseColor = lastBaseColor

		if v79.disconnected then
			local n3: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

			v79.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n3, lastBaseColor.G * n3, lastBaseColor.B * n3)
		else
			v79.frame.BackgroundColor3 = lastBaseColor
		end
	end

	wireSignals(v)
end

players.PlayerAdded:Connect(function(player: Player)
	local v308 = t1[player.UserId]

	if v308 then
		v308.player = player
	else
		v308 = createRowForPlayer(player)
		t1[player.UserId] = v308
		recomputeRowMembership(v308)
	end

	if v308.player ~= nil then
		v308.cachedDisplayName = player.DisplayName
		v308.cachedName = player.Name
		v308.disconnected = false
		renderIdentifier(v308)

		if v308.statsDevice and v308.player then
			local device = v308.player:GetAttribute("Device")
			local text

			if device == nil then
				text = nil
			elseif typeof(device) == "string" then
				text = device
			elseif device == nil then
				text = "?"
			else
				text = tostring(device)
			end

			v308.lastDevice = text
			updateRowTexts(v308)
		end

		local lastBaseColor = v308.lastBaseColor

		v308.lastBaseColor = lastBaseColor

		if v308.disconnected then
			local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

			v308.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n1, lastBaseColor.G * n1, lastBaseColor.B * n1)
		else
			v308.frame.BackgroundColor3 = lastBaseColor
		end
	end

	wireSignals(player)
end)
players.PlayerRemoving:Connect(function(player: Player)
	local v314 = t1[player.UserId]

	if not v314 then
		return
	end

	if v314.inSameMatch then
		v314.cachedDisplayName = player.DisplayName
		v314.cachedName = player.Name

		local matchId: any = player:GetAttribute("MatchId")

		if typeof(matchId) == "string" and matchId ~= "" then
			v314.cachedMatchId = matchId
		end

		v314.player = nil
		v314.disconnected = true
		renderIdentifier(v314)

		if v314.statsDevice then
			v314.statsDevice.Visible = true
			v314.statsDevice.Image = icons.Device.Disconnected or icons.Device.disconnected or ""
		end

		local lastBaseColor = v314.lastBaseColor

		v314.lastBaseColor = lastBaseColor

		if v314.disconnected then
			local n1: number = if 0.35 < 0 then 0 else if 0.35 > 1 then 1 else 0.35

			v314.frame.BackgroundColor3 = Color3.new(lastBaseColor.R * n1, lastBaseColor.G * n1, lastBaseColor.B * n1)
		else
			v314.frame.BackgroundColor3 = lastBaseColor
		end

		v314.frame.Visible = true
		u34 = true

		return
	end

	local userId = player.UserId
	local v319 = t1[userId]

	if not v319 then
		return
	end

	if v319.frame and v319.frame.Parent then
		v319.frame:Destroy()
	end

	t1[userId] = nil
end)

local function tickPingUpdate()
	for _, v in pairs(t1) do
		if v.inSameMatch then
			setPingVisual(v, v.lastPingMs)
		end
	end
end

local u85 = nil

local function setHovered(p50)
	if p50 == u85 then
		return
	end

	local v323 = if u85 then t1[u85] else nil

	u85 = p50

	if v323 then
		v323.hovered = false
		renderIdentifier(v323)
	end

	v323 = if p50 then t1[p50] else nil

	if v323 then
		v323.hovered = true
		renderIdentifier(v323)
	end
end
local function cursorInList()
	local v324 = guiSpace.mouseLocation()

	if v324 == nil then
		return nil
	end

	if not guiSpace.contains(playerContainer, v324) then
		return nil
	end

	return v324
end
local function tickHover()
	local v325: boolean = false

	if userInputService.MouseEnabled then
		local v326 = guiSpace.mouseLocation()
		local v327 = if v326 == nil then nil else if not guiSpace.contains(playerContainer, v326) then nil else v326
		local v328: boolean = false

		if v327 then
			for k, v in pairs(t1) do
				if v.inSameMatch and v.frame.Visible and guiSpace.contains(v.frame, v327) then
					if k == u85 then
						return
					end

					local v331 = if u85 then t1[u85] else nil

					u85 = k

					if v331 then
						v331.hovered = false
						renderIdentifier(v331)
					end

					v331 = if k then t1[k] else nil

					if v331 then
						v331.hovered = true
						renderIdentifier(v331)
					end

					return
				end
			end

			v328 = true
		end

		v325 = true
	end

	if u85 == nil then
		return
	end

	local v332 = if u85 then t1[u85] else nil

	u85 = nil

	if v332 then
		v332.hovered = false
		renderIdentifier(v332)
	end
end

scriptParent.Visible = false

local matchId: any = LocalPlayer:GetAttribute("MatchId")
local v90 = if typeof(matchId) == "string" and matchId ~= "" then matchId else nil

if not v90 then
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	v90 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
end

scriptParent.Visible = (not not u31 or LocalPlayer:GetAttribute("ScoreboardMenuOpen") == true or LocalPlayer:GetAttribute("ScoreboardFocused") == true) and v90 ~= nil
scriptParent:GetPropertyChangedSignal("Visible"):Connect(function()
	if scriptParent.Visible then
		tickPingUpdate()
	end

	if not scriptParent.Visible then
		if u85 ~= nil then
			local v333 = if u85 then t1[u85] else nil

			u85 = nil

			if v333 then
				v333.hovered = false
				renderIdentifier(v333)
			end
		end

		unfocusBoard()
	end

	blackBackground3.Visible = scriptParent.Visible
end)
runService.Heartbeat:Connect(function(deltaTime: number)
	if not scriptParent.Visible then
		return
	end

	sortAndLayout()
	tickHover()
	n1 += deltaTime

	if n1 >= 2 then
		n1 = 0
		tickPingUpdate()
	end

	n2 += deltaTime

	if n2 >= 1 then
		n2 = 0

		local matchId7: any = LocalPlayer:GetAttribute("MatchId")
		local v336 = if typeof(matchId7) == "string" and matchId7 ~= "" then matchId7 else nil

		if not v336 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v336 = (if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil) or getSpectateTargetMatchId()
		end

		if v336 and v336 ~= "PRACTICE" then
			if not botPlayers.IsLiveMatch(v336) then
				spectators.Visible = false

				return
			end

			local v338 = countLobbySpectators(v336)

			if v338 > 0 then
				amount.Text = tostring(v338)
				spectators.Visible = true

				return
			end

			spectators.Visible = false

			return
		end

		spectators.Visible = false

		return
	end
end)
task.spawn(function()
	local activeMatches: Instance = replicatedStorage:WaitForChild("ActiveMatches", 10)

	if not activeMatches then
		return
	end

	local function watchMatchNode(p52)
		p52.ChildAdded:Connect(function(p53)
			if p53.Name == "Bots" then
				task.wait(0.1)
				refreshEffectiveContext()
				p53.ChildAdded:Connect(function()
					task.wait(0.1)
					refreshEffectiveContext()
				end)
			end
		end)

		local bots = p52:FindFirstChild("Bots")

		if bots then
			task.wait(0.1)
			refreshEffectiveContext()
			bots.ChildAdded:Connect(function()
				task.wait(0.1)
				refreshEffectiveContext()
			end)
		end
	end

	for _, v in ipairs(activeMatches:GetChildren()) do
		if v:IsA("Folder") then
			watchMatchNode(v)
		end
	end

	activeMatches.ChildAdded:Connect(function(p54: Instance)
		if p54:IsA("Folder") then
			watchMatchNode(p54)
		end
	end)
end)
