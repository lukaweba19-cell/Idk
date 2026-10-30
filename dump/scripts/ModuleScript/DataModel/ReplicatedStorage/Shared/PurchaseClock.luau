-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Now = function()
		local ok, result = pcall(function()
			return workspace:GetServerTimeNow()
		end)

		if ok and typeof(result) == "number" and result > 0 and result == result then
			return result
		end

		return os.time()
	end,
	IsStamp = function(p1)
		local u4: boolean = false

		if typeof(p1) == "number" then
			u4 = false

			if p1 == p1 then
				u4 = p1 > 1000000000
			end
		end

		return u4
	end
}
