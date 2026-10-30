-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	Products = {
		Package1 = {
			productId = 3538978997,
			displayName = "1,200 Coins",
			currency = "Cash",
			amount = 1200,
			bonus = nil,
			robuxPrice = 80
		},
		Package2 = {
			productId = 3538979131,
			displayName = "5,250 Coins",
			currency = "Cash",
			amount = 5250,
			bonus = nil,
			robuxPrice = 350
		},
		Package3 = {
			productId = 3538979244,
			displayName = "20,000 Coins",
			currency = "Cash",
			amount = 20000,
			bonus = 2000,
			robuxPrice = 1200
		},
		Package4 = {
			productId = 3538979399,
			displayName = "75,000 Coins",
			currency = "Cash",
			amount = 75000,
			bonus = 15000,
			robuxPrice = 4000
		},
		Package5 = {
			productId = 3538979571,
			displayName = "200,000 Coins",
			currency = "Cash",
			amount = 200000,
			bonus = 50000,
			robuxPrice = 10000
		}
	}
}

function module.GetBestProductForDeficit(p1, p2)
	local v4 = nil

	for _, v in pairs(module.Products) do
		if p1 == v.currency and not (p2 > v.amount) and (not v4 or v.amount < v4.amount) then
			v4 = v
		end
	end

	if not v4 then
		for _, v in pairs(module.Products) do
			if p1 == v.currency and (not v4 or v.amount > v4.amount) then
				v4 = v
			end
		end
	end

	return v4
end

setmetatable(module, {
	__index = function(_, p4)
		return module.Products[p4]
	end
})

return module
