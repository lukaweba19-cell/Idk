-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local LocalPlayer: Player = players.LocalPlayer
local u6 = nil
local u7 = nil

local function getOrCreateEffect()
	if u6 then
		u6:Pause()
		u6:Destroy()
		u6 = nil
	end

	if u7 then
		u7:Pause()
		u7:Destroy()
		u7 = nil
	end

	if lighting:FindFirstChild("MatchFlash") then
		return lighting.MatchFlash
	end

	local matchFlash: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

	matchFlash.Name = "MatchFlash"
	matchFlash.Brightness = 0
	matchFlash.Parent = lighting

	return matchFlash
end
local function playFlashTransition()
	local v13 = getOrCreateEffect()
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	u6 = tweenService:Create(v13, tweenInfo, { Brightness = 2 })
	u6:Play()
	u6.Completed:Connect(function()
		local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		u7 = tweenService:Create(v13, tweenInfo2, { Brightness = 0 })
		u7.Completed:Connect(function()
			v13:Destroy()
		end)
		u7:Play()
	end)
end
local function fadeToBlackThenBack()
	local v15 = getOrCreateEffect()
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	u6 = tweenService:Create(v15, tweenInfo, { Brightness = -2 })
	u6:Play()
	u6.Completed:Connect(function()
		local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		u7 = tweenService:Create(v15, tweenInfo3, { Brightness = 0 })
		u7.Completed:Connect(function()
			v15:Destroy()
		end)
		u7:Play()
	end)
end
local function getMyMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" then
		return matchId
	end

	return nil
end;

(function()
	local matchRemotes: Instance = replicatedStorage:WaitForChild("MatchRemotes", 30)

	if not matchRemotes then
		warn("[MatchTransition] MatchRemotes folder not found")

		return
	end

	local v19: Instance = matchRemotes:WaitForChild("State", 30)

	if not v19 then
		warn("[MatchTransition] State RemoteEvent not found")

		return
	end

	v19.OnClientEvent:Connect(function(p1, p2)
		if typeof(p2) == "table" then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v25 = if typeof(matchId) == "string" then matchId else nil

			if not v25 or p1 ~= v25 then
			elseif p2.t == "MatchStarted" then
				playFlashTransition()
			elseif p2.t == "RoundLoading" then
				fadeToBlackThenBack()
			end

			return
		end
	end)
end)()
