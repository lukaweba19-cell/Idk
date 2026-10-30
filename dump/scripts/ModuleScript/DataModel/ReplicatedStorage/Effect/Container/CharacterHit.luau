-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local debris = require(game.ReplicatedStorage.Util.Debris)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player)
	local cFrame = player.CFrame
	local Character = player.Character
	local limb = player.Limb

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude < 1000 then
		local clone = script.KillFX:Clone()

		clone.CFrame = cFrame
		clone.Parent = workspace
		debris:AddItem(clone, 1)

		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(v:GetAttribute("EmitCount"))
			end
		end

		local highlightPoolsEffect = highlightPools.Effect
		local v16 = highlightPoolsEffect:acquire(Character, {
			FillTransparency = 0.1,
			OutlineTransparency = 0.6,
			Enabled = true,
			FillColor = Color3.new(1, 1, 1),
			OutlineColor = Color3.new(1, 0.0980392, 0.0980392),
			DepthMode = Enum.HighlightDepthMode.Occluded
		})

		if not v16 then
			return
		end

		highlightPoolsEffect:releaseAfter(v16, 0.3)

		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		local v18: Tween = tweenService:Create(v16, tweenInfo, { FillColor = Color3.new(1, 0.2, 0.2) })

		highlightPoolsEffect:trackTween(v16, v18)
		v18:Play()

		local tweenInfo2 = TweenInfo.new(0.215, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		v18 = tweenService:Create(v16, tweenInfo2, { FillTransparency = 1 })
		highlightPoolsEffect:trackTween(v16, v18)
		v18:Play()

		local tweenInfo3 = TweenInfo.new(0.215, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		v18 = tweenService:Create(v16, tweenInfo3, { OutlineTransparency = 1 })
		highlightPoolsEffect:trackTween(v16, v18)
		v18:Play()

		return
	end
end
