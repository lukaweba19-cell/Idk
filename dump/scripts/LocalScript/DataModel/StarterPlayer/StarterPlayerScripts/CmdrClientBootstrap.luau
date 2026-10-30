-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")

while true do
	if LocalPlayer:GetAttribute("CmdrAuthorized") ~= nil then
		break
	end

	LocalPlayer:GetAttributeChangedSignal("CmdrAuthorized"):Wait()
end

if LocalPlayer:GetAttribute("CmdrAuthorized") == true then
	local cmdrClient = require(replicatedStorage:WaitForChild("CmdrClient"))

	cmdrClient.Registry:RegisterHook("BeforeRun", function(_)
		return nil
	end)

	local remotes: Instance = replicatedStorage:FindFirstChild("Remotes")
	local openConsole: Instance = remotes and remotes:FindFirstChild("OpenConsole")

	if openConsole then
		openConsole.OnClientEvent:Connect(function()
			cmdrClient:Show()
		end)

		return
	end

	warn("[CmdrClientBootstrap] ReplicatedStorage.Remotes.OpenConsole missing; /openconsole will be a no-op for this client.")

	return
end

local function stripCmdrGui(p2)
	task.defer(function()
		if p2.Parent then
			p2:Destroy()
		end
	end)
end

local cmdr: Instance = playerGui:FindFirstChild("Cmdr")

if cmdr and cmdr:IsA("ScreenGui") then
	task.defer(function()
		if cmdr.Parent then
			cmdr:Destroy()
		end
	end)
end

playerGui.ChildAdded:Connect(function(p3: Instance)
	if p3.Name == "Cmdr" and p3:IsA("ScreenGui") then
		task.defer(function()
			if p3.Parent then
				p3:Destroy()
			end
		end)
	end
end)
