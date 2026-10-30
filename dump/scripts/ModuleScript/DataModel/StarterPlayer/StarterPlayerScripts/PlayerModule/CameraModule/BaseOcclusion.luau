-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module
setmetatable(module, {
	__call = function(_, ...)
		return module.new(...)
	end
})

function module.new()
	return (setmetatable({}, module))
end
function module.CharacterAdded(_, _, _)
end
function module.CharacterRemoving(_, _, _)
end
function module.OnCameraSubjectChanged(_, _)
end
function module.GetOcclusionMode(_)
	warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")

	return nil
end
function module.Enable(_, _)
	warn("BaseOcclusion Enable must be overridden by derived classes")
end
function module.Update(_, _, p15, p16)
	warn("BaseOcclusion Update must be overridden by derived classes")

	return p15, p16
end

return module
