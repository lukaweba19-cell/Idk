-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local t1: {[any]: any} = {
	CandyCorn = "CandyCornWallHit",
	GummyWorm = "GummyWormWallHit",
	LolliStick = "LollipopWallHit"
}

local function candySource(p1)
	local pumpkinBucket = game.ReplicatedStorage.Knives:FindFirstChild("PumpkinBucket")
	local knifeRoot = pumpkinBucket and pumpkinBucket:FindFirstChild("KnifeRoot")

	return knifeRoot and knifeRoot:FindFirstChild(p1)
end
local function sprayCandy(p2, p3, p4)
	local pumpkinBucket = game.ReplicatedStorage.Knives:FindFirstChild("PumpkinBucket")
	local knifeRoot = pumpkinBucket and pumpkinBucket:FindFirstChild("KnifeRoot")
	local v17 = knifeRoot

	if v17 then
		v17 = knifeRoot:FindFirstChild(p2)
	end

	if not v17 then
		return
	end

	local t2: {[any]: any} = {}

	for _ = 1, 5 do
		local model: Model = Instance.new("Model")
		local clone = v17:Clone()

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("Trail") or v:IsA("Attachment") or v:IsA("ParticleEmitter") then
				v:Destroy()
			end
		end

		clone.Parent = model
		model.PrimaryPart = clone

		for _, v in ipairs(model:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 0
				v.Anchored = false
				v.CanCollide = false
				v.CanQuery = false
				v.CanTouch = false
				v.CastShadow = false
				v.Massless = true
			end
		end

		clone.Anchored = true
		model:ScaleTo(0.42)

		local randomNumber = math.random()
		local randomNumber2 = math.random()
		local randomNumber3 = math.random()
		local vector3 = Vector3.new(randomNumber - 0.5, randomNumber2 - 0.5, randomNumber3 - 0.5)
		local randomNumber4 = math.random()
		local cFrameAngles = CFrame.Angles
		local randomNumber5 = math.random()
		local randomNumber6 = math.random()
		local randomNumber7 = math.random()
		local v35 = cFrameAngles((randomNumber5 - 0.5) * 0.6, (randomNumber6 - 0.5) * 0.6, (randomNumber7 - 0.5) * 0.6)
		local cFrame = CFrame.new(p3.Position + p4 * 0.3)
		local angles = CFrame.Angles
		local randomNumber8 = math.random()
		local randomNumber9 = math.random()
		local randomNumber10 = math.random()
		local v41 = angles(randomNumber8 * 6.28, randomNumber9 * 6.28, randomNumber10 * 6.28)
		local n1 = cFrame * v41

		model:PivotTo(n1)
		model.Parent = workspace.Bin
		debris:AddItem(model, 1.2)
		table.insert(t2, {
			model = model,
			pos = n1.Position,
			rot = n1.Rotation,
			vel = p4 * (9 + randomNumber4 * 7) + vector3 * 2 * 7 + Vector3.new(0, 7, 0),
			spin = v35
		})
		task.delay(0.65, function()
			for _, v in ipairs(model:GetDescendants()) do
				if v:IsA("BasePart") then
					tweenService:Create(v, TweenInfo.new(0.25), { Transparency = 1 }):Play()
				end
			end
		end)
	end

	local n2: number = 0
	local connection = nil

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n2 += deltaTime

		if n2 > 1.2 then
			connection:Disconnect()

			return
		end

		for _, v in ipairs(t2) do
			if v.model.Parent then
				v.vel = v.vel - Vector3.new(0, 70, 0) * deltaTime
				v.pos = v.pos + v.vel * deltaTime
				v.rot = v.rot * v.spin

				local vModel = v.model
				local cFrame2 = CFrame.new(v.pos)

				vModel:PivotTo(cFrame2 * v.rot)
			end
		end
	end)
end

return function(p6)
	local cFrame = p6.CFrame

	if (workspace.CurrentCamera.CFrame.Position - cFrame.Position).Magnitude > 1000 + (p6.Scale or 1.75) * 10 then
		return
	end

	local knife = p6.Knife
	local v48 = knife and knife:GetAttribute("HeldVariant")

	if typeof(v48) ~= "string" or not t1[v48] then
		v48 = "CandyCorn"
	end

	sound:Play("WallHit." .. script.Parent.Name, cFrame)

	local clone = game.ReplicatedStorage.FX.WallHitFX[t1[v48]]:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	local pointLight = clone:FindFirstChild("IMPACTBAMP") and clone.IMPACTBAMP:FindFirstChildWhichIsA("PointLight")

	if pointLight then
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

		tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	end

	sprayCandy(v48, cFrame, if p6.HitPart then cFrame.UpVector else cFrame.LookVector)
end
