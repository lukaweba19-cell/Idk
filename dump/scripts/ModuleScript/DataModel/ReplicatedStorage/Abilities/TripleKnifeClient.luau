-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("TweenService")
game:GetService("RunService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local t1: {[any]: any} = {}
local CurrentCamera: Camera = workspace.CurrentCamera

require(replicatedStorage:WaitForChild("Sound"))

return {
	Cast = function(player)
		task.spawn(function()
			local Character = player.Character

			if not Character then
			elseif not Character:FindFirstChild("HumanoidRootPart") then
				return
			end
		end)

		local v6 = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")

		if v6 then
			player.Character.Humanoid:EquipTool(v6)
		end

		local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
		local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
		local abilityEffectClient = require(replicatedStorage:WaitForChild("AbilityEffectClient"))
		local tripleKnife = abilityCatalog.Get("TripleKnife")

		v6 = abilityEffectClient.MakeEffectKey()
		abilityEffectClient.PredictGrant({
			id = "Shotgun",
			appliesTo = "throw",
			usesLeft = 1,
			effectKey = v6,
			duration = tripleKnife and tripleKnife.PendingExpiration,
			params = { pellets = 3, spreadDeg = 6 }
		})

		return v6
	end
}
