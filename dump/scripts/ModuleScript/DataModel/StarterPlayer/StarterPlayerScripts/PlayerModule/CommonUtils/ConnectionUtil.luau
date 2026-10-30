-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local object = setmetatable({}, module)

	object._connections = {}

	return object
end
function module.trackConnection(p1, p2, p3)
	if p1._connections[p2] then
		p1._connections[p2]()
	end

	p1._connections[p2] = function()
		p3:Disconnect()
	end
end
function module.trackBoundFunction(p4, p5, p6)
	if p4._connections[p5] then
		p4._connections[p5]()
	end

	p4._connections[p5] = p6
end
function module.disconnect(p7, p8)
	if p7._connections[p8] then
		p7._connections[p8]()
		p7._connections[p8] = nil
	end
end
function module.disconnectAll(p9)
	for _, v in pairs(p9._connections) do
		v()
	end

	p9._connections = {}
end

return module
