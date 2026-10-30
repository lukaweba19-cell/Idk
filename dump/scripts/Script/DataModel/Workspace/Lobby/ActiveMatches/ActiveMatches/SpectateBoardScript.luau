-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local httpService: HttpService = game:GetService("HttpService")
local LocalPlayer: Player = players.LocalPlayer
local activeMatches: Instance = replicatedStorage:WaitForChild("ActiveMatches")
local t1: {[any]: any} = { "TeamA", "Team1", "A", "PlayersA", "AliveA", "QueueA" }
local t2: {[any]: any} = { "TeamB", "Team2", "B", "PlayersB", "AliveB", "QueueB" }
local t3: {[any]: any} = { "TeamSize", "TeamCount", "Size", "Mode" }
local spectate: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Spectate")
local surfaceGui: Instance = script.Parent:WaitForChild("SurfaceGui")
local scrollingFrame: Instance = surfaceGui:WaitForChild("ScrollingFrame")
local matchTemplate: Instance = scrollingFrame:WaitForChild("MatchTemplate")

matchTemplate.Visible = false
matchTemplate.Parent = surfaceGui

local function decodeIds(p1)
	if typeof(p1) == "string" and p1 ~= "" then
		local ok, result = pcall(function()
			return httpService:JSONDecode(p1)
		end)

		if ok and typeof(result) == "table" then
			local t5: {[any]: any} = {}

			for _, v in ipairs(result) do
				if typeof(v) == "number" then
					local floored = math.floor(v)

					table.insert(t5, floored)
				end
			end

			return t5
		end

		return {}
	end

	return {}
end
local function firstAttrString(p2, p3)
	for _, v in ipairs(p3) do
		local attributeValue = p2:GetAttribute(v)

		if typeof(attributeValue) == "string" and attributeValue ~= "" then
			return attributeValue
		end
	end

	return nil
end
local function firstAttrNumber(p4, p5)
	for _, v in ipairs(p5) do
		local attributeValue = p4:GetAttribute(v)

		if typeof(attributeValue) == "number" then
			return attributeValue
		end
	end

	return nil
end
local function containsId(p6, p7)
	for _, v in ipairs(p6) do
		if v == p7 then
			return true
		end
	end

	return false
end

containsId = function(p8, p9, p10)
	local foundChild = p8:FindFirstChild(p9, true)

	if foundChild and p10 == foundChild.ClassName then
		return foundChild
	end

	return nil
end

local function findHeadshotImage(p11)
	local foundChild = p11:FindFirstChild("HeadShot", true)

	if foundChild and foundChild:IsA("ImageLabel") then
		return foundChild
	end

	local foundChild2 = p11:FindFirstChild("Headshot", true)

	if foundChild2 and foundChild2:IsA("ImageLabel") then
		return foundChild2
	end

	return nil
end
local function setText(p12, text)
	p12.Text = text

	for _, v in ipairs(p12:GetChildren()) do
		if v:IsA("TextLabel") then
			v.Text = text
		end
	end
end
local function setSlotUserId(p14, p15: number)
	local foundChild = p14:FindFirstChild("HeadShot", true)
	local v70

	if foundChild and foundChild:IsA("ImageLabel") then
		v70 = foundChild
	else
		local foundChild3 = p14:FindFirstChild("Headshot", true)

		v70 = if foundChild3 and foundChild3:IsA("ImageLabel") then foundChild3 else nil
	end

	if not v70 then
		return
	end

	if p15 and p15 < 0 then
		p15 = 1
	end

	if p15 and p15 > 0 then
		v70.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p15)

		return
	end

	v70.Image = "rbxassetid://127075876244307"
end
local function getPlayerTemplate(p16)
	for _, v in ipairs(p16:GetDescendants()) do
		if v:IsA("GuiObject") and v.Name == "Player" and v:GetAttribute("_IsPlayerSlotTemplate") == true then
			return v
		end
	end

	local v75 = nil

	for _, v in ipairs(p16:GetDescendants()) do
		if v:IsA("GuiObject") and v.Name == "Player" then
			v75 = v

			break
		end
	end

	if v75 then
		v75:SetAttribute("_IsPlayerSlotTemplate", true)
	end

	return v75
end
local function clearClonedPlayers(p17)
	for _, v in ipairs(p17:GetDescendants()) do
		if v:IsA("GuiObject") and v.Name == "Player" and v:GetAttribute("_IsPlayerSlotTemplate") ~= true then
			v:Destroy()
		end
	end
