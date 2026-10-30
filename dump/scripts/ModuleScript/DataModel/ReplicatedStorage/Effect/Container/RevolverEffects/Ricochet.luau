-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")
require(game.ReplicatedStorage.Util.Misc)

local stopSoundOnToolEquip = require(game.ReplicatedStorage.Util.StopSoundOnToolEquip)

require(game.ReplicatedStorage.Util.Debris)

return function(p1)
	local model = p1.Model
	local revolver = p1.Revolver

	if not p1.Toggle then
		pcall(function()
			revolver.Parent:FindFirstChild("RevolverMuzzle", true):FindFirstChild("EXPLOSIONVFX"):Destroy()
		end)
	elseif (workspace.CurrentCamera.CFrame.p - revolver.Position).Magnitude < 1000 then
		task.spawn(function()
			local clone = game.ReplicatedStorage.FX.AbilityFX.Ricochet.RevolverMuzzle:Clone()

			clone:SetAttribute("FromAbilityCast", true)
			clone.Name = "EXPLOSIONVFX"
			clone.Parent = revolver.Parent:FindFirstChild("RevolverMuzzle", true)

			local v7 = sound:Play("Abilities.RicochetActivate", revolver)

			stopSoundOnToolEquip.Bind(v7, p1.Root and p1.Root.Parent, "Revolver")
		end)

		return
	end
end
