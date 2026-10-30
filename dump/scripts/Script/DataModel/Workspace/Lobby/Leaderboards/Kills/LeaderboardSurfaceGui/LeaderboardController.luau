-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local globalLeaderboard: Instance = remotes:WaitForChild("GlobalLeaderboard")
local scriptParent: Instance = script.Parent
local scrollingFrame: Instance = scriptParent:WaitForChild("ScrollingFrame")
local options: Instance = scriptParent:WaitForChild("Options")
local you: Instance = scriptParent:WaitForChild("You")
local number1Template: Instance = scrollingFrame:WaitForChild("Number1Template")
local number2Template: Instance = scrollingFrame:WaitForChild("Number2Template")
local number3Template: Instance = scrollingFrame:WaitForChild("Number3Template")
local regularTemplate: Instance = scrollingFrame:WaitForChild("RegularTemplate")
local allTime: Instance = options:FindFirstChild("AllTime")
local monthly: Instance = options:FindFirstChild("Monthly")
local daily: Instance = options:FindFirstChild("Daily")
local stat: any = scriptParent:GetAttribute("Stat")

if not stat then
	scriptParent:GetAttributeChangedSignal("Stat"):Wait()
	stat = scriptParent:GetAttribute("Stat")
end

local t1: {[any]: any} = { Wins = true, Kills = true }
local size100x100 = Enum.ThumbnailSize.Size100x100
local t2: {[any]: any} = { AllTime = "AllTime", Monthly = "Monthly", Daily = "Weekly" }
local t3: {[any]: any} = {}
local u22: boolean = t1[stat] == true
local u23: boolean = stat == "Clans"

local u24 = u23 and (function()
	local v49 = replicatedStorage:WaitForChild("Shared")

	v49 = require(v49:WaitForChild("ClanRewardPeriod")).Active()

	for k, v in pairs(t2) do
		if v == v49 then
			return k
		end
	end

	return "AllTime"
end)() or "AllTime"

local function formatWithCommas(p1)
	local floored = math.floor(p1)
	local text = tostring(floored)

	repeat
		local v55, v56 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v55
	until v56 == 0

	return text
end

local t4: {[any]: any} = {}

if u23 then
	if allTime then
		t4.AllTime = allTime
	end

	if monthly then
		t4.Monthly = monthly
	end

	if daily then
		t4.Daily = daily

		local textLabel: Instance = daily:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = "Weekly"

			local textLabel2: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel2 and textLabel2:IsA("TextLabel") then
				textLabel2.Text = "Weekly"
			end
		end
	end
elseif u22 then
	if allTime then
		t4.AllTime = allTime
	end

	if monthly then
		t4.Monthly = monthly
	end

	if daily then
		t4.Daily = daily
	end
else
	if allTime then
		t4.AllTime = allTime
	end

	if monthly then
		monthly:Destroy()
	end

	if daily then
		daily:Destroy()
	end
end

number1Template.Visible = false
number2Template.Visible = false
number3Template.Visible = false
regularTemplate.Visible = false

local function updateFilterButtons()
	for k, v in pairs(t4) do
		local darkenDeselectedCover = v:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover then
			darkenDeselectedCover.Visible = k ~= u24
		end
	end
end
local function getTemplate(p2)
	if p2 == 1 then
		return number1Template
	end

	if p2 == 2 then
		return number2Template
	end

	if p2 == 3 then
		return number3Template
	end

	return regularTemplate
end
local function getOrCreateEntry(layoutOrder)
	if t3[layoutOrder] then
		return t3[layoutOrder]
	end

	local clone = (if layoutOrder == 1 then number1Template else if layoutOrder == 2 then number2Template else if layoutOrder == 3 then number3Template else regularTemplate):Clone()

	clone.Name = "Entry_" .. layoutOrder
	clone.LayoutOrder = layoutOrder
	clone.Visible = false
	clone.Parent = scrollingFrame
	t3[layoutOrder] = clone

	return clone
