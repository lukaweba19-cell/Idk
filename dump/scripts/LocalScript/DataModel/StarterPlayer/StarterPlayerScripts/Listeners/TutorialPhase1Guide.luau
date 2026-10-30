-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tutorialSpotlight = require(shared:WaitForChild("TutorialSpotlight"))
local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared")
local isReservedServer: Instance = matchmakingShared:WaitForChild("IsReservedServer", 3)
local u9: boolean = isReservedServer ~= nil and isReservedServer.Value == true

local function backendAvailable()
	return matchmakingShared:FindFirstChild("Remotes") ~= nil
end
local function isPhase1()
	return LocalPlayer:GetAttribute("TutorialPhase") == 1
end
local function getPlayButton()
	local hud: Instance = playerGui:FindFirstChild("HUD")
	local lobbyTopButtons: Instance = hud and hud:FindFirstChild("LobbyTopButtons")
	local v20: Instance = lobbyTopButtons

	if v20 then
		v20 = lobbyTopButtons:FindFirstChild("PlayBtn")
	end

	if v20 and v20:IsA("GuiObject") then
		return v20
	end

	return nil
end
local function getPanelAndStart()
	local matchmaking: Instance = playerGui:FindFirstChild("Matchmaking")
	local matchmake: Instance = matchmaking and matchmaking:FindFirstChild("Matchmake")

	if not matchmake or not matchmake:IsA("GuiObject") then
		return nil, nil
	end

	local btnContainer: Instance = matchmake:FindFirstChild("BtnContainer")

	if not btnContainer then
		return nil, nil
	end

	local startBtn: Instance = btnContainer:FindFirstChild("StartBtn")

	if startBtn and startBtn:IsA("GuiObject") then
		return matchmake, startBtn
	end

	return matchmake, nil
end

local u14 = nil
local n1: number = 0

local function teardown()
	n1 += 1

	if u14 then
		local v25 = u14

		u14 = nil
		pcall(function()
			v25:fadeOut(0.25)
		end)
	end
end
local function runPhase1Guide()
	if not not u9 or matchmakingShared:FindFirstChild("Remotes") == nil then
		return
	end

	if LocalPlayer:GetAttribute("TutorialPhase") ~= 1 then
		return
	end

	if u14 then
		return
	end

	n1 += 1

	local v26: number = n1
	local v27 = nil
	local v28 = os.clock()

	while true do
		if not (os.clock() - v28 < 10) then
			break
		end

		if v26 ~= n1 or LocalPlayer:GetAttribute("TutorialPhase") ~= 1 then
			return
		end

		local hud: Instance = playerGui:FindFirstChild("HUD")
		local lobbyTopButtons: Instance = hud and hud:FindFirstChild("LobbyTopButtons")
		local v31: Instance = lobbyTopButtons

		if v31 then
			v31 = lobbyTopButtons:FindFirstChild("PlayBtn")
		end

		v27 = if v31 and v31:IsA("GuiObject") then v31 else nil

		if v27 then
			break
		end

		task.wait(0.1)
	end

	if not v27 then
	elseif v26 == n1 and LocalPlayer:GetAttribute("TutorialPhase") == 1 then
		local v32 = tutorialSpotlight.new()

		u14 = v32

		local v33 = nil
		local u34: boolean = false

		while true do
			if LocalPlayer:GetAttribute("TutorialPhase") ~= 1 or v26 ~= n1 then
				break
			end

			local v35, v36 = getPanelAndStart()
			local v37

			if v35 ~= nil and v35.Visible and v36 ~= nil then
				v37 = v36
			else
				local hud2: Instance = playerGui:FindFirstChild("HUD")
				local hud2LobbyTopButtons: Instance = hud2 and hud2:FindFirstChild("LobbyTopButtons")
				local v40: Instance = hud2LobbyTopButtons

				if v40 then
					v40 = hud2LobbyTopButtons:FindFirstChild("PlayBtn")
				end

				v37 = (if v40 and v40:IsA("GuiObject") then v40 else nil) or v27
			end

			if v37 ~= nil and v37 ~= v33 then
				v33 = v37
				v32:pointAt(v37, true)

				if not u34 then
					u34 = true
					v32:fadeIn(0.4)
				end
			end

			task.wait(0.15)
		end

		if v26 == n1 then
			n1 += 1

			if u14 then
				local v41 = u14

				u14 = nil
				pcall(function()
					v41:fadeOut(0.25)
				end)
			end
		end

		return
	end
end

if LocalPlayer:GetAttribute("DataReady") ~= true then
	LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
end

if LocalPlayer:GetAttribute("TutorialPhase") == 1 then
	task.spawn(runPhase1Guide)
end

LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(function()
	if LocalPlayer:GetAttribute("TutorialPhase") == 1 then
		task.spawn(runPhase1Guide)

		return
	end

	n1 += 1

	if u14 then
		local v42 = u14

		u14 = nil
		pcall(function()
			v42:fadeOut(0.25)
		end)
	end
end)
