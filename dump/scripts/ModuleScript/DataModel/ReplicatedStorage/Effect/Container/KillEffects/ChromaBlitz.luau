-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")

local players: Players = game:GetService("Players")
local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)

require(game.ReplicatedStorage.Util.HighlightPools)

local chromaBlitz = game.ReplicatedStorage.FX.KillEffects.ChromaBlitz
local knives = game.ReplicatedStorage.Knives
local default = knives:FindFirstChild("Default")

if not default then
	default = knives:GetChildren()[1]
end

game:GetService("TweenService")

local function getKillerKnife(p1)
	local killerUserId = p1:GetAttribute("KillerUserId")

	if not killerUserId then
		return default
	end

	local player: Player = players:GetPlayerByUserId(killerUserId)

	if not player then
		return default
	end

	local knifeSkin: any = player:GetAttribute("KnifeSkin")

	if not knifeSkin then
		return default
	end

	local knifeSkin2 = knives:FindFirstChild(knifeSkin)

	if not knifeSkin2 then
		return default
	end

	return knifeSkin2
end

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	if not Character:FindFirstChild("Torso") then
		return
	end

	local part: Part = Instance.new("Part")

	Character:FindFirstChild("HumanoidRootPart")

	if not Character:FindFirstChild("Torso") and not Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local _fx_ChromaBlitz: Folder = Instance.new("Folder")

	_fx_ChromaBlitz.Name = "_FX_ChromaBlitz"
	_fx_ChromaBlitz.Parent = workspace.Bin
	debris:AddItem(_fx_ChromaBlitz, 7)
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_ChromaBlitz:Destroy()
		end
	end)

	local t1: {[any]: any} = {}

	for _, v in ipairs({ "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }) do
		local v = Character:FindFirstChild(v)

		if v and v:IsA("BasePart") then
			v.Anchored = true
			table.insert(t1, v)
		end
	end

	local cFrame = Character.Torso.CFrame

	part.CFrame = CFrame.new(cFrame.p, cFrame.p - cFrame.LookVector * Vector3.new(1, 0, 1))

	local clone = chromaBlitz.Mesh.Slashes:Clone()

	clone.Parent = _fx_ChromaBlitz
	misc.EmitAll(clone)

	local CFramePosition = workspace.CurrentCamera.CFrame.Position
	local v25 = part.CFrame.Position
	local vector3 = Vector3.new(CFramePosition.X, v25.Y, CFramePosition.Z)

	if (vector3 - v25).Magnitude < 0.01 then
		local partCFrame: CFrame = part.CFrame
		local v28 = CFrame.Angles(0, 3.141592653589793, 0)

		clone.CFrame = partCFrame * v28
	else
		clone.CFrame = CFrame.lookAt(v25, vector3)
	end

	task.spawn(function()
		task.wait(1.125)

		for key, value in t1 do
			value.Anchored = false
		end
	end)
	sound:Play("KillEffects.ChromaBlitz", clone)
end