end
local function hideAllEntries()
	for _, v in ipairs(t3) do
		v.Visible = false
	end
end
local function populateEntry(p4, p5, p6)
	local position = p4:FindFirstChild("Position")
	local playerName = p4:FindFirstChild("PlayerName")
	local score = p4:FindFirstChild("Score")
	local playerHeadshot = p4:FindFirstChild("PlayerHeadshot")

	if position then
		position.Text = "#" .. tostring(p5)
	end

	if playerName then
		playerName.Text = p6.Name
	end

	if score then
		score.Text = formatWithCommas(p6.Value)
	end

	if playerHeadshot then
		task.spawn(function()
			local ok, result = pcall(function()
				return players:GetUserThumbnailAsync(p6.UserId, Enum.ThumbnailType.HeadShot, size100x100)
			end)

			if ok and result and playerHeadshot.Parent then
				playerHeadshot.Image = result
			end
		end)
	end

	p4.Visible = true
end

local u34 = nil

local function getClanDeps()
	if u34 then
		return u34
	end

	local t5: {[any]: any} = {}
	local shared: Instance = replicatedStorage:WaitForChild("Shared", 30)
	local clanImage: Instance = shared and shared:WaitForChild("ClanImage", 30)

	if clanImage then
		local ok, result = pcall(require, clanImage)

		if ok then
			t5.ClanImage = result
		end
	end

	local bindables: Instance = replicatedStorage:WaitForChild("Bindables", 30)
	local v78: Instance = bindables

	if v78 then
		v78 = bindables:FindFirstChild("RequestClanView")
	end

	if v78 and v78:IsA("BindableEvent") then
		t5.RequestClanView = v78
	end

	local clanLeaderboard: Instance = remotes:WaitForChild("ClanLeaderboard", 30)

	if clanLeaderboard and clanLeaderboard:IsA("RemoteFunction") then
		t5.Remote = clanLeaderboard
	else
		warn("[Leaderboard] Clans - ClanLeaderboard remote unavailable; board left empty")
	end

	u34 = t5

	return t5
end
local function clanTitleFor(p7)
	local text: string = tostring(p7.Name or "Clan")
	local text2: string = tostring(p7.DisplayTag or "")

	if text2 == "" or text2 == text then
		return text
	end

	return text .. " [" .. text2 .. "]"
end
local function ensureClickOverlay(parent)
	local clanClickOverlay = parent:FindFirstChild("ClanClickOverlay")

	if clanClickOverlay and clanClickOverlay:IsA("TextButton") then
		return clanClickOverlay
	end

	local clanClickOverlay: TextButton = Instance.new("TextButton")

	clanClickOverlay.Name = "ClanClickOverlay"
	clanClickOverlay.BackgroundTransparency = 1
	clanClickOverlay.Text = ""
	clanClickOverlay.AutoButtonColor = false
	clanClickOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
	clanClickOverlay.Position = UDim2.fromScale(0.5, 0.5)
	clanClickOverlay.Size = UDim2.fromScale(1, 1)
	clanClickOverlay.ZIndex = 50
	clanClickOverlay.Parent = parent

	return clanClickOverlay
end
local function bindClanRow(p9)
	local v87 = ensureClickOverlay(p9)

	if v87:GetAttribute("Bound") then
		return
	end

	v87:SetAttribute("Bound", true)
	v87.MouseButton1Click:Connect(function()
		local clanId = p9:GetAttribute("ClanId")

		if typeof(clanId) == "string" and clanId ~= "" then
			local requestClanView = getClanDeps().RequestClanView

			if requestClanView then
				requestClanView:Fire({ clanId = clanId })
			end

			return
		end
	end)
