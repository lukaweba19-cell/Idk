-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local teleportService: TeleportService = game:GetService("TeleportService")
local runService: RunService = game:GetService("RunService")
local event = require(script.Event)
local remotes = require(script.Remotes)
local module: {[any]: any} = {}

module.__index = module

local t2: {[any]: any} = {}
local scriptPhysicalParties = script.PhysicalParties
local scriptPhysicalPartiesPartyTemplate = scriptPhysicalParties.PartyTemplate
local v10 = event.new()
local v11 = event.new()
local v12 = event.new()
local v13 = event.new()
local v14 = event.new()
local v15 = event.new()
local v16 = event.new()
local v17 = event.new()
local v18 = event.new()

module.Events = {
	InviteSent = v10,
	MemberJoined = v11,
	MemberLeft = v12,
	Created = v13,
	Disband = v14,
	InviteRevoked = v15,
	PartyNameChanged = v16,
	MemberPermissionsChanged = v17,
	InviteExpired = v18
}

function module.OnInviteSent(p1, p2)
	return p1.Events.InviteSent:Connect(p2)
end
function module.OnMemberJoined(p3, p4)
	return p3.Events.MemberJoined:Connect(p4)
end
function module.OnMemberLeft(p5, p6)
	return p5.Events.MemberLeft:Connect(p6)
end
function module.OnPartyCreate(p7, p8)
	return p7.Events.Created:Connect(p8)
end
function module.OnDisband(p9, p10)
	return p9.Events.Disband:Connect(p10)
end
function module.OnInviteRevoked(p11, p12)
	return p11.Events.InviteRevoked:Connect(p12)
end
function module.OnPartyNameChanged(p13, p14)
	return p13.Events.PartyNameChanged:Connect(p14)
end
function module.OnMemberPermissionsChanged(p15, p16)
	return p15.Events.MemberPermissionsChanged:Connect(p16)
end
function module.OnInviteExpired(p17, p18)
	return p17.Events.InviteExpired:Connect(p18)
end
function module.GetParty(p19, p20)
	local v41 = p19:_FindPlayerParty(p20)

	if v41 then
		return v41
	end

	return nil
end
function module.GetPartyById(_, p22)
	return t2[p22]
end
function module.GetAllParties(_)
	return table.clone(t2)
end
function module._FindPlayerParty(_, p25)
	for key, value in t2 do
		if table.find(value.Members, p25) then
			return value
		end
	end

	return nil
end
function module.new(p26)
	local v50 = module:_FindPlayerParty(p26)

	if v50 then
		local v51 = ("%* is already a party leader!"):format(p26.Name)

		warn(v51)

		return v50
	end

	local clone = scriptPhysicalPartiesPartyTemplate:Clone()
	local text: string = tostring(math.random(10000, 99999))
	local object = setmetatable({
		MaxMembers = 4,
		CurrentMemberCount = 0,
		InviteOnly = false,
		Leader = p26,
		Members = {},
		Invites = {},
		Blacklist = {},
		PhysicalParty = clone,
		PartyId = text,
		PartyName = p26.Name .. "'s Party"
	}, module)

	object.PhysicalParty.Name = p26.Name
	object.PhysicalParty.Parent = scriptPhysicalParties
	object.PhysicalParty:SetAttribute("PartyId", object.PartyId)
	object:_SetupPhysicalParty(p26)
	t2[object.PartyId] = object
	table.insert(object.Members, p26)
	object.CurrentMemberCount = 1
	object.Events.Created:Fire(object)

	return object
end
local function createNewInstance(p27, p28, p29, p30)
	local ok, result = pcall(function()
		local v198 = Instance.new(p27)

		v198.Parent = p28
		v198.Name = p29

		if p30 then
			v198.Value = p30
		end

		return v198
	end)

	local v61 = result

	if not ok then
		local v62 = ("Error creating instance: %*"):format(v61)

		warn(v62)

		return nil
	end

	return v61
