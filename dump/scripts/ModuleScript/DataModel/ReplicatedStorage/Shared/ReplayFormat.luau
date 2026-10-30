-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = { Stunned = true, Reflecting = true, ClientReflecting = true }

local module: {[any]: any} = {
	MAGIC = 1347568717,
	FORMAT_VERSION = 7,
	MIN_FORMAT_VERSION = 5,
	HEADER_BYTES = 116,
	SAMPLE_STRIDE = 18,
	MATCHID_BYTES = 36,
	BASE_RATE_HZ = 20,
	OVERLAY_RATE_HZ = 60,
	MAX_RECORD_SECONDS = 1200,
	OVERLAY_BUDGET_RATIO = 0.3,
	FLAG_TRUNCATED = 1,
	FLAG_HAS_BOTS = 2,
	FLAG_PRESERVE_EVIDENCE = 4,
	FLAG_HAS_OVERLAY = 8,
	FLAG_OVERLAY_EXHAUSTED = 16,
	FLAG_ROUND_SLICE = 32,
	S_ALIVE = 1,
	S_GROUNDED = 2,
	S_DISCONTINUITY = 4,
	S_WEAPON_MASK = 24,
	S_WEAPON_SHIFT = 3,
	S_FIRING = 32,
	WEAPON_NONE = 0,
	WEAPON_KNIFE = 1,
	WEAPON_REVOLVER = 2,
	STATE_NONE = 0,
	STATE_CROUCHING = 1,
	STATE_SLIDING = 2,
	STATE_AIRBORNE = 3,
	STATE_RESERVED_BASE = 32,
	EV_SHOT = 1,
	EV_KNIFE_THROW = 2,
	EV_HIT = 3,
	EV_DEATH = 4,
	EV_ABILITY_CAST = 5,
	EV_ABILITY_EFFECT = 6,
	EV_ROUND_START = 7,
	EV_ROUND_END = 8,
	EV_SPAWN = 9,
	EV_RELOAD = 10,
	EV_MAP_PING = 11,
	EV_FINISHER = 12,
	EV_REMOTE = 13,
	EV_ANIM_START = 14,
	EV_ANIM_STOP = 15,
	EV_ATTR = 16,
	MK_KILL = 1,
	MK_MULTIKILL = 2,
	MK_ROUND_WIN = 3,
	MK_ROUND_START = 4,
	MK_ABILITY = 5,
	MK_CLUTCH = 6,
	MK_MATCH_POINT = 7,
	TRIG_KILL = 1,
	TRIG_ABILITY = 2,
	TRIG_TRUST_FLAGGED = 3,
	TRIG_MANUAL = 4,
	NO_SLOT = 255,
	IsTimeAttr = function(p1)
		if t1[p1] then
			return true
		end

		return string.match(p1, "ExpiresAt$") ~= nil
	end
}

local function versionError(p2)
	if p2 > module.FORMAT_VERSION then
		return string.format("formatVersion %d is newer than this decoder (%d)", p2, module.FORMAT_VERSION)
	end

	if p2 < module.MIN_FORMAT_VERSION then
		return string.format("formatVersion %d predates the current sample layout (min %d) -- re-record", p2, module.MIN_FORMAT_VERSION)
	end

	return nil
end
local function clampI16(p3)
	return (math.clamp(p3, -32768, 32767))
end
function module.encodePos(p4)
	local rounded = math.round(p4 * 16)

	return (math.clamp(rounded, -32768, 32767))
end
function module.decodePos(p5)
	return p5 / 16
