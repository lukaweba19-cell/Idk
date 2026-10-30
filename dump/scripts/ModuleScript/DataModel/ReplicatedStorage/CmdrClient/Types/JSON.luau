-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local httpService: HttpService = game:GetService("HttpService")

return function(p1)
	p1:RegisterType("json", {
		Validate = function(p2)
			return pcall(httpService.JSONDecode, httpService, p2)
		end,
		Parse = function(p3)
			return httpService:JSONDecode(p3)
		end
	})
end
