-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {
	{
		id = "HeartAttack",
		weight = 34,
		name = "Heart Attack",
		note = "died of a sudden heart attack"
	},
	{
		id = "CarHit",
		weight = 33,
		name = "Traffic Accident",
		note = "was struck by a speeding car"
	},
	{
		id = "PianoDrop",
		weight = 33,
		name = "Piano Drop",
		note = "was crushed by a falling piano"
	},
	{ id = "Oof", weight = 33, name = "Oof", note = "simply oofed" },
	{
		id = "OldAge",
		weight = 33,
		name = "Old Age",
		note = "died of old age"
	}
}
local module: {[any]: any} = { Pool = t1 }

function module.TotalWeight()
	local n1 = 0

	for iterFirst, iterSecond in module.Pool, nil, nil do
		n1 += iterSecond.weight
	end

	return n1
end

module.TEST_SEQUENTIAL = false

local n1: number = 0

function module.NextTestSeed()
	if not module.TEST_SEQUENTIAL then
		return nil
	end

	n1 += 1

	return n1
end

if module.TEST_SEQUENTIAL then
	warn("[MurderNoteCatalog] TEST_SEQUENTIAL is ON -- MurderNote deaths play in pool order, not weighted. Turn off before shipping.")
end

function module.Pick(p1)
	if module.TEST_SEQUENTIAL then
		return t1[(p1 - 1) % #t1 + 1]
	end

	local v8 = Random.new(p1):NextNumber(0, module.TotalWeight())
	local n1 = 0

	for iterFirst, iterSecond in module.Pool, nil, nil do
		n1 += iterSecond.weight

		if n1 >= v8 then
			return iterSecond
		end
	end

	return module.Pool[#module.Pool]
end
function module.Get(p2)
	for iterFirst, iterSecond in module.Pool, nil, nil do
		if p2 == iterSecond.id then
			return iterSecond
		end
	end

	return nil
end

return module
