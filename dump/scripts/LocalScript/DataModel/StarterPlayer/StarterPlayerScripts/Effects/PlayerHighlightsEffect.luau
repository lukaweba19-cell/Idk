-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local util: Instance = replicatedStorage:WaitForChild("Util")
local highlightPool = require(util:WaitForChild("HighlightPool"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(shared:WaitForChild("ViewedPlayer"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(replicatedStorageShared:WaitForChild("PlayerState"))
local LocalPlayer: Player = players.LocalPlayer
local allyHead: Instance = replicatedStorage:WaitForChild("FX"):WaitForChild("AllyHead")
local characters: Instance = workspace:WaitForChild("Characters")
local CurrentCamera: Camera = workspace.CurrentCamera
local color3 = Color3.fromRGB(90, 255, 120)
local color32 = Color3.fromRGB(255, 70, 70)
local __HighlightPool = workspace:FindFirstChild("__HighlightPool")

if not __HighlightPool then
	__HighlightPool = Instance.new("Folder")
	__HighlightPool.Name = "__HighlightPool"
	__HighlightPool.Parent = workspace
end

local v16 = highlightPool.new({ name = "PlayerHL", size = 32, parent = __HighlightPool })
local v17 = highlightPool.new({ name = "SelfHL", size = 2, parent = __HighlightPool })
local t1: {[any]: any} = {}

local function _poolFor(p1)
	if p1 == "__SelfHighlight" then
		return v17
	end

	return v16
end

local color33 = Color3.new(0, 0, 0)

local function getMatchId(p2)
	local matchId = p2:GetAttribute("MatchId")

	if typeof(matchId) == "string" then
		return matchId
	end

	return nil
end
local function isLobbySpectating()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u60: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u60 = lobbySpectateMatchId ~= ""
	end

	return u60
end
local function getMyMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v62 = if typeof(matchId) == "string" then matchId else nil

	if v62 then
		return v62
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		return lobbySpectateMatchId
	end

	return nil
end
local function isMyMatchLive()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v65 = if typeof(matchId) == "string" then matchId else nil
	local v66

	if v65 then
		v66 = v65
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v66 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	return v66 ~= nil and v66 ~= "PRACTICE"
end
local function isXRayEnabled()
	if LocalPlayer:GetAttribute("XRay") == true then
		return true
	end

	return LocalPlayer:GetAttribute("ReplayXRay") == true
end
local function getPlayerFromCharacterModel(p3)
	return players:GetPlayerFromCharacter(p3)
end
local function getDecoyOwner(p4)
	local ok, result = pcall(function()
		return p4:GetAttribute("Decoy")
	end)

	if ok and result then
		local ok2, result2 = pcall(function()
			return p4:GetAttribute("DecoyOwnerUserId")
		end)

		if ok2 and typeof(result2) == "number" then
			return players:GetPlayerByUserId(result2)
		end

		return nil
	end

	return nil
end
local function getViewerMatchSide()
	local matchSide = viewedPlayer.Player:GetAttribute("MatchSide")

	if typeof(matchSide) == "string" and matchSide ~= "" then
		return matchSide
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u76: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u76 = lobbySpectateMatchId ~= ""
	end

	if u76 then
		local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

		if typeof(lobbySpectateTeam) == "string" and lobbySpectateTeam ~= "" then
			return lobbySpectateTeam
		end

		return nil
	end

	return nil
end
local function isEnemyRelativeToLocal(player)
	local team = viewedPlayer.Player.Team

	if team == nil then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u81: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u81 = lobbySpectateMatchId ~= ""
		end

		if u81 then
			local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")
			local matchSide = player:GetAttribute("MatchSide")

			if typeof(lobbySpectateTeam) == "string" and typeof(matchSide) == "string" and lobbySpectateTeam ~= "" and matchSide ~= "" then
				return matchSide ~= lobbySpectateTeam
			end

			return true
		end

		return false
	end

	return player.Team ~= nil and team ~= player.Team
end
local function ensureHighlight(adornee, p7, depthMode)
	local v87 = t1[adornee]

	if v87 and v87[p7] then
		local v88 = v87[p7]

		v88.DepthMode = depthMode

		if adornee ~= v88.Adornee then
			v88.Adornee = adornee
		end

		if v88.Parent ~= __HighlightPool then
			v88.Parent = __HighlightPool
		end

		return v88
	end

	local v89 = (if p7 == "__SelfHighlight" then v17 else v16):acquire(adornee, { DepthMode = depthMode })

	if not v89 then
		return nil
	end

	local t3 = v87 or {}

	t3[p7] = v89
	t1[adornee] = t3

	return v89
end
local function removeHighlightByName(p9, p10)
	if not p9 then
		return
	end

	local v93 = t1[p9]

	if not v93 then
		return
	end

	local v94 = v93[p10]

	if not v94 then
		return
	end;

	(if p10 == "__SelfHighlight" then v17 else v16):release(v94)
	v93[p10] = nil

	if next(v93) == nil then
		t1[p9] = nil
	end
end
local function removeAllOurHighlights(character)
	if not character then
		return
	end

	local v96 = t1[character]

	if v96 then
		local __MatchTeamHighlight = v96.__MatchTeamHighlight

		if __MatchTeamHighlight then
			v16:release(__MatchTeamHighlight)
			v96.__MatchTeamHighlight = nil

			if next(v96) == nil then
				t1[character] = nil
			end
		end
	end

	if character then
		local v98 = t1[character]

		if v98 then
			local __XRayHighlight = v98.__XRayHighlight

			if __XRayHighlight then
				v16:release(__XRayHighlight)
				v98.__XRayHighlight = nil

				if next(v98) == nil then
					t1[character] = nil
				end
			end
		end
	end

	if character then
		local v100 = t1[character]

		if v100 then
			local __SelfHighlight = v100.__SelfHighlight

			if __SelfHighlight then
				v17:release(__SelfHighlight)
				v100.__SelfHighlight = nil

				if next(v100) == nil then
					t1[character] = nil
				end
			end
		end
	end

	removeAllyHead(character)
end
local function getCharPos(p12)
	local humanoidRootPart = p12:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		return humanoidRootPart.Position
	end

	local primaryPart = p12.PrimaryPart

	if primaryPart then
		return primaryPart.Position
	end

	return nil
end
local function getLocalReferencePos()
	if CurrentCamera then
		return CurrentCamera.CFrame.Position
	end

	local Character: Model = LocalPlayer.Character

	if Character then
		local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
			return humanoidRootPart.Position
		end

		local characterPrimaryPart: BasePart = Character.PrimaryPart

		if characterPrimaryPart then
			return characterPrimaryPart.Position
		end

		return nil
	end

	return nil
end
local function isWithinXRayDistance(p13)
	local v109

	if CurrentCamera then
		v109 = CurrentCamera.CFrame.Position
	else
		local Character: Model = LocalPlayer.Character

		if Character then
			local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")
			local characterPrimaryPart: BasePart = Character.PrimaryPart

			v109 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart.Position else if characterPrimaryPart then characterPrimaryPart.Position else nil
		else
			v109 = nil
		end
	end

	if not v109 then
		return true
	end

	local humanoidRootPart = p13:FindFirstChild("HumanoidRootPart")
	local primaryPart = p13.PrimaryPart
	local v115 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart.Position else if primaryPart then primaryPart.Position else nil

	if not v115 then
		return false
	end

	return (v115 - v109).Magnitude <= 1000
end
local function getSpectatedCharacter()
	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		return nil
	end

	local v116 = viewedPlayer.GetCharacter()

	if v116 and v116 ~= LocalPlayer.Character then
		return v116
	end

	return nil
end
function removeAllyHead(character)
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		local __AllyHeadBillboard = humanoidRootPart:FindFirstChild("__AllyHeadBillboard")

		if __AllyHeadBillboard then
			__AllyHeadBillboard:Destroy()
		end
	end

	for _, v in ipairs(character:GetDescendants()) do
		if v.Name == "__AllyHeadBillboard" and v:IsA("BillboardGui") then
			v:Destroy()
		end
	end
end
local function ensureAllyHead(p15, player)
	local humanoidRootPart = p15:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return
	end

	local __AllyHeadBillboard = humanoidRootPart:FindFirstChild("__AllyHeadBillboard")

	if __AllyHeadBillboard and __AllyHeadBillboard:IsA("BillboardGui") then
		return
	end

	local clone: Instance = allyHead:Clone()

	clone.Name = "__AllyHeadBillboard"

	local foundChild: Instance = clone:FindFirstChild("Headshot", true)

	if foundChild and foundChild:IsA("ImageLabel") then
		foundChild.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
	end

	clone.Parent = humanoidRootPart
end
local function applyAllyHeadFor(player)
	if player == LocalPlayer then
		return
	end

	local Character = player.Character

	if not Character then
		return
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u131: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u131 = lobbySpectateMatchId ~= ""
	end

	if u131 then
		removeAllyHead(Character)

		return
	end

	local v132

	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		v132 = nil
	else
		local v133 = viewedPlayer.GetCharacter()

		v132 = if v133 and v133 ~= LocalPlayer.Character then v133 else nil
	end

	if v132 and Character == v132 then
		removeAllyHead(Character)

		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v135 = if typeof(matchId) == "string" then matchId else nil
	local v136

	if v135 then
		v136 = v135
	else
		local lobbySpectateMatchId2: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v136 = if typeof(lobbySpectateMatchId2) == "string" and lobbySpectateMatchId2 ~= "" then lobbySpectateMatchId2 else nil
	end

	if v136 == nil or v136 == "PRACTICE" then
		removeAllyHead(Character)

		return
	end

	local matchId2: any = LocalPlayer:GetAttribute("MatchId")

	v135 = if typeof(matchId2) == "string" then matchId2 else nil

	local v139

	if v135 then
		v139 = v135
	else
		local lobbySpectateMatchId3: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v139 = if typeof(lobbySpectateMatchId3) == "string" and lobbySpectateMatchId3 ~= "" then lobbySpectateMatchId3 else nil
	end

	local matchId3 = player:GetAttribute("MatchId")

	v135 = if typeof(matchId3) == "string" then matchId3 else nil

	if v139 and v135 and v139 == v135 then
		if isEnemyRelativeToLocal(player) then
			removeAllyHead(Character)

			return
		end

		ensureAllyHead(Character, player)

		return
	end

	removeAllyHead(Character)
end
local function shouldMatchHighlight(player)
	if player == LocalPlayer then
		return false
	end

	local v143

	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		v143 = nil
	else
		local v144 = viewedPlayer.GetCharacter()

		v143 = if v144 and v144 ~= LocalPlayer.Character then v144 else nil
	end

	if v143 and v143 == player.Character then
		return false
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v146 = if typeof(matchId) == "string" then matchId else nil
	local v147

	if v146 then
		v147 = v146
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v147 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	if v147 == nil or v147 == "PRACTICE" then
		return false
	end

	local matchId4: any = LocalPlayer:GetAttribute("MatchId")

	v146 = if typeof(matchId4) == "string" then matchId4 else nil

	local v150

	if v146 then
		v150 = v146
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v150 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	local matchId5 = player:GetAttribute("MatchId")

	v146 = if typeof(matchId5) == "string" then matchId5 else nil

	if not v150 or not v146 then
		return false
	end

	if v146 ~= v150 then
		return false
	end

	local Character = player.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health <= 0 then
		return false
	end

	return true
end
local function applyMatchHighlightFor(player)
	applyAllyHeadFor(player)

	if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
		local Character = player.Character

		if Character then
			local v157 = t1[Character]

			if not v157 then
				return
			end

			local __MatchTeamHighlight = v157.__MatchTeamHighlight

			if not __MatchTeamHighlight then
				return
			end

			v16:release(__MatchTeamHighlight)
			v157.__MatchTeamHighlight = nil

			if next(v157) == nil then
				t1[Character] = nil
			end

			return
		end

		return
	end

	local Character = player.Character

	if not Character then
		return
	end

	if shouldMatchHighlight(player) then
		local v160 = isEnemyRelativeToLocal(player)
		local v162

		if not v160 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
			local u163: boolean = false

			if typeof(lobbySpectateMatchId) == "string" then
				u163 = lobbySpectateMatchId ~= ""
			end

			v162 = if u163 then Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.AlwaysOnTop else Enum.HighlightDepthMode.AlwaysOnTop
		else
			v162 = Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.AlwaysOnTop
		end

		local v164 = ensureHighlight(Character, "__MatchTeamHighlight", v162)

		if not v164 then
			return
		end

		if v160 then
			v164.FillColor = color32
			v164.OutlineColor = color32
			v164.FillTransparency = 0.75
			v164.OutlineTransparency = 0.4

			return
		end

		v164.FillColor = color3
		v164.OutlineColor = color3
		v164.FillTransparency = 0.9
		v164.OutlineTransparency = 0.6

		return
	end

	if not Character then
		return
	end

	local v165 = t1[Character]

	if not v165 then
		return
	end

	local v166 = v165.__MatchTeamHighlight

	if not v166 then
		return
	end

	v16:release(v166)
	v165.__MatchTeamHighlight = nil

	if next(v165) == nil then
		t1[Character] = nil
	end
end
local function applyMatchHighlightForBot(character)
	if not character:GetAttribute("BotMatchBot") then
		return
	end

	local v168

	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		v168 = nil
	else
		local v169 = viewedPlayer.GetCharacter()

		v168 = if v169 and v169 ~= LocalPlayer.Character then v169 else nil
	end

	local v170: boolean = false

	if not v168 or character ~= v168 then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v172 = if typeof(matchId) == "string" then matchId else nil
		local v173

		if v172 then
			v173 = v172
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v173 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
		end

		local v175: boolean = false

		if v173 ~= nil and v173 ~= "PRACTICE" then
			local v176: boolean = false

			if not (if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true) then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if not humanoid or not (humanoid.Health <= 0) then
					local matchSide = viewedPlayer.Player:GetAttribute("MatchSide")
					local v180

					if typeof(matchSide) == "string" and matchSide ~= "" then
						v180 = matchSide
					else
						local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
						local u181: boolean = false

						if typeof(lobbySpectateMatchId) == "string" then
							u181 = lobbySpectateMatchId ~= ""
						end

						if u181 then
							local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

							v180 = if typeof(lobbySpectateTeam) == "string" and lobbySpectateTeam ~= "" then lobbySpectateTeam else nil
						else
							v180 = nil
						end
					end

					local matchSide2 = character:GetAttribute("MatchSide")
					local u184: boolean = false

					if typeof(v180) == "string" then
						u184 = false

						if typeof(matchSide2) == "string" then
							u184 = matchSide2 ~= v180
						end
					end

					local v185 = ensureHighlight(character, "__MatchTeamHighlight", u184 and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop)

					if not v185 then
						return
					end

					if u184 then
						v185.FillColor = color32
						v185.OutlineColor = color32
						v185.FillTransparency = 0.75
						v185.OutlineTransparency = 0.4

						return
					end

					v185.FillColor = color3
					v185.OutlineColor = color3
					v185.FillTransparency = 0.9
					v185.OutlineTransparency = 0.6

					return
				end

				v176 = true
			end

			v175 = true
		end

		v170 = true
	end

	if not character then
		return
	end

	local v186 = t1[character]

	if not v186 then
		return
	end

	local __MatchTeamHighlight = v186.__MatchTeamHighlight

	if not __MatchTeamHighlight then
		return
	end

	v16:release(__MatchTeamHighlight)
	v186.__MatchTeamHighlight = nil

	if next(v186) == nil then
		t1[character] = nil
	end
end
local function shouldXRayHighlightCharacter(character)
	if not (if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true) then
		return false
	end

	local v189

	if CurrentCamera then
		v189 = CurrentCamera.CFrame.Position
	else
		local Character: Model = LocalPlayer.Character

		if Character then
			local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")
			local characterPrimaryPart: BasePart = Character.PrimaryPart

			v189 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart.Position else if characterPrimaryPart then characterPrimaryPart.Position else nil
		else
			v189 = nil
		end
	end

	local u193

	if not v189 then
		u193 = true
	else
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local primaryPart = character.PrimaryPart
		local v196 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart.Position else if primaryPart then primaryPart.Position else nil

		u193 = if not v196 then false else (v196 - v189).Magnitude <= 1000
	end

	if not u193 then
		return false
	end

	if character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health <= 0 then
		return false
	end

	if LocalPlayer.Character and character == LocalPlayer.Character then
		return false
	end

	local v197

	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		v197 = nil
	else
		local v198 = viewedPlayer.GetCharacter()

		v197 = if v198 and v198 ~= LocalPlayer.Character then v198 else nil
	end

	if v197 and character == v197 then
		return false
	end

	local v199 = players:GetPlayerFromCharacter(character) or getDecoyOwner(character)

	if v199 == LocalPlayer then
		return false
	end

	if v199 == nil then
		return true
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v201 = if typeof(matchId) == "string" then matchId else nil
	local v202

	if v201 then
		v202 = v201
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v202 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	if v202 ~= nil and v202 ~= "PRACTICE" then
		local matchId6: any = LocalPlayer:GetAttribute("MatchId")
		local v205 = if typeof(matchId6) == "string" then matchId6 else nil
		local v206

		if v205 then
			v206 = v205
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v206 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
		end

		local matchId7 = v199:GetAttribute("MatchId")

		v205 = if typeof(matchId7) == "string" then matchId7 else nil

		if v206 and v205 then
			return v205 == v206
		end

		return false
	end

	return true
end
local function applyXRayHighlightForCharacter(p22)
	if shouldXRayHighlightCharacter(p22) then
		local v210 = ensureHighlight(p22, "__XRayHighlight", Enum.HighlightDepthMode.AlwaysOnTop)

		if not v210 then
			return
		end

		local v211 = players:GetPlayerFromCharacter(p22) or getDecoyOwner(p22)

		if v211 then
			if isEnemyRelativeToLocal(v211) then
				v210.FillColor = color32
				v210.OutlineColor = color32
				v210.FillTransparency = 0.2
				v210.OutlineTransparency = 0.04

				return
			end

			v210.FillColor = color3
			v210.OutlineColor = color3
			v210.FillTransparency = 0.35
			v210.OutlineTransparency = 0.08

			return
		end

		local matchSide = viewedPlayer.Player:GetAttribute("MatchSide")
		local v214

		if typeof(matchSide) == "string" and matchSide ~= "" then
			v214 = matchSide
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
			local u215: boolean = false

			if typeof(lobbySpectateMatchId) == "string" then
				u215 = lobbySpectateMatchId ~= ""
			end

			if u215 then
				local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

				v214 = if typeof(lobbySpectateTeam) == "string" and lobbySpectateTeam ~= "" then lobbySpectateTeam else nil
			else
				v214 = nil
			end
		end

		local matchSide3 = p22:GetAttribute("MatchSide")
		local u218: boolean = false

		if typeof(v214) == "string" then
			u218 = false

			if typeof(matchSide3) == "string" then
				u218 = v214 == matchSide3
			end
		end

		if not u218 then
			v210.FillColor = color32
			v210.OutlineColor = color32
			v210.FillTransparency = 0.2
			v210.OutlineTransparency = 0.04

			return
		end

		v210.FillColor = color3
		v210.OutlineColor = color3
		v210.FillTransparency = 0.35
		v210.OutlineTransparency = 0.08

		return
	end

	if not p22 then
		return
	end

	local v219 = t1[p22]

	if not v219 then
		return
	end

	local __XRayHighlight = v219.__XRayHighlight

	if not __XRayHighlight then
		return
	end

	v16:release(__XRayHighlight)
	v219.__XRayHighlight = nil

	if next(v219) == nil then
		t1[p22] = nil
	end
end
local function applyDecoyMatchHighlight(character)
	local player = getDecoyOwner(character)

	if not player then
		return
	end

	if player == LocalPlayer then
		return
	end

	local v223

	if LocalPlayer:GetAttribute("ReplayFreecam") == true then
		v223 = nil
	else
		local v224 = viewedPlayer.GetCharacter()

		v223 = if v224 and v224 ~= LocalPlayer.Character then v224 else nil
	end

	if v223 and v223 == player.Character then
		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v226 = if typeof(matchId) == "string" then matchId else nil
	local v227

	if v226 then
		v227 = v226
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		v227 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
	end

	local v229: boolean = false

	if v227 ~= nil and v227 ~= "PRACTICE" then
		local matchId8: any = LocalPlayer:GetAttribute("MatchId")
		local v231 = if typeof(matchId8) == "string" then matchId8 else nil
		local v232

		if v231 then
			v232 = v231
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v232 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
		end

		local matchId9 = player:GetAttribute("MatchId")

		v231 = if typeof(matchId9) == "string" then matchId9 else nil

		local v235: boolean = false

		if v232 and v231 and v231 == v232 then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if not humanoid or not (humanoid.Health <= 0) then
				local v237 = isEnemyRelativeToLocal(player)
				local v238 = ensureHighlight(character, "__MatchTeamHighlight", Enum.HighlightDepthMode.Occluded)

				if not v238 then
					return
				end

				if v237 then
					v238.FillColor = color32
					v238.OutlineColor = color32
					v238.FillTransparency = 0.75
					v238.OutlineTransparency = 0.4

					return
				end

				v238.FillColor = color3
				v238.OutlineColor = color3
				v238.FillTransparency = 0.9
				v238.OutlineTransparency = 0.6

				return
			end

			v235 = true
		end

		v229 = true
	end

	if not character then
		return
	end

	local v239 = t1[character]

	if not v239 then
		return
	end

	local __MatchTeamHighlight = v239.__MatchTeamHighlight

	if not __MatchTeamHighlight then
		return
	end

	v16:release(__MatchTeamHighlight)
	v239.__MatchTeamHighlight = nil

	if next(v239) == nil then
		t1[character] = nil
	end
end
local function refreshXRayAllCharacters()
	if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
		for _, v in ipairs(players:GetPlayers()) do
			if v ~= LocalPlayer and v.Character then
				local Character = v.Character

				if Character then
					local v244 = t1[Character]

					if v244 then
						local __MatchTeamHighlight = v244.__MatchTeamHighlight

						if __MatchTeamHighlight then
							v16:release(__MatchTeamHighlight)
							v244.__MatchTeamHighlight = nil

							if next(v244) == nil then
								t1[Character] = nil
							end
						end
					end
				end

				applyAllyHeadFor(v)
			end
		end

		for _, v in ipairs(characters:GetChildren()) do
			if v:IsA("Model") and v:IsDescendantOf(game) then
				if v then
					local v248 = t1[v]

					if v248 then
						local v249 = v248.__MatchTeamHighlight

						if v249 then
							v16:release(v249)
							v248.__MatchTeamHighlight = nil

							if next(v248) == nil then
								t1[v] = nil
							end
						end
					end
				end

				applyXRayHighlightForCharacter(v)
			end
		end

		return
	end

	for _, v in ipairs(characters:GetChildren()) do
		if v:IsA("Model") and v:IsDescendantOf(game) then
			if v then
				local v252 = t1[v]

				if v252 then
					local __XRayHighlight = v252.__XRayHighlight

					if __XRayHighlight then
						v16:release(__XRayHighlight)
						v252.__XRayHighlight = nil

						if next(v252) == nil then
							t1[v] = nil
						end
					end
				end
			end

			if getDecoyOwner(v) then
				applyDecoyMatchHighlight(v)
			end
		end
	end

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer then
			applyMatchHighlightFor(v)
		end
	end

	for _, v in ipairs(characters:GetChildren()) do
		if v:IsA("Model") and v:GetAttribute("BotMatchBot") == true then
			applyMatchHighlightForBot(v)
		end
	end
end
local function applySelfHighlight()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local v259: boolean = false

	if LocalPlayer:GetAttribute("FrostGunActive") ~= true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v261 = if typeof(matchId) == "string" then matchId else nil
		local v262

		if v261 then
			v262 = v261
		else
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

			v262 = if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then lobbySpectateMatchId else nil
		end

		if v262 then
			local v264 = ensureHighlight(Character, "__SelfHighlight", Enum.HighlightDepthMode.AlwaysOnTop)

			if not v264 then
				return
			end

			v264.FillColor = color33
			v264.OutlineColor = color33
			v264.FillTransparency = 0.98
			v264.OutlineTransparency = 0.9

			return
		end

		v259 = true
	end

	if not Character then
		return
	end

	local v265 = t1[Character]

	if not v265 then
		return
	end

	local __SelfHighlight = v265.__SelfHighlight

	if not __SelfHighlight then
		return
	end

	v17:release(__SelfHighlight)
	v265.__SelfHighlight = nil

	if next(v265) == nil then
		t1[Character] = nil
	end
end

local t2: {[any]: any} = {}

local function disconnectState(p24)
	local v268 = t2[p24]

	if not v268 then
		return
	end

	if v268.charConn then
		v268.charConn:Disconnect()
	end

	if v268.teamConn then
		v268.teamConn:Disconnect()
	end

	if v268.attrConn then
		v268.attrConn:Disconnect()
	end

	if v268.sideConn then
		v268.sideConn:Disconnect()
	end

	if v268.diedConn then
		v268.diedConn:Disconnect()
	end

	t2[p24] = nil
end
local function hookPlayerCharacter(p25, character)
	local v271 = t2[p25]

	if v271 and v271.prevChar and character ~= v271.prevChar then
		local prevChar = v271.prevChar

		if prevChar then
			local v273 = t1[prevChar]

			if v273 then
				local __MatchTeamHighlight = v273.__MatchTeamHighlight

				if __MatchTeamHighlight then
					v16:release(__MatchTeamHighlight)
					v273.__MatchTeamHighlight = nil

					if next(v273) == nil then
						t1[prevChar] = nil
					end
				end
			end

			if prevChar then
				local v275 = t1[prevChar]

				if v275 then
					local __XRayHighlight = v275.__XRayHighlight

					if __XRayHighlight then
						v16:release(__XRayHighlight)
						v275.__XRayHighlight = nil

						if next(v275) == nil then
							t1[prevChar] = nil
						end
					end
				end
			end

			if prevChar then
				local v277 = t1[prevChar]

				if v277 then
					local __SelfHighlight = v277.__SelfHighlight

					if __SelfHighlight then
						v17:release(__SelfHighlight)
						v277.__SelfHighlight = nil

						if next(v277) == nil then
							t1[prevChar] = nil
						end
					end
				end
			end

			removeAllyHead(prevChar)
		end
	end

	if v271 then
		v271.prevChar = character
	end

	if character then
		local v279 = t1[character]

		if v279 then
			local v280 = v279.__MatchTeamHighlight

			if v280 then
				v16:release(v280)
				v279.__MatchTeamHighlight = nil

				if next(v279) == nil then
					t1[character] = nil
				end
			end
		end

		if character then
			local v281 = t1[character]

			if v281 then
				local v282 = v281.__XRayHighlight

				if v282 then
					v16:release(v282)
					v281.__XRayHighlight = nil

					if next(v281) == nil then
						t1[character] = nil
					end
				end
			end
		end

		if character then
			local v283 = t1[character]

			if v283 then
				local v284 = v283.__SelfHighlight

				if v284 then
					v17:release(v284)
					v283.__SelfHighlight = nil

					if next(v283) == nil then
						t1[character] = nil
					end
				end
			end
		end

		removeAllyHead(character)
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		if v271 and v271.diedConn then
			v271.diedConn:Disconnect()
		end

		if v271 then
			v271.diedConn = humanoid.Died:Connect(function()
				local v382 = character

				if not v382 then
					return
				end

				local v383 = t1[v382]

				if v383 then
					local __MatchTeamHighlight = v383.__MatchTeamHighlight

					if __MatchTeamHighlight then
						v16:release(__MatchTeamHighlight)
						v383.__MatchTeamHighlight = nil

						if next(v383) == nil then
							t1[v382] = nil
						end
					end
				end

				if v382 then
					local v385 = t1[v382]

					if v385 then
						local __XRayHighlight = v385.__XRayHighlight

						if __XRayHighlight then
							v16:release(__XRayHighlight)
							v385.__XRayHighlight = nil

							if next(v385) == nil then
								t1[v382] = nil
							end
						end
					end
				end

				if v382 then
					local v387 = t1[v382]

					if v387 then
						local __SelfHighlight = v387.__SelfHighlight

						if __SelfHighlight then
							v17:release(__SelfHighlight)
							v387.__SelfHighlight = nil

							if next(v387) == nil then
								t1[v382] = nil
							end
						end
					end
				end

				removeAllyHead(v382)
			end)
		end
	end

	if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
		applyXRayHighlightForCharacter(character)

		return
	end

	applyMatchHighlightFor(p25)
end
local function refreshForPlayer(player)
	if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
		applyAllyHeadFor(player)

		local Character = player.Character

		if Character then
			applyXRayHighlightForCharacter(Character)

			return
		end
	else
		applyMatchHighlightFor(player)
	end
end
local function trackPlayer(player)
	if player == LocalPlayer then
		return
	end

	local t4: {[any]: any} = {}

	t2[player] = t4
	t4.teamConn = player:GetPropertyChangedSignal("Team"):Connect(function()
		local v389 = player

		if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
			applyAllyHeadFor(v389)

			local Character = v389.Character

			if Character then
				applyXRayHighlightForCharacter(Character)

				return
			end
		else
			applyMatchHighlightFor(v389)
		end
	end)
	t4.attrConn = player:GetAttributeChangedSignal("MatchId"):Connect(function()
		local v391 = player

		if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
			applyAllyHeadFor(v391)

			local Character = v391.Character

			if Character then
				applyXRayHighlightForCharacter(Character)

				return
			end
		else
			applyMatchHighlightFor(v391)
		end
	end)
	t4.sideConn = player:GetAttributeChangedSignal("MatchSide"):Connect(function()
		local v393 = player

		if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
			applyAllyHeadFor(v393)

			local Character = v393.Character

			if Character then
				applyXRayHighlightForCharacter(Character)

				return
			end
		else
			applyMatchHighlightFor(v393)
		end
	end)
	t4.charConn = player.CharacterAdded:Connect(function(p29)
		hookPlayerCharacter(player, p29)
	end)

	if player.Character then
		hookPlayerCharacter(player, player.Character)
	end
end
local function refreshAllMatch()
	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer then
			applyMatchHighlightFor(v)
		end
	end
end

refreshAllMatch = function()
	refreshXRayAllCharacters()
	applySelfHighlight()
end

local function v53()
	print("========== HIGHLIGHT DIAGNOSTIC (" .. LocalPlayer.Name .. ") ==========")

	local stringFormat = string.format
	local localPlayerName: string = LocalPlayer.Name
	local text: string = tostring(LocalPlayer:GetAttribute("MatchId"))
	local text2: string = tostring(LocalPlayer.Team and LocalPlayer.Team.Name or "nil")
	local text3: string = tostring(LocalPlayer:GetAttribute("Spectating"))
	local text4: string = tostring(LocalPlayer:GetAttribute("XRay"))

	print(stringFormat("LocalPlayer=%s  MatchId=%s  Team=%s  Spectating=%s  XRay=%s", localPlayerName, text, text2, text3, text4))
	print("--- Pools ---")

	local v298 = string.format
	local httpService: HttpService = game:GetService("HttpService")

	print(v298("PlayerHL: %s", httpService:JSONEncode(v16:stats())))

	local v300 = string.format
	local httpService2: HttpService = game:GetService("HttpService")

	print(v300("SelfHL:   %s", httpService2:JSONEncode(v17:stats())))
	print("--- _charState entries ---")

	local n1: number = 0

	for k, v in pairs(t1) do
		n1 += 1

		local t5: {[any]: any} = {}

		for k2, iterValue in pairs(v) do
			local v308 = string.format
			local v309 = iterValue.Adornee and iterValue.Adornee:GetFullName() or "nil"
			local text5: string = tostring(v309)
			local text6: string = tostring(iterValue.Enabled)
			local v312 = iterValue.FillTransparency
			local v313 = iterValue.OutlineTransparency
			local v314 = iterValue.Parent and iterValue.Parent:GetFullName() or "nil"
			local text7: string = tostring(v314)

			table.insert(t5, v308("%s->Highlight{Adornee=%s, Enabled=%s, fillT=%.2f, outlineT=%.2f, parent=%s}", k2, text5, text6, v312, v313, text7))
		end

		local v316 = string.format
		local kName = k.Name
		local v318 = k.Parent and k.Parent:GetFullName() or "nil"
		local text8: string = tostring(v318)
		local text9: string = tostring(k:IsDescendantOf(workspace))

		print(v316("  [%d] char=%s (parent=%s, descOfWorkspace=%s): %s", n1, kName, text8, text9, table.concat(t5, "; ")))
	end

	if n1 == 0 then
		print("  (empty)")
	end

	print("--- ALL Highlights in DataModel ---")
	n1 = 0

	local n2: number = 0

	for iterFirst, iterSecond in game:GetDescendants() do
		if iterSecond:IsA("Highlight") then
			n1 += 1

			local adornee = iterSecond.Adornee
			local v325 = adornee and adornee:IsDescendantOf(workspace)
			local v326 = adornee or iterSecond.Parent
			local v327 = iterSecond.Enabled and v326 and v326:IsDescendantOf(workspace)

			if v327 then
				v327 = true

				if not (iterSecond.FillTransparency < 1) then
					v327 = iterSecond.OutlineTransparency < 1
				end
			end

			if v327 then
				n2 += 1
			end

			local v328 = string.format
			local v329 = iterSecond.Name
			local v330 = iterSecond.Parent and iterSecond.Parent:GetFullName() or "nil"
			local text10: string = tostring(v330)
			local v332 = adornee and adornee:GetFullName() or "nil"
			local text11: string = tostring(v332)
			local text12: string = tostring(v325)
			local text13: string = tostring(iterSecond.Enabled)
			local fillTransparency = iterSecond.FillTransparency
			local outlineTransparency = iterSecond.OutlineTransparency
			local text14: string = tostring(iterSecond.DepthMode)
			local text15: string = tostring(v327)

			print(v328("  H[%d] %s | parent=%s | adornee=%s (inWS=%s) | enabled=%s fillT=%.2f outlineT=%.2f depth=%s | wouldRender=%s", n1, v329, text10, text11, text12, text13, fillTransparency, outlineTransparency, text14, text15))
		end
	end

	print(string.format("--- Total Highlights: %d | Estimated visible: %d ---", n1, n2))
	print("--- Players & their characters ---")

	for _, v in pairs(players:GetPlayers()) do
		local Character = v.Character
		local v343 = string.format
		local vName = v.Name
		local text16: string = tostring(v:GetAttribute("MatchId"))
		local text17: string = tostring(v.Team and v.Team.Name or "nil")
		local v347 = Character and Character:GetFullName() or "nil"
		local text18: string = tostring(v347)
		local v349 = Character and Character.Parent and Character.Parent:GetFullName() or "nil"
		local text19: string = tostring(v349)

		print(v343("  Player=%s MatchId=%s Team=%s Character=%s (parent=%s)", vName, text16, text17, text18, text19))
	end

	print("--- workspace.Characters children ---")

	for _, v in pairs(characters:GetChildren()) do
		print(string.format("  %s (%s)", v.Name, v.ClassName))
	end

	print("========== END DIAGNOSTIC (" .. LocalPlayer.Name .. ") ==========")
end

LocalPlayer:GetAttributeChangedSignal("DumpHL"):Connect(function()
	pcall(v53)
end)
LocalPlayer.CharacterAdded:Connect(function(character: Model)
	if LocalPlayer:GetAttribute("FrostGunActive") ~= nil then
		LocalPlayer:SetAttribute("FrostGunActive", nil)
	end

	task.defer(applySelfHighlight)
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("MatchSide"):Connect(refreshAllMatch)
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("XRay"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("ReplayXRay"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("ReplayFreecam"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateTeam"):Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshAllMatch)
viewedPlayer.Changed:Connect(refreshAllMatch)
LocalPlayer:GetAttributeChangedSignal("FrostGunActive"):Connect(applySelfHighlight)
players.PlayerAdded:Connect(trackPlayer)
players.PlayerRemoving:Connect(function(player: Player)
	if player ~= LocalPlayer then
		local Character: Model = player.Character

		if Character then
			local v356 = t1[Character]

			if v356 then
				local __MatchTeamHighlight = v356.__MatchTeamHighlight

				if __MatchTeamHighlight then
					v16:release(__MatchTeamHighlight)
					v356.__MatchTeamHighlight = nil

					if next(v356) == nil then
						t1[Character] = nil
					end
				end
			end

			if Character then
				local v358 = t1[Character]

				if v358 then
					local __XRayHighlight = v358.__XRayHighlight

					if __XRayHighlight then
						v16:release(__XRayHighlight)
						v358.__XRayHighlight = nil

						if next(v358) == nil then
							t1[Character] = nil
						end
					end
				end
			end

			if Character then
				local v360 = t1[Character]

				if v360 then
					local __SelfHighlight = v360.__SelfHighlight

					if __SelfHighlight then
						v17:release(__SelfHighlight)
						v360.__SelfHighlight = nil

						if next(v360) == nil then
							t1[Character] = nil
						end
					end
				end
			end

			removeAllyHead(Character)
		end

		disconnectState(player)
	end
end)

for _, v in ipairs(players:GetPlayers()) do
	trackPlayer(v)
end

characters.ChildAdded:Connect(function(character: Instance)
	if not character:IsA("Model") then
		return
	end

	if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
		applyXRayHighlightForCharacter(character)
	elseif getDecoyOwner(character) then
		applyDecoyMatchHighlight(character)
	elseif character:GetAttribute("BotMatchBot") == true then
		applyMatchHighlightForBot(character)
	end

	local humanoid: Instance = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Died:Connect(function()
			local v396: Instance = character

			if not v396 then
				return
			end

			local v397 = t1[v396]

			if v397 then
				local __MatchTeamHighlight = v397.__MatchTeamHighlight

				if __MatchTeamHighlight then
					v16:release(__MatchTeamHighlight)
					v397.__MatchTeamHighlight = nil

					if next(v397) == nil then
						t1[v396] = nil
					end
				end
			end

			if v396 then
				local v399 = t1[v396]

				if v399 then
					local __XRayHighlight = v399.__XRayHighlight

					if __XRayHighlight then
						v16:release(__XRayHighlight)
						v399.__XRayHighlight = nil

						if next(v399) == nil then
							t1[v396] = nil
						end
					end
				end
			end

			if v396 then
				local v401 = t1[v396]

				if v401 then
					local __SelfHighlight = v401.__SelfHighlight

					if __SelfHighlight then
						v17:release(__SelfHighlight)
						v401.__SelfHighlight = nil

						if next(v401) == nil then
							t1[v396] = nil
						end
					end
				end
			end

			removeAllyHead(v396)
		end)
	end
end)
characters.ChildRemoved:Connect(function(character: Instance)
	if not character:IsA("Model") then
		return
	end

	if not character then
		return
	end

	local v365 = t1[character]

	if v365 then
		local __MatchTeamHighlight = v365.__MatchTeamHighlight

		if __MatchTeamHighlight then
			v16:release(__MatchTeamHighlight)
			v365.__MatchTeamHighlight = nil

			if next(v365) == nil then
				t1[character] = nil
			end
		end
	end

	if character then
		local v367 = t1[character]

		if v367 then
			local __XRayHighlight = v367.__XRayHighlight

			if __XRayHighlight then
				v16:release(__XRayHighlight)
				v367.__XRayHighlight = nil

				if next(v367) == nil then
					t1[character] = nil
				end
			end
		end
	end

	if character then
		local v369 = t1[character]

		if v369 then
			local __SelfHighlight = v369.__SelfHighlight

			if __SelfHighlight then
				v17:release(__SelfHighlight)
				v369.__SelfHighlight = nil

				if next(v369) == nil then
					t1[character] = nil
				end
			end
		end
	end

	removeAllyHead(character)
end)
task.spawn(function()
	while true do
		local v371: boolean = false

		if if LocalPlayer:GetAttribute("XRay") == true then true else LocalPlayer:GetAttribute("ReplayXRay") == true then
			for _, v in ipairs(characters:GetChildren()) do
				if v:IsA("Model") and v:IsDescendantOf(game) then
					applyXRayHighlightForCharacter(v)
				end
			end
		else
			if playerState.ReplayActive then
				for _, v in ipairs(characters:GetChildren()) do
					if v:IsA("Model") and v:IsDescendantOf(game) and v:GetAttribute("BotMatchBot") == true then
						applyMatchHighlightForBot(v)
					end
				end
			end
		end

		v371 = true

		if v371 then
			task.wait(0.25)
		end
	end
end)
task.spawn(function()
	while true do
		task.wait(2)

		local n1: number = 0

		for k, v in pairs(t1) do
			if not k:IsDescendantOf(workspace) then
				for k3, iterValue in pairs(v) do
					(if k3 == "__SelfHighlight" then v17 else v16):release(iterValue)
				end

				t1[k] = nil
				n1 += 1
			end
		end

		local v381: boolean = n1 > 0
	end
end)
refreshXRayAllCharacters()
applySelfHighlight()
