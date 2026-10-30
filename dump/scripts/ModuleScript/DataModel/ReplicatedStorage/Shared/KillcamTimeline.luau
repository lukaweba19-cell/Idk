-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function ease(p1, p2)
	return math.clamp(p1, 0, 1) ^ p2
end
local function smoothstep(p3)
	local v7 = math.clamp(p3, 0, 1)

	return v7 * v7 * (3 - v7 * 2)
end

local module: {[any]: any} = {
	LEAD_IN_MS = 1200,
	FADE_OUT_MS = 1200,
	FADE_LEAD_MS = 400,
	FlightRate = function(p4, p5)
		local n1 = p5 - p4

		if n1 <= 0 then
			return 1
		end

		return (math.max(0.1, n1 / 2200))
	end
}

function module.RateAt(p6, p7, p8)
	local n1 = p6 - p7
	local n2 = if n1 < -2000 then 1 else if n1 < 0 then math.clamp((n1 + 2000) / 2000, 0, 1) ^ 1.4 * -0.85 + 1 else if n1 < 200 then 0.15 else if n1 < 700 then math.clamp((n1 - 200) / 500, 0, 1) ^ 0.8 * 0.85 + 0.15 else 1

	if p8 == nil then
		return n2
	end

	local startMs = p8.startMs
	local endMs = p8.endMs

	if typeof(startMs) ~= "number" or typeof(endMs) ~= "number" or startMs >= endMs then
		return n2
	end

	if p6 < startMs - 45 or p6 > endMs + 45 then
		return n2
	end

	n1 = 1

	if p6 < startMs then
		local v18 = math.clamp((p6 - (startMs - 45)) / 45, 0, 1)

		n1 = v18 * v18 * (3 - v18 * 2)
	elseif p6 > endMs then
		local v19 = math.clamp((endMs + 45 - p6) / 45, 0, 1)

		n1 = v19 * v19 * (3 - v19 * 2)
	end

	local v20 = math.min(n2, module.FlightRate(startMs, endMs))

	return n2 + (v20 - n2) * n1
end
function module.RealDurationMs(p9, p10, p11, p12)
	if p9 >= p10 then
		return 0
	end

	local n1 = 0
	local v26 = p9

	while p10 > v26 do
		local v27 = math.min(5, p10 - v26)
		local v28 = module.RateAt(v26 + v27 * 0.5, p11, p12)
		local v29 = math.max(v28, 0.01)

		n1 += v27 / v29
		v26 += v27
	end

	return (math.ceil(n1))
end

return module
