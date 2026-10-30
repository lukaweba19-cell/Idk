-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local uiFramework = require(game.ReplicatedStorage:WaitForChild("UIFramework"))
local extensions = game.ReplicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions = game.ReplicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local httpService: HttpService = game:GetService("HttpService")
local LocalPlayer: Player = players.LocalPlayer
local spectate: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Spectate")

local v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22 = (function()
	local spectating: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Spectating")
	local bottom: Instance = spectating:WaitForChild("Bottom")
	local playerName: Instance = bottom:WaitForChild("PlayerName")
	local playerUsername: Instance = bottom:WaitForChild("PlayerUsername")
	local headshot: Instance = bottom:WaitForChild("PlayerTemplate"):WaitForChild("Headshot")
	local next: Instance = spectating:WaitForChild("Next")
	local back: Instance = spectating:WaitForChild("Back")
	local exit: Instance = spectating:FindFirstChild("Exit")

	assert(exit, "Spectating.Exit missing")

	local green_UIGradient: Instance = playerName:WaitForChild("Green_UIGradient")
	local red_UIGradient: Instance = playerName:WaitForChild("Red_UIGradient")
	local playerUsernameGreen_UIGradient: Instance = playerUsername:WaitForChild("Green_UIGradient")
	local playerUsernameRed_UIGradient: Instance = playerUsername:WaitForChild("Red_UIGradient")

	return spectating, playerName, playerUsername, next, back, exit, green_UIGradient, red_UIGradient, playerUsernameGreen_UIGradient, playerUsernameRed_UIGradient, headshot
end)()

local v23 = v13.Position
local v24 = v13.Size
local uDim2 = UDim2.new(0.55, 0, 0.4, 0)
local uDim22 = UDim2.new(0.5, 0, 0.7, 0)

v14.Visible = false
v12.Visible = false

local v27 = v17:IsA("ImageButton") and v17 or nil
local v28 = v17:IsA("TextButton") and v17 or nil
local v29 = v17 and v17:FindFirstChild("Keybind")

if v29 then
	uiFramework.applyGamepadKeybind(v29, gamepadBindings.Menu)
	uiFramework.bindKeybindLabel(v29, "Menu")
end

local keybind = v15:FindFirstChild("Keybind")

if keybind then
	uiFramework.applyGamepadKeybind(keybind, gamepadBindings.SpectateRight, "►")
	uiFramework.bindKeybindLabel(keybind, "SpectateNext")
end

local keybind2 = v16:FindFirstChild("Keybind")

if keybind2 then
	uiFramework.applyGamepadKeybind(keybind2, gamepadBindings.SpectateLeft, "◄")
	uiFramework.bindKeybindLabel(keybind2, "SpectatePrev")
end

local u32: boolean = false
local t1: {[any]: any} = {}
local n1 = 0
local u35 = nil
local connection = nil
local connection4 = nil
local connection5 = nil
local connection6 = nil
local connection3 = nil
local connection7 = nil
local connection2 = nil
local connection8 = nil

local function disconnect(p1)
	if p1 then
		p1:Disconnect()
	end
end
local function setExitVisible(visible)
	if v27 then
		v27.Visible = visible
	end

	if v28 then
		v28.Visible = visible
	end
end

local n2 = 0

local function stopSpectating()
	u35 = nil
	n1 = 0
	t1 = {}
	local v82 = connection

	if v82 then
		v82:Disconnect()
	end

	connection = nil
	v82 = connection5

	if v82 then
		v82:Disconnect()
	end

	connection5 = nil
	v82 = connection6

	if v82 then
		v82:Disconnect()
	end

	connection6 = nil
	v82 = connection4

	if v82 then
		v82:Disconnect()
	end

	connection4 = nil
	spectate:FireServer(nil)
end
local function isInRealMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u84: boolean = false

	if typeof(matchId) == "string" then
		u84 = false

		if matchId ~= "" then
			u84 = matchId ~= "PRACTICE"
		end
	end

	return u84
end
local function isLobbyMode()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u86: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u86 = lobbySpectateMatchId ~= ""
	end

	return u86
end
local function getLobbyMatchId()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		return lobbySpectateMatchId
	end

	return nil
