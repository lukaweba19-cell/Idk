-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local tweenService: TweenService = game:GetService("TweenService")

local function ScaleModelTo(p1, p2, p3)
	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = p1:GetScale()

	local tweenInfo = TweenInfo.new(p3 or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v12: Tween = tweenService:Create(numberValue, tweenInfo, { Value = p2 or 0.01 })

	v12.Completed:Connect(function()
		numberValue:Destroy()
	end)
	numberValue:GetPropertyChangedSignal("Value"):Connect(function()
		p1:ScaleTo(numberValue.Value)
	end)
	v12:Play()
end
local function makeTween(p4, p5, p6)
	return (tweenService:Create(p4, p5, p6))
end

return function(p7)
	local cFrame = p7.CFrame

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + (p7.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit." .. script.Parent.Name, cFrame, nil, nil, nil, 0.2)

	local clone = game.ReplicatedStorage.FX.WallHitFX.InfernumWallHit:Clone()

	clone.CFrame = cFrame
	clone.Parent = workspace.Bin
	debris:AddItem(clone, 1)
	misc.EmitAll(clone)

	local pointLight = clone.IMPACTBAMP.PointLight
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("Beam") then
			local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

			tweenService:Create(v, tweenInfo2, { Width0 = 0, Width1 = 0 }):Play()
		end
	end

	task.spawn(function()
		ScaleModelTo(clone.Rings.Ring1, 0.01, 0.35)
		task.wait(0.025)
		ScaleModelTo(clone.Rings.Ring2, 0.01, 0.35)
		task.wait(0.025)
		ScaleModelTo(clone.Rings.Ring3, 0.01, 0.35)
		task.wait(0.025)
		ScaleModelTo(clone.Rings.Ring4, 0.01, 0.35)
		task.wait(0.025)
		ScaleModelTo(clone.Rings.Ring5, 0.01, 0.35)
	end)
end
