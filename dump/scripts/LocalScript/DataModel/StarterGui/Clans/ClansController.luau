-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local _locals: {[any]: any} = {}
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent

scriptParent.Enabled = false

local function wc(p1, ...)
	local v192 = p1

	for _, v in ipairs({ ... }) do
		v192 = v192:WaitForChild(v)
	end

	return v192
end

local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local clan: Instance = remotes:WaitForChild("Clan")

remotes:WaitForChild("PlayerRequestSend")

local v9 = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(v9:WaitForChild("WindowBlur"))

v9 = replicatedStorage:WaitForChild("Shared")

local windowSlide = require(v9:WaitForChild("WindowSlide"))

v9 = replicatedStorage:WaitForChild("Catalogs")

local clanCatalog = require(v9:WaitForChild("ClanCatalog"))

v9 = replicatedStorage:WaitForChild("Shared")

local clanRosterUI = require(v9:WaitForChild("ClanRosterUI"))

v9 = replicatedStorage:WaitForChild("Shared")

local clanImage = require(v9:WaitForChild("ClanImage"))

v9 = replicatedStorage:WaitForChild("Shared")

local invitePickerUI = require(v9:WaitForChild("InvitePickerUI"))

local ok, result = pcall(function()
	return require(replicatedStorage:WaitForChild("Sound"))
end)

local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local requestClanView: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("RequestClanView")
local v20 = wc(scriptParent, "CreateClan")
local v21 = wc(scriptParent, "ClanMenu")
local v22 = wc(scriptParent, "Manage")
local v23 = v20.Position
local v24 = windowSlide.closedPosFor(v23)
local u25 = nil
local u26: boolean = false
local u27: boolean = false

local function cancelSlide()
	if u25 then
		u25:Cancel()
		u25 = nil
	end
end
local function visibleFrame()
	if v20.Visible then
		return v20
	end

	if v21.Visible then
		return v21
	end

	if v22.Visible then
		return v22
	end

	return nil
end

local v30 = wc(v20, "Content", "TopPanel", "Name", "TextBoxContainer", "TextBox")
local v31 = wc(v20, "Content", "TopPanel", "Tag", "TextBoxContainer", "TextBox")
local v32 = wc(v20, "Content", "Image", "TextBoxContainer", "TextBox")

v9 = wc(v20, "CreateButton")

local v33 = wc(v9, "TextLabel", "TextLabel")
local v34 = wc(v9, "TextLabel")
local v35 = wc(v20, "Content", "Display", "ImageLabel")
local v36 = wc(v20, "Content", "Display", "TextLabel")
local v37 = wc(v20, "Content", "Display", "Leader")
local v38 = wc(v20, "Content", "Display", "TipText1")
local t2: {[any]: any} = { name = v36, image = v35, leader = v37, tip1 = v38 }
local v40 = wc(v21, "ClanInfo", "TextLabel")
local v41 = wc(v21, "ClanInfo", "ImageLabel")
local v42 = wc(v21, "ClanInfo", "Leader")
local v43 = wc(v21, "ClanInfo", "Stats", "Kills")
local v44 = wc(v21, "ClanInfo", "Stats", "Streak")
local v45 = wc(v21, "OnlineCount")
local v46 = wc(v21, "ScrollingFrame")

v38 = wc(v21, "Buttons", "ManageButton")
v37 = wc(v21, "Buttons", "LeaveButton")

local textLabel = v37:FindFirstChild("TextLabel")
local v48 = wc(v21, "Buttons", "InviteButton")
local v49 = wc(v21, "ClanInfo")
local v50 = wc(v21, "Buttons")
local v51 = wc(v21, "Stats")
local v52 = wc(v21, "Rank")
local v53 = wc(v21, "LeaderboardPage")
local v54 = wc(v53, "ScrollingFrame")
local v55 = wc(v53, "OnlineCount")
local t3: {[any]: any} = {}

for i, v in ipairs({ "One", "Two", "Three" }) do
	local foundChild = v54:FindFirstChild("ClanLeaderboard_Template_" .. v)

	if foundChild and foundChild:IsA("GuiObject") then
		foundChild.Visible = false
		t3[i] = foundChild
	end
end

v36 = nil

for _, v in ipairs(v54:GetChildren()) do
	if v:IsA("GuiObject") and v.Name == "ClanLeaderboard_Template" then
		if v36 then
			v:Destroy()
		else
			v.Visible = false
			v36 = v
		end
	end
end

local v62 = v36 and v36.Size or UDim2.new(0.98, 0, 0.2485, 0)
local v63 = wc(v53, "ClanLeaderboard_Template")

v63.Visible = false

local v64 = v36 or v63

v36 = wc(v53, "Buttons", "AllTimeButton")
v35 = wc(v53, "Buttons", "MonthlyButton")

local v65 = wc(v53, "Buttons", "WeeklyButton")
local t4: {[any]: any} = { AllTime = v36, Monthly = v35, Weekly = v65 }

v65 = v21:FindFirstChild("Leaderboards")

if v65 and v65:IsA("GuiObject") then
	v65.Visible = false
end

v65 = v21:FindFirstChild("ScrollingFrameLeaderboardComingSoon")

if v65 and v65:IsA("GuiObject") then
	v65.Visible = false
end

local t5: {[any]: any} = { AllTime = "All Time", Monthly = "Monthly", Weekly = "Weekly" }
local u68 = require(replicatedStorage.Shared.ClanRewardPeriod).Active()
local u69: boolean = false
local u70: boolean = false
local u71 = nil
local n1: number = 0

local function lbInnerFill(p2)
	local textLabel2 = p2:FindFirstChild("TextLabel")

	if not textLabel2 then
		return nil
	end

	local textLabel3 = textLabel2:FindFirstChild("TextLabel")

	if textLabel3 and textLabel3:IsA("TextLabel") then
		return textLabel3
	end

	return nil
end
local function lbWhiteBorder(p3)
	for _, v in ipairs(p3:GetChildren()) do
		if v:IsA("UIStroke") and v.Color.R > 0.8 and v.Color.G > 0.8 and v.Color.B > 0.8 then
			return v
		end
	end

	return nil
end

v65 = t4.AllTime
v35 = t4.Monthly

local backgroundColor3 = v65.BackgroundColor3
local v76 = v35.BackgroundColor3

v36 = v65:FindFirstChild("TextLabel")
_locals[1] = nil

if not v36 then
	_locals[1] = nil
else
	local textLabel4 = v36:FindFirstChild("TextLabel")

	_locals[1] = if textLabel4 and textLabel4:IsA("TextLabel") then textLabel4 else nil
end

