-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	ProfileField = "HiddenMMR",
	EnabledConfigKey = "SKILL_BASED_MATCHMAKING_ENABLED",
	MatchmadeOnly = true,
	Settings = {
		tau = 0.5,
		scale = 173.7178,
		center = 1000,
		minRd = 30,
		maxRd = 350,
		epsilon = 0.000001
	},
	DefaultRating = 1000,
	DefaultRD = 350,
	DefaultVol = 0.06,
	ProvisionalRD = 110,
	RatingPeriodSeconds = 86400
}

function module.normalize(p1)
	if type(p1) == "table" then
		return {
			r = type(p1.r) == "number" and p1.r or module.DefaultRating,
			rd = type(p1.rd) == "number" and p1.rd or module.DefaultRD,
			vol = type(p1.vol) == "number" and p1.vol or module.DefaultVol,
			t = type(p1.t) == "number" and p1.t or 0,
			games = type(p1.games) == "number" and p1.games or 0,
			matches = type(p1.matches) == "number" and p1.matches or 0
		}
	end

	return {
		t = 0,
		games = 0,
		matches = 0,
		r = module.DefaultRating,
		rd = module.DefaultRD,
		vol = module.DefaultVol
	}
end
function module.ratingOf(p2)
	if type(p2) == "table" and type(p2.r) == "number" then
		return p2.r
	end

	return module.DefaultRating
end
function module.isProvisional(p3)
	return p3.rd > module.ProvisionalRD
end

return module
