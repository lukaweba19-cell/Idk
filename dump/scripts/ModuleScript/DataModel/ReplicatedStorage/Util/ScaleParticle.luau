-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, p2)
	local max = p1.Lifetime.Max
	local drag = p1.Drag
	local min = p1.Speed.Min
	local v6 = p1.Speed.Max

	local function getDistance(p3, p4, p5)
		if p4 > 0 then
			local v18 = math.exp(-p4 * p5)

			return p3 / p4 * (1 - v18)
		end

		return p3 * p5
	end
	local function getSpeedFromDistance(p6, p7, p8)
		if p7 > 0 then
			local v22 = math.exp(-p7 * p8)

			return p6 * p7 / (1 - v22)
		end

		return p6 / p8
	end

	getDistance = (if drag > 0 then min / drag * (1 - math.exp(-drag * max)) else min * max) * p2

	local n1 = (if drag > 0 then v6 / drag * (1 - math.exp(-drag * max)) else v6 * max) * p2
	local n2 = if drag > 0 then getDistance * drag / (1 - math.exp(-drag * max)) else getDistance / max
	local n3

	if drag > 0 then
		local v12 = math.exp(-drag * max)

		n3 = n1 * drag / (1 - v12)
	else
		n3 = n1 / max
	end

	p1.Speed = NumberRange.new(n2, n3)
	n1 = {}

	for _, v in ipairs(p1.Size.Keypoints) do
		table.insert(n1, NumberSequenceKeypoint.new(v.Time, v.Value * p2))
	end

	p1.Size = NumberSequence.new(n1)

	if p1.Acceleration.Magnitude > 0 then
		p1.Acceleration = p1.Acceleration * p2
	end
end
