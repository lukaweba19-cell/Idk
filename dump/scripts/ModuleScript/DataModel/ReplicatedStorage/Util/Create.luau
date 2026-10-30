-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

function module.new(className, p2)
	local v4 = Instance.new(className)

	for k, v in pairs(p2 or {}) do
		v4[k] = v
	end

	return v4
end
function module.Part()
	return (module.new("Part", {
		TopSurface = 0,
		BottomSurface = 0,
		CastShadow = false,
		CanTouch = false,
		Size = Vector3.new(1, 1, 1),
		Anchored = true,
		CanCollide = false
	}))
end
function module.Sphere()
	local v7 = module.Part()
	local mesh: SpecialMesh = Instance.new("SpecialMesh", v7)

	mesh.Name = "Mesh"
	mesh.MeshType = "Sphere"

	return v7
end
function module.Block()
	local v9 = module.Part()

	Instance.new("BlockMesh", v9).Name = "Mesh"

	return v9
end

return module
