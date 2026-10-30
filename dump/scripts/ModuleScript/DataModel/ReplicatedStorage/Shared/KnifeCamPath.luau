-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local replayFormat = require(shared:WaitForChild("ReplayFormat"))
local replayCodec = require(shared:WaitForChild("ReplayCodec"))
local knifeFlight = require(shared:WaitForChild("KnifeFlight"))
local n1 = knifeFlight.FIXED_DT * 1000
local module: {[any]: any} = {
	MIN_DISTANCE_STUDS = 30,
	MAX_LOOKBACK_MS = 1500,
	LANDING_TOLERANCE_STUDS = 14
}

local function candidateThrows(p1, p2, p3)
	local t3: {[any]: any} = {}
	local events = p1.events

	for i = #events, 1, -1 do
		local v17 = events[i]

		if not (p3 < v17.timeMs) then
			if v17.timeMs < p3 - module.MAX_LOOKBACK_MS then
				break
			end

			if v17.etype ~= replayFormat.EV_REMOTE or p2 ~= v17.actorSlot then
				continue
			end

			local ok, result = pcall(string.unpack, "<s1", v17.payload)

			if not ok or result ~= "ThrowReplicate" then
				continue
			end

			table.insert(t3, v17)
		end
	end

	return t3
end

local t2: {[any]: any} = {
	mapRoot = nil,
	actorModels = {}
}

local function simulate(p4, p5, p6)
	local v23, v24, v25 = pcall(string.unpack, "<s1", p5.payload)

	if v23 and v24 == "ThrowReplicate" then
		local replayCodecDecode = replayCodec.Decode
		local substring = p5.payload:sub(v25)
		local v28 = replayCodecDecode(substring, t2)

		if typeof(v28) == "table" then
			local origin = v28.origin
			local target = v28.target

			if typeof(origin) == "Vector3" and typeof(target) == "Vector3" then
				local n3 = target - origin

				if n3.Magnitude < 0.001 then
					return nil
				end

				local n2 = origin - p4.origin
				local u33 = false
				local effects = v28.effects

				if typeof(effects) == "table" and typeof(effects.Portal) == "number" and effects.Portal > 0 then
					u33 = true
				end

				local v35 = knifeFlight.newState(n2, n3, v28.power, u33)
				u33 = { { tMs = p5.timeMs, pos = n2 } }
				local timeMs = p5.timeMs
				local t4: {[any]: any} = {}
				local v38 = p6.rewindMs or 0
				local v39 = math.min(p6.killMs + 250, p5.timeMs + 1600)

				if timeMs < v39 then
					local u40 = nil

					knifeFlight.advance(v35, knifeFlight.FIXED_DT, function(_, p8)
						u40 = p8
					end)
				end

				if 1 < 2 then
					return nil
				end

				for i = #u33, 1 + 1, -1 do
					u33[i] = nil
				end

				local pos = u33[1].pos

				return {
					throwMs = p5.timeMs,
					impactMs = u33[1].tMs,
					distance = (pos - n2).Magnitude,
					residual = math.huge,
					stepMs = n1,
					origin = n2,
					impact = pos,
					points = u33
				}
			end

			return nil
		end

		return nil
	end

	return nil
end
function module.Solve(p9, p10)
	if typeof(p9) == "table" or typeof(p9) == "userdata" then
		if typeof(p10) == "table" then
			if typeof(p10.killMs) == "number" then
				if typeof(p10.killerSlot) ~= "number" or typeof(p10.victimSlot) ~= "number" then
					return nil
				end

				if p10.killerSlot == replayFormat.NO_SLOT or p10.victimSlot == replayFormat.NO_SLOT then
					return nil
				end

				local v45 = nil
				local v46 = candidateThrows(p9, p10.killerSlot, p10.killMs)

				for _, v in ipairs(v46) do
					local v49 = simulate(p9, v, p10)

					if v49 and (v45 == nil or v49.residual < v45.residual) then
						v45 = v49
					end
				end

				if not v45 then
					return nil
				end

				if v45.residual > module.LANDING_TOLERANCE_STUDS then
					return nil
				end

				if v45.distance < module.MIN_DISTANCE_STUDS then
					return nil
				end

				if v45.impactMs <= v45.throwMs then
					return nil
				end

				return v45
			end

			return nil
		end

		return nil
	end

	return nil
end
local function catmullRom(p11, p12, p13, p14, p15)
	local n1 = p15 * p15

	return (p12 * 2 + (-p11 + p13) * p15 + (p11 * 2 - p12 * 5 + p13 * 4 - p14) * n1 + (-p11 + p12 * 3 - p13 * 3 + p14) * (n1 * p15)) * 0.5
end
function module.PositionAt(p16, p17)
	local points = p16.points
	local n1: number = #points

	if n1 == 0 then
		return Vector3.new(0, 0, 0)
	end

	if n1 == 1 or p17 <= points[1].tMs then
		return points[1].pos
	end

	if p17 >= points[n1].tMs then
		return points[n1].pos
	end

	local floored = math.floor((p17 - points[1].tMs) / p16.stepMs)
	local v61 = math.clamp(floored + 1, 1, n1 - 1)
	local v62 = math.clamp((p17 - points[v61].tMs) / p16.stepMs, 0, 1)
	local v63 = math.max(v61 - 1, 1)
	local pos = points[v63].pos
	local v65 = points[v61].pos
	local v66 = points[v61 + 1].pos
	local v67 = math.min(v61 + 2, n1)
	local v68 = points[v67].pos

	v67 = v62 * v62

	return (v65 * 2 + (-pos + v66) * v62 + (pos * 2 - v65 * 5 + v66 * 4 - v68) * v67 + (-pos + v65 * 3 - v66 * 3 + v68) * (v67 * v62)) * 0.5
end
function module.Sample(p18, p19)
	local t5: {[any]: any} = {}
	local floored = math.floor(p19)
	local v73 = math.max(floored, 2)
	local n1 = p18.impactMs - p18.throwMs

	if n1 <= 0 then
		return { p18.origin }
	end

	for i = 0, v73 - 1 do
		table.insert(t5, module.PositionAt(p18, p18.throwMs + n1 * (i / (v73 - 1))))
	end

	return t5
end

return module
