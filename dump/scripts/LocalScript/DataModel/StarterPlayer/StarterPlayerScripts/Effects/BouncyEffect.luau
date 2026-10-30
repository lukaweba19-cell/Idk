-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local collectionService: CollectionService = game:GetService("CollectionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local bouncyDamage: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("BouncyDamage")
local effect = require(replicatedStorage:WaitForChild("Effect"))
local LocalPlayer: Player = players.LocalPlayer
local game2: Instance = workspace:WaitForChild("Game")
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function isLocalCharacterHit(p1)
	return p1:FindFirstAncestorOfClass("Model") == LocalPlayer.Character
end
local function launchLocalCharacter(p2)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not humanoidRootPart then
		return
	end

	if humanoid.Health <= 0 then
		return
	end

	local u31 = math.max(humanoidRootPart.AssemblyLinearVelocity.Y, p2 or 90)

	if u31 > 140 then
		u31 = 140
	end

	task.spawn(function()
		for _ = 1, 4 do
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, u31, 0)
			task.wait()
		end
	end)
end
local function canLaunch(p3)
	local v33 = os.clock()
	local v34 = t1[p3]

	if v34 and v33 - v34 < 0.35 then
		return false
	end

	t1[p3] = v33

	return true
end
local function getAnyBasePart(p4)
	if p4.PrimaryPart then
		return p4.PrimaryPart
	end

	return p4:FindFirstChildWhichIsA("BasePart", true)
end
local function ensureModelFxState(p5)
	local v37 = t2[p5]

	if v37 then
		return v37
	end

	local n1 = 1

	local ok, result = pcall(function()
		return p5:GetScale()
	end)

	if ok and typeof(result) == "number" then
		n1 = result
	end

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = n1

	local connection = numberValue.Changed:Connect(function(p6: number)
		pcall(function()
			p5:ScaleTo(p6)
		end)
	end)

	local t3: {[any]: any} = {
		tweenUp = nil,
		tweenDown = nil,
		baseScale = n1,
		scaler = numberValue,
		conn = connection
	}

	t2[p5] = t3
	p5.AncestryChanged:Connect(function(_, p8)
		if p8 == nil then
			if t3.tweenUp then
				t3.tweenUp:Cancel()
			end

			if t3.tweenDown then
				t3.tweenDown:Cancel()
			end

			if t3.conn then
				t3.conn:Disconnect()
			end

			if t3.scaler then
				t3.scaler:Destroy()
			end

			t2[p5] = nil
		end
	end)

	return t3
end
local function pulseModel(p9)
	if p9:GetAttribute("NoPulse") == true then
		return
	end

	local v45 = ensureModelFxState(p9)

	if v45.tweenUp then
		v45.tweenUp:Cancel()
	end

	if v45.tweenDown then
		v45.tweenDown:Cancel()
	end

	if v45.tweenMid then
		v45.tweenMid:Cancel()
	end

	v45.scaler.Value = v45.baseScale

	local pulseScale = p9:GetAttribute("PulseScale")

	pulseScale = v45.baseScale * (pulseScale or 1.18)

	local value = v45.baseScale * 0.985
	local scaler = v45.scaler
	local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	v45.tweenUp = tweenService:Create(scaler, tweenInfo, { Value = pulseScale })

	local v50 = v45.scaler
	local tweenInfo2 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	v45.tweenMid = tweenService:Create(v50, tweenInfo2, { Value = value })

	local v52 = v45.scaler
	local tweenInfo3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	v45.tweenDown = tweenService:Create(v52, tweenInfo3, { Value = v45.baseScale })
	v45.tweenUp:Play()

	local connection = nil

	connection = v45.tweenUp.Completed:Connect(function()
		connection:Disconnect()
		v45.tweenMid:Play()

		local connection2 = nil

		connection2 = v45.tweenMid.Completed:Connect(function()
			connection2:Disconnect()
			v45.tweenDown:Play()
		end)
	end)
