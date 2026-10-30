-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

local function tune(p1, p2)
	local v7 = t1[p1]

	return typeof(v7) == "number" and v7 or p2
end

local module: {[any]: any} = {
	PRE_DROP_GRACE_SECONDS = 5,
	PENALTY_BASE_SECONDS = 30,
	PENALTY_CAP_SECONDS = 300,
	MINT_COOLDOWN_SECONDS = 0,
	MAX_MINTS_PER_ACCOUNT = 0,
	CASE_COOLDOWN_SECONDS = 0,
	CASE_RUSH_WINDOW_SECONDS = 600
}

function module.MintCooldown()
	local mint_cooldown_seconds = t1.MINT_COOLDOWN_SECONDS

	return typeof(mint_cooldown_seconds) == "number" and mint_cooldown_seconds or module.MINT_COOLDOWN_SECONDS
end
function module.MintCeiling()
	local max_mints_per_account = t1.MAX_MINTS_PER_ACCOUNT

	return typeof(max_mints_per_account) == "number" and max_mints_per_account or module.MAX_MINTS_PER_ACCOUNT
end
function module.CaseCooldown()
	local case_cooldown_seconds = t1.CASE_COOLDOWN_SECONDS

	return typeof(case_cooldown_seconds) == "number" and case_cooldown_seconds or module.CASE_COOLDOWN_SECONDS
end
function module.CaseRushWindow()
	local case_rush_window_seconds = t1.CASE_RUSH_WINDOW_SECONDS

	return typeof(case_rush_window_seconds) == "number" and case_rush_window_seconds or module.CASE_RUSH_WINDOW_SECONDS
end
function module.PreDropGrace()
	local pre_drop_grace_seconds = t1.PRE_DROP_GRACE_SECONDS

	return typeof(pre_drop_grace_seconds) == "number" and pre_drop_grace_seconds or module.PRE_DROP_GRACE_SECONDS
end
function module.PenaltyBase()
	local penalty_base_seconds = t1.PENALTY_BASE_SECONDS

	return typeof(penalty_base_seconds) == "number" and penalty_base_seconds or module.PENALTY_BASE_SECONDS
end
function module.PenaltyCap()
	local penalty_cap_seconds = t1.PENALTY_CAP_SECONDS

	return typeof(penalty_cap_seconds) == "number" and penalty_cap_seconds or module.PENALTY_CAP_SECONDS
end

module.PENALTY_ENFORCED = 0

function module.PenaltyEnforced()
	local penalty_enforced = t1.PENALTY_ENFORCED

	return (typeof(penalty_enforced) == "number" and penalty_enforced or module.PENALTY_ENFORCED) ~= 0
end
function module.SetOverrides(p3)
	if typeof(p3) == "table" then
		local t3: {[any]: any} = {}

		for _, v in ipairs({
			"MINT_COOLDOWN_SECONDS",
			"MAX_MINTS_PER_ACCOUNT",
			"CASE_COOLDOWN_SECONDS",
			"CASE_RUSH_WINDOW_SECONDS",
			"PRE_DROP_GRACE_SECONDS",
			"PENALTY_BASE_SECONDS",
			"PENALTY_CAP_SECONDS",
			"PENALTY_ENFORCED"
		}) do
			local numberValue: number? = tonumber(p3[v])

			if numberValue and numberValue == numberValue and numberValue >= 0 then
				t3[v] = numberValue
			end
		end

		t1 = t3

		return
	end

	t1 = {}
end
function module.ItemKey(p4, p5)
	local text: string = tostring(p4)
	local text2: string = tostring(p5)

	return text .. ":" .. text2
end
function module.Read(p6, p7)
	if typeof(p6) == "table" then
		local collectibleMints = p6.CollectibleMints

		if typeof(collectibleMints) == "table" then
			local v28 = collectibleMints[p7]

			if typeof(v28) == "table" then
				local v29 = typeof(v28.N) == "number" and v28.N or 0
				local v30 = typeof(v28.Last) == "number" and v28.Last or 0
				local typeName: string = typeof(v28.CLast)

				return v29, v30, typeName == "number" and v28.CLast or 0
			end

			return 0, 0, 0
		end

		return 0, 0, 0
	end

	return 0, 0, 0
