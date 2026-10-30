-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("../mod/attributes")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../mod/common/bezier")
local v6 = require("../obj/Bezier")
local v7 = require("../pkg/Promise")

require("../obj/ObjectCache")

local u8 = nil

local function readBezierAttributes(p2)
	local v11 = v2.get(p2, "FacePath", false)
	local v12 = v2.get(p2, "ArcSpace", false)
	local v13 = v2.getRange(p2, "RotSpeed_Start", NumberRange.new(0, 0))
	local v14 = v2.getRange(p2, "RotSpeed_End", NumberRange.new(0, 0))
	local v15 = v2.get(p2, "MinInitRot", Vector3.new(0, 0, 0))
	local v16 = v2.get(p2, "MaxInitRot", Vector3.new(0, 0, 0))
	local v17 = v2.get(p2, "Speed_Curve", v4.default_bezier)
	local v18 = v2.get(p2, "Speed_Duration", 0.1)
	local v19 = v2.get(p2, "Easing_Curve", v4.linear_bezier)

	return {
		facePath = v11,
		arcSpace = v12,
		rotSpeedStart = v13,
		rotSpeedEnd = v14,
		minInitRot = v15,
		maxInitRot = v16,
		speedCurve = v17,
		speedDuration = v18,
		easingCurve = v19
	}
end

