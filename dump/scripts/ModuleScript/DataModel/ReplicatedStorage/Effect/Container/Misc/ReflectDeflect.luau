-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local debris = require(util:WaitForChild("Debris"))
local misc = require(game.ReplicatedStorage.Util.Misc)
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

		local knifeRig = Character:FindFirstChild("KnifeRig")
		local parent = knifeRig and knifeRig:FindFirstChild("BoundingBox") or nil

		if not parent then
			return
		end

		local clone = replicatedStorage.FX.AbilityFX.Reflect.Deflect:Clone()

		clone.Position = Vector3.new(-0, -0.125, -0)
		clone.Parent = parent
		debris:AddItem(clone, 3)

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

		tweenService:Create(clone, tweenInfo, { Position = Vector3.new(0, 1, 0) * parent.Size.Y * 0.425 }):Play()
		misc.EmitAll(clone)

		local reflectAttachment = parent:FindFirstChild("ReflectAttachment")

		if reflectAttachment then
			reflectAttachment:Destroy()
		end

		local clonePointLight = clone.PointLight
		local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

		tweenService:Create(clonePointLight, tweenInfo2, { Brightness = 0 }):Play()
		sound:Play("Abilities.Deflect", humanoidRootPart)

		return
	end
end
