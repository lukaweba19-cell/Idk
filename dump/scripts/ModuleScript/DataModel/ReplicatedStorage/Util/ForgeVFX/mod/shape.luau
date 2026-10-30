-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local v1 = require("./utility")

local module: {[any]: any} = {
	getSurfaceCFrame = function(p1, p2, p3)
		local v6 = p2:Dot(Vector3.new(0, 1, 0))
		local absoluteValue = math.abs(v6)

		absoluteValue = CFrame.lookAt(Vector3.new(0, 0, 0), p2, if absoluteValue > 0.99 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0))

		local cFrame = CFrame.new(p3)

		return p1 * cFrame * absoluteValue
	end
}

function module.getPointWithinBox(p4, p5, p6, p7)
	debug.profilebegin("getPointWithinBox")

	local random = Random.new(p4)
	local v14 = random:NextNumber(-1, 1)
	local v15 = random:NextNumber(-1, 1)
	local vector3 = Vector3.new(v14, v15, random:NextNumber(-1, 1))
	local getSurfaceCFrame = module.getSurfaceCFrame

	v15 = Vector3.FromNormalId(p7)

	local v18 = getSurfaceCFrame(p5, v15, vector3 * (p6 / 2))

	debug.profileend()

	return v18
end
function module.getPointOnBox(p8, p9, p10, p11)
	debug.profilebegin("getPointOnBox")

	local random = Random.new(p8)
	local v24 = Vector3.FromNormalId(p11)
	local n1 = p10 / 2
	local v26 = v24:Abs()
	local v27 = random:NextNumber(-1, 1)
	local v28 = random:NextNumber(-1, 1)
	local vector3 = Vector3.new(v27, v28, random:NextNumber(-1, 1))
	local v30 = module.getSurfaceCFrame(p9, v24, vector3 * n1 * (Vector3.new(1, 1, 1) - v26) + v24 * n1)

	debug.profileend()

	return v30
end
function module.getPointWithinCylinder(p12, p13, p14, p15, p16, p17)
	debug.profilebegin("getPointWithinCylinder")

	local random = Random.new(p12)
	local v38 = random:NextNumber(p13, 1)
	local squareRoot = math.sqrt(v38)

	v38 = random:NextNumber(0, 6.283185307179586)

	if p17 == Enum.NormalId.Left or p17 == Enum.NormalId.Right then
		local v40 = CFrame.fromOrientation(0, 1.5707963267948966 * (if p17 == Enum.NormalId.Right then -1 else 1), 0)

		p15 *= v40
		p16 = Vector3.new(p16.Z, p16.Y, p16.X)
	elseif p17 == Enum.NormalId.Front or p17 == Enum.NormalId.Back then
		local v41 = CFrame.fromOrientation(0, 3.141592653589793, 0)

		p15 *= v41
	end

	local v42 = random:NextNumber()
	local lerp = v1.lerp
	local squareRoot2 = math.sqrt(p14)
	local v45 = lerp(0.5, 1, squareRoot2)
	local n1 = 1 - v42 ^ v45

	v42 = v1.lerp(1, p14, n1)

	local sine = math.sin(v38)
	local cosine = math.cos(v38)
	local vector3 = Vector3.new(n1 * 2 - 1, squareRoot * sine * v42, squareRoot * cosine * v42)
	local sine2 = math.sin(v38)
	local cosine2 = math.cos(v38)
	local vector32 = Vector3.new(0, sine2 * v42, cosine2 * v42)
	local cosine3 = math.cos(v38)
	local sine3 = math.sin(v38)

	n1 = Vector3.new(0, cosine3 * v42, -sine3 * v42) * p16 / 2
	v42 = n1.Magnitude > 0.001 and n1.Unit or p15.UpVector

	local cFrame = CFrame.new(vector3 * p16 / 2)
	local v56 = CFrame.lookAt(Vector3.new(0, 0, 0), vector32 * p16 / 2, v42)

	debug.profileend()

	return p15 * cFrame * v56
end
function module.getPointWithinSphere(p18, p19, p20, p21, p22, p23)
	debug.profilebegin("getPointWithinSphere")

	local random = Random.new(p18)
	local v64 = random:NextNumber()
	local v65 = random:NextNumber()
	local n1 = v64 * 2 * 3.141592653589793

	v64 = math.acos(2 * v65 - 1) * p20
	v65 = random:NextNumber(p19, 1) ^ 0.3333333333333333

	local sine = math.sin(n1)
	local cosine = math.cos(n1)
	local sine4 = math.sin(v64)
	local cosine4 = math.cos(v64)
	local v71 = Vector3.FromNormalId(p23)

	if p23 == Enum.NormalId.Left or p23 == Enum.NormalId.Right then
		p22 = Vector3.new(p22.Z, p22.Y, p22.X)
	elseif p23 == Enum.NormalId.Top or p23 == Enum.NormalId.Bottom then
		p22 = Vector3.new(p22.X, p22.Z, p22.Y)
	end

	local n2 = p22 / 2
	local v73 = module.getSurfaceCFrame(p21, v71, Vector3.new(0, 0, 0))

	v64 = Vector3.new(v65 * sine4 * cosine, v65 * sine4 * sine, v65 * cosine4) * n2

	local n3 = Vector3.new(-sine4 * sine, sine4 * cosine, 0) * n2

	n2 = if n3.Magnitude > 0.001 then n3.Unit else Vector3.new(1, 0, 0)

	local v75 = CFrame.Angles(0, 3.141592653589793, 0)
	local cFrame = CFrame.new(v64)
	local v77 = CFrame.lookAt(Vector3.new(0, 0, 0), v64, n2)

	debug.profileend()

	return v73 * v75 * cFrame * v77
end
function module.getPointWithinDisc(p24, p25, p26, p27, p28, p29)
	debug.profilebegin("getPointWithinDisc")

	local random = Random.new(p24)
	local v85 = Vector3.FromNormalId(p29)
	local v86 = v85:Abs()
	local n1 = p28 / 2
	local v88 = random:NextNumber(p25, 1)
	local v89 = v1.lerp(1, 0.5, p26 ^ 4)
	local n2 = random:NextNumber(1 - p26, 1) ^ v89

	v89 = random:NextNumber(0, 6.283185307179586)

	local sine = math.sin(v89)
	local cosine = math.cos(v89)
	local vector3 = Vector3.new(v88 * 2 - 1, n2 * sine, n2 * cosine)

	if p29 == Enum.NormalId.Bottom or p29 == Enum.NormalId.Top then
		vector3 = Vector3.new(vector3.Z, vector3.X, vector3.Y)
	elseif p29 == Enum.NormalId.Front or p29 == Enum.NormalId.Back then
		vector3 = Vector3.new(vector3.Y, vector3.Z, vector3.X)
	end

	n2 = module.getSurfaceCFrame(p27, v85, vector3 * (n1 * (Vector3.new(1, 1, 1) - v86 * p25)) + v85 * p25 * n1)
	debug.profileend()

	return n2
end

return module
