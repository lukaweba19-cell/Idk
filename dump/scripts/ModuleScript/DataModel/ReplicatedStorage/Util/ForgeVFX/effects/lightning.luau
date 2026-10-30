-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")

require("../types")

local v3 = require("../mod/utility")
local v4 = require("../mod/common/bezier")
local v5 = require("../obj/Bezier")
local v6 = require("../pkg/Promise")

require("../obj/ObjectCache")

local u7 = nil

local function readLightningAttributes(p2)
	local v18 = v1.get(p2, "Segments", 8)
	local v19 = math.max(v18, 2)
	local v20 = v1.getRange(p2, "Jaggedness", NumberRange.new(0.5, 1), NumberRange.new(0, math.huge))
	local v21 = v1.get(p2, "OffsetScale", 1)
	local v22 = v1.get(p2, "RefreshRate", 15)
	local v23 = v1.get(p2, "IndependentSegments", false)
	local v24 = v1.get(p2, "RefreshDuringDissipate", false)
	local v25 = v1.getEnum(p2, "NestedEffectMode", "None", { "None", "All", "Head", "Tail" })
	local v26 = v1.get(p2, "Color", ColorSequence.new(Color3.new(1, 1, 1)))
	local v27 = v1.get(p2, "Color_Curve", v3.linear_bezier)
	local v28 = v1.get(p2, "Color_Duration", 1)
	local v29 = v1.get(p2, "Transparency_Start", 0)
	local v30 = v1.get(p2, "Transparency_End", 0)
	local v31 = v1.get(p2, "Fill_Color", ColorSequence.new(Color3.new(1, 1, 1)))
	local v32 = v1.get(p2, "Fill_Color_Curve", v3.linear_bezier)
	local v33 = v1.get(p2, "Fill_Color_Duration", 1)
	local v34 = v1.get(p2, "Fill_Transparency_Start", 1)
	local v35 = v1.get(p2, "Fill_Transparency_End", 1)
	local v36 = v1.getEnum(p2, "Fill_DepthMode", "Occluded", { "AlwaysOnTop", "Occluded" })
	local v37 = v1.get(p2, "Fade_In_Start", 1)
	local v38 = v1.get(p2, "Fade_In_Duration", 0)
	local v39 = v1.get(p2, "Fade_In_Curve", v3.default_bezier)
	local v40 = v1.get(p2, "Fade_Out_End", 1)
	local v41 = v1.get(p2, "Fade_Out_Duration", 0)
	local v42 = v1.get(p2, "Fade_Out_Curve", v3.default_bezier)
	local v43 = v1.get(p2, "Length_Start", 1)
	local v44 = v1.get(p2, "Length_End", 1)
	local v45 = v1.getEnum(p2, "Dissipate_Mode", "None", { "None", "Retract", "Scale" })
	local v46 = v1.get(p2, "Dissipate_Duration", 0.5)
	local v47 = v1.get(p2, "Dissipate_Curve", v3.default_bezier)
	local v48 = v1.get(p2, "Width_Start", 2)
	local v49 = v1.get(p2, "Width_End", 0.2)

	return {
		segments = v19,
		jaggedness = v20,
		offsetScale = v21,
		refreshRate = v22,
		independentSegments = v23,
		refreshDuringDissipate = v24,
		nestedEffectMode = v25,
		colorSequence = v26,
		colorEasingData = v27,
		colorDuration = v28,
		transparencyStart = v29,
		transparencyEnd = v30,
		fillColorSequence = v31,
		fillColorEasingData = v32,
		fillColorDuration = v33,
		fillTransparencyStart = v34,
		fillTransparencyEnd = v35,
		fillDepthMode = v36,
		fadeInStart = v37,
		fadeInDuration = v38,
		fadeInCurveData = v39,
		fadeOutEnd = v40,
		fadeOutDuration = v41,
		fadeOutCurveData = v42,
		lengthStart = v43,
		lengthEnd = v44,
		dissipateMode = v45,
		dissipateDuration = v46,
		dissipateCurveData = v47,
		widthStart = v48,
		widthEnd = v49
	}
end
local function createSegmentStates(p3)
	local t1: {[any]: any} = {}

	for i = 1, p3 do
		t1[i] = {
			birthTime = nil,
			initialWidth = nil,
			initialTransparency = nil,
			wasVisible = false
		}
	end

	return t1
