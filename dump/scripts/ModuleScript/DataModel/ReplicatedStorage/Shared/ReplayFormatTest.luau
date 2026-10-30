-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function loadFormat()
	local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
	local v8, v9 = loadstring(replicatedStorage.Shared.ReplayFormat.Source, "ReplayFormat")

	if not v8 then
		local text: string = tostring(v9)

		error("ReplayFormat failed to compile: " .. text)
	end

	return v8()
end

local t1: {[any]: any} = {}

local function check(p1, p2, p3)
	table.insert(t1, { name = p1, ok = p2, detail = p3 })
end
local function approx(p4, p5, p6)
	local absoluteValue = math.abs(p4 - p5)

	return p6 >= absoluteValue
end
local function buildSynthetic(p7, p8)
	local newWriter = p7.newWriter
	local v21 = string.rep("a", 8)
	local v22 = string.rep("b", 4)
	local v23 = string.rep("c", 4)
	local v24 = string.rep("d", 4)
	local v25 = string.rep("e", 12)
	local v26 = newWriter({
		mode = 2,
		playerCount = 4,
		origin = Vector3.new(1024, 5000, -2048),
		startedAt = 1770000000,
		buildVersion = 3902,
		mapName = "Office",
		mapImage = "rbxassetid://123456789",
		sampleRateHz = 20,
		maxSeconds = 900,
		matchId = v21 .. "-" .. v22 .. "-" .. v23 .. "-" .. v24 .. "-" .. v25
	})

	for i = 0, 3 do
		v26:addParticipant({
			pflags = 0,
			revolverId = "DefaultRevolver",
			userId = if i == 0 then 8172635948271 else i + 100000,
			slot = i,
			side = if i < 2 then 0 else 1,
			displayName = "Player" .. i,
			knifeId = if i == 0 then "ChromaKatana" else "DefaultKnife",
			abilities = { "SpeedBoost", "XRay" }
		})
	end

	local t3: {[any]: any} = {}

	for i = 0, 239 do
		local n1: number = i / 20

		t3[i] = {}

		for j = 0, 3 do
			local n2: number = n1 * 3 + j * 1.7
			local n3 = j * 6 + 40
			local n4 = p7.S_ALIVE + p7.S_GROUNDED
			local n5 = math.cos(n2) * n3 + 1024
			local n6 = math.sin(n1 * 5) * 2 + 5003
			local n7 = math.sin(n2) * n3 + -2048

			if j == 3 and i > 140 then
				n4 = 0
				n5 = 1024
				n6 = 5000
				n7 = -2048
			end

			if j == 1 and i == 100 then
				n5 = 1324
				n6 = 5050
				n7 = -2348
				n4 += p7.S_DISCONTINUITY
			end

			local sine = math.sin(n1)
			local sine2 = math.sin(n1 * 0.7)
			local cosine = math.cos(n1 * 0.5)
			n3 = {
				x = n5,
				y = n6,
				z = n7,
				yaw = n2 % 6.283185307179586 - 3.141592653589793,
				pitch = sine * 1.2,
				camYaw = (n2 + 0.6) % 6.283185307179586 - 3.141592653589793,
				bodyPitch = sine2 * 0.4,
				bodyRoll = cosine * 0.3,
				state = i % 60 < 20 and p7.STATE_SLIDING or p7.STATE_NONE,
				sflags = n4
			}
			v26:writeSample(i, j, n3)
			t3[i][j] = n3
		end
	end

	v26:addRound({
		startSample = 0,
		endSample = 119,
		winnerSide = 0,
		rflags = 0,
		kills = { [0] = 2, 0, 1, 0 }
	})
	v26:addRound({
		startSample = 120,
		endSample = 239,
		winnerSide = 1,
		rflags = 0,
		kills = { [0] = 0, 1, 3, 0 }
	})
	v26:addEvent({
		timeMs = 1500,
		actorSlot = 0,
		payload = "\001\002\003\004",
		etype = p7.EV_SHOT,
		targetSlot = p7.NO_SLOT
	})
	v26:addEvent({
		timeMs = 3200,
		actorSlot = 2,
		targetSlot = 3,
		payload = "",
		etype = p7.EV_DEATH
	})
	v26:addEvent({
		timeMs = 7000,
		actorSlot = 1,
		payload = "SpeedBoost",
		etype = p7.EV_ABILITY_CAST,
		targetSlot = p7.NO_SLOT
	})
	v26:addMarker({
		timeMs = 3200,
		actorSlot = 2,
		targetSlot = 3,
		label = "Player2 killed Player3",
		kind = p7.MK_KILL
	})
	v26:addMarker({
		timeMs = 6000,
		label = "Round 1",
		kind = p7.MK_ROUND_WIN,
		actorSlot = p7.NO_SLOT,
		targetSlot = p7.NO_SLOT
	})

	if not (p8 or {}).noOverlay then
		local overlay_rate_hz = p7.OVERLAY_RATE_HZ
		local t4: {[any]: any} = { 2, 3 }
		local t5: {[any]: any} = {}

		for i = 0, math.floor(2.5 * overlay_rate_hz) + 1 - 1 do
			local n8 = (1700 + i * 1000 / overlay_rate_hz) / 1000
			local t6: {[any]: any} = {}

			for i, v in ipairs(t4) do
				local n9 = n8 * 3 + v * 1.7
				local n10 = 40 + v * 6
				local cosine2 = math.cos(n9)
				local sine3 = math.sin(n8 * 5)
				local sine4 = math.sin(n9)
				local sine5 = math.sin(n8)

				t6[i] = {
					x = 1024 + cosine2 * n10,
					y = sine3 * 2 + 5003,
					z = -2048 + sine4 * n10,
					yaw = n9 % 6.283185307179586 - 3.141592653589793,
					pitch = sine5 * 1.2,
					camYaw = (n9 + 0.6) % 6.283185307179586 - 3.141592653589793,
					state = p7.STATE_NONE,
					sflags = p7.S_ALIVE + p7.S_GROUNDED
				}
			end

			t5[i + 1] = t6
		end

		v26:addOverlayWindow({
			startMs = 1700,
			endMs = 4200,
			trigger = p7.TRIG_KILL,
			slots = t4,
			samples = t5
		})
	end

	return v26, t3, 240
