--[[
	Remotes Kit — built from remote_log_20261030_a.txt
	(LEX Remote Spy dump, 2026-10-30 06:42 -> 06:45)

	What the dump actually contains, and what this script does with it:

	  * Every gameplay remote sits in ReplicatedStorage.Remotes. There is a second
	    copy of PingHeartbeat / PingRF under ReplicatedStorage.Game.Remotes.
	  * PingHeartbeat fires 2x/sec, PingRF 1x/3sec, PerfStats 1x/20sec,
	    ReplayAimSync ~30x/sec while aiming, plus Sound / Effect. That is well over
	    90% of all traffic — they are muted by default here so the log is readable.
	  * Server -> client pushes visible in the dump: KillFeed_Push, MatchRemotes.State,
	    ParkourState, MurderNoteSync, KnifeRigHideUntil, HitReplicate, ShootReplicate,
	    ThrowReplicate. Those carry the real payloads, so they are watched (never
	    muted) and their latest arguments show on the row.
	  * RemoteFunctions with string commands: Inventory ("GetCaseView" {CrateId},
	    "Equip" {InstanceId, Kind}, "Unequip" {Kind}), ClanLeaderboard ("GetPodium",
	    "GetBoard" "Monthly"), GlobalLeaderboard ("GetBoard"/"GetPlayerStat" with
	    RobuxSpent, Level, WinStreak, Kills_AllTime, Wins_AllTime), Abilities_Request
	    ("NotifyShopOpened"). Those exact calls ship as one-click presets.
	  * RobloxReplicatedStorage (CanChatWith, SendPlayerProfileSettings,
	    NewPlayerGroupDetails, NewPlayerCanManageDetails) is core Roblox, muted.

	This is a viewer/logger: it never fires anything by itself. You pick a remote,
	you press the button. Outgoing capture needs hookfunction (executor); without
	it you still see every incoming push.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local RK = {}

-- ------------------------------------------------------------------ config --

RK.conf = (type(getgenv().REMOTEKIT) == "table") and getgenv().REMOTEKIT or {}
RK.spy = RK.conf.spy ~= false
RK.mute = RK.conf.mute ~= false
RK.limit = tonumber(RK.conf.limit) or 200
RK.throttle = tonumber(RK.conf.throttle) or 0.2

-- remotes that drown out everything else in the dump
RK.MUTED = {
	PingHeartbeat = true, PingRF = true, PerfStats = true, ReplayAimSync = true,
	Sound = true, Effect = true, CanChatWith = true, SendPlayerProfileSettings = true,
	NewPlayerGroupDetails = true, NewPlayerCanManageDetails = true,
	-- Roblox core remotes that are always noisy
	FireAllClients = true,
}

-- payloads worth keeping, so these ignore the mute list and the slow throttle
RK.WATCH = {
	KillFeed_Push = true, MurderNoteSync = true, ParkourState = true,
	KnifeRigHideUntil = true, HitReplicate = true, ShootReplicate = true,
	ThrowReplicate = true, State = true, Abilities_Request = true, Inventory = true,
	InventoryDirty = true, UpdateSettings = true, WarmupReady = true,
	WarmupStatus = true, WinScreenDismiss = true, Weapon_DebugNoCooldown = true,
}

-- commands seen in the dump, ready to send
RK.PRESETS = {
	{ label = "Case view", remote = "Inventory", args = '"GetCaseView", {CrateId = "HallowsCase"}' },
	{ label = "Equip knife", remote = "Inventory", args = '"Equip", {InstanceId = "9c1ba19c-1578-401a-90b3-f7abde5141a6", Kind = "Knife"}' },
	{ label = "Equip revolver", remote = "Inventory", args = '"Equip", {InstanceId = "65651944-f1fe-4e5c-bfd2-a5fc61c7afd0", Kind = "Revolver"}' },
	{ label = "Unequip revolver", remote = "Inventory", args = '"Unequip", {Kind = "Revolver"}' },
	{ label = "Clan podium", remote = "ClanLeaderboard", args = '"GetPodium"' },
	{ label = "Clan board", remote = "ClanLeaderboard", args = '"GetBoard", "Monthly"' },
	{ label = "My level", remote = "GlobalLeaderboard", args = '"GetPlayerStat", "Level"' },
	{ label = "My win streak", remote = "GlobalLeaderboard", args = '"GetPlayerStat", "WinStreak"' },
	{ label = "My kills", remote = "GlobalLeaderboard", args = '"GetPlayerStat", "Kills_AllTime"' },
	{ label = "My wins", remote = "GlobalLeaderboard", args = '"GetPlayerStat", "Wins_AllTime"' },
	{ label = "Top by level", remote = "GlobalLeaderboard", args = '"GetBoard", "Level"' },
	{ label = "Top by wins", remote = "GlobalLeaderboard", args = '"GetBoard", "Wins_AllTime"' },
	{ label = "Shop opened", remote = "Abilities_Request", args = '"NotifyShopOpened"' },
}

RK.list = {}
RK.byName = {}
RK.rows = {}
RK.count = {}
RK.lastAt = {}
RK.lines = {}
RK.logRows = {}
RK.selected = nil

-- --------------------------------------------------------------- formatting --

RK.fmtValue = function(v, depth)
	depth = depth or 0
	local t = typeof(v)
	if t == "string" then
		local s = tostring(v):gsub("\n", "\\n")
		if #s > 140 then s = s:sub(1, 137) .. "..." end
		return '"' .. s .. '"'
	elseif t == "number" then
		if v == math.floor(v) and math.abs(v) < 1e15 then return tostring(v) end
		return string.format("%.4f", v)
	elseif t == "Instance" then
		local ok, full = pcall(function() return v:GetFullName() end)
		return ok and full or ("<" .. tostring(v) .. ">")
	elseif t == "Vector3" then
		return string.format("Vector3.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
	elseif t == "Vector2" then
		return string.format("Vector2.new(%.2f, %.2f)", v.X, v.Y)
	elseif t == "CFrame" then
		local p = v.Position
		return string.format("CFrame.new(%.2f, %.2f, %.2f)", p.X, p.Y, p.Z)
	elseif t == "Color3" then
		return string.format("Color3.fromRGB(%d, %d, %d)",
			math.floor(v.R * 255 + 0.5), math.floor(v.G * 255 + 0.5), math.floor(v.B * 255 + 0.5))
	elseif t == "table" then
		if depth >= 2 then return "{...}" end
		local parts, n = {}, 0
		local ok = pcall(function()
			for k, val in pairs(v) do
				n = n + 1
				if n > 12 then
					parts[#parts + 1] = "..."
					break
				end
				local key = (type(k) == "string" and k .. " = ") or ""
				parts[#parts + 1] = key .. RK.fmtValue(val, depth + 1)
			end
		end)
		if not ok then return "{...}" end
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	local ok, s = pcall(tostring, v)
	return ok and s or "?"
end

RK.fmtArgs = function(packed)
	local parts = {}
	for i = 1, (packed.n or #packed) do
		parts[#parts + 1] = RK.fmtValue(packed[i])
	end
	return table.concat(parts, ", ")
end

-- "args as Lua": fire server args from text, e.g.  "GetBoard", "Monthly"
RK.parseArgs = function(text)
	text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then return {} end
	local loader = loadstring or load
	if not loader then return nil, "no loadstring in this executor" end
	-- some runtimes raise on a syntax error instead of returning nil, err
	local built = table.pack(pcall(loader, "return " .. text))
	if not built[1] then return nil, tostring(built[2]) end
	local chunk = built[2]
	if not chunk then return nil, tostring(built[3] or "could not compile") end
	local res = table.pack(pcall(chunk))
	if not res[1] then return nil, tostring(res[2]) end
	local args = {}
	for i = 2, res.n do args[#args + 1] = res[i] end
	return args
end

-- same expression the dump uses, straight from the instance tree
RK.pathCode = function(inst)
	local parts, node = {}, inst
	while node and node ~= game do
		table.insert(parts, 1, node.Name)
		node = node.Parent
	end
	if #parts == 0 then return "game" end
	local out = 'game:GetService("' .. parts[1] .. '")'
	for i = 2, #parts do
		out = out .. ':WaitForChild("' .. parts[i] .. '")'
	end
	return out
end

-- --------------------------------------------------------------- discovery --

RK.scan = function(node, depth)
	if depth > 6 then return end
	local ok, children = pcall(function() return node:GetChildren() end)
	if not ok or not children then return end
	for _, child in ipairs(children) do
		local isRemote = false
		pcall(function()
			isRemote = child:IsA("RemoteEvent") or child:IsA("RemoteFunction")
				or child:IsA("UnreliableRemoteEvent")
		end)
		if isRemote then
			RK.addRemote(child)
		else
			RK.scan(child, depth + 1)
		end
	end
end

RK.addRemote = function(inst)
	local ok, key = pcall(function() return inst:GetFullName() end)
	if not ok or not key or RK.byName[key] then return end
	local kind = "event"
	pcall(function()
		if inst:IsA("RemoteFunction") then kind = "function" end
	end)
	local entry = {
		inst = inst,
		key = key,
		name = inst.Name,
		kind = kind,
		code = RK.pathCode(inst),
	}
	RK.byName[key] = entry
	RK.count[key] = RK.count[key] or 0
	table.insert(RK.list, entry)
	if kind == "event" then
		pcall(function()
			inst.OnClientEvent:Connect(function(...)
				RK.log(entry, "in", table.pack(...), "OnClientEvent")
			end)
		end)
	end
	if RK.listFrame then RK.makeRow(entry) end
	return entry
end

RK.discover = function()
	RK.list = {}
	RK.byName = {}
	RK.scan(ReplicatedStorage, 0)
	pcall(function()
		RK.scan(game:GetService("RobloxReplicatedStorage"), 0)
	end)
	table.sort(RK.list, function(a, b)
		if a.name == b.name then return a.code < b.code end
		return a.name:lower() < b.name:lower()
	end)
	return #RK.list
end

-- ----------------------------------------------------------------- logging --

RK.pushLog = function(dir, method, entry, preview, args, ret)
	local stamp = os.date("%H:%M:%S")
	table.insert(RK.lines, 1, {
		stamp = stamp,
		dir = dir,
		method = method,
		name = entry.name,
		code = entry.code,
		preview = preview,
		args = args,
		ret = ret,
	})
	while #RK.lines > RK.limit do table.remove(RK.lines) end

	local text = "[" .. stamp .. "] " .. method .. "  " .. entry.name
		.. "(" .. preview .. ")"
	print("[RK] " .. text)
	if not RK.logInner then return end
	local lbl = RK.new("TextLabel", {
		Size = UDim2.new(1, -8, 0, 14),
		BackgroundTransparency = 1,
		Font = Enum.Font.Code,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = (dir == "in") and RK.CYAN or RK.PURPLE,
		Text = text,
		LayoutOrder = -#RK.logRows - 1,
	}, RK.logInner)
	table.insert(RK.logRows, lbl)
	while #RK.logRows > RK.limit do
		local old = table.remove(RK.logRows, 1)
		if old then pcall(function() old:Destroy() end) end
	end
	if RK.logInner then
		RK.logInner.CanvasSize = UDim2.fromOffset(0, #RK.logRows * 15)
	end
end

RK.log = function(entry, dir, packed, method)
	if not RK.spy then return end
	local key = entry.key
	RK.count[key] = (RK.count[key] or 0) + 1
	local now = os.clock()
	local since = now - (RK.lastAt[key] or 0)
	local noise = RK.mute and RK.MUTED[entry.name] and not RK.WATCH[entry.name]
	local gap = RK.WATCH[entry.name] and 0.05 or RK.throttle
	if noise then gap = 0.75 end
	if since < gap then return end
	RK.lastAt[key] = now

	local preview = RK.fmtArgs(packed)
	local row = RK.rows[key]
	if row then
		row.preview.Text = (preview ~= "" and preview) or "(no arguments)"
		row.count.Text = tostring(RK.count[key])
		if RK.WATCH[entry.name] then
			row.preview.TextColor3 = RK.CYAN
		end
	end
	if noise then return end
	RK.pushLog(dir, method, entry, preview, packed)
end

RK.note = function(text)
	if RK.statusLbl then
		RK.statusLbl.Text = text
		RK.statusLbl.TextColor3 = RK.MUTEDTEXT
	end
end

-- --------------------------------------------------------------------- UI --

RK.BG = Color3.fromRGB(16, 16, 20)
RK.PANEL = Color3.fromRGB(26, 26, 33)
RK.PANEL2 = Color3.fromRGB(34, 34, 43)
RK.TEXT = Color3.fromRGB(232, 232, 240)
RK.MUTEDTEXT = Color3.fromRGB(140, 140, 155)
RK.PURPLE = Color3.fromRGB(150, 110, 240)
RK.CYAN = Color3.fromRGB(90, 200, 220)
RK.RED = Color3.fromRGB(235, 100, 100)
RK.ON = Color3.fromRGB(120, 220, 150)

RK.new = function(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			pcall(function() inst[k] = v end)
		end
	end
	if parent then inst.Parent = parent end
	return inst
end

RK.highlight = function(entry)
	for key, row in pairs(RK.rows) do
		local on = RK.selected and key == RK.selected.key
		row.bg.BackgroundColor3 = on and RK.PANEL2 or RK.PANEL
	end
	if entry then
		RK.pathLbl.Text = entry.code
		RK.kindLbl.Text = entry.kind == "function" and "RemoteFunction" or "RemoteEvent"
		if RK.argsBox and RK.argsBox.Text == "" then
			RK.argsBox.Text = entry.kind == "function" and '"GetPodium"' or ""
		end
	end
end

RK.select = function(entry)
	RK.selected = entry
	RK.highlight(entry)
end

RK.makeRow = function(entry)
	if not RK.listFrame then return end
	local row = {}
	row.bg = RK.new("TextButton", {
		Size = UDim2.new(1, -10, 0, 22),
		BackgroundColor3 = RK.PANEL,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	}, RK.listFrame)
	row.bg.MouseButton1Click:Connect(function() RK.select(entry) end)

	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, row.bg)
	RK.new("TextLabel", {
		Size = UDim2.fromOffset(14, 22),
		BackgroundTransparency = 1,
		Text = entry.kind == "function" and "F" or "E",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = entry.kind == "function" and RK.PURPLE or RK.CYAN,
	}, row.bg)
	RK.new("TextLabel", {
		Size = UDim2.new(0, 150, 1, 0),
		Position = UDim2.fromOffset(18, 0),
		BackgroundTransparency = 1,
		Text = entry.name,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = RK.WATCH[entry.name] and RK.CYAN or RK.TEXT,
	}, row.bg)
	row.count = RK.new("TextLabel", {
		Size = UDim2.fromOffset(36, 22),
		Position = UDim2.new(0, 172, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(RK.count[entry.key] or 0),
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = RK.MUTEDTEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row.bg)
	row.preview = RK.new("TextLabel", {
		Size = UDim2.new(1, -216, 1, 0),
		Position = UDim2.fromOffset(212, 0),
		BackgroundTransparency = 1,
		Text = "",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = RK.MUTEDTEXT,
	}, row.bg)
	RK.rows[entry.key] = row
	RK.listFrame.CanvasSize = UDim2.fromOffset(0, #RK.list * 24 + 8)
	return row
end

RK.fillRows = function()
	if not RK.listFrame then return end
	for _, row in pairs(RK.rows) do
		pcall(function() row.bg:Destroy() end)
	end
	RK.rows = {}
	for _, entry in ipairs(RK.list) do
		RK.makeRow(entry)
	end
	RK.listFrame.CanvasSize = UDim2.fromOffset(0, #RK.list * 24 + 8)
	RK.countLbl.Text = tostring(#RK.list) .. " remotes"
end

RK.build = function()
	local gui = Instance.new("ScreenGui")
	gui.Name = "RemotesKit"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local host = player:WaitForChild("PlayerGui")
	pcall(function()
		local hui = gethui and gethui()
		if hui then host = hui end
	end)
	gui.Parent = host
	RK.gui = gui

	local f = RK.new("Frame", {
		Size = UDim2.fromOffset(660, 520),
		Position = UDim2.new(0.5, -330, 0.5, -260),
		BackgroundColor3 = RK.BG,
		BorderSizePixel = 0,
	}, gui)
	RK.frame = f
	RK.new("UICorner", { CornerRadius = UDim.new(0, 10) }, f)
	local stroke = Instance.new("UIStroke")
	stroke.Color = RK.PURPLE
	stroke.Thickness = 1
	stroke.Parent = f

	-- title bar (drag handle)
	local title = RK.new("Frame", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = RK.PANEL2,
		BorderSizePixel = 0,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 10) }, title)
	RK.new("TextLabel", {
		Size = UDim2.new(1, -120, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		Text = "Remotes Kit  ·  dump 2026-10-30",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = RK.TEXT,
	}, title)
	RK.countLbl = RK.new("TextLabel", {
		Size = UDim2.fromOffset(90, 28),
		Position = UDim2.new(1, -128, 0, 0),
		BackgroundTransparency = 1,
		Text = "0 remotes",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = RK.MUTEDTEXT,
	}, title)
	local close = RK.new("TextButton", {
		Size = UDim2.fromOffset(24, 20),
		Position = UDim2.new(1, -32, 0, 4),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		Text = "X",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = RK.TEXT,
	}, title)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, close)
	close.MouseButton1Click:Connect(function() f.Visible = false end)

	-- floating re-open button
	RK.button = RK.new("TextButton", {
		Size = UDim2.fromOffset(44, 22),
		Position = UDim2.fromOffset(12, 12),
		BackgroundColor3 = RK.PANEL2,
		BorderSizePixel = 0,
		Text = "RK",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = RK.PURPLE,
	}, gui)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 5) }, RK.button)
	RK.button.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

	local dragging, dragStart, startPos = false, nil, nil
	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = f.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragStart
			f.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	-- toolbar
	local bar = RK.new("Frame", {
		Size = UDim2.new(1, -16, 0, 26),
		Position = UDim2.fromOffset(8, 32),
		BackgroundTransparency = 1,
	}, f)
	RK.search = RK.new("TextBox", {
		Size = UDim2.fromOffset(180, 24),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		PlaceholderText = "filter remotes...",
		PlaceholderColor3 = RK.MUTEDTEXT,
		Text = "",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = RK.TEXT,
		ClearTextOnFocus = false,
	}, bar)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, RK.search)

	RK.mkToggle = function(text, get, flip, x, parent)
		local b = RK.new("TextButton", {
			Size = UDim2.fromOffset(96, 24),
			Position = UDim2.fromOffset(x, 0),
			BackgroundColor3 = RK.PANEL,
			BorderSizePixel = 0,
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = get() and RK.ON or RK.MUTEDTEXT,
		}, parent)
		RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, b)
		b.MouseButton1Click:Connect(function()
			flip()
			b.TextColor3 = get() and RK.ON or RK.MUTEDTEXT
		end)
		return b
	end

	RK.mkToggle("Spy", function() return RK.spy end, function() RK.spy = not RK.spy end, 188, bar)
	RK.mkToggle("Mute spam", function() return RK.mute end, function() RK.mute = not RK.mute end, 290, bar)
	local rescan = RK.new("TextButton", {
		Size = UDim2.fromOffset(70, 24),
		Position = UDim2.fromOffset(392, 0),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		Text = "Rescan",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = RK.TEXT,
	}, bar)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, rescan)
	rescan.MouseButton1Click:Connect(function()
		RK.discover()
		RK.fillRows()
		RK.note("rescanned: " .. tostring(#RK.list) .. " remotes")
	end)
	local copyLog = RK.new("TextButton", {
		Size = UDim2.fromOffset(96, 24),
		Position = UDim2.fromOffset(468, 0),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		Text = "Copy all",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = RK.TEXT,
	}, bar)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, copyLog)
	copyLog.MouseButton1Click:Connect(function() RK.exportAll() end)
	local clear = RK.new("TextButton", {
		Size = UDim2.fromOffset(56, 24),
		Position = UDim2.fromOffset(570, 0),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		Text = "Clear",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = RK.TEXT,
	}, bar)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, clear)
	clear.MouseButton1Click:Connect(function()
		RK.lines = {}
		for _, lbl in ipairs(RK.logRows) do pcall(function() lbl:Destroy() end) end
		RK.logRows = {}
	end)

	-- remote list
	RK.listFrame = RK.new("ScrollingFrame", {
		Size = UDim2.new(1, -16, 0, 150),
		Position = UDim2.fromOffset(8, 64),
		BackgroundColor3 = RK.PANEL,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = RK.PURPLE,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 6) }, RK.listFrame)
	RK.new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, RK.listFrame)

	-- log
	RK.logInner = RK.new("ScrollingFrame", {
		Size = UDim2.new(1, -16, 0, 128),
		Position = UDim2.fromOffset(8, 220),
		BackgroundColor3 = RK.PANEL,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = RK.PURPLE,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 6) }, RK.logInner)
	RK.new("UIListLayout", { Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder }, RK.logInner)

	-- detail
	RK.pathLbl = RK.new("TextLabel", {
		Size = UDim2.new(1, -16, 0, 30),
		Position = UDim2.fromOffset(8, 354),
		BackgroundTransparency = 1,
		Text = "pick a remote above",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = RK.MUTEDTEXT,
	}, f)
	RK.kindLbl = RK.new("TextLabel", {
		Size = UDim2.fromOffset(120, 14),
		Position = UDim2.fromOffset(500, 354),
		BackgroundTransparency = 1,
		Text = "",
		Font = Enum.Font.Code,
		TextSize = 10,
		TextColor3 = RK.MUTEDTEXT,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, f)
	RK.argsBox = RK.new("TextBox", {
		Size = UDim2.new(1, -16, 0, 26),
		Position = UDim2.fromOffset(8, 386),
		BackgroundColor3 = RK.PANEL,
		BorderSizePixel = 0,
		PlaceholderText = 'arguments as Lua, e.g.  "GetBoard", "Monthly"  or  {}',
		PlaceholderColor3 = RK.MUTEDTEXT,
		Text = "",
		Font = Enum.Font.Code,
		TextSize = 11,
		TextColor3 = RK.TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, RK.argsBox)

	RK.actBtn = RK.new("TextButton", {
		Size = UDim2.fromOffset(110, 24),
		Position = UDim2.fromOffset(8, 416),
		BackgroundColor3 = RK.PURPLE,
		BorderSizePixel = 0,
		Text = "Run",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = RK.TEXT,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, RK.actBtn)
	RK.actBtn.MouseButton1Click:Connect(function() RK.act() end)

	local copyCall = RK.new("TextButton", {
		Size = UDim2.fromOffset(110, 24),
		Position = UDim2.fromOffset(126, 416),
		BackgroundColor3 = RK.PANEL2,
		BorderSizePixel = 0,
		Text = "Copy call",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = RK.TEXT,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, copyCall)
	copyCall.MouseButton1Click:Connect(function() RK.copyCall() end)

	RK.statusLbl = RK.new("TextLabel", {
		Size = UDim2.new(1, -260, 0, 24),
		Position = UDim2.fromOffset(244, 416),
		BackgroundTransparency = 1,
		Text = "ready",
		Font = Enum.Font.Code,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = RK.MUTEDTEXT,
	}, f)

	-- preset chips
	local chips = RK.new("ScrollingFrame", {
		Size = UDim2.new(1, -16, 0, 40),
		Position = UDim2.fromOffset(8, 448),
		BackgroundColor3 = RK.PANEL,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = RK.PURPLE,
	}, f)
	RK.new("UICorner", { CornerRadius = UDim.new(0, 6) }, chips)
	local row = RK.new("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	}, chips)
	RK.new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	RK.new("UIPadding", {
		PaddingLeft = UDim.new(0, 6),
		PaddingTop = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
	}, row)
	local x = 0
	for _, preset in ipairs(RK.PRESETS) do
		local chip = RK.new("TextButton", {
			Size = UDim2.fromOffset(108, 24),
			BackgroundColor3 = RK.PANEL2,
			BorderSizePixel = 0,
			Text = preset.label,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = RK.TEXT,
			LayoutOrder = x,
		}, row)
		x = x + 1
		RK.new("UICorner", { CornerRadius = UDim.new(0, 4) }, chip)
		chip.MouseButton1Click:Connect(function()
			local picked
			for _, entry in ipairs(RK.list) do
				if entry.name == preset.remote then
					picked = entry
					break
				end
			end
			if not picked then
				RK.note(preset.remote .. " is not in this game")
				return
			end
			RK.select(picked)
			RK.argsBox.Text = preset.args
			RK.note("loaded preset: " .. preset.label .. " -> press Run")
		end)
	end
	chips.CanvasSize = UDim2.fromOffset(x * 114 + 12, 0)

	RK.search:GetPropertyChangedSignal("Text"):Connect(function()
		RK.applyFilter()
	end)
	RK.highlight(nil)
end

RK.applyFilter = function()
	if not RK.listFrame then return end
	local q = tostring(RK.search.Text or ""):lower()
	for _, entry in ipairs(RK.list) do
		local row = RK.rows[entry.key]
		if row then
			local show = q == "" or entry.code:lower():find(q, 1, true) ~= nil
			row.bg.Visible = show
		end
	end
end

RK.act = function()
	local entry = RK.selected
	if not entry then
		RK.note("select a remote first")
		return
	end
	local args, err = RK.parseArgs(RK.argsBox.Text)
	if not args then
		RK.note("bad arguments: " .. tostring(err))
		return
	end
	RK.argsBox.Text = ""
	if entry.kind == "function" then
		RK.note("invoking " .. entry.name .. "...")
		task.spawn(function()
			local ok, res = pcall(function()
				return entry.inst:InvokeServer(table.unpack(args, 1, #args))
			end)
			if ok then
				RK.note(entry.name .. " -> " .. RK.fmtValue(res))
				RK.pushLog("in", "InvokeServer", entry, RK.fmtValue(res), args, res)
			else
				RK.note(entry.name .. " failed: " .. tostring(res))
			end
		end)
	else
		local ok, err2 = pcall(function()
			entry.inst:FireServer(table.unpack(args, 1, #args))
		end)
		if ok then
			RK.note("fired " .. entry.name)
		else
			RK.note(entry.name .. " failed: " .. tostring(err2))
		end
	end
end

RK.copyCall = function()
	local entry = RK.selected
	if not entry then
		RK.note("select a remote first")
		return
	end
	local args = RK.parseArgs(RK.argsBox.Text)
	if not args then
		RK.note("bad arguments in the box")
		return
	end
	local parts = {}
	for i = 1, #args do parts[#parts + 1] = RK.fmtValue(args[i]) end
	local call = entry.code .. ":" .. (entry.kind == "function" and "InvokeServer" or "FireServer")
		.. "(" .. table.concat(parts, ", ") .. ")"
	RK.clip(call)
end

RK.clip = function(text, label)
	label = label or "copied to clipboard"
	text = tostring(text)
	local ok = pcall(function()
		if setclipboard then
			setclipboard(text)
		elseif toclipboard then
			toclipboard(text)
		else
			error("no clipboard function")
		end
	end)
	if ok then
		RK.note(label .. " · " .. tostring(#text) .. " chars — paste it to me")
		return
	end
	local saved = false
	pcall(function()
		if writefile then
			local name = "remotekit_" .. os.date("%H%M%S") .. ".txt"
			writefile(name, text)
			RK.note("no clipboard — wrote " .. name)
			saved = true
		end
	end)
	if not saved then
		for i = 1, #text, 900 do print(text:sub(i, i + 899)) end
		RK.note(label .. " — no clipboard, printed to console")
	end
end

-- export in the same shape as the dump so it can be diffed with it
RK.export = function()
	if #RK.lines == 0 then
		RK.note("nothing logged yet")
		return
	end
	local out = { "-- Remotes Kit log " .. os.date("%Y-%m-%d %H:%M:%S"), "" }
	for i = #RK.lines, 1, -1 do
		local line = RK.lines[i]
		table.insert(out, "-- [" .. line.stamp .. "] " .. line.method)
		table.insert(out, line.code .. ":" .. line.method .. "(" .. line.preview .. ")")
		table.insert(out, "")
	end
	RK.clip(table.concat(out, "\n"))
end

RK.maxExport = tonumber(RK.conf.maxExport) or 60000

-- full-fidelity serializer: the panel trims strings and depth, this does not
RK.deep = function(v, depth, seen)
	depth = depth or 0
	seen = seen or {}
	local t = typeof(v)
	if t == "string" then
		local s = tostring(v)
		if #s > 400 then s = s:sub(1, 400) .. "..." end
		return string.format("%q", s)
	elseif t == "number" then
		if v ~= v then return "nan" end
		if v == math.floor(v) and math.abs(v) < 1e15 then return tostring(v) end
		return string.format("%.6f", v)
	elseif t == "boolean" or t == "nil" then
		return tostring(v)
	elseif t == "table" then
		if seen[v] then return "<cycle>" end
		if depth >= 5 then return "{...}" end
		seen[v] = true
		local keys = {}
		local okKeys = pcall(function()
			for k in pairs(v) do keys[#keys + 1] = k end
		end)
		if not okKeys then
			seen[v] = nil
			return "{...}"
		end
		table.sort(keys, function(a, b)
			if type(a) == "number" and type(b) == "number" then return a < b end
			return tostring(a) < tostring(b)
		end)
		local parts = {}
		for i, k in ipairs(keys) do
			if i > 40 then
				parts[#parts + 1] = "..."
				break
			end
			local key = (type(k) == "string" and (k .. " = ")) or ""
			parts[#parts + 1] = key .. RK.deep(v[k], depth + 1, seen)
		end
		seen[v] = nil
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	return RK.fmtValue(v, depth)
end

RK.deepArgs = function(packed)
	local parts = {}
	for i = 1, (packed.n or #packed) do
		parts[#parts + 1] = RK.deep(packed[i])
	end
	return table.concat(parts, ", ")
end

-- copy all: the whole remote inventory plus every captured call with its full
-- arguments and any invoke return, in one paste
RK.exportAll = function()
	local out = {}
	local function add(line) out[#out + 1] = line end
	add("== REMOTES KIT ==")
	add("place  : " .. tostring(game.PlaceId) .. "  " .. tostring(game.Name))
	add("player : " .. tostring(player.Name) .. " (" .. tostring(player.UserId) .. ")")
	add("taken  : " .. os.date("%Y-%m-%d %H:%M:%S"))
	add("counts : " .. tostring(#RK.lines) .. " logged calls  ·  " .. tostring(#RK.list) .. " remotes")
	add("")
	add("== REMOTES ==")
	for _, e in ipairs(RK.list) do
		add(string.format("%-40s %-14s x%d", e.name, e.kind, RK.count[e.key] or 0))
		add("    " .. e.code)
	end
	add("")
	add("== LOG ==")
	for i = #RK.lines, 1, -1 do
		local line = RK.lines[i]
		local args = line.args and RK.deepArgs(line.args) or line.preview
		add("[" .. line.stamp .. "] " .. line.code .. ":" .. line.method .. "(" .. args .. ")")
		if line.ret ~= nil then add("    ret: " .. RK.deep(line.ret)) end
	end
	local text = table.concat(out, "\n")
	if #text > RK.maxExport then
		text = text:sub(1, RK.maxExport) .. "\n-- truncated at " .. RK.maxExport .. " chars"
	end
	RK.clip(text, "exported " .. tostring(#RK.lines) .. " calls")
	return text
end

RK.export = function()
	return RK.exportAll()
end

-- ------------------------------------------------------- outgoing capture --

RK.hook = function()
	if RK.hooked then return end
	local getmt, hookfunc, getmethod = getrawmetatable, hookfunction, getnamecallmethod
	if not (getmt and hookfunc and getmethod) then
		RK.note("outgoing capture needs hookfunction — showing incoming only")
		return
	end
	local ok, mt = pcall(getmt, game)
	if not ok or not mt or not rawget(mt, "__namecall") then
		RK.note("could not reach the namecall metatable")
		return
	end
	pcall(function() setreadonly(mt, false) end)
	local old
	local hooked = hookfunc(mt.__namecall, function(self, ...)
		local method = getmethod()
		if RK.spy and (method == "FireServer" or method == "InvokeServer") then
			local okKey, key = pcall(function() return self:GetFullName() end)
			local entry = okKey and key and RK.byName[key]
			if entry then
				RK.log(entry, "out", table.pack(...), method)
			end
		end
		return old(self, ...)
	end)
	if hooked then old = hooked else old = mt.__namecall end
	pcall(function() setreadonly(mt, true) end)
	RK.hooked = true
	RK.note("outgoing capture on — spy is " .. (RK.spy and "enabled" or "paused"))
end

RK.watchTree = function()
	pcall(function()
		ReplicatedStorage.DescendantAdded:Connect(function(inst)
			local ok, isRemote = pcall(function()
				return inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")
			end)
			if ok and isRemote then
				RK.addRemote(inst)
				if RK.countLbl then
					RK.countLbl.Text = tostring(#RK.list) .. " remotes"
				end
			end
		end)
	end)
end

-- ------------------------------------------------------------------- start --

RK.build()
RK.discover()
RK.fillRows()
RK.watchTree()
RK.hook()

if RK.conf.startOpen == false then
	RK.frame.Visible = false
end

RK.note("ready — " .. tostring(#RK.list) .. " remotes, log muted for known spam")
getgenv().REMOTEKIT = RK
getgenv().RK = RK
