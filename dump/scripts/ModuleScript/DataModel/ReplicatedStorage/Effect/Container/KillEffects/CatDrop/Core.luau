-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local catDrop = game.ReplicatedStorage.FX.KillEffects.CatDrop
local t1: {[any]: any} = {
	MaxDistance = 1000,
	DropHeight = 45,
	FallTime = 0.6,
	SettleTime = 0.5,
	HopAt = 1.55,
	HopTime = 0.38,
	HopHeight = 1.7,
	PoofAt = 1.95,
	PoofTime = 0.28,
	Cleanup = 3.6,
	FaceSink = 0.35,
	CloseRange = 7,
	CloseScale = 0.65,
	ShakeNear = 18,
	ShakeFar = 120
}

local function shake(p1, p2, p3, p4)
	local v18 = _G.Shared and _G.Shared.CamShaker

	if not v18 then
		return
	end

	local n1 = 1 - math.clamp(((workspace.CurrentCamera.CFrame.Position - p1).Magnitude - 18) / 102, 0, 1)

	if n1 <= 0 then
		return
	end

	pcall(function()
		v18:ShakeOnce(p2 * n1, p3, 0.02, p4)
	end)
end
local function host(name, parent, cFrame, p8)
	local part: Part = Instance.new("Part")

	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = p8 or Vector3.new(0.2, 0.2, 0.2)
	part.CFrame = cFrame
	part.Parent = parent

	return part
end
local function scaleSeq(p9, p10)
	local t2: {[any]: any} = {}

	for _, v in ipairs(p9.Keypoints) do
		table.insert(t2, NumberSequenceKeypoint.new(v.Time, v.Value * p10, v.Envelope * p10))
	end

	return NumberSequence.new(t2)
end
local function applyScale(p11, p12)
	if p12 == 1 then
		return
	end

	local descendants = p11:GetDescendants()

	table.insert(descendants, p11)

	for _, v in ipairs(descendants) do
		if v:IsA("ParticleEmitter") and not v:GetAttribute("NoScale") then
			v.Size = scaleSeq(v.Size, p12)

			if v:GetAttribute("ScaleSpeed") then
				v.Speed = NumberRange.new(v.Speed.Min * p12, v.Speed.Max * p12)
			end
		end
	end