end
local function populateClanEntry(p10, p11, p12)
	local position = p10:FindFirstChild("Position")
	local playerName = p10:FindFirstChild("PlayerName")
	local score = p10:FindFirstChild("Score")
	local playerHeadshot = p10:FindFirstChild("PlayerHeadshot")

	if position then
		position.Text = "#" .. tostring(p11)
	end

	if playerName then
		local text: string = tostring(p12.Name or "Clan")
		local text3: string = tostring(p12.DisplayTag or "")

		playerName.Text = if text3 == "" or text3 == text then text else text .. " [" .. text3 .. "]"
	end

	if score then
		score.Text = formatWithCommas(p12.Kills or 0)
	end

	local clanId = p10:GetAttribute("ClanId")
	local v98 = typeof(p12.ClanId) == "string" and p12.ClanId or nil

	if playerHeadshot then
		local v99 = getClanDeps()

		if v99.ClanImage and clanId ~= v98 then
			v99.ClanImage.apply(playerHeadshot, p12.ImageId)
		end
	end

	p10:SetAttribute("ClanId", v98)
	bindClanRow(p10)
	p10.Visible = true
end
local function updateClanYouRow(p13)
	if typeof(p13) == "table" then
		local position: Instance = you:FindFirstChild("Position")
		local playerName: Instance = you:FindFirstChild("PlayerName")
		local score: Instance = you:FindFirstChild("Score")
		local playerHeadshot: Instance = you:FindFirstChild("PlayerHeadshot")

		if position then
			position.Text = typeof(p13.Rank) == "number" and "#" .. tostring(p13.Rank) or "N/A"
		end

		if playerName then
			local text: string = tostring(p13.Name or "Clan")
			local text4: string = tostring(p13.DisplayTag or "")

			playerName.Text = if text4 == "" or text4 == text then text else text .. " [" .. text4 .. "]"
		end

		if score then
			score.Text = formatWithCommas(p13.Kills or 0)
		end

		local clanId: any = you:GetAttribute("ClanId")
		local v108 = typeof(p13.ClanId) == "string" and p13.ClanId or nil

		if playerHeadshot then
			local v109 = getClanDeps()

			if v109.ClanImage and clanId ~= v108 then
				v109.ClanImage.apply(playerHeadshot, p13.ImageId)
			end
		end

		you:SetAttribute("ClanId", v108)
		you.Visible = true

		return
	end

	you.Visible = false
end
local function fetchAndDisplayClans()
	local remote = getClanDeps().Remote

	if not remote then
		return false
	end

	local v111 = t2[u24] or "AllTime"

	local ok, result = pcall(function()
		return remote:InvokeServer("GetBoard", v111)
	end)

	if ok and typeof(result) == "table" then
		local t6 = result.board or {}

		for _, v in ipairs(t3) do
			v.Visible = false
		end

		for i, v in ipairs(t6) do
			if i > 100 then
				break
			end

			local v119

			if t3[i] then
				v119 = t3[i]
			else
				local clone = (if i == 1 then number1Template else if i == 2 then number2Template else if i == 3 then number3Template else regularTemplate):Clone()

				clone.Name = "Entry_" .. i
				clone.LayoutOrder = i
				clone.Visible = false
				clone.Parent = scrollingFrame
				t3[i] = clone
				v119 = clone
			end

			populateClanEntry(v119, i, v)
		end

		local uiListLayout: Instance = scrollingFrame:FindFirstChildOfClass("UIListLayout")
		local v122 = uiListLayout and uiListLayout.Padding.Offset or 0
		local v123 = regularTemplate.AbsoluteSize.Y

		if v123 == 0 then
			v123 = 70
		end

		local uDim2New = UDim2.new
		local v125 = math.max(1, #t6)

		scrollingFrame.CanvasSize = uDim2New(0, 0, 0, v125 * (v123 + v122))
		updateClanYouRow(result.you)
		scriptParent.Enabled = true

		return #t6 > 0
	end

	if not ok then
		warn("[Leaderboard] Clans - InvokeServer failed:", result)
	end

	return false
end
local function updateYouFrame()
	if not LocalPlayer then
		return
	end

	local s1 = u22 and stat .. "_" .. u24 or stat

	local ok, result = pcall(function()
		return globalLeaderboard:InvokeServer("GetPlayerStat", s1)
	end)

	if ok and typeof(result) == "table" then
		local v129 = result.Value or 0
		local resultRank = result.Rank
		local position: Instance = you:FindFirstChild("Position")
		local playerName: Instance = you:FindFirstChild("PlayerName")
		local score: Instance = you:FindFirstChild("Score")
		local playerHeadshot: Instance = you:FindFirstChild("PlayerHeadshot")

		if position then
			position.Text = typeof(resultRank) == "number" and "#" .. tostring(resultRank) or "N/A"
		end

		if playerName then
			playerName.Text = LocalPlayer.Name
		end

		if score then
			score.Text = formatWithCommas(v129)
		end

		if playerHeadshot then
			task.spawn(function()
				local ok2, result2 = pcall(function()
					return players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, size100x100)
				end)

				if ok2 and result2 and playerHeadshot.Parent then
					playerHeadshot.Image = result2
				end
			end)
		end

		return
	end
