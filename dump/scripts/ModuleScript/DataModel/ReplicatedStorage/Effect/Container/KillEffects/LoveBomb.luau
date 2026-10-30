-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local loveBomb = game.ReplicatedStorage.FX.KillEffects.LoveBomb
local loveBombMesh = loveBomb.Mesh
local loveBombSounds = loveBomb.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local v9 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v9
}

t1 = function(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local function hideCharacter(p4)
	for _, v in pairs(p4:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") then
				v.Enabled = false
			elseif not v:IsA("BillboardGui") and not v:IsA("SurfaceGui") then
				if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				end
			else
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end
end

v9 = function(parent, animationId)
	if not parent then
		return nil
	end

	local animator = parent:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = parent
	end

	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = animationId

	local animationTrack = animator:LoadAnimation(animation)

	animationTrack:Play()

	return animationTrack
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_LoveBomb: Folder = Instance.new("Folder")

		_fx_LoveBomb.Name = "_FX_LoveBomb"
		_fx_LoveBomb.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_LoveBomb:Destroy()
			end
		end)
		debris:AddItem(_fx_LoveBomb, 7)

		local v28 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		v28.Anchored = true
		sound:Play("KillEffects.LoveBomb", v28)

		local clone = loveBombMesh.HeartBurst:Clone()

		clone.PrimaryPart.CFrame = Character.PrimaryPart.CFrame
		misc.EmitAll(clone)
		clone.Parent = _fx_LoveBomb
		clone.AnimationController:LoadAnimation(loveBomb.Animation):Play()

		local cloneHeart = clone.Heart
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(cloneHeart, tweenInfo, { Size = Vector3.new(4.702, 4.407, 2.023) }):Play()

		local highlightPoolsEffect = highlightPools.Effect
		local heart = clone.Heart
		local color3 = Color3.fromRGB(255, 151, 238)
		local v35 = highlightPoolsEffect:acquire(heart, {
			FillTransparency = 0.8,
			OutlineTransparency = 0,
			FillColor = color3,
			OutlineColor = Color3.new(1, 1, 1),
			DepthMode = Enum.HighlightDepthMode.Occluded
		})

		if v35 then
			highlightPools.Effect:releaseAfter(v35, 0.7)
		end

		task.spawn(function()
			if not v35 then
				return
			end

			local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local color32 = Color3.fromRGB(255, 76, 207)
			local v39: Tween = tweenService:Create(v35, tweenInfo2, { FillColor = color32 })

			highlightPools.Effect:trackTween(v35, v39)
			v39:Play()
			task.wait(0.15)

			local tweenInfo3 = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local color33 = Color3.fromRGB(255, 212, 238)

			v39 = tweenService:Create(v35, tweenInfo3, { FillColor = color33 })
			highlightPools.Effect:trackTween(v35, v39)
			v39:Play()
			task.wait(0.15)

			local tweenInfo4 = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local color34 = Color3.fromRGB(255, 76, 207)

			v39 = tweenService:Create(v35, tweenInfo4, { FillColor = color34 })
			highlightPools.Effect:trackTween(v35, v39)
			v39:Play()
			task.wait(0.15)

			local tweenInfo5 = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local color35 = Color3.fromRGB(255, 212, 238)

			v39 = tweenService:Create(v35, tweenInfo5, { FillColor = color35 })
			highlightPools.Effect:trackTween(v35, v39)
			v39:Play()
		end)

		local clone2 = loveBombMesh.LoveExplode:Clone()

		clone2.CFrame = CFrame.new(Character.PrimaryPart.Position + Vector3.new(0, -2.8, 0))
		clone2.Parent = _fx_LoveBomb
		task.spawn(function()
			task.wait(0.62)
			misc.EmitAll(clone2)

			local pointLight = clone2.IMPACTBAMP.PointLight
			local tweenInfo6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

			tweenService:Create(pointLight, tweenInfo6, { Brightness = 0 }):Play()
			clone:Destroy()
		end)

		if Character and Character.Parent then
			hideCharacter(Character)
		end
	end
end
