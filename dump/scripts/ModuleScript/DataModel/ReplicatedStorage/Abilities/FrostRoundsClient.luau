-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local module: {[any]: any} = {
	PARAMS = {
		totalShots = 3,
		perShotCooldown = 0.15,
		damageHead = 100,
		damageBody = 75,
		damageLeg = 50,
		slowPctPerStack = 0.33,
		stacksPerHit = 2,
		slowDuration = 3
	}
}

function module.Cast(player)
	task.spawn(function()
		local Character = player.Character

		if not Character then
		elseif not Character:FindFirstChild("HumanoidRootPart") then
			return
		end
	end)

	local v5 = player.Backpack:FindFirstChild("Revolver") or player.Character:FindFirstChild("Revolver")

	if v5 then
		player.Character.Humanoid:EquipTool(v5)
	end

	local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
	local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
	local abilityEffectClient = require(replicatedStorage:WaitForChild("AbilityEffectClient"))
	local frostRounds = abilityCatalog.Get("FrostRounds")

	v5 = abilityEffectClient.MakeEffectKey()
	abilityEffectClient.PredictGrant({
		id = "Frost",
		appliesTo = "bullet",
		usesLeft = 1,
		effectKey = v5,
		duration = frostRounds and frostRounds.PendingExpiration,
		params = module.PARAMS
	})

	return v5
end

return module