end
local function getBoardKey()
	if u22 then
		return stat .. "_" .. u24
	end

	return stat
end
local function fetchAndDisplay()
	if u23 then
		fetchAndDisplayClans()

		return
	end

	local s1 = if u22 then stat .. "_" .. u24 else stat

	local ok, result = pcall(function()
		return globalLeaderboard:InvokeServer("GetBoard", s1)
	end)

	if ok and typeof(result) == "table" then
		for _, v in ipairs(t3) do
			v.Visible = false
		end

		for i, v in ipairs(result) do
			if i > 100 then
				break
			end

			if t3[i] then
				(if i == 1 then number1Template else if i == 2 then number2Template else if i == 3 then number3Template else regularTemplate).Name:gsub("Template", "")
			end

			local v142

			if t3[i] then
				v142 = t3[i]
			else
				local clone = (if i == 1 then number1Template else if i == 2 then number2Template else if i == 3 then number3Template else regularTemplate):Clone()

				clone.Name = "Entry_" .. i
				clone.LayoutOrder = i
				clone.Visible = false
				clone.Parent = scrollingFrame
				t3[i] = clone
				v142 = clone
			end

			populateEntry(v142, i, v)
		end

		local uiListLayout: Instance = scrollingFrame:FindFirstChildOfClass("UIListLayout")
		local v145 = uiListLayout and uiListLayout.Padding.Offset or 0
		local v146 = regularTemplate.AbsoluteSize.Y

		if v146 == 0 then
			v146 = 70
		end

		local v147 = math.max(1, #result)

		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v147 * (v146 + v145))
		updateYouFrame()
		scriptParent.Enabled = true
	elseif not ok then
		warn("[Leaderboard]", stat, "- InvokeServer failed:", result)
	end
end

for k, v in pairs(t4) do
	v.MouseButton1Click:Connect(function()
		if u24 == k then
			return
		end

		u24 = k
		updateFilterButtons()
		fetchAndDisplay()
	end)
end

if u23 then
	you.Visible = false
end

if LocalPlayer and not u23 then
	local playerHeadshot: Instance = you:FindFirstChild("PlayerHeadshot")
	local playerName: Instance = you:FindFirstChild("PlayerName")

	if playerName then
		playerName.Text = LocalPlayer.Name
	end

	if playerHeadshot then
		task.spawn(function()
			local ok, result = pcall(function()
				return players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, size100x100)
			end)

			if ok and result and playerHeadshot.Parent then
				playerHeadshot.Image = result
			end
		end)
	end
end

updateFilterButtons()
task.delay(5, function()
	if u23 then
		local n1: number = 0

		while true do
			if not not fetchAndDisplayClans() or not (n1 < 6) then
				break
			end

			n1 += 1
			task.wait(15)
		end
	else
		fetchAndDisplay()
	end

	while true do
		task.wait(180)
		fetchAndDisplay()
	end
end)
