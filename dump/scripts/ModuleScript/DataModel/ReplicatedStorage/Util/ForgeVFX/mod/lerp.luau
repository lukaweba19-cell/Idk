-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("./color/Oklab")

local module: {[any]: any} = {
	number = function(p1, p2, p3)
		return p1 + (p2 - p1) * p3
	end,
	Vector3 = function(p4, p5, p6)
		return p4:Lerp(p5, p6)
	end,
	Vector2 = function(p7, p8, p9)
		return p7:Lerp(p8, p9)
	end,
	CFrame = function(p10, p11, p12)
		return p10:Lerp(p11, p12)
	end,
	UDim2 = function(p13, p14, p15)
		return p13:Lerp(p14, p15)
	end
}

function module.UDim(p16, p17, p18)
	local uDimNew = UDim.new
	local v23 = module.number(p16.Scale, p17.Scale, p18)

	return uDimNew(v23, module.number(p16.Offset, p17.Offset, p18))
end
function module.NumberRange(p19, p20, p21)
	local numberRangeNew = NumberRange.new
	local v28 = module.number(p19.Min, p20.Min, p21)

	return numberRangeNew(v28, module.number(p19.Max, p20.Max, p21))
end
function module.Color3(p22, p23, p24)
	local toSRGB = v1.toSRGB
	local v33 = v1.fromSRGB(p22)
	local v34 = v1.fromSRGB(p23)

	return toSRGB(v33:Lerp(v34, p24))
end
function module.PhysicalProperties(p25, p26, p27)
	local physicalPropertiesNew = PhysicalProperties.new
	local v39 = module.number(p25.Density, p26.Density, p27)
	local v40 = module.number(p25.Friction, p26.Friction, p27)
	local v41 = module.number(p25.Elasticity, p26.Elasticity, p27)
	local v42 = module.number(p25.FrictionWeight, p26.FrictionWeight, p27)

	return physicalPropertiesNew(v39, v40, v41, v42, module.number(p25.ElasticityWeight, p26.ElasticityWeight, p27))
end
function module.Rect(p28, p29, p30)
	local rectNew = Rect.new
	local v47 = p28.Min:Lerp(p29.Min, p30)

	return rectNew(v47, p28.Max:Lerp(p29.Max, p30))
end
function module.NumberSequence(p31, p32, p33)
	local t2: {[any]: any} = {}
	local t3: {[any]: any} = {}
	local n1: number = 0

	for iterFirst, iterSecond in p31.Keypoints, nil, nil do
		local v56 = nil
		local v57 = nil

		for iterFirst2, iterSecond2 in p32.Keypoints, nil, nil do
			if iterSecond2.Time == iterSecond.Time then
				v56 = iterSecond2
				v57 = iterSecond2

				break
			end

			if iterSecond2.Time < iterSecond.Time and (v57 == nil or iterSecond2.Time > v57.Time) then
				v57 = iterSecond2
			elseif iterSecond2.Time > iterSecond.Time and (v56 == nil or iterSecond2.Time < v56.Time) then
				v56 = iterSecond2
			end
		end

		local v61
		local v63

		if v56 == v57 then
			v61 = v56.Value
			v63 = v56.Envelope
		else
			local n2 = (iterSecond.Time - v57.Time) / (v56.Time - v57.Time)

			v61 = (v56.Value - v57.Value) * n2 + v57.Value
			v63 = (v56.Envelope - v57.Envelope) * n2 + v57.Envelope
		end

		n1 += 1
		t2[n1] = NumberSequenceKeypoint.new(iterSecond.Time, (v61 - iterSecond.Value) * p33 + iterSecond.Value, (v63 - iterSecond.Envelope) * p33 + iterSecond.Envelope)
		t3[iterSecond.Time] = true
	end

	for iterFirst3, iterSecond3 in p32.Keypoints, nil, nil do
		if not t3[iterSecond3.Time] then
			local v66 = nil
			local v67 = nil

			for iterFirst4, iterSecond4 in p31.Keypoints, nil, nil do
				if iterSecond4.Time == iterSecond3.Time then
					v66 = iterSecond4
					v67 = iterSecond4

					break
				end

				if iterSecond4.Time < iterSecond3.Time and (v67 == nil or iterSecond4.Time > v67.Time) then
					v67 = iterSecond4
				elseif iterSecond4.Time > iterSecond3.Time and (v66 == nil or iterSecond4.Time < v66.Time) then
					v66 = iterSecond4
				end
			end

			local v71
			local v73

			if v66 == v67 then
				v71 = v66.Value
				v73 = v66.Envelope
			else
				local n3 = (iterSecond3.Time - v67.Time) / (v66.Time - v67.Time)

				v71 = (v66.Value - v67.Value) * n3 + v67.Value
				v73 = (v66.Envelope - v67.Envelope) * n3 + v67.Envelope
			end

			n1 += 1
			t2[n1] = NumberSequenceKeypoint.new(iterSecond3.Time, (iterSecond3.Value - v71) * p33 + v71, (iterSecond3.Envelope - v73) * p33 + v73)
		end
	end

	table.sort(t2, function(p34, p35)
		return p34.Time < p35.Time
	end)

	local t4

	if #t2 > 20 then
		t4 = {}

		for i = 0, 19 do
			local floored = math.floor(i * ((#t2 - 1) / 19) + 1)

			table.insert(t4, t2[floored])
		end

		if t4[#t4].Time < t2[#t2].Time then
			t4[#t4] = t2[#t2]
		end
	else
		t4 = t2
	end

	return NumberSequence.new(t4)
end
local function getColorAtTime(p36, p37)
	local keypoints = p36.Keypoints

	if p37 <= keypoints[1].Time then
		return keypoints[1].Value
	end

	if p37 >= keypoints[#keypoints].Time then
		return keypoints[#keypoints].Value
	end

	local v80 = nil
	local v81 = nil

	for i = 1, #keypoints do
		local v83 = keypoints[i]

		if p37 == v83.Time then
			return v83.Value
		end

		if p37 > v83.Time then
			v80 = v83
		elseif p37 < v83.Time then
			v81 = v83

			break
		end
	end

	return v80.Value:Lerp(v81.Value, (p37 - v80.Time) / (v81.Time - v80.Time))
end
function module.ColorSequence(p38, p39, p40)
	local t5: {[any]: any} = {}

	for _, v in ipairs(p39.Keypoints) do
		local v90 = getColorAtTime(p38, v.Time)
		local v91 = v1.toSRGB(v1.fromSRGB(v90:Lerp(v.Value, p40)))

		table.insert(t5, ColorSequenceKeypoint.new(v.Time, v91))
	end

	return ColorSequence.new(t5)
end
function module.Other(p41, p42, p43)
	return p43 < 0.5 and p41 or p42
end

return module
