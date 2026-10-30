-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(190, 85, 255)
local color32 = Color3.fromRGB(255, 70, 70)
local color33 = Color3.fromRGB(255, 221, 0)
local color34 = Color3.fromRGB(255, 255, 255)
local t1: {[any]: any} = {
	{ max = 3, color = color3 },
	{ max = 10, color = color32 },
	{ max = 25, color = color33 },
	{ max = 50, color = color34 }
}
local color35 = Color3.fromRGB(255, 255, 255)

local function toHex(p1)
	local stringFormat = string.format
	local floored = math.floor(p1.R * 255 + 0.5)
	local floored2 = math.floor(p1.G * 255 + 0.5)
	local floored3 = math.floor(p1.B * 255 + 0.5)

	return stringFormat("#%02X%02X%02X", floored, floored2, floored3)
end
local function escapeRichText(p2)
	return (p2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;"))
end
local function fontSpan(p3, p4)
	local stringFormat = string.format
	local v20 = string.format
	local floored = math.floor(p3.R * 255 + 0.5)
	local floored4 = math.floor(p3.G * 255 + 0.5)
	local floored5 = math.floor(p3.B * 255 + 0.5)
	local v24 = v20("#%02X%02X%02X", floored, floored4, floored5)

	return stringFormat("<font color=\"%s\">%s</font>", v24, p4)
end

local module: {[any]: any} = {
	RANK_TIERS = t1,
	RankColor = function(p5)
		if typeof(p5) == "number" and not (p5 < 1) then
			for _, v in ipairs(t1) do
				if p5 <= v.max then
					return v.color
				end
			end

			return nil
		end

		return nil
	end
}

function module.GetRankPrefix(p6)
	local v29 = module.RankColor(p6)

	if v29 and typeof(p6) == "number" then
		local floored = math.floor(p6)
		local text: string = tostring(floored)

		return fontSpan(v29, "[#" .. text .. "]")
	end

	return ""
end
function module.GetTag(p7)
	local v33 = escapeRichText(p7)

	return fontSpan(color35, "[" .. v33 .. "]")
end
function module.GetTagWithLeaderboard(p8, p9)
	local v36 = module.GetRankPrefix(p9)
	local v37 = module.GetTag(p8)

	if v36 == "" then
		return v37
	end

	return v36 .. " " .. v37
end

return module
