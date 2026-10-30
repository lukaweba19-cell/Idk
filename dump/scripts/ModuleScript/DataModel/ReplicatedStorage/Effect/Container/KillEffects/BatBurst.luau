-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local burst = game.ReplicatedStorage.FX.KillEffects.BatBurst.Burst

local function hideCharacter(p1)
	for _, v in pairs(p1:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
end

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local _fx_BatBurst: Folder = Instance.new("Folder")

	_fx_BatBurst.Name = "_FX_BatBurst"
	_fx_BatBurst.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_BatBurst:Destroy()
		end
	end)
	debris:AddItem(_fx_BatBurst, 7)

	local v12 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v12 then
		return
	end

	v12.Anchored = true
	sound:Play("KillEffects.BatBurst", v12)

	local clone = burst:Clone()

	clone.CFrame = CFrame.new(v12.Position)
	clone.Parent = _fx_BatBurst
	misc.EmitAll(clone)
	hideCharacter(Character)
end