end
function module._SetupPhysicalParty(p31, p32)
	local members = p31.PhysicalParty.Members
	local v66 = p32.Name
	local s1: string = "ObjectValue"

	local ok, result = pcall(function()
		local v199 = Instance.new(s1)

		v199.Parent = members
		v199.Name = v66

		if p32 then
			v199.Value = p32
		end

		return v199
	end)

	local v70 = result
	local v71

	if not ok then
		local v72 = ("Error creating instance: %*"):format(v70)

		warn(v72)
		v71 = nil
	else
		v71 = v70
	end

	if v71 then
		v71:SetAttribute("Leader", true)
		v71:SetAttribute("CanKick", true)
		v71:SetAttribute("CanInvite", true)
	end

	p31.Events.MemberJoined:Fire(p31, p32, { p32 })

	return true
end
function module.Disband(p33)
	if not t2[p33.PartyId] then
		warn("Party does not exist!")

		return false
	end

	local leader = p33.Leader
	local v75 = p33:GetMembers()

	p33.Events.Disband:Fire(p33, leader, v75)
	t2[p33.PartyId] = nil
	p33.PhysicalParty:Destroy()

	return true
end
function module.TransferOwnership(p34, p35)
	local leader = p34.Leader

	if not table.find(p34.Members, p35) then
		local v79 = ("%* is not in the party!"):format(p35.Name)

		warn(v79)

		return false
	end

	if p35 == p34.Leader then
		warn("Cannot transfer ownership to current leader!")

		return false
	end

	p34.Leader = p35
	p34.PhysicalParty.Name = p35.Name

	local foundChild = p34.PhysicalParty.Members:FindFirstChild(leader.Name)

	if foundChild then
		foundChild:SetAttribute("Leader", false)
		foundChild:SetAttribute("CanKick", false)
		foundChild:SetAttribute("CanInvite", false)
		p34.Events.MemberPermissionsChanged:Fire(p34, leader, "Leader", false)
		p34.Events.MemberPermissionsChanged:Fire(p34, leader, "CanKick", false)
		p34.Events.MemberPermissionsChanged:Fire(p34, leader, "CanInvite", false)
	end

	local foundChild2 = p34.PhysicalParty.Members:FindFirstChild(p35.Name)

	if foundChild2 then
		foundChild2:SetAttribute("Leader", true)
		foundChild2:SetAttribute("CanKick", true)
		foundChild2:SetAttribute("CanInvite", true)
		p34.Events.MemberPermissionsChanged:Fire(p34, p35, "Leader", true)
		p34.Events.MemberPermissionsChanged:Fire(p34, p35, "CanKick", true)
		p34.Events.MemberPermissionsChanged:Fire(p34, p35, "CanInvite", true)
	end

	return true
end
function module.InvitePlayer(p36, p37)
	if table.find(p36.Members, p37) then
		local v84 = ("%* is already a member!"):format(p37.Name)

		warn(v84)

		return false
	end

	p36.Invites[p37] = true

	while true do
		if not p36.PhysicalParty.Invites:FindFirstChild(p37.Name) then
			break
		end

		p36.PhysicalParty.Invites[p37.Name]:Destroy()
	end

	local invites = p36.PhysicalParty.Invites
	local v86 = p37.Name
	local s1: string = "ObjectValue"

	local ok, result = pcall(function()
		local v200 = Instance.new(s1)

		v200.Parent = invites
		v200.Name = v86

		if p37 then
			v200.Value = p37
		end

		return v200
	end)

	local v90 = result
	local u91

	if not ok then
		local v92 = ("Error creating instance: %*"):format(v90)

		warn(v92)
		u91 = nil
	else
		u91 = v90
	end

	if u91 then
		u91:SetAttribute("PartyId", p36.PartyId)
	end

	p36.Events.InviteSent:Fire(u91, p36.Leader, p37, p36)
	task.spawn(function()
		task.wait(20)

		if p36.Invites[p37] then
			p36.Invites[p37] = nil

			if u91 and u91.Parent then
				u91:Destroy()
			end

			p36.Events.InviteExpired:Fire(p36, p37)
		end
	end)

	return true
end
function module.InvitePlayerByUsername(p38, p39)
	local foundChild: Instance = players:FindFirstChild(p39)

	if not foundChild then
		local v96 = ("Player %* not found in game!"):format(p39)

		warn(v96)

		return false
	end

	return p38:InvitePlayer(foundChild)
