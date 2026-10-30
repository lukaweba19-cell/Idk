-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local restartNotice = require(shared:WaitForChild("RestartNotice"))
local bar: Instance = script.Parent:WaitForChild("Bar")
local shadow: Instance = bar:WaitForChild("Shadow")
local front: Instance = shadow:WaitForChild("Front")

bar.Visible = false

local uDim2 = UDim2.new(0.5, 0, 0.145, 0)
local uDim22 = UDim2.new(0.5, 0, 0.345, 0)
local u12 = nil

local function applyPosition()
	local u24 = false

	if u12 ~= nil then
		u24 = u12.Visible
	end

	bar.Position = if u24 then uDim22 else uDim2
end

task.spawn(function()
	local topTextGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TopTextGui", 10)

	if not topTextGui then
		return
	end

	local frame: Instance = topTextGui:WaitForChild("Frame", 5)

	if not frame or not frame:IsA("Frame") then
		return
	end

	u12 = frame
	frame:GetPropertyChangedSignal("Visible"):Connect(applyPosition)

	local u27 = false

	if u12 ~= nil then
		u27 = u12.Visible
	end

	bar.Position = if u27 then uDim22 else uDim2
end)

local u14 = nil
local u15 = nil
local u16 = false

local function setText(text)
	shadow.Text = text
	front.Text = text
end
local function stopPulse()
	if u15 then
		u15:Cancel()
		u15 = nil
	end

	bar.BackgroundTransparency = 0.35
end
local function startPulse()
	if u15 then
		return
	end

	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

	u15 = tweenService:Create(bar, tweenInfo, { BackgroundTransparency = 0.1 })
	u15:Play()
end
local function setUrgent(p2)
	if p2 == u16 then
		return
	end

	u16 = p2
	front.TextColor3 = if p2 then restartNotice.UrgentColor else restartNotice.NormalColor

	if p2 then
		startPulse()

		return
	end

	if u15 then
		u15:Cancel()
		u15 = nil
	end

	bar.BackgroundTransparency = 0.35
end
local function hide()
	bar.Visible = false

	if u15 then
		u15:Cancel()
		u15 = nil
	end

	bar.BackgroundTransparency = 0.35
end

local u22 = nil

local function render()
	local v31 = u14

	if not v31 then
		bar.Visible = false

		if u15 then
			u15:Cancel()
			u15 = nil
		end

		bar.BackgroundTransparency = 0.35

		return
	end

	local deadline = v31.deadline
	local v33 = workspace:GetServerTimeNow()
	local n1 = deadline - v33

	if n1 < -restartNotice.OverrunGraceSeconds then
		u14 = nil
		bar.Visible = false

		if u15 then
			u15:Cancel()
			u15 = nil
		end

		bar.BackgroundTransparency = 0.35

		return
	end

	if n1 > restartNotice.BannerAtSeconds then
		if bar.Visible then
			bar.Visible = false

			if u15 then
				u15:Cancel()
				u15 = nil
			end

			bar.BackgroundTransparency = 0.35
		end

		return
	end

	local v35 = math.max(0, n1)

	n1 = ("%s<br/>%s"):format(restartNotice.Headline(v31.maintenance), restartNotice.BannerBody(v35, v31.message))

	if n1 ~= u22 then
		u22 = n1
		shadow.Text = n1
		front.Text = n1
	end

	v33 = v35 <= restartNotice.UrgentSeconds

	if v33 ~= u16 then
		u16 = v33
		front.TextColor3 = if v33 then restartNotice.UrgentColor else restartNotice.NormalColor

		if v33 then
			startPulse()
		else
			if u15 then
				u15:Cancel()
				u15 = nil
			end

			bar.BackgroundTransparency = 0.35
		end
	end

	if not bar.Visible then
		local u36 = false

		if u12 ~= nil then
			u36 = u12.Visible
		end

		bar.Position = if u36 then uDim22 else uDim2
		bar.Visible = true
	end
end

runService.RenderStepped:Connect(function()
	if u14 then
		render()
	end
end)
replicatedStorage:WaitForChild("Remotes"):WaitForChild(restartNotice.RemoteName).OnClientEvent:Connect(function(p3)
	if typeof(p3) == "table" then
		if typeof(p3.deadline) ~= "number" then
			return
		end

		if u14 and p3.deadline >= u14.deadline then
			return
		end

		u14 = {
			deadline = p3.deadline,
			maintenance = if p3.maintenance == true then true else false,
			message = if typeof(p3.message) == "string" then p3.message else nil
		}
		u22 = nil
		render()

		return
	end
end)
