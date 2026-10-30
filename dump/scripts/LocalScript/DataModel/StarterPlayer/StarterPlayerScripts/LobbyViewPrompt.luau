-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local runService: RunService = game:GetService("RunService")
local requestPlayerCard: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("RequestPlayerCard")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local inspectHUD: Instance = playerGui:WaitForChild("InspectHUD")
local winScreen: Instance = playerGui:WaitForChild("WinScreen")
local lobby: Instance = workspace:WaitForChild("Lobby")
local t1: {[any]: any} = {}
local inspectHUDEnabled = inspectHUD.Enabled
local winScreenEnabled = winScreen.Enabled
local u14: boolean = LocalPlayer:GetAttribute("WatchingReplay") == true
local n1 = 0

local function isPlayerPrompt(p1)
	return p1.Name == "ViewPlayerPrompt"
end
local function isInLobby(p2)
	return p2:GetAttribute("MatchId") == nil
end

local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local u21: boolean = false

local function setPlateHidden(_, p4, p5)
	if p5 == p4.hidden then
		return
	end

	p4.hidden = p5
	p4.gui.PlayerToHideFrom = p5 and LocalPlayer or nil
end
local function registerPlate(p6, p7)
	local t9: {[any]: any} = {
		gui = p7,
		hidden = if p7.PlayerToHideFrom == nil then false else true
	}

	t4[p6] = t9
	p7.AncestryChanged:Connect(function(_, p9)
		if not p9 and t4[p6] == t9 then
			t4[p6] = nil
		end
	end)
end
local function watchPlayerPlates(player)
	local connection = nil

	local function hookChar(p11)
		if connection then
			connection:Disconnect()
		end

		t4[player] = nil

		local overhead = p11:FindFirstChild("OVERHEAD")

		if overhead and overhead:IsA("BillboardGui") then
			registerPlate(player, overhead)
		end

		connection = p11.ChildAdded:Connect(function(p12)
			if p12:IsA("BillboardGui") and p12.Name == "OVERHEAD" then
				registerPlate(player, p12)
			end
		end)
	end

	if player.Character then
		hookChar(player.Character)
	end

	player.CharacterAdded:Connect(hookChar)
	player.CharacterRemoving:Connect(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		t4[player] = nil
	end)
