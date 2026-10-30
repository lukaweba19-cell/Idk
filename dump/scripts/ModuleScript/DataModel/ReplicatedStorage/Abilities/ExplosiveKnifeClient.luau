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

local module: {[any]: any} = {
	PARAMS = {
		radius = 12.5,
		killFrac = 0.5,
		damage = 100,
		edgeDamage = 75,
		selfDamage = 25,
		edgeKnockback = 42.5,
		edgeKnockbackMin = 42.5,
		selfKnockback = 42.5,
		selfKnockbackMin = 42.5,
		knockbackUp = 25,
		knockbackHorizontalMult = 2,
		enemyKnockbackScale = 0.4
	},
	KnockbackVelocity = function(p1, p2, p3, p4, p5, p6)
		local n1 = p3 - p2
		local magnitude = n1.Magnitude
		local v14 = math.clamp(p4, 0, 1)
		local numberValue: number? = tonumber(p1 and p1.knockbackUp)
		local numberValue2 = tonumber(p1 and p1.knockbackHorizontalMult) or 1
		local n2 = (magnitude > 0.001 and n1 / magnitude or Vector3.new(0, 1, 0)) * (p5 + (p6 - p5) * v14)
		local vector3 = Vector3.new(n2.X * numberValue2, n2.Y + (numberValue or 38), n2.Z * numberValue2)

		return vector3
	end
}

function module.Cast(player)
	task.spawn(function()
		local Character = player.Character

		if not Character then
		elseif not Character:FindFirstChild("HumanoidRootPart") then
			return
		end
	end)

	local v20 = player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")

	if v20 then
		player.Character.Humanoid:EquipTool(v20)
	end

	local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
	local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
	local abilityEffectClient = require(replicatedStorage:WaitForChild("AbilityEffectClient"))
	local explosiveKnife = abilityCatalog.Get("ExplosiveKnife")

	v20 = abilityEffectClient.MakeEffectKey()
	abilityEffectClient.PredictGrant({
		id = "Explosive",
		appliesTo = "throw",
		usesLeft = 1,
		effectKey = v20,
		duration = explosiveKnife and explosiveKnife.PendingExpiration,
		params = module.PARAMS
	})

	return v20
end

return module
