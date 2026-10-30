-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(_, p2)
	for _, v in pairs(p2) do
		v:Kick("Kicked by admin.")
	end

	return ("Kicked %d players."):format(#p2)
end
