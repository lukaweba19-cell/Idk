-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function comma(p1)
	local floored = math.floor(p1)

	return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

return {
	Format = function(p2, _)
		if typeof(p2) == "number" then
			local floored = math.floor(p2)

			return "#" .. tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end

		return nil
	end,
	IsSerialized = function(p4)
		return typeof(p4) == "number"
	end
}
