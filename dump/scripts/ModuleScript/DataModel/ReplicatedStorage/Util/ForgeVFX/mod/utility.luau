-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local runService: RunService = game:GetService("RunService")
local physicsService: PhysicsService = game:GetService("PhysicsService")
local v3 = require("./attributes")
local v4 = require("./logger")
local v5 = require("../pkg/Promise")
local v6 = script:FindFirstAncestorOfClass("Plugin")

if not v6 then
	v6 = runService:IsStudio()

	if v6 then
		v6 = not runService:IsRunning()
	end
end

local module: {[any]: any} = { PLUGIN_CONTEXT = v6 }

module.SERVER_CONTEXT = runService:IsServer() or module.PLUGIN_CONTEXT
module.DEG_TO_RAD = 0.017453292519943295
module.BEZIER_TAG = "BezierParticle"
module.LIGHTNING_TAG = "LightningBolt"
module.SHOCKWAVE_TAG = "Shockwave"
module.SCREENSHAKE_TAG = "CameraShake"
module.PROPERTY_TWEENER_TAG = "PropertyTweener"
module.PROPERTY_RANDOMIZER_TAG = "PropertyRandomizer"
module.ATTRIBUTE_TWEENER_TAG = "AttributeTweener"
module.ATTRIBUTE_RANDOMIZER_TAG = "AttributeRandomizer"
module.ENABLED_VFX_TAG = "ConstantVFX"
module.TEXTURE_LOAD_TAG = "LoadVFXTextures"
module.CLEANUP_TAG = "__forge__cleanupOnExit"
module.EMIT_EXCLUDE_TAG = "__forge_excludeFromEmit"
module.RENDER_PRIORITY = Enum.RenderPriority.Camera.Value + 1
module.COLLISION_GROUPS = {
	StudioSelectable = {},
	ForgeDebris = { ForgeDebris = false },
	ForgeMouseIgnore = { StudioSelectable = false }
}
module.COPY_SPECIALMESH_PROPERTIES = { "MeshId", "MeshType", "Offset", "Scale", "TextureId", "VertexColor" }
module.COPY_PART_PROPERTIES = {
	"CastShadow",
	"Color",
	"Material",
	"MaterialVariant",
	"Reflectance",
	"Shape",
	"FrontSurface",
	"BackSurface",
	"LeftSurface",
	"RightSurface",
	"TopSurface",
	"BottomSurface"
}
module.COPY_EXTENDED_PART_PROPERTIES = {
	"Size",
	"Transparency",
	"CustomPhysicalProperties",
	"CanCollide",
	"CanQuery",
	"CanTouch",
	"CollisionGroup"
}

local object = setmetatable({}, { __mode = "k" })

function module.lock(p1)
	if object[p1] then
		return true
	end

	object[p1] = coroutine.running()

	return false
end
function module.unlock(p2, p3)
	local v26 = object[p2]

	if coroutine.running() ~= v26 and p3 ~= v26 then
		v4.error("attempt to unlock an instance owned by a different thread")
	end

	object[p2] = nil
end
function module.setCollisionGroups(p4)
	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in p4 do
		physicsService:RegisterCollisionGroup(iterFirst)

		if not iterFirst:match("Studio") or runService:IsStudio() then
			t2[iterFirst] = iterSecond
		end
	end

	for key, value in t2 do
		for iterFirst2, iterSecond2 in value do
			if not iterFirst2:match("Studio") or runService:IsStudio() then
				physicsService:CollisionGroupSetCollidable(key, iterFirst2, iterSecond2)
			end
		end
	end
end

local n1: number = 0

function module.getRandomId()
	n1 += 1

	return (tostring(n1))
end
function module.copyProperties(p5, p6, p7)
	for iterFirst, iterSecond in p7 do
		p6[iterSecond] = p5[iterSecond]
	end
end
function module.lerp(p8, p9, p10)
	return p8 + (p9 - p8) * p10
end
function module.try(p11, p12, ...)
	local t3: {[any]: any} = { xpcall(p12, function(p13)
		v4.warn(string.format(p11, p13))
	end, ...) }

	return t3[1], table.unpack(t3, 2)