v36 = v35:FindFirstChild("TextLabel")
_locals[2] = nil

if not v36 then
	_locals[2] = nil
else
	local textLabel5 = v36:FindFirstChild("TextLabel")

	_locals[2] = if textLabel5 and textLabel5:IsA("TextLabel") then textLabel5 else nil
end

local v79 = _locals[1] and _locals[1].TextColor3 or Color3.new(1, 1, 1)
local v80 = _locals[2] and _locals[2].TextColor3

if not v80 then
	v80 = Color3.fromRGB(134, 134, 134)
end

v36 = lbWhiteBorder(v65)
v65 = lbWhiteBorder(v35)

local v81 = v36 and v36.Transparency or 0.5
local v82 = v65 and v65.Transparency or 0.75
local v83 = wc(v21, "Navigator")

v65 = wc(v83, "Members")
v36 = wc(v83, "LeaderboardTab")

local v84 = wc(v65, "ImageLabel")
local v85 = wc(v65, "TextLabel")
local v86 = wc(v36, "ImageLabel")
local v87 = wc(v36, "TextLabel")
local imageColor3 = v84.ImageColor3
local v89 = v86.ImageColor3

v35 = wc(v21, "Stats", "Arrow")
v35.Active = true
v35.Selectable = true

local sortGlyph = v35:FindFirstChild("SortGlyph")
local imageLabel

if sortGlyph and sortGlyph:IsA("ImageLabel") then
	imageLabel = sortGlyph
else
	imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "SortGlyph"
	imageLabel.BackgroundTransparency = 1
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.Size = UDim2.fromScale(1, 1)
	imageLabel.ScaleType = v35.ScaleType
	imageLabel.Image = v35.Image
	imageLabel.Parent = v35
end

v35.Image = ""

local v92 = wc(v22, "Header", "TextLabel")

sortGlyph = wc(v22, "Navigator")

local v93 = wc(sortGlyph, "Members")
local v94 = wc(sortGlyph, "Roles")
local v95 = wc(sortGlyph, "Invites")
local v96 = wc(sortGlyph, "Upgrade")

sortGlyph = wc(v22, "Content")

local v97 = wc(sortGlyph, "MembersScrollingFrame")
local v98 = wc(sortGlyph, "RolesFrame")
local v99 = wc(sortGlyph, "InvitesScrollingFrame")
local v100 = wc(sortGlyph, "UpgradeFrame")

sortGlyph = wc(v100, "Upgrade")

local v101 = wc(sortGlyph, "UpgradeButton")
local v102 = wc(sortGlyph, "Description")
local v103 = sortGlyph:FindFirstChild("Header") and sortGlyph.Header:FindFirstChild("TextLabel")

require(replicatedStorage.Shared:WaitForChild("ScrollListFit")).bindAll({ v46, v54, v97, v99 })

local clanRosterUIRole_order = clanRosterUI.ROLE_ORDER
local text = v33.Text
local v106 = v92.Text
local u107: boolean = false
local u108: boolean = false
local u109 = nil

local function resolveLeaveText()
	if (u109 and tostring(u109.YourRole) or nil) == "Owner" and clanCatalog.OWNER_LEAVE_DISBANDS then
		return "Disband"
	end

	return "Leave"
end
local function setLeaveText(text)
	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel6 = textLabel:FindFirstChild("TextLabel")

		if textLabel6 and textLabel6:IsA("TextLabel") then
			textLabel6.Text = text
		end
	end
end

local u112 = nil
local s1 = "Members"

sortGlyph = clanRosterUI.grabTemplates

local v114, v115 = sortGlyph(v46)
local v116, v117 = sortGlyph(v97)

local function notifyError(p5)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p5 })
	end
end
local function notifySuccess(p6)
	if _G.Notify then
		_G.Notify({
			notifType = "SuccessNotification",
			topText = "Success!",
			bottomText = p6
		})
	end
end

local clanRosterUICommas = clanRosterUI.commas
local clanRosterUIFillCommon = clanRosterUI.fillCommon
local u122 = nil
local u123 = nil
local u124 = nil
local u125 = nil
local u126 = nil
local u127 = nil
local u128 = nil
local u129 = nil
local u130 = nil
local u131 = nil
local u132 = nil
local u133 = nil
local u134: boolean = false
local t6: {[any]: any} = {}
local u136: boolean = false

u122 = function(p7)
	v20.Visible = p7 == "Create"
	v21.Visible = p7 == "Menu"
	v22.Visible = p7 == "Manage"

	if u26 and p7 ~= "" then
		u26 = false

		local v206 = if v20.Visible then v20 else if v21.Visible then v21 else if v22.Visible then v22 else nil

		if v206 then
			if u25 then
				u25:Cancel()
				u25 = nil
			end

			u25 = windowSlide.slideIn(v206, v23, v24)
		end
	end
end
u124 = function()
	u70 = false
	u71 = nil
	u134 = false

	if u130 then
		u130()
	end

	if u133 then
		u133()
	end

	if not u27 then
		return
	end

	u27 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v208 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v208)
	pcall(function()
		windowBlur.hide("Clans")
	end)

	local v209 = if v20.Visible then v20 else if v21.Visible then v21 else if v22.Visible then v22 else nil

	if u25 then
		u25:Cancel()
		u25 = nil
	end

	if v209 then
		u25 = windowSlide.slideOut(v209, v24, function()
			if not u27 then
				scriptParent.Enabled = false

				for _, v in ipairs({ v20, v21, v22 }) do
					v.Position = v23
				end
			end
		end)

		return
	end

	scriptParent.Enabled = false
end

local function canKickTarget(p8, player, p10)
	if p10 then
	elseif typeof(player.UserId) == "number" and player.UserId ~= LocalPlayer.UserId then
		if p8 == "Owner" then
			return true
		end

		if p8 == "Officer" and player.Role == "Member" then
			return true
		end

		return false
	end

	return false
end
local function canInviteFromClient(p11)
	if not p11 then
		return false
	end

	if p11.YourRole ~= "Owner" and p11.YourRole ~= "Officer" then
		return false
	end

	if (p11.MemberCount or 0) >= (p11.MaxMembers or 0) then
		return false
	end

	return true
end

local clanRosterUIClearClones = clanRosterUI.clearClones

local function setKickLabel(p12, text)
	local textLabel7 = p12:FindFirstChild("TextLabel")

	if textLabel7 and textLabel7:IsA("TextLabel") then
		textLabel7.Text = text

		local textLabel8 = textLabel7:FindFirstChild("TextLabel")

		if textLabel8 and textLabel8:IsA("TextLabel") then
			textLabel8.Text = text
		end
	end
