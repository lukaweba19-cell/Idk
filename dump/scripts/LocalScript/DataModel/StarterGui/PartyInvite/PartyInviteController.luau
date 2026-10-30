-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local socialService: SocialService = game:GetService("SocialService")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent

scriptParent.Enabled = false

local shared: Instance = replicatedStorage:WaitForChild("Shared")

if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local panel: Instance = scriptParent:WaitForChild("Panel")
local invitesScrollingFrame: Instance = panel:WaitForChild("Content"):WaitForChild("InvitesScrollingFrame")
local closeButton: Instance = panel:WaitForChild("CloseButton")
local friends: Instance = panel:WaitForChild("Friends")
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(replicatedStorageShared:WaitForChild("WindowBlur"))
local windowSlide = require(replicatedStorageShared:WaitForChild("WindowSlide"))

local ok, result = pcall(function()
	return require(replicatedStorage:WaitForChild("Sound"))
end)

local physicalParties: Instance = replicatedStorageShared:WaitForChild("PartySystem"):WaitForChild("PhysicalParties")
local playerRequestSend: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerRequestSend")
local partyRemoteFunction: Instance = replicatedStorage:WaitForChild("PartyRemoteFunction")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local openPartyInvite: Instance = bindables:WaitForChild("OpenPartyInvite")

local function inviteTTL()
	return tonumber(playerRequestSend:GetAttribute("RequestTTL")) or 7.5
end
local function notifyError(p1)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p1 })
	end
end
local function notifySuccess(p2)
	if _G.Notify then
		_G.Notify({
			notifType = "SuccessNotification",
			topText = "Success!",
			bottomText = p2
		})
	end
end
local function membersFolderOf(p3)
	local members = p3:FindFirstChild("Members")

	if members and members:IsA("Folder") then
		return members
	end

	return nil
end
local function isPlayerInAnyParty(p4)
	for _, v in ipairs(physicalParties:GetChildren()) do
		if v.Name ~= "PartyTemplate" then
			local members = v:FindFirstChild("Members")
			local v74 = if members and members:IsA("Folder") then members else nil

			if v74 and v74:FindFirstChild(p4.Name) then
				return true
			end
		end
	end

	return false
end
local function myPartyInst()
	for _, v in ipairs(physicalParties:GetChildren()) do
		if v.Name ~= "PartyTemplate" then
			local members = v:FindFirstChild("Members")
			local v78 = if members and members:IsA("Folder") then members else nil

			if v78 and v78:FindFirstChild(LocalPlayer.Name) then
				return v
			end
		end
	end

	return nil
end
local function memberCount(p5)
	local n1: number = 0

	for _, v in ipairs(p5:GetChildren()) do
		if v:IsA("ObjectValue") then
			n1 += 1
		end
	end

	return n1
end
local function iAmPartyLeader()
	local v83 = myPartyInst()

	if not v83 then
		return false
	end

	local members = v83:FindFirstChild("Members")
	local v85 = if members and members:IsA("Folder") then members else nil

	if not v85 then
		return false
	end

	local LocalPlayerName = v85:FindFirstChild(LocalPlayer.Name)
	local u87 = false

	if LocalPlayerName ~= nil then
		u87 = LocalPlayerName:IsA("ObjectValue")

		if u87 then
			u87 = LocalPlayerName:GetAttribute("Leader") == true
		end
	end

	return u87
end
local function canLocalPartyInvite()
	local v88 = myPartyInst()

	if not v88 then
		return true
	end

	local members = v88:FindFirstChild("Members")
	local v90 = if members and members:IsA("Folder") then members else nil

	if not v90 then
		return true
	end

	if not iAmPartyLeader() then
		return false, "Only the party leader can invite."
	end

	if memberCount(v90) >= 4 then
		return false, "Your party is full."
	end

	return true
end
local function myPartyMembers()
	local t4: {[any]: any} = {}
	local v92 = myPartyInst()

	if not v92 then
		return t4
	end

	local members = v92:FindFirstChild("Members")
	local v94 = if members and members:IsA("Folder") then members else nil

	if not v94 then
		return t4
	end

	for _, v in ipairs(v94:GetChildren()) do
		if v:IsA("ObjectValue") and v.Name ~= LocalPlayer.Name then
			local vName: Instance = players:FindFirstChild(v.Name)

			if vName and vName:IsA("Player") then
				table.insert(t4, vName)
			end
		end
	end

	return t4
end
local function isInRealMatch(p6)
	if p6:GetAttribute("InMatch") == true then
		return p6:GetAttribute("MatchId") ~= "PRACTICE"
	end

	return false
end
local function isInvitable(p7)
	if p7 == LocalPlayer then
		return false
	end

	if if p7:GetAttribute("InMatch") == true then p7:GetAttribute("MatchId") ~= "PRACTICE" else false then
		return false
	end

	if isPlayerInAnyParty(p7) then
		return false
	end

	return true