end
local function computeJaggedOffset(p4, p5, p6, p7, p8, p9)
	local v59 = p4:NextNumber(p5.Min, p5.Max)
	local v60 = math.min(v59 * p6 * p7, p7 * 0.8)
	local v61 = p4:NextNumber(0, 6.283185307179586)
	local cosine = math.cos(v61)
	local sine = math.sin(v61)

	return (p8 * cosine + p9 * sine) * v60
end
local function generateLightningPoints(p10, p11, p12, p13, p14)
	local v69 = table.create(p11 + 1)

	v69[1] = p12(0)

	local v70 = v69[1]

	for i = 1, p11 - 1 do
		local n1 = i * (1 / p11)
		local v73 = p12(n1)
		local v74 = math.min(n1 + 0.01, 1)

		n1 = p12(v74) - v73

		local v75, v76 = v4.getPerpendicularVectors(if n1.Magnitude > 0.001 then n1.Unit else Vector3.new(0, 1, 0))
		local magnitude = (v73 - v70).Magnitude
		local v78 = p10:NextNumber(p13.Min, p13.Max)
		local v79 = math.min(v78 * p14 * magnitude, magnitude * 0.8)
		local v80 = p10:NextNumber(0, 6.283185307179586)
		local cosine = math.cos(v80)
		local sine = math.sin(v80)
		local n2 = v73 + (v75 * cosine + v76 * sine) * v79

		v70 = n2
		v69[i + 1] = n2
	end

	v69[p11 + 1] = p12(1)

	return v69
end
local function generateProjectilePoints(p15, p16, p17, p18, p19, p20, p21)
	local v91 = table.create(p16 + 1)
	local n1 = 1 / p16
	local n2 = p18 - p17
	local magnitude = n2.Magnitude
	local v95, v96 = v4.getPerpendicularVectors(if magnitude > 0.001 then n2 / magnitude else p21)
	local n3 = magnitude * n1

	v91[1] = p17

	for i = 1, p16 - 1 do
		local v99 = p17:Lerp(p18, i * n1)
		local v100 = p15:NextNumber(p19.Min, p19.Max)
		local v101 = math.min(v100 * p20 * n3, n3 * 0.8)
		local v102 = p15:NextNumber(0, 6.283185307179586)
		local cosine = math.cos(v102)
		local sine = math.sin(v102)

		v91[i + 1] = v99 + (v95 * cosine + v96 * sine) * v101
	end

	v91[p16 + 1] = p18

	return v91
end
local function getBlendedPosition(p22, p23, p24, p25, p26)
	local v110 = math.clamp((p26.distanceTraveled - (1 - p22) * p26.boltLength) / p26.transitionBuffer, 0, 1)
	local v111 = math.min(p26.distanceTraveled / p26.boltLength, 1)

	v111 = math.min(1, p26.curvedTailT + p22 * p26.curvedLengthT + v111 * p26.curvedLengthT)

	local v112 = p23(v111)

	v111 = p24:Lerp(p25, p22)

	return v112:Lerp(v111, v110)
end
local function generateTransitionPoints(p27, p28, p29, p30, p31, p32, p33, p34, p35)
	local v122 = table.create(p28 + 1)
	local v123 = table.create(p28 + 1)
	local n1 = 1 / p28
	local n2 = p31 - p30
	local magnitude = n2.Magnitude
	local v127, v128 = v4.getPerpendicularVectors(if magnitude > 0.001 then n2 / magnitude else p34)
	local n3 = magnitude * n1

	for i = 0, p28 do
		local v131 = getBlendedPosition(i * n1, p29, p30, p31, p35)

		if i == 0 or i == p28 then
			v122[i + 1] = v131
			v123[i + 1] = Vector3.new(0, 0, 0)
		else
			local v132 = p27:NextNumber(p32.Min, p32.Max)
			local v133 = math.min(v132 * p33 * n3, n3 * 0.8)
			local v134 = p27:NextNumber(0, 6.283185307179586)
			local cosine = math.cos(v134)
			local sine = math.sin(v134)
			local n4 = (v127 * cosine + v128 * sine) * v133

			v122[i + 1] = v131 + n4
			v123[i + 1] = n4
		end
	end

	return v122, v123
