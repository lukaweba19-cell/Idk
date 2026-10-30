-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

function module.new(p1)
	local v3 = p1 or 0
	local timestamp = tick()

	return (setmetatable({
		_damper = 1,
		_speed = 1,
		_time0 = timestamp,
		_position0 = v3,
		_velocity0 = 0 * v3,
		_target = v3
	}, module))
end
function module.Impulse(p2, p3)
	p2.Velocity = p2.Velocity + p3
end
function module.TimeSkip(p4, p5)
	local timestamp = tick()
	local v10, v11 = p4:_positionVelocity(timestamp + p5)

	p4._position0 = v10
	p4._velocity0 = v11
	p4._time0 = timestamp
end
function module.__index(p6, p7)
	if module[p7] then
		return module[p7]
	end

	if p7 == "Value" or p7 == "Position" or p7 == "p" then
		local v14, v15 = p6:_positionVelocity(tick())

		return v14
	end

	if p7 == "Velocity" or p7 == "v" then
		local v16, v17 = p6:_positionVelocity(tick())

		return v17
	end

	if p7 == "Target" or p7 == "t" then
		return p6._target
	end

	if p7 == "Damper" or p7 == "d" then
		return p6._damper
	end

	if p7 == "Speed" or p7 == "s" then
		return p6._speed
	end

	local v18 = ("%q is not a valid member of Spring"):format((tostring(p7)))

	error(v18, 2)
end
function module.__newindex(p8, p9, p10)
	local timestamp = tick()

	if p9 == "Value" or p9 == "Position" or p9 == "p" then
		local v23, v24 = p8:_positionVelocity(timestamp)

		p8._position0 = p10
		p8._velocity0 = v24
	elseif p9 == "Velocity" or p9 == "v" then
		local v25, v26 = p8:_positionVelocity(timestamp)

		p8._position0 = v25
		p8._velocity0 = p10
	elseif p9 == "Target" or p9 == "t" then
		local v27, v28 = p8:_positionVelocity(timestamp)

		p8._position0 = v27
		p8._velocity0 = v28
		p8._target = p10
	elseif p9 == "Damper" or p9 == "d" then
		local v29, v30 = p8:_positionVelocity(timestamp)

		p8._position0 = v29
		p8._velocity0 = v30
		p8._damper = math.clamp(p10, 0, 1)
	elseif p9 == "Speed" or p9 == "s" then
		local v31, v32 = p8:_positionVelocity(timestamp)

		p8._position0 = v31
		p8._velocity0 = v32
		p8._speed = if p10 < 0 then 0 else p10
	else
		local v33 = ("%q is not a valid member of Spring"):format((tostring(p9)))

		error(v33, 2)
	end

	p8._time0 = timestamp
end
function module._positionVelocity(p11, p12)
	local _position0 = p11._position0
	local _velocity0 = p11._velocity0
	local _target = p11._target
	local _damper = p11._damper
	local _speed = p11._speed
	local n1 = _speed * (p12 - p11._time0)
	local n2 = _damper * _damper
	local squareRoot
	local n3
	local n4

	if n2 < 1 then
		squareRoot = math.sqrt(1 - n2)

		local n5 = math.exp(-_damper * n1) / squareRoot
		local cosine = math.cos(squareRoot * n1)

		n3 = n5 * cosine

		local sine = math.sin(squareRoot * n1)

		n4 = n5 * sine
	elseif n2 == 1 then
		squareRoot = 1

		local n6 = math.exp(-_damper * n1) / squareRoot

		n3 = n6
		n4 = n6 * n1
	else
		squareRoot = math.sqrt(n2 - 1)

		local n7 = math.exp((-_damper + squareRoot) * n1) / (2 * squareRoot)
		local n8 = math.exp((-_damper - squareRoot) * n1) / (2 * squareRoot)

		n3 = n7 + n8
		n4 = n7 - n8
	end

	return (squareRoot * n3 + _damper * n4) * _position0 + (1 - (squareRoot * n3 + _damper * n4)) * _target + n4 / _speed * _velocity0, -_speed * n4 * _position0 + _speed * n4 * _target + (squareRoot * n3 - _damper * n4) * _velocity0
end

return module
