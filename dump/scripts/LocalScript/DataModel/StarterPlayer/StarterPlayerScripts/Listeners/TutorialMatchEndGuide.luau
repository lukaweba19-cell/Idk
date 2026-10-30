-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared", 5)
local isReservedServer: Instance = matchmakingShared and matchmakingShared:WaitForChild("IsReservedServer", 3)

if isReservedServer ~= nil and isReservedServer.Value == true and matchmakingShared then
	local shared: Instance = replicatedStorage:WaitForChild("Shared")
	local tutorialSpotlight = require(shared:WaitForChild("TutorialSpotlight"))

	local function isTutorialServer()
		return matchmakingShared:GetAttribute("MMTutorialMatch") == true
	end
	local function winScreenOpen()
		return LocalPlayer:GetAttribute("_WinScreenOpen") == true
	end

	local u11 = nil
	local n1: number = 0

	local function teardown()
		n1 += 1

		if u11 then
			local v15 = u11

			u11 = nil
			pcall(function()
				v15:fadeOut(0.25)
			end)
		end
	end
	local function runGuide()
		if matchmakingShared:GetAttribute("MMTutorialMatch") ~= true then
			return
		end

		if LocalPlayer:GetAttribute("_WinScreenOpen") ~= true then
			return
		end

		if u11 then
			return
		end

		n1 += 1

		local v16: number = n1
		local v17 = nil

		while true do
			if LocalPlayer:GetAttribute("_WinScreenOpen") ~= true or v16 ~= n1 then
				break
			end

			local winScreen: Instance = playerGui:FindFirstChild("WinScreen")
			local postMatchActions: Instance = winScreen and winScreen:FindFirstChild("PostMatchActions")
			local v20: Instance = postMatchActions

			if v20 then
				v20 = postMatchActions:FindFirstChild("ReturnToLobbyAction")
			end

			if v20 and v20:IsA("GuiObject") then
				v17 = v20

				break
			end

			task.wait(0.1)
		end

		if not v17 then
			return
		end

		if v16 ~= n1 or LocalPlayer:GetAttribute("_WinScreenOpen") ~= true then
			return
		end

		local v21 = tutorialSpotlight.new()

		u11 = v21
		v21:pointAt(v17, true)
		v21:fadeIn(0.4)

		while true do
			if LocalPlayer:GetAttribute("_WinScreenOpen") ~= true or v16 ~= n1 then
				break
			end

			task.wait(0.2)
		end

		if v16 == n1 then
			n1 += 1

			if u11 then
				local v22 = u11

				u11 = nil
				pcall(function()
					v22:fadeOut(0.25)
				end)
			end
		end
	end

	LocalPlayer:GetAttributeChangedSignal("_WinScreenOpen"):Connect(function()
		if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
			task.spawn(runGuide)

			return
		end

		n1 += 1

		if u11 then
			local v23 = u11

			u11 = nil
			pcall(function()
				v23:fadeOut(0.25)
			end)
		end
	end)

	if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		task.spawn(runGuide)
	end

	return
end
