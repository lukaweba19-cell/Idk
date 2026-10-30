-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local players: Players = game:GetService("Players")
local collectionService: CollectionService = game:GetService("CollectionService")
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local ice = game.ReplicatedStorage.FX.AbilityFX.FrostRounds:WaitForChild("Ice")
local random = Random.new()

local function surfaceCFrame(p1, p2)
	local unit = p2.Unit
	local v12 = unit:Dot(Vector3.new(0, 1, 0))
	local v13 = (if math.abs(v12) > 0.95 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)):Cross(unit).Unit

	v12 = v13:Cross(unit)
	v12 = CFrame.fromMatrix(p1, v13, unit, v12.Unit)

	local cFrameAngles = CFrame.Angles
	local v15 = random:NextNumber(0, 6.283185307179586)
	local cFrame = cFrameAngles(0, v15, 0)

	return v12 * cFrame
end

return function(p3)
	local v18 = p3.Position
	local normal = p3.Normal

	if typeof(v18) ~= "Vector3" or typeof(normal) ~= "Vector3" then
		return
	end

	if normal.Magnitude < 0.001 then
		return
	end

	local v20 = players.LocalPlayer and players.LocalPlayer.Character
	local humanoidRootPart = v20 and v20:FindFirstChild("HumanoidRootPart")

	if ((humanoidRootPart and humanoidRootPart.Position or workspace.CurrentCamera.CFrame.Position) - v18).Magnitude > 750 then
		return
	end

	local clone = ice:Clone()

	v20 = clone.Size
	clone.CFrame = surfaceCFrame(v18 + normal.Unit * (v20.Y * 0.5), normal)

	local v23 = random:NextNumber(1, 2)

	clone.Size = v20 / 2 * v23
	clone:SetAttribute("FromAbilityCast", true)
	collectionService:AddTag(clone, "FrostIce")
	clone.Parent = workspace:FindFirstChild("Bin") or workspace
	sound:Play("Abilities.IceFloorCreate", clone.CFrame)

	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back)

	tweenService:Create(clone, tweenInfo, { Size = v20 }):Play()
	misc.EmitAll(clone)
	task.delay(3, function()
		if not clone.Parent then
			return
		end

		local tweenInfo2 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local v26: Tween = tweenService:Create(clone, tweenInfo2, { Size = Vector3.new(0.001, 0.001, 0.001) })

		v26.Completed:Connect(function()
			clone:Destroy()
		end)
		v26:Play()
	end)
end