end
local function wireKickConfirm(p14, p15)
	local textLabel9 = p14:FindFirstChild("TextLabel")
	local v221 = textLabel9 and textLabel9:IsA("TextLabel") and textLabel9.Text or "Kick"
	local u222: boolean = false

	p14.MouseButton1Click:Connect(function()
		if u107 then
			return
		end

		if not u222 then
			u222 = true

			local textLabel10 = p14:FindFirstChild("TextLabel")

			if textLabel10 and textLabel10:IsA("TextLabel") then
				textLabel10.Text = "Confirm?"

				local textLabel11 = textLabel10:FindFirstChild("TextLabel")

				if textLabel11 and textLabel11:IsA("TextLabel") then
					textLabel11.Text = "Confirm?"
				end
			end

			task.delay(3, function()
				if u222 then
					u222 = false

					local text = v221
					local textLabel12 = p14:FindFirstChild("TextLabel")

					if textLabel12 and textLabel12:IsA("TextLabel") then
						textLabel12.Text = text

						local textLabel13 = textLabel12:FindFirstChild("TextLabel")

						if textLabel13 and textLabel13:IsA("TextLabel") then
							textLabel13.Text = text
						end
					end
				end
			end)

			return
		end

		u222 = false
		u126("Kick", p15)
	end)
end
local function makeMenuCard(player, p17, p18)
	local u226: boolean = player.Role == "Owner"
	local v227 = if u226 then v114 else v115

	if not v227 then
		return
	end

	local clone = v227:Clone()

	clone.Name = "ClanMemberCard"
	clone.LayoutOrder = p18 or clanRosterUIRole_order[player.Role] or 2
	clone.Visible = true
	clanRosterUIFillCommon(clone, player)
	clone:SetAttribute("SortKills", player.Kills or 0)
	clone:SetAttribute("SortStreak", player.Streak or 0)
	clone:SetAttribute("SortUserId", player.UserId or 0)

	local kickButton = clone:FindFirstChild("KickButton")

	if kickButton and kickButton:IsA("TextButton") then
		local visible: boolean = not u70 and (if u226 then false else if typeof(player.UserId) == "number" and player.UserId ~= LocalPlayer.UserId then if p17 == "Owner" then true else p17 == "Officer" and player.Role == "Member" else false)

		kickButton.Visible = visible

		if visible then
			wireKickConfirm(kickButton, player.UserId)
		end
	end

	clone.Parent = v46
end
local function renderMenuRoster()
	local v231 = u109

	if not v231 then
		return
	end

	clanRosterUIClearClones(v46)

	local t9 = v231.Members or {}
	local text: string = tostring(v231.YourRole or clanCatalog.DEFAULT_ROLE)

	if u112 == nil then
		clanRosterUI.sortMembers(t9)

		for _, v in ipairs(t9) do
			makeMenuCard(v, text)
		end

		return
	end

	local u236: boolean = u112 == "Streak"
	local v237 = table.clone(t9)

	table.sort(v237, function(player, player2)
		local v433 = if u236 then player.Streak or 0 else player.Kills or 0
		local v434 = if u236 then player2.Streak or 0 else player2.Kills or 0

		if v433 ~= v434 then
			return v433 > v434
		end

		v434 = if u236 then player.Kills or 0 else player.Streak or 0
		v433 = if u236 then player2.Kills or 0 else player2.Streak or 0

		if v434 ~= v433 then
			return v433 < v434
		end

		return (player.UserId or 0) < (player2.UserId or 0)
	end)

	for i, v in ipairs(v237) do
		makeMenuCard(v, text, i)
	end
end
local function applyMenuSortOrder()
	if u112 == nil then
		return
	end

	local u240: boolean = u112 == "Streak"
	local t10: {[any]: any} = {}

	for _, v in ipairs(v46:GetChildren()) do
		if v:IsA("Frame") and v.Name == "ClanMemberCard" then
			table.insert(t10, v)
		end
	end

	table.sort(t10, function(p21, p22)
		local v437 = if u240 then p21:GetAttribute("SortStreak") or 0 else p21:GetAttribute("SortKills") or 0
		local v438 = if u240 then p22:GetAttribute("SortStreak") or 0 else p22:GetAttribute("SortKills") or 0

		if v437 ~= v438 then
			return v437 > v438
		end

		v438 = if u240 then p21:GetAttribute("SortKills") or 0 else p21:GetAttribute("SortStreak") or 0
		v437 = if u240 then p22:GetAttribute("SortKills") or 0 else p22:GetAttribute("SortStreak") or 0

		if v438 ~= v437 then
			return v437 < v438
		end

		local sortUserId = p21:GetAttribute("SortUserId")
		local sortUserId2 = p22:GetAttribute("SortUserId")

		return (sortUserId or 0) < (sortUserId2 or 0)
	end)

	for i, v in ipairs(t10) do
		v.LayoutOrder = i
	end
end
local function getLbRemote()
	local clanLeaderboard: Instance = remotes:FindFirstChild("ClanLeaderboard")

	if clanLeaderboard and clanLeaderboard:IsA("RemoteFunction") then
		return clanLeaderboard
	end

	local remotesClanLeaderboard: Instance = remotes:WaitForChild("ClanLeaderboard", 5)

	if remotesClanLeaderboard and remotesClanLeaderboard:IsA("RemoteFunction") then
		return remotesClanLeaderboard
	end

	return nil
end
local function clearLbRows()
	for _, v in ipairs(v54:GetChildren()) do
		if v:IsA("GuiObject") and v.Name == "ClanLBRow" then
			v:Destroy()
		end
	end
end
local function setLbRowText(p23, p24, text)
	local foundChild2 = p23:FindFirstChild(p24)

	if foundChild2 and foundChild2:IsA("TextLabel") then
		foundChild2.Text = text
	end
end
local function fillLbRow(p26, p27, p28)
	local placeNumber = p26:FindFirstChild("PlaceNumber")

	if placeNumber and placeNumber:IsA("TextLabel") then
		placeNumber.Text = p28
	end

	local text: string = tostring(p27.Name or "Clan")
	local username = p26:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.Text = text
	end

	local v260 = formatLeaderLine(p27.DisplayTag, p27.OwnerName)
	local role_Rank = p26:FindFirstChild("Role_Rank")

	if role_Rank and role_Rank:IsA("TextLabel") then
		role_Rank.Text = v260
	end

	local playerDisplay = p26:FindFirstChild("PlayerDisplay")

	if playerDisplay and playerDisplay:IsA("ImageLabel") then
		clanImage.apply(playerDisplay, p27.ImageId)
	end

	local contributions = p26:FindFirstChild("Contributions")

	if contributions then
		local v264 = clanRosterUICommas(p27.Kills or 0)
		local kills = contributions:FindFirstChild("Kills")

		if kills and kills:IsA("TextLabel") then
			kills.Text = "💀 Kills: <b>" .. v264 .. "</b>"
		end

		local text2: string = tostring(p27.Streak or 0)
		local streak = contributions:FindFirstChild("Streak")

		if streak and streak:IsA("TextLabel") then
			streak.Text = "🔥 Streak: <b>" .. text2 .. "</b>"
		end
	end
