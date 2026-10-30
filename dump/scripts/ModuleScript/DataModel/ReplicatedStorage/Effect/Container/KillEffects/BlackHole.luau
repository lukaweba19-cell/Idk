-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)
require(game.ReplicatedStorage.Util.HighlightPools)

local blackHole = game.ReplicatedStorage.FX.KillEffects.BlackHole
local blackHoleMesh = blackHole.Mesh
local blackHoleSounds = blackHole.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)

require(game.ReplicatedStorage.Util.Misc)

local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local v8 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v8
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

v8 = function(parent, animationId)
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

		local v27 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		v27.Anchored = true
		sound:Play("KillEffects.BlackHole", v27)

		local clone = blackHoleMesh.SphereExpand:Clone()

		clone.CFrame = v27.CFrame
		clone.Parent = _fx_LoveBomb

		local clone2 = blackHoleMesh.Start:Clone()
		local cFrame = v27.CFrame
		local v31 = CFrame.Angles(-1.5707963267948966, 0, 0)

		clone2.CFrame = cFrame * v31
		clone2.Parent = _fx_LoveBomb
		clone.Size = Vector3.new(0, 0, 0)

		local tweenInfo = TweenInfo.new(0.917, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

		tweenService:Create(clone, tweenInfo, { Size = Vector3.new(13, 13, 13) }):Play()
		task.spawn(function()
			task.wait(0.917)

			local tweenInfo2 = TweenInfo.new(0.066, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(clone, tweenInfo2, { Size = Vector3.new(25, 25, 25) }):Play()
			task.wait(0.066)

			local tweenInfo3 = TweenInfo.new(0.066, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(clone, tweenInfo3, { Size = Vector3.new(0, 0, 0) }):Play()
		end)
		forgeVFX.emit(clone2)
		task.spawn(function()
			task.wait(1.25)

			local clone3 = blackHoleMesh.SphereX:Clone()

			clone3.CFrame = v27.CFrame
			clone3.Parent = _fx_LoveBomb
			clone3.Size = Vector3.new(15, 15, 15)
			task.spawn(function()
				task.wait(0.067)

				local tweenInfo4 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(clone3, tweenInfo4, { Transparency = 1 }):Play()
			end)
			task.spawn(function()
				local clone3Highlight = clone3.Highlight
				local tweenInfo5 = TweenInfo.new(0.067, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

				tweenService:Create(clone3Highlight, tweenInfo5, { FillTransparency = -15 }):Play()
				task.wait(0.04)

				local tweenInfo6 = TweenInfo.new(0.067, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

				tweenService:Create(clone3Highlight, tweenInfo6, { FillTransparency = 0 }):Play()
			end)
			task.spawn(function()
				local tweenInfo7 = TweenInfo.new(0.167, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(clone3, tweenInfo7, { Size = Vector3.new(35, 35, 35) }):Play()
				task.wait(0.066)

				local tweenInfo8 = TweenInfo.new(0.066, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(clone3, tweenInfo8, { Size = Vector3.new(0, 0, 0) }):Play()
			end)
		end)

		local clone4 = blackHoleMesh.Core:Clone()
		local clone4PrimaryPart = clone4.PrimaryPart
		local v35 = v27.CFrame
		local v36 = CFrame.Angles(-4.537856055185257, 0, 0)

		clone4PrimaryPart.CFrame = v35 * v36
		clone4.Parent = _fx_LoveBomb
		forgeVFX.emit(clone4)
		task.spawn(function()
			task.wait(0.933)

			local clone5 = blackHoleMesh.Preimpact:Clone()

			clone5.CFrame = v27.CFrame
			clone5.Parent = _fx_LoveBomb
			forgeVFX.emit(clone5)
			task.wait(0.3)

			local clone6 = blackHoleMesh.Explode:Clone()

			clone6.PrimaryPart.CFrame = v27.CFrame
			clone6.Parent = _fx_LoveBomb
			forgeVFX.emit(clone6)
		end)

		if Character and Character.Parent then
			hideCharacter(Character)
		end
	end
end
