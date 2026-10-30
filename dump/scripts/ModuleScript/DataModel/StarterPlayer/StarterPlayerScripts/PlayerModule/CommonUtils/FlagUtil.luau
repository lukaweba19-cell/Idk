-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	getUserFlag = function(p1)
		local ok, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled(p1)
		end)

		return ok and result
	end
}
