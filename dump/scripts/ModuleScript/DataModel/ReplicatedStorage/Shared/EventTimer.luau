-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	ENDED_TEXT = "ENDED",
	RED = Color3.fromRGB(255, 0, 0),
	RED_THRESHOLD = 86400
}

function module.formatWeeks(p1)
	local floored = math.floor(p1)
	local v4 = math.max(0, floored)
	local floored2 = math.floor(v4 / 604800)
	local floored3 = math.floor(v4 % 604800 / 86400)

	if floored2 > 0 then
		return string.format("%dw %dd", floored2, floored3)
	end

	return module.format(v4)
end
function module.format(p2)
	local floored = math.floor(p2)
	local v9 = math.max(0, floored)
	local floored4 = math.floor(v9 / 86400)
	local floored5 = math.floor(v9 % 86400 / 3600)
	local floored6 = math.floor(v9 % 3600 / 60)

	if floored4 > 0 then
		return string.format("%dd %dh %dm", floored4, floored5, floored6)
	end

	if floored5 > 0 then
		return string.format("%dh %dm", floored5, floored6)
	end

	return string.format("%dm %ds", floored6, v9 % 60)
end
function module.driveLabel(p3, p4, p5)
	local t2 = p5 or {}
	local v17 = t2.endedText or module.ENDED_TEXT
	local u18: boolean = t2.redInFinalDay == true
	local onUpdate = t2.onUpdate
	local v20 = t2.format or module.format
	local wrap = t2.wrap
	local textColor3 = p3.TextColor3
	local u23: boolean = true

	task.spawn(function()
		while u23 do
			local v24 = p4()

			if typeof(v24) == "number" then
				local timestamp = os.time()
				local n1 = v24 - timestamp
				local u27: boolean = n1 <= 0

				if u27 then
					p3.Text = v17

					if u18 then
						p3.TextColor3 = module.RED
					end
				else
					local v28 = v20(n1)

					p3.Text = wrap and wrap(v28) or v28

					if u18 then
						if n1 <= module.RED_THRESHOLD then
							p3.TextColor3 = module.RED
						else
							p3.TextColor3 = textColor3
						end
					end
				end

				if onUpdate then
					onUpdate(n1, u27)
				end
			end

			task.wait(1)
		end
	end)

	return function()
		u23 = false
	end
end

return module