end
local function playBounceSound(p10, p11)
	if p11:GetAttribute("NoBounceSound") == true then
		return
	end

	if p10:GetAttribute("NoBounceSound") == true then
		return
	end

	local parent = p11 or (if p10.PrimaryPart then p10.PrimaryPart else p10:FindFirstChildWhichIsA("BasePart", true))

	if not parent then
		return
	end

	local v58 = p11:FindFirstChild("BounceSound") or p10:FindFirstChild("BounceSound")
	local v59 = v58 and v58:IsA("Sound")
	local clone

	if v59 then
		clone = v58:Clone()
	else
		local soundId = p11:GetAttribute("BounceSoundId") or p10:GetAttribute("BounceSoundId") or "rbxassetid://101314601670996"

		if typeof(soundId) ~= "string" or soundId == "" or soundId == "rbxassetid://0" then
			return
		end

		local v63 = p11:GetAttribute("BounceSoundVolume") or p10:GetAttribute("BounceSoundVolume") or 0.7
		local v64 = p11:GetAttribute("BounceSoundPitch") or p10:GetAttribute("BounceSoundPitch") or 1
		local v65 = p11:GetAttribute("BouncePitchMin") or p10:GetAttribute("BouncePitchMin") or 0.8
		local v66 = p11:GetAttribute("BouncePitchMax") or p10:GetAttribute("BouncePitchMax") or 1.2
		local n1 = v65 == v66 and v65

		if not n1 then
			local randomNumber = math.random()

			n1 = v65 + (v66 - v65) * randomNumber
		end

		local n2 = v64 * n1

		n2 = p11:GetAttribute("BounceSoundPitch") or p10:GetAttribute("BounceSoundPitch") or 1
		v65 = p11:GetAttribute("BounceSoundMaxDistance") or p10:GetAttribute("BounceSoundMaxDistance") or 70
		clone = Instance.new("Sound")
		clone.Name = "BounceSoundPlaying"
		clone.SoundId = soundId
		clone.Volume = tonumber(v63) or 0.7
		clone.PlaybackSpeed = tonumber(n2) or 1
		clone.RollOffMaxDistance = tonumber(v65) or 70
	end

	clone.Parent = parent
	clone:Play()
	clone.Ended:Connect(function()
		clone:Destroy()
	end)
end
local function hookPart(p12, p13)
	if p13:GetAttribute("BouncyHooked") then
		return
	end

	p13:SetAttribute("BouncyHooked", true)
	p13.Touched:Connect(function(p14)
		if p14:FindFirstAncestorOfClass("Model") ~= LocalPlayer.Character then
			return
		end

		local v84 = p12
		local v85 = os.clock()
		local v86 = t1[v84]
		local u87

		if v86 and v85 - v86 < 0.35 then
			u87 = false
		else
			t1[v84] = v85
			u87 = true
		end

		if not u87 then
			return
		end

		local v88 = p12:GetAttribute("LaunchY") or p13:GetAttribute("LaunchY")

		v84 = true

		if p13.Name ~= "WaterBouncy" then
			v84 = true

			if p12.Name ~= "WaterBouncy" then
				v84 = true

				if p13:GetAttribute("Splash") ~= true then
					v84 = p12:GetAttribute("Splash") == true
				end
			end
		end

		if v84 then
			local Character: Model = LocalPlayer.Character
			local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				effect.new("WaterSplash"):replicate({ Scale = 1, Duration = 1, Position = humanoidRootPart.Position })
			end
		else
			pulseModel(p12)
			playBounceSound(p12, p13)
		end

		local Character: Model = LocalPlayer.Character

		v86 = p13:GetAttribute("Damage") or p12:GetAttribute("Damage")

		if v86 and v86 > 0 then
			bouncyDamage:FireServer(p13, v84, false, Character)
		elseif v84 then
			bouncyDamage:FireServer(p13, v84, true, Character)
		end

		launchLocalCharacter(v88)
	end)
