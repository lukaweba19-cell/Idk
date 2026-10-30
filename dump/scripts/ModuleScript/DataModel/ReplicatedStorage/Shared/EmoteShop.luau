-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local emoteCatalog = require(script.Parent:WaitForChild("EmoteCatalog"))
local t1: {[any]: any} = {
	Uncommon = 3712634246,
	Rare = 3712634298,
	Epic = 3712634358,
	Legendary = 3712634486
}
local t2: {[any]: any} = {
	Uncommon = 3712760434,
	Rare = 3712760489,
	Epic = 3712760524,
	Legendary = 3712760562
}

local module: {[any]: any} = {
	DAILY_COUNT = 6,
	TIER_PRODUCTS = t1,
	TIER_GIFT_PRODUCTS = t2,
	PERIOD = 86400,
	Now = function()
		if runService:IsServer() then
			return os.time()
		end

		return workspace:GetServerTimeNow()
	end
}

function module.DayIndex(p1)
	local v16 = p1 or module.Now()

	return (math.floor(v16 / module.PERIOD))
end
function module.NextResetUnix(p2)
	return (module.DayIndex(p2) + 1) * module.PERIOD
end
function module.SecondsToReset(p3)
	local v19 = p3 or module.Now()
	local v20 = module.NextResetUnix(v19)

	return (math.max(0, v20 - v19))
end
function module.ProductFor(p4)
	local v22 = emoteCatalog.Get(p4)

	if not v22 then
		return nil
	end

	if v22.NotSold then
		return nil
	end

	local productId = v22.ProductId

	if typeof(productId) == "number" then
		return productId
	end

	return t1[v22.Rarity]
end
function module.GiftProductFor(p5)
	local v25 = emoteCatalog.Get(p5)

	if v25 and not v25.NotSold then
		local v26 = t2[v25.Rarity]

		if typeof(v26) == "number" and v26 > 0 then
			return v26
		end

		return nil
	end

	return nil
end

local t4: {[any]: any} = {}

for _, v in pairs(t2) do
	if v > 0 then
		t4[v] = true
	end
end

function module.IsEmoteGiftProduct(p6)
	local u28: boolean = false

	if typeof(p6) == "number" then
		u28 = t4[p6] == true
	end

	return u28
end
function module.Sellable()
	local t6: {[any]: any} = {}

	for _, v in ipairs(emoteCatalog.Order) do
		if module.ProductFor(v) then
			table.insert(t6, v)
		end
	end

	return t6
end
function module.TodayIds(p7)
	local v33 = module.Sellable()
	local n1: number = #v33

	if n1 <= module.DAILY_COUNT then
		return v33
	end

	local randomNew = Random.new
	local v36 = module.DayIndex(p7)
	local v37 = randomNew(v36 * 1000003 + 8675309)

	for i = n1, 2, -1 do
		local v39 = v37:NextInteger(1, i)
		local v40 = v33[i]

		v33[i] = v33[v39]
		v33[v39] = v40
	end

	v37 = {}

	for i = 1, module.DAILY_COUNT do
		v37[i] = v33[i]
	end

	return v37
end
function module.IsOnSale(p8, p9)
	for _, v in ipairs(module.TodayIds(p9)) do
		if v == p8 then
			return true
		end
	end

	return false
end

local t5: {[any]: any} = {}

for _, v in pairs(t1) do
	t5[v] = true
end

for _, v in pairs(emoteCatalog.Defs) do
	local vProductId = v.ProductId

	if typeof(vProductId) == "number" then
		t5[vProductId] = true
	end
end

function module.IsEmoteProduct(p10)
	local u47: boolean = false

	if typeof(p10) == "number" then
		u47 = t5[p10] == true
	end

	return u47
end
function module.EmotesForProduct(p11)
	local t7: {[any]: any} = {}

	if not module.IsEmoteProduct(p11) then
		return t7
	end

	for _, v in ipairs(emoteCatalog.Order) do
		local v52 = module.ProductFor(v)

		if p11 == v52 then
			table.insert(t7, v)
		end
	end

	return t7
end

return module
