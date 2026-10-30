-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(game.ReplicatedStorage.Sound)
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local keybindSettings = require(replicatedStorageShared:WaitForChild("KeybindSettings"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local LocalPlayer: Player = players.LocalPlayer
local u14: boolean = false
local lobby: Instance = workspace:WaitForChild("Lobby", 30)

if not lobby then
	return
end

local function isTrainingPad(p1)
	if not p1:IsA("BasePart") then
		return false
	end

	local u29: boolean = true

	if p1.Name:match("^TrainingPortal%d*$") == nil then
		u29 = p1.Name == "ShootingRangeEntrance"
	end

	return u29
end

local v17 = tradingPlazaGate.IsTradingPlaza()

if not lobby:WaitForChild(if v17 then "ShootingRangeEntrance" else "TrainingPortal", 30) then
	return
end

local cutsceneFadeGui: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CutsceneFadeGui", 30)

if not cutsceneFadeGui then
	return
end

local trainingPortal: Instance = cutsceneFadeGui:WaitForChild("TrainingPortal")

local function sinkInput(_, _, _)
	return Enum.ContextActionResult.Sink
end

local t1: {[any]: any} = {
	"MoveForward",
	"MoveBackward",
	"MoveLeft",
	"MoveRight",
	"Jump",
	"Attack",
	"Aim"
}

local function blockedInputs()
	local t2: {[any]: any} = {}
	local t3: {[any]: any} = {}

	for _, v in ipairs(t1) do
		for _, iterValue in ipairs(inputMap.getBindings(v)) do
			if not t2[iterValue] then
				t2[iterValue] = true

				local v39 = keybindSettings.resolve(iterValue)

				if v39 then
					table.insert(t3, v39)
				end
			end
		end
	end

	return t3
end

v17 = function()
	return LocalPlayer:GetAttribute("MatchId") == "PRACTICE"
end

local function trainingLocked()
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
	local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

	if not isReservedServer or not isReservedServer.Value then
		return false
	end

	return matchmakingShared:GetAttribute("MMTrainingUnlocked") ~= true
end
local function onPadTouched(p5, p6)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	if Character ~= p6.Parent then
		return
	end

	if u14 then
		return
	end

	if LocalPlayer:GetAttribute("MatchId") ~= "PRACTICE" and (if not v45 or not v45:FindFirstChild("IsReservedServer") or not (v45 and v45:FindFirstChild("IsReservedServer")).Value then false else replicatedStorage:FindFirstChild("MatchmakingShared"):GetAttribute("MMTrainingUnlocked") ~= true) then
		return
	end

	u14 = true

	local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if humanoid and humanoidRootPart then
		if LocalPlayer:GetAttribute("MatchId") == "PRACTICE" then
			trainingPortal.BackgroundTransparency = 1
			trainingPortal.Visible = true

			local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			local v49: Tween = tweenService:Create(trainingPortal, tweenInfo, { BackgroundTransparency = 0 })

			v49:Play()
			v49.Completed:Wait()
			task.wait(0.3)

			local tweenInfo2 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			v49 = tweenService:Create(trainingPortal, tweenInfo2, { BackgroundTransparency = 1 })
			v49:Play()
			v49.Completed:Wait()
			trainingPortal.Visible = false
			u14 = false

			return
		end

		local v51 = blockedInputs()

		if #v51 > 0 then
			contextActionService:BindActionAtPriority("TrainingPortalBlock", sinkInput, false, Enum.ContextActionPriority.High.Value, table.unpack(v51))
		end

		local CurrentCamera: Camera = workspace.CurrentCamera
		local currentCameraCameraType: Enum.CameraType = CurrentCamera.CameraType

		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local currentCameraCFrame: CFrame = CurrentCamera.CFrame

		local connection = runService.RenderStepped:Connect(function()
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.CFrame = currentCameraCFrame
		end)

		local animator: Instance = humanoid:FindFirstChildOfClass("Animator")
		local v57 = nil

		if animator then
			local animation: Animation = Instance.new("Animation")

			animation.AnimationId = "rbxassetid://78390712319586"
			v57 = animator:LoadAnimation(animation)
			v57.Looped = true
			v57.Priority = Enum.AnimationPriority.Action4
			v57:Play()
		end

		local lookVector = humanoidRootPart.CFrame.LookVector
		local humanoidWalkSpeed = humanoid.WalkSpeed

		local connection2 = runService.Heartbeat:Connect(function(deltaTime: number)
			if humanoidRootPart.Parent then
				humanoidRootPart.CFrame = humanoidRootPart.CFrame + lookVector * humanoidWalkSpeed * deltaTime
			end
		end)

		trainingPortal.BackgroundTransparency = 1
		trainingPortal.Visible = true

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

		tweenService:Create(trainingPortal, tweenInfo, { BackgroundTransparency = 0 }):Play()
		sound:Play("Misc.Teleport", workspace)
		p5.CanCollide = false
		task.wait(0.5)
		p5.CanCollide = true
		connection2:Disconnect()

		if v57 then
			v57:Stop(0.1)
		end

		connection:Disconnect()
		CurrentCamera.CameraType = currentCameraCameraType
		contextActionService:UnbindAction("TrainingPortalBlock")
		inputMap.reconcile()
		task.wait(0.3)

		local tweenInfo3 = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(trainingPortal, tweenInfo3, { BackgroundTransparency = 1 }):Play()
		task.wait(0.8)
		trainingPortal.Visible = false
		u14 = false

		return
	end

	u14 = false
end

for _, v in ipairs(lobby:GetChildren()) do
	local u27

	if not v:IsA("BasePart") then
		u27 = false
	else
		u27 = true

		if v.Name:match("^TrainingPortal%d*$") == nil then
			u27 = v.Name == "ShootingRangeEntrance"
		end
	end

	if u27 then
		v.Touched:Connect(function(p10)
			onPadTouched(v, p10)
		end)
	end
end

lobby.ChildAdded:Connect(function(p8: Instance)
	local u66

	if not p8:IsA("BasePart") then
		u66 = false
	else
		u66 = true

		if p8.Name:match("^TrainingPortal%d*$") == nil then
			u66 = p8.Name == "ShootingRangeEntrance"
		end
	end

	if not u66 then
		return
	end

	p8.Touched:Connect(function(p9)
		onPadTouched(p8, p9)
	end)
end)