end
local function getLobbyIds()
	local lobbySpectateIds: any = LocalPlayer:GetAttribute("LobbySpectateIds")

	if typeof(lobbySpectateIds) == "string" and lobbySpectateIds ~= "" then
		local ok, result = pcall(function()
			return httpService:JSONDecode(lobbySpectateIds)
		end)

		if ok and typeof(result) == "table" then
			local t2: {[any]: any} = {}

			for _, v in ipairs(result) do
				if typeof(v) == "number" then
					local floored = math.floor(v)

					table.insert(t2, floored)
				end
			end

			return t2
		end

		return {}
	end

	return {}
end

getLobbyIds = function(player)
	local Character = player.Character

	if not Character then
		return false
	end

	local humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return false
	end

	return humanoid.Health > 0
end

local function getSide(p4)
	local matchSide = p4:GetAttribute("MatchSide")

	if typeof(matchSide) == "string" and matchSide ~= "" then
		return matchSide
	end

	return "?"
end
local function isTargetAlly(player)
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u102: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u102 = lobbySpectateMatchId ~= ""
	end

	if u102 then
		local matchSide = player:GetAttribute("MatchSide")

		return (if typeof(matchSide) == "string" and matchSide ~= "" then matchSide else "?") == "A"
	end

	return player.Team == LocalPlayer.Team
end
local function applyTeamGradient(player)
	if not player then
		v18.Enabled = true
		v19.Enabled = false
		v20.Enabled = true
		v21.Enabled = false

		return
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u106: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u106 = lobbySpectateMatchId ~= ""
	end

	local u107

	if u106 then
		local matchSide = player:GetAttribute("MatchSide")

		u107 = (if typeof(matchSide) == "string" and matchSide ~= "" then matchSide else "?") == "A"
	else
		u107 = player.Team == LocalPlayer.Team
	end

	v18.Enabled = u107
	v19.Enabled = not u107
	v20.Enabled = u107
	v21.Enabled = not u107
end
local function rebuildCandidates()
	t1 = {}
	n1 = 0

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u110: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u110 = lobbySpectateMatchId ~= ""
	end

	if u110 then
		local lobbySpectateMatchId2: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local v112 = if typeof(lobbySpectateMatchId2) == "string" and lobbySpectateMatchId2 ~= "" then lobbySpectateMatchId2 else nil

		if not v112 then
			return
		end

		for _, v in ipairs(players:GetPlayers()) do
			if v ~= LocalPlayer and v112 == v:GetAttribute("MatchId") then
				local Character = v.Character
				local u116

				if not Character then
					u116 = false
				else
					local humanoid = Character:FindFirstChildOfClass("Humanoid")

					u116 = if not humanoid then false else humanoid.Health > 0
				end

				if u116 then
					table.insert(t1, v)
				end
			end
		end

		table.sort(t1, function(player, player2)
			local matchSide = player:GetAttribute("MatchSide")
			local v181 = if typeof(matchSide) == "string" and matchSide ~= "" then matchSide else "?"
			local matchSide2 = player2:GetAttribute("MatchSide")
			local v183 = if typeof(matchSide2) == "string" and matchSide2 ~= "" then matchSide2 else "?"

			if v181 ~= v183 then
				return (if v181 == "A" then 1 else if v181 == "B" then 2 else 3) < (if v183 == "A" then 1 else if v183 == "B" then 2 else 3)
			end

			return player.UserId < player2.UserId
		end)

		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	u110 = false

	if typeof(matchId) == "string" then
		u110 = false

		if matchId ~= "" then
			u110 = matchId ~= "PRACTICE"
		end
	end

	if not u110 then
		return
	end

	local matchId2: any = LocalPlayer:GetAttribute("MatchId")
	local localPlayerTeam: Team = LocalPlayer.Team

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer and localPlayerTeam == v.Team and matchId2 == v:GetAttribute("MatchId") then
			local Character = v.Character
			local u124

			if not Character then
				u124 = false
			else
				local humanoid = Character:FindFirstChildOfClass("Humanoid")

				u124 = if not humanoid then false else humanoid.Health > 0
			end

			if u124 then
				table.insert(t1, v)
			end
		end
	end

	table.sort(t1, function(player, player2)
		return player.UserId < player2.UserId
	end)
