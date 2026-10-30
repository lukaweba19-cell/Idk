-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local debris = require(game.ReplicatedStorage.Util.Debris)
local color3 = Color3.fromRGB(245, 205, 48)
local color32 = Color3.fromRGB(13, 105, 172)
local color33 = Color3.fromRGB(245, 205, 48)
local color34 = Color3.fromRGB(245, 205, 48)
local color35 = Color3.fromRGB(164, 189, 71)
local color36 = Color3.fromRGB(164, 189, 71)
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1: {[any]: any} = {
	Head = color3,
	Torso = color32,
	["Left Arm"] = color33,
	["Right Arm"] = color34,
	["Left Leg"] = color35,
	["Right Leg"] = color36
}

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local _fx_Noobify: Folder = Instance.new("Folder")

	_fx_Noobify.Name = "_FX_Noobify"
	_fx_Noobify.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_Noobify:Destroy()
		end
	end)
	debris:AddItem(_fx_Noobify, 5)

	local v15 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if v15 then
		sound:Play("KillEffects.Oof", v15)
	end

	local t2: {[any]: any} = {}

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("Accessory") or v:IsA("Hat") then
			local handle = v:FindFirstChild("Handle")

			if handle and handle:IsA("BasePart") then
				tweenService:Create(handle, tweenInfo, { Transparency = 1 }):Play()
			end

			table.insert(t2, v)
		end

		if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
			table.insert(t2, v)
		end

		if v:IsA("Decal") and v.Parent and v.Parent.Name == "Head" then
			table.insert(t2, v)
		end

		if v:IsA("Texture") or v:IsA("SurfaceAppearance") then
			table.insert(t2, v)
		end
	end

	task.delay(0.1, function()
		for _, v in ipairs(t2) do
			if v and v.Parent then
				v:Destroy()
			end
		end
	end)

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			local v22 = t1[v.Name]

			if v22 then
				v.Material = Enum.Material.Plastic
				tweenService:Create(v, tweenInfo, { Color = v22 }):Play()
			end
		end

		if v:IsA("SpecialMesh") or v:IsA("FileMesh") or v:IsA("Mesh") then
			v.TextureId = ""
		end
	end
end
