-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local mathPow = math.pow
local mathSin = math.sin
local mathCos = math.cos
local mathSqrt = math.sqrt
local mathAbs = math.abs
local mathAsin = math.asin

local function calculatePAS(p117, p118, p119, p120)
	local n1 = p117 or p120 * 0.3
	local v16 = p118 or 0
	local v17 = mathAbs(p119)

	if v16 < v17 then
		return n1, p119, n1 / 4
	end

	local v18 = mathAsin(p119 / v16)

	return n1, v16, n1 / 6.283185307179586 * v18
end
local function inElastic(p121, p122, p123, p124, p125, p126)
	if p121 == 0 then
		return p122
	end

	local n1 = p121 / p124

	if n1 == 1 then
		return p122 + p123
	end

	local n2 = p126 or p124 * 0.3
	local v27 = p125 or 0
	local v28 = mathAbs(p123)
	local n3
	local v30
	local n4

	if v27 < v28 then
		n3 = n2
		v30 = p123
		n4 = n2 / 4
	else
		n3 = n2
		v30 = v27

		local v32 = mathAsin(p123 / v27)

		n4 = n2 / 6.283185307179586 * v32
	end

	local n5 = n1 - 1

	v27 = mathPow(2, 10 * n5)

	local v34 = mathSin((n5 * p124 - n4) * 6.283185307179586 / n3)

	return -(v30 * v27 * v34) + p122
end
local function outElastic(p127, p128, p129, p130, p131, p132)
	if p127 == 0 then
		return p128
	end

	local n1 = p127 / p130

	if n1 == 1 then
		return p128 + p129
	end

	local n2 = p132 or p130 * 0.3
	local v43 = p131 or 0
	local v44 = mathAbs(p129)
	local n3
	local v46
	local n4

	if v43 < v44 then
		n3 = n2
		v46 = p129
		n4 = n2 / 4
	else
		n3 = n2
		v46 = v43

		local v48 = mathAsin(p129 / v43)

		n4 = n2 / 6.283185307179586 * v48
	end

	v43 = mathPow(2, -10 * n1)

	local v49 = mathSin((n1 * p130 - n4) * 6.283185307179586 / n3)

	return v46 * v43 * v49 + p129 + p128
end
local function outBounce(p165, p166, p167, p168)
	local n1 = p165 / p168

	if n1 < 0.36363636363636365 then
		return p167 * (7.5625 * n1 * n1) + p166
	end

	if n1 < 0.7272727272727273 then
		local n2 = n1 - 0.5454545454545454

		return p167 * (7.5625 * n2 * n2 + 0.75) + p166
	end

	if n1 < 0.9090909090909091 then
		local n3 = n1 - 0.8181818181818182

		return p167 * (7.5625 * n3 * n3 + 0.9375) + p166
	end

	local n4 = n1 - 0.9545454545454546

	return p167 * (7.5625 * n4 * n4 + 0.984375) + p166
end