end
function module.reboundfn(p14, p15)
	local u48 = nil

	return function(...)
		if u48 then
			task.cancel(u48)
		end

		local t14: {[any]: any} = { ... }

		u48 = task.delay(p14, function()
			u48 = nil
			p15(table.unpack(t14))
		end)
	end
end
function module.randomUnitVector(p16, p17, p18)
	local v52 = p18 or Random.new()
	local v53 = v52:NextNumber(p16.X, p17.X)
	local v54 = v52:NextNumber(p16.Y, p17.Y)
	local vector3 = Vector3.new(v53, v54, v52:NextNumber(p16.Z, p17.Z))

	return vector3
end
function module.getImpulseForce(p19, p20, p21)
	local vector3 = Vector3.new(0, workspace.Gravity * p21 * 0.5, 0)

	return (p20 - p19) / p21 + vector3
end
function module.isMeshVFX(p22)
	return p22 and p22:IsA("Model") and p22:FindFirstChild("Start") and p22.Start:IsA("BasePart") and p22:FindFirstChild("End") and p22.End:IsA("BasePart")
end
function module.isSpinModelStatic(p23)
	local u62: boolean = false

	if v3.get(p23, "SpinRotation", Vector3.new(0, 0, 0), true) == Vector3.new(0, 0, 0) then
		u62 = false

		if v3.get(p23, "Scale_Start", 1, true) == 1 then
			u62 = false

			if v3.get(p23, "Scale_End", 1, true) == 1 then
				u62 = v3.get(p23, "SyncPosition", false, true) == false
			end
		end
	end

	return u62
end
function module.shouldSkipNested(p24)
	local v64 = p24:IsA("Beam") or p24:HasTag(module.BEZIER_TAG) or p24:HasTag(module.LIGHTNING_TAG) or module.isMeshVFX(p24)

	if not v64 then
		v64 = p24:IsA("BasePart")

		if v64 then
			v64 = module.findFirstClassWithTag(p24, "Attachment", module.SHOCKWAVE_TAG) ~= nil
		end
	end

	return v64
end
function module.getTarget(p25)
	local objectValue = p25:FindFirstChildOfClass("ObjectValue")

	if objectValue and objectValue.Value then
		return objectValue.Value
	end

	local v67 = p25.Parent

	if not v67 then
		return nil
	end

	while true do
		if not v67:IsA("Folder") then
			break
		end

		v67 = v67.Parent

		if not v67 then
			return nil
		end
	end

	return v67
end
function module.createEmitPromise(p26, _, p28, p29, p30)
	local v73 = v5.new(function(p31, _, p33)
		local t15: {[any]: any} = { depth = p28, effects = p26, _context = p30 }

		p33(function()
			if t15._onCancel then
				for iterFirst, iterSecond in t15._onCancel, nil, nil do
					iterSecond()
				end
			end

			module.cleanupScope(t15)
		end)
		p29(t15)
		module.cleanupScope(t15)
		p31()
	end)

	if p30 then
		table.insert(p30._promises, v73)
	end

	return v73
end
function module.onCancel(p34, p35)
	if not p34._onCancel then
		p34._onCancel = {}
	end

	table.insert(p34._onCancel, p35)
end

local object2 = setmetatable({}, { __mode = "k" })
local object3 = setmetatable({}, { __mode = "k" })

function module.forceEmit(p36, p37)
	object3[p36] = if p37 then true else nil
end
function module.isForceEmitting(p38)
	return object3[p38] == true
end
function module.setEnabledCancelToken(p39, p40)
	object2[p39] = p40
end
function module.getEnabledCancelToken(p41)
	return object2[p41]
end
function module.cancelToken(p42)
	for iterFirst, iterSecond in p42._promises, nil, nil do
		iterSecond:cancel()
	end

	for iterFirst2, iterSecond2 in p42._scopes, nil, nil do
		module.cleanupScope(iterSecond2, true)
	end

	table.clear(p42._promises)
	table.clear(p42._scopes)
