-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local windowBlur = require(replicatedStorage.Shared:WaitForChild("WindowBlur"))
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local uDim2 = UDim2.new(0.3, 0, 0.85, 0)
local uDim22 = UDim2.new(0.3, 0, 0.75, 0)
local uDim23 = UDim2.new(0.3, 0, 1.15, 0)
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local u11 = nil
local u12 = false

local function isInMatch()
	return LocalPlayer:GetAttribute("InMatch") ~= nil
end
local function onDuelPad()
	return LocalPlayer:GetAttribute("DuelStationQueued") == true
end
local function goTo(p1)
	if u11 then
		u11:Cancel()
	end

	u11 = tweenService:Create(scriptParent, tweenInfo, { Position = p1 })
	u11:Play()
end
local function apply()
	if LocalPlayer:GetAttribute("InMatch") ~= nil then
		if u11 then
			u11:Cancel()
		end

		scriptParent.Position = uDim23
		scriptParent.Visible = false

		return
	end

	scriptParent.Visible = true

	if u12 then
		if u11 then
			u11:Cancel()
		end

		u11 = tweenService:Create(scriptParent, tweenInfo, { Position = uDim23 })
		u11:Play()

		return
	end

	local duelStationQueued: any = LocalPlayer:GetAttribute("DuelStationQueued")

	if u11 then
		u11:Cancel()
	end

	u11 = tweenService:Create(scriptParent, tweenInfo, {
		Position = if duelStationQueued == true then uDim22 else uDim2
	})
	u11:Play()
end

windowBlur.onActiveChanged(function(p2)
	u12 = p2

	if LocalPlayer:GetAttribute("InMatch") ~= nil then
		if u11 then
			u11:Cancel()
		end

		scriptParent.Position = uDim23
		scriptParent.Visible = false

		return
	end

	scriptParent.Visible = true

	if u12 then
		if u11 then
			u11:Cancel()
		end

		u11 = tweenService:Create(scriptParent, tweenInfo, { Position = uDim23 })
		u11:Play()

		return
	end

	local duelStationQueued: any = LocalPlayer:GetAttribute("DuelStationQueued")

	if u11 then
		u11:Cancel()
	end

	u11 = tweenService:Create(scriptParent, tweenInfo, {
		Position = if duelStationQueued == true then uDim22 else uDim2
	})
	u11:Play()
end)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(apply)
LocalPlayer:GetAttributeChangedSignal("DuelStationQueued"):Connect(apply)

if LocalPlayer:GetAttribute("InMatch") ~= nil then
	if u11 then
		u11:Cancel()
	end

	scriptParent.Position = uDim23
	scriptParent.Visible = false
else
	scriptParent.Visible = true

	if u12 then
		if u11 then
			u11:Cancel()
		end

		u11 = tweenService:Create(scriptParent, tweenInfo, { Position = uDim23 })
	else
		local duelStationQueued: any = LocalPlayer:GetAttribute("DuelStationQueued")

		if u11 then
			u11:Cancel()
		end

		u11 = tweenService:Create(scriptParent, tweenInfo, {
			Position = if if duelStationQueued == true then true else false then uDim22 else uDim2
		})
	end

	u11:Play()
end