end
local function rebuildStaticPrompts()
	table.clear(t2)

	for _, v in ipairs(lobby:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Name ~= "ViewPlayerPrompt" then
			table.insert(t2, v)
		end
	end
end
local function setPlayerPromptsEnabled(enabled)
	for _, v in ipairs(players:GetPlayers()) do
		local Character = v.Character

		if Character then
			local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local viewPlayerPrompt = humanoidRootPart and humanoidRootPart:FindFirstChild("ViewPlayerPrompt")

			if viewPlayerPrompt and viewPlayerPrompt:IsA("ProximityPrompt") then
				viewPlayerPrompt.Enabled = enabled
			end
		end
	end
end
local function refreshVisibility()
	local u66: boolean = false

	for _, v in pairs(t1) do
		if v then
			u66 = true

			break
		end
	end

	local enabled: boolean = not winScreenEnabled and not inspectHUDEnabled and not u66 and not u14

	proximityPromptService.Enabled = enabled
	setPlayerPromptsEnabled(enabled and n1 == 0)
end

proximityPromptService.PromptShown:Connect(function(prompt: ProximityPrompt)
	if prompt.Name == "ViewPlayerPrompt" then
		return
	end

	n1 += 1
	refreshVisibility()
end)
proximityPromptService.PromptHidden:Connect(function(prompt: ProximityPrompt)
	if prompt.Name == "ViewPlayerPrompt" then
		return
	end

	n1 = math.max(0, n1 - 1)
	refreshVisibility()
end)
inspectHUD:GetPropertyChangedSignal("Enabled"):Connect(function()
	inspectHUDEnabled = inspectHUD.Enabled
	refreshVisibility()
end)
winScreen:GetPropertyChangedSignal("Enabled"):Connect(function()
	winScreenEnabled = winScreen.Enabled
	refreshVisibility()
end)
LocalPlayer:GetAttributeChangedSignal("WatchingReplay"):Connect(function()
	u14 = LocalPlayer:GetAttribute("WatchingReplay") == true
	refreshVisibility()
end)

local children = playerGui:WaitForChild("HUD"):GetChildren()
local effects: Instance = playerGui:WaitForChild("HUD"):WaitForChild("Effects")

table.insert(children, effects:WaitForChild("EffectsWindow"))

for _, v in pairs(children) do
	if v.Name:match("Window") or v.Name:match("Background") or v.Name:match("PlayerCard") or v.Name == "Spectating" or v.Name == "Trading" then
		if v:IsA("GuiObject") then
			t1[v.Name] = v.Visible
		end

		v:GetPropertyChangedSignal("Visible"):Connect(function()
			t1[v.Name] = v.Visible
			refreshVisibility()
		end)
	end
end

local t5: {[any]: any} = {}
local t6: {[any]: any} = {}
local t7: {[any]: any} = {}
local t8: {[any]: any} = {}

local function scanOverheads()
	if LocalPlayer:GetAttribute("MatchId") ~= nil then
		if u21 then
			u21 = false

			for _, v in pairs(t4) do
				if v.gui.Parent and v.hidden ~= false then
					v.hidden = false
					v.gui.PlayerToHideFrom = nil
				end
			end

			table.clear(t4)
		end

		return
	end

	u21 = true

	local n1: number = 0

	for k, v in pairs(t4) do
		local Character = k.Character
		local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
			n1 += 1
			t5[n1] = k
			t6[n1] = humanoidRootPart.Position
			t7[n1] = v
			t8[n1] = false
		end
	end

	if n1 == 0 then
		return
	end

	for i = 1, n1 do
		local v80 = t6[i]

		for _, v in ipairs(t2) do
			if v.Enabled and v.Parent and v.Parent:IsA("BasePart") and (v.Parent.Position - v80):Dot(v.Parent.Position - v80) <= math.min(8, v.MaxActivationDistance - 0.5) * math.min(8, v.MaxActivationDistance - 0.5) then
				t8[i] = true

				break
			end
		end

		if not t8[i] then
			for _, v in ipairs(t3) do
				local n2 = v.Position - v80

				if n2:Dot(n2) <= 156.25 then
					t8[i] = true

					break
				end
			end
		end
	end

	for i = 1, n1 do
		local v87 = t5[i]
		local v88 = t7[i]
		local v89 = t8[i]

		if v88.hidden ~= v89 then
			v88.hidden = v89
			v88.gui.PlayerToHideFrom = v89 and LocalPlayer or nil
		end

		t5[i] = nil
		t7[i] = nil
	end
end

rebuildStaticPrompts();
(function()
	table.clear(t3)

	local leaderboards: Instance = lobby:FindFirstChild("Leaderboards")

	if not leaderboards then
		return
	end

	for _, v in ipairs(leaderboards:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(t3, v)
		end
	end
end)()
lobby.DescendantAdded:Connect(function(p16: Instance)
	if p16:IsA("ProximityPrompt") and p16.Name ~= "ViewPlayerPrompt" then
		rebuildStaticPrompts()
	end
end)
lobby.DescendantRemoving:Connect(function(p17: Instance)
	if p17:IsA("ProximityPrompt") and p17.Name ~= "ViewPlayerPrompt" then
		rebuildStaticPrompts()
	end
end)
players.PlayerRemoving:Connect(function(player: Player)
	t4[player] = nil
end)

local n2: number = 0

runService.Heartbeat:Connect(function(deltaTime: number)
	n2 += deltaTime

	if n2 < 0.1 then
		return
	end

	n2 = 0
	scanOverheads()
end)
refreshVisibility()
scanOverheads()

local function getHumanoidRootPart(p20)
	local humanoidRootPart = p20:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		return humanoidRootPart
	end

	return nil
end
local function removePrompt(p21)
	local humanoidRootPart = p21:FindFirstChild("HumanoidRootPart")
	local v101 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

	if not v101 then
		return
	end

	local viewPlayerPrompt = v101:FindFirstChild("ViewPlayerPrompt")

	if viewPlayerPrompt then
		viewPlayerPrompt:Destroy()
	end
end
local function ensurePrompt(p22, p23)
	local humanoidRootPart = p23:FindFirstChild("HumanoidRootPart")
	local parent = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

	if not parent then
		return
	end

	local viewPlayerPrompt = parent:FindFirstChild("ViewPlayerPrompt")

	if viewPlayerPrompt and viewPlayerPrompt:IsA("ProximityPrompt") then
		return
	end

	local viewPlayerPrompt: ProximityPrompt = Instance.new("ProximityPrompt")

	viewPlayerPrompt.Name = "ViewPlayerPrompt"
	viewPlayerPrompt.ActionText = "View"
	viewPlayerPrompt.ObjectText = p22.DisplayName
	viewPlayerPrompt.HoldDuration = 0
	viewPlayerPrompt.MaxActivationDistance = 6
	viewPlayerPrompt.RequiresLineOfSight = false
	viewPlayerPrompt.Enabled = proximityPromptService.Enabled and n1 == 0
	viewPlayerPrompt.Parent = parent
	viewPlayerPrompt.Triggered:Connect(function(playerWhoTriggered: Player)
		if not p22.Parent or not playerWhoTriggered.Parent then
			return
		end

		if p22:GetAttribute("MatchId") ~= nil then
			return
		end

		if playerWhoTriggered:GetAttribute("MatchId") ~= nil then
			return
		end

		requestPlayerCard:Fire(p22)
	end)
end
local function refreshForPlayer(player)
	local Character = player.Character

	if not Character then
		return
	end

	if player:GetAttribute("MatchId") == nil then
		ensurePrompt(player, Character)

		return
	end

	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local v112 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

	if not v112 then
		return
	end

	local viewPlayerPrompt = v112:FindFirstChild("ViewPlayerPrompt")

	if viewPlayerPrompt then
		viewPlayerPrompt:Destroy()
	end
end
local function hookPlayer(player)
	if player == players.LocalPlayer then
		return
	end

	player.CharacterAdded:Connect(function(_)
		task.defer(function()
			local v136 = player
			local Character = v136.Character

			if not Character then
				return
			end

			if v136:GetAttribute("MatchId") == nil then
				ensurePrompt(v136, Character)

				return
			end

			local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local v139 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

			if not v139 then
				return
			end

			local viewPlayerPrompt = v139:FindFirstChild("ViewPlayerPrompt")

			if viewPlayerPrompt then
				viewPlayerPrompt:Destroy()
			end
		end)
	end)
	player:GetAttributeChangedSignal("MatchId"):Connect(function()
		local v130 = player
		local Character = v130.Character

		if not Character then
			return
		end

		if v130:GetAttribute("MatchId") == nil then
			ensurePrompt(v130, Character)

			return
		end

		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local v133 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

		if not v133 then
			return
		end

		local viewPlayerPrompt = v133:FindFirstChild("ViewPlayerPrompt")

		if viewPlayerPrompt then
			viewPlayerPrompt:Destroy()
		end
	end)

	if player.Character then
		local Character = player.Character

		if not Character then
			return
		end

		if player:GetAttribute("MatchId") == nil then
			ensurePrompt(player, Character)

			return
		end

		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local v117 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

		if not v117 then
			return
		end

		local viewPlayerPrompt = v117:FindFirstChild("ViewPlayerPrompt")

		if viewPlayerPrompt then
			viewPlayerPrompt:Destroy()
		end

		return
	end
end

for _, v in ipairs(players:GetPlayers()) do
	hookPlayer(v)
end

players.PlayerAdded:Connect(hookPlayer)

for _, v in ipairs(players:GetPlayers()) do
	watchPlayerPlates(v)
end

players.PlayerAdded:Connect(watchPlayerPlates)
players.PlayerRemoving:Connect(function(player: Player)
	local Character: Model = player.Character

	if Character then
		local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")
		local v122 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

		if not v122 then
			return
		end

		local viewPlayerPrompt = v122:FindFirstChild("ViewPlayerPrompt")

		if viewPlayerPrompt then
			viewPlayerPrompt:Destroy()
		end

		return
	end
end)