return {
	point = function(p181, p182, p183)
		return (p182 - p181) * p183 + p181
	end,
	ease = {
		["in"] = {
			linear = function(p1, p2, p3, p4)
				return p3 * p1 / p4 + p2
			end,
			quad = function(p5, p6, p7, p8)
				local v69 = mathPow(p5 / p8, 2)

				return p7 * v69 + p6
			end,
			cubic = function(p21, p22, p23, p24)
				local v74 = mathPow(p21 / p24, 3)

				return p23 * v74 + p22
			end,
			quart = function(p37, p38, p39, p40)
				local v79 = mathPow(p37 / p40, 4)

				return p39 * v79 + p38
			end,
			quint = function(p53, p54, p55, p56)
				local v84 = mathPow(p53 / p56, 5)

				return p55 * v84 + p54
			end,
			sine = function(p69, p70, p71, p72)
				local v89 = mathCos(p69 / p72 * 1.5707963267948966)

				return -p71 * v89 + p71 + p70
			end,
			expo = function(p85, p86, p87, p88)
				if p85 == 0 then
					return p86
				end

				local v94 = mathPow(2, 10 * (p85 / p88 - 1))

				return p87 * v94 + p86 - p87 * 0.001
			end,
			circ = function(p101, p102, p103, p104)
				local v99 = mathPow(p101 / p104, 2)
				local v100 = mathSqrt(1 - v99)

				return -p103 * (v100 - 1) + p102
			end,
			elastic = inElastic,
			back = function(p145, p146, p147, p148, p149)
				local v106 = p149 or 1.70158
				local n1 = p145 / p148

				return p147 * n1 * n1 * ((v106 + 1) * n1 - v106) + p146
			end,
			bounce = function(p169, p170, p171, p172)
				local v112 = outBounce(p172 - p169, 0, p171, p172)

				return p171 - v112 + p170
			end
		},
		out = {
			quad = function(p9, p10, p11, p12)
				local n1 = p9 / p12

				return -p11 * n1 * (n1 - 2) + p10
			end,
			cubic = function(p25, p26, p27, p28)
				local v122 = mathPow(p25 / p28 - 1, 3)

				return p27 * (v122 + 1) + p26
			end,
			quart = function(p41, p42, p43, p44)
				local v127 = mathPow(p41 / p44 - 1, 4)

				return -p43 * (v127 - 1) + p42
			end,
			quint = function(p57, p58, p59, p60)
				local v132 = mathPow(p57 / p60 - 1, 5)

				return p59 * (v132 + 1) + p58
			end,
			sine = function(p73, p74, p75, p76)
				local v137 = mathSin(p73 / p76 * 1.5707963267948966)

				return p75 * v137 + p74
			end,
			expo = function(p89, p90, p91, p92)
				if p89 == p92 then
					return p90 + p91
				end

				local v142 = mathPow(2, -10 * p89 / p92)

				return p91 * 1.001 * (-v142 + 1) + p90
			end,
			circ = function(p105, p106, p107, p108)
				local v147 = mathPow(p105 / p108 - 1, 2)
				local v148 = mathSqrt(1 - v147)

				return p107 * v148 + p106
			end,
			elastic = outElastic,
			back = function(p150, p151, p152, p153, p154)
				local v154 = p154 or 1.70158
				local n1 = p150 / p153 - 1

				return p152 * (n1 * n1 * ((v154 + 1) * n1 + v154) + 1) + p151
			end,
			bounce = outBounce
		},
		inout = {
			quad = function(p13, p14, p15, p16)
				local n1 = p13 / p16 * 2

				if n1 < 1 then
					local v161 = mathPow(n1, 2)

					return p15 / 2 * v161 + p14
				end

				return -p15 / 2 * ((n1 - 1) * (n1 - 3) - 1) + p14
			end,
			cubic = function(p29, p30, p31, p32)
				local n1 = p29 / p32 * 2

				if n1 < 1 then
					return p31 / 2 * n1 * n1 * n1 + p30
				end

				local n2 = n1 - 2

				return p31 / 2 * (n2 * n2 * n2 + 2) + p30
			end,
			quart = function(p45, p46, p47, p48)
				local n1 = p45 / p48 * 2

				if n1 < 1 then
					local v173 = mathPow(n1, 4)

					return p47 / 2 * v173 + p46
				end

				local v174 = mathPow(n1 - 2, 4)

				return -p47 / 2 * (v174 - 2) + p46
			end,
			quint = function(p61, p62, p63, p64)
				local n1 = p61 / p64 * 2

				if n1 < 1 then
					local v180 = mathPow(n1, 5)

					return p63 / 2 * v180 + p62
				end

				local v181 = mathPow(n1 - 2, 5)

				return p63 / 2 * (v181 + 2) + p62
			end,
			sine = function(p77, p78, p79, p80)
				local v186 = mathCos(3.141592653589793 * p77 / p80)

				return -p79 / 2 * (v186 - 1) + p78
			end,
			expo = function(p93, p94, p95, p96)
				if p93 == 0 then
					return p94
				end

				if p93 == p96 then
					return p94 + p95
				end

				local n1 = p93 / p96 * 2

				if n1 < 1 then
					local v192 = mathPow(2, 10 * (n1 - 1))

					return p95 / 2 * v192 + p94 - p95 * 0.0005
				end

				local v193 = mathPow(2, -10 * (n1 - 1))

				return p95 / 2 * 1.0005 * (-v193 + 2) + p94
			end,
			circ = function(p109, p110, p111, p112)
				local n1 = p109 / p112 * 2

				if n1 < 1 then
					local v199 = mathSqrt(1 - n1 * n1)

					return -p111 / 2 * (v199 - 1) + p110
				end

				local n2 = n1 - 2
				local v201 = mathSqrt(1 - n2 * n2)

				return p111 / 2 * (v201 + 1) + p110
			end,
			elastic = function(p133, p134, p135, p136, p137, p138)
				if p133 == 0 then
					return p134
				end

				local n1 = p133 / p136 * 2

				if n1 == 2 then
					return p134 + p135
				end

				local n2 = p138 or p136 * 0.3
				local v210 = p137 or 0
				local v211 = mathAbs(p135)
				local n3
				local v213
				local n4

				if v210 < v211 then
					n3 = n2
					v213 = p135
					n4 = n2 / 4
				else
					n3 = n2
					v213 = v210

					local v215 = mathAsin(p135 / v210)

					n4 = n2 / 6.283185307179586 * v215
				end

				local n5 = n3
				local v217 = v213
				local n6 = n4
				local n7 = n1 - 1

				if n7 < 0 then
					local v220 = mathPow(2, 10 * n7)
					local v221 = mathSin((n7 * p136 - n6) * 6.283185307179586 / n5)

					return -0.5 * (v217 * v220 * v221) + p134
				end

				v211 = mathPow(2, -10 * n7)

				local v222 = mathSin((n7 * p136 - n6) * 6.283185307179586 / n5)

				return v217 * v211 * v222 * 0.5 + p135 + p134
			end,
			back = function(p155, p156, p157, p158, p159)
				local n1 = (p159 or 1.70158) * 1.525
				local n2 = p155 / p158 * 2

				if n2 < 1 then
					return p157 / 2 * (n2 * n2 * ((n1 + 1) * n2 - n1)) + p156
				end

				local n3 = n2 - 2

				return p157 / 2 * (n3 * n3 * ((n1 + 1) * n3 + n1) + 2) + p156
			end,
			bounce = function(p173, p174, p175, p176)
				if p173 < p176 / 2 then
					local v235 = outBounce(p176 - p173 * 2, 0, p175, p176)

					return (p175 - v235 + 0) * 0.5 + p174
				end

				return outBounce(p173 * 2 - p176, 0, p175, p176) * 0.5 + p175 * 0.5 + p174
			end
		},
		outin = {
			quad = function(p17, p18, p19, p20)
				if p17 < p20 / 2 then
					local n1 = p17 * 2 / p20

					return -(p19 / 2) * n1 * (n1 - 2) + p18
				end

				local v241 = mathPow((p17 * 2 - p20) / p20, 2)

				return p19 / 2 * v241 + (p18 + p19 / 2)
			end,
			cubic = function(p33, p34, p35, p36)
				if p33 < p36 / 2 then
					local v246 = mathPow(p33 * 2 / p36 - 1, 3)

					return p35 / 2 * (v246 + 1) + p34
				end

				local v247 = mathPow((p33 * 2 - p36) / p36, 3)

				return p35 / 2 * v247 + (p34 + p35 / 2)
			end,
			quart = function(p49, p50, p51, p52)
				if p49 < p52 / 2 then
					local v252 = mathPow(p49 * 2 / p52 - 1, 4)

					return -(p51 / 2) * (v252 - 1) + p50
				end

				local v253 = mathPow((p49 * 2 - p52) / p52, 4)

				return p51 / 2 * v253 + (p50 + p51 / 2)
			end,
			quint = function(p65, p66, p67, p68)
				if p65 < p68 / 2 then
					local v258 = mathPow(p65 * 2 / p68 - 1, 5)

					return p67 / 2 * (v258 + 1) + p66
				end

				local v259 = mathPow((p65 * 2 - p68) / p68, 5)

				return p67 / 2 * v259 + (p66 + p67 / 2)
			end,
			sine = function(p81, p82, p83, p84)
				if p81 < p84 / 2 then
					local v264 = mathSin(p81 * 2 / p84 * 1.5707963267948966)

					return p83 / 2 * v264 + p82
				end

				local n1 = p83 / 2
				local v266 = mathCos((p81 * 2 - p84) / p84 * 1.5707963267948966)

				return -n1 * v266 + n1 + (p82 + p83 / 2)
			end,
			expo = function(p97, p98, p99, p100)
				if p97 < p100 / 2 then
					local n1 = p97 * 2
					local n2 = p99 / 2

					if p100 == n1 then
						return p98 + n2
					end

					local v273 = mathPow(2, -10 * n1 / p100)

					return n2 * 1.001 * (-v273 + 1) + p98
				end

				local n3 = p97 * 2 - p100
				local n4 = p98 + p99 / 2
				local n5 = p99 / 2

				if n3 == 0 then
					return n4
				end

				local v277 = mathPow(2, 10 * (n3 / p100 - 1))

				return n5 * v277 + n4 - n5 * 0.001
			end,
			circ = function(p113, p114, p115, p116)
				if p113 < p116 / 2 then
					local v282 = mathPow(p113 * 2 / p116 - 1, 2)
					local v283 = mathSqrt(1 - v282)

					return p115 / 2 * v283 + p114
				end

				local v284 = mathPow((p113 * 2 - p116) / p116, 2)
				local v285 = mathSqrt(1 - v284)

				return -(p115 / 2) * (v285 - 1) + (p114 + p115 / 2)
			end,
			elastic = function(p139, p140, p141, p142, p143, p144)
				if p139 < p142 / 2 then
					return (outElastic(p139 * 2, p140, p141 / 2, p142, p143, p144))
				end

				return (inElastic(p139 * 2 - p142, p140 + p141 / 2, p141 / 2, p142, p143, p144))
			end,
			back = function(p160, p161, p162, p163, p164)
				if p160 < p163 / 2 then
					local v297 = p164 or 1.70158
					local n1 = p160 * 2 / p163 - 1

					return p162 / 2 * (n1 * n1 * ((v297 + 1) * n1 + v297) + 1) + p161
				end

				local v299 = p164 or 1.70158
				local n2 = (p160 * 2 - p163) / p163

				return p162 / 2 * n2 * n2 * ((v299 + 1) * n2 - v299) + (p161 + p162 / 2)
			end,
			bounce = function(p177, p178, p179, p180)
				if p177 < p180 / 2 then
					return (outBounce(p177 * 2, p178, p179 / 2, p180))
				end

				local n1 = p179 / 2
				local v306 = outBounce(p180 - (p177 * 2 - p180), 0, n1, p180)

				return n1 - v306 + (p178 + p179 / 2)
			end
		}
	}
}
