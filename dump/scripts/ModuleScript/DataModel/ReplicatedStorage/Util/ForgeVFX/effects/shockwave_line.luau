-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local v2 = require("../mod/attributes")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/logger")
local v5 = require("../mod/utility")
local v6 = require("../obj/Bezier")
local v7 = require("../pkg/Promise")

require("../obj/ObjectCache")

local random = Random.new()
local u9 = nil

return {
	init = function(p1)
		u9 = p1
	end,
	deinit = function()
		u9 = nil
	end,
	emit = function(p2, p3, p4)
		if not u9 then
			return
		end

		local v14 = v2.get(p2, "RayDirection", Vector3.new(0, -50, 0))
		local collisionGroup = v2.get(p2, "RayCollisionGroup", "Default")
		local v16 = v2.get(p2, "FilterTag", "")
		local v17 = v2.get(p2, "FilterType", "Exclude")
		local v18 = v2.get(p2, "IgnoreWater", true)
		local v19 = v2.get(p2, "IgnoreCanCollide", false)
		local raycastParams = RaycastParams.new()

		raycastParams.CollisionGroup = collisionGroup
		raycastParams.IgnoreWater = v18
		raycastParams.RespectCanCollide = not v19
		raycastParams.FilterType = Enum.RaycastFilterType[v17]
		raycastParams.FilterDescendantsInstances = collectionService:GetTagged(v16)

		if v17 == "Exclude" then
			raycastParams:AddToFilter({ workspace.Terrain })
		end

		local v21 = v2.get(p3, "EmitDelay", 0)
		local u22 = v2.get(p3, "Rate_Start", 30)
		local u23 = v2.get(p3, "Rate_End", 30)

		v18 = v2.get(p3, "FixedAmount", 0)

		local v24 = v2.get(p3, "Scale_Start", 1)
		local v25 = v2.get(p3, "Scale_End", 1)
		local v26 = v2.get(p3, "Duration", 1)
		local v27 = v2.get(p3, "Direction", Vector3.new(0, 0, -1))
		local v28 = v2.get(p3, "Length", 50)
		local v29 = v2.getRange(p3, "Rotation", NumberRange.new(-180, 180))
		local v30 = v2.get(p3, "PartOffset", Vector3.new(0, 0, 0), true)
		local v31 = v2.get(p3, "BaseOffset", v30)
		local v32 = v2.get(p3, "Offset_Start", v30)
		local v33 = v2.get(p3, "Offset_End", v30)
		local v34 = v2.get(p3, "Offset_Start_Duration", 0.5)
		local v35 = v2.get(p3, "Offset_End_Duration", 0.5)
		local v36 = v2.getRange(p3, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, math.huge))
		local v37 = v2.get(p3, "SizeScaleStart", Vector3.new(0, 0, 0))
		local v38 = v2.get(p3, "SizeScaleEnd", Vector3.new(0, 0, 0))
		local v39 = v2.get(p3, "MinSize", Vector3.new(2, 1, 2))
		local v40 = v2.get(p3, "MaxSize", Vector3.new(3, 2, 3))
		local v41 = v2.get(p3, "Size_Curve", v5.default_bezier, true)
		local v42 = v2.get(p3, "Size_Duration", 0.5, true)
		local v43 = v2.get(p3, "Size_Start_Curve", v41)
		local v44 = v2.get(p3, "Size_End_Curve", v41)
		local v45 = v2.get(p3, "Size_Start_Duration", v42)
		local v46 = v2.get(p3, "Size_End_Duration", v42)
		local v47 = v2.get(p3, "Transparency_Duration", 0.5)
		local v48 = v2.get(p3, "Transparency_Start", 0)
		local v49 = v2.get(p3, "Transparency_End", 0)
		local v50 = v2.get(p3, "SyncPosition", false)
		local u51 = math.max(v26, 0.001)

		if v18 > 0 then
			local n1 = v18 / u51

			u22 = n1
			u23 = n1
		end

		local u53 = v27.Unit

		if u53 ~= u53 then
			u53 = Vector3.new(-0, -0, -1)
		end

		task.wait(v21)

		local t1: {[any]: any} = {}
		local u55 = v5.getTransformedOriginExtents(p2)
		local n2 = 0
		local n3: number = 0
		local n4 = u22
		local u59 = v24

		if v24 ~= v25 then
			local fromParams = v3.fromParams
			local v61 = v2.get(p3, "Scale_Curve", v5.default_bezier)

			table.insert(p4, fromParams(v61, u51, function(p5, p6)
				u59 = v5.lerp(v24, v25, p5)

				return p6
			end))
		end

		if u22 ~= u23 then
			local v62 = v3.fromParams
			local v63 = v2.get(p3, "Rate_Curve", v5.default_bezier)

			table.insert(p4, v62(v63, u51, function(p7, p8)
				n4 = v5.lerp(u22, u23, p7)

				return p8
			end))
		end

		local v64 = v2.get(p3, "Path_Curve", v5.linear_bezier)

		local ok, result = pcall(function()
			return v5.deserializePath(v64)
		end)

		if not ok then
			local error = v4.error
			local v68 = ("failed to decode bezier path data with error: %*"):format(result)

			error(v68)
		end

		local v69 = v6.new(result, 0)

		table.insert(p4, v3.fromParams(v5.linear_bezier, u51, function(_, p10)
			n2 += p10

			local n1 = 1 / n4
			local n6 = u51 * n4

			if n1 > n2 or n6 <= n3 then
				return p10
			end

			for _ = 1, n2 // n1 do
				if not (n6 <= n3) then
					n3 += 1

					local v82 = math.clamp(n3 / n6, 0, 1)
					local n7 = 1 - v69:getEase(v82).y

					if v50 then
						u55 = v5.getTransformedOriginExtents(p2)
					end

					v82 = v5.getTransformedOriginExtents(p2)

					local v84 = u55.Position
					local v85 = u55:VectorToWorldSpace(u53)
					local v86 = v82:VectorToWorldSpace(v14)
					local v87 = workspace:Raycast(v84 + v85 * v28 * n7, v86, raycastParams)

					if not v87 then
						n2 = 0

						return p10
					end

					local v88 = random:NextNumber(v39.X, v40.X)
					local v89 = random:NextNumber(v39.Y, v40.Y)
					local v90 = random:NextNumber(v39.Z, v40.Z)
					local v91 = v5.getRandomId()
					local v92 = u9:get(v91)
					local parent = v92._getReal()

					v5.copyProperties(p3, parent, v5.COPY_PART_PROPERTIES)
					v5.copyProperties(p3, parent, v5.COPY_EXTENDED_PART_PROPERTIES)

					if #p3:GetChildren() ~= 0 then
						local clone = p3:Clone()

						for iterFirst, iterSecond in clone:GetChildren() do
							iterSecond.Parent = parent
						end

						clone:Destroy()
					end

					local v97 = p4.effects.prepareEmitOnFinish(parent, p4)

					table.insert(p4, function()
						if u9 then
							u9:free(v91)
						end
					end)
					v92.Color = v87.Instance.Color
					v92.Material = v87.Material
					v92.Transparency = v87.Instance.Transparency

					if v92.Transparency == 0 then
						v92.Transparency = v48
					end

					v92.Size = Vector3.new(0, 0, 0)

					local v98 = random:NextNumber(v29.Min, v29.Max)
					local cosine = math.cos(v98)
					local sine = math.sin(v98)
					local vector3 = Vector3.new(-cosine, 0, -sine)
					local v102 = v82:VectorToWorldSpace(vector3):Cross(v87.Normal)
					local v103 = CFrame.fromMatrix(v87.Position, v102.Unit, v87.Normal)
					local cFrameFromOrientation = CFrame.fromOrientation
					local v105 = math.atan(v89 / v90)
					local v106 = cFrameFromOrientation(-v105, 0, 0)
					local n8 = v103 * v106

					v92.CFrame = CFrame.new(v32) * n8

					local u108 = nil
					local u109 = nil
					local vectorValue = Vector3.new(0, 0, 0)

					if v32 ~= v31 then
						local fromParams = v3.fromParams
						local v112 = v2.get(p3, "Offset_Start_Curve", v5.default_bezier)

						u109 = fromParams(v112, v34, function(p11, p12)
							vectorValue = v32:Lerp(v31, p11)
							v92.CFrame = CFrame.new(vectorValue) * n8

							return p12
						end)
						table.insert(p4, u109)
					end

					local n5 = Vector3.new(v88, v89, v90) * u59

					if n5 * v37 ~= n5 then
						u108 = v3.fromParams(v43, v45, function(p13, p14)
							v92.Size = (n5 * v37):Lerp(n5, p13)

							return p14
						end)
						table.insert(p4, u108)
					else
						v92.Size = n5 * v37
					end

					v105 = p4.effects.emitNested(parent, p4.depth + 1, p4)
					table.insert(t1, v105.Finished)

					local taskDelay = task.delay
					local v115 = random:NextNumber(v36.Min, v36.Max)

					taskDelay(v115, function()
						if u108 then
							u108:Disconnect()
						end

						if u109 then
							u109:Disconnect()
						end

						local v120 = v92.Size
						local transparency = v92.Transparency

						if v120 ~= n5 * v38 then
							table.insert(p4, v3.fromParams(v44, v46, function(p15, p16)
								v92.Size = v120:Lerp(n5 * v38, p15)

								return p16
							end))
						end

						if vectorValue ~= v33 then
							local fromParams = v3.fromParams
							local v123 = v2.get(p3, "Offset_End_Curve", v5.default_bezier)

							table.insert(p4, fromParams(v123, v35, function(p17, p18)
								v92.CFrame = CFrame.new(vectorValue:Lerp(v33, p17)) * n8

								return p18
							end))
						end

						if transparency ~= v49 then
							local v124 = v3.fromParams
							local v125 = v2.get(p3, "Transparency_Curve", v5.default_bezier)

							table.insert(p4, v124(v125, v47, function(p19, p20)
								v92.Transparency = v5.lerp(transparency, v49, p19)

								return p20
							end))
						end

						local v126 = p4.effects.emitOnFinish(v97, parent, p4.depth + 1, p4)

						table.insert(t1, v126.Finished)
					end)
				end
			end

			n2 %= n1

			return p10
		end, nil, nil, true, v5.RENDER_PRIORITY + p4.depth))

		local taskWait = task.wait
		local n5 = v36.Max + u51
		local v72 = math.max(v46, v35)

		taskWait(n5 + v72)
		v7.all(t1):await()
	end
}
