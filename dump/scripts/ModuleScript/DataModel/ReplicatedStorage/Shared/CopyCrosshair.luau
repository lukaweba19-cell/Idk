-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local httpService: HttpService = game:GetService("HttpService")

if not runService:IsClient() then
	error("Shared.CopyCrosshair is client-only (SettingsService owns the server half)", 2)
end

local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local updateSettings: Instance = remotes:WaitForChild("UpdateSettings")
local n1: number = 0

updateSettings.OnClientEvent:Connect(function(p1, p2)
	if p1 ~= "CrosshairCopyResult" then
		return
	end

	if n1 <= 0 then
		return
	end

	n1 -= 1

	if not _G.Notify then
		return
	end

	if p2 == true then
		_G.Notify({
			notifType = "SuccessNotification",
			topText = "Crosshair Copied",
			bottomText = "Their crosshair is now yours."
		})

		return
	end

	_G.Notify({
		notifType = "FailNotification",
		errorMessage = "Couldn't copy that crosshair."
	})
end)

local function recordedCrosshairFor(p3)
	local LocalPlayer: Player = players.LocalPlayer
	local v16 = LocalPlayer and LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(v16) == "string" and v16 ~= "" then
		local replayRoster: Instance = replicatedStorage:FindFirstChild("ReplayRoster")

		if not replayRoster then
			return nil
		end

		for _, v in ipairs(replayRoster:GetChildren()) do
			local userId = v:GetAttribute("UserId")

			if p3 == userId and v16 == v:GetAttribute("MatchId") then
				local crosshair = v:GetAttribute("Crosshair")

				return typeof(crosshair) == "string" and crosshair ~= "" and crosshair or nil
			end
		end

		return nil
	end

	return nil
end

local u10 = nil

local function getConfirmFn()
	if u10 == nil then
		u10 = bindables:WaitForChild("ConfirmModal", 5)
	end

	return u10
end

return {
	Request = function(p4, p5)
		if typeof(p4) == "number" then
			local LocalPlayer: Player = players.LocalPlayer

			if LocalPlayer and p4 == LocalPlayer.UserId then
				return
			end

			if u10 == nil then
				u10 = bindables:WaitForChild("ConfirmModal", 5)
			end

			local v25 = u10

			if not v25 then
				return
			end

			local typeName: string = typeof(p5)
			local v27 = recordedCrosshairFor(p4)
			local v28 = nil

			if v27 then
				local ok, result = pcall(function()
					return httpService:JSONDecode(v27)
				end)

				if ok and typeof(result) == "table" then
					v28 = result
				end
			end

			local v31 = ("Replace your crosshair with %s's? Your current crosshair settings will be overwritten."):format(typeName == "string" and p5 ~= "" and p5 or "this player")

			if v25:Invoke({
				Header = "Copy Crosshair?",
				AcceptText = "Copy",
				DeclineText = "Cancel",
				Body = v31
			}) == true then
				n1 += 1

				if v28 then
					updateSettings:FireServer("CopyCrosshairStyle", v28)

					return
				end

				updateSettings:FireServer("CopyCrosshair", p4)

				return
			end

			return
		end
	end
}
