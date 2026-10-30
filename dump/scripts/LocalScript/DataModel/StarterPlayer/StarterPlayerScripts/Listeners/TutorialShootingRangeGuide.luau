-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local workspace: Workspace = game:GetService("Workspace")
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local dailyTasks_Push: Instance = remotes:WaitForChild("DailyTasks_Push")
local dailyTasks_Request: Instance = remotes:WaitForChild("DailyTasks_Request")
local tutorialShootingRangeGuide: Folder = Instance.new("Folder")

tutorialShootingRangeGuide.Name = "TutorialShootingRangeGuide"
tutorialShootingRangeGuide.Parent = workspace

local beamStart: Part = Instance.new("Part")

beamStart.Name = "BeamStart"
beamStart.Anchored = true
beamStart.CanCollide = false
beamStart.CanQuery = false
beamStart.CanTouch = false
beamStart.Transparency = 1
beamStart.Size = Vector3.new(0.2, 0.2, 0.2)
beamStart.Parent = tutorialShootingRangeGuide

local clone: Instance = beamStart:Clone()

clone.Name = "BeamEnd"
clone.Parent = tutorialShootingRangeGuide

local attachment: Attachment = Instance.new("Attachment")

attachment.Parent = beamStart

local attachment2: Attachment = Instance.new("Attachment")

attachment2.Parent = clone

local groundBeam: Beam = Instance.new("Beam")

groundBeam.Name = "GroundBeam"
groundBeam.Attachment0 = attachment2
groundBeam.Attachment1 = attachment
groundBeam.Color = ColorSequence.new(Color3.fromRGB(255, 221, 64))
groundBeam.LightEmission = 0.6
groundBeam.LightInfluence = 0
groundBeam.Segments = 1
groundBeam.Transparency = NumberSequence.new(0.05)
groundBeam.Width0 = 3
groundBeam.Width1 = 3
groundBeam.FaceCamera = true
groundBeam.Texture = "rbxassetid://1274378728"
groundBeam.TextureMode = Enum.TextureMode.Wrap
groundBeam.TextureLength = 2
groundBeam.TextureSpeed = -2
groundBeam.Enabled = false
groundBeam.Parent = tutorialShootingRangeGuide

local u15 = false
local u16 = false

local function isInMatch()
	return LocalPlayer:GetAttribute("MatchId") ~= nil
end
local function getTrainingPortal()
	local lobby: Instance = workspace:FindFirstChild("Lobby")

	if not lobby then
		return nil
	end

	local trainingPortal: Instance = lobby:FindFirstChild("TrainingPortal")

	if trainingPortal and trainingPortal:IsA("BasePart") then
		return trainingPortal
	end

	return nil
end
local function getRootPart()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return nil
	end

	return (Character:FindFirstChild("HumanoidRootPart"))
end
local function setGuideVisible(p1)
	u16 = p1

	local v32 = p1

	if v32 then
		v32 = LocalPlayer:GetAttribute("MatchId") == nil
	end

	u15 = v32
	groundBeam.Enabled = v32
end
local function shouldShowForSnapshot(p2)
	if LocalPlayer:GetAttribute("TutorialPhase") == 3 then
		if typeof(p2) == "table" and typeof(p2.Tasks) == "table" then
			for _, v in ipairs(p2.Tasks) do
				if v.Id == "BT_ShootingRange" then
					return v.Claimed ~= true and v.Completed ~= true
				end
			end

			return false
		end

		return false
	end

	return false
end
local function refreshFromServer()
	local ok, result = pcall(function()
		return dailyTasks_Request:InvokeServer("GetSnapshot")
	end)

	local v38 = ok and shouldShowForSnapshot(result)

	u16 = v38

	local v39 = v38

	if v39 then
		v39 = LocalPlayer:GetAttribute("MatchId") == nil
	end

	u15 = v39
	groundBeam.Enabled = v39
end
local function updateGuide()
	local Character: Model = LocalPlayer.Character
	local v41 = if not Character then nil else Character:FindFirstChild("HumanoidRootPart")
	local lobby: Instance = workspace:FindFirstChild("Lobby")
	local v43

	if not lobby then
		v43 = nil
	else
		local trainingPortal: Instance = lobby:FindFirstChild("TrainingPortal")

		v43 = if trainingPortal and trainingPortal:IsA("BasePart") then trainingPortal else nil
	end

	if v41 and v43 then
		beamStart.Position = v41.Position
		clone.Position = v43.Position

		return
	end

	u16 = false
	u15 = false
	groundBeam.Enabled = false
end

dailyTasks_Push.OnClientEvent:Connect(function(p3)
	local v46 = shouldShowForSnapshot(p3)

	u16 = v46

	local v47 = v46

	if v47 then
		v47 = LocalPlayer:GetAttribute("MatchId") == nil
	end

	u15 = v47
	groundBeam.Enabled = v47
end)
LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(function()
	if LocalPlayer:GetAttribute("TutorialPhase") == 3 then
		local ok, result = pcall(function()
			return dailyTasks_Request:InvokeServer("GetSnapshot")
		end)

		local v50 = ok and shouldShowForSnapshot(result)

		u16 = v50

		local v51 = v50

		if v51 then
			v51 = LocalPlayer:GetAttribute("MatchId") == nil
		end

		u15 = v51
		groundBeam.Enabled = v51

		return
	end

	u16 = false
	u15 = false
	groundBeam.Enabled = false
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	local v52 = u16

	if v52 then
		v52 = LocalPlayer:GetAttribute("MatchId") == nil
	end

	u15 = v52
	groundBeam.Enabled = v52
end)
LocalPlayer.CharacterAdded:Connect(function()
	if u15 then
		task.defer(updateGuide)
	end
end)

if LocalPlayer:GetAttribute("DataReady") ~= true then
	LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
end

local ok, result = pcall(function()
	return dailyTasks_Request:InvokeServer("GetSnapshot")
end)

local v26 = ok and shouldShowForSnapshot(result)

u16 = v26

local v27 = v26

if v27 then
	v27 = LocalPlayer:GetAttribute("MatchId") == nil
end

u15 = v27
groundBeam.Enabled = v27
runService.RenderStepped:Connect(function()
	if not u15 then
		return
	end

	local Character: Model = LocalPlayer.Character
	local v54 = if not Character then nil else Character:FindFirstChild("HumanoidRootPart")
	local lobby: Instance = workspace:FindFirstChild("Lobby")
	local v56

	if not lobby then
		v56 = nil
	else
		local trainingPortal: Instance = lobby:FindFirstChild("TrainingPortal")

		v56 = if trainingPortal and trainingPortal:IsA("BasePart") then trainingPortal else nil
	end

	if v54 and v56 then
		beamStart.Position = v54.Position
		clone.Position = v56.Position

		return
	end

	u16 = false
	u15 = false
	groundBeam.Enabled = false
end)
