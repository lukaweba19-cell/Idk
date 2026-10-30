-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function pathUnder(p1, p2)
	local t5: {[any]: any} = {}
	local v14 = p2

	while v14 and v14 ~= p1 do
		table.insert(t5, 1, v14.Name)
		v14 = v14.Parent
	end

	if v14 ~= p1 then
		return nil
	end

	if #t5 == 0 then
		return nil
	end

	return table.concat(t5, "\001")
end
local function resolvePath(p3, p4)
	local v17 = p3

	for iterValue in p4:gmatch("[^\001]+") do
		if not v17 then
			return nil
		end

		v17 = v17:FindFirstChild(iterValue)
	end

	return v17
end

local u3 = nil
local t1: {[any]: any} = { "ReplicatedStorage", "ReplicatedFirst", "Lighting", "SoundService" }

local function staticPath(p5)
	for _, v in ipairs(t1) do
		local v2: Instance = game:FindFirstChild(v)

		if v2 and (p5 == v2 or p5:IsDescendantOf(v2)) then
			local v23 = pathUnder(v2, p5)

			if v23 then
				return v .. "\001" .. v23
			end
		end
	end

	return nil
end
local function encodeInstance(p6, p7, p8)
	local v27 = p7

	while v27 do
		local v28 = p8.actorSlots[v27]

		if v28 then
			table.insert(p6, string.pack("<BBs2", 11, v28, if v27 == p7 then "" else p7.Name))

			return
		end

		v27 = v27.Parent
	end

	v27 = p8.mapRoot and pathUnder(p8.mapRoot, p7)

	if v27 then
		table.insert(p6, string.pack("<Bs2", 10, v27))

		return
	end

	local v29 = staticPath(p7)

	if v29 then
		table.insert(p6, string.pack("<Bs2", 13, v29))

		return
	end

	if p8.onDrop then
		pcall(p8.onDrop, p7)
	end

	table.insert(p6, string.pack("<B", 0))
end

