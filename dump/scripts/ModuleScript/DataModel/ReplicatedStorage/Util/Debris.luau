-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}
t1 = {}
t1.__index = t1

function t1.AddItem(_, p2, p3, _)
	task.delay(p3, function()
		pcall(game.Destroy, p2)
	end)
end

return t1
