-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local sound = require(game.ReplicatedStorage.Sound)
local scriptParent: Instance = script.Parent

scriptParent.Visible = false

local trainingPortal: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CutsceneFadeGui"):WaitForChild("TrainingPortal")

local function getMyMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" then
		return matchId
	end

	return nil
end
local function isPractice()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	return (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE"
end
local function shouldShow()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u27: boolean = (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE"

	if u27 then
		u27 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	return u27
end

local u18: boolean = false

local function onClick()
	if u18 then
		return
	end

	u18 = true
	trainingPortal.BackgroundTransparency = 1
	trainingPortal.Visible = true

	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local v29: Tween = tweenService:Create(trainingPortal, tweenInfo, { BackgroundTransparency = 0 })

	v29:Play()
	v29.Completed:Wait()
	remotes.ExitPractice:FireServer()
	sound:Play("Misc.Teleport", workspace)
	task.wait(0.5)

	local tweenInfo2 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	v29 = tweenService:Create(trainingPortal, tweenInfo2, { BackgroundTransparency = 1 })
	v29:Play()
	v29.Completed:Wait()
	trainingPortal.Visible = false
	u18 = false
end

scriptParent.MouseButton1Click:Connect(function()
	onClick()
end)

local keybind: Instance = scriptParent:FindFirstChild("Keybind")

if keybind then
	uiFramework.applyGamepadKeybind(keybind, gamepadBindings.Menu)
	uiFramework.bindKeybindLabel(keybind, "Menu")
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if inputMap.matches("Menu", input) and scriptParent.Visible then
		onClick()
	end
end)

local function refreshVisible()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u34: boolean = (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE"

	if u34 then
		u34 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	scriptParent.Visible = u34
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshVisible)
LocalPlayer:GetAttributeChangedSignal("MMWarmup"):Connect(refreshVisible)

local matchId: any = LocalPlayer:GetAttribute("MatchId")
local u23: boolean = (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE"

if u23 then
	u23 = LocalPlayer:GetAttribute("MMWarmup") ~= true
end

scriptParent.Visible = u23
