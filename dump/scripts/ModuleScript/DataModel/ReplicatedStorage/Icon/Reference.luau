-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local module: {[any]: any} = { objectName = "TopbarPlusReference" }

function module.addToReplicatedStorage()
	if replicatedStorage:FindFirstChild(module.objectName) then
		return false
	end

	local objectValue: ObjectValue = Instance.new("ObjectValue")

	objectValue.Name = module.objectName
	objectValue.Value = script.Parent
	objectValue.Parent = replicatedStorage

	return objectValue
end
function module.getObject()
	local foundChild: Instance = replicatedStorage:FindFirstChild(module.objectName)

	if foundChild then
		return foundChild
	end

	return false
end

return module
