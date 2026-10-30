-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace: Workspace = game:GetService("Workspace")
local debris: Debris = game:GetService("Debris")
local players: Players = game:GetService("Players")
local lighting: Lighting = game:GetService("Lighting")
local tweenService: TweenService = game:GetService("TweenService")
local soundService: SoundService = game:GetService("SoundService")
local trainEvents: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("TrainEvents")
local train: Instance = soundService:WaitForChild("Train")
local trainsignal: Instance = train:WaitForChild("trainsignal")
local trainincoming: Instance = train:WaitForChild("trainincoming")
local trainhit: Instance = train:WaitForChild("trainhit")
local LocalPlayer: Player = players.LocalPlayer

local function playAt(p1, p2, p3, p4)
	if not p1 then
	elseif typeof(p2) == "Vector3" then
		local part: Part = Instance.new("Part")

		part.Size = Vector3.new(1, 1, 1)
		part.Transparency = 1
		part.CanCollide = false
		part.CanQuery = false
		part.CastShadow = false
		part.Anchored = true
		part.Position = p2
		part.Parent = workspace

		local clone = p1:Clone()

		clone.Looped = false
		clone.Volume = math.max(p1.Volume, 0.1)

		if p3 and p4 then
			clone.PlaybackSpeed = Random.new():NextNumber(p3, p4)
		end

		clone.RollOffMode = Enum.RollOffMode.Linear
		clone.RollOffMinDistance = 30
		clone.RollOffMaxDistance = 1200
		clone.Parent = part
		clone:Play()
		clone.Ended:Connect(function()
			part:Destroy()
		end)
		debris:AddItem(part, 20)

		return
	end
end

local u15 = nil

local function playHitBlur()
	if u15 then
		u15:Destroy()
		u15 = nil
	end

	local trainHitBlur: BlurEffect = Instance.new("BlurEffect")

	trainHitBlur.Name = "TrainHitBlur"
	trainHitBlur.Size = 24
	trainHitBlur.Parent = lighting
	u15 = trainHitBlur

	local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local v26: Tween = tweenService:Create(trainHitBlur, tweenInfo, { Size = 0 })

	v26:Play()
	v26.Completed:Connect(function()
		if u15 == trainHitBlur then
			u15 = nil
		end

		trainHitBlur:Destroy()
	end)
end
local function bounceLocalCharacter(assemblyLinearVelocity)
	if typeof(assemblyLinearVelocity) == "Vector3" then
		local Character: Model = LocalPlayer.Character

		if not Character then
			return
		end

		local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

		if humanoid and humanoidRootPart then
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 5, 0)
			humanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
			humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

			return
		end

		return
	end
end

trainEvents.OnClientEvent:Connect(function(p6, p7, p8)
	if p6 == "signal" then
		playAt(trainsignal, p7)
	elseif p6 == "incoming" then
		playAt(trainincoming, p7)
	elseif p6 == "pass" then
		local v34 = typeof(p8) == "string" and train:FindFirstChild(p8) or train:FindFirstChild("trainpass")

		playAt(v34, p7, 0.9, 1.1)
	elseif p6 == "hit" then
		playAt(trainhit, p7)
		bounceLocalCharacter(p8)
		playHitBlur()
	end
end)