end
local function makeLbRow(p29, layoutOrder)
	local clone = (p29.Rank and t3[p29.Rank] or v64):Clone()

	clone.Name = "ClanLBRow"
	clone.LayoutOrder = layoutOrder
	clone.Size = v62
	clone.Visible = true

	local text: string = tostring(p29.Rank)

	fillLbRow(clone, p29, "#" .. text)

	if clone:IsA("GuiButton") and typeof(p29.ClanId) == "string" and #p29.ClanId > 0 then
		clone.MouseButton1Click:Connect(function()
			requestClanView:Fire({ returnTo = "Leaderboard", clanId = p29.ClanId })
		end)
	end

	clone.Parent = v54

	return clone
end
local function updateYouRow(p31)
	if not p31 then
		v63.Visible = false

		return
	end

	local s1 = p31.Rank ~= nil and "#" .. tostring(p31.Rank) or "N/A"

	fillLbRow(v63, p31, s1)
	v63.Visible = true
end
local function setLbTabHighlight(p32)
	for k, v in pairs(t4) do
		local u277: boolean = k == p32

		v.BackgroundColor3 = u277 and backgroundColor3 or v76

		local textLabel14 = v:FindFirstChild("TextLabel")
		local v279

		if not textLabel14 then
			v279 = nil
		else
			local textLabel15 = textLabel14:FindFirstChild("TextLabel")

			v279 = if textLabel15 and textLabel15:IsA("TextLabel") then textLabel15 else nil
		end

		if v279 then
			v279.TextColor3 = u277 and v79 or v80
		end

		local v281 = lbWhiteBorder(v)

		if v281 then
			v281.Transparency = u277 and v81 or v82
		end
	end
end
local function showLbPeriod(p33)
	u68 = p33
	v55.Text = "<b>" .. (t5[p33] or "All Time") .. "</b> Rankings"
	setLbTabHighlight(p33)
	n1 += 1

	local v283: number = n1

	clearLbRows()
	v63.Visible = false

	local clanLeaderboard: Instance = remotes:FindFirstChild("ClanLeaderboard")
	local v285

	if clanLeaderboard and clanLeaderboard:IsA("RemoteFunction") then
		v285 = clanLeaderboard
	else
		local remotesClanLeaderboard: Instance = remotes:WaitForChild("ClanLeaderboard", 5)

		v285 = if remotesClanLeaderboard and remotesClanLeaderboard:IsA("RemoteFunction") then remotesClanLeaderboard else nil
	end

	if not v285 then
		return
	end

	task.spawn(function()
		for _ = 1, 8 do
			local ok2, result2 = pcall(function()
				return v285:InvokeServer("GetBoard", p33, true)
			end)

			if v283 ~= n1 then
				return
			end

			if not u27 or not v21.Visible or not v53.Visible then
				return
			end

			if not ok2 or typeof(result2) ~= "table" then
				return
			end

			clearLbRows()

			for i, v in ipairs(result2.board or {}) do
				makeLbRow(v, i)
			end

			local result2You = result2.you

			if not result2You then
				v63.Visible = false
			else
				local s1 = result2You.Rank ~= nil and "#" .. tostring(result2You.Rank) or "N/A"

				fillLbRow(v63, result2You, s1)
				v63.Visible = true
			end

			if not result2.loading then
				return
			end

			task.wait(4)

			if v283 ~= n1 then
				return
			end
		end
	end)
end

local v153 = wc(v21, "EditPage")

sortGlyph = wc(v153, "Content", "Display", "TextLabel")

local v154 = wc(v153, "Content", "Display", "ImageLabel")
local v155 = wc(v153, "Content", "Display", "Leader")
local v156 = wc(v153, "Content", "Display", "TipText1")
local v157 = wc(v153, "Content", "TopPanel", "Name", "TextBoxContainer", "TextBox")
local v158 = wc(v153, "Content", "TopPanel", "Tag", "TextBoxContainer", "TextBox")
local v159 = wc(v153, "Content", "Image", "TextBoxContainer", "TextBox")
local v160 = wc(v153, "EditButton")
local v161 = wc(v83, "Edit")

local v162 = (function()
	local v287 = wc(v21, "UpgradeFrame")
	local v288 = wc(v287, "Upgrade")
	local t11: {[any]: any} = {}

	for _, v in ipairs(v288:GetChildren()) do
		if v:IsA("TextLabel") and v.Name == "Description" then
			table.insert(t11, v)
		end
	end

	table.sort(t11, function(p34, p35)
		return p34.Position.Y.Scale < p35.Position.Y.Scale
	end)

	local v292 = wc(v83, "Upgrade")
	local v293 = wc(v288, "UpgradeButton")

	return {
		render = nil,
		nav = v292,
		frame = v287,
		btn = v293,
		header = v288:FindFirstChild("Header") and v288.Header:FindFirstChild("TextLabel"),
		prompt = t11[1],
		cost = t11[2]
	}
end)()

local function fillDisplay(p36, p37)
	p36.name.Text = p37.Name ~= nil and p37.Name ~= "" and tostring(p37.Name) or "Clan Name"
	clanImage.apply(p36.image, p37.ImageId)
	p36.leader.Text = formatLeaderLine(p37.Tag, p37.OwnerName)

	if p36.tip1 then
		local v296 = p37.MaxMembers or 0
		local tip1 = p36.tip1
		local text: string = tostring(p37.MemberCount or 0)
		local text3: string = tostring(v296)

		tip1.Text = "<b>" .. text .. "/" .. text3 .. "</b> Members"
	end
end

local t7: {[any]: any} = { name = sortGlyph, image = v154, leader = v155, tip1 = v156 }

local function refreshEditPreview()
	local t12 = u109 or {}

	fillDisplay(t7, {
		Name = t12.Name,
		Tag = v158.Text,
		ImageId = v159.Text ~= "" and v159.Text or t12.ImageId,
		OwnerName = t12.OwnerName,
		MemberCount = t12.MemberCount,
		MaxMembers = t12.MaxMembers
	})
end
local function u166()
	local t13 = u109 or {}

	v157.Text = tostring(t13.Name or "")
	v158.Text = tostring(t13.Tag or "")
	v159.Text = tostring(t13.ImageId or "")
	v157.TextEditable = false
	refreshEditPreview()
