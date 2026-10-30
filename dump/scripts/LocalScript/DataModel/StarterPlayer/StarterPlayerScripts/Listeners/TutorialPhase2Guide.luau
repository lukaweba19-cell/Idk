-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tutorialSpotlight = require(shared:WaitForChild("TutorialSpotlight"))
local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared", 5)
local isReservedServer: Instance = matchmakingShared and matchmakingShared:WaitForChild("IsReservedServer", 3)

if isReservedServer == nil or isReservedServer.Value ~= true then
	local hud: Instance = playerGui:WaitForChild("HUD")
	local winScreen: Instance = playerGui:WaitForChild("WinScreen")
	local abilitiesButton: Instance = hud:WaitForChild("LobbyButtons"):WaitForChild("LobbyButtons"):WaitForChild("AbilitiesButton")
	local abilitiesWindow: Instance = hud:WaitForChild("AbilitiesWindow")
	local items: Instance = abilitiesWindow:WaitForChild("Container"):WaitForChild("Items"):WaitForChild("Items")
	local filters: Instance = abilitiesWindow:WaitForChild("Container"):WaitForChild("Filters")
	local buyButton: Instance = filters:WaitForChild("BuyButton")

	replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")

	local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
	local abilities_Request: Instance = remotes:WaitForChild("Abilities_Request")
	local abilities_Push: Instance = remotes:WaitForChild("Abilities_Push")

	local function isWinScreenVisible()
		return winScreen.Enabled
	end
	local function isAbilitiesWindowOpen()
		return abilitiesWindow.Visible
	end
	local function waitForWinScreenDismissed()
		if not winScreen.Enabled then
			return
		end

		while winScreen.Enabled do
			task.wait(0.2)
		end

		task.wait(0.3)
	end
	local function findTileByName(p1)
		return (items:FindFirstChild(p1))
	end
	local function waitForTile(p2, p3)
		local v34 = os.clock()

		while true do
			local v35 = os.clock()

			if not ((p3 or 10) > v35 - v34) then
				break
			end

			local foundChild: Instance = items:FindFirstChild(p2)

			if foundChild then
				return foundChild
			end

			task.wait()
		end

		return nil
	end
	local function isAbilityUnlocked(p4)
		local ok, result = pcall(function()
			return abilities_Request:InvokeServer("GetSnapshot", nil)
		end)

		if ok and typeof(result) == "table" and typeof(result.Unlocked) == "table" then
			for _, v in ipairs(result.Unlocked) do
				if v == p4 then
					return true
				end
			end

			return false
		end

		return false
	end
	local function areAbilitiesUnlocked(...)
		local ok, result = pcall(function()
			return abilities_Request:InvokeServer("GetSnapshot", nil)
		end)

		if ok and typeof(result) == "table" and typeof(result.Unlocked) == "table" then
			for _, v in ipairs({ ... }) do
				local u46: boolean = false

				for _, iterValue in ipairs(result.Unlocked) do
					if iterValue == v then
						u46 = true
					end
				end

				if not u46 then
					return false
				end
			end

			return true
		end

		return false
	end
	local function waitForAbilityUnlocked(p5, p6)
		if isAbilityUnlocked(p5) then
			return true
		end

		local u51: boolean = false

		local connection = abilities_Push.OnClientEvent:Connect(function(p7, p8)
			if p7 == "Snapshot" and typeof(p8) == "table" and typeof(p8.Unlocked) == "table" then
				for _, v in ipairs(p8.Unlocked) do
					if v == p5 then
						u51 = true
					end
				end
			end
		end)

		while not u51 do
			if not p6() or not abilitiesWindow.Visible then
				return false
			end

			task.wait(0.05)
		end

		if connection then
			connection:Disconnect()
		end

		return true
	end
	local function guideAbilityPurchase(p9, p10)
		local brk0: boolean = false
		local v55 = waitForTile(p10, 15)

		if not v55 then
			warn("[TutorialPhase2Guide] Could not find tile for " .. p10)

			return false
		end

		local v56 = replicatedStorage:WaitForChild("Catalogs")

		v56 = require(v56:WaitForChild("AbilityCatalog")).Get(p10)

		local v57 = v56 and v56.DisplayName or p10
		local skillName: Instance = filters:FindFirstChild("SkillName")

		while abilitiesWindow.Visible do
			brk0 = false
			p9:pointAt(v55)

			while abilitiesWindow.Visible do
				if skillName and v57 == skillName.Text and buyButton.Visible then
					p9:pointAt(buyButton)
					p9:setSuppressFade(true)

					if waitForAbilityUnlocked(p10, function()
						local v78 = skillName

						if v78 then
							v78 = false

							if skillName.Text == v57 then
								v78 = buyButton.Visible
							end
						end

						return v78
					end) then
						return true
					end

					if not abilitiesWindow.Visible then
						return true
					end

					brk0 = true

					break
				end

				task.wait()
			end

			if not brk0 then
				return true
			end
		end

		return true
	end
	local function runPhase2Guide()
		local tutorialPhase
		local typeName
		local v61
		local tutorialPhase2
		local typeName2
		local v64
		local v65
		local v66
		local dailyTasks
		local v68
		local v69
		local v70
		local v71
		local state: number = 0

		while true do
			if state == 0 then
				waitForWinScreenDismissed()
				tutorialPhase = LocalPlayer:GetAttribute("TutorialPhase")
				typeName = typeof(tutorialPhase)
				state = if typeName == "number" and tutorialPhase == 2 then 3 else 2
			elseif state == 1 then
				state = if tutorialPhase == 2 then 1 else 1
			elseif state == 2 then
				return
			elseif state == 3 then
				v61 = tutorialSpotlight.new()
				v61:pointAt(abilitiesButton, true)
				state = 4
			elseif state == 4 then
				v61:fadeIn(0.4)
				state = 5
			elseif state == 5 then
				state = if not abilitiesWindow.Visible then 6 else 10
			elseif state == 6 then
				task.wait()
				tutorialPhase2 = LocalPlayer:GetAttribute("TutorialPhase")
				typeName2 = typeof(tutorialPhase2)
				state = if typeName2 == "number" and tutorialPhase2 == 2 then 9 else 8
			elseif state == 7 then
				state = if tutorialPhase2 == 2 then 7 else 7
			elseif state == 8 then
				v61:fadeOut(0.3)

				return
			elseif state == 9 then
				state = 5
			elseif state == 10 then
				task.wait(0.1)
				v61:setSuppressFade(true)
				v64 = isAbilityUnlocked("TripleKnife")
				state = if not v64 and not guideAbilityPurchase(v61, "TripleKnife") then 12 else 13
			elseif state == 11 then
				state = if not guideAbilityPurchase(v61, "TripleKnife") then 11 else 11
			elseif state == 12 then
				v61:fadeOut(0.3)

				return
			elseif state == 13 then
				v65 = isAbilityUnlocked("BarrageBullet")
				state = if not v65 and not guideAbilityPurchase(v61, "BarrageBullet") then 15 else 16
			elseif state == 14 then
				state = if not guideAbilityPurchase(v61, "BarrageBullet") then 14 else 14
			elseif state == 15 then
				v61:fadeOut(0.3)

				return
			elseif state == 16 then
				v66 = areAbilitiesUnlocked("BarrageBullet", "TripleKnife")
				state = if not v66 then 17 else 18
			elseif state == 17 then
				v61:pointAt(abilitiesButton)
				state = 26
			elseif state == 18 then
				v61:setSuppressFade(false)
				v61:fadeOut(0.3)
				state = 19
			elseif state == 19 then
				state = if abilitiesWindow.Visible then 20 else 21
			elseif state == 20 then
				task.wait()
				state = 19
			elseif state == 21 then
				task.wait(0.3)
				dailyTasks = hud:FindFirstChild("DailyTasks")
				v68 = dailyTasks and dailyTasks:FindFirstChild("QuestFrame")
				v69 = v68 and v68:FindFirstChild("QuestTemplate1")
				v70 = v69 and v69:IsA("GuiObject")
				state = if v70 then 25 else 26
			elseif state == 22 then
				state = 22
			elseif state == 23 then
				state = 23
			elseif state == 24 then
				state = 24
			elseif state == 25 then
				v71 = tutorialSpotlight.new()
				v71:pointAt(v69, true)
				v71:fadeIn(0.3)
				task.wait(3)
				v71:fadeOut(0.4)
				state = 26
			elseif state == 26 then
				state = 4
			elseif state == 27 or state == 28 then
				return
			end
		end
	end
	local function checkAndRun()
		local tutorialPhase: any = LocalPlayer:GetAttribute("TutorialPhase")

		if typeof(tutorialPhase) == "number" and tutorialPhase == 2 then
			runPhase2Guide()
		end
	end

	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local tutorialPhase: any = LocalPlayer:GetAttribute("TutorialPhase")

	if typeof(tutorialPhase) == "number" and tutorialPhase == 2 then
		runPhase2Guide()
	end

	LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(function()
		local tutorialPhase2: any = LocalPlayer:GetAttribute("TutorialPhase")

		if typeof(tutorialPhase2) == "number" and tutorialPhase2 == 2 then
			task.defer(runPhase2Guide)
		end
	end)

	return
end
