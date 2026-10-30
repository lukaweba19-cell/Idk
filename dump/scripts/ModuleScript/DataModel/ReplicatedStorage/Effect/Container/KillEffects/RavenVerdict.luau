-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local ravenVerdict = game.ReplicatedStorage.FX.KillEffects.RavenVerdict
local ravenVerdictMesh = ravenVerdict.Mesh
local ravenVerdictSounds = ravenVerdict.Sounds

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
		local _fx_RavenVerdict: Folder = Instance.new("Folder")

		_fx_RavenVerdict.Name = "_FX_RavenVerdict"
		_fx_RavenVerdict.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_RavenVerdict:Destroy()
			end
		end)
		debris:AddItem(_fx_RavenVerdict, 7)

		local v27 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.RavenVerdict", v27)
		v27.Anchored = true

		local clone = ravenVerdictMesh.Crows:Clone()

		clone.CFrame = v27.CFrame * CFrame.new(0, 0.75, 0)
		misc.EmitAll(clone)
		clone.Parent = _fx_RavenVerdict

		local tweenInfo = TweenInfo.new(2.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local cloneCFrame = clone.CFrame
		local v31 = CFrame.Angles(0, -4.014257279586958, 0)

		tweenService:Create(clone, tweenInfo, { CFrame = cloneCFrame * CFrame.new(0, 1, 0) * v31 }):Play()

		if Character and Character.Parent then
			hideCharacter(Character)
		end
	end
end