end
local function hookBouncyModel(p15)
	for _, v in ipairs(p15:GetDescendants()) do
		if v:IsA("BasePart") and not v:GetAttribute("BouncyHooked") then
			v:SetAttribute("BouncyHooked", true)
			v.Touched:Connect(function(p16)
				if p16:FindFirstAncestorOfClass("Model") ~= LocalPlayer.Character then
					return
				end

				local v93 = p15
				local v94 = os.clock()
				local v95 = t1[v93]
				local u96

				if v95 and v94 - v95 < 0.35 then
					u96 = false
				else
					t1[v93] = v94
					u96 = true
				end

				if not u96 then
					return
				end

				local v97 = p15:GetAttribute("LaunchY") or v:GetAttribute("LaunchY")

				v93 = true

				if v.Name ~= "WaterBouncy" then
					v93 = true

					if p15.Name ~= "WaterBouncy" then
						v93 = true

						if v:GetAttribute("Splash") ~= true then
							v93 = p15:GetAttribute("Splash") == true
						end
					end
				end

				if v93 then
					local Character: Model = LocalPlayer.Character
					local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						effect.new("WaterSplash"):replicate({ Scale = 1, Duration = 1, Position = humanoidRootPart.Position })
					end
				else
					pulseModel(p15)
					playBounceSound(p15, v)
				end

				local Character: Model = LocalPlayer.Character

				v95 = v:GetAttribute("Damage") or p15:GetAttribute("Damage")

				if v95 and v95 > 0 then
					bouncyDamage:FireServer(v, v93, false, Character)
				elseif v93 then
					bouncyDamage:FireServer(v, v93, true, Character)
				end

				launchLocalCharacter(v97)
			end)
		end
	end

	p15.DescendantAdded:Connect(function(p17)
		if p17:IsA("BasePart") then
			local v102 = p15

			if p17:GetAttribute("BouncyHooked") then
				return
			end

			p17:SetAttribute("BouncyHooked", true)
			p17.Touched:Connect(function(p18)
				if p18:FindFirstAncestorOfClass("Model") ~= LocalPlayer.Character then
					return
				end

				local v106 = v102
				local v107 = os.clock()
				local v108 = t1[v106]
				local u109

				if v108 and v107 - v108 < 0.35 then
					u109 = false
				else
					t1[v106] = v107
					u109 = true
				end

				if not u109 then
					return
				end

				local v110 = v102:GetAttribute("LaunchY") or p17:GetAttribute("LaunchY")

				v106 = true

				if p17.Name ~= "WaterBouncy" then
					v106 = true

					if v102.Name ~= "WaterBouncy" then
						v106 = true

						if p17:GetAttribute("Splash") ~= true then
							v106 = v102:GetAttribute("Splash") == true
						end
					end
				end

				if v106 then
					local Character: Model = LocalPlayer.Character
					local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						effect.new("WaterSplash"):replicate({ Scale = 1, Duration = 1, Position = humanoidRootPart.Position })
					end
				else
					pulseModel(v102)
					playBounceSound(v102, p17)
				end

				local Character: Model = LocalPlayer.Character

				v108 = p17:GetAttribute("Damage") or v102:GetAttribute("Damage")

				if v108 and v108 > 0 then
					bouncyDamage:FireServer(p17, v106, false, Character)
				elseif v106 then
					bouncyDamage:FireServer(p17, v106, true, Character)
				end

				launchLocalCharacter(v110)
			end)

			return
		end
	end)
	p15.AncestryChanged:Connect(function(_, p20)
		if p20 == nil then
			t1[p15] = nil
		end
	end)
end
local function tryHookModel(p21)
	if p21:GetAttribute("BouncyModelHooked") then
		return
	end

	p21:SetAttribute("BouncyModelHooked", true)
	hookBouncyModel(p21)
end
local function tryHook(p22)
	if p22:IsA("Model") and p22.Name == "Bouncy" and p22:IsDescendantOf(game2) then
		if p22:GetAttribute("BouncyModelHooked") then
			return
		end

		p22:SetAttribute("BouncyModelHooked", true)
		hookBouncyModel(p22)

		return
	end

	if p22:IsA("Model") and collectionService:HasTag(p22, "Bouncy") then
		if p22:GetAttribute("BouncyModelHooked") then
			return
		end

		p22:SetAttribute("BouncyModelHooked", true)
		hookBouncyModel(p22)

		return
	end
end

for _, v in ipairs(game2:GetDescendants()) do
	tryHook(v)
end

game2.DescendantAdded:Connect(function(p23: Instance)
	tryHook(p23)
end)

for _, v in ipairs(collectionService:GetTagged("Bouncy")) do
	if v:IsA("Model") and not v:GetAttribute("BouncyModelHooked") then
		v:SetAttribute("BouncyModelHooked", true)
		hookBouncyModel(v)
	end
end

collectionService:GetInstanceAddedSignal("Bouncy"):Connect(function(p24)
	if p24:IsA("Model") then
		if p24:GetAttribute("BouncyModelHooked") then
			return
		end

		p24:SetAttribute("BouncyModelHooked", true)
		hookBouncyModel(p24)

		return
	end
end)
