-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local anims = require(replicatedStorage:WaitForChild("Anims"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local debris = require(util:WaitForChild("Debris"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(shared:WaitForChild("ViewedPlayer"))
local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player, _)
	local Character = player.Character

	if not Character then
	elseif typeof(Character) == "Instance" then
		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not humanoidRootPart then
			return
		end

		local attachment: Attachment = Instance.new("Attachment")

		attachment.Parent = humanoidRootPart
		debris:AddItem(attachment, 2)

		local pointLight: PointLight = Instance.new("PointLight")

		pointLight.Color = Color3.fromRGB(255, 205, 143)
		pointLight.Brightness = 5
		pointLight.Range = 20
		pointLight.Parent = attachment
		task.spawn(function()
			task.wait(0.15)

			if pointLight and pointLight.Parent then
				pointLight.Brightness = 0
			end
		end)

		local head = Character:FindFirstChild("Head")
		local clone = replicatedStorage.FX.AbilityFX.Reflect.Dizzy:Clone()
		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = Character.Torso.CFrame * CFrame.new(0, 5.25, 0)
		clone.Parent = workspace.Bin

		local motor6D: Motor6D = Instance.new("Motor6D")

		motor6D.Part0 = Character:FindFirstChild("Torso")
		motor6D.Part1 = clonePrimaryPart
		motor6D.C0 = CFrame.new(0, 2.5, 0)
		motor6D.Parent = head
		clone.AnimationController:LoadAnimation(replicatedStorage.Anims.Default.Abilities.Reflect.DizzyStars):Play()

		local dizzyCharacter = replicatedStorage.Anims.Default.Abilities.Reflect.DizzyCharacter
		local v24 = anims.Get(Character, "Abilities.Reflect.DizzyCharacter")

		if v24 then
			v24.Priority = Enum.AnimationPriority.Action4
			v24:Play()
		end

		if viewedPlayer.IsViewed(Character) then
			task.spawn(function()
				local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

				colorCorrectionEffect.Parent = game.Lighting
				debris:AddItem(colorCorrectionEffect, 0.3)

				local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local color3 = Color3.fromRGB(255, 169, 98)

				tweenService:Create(colorCorrectionEffect, tweenInfo, {
					Brightness = 1.3,
					Saturation = -0.2,
					Contrast = 3,
					TintColor = color3
				}):Play()
				task.wait(0.05)

				local tweenInfo2 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local color32 = Color3.fromRGB(255, 203, 165)

				tweenService:Create(colorCorrectionEffect, tweenInfo2, { Brightness = 0.4, Saturation = 0, Contrast = 1, TintColor = color32 }):Play()
				task.wait(0.05)

				local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local color33 = Color3.fromRGB(255, 255, 255)

				tweenService:Create(colorCorrectionEffect, tweenInfo3, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color33 }):Play()
			end)

			local blurEffect: BlurEffect = Instance.new("BlurEffect")

			blurEffect.Parent = game.Lighting
			blurEffect.Size = 37

			local tweenInfo = TweenInfo.new(1.84, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut)

			tweenService:Create(blurEffect, tweenInfo, { Size = 0 }):Play()
			debris:AddItem(blurEffect, 2)
			sound:Play("Abilities.EarRing", workspace)
			task.spawn(function()
			end)
		end

		task.delay(1.4, function()
			if v24 then
				v24:Stop(0.1)
			end

			local numberValue: NumberValue = Instance.new("NumberValue")

			numberValue.Value = clone:GetScale()

			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local v36: Tween = tweenService:Create(numberValue, tweenInfo, { Value = 0.01 })

			v36.Completed:Connect(function()
				numberValue:Destroy()
				task.delay(0.1, function()
					clone:Destroy()
					motor6D:Destroy()
				end)
			end)
			v36:Play()
			numberValue:GetPropertyChangedSignal("Value"):Connect(function()
				clone:ScaleTo(numberValue.Value)
			end)
		end)
		sound:Play("Abilities.VictimDeflect", humanoidRootPart)

		return
	end
end