end
local function hasAnyCandidates()
	rebuildCandidates()

	return #t1 > 0
end
local function setUiTextForTarget(player)
	if player then
		v13.Text = string.upper(player.DisplayName)
		v22.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)

		if player.DisplayName ~= player.Name then
			v13.Position = uDim2
			v13.Size = uDim22
			v14.Text = "@" .. player.Name
			v14.Visible = true
		else
			v13.Position = v23
			v13.Size = v24
			v14.Visible = false
		end

		if not player then
			v18.Enabled = true
			v19.Enabled = false
			v20.Enabled = true
			v21.Enabled = false

			return
		end

		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u128: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u128 = lobbySpectateMatchId ~= ""
		end

		local u129

		if u128 then
			local matchSide = player:GetAttribute("MatchSide")

			u129 = (if typeof(matchSide) == "string" and matchSide ~= "" then matchSide else "?") == "A"
		else
			u129 = player.Team == LocalPlayer.Team
		end

		v18.Enabled = u129
		v19.Enabled = not u129
		v20.Enabled = u129
		v21.Enabled = not u129

		return
	end

	v13.Text = "NO ONE"
	v22.Image = ""
	v13.Position = v23
	v13.Size = v24
	v14.Visible = false
	v18.Enabled = true
	v19.Enabled = false
	v20.Enabled = true
	v21.Enabled = false
end

local u58 = nil

local function advanceFromDeadTarget(p12)
	if not u32 then
		return
	end

	if p12 ~= u35 then
		return
	end

	rebuildCandidates()

	local v132 = nil

	for _, v in ipairs(t1) do
		if v ~= p12 then
			v132 = v

			break
		end
	end

	if v132 then
		for i, v in ipairs(t1) do
			if v == v132 then
				n1 = i

				break
			end
		end

		u58(v132)
	end
end

u58 = function(player, p14)
	local v139 = connection

	if v139 then
		v139:Disconnect()
	end

	connection = nil
	v139 = connection5

	if v139 then
		v139:Disconnect()
	end

	connection5 = nil
	v139 = connection6

	if v139 then
		v139:Disconnect()
	end

	connection6 = nil
	v139 = connection4

	if v139 then
		v139:Disconnect()
	end

	connection4 = nil
	u35 = player
	setUiTextForTarget(player)

	if not player then
		stopSpectating()

		return
	end

	spectate:FireServer(player.UserId)
	v139 = p14 or player.Character

	local function watchHumanoid(p15)
		local v187 = connection

		if v187 then
			v187:Disconnect()
		end

		connection = p15.HealthChanged:Connect(function(p16)
			if p16 <= 0 then
				task.defer(advanceFromDeadTarget, player)
			end
		end)
	end

	local humanoid = v139 and v139:FindFirstChildOfClass("Humanoid")

	if humanoid then
		local v142 = connection

		if v142 then
			v142:Disconnect()
		end

		connection = humanoid.HealthChanged:Connect(function(p17)
			if p17 <= 0 then
				task.defer(advanceFromDeadTarget, player)
			end
		end)
	elseif v139 then
		connection4 = v139.ChildAdded:Connect(function(p18)
			if p18:IsA("Humanoid") then
				local v190 = connection4

				if v190 then
					v190:Disconnect()
				end

				connection4 = nil
				v190 = connection

				if v190 then
					v190:Disconnect()
				end

				connection = p18.HealthChanged:Connect(function(p19)
					if p19 <= 0 then
						task.defer(advanceFromDeadTarget, player)
					end
				end)
			end
		end)
	end

	if v139 then
		connection5 = v139.AncestryChanged:Connect(function(_, p21)
			if p21 == nil then
				task.defer(function()
					advanceFromDeadTarget(player)
				end)
			end
		end)
	end

	connection6 = player.CharacterAdded:Connect(function(p22)
		if u35 ~= player then
		elseif not p22 or not p22:WaitForChild("Humanoid", 5) then
		elseif u35 == player then
			u58(player, p22)
		end
	end)
end

