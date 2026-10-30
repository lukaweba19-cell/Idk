-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

function module.new()
	return (setmetatable({
		_callbacks = {}
	}, module))
end
function module.Connect(p1, p2)
	table.insert(p1._callbacks, p2)

	return {
		Disconnect = function()
			local v7 = table.find(p1._callbacks, p2)

			if v7 then
				table.remove(p1._callbacks, v7)
			end
		end
	}
end
function module.Fire(p3, ...)
	for iterFirst, iterSecond in p3._callbacks, nil, nil do
		iterSecond(...)
	end
end

return module
