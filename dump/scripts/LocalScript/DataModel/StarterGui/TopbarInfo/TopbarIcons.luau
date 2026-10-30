-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local windowSlide = require(replicatedStorageShared:WaitForChild("WindowSlide"))
local v7: Instance = replicatedStorage:WaitForChild("Shared")
local updateLogData = require(v7:WaitForChild("UpdateLogData"))
local icon = require(replicatedStorage:WaitForChild("Icon"))
local LocalPlayer: Player = players.LocalPlayer
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")

local function makeToggleWindow(p1)
	local window = p1.window
	local windowPosition = window.Position
	local v31 = windowSlide.closedPosFor(windowPosition)

	window.Visible = false
	window.Position = v31

	local u32 = nil
	local u33: boolean = false

	local function cancelTween()
		if u32 then
			u32:Cancel()
			u32 = nil
		end
	end
	local function open()
		if u33 then
			return
		end

		if LocalPlayer:GetAttribute("DailyGiftsOpen") then
			return
		end

		u33 = true

		if u32 then
			u32:Cancel()
			u32 = nil
		end

		u32 = windowSlide.slideIn(window, windowPosition, v31)

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		activeWindowChanged:Fire(p1.name)
		windowBlur.show(p1.name)

		if p1.onOpen then
			p1.onOpen()
		end
	end
	local function close()
		if not u33 then
			return
		end

		u33 = false

		if u32 then
			u32:Cancel()
			u32 = nil
		end

		u32 = windowSlide.slideOut(window, v31, function()
			if not u33 then
				window.Visible = false
			end
		end)

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local v49 = math.max((mouseUnlocked or 0) - 1, 0)

		LocalPlayer:SetAttribute("MouseUnlocked", v49)
		windowBlur.hide(p1.name)
	end

	local v37 = icon.new():setName(p1.name)

	if p1.dropdownMode then
		v37:setLabel(p1.label or p1.name):oneClick()
	else
		v37:setImage(p1.iconImage):align("Left")
	end

	v37:bindEvent("selected", function()
		if u33 then
			close()
		else
			open()
		end

		v37:deselect()

		if p1.closeDropdown then
			p1.closeDropdown()
		end
	end)
	activeWindowChanged.Event:Connect(function(p2)
		if p2 ~= p1.name and u33 then
			close()
		end
	end)

	if p1.closeBindable then
		p1.closeBindable.Event:Connect(function()
			if u33 then
				close()
			end
		end)
	end

	window:GetPropertyChangedSignal("Visible"):Connect(function()
		if not window.Visible and u33 then
			u33 = false

			local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
			local v52 = math.max((mouseUnlocked or 0) - 1, 0)

			LocalPlayer:SetAttribute("MouseUnlocked", v52)
			windowBlur.hide(p1.name)
		end
	end)

	return {
		open = open,
		close = close,
		isOpen = function()
			return u33
		end,
		icon = v37
	}
end

local updateLogWindow: Instance = hud:WaitForChild("UpdateLogWindow")
local updateLog_Seen: Instance = remotes:WaitForChild("UpdateLog_Seen")
local closeUpdateLog: Instance = bindables:WaitForChild("CloseUpdateLog")

local v19 = makeToggleWindow({
	name = "UpdateLog",
	iconImage = "rbxassetid://104910050624931",
	window = updateLogWindow,
	closeBindable = closeUpdateLog,
	onOpen = function()
		updateLog_Seen:FireServer()
	end
})

local matchHistoryWindow: Instance = hud:WaitForChild("MatchHistoryWindow")
local closeMatchHistory: Instance = bindables:WaitForChild("CloseMatchHistory")
local v22 = makeToggleWindow({
	name = "MatchHistory",
	iconImage = "rbxassetid://77666466828006",
	window = matchHistoryWindow,
	closeBindable = closeMatchHistory
})
local v23 = icon.new():setName("Clans"):setImage("rbxassetid://133823034422531"):align("Left")

v23:bindEvent("selected", function()
	if LocalPlayer:GetAttribute("DataReady") == true then
		if _G.ToggleClans then
			_G.ToggleClans()
		end

		v23:deselect()

		return
	end
end)

local function inRealMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
		return true
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return true
	end

	return false
end
local function refreshLobbyIconsVisibility()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u41

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
		u41 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u41 = typeof(spectating) == "number" and spectating ~= 0
	end

	if u41 and v19.isOpen() then
		v19.close()
	end

	if u41 and v22.isOpen() then
		v22.close()
	end

	v19.icon:setEnabled(not u41)
	v22.icon:setEnabled(not u41)
	v23:setEnabled(not u41)
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshLobbyIconsVisibility)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshLobbyIconsVisibility)
refreshLobbyIconsVisibility()

local settingsWindow: Instance = hud:WaitForChild("SettingsWindow")
local closeSettings: Instance = bindables:WaitForChild("CloseSettings")

makeToggleWindow({
	name = "Settings",
	iconImage = "rbxassetid://14357671883",
	window = settingsWindow,
	closeBindable = closeSettings
})
task.spawn(function()
	local lastSeenUpdateLog: any = LocalPlayer:GetAttribute("LastSeenUpdateLog")
	local v44 = os.clock()

	while lastSeenUpdateLog == nil and os.clock() - v44 < 60 do
		task.wait(0.1)
		lastSeenUpdateLog = LocalPlayer:GetAttribute("LastSeenUpdateLog")
	end

	if lastSeenUpdateLog == nil then
	elseif lastSeenUpdateLog >= updateLogData.GetLatestId() then
	elseif LocalPlayer:GetAttribute("TutorialPhase") == 0 then
		local u45: boolean = false

		local connection = activeWindowChanged.Event:Connect(function()
			u45 = true
		end)

		repeat
			task.wait(0.1)
		until workspace:GetAttribute("LoadingScreenCompleted")

		task.wait(0.5)
		connection:Disconnect()

		if not u45 and not v19.isOpen() then
			v19.open()

			return
		end

		return
	end
end)
