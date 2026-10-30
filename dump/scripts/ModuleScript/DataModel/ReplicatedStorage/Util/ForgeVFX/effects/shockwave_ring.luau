-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local v2 = require("../mod/attributes")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../pkg/Promise")

require("../obj/ObjectCache")

local random = Random.new()
local u7 = nil

return {
	init = function(p1)
		u7 = p1
	end,
	deinit = function()
		u7 = nil
	end,
	emit = function(p2, p3, p4)
		if not u7 then
			return
		end

		local v12 = v2.get(p2, "RayDirection", Vector3.new(0, -50, 0))
		local v13 = v2.get(p2, "RayCollisionGroup", "Default")
		local v14 = v2.get(p2, "FilterTag", "")
		local v15 = v2.get(p2, "FilterType", "Exclude")
		local v16 = v2.get(p2, "IgnoreWater", true)
		local v17 = v2.get(p2, "IgnoreCanCollide", false)
		local raycastParams = RaycastParams.new()

		raycastParams.CollisionGroup = v13
		raycastParams.IgnoreWater = v16
		raycastParams.RespectCanCollide = not v17
		raycastParams.FilterType = Enum.RaycastFilterType[v15]
		raycastParams.FilterDescendantsInstances = collectionService:GetTagged(v14)

		if v15 == "Exclude" then
			raycastParams:AddToFilter({ workspace.Terrain })
		end

		local v19 = v2.get(p3, "EmitDelay", 0)

		v16 = v2.get(p3, "Radius", 5)
		v15 = v2.get(p3, "Segments", 7)
		v14 = v2.getRange(p3, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, math.huge))
		v13 = v2.get(p3, "PartOffset", Vector3.new(0, 0, 0), true)

		local v20 = v2.get(p3, "BaseOffset", v13)
		local v21 = v2.get(p3, "Offset_Start", v13)
		local v22 = v2.get(p3, "Offset_End", v13)
		local v23 = v2.get(p3, "Offset_Start_Duration", 0.5)
		local v24 = v2.get(p3, "Offset_End_Duration", 0.5)
		local v25 = v2.get(p3, "SizeScaleStart", Vector3.new(0, 0, 0))
		local v26 = v2.get(p3, "SizeScaleEnd", Vector3.new(0, 0, 0))
		local v27 = v2.get(p3, "MinSize", Vector3.new(2, 1, 2))
		local v28 = v2.get(p3, "MaxSize", Vector3.new(3, 2, 3))
		local v29 = v2.get(p3, "Size_Curve", v4.default_bezier, true)
		local v30 = v2.get(p3, "Size_Duration", 0.5, true)
		local v31 = v2.get(p3, "Size_Start_Curve", v29)
		local v32 = v2.get(p3, "Size_End_Curve", v29)
		local v33 = v2.get(p3, "Size_Start_Duration", v30)
		local v34 = v2.get(p3, "Size_End_Duration", v30)
		local v35 = v2.get(p3, "Transparency_Duration", 0.5)
		local transparency = v2.get(p3, "Transparency_Start", 0)
		local v37 = v2.get(p3, "Transparency_End", 0)

		task.wait(v19)

		local t1: {[any]: any} = {}
		local v39 = v4.getTransformedOriginExtents(p2)

		for i = 0, v15 - 1 do
			local n1 = i / v15 * 3.141592653589793 * 2
			local cosine = math.cos(n1)
			local sine = math.sin(n1)
			local cFrame = CFrame.new(v16 * cosine, 0, v16 * sine)
			local v45 = (v39 * cFrame).Position
			local v46 = v39:VectorToWorldSpace(v12)
			local v47 = workspace:Raycast(v45, v46, raycastParams)

			if v47 then
				local v48 = random:NextNumber(v27.X, v28.X)
				local v49 = random:NextNumber(v27.Y, v28.Y)
				local v50 = random:NextNumber(v27.Z, v28.Z)
				local v51 = v4.getRandomId()
				local v52 = u7:get(v51)
				local parent = v52._getReal()

				v4.copyProperties(p3, parent, v4.COPY_PART_PROPERTIES)
				v4.copyProperties(p3, parent, v4.COPY_EXTENDED_PART_PROPERTIES)

				if #p3:GetChildren() ~= 0 then
					local clone = p3:Clone()

					for iterFirst, iterSecond in clone:GetChildren() do
						iterSecond.Parent = parent
					end

					clone:Destroy()
				end

				local v57 = p4.effects.prepareEmitOnFinish(v52, p4)

				table.insert(p4, function()
					if u7 then
						u7:free(v51)
					end
				end)
				v52.Color = v47.Instance.Color
				v52.Material = v47.Material
				v52.Transparency = v47.Instance.Transparency

				if v52.Transparency == 0 then
					v52.Transparency = transparency
				end

				v52.Size = Vector3.new(0, 0, 0)

				local cosine2 = math.cos(n1)
				local sine2 = math.sin(n1)
				local vector3 = Vector3.new(-cosine2, 0, -sine2)
				local v61 = v39:VectorToWorldSpace(vector3):Cross(v47.Normal)
				local v62 = CFrame.fromMatrix(v47.Position, v61.Unit, v47.Normal)
				local cFrameFromOrientation = CFrame.fromOrientation
				local v64 = math.atan(v49 / v50)
				local v65 = cFrameFromOrientation(-v64, 0, 0)
				local n2 = v62 * v65

				v52.CFrame = CFrame.new(v21) * n2

				local u67 = nil
				local u68 = nil
				local vectorValue = Vector3.new(0, 0, 0)

				if v21 ~= v20 then
					local fromParams = v3.fromParams
					local v71 = v2.get(p3, "Offset_Start_Curve", v4.default_bezier)

					u68 = fromParams(v71, v23, function(p5, p6)
						vectorValue = v21:Lerp(v20, p5)
						v52.CFrame = CFrame.new(vectorValue) * n2

						return p6
					end)
					table.insert(p4, u67)
				end

				local vector32 = Vector3.new(v48, v49, v50)

				if vector32 * v25 ~= vector32 then
					u67 = v3.fromParams(v31, v33, function(p7, p8)
						v52.Size = (vector32 * v25):Lerp(vector32, p7)

						return p8
					end)
					table.insert(p4, u67)
				else
					v52.Size = vector32 * v25
				end

				v64 = p4.effects.emitNested(v52, p4.depth + 1, p4)
				table.insert(t1, v64.Finished)

				local taskDelay = task.delay
				local v74 = random:NextNumber(v14.Min, v14.Max)

				taskDelay(v74, function()
					if u67 then
						u67:Disconnect()
					end

					if u68 then
						u68:Disconnect()
					end

					local v82 = v52.Size
					local transparency = v52.Transparency

					if v82 ~= vector32 * v26 then
						table.insert(p4, v3.fromParams(v32, v34, function(p9, p10)
							v52.Size = v82:Lerp(vector32 * v26, p9)

							return p10
						end))
					end

					if vectorValue ~= v22 then
						local fromParams = v3.fromParams
						local v85 = v2.get(p3, "Offset_End_Curve", v4.default_bezier)

						table.insert(p4, fromParams(v85, v24, function(p11, p12)
							v52.CFrame = CFrame.new(vectorValue:Lerp(v22, p11)) * n2

							return p12
						end))
					end

					if transparency ~= v37 then
						local v86 = v3.fromParams
						local v87 = v2.get(p3, "Transparency_Curve", v4.default_bezier)

						table.insert(p4, v86(v87, v35, function(p13, p14)
							v52.Transparency = v4.lerp(transparency, v37, p13)

							return p14
						end))
					end

					local v88 = p4.effects.emitOnFinish(v57, v52, p4.depth + 1, p4)

					table.insert(t1, v88.Finished)
				end)
			end
		end

		local taskWait = task.wait
		local max = v14.Max
		local v77 = math.max(v34, v24)

		taskWait(max + v77)
		v5.all(t1):await()
	end
}
