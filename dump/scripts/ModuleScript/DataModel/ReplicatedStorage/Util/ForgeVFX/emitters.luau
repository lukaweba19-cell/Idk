-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("./effects/beam")
local v2 = require("./effects/spin")
local v3 = require("./effects/mesh")
local v4 = require("./effects/sound")
local v5 = require("./effects/bezier")
local v6 = require("./effects/screen")
local v7 = require("./effects/particle")
local v8 = require("./effects/lightning")
local v9 = require("./effects/camera_shake")
local v10 = require("./effects/tweener")
local v11 = require("./effects/randomizer")
local v12 = require("./effects/shockwave_ring")
local v13 = require("./effects/shockwave_line")
local v14 = require("./effects/shockwave_debris")
local v15 = require("./mod/attributes")

require("./types")

local v16 = require("./mod/utility")
local v17 = require("./pkg/Promise")

local function processRandomizers(p1, p2)
	local v22 = ("> RayValue.%*"):format(v16.PROPERTY_RANDOMIZER_TAG)
	local v23 = p1:QueryDescendants(v22)
	local v24 = ("> RayValue.%*"):format(v16.ATTRIBUTE_RANDOMIZER_TAG)
	local v25 = p1:QueryDescendants(v24)

	if p1:IsA("RayValue") then
		if p1:HasTag(v16.PROPERTY_RANDOMIZER_TAG) then
			table.insert(v23, p1)
		elseif p1:HasTag(v16.ATTRIBUTE_RANDOMIZER_TAG) then
			table.insert(v25, p1)
		end
	end

	for iterFirst, iterSecond in v23 do
		v16.try("failed to emit property randomizer with error: %s", v11.emit, iterSecond, p2, false)
	end

	for iterFirst2, iterSecond2 in v25 do
		v16.try("failed to emit attribute randomizer with error: %s", v11.emit, iterSecond2, p2, true)
	end
end

local module: {[any]: any} = {
	particle = function(p3, p4, p5, p6, p7)
		local v35 = v15.get(p3, "EmitCount", if v16.PLUGIN_CONTEXT then 1 else nil)
		local v36 = v15.get(p3, "EmitDuration", 0, true)

		if v35 and (not (v35 <= 0) or not (v36 <= 0)) then
			if not p3:IsDescendantOf(workspace) then
				local parent, v38 = v16.cloneParticleAncestry(p3, p6)

				if not parent then
					return
				end

				local clone = p3:Clone()

				clone.Archivable = false
				clone.Parent = parent

				if not p5[v38] then
					v38.Parent = workspace.Terrain
					p5[v38] = 1
				else
					p5[v38] = p5[v38] + 1
				end

				table.insert(p4, function()
					local v114 = p5
					local v115 = v38

					v114[v115] = v114[v115] - 1

					if p5[v38] <= 0 then
						v38:Destroy()
					end
				end)
				v16.try("failed to emit particle with error: %s", v7.emit, p3, clone, p4, p7)

				return
			end

			v16.try("failed to emit particle with error: %s", v7.emit, p3, p3, p4, p7)

			return
		end
	end,
	beam = function(p8, p9, p10)
		local attachment0 = p8.Attachment0
		local attachment1 = p8.Attachment1

		if attachment0 and attachment1 then
			local clone = p8:Clone()

			clone.Archivable = false
			clone.Parent = workspace.Terrain

			if v15.get(p8, "Length_Scale_Start", NumberRange.new(1, 1), true) ~= NumberRange.new(1, 1) or NumberRange.new(1, 1) ~= v15.get(p8, "Length_Scale_End", NumberRange.new(1, 1), true) then
				local clone2 = attachment0:Clone()
				local clone3 = attachment1:Clone()

				table.insert(p9, clone2)
				table.insert(p9, clone3)
				clone2.Name = "_ForgeTempAttachment"
				clone3.Name = "_ForgeTempAttachment"
				clone2:AddTag(v16.EMIT_EXCLUDE_TAG)
				clone3:AddTag(v16.EMIT_EXCLUDE_TAG)
				clone.Attachment0 = clone2
				clone.Attachment1 = clone3
				clone2.Parent = attachment0.Parent
				clone3.Parent = attachment1.Parent
			end

			table.insert(p9, clone)
			v16.try("failed to emit beam with error: %s", v1.emit, p8, clone, p9, p10)

			return
		end
	end,
	trail = function(p11)
		p11.Enabled = true
	end,
	bezier = function(p12, p13, p14)
		local part = p12:FindFirstChildOfClass("Part")

		if not part then
			return
		end

		if not p14 and p12:GetAttribute("Enabled") then
			p12:SetAttribute("Enabled", false)
		end

		local clone = part:Clone()

		clone.Locked = true
		table.insert(p13, clone)
		v16.try("failed to emit bezier with error: %s", v5.emit, p12, clone, p13, p14)
	end,
	lightning = function(p15, p16, p17)
		local part = p15:FindFirstChildOfClass("Part")

		if not part then
			return
		end

		if not p17 and p15:GetAttribute("Enabled") then
			p15:SetAttribute("Enabled", false)
		end

		local clone = part:Clone()

		clone.Locked = true
		table.insert(p16, clone)
		v16.try("failed to emit lightning with error: %s", v8.emit, p15, clone, p16, p17)
	end,
	mesh = function(p18, p19, p20, p21, p22)
		local start = p18:FindFirstChild("Start")

		if not start then
			return
		end

		if not p22 and p18:GetAttribute("Enabled") then
			p18:SetAttribute("Enabled", false)
		end

		local t2: {[any]: any} = {}
		local _context = p19._context
		local v67 = p18:HasTag(v16.ENABLED_VFX_TAG)

		if v67 then
			v67 = v15.get(p18, "EmitDuration", 0) > 0
		end

		for _ = 1, if v67 and not p22 then 1 else v15.get(p18, "EmitCount", 1) do
			local v69 = v17.new(function(p23)
				local try = v16.try
				local emit = v3.emit
				local v119 = v16.assembleMeshVFX(start, p19, p20)

				try("failed to emit mesh with error: %s", emit, p18, v119, p19, p21, p22)
				p23()
			end)

			table.insert(t2, v69)

			if _context then
				table.insert(_context._promises, v69)
			end
		end

		v17.all(t2):await()
	end,
	spin = function(p24, p25)
		if v16.lock(p24) then
			return
		end

		v16.try("failed to emit spinning model with error: %s", v2.emit, p24, p25)
		v16.unlock(p24)
	end,
	camera_shake = function(p26, p27)
		v16.try("failed to emit camera shake with error: %s", v9.emit, p26, p27)
	end,
	property_tweener = function(p28, p29)
		if p28.Parent and not v16.lock(p28) then
			v16.try("failed to emit property tweener with error: %s", v10.emit, p28, p29, false)
			v16.unlock(p28)

			return
		end
	end,
	attribute_tweener = function(p30, p31)
		if p30.Parent and not v16.lock(p30) then
			v16.try("failed to emit attribute tweener with error: %s", v10.emit, p30.Parent, p30, p31, true)
			v16.unlock(p30)

			return
		end
	end,
	screen = function(p32, p33)
		local v80, v81 = v16.try("failed to emit screen effect with error: %s", v6.emit, p32, p33)

		if v80 then
			return v81
		end

		return false
	end,
	shockwave_ring = function(p34, p35, p36)
		v16.try("failed to emit shockwave ring with error: %s", v12.emit, p34, p35, p36)
	end,
	shockwave_debris = function(p37, p38, p39)
		v16.try("failed to emit shockwave debris with error: %s", v14.emit, p37, p38, p39)
	end,
	shockwave_line = function(p40, p41, p42)
		v16.try("failed to emit shockwave line with error: %s", v13.emit, p40, p41, p42)
	end,
	sound = function(p43, p44)
		if v15.get(p43, "EmitCount", 1, true) <= 0 then
			return
		end

		v16.try("failed to emit sound with error: %s", v4.emit, p43, p44)
	end
}

