-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")
game:GetService("ReplicatedStorage")

local v1: boolean = game:GetService("RunService"):IsServer()
local module: {[any]: any} = { DEFAULT_SLOW_PER_STACK = 0.3, DEFAULT_DURATION = 2 }

module.FROST_SLOW_PER_STACK = module.DEFAULT_SLOW_PER_STACK
module.FROST_DURATION_DEFAULT = module.DEFAULT_DURATION

function module.IsFrosted(p1)
	if not p1 then
		return false
	end

	local frosted = p1:GetAttribute("Frosted")

	if typeof(frosted) == "number" then
		local v5: number = workspace:GetServerTimeNow()

		return frosted > v5
	end

	return false
end
function module.GetFrostExpiry(p2)
	if not p2 then
		return nil
	end

	local frosted = p2:GetAttribute("Frosted")

	if typeof(frosted) == "number" then
		local v8: number = workspace:GetServerTimeNow()

		if frosted <= v8 then
			return nil
		end

		return frosted
	end

	return nil
end
function module.GetFrostStacks(p3)
	if not p3 then
		return 0
	end

	if not module.IsFrosted(p3) then
		return 0
	end

	local frostStacks = p3:GetAttribute("FrostStacks")

	if typeof(frostStacks) == "number" then
		local floored = math.floor(frostStacks)

		return (math.max(0, floored))
	end

	return 0
end
function module.GetSlowMultiplier(p4)
	if not p4 or not module.IsFrosted(p4) then
		return 1
	end

	local v13 = module.GetFrostStacks(p4)

	if v13 <= 0 then
		return 1
	end

	local frostSlowPctPerStack = p4:GetAttribute("FrostSlowPctPerStack")

	if typeof(frostSlowPctPerStack) ~= "number" then
		frostSlowPctPerStack = module.DEFAULT_SLOW_PER_STACK
	end

	return (math.max(0, 1 - frostSlowPctPerStack * v13))
end
function module.GetRemainingTime(p5)
	local v16 = module.GetFrostExpiry(p5)

	if not v16 then
		return 0
	end

	local v17: number = workspace:GetServerTimeNow()

	return (math.max(0, v16 - v17))
end
function module.ApplyFrost(character, p7, p8, p9, _)
	assert(v1, "SlowModule.ApplyFrost must be called on the server")

	if not character then
	elseif character:FindFirstChildOfClass("Humanoid") and not (character:FindFirstChildOfClass("Humanoid").Health <= 0) then
		local floored = math.floor(p7 or 1)
		local v24 = math.max(1, floored)
		local v25 = p9 or module.DEFAULT_DURATION
		local v26 = p8 or module.DEFAULT_SLOW_PER_STACK
		local v27: number = workspace:GetServerTimeNow()
		local n1 = v27 + v25
		local frosted = character:GetAttribute("Frosted")
		local frostStacks = character:GetAttribute("FrostStacks")
		local u31: boolean = false

		if typeof(frosted) == "number" then
			u31 = frosted > v27
		end

		local n2

		if u31 and typeof(frostStacks) == "number" then
			local floored2 = math.floor(frostStacks)

			n2 = math.max(1, floored2) + v24

			if typeof(frosted) == "number" and frosted > n1 then
				n1 = frosted
			end
		else
			n2 = v24
		end

		character:SetAttribute("FrostStacks", n2)
		character:SetAttribute("FrostSlowPctPerStack", v26)
		character:SetAttribute("Frosted", n1)

		local v34 = n1

		task.delay(n1 - v27 + 0.05, function()
			local frosted2 = character:GetAttribute("Frosted")

			if typeof(frosted2) == "number" and math.abs(frosted2 - v34) < 0.01 then
				module.ClearFrost(character)
			end
		end)

		return
	end
end
function module.ClearFrost(p11)
	assert(v1, "SlowModule.ClearFrost must be called on the server")

	if not p11 then
		return
	end

	p11:SetAttribute("Frosted", nil)
	p11:SetAttribute("FrostStacks", nil)
	p11:SetAttribute("FrostSlowPctPerStack", nil)
end

return module
