--[[ Speed / Jump / NoClip / Fly + Emotes + Player Trolls
     Anti-void / anti-fling / no fall damage run always, no toggles
     Emotes = read from your emotes.json in the executor workspace (with search)
     Players = pick a player then HeadSit / Twerk / Slap Ass etc. ]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PURPLE = Color3.fromRGB(140, 60, 255)
local PURPLE_DIM = Color3.fromRGB(90, 40, 170)
local BG = Color3.fromRGB(12, 10, 18)
local PANEL = Color3.fromRGB(22, 18, 32)
local TEXT = Color3.fromRGB(235, 230, 255)
local OFF = Color3.fromRGB(50, 45, 60)
local ON = Color3.fromRGB(80, 180, 90)
local MUTED = Color3.fromRGB(140, 130, 160)
local RED = Color3.fromRGB(160, 50, 60)

local open = false
local emotesOpen = false
local playersOpen = false
local chatOpen = false
local speedVal = 16
local jumpVal = 50
local noclipOn = false
local flyOn = false

local showFlyBtn = true
local showEmotesBtn = true
local showPlayersBtn = true

-- Tornado / Part Claim
local tornadoEnabled = false
local floatAroundMe = false
local tornadoRadius = 300 -- funnel radius in studs (Waypoint page > Radius)
local tornadoHeight = 120 -- funnel height in studs
local tornadoRotSpeed = 1000 -- spin speed: studs travelled per second around the funnel
local tornadoAttract = 2200 -- max studs/sec a part moves while it is being pulled in
local claimedParts = {} -- [part] = {ring, h, angle, owned, ...}
local tornadoConn = nil

-- OpenRouter (hardcoded) — openrouter/free auto-picks best free model
local DEFAULT_OPENROUTER_KEY = "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"

-- Up to 5 keys, used in turn. When one is rate limited (429), rejected (401)
-- or out of credits (402) it rests for a while and the next key answers the
-- very same request, so one dead key cannot break translation.
-- Any of these work, in this order:
--   getgenv().OPENROUTER_KEYS = { "sk-or-v1-a", "sk-or-v1-b" }   (best)
--   getgenv().OPENROUTER_KEY  = "sk-or-v1-a"                    (one key)
--   openrouter_keys.txt in the executor workspace, one key per line
--   the OPENROUTER_KEYS table right below
local OPENROUTER_KEYS = {
	-- "sk-or-v1-second-key",
	-- "sk-or-v1-third-key",
}

local function readKeyFile()
	local out = {}
	pcall(function()
		if not (isfile and readfile and isfile("openrouter_keys.txt")) then return end
		for line in tostring(readfile("openrouter_keys.txt")):gmatch("[^\r\n]+") do
			line = (line:gsub("%s+", ""))
			if line ~= "" and not line:match("^%-%-") then out[#out + 1] = line end
		end
	end)
	return out
end
local OPENROUTER_FILE_KEYS = readKeyFile()

-- A stale key is the number one reason translation silently does nothing.
local GENV_KEY = nil
pcall(function()
	if type(getgenv) == "function" then GENV_KEY = getgenv().OPENROUTER_KEY end
end)
local OPENROUTER_KEY = (type(GENV_KEY) == "string" and GENV_KEY ~= "")
	and GENV_KEY or DEFAULT_OPENROUTER_KEY
local OPENROUTER_MODEL = "openrouter/free"

local flyBV, flyBG, flyConn, flyMoveConn
local noclipConn
local tpwalking = false
local currentTrack = nil

local selectedPlayer = nil
local waypointPos = nil
local waypointSet = false
local trollConn = nil
-- multiple trolls can be active at once (e.g. headsit + twerk)
local activeTrolls = {} -- set of mode strings
local trollAnimTracks = {} -- mode -> track

local STATES = {
	Enum.HumanoidStateType.Climbing,
	Enum.HumanoidStateType.FallingDown,
	Enum.HumanoidStateType.Flying,
	Enum.HumanoidStateType.Freefall,
	Enum.HumanoidStateType.GettingUp,
	Enum.HumanoidStateType.Jumping,
	Enum.HumanoidStateType.Landed,
	Enum.HumanoidStateType.Physics,
	Enum.HumanoidStateType.PlatformStanding,
	Enum.HumanoidStateType.Ragdoll,
	Enum.HumanoidStateType.Running,
	Enum.HumanoidStateType.RunningNoPhysics,
	Enum.HumanoidStateType.Seated,
	Enum.HumanoidStateType.StrafingNoPhysics,
	Enum.HumanoidStateType.Swimming,
}

-- R6 / float emotes stay built in: they need per-entry speed / timePos / loop,
-- which a plain name + id file cannot describe.
local EMOTES = {
	-- R6 / float / special (need speed + Animate off)
	{name = "Arm Detach", id = 33169583, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Arm Turbine", id = 259438880, kind = "r6", speed = 1.5, timePos = 0.0, loop = true},
	{name = "Arms Out", id = 27432691, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Balloon Float", id = 148840371, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Beat Box", id = 45504977, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Big Guns", id = 161268368, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Bigger Guns", id = 225975820, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Bow Down", id = 204292303, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Charleston", id = 429703734, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Chop", id = 33169596, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Clone Illusion", id = 215384594, kind = "r6", speed = 1.0, timePos = 0.5, loop = true},
	{name = "Crouch", id = 287325678, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Crouch", id = 182724289, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Cry", id = 180612465, kind = "r6", speed = 1.5, timePos = 0.0, loop = true},
	{name = "Dab", id = 183412246, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Dance", id = 35654637, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Dino Walk", id = 204328711, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Faint", id = 181526230, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Float Sit", id = 179224234, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Floating Head", id = 121572214, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Floor Faint", id = 181525546, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Flying", id = 46196309, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Full Punch", id = 204062532, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Full Swing", id = 218504594, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Glitch Levitate", id = 313762630, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Goal!", id = 28488254, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Head Detach", id = 35154961, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Hero Jump", id = 184574340, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Hmmm", id = 33855276, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Idle", id = 180435571, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Insane Legs", id = 87986341, kind = "r6", speed = 99.0, timePos = 0.0, loop = true},
	{name = "Insane Rotation", id = 121572214, kind = "r6", speed = 99.0, timePos = 0.0, loop = true},
	{name = "Jumping Jacks", id = 429681631, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Kick", id = 45737360, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Mega Insane", id = 184574340, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Moon Dance", id = 27789359, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Moon Walk", id = 30196114, kind = "r6", speed = 0.0, timePos = 3.0, loop = true},
	{name = "Party Time", id = 33796059, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Penguin Slide", id = 282574440, kind = "r6", speed = 0.0, timePos = 0.0, loop = true},
	{name = "Pinch Nose", id = 30235165, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Random", id = 48977286, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Roar", id = 163209885, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Rotation", id = 136801964, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Scream", id = 180611870, kind = "r6", speed = 1.5, timePos = 0.0, loop = true},
	{name = "Spin", id = 188632011, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Spin Dance", id = 429730430, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Spin Dance 2", id = 186934910, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Stab", id = 66703241, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Sword", id = 35978879, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Sword Slam", id = 204295235, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Tilt Head", id = 283545583, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Weird Float", id = 248336459, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Weird Pose", id = 248336163, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Weird Sway", id = 248336677, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
	{name = "Zombie Arms", id = 183294396, kind = "r6", speed = 1.0, timePos = 0.0, loop = true},
}

-- ===== Catalog emotes: read from emotes.json in your executor workspace =====
-- Names + ids are not hardcoded here any more; the file fills the Emotes list.
-- Accepted shapes:
--   [{"name": "Dance", "id": 12345}, ...]
--   [["Dance", 12345], ...]   or   [[12345, "Dance"], ...]
--   {"Dance": 12345, ...}     (wrapped in {"emotes": ...} / {"data": ...} is fine)
-- Optional per-entry fields are honoured: kind, speed, timePos, loop.
-- Use another file name with:  getgenv().EMOTES_FILE = "my_emotes.json"
local EMOTE_SRC = {
	path = (type(getgenv().EMOTES_FILE) == "string" and getgenv().EMOTES_FILE ~= "")
		and getgenv().EMOTES_FILE or "emotes.json",
	builtin = #EMOTES, -- the R6 entries above are kept; everything after them comes from the file
	loaded = 0,
	printed = -1,
	error = nil,
	reported = nil,
	tried = nil,
	seen = {},
}

function EMOTE_SRC.fail(short, detail)
	EMOTE_SRC.error = short
	local full = detail or short
	if EMOTE_SRC.reported ~= full then
		EMOTE_SRC.reported = full
		warn("[emotes] " .. full)
	end
	return false
end

function EMOTE_SRC.read()
	if type(readfile) ~= "function" then
		EMOTE_SRC.error = "this executor has no readfile()"
		return nil
	end
	local paths = { EMOTE_SRC.path }
	pcall(function()
		local ws = (type(getworkspace) == "function") and getworkspace() or nil
		if type(ws) == "string" and ws ~= "" then
			table.insert(paths, 1, ws .. "/" .. EMOTE_SRC.path)
			table.insert(paths, 1, ws .. "\\" .. EMOTE_SRC.path)
		end
	end)
	local tried = {}
	for _, path in ipairs(paths) do
		local exists = true
		if type(isfile) == "function" then
			local ok, found = pcall(isfile, path)
			exists = ok and found == true
		end
		if exists then
			local ok, data = pcall(readfile, path)
			if ok and type(data) == "string" and data ~= "" then
				EMOTE_SRC.path = path
				return data
			end
		end
		tried[#tried + 1] = path
	end
	EMOTE_SRC.tried = tried
	EMOTE_SRC.error = "not found"
	return nil
end

function EMOTE_SRC.add(name, id, extra)
	local numId = tonumber(id)
	if type(name) ~= "string" or not numId then return end
	name = name:gsub("^%s+", ""):gsub("%s+$", "")
	numId = math.floor(numId)
	if name == "" or numId <= 0 then return end
	local key = tostring(numId) .. "|" .. string.lower(name)
	if EMOTE_SRC.seen[key] then return end
	EMOTE_SRC.seen[key] = true
	local entry = {
		name = name,
		id = numId,
		kind = (type(extra) == "table" and type(extra.kind) == "string") and extra.kind or "catalog",
	}
	if type(extra) == "table" then
		if type(extra.speed) == "number" then entry.speed = extra.speed end
		if type(extra.timePos) == "number" then entry.timePos = extra.timePos end
		if type(extra.loop) == "boolean" then entry.loop = extra.loop end
	end
	EMOTES[#EMOTES + 1] = entry
	EMOTE_SRC.loaded = EMOTE_SRC.loaded + 1
end

function EMOTE_SRC.parse(data)
	local ok, decoded = pcall(function()
		return game:GetService("HttpService"):JSONDecode(data)
	end)
	if not ok or type(decoded) ~= "table" then
		return false, "invalid JSON"
	end
	if type(decoded.emotes) == "table" then
		decoded = decoded.emotes
	elseif type(decoded.list) == "table" then
		decoded = decoded.list
	elseif type(decoded.data) == "table" then
		decoded = decoded.data
	end
	for key, value in pairs(decoded) do
		if type(value) == "table" then
			local name = value.name or value.Name or value.title or value.Title
				or value.displayName or value.DisplayName
			local id = value.id or value.Id or value.assetId or value.AssetId
				or value.animationId or value.AnimationId
			if name ~= nil and id ~= nil then
				EMOTE_SRC.add(tostring(name), id, value)
			elseif type(value[1]) == "string" then
				EMOTE_SRC.add(value[1], value[2])
			elseif type(value[2]) == "string" then
				EMOTE_SRC.add(value[2], value[1])
			end
		elseif type(key) == "string" and tonumber(value) then
			EMOTE_SRC.add(key, value) -- {"Dance": 12345}
		end
	end
	return true
end

function EMOTE_SRC.load()
	-- drop whatever the previous read added, keep the built-in R6 set
	for i = #EMOTES, EMOTE_SRC.builtin + 1, -1 do EMOTES[i] = nil end
	EMOTE_SRC.loaded = 0
	EMOTE_SRC.error = nil
	EMOTE_SRC.tried = nil
	EMOTE_SRC.seen = {}

	local data = EMOTE_SRC.read()
	if not data then
		local detail = "could not read " .. EMOTE_SRC.path .. " — " .. tostring(EMOTE_SRC.error)
		if EMOTE_SRC.tried and #EMOTE_SRC.tried > 0 then
			detail = detail .. " (tried: " .. table.concat(EMOTE_SRC.tried, ", ") .. ")"
		end
		return EMOTE_SRC.fail(EMOTE_SRC.error or "unreadable", detail)
	end

	local parsed, perr = EMOTE_SRC.parse(data)
	if not parsed then
		return EMOTE_SRC.fail(tostring(perr), EMOTE_SRC.path .. ": " .. tostring(perr))
	end
	if EMOTE_SRC.loaded == 0 then
		return EMOTE_SRC.fail("no entries", EMOTE_SRC.path .. ": no usable name/id entries")
	end

	-- alphabetical like the old hardcoded list, ignoring case
	local tail = {}
	for i = EMOTE_SRC.builtin + 1, #EMOTES do tail[#tail + 1] = EMOTES[i] end
	table.sort(tail, function(a, b)
		return string.lower(a.name) < string.lower(b.name)
	end)
	for i = 1, #tail do EMOTES[EMOTE_SRC.builtin + i] = tail[i] end

	if EMOTE_SRC.loaded ~= EMOTE_SRC.printed then
		EMOTE_SRC.printed = EMOTE_SRC.loaded
		print(string.format("[emotes] %d entries loaded from %s", EMOTE_SRC.loaded, EMOTE_SRC.path))
	end
	return true
end

EMOTE_SRC.load()

local TROLL_ACTIONS = {
	{ name = "Head Sit", mode = "headsit", id = nil },
	{ name = "Twerk Ass", mode = "twerk", id = 13694096724 }, -- Scorpion-style
	{ name = "Twerk Ass 2", mode = "twerk2", id = 16302968986 }, -- Beauty Touchdown
	{ name = "Slap Ass", mode = "slap", id = 16302968986 },
	{ name = "Front Hug", mode = "fronthug", id = 4940563117 }, -- cower-ish / close
	{ name = "Back Hug", mode = "backhug", id = 3333331310 },
}

local function humanoid()
	local char = player.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function root()
	local char = player.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function flyPart()
	local char = player.Character
	if not char then return nil end
	return char:FindFirstChild("Torso")
		or char:FindFirstChild("LowerTorso")
		or char:FindFirstChild("HumanoidRootPart")
end

local function applyStats()
	local h = humanoid()
	if not h then return end
	h.WalkSpeed = speedVal
	pcall(function() h.JumpPower = jumpVal end)
	pcall(function() h.JumpHeight = jumpVal / 7.2 end)
end

local function setNoclip(state)
	noclipOn = state
	if noclipConn then
		noclipConn:Disconnect()
		noclipConn = nil
	end
	if not noclipOn then
		local char = player.Character
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = true end
			end
		end
		return
	end
	noclipConn = RunService.Stepped:Connect(function()
		local char = player.Character
		if not char then return end
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end)
end

-- ===== SAFETY: anti-void, anti-fling, no fall damage (always on) =====
-- No toggles, no buttons: all three start with the script.
--   fall damage  - Natural Disaster Survival (and most games) do not measure how
--                  far you fell, they measure SPEED. Above ~65 studs/sec they
--                  bank damage, and on the tick your speed drops they call
--                  Humanoid:TakeDamage(banked). That is why a catch platform
--                  never fixed it: stopping dead is exactly the trigger. Holding
--                  the descent under 65 keeps the bank at 0, so the landing call
--                  deals nothing.
--   anti-void   - remembers the last ground you actually stood on and only
--                  rescues you once you are below the kill plane AND fell far
--                  below that spot. It drops you onto the nearest floor under
--                  you first, so you are never yanked back to old ground.
--   anti-fling  - clamps insane linear velocity, zeroes runaway spin (clamping
--                  a 1e6 spin still spins you), and undoes a high-energy
--                  one-frame teleport. Quiet teleports, respawns and round
--                  changes carry no speed and are left alone, so nothing snaps
--                  you backwards during normal play.
local SAFE = {}
SAFE.maxVel = tonumber(getgenv().SAFE_MAX_VEL) or 300
SAFE.maxSpin = tonumber(getgenv().SAFE_MAX_SPIN) or 20
SAFE.termVel = tonumber(getgenv().SAFE_TERM_VEL) or 55 -- keep under the 65 line
SAFE.catchSpeed = tonumber(getgenv().SAFE_CATCH_SPEED) or 140
SAFE.flingSpeed = tonumber(getgenv().SAFE_FLING_SPEED) or 600
SAFE.voidMargin = tonumber(getgenv().SAFE_VOID_MARGIN) or 60
SAFE.voidDrop = tonumber(getgenv().SAFE_VOID_DROP) or 120
SAFE.jumpLimit = tonumber(getgenv().SAFE_JUMP_LIMIT) or 150
SAFE.teleport = getgenv().SAFE_RESCUE_TP ~= false
SAFE.pad = nil
SAFE.lastSafe = nil
SAFE.lastPos = nil
SAFE.saved = -math.huge

SAFE.dropPad = function(wait)
	local p = SAFE.pad
	if not p then return end
	SAFE.pad = nil
	task.delay(wait or 0, function()
		pcall(function() p:Destroy() end)
	end)
end

SAFE.onSpawn = function()
	SAFE.dropPad()
	SAFE.lastSafe = nil
	SAFE.lastPos = nil
	SAFE.saved = -math.huge
end

SAFE.makePad = function()
	if SAFE.pad then return SAFE.pad end
	local r = root()
	if not r then return nil end
	local p = Instance.new("Part")
	p.Name = "SafeFloor"
	p.Size = Vector3.new(15, 1, 15)
	p.CFrame = CFrame.new(r.Position - Vector3.new(0, 4, 0))
	p.Anchored = true
	p.CanCollide = true
	p.Massless = true
	p.Locked = true
	p.Transparency = 1
	pcall(function() p.CanTouch = false end)
	p.Parent = workspace
	SAFE.pad = p
	task.delay(10, function()
		if SAFE.pad == p then SAFE.dropPad() end
	end)
	return p
end

-- first solid thing under us (character excluded); nil when there is none
SAFE.hitBelow = function(r, maxDist)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = { player.Character }
	local ok, hit = pcall(function()
		return workspace:Raycast(r.Position, Vector3.new(0, -maxDist, 0), params)
	end)
	if ok and hit then return hit.Position end
	return nil
end

SAFE.airBelow = function(r, maxDist)
	local pos = SAFE.hitBelow(r, maxDist)
	if not pos then return nil end
	return r.Position.Y - pos.Y
end

-- move the character without keeping the speed that got it in trouble
SAFE.place = function(target)
	local r = root()
	local hum = humanoid()
	if not r or not hum then return end
	SAFE.saved = os.clock()
	pcall(function() r.AssemblyLinearVelocity = Vector3.zero end)
	pcall(function() r.AssemblyAngularVelocity = Vector3.zero end)
	if SAFE.teleport then
		pcall(function() r.CFrame = CFrame.new(target) end)
	else
		pcall(function() r.AssemblyLinearVelocity = Vector3.new(0, 30, 0) end)
	end
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed) end)
	SAFE.lastPos = nil
end

SAFE.step = function()
	local r = root()
	local hum = humanoid()
	if not r or not hum or not r:IsDescendantOf(workspace) then return end
	if hum.Health <= 0 then return end

	local ok, vel = pcall(function() return r.AssemblyLinearVelocity end)
	if not ok or typeof(vel) ~= "Vector3" then vel = Vector3.zero end
	local raw = vel.Magnitude

	-- ---------- anti-fling ----------
	if raw > SAFE.maxVel then
		vel = vel.Unit * SAFE.maxVel
		pcall(function() r.AssemblyLinearVelocity = vel end)
	end
	pcall(function()
		local spin = r.AssemblyAngularVelocity
		if typeof(spin) == "Vector3" and spin.Magnitude > SAFE.maxSpin then
			r.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	-- only a teleport that arrives with real energy is a fling; a spawn, a round
	-- change or a fast travel carries ~no velocity and must not be undone
	if SAFE.lastPos and not flyOn and raw > SAFE.flingSpeed
		and os.clock() - SAFE.saved > 0.75 then
		if (r.Position - SAFE.lastPos).Magnitude > SAFE.jumpLimit then
			SAFE.place(SAFE.lastPos)
			return
		end
	end
	SAFE.lastPos = r.Position

	-- ---------- anti-void ----------
	local destroyY = workspace.FallenPartsDestroyHeight
	local grounded = hum.FloorMaterial ~= Enum.Material.Air
	if grounded and r.Position.Y > destroyY + SAFE.voidMargin * 2 then
		SAFE.lastSafe = r.Position
	end
	if r.Position.Y < destroyY + SAFE.voidMargin and not flyOn
		and os.clock() - SAFE.saved > 0.75 then
		local dropped = SAFE.lastSafe and (SAFE.lastSafe.Y - r.Position.Y) or math.huge
		if vel.Y < -20 or noclipOn or dropped > SAFE.voidDrop then
			local floorPos = SAFE.hitBelow(r, 600)
			if floorPos and floorPos.Y > destroyY + SAFE.voidMargin then
				-- fell through the map: land on whatever is under you now
				SAFE.place(floorPos + Vector3.new(0, 4, 0))
			elseif SAFE.lastSafe then
				SAFE.place(SAFE.lastSafe + Vector3.new(0, 5, 0))
			else
				SAFE.place(r.Position + Vector3.new(0, 250, 0))
			end
			return
		end
	end

	-- ---------- no fall damage ----------
	if flyOn then
		if SAFE.pad then SAFE.dropPad() end
		return
	end
	if grounded then
		if SAFE.pad then SAFE.dropPad(0.6) end
		return
	end
	-- the fix itself: hold the sampled speed under the damage threshold. 55 is
	-- under the 65 line, and a normal jump only reaches ~50, so ordinary
	-- movement is untouched and only real falls get held back.
	if vel.Y < -20 and vel.Magnitude > SAFE.termVel then
		local capped = vel.Unit * SAFE.termVel
		pcall(function() r.AssemblyLinearVelocity = capped end)
	end
	-- last resort for games that never look at velocity: still catch the drop
	if vel.Y < -SAFE.catchSpeed then
		local air = SAFE.airBelow(r, 8)
		if air and air <= 6 then
			SAFE.makePad()
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.new(vel.X * 0.2, 0, vel.Z * 0.2)
			end)
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed) end)
		end
	end
end

-- pcall wrapper: one bad frame must never turn into a spam of errors
SAFE.conn = RunService.Stepped:Connect(function()
	pcall(SAFE.step)
end)

local function setStatesEnabled(hum, on)
	for _, st in ipairs(STATES) do
		pcall(function() hum:SetStateEnabled(st, on) end)
	end
end

local function stopFly()
	flyOn = false
	tpwalking = false
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyMoveConn then flyMoveConn:Disconnect() flyMoveConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local char = player.Character
	local hum = humanoid()
	if hum then
		setStatesEnabled(hum, true)
		hum.PlatformStand = false
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
	end
	if char then
		local anim = char:FindFirstChild("Animate")
		if anim then anim.Disabled = false end
	end
end

local function startFly()
	local char = player.Character
	local hum = humanoid()
	local part = flyPart()
	if not char or not hum or not part then return end
	stopFly()
	flyOn = true
	local anim = char:FindFirstChild("Animate")
	if anim then anim.Disabled = true end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function() t:AdjustSpeed(0) end)
	end
	setStatesEnabled(hum, false)
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Swimming) end)
	hum.PlatformStand = true

	flyBG = Instance.new("BodyGyro")
	flyBG.P = 9e4
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.CFrame = part.CFrame
	flyBG.Parent = part

	flyBV = Instance.new("BodyVelocity")
	flyBV.Velocity = Vector3.new(0, 0, 0)
	flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Parent = part

	tpwalking = true
	flyMoveConn = RunService.Heartbeat:Connect(function()
		if not flyOn or not tpwalking then return end
		local c = player.Character
		local h = humanoid()
		if not c or not h or not h.Parent then return end
		local md = h.MoveDirection
		if md.Magnitude > 0 then
			local mult = math.clamp(speedVal / 16, 0.25, 100)
			c:TranslateBy(md * mult)
		end
	end)

	flyConn = RunService.RenderStepped:Connect(function()
		if not flyOn then return end
		local part2 = flyPart()
		local cam = workspace.CurrentCamera
		if not part2 or not flyBV or not flyBG or not cam then return end
		flyBG.CFrame = cam.CFrame
		flyBV.Velocity = Vector3.new(0, 0, 0)
	end)
