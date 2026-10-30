-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)

local function validateVector(p1, p2)
	if p1 == nil then
		return false, ("Invalid or missing number at position %d in Vector type."):format(p2)
	end

	return true
end

local v3 = util.MakeSequenceType({
	Length = 3,
	ValidateEach = validateVector,
	TransformEach = tonumber,
	Constructor = Vector3.new
})
local v4 = util.MakeSequenceType({
	Length = 2,
	ValidateEach = validateVector,
	TransformEach = tonumber,
	Constructor = Vector2.new
})

return function(p3)
	p3:RegisterType("vector3", v3)
	p3:RegisterType("vector3s", util.MakeListableType(v3))
	p3:RegisterType("vector2", v4)
	p3:RegisterType("vector2s", util.MakeListableType(v4))
end
