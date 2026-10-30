-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function smootherstep(p1)
	local v5 = math.clamp(p1, 0, 1)

	return v5 * v5 * v5 * (v5 * (v5 * 6 - 15) + 10)
end

local module: {[any]: any} = {
	PARAMS = {
		THROW_SPEED = 420,
		GRAVITY_FACTOR = 0.75,
		DRAG_NEAR = 0.03,
		DRAG_FAR = 0.22,
		MIN_SPEED = 15,
		NO_DROP_DIST = 52.800000000000004,
		RAMP_DIST = 92.4,
		SPIN_RPS = 12,
		GRAVITY_MIN_SCALE = 0.15,
		GRAVITY_RAMP_SCALE = 0.85
	},
	FIXED_DT = 0.016666666666666666,
	computePowerScalar = function(p2, p3)
		local n1 = 0.3333333333333333 + (p2 or 1) * 2 / 3

		if p3 then
			n1 *= 0.5
		end

		return n1
	end
}

function module.newState(p4, p5, p6, p7)
	local params = module.PARAMS
	local v14 = p5.Magnitude > 0.001 and p5.Unit or Vector3.new(0, 0, -1)
	local v15 = module.computePowerScalar(p6, p7)

	return {
		travel = 0,
		spinAngle = 0,
		_accum = 0,
		position = p4,
		velocity = v14 * (params.THROW_SPEED * v15),
		powerScalar = v15,
		spinSpeed = 6.283185307179586 * params.SPIN_RPS * v15
	}
end
local function stepFixed(p8)
	local params = module.PARAMS
	local fixed_dt = module.FIXED_DT
	local vector3 = Vector3.new(0, -workspace.Gravity * params.GRAVITY_FACTOR, 0)
	local position = p8.position

	p8.travel = p8.travel + p8.velocity.Magnitude * fixed_dt

	local v21 = math.clamp((p8.travel - params.NO_DROP_DIST * p8.powerScalar) / (params.RAMP_DIST * p8.powerScalar), 0, 1)
	local n1 = v21 * v21 * v21 * (v21 * (v21 * 6 - 15) + 10)

	v21 = params.GRAVITY_MIN_SCALE + params.GRAVITY_RAMP_SCALE * n1

	local velocity = p8.velocity
	local v24 = math.exp(-(params.DRAG_NEAR + (params.DRAG_FAR - params.DRAG_NEAR) * n1) * fixed_dt)

	p8.velocity = velocity * v24
	p8.velocity = p8.velocity + vector3 * v21 * fixed_dt

	local magnitude = p8.velocity.Magnitude

	if magnitude > 0.001 and magnitude < params.MIN_SPEED then
		p8.velocity = p8.velocity.Unit * params.MIN_SPEED
	end

	p8.spinAngle = p8.spinAngle + p8.spinSpeed * fixed_dt
	p8.position = position + p8.velocity * fixed_dt

	return position, p8.position
end
function module.advance(p9, p10, p11)
	p9._accum = p9._accum + p10

	local n1: number = 0

	while p9._accum >= module.FIXED_DT and n1 < 8 do
		p9._accum = p9._accum - module.FIXED_DT

		local v30, v31 = stepFixed(p9)

		if p11 then
			p11(v30, v31)
		end

		n1 += 1
	end

	return n1
end

return module