function module.dispatch(p45, p46, p47, p48, p49, p50)
	local className = p45.ClassName

	processRandomizers(p45, p46)

	if className == "ParticleEmitter" then
		module.particle(p45, p46, p47, p48, p50)

		return
	end

	if className == "Beam" then
		module.beam(p45, p46, p50)

		return
	end

	if className == "Trail" then
		module.trail(p45)

		return
	end

	if className == "Sound" then
		module.sound(p45, p46)

		return
	end

	if className == "RayValue" then
		if p45:HasTag(v16.SCREENSHAKE_TAG) then
			module.camera_shake(p45, p46)
		elseif p45:HasTag(v16.ATTRIBUTE_TWEENER_TAG) then
			module.attribute_tweener(p45, p46)
		elseif not p45:HasTag(v16.PROPERTY_RANDOMIZER_TAG) then
			if p45:HasTag(v16.ATTRIBUTE_RANDOMIZER_TAG) then
				return
			end

			module.property_tweener(p45, p46)

			return
		end

		return
	end

	if p45:HasTag(v16.BEZIER_TAG) then
		module.bezier(p45, p46)

		return
	end

	if p45:HasTag(v16.LIGHTNING_TAG) then
		module.lightning(p45, p46)

		return
	end

	if className == "Model" then
		if v16.isMeshVFX(p45) then
			module.mesh(p45, p46, p49, p50)

			return
		end

		module.spin(p45, p46)

		return
	end

	local v100 = className == "Part" and v16.findFirstClassWithTag(p45, "Attachment", v16.SHOCKWAVE_TAG)

	if v100 then
		local v101 = p45.Parent and p45.Parent.Name or ""

		if v101 == "Rings" then
			module.shockwave_ring(v100, p45, p46)
		elseif v101 == "Debris" then
			module.shockwave_debris(v100, p45, p46)
		elseif v101 == "Lines" then
			module.shockwave_line(v100, p45, p46)
		end

		return
	end
end

module.enabled_registry = {
	mesh = {
		check = function(p51)
			return v16.isMeshVFX(p51)
		end,
		emit = function(p52, p53, p54)
			module.mesh(p52, p53, p54, 1, true)
		end
	},
	bezier = {
		check = function(p55)
			return p55:HasTag(v16.BEZIER_TAG)
		end,
		emit = function(p56, p57, _)
			module.bezier(p56, p57, true)
		end
	},
	lightning = {
		check = function(p59)
			return p59:HasTag(v16.LIGHTNING_TAG)
		end,
		emit = function(p60, p61, _)
			module.lightning(p60, p61, true)
		end
	}
}

return module
