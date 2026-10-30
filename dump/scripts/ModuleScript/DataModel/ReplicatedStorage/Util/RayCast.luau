-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local bin: Instance = workspace:WaitForChild("Bin")
local CurrentCamera: Camera = workspace.CurrentCamera
local destructibles: Instance = workspace:WaitForChild("Destructibles")
local t1: {[any]: any} = {
	bin,
	CurrentCamera,
	destructibles,
	workspace:WaitForChild("Characters")
}

return function(p1, p2, p3, _)
	local t2: {[any]: any} = {}

	for _, v in pairs(t1) do
		table.insert(t2, v)
	end

	for _, v in pairs(p3 or {}) do
		table.insert(t2, v)
	end

	local ray = Ray.new(p1, p2)

	return workspace:FindPartOnRayWithIgnoreList(ray, t2)
end
