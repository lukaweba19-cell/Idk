-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local LocalPlayer: Player = players.LocalPlayer
local lobby: Instance = workspace:WaitForChild("Lobby")
local magicFrame: Instance = lobby:WaitForChild("MagicFrame")
local frame: Instance = magicFrame:WaitForChild("frame")
local part: Instance = magicFrame:WaitForChild("Part")
local v9: Instance = part:WaitForChild("43")
local chan: Instance = part:WaitForChild("Chan")
local color3 = Color3.fromRGB(128, 103, 76)
local color32 = Color3.fromRGB(147, 4, 0)
local connection = nil
local n1 = -1

local function applyAlpha(transparency)
	if math.abs(transparency - n1) < 0.004 then
		return
	end

	n1 = transparency
	frame.Color = color3:Lerp(color32, transparency)
	v9.Transparency = transparency
	chan.Transparency = 1 - transparency
end
local function onHeartbeat()
	local Character: Model = LocalPlayer.Character
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return
	end

	local magnitude = (humanoidRootPart.Position - frame.Position).Magnitude

	if magnitude >= 20 then
		if not (math.abs(0 - n1) < 0.004) then
			n1 = 0
			frame.Color = color3:Lerp(color32, 0)
			v9.Transparency = 0
			chan.Transparency = 1
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		return
	end

	local transparency = 1 - math.clamp((magnitude - 5) / 15, 0, 1)

	if math.abs(transparency - n1) < 0.004 then
		return
	end

	n1 = transparency
	frame.Color = color3:Lerp(color32, transparency)
	v9.Transparency = transparency
	chan.Transparency = 1 - transparency
end

task.spawn(function()
	while true do
		task.wait(0.2)

		if not connection then
			local Character: Model = LocalPlayer.Character
			local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and (humanoidRootPart.Position - part.Position).Magnitude < 20 then
				connection = runService.Heartbeat:Connect(onHeartbeat)
			end
		end
	end
end);
(function(childName, childName2, childName3)
	local part: Instance = lobby:WaitForChild(childName):WaitForChild("Part")
	local clickDetector: Instance = part:WaitForChild("ClickDetector")
	local v29: Instance = part:WaitForChild(childName2)
	local v30: Instance = part:WaitForChild(childName3)

	clickDetector.MouseClick:Connect(function(p5)
		if p5 ~= LocalPlayer then
			return
		end

		v29.PlaybackSpeed = 0.8 + math.random() * 0.30000000000000004
		v29:Play()
		v30.Enabled = true
		task.wait(0.5)
		v30.Enabled = false
	end)
end)("CoinFrame", "coinsound", "coins")
