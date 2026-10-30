-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local players: Players = game:GetService("Players")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local mesh = game.ReplicatedStorage.FX.KillEffects.Damnation.Mesh
local t1: {[any]: any} = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local v9 = CFrame.Angles(0.17453292519943295, 0, 0)
local v10 = CFrame.Angles(0.4886921905584123, 0, 0)
local v11 = CFrame.Angles(0, 0, 2.181661564992912)
local v12 = CFrame.Angles(0, 0, -2.181661564992912)
local v13 = CFrame.Angles(0, 0, 0.3839724354387525)
local v14 = CFrame.Angles(0, 0, -0.3839724354387525)
local cFrame = CFrame.new(0, -0.75, 0)
local v16 = CFrame.Angles(1.5707963267948966, 0, 0)
local v17 = CFrame.Angles(0, 0, 1.5707963267948966)
local v18 = CFrame.Angles(1.5707963267948966, 0, 0)
local n1 = v17 * v18
local v20 = CFrame.Angles(1.5707963267948966, 0, 0)

v18 = function(p1)
	return (p1 - 1) ^ 3 * 2.70158 + 1 + (p1 - 1) ^ 2 * 1.70158
end

local function quadOut(p2)
	return 1 - (1 - p2) * (1 - p2)
end
local function quadIn(p3)
	return p3 * p3
end
local function emit(p4)
	local ok, result = pcall(forgeVFX.emit, p4)

	if not ok then
		local v34 = p4.Name
		local text: string = tostring(result)

		warn("[Damnation] emit failed on " .. v34 .. ": " .. text)
	end
