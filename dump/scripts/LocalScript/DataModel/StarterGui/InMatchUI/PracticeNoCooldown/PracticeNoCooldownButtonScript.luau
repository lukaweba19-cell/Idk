-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local practiceNoCooldown: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PracticeNoCooldown")
local scriptParent: Instance = script.Parent

scriptParent.Visible = false

local t1: {[any]: any} = {
	on = {
		text = "Cooldown: OFF",
		top = Color3.new(1, 0.596078, 0.603922),
		bottom = Color3.new(0.505882, 0.0784314, 0.0784314),
		shade = Color3.new(0.407843, 0, 0),
		stroke = Color3.new(0.156863, 0, 0)
	},
	off = {
		text = "Cooldown: ON",
		top = Color3.new(0.788235, 1, 0.564706),
		bottom = Color3.new(0.176471, 0.631373, 0),
		shade = Color3.new(0.113725, 0.407843, 0.0235294),
		stroke = Color3.new(0, 0.156863, 0.0196078)
	}
}
local uiGradient: Instance = scriptParent:FindFirstChildOfClass("UIGradient")
local textLabel: Instance = scriptParent:FindFirstChild("TextLabel")
local v7: Instance = textLabel and textLabel:FindFirstChild("TextLabel")
local uiStroke: Instance = v7 and v7:FindFirstChildOfClass("UIStroke")

local function refreshLook()
	local v16 = if LocalPlayer:GetAttribute("PracticeNoCooldown") == true then t1.on else t1.off

	if uiGradient then
		uiGradient.Color = ColorSequence.new(v16.top, v16.bottom)
	end

	if textLabel then
		textLabel.Text = v16.text
		textLabel.TextColor3 = v16.shade
	end

	if v7 then
		v7.Text = v16.text
	end

	if uiStroke then
		uiStroke.Color = v16.stroke
	end
end

local changeAbilities: Instance = scriptParent.Parent:WaitForChild("ChangeAbilities")
local holder: Instance = changeAbilities:WaitForChild("Holder")

local function inPractice()
	local u17: boolean = false

	if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
		u17 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	return u17
end
local function shouldShow()
	local u18 = false

	if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
		u18 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	if u18 then
		u18 = changeAbilities.Visible and holder.Visible
	end

	return u18
end
local function refreshVisible()
	local u19 = false

	if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
		u19 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	if u19 then
		u19 = changeAbilities.Visible and holder.Visible
	end

	scriptParent.Visible = u19
end

scriptParent.MouseButton1Click:Connect(function()
	local u20: boolean = false

	if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
		u20 = LocalPlayer:GetAttribute("MMWarmup") ~= true
	end

	if not u20 then
		return
	end

	practiceNoCooldown:FireServer()
end)
LocalPlayer:GetAttributeChangedSignal("PracticeNoCooldown"):Connect(refreshLook)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshVisible)
LocalPlayer:GetAttributeChangedSignal("MMWarmup"):Connect(refreshVisible)
changeAbilities:GetPropertyChangedSignal("Visible"):Connect(refreshVisible)
holder:GetPropertyChangedSignal("Visible"):Connect(refreshVisible)
refreshLook()

local u15 = false

if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
	u15 = LocalPlayer:GetAttribute("MMWarmup") ~= true
end

if u15 then
	u15 = changeAbilities.Visible and holder.Visible
end

scriptParent.Visible = u15
