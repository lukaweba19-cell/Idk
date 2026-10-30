-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("../mod/attributes")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../mod/common/flipbook")
local v6 = require("../mod/color/Oklab")
local v7 = require("../pkg/Promise")
local random = Random.new()

return {
	emit = function(p1, p2, p3, p4, p5)
		local start = p1:FindFirstChild("Start")
		local v15 = p1:FindFirstChild("End")

		if start and v15 and start:IsA("BasePart") and v15:IsA("BasePart") and (not v2.get(p1, "Enabled", false) or not not p5) then
			local v16 = v2.get(p1, "Duration", 1, true)
			local getRange = v2.getRange
			local numberRange = NumberRange.new(v16, v16)
			local v19 = getRange(p1, "EffectDuration", numberRange, NumberRange.new(0, math.huge))

			v16 = random:NextNumber(v19.Min, v19.Max)
			v19 = v2.get(p1, "EmitDelay", 0)

			local v20 = v2.get(p1, "DestroyDelay", 0)
			local v21 = v2.get(p1, "EmitDuration", 0)
			local v22 = v2.get(p1, "Flipbook", false, true)
			local v23 = v2.get(p1, "FlipbookFadeOffset", 0, true)
			local s1 = if not v22 and start:FindFirstChildOfClass("Decal") then "Decal_" else "Mesh_"
			local startTransparency = p1:GetAttribute("StartTransparency")

			if startTransparency ~= nil then
				p1:SetAttribute(s1 .. "StartTransparency", startTransparency)
				p1:SetAttribute("StartTransparency", nil)
			end

			local endTransparency = p1:GetAttribute("EndTransparency")

			if endTransparency ~= nil then
				p1:SetAttribute(s1 .. "EndTransparency", endTransparency)
				p1:SetAttribute("EndTransparency", nil)
			end

			s1 = p1:HasTag(v4.ENABLED_VFX_TAG) and v21 > 0

			local v27 = v2.get(p1, "Decal_StartTransparency", 0, true)
			local v28 = v2.get(p1, "Decal_EndTransparency", 1, true)
			local n1: number = 0

			if start and start:FindFirstChildOfClass("Decal") then
				n1 = 1
			end

			local v30 = v2.get(p1, "Mesh_StartTransparency", n1, true)
			local v31 = v2.get(p1, "Mesh_EndTransparency", n1, true)
			local v32 = v2.get(p1, "SyncPosition", false)
			local v33 = v2.get(p1, "Speed_Start", 1)
			local v34 = v2.get(p1, "Speed_End", 1)
			local transparency = v2.get(p1, "Part_Transparency_Start", v30)
			local v36 = v2.get(p1, "Part_Transparency_End", v31)

			v31 = v2.get(p1, "SpreadAngle", Vector3.new(0, 0, 0))

			local v37 = v2.getRange(p1, "Part_RotSpeed_Start", NumberRange.new(0, 0))
			local v38 = v2.getRange(p1, "Part_RotSpeed_End", NumberRange.new(0, 0))
			local v39 = v2.get(p1, "RotAroundOrigin", false)
			local v40 = v2.get(p1, "MinInitRot", Vector3.new(0, 0, 0))
			local v41 = v2.get(p1, "MaxInitRot", Vector3.new(0, 0, 0))
			local v42 = random:NextNumber(v37.Min, v37.Max)
			local v43 = random:NextNumber(v38.Min, v38.Max)
			local v44 = random:NextNumber(v40.x, v41.x)
			local v45 = random:NextNumber(v40.y, v41.y)
			local n2 = vector.create(v44, v45, random:NextNumber(v40.z, v41.z)) * v4.DEG_TO_RAD

			task.wait(v19)

			if s1 and not p5 then
				v4.forceEmit(p1, true)
				v2.trigger(p1, "Enabled", true)
				v4.onCancel(p3, function()
					local v108 = v4.stopEmitDuration(p1)

					if v108 then
						v4.cancelToken(v108)
					end
				end)

				if v33 ~= v34 then
					v2.setState(p1, "SpeedTweening", true)

					local fromParams = v3.fromParams
					local v48 = v2.get(p1, "Speed_Curve", v4.default_bezier)
					local v49 = v2.get(p1, "Speed_Duration", 0.1)

					table.insert(p3, fromParams(v48, v49, function(p6, p7)
						v2.setState(p1, "SpeedOverride", v4.lerp(v33, v34, p6))

						return p7
					end, nil, function()
						v2.setState(p1, "SpeedTweening", nil)
					end))
				end

				task.wait(v21)
				v4.awaitEmitDuration(v4.stopEmitDuration(p1))

				return
			end

			local v50 = p1:FindFirstAncestorOfClass("Attachment") or start
			local parent = typeof(p2) == "table" and p2._getReal() or p2
			local v52 = v4.getTransformedOriginExtents(v50)
			local v53 = start.CFrame:ToObjectSpace(v15.CFrame)
			local u54 = v33
			local u55 = v42
			local u56 = CFrame.fromOrientation(n2.x, n2.y, n2.z)
			local cFrameIdentity = CFrame.identity
			local cFrameFromOrientation = CFrame.fromOrientation
			local v59 = random:NextNumber(-v31.x, v31.x)
			local v60 = math.rad(v59)
			local v61 = random:NextNumber(-v31.y, v31.y)

			v59 = math.rad(v61)

			local v62 = cFrameFromOrientation(v60, v59, 0)

			v31 = function(p8)
				local v112 = v32 and v4.getTransformedOriginExtents(v50) or v52
				local n1 = n2:Sign() * u55 * p8
				local v114 = u56
				local v115 = CFrame.fromOrientation(n1.x, n1.y, n1.z)

				u56 = v114 * v115
				p2.CFrame = (if v39 then v112 * v62 * u56 * cFrameIdentity else v112 * v62 * cFrameIdentity * u56) * u56
			end
			v31(0)

			local v63 = v4.getRandomId()

			runService:BindToRenderStep(v63, v4.RENDER_PRIORITY + p3.depth, v31)
			table.insert(p3, function()
				runService:UnbindFromRenderStep(v63)
			end)
			v31 = {}
			local v64 = p3.effects.prepareEmitOnFinish(p2, p3)

			v60 = p3.effects.emitNested(p2, p3.depth + 1, p3)
			table.insert(v31, v60.Finished)

			local u65 = nil

			if v33 ~= v34 and not v2.getState(p1, "SpeedOverride", nil) then
				local v66 = v3.fromParams
				local v67 = v2.get(p1, "Speed_Curve", v4.default_bezier)
				local v68 = v2.get(p1, "Speed_Duration", 0.1)

				u65 = v66(v67, v68, function(p9, p10)
					u54 = v4.lerp(v33, v34, p9)

					return p10
				end)
				table.insert(p3, u65)
			end

			if v53 ~= CFrame.identity then
				local v69 = v3.fromParams
				local v70 = v2.get(p1, "Part_CFrame_Curve", v4.default_bezier)

				table.insert(p3, v69(v70, v16, function(p11, p12)
					cFrameIdentity = CFrame.identity:Lerp(v53, p11)

					local v120 = v2.getState(p1, "SpeedOverride", u54)

					return p12 * v120
				end, u65))
			end

			if v42 ~= v43 then
				local v71 = v3.fromParams
				local v72 = v2.get(p1, "Part_RotSpeed_Curve", v4.default_bezier)

				table.insert(p3, v71(v72, v16, function(p13, p14)
					u55 = v4.lerp(v42, v43, p13)

					local v123 = v2.getState(p1, "SpeedOverride", u54)

					return p14 * v123
				end, u65))
			end

			if transparency ~= v36 then
				local v73 = v3.fromParams
				local v74 = v2.get(p1, "Part_Transparency_Curve", v4.default_bezier)

				table.insert(p3, v73(v74, v16, function(p15, p16)
					p2.Transparency = v4.lerp(transparency, v36, p15)

					local v126 = v2.getState(p1, "SpeedOverride", u54)

					return p16 * v126
				end, u65))
			else
				p2.Transparency = transparency
			end

			local n3 = start.Size * p4
			local n4 = v15.Size * p4

			if n3 ~= n4 then
				local n5 = -1
				local v78 = v3.fromParams
				local v79 = v2.get(p1, "Part_Size_Curve", v4.default_bezier)

				table.insert(p3, v78(v79, v16, function(p17, p18)
					local v129 = v2.getState(p1, "SpeedOverride", u54)

					if math.abs(p17 - n5) < 0.005 then
						return p18 * v129
					end

					n5 = p17
					p2.Size = n3:Lerp(n4, p17)

					return p18 * v129
				end, u65))
			else
				p2.Size = n3
			end

			local specialMesh = start:FindFirstChildOfClass("SpecialMesh")
			local specialMesh2 = v15:FindFirstChildOfClass("SpecialMesh")
			local specialMesh3 = p2:FindFirstChildOfClass("SpecialMesh")

			if specialMesh3 then
				if specialMesh and specialMesh2 then
					local n6 = specialMesh.Scale * p4
					local n7 = specialMesh2.Scale * p4

					if n6 ~= n7 then
						local v85 = v3.fromParams
						local v86 = v2.get(p1, "Mesh_Scale_Curve", v4.default_bezier)

						table.insert(p3, v85(v86, v16, function(p19, p20)
							specialMesh3.Scale = v4.lerp(n6, n7, p19)

							local v132 = v2.getState(p1, "SpeedOverride", u54)

							return p20 * v132
						end, u65))
					end
				else
					specialMesh3.Parent = nil
					table.insert(p3, function()
						specialMesh3.Parent = parent
					end)
				end
			end

			local v87, v88, v89 = v4.getMeshDecals(p1, p2)

			v60 = 0

			if v22 then
				table.sort(v87, function(p21, p22)
					local v135 = p21.Name:match("%d+")
					local v136 = p22.Name:match("%d+")
					local numberValue: number? = tonumber(v135 or 0)
					local numberValue2: number? = tonumber(v136 or 0)

					return numberValue < numberValue2
				end)

				local decal: Decal = Instance.new("Decal")

				decal.Parent = parent
				table.insert(p3, decal)

				if v23 > 0 and v27 ~= v28 then
					table.insert(p3, v3.fromParams(v4.default_bezier, v16 + v23, function(p23, p24)
						decal.Transparency = v4.lerp(v27, v28, p23)

						local v141 = v2.getState(p1, "SpeedOverride", u54)

						return p24 * v141
					end, u65))
				end

				table.insert(p3, v3.fromParams(v4.default_bezier, v16, function(p25, p26)
					local rounded = math.round(#v87 * p25)
					local v145 = math.max(rounded, 1)
					local v146 = v87[v145]

					decal.Texture = v146.Texture
					decal.Color3 = v146.Color3
					decal.ZIndex = v146.ZIndex

					if v23 == 0 then
						decal.Transparency = v4.lerp(v27, v28, p25)
						decal.ZIndex = v146.ZIndex
					end

					local v147 = v2.getState(p1, "SpeedOverride", u54)

					return p26 * v147
				end, u65))
			else
				for iterFirst, iterSecond in v87 do
					local v93 = v89[iterSecond]
					local v94 = v2.get(iterSecond, "Transparency_Start", v27)
					local v95 = v2.get(iterSecond, "Transparency_End", v28)

					if v94 ~= v95 then
						local v96 = v3.fromParams
						local v97 = v2.get(iterSecond, "Transparency_Curve", v4.default_bezier)

						table.insert(p3, v96(v97, v16, function(p27, p28)
							iterSecond.Transparency = v4.lerp(v94, v95, p27)

							local v150 = v2.getState(p1, "SpeedOverride", u54)

							return p28 * v150
						end, u65))
					else
						iterSecond.Transparency = v94
					end

					if iterSecond.Color3 ~= v93.Color3 then
						local v98 = v3.fromParams
						local v99 = v2.get(iterSecond, "Color_Curve", v4.default_bezier)

						table.insert(p3, v98(v99, v16, function(p29, p30)
							local v153 = v6.fromSRGB(iterSecond.Color3)
							local v154 = v6.fromSRGB(v93.Color3)
							local toSRGB = v6.toSRGB
							local v156 = v153:Lerp(v154, p29)

							iterSecond.Color3 = toSRGB(v156, true)

							local v157 = v2.getState(p1, "SpeedOverride", u54)

							return p30 * v157
						end, u65))
					end

					local v100 = v88[iterSecond]

					if v100 then
						local t1: {[any]: any} = {
							ref = iterSecond,
							frames = v100,
							speedTween = u65,
							effectDuration = v16,
							curve = v2.get(iterSecond, "Flipbook_Change_Curve", v4.linear_bezier),
							duration = v2.get(iterSecond, "Flipbook_Change_Duration", v16),
							getSpeed = function()
								return v2.getState(p1, "SpeedOverride", u54)
							end,
							setTexture = function(texture)
								iterSecond.Texture = texture
							end
						}

						local v102 = v5.getChangeDuration(t1)

						if v60 < v102 then
							v60 = v102
						end

						local v103 = v3.fromParams
						local curve = t1.curve
						local v105 = v5.createUpdateCallback(t1)

						table.insert(p3, v103(curve, v102, v105, u65))
					end
				end
			end

			local timer = v3.timer
			local v107 = math.max(v16, v60)

			timer(v107 + v23 + v20, function(p32, p33)
				local v161 = v2.getState(p1, "SpeedOverride", u54)

				u54 = v161

				if v161 > 0 or p33 > 0 and (if u65 then u65.Connected else v2.getState(p1, "SpeedTweening", false)) then
					return p32 * v161
				end

				return nil
			end, u65, p3)
			v7.all(v31):await()
			p3.effects.emitOnFinish(v64, parent, p3.depth + 1, p3).Finished:await()

			return
		end
	end
}
