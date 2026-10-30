-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local timestamp = os.time()

return function()
	local n1 = os.time() - timestamp
	local floored = math.floor(n1 / 86400)
	local floored2 = math.floor(n1 / 3600)
	local floored3 = math.floor(n1 / 60)
	local floored4 = math.floor(n1)

	return ("%dd %dh %dm %ds"):format(floored, floored2 % 24, floored3 % 60, floored4 % 60)
end
