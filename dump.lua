--[[
	Remote Dump — collector for the *next* script

	The last LEX log had two gaps that make it impossible to build much from:
	  1. OnClientEvent entries are recorded as bare `function(...)` with a
	     "captured" comment — the real payload never made it into the file.
	  2. No return values, so what Inventory / ClanLeaderboard /
	     GlobalLeaderboard actually answer with is unknown.
	  Plus ~90% of the lines are PingHeartbeat / ReplayAimSync spam.

	This records, per remote: call count, the real arguments fully serialized
	(tables, Instances, numbers), what RemoteFunctions returned, and whether the
	call came from you (checkcaller) or from the game.

	Usage:
	  1. Paste this in the executor while in the game.
	  2. Play one round: walk, sprint, jump, melee swing, throw the knife, shoot,
	     take a hit, open the case, open both leaderboards, get killed.
	  3. Press "Copy" (or read the console if your executor has no clipboard).
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local DUMP = {}

DUMP.conf = (type(getgenv().REMOTEDUMP) == "table") and getgenv().REMOTEDUMP or {}
DUMP.live = true
DUMP.maxCalls = tonumber(DUMP.conf.maxCalls) or 5000
DUMP.examples = tonumber(DUMP.conf.examples) or 3
DUMP.maxChars = tonumber(DUMP.conf.maxChars) or 40000
DUMP.startedAt = os.clock()
DUMP.entries = {}
DUMP.order = {}
DUMP.total = 0
DUMP.watched = {}
DUMP.uiAt = 0

-- chatty remotes are counted but not shown, same as the spy log only quieter
DUMP.NOISE = {
	PingHeartbeat = true, PingRF = true, PerfStats = true, ReplayAimSync = true,
	Sound = true, Effect = true, CanChatWith = true, SendPlayerProfileSettings = true,
	NewPlayerGroupDetails = true, NewPlayerCanManageDetails = true,
}

-- --------------------------------------------------------------- serialize --

DUMP.ser = function(v, depth, seen)
	depth = depth or 0
	seen = seen or {}
	local t = typeof(v)
	if t == "string" then
		local s = v
		if #s > 200 then s = s:sub(1, 200) .. "..." end
		return string.format("%q", s)
	elseif t == "number" then
		if v ~= v then return "nan" end
		if v == math.floor(v) and math.abs(v) < 1e15 then return string.format("%d", v) end
		return string.format("%.4f", v)
	elseif t == "boolean" or t == "nil" then
		return tostring(v)
	elseif t == "Instance" then
		local ok, full = pcall(function() return v:GetFullName() end)
		local cls = "Instance"
		pcall(function() cls = v.ClassName end)
		return "<" .. cls .. " " .. (ok and full or "?") .. ">"
	elseif t == "table" then
		if seen[v] then return "<cycle>" end
		if depth >= 4 then return "{...}" end
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
			-- numeric keys must sort numerically, or index 11 lands before 2
			if type(a) == "number" and type(b) == "number" then return a < b end
			return tostring(a) < tostring(b)
		end)
		local parts = {}
		for i, k in ipairs(keys) do
			if i > 14 then
				parts[#parts + 1] = "..."
				break
			end
			local key = (type(k) == "string" and (k .. " = ")) or ""
			parts[#parts + 1] = key .. DUMP.ser(v[k], depth + 1, seen)
		end
		seen[v] = nil
		return "{" .. table.concat(parts, ", ") .. "}"
	end
	local ok, s = pcall(tostring, v)
	return ok and s or "<?>"
end

DUMP.serArgs = function(packed)
	local parts = {}
	for i = 1, (packed.n or #packed) do
		parts[#parts + 1] = DUMP.ser(packed[i])
	end
	return table.concat(parts, ", ")
end

DUMP.short = function(full)
	local s = tostring(full)
	s = s:gsub("^ReplicatedStorage%.", "")
	s = s:gsub("^RobloxReplicatedStorage%.", "RRS.")
	return s
end

DUMP.noisy = function(name)
	return DUMP.NOISE[name] == true
end

-- ------------------------------------------------------------------ record --

DUMP.hit = function(inst, method, packed, ret, fromPlayer)
	if not DUMP.live then return end
	if DUMP.total >= DUMP.maxCalls then return end

	local okName, full = pcall(function() return inst:GetFullName() end)
	full = okName and full or tostring(inst)
	local key = full .. ":" .. method

	local entry = DUMP.entries[key]
	if not entry then
		local name = "?"
		pcall(function() name = inst.Name end)
		entry = {
			key = key,
			path = full,
			short = DUMP.short(full),
			name = name,
			method = method,
			count = 0,
			examples = {},
			ret = nil,
			fromPlayer = false,
		}
		DUMP.entries[key] = entry
		table.insert(DUMP.order, key)
	end

	entry.count = entry.count + 1
	DUMP.total = DUMP.total + 1
	if fromPlayer then entry.fromPlayer = true end

	local sig = DUMP.serArgs(packed)
	entry.last = sig
	if not DUMP.noisy(entry.name) and #entry.examples < DUMP.examples then
		local dupe = false
		for _, ex in ipairs(entry.examples) do
			if ex == sig then
				dupe = true
				break
			end
		end
		if not dupe then entry.examples[#entry.examples + 1] = sig end
	end
	if ret ~= nil then entry.ret = DUMP.ser(ret) end

	DUMP.paint()
end

DUMP.paint = function()
	if not DUMP.status then return end
	local now = os.clock()
	if now - DUMP.uiAt < 0.2 then return end
	DUMP.uiAt = now
	DUMP.status.Text = tostring(DUMP.total) .. " calls  ·  "
		.. tostring(#DUMP.order) .. " remotes  ·  "
		.. string.format("%.0fs", now - DUMP.startedAt)
end

-- ------------------------------------------------------------------ attach --

DUMP.watchEvent = function(inst)
	local okKey, key = pcall(function() return inst:GetFullName() end)
	if not okKey or not key or DUMP.watched[key] then return end
	DUMP.watched[key] = true
	pcall(function()
		inst.OnClientEvent:Connect(function(...)
			-- Luau forbids "..." inside a nested closure, so pack it here
			local args = table.pack(...)
			pcall(function()
				DUMP.hit(inst, "OnClientEvent", args)
			end)
		end)
	end)
end

DUMP.scan = function(node, depth)
	if depth > 6 then return end
	local ok, kids = pcall(function() return node:GetChildren() end)
	if not ok or not kids then return end
	for _, child in ipairs(kids) do
		local isRemote = false
		pcall(function()
			isRemote = child:IsA("RemoteEvent") or child:IsA("RemoteFunction")
				or child:IsA("UnreliableRemoteEvent")
		end)
		if isRemote then
			if not child:IsA("RemoteFunction") then DUMP.watchEvent(child) end
		else
			DUMP.scan(child, depth + 1)
		end
	end
end

DUMP.hook = function()
	if DUMP.hooked then return end
	local getmt, hookfunc, method, caller = getrawmetatable, hookfunction, getnamecallmethod, checkcaller
	if not (getmt and hookfunc and method) then
		DUMP.note("no hookfunction — incoming events only")
		DUMP.hooked = "partial"
		return
	end
	local ok, mt = pcall(getmt, game)
	if not ok or not mt or not rawget(mt, "__namecall") then
		DUMP.note("could not reach __namecall")
		DUMP.hooked = "partial"
		return
	end
	pcall(function() setreadonly(mt, false) end)
	local old = mt.__namecall
	hookfunc(old, function(self, ...)
		local m = method()
		if m == "FireServer" or m == "InvokeServer" then
			local args = table.pack(...)
			local mine = false
			if caller then
				local okCaller, res = pcall(caller)
				mine = okCaller and res == true
			end
			if m == "InvokeServer" then
				local ret = old(self, ...)
				pcall(function() DUMP.hit(self, m, args, ret, mine) end)
				return ret
			end
			old(self, ...)
			pcall(function() DUMP.hit(self, m, args, nil, mine) end)
			return nil
		end
		return old(self, ...)
	end)
	pcall(function() setreadonly(mt, true) end)
	DUMP.hooked = true
end

-- ------------------------------------------------------------------ report --

DUMP.entryList = function()
	local list = {}
	for _, key in ipairs(DUMP.order) do
		local e = DUMP.entries[key]
		if e then list[#list + 1] = e end
	end
	table.sort(list, function(a, b)
		local an, bn = DUMP.noisy(a.name), DUMP.noisy(b.name)
		if an ~= bn then return not an end
		if a.count ~= b.count then return a.count > b.count end
		return a.short < b.short
	end)
	return list
end

DUMP.report = function()
	local list = DUMP.entryList()
	local out = {}
	local function add(line) out[#out + 1] = line end

	local okPlace, placeId = pcall(function() return game.PlaceId end)
	local okName, placeName = pcall(function() return game.Name end)
	add("== GAME ==")
	add("place  : " .. tostring(okPlace and placeId or "?") .. "  " .. tostring(okName and placeName or ""))
	add("player : " .. tostring(player.Name) .. " (" .. tostring(player.UserId) .. ")")
	add(string.format("window : %.0fs   calls: %d   remotes: %d",
		os.clock() - DUMP.startedAt, DUMP.total, #list))
	add("")

	add("== REMOTES ==")
	for _, e in ipairs(list) do
		local tag = ""
		if e.fromPlayer then tag = "  [called by you]" end
		if DUMP.noisy(e.name) then tag = "  [noise]" end
		local ret = e.ret and ("  ret: " .. e.ret:sub(1, 60)) or ""
		add(string.format("%-44s %-14s x%-4d%s%s",
			e.short, e.method, e.count, ret, tag))
	end
	add("")

	add("== CALLS ==")
	local cut = false
	for _, e in ipairs(list) do
		if DUMP.noisy(e.name) then
			if e.last then
				add(e.short .. ":" .. e.method .. "(" .. e.last .. ")   [noise, x" .. e.count .. "]")
			end
		else
			add("-- " .. e.short .. ":" .. e.method .. "  x" .. e.count)
			add("path : " .. e.path)
			for _, ex in ipairs(e.examples) do
				add("  (" .. ex .. ")")
			end
			if e.ret then add("  ret: " .. e.ret) end
		end
		if #out > 900 then
			cut = true
			break
		end
	end
	if cut then add("-- ...report cut short") end

	local text = table.concat(out, "\n")
	if #text > DUMP.maxChars then
		text = text:sub(1, DUMP.maxChars) .. "\n-- truncated at " .. DUMP.maxChars .. " chars"
	end
	return text
end

DUMP.copy = function()
	local text = DUMP.report()
	local okClip = false
	pcall(function()
		if setclipboard then
			setclipboard(text)
			okClip = true
		elseif toclipboard then
			toclipboard(text)
			okClip = true
		end
	end)
	if okClip then
		DUMP.note("report copied (" .. tostring(#text) .. " chars)")
	else
		for i = 1, #text, 900 do
			print(text:sub(i, i + 899))
		end
		DUMP.note("no clipboard — printed to console")
	end
end

DUMP.note = function(text)
	if DUMP.status then DUMP.status.Text = text end
	print("[DUMP] " .. text)
end

-- ---------------------------------------------------------------------- ui --

DUMP.new = function(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			pcall(function() inst[k] = v end)
		end
	end
	if parent then inst.Parent = parent end
	return inst
end

DUMP.build = function()
	local gui = Instance.new("ScreenGui")
	gui.Name = "RemoteDump"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 998
	local host = player:WaitForChild("PlayerGui")
	pcall(function()
		local hui = gethui and gethui()
		if hui then host = hui end
	end)
	gui.Parent = host
	DUMP.gui = gui

	local f = DUMP.new("Frame", {
		Size = UDim2.fromOffset(430, 92),
		Position = UDim2.new(0.5, -215, 0, 40),
		BackgroundColor3 = Color3.fromRGB(16, 16, 20),
		BorderSizePixel = 0,
	}, gui)
	DUMP.frame = f
	DUMP.new("UICorner", { CornerRadius = UDim.new(0, 8) }, f)

	DUMP.new("TextLabel", {
		Size = UDim2.new(1, -16, 0, 18),
		Position = UDim2.fromOffset(8, 6),
		BackgroundTransparency = 1,
		Text = "Remote Dump",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(232, 232, 240),
	}, f)

	DUMP.status = DUMP.new("TextLabel", {
		Size = UDim2.new(1, -16, 0, 14),
		Position = UDim2.fromOffset(8, 24),
		BackgroundTransparency = 1,
		Text = "0 calls",
		Font = Enum.Font.Code,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(140, 140, 155),
	}, f)

	local function btn(text, x, w, fn)
		local b = DUMP.new("TextButton", {
			Size = UDim2.fromOffset(w, 24),
			Position = UDim2.fromOffset(x, 52),
			BackgroundColor3 = Color3.fromRGB(34, 34, 43),
			BorderSizePixel = 0,
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(232, 232, 240),
		}, f)
		DUMP.new("UICorner", { CornerRadius = UDim.new(0, 4) }, b)
		b.MouseButton1Click:Connect(fn)
		return b
	end

	btn("Copy", 8, 96, function() DUMP.copy() end)
	btn("Clear", 112, 96, function()
		DUMP.entries = {}
		DUMP.order = {}
		DUMP.total = 0
		DUMP.startedAt = os.clock()
		DUMP.note("cleared")
	end)
	local pause = btn("Pause", 216, 96, function() end)
	pause.MouseButton1Click:Connect(function()
		DUMP.live = not DUMP.live
		pause.Text = DUMP.live and "Pause" or "Resume"
		DUMP.note(DUMP.live and "recording" or "paused")
	end)
	btn("Hide", 320, 96, function() f.Visible = false end)

	local tab = DUMP.new("TextButton", {
		Size = UDim2.fromOffset(44, 22),
		Position = UDim2.fromOffset(12, 40),
		BackgroundColor3 = Color3.fromRGB(34, 34, 43),
		BorderSizePixel = 0,
		Text = "D",
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.fromRGB(150, 110, 240),
	}, gui)
	DUMP.new("UICorner", { CornerRadius = UDim.new(0, 5) }, tab)
	tab.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)
end

-- ------------------------------------------------------------------- start --

DUMP.build()
DUMP.scan(ReplicatedStorage, 0)
pcall(function() DUMP.scan(game:GetService("RobloxReplicatedStorage"), 0) end)
DUMP.hook()
pcall(function()
	ReplicatedStorage.DescendantAdded:Connect(function(inst)
		local ok, isRemote = pcall(function()
			return inst:IsA("RemoteEvent") or inst:IsA("UnreliableRemoteEvent")
		end)
		if ok and isRemote then DUMP.watchEvent(inst) end
	end)
end)

DUMP.note("recording — play a round, then press Copy")

getgenv().REMOTEDUMP = DUMP
getgenv().RD = DUMP
