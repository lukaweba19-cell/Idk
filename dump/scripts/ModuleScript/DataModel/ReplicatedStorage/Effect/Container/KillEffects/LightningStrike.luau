-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local lightning = require(game.ReplicatedStorage.Util.Lightning)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local v5 = game.ReplicatedStorage.FX.KillEffects.Lightning
local mesh = v5.Mesh

Color3.fromRGB(87, 98, 117)

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local rayCast = require(game.ReplicatedStorage.Util.RayCast)
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Include
raycastParams.FilterDescendantsInstances = {}

local color3 = Color3.fromRGB(140, 170, 255)
local color32 = Color3.fromRGB(121, 146, 255)
local v13 = lightning.Storm({
	SpawnRate = NumberRange.new(1, 1),
	StartVolume = workspace.Terrain,
	EndVolume = workspace.Terrain
}, {
	Branch_ThicknessFactor = 0.8,
	Branch_ThicknessRandomness = 0.5,
	AnimationType = "Sway",
	Sway_MaxOffsetFactor = 0.06,
	Sway_FalloffPower = 5.4,
	Raycast = false,
	FolderName = "LightningKillFX",
	Segments = NumberRange.new(10, 16),
	Jaggedness = NumberRange.new(0.1, 0.2),
	Curvature = NumberRange.new(0.08, 0.15),
	CurveBreaks = NumberRange.new(1, 3),
	Thickness = NumberRange.new(0.4, 0.8),
	Color = { color3, color32, Color3.fromRGB(129, 158, 255) },
	Material = Enum.Material.Neon,
	SpawnDur = NumberRange.new(0.02, 0.05),
	Lifetime = NumberRange.new(0.07, 0.1),
	FadeTime = NumberRange.new(0.4, 0.6),
	Branch_Amount = NumberRange.new(3, 6),
	Branch_Span = NumberRange.new(3, 18),
	Branch_Segments = NumberRange.new(4, 8),
	Branch_LengthFactor = NumberRange.new(0.15, 0.35),
	Sway_Grabs = NumberRange.new(2, 4),
	RaycastParams = raycastParams,
	Parent = workspace.Bin
})