end
function module.stopEmitDuration(p43)
	local v88 = module.getEnabledCancelToken(p43)

	v3.trigger(p43, "Enabled", false)
	v3.clearState(p43)
	module.forceEmit(p43, false)

	return v88
end
function module.awaitEmitDuration(p44)
	if not p44 then
		return
	end

	local t4: {[any]: any} = {}

	for iterFirst, iterSecond in p44._promises, nil, nil do
		table.insert(t4, iterSecond)
	end

	if #t4 > 0 then
		v5.all(t4):await()
	end
end
function module.cleanupScope(p45, p46)
	local depth = p45.depth
	local effects = p45.effects
	local _context = p45._context
	local _onCancel = p45._onCancel

	for iterFirst, iterSecond in p45 do
		if iterFirst ~= "depth" and iterFirst ~= "effects" and iterFirst ~= "_context" and iterFirst ~= "_onCancel" then
			local typeName: string = typeof(iterSecond)

			if typeName == "Instance" then
				iterSecond:Destroy()
			elseif typeName == "RBXScriptConnection" then
				iterSecond:Disconnect()
			elseif typeName == "thread" then
				if coroutine.status(iterSecond) ~= "dead" then
					task.cancel(iterSecond)
				end
			elseif typeName ~= "function" then
				if typeName == "table" then
					module.cleanupScope(iterSecond)
				end
			elseif p46 then
				iterSecond()
			else
				task.spawn(iterSecond)
			end
		end
	end

	table.clear(p45)
	p45.depth = depth
	p45.effects = effects
	p45._context = _context
	p45._onCancel = _onCancel
end
function module.protectParent(p47, p48)
	table.insert(p47, p48.AncestryChanged:Connect(function(_, _)
		if p48.Parent == workspace.Terrain then
			return
		end

		p48.Parent = workspace.Terrain
	end))
end
function module.findFirstClassWithTag(p51, p52, p53)
	if p51 and p51.Parent ~= game then
		if p52 == p51.ClassName and p51:HasTag(p53) then
			return p51
		end

		return module.findFirstClassWithTag(p51.Parent, p52, p53)
	end
end
function module.cloneParticleAncestry(p54, p55)
	if not p54:FindFirstAncestorWhichIsA("BasePart") and not p54:FindFirstAncestorOfClass("Attachment") then
		return
	end

	local function findAncestor(p56)
		if not p56 then
			return
		end

		local v226 = p56

		if p56.Parent and (not not p56.Parent:IsA("BasePart") or not not p56.Parent:IsA("Attachment")) then
			v226 = findAncestor(p56.Parent)
		end

		return v226
	end
	local function recurse(p57)
		if not p57 then
			return
		end

		local v228 = p55[p57]

		if v228 then
			local v229 = v228

			if p57 == p54 then
				return v229, p55[p57.Parent]
			end

			local v230 = p57.Parent
			local v231

			if not v230 then
				v231 = nil
			else
				local v232 = v230

				if v230.Parent and (not not v230.Parent:IsA("BasePart") or not not v230.Parent:IsA("Attachment")) then
					v232 = findAncestor(v230.Parent)
				end

				v231 = v232
			end

			return v229, p55[v231] or p55[p57]
		end

		v228 = Instance.fromExisting(p57)
		v228.Archivable = false

		if v228:IsA("BasePart") then
			v228.Locked = true
		end

		local v233 = v228

		if p55 then
			p55[p57] = v228
		end

		if p57.Parent and (not not p57.Parent:IsA("BasePart") or not not p57.Parent:IsA("Attachment")) then
			local parent, v235 = recurse(p57.Parent)

			if v235 then
				v233 = v235
			end

			if parent then
				v228.Parent = parent
			end
		end

		return v228, v233
	end

	return recurse(p54.Parent)
