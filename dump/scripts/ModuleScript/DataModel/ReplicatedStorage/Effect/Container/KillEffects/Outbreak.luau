-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local mesh = game.ReplicatedStorage.FX.KillEffects.Outbreak.Mesh

local function populate(p1, parent, p3)
	local t2: {[any]: any} = {}
	local attachment = nil

	for _, v in ipairs(p1:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			local clone = v:Clone()

			if p3 then
				if not attachment then
					attachment = Instance.new("Attachment")
					attachment.Name = "_OutbreakPoint"
					attachment.Parent = parent
				end

				clone.Parent = attachment
			else
				clone.Parent = parent
			end

			table.insert(t2, clone)
		elseif v:IsA("Attachment") then
			local clone = v:Clone()

			clone.Parent = parent

			for _, iterValue in ipairs(clone:GetDescendants()) do
				if iterValue:IsA("ParticleEmitter") then
					table.insert(t2, iterValue)
				end
			end
		end
	end

	return t2
end
local function makeAnchor(name, cFrame, p6, parent)
	local part: Part = Instance.new("Part")

	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = p6
	part.CFrame = cFrame
	part.Parent = parent

	return part
end
local function scaleAboutTorso(p8, p9, p10)
	local v30 = p9.Position

	p8:ScaleTo(p10)

	local n1 = v30 - p9.Position

	if n1.Magnitude > 0.05 then
		local pivot = p8:GetPivot()

		p8:PivotTo(pivot + n1)
	end
end
local function hideCharacter(p11)
	for _, v in ipairs(p11:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("Light") then
				if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Highlight") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
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

local t1: {[any]: any} = {
	SpreadTime = 0.9,
	SwellTime = 0.45,
	SwellScale = 1.3,
	LingerTime = 1.4,
	LingerSize = Vector3.new(5, 3.5, 5),
	LightFade = 0.5,
	TintFill = 0.4,
	SkinTint = 0.6,
	TintColor = Color3.fromRGB(115, 255, 29),
	Limbs = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
}

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local v38 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v38 then
		return
	end

	local function alive()
		return Character:IsDescendantOf(workspace) and v38:IsDescendantOf(Character)
	end

	local _fx_Outbreak: Folder = Instance.new("Folder")

	_fx_Outbreak.Name = "_FX_Outbreak"
	_fx_Outbreak.Parent = workspace.Bin
	debris:AddItem(_fx_Outbreak, t1.SpreadTime + t1.SwellTime + t1.LingerTime + 4)
	sound:Play("KillEffects.Outbreak", v38)

	local _OutbreakTint: Highlight = Instance.new("Highlight")

	_OutbreakTint.Name = "_OutbreakTint"
	_OutbreakTint.DepthMode = Enum.HighlightDepthMode.Occluded
	_OutbreakTint.FillColor = t1.TintColor
	_OutbreakTint.OutlineColor = t1.TintColor
	_OutbreakTint.FillTransparency = 1
	_OutbreakTint.OutlineTransparency = 1
	_OutbreakTint.Parent = Character

	local tweenInfo = TweenInfo.new(t1.SpreadTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	tweenService:Create(_OutbreakTint, tweenInfo, { OutlineTransparency = 0, FillTransparency = t1.TintFill }):Play()

	local t3: {[any]: any} = {}

	for _, v in ipairs(t1.Limbs) do
		local v = Character:FindFirstChild(v)

		if v and v:IsA("BasePart") then
			table.insert(t3, v)
		end
	end

	local t4: {[any]: any} = {}
	local n1 = t1.SpreadTime * 0.7
	local v49 = math.max(#t3, 1)

	for i, v in ipairs(t3) do
		task.delay((i - 1) * (n1 / v49), function()
			if not Character:IsDescendantOf(workspace) or not v38:IsDescendantOf(Character) or not v.Parent then
				return
			end

			local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v70 = v.Color:Lerp(t1.TintColor, t1.SkinTint)

			tweenService:Create(v, tweenInfo2, { Color = v70 }):Play()

			local v71 = populate(mesh.Spread, v, false)

			for _, iterValue in ipairs(v71) do
				iterValue.Enabled = true
				table.insert(t4, iterValue)
			end
		end)
	end

	task.wait(t1.SpreadTime)

	if not Character:IsDescendantOf(workspace) or not v38:IsDescendantOf(Character) then
		_fx_Outbreak:Destroy()

		return
	end

	local value = Character:GetScale()
	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = value

	local connection = numberValue:GetPropertyChangedSignal("Value"):Connect(function()
		if Character:IsDescendantOf(workspace) and v38:IsDescendantOf(Character) then
			local v74 = Character
			local v75 = v38
			local v76 = v75.Position

			v74:ScaleTo(numberValue.Value)

			local n1 = v76 - v75.Position

			if n1.Magnitude > 0.05 then
				local pivot = v74:GetPivot()

				v74:PivotTo(pivot + n1)
			end
		end
	end)

	local tweenInfo3 = TweenInfo.new(t1.SwellTime, Enum.EasingStyle.Back, Enum.EasingDirection.In)

	tweenService:Create(numberValue, tweenInfo3, { Value = value * t1.SwellScale }):Play()
	task.wait(t1.SwellTime)
	connection:Disconnect()
	numberValue:Destroy()

	if not Character:IsDescendantOf(workspace) or not v38:IsDescendantOf(Character) then
		_fx_Outbreak:Destroy()

		return
	end

	local cFrame = CFrame.new(v38.Position)

	_OutbreakTint:Destroy()

	for _, v in ipairs(t4) do
		v.Enabled = false
	end

	hideCharacter(Character)

	local burst: Part = Instance.new("Part")

	burst.Name = "Burst"
	burst.Anchored = true
	burst.CanCollide = false
	burst.CanQuery = false
	burst.CanTouch = false
	burst.CastShadow = false
	burst.Transparency = 1
	burst.Size = Vector3.new(0.01, 0.01, 0.01)
	burst.CFrame = cFrame
	burst.Parent = _fx_Outbreak
	populate(mesh.Burst, burst, true)
	misc.EmitAll(burst)

	for _, v in ipairs(burst:GetDescendants()) do
		if v:IsA("Light") then
			local tweenInfo4 = TweenInfo.new(t1.LightFade, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(v, tweenInfo4, { Brightness = 0 }):Play()
		end
	end

	local lingerSize = t1.LingerSize
	local linger: Part = Instance.new("Part")

	linger.Name = "Linger"
	linger.Anchored = true
	linger.CanCollide = false
	linger.CanQuery = false
	linger.CanTouch = false
	linger.CastShadow = false
	linger.Transparency = 1
	linger.Size = lingerSize
	linger.CFrame = cFrame
	linger.Parent = _fx_Outbreak
	n1 = populate(mesh.Linger, linger, false)

	for _, v in ipairs(n1) do
		v.Enabled = true
	end

	task.wait(t1.LingerTime)

	for _, v in ipairs(n1) do
		v.Enabled = false
	end
end