end
function v162.render()
	local v302 = u109

	if not v302 then
		return
	end

	if v162.header and v162.header:IsA("TextLabel") then
		v162.header.Text = "Upgrade Max Members"
	end

	local clanCatalogMax_member_cap = clanCatalog.MAX_MEMBER_CAP
	local v304 = v302.MaxMembers or 0

	if clanCatalogMax_member_cap <= v304 then
		if v162.prompt then
			v162.prompt.Text = "Your clan is at the maximum size (" .. tostring(clanCatalogMax_member_cap) .. ")."
		end

		if v162.cost then
			v162.cost.Visible = false
		end

		v162.btn.Visible = false

		return
	end

	if v302.YourRole == "Owner" then
		local v305 = clanCatalog.GetUpgradeCost(v304)
		local v306 = math.min(v304 + clanCatalog.UPGRADE_MEMBER_STEP, clanCatalogMax_member_cap)

		if v162.prompt then
			v162.prompt.Text = "Increase the member capacity of your clan by " .. tostring(v306 - v304) .. "?"
		end

		if v162.cost then
			local cash = LocalPlayer:GetAttribute("Cash")

			cash = typeof(cash) == "number" and cash or 0
			v162.cost.Visible = true

			local cost = v162.cost
			local v309 = clanRosterUICommas(cash)
			local v310 = clanRosterUICommas(v305)

			cost.Text = "<font color=\"" .. (if v305 <= cash then "#ffd024" else "#ff5555") .. "\"><b>$" .. v309 .. "</b></font>/$" .. v310 .. " coins"
		end

		v162.btn.Visible = true

		return
	end

	if v162.prompt then
		local prompt = v162.prompt
		local text: string = tostring(v304)
		local text4: string = tostring(clanCatalogMax_member_cap)

		prompt.Text = "Capacity: " .. text .. "/" .. text4 .. ". Only the leader can upgrade."
	end

	if v162.cost then
		v162.cost.Visible = false
	end

	v162.btn.Visible = false
end
local function setClanMenuView(p38)
	local u315 = p38 == "Members"
	local visible: boolean = p38 == "Leaderboards"
	local u317: boolean = p38 == "Edit"
	local u318: boolean = p38 == "Upgrade"

	v51.Visible = u315
	v52.Visible = u315
	v45.Visible = u315
	v46.Visible = u315
	v49.Visible = u315
	v50.Visible = u315 and not u70
	v53.Visible = visible
	v153.Visible = u317
	v162.frame.Visible = u318
	v83.Visible = not u70

	local v319 = if u315 then imageColor3 else v89

	u315 = if visible then imageColor3 else v89

	local v320 = if u317 then imageColor3 else v89

	v84.ImageColor3 = v319
	v85.TextColor3 = v319
	v86.ImageColor3 = u315
	v87.TextColor3 = u315

	local imageLabel = v161:FindFirstChild("ImageLabel")
	local textLabel16 = v161:FindFirstChild("TextLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.ImageColor3 = v320
	end

	if textLabel16 and textLabel16:IsA("TextLabel") then
		textLabel16.TextColor3 = v320
	end

	v320 = if u318 then imageColor3 else v89

	local imageLabel2 = v162.nav:FindFirstChild("ImageLabel")
	local textLabel17 = v162.nav:FindFirstChild("TextLabel")

	if imageLabel2 and imageLabel2:IsA("ImageLabel") then
		imageLabel2.ImageColor3 = v320
	end

	if textLabel17 and textLabel17:IsA("TextLabel") then
		textLabel17.TextColor3 = v320
	end

	if visible then
		local clanRewardPeriod = require(replicatedStorage.Shared.ClanRewardPeriod)

		showLbPeriod(clanRewardPeriod.Active())
	elseif u317 then
		u166()
	elseif u318 then
		v162.render()
	end
end
function formatLeaderLine(p39, p40)
	local text: string = tostring(p40 or "?")

	if typeof(p39) == "string" and p39 ~= "" then
		return "[" .. p39 .. "] Leader: " .. text
	end

	return "Leader: " .. text
end
local function applyMenuData(p41)
	u109 = p41
	v40.Text = tostring(p41.Name or "Clan")
	clanImage.apply(v41, p41.ImageId)
	v42.Text = formatLeaderLine(p41.Tag, p41.OwnerName)

	local t14 = p41.Totals or {}

	v43.Text = "💀 Clan Kills: <b>" .. clanRosterUICommas(t14.Kills or 0) .. "</b>"
	v44.Text = "🔥 Streak: <b>" .. tostring(t14.Streak or 0) .. "</b>"

	local text: string = tostring(p41.MemberCount or 0)
	local text5: string = tostring(p41.MaxMembers or 0)

	v45.Text = "<b>Members</b> (" .. text .. "/" .. text5 .. ")"

	local yourRole = p41.YourRole

	v48.Visible = if not p41 then false else if yourRole == "Owner" or yourRole == "Officer" then not ((p41.MemberCount or 0) >= (p41.MaxMembers or 0)) else false
	renderMenuRoster()
end

u127 = function(p42)
	applyMenuData(p42)
	u108 = false

	local text: string = if (u109 and tostring(u109.YourRole) or nil) == "Owner" and clanCatalog.OWNER_LEAVE_DISBANDS then "Disband" else "Leave"

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel18 = textLabel:FindFirstChild("TextLabel")

		if textLabel18 and textLabel18:IsA("TextLabel") then
			textLabel18.Text = text
		end
	end

	if u69 then
		u69 = false
		setClanMenuView("Leaderboards")

		return
	end

	setClanMenuView("Members")
end

local function makeManageMemberCard(player, p44)
	local u339: boolean = player.Role == "Owner"
	local v340 = if u339 then v116 else v117

	if not v340 then
		return
	end

	local clone = v340:Clone()

	clone.Name = "ClanMemberCard"
	clone.LayoutOrder = clanRosterUIRole_order[player.Role] or 2
	clone.Visible = true
	clanRosterUIFillCommon(clone, player)

	local kickButton = clone:FindFirstChild("KickButton")

	if kickButton and kickButton:IsA("GuiButton") then
		kickButton.Visible = false
	end

	local buttons = clone:FindFirstChild("Buttons")

	if buttons then
		local transferButton = buttons:FindFirstChild("TransferButton")

		if transferButton and transferButton:IsA("GuiButton") then
			transferButton.Visible = false
		end

		local kickButton2 = buttons:FindFirstChild("KickButton")

		if kickButton2 and kickButton2:IsA("TextButton") then
			local visible: boolean = if u339 then false else if typeof(player.UserId) == "number" and player.UserId ~= LocalPlayer.UserId then if p44 == "Owner" then true else p44 == "Officer" and player.Role == "Member" else false

			kickButton2.Visible = visible

			if visible then
				wireKickConfirm(kickButton2, player.UserId)
			end
		end

		local demoteButton = buttons:FindFirstChild("DemoteButton")

		if demoteButton and demoteButton:IsA("GuiButton") then
			demoteButton.Visible = false
		end
	end

	clone.Parent = v97
end
local function renderMembers()
	clanRosterUIClearClones(v97)

	local v348 = u109

	if not v348 then
		return
	end

	local t15 = v348.Members or {}

	clanRosterUI.sortMembers(t15)

	for _, v in ipairs(t15) do
		local text: string = tostring(v348.YourRole or clanCatalog.DEFAULT_ROLE)

		makeManageMemberCard(v, text)
	end
end
local function renderUpgrade()
	local v353 = u109

	if not v353 then
		return
	end

	if v103 and v103:IsA("TextLabel") then
		v103.Text = "Upgrade Max Members"
	end

	local clanCatalogMax_member_cap = clanCatalog.MAX_MEMBER_CAP
	local v355 = v353.MaxMembers or 0
	local v356 = clanCatalog.GetUpgradeCost(v355)

	if clanCatalogMax_member_cap <= v355 then
		v102.Text = "Your clan is at the maximum size (" .. tostring(clanCatalogMax_member_cap) .. ")."
		v101.Visible = false

		return
	end

	if v353.YourRole == "Owner" then
		local text: string = tostring(v355)
		local text6: string = tostring(v355 + 1)
		local v359 = clanRosterUICommas(v356)

		v102.Text = "Capacity " .. text .. " → " .. text6 .. "    <font color=\"#ffd024\"><b>$" .. v359 .. "</b></font> coins"
		v101.Visible = true

		return
	end

	local text: string = tostring(v355)
	local text7: string = tostring(clanCatalogMax_member_cap)

	v102.Text = "Capacity: " .. text .. "/" .. text7 .. ". Only the leader can upgrade."
	v101.Visible = false
end

local v172 = invitePickerUI.new({
	requestType = "ClanInvite",
	cooldown = 5,
	showStats = true,
	scrollingFrame = v99,
	isInvitable = function(p45)
		if p45 == LocalPlayer then
		elseif p45:GetAttribute("ClanTag") == nil then
			if p45:GetAttribute("InMatch") == true then
				return false
			end

			return true
		end

		return false
	end,
	canInvite = function()
		local v363 = u109

		if not v363 then
			return false
		end

		if v363.YourRole ~= "Owner" and v363.YourRole ~= "Officer" then
			return false
		end

		if (v363.MemberCount or 0) >= (v363.MaxMembers or 0) then
			return false
		end

		return true
	end,
	successText = function(p46)
		return "Invited " .. p46.DisplayName .. " to your clan!"
	end,
	bindLiveSignals = function(p47)
		local t16: {[any]: any} = {}

		for _, v in ipairs(players:GetPlayers()) do
			local v369 = v:GetAttributeChangedSignal("ClanTag")

			table.insert(t16, v369:Connect(p47))
		end

		table.insert(t16, players.PlayerAdded:Connect(function(player: Player)
			local v451: RBXScriptSignal = player:GetAttributeChangedSignal("ClanTag")

			table.insert(t16, v451:Connect(p47))
		end))

		return t16
	end
})

u130 = function()
	v172.close()
end

local function v173()
	v172.render()
end

u129 = function()
	local v370 = u109
	local yourRole = v370.YourRole

	if not (if not v370 then false else if yourRole == "Owner" or yourRole == "Officer" then not ((v370.MemberCount or 0) >= (v370.MaxMembers or 0)) else false) then
		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = "Only the leader can invite, and the clan can't be full."
			})
		end

		return
	end

	u122("Manage")
	v92.Text = "INVITE"
	v97.Visible = false
	v98.Visible = false
	v100.Visible = false
	v99.Visible = true
	u134 = true
	v172.open()
