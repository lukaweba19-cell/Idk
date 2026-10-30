-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local starterGui: StarterGui = game:GetService("StarterGui")
local window = require(script.Parent.CmdrInterface.Window)

return function(p1)
	p1:HandleEvent("Message", function(p2)
		local v5 = ("[Announcement] %s"):format(p2)
		local color3 = Color3.fromRGB(249, 217, 56)

		starterGui:SetCore("ChatMakeSystemMessage", { Text = v5, Color = color3 })
	end)
	p1:HandleEvent("AddLine", function(...)
		window:AddLine(...)
	end)
end
