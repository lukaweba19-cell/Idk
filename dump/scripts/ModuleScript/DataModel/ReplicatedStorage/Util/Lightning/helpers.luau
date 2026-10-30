-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local v3 = table.create(256)
local v4 = table.create(256)
local v5 = table.create(256)
local v6 = table.create(256)
local v7 = table.create(64)
local connection = nil
local t1: {[any]: any} = {}
local object = setmetatable({}, { __mode = "k" })

local function _getState(p1)
	local v41 = object[p1]

	if v41 then
		return v41
	end

	v41 = { gen = 0, tIn = nil, tOut = nil }
	object[p1] = v41

	return v41
end
local function _resetPartForUse(p2, parent, p4, cFrame, p6)
	p2.Anchored = true
	p2.CastShadow = false
	p2.CanCollide = false
	p2.CanQuery = false
	p2.CanTouch = false
	p2.Material = p4.Material
	p2.Color = p4.Color
	p2.Transparency = 0
	p2.CFrame = cFrame
	p2.Size = Vector3.new(0.001, 0.001, p6)
	p2.Parent = parent
end
local function _acquirePart(parent, p8, cFrame, p10)
	local n1 = #t1
	local part

	if n1 > 0 then
		part = t1[n1]
		t1[n1] = nil
	else
		part = Instance.new("Part")
	end

	n1 = object[part]

	if not n1 then
		n1 = { gen = 0, tIn = nil, tOut = nil }
		object[part] = n1
	end

	if n1.tIn and n1.tIn.PlaybackState == Enum.PlaybackState.Playing then
		n1.tIn:Cancel()
	end

	if n1.tOut and n1.tOut.PlaybackState == Enum.PlaybackState.Playing then
		n1.tOut:Cancel()
	end

	n1.tIn = nil
	n1.tOut = nil
	n1.gen = n1.gen + 1
	part.Anchored = true
	part.CastShadow = false
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Material = p8.Material
	part.Color = p8.Color
	part.Transparency = 0
	part.CFrame = cFrame
	part.Size = Vector3.new(0.001, 0.001, p10)
	part.Parent = parent

	return part, n1