end
u128 = function(p49)
	u134 = false
	u130()
	v92.Text = v106
	s1 = p49
	v97.Visible = p49 == "Members"
	v100.Visible = p49 == "Upgrade"
	v98.Visible = false
	v99.Visible = false

	if p49 == "Members" then
		renderMembers()
	elseif p49 == "Upgrade" then
		renderUpgrade()
	end
end

local u174 = nil

u125 = function()
	local ok3, result3 = pcall(function()
		return clan:InvokeServer("GetMine")
	end)

	if ok3 and result3 and result3.ok and result3.clan then
		u174 = result3.clan
		u127(result3.clan)
		u122("Menu")

		return
	end

	if ok3 and result3 and result3.ok then
		u69 = false
		u109 = nil
		u174 = nil
		u122("Create")

		return
	end

	if u174 then
		u127(u174)
		u122("Menu")

		return
	end

	u69 = false

	if _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = ok3 and result3 and result3.reason or "Couldn't load your clan right now. Try again in a moment."
		})
	end

	u124()
end
u126 = function(p50, p51, p52)
	if u107 then
		return
	end

	u107 = true

	local ok4, result4 = pcall(function()
		return clan:InvokeServer(p50, p51)
	end)

	u107 = false

	if ok4 and result4 and result4.ok then
		if result4.clan then
			u109 = result4.clan

			if v22.Visible then
				u128(s1)
			elseif v21.Visible and v162.frame.Visible then
				applyMenuData(result4.clan)
				setClanMenuView("Upgrade")
			else
				u127(result4.clan)
			end

			if p52 and _G.Notify then
				_G.Notify({
					notifType = "SuccessNotification",
					topText = "Success!",
					bottomText = p52
				})

				return
			end
		elseif result4.left or result4.disbanded then
			u109 = nil
			u174 = nil
			u122("Create")

			return
		end
	elseif _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = result4 and result4.reason or "Something went wrong."
		})
	end
end

local function affectsMyClan(player)
	local v381 = u109

	if not v381 then
		return false
	end

	if player:GetAttribute("ClanName") == v381.Name then
		return true
	end

	for _, v in ipairs(v381.Members or {}) do
		if v.UserId == player.UserId then
			return true
		end
	end

	return false
end
local function queueLiveRefresh()
	if u136 then
		return
	end

	u136 = true
	task.delay(0.3, function()
		u136 = false
		u131()
	end)
end