end
local function grabTemplate(p8)
	local foundChild: Instance = invitesScrollingFrame:FindFirstChild(p8)

	if foundChild and foundChild:IsA("ImageButton") then
		foundChild.Visible = false

		return foundChild
	end

	return nil
end

local cell: Instance = invitesScrollingFrame:FindFirstChild("Cell")
local v36

if cell and cell:IsA("ImageButton") then
	cell.Visible = false
	v36 = cell
else
	v36 = nil
end

local cell_Party: Instance = invitesScrollingFrame:FindFirstChild("Cell_Party")
local v38

if cell_Party and cell_Party:IsA("ImageButton") then
	cell_Party.Visible = false
	v38 = cell_Party
else
	v38 = nil
end

if not v38 then
	local cell_Friend: Instance = invitesScrollingFrame:FindFirstChild("Cell_Friend")

	if cell_Friend and cell_Friend:IsA("ImageButton") then
		cell_Friend.Visible = false
		v38 = cell_Friend
	else
		v38 = nil
	end
end

local cell_Invited: Instance = invitesScrollingFrame:FindFirstChild("Cell_Invited")
local v41

if cell_Invited and cell_Invited:IsA("ImageButton") then
	cell_Invited.Visible = false
	v41 = cell_Invited
else
	v41 = nil
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local u44: boolean = false
local t3: {[any]: any} = {}
local n1: number = 0
local u47 = nil

local function clearRows()
	for _, v in ipairs(invitesScrollingFrame:GetChildren()) do
		if v:IsA("GuiObject") and v.Name:sub(1, 4) == "Row_" then
			v:Destroy()
		end
	end
end
local function ensureFriendCached(player)
	local userId = player.UserId

	if t2[userId] ~= nil then
		return
	end

	if userId <= 0 then
		t2[userId] = false

		return
	end

	local ok2, result2 = pcall(function()
		return LocalPlayer:IsFriendsWith(userId)
	end)

	t2[userId] = ok2 and result2 == true
end
local function setIdentity(p10, player, p12)
	local displayName = p10:FindFirstChild("DisplayName")

	if displayName and displayName:IsA("TextLabel") then
		displayName.Text = player.DisplayName
	end

	local v112 = p12 and p10:FindFirstChild("Username")

	if v112 and v112:IsA("TextLabel") then
		v112.Text = "@" .. player.Name
	end

	local imageLabel = p10:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)
	end
end

local u51 = nil

local function makeInvitedRow(player, layoutOrder)
	if not v41 then
		return nil
	end

	local clone = v41:Clone()

	clone.Name = "Row_" .. tostring(player.UserId)
	clone.LayoutOrder = layoutOrder
	clone.Visible = true
	clone.Active = true
	clone.Interactable = false
	clone.AutoButtonColor = false

	local displayName = clone:FindFirstChild("DisplayName")

	if displayName and displayName:IsA("TextLabel") then
		displayName.Text = player.DisplayName
	end

	local imageLabel = clone:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)
	end

	clone.Parent = invitesScrollingFrame

	return clone
end
local function makeNormalRow(player, layoutOrder)
	if not v36 then
		return nil
	end

	local clone = v36:Clone()

	clone.Name = "Row_" .. tostring(player.UserId)
	clone.LayoutOrder = layoutOrder
	clone.Visible = true
	clone.Active = true
	clone.Interactable = true
	setIdentity(clone, player, true)
	clone.Parent = invitesScrollingFrame
	clone.MouseButton1Click:Connect(function()
		if t1[player.UserId] == nil then
			local v172 = myPartyInst()
			local u173
			local v174

			if not v172 then
				u173 = true
				v174 = nil
			else
				local members = v172:FindFirstChild("Members")
				local v176 = if members and members:IsA("Folder") then members else nil

				if not v176 then
					u173 = true
					v174 = nil
				elseif not iAmPartyLeader() then
					u173 = false
					v174 = "Only the party leader can invite."
				elseif memberCount(v176) >= 4 then
					u173 = false
					v174 = "Your party is full."
				else
					u173 = true
					v174 = nil
				end
			end

			if not u173 then
				if _G.Notify then
					_G.Notify({
						notifType = "FailNotification",
						errorMessage = v174 or "You can't invite right now."
					})
				end

				return
			end

			t1[player.UserId] = os.clock()

			local cloneLayoutOrder = clone.LayoutOrder

			v172 = player

			if v41 then
				local clone2 = v41:Clone()

				clone2.Name = "Row_" .. tostring(v172.UserId)
				clone2.LayoutOrder = cloneLayoutOrder
				clone2.Visible = true
				clone2.Active = true
				clone2.Interactable = false
				clone2.AutoButtonColor = false

				local displayName = clone2:FindFirstChild("DisplayName")

				if displayName and displayName:IsA("TextLabel") then
					displayName.Text = v172.DisplayName
				end

				local imageLabel = clone2:FindFirstChild("ImageLabel")

				if imageLabel and imageLabel:IsA("ImageLabel") then
					imageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(v172.UserId)
				end

				clone2.Parent = invitesScrollingFrame
			end

			clone:Destroy()
			task.spawn(function()
				local ok3, result3 = pcall(function()
					return playerRequestSend:InvokeServer({ Type = "Party", TargetUserId = player.UserId })
				end)

				if ok3 and result3 == true then
					if _G.Notify then
						_G.Notify({
							notifType = "SuccessNotification",
							topText = "Success!",
							bottomText = "Invited " .. player.DisplayName .. " to your party!"
						})
					end

					local numberValue = tonumber(playerRequestSend:GetAttribute("RequestTTL")) or 7.5

					task.delay(numberValue, function()
						local v195 = t1[player.UserId]

						if v195 and os.clock() - v195 >= numberValue then
							t1[player.UserId] = nil

							if u44 then
								u47()
							end
						end
					end)

					return
				end

				t1[player.UserId] = nil

				if u44 then
					u47()
				end

				local typeName: string = typeof(result3)

				if _G.Notify then
					_G.Notify({
						notifType = "FailNotification",
						errorMessage = typeName == "string" and result3 or "Couldn't send the invite."
					})
				end
			end)

			return
		end
	end)

	return clone
