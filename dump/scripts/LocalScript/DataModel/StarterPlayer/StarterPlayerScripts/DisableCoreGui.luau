-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local u1 = nil
local starterGui: StarterGui = game:GetService("StarterGui")
local runService: RunService = game:GetService("RunService")

u1 = function(p1, ...)
	local t1: {[any]: any} = {}

	for _ = 1, 600 do
		t1 = { pcall(starterGui[p1], starterGui, ...) }

		if t1[1] then
			break
		end

		runService.Heartbeat:Wait()
	end

	return unpack(t1)
end

local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local lobbyRespawn: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyRespawn")

local function setBackpackEnabled(p2)
	LocalPlayer:SetAttribute("BackpackEnabled", p2)
end
local function hookCharacter(p3)
	p3:WaitForChild("Humanoid").Died:Connect(function()
		LocalPlayer:SetAttribute("BackpackEnabled", false)
	end)
end

LocalPlayer.CharacterAdded:Connect(function(character: Model)
	LocalPlayer:SetAttribute("BackpackEnabled", true)
	character:WaitForChild("Humanoid").Died:Connect(function()
		LocalPlayer:SetAttribute("BackpackEnabled", false)
	end)
end)

if LocalPlayer.Character then
	LocalPlayer:SetAttribute("BackpackEnabled", true)
	LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
		LocalPlayer:SetAttribute("BackpackEnabled", false)
	end)
end

u1("SetCoreGuiEnabled", Enum.CoreGuiType.Backpack, false)
task.spawn(function()
	local starterGui2: StarterGui = game:GetService("StarterGui")
	local runService2: RunService = game:GetService("RunService")

	for _ = 1, 600 do
		pcall(starterGui2.SetCoreGuiEnabled, starterGui2, Enum.CoreGuiType.PlayerList, false)

		local ok, result = pcall(starterGui2.GetCoreGuiEnabled, starterGui2, Enum.CoreGuiType.PlayerList)

		if ok and result == false then
			break
		end

		runService2.Heartbeat:Wait()
	end

	for _ = 1, 8 do
		task.wait(1)

		local ok2, result2 = pcall(starterGui2.GetCoreGuiEnabled, starterGui2, Enum.CoreGuiType.PlayerList)

		if ok2 and result2 == true then
			pcall(starterGui2.SetCoreGuiEnabled, starterGui2, Enum.CoreGuiType.PlayerList, false)
		end
	end
end)

local bindableEvent: BindableEvent = Instance.new("BindableEvent")

bindableEvent.Event:Connect(function()
	lobbyRespawn:FireServer()
end)

if LocalPlayer:GetAttribute("InMatch") == true then
	u1("SetCore", "ResetButtonCallback", false)
else
	u1("SetCore", "ResetButtonCallback", bindableEvent)
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	if LocalPlayer:GetAttribute("InMatch") == true then
		u1("SetCore", "ResetButtonCallback", false)

		return
	end

	u1("SetCore", "ResetButtonCallback", bindableEvent)
end)
