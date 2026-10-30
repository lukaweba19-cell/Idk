-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local collectionService: CollectionService = game:GetService("CollectionService")
local v3 = require("../mod/attributes")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../emitters")

return {
	init = function(p1, p2, p3)
		local t1: {[any]: any} = {}
		local t2: {[any]: any} = {}

		local function removeEnabledEffect(p4)
			local v16 = t1[p4]

			if v16 then
				v4.cleanupScope(v16)
			end

			t1[p4] = nil
		end
		local function addEnabledEffect(p6)
			local u18 = nil

			for iterFirst, iterSecond in v5.enabled_registry, nil, nil do
				if iterSecond.check(p6) then
					u18 = iterSecond

					break
				end
			end

			if not u18 then
				return
			end

			local t3: {[any]: any} = {}
			local t4: {[any]: any} = {}

			table.insert(t4, t3)
			t1[p6] = t4

			if not t2[p6] then
				t2[p6] = p6.AncestryChanged:Connect(function()
					if not p6:IsDescendantOf(workspace) and (not p6.Parent or not p6.Parent:HasTag("AllowEmitting")) then
						local v30 = p6
						local v31 = t1[v30]

						if v31 then
							v4.cleanupScope(v31)
						end

						t1[v30] = nil
					elseif not t1[p6] then
						addEnabledEffect(p6)

						return
					end
				end)
			end

			local function onEnabled(p7)
				if p7 == nil then
					p7 = v3.get(p6, "Enabled", true)
				end

				local v33 = v4.isForceEmitting(p6) or p6:IsDescendantOf(workspace) or p6.Parent and p6.Parent:HasTag("AllowEmitting")

				if p7 and not v33 then
					return
				end

				local n1

				if p7 then
					v4.cleanupScope(t3)
					n1 = 0

					local t5: {[any]: any} = {
						_promises = {},
						_scopes = {}
					}

					v4.setEnabledCancelToken(p6, t5)
					table.insert(t3, runService.RenderStepped:Connect(function()
						local v37 = v3.get(p6, "Rate", 5)
						local v38 = v3.getState(p6, "SpeedOverride", 1)

						if v38 == 0 then
							return
						end

						if os.clock() - n1 <= 1 / v37 / v38 then
							return
						end

						n1 = os.clock()
						v38 = { depth = 0, effects = p3, _context = t5 }
						table.insert(t5._scopes, v38)
						u18.emit(p6, v38, p2)
						v37 = table.find(t5._scopes, v38)

						if v37 then
							table.remove(t5._scopes, v37)
						end

						v4.cleanupScope(v38)
					end))

					return
				end

				n1 = v4
				n1 = n1.cleanupScope
				n1(t3)
			end

			table.insert(t4, v3.hook(p6, "Enabled", onEnabled))
			onEnabled()
		end

		for iterFirst, iterSecond in collectionService:GetTagged(v4.ENABLED_VFX_TAG) do
			addEnabledEffect(iterSecond)
		end

		collectionService:GetInstanceAddedSignal(v4.ENABLED_VFX_TAG):Connect(addEnabledEffect)
		collectionService:GetInstanceRemovedSignal(v4.ENABLED_VFX_TAG):Connect(function(p5)
			local v25 = t1[p5]

			if v25 then
				v4.cleanupScope(v25)
			end

			t1[p5] = nil
			v25 = t2[p5]

			if v25 then
				v25:Disconnect()
				t2[p5] = nil
			end
		end)
		table.insert(p1, function()
			for key, value in t1 do
				v4.cleanupScope(value)
			end

			for key2, value2 in t2 do
				value2:Disconnect()
			end

			table.clear(t2)
		end)
	end
}
