-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))

replicatedStorage.Remotes.ParkourState.OnClientEvent:Connect(function(p1, p2)
	if not p1 then
		return
	end

	p1:SetAttribute("ParkourState", p2)
end)

local function watchCharacter(p3)
	if not p3 then
		return
	end

	if not p3:IsA("Model") then
		return
	end

	local humanoid = p3:WaitForChild("Humanoid", 10)
	local humanoidRootPart = p3:WaitForChild("HumanoidRootPart", 10)

	if humanoid and humanoidRootPart then
		p3:GetAttributeChangedSignal("ParkourState"):Connect(function()
			if p3:GetAttribute("ParkourState") == "Sliding" then
				sound:Play("Misc.Slide", humanoidRootPart)
			end
		end)

		local customJump = humanoidRootPart:FindFirstChild("CustomJump")

		if not customJump or not customJump:IsA("Sound") then
			customJump = Instance.new("Sound")
			customJump.Name = "CustomJump"
			customJump.SoundId = "rbxasset://sounds/action_jump.mp3"
			customJump.Volume = 0.925
			customJump.RollOffMinDistance = 10
			customJump.RollOffMaxDistance = 40
			customJump.Parent = humanoidRootPart
		end

		local n1 = 0

		humanoid.StateChanged:Connect(function(_, p5)
			if p5 == Enum.HumanoidStateType.Jumping then
				local v16 = os.clock()

				if v16 - n1 < 0.12 then
					return
				end

				n1 = v16
				customJump:Play()

				return
			end
		end)
		task.spawn(function()
			local jumping = humanoidRootPart:WaitForChild("Jumping", 10)

			if jumping and jumping:IsA("Sound") then
				jumping:Destroy()
			end
		end)

		return
	end
end

local characters: Instance = workspace:WaitForChild("Characters")

for iterFirst, iterSecond in characters:GetChildren() do
	task.defer(watchCharacter, iterSecond)
end

characters.ChildAdded:Connect(watchCharacter)
