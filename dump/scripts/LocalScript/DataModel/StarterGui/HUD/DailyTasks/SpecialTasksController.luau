-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local specialTasks_Push: Instance = remotes:WaitForChild("SpecialTasks_Push")
local specialTasks_Request: Instance = remotes:WaitForChild("SpecialTasks_Request")
local dailyTasks: Instance = hud:WaitForChild("DailyTasks")

dailyTasks:WaitForChild("Title")

local title2: Instance = dailyTasks:WaitForChild("Title2")

dailyTasks:WaitForChild("QuestFrame")

local questFrame2: Instance = dailyTasks:WaitForChild("QuestFrame2")
local questTemplate1: Instance = questFrame2:WaitForChild("QuestTemplate1")
local questTemplate2: Instance = questFrame2:WaitForChild("QuestTemplate2")
local questTemplate3: Instance = questFrame2:WaitForChild("QuestTemplate3")
local t1: {[any]: any} = { questTemplate1, questTemplate2, questTemplate3 }
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function captureProgressGradient(p1)
	local progressBar = p1:FindFirstChild("ProgressBar")

	if not progressBar then
		return nil
	end

	local progress = progressBar:FindFirstChild("Progress")

	if not progress then
		return nil
	end

	local uiGradient = progress:FindFirstChildOfClass("UIGradient")

	return uiGradient and uiGradient.Color
end
local function captureLabelColor(p2)
	local label = p2:FindFirstChild("Label")

	return label and label.TextColor3 or nil
end

local progressBar: Instance = questFrame2:WaitForChild("QuestTemplate1"):FindFirstChild("ProgressBar")
local v20

if not progressBar then
	v20 = nil
else
	local progress: Instance = progressBar:FindFirstChild("Progress")

	if not progress then
		v20 = nil
	else
		local uiGradient: Instance = progress:FindFirstChildOfClass("UIGradient")

		v20 = uiGradient and uiGradient.Color
	end
end

local progressBar2: Instance = questFrame2:WaitForChild("QuestTemplate2"):FindFirstChild("ProgressBar")
local v24

if not progressBar2 then
	v24 = nil
else
	local progress: Instance = progressBar2:FindFirstChild("Progress")

	if not progress then
		v24 = nil
	else
		local uiGradient: Instance = progress:FindFirstChildOfClass("UIGradient")

		v24 = uiGradient and uiGradient.Color
	end
end

local label: Instance = questFrame2:WaitForChild("QuestTemplate1"):FindFirstChild("Label")
local v28 = label and label.TextColor3 or nil
local label2: Instance = questFrame2:WaitForChild("QuestTemplate2"):FindFirstChild("Label")
local v30 = label2 and label2.TextColor3 or nil
local n1: number = 0

local function applyColors(p3, p4)
	local uiGradient = p3:FindFirstChild("ProgressBar"):FindFirstChild("Progress"):FindFirstChildOfClass("UIGradient")
	local label3 = p3:FindFirstChild("Label")

	if p4 then
		if uiGradient and v20 then
			uiGradient.Color = v20
		end

		if label3 and v28 then
			label3.TextColor3 = v28

			return
		end
	else
		if uiGradient and v24 then
			uiGradient.Color = v24
		end

		if label3 and v30 then
			label3.TextColor3 = v30
		end
	end
end
local function renderQuest(p5, p6)
	local label4 = p5:FindFirstChild("Label")
	local progressBar3 = p5:FindFirstChild("ProgressBar")
	local progress = progressBar3:FindFirstChild("Progress")
	local label5 = progressBar3:FindFirstChild("Label")
	local u54: boolean = true

	if p6.Completed ~= true then
		u54 = p6.Current >= p6.Required
	end

	if u54 and typeof(p6.CompletedLabel) == "string" and p6.CompletedLabel ~= "" then
		label4.Text = p6.CompletedLabel
	else
		label4.Text = p6.Label
	end

	label5.Text = ("%d/%d"):format(p6.Current, p6.Required)

	local current = p6.Current
	local v56 = math.max(p6.Required, 1)
	local v57 = math.clamp(current / v56, 0, 1)

	applyColors(p5, u54)

	local uDim2 = UDim2.new(if u54 then 1 else v57, 0, progress.Size.Y.Scale, progress.Size.Y.Offset)

	tweenService:Create(progress, tweenInfo, { Size = uDim2 }):Play()

	local reward = p5:FindFirstChild("Reward")

	if reward then
		reward.Visible = false
	end
end
local function setSpecialVisible(visible)
	title2.Visible = visible
	questFrame2.Visible = visible
end
local function applySnapshot(p8)
	if typeof(p8) == "table" then
		local tasks = p8.Tasks

		if typeof(tasks) == "table" then
			n1 = #tasks

			if n1 == 0 then
				title2.Visible = false
				questFrame2.Visible = false

				for _, v in ipairs(t1) do
					v.Visible = false
				end

				return
			end

			for i, v in ipairs(t1) do
				if i <= n1 then
					v.Visible = true
					renderQuest(v, tasks[i])
				else
					v.Visible = false
				end
			end

			title2.Visible = true
			questFrame2.Visible = true

			return
		end

		return
	end
end

title2.Visible = false
questFrame2.Visible = false

for _, v in ipairs(t1) do
	v.Visible = false
end

specialTasks_Push.OnClientEvent:Connect(applySnapshot)
task.spawn(function()
	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local ok, result = pcall(function()
		return specialTasks_Request:InvokeServer("GetSnapshot")
	end)

	if ok then
		applySnapshot(result)
	end
end)
