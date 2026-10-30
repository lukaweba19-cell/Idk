-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local misc = require(game.ReplicatedStorage.Util.Misc)

require(game.ReplicatedStorage.Util.Debris)

local stopSoundOnToolEquip = require(game.ReplicatedStorage.Util.StopSoundOnToolEquip)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local knife = p4.Knife
	local v11 = p4.Position

	if not p4.Toggle then
		pcall(function()
			knife.PORTALVFX:Destroy()
		end)
	elseif (workspace.CurrentCamera.CFrame.p - knife.Position).Magnitude < 1000 then
		task.spawn(function()
			local clone = game.ReplicatedStorage.FX.AbilityFX.Portal.VFX:Clone()

			clone:SetAttribute("FromAbilityCast", true)
			clone.Name = "PORTALVFX"
			clone.Parent = knife
			misc.EmitAll(clone)

			local v13 = sound:Play("Abilities.PortalKnife", knife)

			if p4.Throwing then
				return
			end

			stopSoundOnToolEquip.Bind(v13, p4.Root and p4.Root.Parent, "Knife")
			clone.AncestryChanged:Once(function()
				v13:FadeOut(0.05)
			end)
		end)

		return
	end
end
