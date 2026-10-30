-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if not require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local screenWipe = require(shared:WaitForChild("ScreenWipe"))
local backToLobbyPart: Instance = workspace:WaitForChild("Lobby"):WaitForChild("BackToLobbyPart", 30)

if not backToLobbyPart or not backToLobbyPart:IsA("BasePart") then
	return
end

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local lobbyTeleport: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("LobbyTeleport")
local openPlazaServerList: Instance = bindables:WaitForChild("OpenPlazaServerList", 10)
local LocalPlayer: Player = players.LocalPlayer
local n1 = backToLobbyPart.Size.Magnitude / 2 + 8
local u11: boolean = false
local n2: number = 0
local u13: boolean = false

local function rootPart()
	local Character: Model = LocalPlayer.Character
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		return humanoidRootPart
	end

	return nil
end

lobbyTeleport.OnClientEvent:Connect(function(p1)
	if p1 == "failed" and u13 then
		u13 = false
		n2 += 1
		screenWipe.reveal(0.5)
		u11 = false
	end
end)
backToLobbyPart.Touched:Connect(function(p2)
	if u11 then
		return
	end

	local Character: Model = LocalPlayer.Character

	if not Character or not p2:IsDescendantOf(Character) then
		return
	end

	local Character2: Model = LocalPlayer.Character
	local humanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

	if not (if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil) then
		return
	end

	u11 = true

	local plazaTeleportChoice: Instance = bindables:WaitForChild("PlazaTeleportChoice", 5)

	if not plazaTeleportChoice then
		u11 = false

		return
	end

	local plazaTeleportChoiceCancel: Instance = bindables:FindFirstChild("PlazaTeleportChoiceCancel")
	local u24: boolean = true

	if plazaTeleportChoiceCancel then
		task.spawn(function()
			while u24 do
				local Character3: Model = LocalPlayer.Character
				local humanoidRootPart = Character3 and Character3:FindFirstChild("HumanoidRootPart")
				local v29 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

				if not v29 or (v29.Position - backToLobbyPart.Position).Magnitude > n1 then
					if not u24 then
						break
					end

					plazaTeleportChoiceCancel:Fire()

					return
				end

				task.wait(0.1)
			end
		end)
	end

	local v25 = plazaTeleportChoice:Invoke({
		Header = "Lobby",
		Body = "Teleport back to the Lobby?",
		AcceptText = "Lobby",
		ServersText = "Trade Servers"
	})

	u24 = false

	if v25 == "servers" then
		if openPlazaServerList then
			openPlazaServerList:Fire()
		end

		task.wait(1)
		u11 = false

		return
	end

	if v25 == "teleport" then
		n2 += 1

		local v26: number = n2

		u13 = true
		screenWipe.cover(0.5, "Teleporting to Lobby")
		lobbyTeleport:FireServer()
		task.delay(12, function()
			if n2 ~= v26 then
				return
			end

			u13 = false
			screenWipe.reveal(0.5)
			u11 = false
		end)

		return
	end

	task.wait(1)
	u11 = false
end)