end

local function toggleFly()
	if flyOn then stopFly() else startFly() end
end

local function stopEmote()
	if currentTrack then
		pcall(function() currentTrack:Stop(0.1) end)
		currentTrack = nil
	end
	local char = player.Character
	if char then
		local animate = char:FindFirstChild("Animate")
		if animate then
			animate.Disabled = false
		end
	end
end

local function resolveAnimationId(rawId)
	-- Many catalog / UGC "emote" IDs are not direct Animation assets.
	-- Resolve via GetObjects so we get a real Animation.AnimationId when possible.
	local idStr = tostring(rawId)
	local ok, objs = pcall(function()
		return game:GetObjects("rbxassetid://" .. idStr)
	end)
	if ok and type(objs) == "table" and #objs > 0 then
		local function findAnim(inst)
			if inst:IsA("Animation") and inst.AnimationId and inst.AnimationId ~= "" then
				return inst.AnimationId
			end
			for _, child in ipairs(inst:GetChildren()) do
				local found = findAnim(child)
				if found then return found end
			end
			return nil
		end
		for _, obj in ipairs(objs) do
			local aid = findAnim(obj)
			if aid then
				return aid
			end
		end
	end
	return "rbxassetid://" .. idStr
end

local function playEmote(assetId, opts)
	opts = opts or {}
	local hum = humanoid()
	local char = player.Character
	if not hum or not char then return end

	-- stop previous emote
	if currentTrack then
		pcall(function() currentTrack:Stop(0) end)
		currentTrack = nil
	end

	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end

	-- clear other tracks so this one can take over
	for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
		pcall(function() t:Stop(0) end)
	end

	local resolvedId = resolveAnimationId(assetId)
	local anim = Instance.new("Animation")
	anim.AnimationId = resolvedId

	local ok, track = pcall(function()
		return animator:LoadAnimation(anim)
	end)
	if not ok or not track then
		-- last-resort direct load
		anim.AnimationId = "rbxassetid://" .. tostring(assetId)
		ok, track = pcall(function()
			return animator:LoadAnimation(anim)
		end)
	end
	if not ok or not track then return end

	local looped = opts.loop
	if looped == nil then looped = true end
	local speed = opts.speed or 1
	local timePos = opts.timePos
	-- R6 specials keep Idle; everything else uses Action4 so it actually overrides
	local priority = opts.priority or Enum.AnimationPriority.Action4

	track.Priority = priority
	track.Looped = looped

	local animate = char:FindFirstChild("Animate")
	if animate then
		animate.Disabled = true
	end

	pcall(function()
		track:Play(0.1)
		track:AdjustSpeed(speed)
		if timePos and timePos > 0 then
			track.TimePosition = timePos
		end
	end)
	currentTrack = track
end


local function getTargetRoot(plr)
	if not plr then return nil end
	local ch = plr.Character
	if not ch then return nil end
	return ch:FindFirstChild("HumanoidRootPart")
		or ch:FindFirstChild("Torso")
		or ch:FindFirstChild("UpperTorso")
end

local function getTargetHead(plr)
	if not plr or not plr.Character then return nil end
	return plr.Character:FindFirstChild("Head")
end

local function stopTroll(mode)
	if mode then
		activeTrolls[mode] = nil
		if trollAnimTracks[mode] then
			pcall(function() trollAnimTracks[mode]:Stop() end)
			trollAnimTracks[mode] = nil
		end
	else
		for m in pairs(activeTrolls) do
			activeTrolls[m] = nil
		end
		for m, tr in pairs(trollAnimTracks) do
			pcall(function() tr:Stop() end)
			trollAnimTracks[m] = nil
		end
	end
	local any = false
	for _ in pairs(activeTrolls) do
		any = true
		break
	end
	if not any then
		if trollConn then
			trollConn:Disconnect()
			trollConn = nil
		end
		local hum = humanoid()
		if hum then
			hum.PlatformStand = false
			hum.Sit = false
		end
	end
end

local function playTrollAnim(mode, assetId, timePos)
	if trollAnimTracks[mode] then
		pcall(function() trollAnimTracks[mode]:Stop() end)
		trollAnimTracks[mode] = nil
	end
	if not assetId then return end
	local hum = humanoid()
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. tostring(assetId)
	local ok, track = pcall(function()
		return animator:LoadAnimation(anim)
	end)
	if not ok or not track then return end
	track.Priority = Enum.AnimationPriority.Action4
	track.Looped = true
	pcall(function()
		track:Play()
		if timePos then track.TimePosition = timePos end
		trollAnimTracks[mode] = track
	end)
	if timePos then
		task.spawn(function()
			while activeTrolls[mode] and trollAnimTracks[mode] do
				pcall(function()
					if trollAnimTracks[mode] then
						trollAnimTracks[mode].TimePosition = timePos
					end
				end)
				task.wait(0.15)
			end
		end)
	end
end

local function ensureTrollLoop()
	if trollConn then return end
	local hum = humanoid()
	if hum then hum.PlatformStand = true end
	if not noclipOn then setNoclip(true) end

	trollConn = RunService.Heartbeat:Connect(function()
		local any = false
		for _ in pairs(activeTrolls) do
			any = true
			break
		end
		if not any then return end

		local myRoot = root()
		if not myRoot then return end
		if not selectedPlayer or not selectedPlayer.Parent then
			stopTroll(nil)
			return
		end
		local tRoot = getTargetRoot(selectedPlayer)
		local tHead = getTargetHead(selectedPlayer)
		if not tRoot then return end

		-- headsit wins for position; otherwise hug/twerk behind/front
		if activeTrolls["headsit"] then
			if tHead then
				myRoot.CFrame = tHead.CFrame * CFrame.new(0, 1.2, 0.1)
			else
				myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
			end
		elseif activeTrolls["fronthug"] then
			myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, -1.2) * CFrame.Angles(0, math.pi, 0)
		elseif activeTrolls["backhug"] or activeTrolls["twerk"] or activeTrolls["twerk2"] or activeTrolls["slap"] then
			myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.1)
		end
	end)
end

local function startTroll(mode, assetId)
	if not selectedPlayer or selectedPlayer == player then return end
	if not selectedPlayer.Parent then return end

	-- click again to toggle that action off
	if activeTrolls[mode] then
		stopTroll(mode)
		return
	end

	activeTrolls[mode] = true
	ensureTrollLoop()

	if mode == "twerk" or mode == "twerk2" then
		playTrollAnim(mode, assetId, 83)
	elseif assetId then
		playTrollAnim(mode, assetId, nil)
	end
	-- headsit is position-only
end

player.CharacterAdded:Connect(function()
	stopTroll(nil)
	stopEmote()
	stopFly()
	SAFE.onSpawn()
	task.wait(0.4)
	applyStats()
	if noclipOn then setNoclip(true) end
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedJumpFlyEmoteMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local function mkBtn(text, size, pos, parent, bg)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = bg or PURPLE
	b.TextColor3 = TEXT
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = text
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = PURPLE_DIM
	return b
end

local toggle = mkBtn("Open", UDim2.fromOffset(88, 40), UDim2.new(0, 12, 0.55, 0), gui, PURPLE)
local flyBtn = mkBtn("Fly: OFF", UDim2.fromOffset(88, 40), UDim2.new(1, -100, 0.55, 0), gui, OFF)
local emotesBtn = mkBtn("Emotes", UDim2.fromOffset(88, 40), UDim2.new(1, -100, 0.55, 48), gui, PURPLE)
local playersBtn = mkBtn("Players", UDim2.fromOffset(88, 40), UDim2.new(1, -100, 0.55, 96), gui, PURPLE)
local chatBtn = mkBtn("Chat", UDim2.fromOffset(88, 40), UDim2.new(1, -100, 0.55, 144), gui, PURPLE)

-- TP above Fly (only visible when waypoint is set)
local tpBtn = mkBtn("TP", UDim2.fromOffset(88, 40), UDim2.new(1, -100, 0.55, -48), gui, PURPLE)
tpBtn.Visible = false
tpBtn.MouseButton1Click:Connect(function()
	if not waypointSet or not waypointPos then return end
	local r = root()
	if not r then return end
	r.CFrame = CFrame.new(waypointPos)
end)

local function refreshTpBtn()
	tpBtn.Visible = waypointSet and waypointPos ~= nil
end


local function refreshFlyBtn()
	flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
	flyBtn.BackgroundColor3 = flyOn and ON or OFF
end
flyBtn.MouseButton1Click:Connect(function()
	toggleFly()
	refreshFlyBtn()
end)

-- Main panel
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(340, 250)
panel.Position = UDim2.new(0, 12, 0.55, -105)
panel.BackgroundColor3 = BG
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
local pStroke = Instance.new("UIStroke", panel)
pStroke.Color = PURPLE
pStroke.Thickness = 1.5

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = PANEL
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -56, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = PURPLE
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Speed / Jump"
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(52, 28)
closeBtn.Position = UDim2.new(1, -60, 0.5, -14)
closeBtn.BackgroundColor3 = PURPLE_DIM
closeBtn.Text = "Close"
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = TEXT
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Tabs: Main | Waypoint | UI
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 28)
tabBar.Position = UDim2.fromOffset(10, 44)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(0.33, -3, 1, 0)
mainTabBtn.Position = UDim2.fromOffset(0, 0)
mainTabBtn.BackgroundColor3 = PURPLE
mainTabBtn.Text = "Main"
mainTabBtn.Font = Enum.Font.GothamBold
mainTabBtn.TextSize = 12
mainTabBtn.TextColor3 = TEXT
mainTabBtn.Parent = tabBar
Instance.new("UICorner", mainTabBtn).CornerRadius = UDim.new(0, 6)

local wpTabBtn = Instance.new("TextButton")
wpTabBtn.Size = UDim2.new(0.33, -3, 1, 0)
wpTabBtn.Position = UDim2.new(0.33, 2, 0, 0)
wpTabBtn.BackgroundColor3 = PANEL
wpTabBtn.Text = "Waypoint"
wpTabBtn.Font = Enum.Font.GothamBold
wpTabBtn.TextSize = 12
wpTabBtn.TextColor3 = TEXT
wpTabBtn.Parent = tabBar
Instance.new("UICorner", wpTabBtn).CornerRadius = UDim.new(0, 6)

local uiTabBtn = Instance.new("TextButton")
uiTabBtn.Size = UDim2.new(0.34, -3, 1, 0)
uiTabBtn.Position = UDim2.new(0.66, 2, 0, 0)
uiTabBtn.BackgroundColor3 = PANEL
uiTabBtn.Text = "UI"
uiTabBtn.Font = Enum.Font.GothamBold
uiTabBtn.TextSize = 12
uiTabBtn.TextColor3 = TEXT
uiTabBtn.Parent = tabBar
Instance.new("UICorner", uiTabBtn).CornerRadius = UDim.new(0, 6)

local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.new(1, 0, 1, -76)
mainPage.Position = UDim2.fromOffset(0, 76)
mainPage.BackgroundTransparency = 1
mainPage.Parent = panel

local wpPage = Instance.new("Frame")
wpPage.Size = UDim2.new(1, 0, 1, -76)
wpPage.Position = UDim2.fromOffset(0, 76)
wpPage.BackgroundTransparency = 1
wpPage.Visible = false
wpPage.Parent = panel

local uiPage = Instance.new("Frame")
uiPage.Size = UDim2.new(1, 0, 1, -76)
uiPage.Position = UDim2.fromOffset(0, 76)
uiPage.BackgroundTransparency = 1
uiPage.Visible = false
uiPage.Parent = panel

local function field(labelText, y, default)
	local lab = Instance.new("TextLabel")
	lab.BackgroundTransparency = 1
	lab.Size = UDim2.new(1, -28, 0, 16)
	lab.Position = UDim2.fromOffset(14, y)
	lab.Font = Enum.Font.GothamMedium
	lab.TextSize = 12
	lab.TextColor3 = TEXT
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Text = labelText
	lab.Parent = mainPage
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -28, 0, 34)
	box.Position = UDim2.fromOffset(14, y + 18)
	box.BackgroundColor3 = PANEL
	box.TextColor3 = TEXT
	box.PlaceholderColor3 = Color3.fromRGB(120, 110, 140)
	box.Font = Enum.Font.Gotham
	box.TextSize = 15
	box.Text = tostring(default)
	box.ClearTextOnFocus = false
	box.Parent = mainPage
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", box).Color = PURPLE_DIM
	return box
end

local speedBox = field("Speed (also fly speed)", 4, 16)
local jumpBox = field("Jump", 60, 50)

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.48, -10, 0, 34)
noclipBtn.Position = UDim2.fromOffset(14, 118)
noclipBtn.BackgroundColor3 = OFF
noclipBtn.Text = "NoClip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 13
noclipBtn.TextColor3 = TEXT
noclipBtn.Parent = mainPage
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.48, -10, 0, 34)
applyBtn.Position = UDim2.new(0.52, 0, 0, 118)
applyBtn.BackgroundColor3 = PURPLE
applyBtn.Text = "Apply"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 14
applyBtn.TextColor3 = TEXT
applyBtn.Parent = mainPage
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 8)

local function refreshNoclipBtn()
	noclipBtn.Text = noclipOn and "NoClip: ON" or "NoClip: OFF"
	noclipBtn.BackgroundColor3 = noclipOn and ON or OFF
end
noclipBtn.MouseButton1Click:Connect(function()
	setNoclip(not noclipOn)
	refreshNoclipBtn()
end)

local function doApply()
	local s = tonumber(speedBox.Text)
	local j = tonumber(jumpBox.Text)
	if s then speedVal = math.max(0, s) speedBox.Text = tostring(speedVal) end
	if j then jumpVal = math.max(0, j) jumpBox.Text = tostring(jumpVal) end
	applyStats()
end
applyBtn.MouseButton1Click:Connect(doApply)
speedBox.FocusLost:Connect(function(enter) if enter then doApply() end end)
jumpBox.FocusLost:Connect(function(enter) if enter then doApply() end end)

local hint = Instance.new("TextLabel")
hint.BackgroundTransparency = 1
hint.Size = UDim2.new(1, -28, 0, 28)
hint.Position = UDim2.fromOffset(14, 158)
hint.Font = Enum.Font.Gotham
hint.TextSize = 11
hint.TextColor3 = MUTED
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.TextWrapped = true
hint.Text = "Emotes = dances · Players = trolls"
hint.Parent = mainPage

-- Waypoint page content (compact + Tornado)
local wpStatus = Instance.new("TextLabel")
wpStatus.BackgroundTransparency = 1
wpStatus.Size = UDim2.new(1, -28, 0, 22)
wpStatus.Position = UDim2.fromOffset(14, 4)
wpStatus.Font = Enum.Font.Gotham
wpStatus.TextSize = 11
wpStatus.TextColor3 = MUTED
wpStatus.TextXAlignment = Enum.TextXAlignment.Left
wpStatus.Text = "No waypoint set"
wpStatus.Parent = wpPage

local setWpBtn = Instance.new("TextButton")
setWpBtn.Size = UDim2.new(0.48, -8, 0, 28)
setWpBtn.Position = UDim2.fromOffset(14, 28)
setWpBtn.BackgroundColor3 = PURPLE
setWpBtn.Text = "Set WP"
setWpBtn.Font = Enum.Font.GothamBold
setWpBtn.TextSize = 12
setWpBtn.TextColor3 = TEXT
setWpBtn.Parent = wpPage
Instance.new("UICorner", setWpBtn).CornerRadius = UDim.new(0, 6)

local clearWpBtn = Instance.new("TextButton")
clearWpBtn.Size = UDim2.new(0.48, -8, 0, 28)
clearWpBtn.Position = UDim2.new(0.52, 0, 0, 28)
clearWpBtn.BackgroundColor3 = RED
clearWpBtn.Text = "Clear"
clearWpBtn.Font = Enum.Font.GothamBold
clearWpBtn.TextSize = 12
clearWpBtn.TextColor3 = TEXT
clearWpBtn.Parent = wpPage
Instance.new("UICorner", clearWpBtn).CornerRadius = UDim.new(0, 6)

local radiusLab = Instance.new("TextLabel")
radiusLab.BackgroundTransparency = 1
radiusLab.Size = UDim2.new(0.4, 0, 0, 14)
radiusLab.Position = UDim2.fromOffset(14, 62)
radiusLab.Font = Enum.Font.GothamMedium
radiusLab.TextSize = 11
radiusLab.TextColor3 = TEXT
radiusLab.TextXAlignment = Enum.TextXAlignment.Left
radiusLab.Text = "Radius"
radiusLab.Parent = wpPage

local radiusBox = Instance.new("TextBox")
radiusBox.Size = UDim2.new(0.55, -10, 0, 26)
radiusBox.Position = UDim2.new(0.4, 0, 0, 58)
radiusBox.BackgroundColor3 = PANEL
radiusBox.TextColor3 = TEXT
radiusBox.Font = Enum.Font.Gotham
radiusBox.TextSize = 13
radiusBox.Text = "300"
radiusBox.ClearTextOnFocus = false
radiusBox.Parent = wpPage
Instance.new("UICorner", radiusBox).CornerRadius = UDim.new(0, 6)