end
local function makePartyRow(player, layoutOrder)
	if not v38 then
		return nil
	end

	local clone = v38:Clone()

	clone.Name = "Row_" .. tostring(player.UserId)
	clone.LayoutOrder = layoutOrder
	clone.Visible = true
	clone.Active = true
	setIdentity(clone, player, true)

	local v125 = iAmPartyLeader()

	clone.Interactable = v125
	clone.AutoButtonColor = v125

	if v125 then
		clone.MouseButton1Click:Connect(function()
			if not iAmPartyLeader() then
				return
			end

			local foundChild: Instance = players:FindFirstChild(player.Name)

			if foundChild and foundChild:IsA("Player") then
				task.spawn(function()
					pcall(function()
						partyRemoteFunction:InvokeServer("KickMember", foundChild)
					end)
				end)
			end
		end)
	end

	clone.Parent = invitesScrollingFrame

	return clone
end

u51 = function(player, p20, layoutOrder)
	if p20 then
		makePartyRow(player, layoutOrder)

		return
	end

	if t1[player.UserId] == nil or not (os.clock() - t1[player.UserId] < (tonumber(playerRequestSend:GetAttribute("RequestTTL")) or 7.5)) then
		makeNormalRow(player, layoutOrder)

		return
	end

	if not v41 then
		return
	end

	local clone = v41:Clone()

	clone.Name = "Row_" .. tostring(player.UserId)
	clone.LayoutOrder = layoutOrder
	clone.Visible = true
	clone.Active = true
	clone.Interactable = false
	clone.AutoButtonColor = false

	local displayName = clone:FindFirstChild("DisplayName")

	if displayName and displayName:IsA("TextLabel") then
		displayName.Text = player.DisplayName
	end

	local imageLabel = clone:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)
	end

	clone.Parent = invitesScrollingFrame
end

local function doRender()
	n1 += 1

	local v132: number = n1
	local v133 = myPartyInst()
	local u134

	if not v133 then
		u134 = true
	else
		local members = v133:FindFirstChild("Members")
		local v136 = if members and members:IsA("Folder") then members else nil

		u134 = if not v136 then true else if not iAmPartyLeader() then false else not (memberCount(v136) >= 4)
	end

	v133 = {}
	local t5: {[any]: any} = {}
	local v138 = myPartyMembers()

	for _, v in ipairs(v138) do
		if not t5[v.UserId] then
			t5[v.UserId] = true
			table.insert(v133, { inMyParty = true, plr = v })
		end
	end

	if u134 then
		for _, v in ipairs(players:GetPlayers()) do
			if not t5[v.UserId] and (if v == LocalPlayer then false else if if v:GetAttribute("InMatch") == true then v:GetAttribute("MatchId") ~= "PRACTICE" else false then false else if isPlayerInAnyParty(v) then false else true) then
				t5[v.UserId] = true
				table.insert(v133, { inMyParty = false, plr = v })
			end
		end
	end

	for _, v in ipairs(v133) do
		local userId = v.plr.UserId

		if t2[userId] == nil then
			if userId <= 0 then
				t2[userId] = false
			else
				local ok4, result4 = pcall(function()
					return LocalPlayer:IsFriendsWith(userId)
				end)

				t2[userId] = ok4 and result4 == true
			end
		end
	end

	if v132 ~= n1 then
		return
	end

	table.sort(v133, function(p22, p23)
		local u184: boolean = t2[p22.plr.UserId] == true

		if u184 ~= (t2[p23.plr.UserId] == true) then
			return u184
		end

		local lowerText = p22.plr.DisplayName:lower()
		local lowerText2 = p23.plr.DisplayName:lower()

		return lowerText < lowerText2
	end)
	clearRows()

	for i, v in ipairs(v133) do
		if v.plr.Parent == players then
			if not v.inMyParty and not (if v.plr == LocalPlayer then false else if if v.plr:GetAttribute("InMatch") == true then v.plr:GetAttribute("MatchId") ~= "PRACTICE" else false then false else if isPlayerInAnyParty(v.plr) then false else true) then
				continue
			end

			u51(v.plr, v.inMyParty, i)
		end
	end