end
local function renderTeam(p18, p19, p20)
	local v84 = getPlayerTemplate(p18)

	if not v84 then
		warn(("renderTeam: missing Player template under %s"):format(p18:GetFullName()))

		return
	end

	v84.Visible = false
	clearClonedPlayers(p18)

	local parent = v84.Parent

	if not parent then
		return
	end

	for i = 1, p20 do
		local clone = v84:Clone()

		clone.Name = "Player"
		clone:SetAttribute("_IsPlayerSlotTemplate", nil)
		clone.Visible = true
		clone.Parent = parent

		local v88 = p19[i]
		local foundChild = clone:FindFirstChild("HeadShot", true)
		local v90

		if foundChild and foundChild:IsA("ImageLabel") then
			v90 = foundChild
		else
			local foundChild4 = clone:FindFirstChild("Headshot", true)

			v90 = if foundChild4 and foundChild4:IsA("ImageLabel") then foundChild4 else nil
		end

		if v90 then
			if v88 and v88 < 0 then
				v88 = 1
			end

			if v88 and v88 > 0 then
				v90.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(v88)
			else
				v90.Image = "rbxassetid://127075876244307"
			end
		end
	end
end
local function getTeams(p21)
	local v93 = firstAttrString(p21, t1)
	local v94 = firstAttrString(p21, t2)
	local v95 = decodeIds(v93)

	v93 = decodeIds(v94)
	v94 = firstAttrNumber(p21, t3)

	local v96

	if v94 and v94 > 0 then
		local floored = math.floor(v94)

		v96 = math.max(1, floored)
	else
		v96 = math.max(#v95, #v93, 1)
	end

	return v95, v93, v96
end
local function isAlivePlayer(player)
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
local function buildAliveCandidatesFromIds(p23)
	local t6: {[any]: any} = {}

	for _, v in ipairs(p23) do
		local player: Player = players:GetPlayerByUserId(v)

		if player then
			local Character: Model = player.Character
			local u107

			if not Character then
				u107 = false
			else
				local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")

				u107 = if not humanoid then false else humanoid.Health > 0
			end

			if u107 then
				table.insert(t6, player)
			end
		end
	end

	return t6
end

local random = Random.new()

local function startLobbySpectate(p24, p25, p26)
	local encodedJson: string = httpService:JSONEncode(p26)

	LocalPlayer:SetAttribute("LobbySpectateMatchId", p24.Name)
	LocalPlayer:SetAttribute("LobbySpectateTeam", p25)
	LocalPlayer:SetAttribute("LobbySpectateIds", encodedJson)

	local v113 = buildAliveCandidatesFromIds(p26)

	if #v113 == 0 then
		return nil
	end

	local v114 = random:NextInteger(1, #v113)
	local player = v113[v114]

	LocalPlayer:SetAttribute("LobbySpectateInitialPick", player.UserId)
	spectate:FireServer(player.UserId, { MatchId = p24.Name, Team = p25, Ids = encodedJson })

	return true
end

local t4: {[any]: any} = {}

local function destroyCard(p27)
	local v117 = t4[p27]

	if not v117 then
		return
	end

	if v117.SpecConn then
		v117.SpecConn:Disconnect()
	end

	if v117.Card then
		v117.Card:Destroy()
	end

	t4[p27] = nil
end
local function getOrCreateCard(p28)
	local v119 = t4[p28]

	if v119 and v119.Card and v119.Card.Parent then
		return v119
	end

	local clone: Instance = matchTemplate:Clone()

	clone.Name = "Match_" .. p28.Name
	clone.Visible = true
	clone.Parent = scrollingFrame

	local foundChild: Instance = clone:FindFirstChild("SpectateButton", true)
	local v122 = if foundChild and foundChild.ClassName == "TextButton" then foundChild else nil
	local connection = nil

	if v122 then
		connection = v122.MouseButton1Click:Connect(function()
			local v154, v155 = getTeams(p28)

			if not startLobbySpectate(p28, "A", v154) then
				startLobbySpectate(p28, "B", v155)
			end
		end)
	end

	v122 = { Card = clone, MatchInst = p28, SpecConn = connection }
	t4[p28] = v122

	return v122
end
local function renderMatch(p29)
	if not p29.Parent then
		local v125 = t4[p29]

		if not v125 then
			return
		end

		if v125.SpecConn then
			v125.SpecConn:Disconnect()
		end

		if v125.Card then
			v125.Card:Destroy()
		end

		t4[p29] = nil

		return
	end

	local v126, v127, v128 = getTeams(p29)

	if #v126 == 0 and #v127 == 0 then
		local v129 = t4[p29]

		if not v129 then
			return
		end

		if v129.SpecConn then
			v129.SpecConn:Disconnect()
		end

		if v129.Card then
			v129.Card:Destroy()
		end

		t4[p29] = nil

		return
	end

	local card = getOrCreateCard(p29).Card
	local foundChild = card:FindFirstChild("DuelType", true)
	local v132 = if foundChild and foundChild.ClassName == "TextLabel" then foundChild else nil

	if v132 then
		setText(v132, ("%dv%d"):format(v128, v128))
	end

	local background = card:FindFirstChild("Background")
	local mapID = p29:GetAttribute("MapID")

	if background and background:IsA("ImageLabel") and typeof(mapID) == "string" and mapID ~= "" then
		background.Image = mapID
	end

	local foundChild5 = card:FindFirstChild("Team1", true)
	local v136 = if foundChild5 and foundChild5.ClassName == "Frame" then foundChild5 else nil
	local foundChild6 = card:FindFirstChild("Team2", true)
	local v138 = if foundChild6 and foundChild6.ClassName == "Frame" then foundChild6 else nil

	if v136 and v138 then
		renderTeam(v136, v126, v128)
		renderTeam(v138, v127, v128)
	end
end
local function hookMatch(p30)
	task.spawn(function()
		repeat
			task.wait(0.1)
		until not p30:IsDescendantOf(game) or not not p30:GetAttribute("State") and p30:GetAttribute("State") ~= "Loading"

		if not p30:IsDescendantOf(game) then
			return
		end

		renderMatch(p30)

		for _, v in ipairs(t1) do
			p30:GetAttributeChangedSignal(v):Connect(function()
				renderMatch(v162)
			end)
		end

		for _, v in ipairs(t2) do
			p30:GetAttributeChangedSignal(v):Connect(function()
				renderMatch(v162)
			end)
		end

		for _, v in ipairs(t3) do
			p30:GetAttributeChangedSignal(v):Connect(function()
				renderMatch(v162)
			end)
		end

		p30:GetAttributeChangedSignal("MapID"):Connect(function()
			renderMatch(v162)
		end)
	end)
end

for _, v in ipairs(activeMatches:GetChildren()) do
	task.spawn(function()
		repeat
			task.wait(0.1)
		until not v:IsDescendantOf(game) or not not v:GetAttribute("State") and v:GetAttribute("State") ~= "Loading"

		if not v:IsDescendantOf(game) then
			return
		end

		renderMatch(v)

		for _, iterValue in ipairs(t1) do
			v:GetAttributeChangedSignal(iterValue):Connect(function()
				renderMatch(v162)
			end)
		end

		for _, iterValue2 in ipairs(t2) do
			v:GetAttributeChangedSignal(iterValue2):Connect(function()
				renderMatch(v162)
			end)
		end

		for _, iterValue3 in ipairs(t3) do
			v:GetAttributeChangedSignal(iterValue3):Connect(function()
				renderMatch(v162)
			end)
		end

		v:GetAttributeChangedSignal("MapID"):Connect(function()
			renderMatch(v162)
		end)
	end)
end

activeMatches.ChildAdded:Connect(function(p31: Instance)
	task.defer(function()
		local v162: Instance = p31

		task.spawn(function()
			repeat
				task.wait(0.1)
			until not v162:IsDescendantOf(game) or not not v162:GetAttribute("State") and v162:GetAttribute("State") ~= "Loading"

			if not v162:IsDescendantOf(game) then
				return
			end

			renderMatch(v162)

			for _, v in ipairs(t1) do
				v162:GetAttributeChangedSignal(v):Connect(function()
					renderMatch(v162)
				end)
			end

			for _, v in ipairs(t2) do
				v162:GetAttributeChangedSignal(v):Connect(function()
					renderMatch(v162)
				end)
			end

			for _, v in ipairs(t3) do
				v162:GetAttributeChangedSignal(v):Connect(function()
					renderMatch(v162)
				end)
			end

			v162:GetAttributeChangedSignal("MapID"):Connect(function()
				renderMatch(v162)
			end)
		end)
	end)
end)
activeMatches.ChildRemoved:Connect(function(p32: Instance)
	local v148 = t4[p32]

	if not v148 then
		return
	end

	if v148.SpecConn then
		v148.SpecConn:Disconnect()
	end

	if v148.Card then
		v148.Card:Destroy()
	end

	t4[p32] = nil
end);
(function()
	for k, _ in pairs(t4) do
		if k.Parent ~= activeMatches then
			local v151 = t4[k]

			if v151 then
				if v151.SpecConn then
					v151.SpecConn:Disconnect()
				end

				if v151.Card then
					v151.Card:Destroy()
				end

				t4[k] = nil
			end
		end
	end

	for _, v in ipairs(activeMatches:GetChildren()) do
		renderMatch(v)
	end
end)()
