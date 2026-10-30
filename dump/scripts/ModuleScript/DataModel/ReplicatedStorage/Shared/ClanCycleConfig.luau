-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = { CycleId = 1, DisplayName = "Cycle 1" }

function module.GetCycleKey()
	return "C" .. tostring(module.CycleId)
end

return module
