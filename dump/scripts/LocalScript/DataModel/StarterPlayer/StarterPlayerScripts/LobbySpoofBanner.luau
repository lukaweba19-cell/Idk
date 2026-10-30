-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local playerGui: Instance = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local lobbySpoofBanner: ScreenGui = Instance.new("ScreenGui")

lobbySpoofBanner.Name = "LobbySpoofBanner"
lobbySpoofBanner.ResetOnSpawn = false
lobbySpoofBanner.DisplayOrder = 1000000
lobbySpoofBanner.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
lobbySpoofBanner.Enabled = false

local strip: Frame = Instance.new("Frame")

strip.Name = "Strip"
strip.Position = UDim2.new(0, 0, 0, 0)
strip.Size = UDim2.new(1, 0, 0, 34)
strip.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
strip.BorderSizePixel = 0
strip.Parent = lobbySpoofBanner

local label: TextLabel = Instance.new("TextLabel")

label.Name = "Label"
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 8, 0, 0)
label.Size = UDim2.new(1, -16, 1, 0)
label.Font = Enum.Font.GothamBold
label.TextSize = 16
label.TextColor3 = Color3.new(1, 1, 1)
label.TextStrokeTransparency = 0.5
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextTruncate = Enum.TextTruncate.AtEnd
label.Text = ""
label.Parent = strip
lobbySpoofBanner.Parent = playerGui

local function formatRemaining(p1)
	local floored = math.floor(p1 / 3600)
	local floored2 = math.floor(p1 % 3600 / 60)

	if floored > 0 then
		return ("%dh %02dm"):format(floored, floored2)
	end

	return ("%dm"):format(floored2)
end
local function render()
	local spoofLobbyUntil: any = workspace:GetAttribute("SpoofLobbyUntil")

	if type(spoofLobbyUntil) == "number" then
		local timestamp = os.time()
		local n1 = spoofLobbyUntil - timestamp

		if n1 > 0 then
			label.Text = ("!!!  TEAM TEST LOBBY MODE  --  workspace.%s is SET  --  CLEAR IT BEFORE PUBLISHING  --  expires in %s  !!!"):format("SpoofLobbyUntil", formatRemaining(n1))
			strip.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
		else
			label.Text = ("!!!  workspace.%s is set but EXPIRED  --  clear the attribute before publishing  !!!"):format("SpoofLobbyUntil")
			strip.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
		end

		lobbySpoofBanner.Enabled = true

		return
	end

	lobbySpoofBanner.Enabled = false
end

workspace:GetAttributeChangedSignal("SpoofLobbyUntil"):Connect(render)
render()
task.spawn(function()
	while true do
		task.wait(30)

		if lobbySpoofBanner.Enabled then
			render()
		end
	end
end)
