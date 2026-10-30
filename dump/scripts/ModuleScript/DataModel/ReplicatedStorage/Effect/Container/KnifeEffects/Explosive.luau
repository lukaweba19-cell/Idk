-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local stopSoundOnToolEquip = require(game.ReplicatedStorage.Util.StopSoundOnToolEquip)

require(game.ReplicatedStorage.Util.Debris)

local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local knife = p4.Knife

	if not p4.Toggle then
		pcall(function()
			knife.EXPLOSIONVFX:Destroy()
		end)
	elseif (workspace.CurrentCamera.CFrame.p - (p4.Position or knife.Position)).Magnitude < 1000 then
		task.spawn(function()
			local clone = game.ReplicatedStorage.FX.AbilityFX.ExplodingKnife.Fire:Clone()

			clone:SetAttribute("FromAbilityCast", true)
			clone.Name = "EXPLOSIONVFX"
			clone.Parent = knife

			if p4.Throwing then
				return
			end

			task.spawn(function()
				local highlightPoolsEffect = highlightPools.Effect
				local knifeParent = knife.Parent
				local occluded = Enum.HighlightDepthMode.Occluded
				local color3 = Color3.fromRGB(255, 255, 255)
				local v16 = highlightPoolsEffect:acquire(knifeParent, {
					FillTransparency = 0.2,
					OutlineTransparency = 1,
					DepthMode = occluded,
					OutlineColor = color3
				})

				if not v16 then
					return
				end

				local t1: {[any]: any} = { Current = nil }

				stopSoundOnToolEquip.Bind(t1, p4.Root and p4.Root.Parent, "Knife")

				while true do
					task.wait(0.1)

					if not clone:IsDescendantOf(workspace) then
						break
					end

					t1.Current = sound:Play("Abilities.Beeping", knife)
					v16.FillTransparency = 0.2
					v16.OutlineTransparency = 1

					local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear)
					local v19: Tween = tweenService:Create(v16, tweenInfo, { FillTransparency = 1, OutlineTransparency = 1 })

					highlightPoolsEffect:trackTween(v16, v19)
					v19:Play()
					task.wait(0.525)
				end

				highlightPoolsEffect:release(v16)
			end)
		end)

		return
	end
end