local tornadoBtn = Instance.new("TextButton")
tornadoBtn.Size = UDim2.new(0.48, -8, 0, 28)
tornadoBtn.Position = UDim2.fromOffset(14, 92)
tornadoBtn.BackgroundColor3 = OFF
tornadoBtn.Text = "Tornado: OFF"
tornadoBtn.Font = Enum.Font.GothamBold
tornadoBtn.TextSize = 12
tornadoBtn.TextColor3 = TEXT
tornadoBtn.Parent = wpPage
Instance.new("UICorner", tornadoBtn).CornerRadius = UDim.new(0, 6)

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0.48, -8, 0, 28)
floatBtn.Position = UDim2.new(0.52, 0, 0, 92)
floatBtn.BackgroundColor3 = OFF
floatBtn.Text = "Float Me: OFF"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 12
floatBtn.TextColor3 = TEXT
floatBtn.Parent = wpPage
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 6)

local wpHint = Instance.new("TextLabel")
wpHint.BackgroundTransparency = 1
wpHint.Size = UDim2.new(1, -28, 0, 30)
wpHint.Position = UDim2.fromOffset(14, 126)
wpHint.Font = Enum.Font.Gotham
wpHint.TextSize = 10
wpHint.TextColor3 = MUTED
wpHint.TextXAlignment = Enum.TextXAlignment.Left
wpHint.TextWrapped = true
wpHint.Text = "Set WP = tornado center. Float Me = parts follow you. Parts auto-claim & lock to you."
wpHint.Parent = wpPage

local function refreshWpStatus()
	if waypointSet and waypointPos then
		wpStatus.Text = string.format("WP: %.0f, %.0f, %.0f", waypointPos.X, waypointPos.Y, waypointPos.Z)
		wpStatus.TextColor3 = ON
	else
		wpStatus.Text = "No waypoint set"
		wpStatus.TextColor3 = MUTED
	end
	refreshTpBtn()
end

local function refreshTornadoBtns()
	tornadoBtn.Text = tornadoEnabled and "Tornado: ON" or "Tornado: OFF"
	tornadoBtn.BackgroundColor3 = tornadoEnabled and ON or OFF
	floatBtn.Text = floatAroundMe and "Float Me: ON" or "Float Me: OFF"
	floatBtn.BackgroundColor3 = floatAroundMe and ON or OFF
end

setWpBtn.MouseButton1Click:Connect(function()
	local r = root()
	if not r then return end
	waypointPos = r.Position
	waypointSet = true
	refreshWpStatus()
end)

clearWpBtn.MouseButton1Click:Connect(function()
	waypointPos = nil
	waypointSet = false
	refreshWpStatus()
end)

radiusBox.FocusLost:Connect(function()
	local n = tonumber(radiusBox.Text)
	if n and n > 0 then
		tornadoRadius = math.clamp(n, 10, 2000)
		radiusBox.Text = tostring(tornadoRadius)
	else
		radiusBox.Text = tostring(tornadoRadius)
	end
end)

local function showMainTab()
	mainPage.Visible = true
	wpPage.Visible = false
	uiPage.Visible = false
	mainTabBtn.BackgroundColor3 = PURPLE
	wpTabBtn.BackgroundColor3 = PANEL
	uiTabBtn.BackgroundColor3 = PANEL
end

local function showWpTab()
	mainPage.Visible = false
	wpPage.Visible = true
	uiPage.Visible = false
	mainTabBtn.BackgroundColor3 = PANEL
	wpTabBtn.BackgroundColor3 = PURPLE
	uiTabBtn.BackgroundColor3 = PANEL
	refreshWpStatus()
	refreshTornadoBtns()
end

local function showUiTab()
	mainPage.Visible = false
	wpPage.Visible = false
	uiPage.Visible = true
	mainTabBtn.BackgroundColor3 = PANEL
	wpTabBtn.BackgroundColor3 = PANEL
	uiTabBtn.BackgroundColor3 = PURPLE
end

mainTabBtn.MouseButton1Click:Connect(showMainTab)
wpTabBtn.MouseButton1Click:Connect(showWpTab)
uiTabBtn.MouseButton1Click:Connect(showUiTab)

local function setOpen(state)
	open = state
	panel.Visible = open
	toggle.Text = open and "Close" or "Open"
	toggle.BackgroundColor3 = open and PURPLE_DIM or PURPLE
end
toggle.MouseButton1Click:Connect(function() setOpen(not open) end)
closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)

-- ===== Emotes panel (catalog + search) =====
local emotePanel = Instance.new("Frame")
emotePanel.Size = UDim2.fromOffset(340, 280)
emotePanel.Position = UDim2.new(1, -360, 0.55, -160)
emotePanel.BackgroundColor3 = BG
emotePanel.Visible = false
emotePanel.Parent = gui
Instance.new("UICorner", emotePanel).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", emotePanel).Color = PURPLE

local eHeader = Instance.new("Frame")
eHeader.Size = UDim2.new(1, 0, 0, 40)
eHeader.BackgroundColor3 = PANEL
eHeader.BorderSizePixel = 0
eHeader.Parent = emotePanel
Instance.new("UICorner", eHeader).CornerRadius = UDim.new(0, 12)
local eHeaderFix = Instance.new("Frame")
eHeaderFix.Size = UDim2.new(1, 0, 0, 12)
eHeaderFix.Position = UDim2.new(0, 0, 1, -12)
eHeaderFix.BackgroundColor3 = PANEL
eHeaderFix.BorderSizePixel = 0
eHeaderFix.Parent = eHeader

local eTitle = Instance.new("TextLabel")
eTitle.BackgroundTransparency = 1
eTitle.Size = UDim2.new(1, -110, 1, 0)
eTitle.Position = UDim2.fromOffset(14, 0)
eTitle.Font = Enum.Font.GothamBold
eTitle.TextSize = 15
eTitle.TextColor3 = PURPLE
eTitle.TextXAlignment = Enum.TextXAlignment.Left
eTitle.Text = "Emotes"
eTitle.Parent = eHeader

local stopEmoteBtn = Instance.new("TextButton")
stopEmoteBtn.Size = UDim2.fromOffset(48, 28)
stopEmoteBtn.Position = UDim2.new(1, -108, 0.5, -14)
stopEmoteBtn.BackgroundColor3 = RED
stopEmoteBtn.Text = "Stop"
stopEmoteBtn.TextSize = 12
stopEmoteBtn.Font = Enum.Font.GothamBold
stopEmoteBtn.TextColor3 = TEXT
stopEmoteBtn.Parent = eHeader
Instance.new("UICorner", stopEmoteBtn).CornerRadius = UDim.new(0, 6)
stopEmoteBtn.MouseButton1Click:Connect(stopEmote)

local eClose = Instance.new("TextButton")
eClose.Size = UDim2.fromOffset(48, 28)
eClose.Position = UDim2.new(1, -56, 0.5, -14)
eClose.BackgroundColor3 = PURPLE_DIM
eClose.Text = "Close"
eClose.TextSize = 12
eClose.Font = Enum.Font.GothamBold
eClose.TextColor3 = TEXT
eClose.Parent = eHeader
Instance.new("UICorner", eClose).CornerRadius = UDim.new(0, 6)

-- tabs: every emote, or only the ones you starred
local emoteTab = "all"
local emoteTabs = {}
local emoteTabBar = Instance.new("Frame")
emoteTabBar.Size = UDim2.new(1, -20, 0, 20)
emoteTabBar.Position = UDim2.fromOffset(10, 44)
emoteTabBar.BackgroundTransparency = 1
emoteTabBar.Parent = emotePanel
for i, def in ipairs({ { key = "all", label = "All" }, { key = "fav", label = "⭐ Favorites" } }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1 / 2, -2, 1, 0)
	b.Position = UDim2.new((i - 1) / 2, 1, 0, 0)
	b.BackgroundColor3 = PANEL
	b.Text = def.label
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.TextColor3 = MUTED
	b.Parent = emoteTabBar
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	emoteTabs[def.key] = b
end
local function refreshEmoteTabs()
	for key, b in pairs(emoteTabs) do
		local on = (emoteTab == key)
		b.BackgroundColor3 = on and PURPLE_DIM or PANEL
		b.TextColor3 = on and TEXT or MUTED
	end
end
refreshEmoteTabs()

-- star favorites, kept in the executor workspace when it can write files
local EMOTE_FAV_FILE = "solochat_emote_favorites.json"
local EMOTE_FAV = {}
local function emoteJson()
	local ok, service = pcall(function() return game:GetService("HttpService") end)
	if ok then return service end
	return nil
end
local function loadEmoteFavs()
	local data = nil
	pcall(function()
		if not (isfile and readfile and isfile(EMOTE_FAV_FILE)) then return end
		local json = emoteJson()
		if json then data = json:JSONDecode(readfile(EMOTE_FAV_FILE)) end
	end)
	if type(data) ~= "table" then return end
	for _, id in ipairs(data) do EMOTE_FAV[tostring(id)] = true end
end
local function saveEmoteFavs()
	pcall(function()
		if not writefile then return end
		local json = emoteJson()
		if not json then return end
		local ids = {}
		for id in pairs(EMOTE_FAV) do ids[#ids + 1] = tonumber(id) or id end
		writefile(EMOTE_FAV_FILE, json:JSONEncode(ids))
	end)
end
loadEmoteFavs()

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -20, 0, 26)
search.Position = UDim2.fromOffset(10, 68)
search.BackgroundColor3 = PANEL
search.TextColor3 = TEXT
search.PlaceholderColor3 = MUTED
search.PlaceholderText = "Search emotes..."
search.Font = Enum.Font.Gotham
search.TextSize = 13
search.Text = ""
search.ClearTextOnFocus = false
search.Parent = emotePanel
Instance.new("UICorner", search).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -106)
scroll.Position = UDim2.fromOffset(8, 100)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = PURPLE
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = emotePanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local function rebuildEmoteList(filter)
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") or c:IsA("Frame") or c:IsA("TextLabel") then
			c:Destroy()
		end
	end
	filter = string.lower(filter or "")
	local shown = 0
	for _, em in ipairs(EMOTES) do
		local emRef = em
		local key = tostring(emRef.id)
		local fav = EMOTE_FAV[key] == true
		local nameMatch = (filter == "" or string.find(string.lower(emRef.name), filter, 1, true) ~= nil)
		if nameMatch and (emoteTab == "all" or fav) then
			shown = shown + 1
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, -4, 0, 32)
			row.BackgroundColor3 = PANEL
			row.Parent = scroll
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -34, 1, 0)
			b.BackgroundTransparency = 1
			b.TextColor3 = TEXT
			b.Font = Enum.Font.Gotham
			b.TextSize = 12
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.Text = (emRef.kind == "r6" and "  [R6] " or "  ") .. emRef.name
			b.Parent = row
			b.MouseButton1Click:Connect(function()
				local isR6 = (emRef.kind == "r6")
				playEmote(emRef.id, {
					speed = emRef.speed or 1,
					loop = (emRef.loop ~= false),
					timePos = emRef.timePos or 0,
					priority = isR6 and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Action4,
				})
			end)

			local star = Instance.new("TextButton")
			star.Size = UDim2.fromOffset(30, 32)
			star.Position = UDim2.new(1, -32, 0, 0)
			star.BackgroundColor3 = fav and PURPLE_DIM or BG
			star.Text = "⭐"
			star.TextSize = 13
			star.Font = Enum.Font.GothamBold
			star.TextColor3 = TEXT
			star.Parent = row
			Instance.new("UICorner", star).CornerRadius = UDim.new(0, 6)
			star.MouseButton1Click:Connect(function()
				if EMOTE_FAV[key] then
					EMOTE_FAV[key] = nil
				else
					EMOTE_FAV[key] = true
				end
				saveEmoteFavs()
				rebuildEmoteList(search.Text)
			end)
		end
	end
	if shown == 0 then
		local hint = Instance.new("TextLabel")
		hint.Size = UDim2.new(1, -8, 0, 44)
		hint.BackgroundTransparency = 1
		hint.Font = Enum.Font.Gotham
		hint.TextSize = 12
		hint.TextColor3 = MUTED
		hint.TextWrapped = true
		hint.Text = (emoteTab == "fav")
			and "No favorite emotes yet - tap ⭐ on any emote to save it here."
			or "Nothing matches that search."
		hint.Parent = scroll
	end
	task.defer(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
	end)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)
local function emoteHeaderText()
	eTitle.Text = (EMOTE_SRC.loaded > 0) and ("Emotes  " .. EMOTE_SRC.loaded) or "Emotes"
	search.PlaceholderText = EMOTE_SRC.error and ("emotes.json: " .. EMOTE_SRC.error) or "Search emotes..."
end
rebuildEmoteList("")
emoteHeaderText()
search:GetPropertyChangedSignal("Text"):Connect(function()
	rebuildEmoteList(search.Text)
end)
for key, b in pairs(emoteTabs) do
	b.MouseButton1Click:Connect(function()
		emoteTab = key
		refreshEmoteTabs()
		rebuildEmoteList(search.Text)
	end)
end

local function setEmotesOpen(state)
	emotesOpen = state
	emotePanel.Visible = emotesOpen
	emotesBtn.BackgroundColor3 = emotesOpen and PURPLE_DIM or PURPLE
end
emotesBtn.MouseButton1Click:Connect(function()
	local willOpen = not emotesOpen
	if willOpen then
		-- re-read so edits to emotes.json show up without re-executing the script
		EMOTE_SRC.load()
		rebuildEmoteList(search.Text)
		emoteHeaderText()
	end
	setEmotesOpen(willOpen)
end)
eClose.MouseButton1Click:Connect(function()
	setEmotesOpen(false)
end)

-- ===== Players panel: list → actions (two-step) =====
local plrPanel = Instance.new("Frame")
plrPanel.Size = UDim2.fromOffset(340, 280)
plrPanel.Position = UDim2.new(1, -360, 0.55, -160)
plrPanel.BackgroundColor3 = BG
plrPanel.Visible = false
plrPanel.Parent = gui
Instance.new("UICorner", plrPanel).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", plrPanel).Color = PURPLE

local pHeader = Instance.new("Frame")
pHeader.Size = UDim2.new(1, 0, 0, 40)
pHeader.BackgroundColor3 = PANEL
pHeader.BorderSizePixel = 0
pHeader.Parent = plrPanel
Instance.new("UICorner", pHeader).CornerRadius = UDim.new(0, 12)
local pHeaderFix = Instance.new("Frame")
pHeaderFix.Size = UDim2.new(1, 0, 0, 12)
pHeaderFix.Position = UDim2.new(0, 0, 1, -12)
pHeaderFix.BackgroundColor3 = PANEL
pHeaderFix.BorderSizePixel = 0
pHeaderFix.Parent = pHeader

local pTitle = Instance.new("TextLabel")
pTitle.BackgroundTransparency = 1
pTitle.Size = UDim2.new(1, -60, 1, 0)
pTitle.Position = UDim2.fromOffset(14, 0)
pTitle.Font = Enum.Font.GothamBold
pTitle.TextSize = 15
pTitle.TextColor3 = PURPLE
pTitle.TextXAlignment = Enum.TextXAlignment.Left
pTitle.Text = "Players"
pTitle.Parent = pHeader

local pClose = Instance.new("TextButton")
pClose.Size = UDim2.fromOffset(48, 28)
pClose.Position = UDim2.new(1, -56, 0.5, -14)
pClose.BackgroundColor3 = PURPLE_DIM
pClose.Text = "Close"
pClose.TextSize = 12
pClose.Font = Enum.Font.GothamBold
pClose.TextColor3 = TEXT
pClose.Parent = pHeader
Instance.new("UICorner", pClose).CornerRadius = UDim.new(0, 6)

-- PAGE 1: player list
local listPage = Instance.new("Frame")
listPage.Size = UDim2.new(1, 0, 1, -40)
listPage.Position = UDim2.fromOffset(0, 40)
listPage.BackgroundTransparency = 1
listPage.Parent = plrPanel

local plrSearch = Instance.new("TextBox")
plrSearch.Size = UDim2.new(1, -20, 0, 30)
plrSearch.Position = UDim2.fromOffset(10, 8)
plrSearch.BackgroundColor3 = PANEL
plrSearch.TextColor3 = TEXT
plrSearch.PlaceholderColor3 = MUTED
plrSearch.PlaceholderText = "Search players..."
plrSearch.Font = Enum.Font.Gotham
plrSearch.TextSize = 13
plrSearch.Text = ""
plrSearch.ClearTextOnFocus = false
plrSearch.Parent = listPage
Instance.new("UICorner", plrSearch).CornerRadius = UDim.new(0, 8)

local plrScroll = Instance.new("ScrollingFrame")
plrScroll.Size = UDim2.new(1, -16, 1, -48)
plrScroll.Position = UDim2.fromOffset(8, 44)
plrScroll.BackgroundTransparency = 1
plrScroll.BorderSizePixel = 0
plrScroll.ScrollBarThickness = 4
plrScroll.ScrollBarImageColor3 = PURPLE
plrScroll.Parent = listPage
local plrLayout = Instance.new("UIListLayout")
plrLayout.Padding = UDim.new(0, 4)
plrLayout.Parent = plrScroll

-- PAGE 2: actions for selected player
local actPage = Instance.new("Frame")
actPage.Size = UDim2.new(1, 0, 1, -40)
actPage.Position = UDim2.fromOffset(0, 40)
actPage.BackgroundTransparency = 1
actPage.Visible = false
actPage.Parent = plrPanel

local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.fromOffset(70, 28)
backBtn.Position = UDim2.fromOffset(10, 8)
backBtn.BackgroundColor3 = PURPLE_DIM
backBtn.Text = "← Back"
backBtn.TextSize = 12
backBtn.Font = Enum.Font.GothamBold
backBtn.TextColor3 = TEXT
backBtn.Parent = actPage
Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0, 6)

local selectedLbl = Instance.new("TextLabel")
selectedLbl.BackgroundTransparency = 1
selectedLbl.Size = UDim2.new(1, -90, 0, 28)
selectedLbl.Position = UDim2.fromOffset(88, 8)
selectedLbl.Font = Enum.Font.GothamMedium
selectedLbl.TextSize = 12
selectedLbl.TextColor3 = ON
selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
selectedLbl.Text = ""
selectedLbl.Parent = actPage

local actHint = Instance.new("TextLabel")
actHint.BackgroundTransparency = 1
actHint.Size = UDim2.new(1, -20, 0, 18)
actHint.Position = UDim2.fromOffset(10, 42)
actHint.Font = Enum.Font.Gotham
actHint.TextSize = 11
actHint.TextColor3 = MUTED
actHint.TextXAlignment = Enum.TextXAlignment.Left
actHint.Text = "Tap again to toggle off · stack multiple"
actHint.Parent = actPage

local actScroll = Instance.new("ScrollingFrame")
actScroll.Size = UDim2.new(1, -16, 1, -120)
actScroll.Position = UDim2.fromOffset(8, 64)
actScroll.BackgroundTransparency = 1
actScroll.BorderSizePixel = 0
actScroll.ScrollBarThickness = 4
actScroll.ScrollBarImageColor3 = PURPLE
actScroll.Parent = actPage
local actLayout = Instance.new("UIListLayout")
actLayout.Padding = UDim.new(0, 6)
actLayout.Parent = actScroll

local stopTrollBtn = Instance.new("TextButton")
stopTrollBtn.Size = UDim2.new(1, -20, 0, 34)
stopTrollBtn.Position = UDim2.new(0, 10, 1, -44)
stopTrollBtn.BackgroundColor3 = RED
stopTrollBtn.Text = "Stop All Trolls"
stopTrollBtn.Font = Enum.Font.GothamBold
stopTrollBtn.TextSize = 13
stopTrollBtn.TextColor3 = TEXT
stopTrollBtn.Parent = actPage
Instance.new("UICorner", stopTrollBtn).CornerRadius = UDim.new(0, 8)
stopTrollBtn.MouseButton1Click:Connect(function()
	stopTroll(nil)
	refreshActionButtons()
end)

local actionButtons = {} -- mode -> button for highlight

local function showListPage()
	listPage.Visible = true
	actPage.Visible = false
	pTitle.Text = "Players"
end

local function showActPage()
	listPage.Visible = false
	actPage.Visible = true
	pTitle.Text = "Actions"
	if selectedPlayer and selectedPlayer.Parent then
		selectedLbl.Text = "@" .. selectedPlayer.Name
	else
		selectedLbl.Text = "none"
	end
	refreshActionButtons()
end

function refreshActionButtons()
	for mode, b in pairs(actionButtons) do
		if activeTrolls[mode] then
			b.BackgroundColor3 = ON
			b.Text = "● " .. (b:GetAttribute("BaseName") or mode)
		else
			b.BackgroundColor3 = PANEL
			b.Text = b:GetAttribute("BaseName") or mode
		end
	end
end

local function rebuildPlayers(filter)
	for _, c in ipairs(plrScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	filter = string.lower(filter or "")
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local label = plr.DisplayName .. "  (@" .. plr.Name .. ")"
			if filter == "" or string.find(string.lower(label), filter, 1, true) then
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, -4, 0, 34)
				b.BackgroundColor3 = PANEL
				b.TextColor3 = TEXT
				b.Font = Enum.Font.Gotham
				b.TextSize = 13
				b.TextXAlignment = Enum.TextXAlignment.Left
				b.Text = "  " .. label
				b.Parent = plrScroll
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
				local ref = plr
				b.MouseButton1Click:Connect(function()
					selectedPlayer = ref
					showActPage()
				end)
			end
		end
	end
	task.defer(function()
		plrScroll.CanvasSize = UDim2.new(0, 0, 0, plrLayout.AbsoluteContentSize.Y + 8)
	end)
