-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local chromaPillar = game.ReplicatedStorage.FX.KillEffects.ChromaPillar
local chromaPillarMesh = chromaPillar.Mesh
local chromaPillarSounds = chromaPillar.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
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
		local _fx_ChromaPillar: Folder = Instance.new("Folder")

		_fx_ChromaPillar.Name = "_FX_ChromaPillar"
		_fx_ChromaPillar.Parent = workspace.Bin
		debris:AddItem(_fx_ChromaPillar, 7)
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_ChromaPillar:Destroy()
			end
		end)

		local v27 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		v27.Anchored = true
		sound:Play("KillEffects.Chroma", v27)

		local clone = chromaPillar.Mesh.Beam:Clone()
		local clonePrimaryPart = clone.PrimaryPart
		local cFrame = Character.PrimaryPart.CFrame
		local v31 = CFrame.Angles(1.5707963267948966, 0, 0)

		clonePrimaryPart.CFrame = cFrame * v31
		clone.Parent = _fx_ChromaPillar
		misc.EmitAll(clone)

		local pointLight = clone.PrimaryPart.light.PointLight
		local tweenInfo = TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
		task.spawn(function()
			local t2: {[any]: any} = {}

			for _, v in pairs(clone:GetDescendants()) do
				if v:IsA("Beam") then
					t2[v] = { Width0 = v.Width0, Width1 = v.Width1 }
				end
			end

			for iterKey in pairs(t2) do
				local tweenInfo2 = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In)

				tweenService:Create(iterKey, tweenInfo2, { Width1 = 0, Width0 = 0 }):Play()
			end
		end)

		if Character and Character.Parent then
			hideCharacter(Character)
		end

		local clone2 = chromaPillar.Mesh.Beam2:Clone()
		local clone2PrimaryPart = clone2.PrimaryPart
		local v36 = Character.PrimaryPart.CFrame
		local v37 = CFrame.Angles(1.5707963267948966, 0, 0)

		clone2PrimaryPart.CFrame = v36 * v37
		clone2.Parent = _fx_ChromaPillar
		misc.EmitAll(clone2)
		task.spawn(function()
			local v43 = clone2
			local tweenService2: TweenService = game:GetService("TweenService")
			local numberValue: NumberValue = Instance.new("NumberValue")

			numberValue.Value = v43:GetScale()

			local tweenInfo3 = TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			local v47: Tween = tweenService2:Create(numberValue, tweenInfo3, { Value = 0.01 })

			v47.Completed:Connect(function()
				numberValue:Destroy()
			end)
			v47:Play()
			numberValue:GetPropertyChangedSignal("Value"):Connect(function()
				v43:ScaleTo(numberValue.Value)
			end)
		end)
	end
end
