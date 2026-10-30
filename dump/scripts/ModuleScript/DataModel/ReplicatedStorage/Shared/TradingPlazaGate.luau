-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local universe = require(script.Parent:WaitForChild("Universe"))
local updateGate = require(script.Parent:WaitForChild("UpdateGate"))
local universeDev_game_id = universe.DEV_GAME_ID
local universeLive_game_id = universe.LIVE_GAME_ID

local module: {[any]: any} = {
	SPOOF_ATTRIBUTE = "SpoofTradingPlaza",
	DEV_TRADING_PLAZA_PLACE_ID = 94477081379373,
	LIVE_TRADING_PLAZA_PLACE_ID = 120783481568445,
	IsTradingPlaza = function()
		if runService:IsStudio() and workspace:GetAttribute("SpoofTradingPlaza") == true then
			return true
		end

		if game.GameId == universeDev_game_id and game.PlaceId == 94477081379373 then
			return true
		end

		if game.GameId == universeLive_game_id and game.PlaceId == 120783481568445 then
			return true
		end

		return false
	end,
	GetTradingPlazaPlaceId = function()
		if game.GameId == universeLive_game_id then
			return 120783481568445
		end

		return 94477081379373
	end,
	GetLobbyPlaceId = function()
		if game.GameId == universeLive_game_id then
			return 120851538706364
		end

		return 118700671270994
	end,
	OPENS_WITH_UPDATE = "Event10",
	OPENS_AFTER_UPDATE_SECONDS = 600
}

function module.IsOpen()
	local opens_with_update = module.OPENS_WITH_UPDATE

	if opens_with_update == nil then
		return true
	end

	local v8 = updateGate.UPDATES[opens_with_update]

	if not v8 then
		return true
	end

	return updateGate.GetCurrentTime() >= v8.ReleaseAt + module.OPENS_AFTER_UPDATE_SECONDS
end
function module.SecondsUntilOpen()
	local opens_with_update = module.OPENS_WITH_UPDATE

	if opens_with_update == nil then
		return 0
	end

	local v10 = updateGate.UPDATES[opens_with_update]

	if not v10 then
		return 0
	end

	local n1 = v10.ReleaseAt + module.OPENS_AFTER_UPDATE_SECONDS
	local v12 = updateGate.GetCurrentTime()

	return (math.max(0, n1 - v12))
end

return module
