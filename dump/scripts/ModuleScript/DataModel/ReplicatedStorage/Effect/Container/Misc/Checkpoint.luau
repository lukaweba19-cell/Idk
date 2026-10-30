-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local checkpoint = game.ReplicatedStorage.FX.AbilityFX.Checkpoint
local color3 = Color3.fromRGB(90, 255, 130)

local function pick(p1, p2)
	if sound:Find(p1) then
		return p1
	end

	return p2
end
local function bin()
	return workspace:FindFirstChild("Bin") or workspace
end
local function burstAt(p3, p4, p5)
	local part: Part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.CFrame = CFrame.new(p3)
	part.Parent = workspace:FindFirstChild("Bin") or workspace
	debris:AddItem(part, 3)

	local burst = checkpoint:FindFirstChild("Burst")

	if burst then
		local clone = burst:Clone()

		if p5 then
			for iterFirst, iterSecond in clone:GetDescendants() do
				if iterSecond:IsA("ParticleEmitter") then
					iterSecond.Color = ColorSequence.new(p5)
				end
			end
		end

		clone.Parent = part
		misc.EmitAll(clone)
	end

	if p4 then
		sound:Play(p4, part)
	end
end
local function rewindModules()
	local v26, v27, v28 = pcall(function()
		local checkpointClient = game.ReplicatedStorage.Abilities.CheckpointClient

		return require(checkpointClient), require(checkpointClient.Hologram)
	end)

	if v26 then
		return v27, v28
	end

	return nil, nil
end
local function afterimage(p6, player, p8)
	local Character = player.Character

	if not p6 or typeof(Character) ~= "Instance" or not Character:IsA("Model") then
		return
	end

	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return
	end

	local v34 = p6.Build(Character, p8, 0.15)

	if not v34 then
		return
	end

	local model = v34.model
	local n1 = CFrame.new(player.From) * humanoidRootPart.CFrame.Rotation

	model:PivotTo(n1)
	model.Parent = workspace:FindFirstChild("Bin") or workspace
	debris:AddItem(model, 1.55)

	local v37 = os.clock()
	local connection = nil

	connection = runService.RenderStepped:Connect(function()
		local v81 = os.clock()
		local v82 = math.min((v81 - v37) / 0.55, 1)

		p6.SetFade(v34, 1 - v82)

		local vector3 = Vector3.new(0, v82 * 0.8, 0)

		model:PivotTo(n1 + vector3)

		if v82 >= 1 then
			if connection then
				connection:Disconnect()
			end

			model:Destroy()
		end
	end)
end
local function streak(p9, p10, p11)
	if workspace:GetAttribute("CheckpointRewindTrail") == false then
	elseif typeof(p9) == "Vector3" and typeof(p10) == "table" then
		local t1: {[any]: any} = {}

		for _, v in ipairs(p10) do
			if typeof(v) == "Vector3" then
				table.insert(t1, p9 + v)
			end
		end

		if #t1 < 2 then
			return
		end

		local part: Part = Instance.new("Part")

		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.CastShadow = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, 1)
		part.CFrame = CFrame.new(t1[1])
		part.Parent = workspace:FindFirstChild("Bin") or workspace
		debris:AddItem(part, 1.52)

		local t2: {[any]: any} = {}

		for i, v in ipairs(t1) do
			local attachment: Attachment = Instance.new("Attachment")

			attachment.Position = part.CFrame:PointToObjectSpace(v)
			attachment.Parent = part
			t2[i] = attachment
		end

		local colorSequence = ColorSequence.new(p11)
		local t3: {[any]: any} = {}

		for i = 1, #t2 - 1 do
			local beam: Beam = Instance.new("Beam")

			beam.Attachment0 = t2[i]
			beam.Attachment1 = t2[i + 1]
			beam.FaceCamera = true
			beam.Segments = 1
			beam.Width0 = 0.45
			beam.Width1 = 0.45
			beam.Color = colorSequence
			beam.LightEmission = 1
			beam.LightInfluence = 0
			beam.Transparency = NumberSequence.new(0.15)
			beam.Parent = part
			t3[i] = beam
		end

		local n1: number = #t3
		local v55 = os.clock()
		local connection = nil

		connection = runService.RenderStepped:Connect(function()
			local n3 = os.clock() - v55

			for key, value in t3 do
				local v87 = math.clamp((n3 - (if n1 > 1 then (key - 1) / (n1 - 1) * 0.22 else 0)) / 0.3, 0, 1)

				value.Transparency = NumberSequence.new(v87 * 0.85 + 0.15)

				local n2 = (1 - v87 * 0.7) * 0.45

				value.Width0 = n2
				value.Width1 = n2
			end

			if n3 >= 0.52 then
				if connection then
					connection:Disconnect()
				end

				part:Destroy()
			end
		end)

		return
	end
