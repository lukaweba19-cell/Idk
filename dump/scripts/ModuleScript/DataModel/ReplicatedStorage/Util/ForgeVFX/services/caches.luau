-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../obj/ObjectCache")
local v2 = require("../mod/utility")

return {
	init = function(p1)
		local part: Part = Instance.new("Part")

		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.Locked = true

		local do_not_remove_ForgeSharedPartCache: Folder = Instance.new("Folder")

		do_not_remove_ForgeSharedPartCache.Name = "DO_NOT_REMOVE_ForgeSharedPartCache"
		do_not_remove_ForgeSharedPartCache.Archivable = false
		do_not_remove_ForgeSharedPartCache.Parent = workspace.Terrain
		v2.protectParent(p1, do_not_remove_ForgeSharedPartCache)

		local u6 = v1.new(part, do_not_remove_ForgeSharedPartCache, {
			size = 150,
			on_free = function(p2)
				local value = p2.value

				value.Transparency = 1
				value.Anchored = true
				value.CanQuery = false
				value.CanCollide = false
				value.CollisionGroup = "ForgeMouseIgnore"
				value.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				value.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				value.Parent = do_not_remove_ForgeSharedPartCache
				value:ClearAllChildren()
			end
		})

		local t1: {[any]: any} = { shared_part = u6 }

		table.insert(p1, function()
			u6:destroy()
		end)

		return t1
	end
}