end
plrLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	plrScroll.CanvasSize = UDim2.new(0, 0, 0, plrLayout.AbsoluteContentSize.Y + 8)
end)

for _, act in ipairs(TROLL_ACTIONS) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 36)
	b.BackgroundColor3 = PANEL
	b.TextColor3 = TEXT
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = act.name
	b:SetAttribute("BaseName", act.name)
	b.Parent = actScroll
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	local mode, id = act.mode, act.id
	actionButtons[mode] = b
	b.MouseButton1Click:Connect(function()
		if not selectedPlayer or not selectedPlayer.Parent then
			showListPage()
			return
		end
		startTroll(mode, id)
		refreshActionButtons()
	end)
end
task.defer(function()
	actScroll.CanvasSize = UDim2.new(0, 0, 0, actLayout.AbsoluteContentSize.Y + 8)
end)
actLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	actScroll.CanvasSize = UDim2.new(0, 0, 0, actLayout.AbsoluteContentSize.Y + 8)
end)

backBtn.MouseButton1Click:Connect(function()
	-- keep trolls running when going back; only change UI
	showListPage()
	rebuildPlayers(plrSearch.Text)
end)

plrSearch:GetPropertyChangedSignal("Text"):Connect(function()
	rebuildPlayers(plrSearch.Text)
end)

local function setPlayersOpen(state)
	playersOpen = state
	plrPanel.Visible = playersOpen
	playersBtn.BackgroundColor3 = playersOpen and PURPLE_DIM or PURPLE
	if playersOpen then
		showListPage()
		rebuildPlayers(plrSearch.Text)
	end
end
playersBtn.MouseButton1Click:Connect(function()
	setPlayersOpen(not playersOpen)
end)
pClose.MouseButton1Click:Connect(function()
	setPlayersOpen(false)
end)

Players.PlayerAdded:Connect(function()
	if playersOpen and listPage.Visible then rebuildPlayers(plrSearch.Text) end
end)
Players.PlayerRemoving:Connect(function(plr)
	if selectedPlayer == plr then
		stopTroll(nil)
		selectedPlayer = nil
		if playersOpen then showListPage() end
	end
	if playersOpen and listPage.Visible then rebuildPlayers(plrSearch.Text) end
end)

-- drag helpers
local function makeDraggable(handle, frame)
	local dragging, start, pos
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, start, pos = true, i.Position, frame.Position
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
		end
	end)
end
makeDraggable(header, panel)
makeDraggable(eHeader, emotePanel)
makeDraggable(pHeader, plrPanel)


-- ============================================================
-- NETWORK PART CLAIM (lock parts to local player)
-- ============================================================
-- Version stamped so re-running the script never stacks ownership loops from
-- an older copy. Stacked loops were fighting each other and dragging the local
-- character around, which is why the player used to slide on its own.
local TORN = {}

-- True when the part is (or is welded into) a character: the avatar's own
-- body, an accessory, a held tool, or any prop welded onto one. Driving such
-- a part drags the player around with it, so every claim/drive path checks
-- this first.
TORN.AssemblyInCharacter = function(part, char)
	local ok, rootPart = pcall(function() return part.AssemblyRootPart end)
	if not ok or typeof(rootPart) ~= "Instance" then rootPart = part end
	local function under(playerChar)
		if not playerChar then return false end
		if part:IsDescendantOf(playerChar) then return true end
		if rootPart ~= part and rootPart:IsDescendantOf(playerChar) then return true end
		return false
	end
	if under(char) then return true end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and under(plr.Character) then return true end
	end
	return false
end

-- Map-wide reach comes from the simulation radius alone. player.ReplicationFocus
-- is never pointed away from the character any more: that takes the avatar out
-- of the region this client is allowed to simulate, and the client/server fight
-- over it is what flung the character upwards and moved it on its own. The
-- radius is restored when the tornado stops, so the client goes back to normal
-- physics instead of simulating the whole map forever.
TORN.savedRange = nil
TORN.applyRange = function(on)
	if on then
		if not TORN.savedRange then
			local saved = {}
			pcall(function() saved.sim = getproperties(player).SimulationRadius end)
			pcall(function() saved.max = getproperties(player).MaximumSimulationRadius end)
			TORN.savedRange = saved
		end
		pcall(function() sethiddenproperty(player, "SimulationRadius", math.huge) end)
		pcall(function() sethiddenproperty(player, "MaximumSimulationRadius", math.huge) end)
	else
		local saved = TORN.savedRange or {}
		pcall(function() sethiddenproperty(player, "SimulationRadius", saved.sim or 1024) end)
		pcall(function() sethiddenproperty(player, "MaximumSimulationRadius", saved.max or 3000) end)
		TORN.savedRange = nil
	end
end

TORN.version = 4
if not getgenv().Network or getgenv().Network.Version ~= TORN.version then
	if getgenv().Network and getgenv().Network.Conn then
		pcall(function() getgenv().Network.Conn:Disconnect() end)
	end
	getgenv().Network = {
		Version = TORN.version,
		Parts = {},
		Orig = {},
		Velocity = Vector3.zero,
		Conn = nil,
	}
	Network.BaseParts = Network.Parts
	Network.Orig = Network.Orig or {}
	-- Every part we touch for the tornado becomes non-solid and non-touchable,
	-- which is what stops the funnel from body-blocking or touch-damaging other
	-- players. The original flags are remembered here and put back on stop, so
	-- turning the tornado off never leaves the map see-through.
	Network.RetainPart = function(part)
		if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(workspace) then
			if not Network.Orig[part] then
				local ok, touch = pcall(function() return part.CanTouch end)
				Network.Orig[part] = { collide = part.CanCollide, touch = ok and touch or nil }
			end
			Network.Parts[part] = true
			part.CanCollide = false
			pcall(function() part.CanTouch = false end)
		end
	end
	local function keepOwnership()
		if not tornadoEnabled then return end
		TORN.applyRange(true)
		local char = player.Character
		for part in pairs(Network.Parts) do
			if not part or not part.Parent or not part:IsDescendantOf(workspace) then
				Network.Parts[part] = nil
			elseif TORN.AssemblyInCharacter(part, char) then
				-- welded into an avatar: never hold it still for them
				Network.Parts[part] = nil
			elseif not claimedParts[part] then
				-- Parts the tornado is not driving are held still with a zero
				-- velocity. The old constant drift velocity is what made them
				-- sail off into the distance on their own.
				pcall(function() part.AssemblyLinearVelocity = Network.Velocity end)
			end
		end
	end
	Network.Conn = RunService.Heartbeat:Connect(keepOwnership)
end

-- ============================================================
-- TORNADO SYSTEM
-- ============================================================
TORN.claimInterval = 0.75 -- seconds between full map re-scans
TORN.ownerCheck = 0.5 -- how often each part re-checks its network owner
TORN.grace = 2.0 -- seconds a part may stay server-owned before we drive it anyway

TORN.stats = { found = 0, grabbed = 0, waiting = 0 }

-- small custom notification (no layout changes to the existing panel).
-- Auto-sized and wrapped: errors used to spill out of the fixed 340x30 strip
-- and hang over the left edge, which is what made the pill look broken.
TORN.toast = Instance.new("TextLabel")
TORN.toast.AnchorPoint = Vector2.new(0.5, 0)
TORN.toast.Position = UDim2.new(0.5, 0, 0, 78)
TORN.toast.Size = UDim2.fromOffset(0, 0)
TORN.toast.AutomaticSize = Enum.AutomaticSize.XY
TORN.toast.BackgroundColor3 = PANEL
TORN.toast.BackgroundTransparency = 0.05
TORN.toast.TextColor3 = TEXT
TORN.toast.TextSize = 12
TORN.toast.TextWrapped = true
TORN.toast.TextXAlignment = Enum.TextXAlignment.Center
TORN.toast.TextYAlignment = Enum.TextYAlignment.Center
TORN.toast.RichText = false
TORN.toast.Text = ""
TORN.toast.Visible = false
TORN.toast.ZIndex = 60
TORN.toast.Parent = gui
TORN.toast.Font = Enum.Font.GothamBold
Instance.new("UICorner", TORN.toast).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", TORN.toast).Color = PURPLE
TORN.toastPad = Instance.new("UIPadding", TORN.toast)
TORN.toastPad.PaddingLeft = UDim.new(0, 14)
TORN.toastPad.PaddingRight = UDim.new(0, 14)
TORN.toastPad.PaddingTop = UDim.new(0, 8)
TORN.toastPad.PaddingBottom = UDim.new(0, 8)
TORN.toastLimit = Instance.new("UISizeConstraint", TORN.toast)
TORN.toastLimit.MaxSize = Vector2.new(430, 120)

TORN.toastToken = 0
local function showToast(text, duration)
	TORN.toastToken = TORN.toastToken + 1
	local myToken = TORN.toastToken
	if #text > 170 then text = text:sub(1, 167) .. "..." end
	TORN.toast.Text = text
	TORN.toast.Visible = true
	task.delay(duration or 3, function()
		if TORN.toastToken == myToken then
			TORN.toast.Visible = false
		end
	end)
end

local function isCharacterPart(part)
	for _, plr in ipairs(Players:GetPlayers()) do
		local ch = plr.Character
		if ch and part:IsDescendantOf(ch) then return true end
	end
	local node = part.Parent
	while node and node ~= workspace do
		if node:IsA("Humanoid") then return true end
		if node:IsA("Model") and node:FindFirstChildOfClass("Humanoid") then return true end
		node = node.Parent
	end
	return false
end

local function isClaimable(part)
	if not part or not part:IsA("BasePart") then return false end
	if part.Anchored then return false end
	if not part:IsDescendantOf(workspace) then return false end
	if part.Name == "Handle" or part.Name == "HumanoidRootPart" then return false end
	local par = part.Parent
	if not par then return false end
	if par:FindFirstChildOfClass("Humanoid") or par:FindFirstChild("Head") then return false end
	if isCharacterPart(part) then return false end
	-- anything welded into a character (accessory, tool, held prop) must never
	-- be driven: moving it moves the avatar with it
	if TORN.AssemblyInCharacter(part, player.Character) then return false end
	if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end
	return true
end

-- true / false when the owner is known, nil when the executor will not tell
-- us (then the part is driven anyway, otherwise nothing would ever move).
local function networkOwnerIsUs(part)
	local ok, owner = pcall(function() return part:GetNetworkOwner() end)
	if not ok then return nil end
	if owner == nil then return nil end
	return owner == player
end

local function makePartState(part)
	return {
		ring = 0.4 + math.random() * 0.6, -- where on the funnel it rides
		h = math.random(), -- 0 = bottom of the funnel, 1 = top
		angle = math.random() * math.pi * 2,
		owned = false,
		blocked = false,
		claimedAt = os.clock(),
		ownerCheck = 0,
		origCollide = part.CanCollide,
		origTouch = (function()
			local ok, touch = pcall(function() return part.CanTouch end)
			return ok and touch or nil
		end)(),
	}
end

local function claimPart(part)
	if not isClaimable(part) then return end
	if claimedParts[part] then return end
	for _, x in ipairs(part:GetChildren()) do
		if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro")
			or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity")
			or x:IsA("RocketPropulsion") or x:IsA("AlignPosition") or x:IsA("AlignOrientation")
			or x:IsA("Torque") then
			pcall(function() x:Destroy() end)
		end
	end
	part.CanCollide = false
	pcall(function() part.CanTouch = false end)
	pcall(function()
		part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	end)
	if Network and Network.RetainPart then
		Network.RetainPart(part)
	end
	claimedParts[part] = makePartState(part)
end

local function scanAndClaim()
	local found = 0
	for _, inst in ipairs(workspace:GetDescendants()) do
		if inst:IsA("BasePart") and not inst.Anchored then
			found = found + 1
			claimPart(inst)
		end
	end
	TORN.stats.found = found
end

local function getTornadoCenter()
	if floatAroundMe then
		local r = root()
		if r then return r.Position end
	end
	if waypointSet and waypointPos then
		return waypointPos
	end
	return nil
end

TORN.accum = 0
local function updateStatsLabel()
	local g = TORN.stats.grabbed
	local w = TORN.stats.waiting
	if w > 0 then
		wpHint.Text = string.format("🌪 %d parts spinning · %d waiting for ownership", g, w)
		wpHint.TextColor3 = MUTED
	else
		wpHint.Text = string.format("🌪 %d parts spinning · %d studs/s", g, math.floor(tornadoRotSpeed))
		wpHint.TextColor3 = ON
	end
end

local function stepTornado(dt)
	local center = getTornadoCenter()
	if not center then return end
	dt = math.clamp(dt, 1 / 240, 1 / 15)

	local baseR = math.max(tornadoRadius, 8)
	local height = math.max(tornadoHeight, 10)
	local spin = math.max(tornadoRotSpeed, 0) -- studs per second along the ring
	local pull = math.max(tornadoAttract, 1) -- studs per second while closing in

	local grabbed, waiting, found = 0, 0, 0
	local now = os.clock()

	for part, st in pairs(claimedParts) do
		if not part or not part.Parent or part.Anchored or not part:IsDescendantOf(workspace) then
			claimedParts[part] = nil
		elseif TORN.AssemblyInCharacter(part, player.Character) then
			-- got welded onto an avatar after being claimed: release it at once
			claimedParts[part] = nil
		else
			found = found + 1

			if now - st.ownerCheck > TORN.ownerCheck then
				st.ownerCheck = now
				local mine = networkOwnerIsUs(part)
				if mine == false then
					-- another player is simulating it: touching it would only
					-- rubber-band, so leave it be and report it as waiting
					st.owned = false
					st.blocked = true
				else
					st.blocked = false
					st.owned = (mine == true) or (now - st.claimedAt > TORN.grace)
				end
			end

			if not st.owned then
				waiting = waiting + 1
				part.CanCollide = false
				if Network and Network.RetainPart and not st.blocked then
					Network.RetainPart(part)
				end
			else
				grabbed = grabbed + 1
				local pos = part.Position

				-- funnel: wide at the bottom, narrow at the top
				local ringR = math.max(baseR * (1 - 0.72 * st.h) * st.ring, 5)
				local omega = spin / ringR -- rad/s so the linear speed stays constant
				local angle = st.angle + omega * dt
				st.angle = angle

				local target = Vector3.new(
					center.X + math.cos(angle) * ringR,
					center.Y + height * (0.1 + 0.9 * st.h),
					center.Z + math.sin(angle) * ringR
				)

				local delta = target - pos
				local dist = delta.Magnitude
				local maxStep = pull * dt
				if dist > 1e-4 then
					-- never move further than `maxStep` in one frame: that is
					-- what stops parts overshooting and flying off
					if dist > maxStep then delta = delta.Unit * maxStep end
					part.AssemblyLinearVelocity = delta / dt
				else
					part.AssemblyLinearVelocity = Vector3.zero
				end
				part.CanCollide = false
				pcall(function() part.CanTouch = false end)
			end
		end
	end

	TORN.stats.grabbed = grabbed
	TORN.stats.waiting = waiting
	if found > 0 then TORN.stats.found = found end

	TORN.accum = TORN.accum + dt
	if TORN.accum >= 0.25 then
		TORN.accum = 0
		updateStatsLabel()
	end
end

local function startTornado()
	if tornadoEnabled then return end
	if not waypointSet or not waypointPos then
		local r = root()
		if r then
			waypointPos = r.Position
			waypointSet = true
			refreshWpStatus()
		end
	end
	if not getTornadoCenter() then
		wpStatus.Text = "Set a waypoint first"
		wpStatus.TextColor3 = RED
		return
	end

	tornadoEnabled = true
	refreshTornadoBtns()
	pcall(scanAndClaim)
	showToast(string.format("🌪 Tornado ON — %d parts found, claiming map-wide…", TORN.stats.found), 3)

	task.spawn(function()
		while tornadoEnabled do
			pcall(scanAndClaim)
			task.wait(TORN.claimInterval)
		end
	end)

	if TORN.addConn then pcall(function() TORN.addConn:Disconnect() end) end
	TORN.addConn = workspace.DescendantAdded:Connect(function(inst)
		if tornadoEnabled and inst:IsA("BasePart") then
			task.defer(function()
				if tornadoEnabled then claimPart(inst) end
			end)
		end
	end)

	local last = os.clock()
	local toastAccum = 0
	if tornadoConn then pcall(function() tornadoConn:Disconnect() end) end
	tornadoConn = RunService.Heartbeat:Connect(function()
		if not tornadoEnabled then return end
		local now = os.clock()
		local dt = now - last
		last = now
		stepTornado(dt)
		toastAccum = toastAccum + dt
		if toastAccum >= 6 then
			toastAccum = 0
			showToast(string.format("🌪 %d captured · %d waiting for ownership", TORN.stats.grabbed, TORN.stats.waiting), 2.5)
		end
	end)
end

local function stopTornado()
	tornadoEnabled = false
	if tornadoConn then
		tornadoConn:Disconnect()
		tornadoConn = nil
	end
	if TORN.addConn then
		TORN.addConn:Disconnect()
		TORN.addConn = nil
	end
	for part, st in pairs(claimedParts) do
		claimedParts[part] = nil
		if part and part.Parent then
			pcall(function() part.AssemblyLinearVelocity = Vector3.zero end)
			if st and st.origCollide ~= nil then
				pcall(function() part.CanCollide = st.origCollide end)
			end
			if st and st.origTouch ~= nil then
				pcall(function() part.CanTouch = st.origTouch end)
			end
		end
	end
	if Network and Network.Parts then
		for part in pairs(Network.Parts) do
			Network.Parts[part] = nil
			local orig = Network.Orig and Network.Orig[part]
			if orig then
				pcall(function() part.CanCollide = orig.collide end)
				if orig.touch ~= nil then
					pcall(function() part.CanTouch = orig.touch end)
				end
				Network.Orig[part] = nil
			end
		end
	end
	TORN.applyRange(false)
	pcall(function() player.ReplicationFocus = nil end)
	wpHint.Text = "Set WP = tornado center. Float Me = parts follow you. Parts auto-claim & lock to you."
	wpHint.TextColor3 = MUTED
	showToast(string.format("🌪 Tornado off — %d parts released", TORN.stats.grabbed), 2.5)
	refreshTornadoBtns()
end

tornadoBtn.MouseButton1Click:Connect(function()
	if tornadoEnabled then
		stopTornado()
	else
		startTornado()
	end
end)

floatBtn.MouseButton1Click:Connect(function()
	floatAroundMe = not floatAroundMe
	refreshTornadoBtns()
end)
-- ============================================================
-- UI PAGE: show/hide side buttons
-- ============================================================
local uiHint = Instance.new("TextLabel")
uiHint.BackgroundTransparency = 1
uiHint.Size = UDim2.new(1, -28, 0, 18)
uiHint.Position = UDim2.fromOffset(14, 6)
uiHint.Font = Enum.Font.Gotham
uiHint.TextSize = 11
uiHint.TextColor3 = MUTED
uiHint.TextXAlignment = Enum.TextXAlignment.Left
uiHint.Text = "Show / hide side buttons"
uiHint.Parent = uiPage

local function makeUiToggle(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -28, 0, 34)
	b.Position = UDim2.fromOffset(14, y)
	b.BackgroundColor3 = ON
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.TextColor3 = TEXT
	b.Parent = uiPage
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local flyToggleBtn = makeUiToggle("Fly Button: ON", 30)
local emotesToggleBtn = makeUiToggle("Emotes Button: ON", 70)
local playersToggleBtn = makeUiToggle("Players Button: ON", 110)

local function refreshUiToggles()
	flyToggleBtn.Text = showFlyBtn and "Fly Button: ON" or "Fly Button: OFF"
	flyToggleBtn.BackgroundColor3 = showFlyBtn and ON or OFF
	flyBtn.Visible = showFlyBtn

	emotesToggleBtn.Text = showEmotesBtn and "Emotes Button: ON" or "Emotes Button: OFF"
	emotesToggleBtn.BackgroundColor3 = showEmotesBtn and ON or OFF
	emotesBtn.Visible = showEmotesBtn

	playersToggleBtn.Text = showPlayersBtn and "Players Button: ON" or "Players Button: OFF"
	playersToggleBtn.BackgroundColor3 = showPlayersBtn and ON or OFF
	playersBtn.Visible = showPlayersBtn
end

flyToggleBtn.MouseButton1Click:Connect(function()
	showFlyBtn = not showFlyBtn
	refreshUiToggles()
end)

emotesToggleBtn.MouseButton1Click:Connect(function()
	showEmotesBtn = not showEmotesBtn
	if not showEmotesBtn then
		emotesOpen = false
		emotePanel.Visible = false
		emotesBtn.BackgroundColor3 = PURPLE
	end
	refreshUiToggles()
end)

playersToggleBtn.MouseButton1Click:Connect(function()
	showPlayersBtn = not showPlayersBtn
	if not showPlayersBtn then
		playersOpen = false
		plrPanel.Visible = false
		playersBtn.BackgroundColor3 = PURPLE
	end
	refreshUiToggles()
end)

