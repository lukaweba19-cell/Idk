-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local v2 = require("../obj/ObjectCache")

require("../types")

local v3 = require("../mod/utility")
local v4 = require("../mod/common/flipbook")

return {
	init = function(p1)
		local decal: Decal = Instance.new("Decal")
		local do_not_remove_ForgeTextureCache: Part = Instance.new("Part")

		do_not_remove_ForgeTextureCache.Name = "DO_NOT_REMOVE_ForgeTextureCache"
		do_not_remove_ForgeTextureCache.Transparency = 1
		do_not_remove_ForgeTextureCache.Size = Vector3.new(0, 0, 0)
		do_not_remove_ForgeTextureCache.Archivable = false
		do_not_remove_ForgeTextureCache.Anchored = true
		do_not_remove_ForgeTextureCache.CanCollide = false
		do_not_remove_ForgeTextureCache.CanQuery = false
		do_not_remove_ForgeTextureCache.Locked = true
		do_not_remove_ForgeTextureCache.Parent = workspace.Terrain
		v3.protectParent(p1, do_not_remove_ForgeTextureCache)

		local v8 = v2.new(decal, do_not_remove_ForgeTextureCache, {
			size = 360,
			on_free = function(p2)
				p2.value.Texture = ""
			end
		})

		local t1: {[any]: any} = {}

		local function createLoader(p3, p4, p5)
			local t2: {[any]: any} = {}
			local t3: {[any]: any} = {}

			table.insert(t2, t3)

			local function refresh()
				v3.cleanupScope(t3)
				p4(function(texture)
					if texture == "" then
						return
					end

					local v62 = v8:get(texture)

					v62.Texture = texture
					table.insert(t3, function()
						v8:free(texture)
					end)
				end)
			end

			v3.cleanupScope(t3)
			p4(function(texture)
				if texture == "" then
					return
				end

				local v31 = v8:get(texture)

				v31.Texture = texture
				table.insert(t3, function()
					v8:free(texture)
				end)
			end)

			if v3.PLUGIN_CONTEXT and p5 then
				local v21 = v3.reboundfn(1, refresh)

				for iterFirst, iterSecond in p5(v21) do
					table.insert(t2, iterSecond)
				end
			end

			t1[p3] = t2
		end
		local function loadTextures(p8)
			if p8:IsDescendantOf(workspace.Terrain) then
				return
			end

			if v3.isMeshVFX(p8) then
				local start = p8:FindFirstChild("Start")

				if not start or not start:IsA("BasePart") then
					return
				end

				createLoader(p8, function(p9)
					local v33, v34 = v3.getMeshDecals(p8, start)

					for iterFirst, iterSecond in v33 do
						local typeName: string = typeof(iterSecond)

						p9(typeName ~= "string" and iterSecond.Texture or iterSecond)
					end

					for iterFirst2, iterSecond2 in v34 do
						local v40 = v4.getTexturePrefix(p8)

						for iterFirst3, iterSecond3 in iterSecond2 do
							local v43 = ("%*%*"):format(v40, iterSecond3)

							p9(v43)
						end
					end
				end, function(p10)
					local connection = start.DescendantAdded:Connect(p10)

					return { connection, start.DescendantRemoving:Connect(p10) }
				end)

				return
			end

			if p8:IsA("Beam") then
				createLoader(p8, function(p11)
					p11(p8.Texture)

					local v47 = v4.getFlipbookData(p8)

					if v47 then
						local v48 = v4.getTexturePrefix(p8)

						for iterFirst, iterSecond in v47 do
							local v51 = ("%*%*"):format(v48, iterSecond)

							p11(v51)
						end
					end
				end, function(p12)
					local connection = p8:GetPropertyChangedSignal("Texture"):Connect(p12)

					return { connection, p8.AttributeChanged:Connect(p12) }
				end)

				return
			end

			createLoader(p8, function(p13)
				local function check(p14)
					if p14:IsA("ParticleEmitter") then
						p13(p14.Texture)
					end
				end

				local v56 = p8

				if v56:IsA("ParticleEmitter") then
					p13(v56.Texture)
				end

				for iterFirst, iterSecond in p8:GetDescendants() do
					if iterSecond:IsA("ParticleEmitter") then
						p13(iterSecond.Texture)
					end
				end
			end, function(p15)
				local connection = p8.DescendantAdded:Connect(p15)

				return { connection, p8.DescendantRemoving:Connect(p15) }
			end)
		end

		for iterFirst, iterSecond in collectionService:GetTagged(v3.TEXTURE_LOAD_TAG) do
			loadTextures(iterSecond)
		end

		collectionService:GetInstanceAddedSignal(v3.TEXTURE_LOAD_TAG):Connect(loadTextures)
		collectionService:GetInstanceRemovedSignal(v3.TEXTURE_LOAD_TAG):Connect(function(p16)
			local v27 = t1[p16]

			if v27 then
				v3.cleanupScope(v27)
				t1[p16] = nil
			end
		end)
		table.insert(p1, function()
			v8:destroy()

			for key, value in t1 do
				v3.cleanupScope(value)
			end
		end)
	end
}