v13:SetConfig({ Raycast = false })

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

	local v23 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v23 then
		return
	end

	local _fx_LightningStrike: Folder = Instance.new("Folder")

	_fx_LightningStrike.Name = "_FX_LightningStrike"
	_fx_LightningStrike.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_LightningStrike:Destroy()
		end
	end)
	debris:AddItem(_fx_LightningStrike, 7)

	local v25 = v23.Position
	local clone = mesh.cloud:Clone()

	clone.Name = "LightningCloud"
	clone.Size = Vector3.new(0, 0, 0)
	clone.CFrame = CFrame.new(v25 + Vector3.new(0, 14, 0))
	clone.Anchored = true
	clone.CanCollide = false
	clone.CanQuery = false
	clone.CanTouch = false
	clone.Parent = _fx_LightningStrike
	debris:AddItem(clone, 3)

	local lightningTarget: Part = Instance.new("Part")

	lightningTarget.Name = "LightningTarget"
	lightningTarget.Size = Vector3.new(0.5, 0.5, 0.5)
	lightningTarget.CFrame = v23.CFrame * CFrame.new(0, -2, 0)
	lightningTarget.Anchored = true
	lightningTarget.CanCollide = false
	lightningTarget.CanQuery = false
	lightningTarget.CanTouch = false
	lightningTarget.Transparency = 1
	lightningTarget.Parent = _fx_LightningStrike
	debris:AddItem(lightningTarget, 3)
	misc.EmitAll(clone)
	task.spawn(function()
		clone.Transparency = 0

		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(clone, tweenInfo, { Size = Vector3.new(13, 6, 13) }):Play()
		task.spawn(function()
			task.wait(0.1)

			local tweenInfo2 = TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local color33 = Color3.fromRGB(162, 174, 218)

			tweenService:Create(clone, tweenInfo2, { Color = color33 }):Play()
			task.wait(0.05)

			local tweenInfo3 = TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local color34 = Color3.fromRGB(87, 98, 117)

			tweenService:Create(clone, tweenInfo3, { Color = color34 }):Play()
			task.wait(0.05)

			local tweenInfo4 = TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local color35 = Color3.fromRGB(162, 174, 218)

			tweenService:Create(clone, tweenInfo4, { Color = color35 }):Play()
			task.wait(0.05)

			local tweenInfo5 = TweenInfo.new(0.05, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local color36 = Color3.fromRGB(87, 98, 117)

			tweenService:Create(clone, tweenInfo5, { Color = color36 }):Play()
		end)
		task.delay(0.6, function()
			local tweenInfo6 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			tweenService:Create(clone, tweenInfo6, { Size = Vector3.new(0, 0, 0) }):Play()
		end)
	end)
	v13:Strike(clone.Position, lightningTarget.Position)

	local clone2 = mesh.Strike:Clone()

	debris:AddItem(clone2, 2)

	local v29 = Character.Torso.CFrame
	local v30, v31, v32 = rayCast(v23.Position, Vector3.new(-0, -20, -0))

	if v30 then
		local v33, v34, v35 = v29:ToEulerAnglesYXZ()
		local cFrame = CFrame.new(v31)
		local v37 = CFrame.Angles(0, v34, 0)
		local v38 = CFrame.Angles(0, -1.5707963267948966, 0)

		clone2.CFrame = cFrame * v37 * v38
		misc.EmitAll(clone2)
		clone2.Parent = _fx_LightningStrike
	end

	local pointLight = clone2.IMPACTBAMP.PointLight
	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	sound:Play("KillEffects.Lightning", v23, nil, nil, nil, 0.18)
	sound:Play("KillEffects.Lightning2", v23, nil, nil, nil, 0.18)
	v23.Anchored = true

	local clone3 = mesh.Skeleton:Clone()

	clone3.Parent = Character
	debris:AddItem(clone3, 3)

	local Head = clone3.Head
	local Torso = clone3.Torso
	local clone3LArm = clone3.LArm
	local clone3RArm = clone3.RArm
	local clone3LLeg = clone3.LLeg
	local clone3RLeg = clone3.RLeg

	for iterFirst, iterSecond in clone3:GetDescendants() do
		if iterSecond:IsA("BasePart") then
			iterSecond.CollisionGroup = "Debris"
		end
	end

	Head.CFrame = Character:FindFirstChild("Head").CFrame
	Head.CFrame = Character:FindFirstChild("Head").CFrame
	Torso.CFrame = Character:FindFirstChild("Torso").CFrame
	clone3LArm.CFrame = Character:FindFirstChild("Left Arm").CFrame
	clone3RArm.CFrame = Character:FindFirstChild("Right Arm").CFrame
	clone3LLeg.CFrame = Character:FindFirstChild("Left Leg").CFrame
	clone3RLeg.CFrame = Character:FindFirstChild("Right Leg").CFrame

	local t1 = {}

	t1 = function(part0, parent)
		local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

		weldConstraint.Part0 = part0
		weldConstraint.Part1 = parent
		weldConstraint.Parent = parent
	end

	local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint.Part0 = Head
	weldConstraint.Part1 = Torso
	weldConstraint.Parent = Torso

	local weldConstraint2: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint2.Part0 = Torso
	weldConstraint2.Part1 = clone3LArm
	weldConstraint2.Parent = clone3LArm

	local weldConstraint3: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint3.Part0 = Torso
	weldConstraint3.Part1 = clone3RArm
	weldConstraint3.Parent = clone3RArm

	local weldConstraint4: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint4.Part0 = Torso
	weldConstraint4.Part1 = clone3LLeg
	weldConstraint4.Parent = clone3LLeg

	local weldConstraint5: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint5.Part0 = Torso
	weldConstraint5.Part1 = clone3RLeg
	weldConstraint5.Parent = clone3RLeg

	local highlightPoolsEffect = highlightPools.Effect
	local color37 = Color3.fromRGB(0, 0, 0)
	local v58 = highlightPoolsEffect:acquire(Character, {
		FillTransparency = 0,
		OutlineTransparency = 1,
		FillColor = color37,
		DepthMode = Enum.HighlightDepthMode.Occluded
	})
	local v59 = highlightPools.Effect:acquire(clone3, {
		FillTransparency = 0,
		OutlineTransparency = 0.05,
		Enabled = false,
		FillColor = Color3.new(1, 1, 1),
		OutlineColor = Color3.new(0, 0, 0),
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	})

	if v58 then
		highlightPools.Effect:releaseAfter(v58, 3)
	end

	if v59 then
		highlightPools.Effect:releaseAfter(v59, 3)
	end

	local color38 = Color3.fromRGB(0, 0, 0)
	local tweenInfo7 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t2: {[any]: any} = {}

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Asphalt
			tweenService:Create(v, tweenInfo7, { Color = color38 }):Play()
		end

		if v:IsA("SpecialMesh") or v:IsA("FileMesh") or v:IsA("Mesh") then
			v.TextureId = ""
		end

		if v:IsA("MeshPart") and v:FindFirstAncestorOfClass("Accessory") then
			v.TextureID = ""
			v.Material = Enum.Material.Asphalt
			v.Color = color38
			v.Reflectance = 0.4
		end

		if v:IsA("Texture") or v:IsA("Decal") or v:IsA("SurfaceAppearance") then
			table.insert(t2, v)
		end

		if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
			table.insert(t2, v)
		end
	end

	for _, v in ipairs(t2) do
		v:Destroy()
	end

	task.spawn(function()
		task.wait(0.05)

		if v58 then
			v58.Enabled = true
		end

		if v59 then
			v59.Enabled = false
		end

		task.wait(0.05)

		if v58 then
			v58.Enabled = false
		end

		if v59 then
			v59.Enabled = true
		end

		task.wait(0.05)

		if v58 then
			v58.Enabled = true
		end

		if v59 then
			v59.Enabled = false
		end

		task.wait(0.05)

		if v58 then
			v58.Enabled = false
		end

		if v59 then
			v59.Enabled = true
		end

		task.wait(0.05)

		if v59 then
			v59.Enabled = false
		end

		if v58 then
			highlightPools.Effect:release(v58)
		end

		if v59 then
			highlightPools.Effect:release(v59)
		end

		for _, v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				local clone4 = v5.Mesh.Fade:Clone()

				clone4.Parent = v
				clone4:Emit(19)
			end
		end

		if Character and Character.Parent then
			hideCharacter(Character, 0.25)
		end
	end)
end