end
local function stopEmitters(p5)
	for _, v in ipairs(p5:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end
local function flashLight(p6, p7)
	p6.Range = p7.Range
	p6.Brightness = 0

	local tweenInfo = TweenInfo.new(p7.Up, Enum.EasingStyle.Linear)
	local v42: Tween = tweenService:Create(p6, tweenInfo, { Brightness = p7.Brightness })

	v42.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p7.Down, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p6, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v42:Play()
end

local t2: {[any]: any} = {
	MaxDistance = 1000,
	HitTime = 1.77,
	ReleaseLead = 0.02,
	CleanupAfter = 7,
	Lift = 2.2,
	HoistTime = 0.3,
	Tremble = 0.06,
	ChainStart = 0.08,
	ChainStagger = 0.07,
	ChainTravel = 0.11,
	LinkPitch = 0.66,
	DebrisChance = 0.35,
	OrbAppear = 0.4,
	PinchTime = 0.1,
	DashTime = 0.12,
	OrbUp = 7,
	OrbOut = 7.5,
	OrbStartSize = 0.4,
	OrbEndSize = 2.7,
	ShakeDistance = 70,
	LimbTrailTime = 2.4,
	Chains = {
		{ limb = "Right Arm", rift = Vector3.new(8, 4.4, 1.2) },
		{ limb = "Left Arm", rift = Vector3.new(-8, 4.4, -1.2) },
		{ limb = "Right Leg", rift = Vector3.new(6, -4.4, -1.6) },
		{ limb = "Left Leg", rift = Vector3.new(-6, -4.4, 1.6) }
	},
	OrbLight = { Brightness = 6, Range = 22 },
	Flash = { Brightness = 14, Range = 42, Up = 0.02, Down = 0.35 }
}
local t3: {[any]: any} = {
	Torso = v9,
	Head = CFrame.new(0, 1.45, 0.2) * v10,
	["Right Arm"] = CFrame.new(1.3, 0.8, 0) * v11 * CFrame.new(0, -1, 0),
	["Left Arm"] = CFrame.new(-1.3, 0.8, 0) * v12 * CFrame.new(0, -1, 0),
	["Right Leg"] = CFrame.new(0.5, -1, 0) * v13 * CFrame.new(0, -1, 0),
	["Left Leg"] = CFrame.new(-0.5, -1, 0) * v14 * CFrame.new(0, -1, 0)
}

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude > t2.MaxDistance then
		return
	end

	local torso = Character:FindFirstChild("Torso")

	if not torso or not torso:IsA("BasePart") then
		return
	end

	local _fx_Damnation: Folder = Instance.new("Folder")

	_fx_Damnation.Name = "_FX_Damnation"
	_fx_Damnation.Parent = workspace.Bin

	local u50: boolean = true
	local u51: boolean = false
	local connection2 = nil
	local connection = nil
	local t4: {[any]: any} = {}
	local t5: {[any]: any} = {}

	local function own(p9)
		table.insert(t4, p9)

		return p9
	end
	local function release()
		if u51 then
			return
		end

		u51 = true

		for _, v in pairs(t5) do
			if v.part.Parent then
				v.part.Anchored = false
			end
		end
	end
	local function cleanup()
		if not u50 then
			return
		end

		u50 = false

		if connection2 then
			connection2:Disconnect()
		end

		if connection then
			connection:Disconnect()
		end

		if not u51 then
			u51 = true

			for _, v in pairs(t5) do
				if v.part.Parent then
					v.part.Anchored = false
				end
			end
		end

		for _, v in ipairs(t4) do
			pcall(game.Destroy, v)
		end

		table.clear(t4)
		_fx_Damnation:Destroy()
	end

	connection = Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			cleanup()
		end
	end)
	task.delay(t2.CleanupAfter, cleanup)

	local function at(p10, p11)
		local taskDelay = task.delay
		local v135 = math.max(p10, 0)

		taskDelay(v135, function()
			if u50 then
				p11()
			end
		end)
	end

	local lookVector = torso.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

	vector3 = if vector3.Magnitude > 0.05 then vector3.Unit else Vector3.new(0, 0, -1)

	local torsoPosition = torso.Position
	local t6 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t6, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t6
	t6 = workspace:Raycast(torsoPosition + Vector3.new(0, 2, 0), Vector3.new(0, -16, 0), raycastParams)

	local v66 = if t6 then t6.Position.Y else nil
	local v67

	if v66 then
		v67 = math.max(torsoPosition.Y, v66 + 3)
	else
		v67 = torsoPosition.Y
	end

	local vector32 = Vector3.new(torsoPosition.X, v67 + t2.Lift, torsoPosition.Z)

	t6 = CFrame.lookAt(vector32, vector32 + vector3)

	for i, v in ipairs(t1) do
		local v2 = Character:FindFirstChild(v)

		if v2 and v2:IsA("BasePart") then
			v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v2.Anchored = true
			t5[v] = {
				start = nil,
				part = v2,
				from = v2.CFrame,
				to = t6 * t3[v],
				seed = i * 10
			}
		end
	end

	local v72 = vector3
	local killerUserId = Character:GetAttribute("KillerUserId")
	local v74 = if typeof(killerUserId) == "number" then players:GetPlayerByUserId(killerUserId) else nil
	local character = v74 and v74.Character

	if character then
		local n11 = character:GetPivot().Position - vector32

		n11 = Vector3.new(n11.X, 0, n11.Z)

		if n11.Magnitude > 1 then
			v72 = n11.Unit
		end
	end

	local n2 = vector32 + v72 * t2.OrbOut
	local vector33 = Vector3.new(0, t2.OrbUp, 0)
	local n3 = n2 + vector33
	local n4 = t2.HitTime - t2.DashTime - t2.PinchTime - t2.OrbAppear
	local n5 = t2.OrbAppear + n4
	local n6 = n5 + t2.PinchTime
	local clone = nil

	if v66 then
		clone = mesh.Ground:Clone()
		clone.CFrame = CFrame.new(torsoPosition.X, v66 + 0.15, torsoPosition.Z)
		clone.Parent = _fx_Damnation

		local function v84()
			local cloneHold = clone.Hold
			local ok, result = pcall(forgeVFX.emit, cloneHold)

			if not ok then
				local cloneHoldName = cloneHold.Name
				local text: string = tostring(result)

				warn("[Damnation] emit failed on " .. cloneHoldName .. ": " .. text)
			end

			local cloneRise_Embers = clone.Rise_Embers
			local ok2, result2 = pcall(forgeVFX.emit, cloneRise_Embers)

			if not ok2 then
				local cloneRise_EmbersName = cloneRise_Embers.Name
				local text: string = tostring(result2)

				warn("[Damnation] emit failed on " .. cloneRise_EmbersName .. ": " .. text)
			end

			local cloneRise_Smoke = clone.Rise_Smoke
			local ok3, result3 = pcall(forgeVFX.emit, cloneRise_Smoke)

			if not ok3 then
				local cloneRise_SmokeName = cloneRise_Smoke.Name
				local text: string = tostring(result3)

				warn("[Damnation] emit failed on " .. cloneRise_SmokeName .. ": " .. text)
			end
		end

		task.delay(0.05, function()
			if u50 then
				v84()
			end
		end)
	end

	local t7: {[any]: any} = {}
	local n7 = math.huge

	for i, v in ipairs(t2.Chains) do
		local v89 = t5[v.limb]

		if v89 then
			local v90 = t6:PointToWorldSpace(v.rift)

			if v66 then
				local x = v90.X
				local v92 = math.max(v90.Y, v66 + 1.2)

				v90 = Vector3.new(x, v92, v90.Z)
			end

			local n8 = t2.ChainStart + (i - 1) * t2.ChainStagger
			local n9 = n8 + t2.ChainTravel

			v89.start = n9
			n7 = math.min(n7, n9)

			local clone = mesh.Portal:Clone()

			clone.CFrame = CFrame.lookAt(v90, vector32)
			clone.Parent = _fx_Damnation

			local v96 = math.max((v90 - (v89.from * cFrame).Position).Magnitude, (v90 - (v89.to * cFrame).Position).Magnitude)
			local n10 = math.ceil(v96 / t2.LinkPitch) + 1

			v96 = table.create(n10)

			for i = 1, n10 do
				local clone2 = mesh.Chain.Link:Clone()

				clone2.Transparency = 1
				clone2.CFrame = CFrame.new(v90)
				clone2.Parent = _fx_Damnation
				v96[i] = clone2
			end

			local t8: {[any]: any} = {
				shown = 0,
				cuff = nil,
				broken = false,
				limb = v89,
				rift = clone,
				riftPos = v90,
				fire = n8,
				latch = n9,
				links = v96,
				beams = {}
			}

			table.insert(t7, t8)

			local function v101()
				local cloneOpen = clone.Open
				local ok, result = pcall(forgeVFX.emit, cloneOpen)

				if not ok then
					local cloneOpenName = cloneOpen.Name
					local text: string = tostring(result)

					warn("[Damnation] emit failed on " .. cloneOpenName .. ": " .. text)
				end

				local cloneRift = clone.Rift
				local ok4, result4 = pcall(forgeVFX.emit, cloneRift)

				if not ok4 then
					local cloneRiftName = cloneRift.Name
					local text: string = tostring(result4)

					warn("[Damnation] emit failed on " .. cloneRiftName .. ": " .. text)
				end

				sound:Play("KillEffects.Damnation.Rift", clone, nil, nil, nil, 0.15)
			end

			local taskDelay = task.delay
			local v103 = math.max(n8 - 0.05, 0)

			taskDelay(v103, function()
				if u50 then
					v101()
				end
			end)

			local function v104()
				local cFrame2 = v89.part.CFrame * cFrame
				local clone3 = mesh.Chain.Latch:Clone()

				clone3.CFrame = cFrame2
				clone3.Parent = _fx_Damnation

				local ok, result = pcall(forgeVFX.emit, clone3)

				if not ok then
					local clone3Name = clone3.Name
					local text: string = tostring(result)

					warn("[Damnation] emit failed on " .. clone3Name .. ": " .. text)
				end

				debris:AddItem(clone3, 1.5)
				sound:Play("KillEffects.Damnation.Chain", clone3, nil, nil, nil, 0.2)

				local clone4 = mesh.Chain.Cuff:Clone()

				clone4.Anchored = false
				clone4.CFrame = cFrame2 * v20

				local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

				weldConstraint.Part0 = v89.part
				weldConstraint.Part1 = clone4
				weldConstraint.Parent = clone4
				clone4.Parent = _fx_Damnation
				t8.cuff = clone4

				local attachment: Attachment = Instance.new("Attachment")

				attachment.Parent = clone

				local _DamnationChain: Attachment = Instance.new("Attachment")

				table.insert(t4, _DamnationChain)
				_DamnationChain.Name = "_DamnationChain"
				_DamnationChain.CFrame = cFrame
				_DamnationChain.Parent = v89.part

				for _, iterValue in ipairs({ "Glow", "Crackle" }) do
					local clone5 = mesh.Chain[iterValue]:Clone()

					clone5.Attachment0 = attachment
					clone5.Attachment1 = _DamnationChain
					clone5.Parent = _fx_Damnation
					table.insert(t8.beams, clone5)
				end
			end

			local v105 = task.delay
			local v106 = math.max(n9, 0)

			v105(v106, function()
				if u50 then
					v104()
				end
			end)
		end
	end

	if n7 == math.huge then
		n7 = t2.ChainStart + t2.ChainTravel
	end

	local u107 = nil

	local function v108()
		local clone = mesh.Orb:Clone()
		local cloneCore = clone.Core
		local cloneShell = clone.Shell
		local cloneGather = clone.Gather
		local cFrame2 = CFrame.new(n3)

		cloneCore.CFrame = cFrame2
		cloneShell.CFrame = cFrame2
		cloneGather.CFrame = cFrame2
		cloneCore.Size = Vector3.new(1, 1, 1) * t2.OrbStartSize
		cloneShell.Size = Vector3.new(1, 1, 1) * t2.OrbStartSize * 1.35
		clone.Parent = _fx_Damnation

		local cloneCoreCharge = cloneCore.Charge
		local ok, result = pcall(forgeVFX.emit, cloneCoreCharge)

		if not ok then
			local cloneCoreChargeName = cloneCoreCharge.Name
			local text: string = tostring(result)

			warn("[Damnation] emit failed on " .. cloneCoreChargeName .. ": " .. text)
		end

		local ok5, result5 = pcall(forgeVFX.emit, cloneGather)

		if not ok5 then
			local cloneGatherName = cloneGather.Name
			local text: string = tostring(result5)

			warn("[Damnation] emit failed on " .. cloneGatherName .. ": " .. text)
		end

		local v188, v189 = sound:Play("KillEffects.Damnation.Charge", cloneCore)
		u107 = {
			done = false,
			folder = clone,
			core = cloneCore,
			shell = cloneShell,
			gather = cloneGather,
			light = cloneCore.Light,
			chargeSound = v189,
			pos = n3
		}
	end

	local v109 = task.delay
	local v110 = math.max(t2.OrbAppear, 0)

	v109(v110, function()
		if u50 then
			v108()
		end
	end)

	local function v111()
		if u107 then
			local ready = u107.core.Ready
			local ok, result = pcall(forgeVFX.emit, ready)

			if not ok then
				local readyName = ready.Name
				local text: string = tostring(result)

				warn("[Damnation] emit failed on " .. readyName .. ": " .. text)
			end
		end
	end

	local v112 = task.delay

	v110 = math.max(n5 - 0.2, 0)
	v112(v110, function()
		if u50 then
			v111()
		end
	end)

	local function v113()
		if not u107 then
			return
		end

		stopEmitters(u107.gather)
		stopEmitters(u107.core.Charge)
		u107.core.Trail.Enabled = true

		local launch = u107.core.Launch
		local ok, result = pcall(forgeVFX.emit, launch)

		if not ok then
			local launchName = launch.Name
			local text: string = tostring(result)

			warn("[Damnation] emit failed on " .. launchName .. ": " .. text)
		end

		if u107.chargeSound then
			u107.chargeSound:Destroy()
			u107.chargeSound = nil
		end

		sound:Play("KillEffects.Damnation.Launch", u107.core)
	end

	local v114 = task.delay
	local v115 = math.max(n6, 0)

	v114(v115, function()
		if u50 then
			v113()
		end
	end)

	local v116 = os.clock()
	local t9: {[any]: any} = {}
	local t10: {[any]: any} = {}

	connection2 = runService.Heartbeat:Connect(function()
		if not u50 then
			return
		end

		local n9 = os.clock() - v116
		local v201 = math.clamp((n9 - t2.OrbAppear) / n4, 0, 1)

		if not u51 then
			for _, v in pairs(t5) do
				local v204 = math.clamp((n9 - (v.start or n7)) / t2.HoistTime, 0, 1)

				if v204 > 0 then
					local v205 = v.from:Lerp(v.to, (v204 - 1) ^ 3 * 2.70158 + 1 + (v204 - 1) ^ 2 * 1.70158)

					if v204 >= 1 and v201 > 0 then
						local n2 = t2.Tremble * v201
						local cFrameNew = CFrame.new
						local v208 = math.noise(n9 * 23, v.seed)
						local v209 = math.noise(n9 * 19, v.seed + 7)
						local v210 = math.noise(n9 * 21, v.seed + 13)
						local v211 = cFrameNew(v208 * n2, v209 * n2, v210 * n2)

						v205 *= v211
					end

					v.part.CFrame = v205
				end
			end
		end

		table.clear(t9)
		table.clear(t10)

		for _, v in ipairs(t7) do
			if not v.broken and n9 >= v.fire and v.limb.part.Parent then
				local v214 = (v.limb.part.CFrame * cFrame).Position

				if n9 < v.latch then
					local n10 = (n9 - v.fire) / t2.ChainTravel

					v214 = v.riftPos:Lerp(v214, 1 - (1 - n10) * (1 - n10))
				end

				local magnitude = (v.riftPos - v214).Magnitude

				if magnitude > 0.05 then
					local v217 = CFrame.lookAt(v214, v.riftPos)
					local n11: number = #v.links
					local floored = math.floor(magnitude / t2.LinkPitch)
					local v220 = math.min(n11, floored)

					for i, iterValue in ipairs(v.links) do
						if v220 >= i then
							if i > v.shown then
								iterValue.Transparency = 0
							end

							local n12 = if v201 > 0 then math.sin(n9 * 60 + i * 1.7) * 0.035 * v201 else 0

							table.insert(t9, iterValue)

							local cFrame3 = CFrame.new(n12, 0, -(i - 0.5) * t2.LinkPitch)

							table.insert(t10, v217 * cFrame3 * (if i % 2 == 0 then v16 else n1))
						elseif i <= v.shown then
							iterValue.Transparency = 1
						end
					end

					v.shown = v220
				end
			end
		end

		if #t9 > 0 then
			workspace:BulkMoveTo(t9, t10, Enum.BulkMoveMode.FireCFrameChanged)
		end

		if u107 and not u107.done then
			local n13

			if n9 < n5 then
				local sine = math.sin(v201 * v201 * 55)

				n13 = (t2.OrbStartSize + (t2.OrbEndSize - t2.OrbStartSize) * v201 ^ 2.2) * (v201 * 0.06 * sine + 1)
			elseif n9 < n6 then
				local n14 = (n9 - n5) / t2.PinchTime

				n13 = t2.OrbEndSize * (if n14 < 0.4 then 1 + 0.2 * (n14 / 0.4) else 1.2 - 0.55 * ((n14 - 0.4) / 0.6))
			else
				n13 = t2.OrbEndSize * 0.65

				local v228 = u107
				local v229 = math.clamp((n9 - n6) / t2.DashTime, 0, 1)

				v228.pos = n3:Lerp(vector32, v229 * v229)
			end

			local cFrame4 = CFrame.new(u107.pos)

			u107.core.Size = Vector3.new(1, 1, 1) * n13
			u107.shell.Size = Vector3.new(1, 1, 1) * n13 * 1.35

			local shell = u107.shell
			local gather = u107.gather

			u107.core.CFrame = cFrame4
			shell.CFrame = cFrame4
			gather.CFrame = cFrame4

			local n8 = v201 ^ 2.2

			u107.light.Brightness = t2.OrbLight.Brightness * n8
			u107.light.Range = 6 + (t2.OrbLight.Range - 6) * n8

			if u107.chargeSound then
				u107.chargeSound.PlaybackSpeed = v201 * 1.3 + 0.7
			end
		end
	end)

	local v119 = task.delay
	local v120 = math.max(t2.HitTime - t2.ReleaseLead, 0)

	v119(v120, function()
		if u50 then
			release()
		end
	end)

	local function v121()
		if not u51 then
			u51 = true

			for _, v in pairs(t5) do
				if v.part.Parent then
					v.part.Anchored = false
				end
			end
		end

		if u107 then
			u107.done = true
			u107.core.Transparency = 1
			u107.shell.Transparency = 1
			u107.light.Brightness = 0
			stopEmitters(u107.folder)
			debris:AddItem(u107.folder, 1)
		end

		for _, v in ipairs(t7) do
			v.broken = true

			local v238 = if v.limb.part.Parent then (v.limb.part.CFrame * cFrame).Position else vector32

			for _, iterValue in ipairs(v.beams) do
				iterValue:Destroy()
			end

			if v.cuff then
				v.cuff:Destroy()
			end

			for i, iterValue2 in ipairs(v.links) do
				if i <= v.shown and math.random() < t2.DebrisChance then
					local n1 = iterValue2.Position - vector32

					n1 = if n1.Magnitude > 0.1 then n1.Unit else Vector3.new(0, 1, 0)
					iterValue2.Anchored = false

					local randomNumber = math.random(25, 60)
					local randomNumber2 = math.random(10, 35)
					local vector34 = Vector3.new(0, randomNumber2, 0)

					iterValue2.AssemblyLinearVelocity = n1 * randomNumber + vector34

					local randomNumber3 = math.random(-30, 30)
					local randomNumber4 = math.random(-30, 30)

					iterValue2.AssemblyAngularVelocity = Vector3.new(randomNumber3, randomNumber4, math.random(-30, 30))

					local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.5)

					tweenService:Create(iterValue2, tweenInfo, { Transparency = 1 }):Play()
					debris:AddItem(iterValue2, 1.1)
				else
					iterValue2:Destroy()
				end
			end

			for _, iterValue3 in ipairs({ 0.15, 0.5, 0.85 }) do
				local clone2 = mesh.Chain.Break:Clone()

				clone2.CFrame = CFrame.new(v238:Lerp(v.riftPos, iterValue3))
				clone2.Parent = _fx_Damnation

				local ok, result = pcall(forgeVFX.emit, clone2)

				if not ok then
					local cloneName = clone2.Name
					local text: string = tostring(result)

					warn("[Damnation] emit failed on " .. cloneName .. ": " .. text)
				end

				debris:AddItem(clone2, 1.5)
			end

			stopEmitters(v.rift.Rift)

			local close = v.rift.Close
			local ok6, result6 = pcall(forgeVFX.emit, close)

			if not ok6 then
				local closeName = close.Name
				local text: string = tostring(result6)

				warn("[Damnation] emit failed on " .. closeName .. ": " .. text)
			end

			debris:AddItem(v.rift, 1.5)
		end

		local clone6 = mesh.Explosion:Clone()

		clone6.CFrame = CFrame.new(vector32)
		clone6.Parent = _fx_Damnation

		local ok7, result7 = pcall(forgeVFX.emit, clone6)

		if not ok7 then
			local clone6Name = clone6.Name
			local text: string = tostring(result7)

			warn("[Damnation] emit failed on " .. clone6Name .. ": " .. text)
		end

		flashLight(clone6.Light, t2.Flash)
		sound:Play("KillEffects.Damnation.Explode", clone6)
		sound:Play("KillEffects.Damnation.ExplodeFire", clone6)

		if clone then
			stopEmitters(clone)

			local cloneBurst = clone.Burst
			local ok8, result8 = pcall(forgeVFX.emit, cloneBurst)

			if not ok8 then
				local cloneBurstName = cloneBurst.Name
				local text: string = tostring(result8)

				warn("[Damnation] emit failed on " .. cloneBurstName .. ": " .. text)
			end

			local cloneRadial = clone.Radial
			local ok9, result9 = pcall(forgeVFX.emit, cloneRadial)

			if not ok9 then
				local cloneRadialName = cloneRadial.Name
				local text: string = tostring(result9)

				warn("[Damnation] emit failed on " .. cloneRadialName .. ": " .. text)
			end
		end

		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and (CurrentCamera.CFrame.Position - vector32).Magnitude < t2.ShakeDistance then
			_GSharedCamShaker:Shake("Explosion")
		end

		for _, v in pairs(t5) do
			if v.part.Parent then
				for _, iterValue4 in ipairs(mesh.LimbTrail:GetChildren()) do
					local clone7 = iterValue4:Clone()

					table.insert(t4, clone7)
					clone7.Parent = v.part

					local ok10, result10 = pcall(forgeVFX.emit, clone7)

					if not ok10 then
						local clone7Name = clone7.Name
						local text: string = tostring(result10)

						warn("[Damnation] emit failed on " .. clone7Name .. ": " .. text)
					end

					debris:AddItem(clone7, t2.LimbTrailTime)
				end
			end
		end
	end

	local v122 = task.delay
	local v123 = math.max(t2.HitTime, 0)

	v122(v123, function()
		if u50 then
			v121()
		end
	end)
end
