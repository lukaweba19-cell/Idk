-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local murderNote = game.ReplicatedStorage.FX.KillEffects.MurderNote
local flattenBody = require(script.Parent.FlattenBody)
local t1: {[any]: any} = { DropHeight = 42, GravityMult = 1.6, RestTime = 2.4, BinLifetime = 6 }

return function(player, _, p3)
	local Character = player.Character
	local v12 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v12 then
		return
	end

	local _fx_MurderNote_PianoDrop: Folder = Instance.new("Folder")

	_fx_MurderNote_PianoDrop.Name = "_FX_MurderNote_PianoDrop"
	_fx_MurderNote_PianoDrop.Parent = workspace.Bin
	debris:AddItem(_fx_MurderNote_PianoDrop, 6)

	local u14: boolean = true
	local t2: {[any]: any} = {}
	local t3: {[any]: any} = {}

	local function cleanupHandles()
		for key, value in t2 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t2)

		for key2, value2 in t3 do
			pcall(function()
				value2:Cancel()
			end)
		end

		table.clear(t3)
	end
	local function teardown()
		if not u14 then
			return
		end

		u14 = false
		cleanupHandles()

		if _fx_MurderNote_PianoDrop.Parent then
			_fx_MurderNote_PianoDrop:Destroy()
		end
	end

	Character.AncestryChanged:Once(function()
		if Character:IsDescendantOf(game) then
			return
		end

		if not u14 then
			return
		end

		u14 = false
		cleanupHandles()

		if _fx_MurderNote_PianoDrop.Parent then
			_fx_MurderNote_PianoDrop:Destroy()
		end
	end)
	_fx_MurderNote_PianoDrop.AncestryChanged:Once(function()
		if not _fx_MurderNote_PianoDrop:IsDescendantOf(game) then
			u14 = false
			cleanupHandles()
		end
	end)

	local v19 = v12.Position
	local v20 = p3:NextNumber(0, 6.283185307179586)
	local clone = murderNote.piano:Clone()

	clone.Anchored = true
	clone.CanCollide = false
	clone.CanQuery = false
	clone.CanTouch = false
	clone.Massless = true
	clone.CastShadow = true
	clone.CollisionGroup = "Debris"

	local n1 = v19.Y - 3.9 + clone.Size.Y * 0.5
	local n2 = n1 + 42
	local cFrameNew = CFrame.new
	local vector3 = Vector3.new(v19.X, 0, v19.Z)
	local cFrame = cFrameNew(vector3)
	local v27 = CFrame.Angles(0, v20, 0)
	local n3 = cFrame * v27
	local vector32 = Vector3.new(0, n2, 0)

	clone.CFrame = n3 + vector32
	clone.Parent = _fx_MurderNote_PianoDrop
	debris:AddItem(clone, 5.4)

	local attachment: Attachment = Instance.new("Attachment")

	attachment.Position = Vector3.new(0, -clone.Size.Y * 0.5 + 0.3, 0)
	attachment.Parent = clone

	local dustRing: ParticleEmitter = Instance.new("ParticleEmitter")

	dustRing.Name = "DustRing"
	dustRing.Enabled = false
	dustRing.Texture = "rbxasset://textures/particles/smoke_main.dds"
	dustRing.Orientation = Enum.ParticleOrientation.FacingCamera

	local colorSequenceNew = ColorSequence.new
	local color3 = Color3.fromRGB(168, 150, 128)

	dustRing.Color = colorSequenceNew(color3, Color3.fromRGB(120, 108, 94))
	dustRing.Lifetime = NumberRange.new(0.6, 1.1)
	dustRing.Speed = NumberRange.new(12, 20)
	dustRing.SpreadAngle = Vector2.new(180, 8)
	dustRing.Acceleration = Vector3.new(0, -6, 0)
	dustRing.Drag = 3
	dustRing.Rate = 0
	dustRing.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 2.2),
		NumberSequenceKeypoint.new(1, 4.6)
	})
	dustRing.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.35),
		NumberSequenceKeypoint.new(0.7, 0.6),
		NumberSequenceKeypoint.new(1, 1)
	})
	dustRing.LightInfluence = 1
	dustRing.Parent = attachment

	local clone2: Instance = dustRing:Clone()

	clone2.Name = "WoodChips"
	clone2.Texture = "rbxassetid://105995611214713"
	clone2.Color = ColorSequence.new(Color3.fromRGB(96, 66, 40))
	clone2.Speed = NumberRange.new(16, 30)
	clone2.SpreadAngle = Vector2.new(180, 40)
	clone2.Acceleration = Vector3.new(0, -60, 0)
	clone2.Drag = 0.6
	clone2.Lifetime = NumberRange.new(0.4, 0.8)
	clone2.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 0.2)
	})
	clone2.Parent = attachment

	local n4: number = workspace.Gravity * 1.6
	local v36 = p3:NextNumber(-0.7, 0.7)
	local v37 = os.clock()
	local u38: boolean = false
	local connection = nil

	connection = runService.RenderStepped:Connect(function()
		if not u14 or not clone.Parent then
			connection:Disconnect()

			return
		end

		local n5 = os.clock() - v37
		local n6 = n2 - 0.5 * n4 * n5 * n5

		if n6 <= n1 then
			connection:Disconnect()
			u38 = true

			local vector33 = Vector3.new(0, n1, 0)

			clone.CFrame = n3 + vector33
			sound:Play("KillEffects.MurderNote.PianoCrash", clone, 100, nil, 1, 0.05)
			sound:Play("KillEffects.MurderNote.PianoThud", clone, 100, nil, 0.35, 0.05)
			flattenBody(Character, { slamTime = 0.06, splat = true, jiggle = false })
			dustRing:Emit(16)
			clone2:Emit(22)

			local tweenInfo = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local vector34 = Vector3.new(0, n1 + 0.8, 0)
			local v49: Tween = tweenService:Create(clone, tweenInfo, { CFrame = n3 + vector34 })
			local tweenInfo2 = TweenInfo.new(0.18, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
			local vector35 = Vector3.new(0, n1, 0)
			local v52: Tween = tweenService:Create(clone, tweenInfo2, { CFrame = n3 + vector35 })

			table.insert(t3, v49)
			table.insert(t3, v52)
			v49:Play()
			v49.Completed:Once(function()
				if u14 and clone.Parent then
					v52:Play()
				end
			end)

			return
		end

		local vector36 = Vector3.new(0, n6, 0)
		local v54 = CFrame.Angles(v36 * n5 * 0.5, 0, v36 * n5 * 0.3)

		clone.CFrame = (n3 + vector36) * v54
	end)
	table.insert(t2, connection)
end
