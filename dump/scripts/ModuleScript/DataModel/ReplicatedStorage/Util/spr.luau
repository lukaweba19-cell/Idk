-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local runService: RunService = game:GetService("RunService")
local mathExp = math.exp
local mathSin = math.sin
local mathCos = math.cos
local mathMin = math.min
local mathSqrt = math.sqrt
local mathRound = math.round

local function magnitudeSq(p1)
	local n1 = 0

	for iterFirst, iterSecond in p1 do
		n1 += iterSecond ^ 2
	end

	return n1
end
local function distanceSq(p2, p3)
	local n1 = 0

	for iterFirst, iterSecond in p2 do
		n1 += (p3[iterFirst] - iterSecond) ^ 2
	end

	return n1
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p4, p5, p6, p7, p8)
	local v53 = p8.toIntermediate(p6)
	local v54 = table.create(#v53, 0)

	return (setmetatable({
		d = p4,
		f = p5,
		g = v53,
		p = v53,
		v = v54,
		typedat = p8,
		rawGoal = p7
	}, t1))
end
function t1.setGoal(p9, p10)
	p9.rawGoal = p10
	p9.g = p9.typedat.toIntermediate(p10)
end
function t1.setDampingRatio(p11, p12)
	p11.d = p12
end
function t1.setFrequency(p13, p14)
	p13.f = p14
end
function t1.canSleep(p15)
	local n1 = 0

	for iterFirst, iterSecond in p15.v, nil, nil do
		n1 += iterSecond ^ 2
	end

	if n1 > 0.0001 then
		return false
	end

	local g = p15.g

	n1 = 0

	for iterFirst2, iterSecond2 in p15.p, nil, nil do
		n1 += (g[iterFirst2] - iterSecond2) ^ 2
	end

	if n1 > 6.781684027777778E-8 then
		return false
	end

	return true
end
function t1.step(p16, p17)
	local d = p16.d
	local n1 = p16.f * 2 * 3.141592653589793
	local g = p16.g
	local p = p16.p
	local v = p16.v

	if d == 1 then
		local v75 = mathExp(-n1 * p17)
		local n2 = p17 * v75

		for i = 1, #p do
			local n3 = p[i] - g[i]

			p[i] = n3 * (v75 + n2 * n1) + v[i] * n2 + g[i]
			v[i] = v[i] * (v75 - n2 * n1) - n3 * (n2 * n1 * n1)
		end
	elseif d < 1 then
		local v79 = mathExp(-d * n1 * p17)
		local v80 = mathSqrt(1 - d * d)
		local v81 = mathCos(p17 * n1 * v80)
		local v82 = mathSin(p17 * n1 * v80)
		local n4 = p17 * n1
		local n5 = if v80 > 0.00001 then v82 / v80 else n4 + (n4 * n4 * (v80 * v80) * (v80 * v80) / 20 - v80 * v80) * (n4 * n4 * n4) / 6
		local n6

		if n1 * v80 > 0.00001 then
			n6 = v82 / (n1 * v80)
		else
			local n7 = n1 * v80

			n6 = p17 + (p17 * p17 * (n7 * n7) * (n7 * n7) / 20 - n7 * n7) * (p17 * p17 * p17) / 6
		end

		for i = 1, #p do
			local n8 = p[i] - g[i]

			p[i] = (n8 * (v81 + n5 * d) + v[i] * n6) * v79 + g[i]
			v[i] = (v[i] * (v81 - n5 * d) - n8 * (n5 * n1)) * v79
		end
	else
		local v89 = mathSqrt(d * d - 1)
		local n9 = -n1 * (d - v89)
		local n10 = -n1 * (d + v89)
		local v92 = mathExp(n9 * p17)
		local v93 = mathExp(n10 * p17)

		for i = 1, #p do
			local n11 = p[i] - g[i]
			local n12 = (v[i] - n11 * n9) / (2 * n1 * v89)
			local n13 = v92 * (n11 - n12)

			p[i] = n13 + n12 * v93 + g[i]
			v[i] = n13 * n9 + n12 * v93 * n10
		end
	end

	return p16.typedat.fromIntermediate(p16.p)
end

local t2: {[any]: any} = {}

t2.__index = t2

local function angleBetween(p18, p19)
	local v100, v101 = p19:ToObjectSpace(p18):ToAxisAngle()

	return (math.abs(v101))
end
local function matrixToAxis(p20)
	local v103, v104 = p20:ToAxisAngle()

	return v103 * v104
end
local function axisToMatrix(p21)
	local magnitude = p21.Magnitude

	if magnitude > 0.000001 then
		return CFrame.fromAxisAngle(p21.Unit, magnitude)
	end

	return CFrame.identity
end
function t2.new(p22, p23, p24, p25)
	return (setmetatable({ v = Vector3.new(0, 0, 0), d = p22, f = p23, g = p25, p = p24 }, t2))
end
function t2.setGoal(p26, p27)
	p26.g = p27
end
function t2.setDampingRatio(p28, p29)
	p28.d = p29
end
function t2.setFrequency(p30, p31)
	p30.f = p31
end
function t2.canSleep(p32)
	local v118, v119 = p32.g:ToObjectSpace(p32.p):ToAxisAngle()

	return math.abs(v119) < 0.00017453292519943296 and p32.v.Magnitude < 0.0017453292519943296
end
function t2.step(p33, p34)
	local d = p33.d
	local n1 = p33.f * 2 * 3.141592653589793
	local g = p33.g
	local p = p33.p
	local v = p33.v
	local v127 = g:Inverse()
	local v128, v129 = (p * v127):ToAxisAngle()
	local n2 = v128 * v129
	local v131 = mathExp(-d * n1 * p34)
	local n3
	local n4

	if d == 1 then
		local n5 = (n2 * (1 + n1 * p34) + v * p34) * v131
		local magnitude = n5.Magnitude
		local v137

		if magnitude > 0.000001 then
			v137 = CFrame.fromAxisAngle(n5.Unit, magnitude)
		else
			v137 = CFrame.identity
		end

		n3 = v137 * g
		n4 = (v * (1 - p34 * n1) - n2 * (p34 * n1 * n1)) * v131
	elseif d < 1 then
		local v138 = mathSqrt(1 - d * d)
		local v139 = mathCos(p34 * n1 * v138)
		local v140 = mathSin(p34 * n1 * v138)
		local n6 = v140 / v138
		local n7 = (n2 * (v139 + n6 * d) + v * (v140 / (n1 * v138))) * v131
		local v142 = n7.Magnitude
		local v143

		if v142 > 0.000001 then
			v143 = CFrame.fromAxisAngle(n7.Unit, v142)
		else
			v143 = CFrame.identity
		end

		n3 = v143 * g
		n4 = (v * (v139 - n6 * d) - n2 * (n6 * n1)) * v131
	else
		local v144 = mathSqrt(d * d - 1)
		local n8 = -n1 * (d - v144)
		local n9 = -n1 * (d + v144)
		local n10 = (v - n2 * n8) / (2 * n1 * v144)
		local v147 = mathExp(n8 * p34)
		local n11 = (n2 - n10) * v147

		v147 = mathExp(n9 * p34)
		v144 = n10 * v147

		local n12 = n11 + v144
		local v150 = n12.Magnitude
		local v151

		if v150 > 0.000001 then
			v151 = CFrame.fromAxisAngle(n12.Unit, v150)
		else
			v151 = CFrame.identity
		end

		n3 = v151 * g
		n4 = n11 * n8 + v144 * n9
	end

	p33.p = n3
	p33.v = n4

	return n3
end

local new = t1.new
local t3: {[any]: any} = {}

t3.__index = t3

local t4: {[any]: any} = {
	springType = new,
	toIntermediate = function(p35)
		return { p35.X, p35.Y, p35.Z }
	end,
	fromIntermediate = function(list)
		local vector3 = Vector3.new(list[1], list[2], list[3])

		return vector3
	end
}

function t3.new(p37, p38, p39, p40, _)
	local v160 = t1.new(p37, p38, p39.Position, p40.Position, t4)
	local v161 = t2.new(p37, p38, p39.Rotation, p40.Rotation)

	return (setmetatable({ rawGoal = p40, _position = v160, _rotation = v161 }, t3))
end
function t3.setGoal(p42, p43)
	p42.rawGoal = p43
	p42._position:setGoal(p43.Position)
	p42._rotation:setGoal(p43.Rotation)
end
function t3.setDampingRatio(p44, p45)
	p44._position:setDampingRatio(p45)
	p44._rotation:setDampingRatio(p45)
end
function t3.setFrequency(p46, p47)
	p46._position:setFrequency(p47)
	p46._rotation:setFrequency(p47)
end
function t3.canSleep(p48)
	return p48._position:canSleep() and p48._rotation:canSleep()
end
function t3.step(p49, p50)
	local v171 = p49._position:step(p50)

	return p49._rotation:step(p50) + v171
end
local function inverseGammaCorrectD65(p51)
	return p51 < 0.0404482362771076 and p51 / 12.92 or 0.87941546140213 * (p51 + 0.055) ^ 2.4
end
local function gammaCorrectD65(p52)
	return p52 < 0.0031306684425 and 12.92 * p52 or 1.055 * p52 ^ 0.4166666666666667 - 0.055
end
local function rgbToLuv(p53)
	local r = p53.R
	local n1 = r < 0.0404482362771076 and r / 12.92 or 0.87941546140213 * (r + 0.055) ^ 2.4
	local g = p53.G
	local n2 = g < 0.0404482362771076 and g / 12.92 or 0.87941546140213 * (g + 0.055) ^ 2.4
	local b = p53.B
	local n3 = b < 0.0404482362771076 and b / 12.92 or 0.87941546140213 * (b + 0.055) ^ 2.4
	local n4 = 0.2125862307855956 * n1 + 0.7151703037034108 * n2 + 0.0722004986433362 * n3
	local n5 = 3.6590806972265884 * n1 + 11.442689580057424 * n2 + 4.114991502426484 * n3
	local n6 = n4 > 0.008856451679035631 and 116 * n4 ^ 0.3333333333333333 - 16 or 903.296296296296 * n4
	local n7
	local n8

	if n5 > 1E-14 then
		n7 = n6 * (0.9257063972951867 * n1 - 0.8333736323779866 * n2 - 0.09209820666085898 * n3) / n5
		n8 = n6 * (9 * n4 / n5 - 0.46832)
	else
		n7 = -0.19783 * n6
		n8 = -0.46832 * n6
	end

	return { n6, n7, n8 }
end
local function luvToRgb(list)
	local v187 = list[1]

	if v187 < 0.0197955 then
		return Color3.new(0, 0, 0)
	end

	local n1 = list[2] / v187 + 0.19783
	local n2 = list[3] / v187 + 0.46832
	local n3 = (v187 + 16) / 116

	n3 = n3 > 0.20689655172413793 and n3 * n3 * n3 or n3 * 0.12841854934601665 - 0.01771290335807126
	v187 = n3 * n1 / n2

	local n4 = n3 * ((3 - n1 * 0.75) / n2 - 5)

	n2 = v187 * 7.2914074 - n3 * 1.537208 - n4 * 0.4986286
	n1 = v187 * -2.180094 + n3 * 1.8757561 + n4 * 0.0415175

	local n5 = v187 * 0.1253477 - n3 * 0.2040211 + n4 * 1.0569959

	if n2 < 0 and n1 > n2 and n2 < n5 then
		n1 -= n2
		n5 -= n2
		n2 = 0
	elseif n1 < 0 and n1 < n5 then
		n2 -= n1
		n5 -= n1
		n1 = 0
	elseif n5 < 0 then
		n2 -= n5
		n1 -= n5
		n5 = 0
	end

	local color3New = Color3.new
	local v194 = mathMin(n2 < 0.0031306684425 and 12.92 * n2 or 1.055 * n2 ^ 0.4166666666666667 - 0.055, 1)
	local v195 = mathMin(n1 < 0.0031306684425 and 12.92 * n1 or 1.055 * n1 ^ 0.4166666666666667 - 0.055, 1)
	local v196 = mathMin(n5 < 0.0031306684425 and 12.92 * n5 or 1.055 * n5 ^ 0.4166666666666667 - 0.055, 1)

	return color3New(v194, v195, v196)
end

gammaCorrectD65 = {
	springType = t1.new,
	toIntermediate = function(p55)
		return { if p55 then 1 else 0 }
	end,
	fromIntermediate = function(p56)
		return p56[1] >= 0.5
	end
}

local t5: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p57)
		return { p57 }
	end,
	fromIntermediate = function(p58)
		return p58[1]
	end
}