end
function module.AddMember(p40, p41)
	if not t2[p40.PartyId] then
		local v99 = ("Cannot add %*: party no longer exists!"):format(p41.Name)

		warn(v99)

		return false
	end

	if p40.CurrentMemberCount >= p40.MaxMembers then
		warn("Party is full!")

		return false
	end

	if table.find(p40.Members, p41) then
		local v100 = ("%* is already in the party!"):format(p41.Name)

		warn(v100)

		return false
	end

	if table.find(p40.Blacklist, p41) then
		local v101 = ("%* is blacklisted!"):format(p41.Name)

		warn(v101)

		return false
	end

	if p40.InviteOnly and not p40.Invites[p41] then
		local v102 = ("%* has no active invite!"):format(p41.Name)

		warn(v102)

		return false
	end

	p40.Invites[p41] = nil

	if p40.PhysicalParty.Invites:FindFirstChild(p41.Name) then
		p40.PhysicalParty.Invites[p41.Name]:Destroy()
	end

	table.insert(p40.Members, p41)
	p40.CurrentMemberCount = p40.CurrentMemberCount + 1

	while true do
		if not p40.PhysicalParty.Members:FindFirstChild(p41.Name) then
			break
		end

		p40.PhysicalParty.Members[p41.Name]:Destroy()
	end

	local members = p40.PhysicalParty.Members
	local v104 = p41.Name
	local s1: string = "ObjectValue"

	local ok, result = pcall(function()
		local v201 = Instance.new(s1)

		v201.Parent = members
		v201.Name = v104

		if p41 then
			v201.Value = p41
		end

		return v201
	end)

	local v108 = result
	local v109

	if not ok then
		local v110 = ("Error creating instance: %*"):format(v108)

		warn(v110)
		v109 = nil
	else
		v109 = v108
	end

	if v109 then
		v109:SetAttribute("Leader", false)
		v109:SetAttribute("CanKick", false)
		v109:SetAttribute("CanInvite", false)

		local v111 = p40:GetMembers()

		p40.Events.MemberJoined:Fire(p40, p41, v111)
	end

	return true
end
local function disbandIfAlone(p42)
	if not t2[p42.PartyId] then
		return false
	end

	if p42.CurrentMemberCount > 1 then
		return false
	end

	return p42:Disband() == true
end
function module.RemoveMember(p43, p44)
	local v115 = table.find(p43.Members, p44)

	if not v115 then
		local v116 = ("%* not in party!"):format(p44.Name)

		warn(v116)

		return false
	end

	table.remove(p43.Members, v115)
	p43.CurrentMemberCount = p43.CurrentMemberCount - 1

	if p43.PhysicalParty.Members:FindFirstChild(p44.Name) then
		p43.PhysicalParty.Members[p44.Name]:Destroy()
	end

	v115 = p43:GetMembers()
	p43.Events.MemberLeft:Fire(p43, p44, v115, true)

	if t2[p43.PartyId] and not (p43.CurrentMemberCount > 1) then
		if p43:Disband() == true then
		end
	end

	return true
end
function module.LeaveParty(p45, p46)
	local v119 = table.find(p45.Members, p46)

	if not v119 then
		local v120 = ("%* not in party!"):format(p46.Name)

		warn(v120)

		return false
	end

	if p46 == p45.Leader then
		warn("Leader cannot leave party! Use Disband or TransferOwnership instead.")

		return false
	end

	table.remove(p45.Members, v119)
	p45.CurrentMemberCount = p45.CurrentMemberCount - 1

	if p45.PhysicalParty.Members:FindFirstChild(p46.Name) then
		p45.PhysicalParty.Members[p46.Name]:Destroy()
	end

	v119 = p45:GetMembers()
	p45.Events.MemberLeft:Fire(p45, p46, v119, false)

	if t2[p45.PartyId] and not (p45.CurrentMemberCount > 1) then
		if p45:Disband() == true then
		end
	end

	return true
