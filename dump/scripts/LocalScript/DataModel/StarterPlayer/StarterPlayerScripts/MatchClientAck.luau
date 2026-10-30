-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local util = replicatedStorage:WaitForChild("Util")
local lightingOverride = require(util:WaitForChild("LightingOverride"))
local replicatedStorageUtil = replicatedStorage:WaitForChild("Util")
local audioOverride = require(replicatedStorageUtil:WaitForChild("AudioOverride"))
local seaManager = require(script:WaitForChild("SeaManager"))
local LocalPlayer = players.LocalPlayer
local matchRemotes = replicatedStorage:WaitForChild("MatchRemotes")
local v10 = matchRemotes:WaitForChild("State")
local clientLoaded = matchRemotes:WaitForChild("ClientLoaded")
local n1: number = 0
local lightingOverrideSetMaterialsOff = lightingOverride.SetMaterialsOff
local disableTextures = LocalPlayer:GetAttribute("DisableTextures")

lightingOverrideSetMaterialsOff(disableTextures == true)
LocalPlayer:GetAttributeChangedSignal("DisableTextures"):Connect(function()
	local lightingOverrideSetMaterialsOff = lightingOverride.SetMaterialsOff
	local disableTextures2 = LocalPlayer:GetAttribute("DisableTextures")

	lightingOverrideSetMaterialsOff(disableTextures2 == true)
end)

local function waitForModelAndSomeParts(childName)
	local game: Instance = workspace:WaitForChild("Game", 10)

	if not game then
		return
	end

	local v24: Instance = game:WaitForChild(childName, 10)

	if not v24 then
		return
	end

	local v25 = os.clock()

	while true do
		if not (os.clock() - v25 < 10) or #v24:GetDescendants() >= v24:GetAttribute("DescendantCount") * 0.99 then
			break
		end

		task.wait(0.1)
	end
end
local function shouldAck(p2)
	local v27 = LocalPlayer:GetAttribute("MatchId") or LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u28: boolean = false

	if typeof(v27) == "string" then
		u28 = false

		if v27 == p2 then
			u28 = v27 ~= "PRACTICE"
		end
	end

	return u28
end
local function ack(p3)
	clientLoaded:FireServer(p3)
end

local u18 = nil

v10.OnClientEvent:Connect(function(p4, p5)
	if typeof(p5) == "table" then
		local v32 = LocalPlayer:GetAttribute("MatchId") or LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u33: boolean = false

		if typeof(v32) == "string" then
			u33 = false

			if v32 == p4 then
				u33 = v32 ~= "PRACTICE"
			end
		end

		if not u33 then
		elseif p5.t == "MatchStarted" or p5.t == "RoundLoading" then
			n1 += 1
			waitForModelAndSomeParts(p5.mapName)
			clientLoaded:FireServer(p4)

			local foundChild = workspace.Game:FindFirstChild(p5.mapName)

			if foundChild and foundChild:IsA("Model") then
				lightingOverride.ApplyFromMap(foundChild)
				audioOverride.ApplyFromMap(foundChild)

				local v35 = not u18 and foundChild:WaitForChild("WaterBouncy", 10)
				local waterBouncy = v35 and v35:WaitForChild("WaterBouncy", 10)

				if waterBouncy then
					u18 = seaManager.new(waterBouncy.Position)
					u18:Play()

					return
				end
			end
		elseif p5.t == "MatchEnded" then
			local v37: number = n1

			task.spawn(function()
				local v48 = os.clock()

				while true do
					if LocalPlayer:GetAttribute("_WinScreenOpen") ~= true or not (os.clock() - v48 < 130) then
						break
					end

					task.wait()
				end

				if n1 ~= v37 then
					return
				end

				lightingOverride.Clear()
				audioOverride.Clear()

				if u18 then
					u18:Stop()
					u18 = nil
				end
			end)
		end

		return
	end
end)

local function tryApplyMapLightingForSpectate()
	local lobbySpectateMatchId = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" and lobbySpectateMatchId ~= "PRACTICE" then
		local spectating = LocalPlayer:GetAttribute("Spectating")

		if typeof(spectating) == "number" and spectating ~= 0 then
			local v40 = game.Players:GetPlayerByUserId(spectating)

			if not v40 then
				return
			end

			local matchId = v40:GetAttribute("MatchId")

			if lobbySpectateMatchId ~= matchId then
				return
			end

			for _, v in ipairs(workspace.Game:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("LightingSettings") and string.find(v.Name, "_" .. matchId, 1, true) then
					lightingOverride.ApplyFromMap(v)
					audioOverride.ApplyFromMap(v)

					local v44 = not u18 and v:WaitForChild("WaterBouncy", 10)

					if v44 then
						local waterBouncy = v44:WaitForChild("WaterBouncy", 10)

						if waterBouncy and waterBouncy:IsA("BasePart") then
							u18 = seaManager.new(waterBouncy.Position)
							u18:Play()
						end
					end

					return
				end
			end

			return
		end

		return
	end
end

LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(function()
	local lobbySpectateMatchId = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		task.delay(0.5, tryApplyMapLightingForSpectate)

		return
	end

	lightingOverride.Clear()
	audioOverride.Clear()

	if u18 then
		u18:Stop()
		u18 = nil
	end
end)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local spectating = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		task.delay(0.3, tryApplyMapLightingForSpectate)
	end
end)
