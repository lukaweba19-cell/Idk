-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../color/sRGB")

local module: {[any]: any} = {
	fromLinear = function(p1)
		local n1 = (p1.R * 0.4122214708 + p1.G * 0.5363325363 + p1.B * 0.0514459929) ^ 0.3333333333333333
		local n2 = (p1.R * 0.2119034982 + p1.G * 0.6806995451 + p1.B * 0.1073969566) ^ 0.3333333333333333
		local n3 = (p1.R * 0.0883024619 + p1.G * 0.2817188376 + p1.B * 0.6299787005) ^ 0.3333333333333333
		local vector3 = Vector3.new(n1 * 0.2104542553 + n2 * 0.793617785 - n3 * 0.0040720468, n1 * 1.9779984951 - n2 * 2.428592205 + n3 * 0.4505937099, n1 * 0.0259040371 + n2 * 0.7827717662 - n3 * 0.808675766)

		return vector3
	end
}

function module.fromSRGB(p2)
	return module.fromLinear(v1.toLinear(p2))
end
function module.toLinear(p3, p4)
	local n1 = (p3.X + p3.Y * 0.3963377774 + p3.Z * 0.2158037573) ^ 3
	local n2 = (p3.X - p3.Y * 0.1055613458 - p3.Z * 0.0638541728) ^ 3
	local n3 = (p3.X - p3.Y * 0.0894841775 - p3.Z * 1.291485548) ^ 3
	local n4 = n1 * 4.0767416621 - n2 * 3.3077115913 + n3 * 0.2309699292
	local n5 = n1 * -1.2684380046 + n2 * 2.6097574011 - n3 * 0.3413193965
	local n6 = n1 * -0.0041960863 - n2 * 0.7034186147 + n3 * 1.707614701

	if not p4 then
		n4 = math.clamp(n4, 0, 1)
		n5 = math.clamp(n5, 0, 1)
		n6 = math.clamp(n6, 0, 1)
	end

	return Color3.new(n4, n5, n6)
end
function module.toSRGB(p5, p6)
	return v1.fromLinear(module.toLinear(p5, p6))
end

return module
