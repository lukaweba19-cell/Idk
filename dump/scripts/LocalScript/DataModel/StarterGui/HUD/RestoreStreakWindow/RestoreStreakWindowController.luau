-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local winStreakConfig = require(shared:WaitForChild("WinStreakConfig"))
local streakRestore: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("StreakRestore")
local restoreStreakButton: Instance = hud:WaitForChild("LobbyButtons"):WaitForChild("LobbyButtons"):WaitForChild("RestoreStreakButton")
local v9: Instance = restoreStreakButton:WaitForChild("ImageLabel"):WaitForChild("Value")
local restoreStreakWindow: Instance = hud:WaitForChild("RestoreStreakWindow")
local v11: Instance = restoreStreakWindow:WaitForChild("WinstreakStat"):WaitForChild("ImageLabel"):WaitForChild("Value")
local buyButton: Instance = restoreStreakWindow:WaitForChild("BuyButton")
local textLabel: Instance = buyButton:WaitForChild("TextLabel"):WaitForChild("TextLabel")
local restoreStreakWindowTextLabel: Instance = restoreStreakWindow:WaitForChild("TextLabel")
local u15: boolean = false

local function formatCash(p1)
	return "$" .. tostring(p1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end
local function notify(p2, p3)
	_G.Notify({
		notifType = p3 or "FailNotification",
		errorMessage = p2,
		topText = if p3 == "SuccessNotification" then "Success!" else nil,
		bottomText = if p3 == "SuccessNotification" then p2 else nil
	})
end
local function hasPendingRestore()
	if (LocalPlayer:GetAttribute("StreakRestoreCost") or 0) <= 0 then
		return false
	end

	local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")
	local u26: boolean = false

	if typeof(pendingStreakRestore) == "number" then
		u26 = pendingStreakRestore >= winStreakConfig.MIN_DISPLAY_STREAK
	end

	return u26
end
local function getPendingStreak()
	local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")

	if typeof(pendingStreakRestore) == "number" then
		return pendingStreakRestore
	end

	return 0
end
local function updateUI(p4)
	local streakRestoreCost: any = LocalPlayer:GetAttribute("StreakRestoreCost")
	local s1

	if typeof(streakRestoreCost) == "number" and not (streakRestoreCost <= 0) then
		s1 = "$" .. tostring(streakRestoreCost):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	else
		s1 = "..."
	end

	v9.Text = tostring(p4)
	v11.Text = tostring(p4)
	restoreStreakWindowTextLabel.Text = "Restore your " .. tostring(p4) .. " win streak?"
	textLabel.Text = s1
	textLabel.Parent.Text = textLabel.Text
end
local function enforceButtonVisibility()
	local u31

	if (LocalPlayer:GetAttribute("StreakRestoreCost") or 0) <= 0 then
		u31 = false
	else
		local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")

		u31 = false

		if typeof(pendingStreakRestore) == "number" then
			u31 = pendingStreakRestore >= winStreakConfig.MIN_DISPLAY_STREAK
		end
	end

	if u31 then
		local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")
		local typeName: string = typeof(pendingStreakRestore)

		updateUI(if typeName == "number" then pendingStreakRestore else 0)
	end

	if u31 ~= restoreStreakButton.Visible then
		restoreStreakButton.Visible = u31
	end
end

LocalPlayer:GetAttributeChangedSignal("PendingStreakRestore"):Connect(enforceButtonVisibility)
LocalPlayer:GetAttributeChangedSignal("StreakRestoreCost"):Connect(enforceButtonVisibility)
restoreStreakButton:GetPropertyChangedSignal("Visible"):Connect(function()
	task.defer(function()
		if restoreStreakButton.Visible then
			local u40

			if (LocalPlayer:GetAttribute("StreakRestoreCost") or 0) <= 0 then
				u40 = false
			else
				local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")

				u40 = false

				if typeof(pendingStreakRestore) == "number" then
					u40 = pendingStreakRestore >= winStreakConfig.MIN_DISPLAY_STREAK
				end
			end

			if not u40 then
				restoreStreakButton.Visible = false
			end
		end
	end)
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	task.defer(enforceButtonVisibility)
end)
task.defer(enforceButtonVisibility)
buyButton.MouseButton1Click:Connect(function()
	if u15 then
		return
	end

	u15 = true

	local ok, result = pcall(function()
		return streakRestore:InvokeServer("Restore")
	end)

	if not ok or not result or not result.success then
		_G.Notify({
			notifType = "FailNotification",
			topText = nil,
			bottomText = nil,
			errorMessage = result and result.message or "Failed to restore streak"
		})
	end

	u15 = false
end)
LocalPlayer:GetAttributeChangedSignal("PendingStreakRestore"):Connect(function()
	local u37

	if (LocalPlayer:GetAttribute("StreakRestoreCost") or 0) <= 0 then
		u37 = false
	else
		local pendingStreakRestore: any = LocalPlayer:GetAttribute("PendingStreakRestore")

		u37 = false

		if typeof(pendingStreakRestore) == "number" then
			u37 = pendingStreakRestore >= winStreakConfig.MIN_DISPLAY_STREAK
		end
	end

	if not u37 and restoreStreakWindow.Visible then
		restoreStreakWindow.Visible = false

		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		require(shared:WaitForChild("WindowBlur")).hide("LobbyPanel")
	end
end)
