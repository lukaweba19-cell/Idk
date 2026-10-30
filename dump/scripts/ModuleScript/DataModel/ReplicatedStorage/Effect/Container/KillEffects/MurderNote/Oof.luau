-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local t1: {[any]: any} = { OofDelay = 0.45 }

return function(player, _, _)
	local Character = player.Character
	local v7 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v7 then
		return
	end

	local v8 = Character:FindFirstChild("Head") or v7

	task.delay(0.45, function()
		if not Character.Parent or not v8.Parent then
			return
		end

		sound:Play("KillEffects.MurderNote.Oof", v8, 60, nil, 1, 0.03)
	end)
end
