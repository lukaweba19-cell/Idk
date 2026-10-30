-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local fah = game.ReplicatedStorage.FX.KillEffects.Fah
local fahMesh = fah.Mesh
local fahSounds = fah.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)

require(game.ReplicatedStorage.Util.Misc)

local v7 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v7
}

t1 = function(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local function hideCharacter(p4, p5)
	for _, v in pairs(p4:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			local tweenInfo = TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(v, tweenInfo, { Transparency = 1 }):Play()
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
			local tweenInfo = TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(v, tweenInfo, { Transparency = 1 }):Play()
		end
	end
end

v7 = function(parent, animationId)
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
		local _fx_Fah: Folder = Instance.new("Folder")

		_fx_Fah.Name = "_FX_Fah"
		_fx_Fah.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Fah:Destroy()
			end
		end)
		debris:AddItem(_fx_Fah, 7)

		local v29 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.Fah", v29, nil, nil, nil, 0.18)
		v29.Anchored = true

		for _, v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				local clone = fah.Mesh.Fade:Clone()

				clone.Parent = v
				clone:Emit(35)
			end
		end

		if Character and Character.Parent then
			hideCharacter(Character, 0.25)
		end
	end
end
