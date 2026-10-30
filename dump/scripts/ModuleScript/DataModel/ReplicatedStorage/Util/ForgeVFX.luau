-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local collectionService: CollectionService = game:GetService("CollectionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local v4 = require("@self/mod/logger")
local v5 = require("@self/mod/utility")
local v6 = require("@self/mod/attributes")
local v7 = require("@self/effects/sound")
local v8 = require("@self/effects/bezier")
local v9 = require("@self/effects/lightning")
local v10 = require("@self/effects/camera_shake")
local v11 = require("@self/effects/shockwave_ring")
local v12 = require("@self/effects/shockwave_line")
local v13 = require("@self/effects/shockwave_debris")
local v14 = require("@self/services/caches")
local v15 = require("@self/services/effects")
local v16 = require("@self/services/texture_loader")
local v17 = require("@self/services/enabled_effects")
local plugin_context = v5.PLUGIN_CONTEXT
local server_context = v5.SERVER_CONTEXT
local module: {[any]: any} = {
	scope = {},
	setup = false
}

function module.init(_)
	if module.setup then
		return
	end

	if server_context then
		task.spawn(function()
			local n1: number = 0
			local v47

			while true do
				n1 += 1

				local ok, result = pcall(v5.setCollisionGroups, v5.COLLISION_GROUPS)

				v47 = ok

				if not v47 then
					task.wait(n1)
				end

				if not not v47 or n1 >= 5 then
					break
				end
			end

			if not v47 then
				local warn = v4.warn
				local v51 = ("couldn't register necessary collision groups after %* tries with the last error being: %*"):format(n1, result)

				warn(v51)
			end
		end)
	end

	module.setup = true

	if runService:IsServer() and not plugin_context then
		return
	end

	module.caches = v14.init(module.scope)
	shared.vfx = module
	v15.init(module)
	v16.init(module.scope)
	v17.init(module.scope, module.caches.shared_part, v15)
	v7.init()
	v10.init()
	v8.init(module.caches.shared_part)
	v9.init(module.caches.shared_part)
	v11.init(module.caches.shared_part)
	v12.init(module.caches.shared_part)
	v13.init(module.caches.shared_part)
end
function module.deinit()
	if not module.setup then
		return
	end

	module.setup = false
	shared.vfx = nil

	if runService:IsServer() and not plugin_context then
		return
	end

	v5.cleanupScope(module.scope)
	v15.deinit()
	v7.deinit()
	v8.deinit()
	v9.deinit()
	v10.deinit()
	v11.deinit()
	v12.deinit()
	v13.deinit()

	for iterFirst, iterSecond in collectionService:GetTagged(v5.CLEANUP_TAG), nil, nil do
		iterSecond:Destroy()
	end
end
local function fullEmit(_, p3, ...)
	if not module.setup then
		v4.error("not initialized")
	end

	return v15.emit(p3, ...)
end
function module.emit(p4, ...)
	if typeof(p4) == "number" then
		return fullEmit(p4, 0, ...)
	end

	return fullEmit(1, 0, p4, ...)
end
function module.emitWithDepth(p5, ...)
	return fullEmit(1, p5, ...)
end
function module.cacheAttributes(p6, p7)
	if v5.SERVER_CONTEXT then
		v4.error("attributes can only be cached in a client-side context")
	end

	if not p6:IsDescendantOf(replicatedStorage) then
		v4.error("attributes can only be cached for VFX inside ReplicatedStorage")
	end

	v6.cache(p6)

	if p7 then
		return
	end

	for iterFirst, iterSecond in p6:GetDescendants() do
		v6.cache(iterSecond)
	end
end
function module.restoreAttributes(p8, p9)
	if v5.SERVER_CONTEXT then
		v4.error("attributes can only be restored in a client-side context")
	end

	v6.restore(p8)

	if p9 then
		return
	end

	for iterFirst, iterSecond in p8:GetDescendants() do
		v6.restore(iterSecond)
	end
end
local function setEnabled(p10, enabled)
	if p10:IsA("ParticleEmitter") then
		p10.Enabled = enabled

		return
	end

	if p10:IsA("Beam") then
		p10.Enabled = enabled

		return
	end

	if v6.isCached(p10) then
		v6.trigger(p10, "Enabled", enabled)

		return
	end

	p10:SetAttribute("Enabled", enabled)
end
function module.enable(p12)
	setEnabled(p12, true)

	for iterFirst, iterSecond in p12:GetDescendants() do
		setEnabled(iterSecond, true)
	end
end
function module.disable(p13)
	setEnabled(p13, false)

	for iterFirst, iterSecond in p13:GetDescendants() do
		setEnabled(iterSecond, false)
	end
end

module.retime = require("@self/mod/retime").batch
module.resize = require("@self/mod/resize").batch
module.recolor = require("@self/mod/recolor")

return module
