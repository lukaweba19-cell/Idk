-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local t1: {[any]: any} = {
	Years = 31556926,
	Months = 2629744,
	Weeks = 604800,
	Days = 86400,
	Hours = 3600,
	Minutes = 60,
	Seconds = 1
}
local t2: {[any]: any} = {}

for k, _ in pairs(t1) do
	table.insert(t2, k)
end

local v6 = util.MakeFuzzyFinder(t2)

local function stringToSecondDuration(p1)
	if p1 == nil or p1 == "" then
		return nil
	end

	if tonumber(p1) and tonumber(p1) == 0 then
		return 0, 0, true
	end

	local v11 = p1:gsub("-?%d+%a+", ""):match("-?%d+")

	if v11 then
		return nil, tonumber(v11), true
	end

	v11 = nil

	local v12 = nil

	for iterValue in p1:gmatch("-?%d+%a+") do
		local v14, v15 = iterValue:match("(-?%d+)(%a+)")

		v12 = v14

		local v16 = v15
		local v17 = v6(v16)

		if #v17 == 0 then
			return nil, (tonumber(v12))
		end

		if v11 == nil then
			v11 = 0
		end

		local n1

		if v16:lower() == "m" then
			n1 = 60
		else
			n1 = t1[v17[1]]
		end

		local numberValue: number? = tonumber(v12)

		v11 += n1 * numberValue
	end

	if v11 == nil then
		return nil
	end

	local numberValue2: number? = tonumber(v12)

	return v11, numberValue2
end
local function mapUnits(p2, p3, p4, p5)
	local v25 = p5 or 1
	local t4: {[any]: any} = {}

	for k, v in pairs(p2) do
		if p4 == 1 then
			local substring = v:sub(v25, #v - 1)

			t4[k] = p3 .. substring
		else
			local substring = v:sub(v25)

			t4[k] = p3 .. substring
		end
	end

	return t4
end

local t3: {[any]: any} = {
	Transform = function(p6)
		return p6, stringToSecondDuration(p6)
	end,
	Validate = function(_, p8)
		return p8 ~= nil
	end,
	Autocomplete = function(p9, p10, p11, p12, p13)
		local t5 = {}

		if not p12 and not p13 then
			if p10 ~= nil then
				local v40 = p9:match("^.*-?%d+(%a+)%s?$")
				local v41 = v6(v40)

				t5 = mapUnits(v41, p9, p11, #v40 + 1)
				table.sort(t5)
			end

			return t5
		end

		local v42 = p12 == true and v6("") or p13

		if p12 == true then
			return (mapUnits(v42, p9, p11))
		end

		local v43 = p9:match("^.*(%a+)$"):len()

		return (mapUnits(v42, p9, v43 + 1))
	end,
	Parse = function(_, p15)
		return p15
	end
}

return function(p16)
	p16:RegisterType("duration", t3)
	p16:RegisterType("durations", util.MakeListableType(t3))
end