u3 = function(p9, p10, p11, p12)
	local typeName: string = typeof(p10)

	if p10 == nil then
		table.insert(p9, string.pack("<B", 0))

		return
	end

	if typeName == "boolean" then
		table.insert(p9, string.pack("<B", if p10 then 2 else 1))

		return
	end

	if typeName == "number" then
		if p10 % 1 ~= 0 or p10 ~= p10 or p10 == math.huge or p10 == -math.huge then
			table.insert(p9, string.pack("<Bf", 17, p10))

			return
		end

		if p10 >= -128 and p10 <= 127 then
			table.insert(p9, string.pack("<Bb", 14, p10))

			return
		end

		if p10 >= -32768 and p10 <= 32767 then
			table.insert(p9, string.pack("<Bi2", 15, p10))

			return
		end

		if p10 >= -2147483648 and p10 <= 2147483647 then
			table.insert(p9, string.pack("<Bi4", 16, p10))

			return
		end

		table.insert(p9, string.pack("<Bd", 3, p10))

		return
	end

	if typeName == "string" then
		local stringPack = string.pack
		local v36 = #p10 <= 65535 and p10 or p10:sub(1, 65535)

		table.insert(p9, stringPack("<Bs2", 4, v36))

		return
	end

	if typeName == "Vector3" then
		table.insert(p9, string.pack("<Bfff", 5, p10.X, p10.Y, p10.Z))

		return
	end

	if typeName == "Vector2" then
		table.insert(p9, string.pack("<Bff", 8, p10.X, p10.Y))

		return
	end

	if typeName == "Color3" then
		table.insert(p9, string.pack("<Bfff", 7, p10.R, p10.G, p10.B))

		return
	end

	if typeName == "CFrame" then
		local v37, v38 = p10:ToAxisAngle()
		local n1 = v38 * 0.5
		local sine = math.sin(n1)
		local n2 = v37.X * sine
		local n3 = v37.Y * sine
		local n4 = v37.Z * sine
		local cosine = math.cos(n1)

		n1 = p10.Position

		local v45 = string.pack
		local x = n1.X
		local y = n1.Y
		local z = n1.Z
		local rounded = math.round(n2 * 32767)
		local v50 = math.clamp(rounded, -32767, 32767)
		local rounded2 = math.round(n3 * 32767)
		local v52 = math.clamp(rounded2, -32767, 32767)
		local rounded3 = math.round(n4 * 32767)
		local v54 = math.clamp(rounded3, -32767, 32767)
		local rounded4 = math.round(cosine * 32767)
		local v56 = math.clamp(rounded4, -32767, 32767)

		table.insert(p9, v45("<Bfffi2i2i2i2", 6, x, y, z, v50, v52, v54, v56))

		return
	end

	if typeName == "EnumItem" then
		local v57 = string.pack
		local text: string = tostring(p10.EnumType)

		table.insert(p9, v57("<Bs2s2", 12, text, p10.Name))

		return
	end

	if typeName == "Instance" then
		encodeInstance(p9, p10, p11)

		return
	end

	if typeName ~= "table" then
		table.insert(p9, string.pack("<B", 0))

		return
	end

	if p12 >= 6 then
		table.insert(p9, string.pack("<B", 0))

		return
	end

	local t6: {[any]: any} = {}

	for iterKey in pairs(p10) do
		local typeName2: string = typeof(iterKey)

		if typeName2 == "string" or typeName2 == "number" then
			table.insert(t6, iterKey)
		end

		if #t6 >= 64 then
			break
		end
	end

	table.sort(t6, function(p13, p14)
		local text: string = tostring(p13)
		local text2: string = tostring(p14)

		return text < text2
	end)
	table.insert(p9, string.pack("<BI2", 9, #t6))

	for _, v in ipairs(t6) do
		u3(p9, v, p11, p12 + 1)
		u3(p9, p10[v], p11, p12 + 1)
	end
end

local function decodeValue(p17, p18, p19)
	local v67, v68 = string.unpack("<B", p17, p18)
	local v69 = v67
	local v70 = v68

	if v69 == 0 then
		return nil, v70
	end

	if v69 == 1 then
		return false, v70
	end

	if v69 == 2 then
		return true, v70
	end

	if v69 == 3 then
		local v71, v72 = string.unpack("<d", p17, v70)

		return v71, v72
	end

	if v69 == 14 then
		local v73, v74 = string.unpack("<b", p17, v70)

		return v73, v74
	end

	if v69 == 15 then
		local v75, v76 = string.unpack("<i2", p17, v70)

		return v75, v76
	end

	if v69 == 16 then
		local v77, v78 = string.unpack("<i4", p17, v70)

		return v77, v78
	end

	if v69 == 17 then
		local v79, v80 = string.unpack("<f", p17, v70)

		return v79, v80
	end

	if v69 == 4 then
		local v81, v82 = string.unpack("<s2", p17, v70)

		return v81, v82
	end

	if v69 == 5 then
		local v83, v84, v85, v86 = string.unpack("<fff", p17, v70)
		local vector3 = Vector3.new(v83, v84, v85)

		return vector3, v86
	end

	if v69 == 8 then
		local v88, v89, v90 = string.unpack("<ff", p17, v70)
		local vector2 = Vector2.new(v88, v89)

		return vector2, v90
	end

	if v69 == 7 then
		local v92, v93, v94, v95 = string.unpack("<fff", p17, v70)
		local color3 = Color3.new(v92, v93, v94)

		return color3, v95
	end

	if v69 == 6 then
		local v97, v98, v99, v100, v101, v102, v103, v104 = string.unpack("<fffi2i2i2i2", p17, v70)
		local v105 = v97
		local v106 = v98
		local v107 = v99
		local v108 = v104
		local n1 = v100 / 32767
		local n2 = v101 / 32767
		local n3 = v102 / 32767
		local n4 = v103 / 32767
		local squareRoot = math.sqrt(n1 * n1 + n2 * n2 + n3 * n3 + n4 * n4)

		if squareRoot < 0.000001 then
			local cFrame = CFrame.new(v105, v106, v107)

			return cFrame, v108
		end

		local cFrame = CFrame.new(v105, v106, v107, n1 / squareRoot, n2 / squareRoot, n3 / squareRoot, n4 / squareRoot)

		return cFrame, v108
	end

	local u117
	local u119

	if v69 == 12 then
		local v120, v121, v122 = string.unpack("<s2s2", p17, v70)

		u117 = v120
		u119 = v121

		local ok, result = pcall(function()
			local replacedText = u117:gsub("^Enum%.", "")

			return Enum[replacedText][u119]
		end)

		return ok and result or nil, v122
	end

	if v69 == 11 then
		u117 = nil
		u119 = nil

		local v125, v126, v127 = string.unpack("<Bs2", p17, v70)

		u117 = v125
		u119 = v126

		local v128 = v127
		local v129 = p19.actorModels[u117]

		if not v129 then
			return nil, v128
		end

		if u119 == "" then
			return v129, v128
		end

		if u119 == v129.Name then
			return v129, v128
		end

		return v129:FindFirstChild(u119, true), v128
	end

	if v69 == 10 then
		u117 = nil
		u119 = string.unpack

		local v130, v131 = u119("<s2", p17, v70)

		u117 = v130

		local v132 = v131

		u119 = p19.mapRoot

		if not u119 then
			u119 = nil

			return u119, v132
		end

		u119 = resolvePath
		u119 = u119(p19.mapRoot, u117)

		return u119, v132
	end

	if v69 == 13 then
		u117 = nil
		u119 = string.unpack

		local v133, v134 = u119("<s2", p17, v70)

		u117 = v133
		u119 = pcall

		local v135, v136 = u119(function()
			return (resolvePath(game, u117))
		end)

		return v135 and v136 or nil, v134
	end

	if v69 == 9 then
		u117 = nil
		u119 = string.unpack

		local v137, v138 = u119("<I2", p17, v70)

		u117 = v137

		local v139 = v138
		u119 = {}

		for _ = 1, u117 do
			local v141, v142 = decodeValue(p17, v139, p19)
			local v143 = v141
			local v144, v145 = decodeValue(p17, v142, p19)

			v139 = v145

			if v143 ~= nil then
				u119[v143] = v144
			end
		end

		return u119, v139
	end

	u117 = nil
	u119 = v70

	return u117, u119
end

local t2: {[any]: any} = {
	origin = true,
	target = true,
	hitpos = true,
	position = true,
	pos = true,
	point = true,
	cframe = true,
	worldcframe = true,
	start = true,
	endpos = true,
	from = true,
	to = true,
	muzzle = true,
	impact = true
}
local t3: {[any]: any} = {
	normal = true,
	hitnormal = true,
	dir = true,
	direction = true,
	velocity = true,
	offset = true,
	size = true,
	relcframe = true,
	lookvector = true,
	up = true,
	right = true
}

local module: {[any]: any} = {
	PathUnder = pathUnder,
	ResolvePath = resolvePath,
	Encode = function(p15, p16)
		local t7: {[any]: any} = {}

		if not pcall(u3, t7, p15, p16, 0) then
			return string.pack("<B", 0)
		end

		return table.concat(t7)
	end,
	CFRAME_ROT_TOLERANCE_DEG = 0.1,
	Decode = function(p20, p21)
		if p20 == "" then
			return nil
		end

		local ok, result = pcall(function()
			return (decodeValue(p20, 1, p21))
		end)

		if not ok then
			return nil
		end

		return result
	end
}

function module.Rebase(p22, p23, p24)
	if p23.Magnitude < 0.0001 then
		return p22
	end

	local v156 = p24 or 0

	if v156 > 6 or typeof(p22) ~= "table" then
		return p22
	end

	for k, v in pairs(p22) do
		local v159 = typeof(k) == "string" and string.lower(k) or ""

		if typeof(v) == "table" then
			module.Rebase(v, p23, v156 + 1)
		elseif not t3[v159] and t2[v159] then
			if typeof(v) == "Vector3" or typeof(v) == "CFrame" then
				p22[k] = v + p23
			end
		end
	end

	return p22
end

return module
