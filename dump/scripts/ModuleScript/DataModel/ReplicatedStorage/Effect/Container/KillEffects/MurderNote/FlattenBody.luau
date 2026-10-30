-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local t1: {[any]: any} = {
	Torso = { offset = Vector2.new(0, 0), footprint = Vector2.new(2, 2) },
	Head = {
		faceUp = true,
		offset = Vector2.new(0, 1.85),
		footprint = Vector2.new(1.4, 1.4)
	},
	["Left Arm"] = { offset = Vector2.new(-1.55, 0), footprint = Vector2.new(1, 2) },
	["Right Arm"] = { offset = Vector2.new(1.55, 0), footprint = Vector2.new(1, 2) },
	["Left Leg"] = { offset = Vector2.new(-0.52, -2), footprint = Vector2.new(1, 2) },
	["Right Leg"] = { offset = Vector2.new(0.52, -2), footprint = Vector2.new(1, 2) }
}

return function(p1, p2)
	local t2 = p2 or {}
	local v7 = t2.slamTime or 0.11
	local v8 = t2.delay or 0
	local u9: boolean = t2.splat ~= false
	local u10: boolean = t2.jiggle ~= false
	local v11 = p1:FindFirstChild("Torso") or p1:FindFirstChild("HumanoidRootPart")

	if not v11 then
		return
	end

	local u12: boolean = true
	local t3: {[any]: any} = {}

	local function stopTweens()
		for key, value in t3 do
			pcall(function()
				value:Cancel()
			end)
		end

		table.clear(t3)
	end

	p1.AncestryChanged:Once(function()
		if not p1:IsDescendantOf(game) then
			u12 = false
			stopTweens()
		end
	end)

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin, p1 }

	local v16 = workspace:Raycast(v11.Position, Vector3.new(0, -30, 0), raycastParams)
	local v17 = v16 and v16.Position.Y or v11.Position.Y - 2.5
	local lookVector = v11.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
	local u20 = vector3.Magnitude > 0.05 and vector3.Unit or Vector3.new(0, 0, 1)
	local unit = u20:Cross(Vector3.new(0, 1, 0)).Unit
	local vector32 = Vector3.new(v11.Position.X, v17 + 0.09, v11.Position.Z)

	task.spawn(function()
		if v8 > 0 then
			task.wait(v8)
		end

		if not u12 or not p1.Parent or not v11.Parent then
			return
		end

		local t4: {[any]: any} = {}

		for iterValue in t1 do
			local foundChild = p1:FindFirstChild(iterValue)

			if foundChild and foundChild:IsA("BasePart") then
				foundChild.Anchored = true
				foundChild.CanCollide = false
				foundChild.CanQuery = false
				foundChild.CanTouch = false
				t4[iterValue] = foundChild
			end
		end

		local humanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
			humanoidRootPart.Anchored = true
			humanoidRootPart.CFrame = CFrame.new(vector32)
		end

		local t5: {[any]: any} = {}

		for key, value in t4 do
			local v32 = t1[key]
			local n1 = vector32 + unit * v32.offset.X + u20 * v32.offset.Y
			local v34
			local vector33
			local s1

			if v32.faceUp then
				v34 = CFrame.fromMatrix(n1, -unit, u20)
				vector33 = Vector3.new(v32.footprint.X, v32.footprint.Y, 0.18)
				s1 = "Z"
			else
				v34 = CFrame.fromMatrix(n1, unit, Vector3.new(0, 1, 0))
				vector33 = Vector3.new(v32.footprint.X, 0.18, v32.footprint.Y)
				s1 = "Y"
			end

			t5[value] = { cf = v34, size = vector33, thinAxis = s1 }
		end

		local tweenInfo = TweenInfo.new(v7, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		for key2, value2 in t5 do
			local v40: Tween = tweenService:Create(key2, tweenInfo, { CFrame = value2.cf, Size = value2.size })

			table.insert(t3, v40)
			v40:Play()
		end

		task.wait(v7)

		if not u12 or not v11.Parent then
			return
		end

		if u9 then
			sound:Play("KillEffects.MurderNote.Splat", v11, 60, nil, 1, 0.06)
		end

		if u10 then
			local tweenInfo2 = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tweenInfo3 = TweenInfo.new(0.16, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

			for key3, value3 in t5 do
				local v45 = if value3.thinAxis == "Z" then Vector3.new(value3.size.X * 0.92, value3.size.Y * 0.92, value3.size.Z * 1.9) else Vector3.new(value3.size.X * 0.92, value3.size.Y * 1.9, value3.size.Z * 0.92)
				local v46: Tween = tweenService:Create(key3, tweenInfo2, { Size = v45, CFrame = value3.cf + Vector3.new(0, 0.081, 0) })
				local v47: Tween = tweenService:Create(key3, tweenInfo3, { Size = value3.size, CFrame = value3.cf })

				table.insert(t3, v46)
				table.insert(t3, v47)
				v46:Play()
				v46.Completed:Once(function()
					if u12 and key3.Parent then
						v47:Play()
					end
				end)
			end
		end
	end)
end