local function step(p23)
	if os.clock() < n2 then
		return
	end

	rebuildCandidates()

	if #t1 == 0 then
		return
	end

	if u35 then
		local n3 = 0

		for i, v in ipairs(t1) do
			if v == u35 then
				n3 = i

				break
			end
		end

		n1 = n3 ~= 0 and n3 or 1
	else
		n1 = 1
	end

	n1 += p23

	if n1 > #t1 then
		n1 = 1
	end

	if n1 < 1 then
		n1 = #t1
	end

	n2 = os.clock() + 0.5
	u58(t1[n1])
end
local function clearLobbyMode()
	LocalPlayer:SetAttribute("LobbySpectateIds", nil)
	LocalPlayer:SetAttribute("LobbySpectateMatchId", nil)
	LocalPlayer:SetAttribute("LobbySpectateTeam", nil)
end
local function exitLobbySpectate()
	stopSpectating()
	LocalPlayer:SetAttribute("LobbySpectateIds", nil)
	LocalPlayer:SetAttribute("LobbySpectateMatchId", nil)
	LocalPlayer:SetAttribute("LobbySpectateTeam", nil)
	v12.Visible = false
	u32 = false

	local v147 = connection3

	if v147 then
		v147:Disconnect()
	end

	connection3 = nil
	v147 = connection7

	if v147 then
		v147:Disconnect()
	end

	connection7 = nil
	v147 = connection2

	if v147 then
		v147:Disconnect()
	end

	connection2 = nil
	v147 = connection8

	if v147 then
		v147:Disconnect()
	end

	connection8 = nil

	if v27 then
		v27.Visible = false
	end

	if v28 then
		v28.Visible = false
	end
end
local function bindExitButtonIfLobby()
	local v148 = connection8

	if v148 then
		v148:Disconnect()
	end

	connection8 = nil

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	v148 = false

	if typeof(lobbySpectateMatchId) == "string" then
		v148 = lobbySpectateMatchId ~= ""
	end

	if v27 then
		v27.Visible = v148
	end

	if v28 then
		v28.Visible = v148
	end

	if not v148 then
	elseif v27 then
		connection8 = v27.MouseButton1Click:Connect(exitLobbySpectate)
	elseif v28 then
		connection8 = v28.MouseButton1Click:Connect(exitLobbySpectate)
	end
end
local function enableSpectateUi()
	if u32 then
		bindExitButtonIfLobby()

		return
	end

	rebuildCandidates()

	if not (#t1 > 0) then
		stopSpectating()
		v12.Visible = false
		u32 = false

		return
	end

	u32 = true
	v12.Visible = true
	bindExitButtonIfLobby()
	connection7 = v15.MouseButton1Click:Connect(function()
		step(1)
	end)
	connection2 = v16.MouseButton1Click:Connect(function()
		step(-1)
	end)
	connection3 = userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if not u32 then
		elseif gameProcessedEvent then
			if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			elseif input.KeyCode == gamepadBindings.SpectateRight then
				step(1)
			elseif input.KeyCode == gamepadBindings.SpectateLeft then
				step(-1)
			end
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			if inputMap.matches("SpectateNext", input) then
				step(1)

				return
			end

			if inputMap.matches("SpectatePrev", input) then
				step(-1)
			end

			return
		end
	end)

	local n2 = 1
	local lobbySpectateInitialPick: any = LocalPlayer:GetAttribute("LobbySpectateInitialPick")

	if typeof(lobbySpectateInitialPick) == "number" then
		for i, v in ipairs(t1) do
			if lobbySpectateInitialPick == v.UserId then
				n2 = i

				break
			end
		end

		LocalPlayer:SetAttribute("LobbySpectateInitialPick", nil)
	end

	n1 = n2
	u58(t1[n1])
end
local function disableSpectateUi()
	if not u32 then
		stopSpectating()
		v12.Visible = false

		if v27 then
			v27.Visible = false
		end

		if v28 then
			v28.Visible = false
		end

		return
	end

	u32 = false
	v12.Visible = false

	local v154 = connection3

	if v154 then
		v154:Disconnect()
	end

	connection3 = nil
	v154 = connection7

	if v154 then
		v154:Disconnect()
	end

	connection7 = nil
	v154 = connection2

	if v154 then
		v154:Disconnect()
	end

	connection2 = nil
	v154 = connection8

	if v154 then
		v154:Disconnect()
	end

	connection8 = nil

	if v27 then
		v27.Visible = false
	end

	if v28 then
		v28.Visible = false
	end

	stopSpectating()
