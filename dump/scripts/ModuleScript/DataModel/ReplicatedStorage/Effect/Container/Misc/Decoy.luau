-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")
game:GetService("RunService")

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local t1: {[any]: any} = {}

return function(p1)
	local v6 = p1.Position

	if not p1.Spawned and not p1.Despawned then
		return
	end

	local model = p1.Model
	local v8 = model and model:WaitForChild("Torso", 3) or nil
	local cFrame = nil

	if v8 then
		cFrame = v8.CFrame
	elseif typeof(v6) == "Vector3" then
		cFrame = CFrame.new(v6)
	end

	if not cFrame then
		return
	end

	v6 = function(parent)
		local clone = game.ReplicatedStorage.FX.AbilityFX.Decoy.Smoke:Clone()

		clone.Parent = parent
		misc.EmitAll(clone)
		debris:AddItem(clone, 3)
		sound:Play("Abilities.DecoyPoof", parent)
	end

	local function anchoredAt(cFrame)
		local part: Part = Instance.new("Part")

		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.Transparency = 1
		part.CFrame = cFrame
		part.Parent = workspace.Bin
		debris:AddItem(part, 3)

		return part
	end

	if p1.Spawned and v8 then
		v6(v8)

		return
	end

	local part: Part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.Transparency = 1
	part.CFrame = cFrame
	part.Parent = workspace.Bin
	debris:AddItem(part, 3)
	v6(part)
end
