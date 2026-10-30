-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local partyRemoteFunction: Instance = replicatedStorage:WaitForChild("PartyRemoteFunction")
local physicalParties: Instance = replicatedStorage:WaitForChild("Shared"):WaitForChild("PartySystem"):WaitForChild("PhysicalParties")
local openPartyInvite: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("OpenPartyInvite")

local function findHeadshot(p1)
	local headshot = p1:FindFirstChild("Headshot")

	if headshot and headshot:IsA("ImageLabel") then
		return headshot
	end

	local headShot = p1:FindFirstChild("HeadShot")

	if headShot and headShot:IsA("ImageLabel") then
		return headShot
	end

	return nil
end
local function setSlotUserId(p2, p3: number)
	local headshot = p2:FindFirstChild("Headshot")
	local v26

	if headshot and headshot:IsA("ImageLabel") then
		v26 = headshot
	else
		local headShot = p2:FindFirstChild("HeadShot")

		v26 = if headShot and headShot:IsA("ImageLabel") then headShot else nil
	end

	if not v26 then
		local v28 = p2:GetFullName()

		warn("[PartyView] no Headshot under " .. v28)

		return
	end

	if p3 and p3 < 0 then
		p3 = 1
	end

	if p3 and p3 > 0 then
		v26.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p3)

		return
	end

	v26.Image = "rbxassetid://127075876244307"
end
local function getMembersFolder(p4)
	local members = p4:FindFirstChild("Members")

	if members and members:IsA("Folder") then
		return members
	end

	return nil
end
local function isLocalInPartyInst(p5)
	local members = p5:FindFirstChild("Members")
	local v33 = if members and members:IsA("Folder") then members else nil

	if not v33 then
		return false
	end

	return v33:FindFirstChild(LocalPlayer.Name) ~= nil
end
local function isLocalLeader(p6)
	local members = p6:FindFirstChild("Members")
	local v36 = if members and members:IsA("Folder") then members else nil

	if not v36 then
		return false
	end

	local LocalPlayerName = v36:FindFirstChild(LocalPlayer.Name)

	if not LocalPlayerName or not LocalPlayerName:IsA("ObjectValue") then
		return false
	end

	return LocalPlayerName:GetAttribute("Leader") == true
end
local function getLeaderName(p7)
	local members = p7:FindFirstChild("Members")
	local v40 = if members and members:IsA("Folder") then members else nil

	if not v40 then
		return nil
	end

	for _, v in ipairs(v40:GetChildren()) do
		if v:IsA("ObjectValue") and v:GetAttribute("Leader") == true then
			return v.Name
		end
	end

	return nil
end
local function collectMemberObjs(p8)
	local members = p8:FindFirstChild("Members")
	local v45 = if members and members:IsA("Folder") then members else nil

	if not v45 then
		return {}
	end

	local t1: {[any]: any} = {}

	for _, v in ipairs(v45:GetChildren()) do
		if v:IsA("ObjectValue") then
			table.insert(t1, v)
		end
	end

	table.sort(t1, function(p9, p10)
		local u91: boolean = p9:GetAttribute("Leader") == true
		local leader = p10:GetAttribute("Leader")

		if u91 ~= (leader == true) then
			return u91
		end

		return p9.Name < p10.Name
	end)

	return t1
end
local function findMyPhysicalParty()
	for _, v in ipairs(physicalParties:GetChildren()) do
		if v.Name ~= "PartyTemplate" then
			local members = v:FindFirstChild("Members")
			local v52 = if members and members:IsA("Folder") then members else nil

			if if not v52 then false else v52:FindFirstChild(LocalPlayer.Name) ~= nil then
				return v
			end
		end
	end

	return nil
end
local function resolveUserId(p11)
	local player = p11.Value

	if player and player:IsA("Player") then
		return player.UserId
	end

	local foundChild: Instance = players:FindFirstChild(p11.Name)

	if foundChild and foundChild:IsA("Player") then
		return foundChild.UserId
	end

	return nil
