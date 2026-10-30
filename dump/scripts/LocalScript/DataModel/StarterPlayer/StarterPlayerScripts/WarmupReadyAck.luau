-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local matchmakingShared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("MatchmakingShared", 60)

if not matchmakingShared then
	return
end

local remotes: Instance = matchmakingShared:WaitForChild("Remotes", 60)

if not remotes then
	return
end

local warmupReady: Instance = remotes:WaitForChild("WarmupReady", 60)

if not warmupReady then
	return
end

local u5: boolean = false

local function characterRendered()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return false
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")
	local u11: boolean = false

	if humanoidRootPart ~= nil then
		u11 = humanoidRootPart:IsA("BasePart")
	end

	return u11
end
local function loadingScreenDone()
	return workspace:GetAttribute("LoadingScreenCompleted") == true
end
local function tryFire()
	if u5 then
	elseif LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
		if not game:IsLoaded() then
			return
		end

		if workspace:GetAttribute("LoadingScreenCompleted") ~= true then
			return
		end

		local Character: Model = LocalPlayer.Character
		local u13

		if not Character then
			u13 = false
		else
			local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

			u13 = false

			if humanoidRootPart ~= nil then
				u13 = humanoidRootPart:IsA("BasePart")
			end
		end

		if not u13 then
			return
		end

		u5 = true
		warmupReady:FireServer()

		return
	end
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(tryFire)
workspace:GetAttributeChangedSignal("LoadingScreenCompleted"):Connect(tryFire)
LocalPlayer.CharacterAdded:Connect(function(character: Model)
	character:WaitForChild("HumanoidRootPart", 10)
	tryFire()
end)

if not game:IsLoaded() then
	task.spawn(function()
		game.Loaded:Wait()
		tryFire()
	end)
end

task.spawn(tryFire)
