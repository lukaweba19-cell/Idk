-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local httpService: HttpService = game:GetService("HttpService")
local t1: {[any]: any} = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Secret" }
local module: {[any]: any} = { NEIGHBOURHOOD = 4 }
local t3: {[any]: any} = {}

for i = -module.NEIGHBOURHOOD, module.NEIGHBOURHOOD do
	if i ~= 0 then
		table.insert(t3, i)
	end
end

local u7 = nil
local t4: {[any]: any} = {}

local function loadPools()
	if u7 then
		return u7
	end

	local fx: Instance = replicatedStorage:FindFirstChild("FX")
	local caseFillerPools: Instance = fx and fx:FindFirstChild("CaseFillerPools")

	if not caseFillerPools or not caseFillerPools:IsA("StringValue") then
		return nil
	end

	local ok, result = pcall(function()
		return httpService:JSONDecode(caseFillerPools.Value)
	end)

	if ok and typeof(result) == "table" then
		u7 = result
	end

	return u7
end
local function tiersFor(p1)
	local v18 = t4[p1]

	if v18 == nil then
		local v19 = loadPools()

		if not v19 then
			return nil
		end

		local v20 = v19[p1]

		if typeof(v20) == "table" and typeof(v20.Pools) == "table" and typeof(v20.Odds) == "table" then
			local t5: {[any]: any} = {}
			local t6: {[any]: any} = {}
			local n1 = 0

			for _, v in ipairs(t1) do
				local v26 = v20.Odds[v]
				local v27 = v20.Pools[v]

				if typeof(v26) == "number" and v26 > 0 and typeof(v27) == "table" and #v27 > 0 then
					n1 += v26
					table.insert(t5, v)
					table.insert(t6, n1)
				end
			end

			if n1 <= 0 or #t5 == 0 then
				t4[p1] = false

				return nil
			end

			local t7: {[any]: any} = { names = t5, cumulative = t6, total = n1, pools = v20.Pools }

			t4[p1] = t7

			return t7
		end

		t4[p1] = false

		return nil
	end

	return v18 ~= false and v18 or nil
end
local function draw(p2, p3)
	local n1 = p2:NextNumber() * p3.total
	local n2 = #p3.names

	for i, v in ipairs(p3.cumulative) do
		if n1 <= v then
			n2 = i

			break
		end
	end

	n1 = p3.names[n2]
	n2 = p3.pools[n1]

	local v35 = p2:NextInteger(1, #n2)
	local v36 = n2[v35]

	return n1, v36[1], v36[2]
end
local function drawNeighbourhood(p4, p5)
	local t8: {[any]: any} = {}

	for _, v in ipairs(t3) do
		local v42, v43, name = draw(p4, p5)

		t8[v] = { Rarity = v42, Icon = v43, Name = name }
	end

	return t8
end
function module.Ready()
	return loadPools() ~= nil
end
function module.Neighbourhood(p6, p7)
	local v47 = tiersFor(p6)

	if not v47 then
		return nil
	end

	local random = Random.new(p7)

	return (drawNeighbourhood(random, v47))
end
function module.Build(p8, p9, p10)
	local v52 = tiersFor(p8)

	if not v52 then
		return nil, nil, nil
	end

	local random = Random.new(p9)
	local v54 = drawNeighbourhood(random, v52)
	local v55 = table.create(p10)
	local v56 = table.create(p10)

	for i = 1, p10 do
		local v58, v59 = draw(random, v52)

		v56[i] = v58
		v55[i] = v59
	end

	return v54, v55, v56
end

return module
