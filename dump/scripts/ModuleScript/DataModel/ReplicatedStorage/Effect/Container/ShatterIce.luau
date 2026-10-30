-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local debrisShapes: Instance = script:WaitForChild("DebrisShapes")
local sound = require(game.ReplicatedStorage:WaitForChild("Sound"))

return function(p1)
	local v5, v6 = unpack(p1)

	if not v5 then
		return
	end

	local cFrame = v5.CFrame
	local v8 = v5.Color
	local material = v5.Material
	local transparency = v5.Transparency

	sound:Play("Misc.Shatter", cFrame)

	local children = debrisShapes:GetChildren()
	local randomNumber = math.random(#children)
	local clone = children[randomNumber]:Clone()

	clone:PivotTo(cFrame)

	if v6 then
		clone:ScaleTo(v6)
	end

	clone.Parent = workspace.Bin

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Color = v8
			v.Material = material
			v.Transparency = transparency
			v.Anchored = false
			v.CanCollide = true
			v.CollisionGroup = "Debris2"

			local n1 = v.Position - cFrame.Position
			local vector3

			if n1.Magnitude < 0.1 then
				local randomNumber2 = math.random()
				local randomNumber3 = math.random()
				local randomNumber4 = math.random()

				vector3 = Vector3.new(randomNumber2 - 0.5, randomNumber3, randomNumber4 - 0.5)
			else
				vector3 = n1 + Vector3.new(0, 1, 0)
			end

			local vector3Unit = vector3.Unit
			local randomNumber5 = math.random(35, 50)

			v.AssemblyLinearVelocity = vector3Unit * randomNumber5
			task.delay(0.4, function()
				local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local v24: Tween = tweenService:Create(v, tweenInfo, { Transparency = 1, Size = v.Size * 0.7 })

				v24:Play()
				v24.Completed:Connect(function()
					if v then
						v:Destroy()
					end
				end)
			end)
		end
	end

	task.delay(3, function()
		clone:Destroy()
	end)
end
