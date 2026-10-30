-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local players: Players = game:GetService("Players")

require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local mesh = game.ReplicatedStorage.FX.KillEffects.WaterSpout.Mesh
local t1: {[any]: any} = {
	"Torso",
	"HumanoidRootPart",
	"Head",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg"
}
local t2: {[any]: any} = {
	SpinDuration = 2.2,
	GrowTime = 0.22,
	BurstTail = 1.3,
	BinLifetime = 7,
	MaxViewDistance = 1000,
	SpoutSpinStart = 9,
	SpoutSpinEnd = 30,
	VictimSpinStart = 4,
	VictimSpinEnd = 22,
	VictimLift = 12.6,
	OrbitStart = 0.4,
	OrbitEnd = 3.2,
	VictimTiltMax = 0.2792526803190927,
	LaunchUp = 70,
	LaunchTangent = 28,
	LaunchHandoff = 1,
	TumbleRate = 7,
	FlailAmp = 0.22689280275926285,
	FlailRateMin = 5.5,
	FlailRateMax = 9,
	SwirlPulseTime = 0.55,
	HelixStrands = {
		{ part = "Helix1", extraSpin = 8 },
		{ part = "Helix2", extraSpin = 12 }
	}
}
local t3: {[any]: any} = {
	Head = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true
}

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.p - Character:GetPivot().Position).Magnitude >= t2.MaxViewDistance then
		return
	end

	local v13 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v13 then
		return
	end

	local _fx_WaterSpout: Folder = Instance.new("Folder")

	_fx_WaterSpout.Name = "_FX_WaterSpout"
	_fx_WaterSpout.Parent = workspace.Bin

	local u15: boolean = true
	local t4: {[any]: any} = {}
	local u17 = nil
	local characterArchivable = Character.Archivable

	Character.Archivable = true

	local clone = Character:Clone()

	Character.Archivable = characterArchivable

	local u20 = nil
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}
	local t7: {[any]: any} = {}

	if clone then
		clone.Name = "_WaterSpoutBody"

		for iterFirst, iterSecond in clone:GetDescendants() do
			if not iterSecond:IsA("Script") and not iterSecond:IsA("LocalScript") then
				if iterSecond:IsA("BasePart") then
					iterSecond.CanCollide = false
					iterSecond.CanQuery = false
					iterSecond.CanTouch = false
					iterSecond.Massless = true
					iterSecond.CollisionGroup = "Debris"
				elseif iterSecond:IsA("Humanoid") then
					iterSecond.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					iterSecond.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
					iterSecond.EvaluateStateMachine = false
				end
			else
				iterSecond:Destroy()
			end
		end

		u20 = clone:FindFirstChild("Torso") or clone:FindFirstChild("HumanoidRootPart")

		if u20 then
			local v26 = u20.CFrame

			for key, value in t1 do
				local foundChild = clone:FindFirstChild(value)

				if foundChild and foundChild:IsA("BasePart") then
					foundChild.Anchored = true
					table.insert(t5, foundChild)
					t6[foundChild] = v26:ToObjectSpace(foundChild.CFrame)

					if t3[value] then
						t7[foundChild] = {
							px = key * 2.1,
							pz = key * 3.7,
							rate = t2.FlailRateMin + (t2.FlailRateMax - t2.FlailRateMin) * (key % 3 / 2)
						}
					end
				end
			end

			clone.Parent = _fx_WaterSpout
		else
			clone:Destroy()
			clone = nil
		end
	end

	local t8: {[any]: any} = {}
	local t9: {[any]: any} = {}

	if clone then
		for iterFirst2, iterSecond2 in Character:GetDescendants() do
			if iterSecond2:IsA("BasePart") then
				iterSecond2.LocalTransparencyModifier = 1
				table.insert(t8, iterSecond2)
			elseif iterSecond2:IsA("Decal") then
				t9[iterSecond2] = iterSecond2.Transparency
				iterSecond2.Transparency = 1
			end
		end
	end

	local u34: boolean = false

	local function restoreVisibility()
		if u34 then
			return
		end

		u34 = true

		for key, value in t8 do
			if value.Parent then
				value.LocalTransparencyModifier = 0
			end
		end

		for key2, value2 in t9 do
			if key2.Parent then
				key2.Transparency = value2
			end
		end
	end

	local t10: {[any]: any} = {}
	local t11: {[any]: any} = {}

	local function stopSwirlTweens()
		for key, value in t10 do
			pcall(function()
				value:Cancel()
			end)
		end

		table.clear(t10)
	end
	local function dropConnections()
		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)
	end
	local function killLoopSound()
		if u17 and not u17.Destroyed then
			u17:FadeOut(0.3)
		end

		u17 = nil
	end
	local function teardown()
		if not u15 then
			return
		end

		u15 = false

		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)

		if u17 and not u17.Destroyed then
			u17:FadeOut(0.3)
		end

		u17 = nil

		if not u34 then
			u34 = true

			for key2, value2 in t8 do
				if value2.Parent then
					value2.LocalTransparencyModifier = 0
				end
			end

			for key3, value3 in t9 do
				if key3.Parent then
					key3.Transparency = value3
				end
			end
		end

		stopSwirlTweens()

		if _fx_WaterSpout.Parent then
			_fx_WaterSpout:Destroy()
		end
	end

	Character.AncestryChanged:Once(function()
		if Character:IsDescendantOf(game) then
			return
		end

		if not u15 then
			return
		end

		u15 = false

		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)

		if u17 and not u17.Destroyed then
			u17:FadeOut(0.3)
		end

		u17 = nil

		if not u34 then
			u34 = true

			for key2, value2 in t8 do
				if value2.Parent then
					value2.LocalTransparencyModifier = 0
				end
			end

			for key3, value3 in t9 do
				if key3.Parent then
					key3.Transparency = value3
				end
			end
		end

		stopSwirlTweens()

		if _fx_WaterSpout.Parent then
			_fx_WaterSpout:Destroy()
		end
	end)
	_fx_WaterSpout.AncestryChanged:Once(function()
		if not _fx_WaterSpout:IsDescendantOf(game) then
			u15 = false

			for key, value in t4 do
				if value.Connected then
					value:Disconnect()
				end
			end

			table.clear(t4)

			if u17 and not u17.Destroyed then
				u17:FadeOut(0.3)
			end

			u17 = nil

			if not u34 then
				u34 = true

				for key2, value2 in t8 do
					if value2.Parent then
						value2.LocalTransparencyModifier = 0
					end
				end

				for key3, value3 in t9 do
					if key3.Parent then
						key3.Transparency = value3
					end
				end
			end

			stopSwirlTweens()
		end
	end)
	debris:AddItem(_fx_WaterSpout, t2.BinLifetime)

	local vector3 = Vector3.new(v13.Position.X, v13.Position.Y - 2.6, v13.Position.Z)
	local cFrame = CFrame.new(vector3)
	local clone2 = mesh.Spout:Clone()

	clone2:PivotTo(cFrame)
	clone2.Parent = _fx_WaterSpout
	debris:AddItem(clone2, t2.SpinDuration + t2.BurstTail + 0.5)
	u17 = sound:Play("KillEffects.WaterSpout", clone2.Root, 90, nil, 0.6, 0.08)

	local disperseFX = clone2:FindFirstChild("DisperseFX")
	local glowLight = clone2.Root:FindFirstChild("GlowLight")

	for iterFirst3, iterSecond3 in clone2:GetDescendants() do
		if (not disperseFX or not iterSecond3:IsDescendantOf(disperseFX)) and (iterSecond3:IsA("ParticleEmitter") or iterSecond3:IsA("Beam")) and iterSecond3:GetAttribute("EmitDuration") then
			iterSecond3:SetAttribute("EmitDuration", t2.SpinDuration)
			misc.Emit(iterSecond3)
		end
	end

	if glowLight then
		glowLight.Enabled = true
	end

	for iterFirst4, iterSecond4 in t2.HelixStrands, nil, nil do
		local foundChild = clone2:FindFirstChild(iterSecond4.part)

		if foundChild then
			local t12: {[any]: any} = {}

			for iterFirst5, iterSecond5 in foundChild:GetChildren() do
				if iterSecond5:IsA("Beam") then
					table.insert(t12, iterSecond5)
				end
			end

			local pulse: NumberValue = Instance.new("NumberValue")

			pulse.Name = "Pulse"
			pulse.Parent = foundChild

			local function applyPulse(p2)
				for key, value in t12 do
					local v101 = value:GetAttribute("BaseW0") or value.Width0
					local v102 = value:GetAttribute("BaseW1") or value.Width1
					local u = value:GetAttribute("U")

					value.Width0 = v101 * (1 + 0.45 * p2)
					value.Width1 = v102 * (1 + 0.45 * p2)
					value.Brightness = 1 + 1.3 * p2
					v102 = math.clamp(0.16 + 0.24 * p2 + (u or 0) * 0.12, 0, 1)

					local numberSequenceNew = NumberSequence.new
					local numberSequenceKeypointNew = NumberSequenceKeypoint.new
					local v106 = math.min(v102 + 0.15, 1)
					local v107 = numberSequenceKeypointNew(0, v106)
					local numberSequenceKeypoint = NumberSequenceKeypoint.new(0.5, v102)
					local v109 = NumberSequenceKeypoint.new
					local v110 = math.min(v102 + 0.15, 1)

					value.Transparency = numberSequenceNew({ v107, numberSequenceKeypoint, v109(1, v110) })
				end
			end

			table.insert(t4, pulse.Changed:Connect(applyPulse))
			applyPulse(0)

			local tweenInfo = TweenInfo.new(t2.SwirlPulseTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, (iterFirst4 - 1) * 0.3)

			applyPulse = tweenService:Create(pulse, tweenInfo, { Value = 1 })
			applyPulse:Play()
			table.insert(t10, applyPulse)
			table.insert(t11, { theta = 0, spec = iterSecond4, part = foundChild })
		end
	end

	local v58: Player = players:GetPlayerFromCharacter(Character)
	local u59: boolean = true

	if v58 ~= nil then
		u59 = v58 == players.LocalPlayer
	end

	local v60 = v13.Position
	local n1 = v13.CFrame - v13.CFrame.Position

	local function poseBody(p3, p4, p5)
		if not u20 then
			return
		end

		for key, value in t5 do
			local v116 = t6[value]

			if v116 and value.Parent then
				local v117 = t7[value]

				if v117 then
					local n1 = t2.FlailAmp * p5
					local cFrameAngles = CFrame.Angles
					local sine = math.sin(p4 * v117.rate + v117.px)
					local cosine = math.cos(p4 * v117.rate + v117.pz)
					local cFrame = cFrameAngles(n1 * sine, 0, n1 * cosine)

					value.CFrame = p3 * v116 * cFrame
				else
					value.CFrame = p3 * v116
				end
			end
		end
	end

	local n2 = 0
	local n3 = 0
	local v65 = os.clock()
	local u66: boolean = false
	local u67 = nil
	local u68 = nil
	local u69 = nil
	local n4 = 0
	local connection = nil

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		if not u15 then
			connection:Disconnect()

			return
		end

		local n5 = os.clock() - v65
		local v125 = math.clamp(n5 / t2.SpinDuration, 0, 1)

		if clone2.Parent then
			local v126 = math.clamp(n5 / t2.GrowTime, 0.05, 1)

			clone2:ScaleTo(1 - (1 - v126) ^ 2)
			n2 += (t2.SpoutSpinStart + (t2.SpoutSpinEnd - t2.SpoutSpinStart) * v125) * deltaTime

			local v127 = CFrame.Angles(0, n2, 0)

			clone2:PivotTo(cFrame * v127)

			for key, value in t11 do
				value.theta = value.theta + (t2.SpoutSpinStart + (t2.SpoutSpinEnd - t2.SpoutSpinStart) * v125 + value.spec.extraSpin) * deltaTime

				local part = value.part
				local v131 = CFrame.Angles(0, value.theta, 0)

				part.CFrame = cFrame * v131
			end
		end

		if not u66 then
			n3 -= (t2.VictimSpinStart + (t2.VictimSpinEnd - t2.VictimSpinStart) * v125) * deltaTime

			local n6 = t2.VictimLift * v125 ^ 1.15
			local n7 = t2.OrbitStart + (t2.OrbitEnd - t2.OrbitStart) * v125
			local cosine = math.cos(n3)
			local sine = math.sin(n3)
			local vector32 = Vector3.new(cosine, 0, sine)
			local cFrameAngles = CFrame.Angles
			local victimTiltMax = t2.VictimTiltMax
			local sine2 = math.sin(n5 * 9)
			local v140 = t2.VictimTiltMax
			local cosine2 = math.cos(n5 * 7)
			local v142 = cFrameAngles(victimTiltMax * sine2, 0, v140 * cosine2)
			local cFrameNew = CFrame.new
			local vector33 = Vector3.new(0, n6, 0)
			local v145 = cFrameNew(v60 + vector33 + vector32 * n7)
			local v146 = CFrame.Angles(0, n3, 0)

			poseBody(v145 * v146 * v142 * n1, n5, v125 * 0.6 + 0.4)

			if v125 >= 1 then
				u66 = true

				if disperseFX then
					misc.EmitAll(disperseFX)
				end

				sound:Play("KillEffects.WaterSpoutBurst", u20 or v13, 110, nil, 0.95, 0.1)

				if u17 and not u17.Destroyed then
					u17:FadeOut(0.3)
				end

				u17 = nil
				stopSwirlTweens()

				if glowLight then
					local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					tweenService:Create(glowLight, tweenInfo, { Brightness = 0 }):Play()
				end

				if clone2.Parent then
					debris:AddItem(clone2, t2.BurstTail)
				end

				local sine3 = math.sin(n3)
				local cosine3 = math.cos(n3)
				local vector34 = Vector3.new(-sine3, 0, cosine3)
				local v151 = u20 and u20.Position

				if not v151 then
					local vector35 = Vector3.new(0, t2.VictimLift, 0)

					v151 = v60 + vector35
				end

				u67 = v151
				u68 = Vector3.new(0, t2.LaunchUp, 0) - vector34 * t2.LaunchTangent
				u69 = vector34:Cross(Vector3.new(0, 1, 0))
				u69 = u69.Magnitude > 0.01 and u69.Unit or Vector3.new(1, 0, 0)

				return
			end
		else
			local v153 = u68
			local vector36 = Vector3.new(0, -workspace.Gravity, 0)

			u68 = v153 + vector36 * deltaTime
			u67 += u68 * deltaTime
			n4 += t2.TumbleRate * deltaTime

			local cFrame2 = CFrame.new(u67)
			local v156 = CFrame.fromAxisAngle(u69, n4)
			local v157 = CFrame.Angles(0, n3, 0)

			poseBody(cFrame2 * v156 * v157 * n1, n5, 0.5)

			if n5 >= t2.SpinDuration + t2.LaunchHandoff then
				connection:Disconnect()

				if u59 and Character.Parent and u20 then
					for key2, value2 in t5 do
						local foundChild2 = Character:FindFirstChild(value2.Name)

						if foundChild2 and foundChild2:IsA("BasePart") and value2.Parent then
							foundChild2.CFrame = value2.CFrame
							foundChild2.AssemblyLinearVelocity = u68
							foundChild2.AssemblyAngularVelocity = u69 * t2.TumbleRate
						end
					end
				end

				if not u34 then
					u34 = true

					for key3, value3 in t8 do
						if value3.Parent then
							value3.LocalTransparencyModifier = 0
						end
					end

					for key4, value4 in t9 do
						if key4.Parent then
							key4.Transparency = value4
						end
					end
				end

				if clone and clone.Parent then
					clone:Destroy()
				end
			end
		end
	end)
	table.insert(t4, connection)
end
