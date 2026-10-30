-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

function module.new(p1, p2, p3, p4)
	local object = setmetatable({}, module)

	object.Target = 0
	object.Position = 0
	object.Velocity = 0
	object.Mass = p1 or 5
	object.Force = p2 or 50
	object.Damping = p3 or 4
	object.Speed = p4 or 1

	return object
end
function module.Update(p5, p6)
	p5.Velocity = p5.Velocity + (p5.Force * (p5.Target - p5.Position) - p5.Damping * p5.Velocity) / p5.Mass * p6 * p5.Speed
	p5.Position = p5.Position + p5.Velocity * p6 * p5.Speed

	return p5.Position
end

return module
