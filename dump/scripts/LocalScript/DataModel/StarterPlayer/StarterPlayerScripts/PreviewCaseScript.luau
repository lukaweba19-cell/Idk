-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local regularCase: Instance = workspace:WaitForChild("RegularCase")
local caseRoot: Instance = regularCase:WaitForChild("CaseRoot")
local display: Instance = regularCase:WaitForChild("Display")
local animator: Instance = regularCase:WaitForChild("AnimationController"):WaitForChild("Animator")
local skinList: Instance = regularCase:WaitForChild("SkinList")
local knives: Instance = replicatedStorage:WaitForChild("Knives")
local revolvers: Instance = replicatedStorage:WaitForChild("Revolvers")
local animation: Animation = Instance.new("Animation")

animation.AnimationId = "rbxassetid://94711020833964"

local animation2: Animation = Instance.new("Animation")

animation2.AnimationId = "rbxassetid://108336018771055"

local animation3: Animation = Instance.new("Animation")

animation3.AnimationId = "rbxassetid://90470905146577"

local animationTrack = animator:LoadAnimation(animation)
local v16 = animator:LoadAnimation(animation2)
local v17 = animator:LoadAnimation(animation3)

animationTrack.Looped = false
animationTrack.Priority = Enum.AnimationPriority.Action
v16.Looped = true
v16.Priority = Enum.AnimationPriority.Action
v17.Looped = false
v17.Priority = Enum.AnimationPriority.Action

local t1: {[any]: any} = {}
local children = skinList:GetChildren()

table.sort(children, function(p1, p2)
	return p1.Name < p2.Name
end)

for _, v in ipairs(children) do
	if v:IsA("StringValue") and v.Value ~= "" then
		table.insert(t1, v.Value)
	end
end

local function getSkinModel(p3)
	local v37, v38 = p3:match("^(.+)/(.+)$")

	if v37 and v38 then
		local v39 = if v37 == "Knives" then knives else if v37 == "Revolvers" then revolvers else nil

		if not v39 then
			return nil
		end

		return (v39:FindFirstChild(v38))
	end

	return nil
end

local u23: boolean = false
local u24: boolean = false
local n1 = 0
local u26 = nil
local n2: number = 0
local n3: number = 0
local displayCFrame = display.CFrame

local function showSkin(p4)
	if u26 then
		u26:Destroy()
		u26 = nil
	end

	if p4 < 1 or p4 > #t1 then
		return
	end

	local v41, v42 = t1[p4]:match("^(.+)/(.+)$")
	local v43 = if v41 == "Knives" then knives else if v41 == "Revolvers" then revolvers else nil
	local v44 = if v41 and v42 then if not v43 then nil else v43:FindFirstChild(v42) else nil

	if not v44 then
		return
	end

	local clone = v44:Clone()

	clone.Name = "PreviewSkin"

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Anchored = false
		end
	end

	local v48 = clone.PrimaryPart

	if not v48 then
		v48 = clone:FindFirstChildWhichIsA("BasePart")
	end

	if not v48 then
		clone:Destroy()

		return
	end

	clone:PivotTo(display.CFrame)
	clone.Parent = workspace
	pcall(function()
		clone:ScaleTo(1.5)
	end)

	local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint.Part0 = display
	weldConstraint.Part1 = v48
	weldConstraint.Parent = v48
	u26 = clone
	n1 = p4
end
local function clearSkin()
	if u26 then
		u26:Destroy()
		u26 = nil
	end

	n1 = 0
	n2 = 0
end
local function openCase()
	if not u23 and not u24 then
		u24 = true
		v17:Stop(0)
		v16:Stop(0)
		animationTrack:Play()
		animationTrack.Stopped:Once(function()
			if not u23 then
				u24 = false

				return
			end

			v16:Play()
			u24 = false
		end)
		u23 = true
		n2 = 0
		n1 = 0

		if #t1 > 0 then
			showSkin(1)
		end

		return
	end
end
local function closeCase()
	if u23 and not u24 then
		u24 = true
		u23 = false
		animationTrack:Stop(0)
		v16:Stop(0)
		v17:Play()

		if u26 then
			u26:Destroy()
			u26 = nil
		end

		n1 = 0
		n2 = 0
		n3 = 0
		display.CFrame = displayCFrame
		v17.Stopped:Once(function()
			u24 = false
		end)

		return
	end
end

runService.Heartbeat:Connect(function(deltaTime: number)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return
	end

	local u53: boolean = (humanoidRootPart.Position - caseRoot.Position).Magnitude <= 10

	if u53 and not u23 and not u24 then
		openCase()
	elseif not u53 and u23 and not u24 then
		closeCase()
	end

	if u23 then
		n3 += 0.6 * deltaTime

		local v54 = CFrame.Angles(0, n3, 0)

		display.CFrame = displayCFrame * v54

		if #t1 > 0 then
			n2 += deltaTime

			if n2 >= 3 then
				n2 = 0
				showSkin(n1 % #t1 + 1)
			end
		end
	end
end)
