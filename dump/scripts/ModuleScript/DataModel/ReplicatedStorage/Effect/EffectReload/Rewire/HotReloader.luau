-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local runService: RunService = game:GetService("RunService")
local constants = require(script.Parent.Constants)
local module: {[any]: any} = {}

module.__index = module

function module.new()
	return (setmetatable({
		_listeners = {},
		_clonedModules = {}
	}, module))
end
function module.destroy(p1)
	for _, v in pairs(p1._listeners) do
		v:Disconnect()
	end

	p1._listeners = {}

	for _, v in pairs(p1._clonedModules) do
		v:Destroy()
	end

	p1._clonedModules = {}
end
function module.listen(p2, p3, p4, p5)
	if runService:IsStudio() then
		local connection = p3.Changed:Connect(function()
			local v23: boolean = game:IsAncestorOf(p3)
			local t2: {[any]: any} = { isReloading = v23, originalModule = p3 }

			if p2._clonedModules[p3] then
				p5(p2._clonedModules[p3], t2)
				p2._clonedModules[p3]:Destroy()
			else
				p5(p3, t2)
			end

			if not v23 then
				return
			end

			local clone = p3:Clone()

			collectionService:AddTag(clone, constants.CollectionServiceTag)
			clone.Parent = p3.Parent
			p2._clonedModules[p3] = clone
			p4(clone, { isReloading = true, originalModule = p3 })
			warn(("HotReloaded %s!"):format(p3:GetFullName()))
		end)

		table.insert(p2._listeners, connection)
	end

	p4(p3, { isReloading = false, originalModule = p3 })
end
function module.scan(p6, p7, p8, p9)
	local function add(p10)
		p6:listen(p10, p8, p9)
	end

	for iterFirst, iterSecond in p7:GetDescendants() do
		if iterSecond:IsA("ModuleScript") then
			p6:listen(iterSecond, p8, p9)
		end
	end

	local connection = p7.DescendantAdded:Connect(function(p11)
		if p11:IsA("ModuleScript") and not collectionService:HasTag(p11, constants.CollectionServiceTag) then
			p6:listen(p11, p8, p9)
		end
	end)

	table.insert(p6._listeners, connection)
end

return module
