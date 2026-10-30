-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)

local v2 = util.MakeSequenceType({
	Prefixes = "# hexColor3 ! brickColor3",
	Length = 3,
	ValidateEach = function(p1, p2)
		if p1 == nil then
			return false, ("Invalid or missing number at position %d in Color3 type."):format(p2)
		end

		if p1 < 0 or p1 > 255 then
			return false, ("Number out of acceptable range 0-255 at position %d in Color3 type."):format(p2)
		end

		if p1 % 1 == 0 then
			return true
		end

		return false, ("Number is not an integer at position %d in Color3 type."):format(p2)
	end,
	TransformEach = tonumber,
	Constructor = Color3.fromRGB
})

local function parseHexDigit(p3: string)
	if #p3 == 1 then
		p3 ..= p3
	end

	return (tonumber(p3, 16))
end

local t1: {[any]: any} = {
	Transform = function(p4)
		local v9, v10, v11 = p4:match("^#?(%x%x?)(%x%x?)(%x%x?)$")

		return util.Each(parseHexDigit, v9, v10, v11)
	end,
	Validate = function(p5, p6, p7)
		return p5 ~= nil and p6 ~= nil and p7 ~= nil, "Invalid hex color"
	end,
	Parse = function(...)
		return Color3.fromRGB(...)
	end
}

return function(p8)
	p8:RegisterType("color3", v2)
	p8:RegisterType("color3s", util.MakeListableType(v2, { Prefixes = "# hexColor3s ! brickColor3s" }))
	p8:RegisterType("hexColor3", t1)
	p8:RegisterType("hexColor3s", util.MakeListableType(t1))
end