u131 = function()
	if u70 then
		return
	end

	if not u27 or not v21.Visible then
		return
	end

	local ok5, result5 = pcall(function()
		return clan:InvokeServer("GetMine")
	end)

	if ok5 and result5 and result5.ok and result5.clan then
		u174 = result5.clan
		applyMenuData(result5.clan)
	elseif ok5 and result5 and result5.ok then
		u125()
	end
end

local function hookMenuClanTag(p54)
	local v387 = p54:GetAttributeChangedSignal("ClanName")

	table.insert(t6, v387:Connect(function()
		if not u27 or not v21.Visible or not affectsMyClan(p54) then
			return
		end

		if u136 then
			return
		end

		u136 = true
		task.delay(0.3, function()
			u136 = false
			u131()
		end)
	end))
end

u133 = function()
	for _, v in ipairs(t6) do
		v:Disconnect()
	end

	table.clear(t6)
end
u132 = function()
	u133()
	table.insert(t6, players.PlayerAdded:Connect(function(player: Player)
		local v453: RBXScriptSignal = player:GetAttributeChangedSignal("ClanName")

		table.insert(t6, v453:Connect(function()
			if not u27 or not v21.Visible or not affectsMyClan(player) then
				return
			end

			if u136 then
				return
			end

			u136 = true
			task.delay(0.3, function()
				u136 = false
				u131()
			end)
		end))

		if not u27 or not v21.Visible or not affectsMyClan(player) then
			return
		end

		if u136 then
			return
		end

		u136 = true
		task.delay(0.3, function()
			u136 = false
			u131()
		end)
	end))
	table.insert(t6, players.PlayerRemoving:Connect(function(player: Player)
		if not u27 or not v21.Visible or not affectsMyClan(player) then
			return
		end

		if u136 then
			return
		end

		u136 = true
		task.delay(0.3, function()
			u136 = false
			u131()
		end)
	end))

	for _, v in ipairs(players:GetPlayers()) do
		local v392 = v:GetAttributeChangedSignal("ClanName")

		table.insert(t6, v392:Connect(function()
			if not u27 or not v21.Visible or not affectsMyClan(v) then
				return
			end

			if u136 then
				return
			end

			u136 = true
			task.delay(0.3, function()
				u136 = false
				u131()
			end)
		end))
	end
end

local function doCreate()
	if u107 then
		return
	end

	local text2 = v30.Text

	if #text2:gsub("%s", "") == 0 then
		if _G.Notify then
			_G.Notify({ notifType = "FailNotification", errorMessage = "Enter a clan name." })
		end

		return
	end

	local v394 = v31.Text

	if #v394:gsub("%s", "") == 0 then
		if _G.Notify then
			_G.Notify({ notifType = "FailNotification", errorMessage = "Enter a clan tag." })
		end

		return
	end

	u107 = true
	v33.Text = "Creating..."
	v34.Text = "Creating..."

	local ok6, result6 = pcall(function()
		return clan:InvokeServer("Create", { Name = text2, Tag = v394, Image = v32.Text })
	end)

	u107 = false
	v33.Text = text
	v34.Text = text

	if ok6 and result6 and result6.ok and result6.clan then
		v30.Text = ""
		v31.Text = ""
		v32.Text = ""
		u127(result6.clan)
		u122("Menu")

		if _G.Notify then
			_G.Notify({
				notifType = "SuccessNotification",
				topText = "Success!",
				bottomText = "Clan created!"
			})

			return
		end
	elseif _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = result6 and result6.reason or "Couldn't create the clan."
		})
	end
end

u123 = function()
	if u25 then
		u25:Cancel()
		u25 = nil
	end

	local v397: boolean = u27

	if not u27 then
		u27 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		pcall(function()
			windowBlur.show("Clans")
		end)
	end

	activeWindowChanged:Fire("Clans")
	u122("")
	scriptParent.Enabled = true
	u26 = not v397
	u112 = nil
	imageLabel.Rotation = 0
	u70 = false
	u71 = nil
	u125()
	u132()
end
_G.OpenClans = u123

function _G.OpenClansLeaderboard()
	u69 = true
	u123()
end

local u179: boolean = false

local function enterExternalView(p57, p58)
	u70 = true
	u71 = p58
	applyMenuData(p57)
	setClanMenuView("Members")

	if u25 then
		u25:Cancel()
		u25 = nil
	end

	local v401: boolean = u27

	if not u27 then
		u27 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		pcall(function()
			windowBlur.show("Clans")
		end)
	end

	activeWindowChanged:Fire("Clans")
	scriptParent.Enabled = true
	u26 = not v401
	u122("Menu")
end
local function onPanelClose()
	if u70 then
		local v403 = u71

		u70 = false
		u71 = nil

		if v403 == "Leaderboard" then
			u69 = false
			setClanMenuView("Leaderboards")
			task.spawn(u131)

			return
		end

		u124()

		return
	end

	u124()
end

requestClanView.Event:Connect(function(player)
	local u405 = nil
	local clanId = nil
	local v407 = nil

	if typeof(player) == "table" and typeof(player.clanId) == "string" then
		u405 = "ViewClan"
		clanId = player.clanId

		if player.returnTo == "Leaderboard" then
			v407 = "Leaderboard"
		end
	elseif typeof(player) == "number" then
		u405 = "ViewOf"
		clanId = player
	elseif typeof(player) == "Instance" and player:IsA("Player") then
		u405 = "ViewOf"
		clanId = player.UserId
	end

	if not u405 then
		return
	end

	if u179 then
		return
	end

	u179 = true

	local ok7, result7 = pcall(function()
		return clan:InvokeServer(u405, clanId)
	end)

	u179 = false

	if not ok7 or not result7 or not result7.ok or not result7.clan then
		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = result7 and result7.reason or "Couldn't load that clan."
			})
		end

		return
	end

	enterExternalView(result7.clan, v407)
end)

function _G.ToggleClans()
	if u27 then
		u124()

		return
	end

	u123()
end