local t6: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p59)
		return { p59.Min, p59.Max }
	end,
	fromIntermediate = function(list)
		return NumberRange.new(list[1], list[2])
	end
}

local t7: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p61)
		return { p61.Scale, p61.Offset }
	end,
	fromIntermediate = function(list)
		local uDimNew = UDim.new
		local v206 = list[1]
		local v207 = mathRound(list[2])

		return uDimNew(v206, v207)
	end
}

local t8: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p63)
		local x = p63.X
		local y = p63.Y

		return { x.Scale, x.Offset, y.Scale, y.Offset }
	end,
	fromIntermediate = function(list)
		local uDim2New = UDim2.new
		local v213 = list[1]
		local v214 = mathRound(list[2])
		local v215 = list[3]
		local v216 = mathRound(list[4])

		return uDim2New(v213, v214, v215, v216)
	end
}

local t9: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p65)
		return { p65.X, p65.Y }
	end,
	fromIntermediate = function(list)
		return Vector2.new(list[1], list[2])
	end
}

local t10: {[any]: any} = {
	springType = t1.new,
	toIntermediate = rgbToLuv,
	fromIntermediate = luvToRgb
}

local t11: {[any]: any} = {
	springType = t1.new,
	toIntermediate = function(p67)
		local keypoints = p67.Keypoints
		local v221 = rgbToLuv(keypoints[1].Value)
		local v222 = rgbToLuv(keypoints[#keypoints].Value)

		return { v221[1], v221[2], v221[3], v222[1], v222[2], v222[3] }
	end,
	fromIntermediate = function(list)
		local colorSequenceNew = ColorSequence.new
		local v225 = luvToRgb({ list[1], list[2], list[3] })

		return colorSequenceNew(v225, luvToRgb({ list[4], list[5], list[6] }))
	end
}

local t12: {[any]: any} = {
	springType = t3.new,
	toIntermediate = error,
	fromIntermediate = error
}

local t13: {[any]: any} = {
	Pivot = {
		class = "PVInstance",
		get = function(p69)
			return p69:GetPivot()
		end,
		set = function(p70, p71)
			p70:PivotTo(p71)
		end
	},
	Scale = {
		class = "Model",
		get = function(p72)
			return p72:GetScale()
		end,
		set = function(p73, p74)
			p73:ScaleTo(p74)
		end
	}
}

local function getProperty(p75, p76)
	local v234 = t13[p76]

	if v234 and p75:IsA(v234.class) then
		return v234.get(p75)
	end

	return p75[p76]
end
local function setProperty(p77, p78, p79)
	local v238 = t13[p78]

	if v238 and p77:IsA(v238.class) then
		v238.set(p77, p79)

		return
	end

	p77[p78] = p79
end

local t14: {[any]: any} = {}
local t15: {[any]: any} = {}
local t16: {[any]: any} = {}

local function processSprings(p80, p81)
	for iterFirst, iterSecond in p80 do
		for iterFirst2, iterSecond2 in iterSecond do
			if iterSecond2:canSleep() then
				iterSecond[iterFirst2] = nil

				local rawGoal = iterSecond2.rawGoal
				local v246 = t13[iterFirst2]

				if v246 and iterFirst:IsA(v246.class) then
					v246.set(iterFirst, rawGoal)
				else
					iterFirst[iterFirst2] = rawGoal
				end
			else
				local v247 = iterSecond2:step(p81)
				local v248 = t13[iterFirst2]

				if v248 and iterFirst:IsA(v248.class) then
					v248.set(iterFirst, v247)
				else
					iterFirst[iterFirst2] = v247
				end
			end
		end

		if not next(iterSecond) then
			p80[iterFirst] = nil

			local v249 = t16[iterFirst]

			if v249 then
				t16[iterFirst] = nil

				for iterFirst3, iterSecond3 in v249 do
					task.spawn(iterSecond3)
				end
			end
		end
	end
end

runService.PreSimulation:Connect(function(deltaTimeSim: number)
	processSprings(t14, deltaTimeSim)
end)
runService.PostSimulation:Connect(function(deltaTimeSim: number)
	processSprings(t15, deltaTimeSim)
end)

local function assertType(p84, p85, p86, p87)
	local typeName: string = typeof(p87)

	if not p86:find(typeName) then
		local typeName2: string = typeof(p87)
		local v260 = ("bad argument #%* to %* (%* expected, got %*)"):format(p84, p85, p86, typeName2)

		error(v260, 3)
	end
end

local t17: {[any]: any} = {
	boolean = gammaCorrectD65,
	number = t5,
	NumberRange = t6,
	UDim = t7,
	UDim2 = t8,
	Vector2 = t9,
	Vector3 = t4,
	Color3 = t10,
	ColorSequence = t11,
	CFrame = t12
}

return table.freeze({
	getState = function(p88, p89)
		local v263: {[any]: any} = if p88:IsA("Camera") then t15 else t14
		local v264 = v263 and v263[p88]

		if v264 and p89 then
			return v264[p89]
		end

		return v264
	end,
	target = function(p90, p91, p92, p93)
		if not ("Instance"):find((typeof(p90))) then
			local v269 = ("bad argument #%* to spr.target (Instance expected, got %*)"):format(1, (typeof(p90)))

			error(v269, 3)
		end

		if not ("number"):find((typeof(p91))) then
			local v270 = ("bad argument #%* to spr.target (number expected, got %*)"):format(2, (typeof(p91)))

			error(v270, 3)
		end

		if not ("number"):find((typeof(p92))) then
			local v271 = ("bad argument #%* to spr.target (number expected, got %*)"):format(3, (typeof(p92)))

			error(v271, 3)
		end

		if not ("table"):find((typeof(p93))) then
			local v272 = ("bad argument #%* to spr.target (table expected, got %*)"):format(4, (typeof(p93)))

			error(v272, 3)
		end

		if p91 ~= p91 or p91 < 0 then
			local v273 = ("expected damping ratio >= 0; got %.2f"):format(p91)

			error(v273, 2)
		end

		if p92 ~= p92 or p92 < 0 then
			local v274 = ("expected undamped frequency >= 0; got %.2f"):format(p92)

			error(v274, 2)
		end

		local v275: {[any]: any} = if p90:IsA("Camera") then t15 else t14
		local t18 = v275[p90]

		if not t18 then
			t18 = {}
			v275[p90] = t18
		end

		for iterFirst, iterSecond in p93 do
			local v279 = t13[iterFirst]
			local v280 = if v279 and p90:IsA(v279.class) then v279.get(p90) else p90[iterFirst]
			local typeName: string = typeof(iterSecond)
			local typeName3: string = typeof(v280)

			if typeName ~= typeName3 then
				local typeName4: string = typeof(v280)
				local typeName5: string = typeof(iterSecond)
				local v285 = ("bad property %* to spr.target (%* expected, got %*)"):format(iterFirst, typeName4, typeName5)

				error(v285, 2)
			end

			if p92 == math.huge then
				local v286 = t13[iterFirst]

				if v286 and p90:IsA(v286.class) then
					v286.set(p90, iterSecond)
				else
					p90[iterFirst] = iterSecond
				end

				t18[iterFirst] = nil
			else
				local v287 = t18[iterFirst]

				if not v287 then
					local typeName6: string = typeof(iterSecond)
					local v289 = t17[typeName6]

					if not v289 then
						local typeName7: string = typeof(iterSecond)

						error("unsupported type: " .. typeName7, 2)
					end

					v287 = v289.springType(p91, p92, v280, iterSecond, v289)
					t18[iterFirst] = v287
				end

				v287:setGoal(iterSecond)
				v287:setDampingRatio(p91)
				v287:setFrequency(p92)
			end
		end

		if not next(t18) then
			v275[p90] = nil
		end
	end,
	stop = function(p94, p95)
		if not ("Instance"):find((typeof(p94))) then
			local v293 = ("bad argument #%* to spr.stop (Instance expected, got %*)"):format(1, (typeof(p94)))

			error(v293, 3)
		end

		if not ("string|nil"):find((typeof(p95))) then
			local v294 = ("bad argument #%* to spr.stop (string|nil expected, got %*)"):format(2, (typeof(p95)))

			error(v294, 3)
		end

		if p95 then
			local v295 = t14[p94] or t15[p94]

			if v295 then
				v295[p95] = nil

				return
			end
		else
			t14[p94] = nil
			t15[p94] = nil
		end
	end,
	completed = function(p96, p97)
		if not ("Instance"):find((typeof(p96))) then
			local v298 = ("bad argument #%* to spr.completed (Instance expected, got %*)"):format(1, (typeof(p96)))

			error(v298, 3)
		end

		if not ("function"):find((typeof(p97))) then
			local v299 = ("bad argument #%* to spr.completed (function expected, got %*)"):format(2, (typeof(p97)))

			error(v299, 3)
		end

		local v300 = t16[p96]

		if v300 then
			table.insert(v300, p97)

			return
		end

		t16[p96] = { p97 }
	end
})
