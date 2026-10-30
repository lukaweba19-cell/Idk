-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = { Focus = true, SniperScope = true, MagicCircle = true }
local t2: {[any]: any} = { SniperScope = true, MagicCircle = true }

return {
	VALID_SCOPES = t1,
	FULL_OVERLAY_SCOPES = t2,
	IsFullOverlayScope = function(p1)
		local u4: boolean = false

		if typeof(p1) == "string" then
			u4 = t2[p1] == true
		end

		return u4
	end,
	IsValidScope = function(p2)
		local u6: boolean = false

		if typeof(p2) == "string" then
			u6 = t1[p2] == true
		end

		return u6
	end
}
