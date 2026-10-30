-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function transform(p1)
	if p1 < 0.04045 then
		return p1 / 12.92
	end

	return ((p1 + 0.055) / 1.055) ^ 2.4
end
local function inverse(p2)
	if p2 < 0.0031308 then
		return p2 * 12.92
	end

	return p2 ^ 0.4166666666666667 * 1.055 - 0.055
end

return {
	fromLinear = function(p3)
		local r = p3.R
		local g = p3.G
		local b = p3.B

		return Color3.new(if r < 0.0031308 then r * 12.92 else r ^ 0.4166666666666667 * 1.055 - 0.055, if g < 0.0031308 then g * 12.92 else g ^ 0.4166666666666667 * 1.055 - 0.055, if b < 0.0031308 then b * 12.92 else b ^ 0.4166666666666667 * 1.055 - 0.055)
	end,
	toLinear = function(p4)
		local r = p4.R
		local g = p4.G
		local b = p4.B

		return Color3.new(if r < 0.04045 then r / 12.92 else ((r + 0.055) / 1.055) ^ 2.4, if g < 0.04045 then g / 12.92 else ((g + 0.055) / 1.055) ^ 2.4, if b < 0.04045 then b / 12.92 else ((b + 0.055) / 1.055) ^ 2.4)
	end
}
