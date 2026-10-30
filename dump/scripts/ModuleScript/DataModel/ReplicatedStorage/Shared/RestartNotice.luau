-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(255, 255, 255)
local color32 = Color3.fromRGB(255, 96, 96)
local t1: {[any]: any} = {
	"message",
	"Message",
	"reason",
	"Reason",
	"text",
	"Text",
	"note",
	"Note"
}

local module: {[any]: any} = {
	RemoteName = "RestartNotice",
	ConfigKey = "RestartNoticeEnabled",
	BannerAtSeconds = 300,
	PingsAt = { 300, 120, 60, 30, 10 },
	PingEverySeconds = 600,
	UrgentSeconds = 60,
	NormalColor = color3,
	UrgentColor = color32,
	ChatColor = "#FF6060",
	OverrunGraceSeconds = 240,
	ReadMessage = function(p1)
		if typeof(p1) == "table" then
			for _, v in ipairs(t1) do
				local v8 = p1[v]

				if typeof(v8) == "string" then
					local replacedText = v8:gsub("^%s+", ""):gsub("%s+$", "")

					if replacedText ~= "" then
						if #replacedText > 90 then
							replacedText = replacedText:sub(1, 89) .. "…"
						end

						return replacedText
					end
				end
			end

			return nil
		end

		return nil
	end,
	FormatClock = function(p2)
		local floored = math.floor(p2 + 0.5)
		local v12 = math.max(0, floored)

		return string.format("%d:%02d", v12 // 60, v12 % 60)
	end
}

function module.FormatCoarse(p3)
	local v14 = math.max(0, p3)

	if v14 < 90 then
		return module.FormatClock(v14)
	end

	local floored = math.floor(v14 / 60 + 0.5)

	return string.format("%d minute%s", floored, if floored == 1 then "" else "s")
end
function module.Headline(p4)
	if p4 then
		return "SERVER MAINTENANCE"
	end

	return "SERVERS RESTARTING"
end
function module.BannerBody(p5, p6)
	local v19 = module.FormatClock(p5)

	if p6 then
		return v19 .. " — " .. p6
	end

	return v19
end
function module.ChatLine(p7, p8, p9, p10)
	local v24

	if p10 then
		v24 = ("%s <b>%s</b>!"):format(if p8 then "Server maintenance in" else "Servers restarting in", module.FormatCoarse(p7))

		if p9 then
			v24 = v24 .. " (" .. p9 .. ")"
		end
	elseif p7 <= 60 then
		v24 = ("Restarting in <b>%s</b> -- finishing up now."):format(module.FormatClock(p7))
	else
		v24 = ("Restarting in <b>%s</b>."):format(module.FormatCoarse(p7))
	end

	return ("<font color=\"%s\">%s</font>"):format(module.ChatColor, v24)
end

return module