-- ============================================================
-- CHAT + TRANSLATION (openrouter/free)
--
-- Request budget, by design. Every OpenRouter call is triggered by you:
--   🌐 on one message ....... 1 request (identifies the language AND translates)
--   ↩️ reply, then send ..... 1 request (translates your text into their language)
--   "Speak in: X", then send  1 request (translates your text into X)
-- Receiving chat, tagging a line, echo handling, de-duplication: 0 requests.
-- A second 🌐 click only flips original <-> translation, so that is 0 requests.
-- Nothing auto-translates in the background any more.
-- ============================================================
--[[ CHAT_CORE_BEGIN ]]
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

local CHAT = {
	messages = {},
	nextId = 0,
	replyTarget = nil,
	speakLang = "auto", -- "auto" = send as typed, or match the message being replied to
	sending = false,
	apiRequests = 0, -- diagnostics: how many OpenRouter calls this session made
	pendingEcho = {}, -- signature -> local row waiting for its own echo
	seen = {}, -- signature -> clock, kills duplicate listeners
	tab = "all", -- "all" | "global" | "friends"
	friendIds = {}, -- [userId] = true, filled by CHAT.refreshFriends
	friendsLoaded = false,
	friendsAt = 0,
	notify = function() end,
	onNew = function() end,
	onUpdate = function() end,
	onState = function() end,
}

local function trim(s)
	return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- ------------------------------------------------------------------
-- HTTP + OpenRouter
-- ------------------------------------------------------------------
local API = {
	lastError = nil,
	warned = {},
	maxKeys = 5, -- hard cap on keys in rotation
	maxAttempts = 8, -- hard cap on HTTP tries inside one logical call
	-- openrouter/free auto-picks a model; the rest are only tried when the
	-- previous call actually failed, so a working call is always one request.
	models = { OPENROUTER_MODEL, "google/gemma-4-26b-a4b-it:free", "liquid/lfm-2.5-2.6b:free" },
	cooling = {}, -- key -> { readyAt = clock, status = http status }
	lastGoodKey = nil,
}

local function httpRequest(opts)
	CHAT.apiRequests = CHAT.apiRequests + 1
	local ok, res = pcall(function()
		if syn and syn.request then return syn.request(opts) end
		if http and http.request then return http.request(opts) end
		if request then return request(opts) end
		if http_request then return http_request(opts) end
		error("No HTTP request function available")
	end)
	if ok then return res end
	return nil
end

function API.errorFor(status, body)
	if status == 401 then
		return "OpenRouter key rejected (401) - fix it with getgenv().OPENROUTER_KEYS"
	end
	if status == 402 then return "that OpenRouter key is out of credits (402)" end
	if status == 429 then return "every OpenRouter key is rate limited (429)" end
	if status == 404 then return "OpenRouter: no provider for that model (404)" end
	local msg = body and tostring(body):match('"message"%s*:%s*"([^"]+)"')
	return "OpenRouter HTTP " .. tostring(status) .. (msg and (": " .. msg) or "")
end

function API.report(text)
	if not text or text == "" then return end
	API.lastError = text
	if API.warned[text] then return end
	API.warned[text] = true
	CHAT.notify(utf8.char(9888) .. " " .. text)
end

