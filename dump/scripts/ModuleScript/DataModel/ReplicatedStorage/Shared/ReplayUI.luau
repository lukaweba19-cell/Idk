-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local replayFormat = require(shared:WaitForChild("ReplayFormat"))
local replayFormatMk_kill = replayFormat.MK_KILL
local color3 = Color3.fromRGB(255, 90, 90)
local replayFormatMk_round_start = replayFormat.MK_ROUND_START
local color32 = Color3.fromRGB(200, 200, 200)
local replayFormatMk_round_win = replayFormat.MK_ROUND_WIN
local color33 = Color3.fromRGB(255, 210, 90)
local replayFormatMk_ability = replayFormat.MK_ABILITY
local color34 = Color3.fromRGB(140, 200, 255)
local replayFormatMk_multikill = replayFormat.MK_MULTIKILL
local color35 = Color3.fromRGB(255, 140, 60)
local replayFormatMk_clutch = replayFormat.MK_CLUTCH
local color36 = Color3.fromRGB(190, 120, 255)
local replayFormatMk_match_point = replayFormat.MK_MATCH_POINT
local color37 = Color3.fromRGB(255, 255, 255)

local function hudRoot()
	local playerGui: Instance = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

	return playerGui and playerGui:FindFirstChild("HUD")
end

return {
	MarkerColors = {
		[replayFormatMk_kill] = color3,
		[replayFormatMk_round_start] = color32,
		[replayFormatMk_round_win] = color33,
		[replayFormatMk_ability] = color34,
		[replayFormatMk_multikill] = color35,
		[replayFormatMk_clutch] = color36,
		[replayFormatMk_match_point] = color37
	},
	MarkerNames = {
		[replayFormat.MK_KILL] = "Kill",
		[replayFormat.MK_ROUND_START] = "Round start",
		[replayFormat.MK_ROUND_WIN] = "Round won",
		[replayFormat.MK_ABILITY] = "Ability",
		[replayFormat.MK_MULTIKILL] = "Multikill",
		[replayFormat.MK_CLUTCH] = "Clutch",
		[replayFormat.MK_MATCH_POINT] = "Match point"
	},
	CloneFromHud = function(p1)
		local playerGui: Instance = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local u22: Instance = playerGui

		if u22 then
			u22 = playerGui:FindFirstChild("HUD")
		end

		for _, v in ipairs(p1) do
			if not u22 then
				return nil
			end

			u22 = u22:FindFirstChild(v)
		end

		if not u22 then
			return nil
		end

		local ok, result = pcall(function()
			return u22:Clone()
		end)

		return ok and result or nil
	end,
	CloneFromGui = function(p2, p3)
		local playerGui: Instance = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local u30: Instance = playerGui

		if u30 then
			u30 = playerGui:FindFirstChild(p2)
		end

		for _, v in ipairs(p3) do
			if not u30 then
				return nil
			end

			u30 = u30:FindFirstChild(v)
		end

		if not u30 then
			return nil
		end

		local ok, result = pcall(function()
			return u30:Clone()
		end)

		return ok and result or nil
	end,
	StripScripts = function(p4)
		for _, v in ipairs(p4:GetDescendants()) do
			if v:IsA("LuaSourceContainer") then
				v:Destroy()
			end
		end

		if p4:IsA("LuaSourceContainer") then
			p4:Destroy()
		end
	end,
	FormatTime = function(p5)
		local floored = math.floor(p5 / 1000)
		local v40 = math.max(0, floored)
		local stringFormat = string.format
		local floored2 = math.floor(v40 / 60)

		return stringFormat("%d:%02d", floored2, v40 % 60)
	end
}