end
local function resolvePlayer(p12)
	local v57 = p12.Value

	if v57 and v57:IsA("Player") then
		return v57
	end

	local foundChild: Instance = players:FindFirstChild(p12.Name)

	if foundChild and foundChild:IsA("Player") then
		return foundChild
	end

	return nil
end
local function inRealMatch()
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
local function onDuelPad()
	return LocalPlayer:GetAttribute("DuelStationQueued") == true
end
local function onAddPlayerClicked()
	openPartyInvite:Fire()
end

return {
	mount = function(p13, p14)
		local t2 = p14 or {}
		local u64: boolean = t2.hideInMatch == true
		local u65: boolean = t2.lockComposition == true
		local u66: boolean = t2.hideOnDuelPad == true
		local list = p13:WaitForChild("List")
		local playerLeaderTemplate = list:WaitForChild("PlayerLeaderTemplate")
		local playerClickableTemplate = list:WaitForChild("PlayerClickableTemplate")
		local addPlayerTemplate = list:FindFirstChild("AddPlayerTemplate")
		local leavePlayerTemplate = list:FindFirstChild("LeavePlayerTemplate")

		playerLeaderTemplate.Visible = false
		playerClickableTemplate.Visible = false

		if addPlayerTemplate and addPlayerTemplate:IsA("GuiObject") then
			addPlayerTemplate.Visible = false
		end

		if leavePlayerTemplate and leavePlayerTemplate:IsA("GuiObject") then
			leavePlayerTemplate.Visible = false
		end

		local u72: boolean = false

		local function applyVisibility()
			local v93: boolean = u72

			if v93 then
				local v94: boolean = u64

				if v94 then
					local matchId: any = LocalPlayer:GetAttribute("MatchId")

					if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
						v94 = true
					else
						local spectating: any = LocalPlayer:GetAttribute("Spectating")

						v94 = typeof(spectating) == "number" and spectating ~= 0
					end
				end

				v93 = not v94

				if v93 then
					local v97: boolean = u66

					if v97 then
						v97 = LocalPlayer:GetAttribute("DuelStationQueued") == true
					end

					v93 = not v97
				end
			end

			p13.Visible = v93
		end
		local function clearRendered()
			for _, v in ipairs(list:GetChildren()) do
				if v:IsA("GuiObject") and v ~= playerLeaderTemplate and v ~= playerClickableTemplate and v ~= addPlayerTemplate and v ~= leavePlayerTemplate and v.Name ~= "UIListLayout" then
					v:Destroy()
				end
			end
		end

		local t3: {[any]: any} = {}

		local function clearPartyBindings()
			for _, v in ipairs(t3) do
				v:Disconnect()
			end

			table.clear(t3)
		end

		local u77 = nil
		local u78 = nil

		local function bindCurrentParty(p15)
			for _, v in ipairs(t3) do
				v:Disconnect()
			end

			table.clear(t3)

			if not p15 then
				return
			end

			local members = p15:FindFirstChild("Members")
			local v106 = if members and members:IsA("Folder") then members else nil

			if not v106 then
				return
			end

			local function hookObj(p16)
				table.insert(t3, p16.Changed:Connect(function()
					task.defer(u78)
				end))

				local v153 = p16:GetAttributeChangedSignal("Leader")

				table.insert(t3, v153:Connect(function()
					task.defer(u78)
				end))
			end

			for _, v in ipairs(v106:GetChildren()) do
				if v:IsA("ObjectValue") then
					hookObj(v)
				end
			end

			table.insert(t3, v106.ChildAdded:Connect(function(p17)
				if p17:IsA("ObjectValue") then
					hookObj(p17)
				end

				task.defer(u78)
			end))
			table.insert(t3, v106.ChildRemoved:Connect(function()
				task.defer(u78)
			end))
		end

		local t4: {[any]: any} = {}

		local function hookMembersFolder(p18, p19)
			if t4[p19] then
				return
			end

			t4[p19] = true
			p19.ChildAdded:Connect(function(p20)
				if p20.Name == LocalPlayer.Name or u77 == p18 then
					task.defer(u78)
				end
			end)
			p19.ChildRemoved:Connect(function(p21)
				if p21.Name == LocalPlayer.Name or u77 == p18 then
					task.defer(u78)
				end
			end)
		end
		local function hookPartyInstance(p22)
			local members = p22:FindFirstChild("Members")
			local v114 = if members and members:IsA("Folder") then members else nil

			if v114 then
				hookMembersFolder(p22, v114)
			end

			p22.ChildAdded:Connect(function(p23)
				if p23.Name == "Members" and p23:IsA("Folder") then
					hookMembersFolder(p22, p23)
					task.defer(u78)
				end
			end)
		end
		local function renderAddButton()
			if not addPlayerTemplate or not addPlayerTemplate:IsA("GuiButton") then
				return
			end

			local clone = addPlayerTemplate:Clone()

			clone.Name = "Slot_Add"
			clone.LayoutOrder = 100
			clone.Visible = true
			clone.Parent = list
			clone.MouseButton1Click:Connect(function()
				local v158 = findMyPhysicalParty()

				if v158 then
					local members = v158:FindFirstChild("Members")
					local v160 = if members and members:IsA("Folder") then members else nil
					local u161

					if not v160 then
						u161 = false
					else
						local LocalPlayerName = v160:FindFirstChild(LocalPlayer.Name)

						u161 = if not LocalPlayerName or not LocalPlayerName:IsA("ObjectValue") then false else LocalPlayerName:GetAttribute("Leader") == true
					end

					if not u161 then
						local v163 = getLeaderName(v158)

						if _G.Notify then
							_G.Notify({
								notifType = "FailNotification",
								errorMessage = "Only the party leader (@" .. (v163 or "the leader") .. ") can invite"
							})
						end

						return
					end

					openPartyInvite:Fire()

					return
				end

				openPartyInvite:Fire()
			end)
		end
		local function renderParty(p24)
			clearRendered()
			u72 = true

			local v117: boolean = u72

			if v117 then
				local v118: boolean = u64

				if v118 then
					local matchId: any = LocalPlayer:GetAttribute("MatchId")

					if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
						v118 = true
					else
						local spectating: any = LocalPlayer:GetAttribute("Spectating")

						v118 = typeof(spectating) == "number" and spectating ~= 0
					end
				end

				v117 = not v118

				if v117 then
					local v121: boolean = u66

					if v121 then
						v121 = LocalPlayer:GetAttribute("DuelStationQueued") == true
					end

					v117 = not v121
				end
			end

			p13.Visible = v117

			if not p24 then
				local clone = playerClickableTemplate:Clone()

				clone.Name = "Slot_Self"
				clone.LayoutOrder = 0
				clone.Visible = true
				clone.Parent = list
				setSlotUserId(clone, LocalPlayer.UserId)

				if not u65 then
					renderAddButton()
				end

				return
			end

			local v123 = collectMemberObjs(p24)

			if #v123 == 0 then
				u72 = false

				local v124: boolean = u72

				if v124 then
					local v125: boolean = u64

					if v125 then
						local matchId: any = LocalPlayer:GetAttribute("MatchId")

						if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
							v125 = true
						else
							local spectating: any = LocalPlayer:GetAttribute("Spectating")

							v125 = typeof(spectating) == "number" and spectating ~= 0
						end
					end

					v124 = not v125

					if v124 then
						local v128: boolean = u66

						if v128 then
							v128 = LocalPlayer:GetAttribute("DuelStationQueued") == true
						end

						v124 = not v128
					end
				end

				p13.Visible = v124

				return
			end

			local members = p24:FindFirstChild("Members")
			local v130 = if members and members:IsA("Folder") then members else nil
			local u131

			if not v130 then
				u131 = false
			else
				local LocalPlayerName = v130:FindFirstChild(LocalPlayer.Name)

				u131 = if LocalPlayerName and LocalPlayerName:IsA("ObjectValue") then LocalPlayerName:GetAttribute("Leader") == true else false
			end

			v130 = #v123 == 1

			for i, v in ipairs(v123) do
				local leader = v:GetAttribute("Leader")
				local u136: boolean = v.Name == LocalPlayer.Name
				local vValue = v.Value
				local v138

				if vValue and vValue:IsA("Player") then
					v138 = vValue.UserId
				else
					local vName: Instance = players:FindFirstChild(v.Name)

					v138 = if vName and vName:IsA("Player") then vName.UserId else nil
				end

				local vValue2 = v.Value
				local v141

				if vValue2 and vValue2:IsA("Player") then
					v141 = vValue2
				else
					local vName: Instance = players:FindFirstChild(v.Name)

					v141 = if vName and vName:IsA("Player") then vName else nil
				end

				if leader == true and not v130 then
					local clone = playerLeaderTemplate:Clone()

					clone.Name = "Slot_Leader"
					clone.LayoutOrder = -1
					clone.Visible = true
					clone.Parent = list
					setSlotUserId(clone, v138)
				else
					local clone = playerClickableTemplate:Clone()

					clone.Name = "Slot_Member_" .. v.Name
					clone.LayoutOrder = i
					clone.Visible = true
					clone.Parent = list
					setSlotUserId(clone, v138)

					if u65 then
						clone.Active = false
						clone.AutoButtonColor = false
					elseif not u136 then
						clone.MouseButton1Click:Connect(function()
							if u131 and v141 then
								pcall(function()
									partyRemoteFunction:InvokeServer("KickMember", v141)
								end)
							end
						end)
					end
				end
			end

			if not u65 and (not not u131 or #v123 <= 1) and #v123 < 4 then
				renderAddButton()
			end

			if not u65 and #v123 >= 2 and leavePlayerTemplate and leavePlayerTemplate:IsA("GuiButton") then
				local clone = leavePlayerTemplate:Clone()

				clone.Name = "Slot_Leave"
				clone.LayoutOrder = 101
				clone.Visible = true
				clone.Parent = list
				clone.MouseButton1Click:Connect(function()
					if not u77 then
						return
					end

					pcall(function()
						partyRemoteFunction:InvokeServer("LeaveParty")
					end)
				end)
			end
		end

		u78 = function()
			local v146 = findMyPhysicalParty()

			if v146 ~= u77 then
				u77 = v146
				bindCurrentParty(v146)
			end

			renderParty(v146)
		end

		for _, v in ipairs(physicalParties:GetChildren()) do
			if v.Name ~= "PartyTemplate" then
				local members = v:FindFirstChild("Members")
				local v88 = if members and members:IsA("Folder") then members else nil

				if v88 then
					hookMembersFolder(v, v88)
				end

				v.ChildAdded:Connect(function(p25)
					if p25.Name == "Members" and p25:IsA("Folder") then
						hookMembersFolder(v, p25)
						task.defer(u78)
					end
				end)
			end
		end

		physicalParties.ChildAdded:Connect(function(p26: Instance)
			if p26.Name ~= "PartyTemplate" then
				local members: Instance = p26:FindFirstChild("Members")
				local v150 = if members and members:IsA("Folder") then members else nil

				if v150 then
					hookMembersFolder(p26, v150)
				end

				p26.ChildAdded:Connect(function(p27: Instance)
					if p27.Name == "Members" and p27:IsA("Folder") then
						hookMembersFolder(p26, p27)
						task.defer(u78)
					end
				end)
			end

			task.defer(u78)
		end)
		physicalParties.ChildRemoved:Connect(function(_: Instance)
			task.defer(u78)
		end)
		task.defer(u78)

		if u64 then
			LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(applyVisibility)
			LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(applyVisibility)
		end

		if u66 then
			LocalPlayer:GetAttributeChangedSignal("DuelStationQueued"):Connect(applyVisibility)
		end
	end
}
