-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local v2 = util.MakeDictionary({
	"true",
	"t",
	"yes",
	"y",
	"on",
	"enable",
	"enabled",
	"1",
	"+"
})
local v3 = util.MakeDictionary({
	"false",
	"f",
	"no",
	"n",
	"off",
	"disable",
	"disabled",
	"0",
	"-"
})

local t1: {[any]: any} = {
	Transform = function(p21)
		return p21:lower()
	end,
	Validate = function(p22)
		local u14: boolean = true

		if v2[p22] == nil then
			u14 = v3[p22] ~= nil
		end

		return u14, "Please use true/yes/on or false/no/off."
	end,
	Parse = function(p23)
		if v2[p23] then
			return true
		end

		if v3[p23] then
			return false
		end

		return nil
	end
}

local t2: {[any]: any} = {
	Validate = function(p1)
		return p1 ~= nil
	end,
	Parse = function(p2)
		return (tostring(p2))
	end
}

local t3: {[any]: any} = {
	Transform = function(p3)
		return (tonumber(p3))
	end,
	Validate = function(p4)
		return p4 ~= nil
	end,
	Parse = function(p5)
		return p5
	end
}

local t4: {[any]: any} = {
	Transform = function(p6)
		return (tonumber(p6))
	end,
	Validate = function(p7)
		return p7 ~= nil and p7 == math.floor(p7), "Only whole numbers are valid."
	end,
	Parse = function(p8)
		return p8
	end
}

local t5: {[any]: any} = {
	Transform = function(p9)
		return (tonumber(p9))
	end,
	Validate = function(p10)
		return p10 ~= nil and p10 == math.floor(p10) and p10 > 0, "Only positive whole numbers are valid."
	end,
	Parse = function(p11)
		return p11
	end
}

local t6: {[any]: any} = {
	Transform = function(p12)
		return (tonumber(p12))
	end,
	Validate = function(p13)
		return p13 ~= nil and p13 == math.floor(p13) and p13 >= 0, "Only non-negative whole numbers are valid."
	end,
	Parse = function(p14)
		return p14
	end
}

local t7: {[any]: any} = {
	Transform = function(p15)
		return (tonumber(p15))
	end,
	Validate = function(p16)
		return p16 ~= nil and p16 == math.floor(p16) and p16 >= 0 and p16 <= 255, "Only bytes are valid."
	end,
	Parse = function(p17)
		return p17
	end
}

local t8: {[any]: any} = {
	Transform = function(p18)
		return (tonumber(p18))
	end,
	Validate = function(p19)
		return p19 ~= nil and p19 == math.floor(p19) and p19 >= 0 and p19 <= 9, "Only digits are valid."
	end,
	Parse = function(p20)
		return p20
	end
}

return function(p24)
	p24:RegisterType("string", t2)
	p24:RegisterType("number", t3)
	p24:RegisterType("integer", t4)
	p24:RegisterType("positiveInteger", t5)
	p24:RegisterType("nonNegativeInteger", t6)
	p24:RegisterType("byte", t7)
	p24:RegisterType("digit", t8)
	p24:RegisterType("boolean", t1)
	p24:RegisterType("strings", util.MakeListableType(t2))
	p24:RegisterType("numbers", util.MakeListableType(t3))
	p24:RegisterType("integers", util.MakeListableType(t4))
	p24:RegisterType("positiveIntegers", util.MakeListableType(t5))
	p24:RegisterType("nonNegativeIntegers", util.MakeListableType(t6))
	p24:RegisterType("bytes", util.MakeListableType(t7))
	p24:RegisterType("digits", util.MakeListableType(t8))
	p24:RegisterType("booleans", util.MakeListableType(t1))
end