end

u47 = function()
	task.spawn(doRender)
end

local function openRoster()
	if u44 then
		u47()

		return
	end

	u44 = true
	u47()

	local function watchMatchState(p24)
		local v188 = p24:GetAttributeChangedSignal("InMatch")

		table.insert(t3, v188:Connect(function()
			if u44 then
				u47()
			end
		end))
	end

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer then
			local v153 = v:GetAttributeChangedSignal("InMatch")

			table.insert(t3, v153:Connect(function()
				if u44 then
					u47()
				end
			end))
		end
	end

	table.insert(t3, players.PlayerAdded:Connect(function(player: Player)
		if u44 then
			local v190: RBXScriptSignal = player:GetAttributeChangedSignal("InMatch")

			table.insert(t3, v190:Connect(function()
				if u44 then
					u47()
				end
			end))
			u47()
		end
	end))
	table.insert(t3, players.PlayerRemoving:Connect(function()
		if u44 then
			task.defer(u47)
		end
	end))

	local u154: boolean = false

	local function ping()
		if not u44 then
			return
		end

		if u154 then
			return
		end

		u154 = true
		task.delay(0.1, function()
			u154 = false

			if u44 then
				u47()
			end
		end)
	end

	table.insert(t3, physicalParties.DescendantAdded:Connect(ping))
	table.insert(t3, physicalParties.DescendantRemoving:Connect(ping))
end
local function closeRoster()
	u44 = false

	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	table.clear(t3)
end

local panelPosition = panel.Position
local v59 = windowSlide.closedPosFor(panelPosition)
local u60 = nil
local u61: boolean = false

local function cancelSlide()
	if u60 then
		u60:Cancel()
		u60 = nil
	end
end
local function openPI()
	if u60 then
		u60:Cancel()
		u60 = nil
	end

	local v158 = myPartyInst()
	local u159
	local v160

	if not v158 then
		u159 = true
		v160 = nil
	else
		local members = v158:FindFirstChild("Members")
		local v162 = if members and members:IsA("Folder") then members else nil

		if not v162 then
			u159 = true
			v160 = nil
		elseif not iAmPartyLeader() then
			u159 = false
			v160 = "Only the party leader can invite."
		elseif memberCount(v162) >= 4 then
			u159 = false
			v160 = "Your party is full."
		else
			u159 = true
			v160 = nil
		end
	end

	if not u159 then
		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = v160 or "You can't invite to a party right now."
			})
		end

		return
	end

	local v163: boolean = u61

	if not u61 then
		u61 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		pcall(function()
			windowBlur.show("PartyInvite")
		end)
	end

	activeWindowChanged:Fire("PartyInvite")
	scriptParent.Enabled = true

	if not v163 then
		u60 = windowSlide.slideIn(panel, panelPosition, v59)
	else
		panel.Visible = true
	end

	openRoster()
end
local function closePI()
	u44 = false

	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	table.clear(t3)

	if not u61 then
		return
	end

	u61 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v168 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v168)
	pcall(function()
		windowBlur.hide("PartyInvite")
	end)

	if u60 then
		u60:Cancel()
		u60 = nil
	end

	u60 = windowSlide.slideOut(panel, v59, function()
		if not u61 then
			scriptParent.Enabled = false
			panel.Position = panelPosition
		end
	end)
end

closeButton.MouseButton1Click:Connect(function()
	closePI()
end)

local function canSendRobloxInvite()
	local ok5, result5 = pcall(function()
		return socialService:CanSendGameInviteAsync(LocalPlayer)
	end)

	return ok5 and result5 == true
end

friends.MouseButton1Click:Connect(function()
	pcall(function()
		socialService:PromptGameInvite(LocalPlayer)
	end)
end)
openPartyInvite.Event:Connect(openPI)
_G.OpenPartyInvite = openPI
activeWindowChanged.Event:Connect(function(p26)
	if p26 ~= "PartyInvite" and scriptParent.Enabled then
		closePI()
	end
end)