end
local function _releasePart(p11)
	local t3 = object[p11]

	if not t3 then
		t3 = { gen = 0, tIn = nil, tOut = nil }
		object[p11] = t3
	end

	if t3.tIn and t3.tIn.PlaybackState == Enum.PlaybackState.Playing then
		t3.tIn:Cancel()
	end

	if t3.tOut and t3.tOut.PlaybackState == Enum.PlaybackState.Playing then
		t3.tOut:Cancel()
	end

	t3.tIn = nil
	t3.tOut = nil
	t3.gen = t3.gen + 1
	p11.Parent = nil
	t1[#t1 + 1] = p11
end
local function u15(p12)
	if p12.Parent then
		p12:Destroy()
	end
end

u15 = _releasePart

local function u16(_)
end
local function _easeOutQuad(p14)
	local n1 = 1 - math.clamp(p14, 0, 1)

	return 1 - n1 * n1
end
local function _easeInOutQuad(p15)
	local v60 = math.clamp(p15, 0, 1)

	if v60 < 0.5 then
		return v60 * 2 * v60
	end

	local n1 = v60 * -2 + 2

	return 1 - n1 * n1 * 0.5
end
local function _segmentOverlap(p16, p17)
	return (math.min(p17 * 0.55, p16 * 0.45))
end
local function _swapRemove(p18, p19)
	local n1: number = #p18

	p18[p19] = p18[n1]
	p18[n1] = nil
end
local function _pushSegByPhase(p20, p21)
	if p21 < p20.showAt then
		v3[#v3 + 1] = p20

		return
	end

	if p21 < p20.spawnEnd then
		v4[#v4 + 1] = p20

		return
	end

	if p21 < p20.holdEnd then
		v5[#v5 + 1] = p20

		return
	end

	if p21 < p20.fadeEnd then
		v6[#v6 + 1] = p20

		return
	end

	u15(p20.part)
end
local function _setSegVisible(p22, p23)
	if p23 == p22.visible then
		return
	end

	p22.visible = p23
	p22.part.Transparency = if p23 then 0 else 1
end
local function _setSegXY(p24, p25)
	if math.abs(p25 - p24.currentXY) <= 0.0001 then
		return
	end

	p24.currentXY = p25

	local part = p24.part

	part.Size = Vector3.new(p25, p25, part.Size.Z)
end
local function _isSegValid(p26)
	local part = p26.part

	if not part.Parent then
		return false
	end

	local t4 = object[part]

	if not t4 then
		t4 = { gen = 0, tIn = nil, tOut = nil }
		object[part] = t4
	end

	return t4.gen == p26.gen
end
local function _updateRuntimeSegments(p27)
	for i = #v3, 1, -1 do
		local v79 = v3[i]
		local part = v79.part
		local v81 = v79.part
		local u83

		if not v81.Parent then
			u83 = false
		else
			local t5 = object[v81]

			if not t5 then
				t5 = { gen = 0, tIn = nil, tOut = nil }
				object[v81] = t5
			end

			u83 = t5.gen == v79.gen
		end

		if not u83 then
			local v84 = v3
			local n1: number = #v84

			v84[i] = v84[n1]
			v84[n1] = nil
		elseif p27 >= v79.showAt then
			if v79.visible ~= true then
				v79.visible = true
				v79.part.Transparency = 0
			end

			local v86 = v3
			local n2: number = #v86

			v86[i] = v86[n2]
			v86[n2] = nil

			if p27 < v79.spawnEnd then
				v4[#v4 + 1] = v79
			elseif p27 < v79.holdEnd then
				local targetXY = v79.targetXY

				if not (math.abs(targetXY - v79.currentXY) <= 0.0001) then
					v79.currentXY = targetXY

					local v89 = v79.part

					v89.Size = Vector3.new(targetXY, targetXY, v89.Size.Z)
				end

				v5[#v5 + 1] = v79
			elseif p27 < v79.fadeEnd then
				v6[#v6 + 1] = v79
			else
				u15(part)
			end
		end
	end

	for i = #v4, 1, -1 do
		local v91 = v4[i]
		local v92 = v91.part
		local v93 = v91.part
		local u95

		if not v93.Parent then
			u95 = false
		else
			local t6 = object[v93]

			if not t6 then
				t6 = { gen = 0, tIn = nil, tOut = nil }
				object[v93] = t6
			end

			u95 = t6.gen == v91.gen
		end

		if not u95 then
			local v96 = v4
			local n3: number = #v96

			v96[i] = v96[n3]
			v96[n3] = nil
		elseif p27 >= v91.spawnEnd then
			local v98 = v91.targetXY

			if not (math.abs(v98 - v91.currentXY) <= 0.0001) then
				v91.currentXY = v98

				local v99 = v91.part

				v99.Size = Vector3.new(v98, v98, v99.Size.Z)
			end

			local v100 = v4
			local n4: number = #v100

			v100[i] = v100[n4]
			v100[n4] = nil

			if p27 < v91.holdEnd then
				v5[#v5 + 1] = v91
			elseif p27 < v91.fadeEnd then
				v6[#v6 + 1] = v91
			else
				u15(v92)
			end
		else
			local n5 = p27 - v91.showAt
			local v103 = math.max(v91.spawnEnd - v91.showAt, 0.0001)
			local minXY = v91.minXY
			local n6 = v91.targetXY - v91.minXY
			local n7 = 1 - math.clamp(n5 / v103, 0, 1)

			n5 = minXY + n6 * (1 - n7 * n7)

			if not (math.abs(n5 - v91.currentXY) <= 0.0001) then
				v91.currentXY = n5

				local v107 = v91.part

				v107.Size = Vector3.new(n5, n5, v107.Size.Z)
			end
		end
	end

	for i = #v5, 1, -1 do
		local v109 = v5[i]
		local v110 = v109.part
		local v111 = v109.part
		local u113

		if not v111.Parent then
			u113 = false
		else
			local t7 = object[v111]

			if not t7 then
				t7 = { gen = 0, tIn = nil, tOut = nil }
				object[v111] = t7
			end

			u113 = t7.gen == v109.gen
		end

		if not u113 then
			local v114 = v5
			local n8: number = #v114

			v114[i] = v114[n8]
			v114[n8] = nil
		else
			if v109.visible ~= true then
				v109.visible = true
				v109.part.Transparency = 0
			end

			local v116 = v109.targetXY

			if not (math.abs(v116 - v109.currentXY) <= 0.0001) then
				v109.currentXY = v116

				local v117 = v109.part

				v117.Size = Vector3.new(v116, v116, v117.Size.Z)
			end

			if p27 >= v109.holdEnd then
				local v118 = v5
				local n9: number = #v118

				v118[i] = v118[n9]
				v118[n9] = nil

				if p27 < v109.fadeEnd then
					v6[#v6 + 1] = v109
				else
					u15(v110)
				end
			end
		end
	end

	for i = #v6, 1, -1 do
		local v121 = v6[i]
		local v122 = v121.part
		local v123 = v121.part
		local u125

		if not v123.Parent then
			u125 = false
		else
			local t8 = object[v123]

			if not t8 then
				t8 = { gen = 0, tIn = nil, tOut = nil }
				object[v123] = t8
			end

			u125 = t8.gen == v121.gen
		end

		if not u125 then
			local v126 = v6
			local n10: number = #v126

			v126[i] = v126[n10]
			v126[n10] = nil
		else
			if v121.visible ~= true then
				v121.visible = true
				v121.part.Transparency = 0
			end

			if p27 >= v121.fadeEnd then
				u15(v122)

				local v128 = v6
				local n11: number = #v128

				v128[i] = v128[n11]
				v128[n11] = nil
			else
				local n12 = p27 - v121.holdEnd
				local v131 = math.max(v121.fadeEnd - v121.holdEnd, 0.0001)
				local v132 = v121.targetXY
				local n13 = v121.minXY - v121.targetXY
				local v134 = math.clamp(n12 / v131, 0, 1)
				local n14 = v134 * -2 + 2

				n12 = v132 + n13 * (if v134 < 0.5 then v134 * 2 * v134 else 1 - n14 * n14 * 0.5)

				if not (math.abs(n12 - v121.currentXY) <= 0.0001) then
					v121.currentXY = n12

					local v136 = v121.part

					v136.Size = Vector3.new(n12, n12, v136.Size.Z)
				end
			end
		end
	end
end
local function _hasRuntimeWork()
	local u137: boolean = true

	if not (#v3 > 0) then
		u137 = true

		if not (#v4 > 0) then
			u137 = true

			if not (#v5 > 0) then
				u137 = true

				if not (#v6 > 0) then
					u137 = #v7 > 0
				end
			end
		end
	end

	return u137
end
local function _ensureRuntimeUpdater()
	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function()
		local v583 = time()

		_updateRuntimeSegments(v583)
		u16(v583)

		local u584: boolean = true

		if not (#v3 > 0) then
			u584 = true

			if not (#v4 > 0) then
				u584 = true

				if not (#v5 > 0) then
					u584 = true

					if not (#v6 > 0) then
						u584 = #v7 > 0
					end
				end
			end
		end

		if not u584 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end
local function _registerRuntimeSeg(p28, p29, p30, p31, p32, p33)
	local v144 = time()
	local v145 = math.max(0, p30)
	local v146 = math.max(0, p31)
	local v147 = math.max(v145, p32)
	local v148 = math.max(0.001, p33)
	local n1 = v145 + v146

	if v147 < n1 then
		n1 = v147
	end

	local t9 = object[p28]

	if not t9 then
		t9 = { gen = 0, tIn = nil, tOut = nil }
		object[p28] = t9
	end

	local gen = t9.gen
	local v152 = math.max(0.001, p29)

	p28.Transparency = 1
	p28.Size = Vector3.new(0.001, 0.001, p28.Size.Z)
	_pushSegByPhase({
		minXY = 0.001,
		visible = false,
		currentXY = 0.001,
		part = p28,
		gen = gen,
		targetXY = v152,
		showAt = v145,
		spawnEnd = n1,
		holdEnd = v147,
		fadeEnd = v147 + v148
	}, v144)

	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function()
		local v585 = time()

		_updateRuntimeSegments(v585)
		u16(v585)

		local u586: boolean = true

		if not (#v3 > 0) then
			u586 = true

			if not (#v4 > 0) then
				u586 = true

				if not (#v5 > 0) then
					u586 = true

					if not (#v6 > 0) then
						u586 = #v7 > 0
					end
				end
			end
		end

		if not u586 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end
local function _spawnSegmentRuntime(p34, p35, p36, p37, p38, p39, p40, p41, p42)
	local magnitude = (p35 - p34).Magnitude

	if magnitude < 0.0001 then
		return nil
	end

	local v163 = math.min(p38 * 0.55, magnitude * 0.45)
	local v164 = p39

	if not v164 then
		v164 = CFrame.new((p34 + p35) * 0.5, p35)
	end

	local v165, v166 = _acquirePart(p36, p37, v164, magnitude + v163)
	local v167 = time()

	v163 = p40 or v167
	v167 = math.max(p37.SpawnDur, 0)

	if v167 <= 0.01 then
		v167 = 0
	end

	v164 = p41

	if not v164 then
		local v168 = math.max(p37.Lifetime, 0)

		v164 = v163 + v168
	end

	local v169 = p42

	if not v169 then
		v169 = math.max(p37.FadeTime, 0.001)
	end

	_registerRuntimeSeg(v165, p38, v163, v167, v164, v169)

	return v165
end
local function sampleNumber(p43)
	if typeof(p43) == "NumberRange" then
		local min = p43.Min
		local n1 = p43.Max - p43.Min
		local randomNumber = math.random()

		return min + n1 * randomNumber
	end

	return p43
end
local function randInBox(p53)
	local v175 = p53.Size
	local n1 = (math.random() - 0.5) * v175.X
	local n2 = (math.random() - 0.5) * v175.Y
	local randomNumber = math.random()
	local vector3 = Vector3.new(n1, n2, (randomNumber - 0.5) * v175.Z)
	local v180 = p53.CFrame
	local cFrame = CFrame.new(vector3)

	return (v180 * cFrame).Position
end
local function randInSphere(p54)
	local v183 = math.min(p54.Size.X, p54.Size.Y, p54.Size.Z)
	local randomNumber = math.random()
	local randomNumber2 = math.random()
	local n1 = 6.283185307179586 * randomNumber
	local v187 = math.acos(2 * randomNumber2 - 1)
	local randomNumber3 = math.random()
	local n2 = v183 * 0.5 * randomNumber3 ^ 0.3333333333333333
	local sine = math.sin(v187)
	local cosine = math.cos(n1)
	local cosine2 = math.cos(v187)
	local sine2 = math.sin(v187)
	local sine3 = math.sin(n1)
	local v195 = p54.CFrame
	local cFrame = CFrame.new(n2 * sine * cosine, n2 * cosine2, n2 * sine2 * sine3)

	return (v195 * cFrame).Position
end
local function randInCylinder(p55)
	local v198 = math.min(p55.Size.X, p55.Size.Z)
	local y = p55.Size.Y
	local n1 = math.random() * 2 * 3.141592653589793
	local randomNumber = math.random()
	local squareRoot = math.sqrt(randomNumber)
	local n2 = v198 * 0.5 * squareRoot
	local cosine = math.cos(n1)
	local sine = math.sin(n1)
	local randomNumber4 = math.random()
	local v207 = p55.CFrame
	local cFrame = CFrame.new(n2 * cosine, (randomNumber4 - 0.5) * y, n2 * sine)

	return (v207 * cFrame).Position
end

local module: {[any]: any} = {
	NumOrRange = function(p44, p45)
		local typeName: string = typeof(p44)

		if typeName == "number" or typeName == "NumberRange" then
			return p44
		end

		return p45
	end,
	ClampNumber = function(p46, p47, p48, p49)
		local v216 = if typeof(p46) == "number" then p46 else p47

		if p48 ~= nil then
			v216 = math.max(p48, v216)
		end

		if p49 ~= nil then
			v216 = math.min(p49, v216)
		end

		return v216
	end,
	ToRange = function(p50, p51, p52)
		local typeName: string = typeof(p50)

		if typeName ~= "NumberRange" then
			if typeName == "number" then
				local v221 = p50

				if p52 ~= nil then
					v221 = math.max(p52, v221)
				end

				return NumberRange.new(v221, v221)
			end

			return p51
		end

		if p52 == nil then
			return p50
		end

		local v222 = math.max(p52, p50.Min)
		local v223 = math.max(v222, p50.Max)

		return NumberRange.new(v222, v223)
	end,
	RandomPointInPart = function(p56)
		local v225

		if p56:IsA("Part") then
			if p56.Shape == Enum.PartType.Ball then
				return (randInSphere(p56))
			end

			if p56.Shape == Enum.PartType.Cylinder then
				return (randInCylinder(p56))
			end

			v225 = randInBox(p56)

			return v225
		end

		v225 = randInBox(p56)

		return v225
	end,
	ThicknessJitterMul = function(p57)
		local v227 = math.clamp(p57, 0, 1)

		if v227 <= 0 then
			return 1
		end

		return 1 + (math.random() * 2 - 1) * v227
	end,
	FindClosestPoint = function(p58, p59)
		local cFrame = p58.CFrame
		local n1 = p58.Size * 0.5
		local v232 = cFrame:PointToObjectSpace(p59)
		local Shape = nil

		if p58:IsA("Part") then
			Shape = p58.Shape
		elseif p58:IsA("WedgePart") then
			Shape = Enum.PartType.Wedge
		elseif p58:IsA("CornerWedgePart") then
			Shape = Enum.PartType.CornerWedge
		end

		if Shape == Enum.PartType.Ball then
			local v234 = math.min(n1.X, n1.Y, n1.Z)

			if v234 >= v232.Magnitude then
				return p59
			end

			return cFrame:PointToWorldSpace(v232.Unit * v234)
		end

		if Shape == Enum.PartType.Cylinder then
			local v235 = math.min(n1.X, n1.Z)
			local v236 = math.clamp(v232.Y, -n1.Y, n1.Y)
			local vector3 = Vector3.new(v232.X, 0, v232.Z)
			local v238
			local v239

			if v235 >= vector3.Magnitude then
				v238 = v232.X
				v239 = v232.Z
			else
				local vector3Unit = vector3.Unit

				v238 = vector3Unit.X * v235
				v239 = vector3Unit.Z * v235
			end

			local vector32 = Vector3.new(v238, v236, v239)

			return cFrame:PointToWorldSpace(vector32)
		end

		Shape = math.clamp(v232.X, -n1.X, n1.X)

		local v242 = math.clamp(v232.Y, -n1.Y, n1.Y)
		local v243 = math.clamp(v232.Z, -n1.Z, n1.Z)
		local vector3 = Vector3.new(Shape, v242, v243)

		return cFrame:PointToWorldSpace(vector3)
	end,
	SafeUnit = function(p60)
		local magnitude = p60.Magnitude

		if magnitude < 0.000001 then
			return Vector3.new(0, -1, 0)
		end

		return p60 / magnitude
	end
}

local safeUnit = module.SafeUnit

function module.GetPerpBasis(p61)
	local vectorValue = Vector3.new(0, 1, 0)
	local v249 = p61:Dot(vectorValue)

	if math.abs(v249) > 0.95 then
		vectorValue = Vector3.new(1, 0, 0)
	end

	local v250 = module.SafeUnit(p61:Cross(vectorValue))

	v249 = module.SafeUnit(v250:Cross(p61))

	return v250, v249
end

local getPerpBasis = module.GetPerpBasis

function module.GetPerpBasisTransport(p62, p63)
	local v253 = module.SafeUnit(p62)

	if p63 then
		local v254 = p63:Dot(v253)
		local n1 = p63 - v253 * v254
		local magnitude = n1.Magnitude

		if magnitude > 0.000001 then
			local n2 = n1 / magnitude
			local v258 = module.SafeUnit(n2:Cross(v253))

			return n2, v258
		end

		return module.GetPerpBasis(v253)
	end

	return module.GetPerpBasis(v253)
end
function module.BuildSegmentCFrames(p64)
	local n1: number = #p64 - 1
	local tableCreate = table.create
	local v262 = math.max(n1, 0)
	local v263 = tableCreate(v262)

	v262 = nil

	for i = 1, n1 do
		local v265 = p64[i]
		local v266 = p64[i + 1]
		local v267 = safeUnit(v266 - v265)
		local v268, v269 = module.GetPerpBasisTransport(v267, v262)

		v262 = v268
		v263[i] = CFrame.fromMatrix((v265 + v266) * 0.5, v268, v269, -v267)
	end

	return v263
end
function module.ClampToEndPlane(p65, p66, p67, p68)
	local v274 = (p65 - p66):Dot(p67)

	if v274 < 0 then
		v274 = 0
	elseif p68 < v274 then
		v274 = p68
	end

	local v275 = (p65 - p66):Dot(p67)

	return p66 + p67 * v274 + (p65 - (p66 + p67 * v275))
end
function module.BuildPoints(p69, p70, p71, p72, p73, p74)
	local v282 = table.create(p71 + 1)

	v282[1] = p69
	v282[p71 + 1] = p70

	local v283 = module.SafeUnit(p70 - p69)
	local v284, v285 = module.GetPerpBasis(v283)
	local magnitude = (p70 - p69).Magnitude
	local v287 = math.clamp(p73 or 0, 0, 1)
	local floored = math.floor(p74 or 0)
	local v289 = math.max(0, floored)
	local n1 = v289 + 2
	local v291 = table.create(n1)

	v291[1] = p69
	v291[n1] = p70

	for i = 1, v289 do
		local v293 = p69:Lerp(p70, i / (v289 + 1))
		local safeUnit = module.SafeUnit
		local randomNumber = math.random()
		local randomNumber5 = math.random()
		local v297 = safeUnit(v284 * (randomNumber * 2 - 1) + v285 * (randomNumber5 * 2 - 1))
		local randomNumber6 = math.random()

		v291[i + 1] = module.ClampToEndPlane(v293 + v297 * (magnitude * v287) * (0.6 + 0.4 * randomNumber6), p69, v283, magnitude)
	end

	table.sort(v291, function(p75, p76)
		return (p75 - p69).Magnitude < (p76 - p69).Magnitude
	end)

	local function sampleBackbone(p77)
		local n1: number = #v291

		if n1 == 2 then
			return v291[1]:Lerp(v291[2], p77)
		end

		local n2 = p77 * (n1 - 1)
		local floored2 = math.floor(n2)
		local v593 = math.clamp(floored2 + 1, 1, n1 - 1)

		return v291[v593]:Lerp(v291[v593 + 1], n2 - (v593 - 1))
	end

	local n2 = 0
	local n3 = 0

	for i = 2, p71 do
		local n4 = (i - 1) / p71
		local v304 = sampleBackbone(n4)
		local absoluteValue = math.abs(n4 * 2 - 1)

		n4 = magnitude * p72 * (1 - absoluteValue)

		local randomNumber7 = math.random()
		local randomNumber8 = math.random()

		n2 = n2 * 0.55 + (randomNumber7 * 2 - 1) * n4 * 0.44999999999999996
		n3 = n3 * 0.55 + (randomNumber8 * 2 - 1) * n4 * 0.44999999999999996
		v282[i] = module.ClampToEndPlane(v304 + v284 * n2 + v285 * n3, p69, v283, magnitude)
	end

	return v282
end

local buildPoints = module.BuildPoints

function module.ScheduleThicknessFade(p78, p79, p80, p81, p82)
	local v313 = math.max(p79, 0)
	local u314 = math.max(p80, 0.001)
	local v315 = p81 or 0.001
	local t10 = object[p78]

	if not t10 then
		t10 = { gen = 0, tIn = nil, tOut = nil }
		object[p78] = t10
	end

	local gen = t10.gen

	task.delay(v313, function()
		if not p78.Parent then
			return
		end

		local v594 = p78
		local t19 = object[v594]

		if not t19 then
			t19 = { gen = 0, tIn = nil, tOut = nil }
			object[v594] = t19
		end

		if t19.gen ~= gen then
			return
		end

		if p82 and p82.PlaybackState == Enum.PlaybackState.Playing then
			p82:Cancel()
		end

		if t19.tIn and t19.tIn.PlaybackState == Enum.PlaybackState.Playing then
			t19.tIn:Cancel()
			t19.tIn = nil
		end

		if t19.tOut and t19.tOut.PlaybackState == Enum.PlaybackState.Playing then
			t19.tOut:Cancel()
		end

		local z = p78.Size.Z
		local tweenInfo = TweenInfo.new(u314, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		local vector3 = Vector3.new(v315, v315, z)
		local v599: Tween = tweenService:Create(p78, tweenInfo, { Size = vector3 })

		t19.tOut = v599
		v599:Play()
		v599.Completed:Once(function()
			local v642 = p78
			local t20 = object[v642]

			if not t20 then
				t20 = { gen = 0, tIn = nil, tOut = nil }
				object[v642] = t20
			end

			if t20.gen ~= gen then
			elseif p78.Parent then
				_releasePart(p78)
			end
		end)
	end)
end

local scheduleThicknessFade = module.ScheduleThicknessFade

function module.SpawnSegment(p83, p84, p85, p86, p87, p88)
	return (_spawnSegmentRuntime(p83, p84, p85, p86, p87, p88, nil, nil, nil))
end
function module.DrawBoltDynamic(p89, p90, p91, p92, p93)
	local t11: {[any]: any} = {}
	local v330 = module.BuildSegmentCFrames(p89)
	local v331 = math.max(1, #p89 - 1)
	local v332 = math.max(p91.SpawnDur, 0)
	local v333 = time()
	local v334 = math.max(0, p93 or 0)

	for i = 1, #p89 - 1 do
		local v336 = p89[i]
		local v337 = p89[i + 1]
		local n1 = v333 + v334 + (i - 1) * (v331 > 0 and v332 / v331 or 0)
		local v339 = math.max(p91.Lifetime, 0)
		local v340 = v330[i]
		local v341 = math.max(p91.FadeTime, 0.001)
		local v342 = _spawnSegmentRuntime(v336, v337, p90, p91, p92, v340, n1, n1 + v339, v341)

		if v342 then
			local t12 = object[v342]

			if not t12 then
				t12 = { gen = 0, tIn = nil, tOut = nil }
				object[v342] = t12
			end

			t11[#t11 + 1] = { a = i, b = i + 1, part = v342, gen = t12.gen }
		end
	end

	return t11
end
function module.SpawnSegmentRebuildTimed(p94, p95, p96, p97, p98, p99, p100, p101)
	local v352 = math.max(p100, 0.001)

	return (_spawnSegmentRuntime(p94, p95, p96, p97, p98, p101, nil, p99, v352))
end
function module.DrawBoltDynamicRebuild(p102, p103, p104, p105, p106, p107)
	local t13: {[any]: any} = {}
	local v360 = module.BuildSegmentCFrames(p102)
	local v361 = math.max(1, #p102 - 1)
	local v362 = math.max(p104.SpawnDur, 0)
	local v363 = time()

	for i = 1, #p102 - 1 do
		local v365 = v360[i]
		local v366 = math.max(p107, 0.001)
		local v367 = _spawnSegmentRuntime(p102[i], p102[i + 1], p103, p104, p105, v365, v363 + (i - 1) * (v361 > 0 and v362 / v361 or 0), p106, v366)

		if v367 then
			local t14 = object[v367]

			if not t14 then
				t14 = { gen = 0, tIn = nil, tOut = nil }
				object[v367] = t14
			end

			t13[#t13 + 1] = { a = i, b = i + 1, part = v367, gen = t14.gen }
		end
	end

	return t13
end
function module.UpdateSegmentFromPoints(p108, p109, p110)
	local part = p108.part

	if not part.Parent then
		return
	end

	local t15 = object[part]

	if not t15 then
		t15 = { gen = 0, tIn = nil, tOut = nil }
		object[part] = t15
	end

	if t15.gen ~= p108.gen then
		return
	end

	t15 = p109[p108.a]

	local v374 = p109[p108.b]
	local magnitude = (v374 - t15).Magnitude

	if magnitude < 0.0001 then
		return
	end

	part.CFrame = CFrame.new((t15 + v374) * 0.5, v374)

	local v376 = math.min(p110 * 0.55, magnitude * 0.45)

	part.Size = Vector3.new(part.Size.X, part.Size.Y, magnitude + v376)
end
function module.BuildBranchWarp(list)
	local v378 = list[1]
	local v379 = list[#list]
	local v380 = module.SafeUnit(v379 - v378)
	local v381, v382 = module.GetPerpBasis(v380)
	local v383 = table.create(#list)
	local v384 = table.create(#list)
	local v385 = table.create(#list)
	local v386 = (v379 - v378).Magnitude

	if v386 < 0.000001 then
		v386 = 1
	end

	for i = 1, #list do
		local v388 = list[i]
		local v389 = (v388 - v378):Dot(v380)
		local v390 = math.clamp(v389 / v386, 0, 1)
		local v391 = v378:Lerp(v379, v390)

		v391 = v388 - v391
		v383[i] = v390
		v384[i] = v391:Dot(v381)
		v385[i] = v391:Dot(v382)
	end

	return {
		startIndex = 1,
		endIndex = #list,
		t = v383,
		ox = v384,
		oy = v385,
		prevRight = v381
	}
end
function module.ApplyBranchWarpWithBasis(p112, p113, p114, p115, p116, p117)
	for i = 1, #p112 do
		p112[i] = p114:Lerp(p115, p113.t[i]) + p116 * p113.ox[i] + p117 * p113.oy[i]
	end

	p112[1] = p114
	p112[#p112] = p115
end
local function _buildSwayWeights(p118, p119, p120, p121)
	local v403 = table.create(p118, 0)
	local v404 = table.create(p118)

	if p118 <= 0 then
		return v403, v404
	end

	local v405 = math.max(1, p120)
	local v406 = math.max(0.1, p121)

	for i = 1, p118 do
		local v408 = table.create(#p119, 0)

		v404[i] = v408

		if i == 1 or i == p118 then
			v403[i] = 0
		else
			local v409 = math.max(p118 - 1, 1)
			local n1 = (i - 1) / v409
			local v411 = math.min(n1, 1 - n1)
			local v412 = math.clamp(v411 * 2, 0, 1)

			v403[i] = v412

			if not (v412 <= 0) then
				for j = 1, #p119 do
					local gi = p119[j].gi
					local v415 = math.max(2, p118 - 1)
					local v416 = math.clamp(gi, 2, v415)
					local absoluteValue = math.abs(i - v416)

					v408[j] = math.clamp(1 - absoluteValue / v405, 0, 1) ^ v406 * v412
				end
			end
		end
	end

	return v403, v404
end
function module.RegisterSwayAnimation(list, p123, p124, p125, p126, p127)
	if #list == 0 then
		return
	end

	local v424 = list[1]
	local basePoints = v424.basePoints
	local n1: number = #basePoints

	if n1 < 3 then
		return
	end

	local n2: number = n1 - 1
	local n3: number = n2 - 2 + 1

	if n3 <= 0 then
		return
	end

	local magnitude = (p124 - p123).Magnitude
	local v430 = math.max(0, p125.Sway_MaxOffsetFactor or 0.12)
	local v431 = math.max(0.1, p125.Sway_FalloffPower or 1.6)
	local v432 = math.max(1, p125.Sway_Grabs or 2)
	local v433 = math.clamp(v432, 1, n3)
	local t16: {[any]: any} = {}

	local function pickIndexInBin(p128, p129)
		local v602 = math.clamp(p128, 2, n2)
		local v603 = math.clamp(p129, 2, n2)

		if v602 > v603 then
			v603 = v602
		end

		for _ = 1, 10 do
			local randomNumber = math.random(v602, v603)

			if not t16[randomNumber] then
				t16[randomNumber] = true

				return randomNumber
			end
		end

		for i = v602, v603 do
			if not t16[i] then
				t16[i] = true

				return i
			end
		end

		for i = 2, n2 do
			if not t16[i] then
				t16[i] = true

				return i
			end
		end

		return 2
	end
	local function localSideDirAtIndex(p130)
		local v609 = math.clamp(p130 - 1, 1, n1)
		local v610 = math.clamp(p130 + 1, 1, n1)
		local v611 = module.SafeUnit(basePoints[v610] - basePoints[v609])
		local v612, v613 = module.GetPerpBasis(v611)
		local safeUnit = module.SafeUnit
		local randomNumber = math.random()
		local randomNumber9 = math.random()

		return safeUnit(v612 * (randomNumber * 2 - 1) + v613 * (randomNumber9 * 2 - 1))
	end

	local v437 = table.create(v433)

	local function pickDirForGrab(p131, p132)
		if p131 == 1 then
			local v619 = localSideDirAtIndex(p132)

			v437[1] = v619

			return v619
		end

		if p131 == 2 then
			for _ = 1, 20 do
				local v621 = localSideDirAtIndex(p132)

				if v621:Dot(v437[1]) < 0.2 then
					v437[2] = v621

					return v621
				end
			end

			local n1 = -v437[1]

			v437[2] = n1

			return n1
		end

		for _ = 1, 20 do
			local v624 = localSideDirAtIndex(p132)
			local u625: boolean = true

			for j = 1, #v437 do
				if v624:Dot(v437[j]) > 0.65 then
					u625 = false

					break
				end
			end

			if u625 then
				v437[#v437 + 1] = v624

				return v624
			end
		end

		local v627 = localSideDirAtIndex(p132)

		v437[#v437 + 1] = v627

		return v627
	end

	local v439 = table.create(v433)

	for i = 1, v433 do
		local floored = math.floor((i - 1) / v433 * n3)
		local floored3 = math.floor(i / v433 * n3)
		local v443 = pickIndexInBin(floored + 2, floored3 + 2 - 1)
		local v444 = pickDirForGrab(i, v443)
		local randomNumber = math.random()

		v439[i] = { gi = v443, dir = v444, strength = 0.5 + 0.5 * randomNumber }
	end

	local floored4 = math.floor((n1 - 1) * 0.16)

	pickDirForGrab = math.max(2, floored4)

	local v447, v448 = _buildSwayWeights(n1, v439, pickDirForGrab, v431)
	pickIndexInBin = {}
	v433 = {}

	for i = 2, #list do
		local v450, v451 = _buildSwayWeights(#list[i].basePoints, v439, pickDirForGrab, v431)

		pickIndexInBin[i] = v450
		v433[i] = v451
	end

	local pointsRef = v424.pointsRef
	local v453 = math.max(p126, 0)
	local v454 = time()

	v7[#v7 + 1] = {
		guard = p127,
		allBolts = list,
		mainPointsRef = pointsRef,
		startPoint = p123,
		endPoint = p124,
		mainLen = magnitude,
		totalDur = v453,
		t0 = v454,
		maxOffset = v430 * magnitude,
		fallPow = v431,
		radius = pickDirForGrab,
		grabs = v439,
		mainLocks = v447,
		mainWeights = v448,
		branchLocks = pickIndexInBin,
		branchWeights = v433
	}

	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function()
		local v628 = time()

		_updateRuntimeSegments(v628)
		u16(v628)

		local u629: boolean = true

		if not (#v3 > 0) then
			u629 = true

			if not (#v4 > 0) then
				u629 = true

				if not (#v5 > 0) then
					u629 = true

					if not (#v6 > 0) then
						u629 = #v7 > 0
					end
				end
			end
		end

		if not u629 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end
function module.BranchMultiRejoin(p133, p134, p135, p136)
	local t17: {[any]: any} = {}

	if #p133 < 6 then
		return t17
	end

	local function sampleRangeFloat(p137, p138)
		local min = p137.Min
		local n1 = p137.Max - p137.Min
		local randomNumber = math.random()
		local n2 = min + n1 * randomNumber

		if p138 ~= nil then
			n2 = math.max(p138, n2)
		end

		return n2
	end
	local function sampleRangeInt(p139, p140)
		local min = p139.Min
		local n1 = p139.Max - p139.Min
		local randomNumber = math.random()
		local floored = math.floor(min + n1 * randomNumber + 0.5)

		if p140 ~= nil then
			floored = math.max(p140, floored)
		end

		return floored
	end

	local floored = math.floor(p135.Branch_Amount + 0.5)
	local v463 = math.max(0, floored)

	if v463 == 0 then
		return t17
	end

	local n1: number = #p133 - 3
	local n2: number = n1 - 2 + 1

	if n2 <= 0 then
		return t17
	end

	local v466 = math.min(v463, n2)

	if v466 == 0 then
		return t17
	end

	local v467 = table.create(v466)
	local t18: {[any]: any} = {}

	for i = 1, v466 do
		local n3 = math.floor((i - 1) / v466 * n2) + 2
		local n4 = math.floor(i / v466 * n2) + 2 - 1

		if n4 < n3 then
			n4 = n3
		end

		if n1 < n4 then
			n4 = n1
		end

		local n5 = n3

		for _ = 1, 6 do
			local randomNumber = math.random(n3, n4)

			if not t18[randomNumber] then
				n5 = randomNumber

				break
			end
		end

		while t18[n5] and n1 >= n5 do
			n5 += 1
		end

		if n1 < n5 then
			n5 = 2

			while t18[n5] and n1 >= n5 do
				n5 += 1
			end

			if n1 < n5 then
				break
			end

			t18[n5] = true
			v467[#v467 + 1] = n5
		end
	end

	for i = 1, #v467 do
		local v476 = v467[i]
		local branch_Span = p135.Branch_Span
		local branch_SpanMin = branch_Span.Min
		local n6 = branch_Span.Max - branch_Span.Min
		local randomNumber10 = math.random()
		local floored5 = math.floor(branch_SpanMin + n6 * randomNumber10 + 0.5)

		floored5 = math.max(2, floored5)

		local v482 = math.max(2, floored5)
		local v483 = math.min(#p133 - 1, v476 + v482)
		local v484 = math.min(v483, v476 + 2)

		if not (v484 > v483) then
			local v485 = v484 == v483 and v484

			if not v485 then
				v485 = math.random(v484, v483)
			end

			local v486 = p133[v476]
			local v487 = p133[v485]
			local v488 = safeUnit(v487 - v486)
			local v489, v490 = getPerpBasis(v488)
			local randomNumber11 = math.random()
			local randomNumber12 = math.random()
			local v493 = safeUnit(v489 * (randomNumber11 * 2 - 1) + v490 * (randomNumber12 * 2 - 1))
			local branch_LengthFactor = p135.Branch_LengthFactor
			local branch_LengthFactorMin = branch_LengthFactor.Min
			local n7 = branch_LengthFactor.Max - branch_LengthFactor.Min
			local randomNumber13 = math.random()
			local v498 = math.max(0, branch_LengthFactorMin + n7 * randomNumber13)
			local n8 = (v486 + v487) * 0.5 + v493 * ((v487 - v486).Magnitude * v498)
			local branch_Segments = p135.Branch_Segments
			local branch_SegmentsMin = branch_Segments.Min
			local n9 = branch_Segments.Max - branch_Segments.Min
			local randomNumber14 = math.random()
			local floored6 = math.floor(branch_SegmentsMin + n9 * randomNumber14 + 0.5)

			floored6 = math.max(2, floored6)

			local v505 = math.max(4, floored6)

			v488 = p135.Jaggedness * 1.25

			local floored7 = math.floor(v505 * 0.5)

			n7 = math.max(2, floored7)
			v493 = buildPoints(v486, n8, n7, v488, p135.Curvature, p135.CurveBreaks)

			local roundedUp = math.ceil(v505 * 0.5)
			local v508 = math.max(2, roundedUp)

			v486 = buildPoints(n8, v487, v508, v488, p135.Curvature, p135.CurveBreaks)
			n8 = table.create(#v493 + #v486 - 1)
			v505 = 0

			for _, v in ipairs(v493) do
				v505 += 1
				n8[v505] = v
			end

			for j = 2, #v486 do
				v505 += 1
				n8[v505] = v486[j]
			end

			v493 = module.ThicknessJitterMul(p135.Branch_ThicknessRandomness)
			v505 = p135.Thickness * p135.Branch_ThicknessFactor * v493
			v493 = module.BuildBranchWarp(n8)
			v493.startIndex = v476
			v493.endIndex = v485
			v486 = math.max(1, #p133 - 1)
			v498 = math.max(p135.SpawnDur, 0)
			v487 = v486 > 0 and v498 / v486 or 0
			v488 = (v476 - 1) * v487
			v486 = (v485 - 1) * v487

			if v486 < v488 then
				v488 = v486
			end

			v498 = math.max(0, v488)

			local v512 = math.max(0, v486 - v488)

			v488 = math.max(1, #n8 - 1)
			v486 = 0

			if v488 > 1 and v512 > 0 then
				v486 = v512 * (v488 / (v488 - 1))
			end

			local v513 = table.clone(n8)
			v512 = {
				isBranch = true,
				pointsRef = n8,
				basePoints = v513,
				segRefs = {},
				thicknessForOverlap = v505,
				branchStartMainIndex = v476,
				branchEndMainIndex = v485,
				branchWarp = v493
			}
			t17[#t17 + 1] = v512

			if not p134.Parent then
				continue
			end

			n8 = p133[v476]
			v488 = p133[v485]
			v513 = safeUnit(v488 - n8)

			local v514, v515 = module.GetPerpBasisTransport(v513, v493.prevRight)

			v493.prevRight = v514
			module.ApplyBranchWarpWithBasis(v512.basePoints, v493, n8, v488, v514, v515)
			module.ApplyBranchWarpWithBasis(v512.pointsRef, v493, n8, v488, v514, v515)
			v512.basePoints[1] = n8
			v512.basePoints[#v512.basePoints] = v488
			v512.pointsRef[1] = n8
			v512.pointsRef[#v512.pointsRef] = v488
			v508 = table.clone(p135)
			v508.SpawnDur = v486
			v512.segRefs = p136(v512.pointsRef, p134, v508, v505, v498)

			for j = 1, #v512.segRefs do
				module.UpdateSegmentFromPoints(v512.segRefs[j], v512.pointsRef, v512.thicknessForOverlap)
			end
		end
	end

	return t17
end

u16 = function(p141)
	for i = #v7, 1, -1 do
		local v519 = v7[i]
		local guard = v519.guard

		if guard and not guard.Parent then
			local v521 = v7
			local n1: number = #v521

			v521[i] = v521[n1]
			v521[n1] = nil
		else
			local allBolts = v519.allBolts

			if allBolts and #allBolts ~= 0 then
				local v524 = allBolts[1]

				if not v524 then
					local v525 = v7
					local n2: number = #v525

					v525[i] = v525[n2]
					v525[n2] = nil
				else
					local n3 = p141 - v519.t0
					local v528 = math.max(v519.totalDur, 0)

					if n3 >= v528 then
						local v529 = v7
						local n4: number = #v529

						v529[i] = v529[n4]
						v529[n4] = nil
					else
						local v531 = math.max(v528, 0.001)

						v531 = 1 - math.clamp(n3 / v531, 0, 1)

						local n5 = v519.maxOffset * (1 - v531 * v531)
						local grabs = v519.grabs
						local mainLocks = v519.mainLocks
						local mainWeights = v519.mainWeights
						local basePoints = v524.basePoints
						local pointsRef = v524.pointsRef
						local n6: number = #basePoints

						if n6 >= 2 then
							pointsRef[1] = basePoints[1]
							pointsRef[n6] = basePoints[n6]

							for j = 2, n6 - 1 do
								local v540 = mainLocks[j] or 0

								if v540 <= 0 then
									pointsRef[j] = basePoints[j]
								else
									local v541 = mainWeights[j]
									local vectorValue = Vector3.new(0, 0, 0)

									if v541 then
										for k = 1, #grabs do
											local v544 = v541[k] or 0

											if v544 > 0 then
												local v545 = grabs[k]

												vectorValue += v545.dir * (n5 * v545.strength) * v544
											end
										end
									end

									v541 = n5 * v540

									if v541 < vectorValue.Magnitude and vectorValue.Magnitude > 0.000001 then
										vectorValue = vectorValue.Unit * v541
									end

									pointsRef[j] = basePoints[j] + vectorValue
								end
							end

							pointsRef[1] = basePoints[1]
							pointsRef[n6] = basePoints[n6]

							for j = 1, #v524.segRefs do
								module.UpdateSegmentFromPoints(v524.segRefs[j], pointsRef, v524.thicknessForOverlap)
							end
						end

						local v547 = v524.pointsRef
						local mainLen = v519.mainLen
						local branchLocks = v519.branchLocks
						local branchWeights = v519.branchWeights

						for j = 2, #allBolts do
							local v552 = allBolts[j]

							if v552.isBranch and v552.branchStartMainIndex and v552.branchEndMainIndex and v552.branchWarp then
								local branchStartMainIndex = v552.branchStartMainIndex
								local branchEndMainIndex = v552.branchEndMainIndex
								local branchWarp = v552.branchWarp
								local v556 = v547[branchStartMainIndex]
								local v557 = v547[branchEndMainIndex]

								if not v556 or not v557 then
									continue
								end

								local v558 = safeUnit(v557 - v556)
								local v559, v560 = module.GetPerpBasisTransport(v558, branchWarp.prevRight)

								branchWarp.prevRight = v559
								module.ApplyBranchWarpWithBasis(v552.basePoints, branchWarp, v556, v557, v559, v560)
								module.ApplyBranchWarpWithBasis(v552.pointsRef, branchWarp, v556, v557, v559, v560)

								local v561 = v552.basePoints
								local v562 = v552.pointsRef
								local n7: number = #v561

								if n7 < 2 then
									continue
								end

								v561[1] = v556
								v561[n7] = v557
								v562[1] = v556
								v562[n7] = v557

								local magnitude = (v557 - v556).Magnitude
								local v565 = math.max(mainLen, 0.000001)
								local v566 = math.clamp(magnitude / v565, 0.15, 0.6)
								local n8 = n5 * v566 * 0.8
								local v568 = branchLocks[j]

								v566 = branchWeights[j]

								if not v568 or not v566 then
									local v569, v570 = _buildSwayWeights(n7, grabs, v519.radius, v519.fallPow)
									local v571 = v569
									local v572 = v570

									branchLocks[j] = v571
									branchWeights[j] = v572
									v568 = v571
									v566 = v572
								end

								for k = 2, n7 - 1 do
									local v574 = v568[k] or 0

									if v574 <= 0 then
										v562[k] = v561[k]
									else
										local v575 = v566[k]
										local vectorValue = Vector3.new(0, 0, 0)

										if v575 then
											for l = 1, #grabs do
												local v578 = v575[l] or 0

												if v578 > 0 then
													local v579 = grabs[l]

													vectorValue += v579.dir * (n8 * v579.strength) * v578
												end
											end
										end

										v575 = math.min(n8 * v574, magnitude * 0.35)

										if v575 < vectorValue.Magnitude and vectorValue.Magnitude > 0.000001 then
											vectorValue = vectorValue.Unit * v575
										end

										v562[k] = v561[k] + vectorValue
									end
								end

								v561[1] = v556
								v561[n7] = v557
								v562[1] = v556
								v562[n7] = v557

								for k = 1, #v552.segRefs do
									module.UpdateSegmentFromPoints(v552.segRefs[k], v562, v552.thicknessForOverlap)
								end
							end
						end
					end
				end
			else
				local v581 = v7
				local n9: number = #v581

				v581[i] = v581[n9]
				v581[n9] = nil
			end
		end
	end
end

return module
