-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local color3 = Color3.fromRGB(90, 14, 255)
local glass = Enum.Material.Glass
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local mesh = game.ReplicatedStorage.FX.KillEffects.Purple.Mesh
local misc = require(game.ReplicatedStorage.Util.Misc)

require(game.ReplicatedStorage.Util.Debris)

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local parent = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")
	local clone = mesh.Purple:Clone()

	clone.Parent = Character:FindFirstChild("HumanoidRootPart")
	misc.EmitAll(clone)
	sound:Play("KillEffects.Goldify", parent, nil, nil, nil, 0.18)

	local t1: {[any]: any} = {}

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = glass
			tweenService:Create(v, tweenInfo, { Color = color3 }):Play()
			v.Reflectance = 0.2
		end

		if v:IsA("SpecialMesh") or v:IsA("FileMesh") or v:IsA("Mesh") then
			v.TextureId = ""
		end

		if v:IsA("MeshPart") and v:FindFirstAncestorOfClass("Accessory") then
			v.TextureID = ""
			v.Material = glass
			v.Color = color3
			v.Reflectance = 0.2
		end

		if v:IsA("Texture") or v:IsA("Decal") or v:IsA("SurfaceAppearance") then
			table.insert(t1, v)
		end

		if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
			table.insert(t1, v)
		end
	end

	for _, v in ipairs(t1) do
		v:Destroy()
	end

	if parent then
		for _, v in ipairs(Character:GetDescendants()) do
			if v:IsA("BallSocketConstraint") then
				v:Destroy()
			end
		end

		for _, v in ipairs(Character:GetDescendants()) do
			if v:IsA("BasePart") and v ~= parent and v.Name ~= "HumanoidRootPart" then
				local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

				weldConstraint.Part0 = parent
				weldConstraint.Part1 = v
				weldConstraint.Parent = parent
			end
		end
	end

	task.delay(2, function()
		for _, v in ipairs(Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Velocity = Vector3.new(0, 0, 0)
				v.RotVelocity = Vector3.new(0, 0, 0)
				v.Anchored = true
			end
		end
	end)
end
