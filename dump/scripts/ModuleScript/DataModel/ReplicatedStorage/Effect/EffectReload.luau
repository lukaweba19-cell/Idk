-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local hotReloader = require(script:WaitForChild("Rewire")).HotReloader
local u3 = nil

if runService:IsStudio() then
	u3 = hotReloader.new()
end

local t1: {[any]: any} = {}

local function setupHotReload(p1)
	if not u3 then
		t1[p1] = require(p1)
	elseif t1[p1] == nil then
		u3:listen(p1, function(p2, p3)
			t1[p1] = require(p2)

			if p3.isReloading then
				warn("Hot-reloaded effect module:", p1:GetFullName())

				return
			end
		end, function(_, _)
		end)

		return
	end
end

return {
	getEffectImpl = function(p6)
		if runService:IsStudio() then
			setupHotReload(p6)

			return t1[p6]
		end

		return (require(p6))
	end
}
