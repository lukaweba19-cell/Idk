-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require("../types")

local v1 = require("../mod/logger")
local v2 = require("../mod/utility")
local v3 = require("../emitters")
local v4 = require("../pkg/Promise")
local tableConcat = table.concat
local v6 = (".%*"):format(v2.BEZIER_TAG)
local v7 = (".%*"):format(v2.LIGHTNING_TAG)
local v8 = tableConcat({
	"Beam",
	"Trail",
	"Sound",
	"ParticleEmitter",
	v6,
	v7,
	"Model",
	"RayValue",
	"BasePart[$Enabled=true]",
	"#Rings > Part",
	"#Lines > Part",
	"#Debris > Part"
}, ",")
local u9 = nil

local function v10()
end

local v11 = v4.resolve()

local module: {[any]: any} = {
	init = function(p1)
		u9 = p1
	end,
	deinit = function()
		u9 = nil
	end
}

local t2: {[any]: any} = { Finished = v11, Clear = v10 }

local function emitWithContext(p2, p3, ...)
	if not u9 or not u9.setup then
		v1.error("effects service not initialized")

		return t2
	end

	local t3: {[any]: any} = {}
	local t4: {[any]: any} = {}
	local t5: {[any]: any} = {}

	local function queryAndEmitDescendants(p4, p5)
		local v55 = p4:QueryDescendants(v8)
		local n1 = #v55

		if n1 == 0 then
			return {}
		end

		local v57 = table.create(n1)
		n1 = { [p4] = false }
		local t8: {[any]: any} = { [p4] = p5 }

		for iterFirst, iterSecond in v55 do
			local t9: {[any]: any} = {}
			local v62 = iterSecond.Parent

			while t8[v62] == nil do
				table.insert(t9, v62)
				v62 = v62.Parent
			end

			local v63 = n1[v62]
			local v64 = t8[v62]

			for i = #t9, 1, -1 do
				local v66 = t9[i]

				v64 += 1
				t8[v66] = v64

				if not v63 then
					v63 = v2.shouldSkipNested(v66) or v66:HasTag(v2.EMIT_EXCLUDE_TAG)
				end

				n1[v66] = v63
			end

			if not v63 then
				table.insert(v57, v2.createEmitPromise(module, iterSecond, t8[iterSecond.Parent], function(p6)
					v3.dispatch(iterSecond, p6, t3, t4, u9.caches.shared_part, 1)
				end, p3))
			end
		end

		return v57
	end

	for iterFirst, value in { ... }, nil, nil do
		if not value:IsA("BasePart") or not value:GetAttribute("Enabled") or v2.findFirstClassWithTag(value, "Attachment", v2.SHOCKWAVE_TAG) then
			table.insert(t5, v2.createEmitPromise(module, value, p2, function(p7)
				v3.dispatch(value, p7, t3, t4, u9.caches.shared_part, 1)
			end, p3))

			if not v2.shouldSkipNested(value) then
				for iterFirst2, iterSecond in queryAndEmitDescendants(value, p2 + 1), nil, nil do
					table.insert(t5, iterSecond)
				end
			end
		elseif not v2.lock(value) and (not value:FindFirstAncestorOfClass("Model") or v2.isSpinModelStatic((value:FindFirstAncestorOfClass("Model")))) then
			local v26 = coroutine.running()
			local t6: {[any]: any} = { depth = p2, effects = module, _context = p3 }

			if v3.screen(value, t6) then
				local v28 = queryAndEmitDescendants(value, p2 + 1)

				if #v28 > 0 then
					local v29 = v4.all(v28)

					table.insert(t5, v29:finally(function()
						v2.unlock(value, v26)
						v2.cleanupScope(t6)
					end))
				else
					v2.unlock(value, v26)
					v2.cleanupScope(t6)
				end
			end
		end
	end

	local t7: {[any]: any} = { Finished = v4.all(t5) }

	t7.Clear = if p3 then function()
		for iterFirst, iterSecond in p3._promises, nil, nil do
			iterSecond:cancel()
		end

		t7.Finished:cancel()
	end else v10

	return t7
end
function module.emit(p8, ...)
	return emitWithContext(p8, {
		_promises = {}
	}, ...)
end
function module.prepareEmitFolder(p9, p10, p11)
	local foundChild = p9:FindFirstChild(p10)

	if foundChild and foundChild:IsA("Folder") then
		foundChild.Parent = nil
		table.insert(p11, foundChild)

		return foundChild
	end

	return nil
end
function module.prepareEmitOnFinish(p12, p13)
	return module.prepareEmitFolder(p12, "EmitOnFinish", p13)
end
function module.emitNested(p14, p15, p16)
	if not u9 or not u9.setup then
		return t2
	end

	local children = p14:GetChildren()

	if #children == 0 then
		return t2
	end

	return emitWithContext(p15, if p16 then p16._context else nil, table.unpack(children))
end
function module.emitFromFolder(p17, parent, p19, p20)
	if not p17 then
		return t2
	end

	local children = p17:GetChildren()

	if #children == 0 then
		return t2
	end

	for iterFirst, iterSecond in children do
		iterSecond.Parent = parent
	end

	return emitWithContext(p19, if p20 then p20._context else nil, table.unpack(children))
end
function module.emitOnFinish(p21, p22, p23, p24)
	return module.emitFromFolder(p21, p22, p23, p24)
end

return module