end
local function updateTransitionPoints(p36, p37, p38, p39, p40)
	local v143 = table.create(p36 + 1)
	local jaggedOffsets = p40.jaggedOffsets

	for i = 0, p36 do
		v143[i + 1] = getBlendedPosition(i * (1 / p36), p37, p38, p39, p40) + (if jaggedOffsets then jaggedOffsets[i + 1] else Vector3.new(0, 0, 0))
	end

	return v143
end
local function isTransitionComplete(p41)
	return p41.distanceTraveled >= p41.boltLength + p41.transitionBuffer
end

return {
	init = function(p1)
		u7 = p1
	end,
	deinit = function()
		u7 = nil
	end,
	emit = function(p42, p43, p44, p45)
		local points = p42:FindFirstChild("Points")

		if not points or not points:IsA("Attachment") or not u7 then
			return
		end

		local v153 = v4.readCommonAttributes(p42)
		local v154 = readLightningAttributes(p42)
		local v155 = v4.drawFuncMap[v153.shapeType] and v4.drawFuncMap[v153.shapeType][v153.shapeStyle]

		if not v155 then
			return
		end

		local u156: boolean = v153.emitDuration > 0

		task.wait(v153.emitDelay)

		if u156 and not p45 then
			v3.forceEmit(p42, true)
			v1.trigger(p42, "Enabled", true)
			v3.onCancel(p44, function()
				local v185 = v3.stopEmitDuration(p42)

				if v185 then
					v3.cancelToken(v185)
				end
			end)

			if v153.speedStart ~= v153.speedEnd then
				v1.setState(p42, "SpeedTweening", true)

				local fromParams = v2.fromParams
				local v158 = v1.get(p42, "Speed_Curve", v3.default_bezier)
				local v159 = v1.get(p42, "Speed_Duration", 0.1)

				table.insert(p44, fromParams(v158, v159, function(p46, p47)
					v1.setState(p42, "SpeedOverride", v3.lerp(v153.speedStart, v153.speedEnd, p46))

					return p47
				end, nil, function()
					v1.setState(p42, "SpeedTweening", nil)
				end))
			end

			task.wait(v153.emitDuration)
			v3.awaitEmitDuration(v3.stopEmitDuration(p42))

			return
		end

		if v153.emitCount <= 0 then
			return
		end

		local v160 = v4.validateParent(p42)

		if not v160 then
			return
		end

		local v161, v162 = v3.getTransformedOriginExtents(v160)

		if not v161 then
			return
		end

		local v163, v164 = v4.findEndAttachments(p42)
		local v165 = v3.getBezierPoints(points)
		local random = Random.new()
		local u167 = not v163 and v5.new(v165)
		local new = v5.new
		local v169 = v3.deserializePath(v154.colorEasingData)
		local v170 = new(v169, 0)
		local v171 = v5.new
		local v172 = v3.deserializePath(v154.fillColorEasingData)
		local v173 = v171(v172, 0)
		local v174 = v5.new
		local v175 = v3.deserializePath(v154.fadeInCurveData)
		local v176 = v174(v175, 0)
		local v177 = v5.new
		local v178 = v3.deserializePath(v154.fadeOutCurveData)
		local v179 = v177(v178, 0)
		local v180 = v4.createHitboxParams({
			enabled = v153.hitboxEnabled,
			collisionGroup = v153.hitboxCollisionGroup,
			filterTag = v153.hitboxFilterTag,
			filterType = v153.hitboxFilterType,
			ignoreCanCollide = v153.hitboxIgnoreCanCollide
		}, v160, points)
		local t2: {[any]: any} = {}

		for _ = 1, v153.emitCount do
			local v183 = random:NextNumber(v153.duration.Min, v153.duration.Max)
			local v184 = v153.projectileEnabled and random:NextNumber(v153.projectileLifetime.Min, v153.projectileLifetime.Max)

			table.insert(t2, v6.new(function(p48)
				local v189 = v4.calculateEmissionCFrame(v161, v162, {
					face = v153.face,
					spreadAngle = v153.spreadAngle,
					mirror = v153.mirror,
					mirrorRot = v153.mirrorRot,
					partial = v153.partial,
					emissionDirection = v153.emissionDirection
				}, v155, random, v163, v160:IsA("Attachment"))
				local v190 = u167 or v4.createBezierWithEndpoint(v165, v189, v163, v164)
				local v191 = v4.createPosGetter(v190, v165, v189, v163, true)
				local v192 = table.create(v154.segments)
				local v193 = table.create(v154.segments)
				local v194 = createSegmentStates(v154.segments)
				local n1 = 1 / v154.segments
				local v196 = table.create(v154.segments)

				for i = 1, v154.segments do
					v196[i] = { start = (i - 1) * n1, finish = i * n1 }
				end

				if not u7 then
					p48()

					return
				end

				n1 = true

				if not (v154.fillTransparencyStart < 1) then
					n1 = v154.fillTransparencyEnd < 1
				end

				local u198 = nil
				local u199 = nil

				if n1 then
					local lightningContainer: Model = Instance.new("Model")

					lightningContainer.Name = "LightningContainer"
					lightningContainer.Parent = workspace.Terrain
					u199 = lightningContainer

					local highlight: Highlight = Instance.new("Highlight")

					highlight.Adornee = lightningContainer
					highlight.FillColor = v4.getColorWithEasingOklab(v154.fillColorSequence, 0, v173)
					highlight.FillTransparency = v154.fillTransparencyStart
					highlight.OutlineTransparency = 1
					highlight.DepthMode = Enum.HighlightDepthMode[v154.fillDepthMode]
					highlight.Parent = lightningContainer
					u198 = highlight
				end

				local function shouldEmitNested(p49)
					local nestedEffectMode = v154.nestedEffectMode

					if nestedEffectMode == "All" then
						return true
					end

					if nestedEffectMode == "Head" then
						return p49 == v154.segments
					end

					if nestedEffectMode == "Tail" then
						return p49 == 1
					end

					return false
				end

				local v203 = if v154.nestedEffectMode == "None" then nil else p44.effects.prepareEmitOnFinish(p43, p44)
				local t3 = {}
				local t4: {[any]: any} = {}

				for i = 1, v154.segments do
					local v207 = v3.getRandomId()
					local parent = u7:get(v207)._getReal()

					v3.copyProperties(p43, parent, v3.COPY_PART_PROPERTIES)
					parent.Size = Vector3.new(v154.widthStart, v154.widthStart, 1)
					parent.Anchored = true
					parent.CanQuery = false
					parent.CanTouch = false
					parent.CanCollide = false

					if n1 and u199 then
						parent.Parent = u199
					end

					local nestedEffectMode = v154.nestedEffectMode

					if if nestedEffectMode == "All" then true else if nestedEffectMode == "Head" then i == v154.segments else if nestedEffectMode == "Tail" then i == 1 else false then
						local clone = p43:Clone()

						for iterFirst, iterSecond in clone:GetChildren() do
							iterSecond.Parent = parent

							if v154.nestedEffectMode == "Head" then
								table.insert(t4, iterSecond)
							end
						end

						clone:Destroy()
						table.insert(t3, i)
					end

					v192[i] = parent
					v193[i] = v207
				end

				local u213 = nil

				if v154.nestedEffectMode == "Head" and #t4 > 0 then
					for key, value in t4 do
						value.Parent = v192[1]
					end

					u213 = 1
				end

				table.insert(p44, function()
					if u7 then
						for i = 1, v154.segments do
							u7:free(v193[i])
						end

						if u199 then
							u199:Destroy()
						end
					end
				end)

				local v216 = u199 or p43
				local u217: boolean = false
				local speedStart = v153.speedStart
				local widthStart = v154.widthStart
				local lengthStart = v154.lengthStart
				local transparencyStart = v154.transparencyStart
				local fillTransparencyStart = v154.fillTransparencyStart
				local n2 = 0
				local n3 = 0
				local n4 = 0
				local u226 = generateLightningPoints(random, v154.segments, v191, v154.jaggedness, v154.offsetScale)

				for key2, value2 in t3 do
					local v229 = p44.effects.emitNested(v192[if v154.nestedEffectMode == "Head" then 1 else value2], p44.depth + 1, p44)

					table.insert(t2, v229.Finished)
				end

				local vectorValue = Vector3.new(0, 0, 0)
				local vectorValue2 = Vector3.new(0, 0, 0)
				local n5 = 0
				local u233: boolean = false
				local n6 = 0
				local n7 = 0
				local n8 = 0
				local u237 = v154.widthStart
				local u238 = v161
				local u239 = nil
				local u240 = nil
				local u241 = nil
				local u242 = nil
				local u243 = nil

				if v153.speedStart ~= v153.speedEnd and not v1.getState(p42, "SpeedOverride", nil) then
					local fromParams = v2.fromParams
					local v245 = v1.get(p42, "Speed_Curve", v3.default_bezier)
					local v246 = v1.get(p42, "Speed_Duration", 0.1)

					u243 = fromParams(v245, v246, function(p50, p51)
						speedStart = v3.lerp(v153.speedStart, v153.speedEnd, p50)

						return p51
					end)
					table.insert(p44, u243)
				end

				t3 = function()
					return v1.getState(p42, "SpeedOverride", speedStart)
				end

				local function isSpeedTweening()
					if u243 then
						return u243.Connected
					end

					return (v1.getState(p42, "SpeedTweening", false))
				end
				local function getSpeedDelta(p52, p53)
					local v264 = v1.getState(p42, "SpeedOverride", speedStart)

					speedStart = v264

					if v264 > 0 then
						return p52 * v264
					end

					if not p53 and not (if u243 then u243.Connected else v1.getState(p42, "SpeedTweening", false)) then
						return nil
					end

					return p52 * v264
				end
				local function getHeadSegmentIndex()
					local roundedUp = math.ceil(n6 * v154.segments)

					return (math.clamp(roundedUp, 1, v154.segments))
				end
				local function shapecast()
					if not v153.hitboxEnabled then
						return false
					end

					local roundedUp = math.ceil(n6 * v154.segments)
					local v267 = math.clamp(roundedUp, 1, v154.segments)
					local v268 = v192[v267]

					if v268 and v268.Transparency < 1 and workspace:GetPartsInPart(v268, v180)[1] then
						return true
					end

					return false
				end
				local function refreshPoints()
					if u240 and u241 and u239 then
						if u242 and not (u242.distanceTraveled >= u242.boltLength + u242.transitionBuffer) then
							local v269 = u242
							local v270, v271 = generateTransitionPoints(random, v154.segments, v191, u241, u240, v154.jaggedness, v154.offsetScale, u239, u242)

							u226 = v270
							v269.jaggedOffsets = v271

							return
						end

						u226 = generateProjectilePoints(random, v154.segments, u241, u240, v154.jaggedness, v154.offsetScale, u239)

						if u242 then
							u242.jaggedOffsets = nil

							return
						end
					else
						u226 = generateLightningPoints(random, v154.segments, v191, v154.jaggedness, v154.offsetScale)
					end
				end
				local function updatePointsBetweenRefreshes(p54)
					if u242 and not (u242.distanceTraveled >= u242.boltLength + u242.transitionBuffer) then
						if u242.jaggedOffsets then
							u226 = updateTransitionPoints(v154.segments, v191, u241, u240, u242)

							return
						end

						local v273 = u242
						local v274, v275 = generateTransitionPoints(random, v154.segments, v191, u241, u240, v154.jaggedness, v154.offsetScale, u239, u242)

						u226 = v274
						v273.jaggedOffsets = v275

						return
					end

					for i = 1, #u226 do
						u226[i] = u226[i] + u239 * v153.projectileSpeed * p54
					end
				end
				local function updateSegments(p55, p56, p57, p58, p59)
					local v282 = os.clock()

					n6 = p55

					local v283 = p56 or math.max(0, p55 - lengthStart)
					local v284 = p59 or widthStart

					if p58 ~= false and v154.refreshRate > 0 then
						n4 += p57

						if 1 / v154.refreshRate <= n4 then
							refreshPoints()
							n4 = 0
						end
					end

					for i = 1, v154.segments do
						local v286 = v194[i]
						local v287 = v196[i]
						local v288 = v192[i]
						local start = v287.start
						local finish = v287.finish

						if not (v283 < finish) or not (p55 > start) then
							v288.Transparency = 1

							if v286.wasVisible then
								v286.wasVisible = false
								v286.birthTime = nil
								v286.initialWidth = nil
								v286.initialTransparency = nil
							end
						else
							if not v286.wasVisible then
								v286.wasVisible = true
								v286.birthTime = v282
								v286.initialWidth = widthStart
								v286.initialTransparency = transparencyStart
							end

							v288.Color = v4.getColorWithEasingOklab(v154.colorSequence, n2, v170)

							local v291 = if v154.independentSegments and v286.initialTransparency then v286.initialTransparency else transparencyStart
							local v292 = if v154.fadeInDuration > 0 then math.clamp(n5 / v154.fadeInDuration, 0, 1) else 1
							local v293 = v176:getEase(v292)

							v293 = v3.lerp(v154.fadeInStart, v291, 1 - v293.y)

							local v294 = v291

							if u233 and v154.fadeOutDuration > 0 then
								local v295 = math.clamp(n7 / v154.fadeOutDuration, 0, 1)
								local v296 = v179:getEase(v295)

								v294 = v3.lerp(v291, v154.fadeOutEnd, 1 - v296.y)
							end

							v288.Transparency = if v292 < 1 then v293 else if u233 then v294 else v291

							local n1

							if p59 then
								n1 = (if v154.independentSegments and v286.initialWidth then v286.initialWidth else widthStart) * (if widthStart > 0 then p59 / widthStart else 0)
							else
								n1 = if v154.independentSegments and v286.initialWidth then v286.initialWidth else v284
							end

							v294 = u226[i]
							v292 = u226[i + 1]

							if v294 and v292 then
								local v299 = if v283 > start then v294:Lerp(v292, (v283 - start) / (finish - start)) else v294
								local v300 = if p55 < finish then v294:Lerp(v292, (p55 - start) / (finish - start)) else v292
								local magnitude = (v300 - v299).Magnitude

								if magnitude > 0.001 then
									v288.Size = Vector3.new(n1, n1, magnitude)
									v288.CFrame = CFrame.lookAt((v299 + v300) / 2, v300)
								end
							end
						end
					end

					if u198 then
						u198.FillColor = v4.getColorWithEasingOklab(v154.fillColorSequence, n3, v173)
						u198.FillTransparency = fillTransparencyStart
					end

					if u213 then
						local roundedUp = math.ceil(n6 * v154.segments)
						local v303 = math.clamp(roundedUp, 1, v154.segments)

						if v303 ~= u213 then
							local parent = v192[v303]

							for key, value in t4 do
								value.Parent = parent
							end

							u213 = v303
						end
					end

					local v307 = math.min(p55, 1)

					v282 = v191(v307)

					if p57 > 0 then
						vectorValue = (v282 - vectorValue2) / p57
					end

					vectorValue2 = v282
				end

				v4.createPropertyTween(p44, p42, "Width", v183, v154.widthStart, v154.widthEnd, function(p60)
					widthStart = p60
				end, t3, u243)
				v4.createPropertyTween(p44, p42, "Transparency", v183, v154.transparencyStart, v154.transparencyEnd, function(p61)
					transparencyStart = p61
				end, t3, u243)
				v4.createPropertyTween(p44, p42, "Length", v183, v154.lengthStart, v154.lengthEnd, function(p62)
					lengthStart = p62
				end, t3, u243)

				if n1 then
					v4.createPropertyTween(p44, p42, "FillTransparency", v154.fillColorDuration, v154.fillTransparencyStart, v154.fillTransparencyEnd, function(p63)
						fillTransparencyStart = p63
					end, t3, u243)
				end

				n1 = function(p64, p65, p66, p67, p68, p69, p70)
					u233 = true
					n8 = p65
					u237 = p66
					v2.fromParams(p67, p68, function(p71, p72, p73)
						n7 = p73

						local v353 = v1.getState(p42, "SpeedOverride", speedStart)
						local n1 = p72 * v353

						n5 += n1

						if v154.refreshDuringDissipate then
							n2 = (n2 + n1 / v154.colorDuration) % 1
							n3 = (n3 + n1 / v154.fillColorDuration) % 1
						end

						v353 = if p69 == "Retract" then v3.lerp(n8, p64, p71) else nil

						local v355 = if p69 == "Scale" then v3.lerp(u237, 0, p71) else nil

						updateSegments(p64, v353, n1, v154.refreshDuringDissipate, v355)
						v355 = v1.getState(p42, "SpeedOverride", speedStart)
						speedStart = v355

						if v355 > 0 then
							return p72 * v355
						end

						return p72 * v355
					end, u243, p70, true, v3.RENDER_PRIORITY + p44.depth)
				end

				local function startDissipation()
					if not u233 and not u217 then
						local v319 = n6
						local v320 = if v203 then p44.effects.emitOnFinish(v203, v216, p44.depth + 1, p44) else nil

						local function onDissipationComplete()
							if u217 then
								return
							end

							u217 = true

							if v320 then
								v320.Finished:finally(function()
									p48()
								end)

								return
							end

							p48()
						end

						if v154.dissipateMode == "None" then
							if v154.fadeOutDuration > 0 then
								local v322 = math.max(0, v319 - lengthStart)

								u233 = true
								n8 = v322
								u237 = widthStart

								local s1: string = "None"

								v2.fromParams(v154.fadeOutCurveData, v154.fadeOutDuration, function(p77, p78, p79)
									n7 = p79

									local v359 = v1.getState(p42, "SpeedOverride", speedStart)
									local n1 = p78 * v359

									n5 += n1

									if v154.refreshDuringDissipate then
										n2 = (n2 + n1 / v154.colorDuration) % 1
										n3 = (n3 + n1 / v154.fillColorDuration) % 1
									end

									v359 = if s1 == "Retract" then v3.lerp(n8, v319, p77) else nil

									local v361 = if s1 == "Scale" then v3.lerp(u237, 0, p77) else nil

									updateSegments(v319, v359, n1, v154.refreshDuringDissipate, v361)
									v361 = v1.getState(p42, "SpeedOverride", speedStart)
									speedStart = v361

									if v361 > 0 then
										return p78 * v361
									end

									return p78 * v361
								end, u243, onDissipationComplete, true, v3.RENDER_PRIORITY + p44.depth)

								return
							end

							if u217 then
								return
							end

							u217 = true

							if v320 then
								v320.Finished:finally(function()
									p48()
								end)

								return
							end

							p48()

							return
						end

						local v324 = math.max(0, v319 - lengthStart)
						local dissipateMode = v154.dissipateMode

						u233 = true
						n8 = v324
						u237 = widthStart
						v2.fromParams(v154.dissipateCurveData, v154.dissipateDuration, function(p74, p75, p76)
							n7 = p76

							local v365 = v1.getState(p42, "SpeedOverride", speedStart)
							local n1 = p75 * v365

							n5 += n1

							if v154.refreshDuringDissipate then
								n2 = (n2 + n1 / v154.colorDuration) % 1
								n3 = (n3 + n1 / v154.fillColorDuration) % 1
							end

							v365 = if dissipateMode == "Retract" then v3.lerp(n8, v319, p74) else nil

							local v367 = if dissipateMode == "Scale" then v3.lerp(u237, 0, p74) else nil

							updateSegments(v319, v365, n1, v154.refreshDuringDissipate, v367)
							v367 = v1.getState(p42, "SpeedOverride", speedStart)
							speedStart = v367

							if v367 > 0 then
								return p75 * v367
							end

							return p75 * v367
						end, u243, onDissipationComplete, true, v3.RENDER_PRIORITY + p44.depth)

						return
					end
				end

				local v255 = v2.fromParams
				local v256 = v1.get(p42, "Easing_Curve", v3.linear_bezier)

				table.insert(p44, v255(v256, v183, function(p80, p81, _)
					local v329 = v1.getState(p42, "SpeedOverride", speedStart)
					local n1 = p81 * v329

					n5 += n1
					n2 = (n2 + n1 / v154.colorDuration) % 1
					n3 = (n3 + n1 / v154.fillColorDuration) % 1

					if v153.syncPosition then
						local v331 = v3.getTransformedOriginExtents(v160)
						local v332 = u238:Inverse()

						for i = 1, #u226 do
							u226[i] = (v331 * v332):PointToWorldSpace(u238:PointToObjectSpace(u226[i]))
						end

						u238 = v331
					end

					updateSegments(p80, nil, n1)

					local u334

					if not v153.hitboxEnabled then
						u334 = false
					else
						local roundedUp = math.ceil(n6 * v154.segments)
						local v336 = math.clamp(roundedUp, 1, v154.segments)
						local v337 = v192[v336]

						u334 = if v337 and v337.Transparency < 1 and workspace:GetPartsInPart(v337, v180)[1] then true else false
					end

					if u334 then
						startDissipation()

						return nil
					end

					local v338 = v1.getState(p42, "SpeedOverride", speedStart)

					speedStart = v338
					v329 = if v338 > 0 then p81 * v338 else if if u243 then u243.Connected else v1.getState(p42, "SpeedTweening", false) then p81 * v338 else nil

					if v329 == nil then
						return nil
					end

					if v153.projectileEnabled and p80 * v183 < v184 or not v153.projectileEnabled then
						return v329
					end

					startDissipation()

					return nil
				end, u243, function()
					if not u233 and not u217 then
						if v153.projectileEnabled then
							local v339 = if v153.projectileMatchEnd and v163 then v163.WorldCFrame.LookVector else vectorValue.Unit
							local u340 = if v339 == v339 and not (v339.Magnitude < 0.001) then v339.Unit else Vector3.new(0, 0, 1)
							local v341 = v191(1)
							local v342 = math.max(0, 1 - lengthStart)
							local v343 = v191(v342)
							local magnitude = (v341 - v343).Magnitude

							v343 = math.max(0, 1 - lengthStart)

							local n1 = 1 - v343
							local v346 = table.create(v154.segments + 1)

							for i = 0, v154.segments do
								local v348 = v191(v343 + i / v154.segments * n1)

								v346[i + 1] = u226[i + 1] - v348
							end

							local t5: {[any]: any} = {
								distanceTraveled = 0,
								curvedTailT = v343,
								curvedLengthT = n1,
								boltLength = magnitude,
								transitionBuffer = magnitude * 0.3,
								jaggedOffsets = v346
							}

							u242 = t5
							v2.timer(v184, function(p85, p86)
								local v370 = v1.getState(p42, "SpeedOverride", speedStart)
								local n1 = p85 * v370

								n5 += n1
								n2 = (n2 + n1 / v154.colorDuration) % 1
								n3 = (n3 + n1 / v154.fillColorDuration) % 1
								v370 = p86 * v153.projectileSpeed
								t5.distanceTraveled = v370

								local n7 = v341 + u340 * v370

								u240 = n7
								u241 = n7 - u340 * magnitude
								u239 = u340

								if v154.refreshRate > 0 then
									n4 += n1

									if n4 >= 1 / v154.refreshRate then
										refreshPoints()
										n4 = 0
									else
										updatePointsBetweenRefreshes(p85)
									end
								else
									updatePointsBetweenRefreshes(p85)
								end

								updateSegments(1, nil, n1, false)

								local u373

								if not v153.hitboxEnabled then
									u373 = false
								else
									local roundedUp = math.ceil(n6 * v154.segments)
									local v375 = math.clamp(roundedUp, 1, v154.segments)
									local v376 = v192[v375]

									u373 = if v376 and v376.Transparency < 1 and workspace:GetPartsInPart(v376, v180)[1] then true else false
								end

								if u373 then
									startDissipation()

									return nil
								end

								if p86 >= v184 then
									return nil
								end

								n1 = v1.getState(p42, "SpeedOverride", speedStart)
								speedStart = n1

								if n1 > 0 then
									return p85 * n1
								end

								return p85 * n1
							end, u243, p44, v3.RENDER_PRIORITY + p44.depth)
							startDissipation()

							return
						end

						if v153.destroyDelay > 0 then
							v2.fromParams(v3.linear_bezier, v153.destroyDelay, function(_, p84)
								local v379 = v1.getState(p42, "SpeedOverride", speedStart)
								local n1 = p84 * v379

								n5 += n1
								n2 = (n2 + n1 / v154.colorDuration) % 1
								n3 = (n3 + n1 / v154.fillColorDuration) % 1
								updateSegments(1, nil, n1, true)

								local u381

								if not v153.hitboxEnabled then
									u381 = false
								else
									local roundedUp = math.ceil(n6 * v154.segments)
									local v383 = math.clamp(roundedUp, 1, v154.segments)
									local v384 = v192[v383]

									u381 = if v384 and v384.Transparency < 1 and workspace:GetPartsInPart(v384, v180)[1] then true else false
								end

								if u381 then
									startDissipation()

									return nil
								end

								local v385 = v1.getState(p42, "SpeedOverride", speedStart)

								speedStart = v385

								if v385 > 0 then
									return p84 * v385
								end

								return p84 * v385
							end, u243, function()
								startDissipation()
							end, true, v3.RENDER_PRIORITY + p44.depth)

							return
						end

						startDissipation()

						return
					end
				end, true, v3.RENDER_PRIORITY + p44.depth))
			end))
		end

		v6.all(t2):await()
	end
}
