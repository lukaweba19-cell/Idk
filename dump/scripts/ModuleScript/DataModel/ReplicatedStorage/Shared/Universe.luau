-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = { DEV_GAME_ID = 10136054586, LIVE_GAME_ID = 9561553764 }

function module.IsDev()
	return game.GameId == module.DEV_GAME_ID
end
function module.IsLive()
	return game.GameId == module.LIVE_GAME_ID
end

return module
