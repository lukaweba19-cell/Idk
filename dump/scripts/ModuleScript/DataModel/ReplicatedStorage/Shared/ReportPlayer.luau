-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:GetService("RunService"):IsServer() then
	error("Shared.ReportPlayer is client-only (ReportService owns the server half)", 2)
end

local t1: {[any]: any} = { Cheating = "cheat", Other = "other" }

local function notifyFail(p1)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p1 })
	end
end
local function getConfirmFn()
	local LocalPlayer: Player = players.LocalPlayer
	local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
	local v9 = playerGui

	if v9 then
		v9 = playerGui:FindFirstChild("Bindables")
	end

	local confirmModal = v9 and v9:FindFirstChild("ConfirmModal")

	return confirmModal and confirmModal:IsA("BindableFunction") and confirmModal or nil
end

return {
	Request = function(p2, p3, p4, p5)
		if typeof(p2) == "number" then
			local v15 = t1[p4]

			if not v15 then
				return
			end

			local LocalPlayer: Player = players.LocalPlayer
			local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
			local v18 = playerGui

			if v18 then
				v18 = playerGui:FindFirstChild("Bindables")
			end

			local confirmModal = v18 and v18:FindFirstChild("ConfirmModal")
			local v20 = confirmModal and confirmModal:IsA("BindableFunction") and confirmModal or nil

			if v20 and not v20:Invoke({
				Header = "Report Player?",
				AcceptText = "Report",
				DeclineText = "Cancel",
				Body = ("Report %s for %s? False reports may affect your own account."):format(p3 or "this player", if p4 == "Cheating" then "cheating" else "another reason")
			}) then
				return
			end

			local remotes: Instance = replicatedStorage:FindFirstChild("Remotes")
			local v22: Instance = remotes

			if v22 then
				v22 = remotes:FindFirstChild("ReportPlayer")
			end

			if not v22 or not v22:IsA("RemoteFunction") then
				if _G.Notify then
					_G.Notify({
						notifType = "FailNotification",
						errorMessage = "Reporting is unavailable."
					})
				end

				return
			end

			local ok, result = pcall(function()
				return v22:InvokeServer({ TargetUserId = p2, Reason = v15, Origin = p5 or "live" })
			end)

			if ok and typeof(result) == "table" then
				if result.ok ~= true then
					local typeName: string = typeof(result.err)

					if _G.Notify then
						_G.Notify({
							notifType = "FailNotification",
							errorMessage = typeName == "string" and result.err or "Couldn't submit."
						})
					end
				elseif _G.Notify then
					_G.Notify({
						notifType = "SuccessNotification",
						topText = "Report Submitted",
						bottomText = "Thanks. We'll take a look."
					})

					return
				end
			elseif _G.Notify then
				_G.Notify({
					notifType = "FailNotification",
					errorMessage = "Couldn't submit. Try again."
				})
			end

			return
		end
	end
}