end
function module.BlacklistPlayer(p47, p48)
	local v123 = p47:IsMember(p48)

	if table.find(p47.Blacklist, p48) then
		local v124 = ("%* is already blacklisted!"):format(p48.Name)

		warn(v124)

		return false
	end

	if p48 == p47.Leader then
		warn("Cannot blacklist leader!")

		return false
	end

	if not p47:HasPermission("CanKick") then
		warn("Must have CanKick permission to blacklist!")

		return false
	end

	table.insert(p47.Blacklist, p48)

	local blacklist = p47.PhysicalParty.Blacklist
	local v126 = p48.Name
	local s1: string = "ObjectValue"

	local ok, result = pcall(function()
		local v202 = Instance.new(s1)

		v202.Parent = blacklist
		v202.Name = v126

		if p48 then
			v202.Value = p48
		end

		return v202
	end)

	if not ok then
		local v130 = ("Error creating instance: %*"):format(result)

		warn(v130)
	end

	if v123 then
		p47:RemoveMember(p48)
	end

	return true
end
function module.UnblacklistPlayer(p49, p50)
	local v133 = table.find(p49.Blacklist, p50)

	if not v133 then
		local v134 = ("%* is not blacklisted!"):format(p50.Name)

		warn(v134)

		return false
	end

	table.remove(p49.Blacklist, v133)

	if p49.PhysicalParty.Blacklist:FindFirstChild(p50.Name) then
		p49.PhysicalParty.Blacklist[p50.Name]:Destroy()
	end

	return true
end
function module.SetMaxMembers(p51, maxMembers)
	p51.MaxMembers = maxMembers

	return true
end
function module.SetPermission(p53, p54, p55, p56)
	if not table.find(p53.Members, p54) then
		local v141 = ("%* is not in party!"):format(p54.Name)

		warn(v141)

		return false
	end

	if p54 == p53.Leader then
		warn("Cannot modify leader permissions!")

		return false
	end

	if p55 == "Leader" then
		warn("Use transferOwnership instead!")

		return false
	end

	if p53.PhysicalParty.Members:FindFirstChild(p54.Name) then
		p53.PhysicalParty.Members[p54.Name]:SetAttribute(p55, p56)
		p53.Events.MemberPermissionsChanged:Fire(p53, p54, p55, p56)
	end

	return true
end
function module.ToggleInviteOnly(p57, value)
	p57.InviteOnly = value
	p57.PhysicalParty.InviteOnly.Value = value

	return true
end
function module.GetMembers(p59)
	return table.clone(p59.Members)
end
function module.IsMember(p60, p61)
	return table.find(p60.Members, p61) ~= nil
end
function module.IsLeader(p62, p63)
	return p63 == p62.Leader
end
function module.IsInviteOnly(p64)
	return p64.InviteOnly
end
function module.HasPermission(p65, p66, p67)
	local foundChild = p65.PhysicalParty.Members:FindFirstChild(p66.Name)

	if not foundChild or not foundChild:GetAttribute(p67) then
		return false
	end

	return foundChild:GetAttribute(p67)
end
function module.TeleportMembers(p68, p69, p70)
	local teleportOptions: TeleportOptions = Instance.new("TeleportOptions")

	if p70 then
		if p70.ReservedServerCode then
			teleportOptions.ReservedServerAccessCode = p70.ReservedServerCode
		end

		if p70.JobId then
			teleportOptions.ServerInstanceId = p70.JobId
		end

		if p70.ShouldReserveServer then
			teleportOptions.ShouldReserveServer = p70.ShouldReserveServer
		end
	end

	teleportService:TeleportAsync(p69, p68.Members, teleportOptions)

	return true
end
function module.GetInvites(p71)
	local t3: {[any]: any} = {}

	for iterValue in p71.Invites, nil, nil do
		table.insert(t3, iterValue)
	end

	return t3
