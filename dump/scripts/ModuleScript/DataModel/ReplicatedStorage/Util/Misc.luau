-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	Emit = function(p1)
		if p1:IsA("Beam") then
			local emitDelay = p1:GetAttribute("EmitDelay")
			local emitDuration = p1:GetAttribute("EmitDuration")
			local taskDelay = task.delay
			local numberValue: number? = tonumber(emitDelay)

			taskDelay(numberValue or 0, function()
				if tonumber(emitDuration) and emitDuration ~= 0 then
					p1.Enabled = true

					if not p1:GetAttribute("pr3") then
						p1:SetAttribute("pr3", 0)
					end

					local n1 = (p1:GetAttribute("pr3") + 1) % 1000

					p1:SetAttribute("pr3", n1)
					task.wait(emitDuration)

					local pr3 = p1:GetAttribute("pr3")

					if n1 == pr3 then
						p1.Enabled = false
					end
				end
			end)

			return
		end

		local emitCount = p1:GetAttribute("EmitCount")
		local emitDelay = p1:GetAttribute("EmitDelay")
		local emitDuration = p1:GetAttribute("EmitDuration")
		local v19 = task.delay
		local numberValue: number? = tonumber(emitDelay)

		v19(numberValue or 0, function()
			local numberValue2: number? = tonumber(emitCount)

			p1:Emit(numberValue2 or 0)

			if tonumber(emitDuration) and emitDuration ~= 0 then
				p1.Enabled = true

				if not p1:GetAttribute("pr3") then
					p1:SetAttribute("pr3", 0)
				end

				local n1 = (p1:GetAttribute("pr3") + 1) % 1000

				p1:SetAttribute("pr3", n1)
				task.wait(emitDuration)

				local pr3 = p1:GetAttribute("pr3")

				if n1 == pr3 then
					p1.Enabled = false
				end
			end
		end)
	end
}

function module.EmitAll(p2)
	for iterFirst, iterSecond in p2:GetDescendants() do
		if iterSecond:IsA("ParticleEmitter") or iterSecond:IsA("Beam") then
			module.Emit(iterSecond)
		end
	end
end
function module.InitializeArray(p3)
	for _, v in ipairs(p3) do
		if typeof(v) == "string" then
			p3[v] = true
		end
	end

	for i, _ in ipairs(p3) do
		if typeof(i) ~= "string" then
			p3[i] = nil
		end
	end

	return p3
end
function module.PadNumber(p4, p5)
	local text: string = tostring(p4)

	while p5 > #text do
		text = "0" .. text
	end

	return text
