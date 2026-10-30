-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = { SOLD_OUT_DISPLAY_SECONDS = 259200 }

function module.IsWithinSoldOutWindow(p1, p2)
	if typeof(p1) == "number" then
		return (p2 or os.time()) - p1 < module.SOLD_OUT_DISPLAY_SECONDS
	end

	return false
end
function module.ShouldDisplayInCase(p3, p4)
	if typeof(p3) == "number" then
		return module.IsWithinSoldOutWindow(p3, p4)
	end

	return true
end
function module.SecondsUntilHidden(p5, p6)
	if typeof(p5) == "number" then
		local sold_out_display_seconds = module.SOLD_OUT_DISPLAY_SECONDS
		local v9 = p6 or os.time()
		local n1 = sold_out_display_seconds - (v9 - p5)

		return n1 > 0 and n1 or nil
	end

	return nil
end

module.RELEASE_DELAY_SECONDS = 600

function module.SaleOpensAt(p7, p8)
	if typeof(p7) == "number" then
		local typeName: string = typeof(p8)

		return p7 + (typeName == "number" and p8 >= 0 and p8 or module.RELEASE_DELAY_SECONDS)
	end

	return nil
end
function module.IsRevealed(p9, p10)
	if typeof(p9) == "number" then
		local v16 = p10 or os.time()

		return p9 <= v16
	end

	return true
end
function module.IsPurchasable(p11, p12, p13)
	local v20 = module.SaleOpensAt(p11, p13)

	if v20 == nil then
		return true
	end

	local v21 = p12 or os.time()

	return v20 <= v21
end
function module.SecondsUntilSale(p14, p15, p16)
	local v25 = module.SaleOpensAt(p14, p16)

	if v25 == nil then
		return nil
	end

	local v26 = p15 or os.time()
	local n1 = v25 - v26

	return n1 > 0 and n1 or nil
end
function module.FormatCountdown(p17)
	local roundedUp = math.ceil(p17)
	local v30 = math.max(0, roundedUp)
	local n1 = v30 // 3600
	local n2 = v30 % 3600 // 60
	local n3 = v30 % 60

	if n1 > 0 then
		return ("%d:%02d:%02d"):format(n1, n2, n3)
	end

	return ("%d:%02d"):format(n2, n3)
end

return module