end
function module.AcceptInvite(p72, p73)
	if not p72.Invites[p73] then
		local v163 = ("%* has no active invite to this party!"):format(p73.Name)

		warn(v163)

		return false
	end

	if p72.CurrentMemberCount >= p72.MaxMembers then
		warn("Party is full!")

		return false
	end

	if table.find(p72.Members, p73) then
		local v164 = ("%* is already in the party!"):format(p73.Name)

		warn(v164)

		return false
	end

	if table.find(p72.Blacklist, p73) then
		local v165 = ("%* is blacklisted!"):format(p73.Name)

		warn(v165)

		return false
	end

	for key, value in t2 do
		if value ~= p72 and value.Invites[p73] then
			value:RevokeInvite(p73)
		end
	end

	p72.Invites[p73] = nil

	if p72.PhysicalParty.Invites:FindFirstChild(p73.Name) then
		p72.PhysicalParty.Invites[p73.Name]:Destroy()
	end

	table.insert(p72.Members, p73)
	p72.CurrentMemberCount = p72.CurrentMemberCount + 1

	while true do
		if not p72.PhysicalParty.Members:FindFirstChild(p73.Name) then
			break
		end

		p72.PhysicalParty.Members[p73.Name]:Destroy()
	end

	local members = p72.PhysicalParty.Members
	local v169 = p73.Name
	local s1: string = "ObjectValue"

	local ok, result = pcall(function()
		local v203 = Instance.new(s1)

		v203.Parent = members
		v203.Name = v169

		if p73 then
			v203.Value = p73
		end

		return v203
	end)

	local v173 = result
	local v174

	if not ok then
		local v175 = ("Error creating instance: %*"):format(v173)

		warn(v175)
		v174 = nil
	else
		v174 = v173
	end

	if v174 then
		v174:SetAttribute("Leader", false)
		v174:SetAttribute("CanKick", false)
		v174:SetAttribute("CanInvite", false)

		local v176 = p72:GetMembers()

		p72.Events.MemberJoined:Fire(p72, p73, v176)
	end

	return true
end
function module.RevokeInvite(p74, p75)
	if not p74.Invites[p75] then
		local v179 = ("%* has no pending invite!"):format(p75.Name)

		warn(v179)

		return false
	end

	p74.Invites[p75] = nil

	if p74.PhysicalParty.Invites:FindFirstChild(p75.Name) then
		p74.PhysicalParty.Invites[p75.Name]:Destroy()
	end

	p74.Events.InviteRevoked:Fire(p74, p75)

	return true
end
function module.SetPartyName(p76, p77)
	local partyName = p76.PartyName

	p76.PartyName = p77
	p76.PhysicalParty:SetAttribute("PartyName", p77)
	p76.Events.PartyNameChanged:Fire(p76, partyName, p77)

	return true
end
function module.GetBlacklist(p78)
	return table.clone(p78.Blacklist)
end
function module.ClearBlacklist(p79)
	if #p79.Blacklist == 0 then
		warn("Blacklist is already empty!")

		return false
	end

	for iterFirst, iterSecond in p79.Blacklist, nil, nil do
		if p79.PhysicalParty.Blacklist:FindFirstChild(iterSecond.Name) then
			p79.PhysicalParty.Blacklist[iterSecond.Name]:Destroy()
		end
	end

	table.clear(p79.Blacklist)

	return true
end

module.PhysicalParties = scriptPhysicalParties

if runService:IsServer() then
	remotes.Setup(t2, module)
	players.PlayerRemoving:Connect(function(player: Player)
		local t4: {[any]: any} = {}

		for key, value in t2 do
			if table.find(value.Members, player) then
				table.insert(t4, value)
			end
		end

		for key2, value2 in t4 do
			if t2[value2.PartyId] then
				if player == value2.Leader then
					local v193 = nil

					for iterFirst, iterSecond in value2.Members, nil, nil do
						if iterSecond ~= player and iterSecond.Parent == players then
							v193 = iterSecond

							break
						end
					end

					if not v193 then
						value2:Disband()

						continue
					end

					value2:TransferOwnership(v193)
				end

				local v196 = table.find(value2.Members, player)

				if v196 then
					table.remove(value2.Members, v196)
					value2.CurrentMemberCount = value2.CurrentMemberCount - 1
				end

				local members = value2.PhysicalParty:FindFirstChild("Members")

				if members then
					while true do
						if not members:FindFirstChild(player.Name) then
							break
						end

						members[player.Name]:Destroy()
					end
				end

				v196 = value2:GetMembers()
				value2.Events.MemberLeft:Fire(value2, player, v196, false)

				if t2[value2.PartyId] and not (value2.CurrentMemberCount > 1) then
					if value2:Disband() == true then
					end
				end
			end
		end
	end)
end

return module
