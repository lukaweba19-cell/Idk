-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local childName = require(shared:WaitForChild("FeaturedCollectible")).ModelName()
local scriptParent: Instance = script.Parent
local bubble: Instance = scriptParent:WaitForChild("Bubble")
local v7: Instance = scriptParent:WaitForChild(childName, 10)

if not v7 then
	warn(("[BubbleFX] no '%s' in the bubble after %ds -- animating the bubble alone."):format(childName, 10))
end

local n1 = 0.22
local n2 = 1
local u10: boolean = bubble:GetAttribute("HueCycle") == true
local hueSaturation: any = bubble:GetAttribute("HueSaturation")
local hueValue: any = bubble:GetAttribute("HueValue")

if typeof(hueSaturation) == "number" then
	n1 = hueSaturation
end

if typeof(hueValue) == "number" then
	n2 = hueValue
end

local bubbleSize = bubble.Size
local u14 = scriptParent:GetPivot():ToObjectSpace(bubble.CFrame)
local u15 = v7

if u15 then
	u15 = scriptParent:GetPivot()
	u15 = u15:ToObjectSpace(v7:GetPivot())
end

local function offsetsSane()
	if u14.Position.Magnitude <= 20 then
		return true
	end

	u14 = scriptParent:GetPivot():ToObjectSpace(bubble.CFrame)

	local v20 = v7

	if v20 then
		v20 = scriptParent:GetPivot():ToObjectSpace(v7:GetPivot())
	end

	u15 = v20

	return u14.Position.Magnitude <= 20
end

if v7 then
	for _, v in ipairs(v7:GetDescendants()) do
		if v:IsA("BasePart") and not v.Anchored and #v:GetJoints() == 0 then
			v.Anchored = true
		end
	end
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	if not v7 then
		return
	end

	local inMatch: any = LocalPlayer:GetAttribute("InMatch")
	local highlight: Instance = v7:FindFirstChild("Highlight")

	if highlight then
		highlight.DepthMode = not inMatch and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
	end
end)

local n3: number = 0

runService.RenderStepped:Connect(function(deltaTime: number)
	if LocalPlayer:GetAttribute("InMatch") then
		return
	end

	if not bubble.Parent then
		return
	end

	n3 += deltaTime

	if not offsetsSane() then
		return
	end

	local pivot = scriptParent:GetPivot()
	local n4 = pivot * u14
	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera and (CurrentCamera.CFrame.Position - n4.Position).Magnitude > 250 then
		return
	end

	local sine = math.sin(n3 * 6.283185307179586 / 4)
	local sine2 = math.sin(n3 * 6.283185307179586 / 2.7)
	local vector3 = Vector3.new(0, sine * 0.75, 0)
	local ufoLift: any = bubble:GetAttribute("UfoLift")

	if typeof(ufoLift) == "number" then
		local vector32 = Vector3.new(0, ufoLift, 0)

		vector3 += vector32
	end

	bubble.Size = bubbleSize * (sine2 * 0.03 + 1)
	bubble.CFrame = n4 + vector3

	if u10 then
		bubble.Color = Color3.fromHSV(n3 / 6 % 1, n1, n2)
	end

	if v7 and u15 and v7.Parent then
		v7:PivotTo(pivot * u15 + vector3)
	end
end)
