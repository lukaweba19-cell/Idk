-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("./logger")
local v3: boolean = runService:IsServer()
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local n1: number = 0

local module: {[any]: any} = {
	cache = function(p1)
		local u = p1:GetAttribute("U")

		if u then
			local warn = v2.warn
			local v12 = ("%* is already cached (id=%*)"):format(p1, u)

			warn(v12)

			return
		end

		local v13 = p1:GetAttributes()

		if next(v13) == nil then
			return
		end

		n1 += 1

		local v14: number = n1
		local t5: {[any]: any} = {}

		for iterFirst, iterSecond in v13 do
			if iterFirst ~= "U" then
				t5[iterFirst] = iterSecond
				p1:SetAttribute(iterFirst, nil)
			end
		end

		t1[v14] = t5
		p1:SetAttribute("U", v14)
	end,
	restore = function(p2)
		local u = p2:GetAttribute("U")
		local v20 = t1[u]

		if not v20 then
			local warn = v2.warn
			local v22 = ("%* with cache id '%*' doesn't have any cached attributes"):format(p2, u)

			warn(v22)

			return
		end

		for iterFirst, iterSecond in v20 do
			p2:SetAttribute(iterFirst, iterSecond)
		end

		p2:SetAttribute("U", nil)
	end,
	get = function(p3, p4, p5, p6, p7)
		local u = p3:GetAttribute("U")
		local v31 = t1[u]
		local v32 = v31 and v31[p4]

		if v32 == nil then
			local attributeValue = p3:GetAttribute(p4)

			if p7 then
				attributeValue = p7(attributeValue)
			elseif attributeValue == nil then
				attributeValue = p5
			end

			if not p6 and v3 then
				p3:SetAttribute(p4, attributeValue)
			end

			return attributeValue
		end

		if p7 then
			return (p7(v32))
		end

		if v32 == nil then
			return p5
		end

		return v32
	end
}

function module.getRange(p8, p9, p10, p11, p12)
	return module.get(p8, p9, p10, p12, function(p13)
		if typeof(p13) ~= "NumberRange" then
			return p10
		end

		if p11 then
			local numberRangeNew = NumberRange.new
			local v75 = math.clamp(p13.Min, p11.Min, p11.Max)
			local v76 = math.clamp(p13.Max, p11.Min, p11.Max)

			return numberRangeNew(v75, v76)
		end

		return p13
	end)
end
function module.getEnum(p14, p15, p16, p17, p18)
	return module.get(p14, p15, p16, p18, function(p19)
		if p19 == nil or not table.find(p17, p19) then
			return p16
		end

		return p19
	end)
end
function module.set(p20, p21, p22)
	local u = p20:GetAttribute("U")
	local v48 = t1[u]

	if v48 then
		v48[p21] = p22

		return
	end

	p20:SetAttribute(p21, p22)
end
function module.isCached(p23)
	return p23:GetAttribute("U") ~= nil
end
function module.getState(p24, p25, p26)
	local v53 = t3[p24]
	local v54 = v53 and v53[p25]

	if v54 == nil then
		return p26
	end

	return v54
end
function module.setState(p27, p28, p29)
	local t6 = t3[p27]

	if not t6 then
		t6 = {}
		t3[p27] = t6
	end

	t6[p28] = p29
end
function module.clearState(p30)
	t3[p30] = nil
end
function module.trigger(p31, p32, p33)
	local v63 = t2[p31]
	local v64 = v63 and v63[p32]

	if not v64 then
		return
	end

	for iterFirst, iterSecond in v64 do
		iterSecond(p33)
	end
end
function module.hook(p34, p35, p36)
	local t7 = t2[p34]

	if not t7 then
		t7 = {}
		t2[p34] = t7
	end

	local t8 = t7[p35]

	if not t8 then
		t8 = {}
		t7[p35] = t8
	end

	table.insert(t8, p36)

	local connection = nil

	if not module.isCached(p34) then
		connection = p34:GetAttributeChangedSignal(p35):Connect(function()
			local attributeValue = p34:GetAttribute(p35)

			p36(attributeValue)
		end)
	end

	return function()
		if connection then
			connection:Disconnect()
		end

		local v79 = table.find(t8, p36)

		if v79 then
			table.remove(t8, v79)
		end

		if #t8 == 0 then
			t7[p35] = nil
		end

		if next(t7) == nil then
			t2[p34] = nil
		end
	end
end

return module
