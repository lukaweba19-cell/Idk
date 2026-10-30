-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Lightning)

local mesh = game.ReplicatedStorage.FX.KillEffects.Eruption.Mesh

Color3.fromRGB(87, 98, 117)

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local rayCast = require(game.ReplicatedStorage.Util.RayCast)
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Include
raycastParams.FilterDescendantsInstances = {}

local function hideCharacter(p1, p2)
	for _, v in pairs(p1:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			local tweenInfo = TweenInfo.new(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

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
			local tweenInfo = TweenInfo.new(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(v, tweenInfo, { Transparency = 1 }):Play()
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

	local v17 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v17 then
		return
	end

	local _fx_Eruption: Folder = Instance.new("Folder")

	_fx_Eruption.Name = "_FX_Eruption"
	_fx_Eruption.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_Eruption:Destroy()
		end
	end)
	debris:AddItem(_fx_Eruption, 7)

	local v19 = v17.Position
	local v20 = Character.Torso.CFrame
	local v21, v22, v23 = rayCast(v17.Position, Vector3.new(-0, -20, -0))

	if v21 then
		local clone = mesh.Volcano:Clone()
		local v25, v26, v27 = v20:ToEulerAnglesYXZ()
		local cFrame = CFrame.new(v22)
		local v29 = CFrame.Angles(0, v26, 0)
		local v30 = CFrame.Angles(0, -1.5707963267948966, 0)

		clone.CFrame = cFrame * v29 * v30
		misc.EmitAll(clone)
		clone.Parent = _fx_Eruption
		sound:Play("KillEffects.Volcano", clone, nil, nil, nil, nil)

		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

		tweenService:Create(clone, tweenInfo, { Size = Vector3.new(14, 9, 14) }):Play()

		local tweenInfo2 = TweenInfo.new(0.217, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(clone, tweenInfo2, { CFrame = clone.CFrame * CFrame.new(0, 3.737, 0) }):Play()
		task.spawn(function()
			task.wait(1)

			local tweenInfo3 = TweenInfo.new(0.833, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

			tweenService:Create(clone, tweenInfo3, { CFrame = clone.CFrame * CFrame.new(0, -3.737, 0) }):Play()

			local tweenInfo4 = TweenInfo.new(0.833, Enum.EasingStyle.Back, Enum.EasingDirection.In)

			tweenService:Create(clone, tweenInfo4, { Size = Vector3.new(7, 0, 7) }):Play()
			task.wait(0.6)

			local tweenInfo5 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

			tweenService:Create(clone, tweenInfo5, { Transparency = 1 }):Play()
		end)
		task.spawn(function()
			clone.Light.PointLight.Brightness = 25

			local pointLight = clone.Light.PointLight
			local tweenInfo6 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

			tweenService:Create(pointLight, tweenInfo6, { Brightness = 0 }):Play()

			local v52 = clone.Light.PointLight
			local tweenInfo7 = TweenInfo.new(1.333, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(v52, tweenInfo7, { Range = 0 }):Play()
		end)
		task.spawn(function()
			task.wait(0.55)

			local cloneSurfaceAppearance = clone.SurfaceAppearance
			local tweenInfo8 = TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color3 = Color3.fromRGB(0, 0, 0)

			tweenService:Create(cloneSurfaceAppearance, tweenInfo8, { Color = color3 }):Play()
		end)
	end

	local clone = mesh.Strike:Clone()

	debris:AddItem(clone, 2)

	local v34 = Character.Torso.CFrame
	local v35, v36, v37 = rayCast(v17.Position, Vector3.new(-0, -20, -0))

	if v35 then
		local v38, v39, v40 = v34:ToEulerAnglesYXZ()
		local cFrame = CFrame.new(v36)
		local v42 = CFrame.Angles(0, v39, 0)
		local v43 = CFrame.Angles(0, -1.5707963267948966, 0)

		clone.CFrame = cFrame * v42 * v43
		misc.EmitAll(clone)
		clone.Parent = _fx_Eruption
	end

	for _, v in pairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			local clone2 = mesh.SpreadLava:Clone()

			clone2.Parent = v
			task.delay(2.5, function()
				clone2.Enabled = false
			end)
		end
	end
end
