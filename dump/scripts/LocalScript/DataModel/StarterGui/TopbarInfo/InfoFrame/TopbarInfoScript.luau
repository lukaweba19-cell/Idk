-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local workspace: Workspace = game:GetService("Workspace")
local runService: RunService = game:GetService("RunService")

game:GetService("GuiService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local icon = require(replicatedStorage:WaitForChild("Icon"))
local scriptParent: Instance = script.Parent
local clientInfo: Instance = scriptParent:WaitForChild("ClientInfo")
local scriptParentServerLocation: Instance = scriptParent:WaitForChild("ServerLocation")
local serverLocation: any = workspace:GetAttribute("ServerLocation")

if not serverLocation then
	workspace:GetAttributeChangedSignal("ServerLocation"):Connect(function()
		serverLocation = workspace:GetAttribute("ServerLocation")
		scriptParentServerLocation.Text = serverLocation
	end)
else
	scriptParentServerLocation.Text = serverLocation
end

task.spawn(function()
	while not icon.container do
		task.wait(0.1)
	end

	local topbarStandard = icon.container.TopbarStandard

	if not topbarStandard then
		return
	end

	local holders = topbarStandard:FindFirstChild("Holders")

	if not holders then
		return
	end

	local right = holders:FindFirstChild("Right")

	if not right then
		return
	end

	scriptParent.LayoutOrder = -10000
	scriptParent.Parent = right
end)

local n1: number = 0
local n2 = 0

runService.Heartbeat:Connect(function(deltaTime: number)
	n1 += 1

	local v17 = os.clock()

	if v17 - n2 >= 1 then
		local rounded = math.round(n1 / (v17 - n2))
		local stringFormat = string.format
		local ping: any = LocalPlayer:GetAttribute("Ping")

		clientInfo.Text = stringFormat("%dfps %dms", rounded, ping or 0)
		n1 = 0
		n2 = v17
	end
end)