end
function module.PrettyPrintTimer(p6, p7: string)
	local floored = math.floor(p6 / 86400)
	local n1 = p6 - floored * 86400
	local floored2 = math.floor(n1 / 3600)
	local n2 = n1 - floored2 * 3600
	local floored3 = math.floor(n2 / 60)
	local floored4 = math.floor(n2 - floored3 * 60 + 0.5)

	if not p7:match("d+") then
		floored2 += floored * 24
	end

	if not p7:match("h+") then
		floored3 += floored2 * 60
	end

	if not p7:match("m+") then
		floored4 += floored3 * 60
	end

	if not p7:match("m+") then
		p7 ..= ":ss"
	end

	local padNumber = module.PadNumber
	local v41 = p7:match("d+")
	local v42 = padNumber(floored, #(v41 or ""))
	local v43 = module.PadNumber

	v41 = p7:match("h+")

	local v44 = v43(floored2, #(v41 or ""))
	local v45 = module.PadNumber

	v41 = p7:match("m+")

	local v46 = v45(floored3, #(v41 or ""))
	local v47 = module.PadNumber

	v41 = p7:match("s+")

	local v48 = v47(floored4, #(v41 or ""))

	return p7:gsub("d+", v42):gsub("h+", v44):gsub("m+", v46):gsub("s+", v48)
end

module.math = {}

function module.math.dist(p8, p9)
	return (math.sqrt((p8.X - p9.X) ^ 2 + (p8.Y - p9.Y) ^ 2))
end
function module.math.round(p10, p11: number)
	if not p11 then
		p11 = 1
	end

	assert(p11 ~= 0, "Cannot round a number to the nearest 0th degree.")

	return math.floor(p10 / p11 + 0.5) * p11
end
function module.math.round2(p12, p13)
	local n1 = 10 ^ (p13 or 0)

	return math.floor(p12 * n1 + 0.5) / n1
end

module.math.right = 1.5707963267948966
module.math.straight = 3.141592653589793

function module.math.polar(p14, p15)
	if p15 then
		p14 = Vector2.new(p14, p15)
	end

	local vector2New = Vector2.new
	local squareRoot = math.sqrt(p14.X ^ 2 + p14.Y ^ 2)
	local v60 = math.atan(p14.Y / p14.X)
	local vector2 = vector2New(squareRoot, v60)

	if p14.X < 0 then
		if p14.Y > 0 then
			return Vector2.new(vector2.X, vector2.Y + module.math.straight)
		end

		if p14.Y < 0 then
			return Vector2.new(vector2.X, vector2.Y + module.math.straight)
		end

		return Vector2.new(vector2.X, module.math.straight)
	end

	if p14.X > 0 then
		if p14.Y > 0 then
			return vector2
		end

		if p14.Y < 0 then
			return Vector2.new(vector2.X, 6.283185307179586 + vector2.Y)
		end

		return Vector2.new(vector2.X, 0)
	end

	if p14.Y > 0 then
		return Vector2.new(vector2.X, module.math.right)
	end

	if p14.Y < 0 then
		return Vector2.new(vector2.X, module.math.right + module.math.straight)
	end

	return Vector2.new(0, module.math.straight * 2)
end
function module.math.cartesian(p16, p17)
	if p17 then
		p16 = Vector2.new(p16, p17)
	end

	local vector2New = Vector2.new
	local n1 = math.cos(p16.Y) * p16.X
	local sine = math.sin(p16.Y)

	return vector2New(n1, sine * p16.X)
end
function module.math.mid(p18, p19)
	return Vector2.new((p18.X + p19.X) / 2, (p18.Y + p19.Y) / 2)
end
function module.math.map(p20, p21, p22, p23, p24)
	return p23 + (p20 - p21) * (p24 - p23) / (p22 - p21)
end

module.table = {}

function module.table.Compare(p25, p26, p27)
	local typeName: string = type(p25)
	local typeName2: string = type(p26)

	if typeName ~= typeName2 then
		return false
	end

	if typeName == "table" or typeName2 == "table" then
		local v79 = getmetatable(p25)

		if not p27 and v79 and v79.__eq then
			return p25 == p26
		end

		for k, v in pairs(p25) do
			local v82 = p26[k]

			if v82 == nil or not module.table.Compare(v, v82) then
				return false
			end
		end

		for k, v in pairs(p26) do
			local v85 = p25[k]

			if v85 == nil or not module.table.Compare(v85, v) then
				return false
			end
		end

		return true
	end

	return p25 == p26
end
function module.table.shuffle(p28)
	local n1: number = #p28

	for i = n1, 1, -1 do
		local randomNumber = math.random(n1)
		local v90 = p28[i]

		p28[i] = p28[randomNumber]
		p28[randomNumber] = v90
	end

	return p28
end
function module.print(...)
	local t2: {[any]: any} = { ... }

	for k, v in pairs(t2) do
		if typeof(v) == "table" then
			t2[k] = game:GetService("HttpService"):JSONEncode(v)
		end
	end

	print(unpack(t2))
end
function module.newInstance(className, p30)
	local v96 = Instance.new(className)

	for k, v in pairs(p30) do
		v96[k] = v
	end

	return v96
end
function module.WithinAngle(p31, p32, p33)
	local v102 = p31:Dot(p32)
	local v103 = math.acos(v102)

	if p33 > 3.141592653589793 - v103 then
		return true
	end

	return false
end

local CurrentCamera: Camera = workspace.CurrentCamera

function module.WithinCamera(p34, p35, p36)
	if typeof(p34) == "CFrame" then
		p34 = p34.p
	end

	if not (p35 > (p34 - CurrentCamera.CFrame.p).Magnitude) then
		return false
	end

	if p36 then
		local v107, v108 = CurrentCamera:WorldToScreenPoint(p34)

		return v107.Z > -10
	end

	return true
end
function module.AlignCFrame(p37, p38)
	local v111 = p38 or Vector3.new(0, 1, 0)
	local p = p37.p
	local v113 = p37.LookVector:Cross(v111).Unit

	v113 = (v113.Magnitude > 0.001 and v113 or p37.RightVector).Unit

	local v114 = v113:Cross(v111)

	return CFrame.fromMatrix(p, v113, v111, v114.Unit)
end
function module.ClampCFrameY(p39, p40, p41)
	local lookVector = p39.LookVector
	local unit = (lookVector * Vector3.new(1, 0, 1)).unit
	local unitX = unit.X
	local v121 = math.clamp(lookVector.Y, p40, p41)
	local vector3 = Vector3.new(unitX, v121, unit.Z)

	return CFrame.new(Vector3.new(), vector3.unit) + p39.p
end
function module.PointWithinCylinder(p42, p43)
	local v125 = p43.Size or Vector3.new()
	local v126 = p43.CFrame or CFrame.new()
	local p = v126.p
	local v128 = typeof(p43) == "Instance" and p43:FindFirstChildOfClass("SpecialMesh")

	if v128 then
		v125 = v128.Scale / p43.Size
	end

	v128 = p42 - p

	local v129 = v126:vectorToWorldSpace(Vector3.new(0, 1, 0))

	v126 = v129:Dot(v128)

	return v126 < v125.x / 2 and v126 > -v125.x / 2 and (v128 - v126 * v129).Magnitude < math.max(v125.y, v125.z) / 2, p + (v128 - v126 * v129)
end
function module.PointWithinCone(p44, p45, p46, p47, p48)
	local n1 = p44 - p45
	local v136 = n1:Dot(p46)

	if v136 < 0 or p47 < v136 then
		return false
	end

	local n2 = p45 + p46 * v136

	return p48 > (n1 - p46 * v136).Magnitude, v136 / p47 * p48, n2, (p44 - n2).Unit
end
function module.ClampCFrameByCone(p49, p50, p51, p52, p53)
	local v143, v144, v145, v146 = module.PointWithinCone(p49.p, p50, p51, p52, p53)

	if v143 then
		local unit = (v145 - p50).Unit
		local v148 = unit:Cross(v146)

		return CFrame.fromMatrix(v145 + v146 * v144, v148, v146, -unit)
	end

	return p49
end
function module.reflectVec(p54, p55)
	local v151 = p54:Dot(p55)

	return p54 - 2 * (p55 * v151)
end
function module.rotateVectorAround(p56, p57, p58)
	return CFrame.fromAxisAngle(p58, p57):VectorToWorldSpace(p56)
end
function module.calculatePolarDifference(p59, p60, p61)
	local v158 = p61 or Vector3.new(0, 1, 0)
	local v159 = p59:Dot(v158)
	local v160 = math.acos(v159)
	local v161 = p60:Dot(v158)

	v159 = math.acos(v161)

	return v160 - v159
end
function module.calculateRadiusFromWidthHeight(p62, p63)
	local v164 = p62 or 0
	local v165 = p63 or 0

	if v165 == 0 then
		return 0, 0
	end

	return v165 / 2 + v164 ^ 2 / (8 * v165), v164 ^ 2 / (4 * v165) + v165
end
function module.calculateCenterAngleFromChordRadius(p64, p65)
	return math.asin(p64 / 2 / (2 * p65)) * 2
end
function module.ReflectCFrame(p66, p67, p68)
	local p = p67.p
	local lookVector = p67.lookVector
	local v173, v174, v175, v176, v177, v178, v179, v180, v181, v182, v183, v184 = p66:components()
	local reflectVec = module.reflectVec
	local vector3 = Vector3.new(v173, v174, v175)
	local v187 = reflectVec(vector3 - p, lookVector)
	local n1 = p + v187
	local vector32 = Vector3.new(v176, v179, v182)
	local vector33 = Vector3.new(v177, v180, v183)
	local vector34 = Vector3.new(v178, v181, v184)

	v187 = module.reflectVec(vector32, lookVector)

	local v192 = module.reflectVec(vector33, lookVector)
	local v193 = module.reflectVec(vector34, lookVector)
	local n2 = -v187

	if p68 then
		local n3 = -v193

		v193 = n2
		n2 = n3
	end

	return CFrame.new(n1.X, n1.Y, n1.Z, n2.X, v192.X, v193.X, n2.Y, v192.Y, v193.Y, n2.Z, v192.Z, v193.Z)
end
function module.CalculateColorByIntensity(p69, p70)
	if p70 > 1 then
		local n1 = Vector3.new(1 - p69.r, 1 - p69.g, 1 - p69.b) * (p70 - 1)

		return Color3.new(p69.r + n1.x, p69.g + n1.y, p69.b + n1.z)
	end

	return Color3.new(p69.r * p70, p69.g * p70, p69.b * p70)
end

module.Color3 = {}

function module.Color3.fromHEX(p71)
	local floored = math.floor(p71 / 65536)
	local floored5 = math.floor(p71 / 256)
	local floored6 = math.floor(p71 % 256)

	return Color3.fromRGB(floored % 256, floored5 % 256, floored6)
end
function module.CalculateIntensity(p72)
	return (math.sqrt(p72.R ^ 2 * 0.241 + p72.G ^ 2 * 0.691 + p72.B ^ 2 * 0.068))
end
function module.RayToCFrame(p73, p74, p75)
	if p73 then
		local cFrame = CFrame.new(p74, p74 + p75)
		local v208 = CFrame.Angles(-1.5706963267948966, 0, 0)

		return cFrame * v208
	end

	return CFrame.new(p74, p74 + p75)
end

local rayCastWhitelist = require(script.Parent.RayCastWhitelist)
local rayCast = require(script.Parent.RayCast)

module.RayCast = {}

function module.RayCast.Map(p76, p77, p78)
	return rayCastWhitelist(p76, p77, { workspace.Map }, p78)
end
function module.RayCast.Entity(p79, p80, p81)
	return rayCastWhitelist(p79, p80, { workspace.Entities }, p81)
end
function module.RayCast.Any(p82, p83, p84)
	return rayCastWhitelist(p82, p83, { workspace.Map, workspace.Entities }, p84)
end

module.ClampCFrame = {}

local function clampCFrame(p85, p86, p87, p88, p89)
	local v223 = p89 or 0.1
	local n1 = p88.p - p87
	local v225, v226 = p85(p87, n1 + n1.unit * v223, p86)

	if v225 then
		local cFrame = CFrame.new(v226, v226 + p88.LookVector)
		local cFrame2 = CFrame.new(0, 0, v223)

		return cFrame * cFrame2
	end

	return p88
end
function module.ClampCFrame.Map(...)
	return (clampCFrame(rayCastWhitelist, { workspace.Map }, ...))
end
function module.ClampCFrame.Entity(...)
	return (clampCFrame(rayCastWhitelist, { workspace.Entities }, ...))
end
function module.ClampCFrame.Any(...)
	return (clampCFrame(rayCastWhitelist, { workspace.Map, workspace.Entities }, ...))
end
function module.ClampCFrame.Ignore(p90, p91, p92, p93)
	return (clampCFrame(rayCast, p93, p90, p91, p92))
end
function module.ClampCFrame.Accept(p94, p95, p96, p97)
	return (clampCFrame(rayCastWhitelist, p97, p94, p95, p96))
end
function module.ClampPoint(p98, p99, p100, p101)
	local n1 = p99 - p98
	local magnitude = n1.Magnitude
	local unit = n1.Unit

	if p101 < magnitude then
		local cFrame = CFrame.new(p98, p99)
		local vector3 = Vector3.new(0, 0, -p101)

		return cFrame * vector3
	end

	if p100 > magnitude then
		local cFrame = CFrame.new(p98, p99)
		local vector3 = Vector3.new(0, 0, -p100)

		return cFrame * vector3
	end

	return p99
end
function module.AddOffset(p102, p103)
	local typeName = typeof(p102)

	if typeName == "Instance" then
		if typeName:IsA("AnimationTrack") then
			typeName.TimePosition = typeName.TimePosition + p103

			return typeName
		end
	elseif typeName == "number" then
		typeName += p103
	end

	return typeName
end

module.Physics = {
	Trajectory = function(p104, p105, p106, p107)
		return 0.5 * p106 * p107 ^ 2 + p105 * p107 + p104
	end,
	Velocity = function(p108, p109, p110, p111)
		return (p109 - p108 - 0.5 * p110 * p111 ^ 2) / p111
	end,
	GravityFromHeight = function(p112, p113)
		return p112 * p112 / (2 * p113)
	end
}
module.Particles = {}

function module.Particles.ScaleKeypoint(p114, p115)
	local v263 = math.max(0, p114.Value * p115)

	return NumberSequenceKeypoint.new(p114.Time, v263, v263 < p114.Envelope and v263 or p114.Envelope)
end
function module.Particles.ScaleColorKeypoint(p116, p117)
	local v266 = module.CalculateColorByIntensity(p116.Value, p117)

	return ColorSequenceKeypoint.new(p116.Time, v266)
end
function module.Particles.ScaleKeypoints(p118, p119)
	if type(p118) ~= "table" then
		p118 = p118.Keypoints
	end

	local t3: {[any]: any} = {}

	for _, v in pairs(p118) do
		table.insert(t3, module.Particles.ScaleKeypoint(v, p119))
	end

	return NumberSequence.new(t3)
end
function module.Particles.ScaleColorKeypoints(p120, p121)
	if type(p120) ~= "table" then
		p120 = p120.Keypoints
	end

	local t4: {[any]: any} = {}

	for _, v in pairs(p120) do
		table.insert(t4, module.Particles.ScaleColorKeypoint(v, p121))
	end

	return ColorSequence.new(t4)
end
function module.Particles.ChangeColor(p122, p123, p124)
	if type(p122) ~= "table" then
		p122 = p122.Keypoints
	end

	local t5: {[any]: any} = {}

	for _, v in pairs(p122) do
		local v283 = module.CalculateIntensity(v.Value)

		v283 = module.CalculateColorByIntensity(p123, v283 + (p124 or 0))
		table.insert(t5, ColorSequenceKeypoint.new(v.Time, v283))
	end

	return ColorSequence.new(t5)
end
local function colorToVector(p125)
	local vector3 = Vector3.new(p125.r, p125.g, p125.b)

	return vector3
end
local function vectorToColor(p126)
	return Color3.new(p126.x, p126.y, p126.z)
end
function module.Particles.SwapColors(p127, p128, p129)
	if typeof(p127) == "Instance" and (not not p127:IsA("ParticleEmitter") or not not p127:IsA("Beam")) then
		p127 = p127.Color.Keypoints
	end

	local t6: {[any]: any} = {}

	for _, v in pairs(p127) do
		local vValue = v.Value
		local u294: boolean = false

		for _, iterValue in pairs(p128) do
			local vector3 = Vector3.new(vValue.r, vValue.g, vValue.b)
			local v298 = iterValue[1]
			local vector35 = Vector3.new(v298.r, v298.g, v298.b)

			if (p129 or 0.25) >= (vector3 - vector35).Magnitude then
				u294 = true
				table.insert(t6, ColorSequenceKeypoint.new(v.Time, iterValue[2]))
			end
		end

		if not u294 then
			table.insert(t6, v)
		end
	end

	return ColorSequence.new(t6)
end
function module.Particles.FireColors(p130, p131)
	if typeof(p130) == "Instance" and (not not p130:IsA("ParticleEmitter") or not not p130:IsA("Beam")) then
		p130 = p130.Color.Keypoints
	end

	local t7: {[any]: any} = {}

	for i = 1, #p130 do
		local v304 = p130[i]
		local v305 = p131:Lerp(v304.Value, 0.5):Lerp(Color3.new(1, 1, 1), 0.175):Lerp(p131, 0.7)

		t7[#t7 + 1] = ColorSequenceKeypoint.new(v304.Time, v305)
	end

	return ColorSequence.new(t7)
end
function module.Particles.ScaleParticle(p132, p133, p134)
	local v309 = p134 and p134.Speed or p132.Speed
	local v310 = p134 and p134.ZOffset or p132.ZOffset
	local v311 = module.Particles.ScaleKeypoints(p134 and p134.Size or p132.Size.Keypoints, p133)

	p132.Size = v311
	p132.Speed = NumberRange.new(v309.Min * p133, v309.Max * p133)
	p132.ZOffset = v310 + (p133 - 1) * v310 * (1 / p133)

	return v311
end
function module.Particles.dragRatio(p135, p136)
	return 2 ^ (p135 * -p136)
end
function module.Particles.CalculateDistance(p137, p138, p139)
	local v317 = p138 or 1
	local v318 = p139 or 0

	if v318 == 0 then
		return p137 / v317
	end

	local v319 = module.Particles.dragRatio(v317, v318)

	return -p137 / v318 * (v319 / 0.6931471805599453) + p137 / (0.6931471805599453 * v318)
end
function module.Particles.CalculateVelocity(p140, p141, p142)
	local v323 = p140 or 10
	local v324 = p141 or 1
	local v325 = p142 or 0

	if v325 == 0 then
		return v323 / v324
	end

	local v326 = module.Particles.dragRatio(v324, v325)

	return 0.6931471805599453 * v323 * v325 / (1 - v326)
end
function module.Particles.CalculateVelocity2(p143, p144, p145, p146)
	local v331 = p143 or 0
	local v332 = p144 or 0
	local v333 = p145 or 0
	local v334 = p146 or 1

	if v333 == 0 then
		return v331 + v332 * v334
	end

	return 1 / (v333 * 0.6931471805599453) * (v332 - (v332 - v333 * 0.6931471805599453 * v331) * 2.718281828459045 ^ (-v333 * 0.6931471805599453 * v334))
end
function module.Particles.CalculatePosition(p147, p148, p149, p150)
	local v339 = p147 or 0
	local v340 = p148 or 0
	local v341 = p149 or 0
	local v342 = p150 or 1

	if v341 == 0 then
		return v339 + 0.5 * v340 * v342 ^ 2
	end

	local v343 = module.Particles.dragRatio(v342, v341)

	return -1 / (0.4804530139182014 * v341 ^ 2) * (-0.6931471805599453 * v341 * v340 * v342 - v343 * (v340 - 0.6931471805599453 * v341 * v339)) - (-0.6931471805599453 * v341 * v339 + v340) / (0.4804530139182014 * v341 ^ 2)
end
function module.Particles.CalculateAcceleration(p151, p152, p153, p154)
	local v348 = p151 or 1
	local v349 = p152 or 0
	local v350 = p153 or 0
	local v351 = p154 or 1

	if v350 == 0 then
		return v348 / v351
	end

	local v352 = module.Particles.dragRatio(v351, v350)
	local v353 = module.Particles.dragRatio(v351, v350)

	return (0.4804530139182014 * v350 ^ 2 * v348 + 0.6931471805599453 * v352 * v350 * v349 - 0.6931471805599453 * v350 * v349) / (0.6931471805599453 * v350 * v351 + v353 - 1)
end
function module.MinVector(p155, p156)
	if p155.Magnitude > p156.Magnitude then
		return p156
	end

	return p155
end
function module.MaxVector(p157, p158)
	if p157.Magnitude > p158.Magnitude then
		return p157
	end

	return p158
end
function module.ClampVector(p159, p160, p161)
	local maxVector = module.MaxVector
	local v362 = module.MinVector(p159, p161)

	return maxVector(v362, p160)
end
function module.RoundVector(p162, p163)
	local v365 = p163 or 10
	local v366 = module.math.round2(p162.X, v365)
	local v367 = module.math.round2(p162.Y, v365)
	local vector3 = Vector3.new(v366, v367, module.math.round2(p162.Z, v365))

	return vector3
end

local n1: number = 0

function module.Weights(p164)
	n1 += 1

	local mathRandomseed = math.randomseed
	local timestamp = os.time()

	mathRandomseed(timestamp + n1)

	local n2 = 0

	for _, v in pairs(p164) do
		if v < 0 or v ~= math.floor(v) then
			error("Weights must be non-negative integers")
		end

		n2 += v
	end

	local randomNumber = math.random(n2)

	for k, v in pairs(p164) do
		randomNumber -= v

		if randomNumber <= 0 then
			return k
		end
	end
end

local httpService: HttpService = game:GetService("HttpService")

function module.GenerateID()
	return httpService:GenerateGUID()
end

module.GenerateId = module.GenerateID
module.generateId = module.GenerateID
module.generateID = module.GenerateID

local lighting: Lighting = game:GetService("Lighting")

function module.GetCelestialObjectDirection()
	local v378 = lighting:GetSunDirection()
	local v379 = v378:Dot(Vector3.new(0, 1, 0))
	local v380 = math.acos(v379)

	if v380 >= 1.3962634015954636 then
		v378 = lighting:GetMoonDirection()

		local v381 = v378:Dot(Vector3.new(0, 1, 0))

		v380 = math.acos(v381)

		if v380 >= 1.3962634015954636 then
			v378 = Vector3.new(0, 1, 0)
		end
	end

	return v378, v380
end
function module.GetCelestialObjectPosition(p165, p166, _)
	local v385 = p165 or Vector3.new()
	local v386 = p166 or 10
	local v387, v388 = module.GetCelestialObjectDirection()
	local v389, v390, v391 = module.RayCast.Map(v385, v387 * v386)

	if v389 then
		v386 = math.max(0, (v385 - v390).Magnitude - 4)
	end

	return v385 + v387 * v386
end
function module.calculateTextBuffer(p168, p169)
	local v394 = p169 or 200
	local n1: number = 0

	for iterValue in string.gmatch(p168, "([^.%s]+)") do
		n1 += 1
	end

	return n1 % v394 / (v394 / 60)
end
function module.calculatePointOnSpring(p170, p171, p172, p173, p174, p175)
	local v403 = p172 or 1
	local v404 = p174 or 0
	local v405 = p175 or 1
	local n1 = -v405 * 2 * 3.141592653589793 * (v405 == 1 and v404 or 1 - v404) * (p173 or 0)
	local sine = math.sin(n1)
	local cosine = math.cos(n1)
	local vector3 = Vector3.new(v403 * sine, v403 * cosine, 0)

	return (p171 - p170) * v404 + vector3
end
function module.cubicBezier(p176, p177, p178, p179, p180)
	return (1 - p176) ^ 3 * p177 + 3 * (1 - p176) ^ 2 * p176 * p178 + 3 * (1 - p176) * p176 ^ 2 * p179 + p176 ^ 3 * p180
end
function module.modelTrajectoryPath(p181, p182, p183, p184)
	local n1 = 0.5 * p181 * p184 * p184 + p182 * p184 + p183
	local n2 = n1 - (p181 * p184 * p184 + p182 * p184) / 3
	local n3 = (0.125 * p181 * p184 * p184 + 0.5 * p182 * p184 + p183 - 0.125 * (p183 + n1)) / 0.375 - n2
	local magnitude = (n3 - p183).magnitude
	local v423 = (n2 - n1).magnitude
	local unit = (p183 - n1).unit
	local v425 = (n3 - p183).unit
	local v426 = v425:Cross(unit).unit
	local v427 = (n2 - n1).unit
	local v428 = v427:Cross(unit).unit
	local v429 = v426:Cross(v425).unit
	local cFrame = CFrame.new(p183.x, p183.y, p183.z, v425.x, v426.x, v429.x, v425.y, v426.y, v429.y, v425.z, v426.z, v429.z)
	local cFrame3 = CFrame.new(n1.x, n1.y, n1.z, v427.x, v428.x, v429.x, v427.y, v428.y, v429.y, v427.z, v428.z, v429.z)

	return magnitude, -v423, cFrame, cFrame3
end
function module.getPointOnBeam(p185, p186)
	local worldPosition = p185.Attachment0.WorldPosition
	local worldCFrame = p185.Attachment0.WorldCFrame
	local vector3 = Vector3.new(p185.CurveSize0, 0, 0)
	local v437 = p185.Attachment1.WorldCFrame
	local vector36 = Vector3.new(-p185.CurveSize1, 0, 0)

	return p185.Attachment0.WorldCFrame:PointToObjectSpace(module.cubicBezier(p186 or 0.5, worldPosition, worldCFrame * vector3, v437 * vector36, p185.Attachment1.WorldPosition))
end

colorToVector = function(p187, p188, p189)
	local v442 = p187 or 0
	local v443 = p189 or 1

	return 4 * ((p188 or 0) / v443) * (-(v442 ^ 2) / v443 + v442)
end

function module.calculateVertexVector(p190, p191, p192)
	local n1 = p191 - p190
	local magnitude = n1.Magnitude

	if not p192 then
		p192 = Vector3.new(0, 1, 0)
	elseif typeof(p192) == "boolean" then
		local v449 = n1:Cross(Vector3.new(0, 1, 0)):Cross(n1)

		return v449.Magnitude > 0 and v449.Unit or Vector3.new(0, 1, 0)
	end

	return p192
end
function module.VertexTrajectory(p193, p194, p195, p196, p197)
	local magnitude = (p195 - p194).Magnitude
	local v456 = module.calculateVertexVector(p194, p195, p197)
	local v457 = p193 * magnitude or 0
	local v458 = magnitude or 1

	return p194 + (p195 - p194) * p193 + v456 * (4 * ((p196 or 0 or 0) / v458) * (-(v457 ^ 2) / v458 + v457))
end
function module.modelVertexPath(p198, p199, p200, p201)
	local v463 = p200 or 0
	local n1 = p199 - p198
	local unit = module.calculateVertexVector(p198, p199, p201).Unit
	local magnitude = n1.Magnitude
	local n2 = p198 + n1.Unit * (magnitude / 3) + unit * (4 * v463 / 3)
	local n3 = p198 + n1.Unit * (2 * magnitude / 3) + unit * (4 * v463 / 3)
	local n4 = math.sqrt(magnitude ^ 2 + 16 * v463 ^ 2) * 0.3333333333333333
	local v470 = (p198 - p199).unit
	local v471 = (n2 - p198).unit
	local v472 = v471:Cross(v470).unit
	local v473 = (n3 - p199).unit
	local v474 = v473:Cross(v470).unit
	local v475 = v472:Cross(v471).unit
	local cFrame = CFrame.new(p198.x, p198.y, p198.z, v471.x, v472.x, v475.x, v471.y, v472.y, v475.y, v471.z, v472.z, v475.z)
	local cFrame4 = CFrame.new(p199.x, p199.y, p199.z, v473.x, v474.x, v475.x, v473.y, v474.y, v475.y, v473.z, v474.z, v475.z)

	return n4, -n4, cFrame, cFrame4
end

return module
