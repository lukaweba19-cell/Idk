-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local moneyGun = replicatedStorage.FX.BulletFX.MoneyGun
local random = Random.new()

local function fadeBeam(p1, attachment0, attachment1, parent, p5)
	local clone = p1:Clone()

	clone.Attachment0 = attachment0
	clone.Attachment1 = attachment1
	clone.Parent = parent

	local tweenInfo = TweenInfo.new(p5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone, tweenInfo, { Width0 = 0, Width1 = 0 }):Play()

	local tweenInfo2 = TweenInfo.new(p5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	tweenService:Create(clone, tweenInfo2, { TextureSpeed = 0 }):Play()

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Changed:Connect(function(p6: number)
		clone.Transparency = NumberSequence.new(p6)
	end)

	local tweenInfo3 = TweenInfo.new(p5, Enum.EasingStyle.Linear)
	local v19: Tween = tweenService:Create(numberValue, tweenInfo3, { Value = 1 })

	v19.Completed:Once(function()
		numberValue:Destroy()
	end)
	v19:Play()
end
local function pathCash(p7, p8, p9)
	if (workspace.CurrentCamera.CFrame.Position - p7).Magnitude > 600 then
		return
	end

	local floored = math.floor(p9 / 8)
	local v24 = math.clamp(floored, 1, 8)
	local n1 = moneyGun.TrailDollar.Lifetime.Max + 0.2

	for i = 1, v24 do
		local attachment: Attachment = Instance.new("Attachment")
		local v28 = random:NextNumber(0.2, 0.8)

		attachment.Position = p7:Lerp(p8, (i - v28) / v24)
		attachment.Parent = workspace.Terrain

		local clone = moneyGun.TrailDollar:Clone()

		clone.Parent = attachment
		clone:Emit(1)
		debris:AddItem(attachment, n1)
	end
end

return function(p10)
	local part = p10.Part
	local attachment0 = p10.Attachment0
	local attachment1 = p10.Attachment1
	local gunRoot = p10.GunRoot
	local revolverMuzzle = gunRoot and gunRoot:FindFirstChild("RevolverMuzzle")

	if revolverMuzzle then
		local pointLight = revolverMuzzle:FindFirstChildOfClass("PointLight")

		if pointLight then
			pointLight.Brightness = 7

			local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

			tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
		end

		misc.EmitAll(revolverMuzzle)
	end

	if part and attachment0 and attachment1 then
		fadeBeam(moneyGun.Beam1, attachment0, attachment1, part, 1)
		fadeBeam(moneyGun.Beam2, attachment0, attachment1, part, 1)
		fadeBeam(moneyGun.Beam3, attachment0, attachment1, part, 1)

		if typeof(p10.Origin) == "Vector3" and typeof(p10.HitPos) == "Vector3" then
			pathCash(p10.Origin, p10.HitPos, p10.Length or (p10.HitPos - p10.Origin).Magnitude)
		end

		return
	end
end