return {
	init = function(p1)
		u8 = p1
	end,
	deinit = function()
		u8 = nil
	end,
	emit = function(p3, p4, p5, p6)
		local points = p3:FindFirstChild("Points")

		if not points or not points:IsA("Attachment") or not u8 then
			return
		end

		local v26 = v5.readCommonAttributes(p3)
		local v27 = readBezierAttributes(p3)
		local v28 = v5.drawFuncMap[v26.shapeType] and v5.drawFuncMap[v26.shapeType][v26.shapeStyle]

		if not v28 then
			return
		end

		local u29: boolean = v26.emitDuration > 0

		task.wait(v26.emitDelay)

		if u29 and not p6 then
			v4.forceEmit(p3, true)
			v2.trigger(p3, "Enabled", true)
			v4.onCancel(p5, function()
				local v48 = v4.stopEmitDuration(p3)

				if v48 then
					v4.cancelToken(v48)
				end
			end)

			if v26.speedStart ~= v26.speedEnd then
				v2.setState(p3, "SpeedTweening", true)
				table.insert(p5, v3.fromParams(v27.speedCurve, v27.speedDuration, function(p7, p8)
					v2.setState(p3, "SpeedOverride", v4.lerp(v26.speedStart, v26.speedEnd, p7))

					return p8
				end, nil, function()
					v2.setState(p3, "SpeedTweening", nil)
				end))
			end

			task.wait(v26.emitDuration)
			v4.awaitEmitDuration(v4.stopEmitDuration(p3))

			return
		end

		if v26.emitCount <= 0 then
			return
		end

		local v30 = v5.validateParent(p3)

		if not v30 then
			return
		end

		local v31, v32 = v4.getTransformedOriginExtents(v30)

		if not v31 then
			return
		end

		local v33, v34 = v5.findEndAttachments(p3)
		local v35 = v4.getBezierPoints(points)
		local random = Random.new()
		local u37 = not v33 and v6.new(v35)
		local v38 = v5.createHitboxParams({
			enabled = v26.hitboxEnabled,
			collisionGroup = v26.hitboxCollisionGroup,
			filterTag = v26.hitboxFilterTag,
			filterType = v26.hitboxFilterType,
			ignoreCanCollide = v26.hitboxIgnoreCanCollide
		}, v30, points)
		local t1: {[any]: any} = {}

		for _ = 1, v26.emitCount do
			local v41 = random:NextNumber(v27.rotSpeedStart.Min, v27.rotSpeedStart.Max)
			local v42 = random:NextNumber(v27.rotSpeedEnd.Min, v27.rotSpeedEnd.Max)
			local v43 = random:NextNumber(v27.minInitRot.x, v27.maxInitRot.x)
			local v44 = random:NextNumber(v27.minInitRot.y, v27.maxInitRot.y)
			local vectorValue = vector.create(v43, v44, random:NextNumber(v27.minInitRot.z, v27.maxInitRot.z))
			local v46 = random:NextNumber(v26.duration.Min, v26.duration.Max)
			local v47 = v26.projectileEnabled and random:NextNumber(v26.projectileLifetime.Min, v26.projectileLifetime.Max)

			table.insert(t1, v7.new(function(p9)
				local v52 = v5.calculateEmissionCFrame(v31, v32, {
					face = v26.face,
					spreadAngle = v26.spreadAngle,
					mirror = v26.mirror,
					mirrorRot = v26.mirrorRot,
					partial = v26.partial,
					emissionDirection = v26.emissionDirection
				}, v28, random, v33, v30:IsA("Attachment"))
				local v53 = u37 or v5.createBezierWithEndpoint(v35, v52, v33, v34)
				local v54 = v5.createPosGetter(v53, v35, v52, v33, v27.arcSpace)
				local v55 = v4.getRandomId()

				if not u8 then
					p9()

					return
				end

				local v56 = u8:get(v55)

				v56.CFrame = CFrame.new(v54(0))

				local parent = v56._getReal()

				v4.copyProperties(p4, parent, v4.COPY_PART_PROPERTIES)
				v4.copyProperties(p4, parent, v4.COPY_EXTENDED_PART_PROPERTIES)

				local clone = p4:Clone()

				for iterFirst, iterSecond in clone:GetChildren() do
					iterSecond.Parent = parent
				end

				clone:Destroy()

				local v61 = p5.effects.prepareEmitOnFinish(parent, p5)
				local v62 = p5.effects.emitNested(parent, p5.depth + 1, p5)

				table.insert(t1, v62.Finished)
				table.insert(p5, function()
					if u8 then
						u8:free(v55)
					end
				end)

				local vectorValue2 = Vector3.new(0, 0, 0)
				local vectorValue3 = Vector3.new(0, 0, 0)
				local u65: boolean = false
				local u66: boolean = false
				local cFrameIdentity = CFrame.identity
				local speedStart = v26.speedStart
				local u69 = CFrame.fromOrientation(vectorValue.x, vectorValue.y, vectorValue.z)
				local u70 = v41

				local function onFinish()
					if u66 then
						return
					end

					if v26.syncPosition then
						local v76 = v4.getTransformedOriginExtents(v30)
						local cFrame = v56.CFrame
						local v78 = v4.getRandomId()

						runService:BindToRenderStep(v78, v4.RENDER_PRIORITY + p5.depth, function()
							local v99 = v4.getTransformedOriginExtents(v30)
							local v100 = v76:ToObjectSpace(cFrame)

							v56.CFrame = v99 * v100
						end)
						table.insert(p5, function()
							runService:UnbindFromRenderStep(v78)
						end)
					end

					u66 = true
					p5.effects.emitOnFinish(v61, parent, p5.depth + 1, p5).Finished:finally(function()
						p9()
					end)
				end
				local function shapecast()
					if not v26.hitboxEnabled then
						return false
					end

					return workspace:GetPartsInPart(parent, v38)[1] ~= nil
				end

				local u73 = nil

				if v26.speedStart ~= v26.speedEnd and not v2.getState(p3, "SpeedOverride", nil) then
					u73 = v3.fromParams(v27.speedCurve, v27.speedDuration, function(p10, p11)
						speedStart = v4.lerp(v26.speedStart, v26.speedEnd, p10)

						return p11
					end)
					table.insert(p5, u73)
				end

				local function getEffectiveSpeed()
					return v2.getState(p3, "SpeedOverride", speedStart)
				end
				local function isSpeedTweening()
					if u73 then
						return u73.Connected
					end

					return (v2.getState(p3, "SpeedTweening", false))
				end

				v5.createPropertyTween(p5, p3, "RotSpeed", v46, v41, v42, function(p12)
					u70 = p12
				end, function()
					return getEffectiveSpeed()
				end, u73)
				table.insert(p5, v3.fromParams(v27.easingCurve, v46, function(p13, p14, p15)
					local v85 = v54(p13)
					local cFrame = CFrame.new(v85)

					if v27.facePath then
						local v87 = math.clamp((p15 + 0.016666666666666666) / v46, 0, 1)
						local v88 = v54(v87)

						cFrame = if v85 == v88 then cFrame * cFrameIdentity.Rotation else CFrame.lookAt(v85, v88)
					end

					local n1 = vectorValue:Sign() * u70 * v4.DEG_TO_RAD * p14
					local v90 = u69
					local v91 = CFrame.fromOrientation(n1.x, n1.y, n1.z)

					u69 = v90 * v91
					cFrameIdentity = cFrame

					local n2 = cFrame * u69

					if v26.syncPosition then
						local v93 = v4.getTransformedOriginExtents(v30)
						local v94 = v31:ToObjectSpace(n2)

						v56.CFrame = v93 * v94
					else
						v56.CFrame = n2
					end

					vectorValue3 = (v85 - vectorValue2) / p14
					vectorValue2 = v85

					if if not v26.hitboxEnabled then false else workspace:GetPartsInPart(parent, v38)[1] ~= nil then
						onFinish()
						u65 = true

						return nil
					end

					n2 = v2.getState(p3, "SpeedOverride", speedStart)
					speedStart = n2

					if n2 == 0 and not (if u73 then u73.Connected else v2.getState(p3, "SpeedTweening", false)) then
						return nil
					end

					if v26.projectileEnabled and p13 * v46 < v47 or not v26.projectileEnabled then
						return p14 * n2
					end

					onFinish()

					return nil
				end, u73, function(p16)
					if v26.projectileEnabled and not u65 then
						local v96 = if v26.projectileMatchEnd and v33 then v33.WorldCFrame.LookVector else vectorValue3.Unit

						if v96 ~= v96 then
							v96 = Vector3.new(0, 0, 0)
						end

						vectorValue3 = v96 * v26.projectileSpeed

						local parentPosition = parent.Position
						local v98 = v4.getTransformedOriginExtents(v30)

						v3.timer(v47, function(p17, p18)
							if v26.syncPosition then
								local v103 = v4.getTransformedOriginExtents(v30)
								local v104 = v98:ToObjectSpace(CFrame.new(parentPosition + vectorValue3 * p18))

								v56.CFrame = v103 * v104
							else
								v56.CFrame = CFrame.new(parentPosition + vectorValue3 * p18) * parent.CFrame.Rotation
							end

							if if not v26.hitboxEnabled then false else workspace:GetPartsInPart(parent, v38)[1] ~= nil then
								onFinish()
								u65 = true

								return nil
							end

							local v105 = v2.getState(p3, "SpeedOverride", speedStart)

							speedStart = v105

							if v105 > 0 or p18 > 0 and (if u73 then u73.Connected else v2.getState(p3, "SpeedTweening", false)) then
								return p17 * v105
							end

							return nil
						end, u73, p5, v4.RENDER_PRIORITY + p5.depth)

						if not u65 then
							onFinish()
						end
					elseif p16 then
						onFinish()
					end
				end, true, v4.RENDER_PRIORITY + p5.depth))
			end))
		end

		v7.all(t1):await()
		task.wait(v26.destroyDelay)
	end
}