end
function module.getTransformedOriginExtents(p58)
	local v112 = CFrame.identity

	if p58:IsA("BasePart") then
		return p58.CFrame, p58.Size
	end

	if p58:IsA("Attachment") then
		v112 = p58.WorldCFrame

		local v113 = p58.Parent
		local v114 = v3.get(p58, "PositionScale", Vector3.new(0, 0, 0), true)

		if v113 and v113:IsA("BasePart") and v114 ~= Vector3.new(0, 0, 0) then
			v112 += v113.Size / 2 * v114
		end

		v114 = v3.get(p58, "OverrideWorldRotation", false, true)

		local v115 = v3.get(p58, "WorldRotation", Vector3.new(0, 0, 0), true)

		if v114 then
			local n1 = v115 * module.DEG_TO_RAD
			local cFrame = CFrame.new(v112.Position)
			local v118 = CFrame.fromOrientation(n1.X, n1.Y, n1.Z)

			v112 = cFrame * v118
		end
	end

	return v112, Vector3.new(0, 0, 0)
end
function module.getMeshDecals(p59, p60)
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}
	local t7: {[any]: any} = {}

	local function filter(p61)
		local t16: {[any]: any} = {}

		for iterFirst, iterSecond in p61 do
			if iterSecond:IsA("Decal") then
				table.insert(t16, iterSecond)
			end
		end

		return t16
	end

	if v3.get(p59, "Flipbook", false, true) then
		return filter(p60:GetChildren()), t6, t7
	end

	local v125 = p59:FindFirstChild("End")
	local start = p59:FindFirstChild("Start")

	if v125 then
		for iterFirst, iterSecond in p60:GetChildren() do
			if iterSecond:IsA("Decal") then
				local foundChild = v125:FindFirstChild(iterSecond.Name)

				if foundChild and foundChild:IsA("Decal") then
					table.insert(t5, iterSecond)
					t7[iterSecond] = foundChild

					if not v3.get(iterSecond, "FlipbookEnabled", nil) then
						table.insert(t5, iterSecond)
					else
						local v130 = v3.get(iterSecond, "FlipbookTextures", nil)

						if v130 then
							t6[iterSecond] = module.deserializeFlipbook(v130)
						end
					end
				end
			end
		end

		for iterFirst2, iterSecond2 in start:GetChildren() do
			if iterSecond2:IsA("Decal") then
				local children = iterSecond2:GetChildren()
				local n1: number = 0

				for i = 1, #children do
					local n2: number = i - n1

					if not children[n2]:IsA("Decal") then
						table.remove(children, n2)
						n1 += 1
					end
				end

				if #children ~= 0 then
					local function idx(p62)
						return tonumber(p62:match("%d+")) or 0
					end

					table.sort(children, function(p63, p64)
						local numberValue: number? = tonumber(p63.Name:match("%d+"))
						local numberValue2: number? = tonumber(p64.Name:match("%d+"))

						return (numberValue or 0) < (numberValue2 or 0)
					end)

					local t8: {[any]: any} = {}

					for iterFirst3, iterSecond3 in children do
						local numberValue: number? = tonumber(iterSecond3.Texture:match("%d+"))

						table.insert(t8, numberValue or 0)
						iterSecond3:Destroy()
					end

					local v142 = module.serializeFlipbook(t8)

					v3.set(iterSecond2, "FlipbookEnabled", true)
					v3.set(iterSecond2, "FlipbookTextures", buffer.tostring(v142))
				end
			end
		end
	end

	return t5, t6, t7
end
function module.assembleMeshVFX(p65, p66, p67)
	local v146 = module.getRandomId()

	if p65:IsA("Part") then
		local v147 = p67:get(v146)

		v147.CFrame = p65.CFrame

		local parent = v147._getReal()

		module.copyProperties(p65, parent, module.COPY_PART_PROPERTIES)
		module.copyProperties(p65, parent, module.COPY_EXTENDED_PART_PROPERTIES)

		local clone = p65:Clone()

		for iterFirst, iterSecond in clone:GetChildren() do
			iterSecond.Parent = parent
		end

		clone:Destroy()
		table.insert(p66, function()
			p67:free(v146)
		end)

		return v147
	end

	local clone = p65:Clone()

	clone.Archivable = false
	clone.Locked = true
	clone.Parent = workspace.Terrain
	clone:AddTag(module.CLEANUP_TAG)
	table.insert(p66, clone)

	return clone
