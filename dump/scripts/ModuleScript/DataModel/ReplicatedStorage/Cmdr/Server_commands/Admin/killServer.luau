-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(_, p2)
	for _, v in pairs(p2) do
		if v.Character then
			v.Character:BreakJoints()
		end
	end

	return ("Killed %d players."):format(#p2)
end
