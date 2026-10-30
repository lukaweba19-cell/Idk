-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local mathExp = math.exp
local mathSin = math.sin
local mathCos = math.cos
local mathSqrt = math.sqrt

function module.new(p1, p2, p3)
	local typeName: string = type(p1)

	assert(typeName == "number")

	local typeName2: string = type(p2)

	assert(typeName2 == "number")
	assert(p1 * p2 >= 0, "Spring does not converge")

	return (setmetatable({ d = p1, f = p2, g = p3, p = p3, v = p3 * 0 }, module))
end
function module.SetGoal(p4, p5)
	p4.g = p5
end
function module.GetPosition(p6)
	return p6.p
end
function module.GetVelocity(p7)
	return p7.v
end
function module.Update(p8, p9)
	local d = p8.d
	local n1 = p8.f * 2 * 3.141592653589793
	local g = p8.g
	local v = p8.v
	local n2 = p8.p - g
	local v22 = mathExp(-d * n1 * p9)
	local n3
	local n4

	if d == 1 then
		n3 = (n2 * (1 + n1 * p9) + v * p9) * v22 + g
		n4 = (v * (1 - n1 * p9) - n2 * (n1 * n1 * p9)) * v22
	elseif d < 1 then
		local v27 = mathSqrt(1 - d * d)
		local v28 = mathCos(n1 * v27 * p9)
		local v29 = mathSin(n1 * v27 * p9)
		local n5 = p9 * n1
		local n6 = if v27 > 0.0001 then v29 / v27 else n5 + (n5 * n5 * (v27 * v27) * (v27 * v27) / 20 - v27 * v27) * (n5 * n5 * n5) / 6
		local n7

		if n1 * v27 > 0.0001 then
			n7 = v29 / (n1 * v27)
		else
			local n8 = n1 * v27

			n7 = p9 + (p9 * p9 * (n8 * n8) * (n8 * n8) / 20 - n8 * n8) * (p9 * p9 * p9) / 6
		end

		n3 = (n2 * (v28 + d * n6) + v * n7) * v22 + g
		n4 = (v * (v28 - n6 * d) - n2 * (n6 * n1)) * v22
	else
		local v33 = mathSqrt(d * d - 1)
		local n9 = -n1 * (d - v33)
		local n10 = -n1 * (d + v33)
		local n11 = (v - n2 * n9) / (2 * n1 * v33)
		local v36 = mathExp(n9 * p9)
		local n12 = (n2 - n11) * v36

		v36 = mathExp(n10 * p9)
		v33 = n11 * v36
		n3 = n12 + v33 + g
		n4 = n12 * n9 + v33 * n10
	end

	p8.p = n3
	p8.v = n4

	return n3
end

return module
