-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)
local enumItems = Enum.UserInputType:GetEnumItems()

for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
	enumItems[#enumItems + 1] = v
end

local t1: {[any]: any} = {
	Transform = function(p1)
		return util.MakeFuzzyFinder(enumItems)(p1)
	end,
	Validate = function(p2)
		return #p2 > 0
	end,
	Autocomplete = function(p3)
		return util.GetNames(p3)
	end,
	Parse = function(p4)
		return p4[1]
	end
}

return function(p5)
	p5:RegisterType("userInput", t1)
	p5:RegisterType("userInputs", util.MakeListableType(t1))
end