end
function module.CooldownRemaining(p8, p9, p10, p11)
	local v36, v37 = module.Read(p8, p9)
	local _remaining = module._remaining
	local v39 = p11 or module.MintCooldown()

	return _remaining(v37, p10, v39)
end
function module._remaining(p12, p13, p14)
	if p12 <= 0 then
		return 0
	end

	if p14 <= 0 then
		return 0
	end

	local n1 = (p13 or os.time()) - p12

	if n1 < 0 then
		return 0
	end

	local n2 = p14 - n1

	return n2 > 0 and n2 or 0
end
function module.CaseCooldownRemaining(p15, p16, p17)
	local v48, v49, v50 = module.Read(p15, p16)

	return module._remaining(v50, p17, module.CaseCooldown())
end
function module.AtCeiling(p18, p19, p20)
	local v54 = p20 or module.MintCeiling()

	if v54 <= 0 then
		return false
	end

	local v55 = module.Read(p18, p19)

	return v54 <= v55
end
function module.PenaltyRemaining(p21, p22, p23)
	if not module.PenaltyEnforced() then
	elseif typeof(p21) == "table" then
		local collectibleMints = p21.CollectibleMints

		if typeof(collectibleMints) == "table" then
			local v60 = collectibleMints[p22]

			if typeof(v60) == "table" and typeof(v60.PenUntil) == "number" then
				local penUntil = v60.PenUntil
				local v62 = p23 or os.time()
				local n1 = penUntil - v62

				return n1 > 0 and n1 or 0
			end

			return 0
		end

		return 0
	end

	return 0
end
function module.CheckMint(p24, p25, p26)
	local v67 = module.PenaltyRemaining(p24, p25, p26)

	if v67 > 0 then
		return "Penalized", v67
	end

	if module.AtCeiling(p24, p25) then
		return "Ceiling", 0
	end

	v67 = module.CooldownRemaining(p24, p25, p26)

	if v67 > 0 then
		return "Cooldown", v67
	end

	return "Ok", 0
end
local function ensureRecord(p27, p28)
	if typeof(p27) == "table" then
		if typeof(p27.CollectibleMints) ~= "table" then
			p27.CollectibleMints = {}
		end

		local collectibleMints = p27.CollectibleMints
		local t4 = collectibleMints[p28]

		if typeof(t4) ~= "table" then
			t4 = { N = 0, Last = 0, CLast = 0 }
			collectibleMints[p28] = t4
		end

		return t4
	end

	return nil
end
function module.RecordPreDropAbuse(p29, p30, p31)
	if not module.PenaltyEnforced() then
		return 0
	end

	local v75 = ensureRecord(p29, p30)

	if not v75 then
		return 0
	end

	v75.PenN = (typeof(v75.PenN) == "number" and v75.PenN or 0) + 1

	local v76 = module.PenaltyBase()
	local v77 = math.min(v76 * 2 ^ (v75.PenN - 1), module.PenaltyCap())

	v75.PenUntil = (p31 or os.time()) + v77

	return v77
end
function module.Record(p32, p33, p34)
	local v81 = ensureRecord(p32, p33)

	if not v81 then
		return
	end

	v81.N = (typeof(v81.N) == "number" and v81.N or 0) + 1
	v81.Last = p34 or os.time()
end
function module.RecordCasePull(p35, p36, p37)
	local v85 = ensureRecord(p35, p36)

	if not v85 then
		return
	end

	v85.CLast = p37 or os.time()
end
function module.IsCaseRushActive(p38, p39)
	if typeof(p38) == "number" then
		local v88 = p39 or os.time()

		return p38 <= v88 and v88 - p38 < module.CaseRushWindow()
	end

	return false
end
function module.CaseBlocked(p40, p41, p42, p43, p44)
	if not module.IsCaseRushActive(p42, p43) then
		return false
	end

	return module.CaseCooldownRemaining(p40, p41, p44) > 0
end
function module.FormatWait(p45)
	local roundedUp = math.ceil(p45)
	local v96 = math.max(0, roundedUp)

	if v96 < 60 then
		return ("%ds"):format(v96)
	end

	return ("%dm %02ds"):format(v96 // 60, v96 % 60)
end

return module
