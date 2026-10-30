-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = { Chance = 0.1 }

function module.ChanceFor(p1)
	local v4 = typeof(p1) == "table" and p1.VariantChance or nil

	if typeof(v4) == "number" then
		return (math.clamp(v4, 0, 1))
	end

	return module.Chance
end

local substitutions: {[any]: any} = {
	Knife = {
		MidnightKatana = "NegativeMidnightKatana",
		RedEnergyBlade = "OmegaEnergyBlade",
		BlueEnergyBlade = "OmegaEnergyBlade",
		GreenEnergyBlade = "OmegaEnergyBlade",
		HeartKeeperKnife = "HeartStealerKnife",
		CatAxe = "WhiteCatAxe"
	},
	Revolver = {
		MidnightCrossbow = "NegativeMidnightCrossbow",
		RedEnergyBlaster = "OmegaEnergyBlaster",
		BlueEnergyBlaster = "OmegaEnergyBlaster",
		GreenEnergyBlaster = "OmegaEnergyBlaster",
		HeartKeeperGun = "HeartStealerGun",
		CatShotgun = "WhiteCatShotgun"
	},
	Finisher = {
		MidnightFlame = "NegativeMidnightFlame",
		EnergyOverchargeRed = "EnergyOverchargeOmega",
		EnergyOverchargeBlue = "EnergyOverchargeOmega",
		EnergyOverchargeGreen = "EnergyOverchargeOmega",
		Beloved = "Heartbreak",
		CatDrop = "WhiteCatDrop"
	}
}

module.Substitutions = substitutions

function module.VariantFor(p2, p3)
	if typeof(p2) == "string" and typeof(p3) == "string" then
		local v7 = substitutions[p2]

		if not v7 then
			return nil
		end

		return v7[p3]
	end

	return nil
end
function module.VariantFinisherFor(p4)
	if typeof(p4) == "string" then
		return substitutions.Finisher[p4]
	end

	return nil
end
function module.RewardsCanVary(p5)
	if typeof(p5) == "table" then
		for _, v in ipairs(p5) do
			if module.VariantFor(v.Kind, v.ItemId) then
				return true
			end

			if module.VariantFinisherFor(v.Finisher) then
				return true
			end
		end

		return false
	end

	return false
end
function module.PackCanVary(p6)
	if typeof(p6) == "table" then
		return module.RewardsCanVary(p6.Rewards)
	end

	return false
end
function module.ApplyTo(p7)
	local t3: {[any]: any} = {}

	for i, v in ipairs(p7) do
		local v17 = table.clone(v)
		local v18 = module.VariantFor(v.Kind, v.ItemId)

		if v18 then
			v17.ItemId = v18
		end

		v18 = module.VariantFinisherFor(v.Finisher)

		if v18 then
			v17.Finisher = v18
		end

		t3[i] = v17
	end

	return t3
end
function module.AllVariantIds()
	local t4: {[any]: any} = {}

	for _, v in pairs(substitutions) do
		for _, iterValue in pairs(v) do
			t4[iterValue] = true
		end
	end

	return t4
end

return module