end
function module.getBezierPoints(p68, p69)
	local children = p68:GetChildren()

	table.sort(children, function(p70, p71)
		local numberValue: number? = tonumber(p70.Name)
		local numberValue3: number? = tonumber(p71.Name)

		return numberValue < numberValue3
	end)

	local t9: {[any]: any} = {}
	local t10: {[any]: any} = {}
	local t11: {[any]: any} = {}

	local function vec(p72)
		local v250 = p68.WorldCFrame:PointToObjectSpace(p72.WorldPosition)
		local vectorValue = vector.create(v250.X, v250.Y, v250.Z)

		table.insert(t9, vectorValue)

		if p69 then
			t11[p72] = vectorValue
			table.insert(t10, p72)
		end

		return vectorValue
	end

	for iterFirst, iterSecond in children do
		local t0 = iterSecond:FindFirstChild("T0")
		local t1 = iterSecond:FindFirstChild("T1")

		if iterFirst == 1 then
			local v164 = p68.WorldCFrame:PointToObjectSpace(iterSecond.WorldPosition)
			local vectorValue = vector.create(v164.X, v164.Y, v164.Z)

			table.insert(t9, vectorValue)

			if p69 then
				t11[iterSecond] = vectorValue
				table.insert(t10, iterSecond)
			end
		end

		if iterFirst ~= 1 then
			if t1 then
				local v166 = p68.WorldCFrame:PointToObjectSpace(t1.WorldPosition)
				local vectorValue = vector.create(v166.X, v166.Y, v166.Z)

				table.insert(t9, vectorValue)

				if p69 then
					t11[t1] = vectorValue
					table.insert(t10, t1)
				end
			else
				local v168 = p68.WorldCFrame:PointToObjectSpace(iterSecond.WorldPosition)
				local vectorValue = vector.create(v168.X, v168.Y, v168.Z)

				table.insert(t9, vectorValue)

				if p69 then
					t11[iterSecond] = vectorValue
					table.insert(t10, iterSecond)
				end
			end
		end

		if iterFirst ~= 1 and iterFirst ~= #children then
			local v170 = p68.WorldCFrame:PointToObjectSpace(iterSecond.WorldPosition)
			local vectorValue = vector.create(v170.X, v170.Y, v170.Z)

			table.insert(t9, vectorValue)

			if p69 then
				t11[iterSecond] = vectorValue
				table.insert(t10, iterSecond)
			end
		end

		if iterFirst ~= #children then
			if t0 then
				local v172 = p68.WorldCFrame:PointToObjectSpace(t0.WorldPosition)
				local vectorValue = vector.create(v172.X, v172.Y, v172.Z)

				table.insert(t9, vectorValue)

				if p69 then
					t11[t0] = vectorValue
					table.insert(t10, t0)
				end
			else
				local v174 = p68.WorldCFrame:PointToObjectSpace(iterSecond.WorldPosition)
				local vectorValue = vector.create(v174.X, v174.Y, v174.Z)

				table.insert(t9, vectorValue)

				if p69 then
					t11[iterSecond] = vectorValue
					table.insert(t10, iterSecond)
				end
			end
		end

		if iterFirst == #children then
			local v176 = p68.WorldCFrame:PointToObjectSpace(iterSecond.WorldPosition)
			local vectorValue = vector.create(v176.X, v176.Y, v176.Z)

			table.insert(t9, vectorValue)

			if p69 then
				t11[iterSecond] = vectorValue
				table.insert(t10, iterSecond)
			end
		end
	end

	return t9, t10, t11
end
function module.scaleNumberSequence(p73, p74)
	if p74 == 1 then
		return p73
	end

	local t12: {[any]: any} = {}

	for iterFirst, iterSecond in p73.Keypoints, nil, nil do
		local v183
		local v184

		if typeof(p74) == "function" then
			local v185, v186 = p74(iterSecond.Value, iterSecond.Envelope)

			v183 = v185
			v184 = v186
		else
			v183 = iterSecond.Value * p74
			v184 = iterSecond.Envelope * p74
		end

		table.insert(t12, NumberSequenceKeypoint.new(iterSecond.Time, v183, v184))
	end

	return NumberSequence.new(t12)
