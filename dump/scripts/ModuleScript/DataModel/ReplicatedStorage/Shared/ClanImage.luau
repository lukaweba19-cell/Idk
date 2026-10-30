-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local catalogs: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Catalogs")
local clanCatalog = require(catalogs:WaitForChild("ClanCatalog"))

return {
	apply = function(p1, p2)
		local v6 = clanCatalog.NormalizeImageId(p2)

		if v6 == "" then
			p1.Image = clanCatalog.DEFAULT_IMAGE

			return
		end

		local image: string = "rbxassetid://" .. v6

		p1.Image = image
		task.spawn(function()
			local u8 = nil

			pcall(function()
				contentProvider:PreloadAsync({ p1 }, function(_, p4)
					u8 = p4
				end)
			end)

			if u8 == Enum.AssetFetchStatus.Failure and p1.Image == image then
				p1.Image = clanCatalog.ThumbFor(v6)
			end
		end)
	end
}
