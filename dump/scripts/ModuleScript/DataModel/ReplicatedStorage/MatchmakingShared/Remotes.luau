-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local u2 = nil
local u3 = nil
local remoteFunction = nil

local function getPlayerParty(p1)
	for iterFirst, iterSecond in u2 do
		if iterSecond.PhysicalParty.Members:FindFirstChild(p1.Name) then
			return iterSecond
		end
	end

	return nil
end
local function clearPlayerInvites(p2)
	local u19: boolean = false

	for iterFirst, iterSecond in u2 do
		if iterSecond.Invites[p2] then
			u19 = true
			iterSecond:RevokeInvite(p2)
		end
	end

	return u19
end
local function tutorialGateActive()
	local ok, result = pcall(function()
		local matchmakingGate: Instance = game:GetService("ServerStorage"):FindFirstChild("MatchmakingGate")
		local v137 = matchmakingGate

		if v137 then
			v137 = require(matchmakingGate).IsBackendEnabled()
		end

		return v137
	end)

	return ok and result == true
end
local function isPhase1(p3)
	local ok, result = pcall(function()
		local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
		local beginnerTasks: Instance = main and main:FindFirstChild("BeginnerTasks")
		local v140 = beginnerTasks

		if v140 then
			v140 = require(beginnerTasks).GetTutorialPhase(p3)
		end

		return v140
	end)

	return ok and result == 1
end
local function notifyPartyFail(p4, p5)
	local remotes: Instance = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
	local notification: Instance = remotes and remotes:FindFirstChild("Notification")

	if notification and notification:IsA("RemoteEvent") then
		notification:FireClient(p4, { notifType = "FailNotification", topText = "Party", errorMessage = p5 })
	end
end
local function validatePartyJoin(p6, p7)
	local ok, result = pcall(function()
		local matchmakingGate: Instance = game:GetService("ServerStorage"):FindFirstChild("MatchmakingGate")
		local v137 = matchmakingGate

		if v137 then
			v137 = require(matchmakingGate).IsBackendEnabled()
		end

		return v137
	end)

	if not ok or result ~= true then
		return true
	end

	local ok2, result2 = pcall(function()
		local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
		local beginnerTasks: Instance = main and main:FindFirstChild("BeginnerTasks")
		local v143 = beginnerTasks

		if v143 then
			v143 = require(beginnerTasks).GetTutorialPhase(p7)
		end

		return v143
	end)

	local v37 = ok2 and result2 == 1
	local v38 = p6:GetMembers()
	local u39: boolean = false

	for _, v in ipairs(v38) do
		local ok3, result3 = pcall(function()
			local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
			local beginnerTasks: Instance = main and main:FindFirstChild("BeginnerTasks")
			local v146 = beginnerTasks

			if v146 then
				v146 = require(beginnerTasks).GetTutorialPhase(v)
			end

			return v146
		end)

		if ok3 and result3 == 1 then
			u39 = true

			break
		end
	end

	if not v37 and not u39 then
		return true
	end

	if v37 and not u39 then
		return false, "newcomer_p1"
	end

	if not v37 and u39 then
		return false, "party_p1"
	end

	if #v38 + 1 > 2 then
		return false, "p1_cap"
	end

	return true
end
local function quarantineGateActive()
	local ok, result = pcall(function()
		local matchmakingGate: Instance = game:GetService("ServerStorage"):FindFirstChild("MatchmakingGate")
		local v148 = matchmakingGate

		if v148 then
			v148 = require(matchmakingGate).IsTrustEnforcementEnabled()
		end

		return v148
	end)

	return ok and result == true
end
local function isQuarantined(p8)
	local ok, result = pcall(function()
		local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
		local profileStore: Instance = main and main:FindFirstChild("ProfileStore")
		local v151 = profileStore

		if v151 then
			v151 = require(profileStore).IsQuarantined(p8)
		end

		return v151
	end)

	return ok and result == true
