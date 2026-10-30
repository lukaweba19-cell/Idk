-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)
require(game.ReplicatedStorage.Util.Debris)

local stopSoundOnToolEquip = require(game.ReplicatedStorage.Util.StopSoundOnToolEquip)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local knife = p4.Knife

	if not p4.Toggle then
		pcall(function()
			for _, v in pairs(knife:GetChildren()) do
				if v.Name == "FLAMMABLETRIGGER" then
					v:Destroy()
				end
			end
		end)
	elseif (workspace.CurrentCamera.CFrame.p - (p4.Position or knife.Position)).Magnitude < 1000 then
		local v10 = nil

		for _, v in pairs(game.ReplicatedStorage.FX.AbilityFX.Flammable.FirePartKnife:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				local clone = v:Clone()

				clone:SetAttribute("FromAbilityCast", true)
				clone.Name = "FLAMMABLETRIGGER"
				clone.Parent = knife
				v10 = clone
			end
		end

		local v14 = sound:Play("Abilities.FlammableExplodeKnife", knife)

		if p4.Throwing then
			return
		end

		stopSoundOnToolEquip.Bind(v14, p4.Root and p4.Root.Parent, "Knife")
		v10.AncestryChanged:Once(function()
			v14:FadeOut(0.05)
		end)

		return
	end
end
