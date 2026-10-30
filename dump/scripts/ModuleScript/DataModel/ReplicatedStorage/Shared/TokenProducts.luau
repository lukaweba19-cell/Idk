-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	Products = {
		TokenPackage1 = {
			productId = 3607899668,
			displayName = "50 Trade Tokens",
			currency = "TradeTokens",
			amount = 50,
			bonus = nil,
			robuxPrice = 40
		},
		TokenPackage2 = {
			productId = 3607899713,
			displayName = "250 Trade Tokens",
			currency = "TradeTokens",
			amount = 250,
			bonus = nil,
			robuxPrice = 200
		},
		TokenPackage3 = {
			productId = 3607899778,
			displayName = "1,000 Trade Tokens",
			currency = "TradeTokens",
			amount = 1000,
			bonus = nil,
			robuxPrice = 800
		},
		TokenPackage4 = {
			productId = 3607899820,
			displayName = "5,000 Trade Tokens",
			currency = "TradeTokens",
			amount = 5000,
			bonus = nil,
			robuxPrice = 4000
		},
		TokenPackage5 = {
			productId = 3607899860,
			displayName = "25,000 Trade Tokens",
			currency = "TradeTokens",
			amount = 25000,
			bonus = nil,
			robuxPrice = 20000,
			bonusKnife = "LMADNew"
		}
	}
}

function module.GetById(p1)
	for _, v in pairs(module.Products) do
		if p1 == v.productId then
			return v
		end
	end

	return nil
end

module.TOKENS_PER_ROBUX = 1.25

function module.RobuxToTokens(p2)
	if typeof(p2) == "number" and not (p2 <= 0) then
		return (math.floor(p2 * module.TOKENS_PER_ROBUX))
	end

	return 0
end

setmetatable(module, {
	__index = function(_, p4)
		return module.Products[p4]
	end
})

return module
