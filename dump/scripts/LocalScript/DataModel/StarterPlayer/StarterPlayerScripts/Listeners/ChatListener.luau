-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local textChatService: TextChatService = game:GetService("TextChatService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local customChannels: Instance = textChatService:WaitForChild("CustomChannels")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local clanTagDisplay = require(shared:WaitForChild("ClanTagDisplay"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local replayActors = require(replicatedStorageShared:WaitForChild("ReplayActors"))
local color3 = Color3.fromRGB(80, 255, 80)
local color32 = Color3.fromRGB(255, 80, 80)
local replayActorsMatch_id = replayActors.MATCH_ID

local function isRealMatchId(p1)
	return p1 ~= nil and p1 ~= "PRACTICE" and p1 ~= replayActorsMatch_id
end
local function lobbySpectateMatchId(p2)
	local lobbySpectateMatchId = p2:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		if lobbySpectateMatchId == nil or lobbySpectateMatchId == "PRACTICE" or lobbySpectateMatchId == replayActorsMatch_id then
			return nil
		end

		return lobbySpectateMatchId
	end

	return nil
end
local function c3ToHex(p3)
	local stringFormat = string.format
	local floored = math.floor(p3.R * 255 + 0.5)
	local floored2 = math.floor(p3.G * 255 + 0.5)
	local floored3 = math.floor(p3.B * 255 + 0.5)

	return stringFormat("#%02X%02X%02X", floored, floored2, floored3)
end
local function escapeRichText(p4)
	return (p4:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end

local v17 = BrickColor.new("Alder").Color
local v18 = BrickColor.new("Bright orange").Color
local v19 = BrickColor.new("Bright yellow").Color
local v20 = BrickColor.new("Light reddish violet").Color

local function getNameValue(p5)
	local n1 = 0

	for i = 1, #p5 do
		local v43 = string.sub(p5, i, i)
		local v44 = string.byte(v43)

		v43 = #p5 - i + 1

		if #p5 % 2 == 1 then
			v43 -= 1
		end

		if v43 % 4 >= 2 then
			v44 = -v44
		end

		n1 += v44
	end

	return n1
end

local t1: {[any]: any} = {
	Color3.new(0.9921568627450981, 0.1607843137254902, 0.2627450980392157),
	Color3.new(0.00392156862745098, 0.6352941176470588, 1),
	Color3.new(0.00784313725490196, 0.7215686274509804, 0.3411764705882353),
	v17,
	v18,
	v19,
	v20,
	BrickColor.new("Brick yellow").Color
}

local function computeNameColor(p6)
	local v46 = getNameValue(p6)

	return t1[v46 % #t1 + 1]
end
function textChatService.OnIncomingMessage(p7)
	local textChatMessageProperties: TextChatMessageProperties = Instance.new("TextChatMessageProperties")
	local textSource = p7.TextSource

	if textSource == nil then
		return textChatMessageProperties
	end

	local player: Player = players:GetPlayerByUserId(textSource.UserId)

	if not player then
		return textChatMessageProperties
	end

	local v51 = escapeRichText(player.DisplayName)
	local s1: string = ""
	local clanTag: any = player:GetAttribute("ClanTag")

	if typeof(clanTag) == "string" and clanTag ~= "" then
		s1 = clanTagDisplay.GetTagWithLeaderboard(clanTag, player:GetAttribute("ClanRank")) .. " "
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u55: boolean = matchId ~= nil and matchId ~= "PRACTICE" and matchId ~= replayActorsMatch_id

	if not u55 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local v58

		if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
			v58 = if lobbySpectateMatchId == nil or lobbySpectateMatchId == "PRACTICE" or lobbySpectateMatchId == replayActorsMatch_id then nil else lobbySpectateMatchId
		else
			v58 = nil
		end

		u55 = v58 ~= nil
	end

	local v60
	local v62
	local v64
	local v66
	local v68
	local floored
	local floored8
	local floored9
	local v76
	local v78
	local v79: boolean = false

	if u55 then
		local matchId2: any = player:GetAttribute("MatchId")
		local u81: boolean = matchId2 == nil or matchId2 == "PRACTICE" or matchId2 == replayActorsMatch_id

		if u81 then
			local lobbySpectateMatchId: any = player:GetAttribute("LobbySpectateMatchId")
			local v84

			if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
				v84 = if lobbySpectateMatchId == nil or lobbySpectateMatchId == "PRACTICE" or lobbySpectateMatchId == replayActorsMatch_id then nil else lobbySpectateMatchId
			else
				v84 = nil
			end

			u81 = v84 ~= nil
		end

		if u81 then
			local formattedText = string.format("<font color=\"#FFFFFF\">[Spectator] %s%s</font>", v51, ":")

			textChatMessageProperties.PrefixText = s1 .. formattedText

			return textChatMessageProperties
		end

		local localPlayerTeam: Team = LocalPlayer.Team
		local playerTeam: Team = player.Team

		if localPlayerTeam and playerTeam then
			local u88: boolean = playerTeam == localPlayerTeam
			local v89 = u88 and color3 or color32
			local stringFormat = string.format
			local v91 = string.format
			local floored = math.floor(v89.R * 255 + 0.5)
			local floored4 = math.floor(v89.G * 255 + 0.5)
			local floored5 = math.floor(v89.B * 255 + 0.5)
			local v95 = v91("#%02X%02X%02X", floored, floored4, floored5)
			local v96 = stringFormat("<font color=\"%s\">[%s] %s%s</font>", v95, if u88 then "Friend" else "Enemy", v51, ":")

			textChatMessageProperties.PrefixText = s1 .. v96

			return textChatMessageProperties
		end

		local matchSide: any = player:GetAttribute("MatchSide")

		if matchSide == "A" or matchSide == "B" then
			local v98 = matchSide == "A" and color3 or color32
			local v99 = string.format
			local v100 = string.format
			local floored = math.floor(v98.R * 255 + 0.5)
			local floored6 = math.floor(v98.G * 255 + 0.5)
			local floored7 = math.floor(v98.B * 255 + 0.5)
			local v104 = v100("#%02X%02X%02X", floored, floored6, floored7)
			local v105 = v99("<font color=\"%s\">[%s] %s%s</font>", v104, if matchSide == "A" then "Team A" else "Team B", v51, ":")

			textChatMessageProperties.PrefixText = s1 .. v105

			return textChatMessageProperties
		end

		v79 = true
	end

	v60 = t1
	v62 = getNameValue(player.Name)
	v64 = v60[v62 % #t1 + 1]
	v66 = string.format
	v68 = string.format
	floored = math.floor(v64.R * 255 + 0.5)
	floored8 = math.floor(v64.G * 255 + 0.5)
	floored9 = math.floor(v64.B * 255 + 0.5)
	v76 = v68("#%02X%02X%02X", floored, floored8, floored9)
	v78 = v66("<font color=\"%s\">%s%s</font>", v76, v51, ":")
	textChatMessageProperties.PrefixText = s1 .. v78

	return textChatMessageProperties
end
local function channelName(p8)
	return "Match_" .. tostring(p8)
end

local u25 = nil

local function setTarget()
	local matchId = LocalPlayer:GetAttribute("MatchId")

	if matchId == nil or matchId == "PRACTICE" or matchId == replayActorsMatch_id then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local v110

		if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
			v110 = if lobbySpectateMatchId == nil or lobbySpectateMatchId == "PRACTICE" or lobbySpectateMatchId == replayActorsMatch_id then nil else lobbySpectateMatchId
		else
			v110 = nil
		end

		matchId = v110 or matchId
	end

	local s1 = matchId ~= nil and matchId ~= "PRACTICE" and matchId ~= replayActorsMatch_id and "Match_" .. tostring(matchId) or "Lobby"
	local foundChild: Instance = customChannels:FindFirstChild(s1)

	if foundChild and foundChild:IsA("TextChannel") then
		textChatService.ChatInputBarConfiguration.TargetTextChannel = foundChild

		if s1 ~= u25 and s1 ~= "Lobby" then
			task.defer(function()
				foundChild:DisplaySystemMessage("You are now chatting in this match.")
			end)
		end

		u25 = s1
	end
end

v19 = function(p9)
	if p9 == nil or not p9:IsA("TextChannel") then
		return false
	end

	if p9.Parent == customChannels then
		return true
	end

	if p9.Name:sub(1, 10) == "RBXWhisper" and p9.Parent ~= nil then
		return true
	end

	return false
end

local u27: boolean = false

textChatService.ChatInputBarConfiguration:GetPropertyChangedSignal("TargetTextChannel"):Connect(function()
	if u27 then
		return
	end

	local textChatServiceChatInputBarConfiguration = textChatService.ChatInputBarConfiguration
	local textChatServiceChatInputBarConfigurationTargetTextChannel = textChatServiceChatInputBarConfiguration.TargetTextChannel

	if if textChatServiceChatInputBarConfigurationTargetTextChannel == nil or not textChatServiceChatInputBarConfigurationTargetTextChannel:IsA("TextChannel") then false else if textChatServiceChatInputBarConfigurationTargetTextChannel.Parent == customChannels then true else textChatServiceChatInputBarConfigurationTargetTextChannel.Name:sub(1, 10) == "RBXWhisper" and textChatServiceChatInputBarConfigurationTargetTextChannel.Parent ~= nil then
		return
	end

	u27 = true
	task.spawn(function()
		for _ = 1, 40 do
			setTarget()

			local textChatServiceChatInputBarConfigurationTargetTextChannel = textChatServiceChatInputBarConfiguration.TargetTextChannel

			if if textChatServiceChatInputBarConfigurationTargetTextChannel == nil or not textChatServiceChatInputBarConfigurationTargetTextChannel:IsA("TextChannel") then false else if textChatServiceChatInputBarConfigurationTargetTextChannel.Parent == customChannels then true else textChatServiceChatInputBarConfigurationTargetTextChannel.Name:sub(1, 10) == "RBXWhisper" and textChatServiceChatInputBarConfigurationTargetTextChannel.Parent ~= nil then
				break
			end

			task.wait(0.25)
		end

		u27 = false
	end)
end)
task.spawn(function()
	local mdPublicChatCommand: Instance = textChatService:WaitForChild("MDPublicChatCommand", 30)

	if not mdPublicChatCommand then
		return
	end

	mdPublicChatCommand.Triggered:Connect(function()
		setTarget()

		local targetTextChannel = textChatService.ChatInputBarConfiguration.TargetTextChannel

		if targetTextChannel and targetTextChannel:IsA("TextChannel") then
			targetTextChannel:DisplaySystemMessage("You are now chatting publicly again.")
		end
	end)
end)
setTarget()

local textChatServiceChatInputBarConfiguration = textChatService.ChatInputBarConfiguration
local textChatServiceChatInputBarConfigurationTargetTextChannel = textChatServiceChatInputBarConfiguration.TargetTextChannel

if not (if textChatServiceChatInputBarConfigurationTargetTextChannel == nil or not textChatServiceChatInputBarConfigurationTargetTextChannel:IsA("TextChannel") then false else if customChannels == textChatServiceChatInputBarConfigurationTargetTextChannel.Parent then true else textChatServiceChatInputBarConfigurationTargetTextChannel.Name:sub(1, 10) == "RBXWhisper" and textChatServiceChatInputBarConfigurationTargetTextChannel.Parent ~= nil) then
	u27 = true
	task.spawn(function()
		for _ = 1, 40 do
			setTarget()

			local textChatServiceChatInputBarConfigurationTargetTextChannel = textChatServiceChatInputBarConfiguration.TargetTextChannel

			if if textChatServiceChatInputBarConfigurationTargetTextChannel == nil or not textChatServiceChatInputBarConfigurationTargetTextChannel:IsA("TextChannel") then false else if textChatServiceChatInputBarConfigurationTargetTextChannel.Parent == customChannels then true else textChatServiceChatInputBarConfigurationTargetTextChannel.Name:sub(1, 10) == "RBXWhisper" and textChatServiceChatInputBarConfigurationTargetTextChannel.Parent ~= nil then
				break
			end

			task.wait(0.25)
		end

		u27 = false
	end)
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(setTarget)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(setTarget)
LocalPlayer:GetAttributeChangedSignal("DebugRefreshChat"):Connect(setTarget)
LocalPlayer.CharacterAdded:Connect(function()
	local timestamp = tick()

	while true do
		if not (tick() - timestamp < 10) then
			break
		end

		setTarget()
		task.wait(0.05)
	end
end)

local function waitForMembership(p10, p11)
	local function isMember()
		for _, v in ipairs(p10:GetChildren()) do
			if v:IsA("TextSource") and v.UserId == p11 then
				return true
			end
		end

		return false
	end

	while true do
		if isMember() then
			break
		end

		p10.ChildAdded:Wait()
	end
end

task.spawn(function()
	local lobby: Instance = customChannels:WaitForChild("Lobby")

	waitForMembership(lobby, LocalPlayer.UserId)
	setTarget()
	task.wait(1)

	for _ = 1, 3 do
		task.wait()
	end

	task.wait(1)
	lobby:DisplaySystemMessage("Welcome to <b>Murder Duels</b>, " .. LocalPlayer.DisplayName .. " 👋")
	lobby:DisplaySystemMessage("The game is still in beta. Expect bugs, changes, and new features soon.")
end)
replicatedStorage:WaitForChild("Remotes"):WaitForChild("SystemMessage").OnClientEvent:Connect(function(p12)
	if typeof(p12) == "string" then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local s1 = matchId ~= nil and matchId ~= "PRACTICE" and matchId ~= replayActorsMatch_id and "Match_" .. tostring(matchId) or "Lobby"
		local foundChild: Instance = customChannels:FindFirstChild(s1)

		if foundChild and foundChild:IsA("TextChannel") then
			foundChild:DisplaySystemMessage(p12)
		end

		return
	end
end)