activeWindowChanged.Event:Connect(function(p60)
	if p60 ~= "Clans" and scriptParent.Enabled then
		u124()
	end
end)
v9.MouseButton1Click:Connect(function()
	doCreate()
end)
v38.MouseButton1Click:Connect(function()
	u122("Manage")
	u128("Members")
end)
v48.MouseButton1Click:Connect(function()
	u129()
end)
v35.Activated:Connect(function()
	if not u109 then
		return
	end

	u112 = if u112 == "Streak" then "Kills" else "Streak"
	imageLabel.Rotation = 180
	applyMenuSortOrder()
end)
v37.MouseButton1Click:Connect(function()
	if u107 then
		return
	end

	if not u108 then
		u108 = true

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = "Are you sure?"

			local textLabel19 = textLabel:FindFirstChild("TextLabel")

			if textLabel19 and textLabel19:IsA("TextLabel") then
				textLabel19.Text = "Are you sure?"
			end
		end

		task.delay(3, function()
			if u108 then
				u108 = false

				local text: string = if (u109 and tostring(u109.YourRole) or nil) == "Owner" and clanCatalog.OWNER_LEAVE_DISBANDS then "Disband" else "Leave"

				if textLabel and textLabel:IsA("TextLabel") then
					textLabel.Text = text

					local textLabel20 = textLabel:FindFirstChild("TextLabel")

					if textLabel20 and textLabel20:IsA("TextLabel") then
						textLabel20.Text = text
					end
				end
			end
		end)

		return
	end

	u108 = false

	local text: string = if (u109 and tostring(u109.YourRole) or nil) == "Owner" and clanCatalog.OWNER_LEAVE_DISBANDS then "Disband" else "Leave"

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel21 = textLabel:FindFirstChild("TextLabel")

		if textLabel21 and textLabel21:IsA("TextLabel") then
			textLabel21.Text = text
		end
	end

	u126("Leave")
end)
v65.MouseButton1Click:Connect(function()
	setClanMenuView("Members")
end)
v36.MouseButton1Click:Connect(function()
	setClanMenuView("Leaderboards")
end)
v161.MouseButton1Click:Connect(function()
	if u109 and u109.YourRole == "Owner" then
		setClanMenuView("Edit")
	elseif _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Only the clan leader can edit the clan."
		})
	end
end)
v162.nav.MouseButton1Click:Connect(function()
	setClanMenuView("Upgrade")
end)
v162.btn.MouseButton1Click:Connect(function()
	local v414 = u109

	if not v414 then
	elseif v414.YourRole == "Owner" then
		local v415 = v414.MaxMembers or 0

		if v415 >= clanCatalog.MAX_MEMBER_CAP then
			if _G.Notify then
				_G.Notify({
					notifType = "FailNotification",
					errorMessage = "Your clan is already at the maximum size."
				})
			end

			return
		end

		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		if require(shared:WaitForChild("InsufficientFundsPrompt")).PromptIfNeeded("Cash", clanCatalog.GetUpgradeCost(v415)) then
			return
		end

		u126("Upgrade", nil, "Max members increased!")
	elseif _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Only the clan leader can upgrade the clan."
		})
	end
end)
LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
	if u27 and v21.Visible and v162.frame.Visible then
		v162.render()
	end
end)
v158:GetPropertyChangedSignal("Text"):Connect(refreshEditPreview)
v159:GetPropertyChangedSignal("Text"):Connect(refreshEditPreview)

local u182: boolean = false

v160.Activated:Connect(function()
	if u182 then
	elseif u109 and u109.YourRole == "Owner" then
		u182 = true

		local ok8, result8 = pcall(function()
			return clan:InvokeServer("UpdateClan", { Tag = v158.Text, Image = v159.Text })
		end)

		u182 = false

		if not ok8 or not result8 or not result8.ok then
			if _G.Notify then
				_G.Notify({
					notifType = "FailNotification",
					errorMessage = result8 and result8.reason or "Couldn't save changes."
				})
			end

			return
		end

		applyMenuData(result8.clan)

		if _G.Notify then
			_G.Notify({
				notifType = "SuccessNotification",
				topText = "Success!",
				bottomText = "Clan updated!"
			})
		end

		setClanMenuView("Members")
	elseif _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Only the clan leader can edit the clan."
		})
	end
end)

for k, v in pairs(t4) do
	v.MouseButton1Click:Connect(function()
		if u68 ~= k then
			showLbPeriod(k)
		end
	end)
end

v93.MouseButton1Click:Connect(function()
	u128("Members")
end)
v94.MouseButton1Click:Connect(function()
	if _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Role permissions are coming soon!"
		})
	end
end)
v95.MouseButton1Click:Connect(function()
	if _G.Notify then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Clan join requests are coming soon!"
		})
	end
end)
v96.MouseButton1Click:Connect(function()
	u128("Upgrade")
end)
v101.MouseButton1Click:Connect(function()
	u126("Upgrade", nil, "Max members increased!")
end)

local function backToMenu()
	u134 = false
	u130()

	if u109 then
		u127(u109)
		u122("Menu")
		task.spawn(u131)

		return
	end

	u125()
end

for _, v in ipairs({ v20, v21 }) do
	local closeButton = v:FindFirstChild("CloseButton")

	if closeButton and closeButton:IsA("GuiButton") then
		closeButton.MouseButton1Click:Connect(function()
			if u70 then
				local v419 = u71

				u70 = false
				u71 = nil

				if v419 == "Leaderboard" then
					u69 = false
					setClanMenuView("Leaderboards")
					task.spawn(u131)

					return
				end

				u124()

				return
			end

			u124()
		end)
	end
end

v160 = v22:FindFirstChild("CloseButton")

if v160 and v160:IsA("GuiButton") then
	v160.MouseButton1Click:Connect(function()
		u134 = false
		u130()

		if u109 then
			u127(u109)
			u122("Menu")
			task.spawn(u131)

			return
		end

		u125()
	end)
end

v160 = function()
	fillDisplay(t2, {
		MemberCount = 1,
		Name = v30.Text,
		Tag = v31.Text,
		ImageId = v32.Text ~= "" and v32.Text or nil,
		OwnerName = LocalPlayer.DisplayName,
		MaxMembers = clanCatalog.BASE_MEMBER_CAP
	})
end
v30:GetPropertyChangedSignal("Text"):Connect(v160)
v32:GetPropertyChangedSignal("Text"):Connect(v160)
v31:GetPropertyChangedSignal("Text"):Connect(v160)
v160()

local t8: {[any]: any} = {}

local function sanitizeTagBox(p61)
	if t8[p61] then
		return
	end

	local text = p61.Text
	local v422 = text

	if clanCatalog.TAG_FORCE_UPPERCASE then
		v422 = string.upper(v422)
	end

	local v423 = utf8.len(v422)

	if v423 and v423 > clanCatalog.TAG_MAX_LENGTH then
		local n1: number = 0

		for iterValue in utf8.codes(v422) do
			n1 += 1

			if n1 > clanCatalog.TAG_MAX_LENGTH then
				v422 = string.sub(v422, 1, iterValue - 1)

				break
			end
		end
	end

	if v422 ~= text then
		t8[p61] = true
		p61.Text = v422
		t8[p61] = nil
	end
end

v160 = function(p62)
	p62:GetPropertyChangedSignal("Text"):Connect(function()
		sanitizeTagBox(p62)
	end)
	sanitizeTagBox(p62)
end
v160(v31)
v160(v158)