end
function module.encodeYaw(p6)
	local rounded = math.round(((p6 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 10430.378350470453)

	return (math.clamp(rounded, -32768, 32767))
end
function module.decodeYaw(p7)
	return p7 / 10430.378350470453
end
function module.encodePitch(p8)
	local v30 = math.clamp(p8, -1.5707963267948966, 1.5707963267948966)
	local rounded = math.round(v30 * 20860.120081168538)

	return (math.clamp(rounded, -32768, 32767))
end
function module.decodePitch(p9)
	return p9 / 20860.120081168538
end

module.POS_TOLERANCE = 0.03125
module.YAW_TOLERANCE = 0.000047936899621426287
module.PITCH_TOLERANCE = 0.000023969181292075817

local writer: {[any]: any} = {}

writer.__index = writer

function module.newWriter(p10)
	assert(#p10.matchId == module.MATCHID_BYTES, string.format("matchId must be %d chars, got %d", module.MATCHID_BYTES, #p10.matchId))
	assert(p10.playerCount > 0 and p10.playerCount <= 255, "playerCount out of range")

	local v34 = p10.sampleRateHz or module.BASE_RATE_HZ
	local roundedUp = math.ceil((p10.maxSeconds or module.MAX_RECORD_SECONDS) * v34)
	local n1 = roundedUp * p10.playerCount * module.SAMPLE_STRIDE
	local matchId = p10.matchId
	local mode = p10.mode
	local playerCount = p10.playerCount
	local origin = p10.origin
	local startedAt = p10.startedAt
	local buildVersion = p10.buildVersion
	local v43 = p10.mapName or ""
	local v44 = p10.mapImage or ""
	local v45 = buffer.create(n1)

	return (setmetatable({
		sampleCount = 0,
		overlayUsed = 0,
		overlayExhausted = false,
		flags = 0,
		durationMs = 0,
		matchId = matchId,
		mode = mode,
		playerCount = playerCount,
		origin = origin,
		startedAt = startedAt,
		buildVersion = buildVersion,
		mapName = v43,
		mapImage = v44,
		sampleRateHz = v34,
		maxSamples = roundedUp,
		sampleBuf = v45,
		participants = {},
		rounds = {},
		events = {},
		markers = {},
		windows = {},
		overlayBudget = p10.overlayBudget or math.floor(n1 * module.OVERLAY_BUDGET_RATIO),
		sampleBase = p10.sampleBase or 0,
		roundNumber = p10.roundNumber or 0,
		parentRounds = p10.parentRounds or 0
	}, writer))
end
function writer.setFlag(p11, p12, p13)
	if p13 == false then
		local flags = p11.flags
		local v50 = bit32.bnot(p12)

		p11.flags = bit32.band(flags, v50)

		return
	end

	p11.flags = bit32.bor(p11.flags, p12)
end
function writer.addParticipant(p14, p15)
	assert(p15.slot >= 0 and p15.slot < p14.playerCount, "participant slot out of range")
	table.insert(p14.participants, p15)
end
function writer.addRound(p16, p17)
	table.insert(p16.rounds, p17)
end
function writer.extendLastRound(p18, p19)
	local v57 = p18.rounds[#p18.rounds]

	if v57 and p19 > v57.endSample then
		v57.endSample = p19
	end
end
function writer.addEvent(p20, p21)
	table.insert(p20.events, p21)
end
function writer.addMarker(p22, p23)
	table.insert(p22.markers, p23)
end
function writer.writeSample(p24, p25, p26, p27)
	if p25 >= p24.maxSamples then
		p24:setFlag(module.FLAG_TRUNCATED)

		return
	end

	local n1 = (p25 * p24.playerCount + p26) * module.SAMPLE_STRIDE
	local sampleBuf = p24.sampleBuf
	local v68 = module.encodePos(p27.x - p24.origin.X)

	buffer.writei16(sampleBuf, n1 + 0, v68)
	v68 = module.encodePos(p27.y - p24.origin.Y)
	buffer.writei16(sampleBuf, n1 + 2, v68)
	v68 = module.encodePos(p27.z - p24.origin.Z)
	buffer.writei16(sampleBuf, n1 + 4, v68)
	v68 = module.encodeYaw(p27.yaw)
	buffer.writei16(sampleBuf, n1 + 6, v68)
	v68 = module.encodePitch(p27.pitch)
	buffer.writei16(sampleBuf, n1 + 8, v68)
	v68 = module.encodeYaw(p27.camYaw or p27.yaw)
	buffer.writei16(sampleBuf, n1 + 10, v68)
	v68 = module.encodeYaw(p27.bodyPitch or 0)
	buffer.writei16(sampleBuf, n1 + 12, v68)
	v68 = module.encodeYaw(p27.bodyRoll or 0)
	buffer.writei16(sampleBuf, n1 + 14, v68)
	buffer.writeu8(sampleBuf, n1 + 16, p27.state)
	buffer.writeu8(sampleBuf, n1 + 17, p27.sflags)

	if p25 + 1 > p24.sampleCount then
		p24.sampleCount = p25 + 1
	end
end
function writer.addOverlayWindow(p28, p29)
	local n1 = #p29.slots + 16 + #p29.samples * #p29.slots * module.SAMPLE_STRIDE

	if p28.overlayUsed + n1 > p28.overlayBudget then
		p28.overlayExhausted = true
		p28:setFlag(module.FLAG_OVERLAY_EXHAUSTED)

		return false
	end

	p28.overlayUsed = p28.overlayUsed + n1
	table.insert(p28.windows, p29)

	return true
end
function writer.latestWindowEndMs(p30, p31)
	local t5: {[any]: any} = {}

	for _, v in ipairs(p31) do
		t5[v] = true
	end

	local endMs = nil

	for _, v in ipairs(p30.windows) do
		for _, iterValue in ipairs(v.slots) do
			if t5[iterValue] then
				if endMs ~= nil and not (endMs < v.endMs) then
					break
				end

				endMs = v.endMs

				break
			end
		end
	end

	return endMs
end
function writer.clearWindowRange(p32, p33, p34)
	local overlay_rate_hz = module.OVERLAY_RATE_HZ
	local n1: number = 0
	local n2: number = 0
	local t6: {[any]: any} = {}
	local n3 = 1000 / p32.sampleRateHz

	for _, v in ipairs(p32.windows) do
		local function costOf(p35)
			return #p35.slots + 16 + #p35.samples * #p35.slots * module.SAMPLE_STRIDE
		end

		local u93: boolean = p34 < v.endMs

		if p33 > v.endMs or p34 < v.startMs then
			table.insert(t6, v)
		elseif p33 > v.startMs then
			if u93 then
				warn(string.format("[ReplayFormat] window [%d,%d] spans both edges of the cleared range [%d,%d]; keeping the head only", v.startMs, v.endMs, p33, p34))
			end

			local n4 = p33 - 1

			if n4 <= v.startMs then
				p32.overlayUsed = p32.overlayUsed - (#v.slots + 16 + #v.samples * #v.slots * module.SAMPLE_STRIDE)
				n1 += 1
			else
				local floored = math.floor((n4 - v.startMs) * overlay_rate_hz / 1000)
				local v96 = math.clamp(floored + 2, 1, #v.samples)

				if v96 < #v.samples then
					p32.overlayUsed = p32.overlayUsed - (#v.samples - v96) * #v.slots * module.SAMPLE_STRIDE

					for i = #v.samples, v96 + 1, -1 do
						v.samples[i] = nil
					end
				end

				v.endMs = n4
				n2 += 1
				table.insert(t6, v)
			end
		elseif u93 then
			local n5 = p34 + n3
			local floored = math.floor((n5 - v.startMs) * overlay_rate_hz / 1000)

			if floored >= #v.samples - 1 then
				p32.overlayUsed = p32.overlayUsed - (#v.slots + 16 + #v.samples * #v.slots * module.SAMPLE_STRIDE)
				n1 += 1
			else
				p32.overlayUsed = p32.overlayUsed - floored * #v.slots * module.SAMPLE_STRIDE
				table.move(v.samples, floored + 1, #v.samples, 1)

				for i = #v.samples, #v.samples - floored + 1, -1 do
					v.samples[i] = nil
				end

				v.startMs = n5
				n2 += 1
				table.insert(t6, v)
			end
		else
			p32.overlayUsed = p32.overlayUsed - (#v.slots + 16 + #v.samples * #v.slots * module.SAMPLE_STRIDE)
			n1 += 1
		end
	end

	p32.windows = t6

	if p32.overlayUsed < p32.overlayBudget then
		p32.overlayExhausted = false
		p32:setFlag(module.FLAG_OVERLAY_EXHAUSTED, false)
	end

	return n1, n2
end
function writer._mergeWindows(p36)
	table.sort(p36.windows, function(p37, p38)
		if p37.startMs ~= p38.startMs then
			return p37.startMs < p38.startMs
		end

		return p37.slots[1] < p38.slots[1]
	end)

	local t7: {[any]: any} = {}

	for _, v in ipairs(p36.windows) do
		for _, iterValue in ipairs(v.slots) do
			t7[iterValue] = t7[iterValue] or {}
			table.insert(t7[iterValue], v)
		end
	end

	for k, v in pairs(t7) do
		for i = 1, #v - 1 do
			local v110 = v[i]
			local v111 = v[i + 1]

			if v110 and v111 and v111.startMs <= v110.endMs then
				warn(string.format("[ReplayFormat] overlapping overlay windows on slot %d: [%d,%d] and [%d,%d]", k, v110.startMs, v110.endMs, v111.startMs, v111.endMs))
			end
		end
	end
end
local function strBytes(p39)
	return math.min(#p39, 255) + 1
end
local function writeStr(p40, p41, p42)
	local v116 = math.min(#p42, 255)

	buffer.writeu8(p40, p41, v116)

	if v116 > 0 then
		buffer.writestring(p40, p41 + 1, p42, v116)
	end

	return p41 + 1 + v116
end
local function readStr(p43, p44)
	local v119 = buffer.readu8(p43, p44)

	if v119 == 0 then
		return "", p44 + 1
	end

	return buffer.readstring(p43, p44 + 1, v119), p44 + 1 + v119
end
local function strBytesWide(p45)
	return math.min(#p45, 65535) + 2
end
local function writeStrWide(p46, p47, p48)
	local v124 = math.min(#p48, 65535)

	buffer.writeu16(p46, p47, v124)

	if v124 > 0 then
		buffer.writestring(p46, p47 + 2, p48, v124)
	end

	return p47 + 2 + v124
end
local function readStrWide(p49, p50)
	local v127 = buffer.readu16(p49, p50)

	if v127 == 0 then
		return "", p50 + 2
	end

	return buffer.readstring(p49, p50 + 2, v127), p50 + 2 + v127
end

local v12 = table.freeze({})

function writer.finalize(p51)
	p51:_mergeWindows()

	local playerCount = p51.playerCount
	local sampleCount = p51.sampleCount

	p51.durationMs = math.floor(sampleCount / p51.sampleRateHz * 1000)

	local n1 = 0

	for _, v in ipairs(p51.participants) do
		local v134 = math.min(#v.displayName, 255)
		local v135 = math.min(#v.knifeId, 255)
		local v136 = math.min(#v.revolverId, 255)
		local n2 = n1 + 11 + (v134 + 1 + (v135 + 1) + (v136 + 1)) + 1

		for _, iterValue in ipairs(v.abilities) do
			local v140 = math.min(#iterValue, 255)

			n2 += v140 + 1
		end

		local v141 = math.min(#(v.crosshair or ""), 65535)
		local v142 = math.min(#(v.device or ""), 255)

		n1 = n2 + (v141 + 2) + (v142 + 1)
	end

	local v143 = math.min(#p51.mapName, 255)
	local v144 = math.min(#p51.mapImage, 255)
	local n3 = v143 + 1 + 1 + (v144 + 1)

	for _, _ in ipairs(p51.rounds) do
		n3 += 10 + playerCount
	end

	local n4 = sampleCount * playerCount * module.SAMPLE_STRIDE
	local n5 = 4

	for _, v in ipairs(p51.events) do
		n5 += #v.payload + 9
	end

	local n6 = 4

	for _, v in ipairs(p51.markers) do
		local v155 = math.min(#v.label, 255)

		n6 = n6 + (v155 + 1 + 7) + (#(v.assistSlots or v12) + 1)
	end

	v144 = #p51.windows > 0

	local n7 = 0

	if v144 then
		n7 = 4

		for _, v in ipairs(p51.windows) do
			n7 = n7 + (#v.slots + 20) + #v.samples * #v.slots * module.SAMPLE_STRIDE
		end
	end

	local header_bytes = module.HEADER_BYTES
	local n8 = header_bytes + n1

	n1 = n8 + n3
	n3 = n1 + n4

	local n9 = n3 + n5

	n5 = v144 and n9 + n6 or 0

	local n10 = n9 + n6 + n7

	n7 = buffer.create(n10)

	if v144 then
		p51:setFlag(module.FLAG_HAS_OVERLAY)
	end

	buffer.writeu32(n7, 0, module.MAGIC)
	buffer.writeu8(n7, 4, module.FORMAT_VERSION)
	buffer.writeu8(n7, 5, p51.flags)
	buffer.writeu16(n7, 6, module.HEADER_BYTES)
	buffer.writeu32(n7, 8, p51.buildVersion)
	buffer.writeu8(n7, 12, p51.mode)
	buffer.writeu8(n7, 13, playerCount)
	buffer.writeu8(n7, 14, #p51.rounds)
	buffer.writeu8(n7, 15, p51.sampleRateHz)
	buffer.writeu32(n7, 16, sampleCount)
	buffer.writef32(n7, 20, p51.origin.X)
	buffer.writef32(n7, 24, p51.origin.Y)
	buffer.writef32(n7, 28, p51.origin.Z)
	buffer.writeu32(n7, 32, p51.startedAt)
	buffer.writeu32(n7, 36, p51.durationMs)
	buffer.writeu32(n7, 40, header_bytes)
	buffer.writeu32(n7, 44, n8)
	buffer.writeu32(n7, 48, n1)
	buffer.writeu32(n7, 52, n3)
	buffer.writeu32(n7, 56, n9)
	buffer.writeu32(n7, 60, n5)
	buffer.writeu32(n7, 64, n10)
	buffer.writeu8(n7, 68, module.OVERLAY_RATE_HZ)
	buffer.writestring(n7, 72, p51.matchId, module.MATCHID_BYTES)
	buffer.writeu32(n7, 108, p51.sampleBase)
	buffer.writeu8(n7, 112, p51.roundNumber)
	buffer.writeu8(n7, 113, p51.parentRounds)
	n10 = header_bytes

	for _, v in ipairs(p51.participants) do
		buffer.writef64(n7, n10, v.userId)

		local n11 = n10 + 8

		buffer.writeu8(n7, n11, v.slot)

		local n12 = n11 + 1

		buffer.writeu8(n7, n12, v.side)
		n11 = n12 + 1
		buffer.writeu8(n7, n11, v.pflags)

		local n13 = n11 + 1
		local vDisplayName = v.displayName
		local v169 = math.min(#vDisplayName, 255)

		buffer.writeu8(n7, n13, v169)

		if v169 > 0 then
			buffer.writestring(n7, n13 + 1, vDisplayName, v169)
		end

		local n14 = n13 + 1 + v169
		local vKnifeId = v.knifeId
		local v172 = math.min(#vKnifeId, 255)

		buffer.writeu8(n7, n14, v172)

		if v172 > 0 then
			buffer.writestring(n7, n14 + 1, vKnifeId, v172)
		end

		n13 = n14 + 1 + v172

		local vRevolverId = v.revolverId
		local v174 = math.min(#vRevolverId, 255)

		buffer.writeu8(n7, n13, v174)

		if v174 > 0 then
			buffer.writestring(n7, n13 + 1, vRevolverId, v174)
		end

		n12 = n13 + 1 + v174
		buffer.writeu8(n7, n12, #v.abilities)
		n11 = n12 + 1

		for _, iterValue2 in ipairs(v.abilities) do
			local n15 = n11
			local v178 = math.min(#iterValue2, 255)

			buffer.writeu8(n7, n15, v178)

			if v178 > 0 then
				buffer.writestring(n7, n15 + 1, iterValue2, v178)
			end

			n11 = n15 + 1 + v178
		end

		n14 = n11

		local v179 = v.crosshair or ""
		local v180 = math.min(#v179, 65535)

		buffer.writeu16(n7, n14, v180)

		if v180 > 0 then
			buffer.writestring(n7, n14 + 2, v179, v180)
		end

		n13 = n14 + 2 + v180
		v179 = v.device or ""
		v180 = math.min(#v179, 255)
		buffer.writeu8(n7, n13, v180)

		if v180 > 0 then
			buffer.writestring(n7, n13 + 1, v179, v180)
		end

		n10 = n13 + 1 + v180
	end

	local n16 = n8
	local mapName = p51.mapName

	n8 = math.min(#mapName, 255)
	buffer.writeu8(n7, n16, n8)

	if n8 > 0 then
		buffer.writestring(n7, n16 + 1, mapName, n8)
	end

	local n17 = n16 + 1 + n8
	local mapImage = p51.mapImage
	local v185 = math.min(#mapImage, 255)

	buffer.writeu8(n7, n17, v185)

	if v185 > 0 then
		buffer.writestring(n7, n17 + 1, mapImage, v185)
	end

	n10 = n17 + 1 + v185
	buffer.writeu8(n7, n10, #p51.rounds)

	local n18 = n10 + 1

	for _, v in ipairs(p51.rounds) do
		buffer.writeu32(n7, n18, v.startSample)

		local n19 = n18 + 4

		buffer.writeu32(n7, n19, v.endSample)

		local n20 = n19 + 4

		buffer.writeu8(n7, n20, v.winnerSide)
		n19 = n20 + 1
		buffer.writeu8(n7, n19, v.rflags)
		n18 = n19 + 1

		for i = 0, playerCount - 1 do
			local v192 = math.min(v.kills[i] or 0, 255)

			buffer.writeu8(n7, n18, v192)
			n18 += 1
		end
	end

	if n4 > 0 then
		buffer.copy(n7, n1, p51.sampleBuf, 0, n4)
	end

	n18 = n3
	buffer.writeu32(n7, n18, #p51.events)
	n10 = n18 + 4

	for _, v in ipairs(p51.events) do
		buffer.writeu32(n7, n10, v.timeMs)

		local n21 = n10 + 4

		buffer.writeu8(n7, n21, v.etype)

		local n22 = n21 + 1

		buffer.writeu8(n7, n22, v.actorSlot)
		n21 = n22 + 1
		buffer.writeu8(n7, n21, v.targetSlot)
		n22 = n21 + 1
		buffer.writeu16(n7, n22, #v.payload)
		n10 = n22 + 2

		if #v.payload > 0 then
			buffer.writestring(n7, n10, v.payload, #v.payload)
			n10 += #v.payload
		end
	end

	n18 = n9
	buffer.writeu32(n7, n18, #p51.markers)
	n10 = n18 + 4

	for _, v in ipairs(p51.markers) do
		buffer.writeu32(n7, n10, v.timeMs)

		local n23 = n10 + 4

		buffer.writeu8(n7, n23, v.kind)

		local n24 = n23 + 1

		buffer.writeu8(n7, n24, v.actorSlot)
		n23 = n24 + 1
		buffer.writeu8(n7, n23, v.targetSlot)

		local n25 = n23 + 1
		local vLabel = v.label
		local v203 = math.min(#vLabel, 255)

		buffer.writeu8(n7, n25, v203)

		if v203 > 0 then
			buffer.writestring(n7, n25 + 1, vLabel, v203)
		end

		n24 = n25 + 1 + v203

		local v204 = v.assistSlots or v12
		local v205 = math.min(#v204, playerCount)

		buffer.writeu8(n7, n24, v205)
		n10 = n24 + 1

		for i = 1, v205 do
			buffer.writeu8(n7, n10, v204[i])
			n10 += 1
		end
	end

	if v144 then
		local n26 = n5

		buffer.writeu16(n7, n26, #p51.windows)

		local n27 = n26 + 2

		buffer.writeu8(n7, n27, module.OVERLAY_RATE_HZ)
		n26 = n27 + 1
		buffer.writeu8(n7, n26, 0)
		n27 = n26 + 1

		local n28 = n27

		for _, v in ipairs(p51.windows) do
			n28 += #v.slots + 20
		end

		for _, v in ipairs(p51.windows) do
			local n29: number = #v.slots
			local n30: number = #v.samples

			buffer.writeu32(n7, n27, v.startMs)

			local n31 = n27 + 4

			buffer.writeu32(n7, n31, v.endMs)

			local n32 = n31 + 4

			buffer.writeu32(n7, n32, n28)
			n31 = n32 + 4
			buffer.writeu32(n7, n31, n30)
			n32 = n31 + 4
			buffer.writeu8(n7, n32, n29)
			n31 = n32 + 1
			buffer.writeu8(n7, n31, v.trigger)
			n32 = n31 + 1
			buffer.writeu16(n7, n32, 0)
			n27 = n32 + 2

			for _, iterValue3 in ipairs(v.slots) do
				buffer.writeu8(n7, n27, iterValue3)
				n27 += 1
			end

			local n33 = n28

			for i = 1, n30 do
				local v222 = v.samples[i]

				for j = 1, n29 do
					local v224 = v222[j]
					local v225 = module.encodePos(v224.x - p51.origin.X)

					buffer.writei16(n7, n33 + 0, v225)
					v225 = module.encodePos(v224.y - p51.origin.Y)
					buffer.writei16(n7, n33 + 2, v225)
					v225 = module.encodePos(v224.z - p51.origin.Z)
					buffer.writei16(n7, n33 + 4, v225)
					v225 = module.encodeYaw(v224.yaw)
					buffer.writei16(n7, n33 + 6, v225)
					v225 = module.encodePitch(v224.pitch)
					buffer.writei16(n7, n33 + 8, v225)
					v225 = module.encodeYaw(v224.camYaw or v224.yaw)
					buffer.writei16(n7, n33 + 10, v225)
					v225 = module.encodeYaw(v224.bodyPitch or 0)
					buffer.writei16(n7, n33 + 12, v225)
					v225 = module.encodeYaw(v224.bodyRoll or 0)
					buffer.writei16(n7, n33 + 14, v225)
					buffer.writeu8(n7, n33 + 16, v224.state)
					buffer.writeu8(n7, n33 + 17, v224.sflags)
					n33 += module.SAMPLE_STRIDE
				end
			end

			n28 = n33
		end
	end

	return n7
end

local replay: {[any]: any} = {}

replay.__index = replay

function module.decode(p52)
	local v227 = buffer.len(p52)

	if v227 < module.HEADER_BYTES then
		return { ok = false, err = "blob shorter than header" }
	end

	if buffer.readu32(p52, 0) ~= module.MAGIC then
		return { ok = false, err = "bad magic" }
	end

	local v228 = buffer.readu8(p52, 4)
	local v229 = if v228 > module.FORMAT_VERSION then string.format("formatVersion %d is newer than this decoder (%d)", v228, module.FORMAT_VERSION) else if v228 < module.MIN_FORMAT_VERSION then string.format("formatVersion %d predates the current sample layout (min %d) -- re-record", v228, module.MIN_FORMAT_VERSION) else nil

	if v229 then
		return { ok = false, err = v229 }
	end

	v229 = buffer.readu32(p52, 64)

	if v227 < v229 then
		return {
			ok = false,
			err = string.format("truncated: header claims %d bytes, blob is %d", v229, v227)
		}
	end

	local v230 = buffer.readu8(p52, 5)
	local v231 = buffer.readu32(p52, 8)
	local v232 = buffer.readu8(p52, 12)
	local v233 = buffer.readu8(p52, 13)
	local v234 = buffer.readu8(p52, 14)
	local v235 = buffer.readu8(p52, 15)
	local v236 = buffer.readu32(p52, 16)
	local v237 = buffer.readf32(p52, 20)
	local v238 = buffer.readf32(p52, 24)
	local v239 = buffer.readf32(p52, 28)
	local vector3 = Vector3.new(v237, v238, v239)
	local v241 = buffer.readu32(p52, 32)
	local v242 = buffer.readu32(p52, 36)
	local v243 = buffer.readu32(p52, 48)
	local v244 = buffer.readu8(p52, 68)
	local v245 = buffer.readstring(p52, 72, module.MATCHID_BYTES)
	local v246 = buffer.readu32(p52, 108)
	local v247 = buffer.readu8(p52, 112)
	local v248 = buffer.readu8(p52, 113)
	local object = setmetatable({
		mapName = "",
		mapImage = "",
		buf = p52,
		formatVersion = v228,
		flags = v230,
		buildVersion = v231,
		mode = v232,
		playerCount = v233,
		roundCount = v234,
		sampleRateHz = v235,
		sampleCount = v236,
		origin = vector3,
		startedAt = v241,
		durationMs = v242,
		sampleOff = v243,
		overlayRateHz = v244,
		matchId = v245,
		sampleBase = v246,
		roundNumber = v247,
		parentRounds = v248,
		participants = {},
		rounds = {},
		events = {},
		markers = {},
		windows = {}
	}, replay)

	local ok, result = pcall(function()
		local s1
		local s2
		local s3
		local s4
		local v504 = buffer.readu32(p52, 40)
		local v505 = buffer.readu32(p52, 44)

		while v504 < v505 do
			local v506 = buffer.readf64(p52, v504)
			local n1 = v504 + 8
			local v508 = buffer.readu8(p52, n1)
			local n2 = n1 + 1
			local v510 = buffer.readu8(p52, n2)

			n1 = n2 + 1

			local v511 = buffer.readu8(p52, n1)
			local t18: {[any]: any} = {
				userId = v506,
				slot = v508,
				side = v510,
				pflags = v511,
				displayName = s1,
				knifeId = s2,
				revolverId = s3
			}

			n2 = n1 + 1

			local v513 = p52
			local v514 = buffer.readu8(v513, n2)
			local n3

			if v514 == 0 then
				local s1 = ""

				n3 = n2 + 1
			else
				s1 = buffer.readstring(v513, n2 + 1, v514)
				n3 = n2 + 1 + v514
			end

			n2 = n3
			v513 = p52
			v514 = buffer.readu8(v513, n2)

			local n4

			if v514 == 0 then
				local s2 = ""

				n4 = n2 + 1
			else
				s2 = buffer.readstring(v513, n2 + 1, v514)
				n4 = n2 + 1 + v514
			end

			n2 = n4
			v513 = p52
			v514 = buffer.readu8(v513, n2)

			local n5

			if v514 == 0 then
				local s3 = ""

				n5 = n2 + 1
			else
				s3 = buffer.readstring(v513, n2 + 1, v514)
				n5 = n2 + 1 + v514
			end

			n2 = n5
			v511 = buffer.readu8(p52, n2)
			n1 = n2 + 1
			t18.abilities = {}

			for _ = 1, v511 do
				local v522 = p52
				local v523 = buffer.readu8(v522, n1)
				local s5
				local n6

				if v523 == 0 then
					s5 = ""
					n6 = n1 + 1
				else
					s5 = buffer.readstring(v522, n1 + 1, v523)
					n6 = n1 + 1 + v523
				end

				n1 = n6
				table.insert(t18.abilities, s5)
			end

			local v526 = p52

			v511 = buffer.readu16(v526, n1)

			local s6
			local n7

			if v511 == 0 then
				s6 = ""
				n7 = n1 + 2
			else
				s6 = buffer.readstring(v526, n1 + 2, v511)
				n7 = n1 + 2 + v511
			end

			t18.crosshair = s6
			v504 = n7

			if v228 >= 6 then
				local v529 = p52
				local v530 = buffer.readu8(v529, v504)
				local s7
				local n8

				if v530 == 0 then
					s7 = ""
					n8 = v504 + 1
				else
					s7 = buffer.readstring(v529, v504 + 1, v530)
					n8 = v504 + 1 + v530
				end

				t18.device = s7
				v504 = n8
			else
				t18.device = ""
			end

			table.insert(object.participants, t18)
		end

		v504 = v505

		local v533 = p52

		v505 = buffer.readu8(v533, v504)

		local s8
		local n9

		if v505 == 0 then
			s8 = ""
			n9 = v504 + 1
		else
			s8 = buffer.readstring(v533, v504 + 1, v505)
			n9 = v504 + 1 + v505
		end

		object.mapName = s8
		v504 = n9
		v533 = p52

		local v536 = buffer.readu8(v533, v504)
		local s9
		local n10

		if v536 == 0 then
			s9 = ""
			n10 = v504 + 1
		else
			s9 = buffer.readstring(v533, v504 + 1, v536)
			n10 = v504 + 1 + v536
		end

		object.mapImage = s9
		v504 = n10

		local n11 = v504 + 1

		for _ = 1, buffer.readu8(p52, v504) do
			local v541 = buffer.readu32(p52, n11)
			local n12 = n11 + 4
			local v543 = buffer.readu32(p52, n12)
			local n13 = n12 + 4
			local v545 = buffer.readu8(p52, n13)

			n12 = n13 + 1

			local v546 = buffer.readu8(p52, n12)
			local t19: {[any]: any} = {
				kills = {},
				startSample = v541,
				endSample = v543,
				winnerSide = v545,
				rflags = v546
			}

			n11 = n12 + 1

			for j = 0, object.playerCount - 1 do
				t19.kills[j] = buffer.readu8(p52, n11)
				n11 += 1
			end

			table.insert(object.rounds, t19)
		end

		n11 = buffer.readu32(p52, 52)
		v504 = n11 + 4

		for _ = 1, buffer.readu32(p52, n11) do
			local v550 = buffer.readu32(p52, v504)
			local n14 = v504 + 4
			local v552 = buffer.readu8(p52, n14)
			local n15 = n14 + 1
			local v554 = buffer.readu8(p52, n15)

			n14 = n15 + 1

			local v555 = buffer.readu8(p52, n14)
			local t20: {[any]: any} = { timeMs = v550, etype = v552, actorSlot = v554, targetSlot = v555 }

			n15 = n14 + 1
			v555 = buffer.readu16(p52, n15)
			n14 = n15 + 2
			t20.payload = v555 > 0 and buffer.readstring(p52, n14, v555) or ""
			v504 = n14 + v555
			table.insert(object.events, t20)
		end

		n11 = buffer.readu32(p52, 56)
		v504 = n11 + 4

		for _ = 1, buffer.readu32(p52, n11) do
			local v558 = buffer.readu32(p52, v504)
			local n16 = v504 + 4
			local v560 = buffer.readu8(p52, n16)
			local n17 = n16 + 1
			local v562 = buffer.readu8(p52, n17)

			n16 = n17 + 1

			local v563 = buffer.readu8(p52, n16)
			local t21: {[any]: any} = {
				timeMs = v558,
				kind = v560,
				actorSlot = v562,
				targetSlot = v563,
				label = s4
			}

			n17 = n16 + 1

			local v565 = p52
			local v566 = buffer.readu8(v565, n17)
			local n18

			if v566 == 0 then
				local s4 = ""

				n18 = n17 + 1
			else
				s4 = buffer.readstring(v565, n17 + 1, v566)
				n18 = n17 + 1 + v566
			end

			v504 = n18
			t21.assistSlots = {}

			if v228 >= 7 then
				local v569 = buffer.readu8(p52, v504)

				v504 += 1

				for _ = 1, v569 do
					local assistSlots = t21.assistSlots
					local v572 = buffer.readu8(p52, v504)

					table.insert(assistSlots, v572)
					v504 += 1
				end
			end

			table.insert(object.markers, t21)
		end

		local v573 = buffer.readu32(p52, 60)

		if v573 > 0 then
			local v574 = v573
			local v575 = buffer.readu16(p52, v574)
			local n19 = v574 + 2

			object.overlayRateHz = buffer.readu8(p52, n19)
			v574 = n19 + 1 + 1

			for _ = 1, v575 do
				local v578 = buffer.readu32(p52, v574)
				local n20 = v574 + 4
				local v580 = buffer.readu32(p52, n20)
				local n21 = n20 + 4
				local v582 = buffer.readu32(p52, n21)

				n20 = n21 + 4

				local v583 = buffer.readu32(p52, n20)

				n21 = n20 + 4

				local v584 = buffer.readu8(p52, n21)

				n20 = n21 + 1

				local v585 = buffer.readu8(p52, n20)
				local t22: {[any]: any} = {
					slots = {},
					slotIndex = {},
					startMs = v578,
					endMs = v580,
					blockOff = v582,
					sampleCount = v583,
					trigger = v585
				}

				v574 = n20 + 1 + 2

				for j = 1, v584 do
					local v588 = buffer.readu8(p52, v574)

					v574 += 1
					table.insert(t22.slots, v588)
					t22.slotIndex[v588] = j - 1
				end

				t22.slotCount = v584
				table.insert(object.windows, t22)
			end
		end
	end)

	if not ok then
		return { ok = false, err = "malformed blob: " .. tostring(result) }
	end

	return { ok = true, replay = object }
end
function replay.hasFlag(p53, p54)
	return bit32.band(p53.flags, p54) ~= 0
end
local function readSampleAt(p55, p56, p57)
	local decodePos = module.decodePos
	local v258 = buffer.readi16(p55, p56 + 0)

	p57.x = decodePos(v258)

	local v259 = module.decodePos

	v258 = buffer.readi16(p55, p56 + 2)
	p57.y = v259(v258)

	local v260 = module.decodePos

	v258 = buffer.readi16(p55, p56 + 4)
	p57.z = v260(v258)

	local decodeYaw = module.decodeYaw

	v258 = buffer.readi16(p55, p56 + 6)
	p57.yaw = decodeYaw(v258)

	local decodePitch = module.decodePitch

	v258 = buffer.readi16(p55, p56 + 8)
	p57.pitch = decodePitch(v258)

	local v263 = module.decodeYaw

	v258 = buffer.readi16(p55, p56 + 10)
	p57.camYaw = v263(v258)

	local v264 = module.decodeYaw

	v258 = buffer.readi16(p55, p56 + 12)
	p57.bodyPitch = v264(v258)

	local v265 = module.decodeYaw

	v258 = buffer.readi16(p55, p56 + 14)
	p57.bodyRoll = v265(v258)
	p57.state = buffer.readu8(p55, p56 + 16)
	p57.sflags = buffer.readu8(p55, p56 + 17)

	return p57
end
function module.blankSample()
	return {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}
end
function replay.baseSample(p58, p59, p60, p61)
	local t8 = p61 or {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}

	if p58.sampleCount == 0 then
		return t8
	end

	local v271 = math.clamp(p59, 0, p58.sampleCount - 1)

	return (readSampleAt(p58.buf, p58.sampleOff + (v271 * p58.playerCount + p60) * module.SAMPLE_STRIDE, t8))
end
function replay.findWindow(p62, p63, p64)
	for _, v in ipairs(p62.windows) do
		if p63 >= v.startMs and p63 <= v.endMs and v.slotIndex[p64] ~= nil then
			return v
		end
	end

	return nil
end
function replay.windowSample(p65, p66, p67, p68, p69)
	local v282 = math.clamp(p67, 0, p66.sampleCount - 1)

	return (readSampleAt(p65.buf, p66.blockOff + (v282 * p66.slotCount + p66.slotIndex[p68]) * module.SAMPLE_STRIDE, p69 or {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}))
end
local function catmullRom(p70, p71, p72, p73, p74)
	local n1 = p74 * p74

	return (p71 * 2 + (-p70 + p72) * p74 + (p70 * 2 - p71 * 5 + p72 * 4 - p73) * n1 + (-p70 + p71 * 3 - p72 * 3 + p73) * (n1 * p74)) * 0.5
end
local function lerpAngle(p75, p76, p77)
	return p75 + ((p76 - p75 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p77
end
function replay.stateAt(p78, p79, p80, p81)
	local t9 = p81 or {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}

	if p78.sampleCount == 0 then
		return t9
	end

	local v297 = p78:findWindow(p79, p80)
	local v298
	local v299
	local v300

	if v297 then
		v298 = p78.overlayRateHz
		v299 = v297.startMs
		v300 = v297.sampleCount
	else
		v298 = p78.sampleRateHz
		v299 = 0
		v300 = p78.sampleCount
	end

	local n1 = (p79 - v299) * v298 / 1000
	local floored = math.floor(n1)
	local n2 = n1 - floored

	if floored < 0 then
		floored = 0
		n2 = 0
	end

	if floored >= v300 - 1 then
		floored = v300 - 1
		n2 = 0
	end

	n1 = function(p82, p83)
		if v297 then
			return p78:windowSample(v297, p82, p80, p83)
		end

		return p78:baseSample(p82, p80, p83)
	end

	local v304 = if v297 then p78:windowSample(v297, floored, p80, t9) else p78:baseSample(floored, p80, t9)

	if n2 <= 0 then
		return v304
	end

	local n3 = floored + 1
	local t10: {[any]: any} = {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}
	local v307 = if v297 then p78:windowSample(v297, n3, p80, t10) else p78:baseSample(n3, p80, t10)
	local s_discontinuity = module.S_DISCONTINUITY

	if bit32.band(v307.sflags, s_discontinuity) == 0 and bit32.band(v304.sflags, s_discontinuity) == 0 then
		local n4 = floored - 1
		local t11 = {
			x = 0,
			y = 0,
			z = 0,
			yaw = 0,
			pitch = 0,
			camYaw = 0,
			bodyPitch = 0,
			bodyRoll = 0,
			state = 0,
			sflags = 0
		}
		local v311 = if v297 then p78:windowSample(v297, n4, p80, t11) else p78:baseSample(n4, p80, t11)

		t11 = floored + 2

		local t12: {[any]: any} = {
			x = 0,
			y = 0,
			z = 0,
			yaw = 0,
			pitch = 0,
			camYaw = 0,
			bodyPitch = 0,
			bodyRoll = 0,
			state = 0,
			sflags = 0
		}

		n4 = if v297 then p78:windowSample(v297, t11, p80, t12) else p78:baseSample(t11, p80, t12)

		if bit32.band(n4.sflags, s_discontinuity) ~= 0 then
			n4 = v307
		end

		local x = v311.x
		local v314 = v304.x
		local v315 = v307.x
		local v316 = n4.x
		local n5 = n2 * n2

		t9.x = (v314 * 2 + (-x + v315) * n2 + (x * 2 - v314 * 5 + v315 * 4 - v316) * n5 + (-x + v314 * 3 - v315 * 3 + v316) * (n5 * n2)) * 0.5

		local y = v311.y
		local v319 = v304.y
		local v320 = v307.y
		local v321 = n4.y
		local n6 = n2 * n2

		t9.y = (v319 * 2 + (-y + v320) * n2 + (y * 2 - v319 * 5 + v320 * 4 - v321) * n6 + (-y + v319 * 3 - v320 * 3 + v321) * (n6 * n2)) * 0.5

		local z = v311.z
		local v324 = v304.z
		local v325 = v307.z
		local v326 = n4.z
		local n7 = n2 * n2

		t9.z = (v324 * 2 + (-z + v325) * n2 + (z * 2 - v324 * 5 + v325 * 4 - v326) * n7 + (-z + v324 * 3 - v325 * 3 + v326) * (n7 * n2)) * 0.5

		local yaw = v304.yaw

		t9.yaw = yaw + ((v307.yaw - yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * n2

		local camYaw = v304.camYaw

		t9.camYaw = camYaw + ((v307.camYaw - camYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * n2

		local bodyPitch = v304.bodyPitch

		t9.bodyPitch = bodyPitch + ((v307.bodyPitch - bodyPitch + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * n2

		local bodyRoll = v304.bodyRoll

		t9.bodyRoll = bodyRoll + ((v307.bodyRoll - bodyRoll + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * n2
		t9.pitch = v304.pitch + (v307.pitch - v304.pitch) * n2
		t9.state = v304.state
		t9.sflags = v304.sflags
	elseif n2 >= 0.5 then
		local v332 = v307.y
		local v333 = v307.z

		t9.x = v307.x
		t9.y = v332
		t9.z = v333

		local pitch = v307.pitch
		local v335 = v307.camYaw

		t9.yaw = v307.yaw
		t9.pitch = pitch
		t9.camYaw = v335

		local v336 = v307.bodyRoll

		t9.bodyPitch = v307.bodyPitch
		t9.bodyRoll = v336

		local sflags = v307.sflags

		t9.state = v307.state
		t9.sflags = sflags
	end

	return t9
end
function replay.positionAt(p84, p85, p86)
	local v341 = p84:stateAt(p85, p86)
	local origin = p84.origin
	local vector3 = Vector3.new(v341.x, v341.y, v341.z)

	return origin + vector3
end
function replay.roundStartMs(p87, p88)
	local v346 = p87.rounds[p88]

	if not v346 then
		return nil
	end

	return (math.floor(v346.startSample / p87.sampleRateHz * 1000))
end
function replay.participantBySlot(p89, p90)
	for _, v in ipairs(p89.participants) do
		if p90 == v.slot then
			return v
		end
	end

	return nil
end

local v17 = bit32.bor(module.FLAG_TRUNCATED, module.FLAG_HAS_BOTS, module.FLAG_PRESERVE_EVIDENCE)

local function toWorld(p91, p92, p93, p94)
	p91.x = p91.x + p92
	p91.y = p91.y + p93
	p91.z = p91.z + p94

	return p91
end
local function copyWindowRows(p95, p96, p97, p98, p99, p100, p101)
	local t13: {[any]: any} = {}

	for i = p97, p98 do
		local t14: {[any]: any} = {}

		for i2, v in ipairs(p96.slots) do
			local v367 = p95:windowSample(p96, i, v, {
				x = 0,
				y = 0,
				z = 0,
				yaw = 0,
				pitch = 0,
				camYaw = 0,
				bodyPitch = 0,
				bodyRoll = 0,
				state = 0,
				sflags = 0
			})

			v367.x = v367.x + p99
			v367.y = v367.y + p100
			v367.z = v367.z + p101
			t14[i2] = v367
		end

		t13[#t13 + 1] = t14
	end

	return t13
end
function module.slice(p102, p103, p104)
	local v371 = p104

	if not v371 then
		local v372 = module.decode(p102)

		if not v372.ok then
			return nil, v372.err
		end

		v371 = v372.replay
	end

	local v373 = v371.rounds[p103]

	if not v373 then
		return nil, string.format("round %d not present (blob has %d)", p103, #v371.rounds)
	end

	if v371.sampleCount == 0 then
		return nil, "blob has no samples"
	end

	local sampleRateHz = v371.sampleRateHz
	local overlayRateHz = v371.overlayRateHz
	local playerCount = v371.playerCount
	local v377 = math.clamp(v373.startSample, 0, v371.sampleCount - 1)
	local v378 = math.clamp(v373.endSample, v377, v371.sampleCount - 1)
	local n1 = v378 - v377 + 1
	local floored = math.floor(v377 / sampleRateHz * 1000)
	local floored2 = math.floor((v378 + 1) / sampleRateHz * 1000)
	local t15: {[any]: any} = {}
	local n2 = 0

	for _, v in ipairs(v371.windows) do
		if floored < v.endMs and floored2 > v.startMs then
			table.insert(t15, v)
			n2 += 16 + v.slotCount + v.sampleCount * v.slotCount * module.SAMPLE_STRIDE
		end
	end

	local newWriter = module.newWriter
	local matchId = v371.matchId
	local mode = v371.mode
	local origin = v371.origin
	local startedAt = v371.startedAt
	local floored3 = math.floor(floored / 1000)
	local v392 = newWriter({
		matchId = matchId,
		mode = mode,
		playerCount = playerCount,
		origin = origin,
		startedAt = startedAt + floored3,
		buildVersion = v371.buildVersion,
		mapName = v371.mapName,
		mapImage = v371.mapImage,
		sampleRateHz = sampleRateHz,
		maxSeconds = n1 / sampleRateHz + 1,
		overlayBudget = n2 + 1024,
		sampleBase = v377,
		roundNumber = p103,
		parentRounds = #v371.rounds
	})

	v392.flags = bit32.band(v371.flags, v17)
	v392:setFlag(module.FLAG_ROUND_SLICE)

	for _, v in ipairs(v371.participants) do
		v392:addParticipant(v)
	end

	local x = v371.origin.X
	local y = v371.origin.Y
	local z = v371.origin.Z
	n2 = {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}

	for i = v377, v378 do
		local n3 = i - v377

		for j = 0, playerCount - 1 do
			v371:baseSample(i, j, n2)
			n2.x = n2.x + x
			n2.y = n2.y + y
			n2.z = n2.z + z

			if n3 == 0 then
				n2.sflags = bit32.bor(n2.sflags, module.S_DISCONTINUITY)
			end

			v392:writeSample(n3, j, n2)
		end
	end

	n2 = {}

	for i = 0, playerCount - 1 do
		n2[i] = v373.kills[i] or 0
	end

	v392:addRound({
		startSample = 0,
		endSample = n1 - 1,
		winnerSide = v373.winnerSide,
		rflags = v373.rflags,
		kills = n2
	})
	n2 = {}
	n1 = {}

	for _, v in ipairs(v371.events) do
		if v.etype == module.EV_ATTR and floored > v.timeMs then
			local ok, result = pcall(string.unpack, "<s1", v.payload)

			if ok then
				local s1: string = tostring(v.actorSlot) .. "\000" .. result
				local v407 = n1[s1]

				if v407 == nil then
					table.insert(n2, s1)
					n1[s1] = v
				elseif v.timeMs >= v407.timeMs then
					n1[s1] = v
				end
			end
		end
	end

	for _, v in ipairs(n2) do
		local v410 = n1[v]

		v392:addEvent({
			timeMs = 0,
			etype = v410.etype,
			actorSlot = v410.actorSlot,
			targetSlot = v410.targetSlot,
			payload = v410.payload
		})
	end

	n2 = {}
	n1 = {}

	for _, v in ipairs(v371.events) do
		if floored > v.timeMs and (v.etype == module.EV_ANIM_START or v.etype == module.EV_ANIM_STOP) then
			local v413
			local v414

			if v.etype == module.EV_ANIM_START then
				local v415, v416, v417, v418 = pcall(string.unpack, "<ffs2", v.payload)

				v413 = v415
				v414 = v418
			else
				local ok, result = pcall(string.unpack, "<s2", v.payload)

				v413 = ok
				v414 = result
			end

			if v413 and typeof(v414) == "string" then
				local s2: string = tostring(v.actorSlot) .. "\000" .. v414

				if v.etype == module.EV_ANIM_START then
					if n1[s2] == nil then
						table.insert(n2, s2)
					end

					n1[s2] = v
				else
					n1[s2] = nil
				end
			end
		end
	end

	for _, v in ipairs(n2) do
		local v424 = n1[v]

		if v424 then
			v392:addEvent({
				timeMs = 0,
				etype = v424.etype,
				actorSlot = v424.actorSlot,
				targetSlot = v424.targetSlot,
				payload = v424.payload
			})
		end
	end

	for _, v in ipairs(v371.events) do
		if floored <= v.timeMs and floored2 > v.timeMs then
			v392:addEvent({
				timeMs = v.timeMs - floored,
				etype = v.etype,
				actorSlot = v.actorSlot,
				targetSlot = v.targetSlot,
				payload = v.payload
			})
		end
	end

	for _, v in ipairs(v371.markers) do
		if floored <= v.timeMs and floored2 > v.timeMs then
			v392:addMarker({
				timeMs = v.timeMs - floored,
				kind = v.kind,
				actorSlot = v.actorSlot,
				targetSlot = v.targetSlot,
				label = v.label,
				assistSlots = v.assistSlots
			})
		end
	end

	for _, v in ipairs(t15) do
		local v431 = math.max(v.startMs, floored)
		local v432 = math.min(v.endMs, floored2)
		local floored4 = math.floor((v431 - v.startMs) * overlayRateHz / 1000)

		v431 = math.max(0, floored4)

		local n4 = v.sampleCount - 1
		local floored5 = math.floor((v432 - v.startMs) * overlayRateHz / 1000)
		local v436 = math.min(n4, floored5)
		local u437: boolean = v432 < v.endMs

		if v436 >= v431 then
			local vStartMs = v.startMs
			local floored6 = math.floor(v431 * 1000 / overlayRateHz)
			local n5 = vStartMs + floored6 - floored
			local floored7 = math.floor((v436 - v431) * 1000 / overlayRateHz)
			local n6 = n5 + floored7

			if u437 then
				n6 -= 1
			end

			local vTrigger = v.trigger
			local vSlots = v.slots
			local v445 = copyWindowRows(v371, v, v431, v436, x, y, z)

			v392:addOverlayWindow({
				startMs = n5,
				endMs = n6,
				trigger = vTrigger,
				slots = vSlots,
				samples = v445
			})
		end
	end

	return v392:finalize()
end
function module.sliceAll(p105)
	local v447 = module.decode(p105)

	if not v447.ok then
		return nil, v447.err
	end

	local replay = v447.replay

	if #replay.rounds == 0 then
		return nil, "blob has no rounds"
	end

	v447 = {}

	for i = 1, #replay.rounds do
		local v450, v451 = module.slice(p105, i, replay)

		if not v450 then
			local stringFormat = string.format
			local text: string = tostring(v451)

			return nil, stringFormat("round %d: %s", i, text)
		end

		v447[i] = v450
	end

	return v447
end
function module.merge(list)
	if #list == 0 then
		return nil, "no blobs to merge"
	end

	if #list == 1 then
		local v455 = list[1]

		if buffer.len(v455) < module.HEADER_BYTES then
			return nil, "blob 1: shorter than header"
		end

		local v456 = buffer.readu8(v455, 4)
		local v457 = if v456 > module.FORMAT_VERSION then string.format("formatVersion %d is newer than this decoder (%d)", v456, module.FORMAT_VERSION) else if v456 < module.MIN_FORMAT_VERSION then string.format("formatVersion %d predates the current sample layout (min %d) -- re-record", v456, module.MIN_FORMAT_VERSION) else nil

		if v457 then
			return nil, "blob 1: " .. v457
		end

		return v455
	end

	local t16: {[any]: any} = {}

	for i, v in ipairs(list) do
		local v461 = module.decode(v)

		if not v461.ok then
			local stringFormat = string.format
			local text: string = tostring(v461.err)

			return nil, stringFormat("blob %d: %s", i, text)
		end

		table.insert(t16, v461.replay)
	end

	table.sort(t16, function(p107, p108)
		if p107.roundNumber ~= p108.roundNumber then
			return p107.roundNumber < p108.roundNumber
		end

		return p107.sampleBase < p108.sampleBase
	end)

	local v464 = t16[1]
	local sampleRateHz = v464.sampleRateHz
	local playerCount = v464.playerCount
	local n1 = 0
	local n2 = 0
	local n3 = 0

	for _, v in ipairs(t16) do
		if v.matchId ~= v464.matchId then
			return nil, "slices are from different matches"
		end

		if playerCount ~= v.playerCount then
			return nil, "playerCount mismatch between slices"
		end

		if sampleRateHz ~= v.sampleRateHz then
			return nil, "sampleRate mismatch between slices"
		end

		n1 += v.sampleCount

		local v472 = bit32.band(v.flags, v17)

		n3 = bit32.bor(n3, v472)

		for _, iterValue in ipairs(v.windows) do
			n2 += 16 + iterValue.slotCount + iterValue.sampleCount * iterValue.slotCount * module.SAMPLE_STRIDE
		end
	end

	local v475 = module.newWriter({
		matchId = v464.matchId,
		mode = v464.mode,
		playerCount = playerCount,
		origin = v464.origin,
		startedAt = v464.startedAt,
		buildVersion = v464.buildVersion,
		mapName = v464.mapName,
		mapImage = v464.mapImage,
		sampleRateHz = sampleRateHz,
		maxSeconds = n1 / sampleRateHz + 1,
		overlayBudget = n2 + 1024,
		parentRounds = v464.parentRounds
	})

	v475.flags = n3

	for _, v in ipairs(v464.participants) do
		v475:addParticipant(v)
	end

	n3 = {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		bodyPitch = 0,
		bodyRoll = 0,
		state = 0,
		sflags = 0
	}
	n2 = 0

	for _, v in ipairs(t16) do
		local x = v.origin.X
		local y = v.origin.Y
		local z = v.origin.Z
		local floored = math.floor(n2 / sampleRateHz * 1000)

		for i = 0, v.sampleCount - 1 do
			for j = 0, playerCount - 1 do
				v:baseSample(i, j, n3)
				n3.x = n3.x + x
				n3.y = n3.y + y
				n3.z = n3.z + z

				if i == 0 then
					n3.sflags = bit32.bor(n3.sflags, module.S_DISCONTINUITY)
				end

				v475:writeSample(n2 + i, j, n3)
			end
		end

		local v486 = v.rounds[1]
		local t17: {[any]: any} = {}

		for i = 0, playerCount - 1 do
			t17[i] = v486 and v486.kills[i] or 0
		end

		local v489 = math.max(0, v.sampleCount - 1)

		v475:addRound({
			startSample = n2,
			endSample = n2 + v489,
			winnerSide = v486 and v486.winnerSide or 255,
			rflags = v486 and v486.rflags or 0,
			kills = t17
		})

		for _, iterValue2 in ipairs(v.events) do
			v475:addEvent({
				timeMs = iterValue2.timeMs + floored,
				etype = iterValue2.etype,
				actorSlot = iterValue2.actorSlot,
				targetSlot = iterValue2.targetSlot,
				payload = iterValue2.payload
			})
		end

		for _, iterValue3 in ipairs(v.markers) do
			v475:addMarker({
				timeMs = iterValue3.timeMs + floored,
				kind = iterValue3.kind,
				actorSlot = iterValue3.actorSlot,
				targetSlot = iterValue3.targetSlot,
				label = iterValue3.label,
				assistSlots = iterValue3.assistSlots
			})
		end

		for _, iterValue4 in ipairs(v.windows) do
			local n4 = iterValue4.startMs + floored
			local n5 = iterValue4.endMs + floored
			local v498 = iterValue4.trigger
			local v499 = iterValue4.slots
			local v500 = copyWindowRows(v, iterValue4, 0, iterValue4.sampleCount - 1, x, y, z)

			v475:addOverlayWindow({
				startMs = n4,
				endMs = n5,
				trigger = v498,
				slots = v499,
				samples = v500
			})
		end

		n2 += v.sampleCount
	end

	return v475:finalize()
end

module.Replay = replay
module.Writer = writer

return module
