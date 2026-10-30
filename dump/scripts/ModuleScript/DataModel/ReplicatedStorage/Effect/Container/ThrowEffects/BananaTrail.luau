-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local knife = p1.Knife

	task.spawn(function()
		task.wait(0.005)

		local trail = knife:FindFirstChild("Trail")

		if trail then
			trail.Enabled = true
		end

		misc.EmitAll(knife)
	end)
end
