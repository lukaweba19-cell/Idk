-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)

game:GetService("TweenService")

local players: Players = game:GetService("Players")
local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local timeStop = game.ReplicatedStorage.FX.KillEffects.TimeStop
local knives = game.ReplicatedStorage.Knives
local default = knives:FindFirstChild("Default")

if not default then
	default = knives:GetChildren()[1]
end

local tweenService: TweenService = game:GetService("TweenService")

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

	local torso = Character:FindFirstChild("Torso")

	if not torso then
		return
	end

	local _fx_TimeStop: Folder = Instance.new("Folder")

	_fx_TimeStop.Name = "_FX_TimeStop"
	_fx_TimeStop.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_TimeStop:Destroy()
		end
	end)
	debris:AddItem(_fx_TimeStop, 6.25)

	local v20 = torso.Position

	v20 = getKillerKnife(Character)

	if not v20 then
		return
	end

	local clone = v20:Clone()

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
			v.CastShadow = false
		elseif v:IsA("Bone") or v:IsA("AnimationController") then
			v:Destroy()
		end
	end

	local t1: {[any]: any} = {}

	for _, v in ipairs({ "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }) do
		local v = Character:FindFirstChild(v)

		if v and v:IsA("BasePart") then
			v.Anchored = true
			table.insert(t1, v)
		end
	end

	local t2: {[any]: any} = {}

	for i = 1, 17 do
		local n1: number = 6.283185307179586 * i / 1.618033988749895
		local n2: number = 1 - (i - 0.5) / 17
		local squareRoot = math.sqrt(1 - n2 * n2)
		local cosine = math.cos(n1)
		local sine = math.sin(n1)
		local unit = Vector3.new(squareRoot * cosine, n2, squareRoot * sine).Unit
		local randomNumber = math.random()
		local randomNumber2 = math.random()
		local randomNumber3 = math.random()

		table.insert(t2, {
			knife = nil,
			knifeRoot = nil,
			direction = unit,
			spawnDist = 14 + randomNumber * 10,
			stopDist = 8 + randomNumber2 * 8,
			spawnDelay = randomNumber3 * 0.1
		})
	end

	for i, v in ipairs(t2) do
		task.delay(v.spawnDelay, function()
			if not _fx_TimeStop or not _fx_TimeStop.Parent then
				return
			end

			if not torso or not torso.Parent then
				return
			end

			local torsoPosition = torso.Position
			local vDirection = v.direction
			local clone2 = clone:Clone()

			clone2.Name = "TimeStopKnife_" .. i

			local knifeRoot = clone2:FindFirstChild("KnifeRoot")

			if not knifeRoot then
				warn("TimeStop: Knife has no KnifeRoot!")

				return
			end

			local n1 = torsoPosition + vDirection * v.stopDist
			local v55 = CFrame.lookAt(torsoPosition + vDirection * v.spawnDist, torsoPosition)
			local v56 = CFrame.Angles(-1.5707963267948966, 0, 0)

			knifeRoot.CFrame = v55 * v56
			knifeRoot.Anchored = true
			knifeRoot.CanCollide = false
			clone2.Parent = _fx_TimeStop
			v.knife = clone2
			v.knifeRoot = knifeRoot
			v.stopPos = n1
			v.targetTorsoPos = torsoPosition

			for _, iterValue in pairs(clone2:GetDescendants()) do
				if iterValue:IsA("Trail") then
					iterValue.Enabled = true
				end
			end

			local clone3 = timeStop.StarStart:Clone()

			clone3.Parent = knifeRoot
			misc.EmitAll(clone3)
			task.spawn(function()
				task.wait(1.325)

				local clone4 = timeStop.StarStart:Clone()

				clone4.Parent = knifeRoot
				misc.EmitAll(clone4)
			end)
			v55 = CFrame.lookAt(n1, torsoPosition)
			v56 = CFrame.Angles(-1.5707963267948966, 0, 0)

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			tweenService:Create(knifeRoot, tweenInfo, { CFrame = v55 * v56 }):Play()
		end)
	end

	local clone5 = timeStop.Bubble:Clone()

	clone5.CFrame = torso.CFrame
	clone5.Parent = _fx_TimeStop
	debris:AddItem(clone5, 5.5)

	local highlightPoolsEffect = highlightPools.Effect
	local color3 = Color3.fromRGB(165, 0, 3)
	local v44 = highlightPoolsEffect:acquire(clone5, {
		FillTransparency = -1,
		OutlineTransparency = 1,
		FillColor = color3,
		OutlineColor = Color3.new(1, 1, 1),
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	})

	if v44 then
		highlightPools.Effect:releaseAfter(v44, 5.5)
	end

	sound:Play("KillEffects.TimeStop", clone5, nil, nil, nil, 0.05)

	local clone6 = timeStop.Distortion:Clone()

	clone6.CFrame = torso.CFrame
	clone6.Parent = _fx_TimeStop
	debris:AddItem(clone6, 5.5)
	task.spawn(function()
		task.spawn(function()
			misc.EmitAll(clone5.Stage1)
			task.wait(0.25)
			misc.EmitAll(clone5.TimeStop)
			task.wait(1.0499999999999998)
			misc.EmitAll(clone5.Stage3)
			task.wait(0.105)
			misc.EmitAll(clone5.Stage4)
		end)
		task.wait(0.517)

		for _, v in pairs(clone5.TimeStop:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v.TimeScale = 0
			end
		end

		task.wait(0.6330000000000001)

		for _, v in pairs(clone5.TimeStop:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v.TimeScale = 1
			end
		end
	end)
	task.spawn(function()
		local clone7 = timeStop.Distortion:Clone()

		clone7.CFrame = torso.CFrame
		clone7.Parent = _fx_TimeStop
		debris:AddItem(clone5, 5.5)

		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone7, tweenInfo, { Size = Vector3.new(14.5, 14.5, 14.5) }):Play()

		local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone5, tweenInfo2, { Size = Vector3.new(15, 15, 15) }):Play()
		task.wait(0.15)

		local tweenInfo3 = TweenInfo.new(1.583, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)

		tweenService:Create(clone7, tweenInfo3, { Size = Vector3.new(12.5, 12.5, 12.5) }):Play()

		local tweenInfo4 = TweenInfo.new(1.583, Enum.EasingStyle.Elastic, Enum.EasingDirection.In)

		tweenService:Create(clone5, tweenInfo4, { Size = Vector3.new(13, 13, 13) }):Play()
		task.spawn(function()
			local clone8 = timeStop.Distortion:Clone()

			clone8.CFrame = clone5.CFrame
			clone8.Parent = _fx_TimeStop
			debris:AddItem(clone5, 5.5)

			local tweenInfo5 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(clone8, tweenInfo5, { Size = Vector3.new(16.5, 16.5, 16.5) }):Play()
			task.wait(0.1)

			local tweenInfo6 = TweenInfo.new(0.173, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			tweenService:Create(clone8, tweenInfo6, { Size = Vector3.new(0, 0, 0) }):Play()
		end)
		task.wait(1.0030000000000001)

		local tweenInfo7 = TweenInfo.new(0.03, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone7, tweenInfo7, { Size = Vector3.new(12.5, 12.5, 12.5) }):Play()

		local tweenInfo8 = TweenInfo.new(0.03, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone5, tweenInfo8, { Size = Vector3.new(15, 15, 15) }):Play()
		task.wait(0.03)

		local tweenInfo9 = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone7, tweenInfo9, { Size = Vector3.new(0, 0, 0) }):Play()

		local tweenInfo10 = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In)

		tweenService:Create(clone5, tweenInfo10, { Size = Vector3.new(0, 0, 0) }):Play()
	end)
	task.spawn(function()
		task.spawn(function()
			local clone9 = timeStop.Distortion:Clone()

			clone9.CFrame = clone5.CFrame
			clone9.Parent = _fx_TimeStop
			debris:AddItem(clone5, 5.5)

			local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(clone9, tweenInfo, { Size = Vector3.new(18.5, 18.5, 18.5) }):Play()
			task.wait(0.25)

			local tweenInfo11 = TweenInfo.new(0.333, Enum.EasingStyle.Back, Enum.EasingDirection.In)

			tweenService:Create(clone9, tweenInfo11, { Size = Vector3.new(0, 0, 0) }):Play()
		end)
	end)
	task.spawn(function()
		if not v44 then
			return
		end

		local v74 = v44
		local CurrentCamera: Camera = workspace.CurrentCamera
		local workspaceCharacters = workspace.Characters
		local workspaceBin = workspace.Bin
		local workspaceDestructibles = workspace.Destructibles
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { workspaceCharacters, workspaceBin, workspaceDestructibles }

		while clone5 and clone5.Parent do
			local CFramePosition = CurrentCamera.CFrame.Position
			local v81 = workspace:Raycast(CFramePosition, clone5.Position - CFramePosition, raycastParams)

			if v81 and v81.Instance ~= clone5 then
				v74.DepthMode = Enum.HighlightDepthMode.Occluded
			else
				v74.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			end

			task.wait()
		end
	end)
	task.spawn(function()
		if not v44 then
			return
		end

		local v82 = v44

		local function tweenColor(p3, p4)
			local tweenInfo = TweenInfo.new(p3, Enum.EasingStyle.Linear)
			local v102: Tween = tweenService:Create(v82, tweenInfo, { FillColor = p4 })

			highlightPools.Effect:trackTween(v82, v102)
			v102:Play()
		end

		task.wait(0.15)
		tweenColor(0.05, Color3.fromRGB(51, 173, 177))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(57, 205, 60))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(192, 89, 71))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(94, 179, 238))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(213, 203, 22))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(146, 63, 188))
		task.wait(0.05)
		tweenColor(0.05, Color3.fromRGB(123, 176, 149))
		task.wait(0.6330000000000001)
		tweenColor(0.034, Color3.fromRGB(21, 165, 22))
		task.wait(0.015)
		tweenColor(0.034, Color3.fromRGB(104, 81, 165))
		task.wait(0.015)
		tweenColor(0.034, Color3.fromRGB(217, 206, 45))
		task.wait(0.015)
		tweenColor(0.034, Color3.fromRGB(165, 0, 3))
	end)
	task.wait(0.6)
	task.wait(0.75)

	for key, value in t1 do
		value.Anchored = false
	end

	for i, v in ipairs(t2) do
		task.delay((i - 1) * 0.024, function()
			local vKnifeRoot = v.knifeRoot

			if not vKnifeRoot or not vKnifeRoot.Parent then
				return
			end

			if not torso or not torso.Parent then
				return
			end

			local randomNumber4 = math.random(1, #t1)
			local u86 = t1[randomNumber4]

			if not u86 or not u86.Parent then
				u86 = torso
			end

			local v87 = u86.Position
			local v88 = CFrame.lookAt(v87 + v.direction * 0.3, v87 + v.direction)
			local v89 = CFrame.Angles(-1.5707963267948966, 0, 0)
			local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
			local v91: Tween = tweenService:Create(vKnifeRoot, tweenInfo, { CFrame = v88 * v89 })

			v91:Play()
			sound:Play("KillEffects.TimeStopStab", vKnifeRoot, nil, nil, nil, 0.45)
			sound:Play("KillEffects.TimeStopStab2", vKnifeRoot, nil, nil, nil, 0.45)
			task.spawn(function()
				local clone10 = timeStop.Shoot:Clone()

				clone10.Parent = vKnifeRoot
				misc.EmitAll(clone10)
			end)
			v91.Completed:Once(function()
				if not vKnifeRoot or not vKnifeRoot.Parent then
					return
				end

				for iterFirst, iterSecond in vKnifeRoot:GetDescendants() do
					if iterSecond:IsA("Trail") then
						iterSecond.Enabled = false
					end
				end

				vKnifeRoot.Anchored = false
				vKnifeRoot.Massless = true
				vKnifeRoot.CanQuery = false

				if u86 and not u86:GetAttribute("TimeStopWeld") then
					u86:SetAttribute("TimeStopWeld", true)

					local weld: Weld = Instance.new("Weld")

					weld.Part0 = vKnifeRoot
					weld.Part1 = u86

					local cFrameAngles = CFrame.Angles
					local randomNumber5 = math.random()
					local randomNumber6 = math.random()
					local randomNumber7 = math.random()

					weld.C0 = cFrameAngles(3.141592653589793 * randomNumber5 * 2, 3.141592653589793 * randomNumber6 * 2, 3.141592653589793 * randomNumber7 * 2)
					weld.Parent = vKnifeRoot

					return
				end

				vKnifeRoot.Parent:Destroy()
			end)
		end)
	end
end
