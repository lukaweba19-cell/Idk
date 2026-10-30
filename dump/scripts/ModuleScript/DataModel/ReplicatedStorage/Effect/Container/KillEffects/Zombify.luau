-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local debris = require(game.ReplicatedStorage.Util.Debris)
local color3 = Color3.fromRGB(122, 155, 92)
local color32 = Color3.fromRGB(95, 72, 54)
local color33 = Color3.fromRGB(52, 58, 94)
local color34 = Color3.fromRGB(52, 58, 94)
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1: {[any]: any} = {
	Head = color3,
	["Left Arm"] = color3,
	["Right Arm"] = color3,
	Torso = color32,
	["Left Leg"] = color33,
	["Right Leg"] = color34
}

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local _fx_Zombify: Folder = Instance.new("Folder")

	_fx_Zombify.Name = "_FX_Zombify"
	_fx_Zombify.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_Zombify:Destroy()
		end
	end)
	debris:AddItem(_fx_Zombify, 5)

	local v14 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if v14 then
		sound:Play("KillEffects.ZombieGrowl", v14)
	end

	local t2: {[any]: any} = {}

	for _, v in ipairs(Character:GetDescendants()) do
		if not v:IsA("Accessory") and not v:IsA("Hat") then
			if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or (v:IsA("Texture") or v:IsA("SurfaceAppearance")) and not v:FindFirstAncestorWhichIsA("Accessory") then
				table.insert(t2, v)
			end
		else
			local handle = v:FindFirstChild("Handle")

			if handle and handle:IsA("BasePart") then
				tweenService:Create(handle, tweenInfo, { Transparency = 1 }):Play()
			end

			table.insert(t2, v)
		end
	end

	task.delay(tweenInfo.Time, function()
		for _, v in ipairs(t2) do
			if v and v.Parent then
				v:Destroy()
			end
		end
	end)

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			local v21 = t1[v.Name]

			if v21 and Character == v.Parent then
				v.Material = Enum.Material.Plastic
				tweenService:Create(v, tweenInfo2, { Color = v21 }):Play()
			end
		elseif (v:IsA("SpecialMesh") or v:IsA("FileMesh")) and v.Parent and Character == v.Parent.Parent then
			v.TextureId = ""
		end
	end
end
