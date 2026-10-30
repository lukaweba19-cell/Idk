-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function mix32(p1)
	local v4 = bit32.lshift(p1, 13)
	local v5 = bit32.bxor(p1, v4)

	v4 = bit32.rshift(v5, 17)

	local v6 = bit32.bxor(v5, v4)

	v4 = bit32.lshift(v6, 5)

	local v7 = bit32.bxor(v6, v4)

	return (bit32.band(v7, 4294967295))
end

local module: {[any]: any} = {
	hash32 = function(p2, p3, p4, p5)
		local v12 = bit32.band(p2, 4294967295)
		local v13 = bit32.lshift(p3, 6)
		local v14 = bit32.rshift(p3, 2)
		local n1 = v12 + 2654435769 + v13 + v14

		v13 = bit32.lshift(n1, 13)

		local v16 = bit32.bxor(n1, v13)

		v13 = bit32.rshift(v16, 17)
		n1 = bit32.bxor(v16, v13)
		v13 = bit32.lshift(n1, 5)

		local v17 = bit32.bxor(n1, v13)

		v17 = bit32.band(v17, 4294967295)
		v13 = bit32.lshift(p4, 6)
		v14 = bit32.rshift(p4, 2)
		v16 = v17 + 2246822507 + v13 + v14
		v13 = bit32.lshift(v16, 13)
		n1 = bit32.bxor(v16, v13)
		v13 = bit32.rshift(n1, 17)
		v16 = bit32.bxor(n1, v13)
		v13 = bit32.lshift(v16, 5)
		v17 = bit32.bxor(v16, v13)
		v17 = bit32.band(v17, 4294967295)
		v13 = bit32.lshift(p5, 6)
		v14 = bit32.rshift(p5, 2)
		v16 = v17 + 3266489909 + v13 + v14
		v13 = bit32.lshift(v16, 13)
		n1 = bit32.bxor(v16, v13)
		v13 = bit32.rshift(n1, 17)
		v16 = bit32.bxor(n1, v13)
		v13 = bit32.lshift(v16, 5)
		v17 = bit32.bxor(v16, v13)

		return (bit32.band(v17, 4294967295))
	end,
	makePelletId = function(p6, p7)
		return p6 * 16 + p7
	end
}

function module.computeShotgunPellets(p8, p9, p10, p11, p12, p13, p14)
	local n1 = p12 - p11

	n1 = if n1.Magnitude < 0.000001 then Vector3.new(0, 0, -1) else n1.Unit

	local v28 = n1:Cross(Vector3.new(0, 1, 0))

	if v28.Magnitude < 0.000001 then
		v28 = Vector3.new(1, 0, 0)
	end

	local unit = v28.Unit
	local v30 = unit:Cross(n1).Unit
	local t2: {[any]: any} = {}

	for i = 1, p13 do
		local v33 = module.hash32(p8, p9, p10, i)

		Random.new(v33)

		local v34 = math.rad(p14)
		local v35 = math.tan(v34 * (i / p13 - 0.5))

		v33 = n1 + unit * v35 + v30 * 0
		v33 = if v33.Magnitude < 0.000001 then n1 else v33.Unit

		local v36 = module.makePelletId(p9, i)

		table.insert(t2, { pelletId = v36, dir = v33 })
	end

	return t2
end
function module.makeEffectKey(p15, p16)
	local v39 = time()
	local floored = math.floor(v39 * 1000)
	local v41 = module.hash32(p15, p16, floored, math.random(1, 2147483647))

	return (bit32.band(v41, 2147483647))
end

return module