-- ------------------------------------------------------------------
-- Keys: up to 5, tried in order, only a failure moves to the next one
-- ------------------------------------------------------------------
-- Rebuilt on every call, so a key added at runtime is picked up immediately.
function API.keys()
	local list, seen = {}, {}
	local function add(k)
		if type(k) ~= "string" then return end
		k = (k:gsub("%s+", ""))
		if k == "" or seen[k] or #list >= API.maxKeys then return end
		seen[k] = true
		list[#list + 1] = k
	end
	local genv = nil
	pcall(function()
		if type(getgenv) == "function" then genv = getgenv() end
	end)
	if type(genv) == "table" then
		if type(genv.OPENROUTER_KEYS) == "table" then
			for _, k in ipairs(genv.OPENROUTER_KEYS) do add(k) end
		end
		add(genv.OPENROUTER_KEY)
	end
	if type(OPENROUTER_KEYS) == "table" then
		for _, k in ipairs(OPENROUTER_KEYS) do add(k) end
	end
	if type(OPENROUTER_FILE_KEYS) == "table" then
		for _, k in ipairs(OPENROUTER_FILE_KEYS) do add(k) end
	end
	add(OPENROUTER_KEY)
	if #list == 0 and type(DEFAULT_OPENROUTER_KEY) == "string" then
		add(DEFAULT_OPENROUTER_KEY)
	end
	return list
end

-- ready keys first (the one that worked last time on top), rested keys last
-- and soonest-ready first, so an all-limited set still gets tried
function API.orderedKeys()
	local now = os.clock()
	local ready, resting = {}, {}
	for _, k in ipairs(API.keys()) do
		local cd = API.cooling[k]
		if cd and cd.readyAt > now then
			resting[#resting + 1] = { key = k, at = cd.readyAt }
		else
			API.cooling[k] = nil
			ready[#ready + 1] = k
		end
	end
	table.sort(resting, function(a, b) return a.at < b.at end)
	local out = {}
	for _, k in ipairs(ready) do out[#out + 1] = k end
	for _, entry in ipairs(resting) do out[#out + 1] = entry.key end
	if API.lastGoodKey then
		for i, k in ipairs(out) do
			if k == API.lastGoodKey and i > 1 then
				table.remove(out, i)
				table.insert(out, 1, k)
				break
			end
		end
	end
	return out
end

function API.keyLabel(key)
	for i, k in ipairs(API.keys()) do
		if k == key then return "Key " .. i end
	end
	return "That key"
end

-- 429 = slow down, 401/402 = this key is dead. Either way: rest it, next key.
function API.restKey(key, status, res)
	local wait = (status == 429) and 25 or 300
	if status == 429 then
		local headers = res and res.Headers
		local after = headers and (headers["retry-after"] or headers["Retry-After"])
		local secs = tonumber(after)
		if secs and secs > 0 and secs <= 120 then wait = secs end
	end
	API.cooling[key] = { readyAt = os.clock() + wait, status = status }
end

-- one logical call; extra HTTP requests only happen after a real failure
-- (a rested key, a dead model), never after a good answer
local function callOpenRouter(systemPrompt, userPrompt)
	local lastErr = "unknown error"
	local keys = API.orderedKeys()
	if #keys == 0 then return nil, "no OpenRouter key is set" end
	local budget = math.min(#keys + 2, API.maxAttempts)
	for _, model in ipairs(API.models) do
		local modelProblem = false
		for _, key in ipairs(keys) do
			if budget <= 0 then break end
			budget = budget - 1
			local body = HttpService:JSONEncode({
				model = model,
				messages = {
					{ role = "system", content = systemPrompt },
					{ role = "user", content = userPrompt },
				},
				temperature = 0.2,
				max_tokens = 500,
			})
			local res = httpRequest({
				Url = "https://openrouter.ai/api/v1/chat/completions",
				Method = "POST",
				Headers = {
					["Authorization"] = "Bearer " .. key,
					["Content-Type"] = "application/json",
					["HTTP-Referer"] = "https://roblox.com",
					["X-Title"] = "SoloChatTranslator",
				},
				Body = body,
			})
			if not res then
				lastErr = "no HTTP response from OpenRouter"
				modelProblem = true
			else
				local status = res.StatusCode or res.Status or 200
				local raw = res.Body or ""
				if status >= 200 and status < 300 then
					local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
					local content = ok and data and data.choices and data.choices[1]
						and data.choices[1].message and data.choices[1].message.content
					if type(content) == "string" and content ~= "" then
						API.lastGoodKey = key
						API.cooling[key] = nil
						return trim(content)
					end
					lastErr = "empty completion from " .. model
					modelProblem = true
				elseif status == 401 or status == 402 or status == 429 then
					API.restKey(key, status, res)
					lastErr = API.errorFor(status, raw)
					if status == 429 then
						CHAT.notify(utf8.char(9888) .. " " .. API.keyLabel(key)
							.. " is rate limited - switching to the next key")
					end
				else
					lastErr = API.errorFor(status, raw)
					modelProblem = true
					break
				end
			end
		end
		-- every key was rested: another model would just be limited as well
		if not modelProblem then break end
	end
	return nil, lastErr
end

-- ------------------------------------------------------------------
-- Language detection (free, local) + the two translation calls
-- ------------------------------------------------------------------
local LANG = { playerLang = {} }

-- Every language the panel can name, tag and speak. The selector shows these
-- names, never the bare code.
LANG.names = {
	af = "Afrikaans", am = "Amharic", ar = "Arabic", az = "Azerbaijani",
	be = "Belarusian", bg = "Bulgarian", bn = "Bengali", bs = "Bosnian",
	ca = "Catalan", cs = "Czech", cy = "Welsh", da = "Danish", de = "German",
	el = "Greek", en = "English", eo = "Esperanto", es = "Spanish",
	et = "Estonian", eu = "Basque", fa = "Persian", fi = "Finnish",
	fr = "French", ga = "Irish", gl = "Galician", gu = "Gujarati",
	ha = "Hausa", he = "Hebrew", hi = "Hindi", hr = "Croatian", hu = "Hungarian",
	hy = "Armenian", id = "Indonesian", ig = "Igbo", is = "Icelandic",
	it = "Italian", ja = "Japanese", ka = "Georgian", kk = "Kazakh",
	km = "Khmer", kn = "Kannada", ko = "Korean", ku = "Kurdish", lb = "Luxembourgish",
	lo = "Lao", lt = "Lithuanian", lv = "Latvian", mk = "Macedonian",
	ml = "Malayalam", mn = "Mongolian", mr = "Marathi", ms = "Malay",
	mt = "Maltese", my = "Burmese", ne = "Nepali", nl = "Dutch", no = "Norwegian",
	["or"] = "Odia", pa = "Punjabi", pl = "Polish", ps = "Pashto", pt = "Portuguese",
	ro = "Romanian", ru = "Russian", si = "Sinhala", sk = "Slovak", sl = "Slovenian",
	so = "Somali", sq = "Albanian", sr = "Serbian", sv = "Swedish", sw = "Swahili",
	ta = "Tamil", te = "Telugu", th = "Thai", tl = "Filipino", tr = "Turkish",
	uk = "Ukrainian", ur = "Urdu", uz = "Uzbek", vi = "Vietnamese", xh = "Xhosa",
	yo = "Yoruba", zh = "Chinese", zu = "Zulu",
}

-- ISO 639-2 codes, English names and regional variants a model may answer with
LANG.aliases = {
	por = "pt", spa = "es", fra = "fr", fre = "fr", deu = "de", ger = "de",
	ita = "it", nld = "nl", dut = "nl", rus = "ru", ukr = "uk", pol = "pl",
	ces = "cs", cze = "cs", slk = "sk", slo = "sk", hun = "hu", ron = "ro",
	rum = "ro", bul = "bg", ell = "el", gre = "el", tur = "tr", ara = "ar",
	heb = "he", fas = "fa", per = "fa", urd = "ur", hin = "hi", ben = "bn",
	tam = "ta", tel = "te", kan = "kn", mal = "ml", guj = "gu", pan = "pa",
	ori = "or", ory = "or", asm = "as", srp = "sr", hrv = "hr", bos = "bs",
	slv = "sl", lit = "lt", lav = "lv", est = "et", cat = "ca", glg = "gl",
	eus = "eu", baq = "eu", afr = "af", swa = "sw", amh = "am", kat = "ka",
	geo = "ka", hye = "hy", arm = "hy", aze = "az", kaz = "kk", uzb = "uz",
	mon = "mn", fil = "tl", tgl = "tl", msa = "ms", may = "ms", ind = "id",
	sqi = "sq", alb = "sq", mkd = "mk", mac = "mk", bel = "be", pus = "ps",
	kur = "ku", ckb = "ku", som = "so", yor = "yo", ibo = "ig", hau = "ha",
	zul = "zu", xho = "xh", cym = "cy", wel = "cy", gle = "ga", iri = "ga",
	mlt = "mt", ltz = "lb", epo = "eo", isl = "is", ice = "is", dan = "da",
	swe = "sv", nor = "no", nob = "no", nno = "no", fin = "fi", jpn = "ja",
	kor = "ko", zho = "zh", chi = "zh", cmn = "zh", yue = "zh", nan = "zh",
	vie = "vi", tha = "th", lao = "lo", khm = "km", mya = "my", bur = "my",
	sin = "si", nep = "ne", mar = "mr", ["in"] = "id", iw = "he",
}

-- name -> code, so a model answering "LANG: Spanish" still resolves
LANG.codes = {}
for code, name in pairs(LANG.names) do
	LANG.codes[name:lower()] = code
end
for alias, code in pairs(LANG.aliases) do
	LANG.codes[alias] = code
end

-- Script ranges give an instant, reliable answer for non-Latin text.
LANG.scripts = {
	{ lo = 0x0400, hi = 0x04FF, code = "ru" }, -- Cyrillic (refined below)
	{ lo = 0x0500, hi = 0x052F, code = "ru" },
	{ lo = 0x0530, hi = 0x058F, code = "hy" }, -- Armenian
	{ lo = 0x10A0, hi = 0x10FF, code = "ka" }, -- Georgian
	{ lo = 0x1200, hi = 0x139F, code = "am" }, -- Ethiopic
	{ lo = 0x0590, hi = 0x05FF, code = "he" }, -- Hebrew
	{ lo = 0x0600, hi = 0x06FF, code = "ar" }, -- Arabic (refined below)
	{ lo = 0x0750, hi = 0x077F, code = "ar" },
	{ lo = 0x08A0, hi = 0x08FF, code = "ar" },
	{ lo = 0xFB50, hi = 0xFDFF, code = "ar" },
	{ lo = 0xFE70, hi = 0xFEFF, code = "ar" },
	{ lo = 0x0900, hi = 0x097F, code = "hi" }, -- Devanagari
	{ lo = 0x0980, hi = 0x09FF, code = "bn" }, -- Bengali
	{ lo = 0x0A00, hi = 0x0A7F, code = "pa" }, -- Gurmukhi
	{ lo = 0x0A80, hi = 0x0AFF, code = "gu" }, -- Gujarati
	{ lo = 0x0B00, hi = 0x0B7F, code = "or" }, -- Odia
	{ lo = 0x0B80, hi = 0x0BFF, code = "ta" }, -- Tamil
	{ lo = 0x0C00, hi = 0x0C7F, code = "te" }, -- Telugu
	{ lo = 0x0C80, hi = 0x0CFF, code = "kn" }, -- Kannada
	{ lo = 0x0D00, hi = 0x0D7F, code = "ml" }, -- Malayalam
	{ lo = 0x0D80, hi = 0x0DFF, code = "si" }, -- Sinhala
	{ lo = 0x0E00, hi = 0x0E7F, code = "th" }, -- Thai
	{ lo = 0x0E80, hi = 0x0EFF, code = "lo" }, -- Lao
	{ lo = 0x1000, hi = 0x109F, code = "my" }, -- Burmese
	{ lo = 0x1780, hi = 0x17FF, code = "km" }, -- Khmer
	{ lo = 0x1100, hi = 0x11FF, code = "ko" }, -- Hangul
	{ lo = 0xAC00, hi = 0xD7AF, code = "ko" },
	{ lo = 0x3040, hi = 0x30FF, code = "ja" }, -- kana
	{ lo = 0x31F0, hi = 0x31FF, code = "ja" },
	{ lo = 0x3400, hi = 0x4DBF, code = "zh" }, -- han
	{ lo = 0x4E00, hi = 0x9FFF, code = "zh" },
	{ lo = 0xF900, hi = 0xFAFF, code = "zh" },
	{ lo = 0x0370, hi = 0x03FF, code = "el" }, -- greek
	{ lo = 0x1F00, hi = 0x1FFF, code = "el" },
}

-- Letters that only one or two languages use. A unique letter is very strong
-- evidence; a shared one is a hint.
LANG.marks = {
	es = "ñ¿¡", pt = "ãõ", fr = "œ", de = "ß", tr = "ğış", pl = "łąęśżźćń",
	cs = "řěů", sk = "ľĺŕ", ro = "ășț", hu = "őű", vi = "đơư", is = "þð",
	lv = "ģķļņ", lt = "ųėįū", eo = "ĉĝĥĵŝŭ", az = "ə", sv = "å", da = "ø",
	no = "ø", hr = "đ", sq = "ë", et = "õ", uk = "їєґі", be = "ў", mk = "ѓќѕ",
	sr = "ђћџљњ", kk = "әғқңұүһ",
}

-- Cyrillic and Arabic script are shared by several languages; these letters
-- tell them apart.
LANG.refineMarks = {
	ru = { "і", "ї", "є", "ґ", "ў", "ѓ", "ќ", "ѕ", "ђ", "ћ", "џ", "љ", "њ",
		"ә", "ғ", "қ", "ң", "ұ", "ү", "һ", "ө" },
	ar = { "پ", "چ", "ژ", "گ", "ٹ", "ڈ", "ڑ", "ں", "ے", "ھ" },
}
LANG.refineMap = {
	["і"] = "uk", ["ї"] = "uk", ["є"] = "uk", ["ґ"] = "uk", ["ў"] = "be",
	["ѓ"] = "mk", ["ќ"] = "mk", ["ѕ"] = "mk",
	["ђ"] = "sr", ["ћ"] = "sr", ["џ"] = "sr", ["љ"] = "sr", ["њ"] = "sr",
	["ә"] = "kk", ["ғ"] = "kk", ["қ"] = "kk", ["ң"] = "kk", ["ұ"] = "kk",
	["ү"] = "kk", ["һ"] = "kk", ["ө"] = "mn",
	["پ"] = "fa", ["چ"] = "fa", ["ژ"] = "fa", ["گ"] = "fa",
	["ٹ"] = "ur", ["ڈ"] = "ur", ["ڑ"] = "ur", ["ں"] = "ur", ["ے"] = "ur", ["ھ"] = "ur",
}

-- Scripts that cover several languages: word evidence picks the member.
LANG.family = {
	ru = { "ru", "uk", "be", "bg", "sr", "mk", "kk", "mn" },
	ar = { "ar", "fa", "ur" },
	hi = { "hi", "mr", "ne" },
}

-- Common function words and chat words per language.
LANG.words = {
	es = { "el", "la", "los", "las", "de", "que", "y", "en", "un", "una", "por",
		"para", "con", "no", "sí", "si", "es", "mi", "tu", "como", "pero", "más",
		"mas", "está", "esta", "estoy", "hola", "gracias", "bien", "mal", "porque",
		"cuando", "donde", "muy", "yo", "nosotros", "ellos", "ella", "él", "quiero",
		"tienes", "ayuda", "juego", "amigo", "casa", "qué", "quien", "también",
		"tambien", "nada", "mucho", "hacer", "sé", "eres", "soy", "vamos", "bueno",
		"buenas", "tardes", "noches", "adiós", "adios", "dónde", "tengo", "gusto",
		"mañana", "manana", "ahora", "todos", "algo", "voy", "estás", "estas" },
	pt = { "o", "a", "os", "as", "de", "que", "e", "um", "uma", "não", "nao",
		"para", "com", "por", "do", "da", "dos", "das", "muito", "mais", "você",
		"voce", "está", "esta", "também", "tambem", "como", "quando", "onde", "eu",
		"ele", "ela", "nós", "amigo", "jogo", "casa", "obrigado", "obrigada", "olá",
		"oi", "tudo", "bem", "estou", "tô", "cara", "sim", "tipo", "aqui", "agora",
		"nada", "bom", "boa", "dia", "noite", "tchau", "beleza", "vamos", "quero",
		"isso", "esse", "essa", "meu", "minha", "fazer", "sei", "jogar", "mano" },
	fr = { "le", "la", "les", "des", "de", "du", "et", "un", "une", "est", "pas",
		"que", "qui", "dans", "pour", "avec", "sur", "ne", "plus", "vous", "nous",
		"je", "tu", "il", "elle", "bonjour", "merci", "oui", "non", "mais", "très",
		"tres", "bien", "suis", "comment", "quoi", "où", "au", "aux", "ce", "cette",
		"mon", "ton", "salut", "ça", "va", "peux", "veux", "faire", "bonsoir",
		"revoir", "oui", "merci", "beaucoup", "aujourd" },
	de = { "der", "die", "das", "und", "ist", "nicht", "ein", "eine", "ich", "du",
		"er", "sie", "es", "wir", "ihr", "mit", "für", "fur", "auf", "von", "zu",
		"den", "dem", "des", "haben", "habe", "bin", "bist", "sind", "auch", "aber",
		"sehr", "danke", "hallo", "wie", "was", "wo", "noch", "mal", "gut", "doch",
		"weiß", "weiss", "weißt", "guten", "tag", "tschüss", "tschuss", "bitte",
		"gerne", "kann", "muss", "meinst", "jetzt", "nur", "schon", "mehr" },
	it = { "il", "lo", "la", "gli", "le", "di", "che", "e", "un", "una", "non",
		"per", "con", "su", "sono", "sei", "è", "ciao", "grazie", "come", "dove",
		"quando", "molto", "più", "piu", "anche", "ma", "io", "tu", "lui", "lei",
		"noi", "bene", "cosa", "perché", "perche", "questo", "quella", "buongiorno",
		"buonasera", "arrivederci", "sto", "fare", "adesso", "voglio" },
	nl = { "de", "het", "een", "en", "van", "ik", "je", "jij", "hij", "zij", "wij",
		"niet", "dat", "dit", "met", "voor", "op", "zijn", "ben", "bent", "wat",
		"hoe", "waar", "dank", "hallo", "ook", "maar", "goed", "nog", "ga", "gaat",
		"kan", "wil", "dag", "doei", "alsjeblieft", "bedoelt", "weet", "nu" },
	pl = { "i", "w", "na", "z", "do", "nie", "to", "jest", "się", "sie", "że",
		"ze", "jak", "co", "ale", "tak", "ja", "ty", "on", "ona", "my", "wy",
		"dziękuję", "dziekuje", "cześć", "czesc", "bardzo", "dobrze", "gdzie",
		"kiedy", "mam", "masz", "jestem", "proszę", "prosze", "dzień", "dzien",
		"dobry", "siema", "hej", "robisz" },
	cs = { "a", "v", "se", "na", "je", "že", "ze", "to", "není", "neni", "jak",
		"co", "ale", "tak", "já", "ja", "ty", "on", "ona", "my", "vy", "děkuji",
		"dekuji", "ahoj", "dobrý", "dobry", "den", "prosím", "prosim", "moc",
		"kde", "kdy", "jsem", "jsi", "nevím", "nevim", "mám", "mam", "dělat",
		"delat", "chceš", "chces" },
	sk = { "a", "v", "sa", "na", "je", "že", "to", "nie", "ako", "čo", "co",
		"ale", "tak", "áno", "ano", "ja", "ty", "on", "ona", "my", "vy", "ďakujem",
		"dakujem", "ahoj", "dobrý", "den", "prosím", "prosim", "veľmi", "velmi",
		"kde", "kedy", "som", "si", "nevem", "robím", "robim" },
	hu = { "a", "az", "és", "es", "nem", "hogy", "egy", "van", "vagyok", "vagy",
		"te", "ő", "mi", "ti", "igen", "köszönöm", "koszonom", "szia", "jó", "jo",
		"napot", "hol", "mikor", "nagyon", "jól", "jol", "kérem", "kerem", "én",
		"en", "csinálsz", "csinalsz", "tudom", "akarok" },
	ro = { "și", "si", "în", "in", "nu", "un", "o", "este", "sunt", "eu", "tu",
		"el", "ea", "noi", "voi", "ei", "ce", "cum", "unde", "când", "cand",
		"mulțumesc", "multumesc", "bună", "buna", "ziua", "salut", "foarte", "bine",
		"dar", "mai", "mă", "ma", "te", "vă", "va", "faci", "fac", "frumos" },
	bg = { "и", "в", "на", "е", "не", "се", "че", "да", "с", "за", "от", "това",
		"аз", "ти", "той", "тя", "ние", "вие", "те", "как", "какво", "къде",
		"кога", "благодаря", "здравей", "здравейте", "добре", "много", "но", "си",
		"съм", "искам" },
	hr = { "i", "u", "na", "je", "se", "da", "ne", "što", "sto", "sam", "si",
		"smo", "ste", "su", "ja", "ti", "on", "ona", "mi", "vi", "hvala", "dobar",
		"dan", "dobro", "kako", "gdje", "kada", "molim", "želim", "zelim" },
	sr = { "и", "у", "на", "је", "да", "не", "шта", "ја", "ти", "он", "она",
		"ми", "ви", "хвала", "добар", "дан", "добро", "како", "где", "када",
		"молим", "желим", "здраво", "си", "сам", "смо", "сте", "су", "se", "sam",
		"si", "su", "zdravo" },
	sl = { "in", "v", "na", "je", "se", "da", "ne", "kaj", "sem", "si", "smo",
		"ste", "so", "jaz", "ti", "on", "ona", "mi", "vi", "hvala", "dober",
		"dan", "dobro", "kako", "kje", "kdaj", "prosim", "hočem", "hocm" },
	ru = { "и", "в", "на", "не", "что", "это", "я", "ты", "он", "она", "мы",
		"вы", "они", "как", "где", "когда", "спасибо", "привет", "хорошо", "очень",
		"но", "да", "нет", "пожалуйста", "есть", "можно", "дела", "хочешь",
		"думаешь", "сейчас" },
	uk = { "і", "в", "на", "є", "не", "що", "це", "я", "ти", "він", "вона",
		"ми", "ви", "вони", "як", "де", "коли", "дякую", "привіт", "добре",
		"дуже", "але", "так", "справи", "хочеш", "думаєш", "зараз" },
	be = { "і", "ў", "на", "не", "што", "гэта", "я", "ты", "ён", "яна", "мы",
		"вы", "яны", "як", "дзе", "калі", "дзякуй", "прывітанне", "добра" },
	mk = { "и", "во", "на", "е", "не", "што", "ова", "јас", "ти", "тој", "таа",
		"ние", "вие", "тие", "како", "каде", "кога", "благодарам", "здраво",
		"добро", "многу", "но", "да", "сакам" },
	el = { "και", "το", "η", "ο", "να", "δεν", "είναι", "με", "για", "από",
		"που", "τι", "πώς", "πως", "γεια", "σου", "ευχαριστώ", "ευχαριστω", "καλά",
		"καλα", "κάνεις", "κανεις", "πολύ", "πολυ", "τώρα", "θελω", "θέλω" },
	tr = { "ve", "bir", "bu", "şu", "su", "için", "icin", "ile", "de", "da",
		"ne", "ben", "sen", "o", "biz", "siz", "çok", "cok", "var", "yok", "değil",
		"degil", "nasıl", "nasil", "merhaba", "teşekkür", "tesekkur", "ama",
		"çünkü", "cunku", "nasılsın", "nasilsin", "iyi", "güzel", "guzel", "tamam",
		"istiyorum", "yapıyorsun", "yapiyorsun" },
	id = { "yang", "dan", "di", "ke", "dari", "ini", "itu", "saya", "aku",
		"kamu", "tidak", "nggak", "untuk", "dengan", "apa", "bagaimana", "kenapa",
		"sudah", "belum", "bisa", "mau", "terima", "kasih", "halo", "banget",
		"aja", "sih", "selamat", "pagi", "malam", "sedang", "tahu" },
	ms = { "yang", "dan", "di", "ke", "dari", "ini", "itu", "saya", "awak",
		"tidak", "tak", "untuk", "dengan", "apa", "bagaimana", "kenapa", "sudah",
		"belum", "boleh", "mahu", "terima", "kasih", "hai", "sangat", "juga",
		"selamat", "pagi", "malam", "tahu" },
	tl = { "ang", "ng", "sa", "na", "ay", "at", "ako", "ikaw", "siya", "kami",
		"tayo", "kayo", "sila", "hindi", "oo", "salamat", "kumusta", "mabuti",
		"maganda", "pero", "kasi", "ano", "paano", "saan", "kailan", "ngayon",
		"bukas", "mahal", "gusto" },
	vi = { "và", "va", "của", "cua", "là", "la", "không", "khong", "tôi", "toi",
		"bạn", "ban", "anh", "em", "chị", "chi", "này", "nay", "được", "duoc",
		"có", "co", "một", "mot", "gì", "gi", "rồi", "roi", "với", "voi", "xin",
		"chào", "chao", "cảm", "cam", "ơn", "on", "tốt", "tot", "khỏe", "khoe" },
	sv = { "och", "att", "det", "som", "på", "pa", "är", "ar", "inte", "en",
		"ett", "jag", "du", "han", "hon", "vi", "ni", "de", "med", "för", "for",
		"av", "till", "tack", "hej", "bra", "hur", "vad", "var", "när", "nar",
		"mycket", "också", "ocksa", "vet", "menar" },
	no = { "og", "å", "a", "det", "som", "på", "pa", "er", "ikke", "en", "et",
		"jeg", "du", "han", "hun", "vi", "dere", "de", "med", "for", "av", "til",
		"takk", "hei", "bra", "hvordan", "hva", "hvor", "når", "nar", "veldig",
		"også", "ogsa", "vet", "mener" },
	da = { "og", "det", "som", "på", "pa", "er", "ikke", "en", "et", "jeg",
		"du", "han", "hun", "vi", "de", "med", "for", "af", "til", "tak", "hej",
		"god", "hvordan", "hvad", "hvor", "hvornår", "meget", "også", "ved",
		"mener" },
	fi = { "ja", "on", "ei", "se", "että", "etta", "minä", "mina", "sinä",
		"sina", "hän", "han", "me", "te", "he", "kanssa", "mutta", "kiitos",
		"moi", "hei", "hyvä", "hyva", "miten", "mitä", "mita", "missä", "missa",
		"paljon", "nyt", "tiedä", "tieda" },
	is = { "og", "að", "ad", "er", "ekki", "ég", "eg", "þú", "thu", "hann",
		"hún", "hun", "við", "vid", "þið", "þeir", "með", "med", "fyrir", "takk",
		"halló", "hallo", "góðan", "godan", "dag", "hvað", "hvad", "hvernig",
		"mjög", "mjog" },
	et = { "ja", "on", "ei", "see", "et", "ma", "sa", "ta", "me", "te", "nad",
		"jaoks", "aga", "aitäh", "aitah", "tere", "hea", "kuidas", "mis", "kus",
		"palju", "tean" },
	lt = { "ir", "yra", "ne", "kad", "aš", "as", "tu", "jis", "ji", "mes",
		"jūs", "jus", "jie", "su", "bet", "ačiū", "aciu", "labas", "gerai",
		"kaip", "kur", "kada", "prašau", "prasau", "noriu" },
	lv = { "un", "ir", "ne", "ka", "es", "tu", "viņš", "vins", "viņa", "vina",
		"mēs", "mes", "jūs", "jus", "viņi", "vini", "ar", "bet", "paldies",
		"sveiki", "labi", "kā", "kur", "kad", "lūdzu", "ludzu", "gribu" },
	ca = { "el", "la", "els", "les", "de", "que", "i", "un", "una", "no", "és",
		"es", "amb", "per", "però", "pero", "com", "quan", "on", "molt", "gràcies",
		"gracies", "hola", "bon", "dia", "adéu", "adeu", "sí", "vull" },
	gl = { "o", "a", "os", "as", "de", "que", "e", "un", "unha", "non", "é",
		"con", "por", "pero", "como", "cando", "onde", "moito", "grazas", "ola",
		"bo", "día", "dia", "adeus", "quero" },
	eu = { "eta", "da", "ez", "bat", "ni", "zu", "hura", "gu", "zuek", "haiek",
		"baina", "eskerrik", "asko", "kaixo", "ondo", "nola", "non", "noiz",
		"mesedez", "nahi" },
	af = { "die", "en", "van", "is", "nie", "ek", "jy", "hy", "sy", "ons",
		"julle", "hulle", "met", "vir", "maar", "dankie", "hallo", "goed", "hoe",
		"wat", "waar", "wanneer", "baie", "asseblief", "wil" },
	sw = { "na", "ya", "wa", "ni", "kwa", "katika", "mimi", "wewe", "yeye",
		"sisi", "ninyi", "wao", "lakini", "asante", "habari", "nzuri", "vipi",
		"wapi", "lini", "sana", "ndiyo", "hapana", "nataka" },
	sq = { "dhe", "është", "eshte", "nuk", "një", "nje", "unë", "une", "ti",
		"ai", "ajo", "ne", "ju", "ata", "me", "por", "faleminderit",
		"përshëndetje", "mire", "mirë", "si", "ku", "kur", "shumë", "shume",
		"dua" },
	eo = { "la", "kaj", "estas", "ne", "unu", "mi", "vi", "li", "ŝi", "si",
		"ni", "ili", "kun", "sed", "dankon", "saluton", "bone", "kiel", "kie",
		"kiam", "tre", "jes", "volas" },
	az = { "və", "ve", "bir", "bu", "mən", "men", "sən", "sen", "o", "biz",
		"siz", "onlar", "deyil", "üçün", "ucun", "ilə", "ile", "amma", "sağol",
		"sagol", "salam", "necə", "nece", "harada", "çox", "cox", "yox",
		"istəyirəm" },
	fa = { "و", "از", "که", "در", "این", "است", "را", "با", "برای", "من", "تو",
		"او", "ما", "شما", "آنها", "نه", "بله", "ممنون", "سلام", "خوب", "چطور",
		"کجا", "کی", "بسیار", "خداحافظ", "حال" },
	ur = { "اور", "ہے", "میں", "کی", "سے", "نہیں", "یہ", "وہ", "آپ", "ہم",
		"تم", "کیا", "کیسے", "کہاں", "کب", "شکریہ", "سلام", "ٹھیک", "اچھا",
		"بہت", "لیکن", "جی", "ہوں", "کرتے" },
	ar = { "و", "من", "في", "على", "أن", "ان", "هو", "هي", "نحن", "أنت",
		"انت", "لا", "نعم", "ما", "كيف", "أين", "اين", "متى", "شكرا", "مرحبا",
		"السلام", "عليكم", "جيد", "كثير", "لكن", "هذا", "هذه", "حال" },
	he = { "שלום", "מה", "זה", "לא", "כן", "אני", "אתה", "את", "הוא", "היא",
		"אנחנו", "אתם", "הם", "איך", "איפה", "מתי", "תודה", "טוב", "מאוד", "אבל",
		"אתה", "שלומך" },
	hi = { "और", "है", "मैं", "तुम", "आप", "वह", "हम", "नहीं", "क्या", "कैसे",
		"कहाँ", "कब", "धन्यवाद", "नमस्ते", "अच्छा", "बहुत", "लेकिन", "हाँ",
		"ठीक", "कैसे", "हैं" },
	mr = { "आणि", "आहे", "मी", "तू", "तुम्ही", "तो", "ती", "आम्ही", "नाही",
		"काय", "कसे", "कुठे", "कधी", "धन्यवाद", "नमस्कार", "चांगले", "खूप",
		"पण" },
	ne = { "र", "छ", "म", "तिमी", "तपाईं", "उनी", "हामी", "छैन", "के", "कसरी",
		"कहाँ", "कहिले", "धन्यवाद", "नमस्ते", "राम्रो", "धेरै", "तर" },
	bn = { "এবং", "আছে", "আমি", "তুমি", "আপনি", "সে", "আমরা", "না", "কি",
		"কেমন", "কোথায়", "কখন", "ধন্যবাদ", "হ্যালো", "ভালো", "খুব", "কিন্তু" },
	pa = { "ਅਤੇ", "ਹੈ", "ਮੈਂ", "ਤੂੰ", "ਤੁਸੀਂ", "ਉਹ", "ਅਸੀਂ", "ਨਹੀਂ", "ਕੀ",
		"ਕਿਵੇਂ", "ਕਿੱਥੇ", "ਕਦੋਂ", "ਧੰਨਵਾਦ", "ਸਤ", "ਚੰਗਾ", "ਬਹੁਤ" },
	gu = { "અને", "છે", "હું", "તું", "તમે", "તે", "અમે", "નહીં", "શું",
		"કેવી", "ક્યાં", "ક્યારે", "આભાર", "નમસ્તે", "સારું", "ખૂબ" },
	["or"] = { "ଏବଂ", "ଅଛି", "ମୁଁ", "ତୁମେ", "ସେ", "ଆମେ", "ନାହିଁ", "କଣ", "କେମିତି",
		"କେଉଁଠି", "ଧନ୍ୟବାଦ", "ନମସ୍କାର", "ଭଲ" },
	ta = { "மற்றும்", "உள்ளது", "நான்", "நீ", "நீங்கள்", "அவர்", "நாங்கள்",
		"இல்லை", "என்ன", "எப்படி", "எங்கே", "எப்போது", "நன்றி", "வணக்கம்",
		"நல்ல", "மிக" },
	te = { "మరియు", "ఉంది", "నేను", "నీవు", "మీరు", "అతను", "మేము",
		"లేదు", "ఏమి", "ఎలా", "ఎక్కడ", "ఎప్పుడు", "ధన్యవాదాలు", "నమస్కారం",
		"మంచి", "చాలా" },
	kn = { "ಮತ್ತು", "ಇದೆ", "ನಾನು", "ನೀನು", "ನೀವು", "ಅವರು", "ನಾವು", "ಇಲ್ಲ",
		"ಏನು", "ಹೇಗೆ", "ಎಲ್ಲಿ", "ಯಾವಾಗ", "ಧನ್ಯವಾದ", "ನಮಸ್ಕಾರ", "ಒಳ್ಳೆಯ" },
	ml = { "ഒപ്പം", "ഉണ്ട്", "ഞാൻ", "നീ", "നിങ്ങൾ", "അവൻ", "ഞങ്ങൾ", "ഇല്ല",
		"എന്ത്", "എങ്ങനെ", "എവിടെ", "എപ്പോൾ", "നന്ദി", "നമസ്കാരം", "നല്ല" },
	si = { "සහ", "ඇත", "මම", "ඔබ", "ඔහු", "අපි", "නැත", "මොකක්ද", "කොහොමද",
		"කොහෙද", "ස්තූතියි", "ආයුබෝවන්", "හොඳ" },
	th = { "และ", "คือ", "ฉัน", "คุณ", "เขา", "เรา", "ไม่", "อะไร", "ยังไง",
		"ที่ไหน", "เมื่อไหร่", "ขอบคุณ", "สวัสดี", "ดี", "มาก", "แต่" },
	lo = { "ແລະ", "ແມ່ນ", "ຂ້ອຍ", "ເຈົ້າ", "ເຂົາ", "ເຮົາ", "ບໍ່", "ຫຍັງ",
		"ແນວໃດ", "ຢູ່ໃສ", "ຂອບໃຈ", "ສະບາຍດີ", "ດີ" },
	my = { "နှင့်", "သည်", "ငါ", "မင်း", "သူ", "ကျွန်တော်", "မဟုတ်", "ဘာ",
		"ဘယ်လို", "ဘယ်မှာ", "ကျေးဇူးတင်ပါတယ်", "မင်္ဂလာပါ", "ကောင်း" },
	km = { "និង", "គឺ", "ខ្ញុំ", "អ្នក", "គាត់", "យើង", "មិន", "អ្វី", "យ៉ាងណា",
		"ឯណា", "អរគុណ", "សួស្តី", "ល្អ" },
	ja = { "は", "が", "を", "に", "で", "と", "の", "です", "ます", "ない",
		"これ", "それ", "ありがとう", "こんにちは", "元気", "とても", "でも" },
	ko = { "그리고", "은", "는", "이", "가", "을", "를", "에", "입니다", "있어요",
		"없어요", "고마워", "안녕하세요", "좋아요", "매우", "하지만", "저는" },
	zh = { "的", "是", "我", "你", "他", "她", "我们", "不", "什么", "怎么",
		"哪里", "谢谢", "你好", "很好", "非常", "但是", "这个" },
}

-- English stopwords. Without them, ordinary English scored stray hits on
-- Spanish/Italian words ("no", "son", "con", "a") and got sent to the
-- translator for no reason.
LANG.words.en = {
	"the", "and", "is", "are", "was", "were", "you", "your", "to", "of", "it",
	"its", "that", "this", "these", "those", "for", "with", "have", "has", "had",
	"not", "but", "what", "how", "where", "why", "when", "who", "can", "will",
	"would", "should", "could", "do", "does", "did", "am", "be", "been", "my",
	"me", "we", "our", "they", "them", "their", "he", "she", "his", "her",
	"just", "like", "get", "got", "going", "gonna", "wanna", "there", "here",
	"about", "from", "out", "off", "up", "down", "on", "in", "at", "so", "if",
	"or", "no", "yes", "ok", "okay", "hi", "hello", "thanks", "thank", "please",
	"sorry", "lol", "bro", "dude", "guys", "good", "bad", "nice", "cool",
	"really", "very", "much", "some", "any", "all", "one", "two", "now", "also",
	"too", "than", "then", "im", "ive", "id", "dont", "cant", "wont", "didnt",
	"isnt", "arent", "wasnt", "youre", "theyre", "thats", "whats", "lets",
	"yeah", "yep", "nah", "gg", "ez", "yo", "sup", "lmao", "idk", "pls", "plz",
	"wait", "know", "think", "want", "need", "make", "take", "see", "say",
	"tell", "come", "time", "day", "well", "new", "old", "hey", "man", "anyone",
	"everyone", "someone", "nothing", "something", "again", "still", "only",
	"even", "back", "first", "last", "never", "always", "because", "before",
	"after", "while", "over", "under", "into", "through", "being", "made",
}

-- mark -> languages that use it (built once; unique marks count as strong proof)
LANG.markIndex = {}
for code, marks in pairs(LANG.marks) do
	pcall(function()
		for _, cp in utf8.codes(marks) do
			local ch = utf8.char(cp)
			local list = LANG.markIndex[ch]
			if not list then
				list = {}
				LANG.markIndex[ch] = list
			end
			local found = false
			for _, existing in ipairs(list) do
				if existing == code then found = true end
			end
			if not found then list[#list + 1] = code end
		end
	end)
end

LANG.detectCache = {}
LANG.translateCache = {}

-- "pt-BR", "por", "Portuguese", "zh_Hans" -> "pt", "Portuguese"... -> a code
function LANG.canonical(raw)
	if not raw or raw == "" then return nil end
	local s = tostring(raw):lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("_", "-")
	if LANG.names[s] then return s end
	if LANG.aliases[s] then return LANG.aliases[s] end
	if LANG.codes[s] then return LANG.codes[s] end
	local base = s:match("^([%a]+)")
	if base then
		if LANG.names[base] then return base end
		if LANG.aliases[base] then return LANG.aliases[base] end
	end
	return base or s
end

-- Always a real language name in the UI, never a bare code.
function LANG.displayName(code)
	if not code or code == "" then return "Unknown" end
	local canonical = LANG.canonical(code)
	if canonical and LANG.names[canonical] then return LANG.names[canonical] end
	local raw = tostring(code)
	return raw:sub(1, 1):upper() .. raw:sub(2)
end

local function wordScore(lower, list)
	local score = 0
	for _, w in ipairs(list or {}) do
		if string.find(lower, " " .. w .. " ", 1, true) then
			score = score + 1
		end
	end
	return score
end

-- 0 requests: writing system, then distinctive letters, then function words.
-- Returns code, confidence (3 = script, 2 = words/letters, 0 = no idea).
function LANG.detectLocal(text)
	if not text or text == "" then return "en", 0 end

	local hits = {}
	local ok = pcall(function()
		for _, code in utf8.codes(text) do
			for _, s in ipairs(LANG.scripts) do
				if code >= s.lo and code <= s.hi then
					hits[s.code] = (hits[s.code] or 0) + 1
					break
				end
			end
		end
	end)
	if not ok then return "en", 0 end

	local lower = " " .. string.lower((text:gsub("[%p%c]", " "))) .. " "

	if (hits.ja or 0) > 0 then return "ja", 3 end -- kana never appears in Chinese
	if (hits.ko or 0) > 0 then return "ko", 3 end
	if (hits.zh or 0) > 0 then return "zh", 3 end

	local script, scriptCount = nil, 0
	for code, n in pairs(hits) do
		if n > scriptCount then
			script, scriptCount = code, n
		end
	end
	if script then
		-- shared scripts: a unique letter names the language
		for _, mark in ipairs(LANG.refineMarks[script] or {}) do
			if string.find(text, mark, 1, true) then
				script = LANG.refineMap[mark] or script
				break
			end
		end
		-- shared scripts: word evidence picks the family member
		local family = LANG.family[script]
		if family then
			local pick, pickScore = script, 0
			for _, member in ipairs(family) do
				local score = wordScore(lower, LANG.words[member])
				if score > pickScore then
					pick, pickScore = member, score
				end
			end
			if pickScore >= 2 then script = pick end
		end
		return script, 3
	end

	local scores = {}
	local function add(code, n)
		if code and n and n > 0 then
			scores[code] = (scores[code] or 0) + n
		end
	end

	-- distinctive letters: unique to one language = strong, shared = a hint
	for mark, codes in pairs(LANG.markIndex) do
		if string.find(text, mark, 1, true) then
			add(codes[1], (#codes == 1) and 3 or 1)
		end
	end

	-- function words per language
	for code, list in pairs(LANG.words) do
		if code ~= "en" then
			add(code, wordScore(lower, list))
		end
	end
	local enScore = wordScore(lower, LANG.words.en)

	local bestLang, bestScore = nil, 0
	for code, score in pairs(scores) do
		-- ties go to the alphabetically first code so the answer is stable
		if score > bestScore or (score == bestScore and bestLang ~= nil and code < bestLang) then
			bestLang, bestScore = code, score
		end
	end

	-- Only answer with a language when the evidence clearly beats English.
	if bestLang and bestScore >= 2 and bestScore > enScore
		and (bestScore >= 3 or bestScore >= enScore + 2) then
		return bestLang, bestScore >= 4 and 3 or 2
	end
	return "en", 0
end

function LANG.remember(userId, lang)
	if userId and userId ~= 0 and lang and lang ~= "" then
		LANG.playerLang[userId] = lang
	end
end

-- 1 request: language of a message plus its English translation, in one answer.
function API.detectAndTranslate(text, hint)
	local system = [[You are a precise language identifier and translator.
Read the user's message and reply in EXACTLY this format, nothing else:
LANG: <ISO 639-1 code of the message's own language>
TRANSLATION: <faithful English translation of the message>

Rules: never label a non-English sentence as English. If the message is already
English, use LANG: en and repeat it as the translation. Do not answer the
message. Do not add notes.]]
	local user = text
	if hint and hint ~= "en" and LANG.names[hint] then
		user = "(probable language: " .. LANG.names[hint] .. ")\n" .. text
	end
	local result, err = callOpenRouter(system, user)
	if not result then return nil, nil, err or "detection failed" end
	result = result:gsub("```%w*", ""):gsub("```", ""):gsub("%*%*", "")
	local lang = result:match("LANG:%s*([%a%-]+)")
	local translation = result:match("TRANSLATION:%s*([^\r\n]+)")
	if lang then
		lang = lang:lower():gsub("%s+", "")
		lang = LANG.canonical(lang)
	end
	if translation then
		translation = trim(translation):gsub('^"(.*)"$', "%1")
	elseif lang then
		local rest = result:gsub("^.-LANG:[^\r\n]*[\r\n]*", ""):gsub("TRANSLATION:%s*", "")
		rest = trim(rest)
		if rest ~= "" then translation = rest end
	end
	return lang, translation, nil
end

-- 1 request: translate into a known language.
function API.translate(text, langCode)
	local name = LANG.displayName(langCode)
	local system = "Translate the user's message into " .. name .. " (" .. langCode .. "). "
		.. "Reply with ONLY the translated sentence: no quotes, no notes, no language tags. "
		.. "Keep slang, tone and names. If it is already in " .. name .. ", repeat it unchanged."
	local out, err = callOpenRouter(system, text)
	if not out or out == "" then return nil, err or "translation failed" end
	return trim(out):gsub('^"(.*)"$', "%1")
end

-- 1 request: translate a reply into the language of the message it answers.
-- Doing both in one call is what keeps a reply at exactly one request.
function API.translateLike(text, original)
	local system = [[You are a translator inside a game chat.
The user is answering a message written in another language. Translate the
user's answer into that same language. Keep slang, tone and names.
Reply in EXACTLY this format, nothing else:
LANG: <ISO 639-1 code of the language you translated into>
TRANSLATION: <the translated answer, one line>]]
	local user = "Message being answered:\n" .. original .. "\n\nMy answer:\n" .. text
	local result, err = callOpenRouter(system, user)
	if not result then return nil, nil, err or "translation failed" end
	result = result:gsub("```%w*", ""):gsub("```", ""):gsub("%*%*", "")
	local lang = result:match("LANG:%s*([%a%-]+)")
	local out = result:match("TRANSLATION:%s*([^\r\n]+)")
	if lang then
		lang = lang:lower():gsub("%s+", "")
		lang = LANG.canonical(lang)
	end
	if not out then
		local rest = result:gsub("^.-LANG:[^\r\n]*[\r\n]*", ""):gsub("TRANSLATION:%s*", "")
		rest = trim(rest)
		if rest ~= "" then out = rest end
	end
	if not out then return nil, lang, err or "no translation returned" end
	return trim(out):gsub('^"(.*)"$', "%1"), lang, nil
end

-- internal: manual 🌐 click = 1 request, cached afterwards (0 requests)
function LANG.detectAndTranslate(text)
	local cached = LANG.detectCache[text]
	if cached then return cached.lang, cached.translation, nil end

	local guess, conf = LANG.detectLocal(text)
	local lang, translation, err = API.detectAndTranslate(text, guess)
	if not lang or lang == "" then
		return nil, nil, err or "detection failed"
	end
	-- a non-Latin script outranks the model calling it English
	if conf >= 3 and guess ~= "en" then lang = guess end
	translation = translation or text
	LANG.detectCache[text] = { lang = lang, translation = translation }
	LANG.translateCache[lang .. "|" .. text] = translation
	return lang, translation, nil
end

-- internal: outgoing text -> target language (0 or 1 request)
function LANG.translateTo(text, targetLang)
	local key = targetLang .. "|" .. text
	local cached = LANG.translateCache[key]
	if cached then return cached, nil end
	local out, err = API.translate(text, targetLang)
	if out and out ~= "" then
		LANG.translateCache[key] = out
		return out, nil
	end
	return nil, err
end

-- ------------------------------------------------------------------
-- Message bookkeeping
-- ------------------------------------------------------------------
local function localName()
	return player.DisplayName or player.Name
end

local function prune()
	local t = os.clock()
	if #CHAT.messages > 60 then
		local keep = {}
		for i = #CHAT.messages - 49, #CHAT.messages do
			if CHAT.messages[i] then keep[#keep + 1] = CHAT.messages[i] end
		end
		CHAT.messages = keep
	end
	for sig, when in pairs(CHAT.seen) do
		if t - when > 30 then CHAT.seen[sig] = nil end
	end
end

-- 0 requests. Adds a chat line; only tags it with the free local guess.
function CHAT.pushMessage(playerName, userId, text, channel)
	if type(text) ~= "string" then return nil end
	text = trim(text)
	if text == "" then return nil end

	local mine = (userId == player.UserId)
		or (userId == 0 and playerName == localName())
		or (userId == nil and playerName == localName())

	-- our own line coming back from the server: the panel already has that row
	if mine then
		local now = os.clock()
		for sig, pend in pairs(CHAT.pendingEcho) do
			local fresh = pend.msg ~= nil and (now - pend.t) < 25
			local sameLine = sig:sub(-#text) == text
			if fresh and (sameLine or text:match("^[#%*]+$")) then
				CHAT.pendingEcho[sig] = nil
				CHAT.seen[sig] = now
				pend.msg.sent = true
				CHAT.onUpdate(pend.msg)
				return pend.msg
			end
		end
	end

	-- the same line arriving twice (modern chat + legacy chat, or two listeners)
	local sig = tostring(userId) .. "|" .. text
	local seen = CHAT.seen[sig]
	if seen and os.clock() - seen < 3 then return nil end
	CHAT.seen[sig] = os.clock()

	CHAT.nextId = CHAT.nextId + 1
	local msg = {
		id = CHAT.nextId,
		playerName = playerName or "?",
		userId = userId or 0,
		original = text,
		display = text,
		lang = nil,
		langHint = nil,
		translated = nil,
		state = "original",
		mine = mine,
		sent = mine or nil,
		channel = channel or "RBXGeneral",
		friend = (not mine and CHAT.friendIds[userId or 0]) and true or nil,
	}

	-- free tagging only: nothing here talks to OpenRouter
	if not mine then
		local guess, conf = LANG.detectLocal(text)
		if guess ~= "en" and conf >= 2 then
			msg.langHint = guess
		end
	end
	if text:match("^[#%*]+$") then
		msg.display = text .. "  (filtered by Roblox)"
	end

	CHAT.messages[#CHAT.messages + 1] = msg
	prune()
	CHAT.onNew(msg)
	return msg
end

-- 0 requests: which rows belong to the tab that is open.
function CHAT.isVisible(msg)
	if not msg then return false end
	local tab = CHAT.tab or "all"
	if tab == "friends" then
		return msg.mine == true or msg.friend == true
	end
	if tab == "global" then
		-- anything that is not a team or whisper channel counts as global,
		-- so games that rename their general channel still work
		local name = string.lower(tostring(msg.channel or "RBXGeneral"))
		return not (string.find(name, "team", 1, true) or string.find(name, "whisper", 1, true))
	end
	return true
end

-- 0 requests: switching tabs only shows or hides rows that already exist.
function CHAT.setTab(tab)
	if tab ~= "global" and tab ~= "friends" then tab = "all" end
	CHAT.tab = tab
	CHAT.onState()
end

-- 0 requests: the friend list comes from the players service, not OpenRouter.
-- Cached for two minutes; every row is re-tagged when it lands.
function CHAT.refreshFriends(force)
	if CHAT.friendsBusy then return end
	if not force and CHAT.friendsLoaded and (os.clock() - (CHAT.friendsAt or 0)) < 120 then
		return
	end
	CHAT.friendsBusy = true
	task.spawn(function()
		local ids = {}
		local fetched = false
		pcall(function()
			local pages = Players:GetFriendsAsync(player.UserId)
			if not pages then return end
			while true do
				local items = pages:GetCurrentPage()
				for _, item in ipairs(items or {}) do
					local id = item.Id or item.UserId
					if id then ids[id] = true end
				end
				fetched = true
				if pages.IsFinished then break end
				pages:AdvanceToNextPageAsync()
			end
		end)
		CHAT.friendsBusy = false
		if not fetched then
			-- the friends endpoint can be blocked: ask about the people who are
			-- actually talking here instead, at most 30 of them
			local checked = 0
			for _, msg in ipairs(CHAT.messages) do
				if checked >= 30 then break end
				local uid = msg.userId
				if not msg.mine and uid and uid ~= player.UserId and ids[uid] == nil then
					checked = checked + 1
					local ok, isFriend = pcall(function()
						return player:IsFriendsWithAsync(uid)
					end)
					if ok and isFriend == true then ids[uid] = true end
				end
			end
			for _, msg in ipairs(CHAT.messages) do
				msg.friend = (not msg.mine and ids[msg.userId]) and true or nil
			end
			pcall(function() CHAT.onState() end)
			return
		end
		CHAT.friendIds = ids
		CHAT.friendsLoaded = true
		CHAT.friendsAt = os.clock()
		for _, msg in ipairs(CHAT.messages) do
			msg.friend = (not msg.mine and ids[msg.userId]) and true or nil
		end
		CHAT.onState()
	end)
end

-- 0 requests: remembers which message you are answering.
function CHAT.replyTo(msg)
	if not msg then return end
	CHAT.replyTarget = msg
	CHAT.onState()
end

function CHAT.clearReply()
	CHAT.replyTarget = nil
	CHAT.onState()
end

-- 0 requests: the language selector.
function CHAT.setSpeakLang(code)
	CHAT.speakLang = code or "auto"
	CHAT.onState()
end

-- 0 requests: works out what the next message should be sent as.
-- target = language code when it is known, inferFrom = the message whose
-- language has to be worked out by the single translation request.
function CHAT.outTarget()
	local reply = CHAT.replyTarget
	local speak = CHAT.speakLang or "auto"

	if speak ~= "auto" then
		if speak == "en" then return nil, nil end
		return speak, nil
	end
	if not reply then return nil, nil end

	local remembered = reply.lang or LANG.playerLang[reply.userId]
	if remembered then
		if remembered == "en" then return nil, nil end
		return remembered, nil
	end

	local guess, conf = LANG.detectLocal(reply.original)
	if guess ~= "en" and conf >= 2 then return guess, nil end
	return nil, reply.original
end

-- 0 or 1 request: returns the exact text to send, the language used, an error.
function CHAT.buildOutgoing(text, target, inferFrom)
	if inferFrom then
		local out, lang, err = API.translateLike(text, inferFrom)
		if out and out ~= "" then
			return out, lang or target, nil
		end
		return text, target, err
	end
	if not target or target == "en" then
		return text, "en", nil -- nothing to translate: no request
	end
	local guess = LANG.detectLocal(text)
	if guess == target then
		return text, target, nil -- already written in that language: no request
	end
	local out, err = LANG.translateTo(text, target)
	if out and out ~= "" then
		return out, target, nil
	end
	return text, target, err
end

-- 0 requests: puts our line in the panel and sends it exactly once.
function CHAT.dispatch(toSend, lang, channelName)
	toSend = trim(toSend)
	if toSend == "" then return false end

	local sig = tostring(player.UserId) .. "|" .. toSend

	CHAT.nextId = CHAT.nextId + 1
	local msg = {
		id = CHAT.nextId,
		playerName = localName(),
		userId = player.UserId,
		original = toSend,
		display = toSend,
		lang = lang,
		langHint = (lang and lang ~= "en") and lang or nil,
		state = "original",
		mine = true,
		sent = false,
		channel = channelName or "RBXGeneral",
		friend = false,
	}
	-- registered before SendAsync yields, so the echo the server sends back
	-- finds this row instead of adding a second copy of it
	CHAT.pendingEcho[sig] = { userId = player.UserId, msg = msg, t = os.clock() }

	CHAT.messages[#CHAT.messages + 1] = msg
	prune()
	CHAT.onNew(msg)

	local sent = false
	pcall(function()
		local channels = TextChatService.TextChannels
		local channel = (channelName and channels:FindFirstChild(channelName))
			or channels:FindFirstChild("RBXGeneral")
		if not channel then
			for _, child in ipairs(channels:GetChildren()) do
				if child:IsA("TextChannel") then
					channel = child
					break
				end
			end
		end
		if channel then
			channel:SendAsync(toSend)
			sent = true
		end
	end)
	if not sent then
		pcall(function()
			local rs = game:GetService("ReplicatedStorage")
			local events = rs:FindFirstChild("DefaultChatSystemChatEvents")
			local say = events and events:FindFirstChild("SayMessageRequest")
			if say then
				say:FireServer(toSend, "All")
				sent = true
			end
		end)
	end
	if not sent then
		CHAT.pendingEcho[sig] = nil
		msg.display = toSend .. "  (not sent - chat channel unavailable)"
		CHAT.onUpdate(msg)
		return false
	end
	msg.sent = true
	CHAT.onUpdate(msg)
	return true
end

-- Exactly one send per press: the guard is set before any yielding starts,
-- so a double Enter / a click on Send can never send the same line twice.
function CHAT.enqueueSend(text)
	text = trim(text)
	if text == "" then return false end
	if CHAT.sending then return false end

	local target, inferFrom = CHAT.outTarget()
	local reply = CHAT.replyTarget
	CHAT.sending = true
	CHAT.replyTarget = nil
	CHAT.onState()

	task.spawn(function()
		local ok, err = pcall(function()
			local toSend, usedLang, terr = CHAT.buildOutgoing(text, target, inferFrom)
			if terr then
				CHAT.notify(utf8.char(9888) .. " Could not translate to "
					.. LANG.displayName(usedLang) .. ": " .. tostring(terr))
			end
			if not CHAT.dispatch(toSend, usedLang, reply and reply.channel) then
				CHAT.notify(utf8.char(9888) .. " Message was not sent")
			end
			if reply and usedLang and usedLang ~= "en" then
				LANG.remember(reply.userId, usedLang)
			end
		end)
		if not ok and err then
			CHAT.notify(utf8.char(9888) .. " Send failed: " .. tostring(err))
		end
		CHAT.sending = false
		CHAT.onState()
	end)
	return true
end

-- 1 request the first time, 0 after (it just flips back to the original).
function CHAT.manualTranslate(msg)
	if not msg or msg.busy then return end

	if msg.translated then
		msg.state = (msg.state == "translated") and "original" or "translated"
		msg.err = nil
		CHAT.onUpdate(msg)
		return
	end

	local cached = LANG.detectCache[msg.original]
	if cached and cached.lang and cached.lang ~= "en" and cached.translation
		and cached.translation ~= msg.original then
		msg.lang = cached.lang
		msg.translated = cached.translation
		msg.state = "translated"
		msg.err = nil
		CHAT.onUpdate(msg)
		return
	end

	msg.busy = true
	CHAT.onUpdate(msg)

	task.spawn(function()
		local lang, translation, err = LANG.detectAndTranslate(msg.original) -- 1 request
		msg.busy = false
		if lang and lang ~= "" then
			msg.lang = lang
			LANG.remember(msg.userId, lang)
		end
		if translation and translation ~= "" and translation ~= msg.original then
			msg.translated = translation
			msg.state = "translated"
			msg.err = nil
		elseif lang == "en" then
			msg.state = "original"
			msg.err = nil
			CHAT.notify("That message is already English")
		else
			msg.state = "error"
			msg.err = err or "no translation returned"
			if err then API.report(err) end
		end
		CHAT.onUpdate(msg)
	end)
end

-- One listener only. Attaching both chat systems at once is what made every
-- line show up twice (and cost a translation request for each copy).
function CHAT.startListening()
	pcall(function()
		TextChatService.MessageReceived:Connect(function(textChatMessage)
			if not textChatMessage or not textChatMessage.TextSource then return end
			local src = textChatMessage.TextSource
			local plr = Players:GetPlayerByUserId(src.UserId)
			local name = plr and (plr.DisplayName or plr.Name) or ("User" .. tostring(src.UserId))
			local channelName = nil
			pcall(function()
				local textChannel = textChatMessage.TextChannel
				if textChannel then channelName = textChannel.Name end
			end)
			CHAT.pushMessage(name, src.UserId, textChatMessage.Text, channelName)
		end)
	end)

	CHAT.refreshFriends()

	local modern = true
	pcall(function()
		modern = TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
	end)
	if modern then return end

	pcall(function()
		local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
		if not chatEvents then return end
		local msgDone = chatEvents:FindFirstChild("OnMessageDoneFiltering")
		if not msgDone then return end
		msgDone.OnClientEvent:Connect(function(data)
			if type(data) ~= "table" or not data.Message or not data.FromSpeaker then return end
			CHAT.pushMessage(data.FromSpeaker, tonumber(data.SpeakerUserId) or 0, data.Message, "RBXGeneral")
		end)
	end)
end
--[[ CHAT_CORE_END ]]

-- ============================================================
-- CHAT PANEL
-- ============================================================
local function buildChatPanel()
	local chatPanel = Instance.new("Frame")
	chatPanel.Size = UDim2.fromOffset(340, 280)
	chatPanel.Position = UDim2.new(0.5, -170, 0.5, -140)
	chatPanel.BackgroundColor3 = BG
	chatPanel.Visible = false
	chatPanel.Parent = gui
	Instance.new("UICorner", chatPanel).CornerRadius = UDim.new(0, 12)
	Instance.new("UIStroke", chatPanel).Color = PURPLE

	local cHeader = Instance.new("Frame")
	cHeader.Size = UDim2.new(1, 0, 0, 40)
	cHeader.BackgroundColor3 = PANEL
	cHeader.BorderSizePixel = 0
	cHeader.Parent = chatPanel
	Instance.new("UICorner", cHeader).CornerRadius = UDim.new(0, 12)
	local cHeaderFix = Instance.new("Frame")
	cHeaderFix.Size = UDim2.new(1, 0, 0, 12)
	cHeaderFix.Position = UDim2.new(0, 0, 1, -12)
	cHeaderFix.BackgroundColor3 = PANEL
	cHeaderFix.BorderSizePixel = 0
	cHeaderFix.Parent = cHeader

	local cTitle = Instance.new("TextLabel")
	cTitle.BackgroundTransparency = 1
	cTitle.Size = UDim2.new(1, -110, 1, 0)
	cTitle.Position = UDim2.fromOffset(14, 0)
	cTitle.Font = Enum.Font.GothamBold
	cTitle.TextSize = 15
	cTitle.TextColor3 = PURPLE
	cTitle.TextXAlignment = Enum.TextXAlignment.Left
	cTitle.Text = "Chat + Translate"
	cTitle.Parent = cHeader

	local cClose = Instance.new("TextButton")
	cClose.Size = UDim2.fromOffset(48, 28)
	cClose.Position = UDim2.new(1, -56, 0.5, -14)
	cClose.BackgroundColor3 = PURPLE_DIM
	cClose.Text = "Close"
	cClose.TextSize = 12
	cClose.Font = Enum.Font.GothamBold
	cClose.TextColor3 = TEXT
	cClose.Parent = cHeader
	Instance.new("UICorner", cClose).CornerRadius = UDim.new(0, 6)

	-- tabs: which conversation the list shows --------------------------------
	local tabDefs = {
		{ key = "all", label = "All" },
		{ key = "global", label = "Global" },
		{ key = "friends", label = "Friends" },
	}
	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(1, -16, 0, 20)
	tabBar.Position = UDim2.fromOffset(8, 42)
	tabBar.BackgroundTransparency = 1
	tabBar.Parent = chatPanel
	local tabBtns = {}
	for i, def in ipairs(tabDefs) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1 / 3, -2, 1, 0)
		b.Position = UDim2.new((i - 1) / 3, 1, 0, 0)
		b.BackgroundColor3 = PANEL
		b.Text = def.label
		b.Font = Enum.Font.GothamBold
		b.TextSize = 11
		b.TextColor3 = MUTED
		b.Parent = tabBar
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		tabBtns[def.key] = b
		b.MouseButton1Click:Connect(function()
			CHAT.setTab(def.key)
			if def.key == "friends" then CHAT.refreshFriends() end
		end)
	end
	local function refreshTabBtns()
		for _, def in ipairs(tabDefs) do
			local b = tabBtns[def.key]
			local on = (CHAT.tab or "all") == def.key
			b.BackgroundColor3 = on and PURPLE_DIM or PANEL
			b.TextColor3 = on and TEXT or MUTED
		end
	end

	-- language selector bar -------------------------------------------------
	local langBar = Instance.new("Frame")
	langBar.Size = UDim2.new(1, -16, 0, 26)
	langBar.Position = UDim2.fromOffset(8, 66)
	langBar.BackgroundColor3 = PANEL
	langBar.Parent = chatPanel
	Instance.new("UICorner", langBar).CornerRadius = UDim.new(0, 7)

	local langPad = Instance.new("UIPadding")
	langPad.PaddingLeft = UDim.new(0, 8)
	langPad.PaddingRight = UDim.new(0, 4)
	langPad.Parent = langBar

	local langBtn = Instance.new("TextButton")
	langBtn.Size = UDim2.new(1, -34, 1, 0)
	langBtn.BackgroundTransparency = 1
	langBtn.Text = "Speak in: Auto"
	langBtn.TextXAlignment = Enum.TextXAlignment.Left
	langBtn.Font = Enum.Font.GothamBold
	langBtn.TextSize = 12
	langBtn.TextColor3 = PURPLE
	langBtn.Parent = langBar

	local langClear = Instance.new("TextButton")
	langClear.Size = UDim2.fromOffset(28, 22)
	langClear.Position = UDim2.new(1, -30, 0.5, -11)
	langClear.BackgroundColor3 = RED
	langClear.Text = "✖️"
	langClear.TextSize = 11
	langClear.Font = Enum.Font.GothamBold
	langClear.TextColor3 = TEXT
	langClear.Visible = false
	langClear.Parent = langBar
	Instance.new("UICorner", langClear).CornerRadius = UDim.new(0, 5)

	local langMenu = Instance.new("Frame")
	langMenu.Size = UDim2.new(1, -16, 1, -162)
	langMenu.Position = UDim2.fromOffset(8, 96)
	langMenu.BackgroundColor3 = PANEL
	langMenu.BorderSizePixel = 0
	langMenu.Visible = false
	langMenu.ZIndex = 20
	langMenu.Parent = chatPanel
	Instance.new("UICorner", langMenu).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", langMenu).Color = PURPLE

	local langSearch = Instance.new("TextBox")
	langSearch.Size = UDim2.new(1, -8, 0, 24)
	langSearch.Position = UDim2.fromOffset(4, 4)
	langSearch.BackgroundColor3 = BG
	langSearch.TextColor3 = TEXT
	langSearch.PlaceholderColor3 = MUTED
	langSearch.PlaceholderText = "Search languages (name or code)"
	langSearch.Font = Enum.Font.Gotham
	langSearch.TextSize = 12
	langSearch.Text = ""
	langSearch.ClearTextOnFocus = false
	langSearch.ZIndex = 22
	langSearch.Parent = langMenu
	Instance.new("UICorner", langSearch).CornerRadius = UDim.new(0, 6)

	local langScroll = Instance.new("ScrollingFrame")
	langScroll.Size = UDim2.new(1, -8, 1, -32)
	langScroll.Position = UDim2.fromOffset(4, 32)
	langScroll.BackgroundTransparency = 1
	langScroll.BorderSizePixel = 0
	langScroll.ScrollBarThickness = 4
	langScroll.ScrollBarImageColor3 = PURPLE
	langScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	langScroll.ZIndex = 21
	langScroll.Parent = langMenu

	local langLayout = Instance.new("UIListLayout")
	langLayout.Padding = UDim.new(0, 3)
	langLayout.SortOrder = Enum.SortOrder.LayoutOrder
	langLayout.Parent = langScroll
	langLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		langScroll.CanvasSize = UDim2.new(0, 0, 0, langLayout.AbsoluteContentSize.Y + 6)
	end)

	-- messages -------------------------------------------------------------
	local chatScroll = Instance.new("ScrollingFrame")
	chatScroll.Size = UDim2.new(1, -16, 1, -162)
	chatScroll.Position = UDim2.fromOffset(8, 96)
	chatScroll.BackgroundTransparency = 1
	chatScroll.BorderSizePixel = 0
	chatScroll.ScrollBarThickness = 4
	chatScroll.ScrollBarImageColor3 = PURPLE
	chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	chatScroll.Parent = chatPanel
	local chatLayout = Instance.new("UIListLayout")
	chatLayout.Padding = UDim.new(0, 6)
	chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
	chatLayout.Parent = chatScroll
	chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		chatScroll.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y + 8)
		chatScroll.CanvasPosition = Vector2.new(0, math.max(0, chatLayout.AbsoluteContentSize.Y - chatScroll.AbsoluteSize.Y))
	end)

	local replyBar = Instance.new("Frame")
	replyBar.Size = UDim2.new(1, -16, 0, 56)
	replyBar.Position = UDim2.new(0, 8, 1, -64)
	replyBar.BackgroundColor3 = PANEL
	replyBar.Parent = chatPanel
	Instance.new("UICorner", replyBar).CornerRadius = UDim.new(0, 8)

	local replyHint = Instance.new("TextLabel")
	replyHint.BackgroundTransparency = 1
	replyHint.Size = UDim2.new(1, -16, 0, 14)
	replyHint.Position = UDim2.fromOffset(8, 2)
	replyHint.Font = Enum.Font.Gotham
	replyHint.TextSize = 10
	replyHint.TextColor3 = MUTED
	replyHint.TextXAlignment = Enum.TextXAlignment.Left
	replyHint.TextTruncate = Enum.TextTruncate.AtEnd
	replyHint.Text = "Type message..."
	replyHint.Parent = replyBar

	local replyBox = Instance.new("TextBox")
	replyBox.Size = UDim2.new(1, -70, 0, 28)
	replyBox.Position = UDim2.fromOffset(8, 20)
	replyBox.BackgroundColor3 = BG
	replyBox.TextColor3 = TEXT
	replyBox.PlaceholderColor3 = MUTED
	replyBox.PlaceholderText = "Say something..."
	replyBox.Font = Enum.Font.Gotham
	replyBox.TextSize = 13
	replyBox.Text = ""
	replyBox.ClearTextOnFocus = false
	replyBox.Parent = replyBar
	Instance.new("UICorner", replyBox).CornerRadius = UDim.new(0, 6)

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.fromOffset(50, 28)
	sendBtn.Position = UDim2.new(1, -58, 0, 20)
	sendBtn.BackgroundColor3 = PURPLE
	sendBtn.Text = "Send"
	sendBtn.Font = Enum.Font.GothamBold
	sendBtn.TextSize = 12
	sendBtn.TextColor3 = TEXT
	sendBtn.Parent = replyBar
	Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 6)

	local function setChatOpen(state)
		chatOpen = state
		chatPanel.Visible = chatOpen
		chatBtn.BackgroundColor3 = chatOpen and PURPLE_DIM or PURPLE
		if not chatOpen then langMenu.Visible = false end
	end
	chatBtn.MouseButton1Click:Connect(function()
		setChatOpen(not chatOpen)
	end)
	cClose.MouseButton1Click:Connect(function()
		setChatOpen(false)
	end)
	makeDraggable(cHeader, chatPanel)

	-- one place that decides what the language bar and hint say
	local function refreshLangBar()
		local reply = CHAT.replyTarget
		if reply then
			local code = reply.lang or LANG.playerLang[reply.userId]
			local conf = 0
			if not code then
				local guess, c = LANG.detectLocal(reply.original)
				conf = c
				if guess ~= "en" and c >= 2 then code = guess end
			end
			if (CHAT.speakLang or "auto") ~= "auto" then
				langBtn.Text = "Speak in: " .. LANG.displayName(CHAT.speakLang) .. " 🔽"
			elseif code then
				langBtn.Text = "Reply in: " .. LANG.displayName(code) .. " 🔽"
			else
				langBtn.Text = "Reply in: their language  🔽"
			end
			local hint = "Replying to " .. reply.playerName
			if code and code ~= "en" then
				hint = hint .. " in " .. LANG.displayName(code)
			end
			replyHint.Text = hint .. " - 1 request when you send"
			replyHint.TextColor3 = ON
		elseif (CHAT.speakLang or "auto") == "auto" then
			langBtn.Text = "Speak in: Auto (as typed)  🔽"
			replyHint.Text = "Type message (tap a line to reply, 🌐 to translate)"
			replyHint.TextColor3 = MUTED
		else
			langBtn.Text = "Speak in: " .. LANG.displayName(CHAT.speakLang) .. " 🔽"
			replyHint.Text = "Your text will be translated to " .. LANG.displayName(CHAT.speakLang)
			replyHint.TextColor3 = MUTED
		end
		langClear.Visible = reply ~= nil
	end

	local function refreshSendUi()
		if CHAT.sending then
			sendBtn.Text = "…"
			sendBtn.BackgroundColor3 = OFF
		else
			sendBtn.Text = "Send"
			sendBtn.BackgroundColor3 = PURPLE
		end
	end

	-- repaint a row from its stored state (no requests happen here)
	local function paintRow(msg)
		if msg._nameLbl then
			local tag = msg.lang or msg.langHint
			local bits = {}
			if msg.mine then
				if msg.sent == true then
					bits[#bits + 1] = "(sent)"
				elseif msg.sent == false then
					bits[#bits + 1] = "(sending…)"
				end
			elseif tag and tag ~= "en" then
				bits[#bits + 1] = "[" .. LANG.displayName(tag) .. "]"
			end
			if msg.channel and msg.channel ~= "" and msg.channel ~= "RBXGeneral" then
				bits[#bits + 1] = "(" .. tostring(msg.channel) .. ")"
			end
			local suffix = (#bits > 0) and ("  " .. table.concat(bits, " ")) or ""
			msg._nameLbl.Text = (msg.friend and "⭐ " or "") .. msg.playerName .. suffix
		end
		if msg._textLbl then
			if msg.state == "translated" and msg.translated then
				msg._textLbl.Text = msg.translated
				msg._textLbl.TextColor3 = TEXT
			elseif msg.state == "error" then
				msg._textLbl.Text = msg.original .. "\n" .. utf8.char(9888) .. " " .. (msg.err or "translation failed")
				msg._textLbl.TextColor3 = RED
			else
				msg._textLbl.Text = msg.display
				msg._textLbl.TextColor3 = TEXT
			end
		end
		if msg._trBtn then
			if msg.busy then
				msg._trBtn.Text = "..."
			elseif msg.state == "translated" then
				msg._trBtn.Text = "🔁"
			else
				msg._trBtn.Text = "🌐"
			end
		end
	end

	local function addMessageRow(msg)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -4, 0, 0)
		row.AutomaticSize = Enum.AutomaticSize.Y
		row.BackgroundColor3 = PANEL
		row.Parent = chatScroll
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local pad = Instance.new("UIPadding", row)
		pad.PaddingTop = UDim.new(0, 6)
		pad.PaddingBottom = UDim.new(0, 6)
		pad.PaddingLeft = UDim.new(0, 8)
		pad.PaddingRight = UDim.new(0, 8)

		local nameLbl = Instance.new("TextLabel")
		nameLbl.BackgroundTransparency = 1
		nameLbl.Size = UDim2.new(1, -70, 0, 16)
		nameLbl.Font = Enum.Font.GothamBold
		nameLbl.TextSize = 12
		nameLbl.TextColor3 = PURPLE
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
		nameLbl.Parent = row

		local textLbl = Instance.new("TextLabel")
		textLbl.BackgroundTransparency = 1
		textLbl.Size = UDim2.new(1, 0, 0, 0)
		textLbl.AutomaticSize = Enum.AutomaticSize.Y
		textLbl.Position = UDim2.fromOffset(0, 18)
		textLbl.Font = Enum.Font.Gotham
		textLbl.TextSize = 13
		textLbl.TextColor3 = TEXT
		textLbl.TextXAlignment = Enum.TextXAlignment.Left
		textLbl.TextWrapped = true
		textLbl.Parent = row

		msg._row = row
		msg._nameLbl = nameLbl
		msg._textLbl = textLbl

		local trBtn = Instance.new("TextButton")
		trBtn.Size = UDim2.fromOffset(28, 22)
		trBtn.Position = UDim2.new(1, -60, 0, 0)
		trBtn.BackgroundColor3 = PURPLE_DIM
		trBtn.Text = "🌐"
		trBtn.TextSize = 12
		trBtn.Font = Enum.Font.GothamBold
		trBtn.TextColor3 = TEXT
		trBtn.Parent = row
		Instance.new("UICorner", trBtn).CornerRadius = UDim.new(0, 4)
		msg._trBtn = trBtn

		local rpBtn = Instance.new("TextButton")
		rpBtn.Size = UDim2.fromOffset(28, 22)
		rpBtn.Position = UDim2.new(1, -28, 0, 0)
		rpBtn.BackgroundColor3 = PURPLE_DIM
		rpBtn.Text = "↩️"
		rpBtn.TextSize = 12
		rpBtn.Font = Enum.Font.GothamBold
		rpBtn.TextColor3 = TEXT
		rpBtn.Parent = row
		Instance.new("UICorner", rpBtn).CornerRadius = UDim.new(0, 4)

		trBtn.MouseButton1Click:Connect(function()
			CHAT.manualTranslate(msg)
		end)

		rpBtn.MouseButton1Click:Connect(function()
			if msg.mine then
				CHAT.notify("Pick somebody else's line to reply to")
				return
			end
			CHAT.replyTo(msg)
			setChatOpen(true)
			replyBox:CaptureFocus()
		end)

		row.Visible = CHAT.isVisible(msg)
		paintRow(msg)
		return row
	end

	local function applyTabFilter()
		for _, msg in ipairs(CHAT.messages) do
			if msg._row then msg._row.Visible = CHAT.isVisible(msg) end
		end
	end

	CHAT.onNew = function(msg)
		addMessageRow(msg)
		applyTabFilter()
	end
	CHAT.onUpdate = paintRow
	CHAT.onState = function()
		refreshLangBar()
		refreshSendUi()
		refreshTabBtns()
		applyTabFilter()
	end
	CHAT.notify = function(text)
		showToast(text, 7)
	end

	-- language menu --------------------------------------------------------
	local function setLangMenu(open)
		langMenu.Visible = open
		if open then
			langScroll.CanvasPosition = Vector2.new(0, 0)
		end
	end

		local langRows = {}
	local function addLangRow(text, code)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -4, 0, 28)
		b.BackgroundColor3 = BG
		b.TextColor3 = TEXT
		b.Font = Enum.Font.Gotham
		b.TextSize = 12
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.Text = "  " .. text
		b.ZIndex = 22
		b.Parent = langScroll
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		langRows[#langRows + 1] = b
		b.MouseButton1Click:Connect(function()
			CHAT.setSpeakLang(code)
			setLangMenu(false)
		end)
		return b
	end

	local langEntries = {
		{ text = "Auto - match the language of the line I reply to", code = "auto" },
		{ text = "English (send as typed, no translation)", code = "en" },
	}
	local langOrder = {}
	for code, name in pairs(LANG.names) do
		if code ~= "en" then
			langOrder[#langOrder + 1] = { code = code, name = name }
		end
	end
	table.sort(langOrder, function(a, b)
		return string.lower(a.name) < string.lower(b.name)
	end)
	for _, entry in ipairs(langOrder) do
		langEntries[#langEntries + 1] = { text = entry.name, code = entry.code }
	end

	local function renderLangRows(filter)
		for _, b in ipairs(langRows) do b:Destroy() end
		langRows = {}
		filter = string.lower(trim(filter or ""))
		local shown = 0
		for _, entry in ipairs(langEntries) do
			if filter == "" or string.find(string.lower(entry.text), filter, 1, true)
				or string.lower(entry.code) == filter then
				addLangRow(entry.text, entry.code)
				shown = shown + 1
			end
		end
		if shown == 0 then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -4, 0, 28)
			b.BackgroundColor3 = BG
			b.TextColor3 = MUTED
			b.Font = Enum.Font.Gotham
			b.TextSize = 12
			b.TextXAlignment = Enum.TextXAlignment.Left
			b.Text = "  No language matches that"
			b.ZIndex = 22
			b.Parent = langScroll
			langRows[#langRows + 1] = b
		end
		langScroll.CanvasSize = UDim2.new(0, 0, 0, langLayout.AbsoluteContentSize.Y + 6)
	end
	renderLangRows("")
	langSearch:GetPropertyChangedSignal("Text"):Connect(function()
		renderLangRows(langSearch.Text)
	end)

	langBtn.MouseButton1Click:Connect(function()
		setLangMenu(not langMenu.Visible)
	end)
	langClear.MouseButton1Click:Connect(function()
		setLangMenu(false)
		CHAT.clearReply()
	end)

	-- input ----------------------------------------------------------------
	local function takeInput()
		if CHAT.sending then
			CHAT.notify("Still sending the previous message", 3)
			return
		end
		local text = replyBox.Text
		if not text or not text:match("%S") then return end
		-- clear first, so a second Enter cannot send the same line again
		replyBox.Text = ""
		CHAT.enqueueSend(text)
	end

	sendBtn.MouseButton1Click:Connect(takeInput)
	replyBox.FocusLost:Connect(function(enter)
		if enter then takeInput() end
	end)

	CHAT.startListening()
	refreshLangBar()
	refreshSendUi()
end
buildChatPanel()

-- initial UI state
refreshUiToggles()
refreshTornadoBtns()