end
local function rewound(player)
	local v58, v59, v60 = pcall(function()
		local checkpointClient = game.ReplicatedStorage.Abilities.CheckpointClient

		return require(checkpointClient), require(checkpointClient.Hologram)
	end)

	local v61
	local v62

	if v58 then
		v61 = v59
		v62 = v60
	else
		v61 = nil
		v62 = nil
	end

	local v63 = if v61 and typeof(v61.ColorFor) == "function" then v61.ColorFor(player.UserId, player.Side) else Color3.fromRGB(255, 214, 64)
	local LocalPlayer: Player = players.LocalPlayer
	local u65: boolean = LocalPlayer ~= nil and player.UserId == LocalPlayer.UserId and player.Character ~= nil and player.Character == LocalPlayer.Character
	local v66 = if u65 then nil else if sound:Find("Abilities.CheckpointTeleport") then "Abilities.CheckpointTeleport" else "Abilities.PortalTP"

	if typeof(player.From) == "Vector3" then
		burstAt(player.From, v66)
		task.spawn(afterimage, v62, player, v63)
	end

	burstAt(player.Position, v66)
	task.spawn(streak, player.Position, player.PathOffsets, v63)

	if (tonumber(player.Healed) or 0) > 0 then
		burstAt(player.Position, nil, color3)

		local CurrentCamera: Camera = workspace.CurrentCamera

		if u65 and CurrentCamera then
			local checkpointRewindHeal: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			checkpointRewindHeal.Name = "CheckpointRewindHeal"
			checkpointRewindHeal.TintColor = Color3.fromRGB(200, 255, 215)
			checkpointRewindHeal.Parent = CurrentCamera

			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v70: Tween = tweenService:Create(checkpointRewindHeal, tweenInfo, { TintColor = Color3.new(1, 1, 1) })

			v70.Completed:Connect(function()
				checkpointRewindHeal:Destroy()
			end)
			v70:Play()
			debris:AddItem(checkpointRewindHeal, 1.5)
		end
	end
end

return function(p13)
	local v72 = p13.Position

	if typeof(v72) ~= "Vector3" then
	elseif p13.Rewound then
		rewound(p13)
	elseif p13.Placed then
		local v73 = sound:Find("Abilities.CheckpointPlace")

		burstAt(v72, if v73 then "Abilities.CheckpointPlace" else nil)
	elseif p13.Destroyed then
		local v74 = sound:Find("Abilities.CheckpointBreak")

		burstAt(v72, if v74 then "Abilities.CheckpointBreak" else "Abilities.DecoyPoof")
	elseif p13.Teleported then
		if typeof(p13.From) == "Vector3" then
			local from = p13.From
			local part: Part = Instance.new("Part")

			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Transparency = 1
			part.Size = Vector3.new(1, 1, 1)
			part.CFrame = CFrame.new(from)
			part.Parent = workspace:FindFirstChild("Bin") or workspace
			debris:AddItem(part, 3)

			local burst = checkpoint:FindFirstChild("Burst")

			if burst then
				local clone = burst:Clone()

				clone.Parent = part
				misc.EmitAll(clone)
			end
		end

		local v79 = sound:Find("Abilities.CheckpointTeleport")

		burstAt(v72, if v79 then "Abilities.CheckpointTeleport" else "Abilities.PortalTP")
	end
end
