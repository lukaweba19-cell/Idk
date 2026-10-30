-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local function cubicBezier(p1, p2, p3, p4, p5)
	return (1 - p5) ^ 3 * p1 + 3 * (1 - p5) ^ 2 * p5 * p2 + 3 * (1 - p5) * p5 ^ 2 * p3 + p5 ^ 3 * p4
end
local function cubicBezierDerivative(p6, p7, p8, p9, p10)
	return 3 * (1 - p10) ^ 2 * (p7 - p6) + 6 * (1 - p10) * p10 * (p8 - p7) + 3 * p10 ^ 2 * (p9 - p8)
end

local module: {[any]: any} = {}

module.__index = module

function module.new(p11, p12)
	local object = setmetatable({}, module)

	object.points = p11
	object.accuracy = p12 or 20
	object.point_count = 0
	object.cumulative_lengths = {}
	object:_recalculate()

	return object
end
function module.setPoints(p13, p14)
	p13.points = p14
	p13.ease_lut = nil
	p13:_recalculate()
end
function module.getSegmentPoints(p15, p16)
	local v21
	local v22

	if not (p16 < 1) and not (p16 > p15.point_count - 1) then
		v21 = math.max(p16 - 2, 0)
		v22 = math.max((p16 - 1) * 4 - v21, 1)

		return p15.points[v22], p15.points[v22 + 1], p15.points[v22 + 2], p15.points[v22 + 3]
	end

	if p16 <= 0 then
		return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
	end

	error("attempt to get a non-existent segment at index " .. p16)
	v21 = math.max(p16 - 2, 0)
	v22 = math.max((p16 - 1) * 4 - v21, 1)

	return p15.points[v22], p15.points[v22 + 1], p15.points[v22 + 2], p15.points[v22 + 3]
end
function module.forSample(p17, p18, p19)
	local n1 = p17.length // p18

	if n1 == 0 then
		return
	end

	for i = 0, n1 do
		local v28 = p17:getPositionArcSpace(i / n1)

		p19(v28, i)
	end
end
function module.getPosition(p20, p21)
	local v31, v32 = p20:getSegmentIndex(p21)
	local v33, v34, v35, v36 = p20:getSegmentPoints(v31)

	return (1 - v32) ^ 3 * v33 + 3 * (1 - v32) ^ 2 * v32 * v34 + 3 * (1 - v32) * v32 ^ 2 * v35 + v32 ^ 3 * v36
end
function module.getSegmentIndex(p22, p23)
	local v39 = math.clamp(p23, 0, 1)
	local n1 = p22.point_count - 1
	local n2 = v39 * n1
	local floored = math.floor(n2)
	local v43 = math.min(floored + 1, n1)
	local floored2 = math.floor(n2)

	n1 = n2 - floored2

	if v39 == 1 then
		n1 = 1
	end

	return v43, n1
end
function module.getEasedSegmentIndex(p24, p25)
	local n1 = p24.point_count - 1

	for i = 1, n1 do
		local v49, v50, v51, v52 = p24:getSegmentPoints(i)
		local x = v49.x
		local v54 = v52.x

		if p25 >= x and p25 < v54 then
			return i, (p25 - x) / (v54 - x)
		end
	end

	return n1, 1
end
function module._getEaseRaw(p26, p27)
	local v57, v58 = p26:getEasedSegmentIndex(p27)
	local v59, v60, v61, v62 = p26:getSegmentPoints(v57)

	for _ = 1, 5 do
		local x = v60.x
		local v65 = v61.x
		local n1 = 3 * (1 - v58) ^ 2 * (x - v59.x) + 6 * (1 - v58) * v58 * (v65 - x) + 3 * v58 ^ 2 * (v62.x - v65)

		if n1 == 0 then
			break
		end

		local n2 = ((1 - v58) ^ 3 * v59.x + 3 * (1 - v58) ^ 2 * v58 * v60.x + 3 * (1 - v58) * v58 ^ 2 * v61.x + v58 ^ 3 * v62.x - p27) / n1

		v58 -= n2

		if v58 < 0 then
			v58 = 0
		elseif v58 > 1 then
			v58 = 1
		end

		if math.abs(n2) < 0.001 then
			break
		end
	end

	return (1 - v58) ^ 3 * v59 + 3 * (1 - v58) ^ 2 * v58 * v60 + 3 * (1 - v58) * v58 ^ 2 * v61 + v58 ^ 3 * v62
end
function module._buildEaseLUT(p28)
	local v69 = table.create(65)

	for i = 0, 64 do
		v69[i] = p28:_getEaseRaw(i / 64)
	end

	p28.ease_lut = v69
end
function module.getEase(p29, p30)
	local v73 = p29.ease_lut

	if not v73 then
		p29:_buildEaseLUT()
		v73 = p29.ease_lut
	end

	local v74 = math.clamp(p30, 0, 1)
	local n1 = v74 * 64
	local floored = math.floor(n1)
	local v77 = math.min(floored + 1, 64)
	local v78 = v73[floored]
	local v79 = v73[v77]

	if v78 and v79 then
		return v78:Lerp(v79, n1 - floored)
	end

	return p29:_getEaseRaw(v74)
end
function module.getPositionArcSpace(p31, p32)
	if p31.length <= 0 then
		return p31.points[1] or Vector3.new(0, 0, 0)
	end

	local n1 = math.clamp(p32, 0, 1) * p31.cumulative_lengths[p31.accuracy + 1]
	local n2 = 1
	local n3 = p31.accuracy + 1
	local v85 = nil

	while n2 < n3 do
		v85 = n2 + (n3 - n2) // 2

		if n1 > p31.cumulative_lengths[v85] then
			n2 = v85 + 1
		else
			n3 = v85
		end
	end

	if n1 < p31.cumulative_lengths[v85] and v85 > 1 then
		v85 -= 1
	end

	n3 = p31.cumulative_lengths[v85]

	if n1 == n3 then
		return p31:getPosition((v85 - 1) / p31.accuracy)
	end

	return p31:getPosition((v85 - 1 + (n1 - n3) / (p31.cumulative_lengths[v85 + 1] - n3)) / p31.accuracy)
end
function module._recalculate(p33)
	table.clear(p33.cumulative_lengths)
	table.insert(p33.cumulative_lengths, 0)
	p33.point_count = math.ceil(#p33.points / 3)

	local n1 = 0
	local v88 = nil

	for i = 1, p33.accuracy do
		local v90 = p33:getPosition(i / p33.accuracy)

		if not v88 then
			v88 = p33:getPosition(0)
		end

		local magnitude = vector.magnitude(v90 - v88)

		n1 += magnitude
		v88 = v90
		table.insert(p33.cumulative_lengths, n1)
	end

	p33.length = n1

	for iterFirst, iterSecond in p33.cumulative_lengths, nil, nil do
		p33.cumulative_lengths[iterFirst] = iterSecond / n1
	end
end

return module