end
local function refreshLobbyMode()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u156: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u156 = lobbySpectateMatchId ~= ""
	end

	if u156 then
		enableSpectateUi()

		if not u32 then
			task.spawn(function()
				for _ = 1, 5 do
					task.wait(0.5)

					local lobbySpectateMatchId3: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
					local u198: boolean = false

					if typeof(lobbySpectateMatchId3) == "string" then
						u198 = lobbySpectateMatchId3 ~= ""
					end

					if not u198 then
						return
					end

					if u32 then
						return
					end

					enableSpectateUi()
				end
			end)

			return
		end
	else
		disableSpectateUi()
	end
end

LocalPlayer:GetAttributeChangedSignal("LobbySpectateIds"):Connect(refreshLobbyMode)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(refreshLobbyMode)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateTeam"):Connect(function()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u158: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u158 = lobbySpectateMatchId ~= ""
	end

	if u158 and u32 then
		rebuildCandidates()

		if u35 then
			local u159: boolean = false

			for _, v in ipairs(t1) do
				if v == u35 then
					u159 = true

					break
				end
			end

			if u159 then
				setUiTextForTarget(u35)

				return
			end
		end

		if #t1 > 0 then
			n1 = 1
			u58(t1[n1])

			return
		end

		u58(nil)

		return
	end
end)
task.defer(function()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u163: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u163 = lobbySpectateMatchId ~= ""
	end

	if u163 then
		refreshLobbyMode()
	end
end)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	n2 = 0

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 and spectating ~= LocalPlayer.UserId then
		local player: Player = players:GetPlayerByUserId(spectating)

		if player then
			u35 = player
			setUiTextForTarget(player)
		end
	end

	if typeof(spectating) == "number" and spectating ~= 0 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u167: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u167 = lobbySpectateMatchId ~= ""
		end

		if u167 then
			for _ = 1, 5 do
				if u32 then
					break
				end

				enableSpectateUi()

				if u32 then
					break
				end

				task.wait(0.3)
			end
		end
	end
end)

local function bindCharacter(p26)
	disableSpectateUi()
	task.defer(function()
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u200: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u200 = lobbySpectateMatchId ~= ""
		end

		if u200 then
			enableSpectateUi()
		end
	end)
	p26:WaitForChild("Humanoid").Died:Connect(function()
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u202: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u202 = lobbySpectateMatchId ~= ""
		end

		if u202 then
			return
		end

		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		u202 = false

		if typeof(matchId) == "string" then
			u202 = false

			if matchId ~= "" then
				u202 = matchId ~= "PRACTICE"
			end
		end

		if not u202 then
			return
		end

		task.delay(3, function()
			if LocalPlayer.Character ~= p26 then
				return
			end

			local matchId3: any = LocalPlayer:GetAttribute("MatchId")
			local u207: boolean = false

			if typeof(matchId3) == "string" then
				u207 = false

				if matchId3 ~= "" then
					u207 = matchId3 ~= "PRACTICE"
				end
			end

			if not u207 then
			elseif p26:FindFirstChildOfClass("Humanoid") and not (p26:FindFirstChildOfClass("Humanoid").Health > 0) then
				rebuildCandidates()

				if #t1 > 0 then
					enableSpectateUi()

					return
				end

				disableSpectateUi()

				return
			end
		end)
	end)
end

if LocalPlayer.Character then
	bindCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(bindCharacter)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u171: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u171 = lobbySpectateMatchId ~= ""
	end

	if u171 then
		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	u171 = false

	if typeof(matchId) == "string" then
		u171 = false

		if matchId ~= "" then
			u171 = matchId ~= "PRACTICE"
		end
	end

	if not u171 then
		disableSpectateUi()
	end
end)
players.PlayerRemoving:Connect(function(player: Player)
	if player == u35 then
		task.defer(advanceFromDeadTarget, player)
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if inputMap.matches("Menu", input) then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u177: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u177 = lobbySpectateMatchId ~= ""
		end

		if u177 then
			exitLobbySpectate()
		end
	end
end)