end
local function validatePartyQuarantine(p9, p10)
	local ok, result = pcall(function()
		local matchmakingGate: Instance = game:GetService("ServerStorage"):FindFirstChild("MatchmakingGate")
		local v148 = matchmakingGate

		if v148 then
			v148 = require(matchmakingGate).IsTrustEnforcementEnabled()
		end

		return v148
	end)

	if not ok or result ~= true then
		return true
	end

	local ok4, result4 = pcall(function()
		local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
		local profileStore: Instance = main and main:FindFirstChild("ProfileStore")
		local v154 = profileStore

		if v154 then
			v154 = require(profileStore).IsQuarantined(p10)
		end

		return v154
	end)

	local u55: boolean = false

	for _, v in ipairs(p9:GetMembers()) do
		local ok5, result5 = pcall(function()
			local main: Instance = game:GetService("ServerScriptService"):FindFirstChild("Main")
			local profileStore: Instance = main and main:FindFirstChild("ProfileStore")
			local v157 = profileStore

			if v157 then
				v157 = require(profileStore).IsQuarantined(v)
			end

			return v157
		end)

		if ok5 and result5 == true then
			u55 = true

			break
		end
	end

	return (ok4 and result4 == true) == u55
end

local t1: {[any]: any} = {
	CreateParty = function(p11)
		if typeof(p11) ~= "Instance" or not p11:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if u3:GetParty(p11) == nil then
			u3.new(p11)

			return true
		end

		local v61 = ("%* is already in a party!"):format(p11.Name)

		warn(v61)

		return false
	end,
	InvitePlayer = function(p12, p13)
		if typeof(p12) ~= "Instance" or not p12:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p13) ~= "Instance" or not p13:IsA("Player") then
			warn("InvitedPlayer must be a Player instance")

			return false
		end

		local v64: boolean = false
		local v65

		for iterFirst, iterSecond in u2 do
			if iterSecond.PhysicalParty.Members:FindFirstChild(p12.Name) then
				v65 = iterSecond
				v64 = true

				break
			end
		end

		if not v64 then
			v65 = nil
		end

		if not v65 or not v65:HasPermission(p12, "CanInvite") then
			return false
		end

		local v68, v69 = validatePartyJoin(v65, p13)

		if not v68 then
			if v69 == "newcomer_p1" then
				notifyPartyFail(p12, p13.DisplayName .. " can't join parties until they finish their first duel.")
			elseif v69 == "party_p1" then
				notifyPartyFail(p12, "New player parties can only invite other new players.")
			elseif v69 == "p1_cap" then
				notifyPartyFail(p12, "New player parties are limited to 2 players.")
			end

			return false
		end

		if not validatePartyQuarantine(v65, p13) then
			notifyPartyFail(p12, "You can't party with this player.")

			return false
		end

		return v65:InvitePlayer(p13)
	end,
	AcceptInvite = function(p14, p15)
		if typeof(p14) ~= "Instance" or not p14:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p15) ~= "string" then
			warn("PartyId must be a string")

			return false
		end

		if not p15 then
			warn("Must specify a PartyId!")

			return false
		end

		for iterFirst, iterSecond in u2 do
			print(iterSecond.Invites)

			if p15 == iterSecond.PartyId and iterSecond.Invites[p14] then
				local v74, v75 = validatePartyJoin(iterSecond, p14)

				if not v74 then
					if v75 == "newcomer_p1" then
						notifyPartyFail(p14, "You can only party with other new players until you finish your first duel.")
					elseif v75 == "party_p1" then
						notifyPartyFail(p14, "That party is for new players on their first duel.")
					elseif v75 == "p1_cap" then
						notifyPartyFail(p14, "New player parties are limited to 2 players.")
					end

					iterSecond:RevokeInvite(p14)

					return false
				end

				if not validatePartyQuarantine(iterSecond, p14) then
					notifyPartyFail(p14, "You can't join this party.")
					iterSecond:RevokeInvite(p14)

					return false
				end

				local v76 = iterSecond:AddMember(p14)

				if v76 then
					clearPlayerInvites(p14)
				end

				return v76
			end
		end

		return false
	end,
	LeaveParty = function(p16)
		if typeof(p16) ~= "Instance" or not p16:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		local v78 = u3:GetParty(p16)

		if not v78 then
			return false
		end

		if v78:IsLeader(p16) then
			local v79 = nil

			for iterFirst, iterSecond in v78.Members, nil, nil do
				if iterSecond ~= p16 and iterSecond.Parent == players then
					v79 = iterSecond

					break
				end
			end

			if not v79 then
				return v78:Disband()
			end

			v78:TransferOwnership(v79)

			return v78:LeaveParty(p16)
		end

		return v78:LeaveParty(p16)
	end,
	KickMember = function(p17, p18)
		if typeof(p17) ~= "Instance" or not p17:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p18) ~= "Instance" or not p18:IsA("Player") then
			warn("MemberToKick must be a Player instance")

			return false
		end

		local v84: boolean = false
		local v85

		for iterFirst, iterSecond in u2 do
			if iterSecond.PhysicalParty.Members:FindFirstChild(p17.Name) then
				v85 = iterSecond
				v84 = true

				break
			end
		end

		if not v84 then
			v85 = nil
		end

		if not v85 or not v85:HasPermission(p17, "CanKick") then
			return false
		end

		if not p18 or not v85:IsMember(p18) then
			return false
		end

		return v85:RemoveMember(p18)
	end,
	TransferOwnership = function(p19, p20)
		if typeof(p19) ~= "Instance" or not p19:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p20) ~= "Instance" or not p20:IsA("Player") then
			warn("NewLeader must be a Player instance")

			return false
		end

		local v90: boolean = false
		local v91

		for iterFirst, iterSecond in u2 do
			if iterSecond.PhysicalParty.Members:FindFirstChild(p19.Name) then
				v91 = iterSecond
				v90 = true

				break
			end
		end

		if not v90 then
			v91 = nil
		end

		if not v91 or not v91:IsLeader(p19) then
			return false
		end

		if not p20 or not v91:IsMember(p20) then
			return false
		end

		return v91:TransferOwnership(p20)
	end,
	ToggleInviteOnly = function(p21, p22)
		if typeof(p21) ~= "Instance" or not p21:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p22) == "boolean" then
			local v96: boolean = false
			local v97

			for iterFirst, iterSecond in u2 do
				if iterSecond.PhysicalParty.Members:FindFirstChild(p21.Name) then
					v97 = iterSecond
					v96 = true

					break
				end
			end

			if not v96 then
				v97 = nil
			end

			if not v97 or not v97:IsLeader(p21) then
				return false
			end

			return v97:ToggleInviteOnly(p22)
		end

		warn("Toggle must be a boolean")

		return false
	end,
	SetMaxMembers = function(p23, p24)
		if typeof(p23) ~= "Instance" or not p23:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p24) == "number" then
			local v102: boolean = false
			local v103

			for iterFirst, iterSecond in u2 do
				if iterSecond.PhysicalParty.Members:FindFirstChild(p23.Name) then
					v103 = iterSecond
					v102 = true

					break
				end
			end

			if not v102 then
				v103 = nil
			end

			if not v103 or not v103:IsLeader(p23) then
				return false
			end

			return v103:SetMaxMembers(p24)
		end

		warn("MaxMembers must be a number")

		return false
	end,
	DisbandParty = function(p25)
		if typeof(p25) ~= "Instance" or not p25:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		local v107: boolean = false
		local v108

		for iterFirst, iterSecond in u2 do
			if iterSecond.PhysicalParty.Members:FindFirstChild(p25.Name) then
				v108 = iterSecond
				v107 = true

				break
			end
		end

		if not v107 then
			v108 = nil
		end

		if not v108 or not v108:IsLeader(p25) then
			return false
		end

		return v108:Disband()
	end,
	SetPermission = function(p26, p27, p28, p29)
		if typeof(p26) ~= "Instance" or not p26:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p27) ~= "Instance" or not p27:IsA("Player") then
			warn("Member must be a Player instance")

			return false
		end

		if typeof(p28) == "string" then
			if typeof(p29) == "boolean" then
				local v115: boolean = false
				local v116

				for iterFirst, iterSecond in u2 do
					if iterSecond.PhysicalParty.Members:FindFirstChild(p26.Name) then
						v116 = iterSecond
						v115 = true

						break
					end
				end

				if not v115 then
					v116 = nil
				end

				if not v116 or not v116:IsLeader(p26) then
				elseif p27 and v116:IsMember(p27) and p28 and p29 ~= nil then
					return v116:SetPermission(p27, p28, p29)
				end

				return false
			end

			warn("Toggle must be a boolean")

			return false
		end

		warn("Permission must be a string")

		return false
	end,
	RevokeInvite = function(p30, p31)
		if typeof(p30) ~= "Instance" or not p30:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p31) ~= "Instance" or not p31:IsA("Player") then
			warn("PlayerToRevoke must be a Player instance")

			return false
		end

		local v121: boolean = false
		local v122

		for iterFirst, iterSecond in u2 do
			if iterSecond.PhysicalParty.Members:FindFirstChild(p30.Name) then
				v122 = iterSecond
				v121 = true

				break
			end
		end

		if not v121 then
			v122 = nil
		end

		if not v122 or not v122:HasPermission(p30, "CanInvite") then
			return false
		end

		if not p31 then
			return false
		end

		return v122:RevokeInvite(p31)
	end,
	SetPartyName = function(p32, p33)
		if typeof(p32) ~= "Instance" or not p32:IsA("Player") then
			warn("Player must be a Player instance")

			return false
		end

		if typeof(p33) == "string" then
			local v127: boolean = false
			local v128

			for iterFirst, iterSecond in u2 do
				if iterSecond.PhysicalParty.Members:FindFirstChild(p32.Name) then
					v128 = iterSecond
					v127 = true

					break
				end
			end

			if not v127 then
				v128 = nil
			end

			if not v128 or not v128:IsLeader(p32) then
				return false
			end

			return v128:SetPartyName(p33)
		end

		warn("Name must be a string")

		return false
	end,
	GetParty = function(p34, p35)
		if typeof(p34) ~= "Instance" or not p34:IsA("Player") then
			warn("Player must be a Player instance")

			return false, nil
		end

		if typeof(p35) ~= "Instance" or not p35:IsA("Player") then
			warn("TargetPlayer must be a Player instance")

			return false, nil
		end

		if not p35 then
			return false, nil
		end

		local v133 = u3:GetParty(p35)

		if v133 == "NoParty" then
			return false, nil
		end

		return true, v133
	end
}

return {
	Setup = function(p36, p37)
		if typeof(p36) == "table" then
			if typeof(p37) == "table" then
				u2 = p36
				u3 = p37
				remoteFunction = Instance.new("RemoteFunction")
				remoteFunction.Name = "PartyRemoteFunction"
				remoteFunction.Parent = game.ReplicatedStorage

				function remoteFunction.OnServerInvoke(p38, p39, ...)
					if typeof(p38) ~= "Instance" or not p38:IsA("Player") then
						warn("Player must be a Player instance")

						return false, nil
					end

					if typeof(p39) == "string" then
						if p39 ~= "GetParty" then
							local serverStorage: ServerStorage = game:GetService("ServerStorage")

							if require(serverStorage:WaitForChild("MatchmakingGate")).IsMatchServer() then
								return false, nil
							end

							local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

							if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
								return false, nil
							end
						end

						local v162 = t1[p39]

						if v162 then
							return v162(p38, ...)
						end

						local v163 = ("Unknown remote request: %*"):format(p39)

						warn(v163)

						return false, nil
					end

					warn("Request must be a string")

					return false, nil
				end

				return
			end

			warn("PartySystemModule must be a table")

			return
		end

		warn("PartiesTable must be a table")
	end
}