end
local function hideCharacter(p13)
	for _, v in pairs(p13:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
end
local function easeIn(p14)
	return p14 * p14
end

return function(player, p16)
	local s1: string = if p16 == "White" then "White" else "Black"
	local v42 = catDrop[s1]
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude > 1000 then
		return
	end

	local v47 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v47 or not v47:IsA("BasePart") then
		return
	end

	local _fx_CatDrop: Folder = Instance.new("Folder")

	_fx_CatDrop.Name = "_FX_CatDrop"
	_fx_CatDrop.Parent = workspace.Bin
	debris:AddItem(_fx_CatDrop, 4.6)

	local u49: boolean = true
	local t3: {[any]: any} = {}

	table.insert(t3, Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			if u49 then
				u49 = false

				for _, v in ipairs(t3) do
					v:Disconnect()
				end
			end

			_fx_CatDrop:Destroy()
		end
	end))

	local function at(p17, p18)
		task.delay(p17, function()
			if u49 then
				p18()
			end
		end)
	end

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
		end
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin, Character }

	local v55 = workspace:Raycast(v47.Position + Vector3.new(0, 1, 0), Vector3.new(0, -12, 0), raycastParams)
	local vector3 = Vector3.new(v47.Position.X, v55 and v55.Position.Y or v47.Position.Y - 3, v47.Position.Z)
	local n1 = CurrentCamera.CFrame.Position - vector3
	local magnitude = Vector3.new(n1.X, 0, n1.Z).Magnitude
	local vector32 = Vector3.new(n1.X, 0, n1.Z)
	local u60 = vector32.Magnitude > 0.05 and vector32.Unit or Vector3.new(0, 0, 1)

	local function fx(p19)
		local clone = v42[p19]:Clone()

		applyScale(clone, if magnitude < 7 then 0.65 else 1)

		return clone
	end

	local s2 = s1
	local clone = catDrop["Head" .. s2]:Clone()
	local n2: number = if magnitude < 7 then 0.65 else 1
	local n3 = clone.Size * n2

	clone.Size = n3

	local n4 = vector3 - u60 * (n3.Z * 0.42)

	s2 = function(p20, p21, p22, p23)
		local vector33 = Vector3.new(0, p20 / 2 - 0.35 * n2 + p21, 0)
		local n1 = n4 + vector33
		local v101 = CFrame.lookAt(n1, n1 + u60)
		local v102 = CFrame.Angles(0, p22 or 0, p23 or 0)

		return v101 * v102
	end

	local function setShape(p24, p25, p26)
		clone.Size = Vector3.new(n3.X * p24, n3.Y * p25, n3.Z * p26)
	end

	local t4: {[any]: any} = {}

	for _, v in ipairs({
		Vector3.new(-0.32, 0.45, 0),
		Vector3.new(0.32, 0.45, 0),
		Vector3.new(0, 0.1, 0.2)
	}) do
		local attachment: Attachment = Instance.new("Attachment")

		attachment.Position = Vector3.new(v.X * n3.X, v.Y * n3.Y, v.Z * n3.Z) + Vector3.new(-0.5, 0, 0)
		attachment.Parent = clone

		local attachment2: Attachment = Instance.new("Attachment")

		attachment2.Position = attachment.Position + Vector3.new(1, 0, 0)
		attachment2.Parent = clone

		local clone2 = v42.FallTrail:Clone()

		clone2.Attachment0 = attachment
		clone2.Attachment1 = attachment2
		clone2.Enabled = true
		clone2.Parent = clone
		table.insert(t4, clone2)
	end

	clone.Size = Vector3.new(n3.X * 0.88, n3.Y * 1.2, n3.Z * 0.88)

	local vector34 = Vector3.new(0, clone.Size.Y / 2 - t1.FaceSink * n2 + 45, 0)
	local n5 = n4 + vector34
	local v76 = CFrame.lookAt(n5, n5 + u60)
	local v77 = CFrame.Angles(0, 0, 0)

	clone.CFrame = v76 * v77
	clone.Parent = _fx_CatDrop

	local cFrame, v79 = CFrame.new(vector3 + Vector3.new(0, 0.08, 0))
	local shadow: Part = Instance.new("Part")

	shadow.Name = "Shadow"
	shadow.Anchored = true
	shadow.CanCollide = false
	shadow.CanQuery = false
	shadow.CanTouch = false
	shadow.CastShadow = false
	shadow.Transparency = 1
	shadow.Size = v79 or Vector3.new(0.2, 0.2, 0.2)
	shadow.CFrame = cFrame
	shadow.Parent = _fx_CatDrop

	local clone3 = v42.Shadow:Clone()

	applyScale(clone3, magnitude < t1.CloseRange and t1.CloseScale or 1)
	clone3.Parent = shadow
	misc.Emit(clone3)
	sound:Play("KillEffects.CatDrop.Fall", v47)

	local v82 = os.clock()
	local connection = nil

	connection = runService.Heartbeat:Connect(function()
		local v106 = os.clock()
		local v107 = math.clamp((v106 - v82) / 0.6, 0, 1)
		local sine = math.sin(v107 * 14)
		local vector35 = Vector3.new(0, clone.Size.Y / 2 - t1.FaceSink * n2 + 45 * (1 - v107 * v107), 0)
		local n1 = n4 + vector35
		local v111 = CFrame.lookAt(n1, n1 + u60)
		local v112 = CFrame.Angles(0, 0, sine * 0.08726646259971647 * (1 - v107) or 0)

		clone.CFrame = v111 * v112

		if v107 >= 1 then
			connection:Disconnect()
		end
	end)
	table.insert(t3, connection)

	local n6 = 0

	local function v85()
		for _, v in ipairs(t4) do
			v.Enabled = false
		end

		clone3:Clear()
		hideCharacter(Character)
		sound:Play("KillEffects.CatDrop.Impact", v47)
		sound:Play("KillEffects.CatDrop.Impact2", v47)
		shake(vector3, 2.4, 13, 0.6)

		local clone4 = catDrop["Impact" .. s1]:Clone()
		local n1 = n4 + u60 * (n3.Z * 0.5 + 0.8) + Vector3.new(0, 0.2, 0)
		local v117 = CFrame.lookAt(n1, n1 + u60)
		local v118 = CFrame.Angles(-1.5707963267948966, 0, 0)

		clone4.CFrame = v117 * v118
		clone4.Parent = _fx_CatDrop
		misc.EmitAll(clone4)

		local cFrame, v120 = CFrame.new(n4 + Vector3.new(0, 0.12, 0))
		local ground: Part = Instance.new("Part")

		ground.Name = "Ground"
		ground.Anchored = true
		ground.CanCollide = false
		ground.CanQuery = false
		ground.CanTouch = false
		ground.CastShadow = false
		ground.Transparency = 1
		ground.Size = v120 or Vector3.new(0.2, 0.2, 0.2)
		ground.CFrame = cFrame
		ground.Parent = _fx_CatDrop

		local clone5 = v42.GroundRings:Clone()

		applyScale(clone5, magnitude < t1.CloseRange and t1.CloseScale or 1)
		clone5.Parent = ground
		misc.EmitAll(clone5)

		local n2 = n3.X * 0.5 + 0.5

		v117 = n3.Z * 0.5 + 0.5

		local rightVector = CFrame.lookAt(n4, n4 + u60).RightVector
		local clone6 = v42.GroundDust:Clone()

		applyScale(clone6, magnitude < t1.CloseRange and t1.CloseScale or 1)

		for i = 1, 12 do
			local n7 = (i - 0.5) / 12 * 3.141592653589793 * 2
			local cosine = math.cos(n7)
			local v129 = u60
			local sine = math.sin(n7)
			local n8 = rightVector * cosine * n2 + v129 * sine * v117

			n7 = n4 + n8 + Vector3.new(0, 0.4, 0)

			local clone7 = clone6:Clone()

			clone7.Parent = ground

			local cFrameLookAt = CFrame.lookAt
			local vector36 = Vector3.new(n8.X, 0, n8.Z)

			clone7.WorldCFrame = cFrameLookAt(n7, n7 + vector36.Unit)
			misc.EmitAll(clone7)
		end

		clone6:Destroy()

		local clone8 = v42.FaceBits:Clone()

		applyScale(clone8, magnitude < t1.CloseRange and t1.CloseScale or 1)
		clone8.Parent = ground

		local n5 = n4 + u60 * (n3.Z * 0.5 + 1.2)
		local vector37 = Vector3.new(0, n3.Y * 0.32, 0)

		clone8.WorldPosition = n5 + vector37
		misc.EmitAll(clone8)

		local clone9 = v42.TopPop:Clone()

		applyScale(clone9, magnitude < t1.CloseRange and t1.CloseScale or 1)
		clone9.Parent = ground

		local vector38 = Vector3.new(0, n3.Y * 0.85, 0)

		clone9.WorldPosition = n4 + vector38
		misc.EmitAll(clone9)

		local clone10 = v42.ImpactFlash:Clone()

		clone10.Enabled = true
		clone10.Parent = ground

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(clone10, tweenInfo, { Brightness = 0 }):Play()
		n6 = os.clock()
	end

	task.delay(0.6, function()
		if u49 then
			v85()
		end
	end)

	local connection2 = nil

	local function v87()
		connection2 = runService.Heartbeat:Connect(function()
			local n1 = os.clock() - n6
			local n12 = 1
			local n13 = 1
			local n14 = 0

			if n1 < 1.1 then
				local v152 = math.exp(-7 * n1)
				local cosine = math.cos(n1 * 26)
				local n5 = v152 * cosine

				n13 = 1 - n5 * 0.3
				n12 = n5 * 0.24 + 1
			end

			local v155 = math.clamp((n1 - 0.4) / 0.3, 0, 1)
			local sine = math.sin(n1 * 7)
			local n15 = n13 + sine * 0.025 * v155
			local sine2 = math.sin(n1 * 7)
			local n7 = n12 - sine2 * 0.015 * v155
			local v160 = math.clamp((n1 - 0.5) / 0.45, 0, 1)
			local n8 = math.sin(v160 * 3.141592653589793 / 2) * 0.12217304763960307 * v155

			v155 = (n1 - 0.9500000000000001) / 0.38

			if v155 > 0 and v155 < 1 then
				local sine3 = math.sin(v155 * 3.141592653589793)

				n14 = 1.7 * n2 * sine3

				local n9 = math.sin(v155 * 3.141592653589793) * 0.12

				n15 += n9
				n7 -= n9 * 0.7

				local sine4 = math.sin(v155 * 3.141592653589793)

				n8 *= 1 - sine4
			elseif v155 >= 1 then
				local n10 = v155 - 1
				local v166 = math.exp(-12 * n10)
				local cosine = math.cos(n10 * 30)
				local n11 = v166 * cosine

				n15 -= n11 * 0.12
				n7 += n11 * 0.1
				n8 = 0
			end

			clone.Size = Vector3.new(n3.X * n7, n3.Y * n15, n3.Z * n7)

			local vector39 = Vector3.new(0, clone.Size.Y / 2 - t1.FaceSink * n2 + n14, 0)

			v155 = n4 + vector39

			local v170 = CFrame.lookAt(v155, v155 + u60)
			local v171 = CFrame.Angles(0, 0, n8 or 0)

			clone.CFrame = v170 * v171
		end)
		table.insert(t3, connection2)
	end

	task.delay(0.6, function()
		if u49 then
			v87()
		end
	end)

	local function v88()
		if connection2 then
			connection2:Disconnect()
		end

		local v142 = os.clock()
		local cloneSize = clone.Size
		local connection3 = nil

		connection3 = runService.Heartbeat:Connect(function()
			local v172 = os.clock()
			local v173 = math.clamp((v172 - v142) / 0.28, 0, 1)
			local v174: number = tweenService:GetValue(v173, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			local v175 = math.max(0.02, 1 - v174)

			clone.Size = cloneSize * v175

			local vector310 = Vector3.new(0, clone.Size.Y / 2 - t1.FaceSink * n2 + 0.8 * n2 * v174, 0)

			v175 = n4 + vector310

			local v177 = CFrame.lookAt(v175, v175 + u60)
			local v178 = CFrame.Angles(0, v173 * 0.4363323129985824 or 0, 0)

			clone.CFrame = v177 * v178

			if v173 >= 1 then
				connection3:Disconnect()
				clone:Destroy()
			end
		end)
		table.insert(t3, connection3)

		local function v145()
			sound:Play("KillEffects.CatDrop.Poof", v47)

			local clone11 = v42.Poof:Clone()

			applyScale(clone11, magnitude < t1.CloseRange and t1.CloseScale or 1)
			clone11.Size = n3 * Vector3.new(0.6, 0.5, 0.6)

			local cFrameNew = CFrame.new
			local vector311 = Vector3.new(0, n3.Y * 0.35, 0)

			clone11.CFrame = cFrameNew(n4 + vector311)
			clone11.Parent = _fx_CatDrop
			misc.EmitAll(clone11)

			local pointLight = clone11:FindFirstChildWhichIsA("PointLight")

			if pointLight then
				tweenService:Create(pointLight, TweenInfo.new(0.6), { Brightness = 0 }):Play()
			end
		end

		task.delay(0.098, function()
			if u49 then
				v145()
			end
		end)
	end

	task.delay(1.95, function()
		if u49 then
			v88()
		end
	end)
	task.delay(3.6, function()
		if not u49 then
			return
		end

		u49 = false

		for _, v in ipairs(t3) do
			v:Disconnect()
		end
	end)
end
