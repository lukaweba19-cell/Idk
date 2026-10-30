-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	ItemType = "Knife",
	ItemId = "SteelBall",
	ContentsName = nil,
	UfoDelivery = false,
	ShopCard = false
}

function module.Key()
	return module.ItemType .. ":" .. module.ItemId
end
function module.ModelName()
	return module.ContentsName or module.ItemId
end

return module
