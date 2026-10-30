-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	ICON_ONE = "rbxassetid://98099350810522",
	ICON_FAN = "rbxassetid://95066666893989",
	ICON_STACK = "rbxassetid://116202142705218"
}

module.Products = {
	Tickets1 = {
		productId = 3718620793,
		displayName = "1 Wheel Ticket",
		currency = "WheelTickets",
		amount = 1,
		robuxPrice = 99,
		icon = module.ICON_ONE
	},
	Tickets3 = {
		productId = 3718620798,
		displayName = "3 Wheel Tickets",
		currency = "WheelTickets",
		amount = 3,
		robuxPrice = 279,
		icon = module.ICON_FAN
	},
	Tickets10 = {
		productId = 3718620801,
		displayName = "10 Wheel Tickets",
		currency = "WheelTickets",
		amount = 10,
		robuxPrice = 849,
		icon = module.ICON_STACK
	}
}
module.BIG_SPENDER_ROBUX = 10000
module.SPEND_GATE_MESSAGE = "That bundle is only for players who've spent over 10,000 Robux."
module.Products.Tickets100 = {
	productId = 3721093678,
	displayName = "100 Wheel Tickets",
	currency = "WheelTickets",
	amount = 100,
	robuxPrice = 0,
	icon = "rbxassetid://133625432283871",
	minRobuxSpent = module.BIG_SPENDER_ROBUX
}

local t2: {[any]: any} = {}

for iterFirst, iterSecond in module.Products, nil, nil do
	t2[iterSecond.productId] = iterSecond
end

function module.Get(p1)
	return t2[p1]
end
function module.IsTicketProduct(p2)
	local u7: boolean = false

	if typeof(p2) == "number" then
		u7 = t2[p2] ~= nil
	end

	return u7
end
function module.MeetsSpendGate(p3, p4)
	local v10 = if typeof(p4) == "number" then t2[p4] else nil

	if not v10 or not v10.minRobuxSpent then
		return true
	end

	return (tonumber(p3:GetAttribute("RobuxSpent")) or 0) > v10.minRobuxSpent
end
function module.IconFor(p5)
	if p5 <= 1 then
		return module.ICON_ONE
	end

	if p5 < 5 then
		return module.ICON_FAN
	end

	return module.ICON_STACK
end
function module.Label(p6)
	if p6 == 1 then
		return "1 Wheel Ticket"
	end

	return (string.format("%d Wheel Tickets", p6))
end

return module
