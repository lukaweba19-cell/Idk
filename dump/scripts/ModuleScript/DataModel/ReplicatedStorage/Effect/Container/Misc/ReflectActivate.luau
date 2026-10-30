-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local util: Instance = replicatedStorage:WaitForChild("Util")

require(util:WaitForChild("Debris"))

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))
local misc = require(game.ReplicatedStorage.Util.Misc)
local tweenService: TweenService = game:GetService("TweenService")
local debris = require(game.ReplicatedStorage.Util.Debris)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)

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

		local v21: Player = players:GetPlayerFromCharacter(Character)
		local v22 = v21 and v21.UserId or nil
		local clone = replicatedStorage.FX.AbilityFX.Reflect.ReflectAttachment:Clone()

		clone.Position = Vector3.new(-0, -0.125, -0)
		clone.Parent = parent

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

		tweenService:Create(clone, tweenInfo, { Position = Vector3.new(0, 1, 0) * parent.Size.Y * 0.425 }):Play()
		misc.EmitAll(clone)

		local clonePointLight = clone.PointLight
		local tweenInfo2 = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

		tweenService:Create(clonePointLight, tweenInfo2, { Brightness = 0 }):Play()

		local highlightPoolsEffect = highlightPools.Effect
		local occluded = Enum.HighlightDepthMode.Occluded
		local color3 = Color3.fromRGB(255, 255, 255)
		local color32 = Color3.fromRGB(255, 255, 255)
		local v31 = highlightPoolsEffect:acquire(knifeRig, {
			FillTransparency = 0,
			OutlineTransparency = 0,
			DepthMode = occluded,
			FillColor = color3,
			OutlineColor = color32
		})

		if v31 then
			local tweenInfo3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local v33: Tween = tweenService:Create(v31, tweenInfo3, { FillTransparency = 1, OutlineTransparency = 1 })

			highlightPoolsEffect:trackTween(v31, v33)
			v33:Play()
			highlightPoolsEffect:releaseAfter(v31, 0.3)
		end

		local v34 = sound:Play("Abilities.Reflect", humanoidRootPart, nil, nil, nil, nil)

		if v22 then
			abilityVFXCleanup.Track(v22, "ReflectActivateVFX", {
				duration = 1.5,
				onCleanup = function()
					if clone and clone.Parent then
						clone:Destroy()
					end

					if v31 then
						highlightPoolsEffect:release(v31)
					end

					if v34 then
						v34:FadeOut(0.1)
					end
				end
			})

			return
		end

		debris:AddItem(clone, 1.5)

		return
	end
end
