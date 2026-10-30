-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	DEFAULT = { ID = 177940974, Speed = 1 },
	[Enum.Material.Brick] = { ID = 178190837, Speed = 1 },
	[Enum.Material.Foil] = { ID = 3542369667, Speed = 1.5 },
	[Enum.Material.Cobblestone] = { ID = 178190837, Speed = 1 },
	[Enum.Material.Concrete] = { ID = 277067660, Speed = 1 },
	[Enum.Material.Rock] = { ID = 277067660, Speed = 1 },
	[Enum.Material.CorrodedMetal] = { ID = 177940974, Speed = 1 },
	[Enum.Material.DiamondPlate] = { ID = 177940974, Speed = 1 },
	[Enum.Material.Slate] = { ID = 178054124, Speed = 1 },
	[Enum.Material.Fabric] = { ID = 133705377, Speed = 1.6 },
	[Enum.Material.Carpet] = { ID = 133705377, Speed = 1.6 },
	[Enum.Material.Water] = { ID = 184795891, Speed = 1 },
	[Enum.Material.Granite] = { ID = 178054124, Speed = 1 },
	[Enum.Material.Grass] = { ID = 177940963, Speed = 1 },
	[Enum.Material.LeafyGrass] = { ID = 177940963, Speed = 1 },
	[Enum.Material.Mud] = { ID = 177940963, Speed = 1 },
	[Enum.Material.Ice] = { ID = 178190837, Speed = 1 },
	[Enum.Material.Marble] = { ID = 178190837, Speed = 1 },
	[Enum.Material.Metal] = { ID = 177940974, Speed = 1 },
	[Enum.Material.Pebble] = { ID = 133761546, Speed = 1.85 },
	[Enum.Material.Plastic] = { ID = 177940974, Speed = 1 },
	[Enum.Material.SmoothPlastic] = { ID = 177940974, Speed = 1 },
	[Enum.Material.Sand] = { ID = 212011266, Speed = 1 },
	[Enum.Material.Snow] = { ID = 83894944961712, Speed = 1 },
	[Enum.Material.Wood] = { ID = 177940988, Speed = 1 },
	[Enum.Material.WoodPlanks] = { ID = 211987063, Speed = 1 },
	VARIANTS = {
		["Water??"] = { ID = 131789564421438, Speed = 1 }
	},
	fetch = function(p1, p2, p3)
		local v4 = typeof(p3) == "Instance" and p3.Name or p3

		if v4 and p1.VARIANTS[v4] then
			return p1.VARIANTS[v4]
		end

		return p1[p2] or p1.DEFAULT
	end
}