end

local module: {[any]: any} = {}

function module.run()
	t1 = {}
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local v56, v57 = loadstring(replicatedStorage.Shared.ReplayFormat.Source, "ReplayFormat")

	if not v56 then
		local text: string = tostring(v57)

		error("ReplayFormat failed to compile: " .. text)
	end

	replicatedStorage = v56()

	local v59, v60, v61 = buildSynthetic(replicatedStorage)
	local v62 = v59:finalize()
	local v63 = replicatedStorage.decode(v62)

	if not v63.ok then
		return "FATAL: decode failed -- " .. tostring(v63.err)
	end

	local v64 = v63.replay

	v63 = 0

	local n1 = 0
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local n5 = 0
	local u70 = true

	for i = 0, v61 - 1 do
		for j = 0, 3 do
			local v73 = v60[i][j]
			local v74 = v64:baseSample(i, j)
			local absoluteValue = math.abs(v73.x - 1024 - v74.x)
			local absoluteValue2 = math.abs(v73.y - 5000 - v74.y)
			local absoluteValue3 = math.abs(v73.z - -2048 - v74.z)

			v63 = math.max(v63, absoluteValue, absoluteValue2, absoluteValue3)
			absoluteValue3 = math.abs((v73.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793 - v74.yaw)
			n1 = math.max(n1, absoluteValue3)
			absoluteValue3 = math.abs((v73.camYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793 - v74.camYaw)
			n3 = math.max(n3, absoluteValue3)
			absoluteValue3 = math.abs(v73.bodyPitch - v74.bodyPitch)
			n4 = math.max(n4, absoluteValue3)
			absoluteValue3 = math.abs(v73.bodyRoll - v74.bodyRoll)
			n5 = math.max(n5, absoluteValue3)
			absoluteValue3 = math.abs(v73.pitch - v74.pitch)
			n2 = math.max(n2, absoluteValue3)

			if v74.state ~= v73.state or v74.sflags ~= v73.sflags then
				u70 = false
			end
		end
	end

	local u78 = v63 <= replicatedStorage.POS_TOLERANCE
	local formattedText = string.format("worst %.6f, tol %.6f", v63, replicatedStorage.POS_TOLERANCE)

	table.insert(t1, {
		name = "T1 position within tolerance",
		ok = u78,
		detail = formattedText
	})
	formattedText = n1 <= replicatedStorage.YAW_TOLERANCE
	u78 = string.format("worst %.8f, tol %.8f", n1, replicatedStorage.YAW_TOLERANCE)
	table.insert(t1, { name = "T1 yaw within tolerance", ok = formattedText, detail = u78 })
	u78 = n3 <= replicatedStorage.YAW_TOLERANCE
	formattedText = string.format("worst %.8f, tol %.8f", n3, replicatedStorage.YAW_TOLERANCE)
	table.insert(t1, {
		name = "T1 camera yaw round-trips separately from body yaw",
		ok = u78,
		detail = formattedText
	})
	formattedText = n4 <= replicatedStorage.YAW_TOLERANCE
	u78 = string.format("worst %.8f, tol %.8f", n4, replicatedStorage.YAW_TOLERANCE)
	table.insert(t1, { name = "T1 body pitch round-trips", ok = formattedText, detail = u78 })
	u78 = n5 <= replicatedStorage.YAW_TOLERANCE
	formattedText = string.format("worst %.8f, tol %.8f", n5, replicatedStorage.YAW_TOLERANCE)
	table.insert(t1, { name = "T1 body roll round-trips", ok = u78, detail = formattedText })
	formattedText = n2 <= replicatedStorage.PITCH_TOLERANCE
	u78 = string.format("worst %.8f, tol %.8f", n2, replicatedStorage.PITCH_TOLERANCE)
	table.insert(t1, { name = "T1 pitch within tolerance", ok = formattedText, detail = u78 })
	table.insert(t1, { name = "T1 discrete fields exact", detail = nil, ok = u70 })
	table.insert(t1, {
		name = "T1 header fields",
		detail = nil,
		ok = v64.playerCount == 4 and v64.sampleRateHz == 20 and v61 == v64.sampleCount and v64.buildVersion == 3902 and v64.mode == 2
	})
	u78 = math.abs(v64.origin.X - 1024) <= 0.01

	if u78 then
		u78 = math.abs(v64.origin.Y - 5000) <= 0.01

		if u78 then
			u78 = math.abs(v64.origin.Z - -2048) <= 0.01
		end
	end

	table.insert(t1, { name = "T1 origin preserved", detail = nil, ok = u78 })
	table.insert(t1, {
		name = "T1 rounds decoded",
		detail = nil,
		ok = #v64.rounds == 2 and v64.rounds[1].winnerSide == 0 and v64.rounds[2].winnerSide == 1 and v64.rounds[1].kills[0] == 2 and v64.rounds[2].kills[2] == 3
	})
	u78 = v64.mapName == "Office" and v64.mapImage == "rbxassetid://123456789"
	formattedText = string.format
	u70 = tostring(v64.mapName)
	n2 = tostring(v64.mapImage)
	n5 = formattedText("got name=%q image=%q", u70, n2)
	table.insert(t1, { name = "T1 map identity round-trips", ok = u78, detail = n5 })
	table.insert(t1, {
		name = "T1 events decoded",
		detail = nil,
		ok = #v64.events == 3 and v64.events[1].timeMs == 1500 and v64.events[3].payload == "SpeedBoost" and v64.events[2].targetSlot == 3
	})
	table.insert(t1, {
		name = "T1 markers decoded",
		detail = nil,
		ok = #v64.markers == 2 and v64.markers[1].label == "Player2 killed Player3"
	})
	n5 = {}

	for i = 0, 200 do
		local floored = math.floor(i * 12000 / 200)

		table.insert(n5, floored)
	end

	n2 = {}

	for _, v in ipairs(n5) do
		n2[v] = {}

		for i = 0, 3 do
			local v85 = v64:stateAt(v, i)

			n2[v][i] = {
				v85.x,
				v85.y,
				v85.z,
				v85.yaw,
				v85.pitch,
				v85.state,
				v85.sflags,
				v85.camYaw,
				v85.bodyPitch,
				v85.bodyRoll
			}
		end
	end

	u70 = true

	for i = 0, 12000, 7 do
		for j = 0, 3 do
			v64:stateAt(i, j)
		end
	end

	for _, v in ipairs(n5) do
		for i = 0, 3 do
			local v91 = v64:stateAt(v, i)
			local v92 = n2[v][i]

			if v91.x ~= v92[1] or v91.y ~= v92[2] or v91.z ~= v92[3] or v91.yaw ~= v92[4] or v91.pitch ~= v92[5] or v91.state ~= v92[6] or v91.sflags ~= v92[7] then
				u70 = false
			end
		end
	end

	formattedText = true

	for i = 12000, 0, -7 do
		for j = 0, 3 do
			v64:stateAt(i, j)
		end
	end

	for _, v in ipairs(n5) do
		for i = 0, 3 do
			local v98 = v64:stateAt(v, i)
			local v99 = n2[v][i]

			if v98.x ~= v99[1] or v98.y ~= v99[2] or v98.z ~= v99[3] or v98.yaw ~= v99[4] or v98.pitch ~= v99[5] or v98.state ~= v99[6] or v98.sflags ~= v99[7] then
				formattedText = false
			end
		end
	end

	u78 = Random.new(1337)
	n4 = true

	for _ = 1, 2000 do
		local v101 = u78:NextInteger(0, 12000)

		v64:stateAt(v101, u78:NextInteger(0, 3))
	end

	for _, v in ipairs(n5) do
		for i = 0, 3 do
			local v105 = v64:stateAt(v, i)
			local v106 = n2[v][i]

			if v105.x ~= v106[1] or v105.y ~= v106[2] or v105.z ~= v106[3] or v105.yaw ~= v106[4] or v105.pitch ~= v106[5] or v105.state ~= v106[6] or v105.sflags ~= v106[7] then
				n4 = false
			end
		end
	end

	table.insert(t1, { name = "T2 forward scan == cold seek", detail = nil, ok = u70 })
	table.insert(t1, {
		name = "T2 backward scan == cold seek",
		detail = nil,
		ok = formattedText
	})
	table.insert(t1, { name = "T2 random jumps == cold seek", detail = nil, ok = n4 })
	n4 = v64:stateAt(-5000, 0)
	u78 = v64:baseSample(0, 0)
	formattedText = math.abs(n4.x - u78.x) <= 1E-9

	if formattedText then
		formattedText = math.abs(n4.z - u78.z) <= 1E-9
	end

	table.insert(t1, {
		name = "T3 before start clamps to first sample",
		detail = nil,
		ok = formattedText
	})
	formattedText = v64:stateAt(72000, 0)
	u78 = v64:baseSample(v61 - 1, 0)
	n4 = math.abs(formattedText.x - u78.x) <= 1E-9

	if n4 then
		n4 = math.abs(formattedText.z - u78.z) <= 1E-9
	end

	table.insert(t1, { name = "T3 past end clamps to last sample", detail = nil, ok = n4 })
	n4 = v64:stateAt(8000, 0)
	u78 = v64:baseSample(160, 0)
	formattedText = math.abs(n4.x - u78.x) <= 1E-9

	if formattedText then
		formattedText = math.abs(n4.y - u78.y) <= 1E-9

		if formattedText then
			formattedText = math.abs(n4.z - u78.z) <= 1E-9
		end
	end

	table.insert(t1, {
		name = "T3 exactly on sample == raw sample",
		detail = nil,
		ok = formattedText
	})
	formattedText = v64:stateAt(8025, 0)
	n4 = true

	if formattedText.x == u78.x then
		n4 = formattedText.z ~= u78.z
	end

	table.insert(t1, { name = "T3 between samples interpolates", detail = nil, ok = n4 })
	n4 = v64:baseSample(99, 1)
	formattedText = v64:baseSample(100, 1)
	u78 = v64:stateAt(4975, 1)
	u70 = math.abs(u78.x - n4.x)
	n2 = math.abs(u78.x - formattedText.x)
	n5 = string.format("mid=%.2f pre=%.2f post=%.2f", u78.x, n4.x, formattedText.x)
	table.insert(t1, {
		name = "T3 teleport snaps (I5)",
		ok = (if u70 <= 0.000001 then true else false) or (if n2 <= 0.000001 then true else false),
		detail = n5
	})
	n5 = os.clock()
	n2 = replicatedStorage.newWriter
	u70 = string.rep("f", 8)
	u78 = string.rep("f", 12)
	formattedText = n2({
		mode = 4,
		playerCount = 8,
		origin = Vector3.new(1024, 5000, -2048),
		startedAt = 1770000000,
		buildVersion = 3902,
		sampleRateHz = 20,
		maxSeconds = 900,
		matchId = u70 .. "-ffff-ffff-ffff-" .. u78
	})

	for i = 0, 7 do
		formattedText:addParticipant({
			pflags = 0,
			knifeId = "K",
			revolverId = "R",
			userId = i + 200000,
			slot = i,
			side = if i < 4 then 0 else 1,
			displayName = "P" .. i,
			abilities = {}
		})
	end

	u78 = {
		x = 0,
		y = 0,
		z = 0,
		yaw = 0,
		pitch = 0,
		camYaw = 0,
		state = 0,
		sflags = 1
	}

	for i = 0, 17999 do
		for j = 0, 7 do
			u78.x = i % 200 + 1024
			u78.y = j + 5000
			u78.z = i % 137 + -2048
			u78.yaw = i % 100 / 100
			formattedText:writeSample(i, j, u78)
		end
	end

	u78 = os.clock()
	u70 = os.clock()
	n2 = formattedText:finalize()
	formattedText = os.clock()
	n4 = os.clock()
	n3 = replicatedStorage.decode(n2)
	n1 = os.clock()
	v63 = buffer.len(n2)
	n2 = 144000 * replicatedStorage.SAMPLE_STRIDE

	local v110 = n3.ok
	local formattedText2 = string.format("%.2f MB | write %.0fms finalize %.0fms decode %.0fms", v63 / 1048576, (u78 - n5) * 1000, (formattedText - u70) * 1000, (n1 - n4) * 1000)

	table.insert(t1, {
		name = "T4 8p x 15min encodes+decodes",
		ok = v110,
		detail = formattedText2
	})
	formattedText2 = math.abs(v63 - n2)
	v110 = string.format("got %d, sample data %d (stride %d)", v63, n2, replicatedStorage.SAMPLE_STRIDE)
	table.insert(t1, {
		name = "T4 size matches stride budget",
		ok = if formattedText2 < 2048 then true else false,
		detail = v110
	})
	v110 = os.clock()

	for _ = 1, 10000 do
		local replay = n3.replay
		local randomNumber = math.random(0, 900000)

		replay:stateAt(randomNumber, math.random(0, 7))
	end

	n3 = (os.clock() - v110) * 1000000 / 10000
	v110 = string.format("%.1f us/seek across a 15-min blob", n3)
	table.insert(t1, {
		name = "T4 seek is O(1)",
		ok = if n3 < 200 then true else false,
		detail = v110
	})
	v110 = buffer.create(8)
	n3 = replicatedStorage.decode(v110)
	table.insert(t1, {
		name = "T5 rejects short blob",
		detail = nil,
		ok = if n3.ok == false then true else false
	})
	n3 = buffer.create(buffer.len(v62))
	buffer.copy(n3, 0, v62, 0, buffer.len(v62))
	buffer.writeu32(n3, 0, 3735928559)
	v110 = replicatedStorage.decode(n3)
	table.insert(t1, {
		name = "T5 rejects bad magic",
		detail = nil,
		ok = if v110.ok == false then true else false
	})
	v110 = buffer.create(buffer.len(v62))
	buffer.copy(v110, 0, v62, 0, buffer.len(v62))
	buffer.writeu8(v110, 4, 99)
	n3 = replicatedStorage.decode(v110)
	v110 = n3.ok == false
	formattedText2 = tostring(n3.err)
	table.insert(t1, {
		name = "T5 rejects future formatVersion",
		ok = v110,
		detail = formattedText2
	})
	formattedText2 = buffer.create
	v110 = buffer.len(v62)
	n3 = math.floor(v110 / 2)
	v110 = formattedText2(n3)
	buffer.copy(v110, 0, v62, 0, buffer.len(v110))
	n3 = replicatedStorage.decode(v110)
	v110 = n3.ok == false
	formattedText2 = tostring(n3.err)
	table.insert(t1, {
		name = "T5 rejects truncated blob",
		ok = v110,
		detail = formattedText2
	})
	formattedText2 = v64:participantBySlot(0)
	v110 = formattedText2 ~= nil and formattedText2.userId == 8172635948271
	n3 = string.format("got %.0f, want %.0f", formattedText2 and formattedText2.userId or -1, 8172635948271)
	table.insert(t1, {
		name = "T6 big UserId survives (f64, not u32)",
		ok = v110,
		detail = n3
	})
	table.insert(t1, {
		name = "T6 participants fully decoded",
		detail = nil,
		ok = #v64.participants == 4 and formattedText2.displayName == "Player0" and formattedText2.knifeId == "ChromaKatana" and #formattedText2.abilities == 2 and formattedText2.abilities[1] == "SpeedBoost"
	})
	n3 = #v64.matchId == replicatedStorage.MATCHID_BYTES and v64.matchId:sub(1, 8) == "aaaaaaaa"
	table.insert(t1, { name = "T6 blob self-identifies with matchId", detail = nil, ok = n3 })
	n3 = formattedText2.side == 0 and v64:participantBySlot(3).side == 1
	table.insert(t1, { name = "T6 sides preserved", detail = nil, ok = n3 })

	local v115, v116 = v64:hasFlag(replicatedStorage.FLAG_HAS_OVERLAY)

	table.insert(t1, { name = "T7 overlay flag set", ok = v115, detail = v116 })
	table.insert(t1, {
		name = "T7 window decoded",
		detail = nil,
		ok = #v64.windows == 1 and v64.windows[1].trigger == replicatedStorage.TRIG_KILL
	})
	n3 = v64:findWindow(3000, 2)
	table.insert(t1, {
		name = "T7 inside window, covered slot",
		detail = nil,
		ok = if n3 == nil then false else true
	})
	n3 = v64:findWindow(3000, 0)
	table.insert(t1, {
		name = "T7 inside window, uncovered slot -> base",
		detail = nil,
		ok = if n3 == nil then true else false
	})
	n3 = v64:findWindow(9000, 2)
	table.insert(t1, {
		name = "T7 outside window -> base",
		detail = nil,
		ok = if n3 == nil then true else false
	})
	n3 = true

	for i = 1, #v64.windows do
		for j = i + 1, #v64.windows do
			local v119 = v64.windows[i]
			local v120 = v64.windows[j]

			for iterKey in pairs(v119.slotIndex) do
				if v120.slotIndex[iterKey] and not (v119.endMs < v120.startMs) and not (v120.endMs < v119.startMs) then
					n3 = false
				end
			end
		end
	end

	table.insert(t1, { name = "T7 windows non-overlapping per slot", detail = nil, ok = n3 })
	n3 = replicatedStorage.newWriter
	formattedText2 = string.rep("1", 8)
	v110 = string.rep("1", 12)
	n2 = n3({
		mode = 1,
		playerCount = 2,
		origin = Vector3.new(1024, 5000, -2048),
		startedAt = 1,
		buildVersion = 1,
		sampleRateHz = 20,
		maxSeconds = 60,
		overlayBudget = 16,
		matchId = formattedText2 .. "-1111-1111-1111-" .. v110
	}):addOverlayWindow({
		startMs = 0,
		endMs = 1000,
		trigger = replicatedStorage.TRIG_KILL,
		slots = { 0 },
		samples = { { {
			x = 0,
			y = 0,
			z = 0,
			yaw = 0,
			pitch = 0,
			camYaw = 0,
			state = 0,
			sflags = 1
		} } }
	})
	table.insert(t1, {
		name = "T7 overlay budget rejects gracefully",
		detail = nil,
		ok = if n2 == false then true else false
	})
	n2 = v64.overlayRateHz % v64.sampleRateHz == 0
	v110 = string.format("%d / %d", v64.overlayRateHz, v64.sampleRateHz)
	table.insert(t1, {
		name = "T8 overlay rate is integer multiple of base",
		ok = n2,
		detail = v110
	})
	v110 = v64.windows[1]
	n2 = 1000 / v64.sampleRateHz
	formattedText2 = v110.startMs % n2 == 0 and v110.endMs % n2 == 0
	n3 = string.format("start %d end %d step %d", v110.startMs, v110.endMs, n2)
	table.insert(t1, {
		name = "T8 window edges land on base-sample times",
		ok = formattedText2,
		detail = n3
	})
	n3 = 0

	for _, v in ipairs({
		1700,
		1750,
		2000,
		2500,
		3000,
		3500,
		4000,
		4200
	}) do
		for _, iterValue in ipairs({ 2, 3 }) do
			local n6 = v / 1000 * v64.sampleRateHz
			local floored2 = math.floor(n6)

			if n6 == floored2 and iterValue ~= 3 then
				local v128 = v64:baseSample(n6, iterValue)
				local v129 = v64:windowSample(v110, (v - v110.startMs) / 1000 * v64.overlayRateHz, iterValue)
				local absoluteValue4 = math.abs(v128.x - v129.x)
				local absoluteValue5 = math.abs(v128.z - v129.z)

				n3 = math.max(n3, absoluteValue4, absoluteValue5)
			end
		end
	end

	v110 = n3 <= replicatedStorage.POS_TOLERANCE * 2
	formattedText2 = string.format("worst %.6f", n3)
	table.insert(t1, {
		name = "T8 overlay and base agree at coincident samples",
		ok = v110,
		detail = formattedText2
	})
	formattedText2 = buildSynthetic(replicatedStorage, { noOverlay = true }):finalize()
	v110 = replicatedStorage.decode(formattedText2)
	formattedText2 = v110.ok

	if formattedText2 then
		formattedText2 = false

		if #v110.replay.windows == 0 then
			formattedText2 = not v110.replay:hasFlag(replicatedStorage.FLAG_HAS_OVERLAY)
		end
	end

	table.insert(t1, {
		name = "T8 blob without overlay decodes cleanly",
		detail = nil,
		ok = formattedText2
	})
	formattedText2 = v110.replay:stateAt(9000, 1)
	v110 = v64:stateAt(9000, 1)
	v64 = math.abs(formattedText2.x - v110.x) <= 1E-9

	if v64 then
		v64 = math.abs(formattedText2.z - v110.z) <= 1E-9
	end

	table.insert(t1, {
		name = "T8 base track identical with and without overlay",
		detail = nil,
		ok = v64
	})
	v64 = replicatedStorage.newWriter({
		matchId = "00000000-0000-4000-8000-000000000001",
		mode = 1,
		playerCount = 2,
		origin = Vector3.new(0, 0, 0),
		startedAt = 1700000000,
		buildVersion = 3902,
		sampleRateHz = 20,
		maxSeconds = 10
	})
	v64:addParticipant({
		userId = 8172635948271,
		slot = 0,
		side = 0,
		pflags = 0,
		displayName = "Alpha",
		knifeId = "ChromaKatana",
		revolverId = "Rev",
		abilities = { "XRay" }
	})
	v64:addParticipant({
		userId = 1,
		slot = 1,
		side = 1,
		pflags = 0,
		displayName = "Beta",
		knifeId = "K",
		revolverId = "R",
		abilities = {}
	})

	for i = 0, 39 do
		v64:writeSample(i, 0, {
			y = 10,
			yaw = 0.5,
			pitch = -0.25,
			camYaw = 0.75,
			state = 1,
			sflags = 3,
			x = i * 1.5,
			z = -i * 0.25
		})
		v64:writeSample(i, 1, {
			y = 10,
			yaw = -1,
			pitch = 0.1,
			camYaw = -0.8,
			state = 0,
			sflags = 1,
			x = -i,
			z = i
		})
	end

	v64:addRound({
		startSample = 0,
		endSample = 39,
		winnerSide = 0,
		rflags = 0,
		kills = { [0] = 1, 0 }
	})
	v64:addEvent({
		timeMs = 500,
		actorSlot = 0,
		targetSlot = 1,
		payload = "XY",
		etype = replicatedStorage.EV_SHOT
	})
	v110 = v64:finalize()
	v64 = replicatedStorage.decode(v110)
	formattedText2 = v64.ok and v64.replay:baseSample(20, 0) or nil
	table.insert(t1, { name = "T9 vector decodes", detail = nil, ok = v64.ok })
	v64 = false

	if formattedText2 ~= nil then
		local replicatedStoragePos_tolerance = replicatedStorage.POS_TOLERANCE
		local absoluteValue6 = math.abs(formattedText2.x - 30)

		v64 = replicatedStoragePos_tolerance >= absoluteValue6

		if v64 then
			local pos_tolerance = replicatedStorage.POS_TOLERANCE
			local absoluteValue7 = math.abs(formattedText2.z - -5)

			v64 = pos_tolerance >= absoluteValue7
		end
	end

	n3 = formattedText2 and string.format("x=%.4f z=%.4f", formattedText2.x, formattedText2.z) or "nil"
	table.insert(t1, { name = "T9 vector is deterministic", ok = v64, detail = n3 })
	module.vectorSize = buffer.len(v110)
	module.vectorBlob = v110

	local t7: {[any]: any} = { 44, 48, 52, 56, 60, 64 }

	n3 = function(p9)
		local v148 = buffer.readu32(p9, 40)
		local v149 = buffer.readu32(p9, 44)
		local t8: {[any]: any} = {}
		local v151 = v148

		while v149 > v151 do
			local n1 = v151 + 11
			local v153 = buffer.readu8(p9, n1)
			local n2 = n1 + (v153 + 1)

			v153 = buffer.readu8(p9, n2)
			n1 = n2 + (v153 + 1)
			v153 = buffer.readu8(p9, n1)
			n2 = n1 + (v153 + 1)
			n1 = n2 + 1

			for _ = 1, buffer.readu8(p9, n2) do
				local v156 = buffer.readu8(p9, n1)

				n1 += v156 + 1
			end

			v153 = buffer.readu16(p9, n1)
			n2 = n1 + (v153 + 2)
			v153 = buffer.readu8(p9, n2)
			v151 = n2 + (v153 + 1)
			table.insert(t8, { n2, v151 })
		end

		v151 = 0

		for _, v in ipairs(t8) do
			v151 += v[2] - v[1]
		end

		local bufferCreate = buffer.create
		local v160 = buffer.len(p9)

		v149 = bufferCreate(v160 - v151)

		local n3 = 0
		local n4 = 0

		for _, v in ipairs(t8) do
			local n5 = v[1] - n3

			buffer.copy(v149, n4, p9, n3, n5)
			n4 += n5
			n3 = v[2]
		end

		local bufferCopy = buffer.copy
		local v167 = buffer.len(p9)

		bufferCopy(v149, n4, p9, n3, v167 - n3)
		buffer.writeu8(v149, 4, 5)

		for _, v in ipairs(t7) do
			local v170 = buffer.readu32(v149, v)

			if v170 > 0 then
				buffer.writeu32(v149, v, v170 - v151)
			end
		end

		return v149
	end
	v64 = replicatedStorage.newWriter({
		matchId = "00000000-0000-4000-8000-00000000000A",
		mode = 1,
		playerCount = 2,
		origin = Vector3.new(0, 0, 0),
		startedAt = 1700000000,
		buildVersion = 1,
		mapName = "Cabin",
		mapImage = "rbxassetid://7",
		sampleRateHz = 20,
		maxSeconds = 3
	})
	formattedText2 = string.rep("c", 300)
	v64:addParticipant({
		userId = 8172635948271,
		slot = 0,
		side = 0,
		pflags = 0,
		displayName = "Alpha",
		knifeId = "ChromaKatana",
		revolverId = "Rev",
		device = "console",
		abilities = { "XRay", "Decoy" },
		crosshair = formattedText2
	})
	v64:addParticipant({
		userId = 42,
		slot = 1,
		side = 1,
		pflags = 0,
		displayName = "Beta",
		knifeId = "K",
		revolverId = "R",
		crosshair = "",
		device = "mobile",
		abilities = {}
	})

	for i = 0, 19 do
		v64:writeSample(i, 0, {
			y = 5,
			yaw = 0.25,
			pitch = 0.1,
			camYaw = 0.5,
			bodyPitch = 0,
			bodyRoll = 0,
			state = 1,
			sflags = 1,
			x = i * 2,
			z = -i
		})
		v64:writeSample(i, 1, {
			y = 5,
			yaw = -0.5,
			pitch = 0,
			camYaw = -0.25,
			bodyPitch = 0,
			bodyRoll = 0,
			state = 0,
			sflags = 0,
			x = -i,
			z = i
		})
	end

	v64:addRound({
		startSample = 0,
		endSample = 19,
		winnerSide = 0,
		rflags = 0,
		kills = { [0] = 1, 0 }
	})
	formattedText2 = v64:finalize()
	v64 = n3(formattedText2)
	v110 = buffer.len(v64)
	n2 = buffer.len(formattedText2)
	v63 = string.format
	n1 = buffer.len(formattedText2)
	n4 = v63("v6=%d v5=%d", n1, buffer.len(v64))
	table.insert(t1, {
		name = "T10 v5 is byte-identical to v6 minus the device fields",
		ok = if v110 == n2 - 8 - 7 then true else false,
		detail = n4
	})
	n4 = replicatedStorage.decode(v64)
	n1 = n4.ok
	v63 = if n4.ok then "" else tostring(n4.err)
	table.insert(t1, { name = "T10 v5 blob decodes", ok = n1, detail = v63 })

	if n4.ok then
		local v139 = n4.replay
		local u140 = v139.formatVersion == 5
		local text = tostring(v139.formatVersion)

		table.insert(t1, {
			name = "T10 v5 reports its own version",
			ok = u140,
			detail = "got " .. text
		})
		text = #v139.participants == 2 and v139.participants[1].userId == 8172635948271 and v139.participants[2].userId == 42 and v139.participants[2].displayName == "Beta"
		u140 = string.format("n=%d", #v139.participants)
		table.insert(t1, {
			name = "T10 v5 participants intact past the first",
			ok = text,
			detail = u140
		})
		u140 = v139.participants[1].device == "" and v139.participants[2].device == ""
		text = string.format

		local text2 = tostring(v139.participants[1].device)
		local text3 = tostring(v139.participants[2].device)
		local v144 = text("%q / %q", text2, text3)

		table.insert(t1, {
			name = "T10 v5 device reads as unknown, not garbage",
			ok = u140,
			detail = v144
		})
		table.insert(t1, {
			name = "T10 v5 wide crosshair survives the shorter record",
			detail = nil,
			ok = if #v139.participants[1].crosshair == 300 then true else false
		})
		v144 = replicatedStorage.decode(formattedText2)
		text3 = v139:baseSample(10, 0)
		text2 = v144.ok and v144.replay:baseSample(10, 0) or nil
		v144 = false

		if text2 ~= nil then
			v144 = math.abs(text3.x - text2.x) <= 1E-9

			if v144 then
				v144 = math.abs(text3.z - text2.z) <= 1E-9 and text3.state == text2.state
			end
		end

		text = text2 and string.format("v5 x=%.4f / v6 x=%.4f", text3.x, text2.x) or "nil"
		table.insert(t1, {
			name = "T10 v5 sample track identical to v6",
			ok = v144,
			detail = text
		})
		text = v139.mapName == "Cabin"
		v144 = tostring(v139.mapName)
		table.insert(t1, {
			name = "T10 v5 map identity survives",
			ok = text,
			detail = "got " .. v144
		})
		v144 = replicatedStorage.merge({ v64, formattedText2 })
		table.insert(t1, {
			name = "T10 v5 merges with a v6 slice",
			detail = nil,
			ok = if v144 == nil then false else true
		})
	end

	v63 = n3(formattedText2)
	buffer.writeu8(v63, 4, 4)
	formattedText2 = replicatedStorage.decode(v63)
	v63 = not formattedText2.ok
	replicatedStorage = tostring(formattedText2.err)
	table.insert(t1, {
		name = "T10 v4 is still refused",
		ok = v63,
		detail = replicatedStorage
	})
	replicatedStorage = {}
	v63 = 0
	formattedText2 = 0

	for _, v in ipairs(t1) do
		if v.ok then
			v63 += 1
		else
			formattedText2 += 1
		end

		table.insert(replicatedStorage, string.format("%s  %s%s", if v.ok then "PASS" else "FAIL", v.name, v.detail and "   [" .. v.detail .. "]" or ""))
	end

	table.insert(replicatedStorage, "")
	n3 = string.format
	n1 = buffer.len(v62)
	table.insert(replicatedStorage, n3("%d passed, %d failed | main blob %.1f KB | vector %d B", v63, formattedText2, n1 / 1024, module.vectorSize or 0))

	return table.concat(replicatedStorage, "\n")
end

return module