end
function module.serializePath(p75)
	local v188 = buffer.create(#p75 * 4 * 6)
	local n1: number = 0

	for iterFirst, iterSecond in p75 do
		local scale = iterSecond.Position.X.Scale
		local v193 = iterSecond.Position.Y.Scale

		if iterFirst ~= 1 then
			buffer.writef32(v188, n1, scale + iterSecond.LeftTangent.X.Scale)
			buffer.writef32(v188, n1 + 4, v193 + iterSecond.LeftTangent.Y.Scale)
			n1 += 8
		end

		buffer.writef32(v188, n1, scale)
		buffer.writef32(v188, n1 + 4, v193)
		n1 += 8

		if iterFirst ~= #p75 then
			buffer.writef32(v188, n1, scale + iterSecond.RightTangent.X.Scale)
			buffer.writef32(v188, n1 + 4, v193 + iterSecond.RightTangent.Y.Scale)
			n1 += 8
		end
	end

	return v188
end
function module.deserializePath(p76)
	local v195 = typeof(p76) == "string" and buffer.fromstring(p76) or p76
	local n1 = buffer.len(v195) / 24
	local t13: {[any]: any} = {}

	for i = 0, n1 - 1 do
		local n2: number = i * 4 * 6
		local v200 = buffer.readf32(v195, n2)
		local v201 = buffer.readf32(v195, n2 + 4)
		local vectorValue = vector.create(v200, v201)

		table.insert(t13, vectorValue)

		if i ~= n1 - 1 then
			local v203 = buffer.readf32(v195, n2 + 8)
			local v204 = buffer.readf32(v195, n2 + 12)
			local v205 = buffer.readf32(v195, n2 + 16)
			local v206 = buffer.readf32(v195, n2 + 20)
			local vectorValue2 = vector.create(v203, v204)

			table.insert(t13, vectorValue2)

			local vectorValue3 = vector.create(v205, v206)

			table.insert(t13, vectorValue3)
		end
	end

	return t13
end

local v12 = require("./common/flipbook")

module.serializeFlipbook = v12.serialize
module.deserializeFlipbook = v12.deserialize

local bufferTostring = buffer.tostring
local serializePath = module.serializePath
local path2DControlPointNew = Path2DControlPoint.new
local v16 = UDim2.fromScale(0, 1)
local v17 = path2DControlPointNew(v16, UDim2.new(), UDim2.fromScale(0.215, -0.61))
local v18 = Path2DControlPoint.new
local v19 = UDim2.fromScale(1, 0)
local v20 = UDim2.fromScale(-0.645, 0)

module.default_bezier = bufferTostring(serializePath({ v17, v18(v19, v20, UDim2.new()) }))

local v21 = buffer.tostring
local v22 = module.serializePath

v17 = Path2DControlPoint.new(UDim2.fromScale(0, 1))
module.linear_bezier = v21(v22({ v17, Path2DControlPoint.new(UDim2.fromScale(1, 0)) }))

function module.scaleAttribute(p77, p78, p79)
	local v212 = v3.get(p77, p79, nil)

	if v212 == nil then
		return
	end

	if typeof(v212) == "number" then
		v3.set(p77, p79, v212 * p78)

		return
	end

	if typeof(v212) == "Vector3" then
		v3.set(p77, p79, v212 * p78)

		return
	end

	if typeof(v212) == "NumberRange" then
		v3.set(p77, p79, NumberRange.new(v212.Min * p78, v212.Max * p78))
	end
end
function module.scaleAttachmentDistance(p80, p81, p82)
	if p80 and p81 then
		local n1 = (p80.Position + p81.Position) / 2

		p80.Position = n1 + (p80.Position - n1) * p82
		p81.Position = n1 + (p81.Position - n1) * p82

		return
	end
end

return module
