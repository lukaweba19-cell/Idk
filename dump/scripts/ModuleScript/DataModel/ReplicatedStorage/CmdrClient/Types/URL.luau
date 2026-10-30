-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Parent.Shared.Util)

local t1: {[any]: any} = {
	Validate = function(p1)
		if p1:match("^https?://.+$") then
			return true
		end

		return false, "URLs must begin with http:// or https://"
	end,
	Parse = function(p2)
		return p2
	end
}

return function(p3)
	p3:RegisterType("url", t1)
	p3:RegisterType("urls", util.MakeListableType(t1))
end
