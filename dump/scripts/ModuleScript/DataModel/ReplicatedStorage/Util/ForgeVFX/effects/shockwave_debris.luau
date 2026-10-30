-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local collectionService: CollectionService = game:GetService("CollectionService")
local v3 = require("../mod/attributes")
local v4 = require("../mod/tween")

require("../types")

local v5 = require("../mod/utility")
local v6 = require("../pkg/Promise")

require("../obj/ObjectCache")

local random = Random.new()
local t1: {[any]: any} = {}
local u9 = nil
local connection = nil

return {
	init = function(p1)
		if connection then
			return
		end

		u9 = p1

		if v5.PLUGIN_CONTEXT then
			connection = runService.RenderStepped:Connect(function(deltaTime: number)
				if #t1 == 0 then
					return
				end

				workspace:StepPhysics(deltaTime, t1)
			end)
		end
	end,
	deinit = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		u9 = nil

		for key, value in t1 do
			value:Destroy()
		end

		table.clear(t1)
	end,
	emit = function(p3, p4, p5)
		if not u9 then
			return
		end

		local v17 = nil
		local v18 = v3.get(p4, "InheritanceEnabled", true)
		local v19 = v3.get(p4, "InheritanceRadius", 5)
		local collisionGroup = v3.get(p3, "RayCollisionGroup", "Default")
		local v21 = v3.get(p3, "FilterTag", "")
		local v22 = v3.get(p3, "FilterType", "Exclude")
		local v23 = v3.get(p3, "IgnoreCanCollide", false)

		if v18 then
			local maxParts = v3.get(p4, "InheritanceMaxResults", 5)

			v17 = OverlapParams.new()
			v17.MaxParts = maxParts
			v17.CollisionGroup = collisionGroup
			v17.RespectCanCollide = not v23
			v17.FilterType = Enum.RaycastFilterType[v22]
			v17.FilterDescendantsInstances = collectionService:GetTagged(v21)

			if v22 == "Exclude" then
				v17:AddToFilter({ workspace.Terrain })
			end
		end

		local v25 = v3.get(p4, "EmitDelay", 0)

		v18 = v3.getRange(p4, "Amount", NumberRange.new(5, 10), NumberRange.new(0, math.huge))

		local v26 = v3.getRange(p4, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, math.huge))
		local v27 = v3.getRange(p4, "Airtime", NumberRange.new(0.5, 0.5), NumberRange.new(0, math.huge))
		local v28 = v3.getRange(p4, "LinearMagnitude", NumberRange.new(15, 25))
		local v29 = v3.getRange(p4, "AngularMagnitude", NumberRange.new(5, 15))
		local v30 = v3.get(p4, "SizeScaleEnd", Vector3.new(0, 0, 0))
		local v31 = v3.get(p4, "MinSize", Vector3.new(2, 1, 2))
		local v32 = v3.get(p4, "MaxSize", Vector3.new(3, 2, 3))
		local v33 = v3.get(p4, "MinDirection", Vector3.new(-1, -1, -1))
		local v34 = v3.get(p4, "MaxDirection", Vector3.new(1, 1, 1))
		local v35 = random:NextInteger(v18.Min, v18.Max)
		local v36 = v3.get(p4, "Size_Curve", v5.default_bezier)
		local v37 = v3.get(p4, "Transparency_Curve", v5.default_bezier)
		local v38 = v3.get(p4, "Transparency_Duration", 0.5)
		local v39 = v3.get(p4, "Size_Duration", 0.5)
		local transparency = v3.get(p4, "Transparency_Start", 0)
		local v41 = v3.get(p4, "Transparency_End", 1)
		local t2: {[any]: any} = {}
		local t3: {[any]: any} = {}

		p4.CanCollide = false

		local v44 = v5.getTransformedOriginExtents(p3)
		local v45 = v44.Position

		if v17 then
			for iterFirst, iterSecond in workspace:GetPartBoundsInRadius(v45, v19, v17), nil, nil do
				if iterSecond.Transparency ~= 1 then
					table.insert(t2, iterSecond)
				end
			end
		end

		task.wait(v25)

		for _ = 1, v35 do
			local u49 = false

			if #t2 ~= 0 then
				local v50 = random:NextInteger(1, #t2)

				u49 = t2[v50]
			end

			local v51 = v5.getRandomId()
			local v52 = u9:get(v51)
			local parent = v52._getReal()

			v5.copyProperties(p4, parent, v5.COPY_PART_PROPERTIES)
			v5.copyProperties(p4, parent, v5.COPY_EXTENDED_PART_PROPERTIES)

			if #p4:GetChildren() ~= 0 then
				local clone = p4:Clone()

				for iterFirst2, iterSecond2 in clone:GetChildren() do
					iterSecond2.Parent = parent
				end

				clone:Destroy()
			end

			local v57 = p5.effects.prepareEmitOnFinish(parent, p5)
			local v58 = p5.effects.prepareEmitFolder(parent, "EmitOnImpact", p5)

			if v58 and #v58:GetChildren() > 0 then
				local connection = nil

				connection = parent.Touched:Connect(function(p6)
					if not v23 and not p6:CanCollideWith(parent) or p6:IsDescendantOf(workspace.Terrain) or v22 == "Exclude" and p6:HasTag(v21) then
						return
					end

					connection:Disconnect()

					local v77 = p5.effects.emitFromFolder(v58, parent, p5.depth + 1, p5)

					table.insert(t3, v77.Finished)
				end)
				table.insert(p5, function()
					if connection then
						connection:Disconnect()
						connection = nil
					end
				end)
			end

			v52.Anchored = false
			v52.CanCollide = true

			if v52.CollisionGroup == "Default" then
				v52.CollisionGroup = "ForgeDebris"
			end

			v52.CFrame = CFrame.new(v45)

			local v60 = random:NextNumber(v31.X, v32.X)
			local v61 = random:NextNumber(v31.Y, v32.Y)
			local vector3 = Vector3.new(v60, v61, random:NextNumber(v31.Z, v32.Z))

			v52.Size = vector3

			if u49 then
				v52.Material = u49.Material
				v52.Color = u49.Color
				v52.Transparency = u49.Transparency
			else
				v52.Transparency = transparency
			end

			table.insert(p5, function()
				local v78 = table.find(t1, parent)

				if v78 then
					table.remove(t1, v78)
				end

				if u9 then
					u9:free(v51)
				end
			end)
			table.insert(t1, parent)
			v52.AssemblyLinearVelocity = v44:VectorToWorldSpace(v52.AssemblyLinearVelocity)
			v60 = v5.randomUnitVector(v33, v34)

			local assemblyMass = v52.AssemblyMass
			local getImpulseForce = v5.getImpulseForce
			local unit = v44:VectorToWorldSpace(v60).Unit
			local v66 = random:NextNumber(v28.Min, v28.Max)
			local v67 = getImpulseForce(v45, v45 + unit * v66, random:NextNumber(v27.Min, v27.Max))

			v52:ApplyImpulse(assemblyMass * v67)

			local v68 = v52.AssemblyMass
			local v69 = random:NextUnitVector()

			v67 = random:NextNumber(v29.Min, v29.Max)
			v52:ApplyAngularImpulse(v68 * v69 * v67)
			v60 = p5.effects.emitNested(parent, p5.depth + 1, p5)
			table.insert(t3, v60.Finished)

			local taskDelay = task.delay
			local v71 = random:NextNumber(v26.Min, v26.Max)

			taskDelay(v71, function()
				local v79 = v52.Size
				local transparency = v52.Transparency

				if v79 ~= vector3 * v30 then
					table.insert(p5, v4.fromParams(v36, v39, function(p7, p8)
						v52.Size = v79:Lerp(vector3 * v30, p7)

						return p8
					end))
				end

				if transparency ~= v41 then
					table.insert(p5, v4.fromParams(v37, v38, function(p9, p10)
						v52.Transparency = v5.lerp(transparency, v41, p9)

						return p10
					end))
				end

				local v81 = p5.effects.emitOnFinish(v57, parent, p5.depth + 1, p5)

				table.insert(t3, v81.Finished)
			end)
		end

		local taskWait = task.wait
		local max = v26.Max
		local v74 = math.max(v38, v39)

		taskWait(max + v74)
		v6.all(t3):await()
	end
}
