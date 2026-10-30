-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local players: Players = game:GetService("Players")
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local currencyProducts = require(shared:WaitForChild("CurrencyProducts"))
local LocalPlayer: Player = players.LocalPlayer

local module: {[any]: any} = {
	PromptIfNeeded = function(p1, p2)
		local attributeValue = LocalPlayer:GetAttribute(if p1 == "Cash" then "Cash" else "Gems")

		if typeof(attributeValue) ~= "number" then
			attributeValue = 0
		end

		local n1 = p2 - attributeValue

		if n1 <= 0 then
			return false
		end

		local v11 = currencyProducts.GetBestProductForDeficit(p1, n1)

		if not v11 then
			return false
		end

		pcall(function()
			marketplaceService:PromptProductPurchase(LocalPlayer, v11.productId)
		end)

		return true
	end
}

function module.HandlePurchaseError(p3, _, p5)
	if p3 == "NoCash" or p3 == "NoMoney" then
		return module.PromptIfNeeded("Cash", p5)
	end

	if p3 == "NoGems" then
		return module.PromptIfNeeded("Gems", p5)
	end

	return false
end

return module
