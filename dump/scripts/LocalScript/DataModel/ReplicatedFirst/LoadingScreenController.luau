-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("RunService")
game:GetService("ReplicatedFirst")

local contentProvider: ContentProvider = game:GetService("ContentProvider")
local starterGui: StarterGui = game:GetService("StarterGui")
local sound = require(game.ReplicatedStorage:WaitForChild("Sound"))

pcall(function()
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local scriptLoadingScreen = script.LoadingScreen

scriptLoadingScreen.Parent = playerGui
scriptLoadingScreen.Enabled = true

local frame = scriptLoadingScreen:WaitForChild("Frame")
local logo = frame:WaitForChild("Logo")
local logoGlow = frame:WaitForChild("LogoGlow")
local backGlow = frame:WaitForChild("BackGlow")
local textLabel = frame:WaitForChild("TextLabel")

task.spawn(function()
	contentProvider:PreloadAsync({ logo, logoGlow, backGlow })
end)

local n1: number = 3
local n2: number = 3
local n3: number = 3
local n4: number = 0.3

if game:GetService("RunService"):IsStudio() then
	n1 = 0
	n2 = 0
	n3 = 0
	n4 = 0
end

if game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0 then
	n1 = 0
	n2 = 0.5
	n3 = 0.5
end

local logoSize = logo.Size
local v19 = logoGlow.Size
local v20 = backGlow.Size

logo.Size = UDim2.new(0, 0, 0, 0)
logoGlow.Size = UDim2.new(0, 0, 0, 0)
backGlow.Size = UDim2.new(0, 0, 0, 0)
textLabel.Visible = false
textLabel.Text = ""

local uiGradient = logo:FindFirstChildOfClass("UIGradient")

if uiGradient then
	uiGradient:Destroy()
end

local u22: boolean = LocalPlayer:GetAttribute("DataReady") == true

if not u22 then
	LocalPlayer:GetAttributeChangedSignal("DataReady"):Connect(function()
		if LocalPlayer:GetAttribute("DataReady") then
			u22 = true
		end
	end)
end

task.wait(n1)

local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

tweenService:Create(logo, tweenInfo, { Size = logoSize }):Play()
tweenService:Create(logoGlow, tweenInfo, { Size = v19 }):Play()
tweenService:Create(backGlow, tweenInfo, { Size = v20 }):Play()
TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
tweenService:Create(logo, tweenInfo, { ImageTransparency = 0 }):Play()
tweenService:Create(logoGlow, tweenInfo, { ImageTransparency = 0 }):Play()
tweenService:Create(backGlow, tweenInfo, { ImageTransparency = 0 }):Play()
sound:Play("UI.Logo", workspace)
task.wait(0.05)

local tweenInfo2 = TweenInfo.new(n2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

tweenService:Create(backGlow, tweenInfo2, { ImageTransparency = 1 }):Play()

local tweenInfo3 = TweenInfo.new(n2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

tweenService:Create(logoGlow, tweenInfo3, { ImageTransparency = 1 }):Play()

local u26: boolean = false

task.spawn(function()
	task.wait(1)

	if u26 then
		return
	end

	textLabel.Visible = true
	textLabel.TextTransparency = 1

	local tweenInfo4 = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

	tweenService:Create(textLabel, tweenInfo4, { TextTransparency = 0 }):Play()
end)

local v27 = os.clock()

v20 = 0
v19 = v27

while true do
	local v28 = os.clock()

	if v28 - v19 >= 0.4 then
		v20 = v20 % 3 + 1
		v19 = v28
	end

	textLabel.Text = "Loading Data" .. string.rep(".", v20)

	local n5 = v28 - v27

	logo.Rotation = -math.sin(n5 / 2) * 1.5
	logoGlow.Rotation = logo.Rotation

	if n5 >= n3 and u22 or n5 >= 600 then
		break
	end

	task.wait()
end

u26 = true

local tweenInfo5 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

tweenService:Create(logo, tweenInfo5, { Size = UDim2.new(0, 0, 0, 0) }):Play()
tweenService:Create(logoGlow, tweenInfo5, { ImageTransparency = 1 }):Play()
tweenService:Create(textLabel, tweenInfo5, { TextTransparency = 1 }):Play()
task.wait(n4)
logo.Visible = false
logoGlow.Visible = false
backGlow.Visible = false
textLabel.Visible = false

local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

v20 = require(shared:WaitForChild("ScreenWipe")).attach(frame, true)
frame.BackgroundTransparency = 1
workspace:SetAttribute("LoadingScreenCompleted", true)
v20:reveal(0.5)
v20:destroy()

local hud: Instance = playerGui:FindFirstChild("HUD")

if hud then
	hud.Enabled = true
end

scriptLoadingScreen:Destroy()
