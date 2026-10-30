-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local replayFormat = require(shared:WaitForChild("ReplayFormat"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(replicatedStorageShared:WaitForChild("WeaponRigUtil"))
local v7: Instance = replicatedStorage:WaitForChild("Shared")
local ragdoll = require(v7:WaitForChild("Ragdoll"))
local v9: Instance = replicatedStorage:WaitForChild("Shared")
local finisherVelocity = require(v9:WaitForChild("FinisherVelocity"))
local t1: {[any]: any} = {}

local function fetchDescription(p2)
	if p2 <= 0 then
		return nil
	end

	if t1[p2] then
		return t1[p2]
	end

	local ok, result = pcall(function()
		return players:GetHumanoidDescriptionFromUserId(p2)
	end)

	if ok and result then
		t1[p2] = result

		return result
	end

	return nil
end
local function fallbackRig()
	local dummy: Instance = replicatedStorage:FindFirstChild("Dummy")

	return dummy and dummy:Clone() or nil
end
local function neutralise(character)
	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = v.Name == "HumanoidRootPart"
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
		elseif v:IsA("LuaSourceContainer") then
			v:Destroy()
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		humanoid.EvaluateStateMachine = false
		humanoid.BreakJointsOnDeath = false
		humanoid.RequiresNeck = false
	end
end

local module: {[any]: any} = {
	MATCH_ID = "__REPLAY__",
	SyntheticId = function(p1)
		return -900000 - p1
	end,
	AttachWeapon = function(p4, p5, p6)
		if p6 == "" then
			return nil
		end

		local foundChild = p4:FindFirstChild(if p5 == "Revolver" then "Left Arm" else "Right Arm")

		if not foundChild then
			return nil
		end

		local ok, result = pcall(function()
			if p5 == "Revolver" then
				return (weaponRigUtil.ApplyRevolverSkin(p4, p6, foundChild, "Gun_HandAttach"))
			end

			return (weaponRigUtil.ApplyKnifeSkin(p4, p6, foundChild, "Knife_HandAttach"))
		end)

		if ok and result then
			pcall(function()
				weaponRigUtil.EnsureNoCollide(result)
			end)

			for _, v in ipairs(result:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanQuery = false
					v.CanTouch = false
					v.Massless = true
				end
			end

			return result
		end

		return nil
	end
}

local function publishWeaponAttributes(p7, p8)
	p7:SetAttribute("BotMatchBot", true)
	p7:SetAttribute("KnifeSkin", p8.knifeId ~= "" and p8.knifeId or "Default")
	p7:SetAttribute("RevolverSkin", p8.revolverId ~= "" and p8.revolverId or "Default")
	p7:SetAttribute("KnifeIcon", p8.knifeIcon)
	p7:SetAttribute("KnifeRarity", p8.knifeRarity)
	p7:SetAttribute("RevolverIcon", p8.revolverIcon)
	p7:SetAttribute("RevolverRarity", p8.revolverRarity)
	p7:SetAttribute("EnableKnifeRig", false)
	p7:SetAttribute("EnableRevolverRig", false)
	p7:SetAttribute("MatchId", module.MATCH_ID)
	p7:SetAttribute("InMatch", true)
end
function module.Build(p9, parent)
	local v48 = nil
	local userId = p9.userId
	local v51

	if userId <= 0 then
		v51 = nil
	elseif t1[userId] then
		v51 = t1[userId]
	else
		local ok, result = pcall(function()
			return players:GetHumanoidDescriptionFromUserId(userId)
		end)

		if ok and result then
			t1[userId] = result
			v51 = result
		else
			v51 = nil
		end
	end

	if v51 then
		local ok, result = pcall(function()
			return players:CreateHumanoidModelFromDescription(v51, Enum.HumanoidRigType.R6)
		end)

		if ok and result then
			v48 = result
		end
	end

	if not v48 then
		local dummy: Instance = replicatedStorage:FindFirstChild("Dummy")

		v48 = dummy and dummy:Clone() or nil
	end

	if not v48 then
		return nil
	end

	neutralise(v48)
	v48.Name = "ReplayActor_" .. tostring(p9.slot)
	v48:SetAttribute("BotUserId", module.SyntheticId(p9.slot))
	v48:SetAttribute("ReplayActor", true)
	v48:SetAttribute("ReplaySlot", p9.slot)
	v48:SetAttribute("MatchSide", if p9.side == 0 then "A" else "B")
	publishWeaponAttributes(v48, p9)

	local humanoidRootPart = v48:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		v48.PrimaryPart = humanoidRootPart
	end

	local torso = v48:FindFirstChild("Torso")
	local t5: {[any]: any} = {}

	if torso then
		for _, v in ipairs(torso:GetChildren()) do
			if v:IsA("Motor6D") then
				t5[v.Name] = { motor = v, c0 = v.C0 }
			end
		end
	end

	local t6: {[any]: any} = {}
	local t7: {[any]: any} = {}

	for _, v in ipairs(v48:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(t6, v)
			t7[v] = v.Transparency
		end
	end

	if humanoidRootPart and not humanoidRootPart:FindFirstChild("Running") then
		local running: Sound = Instance.new("Sound")

		running.Name = "Running"
		running.Volume = 0
		running.Looped = true
		running.Parent = humanoidRootPart
		running:Play()
	end

	v48.Parent = parent

	local head = v48:FindFirstChild("Head")
	local slot = p9.slot
	local side = p9.side
	local displayName = p9.displayName
	local v71 = module.SyntheticId(p9.slot)

	return {
		knifeModel = nil,
		released = false,
		lastPos = nil,
		phase = 0,
		currentWeapon = -1,
		hidden = false,
		model = v48,
		root = humanoidRootPart,
		torso = torso,
		head = head,
		joints = t5,
		slot = slot,
		side = side,
		name = displayName,
		synthId = v71,
		knifeId = p9.knifeId,
		revolverId = p9.revolverId,
		baseTransparency = t7,
		parts = t6,
		isBot = bit32.band(p9.pflags or 0, 1) ~= 0
	}
end
function module.SetWeapon(p11, p12)
	if p12 == p11.currentWeapon then
		return
	end

	p11.currentWeapon = p12
	p11.model:SetAttribute("EnableKnifeRig", p12 == replayFormat.WEAPON_KNIFE)
	p11.model:SetAttribute("EnableRevolverRig", p12 == replayFormat.WEAPON_REVOLVER)
end
function module.Destroy(p13)
	if p13 and p13.model then
		pcall(function()
			p13.model:Destroy()
		end)
	end
end

local t3: {[any]: any} = { "KnifeRig", "KnifeRig_L", "KnifeRig_R", "RevolverRig" }

local function mirrorTracksFor(p14, p15)
	local model = p14.model

	if model and p15 ~= "" then
		p14.rigTrackCache = p14.rigTrackCache or {}

		for iterKey in pairs(p14.rigTrackCache) do
			if not iterKey.Parent then
				p14.rigTrackCache[iterKey] = nil
			end
		end

		local t8: {[any]: any} = {}

		for _, v in ipairs(t3) do
			local v = model:FindFirstChild(v)
			local animationController = v and v:FindFirstChildWhichIsA("AnimationController")
			local v84 = animationController

			if v84 then
				v84 = animationController:FindFirstChildWhichIsA("Animator")
			end

			if v84 then
				local t9 = p14.rigTrackCache[v84]

				if not t9 then
					t9 = {}
					p14.rigTrackCache[v84] = t9
				end

				local v86 = t9[p15]

				if not v86 then
					local ok, result = pcall(function()
						local animation: Animation = Instance.new("Animation")

						animation.AnimationId = p15

						return v84:LoadAnimation(animation)
					end)

					if ok and result then
						v86 = result
						t9[p15] = v86
					end
				end

				if v86 then
					table.insert(t8, v86)
				end
			end
		end

		return t8
	end

	return {}
end
local function allMirrorTracks(p16)
	local t10: {[any]: any} = {}

	if not p16.rigTrackCache then
		return t10
	end

	for k, v in pairs(p16.rigTrackCache) do
		if k.Parent then
			for _, iterValue in pairs(v) do
				table.insert(t10, iterValue)
			end
		end
	end

	return t10
end
local function startMirrors(p17, p18, p19, p20, p21, p22)
	local v101 = mirrorTracksFor(p17, p18)

	for _, v in ipairs(v101) do
		pcall(function()
			v.Looped = p19

			if p20 then
				for _, iterValue in ipairs(Enum.AnimationPriority:GetEnumItems()) do
					if iterValue.Value == p20 then
						v.Priority = iterValue

						break
					end
				end
			end

			v:Play(0.1)
			v:AdjustSpeed(p21 * (p17.timeScale or 1))

			if p22 and p22 > 0 then
				v.TimePosition = p22
			end
		end)
	end
end
local function syncRigMirrors(p23)
	local model = p23.model

	if not model then
		return
	end

	local t11: {[any]: any} = {}
	local u107: boolean = false
	local lastRigAnimators = p23.lastRigAnimators

	for _, v in ipairs(t3) do
		local v2 = model:FindFirstChild(v)
		local animationController = v2 and v2:FindFirstChildWhichIsA("AnimationController")
		local v113 = animationController

		if v113 then
			v113 = animationController:FindFirstChildWhichIsA("Animator")
		end

		t11[v] = v113

		if not lastRigAnimators or v113 ~= lastRigAnimators[v] then
			u107 = true
		end
	end

	if not u107 then
		return
	end

	p23.lastRigAnimators = t11
	p23.rigTrackCache = nil

	if not p23.tracks then
		return
	end

	for k, v in pairs(p23.tracks) do
		local u116 = true
		local n1 = 0

		pcall(function()
			u116 = v.Looped
			n1 = v.TimePosition
		end)
		startMirrors(p23, k, u116, nil, p23.trackSpeeds and p23.trackSpeeds[k] or 1, n1)
	end
end
local function animatorOf(p24)
	if p24.animator and p24.animator.Parent then
		return p24.animator
	end

	local parent = p24.model and p24.model:FindFirstChildOfClass("Humanoid")

	if not parent then
		return nil
	end

	local animator = parent:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = parent
	end

	p24.animator = animator

	return animator
end
function module.PlayAnim(p25, p26, p27, p28, p29, p30)
	if p25 and p26 ~= "" then
		local animator = p25.animator
		local v128 = animatorOf(p25)

		if not v128 then
			return
		end

		if animator and animator ~= v128 then
			p25.trackCache = nil
			p25.tracks = nil
			p25.trackSpeeds = nil
		end

		p25.tracks = p25.tracks or {}
		p25.trackCache = p25.trackCache or {}

		local u129 = p25.trackCache[p26]

		if u129 and p25.tracks[p26] then
			local u130 = false

			pcall(function()
				u130 = u129.IsPlaying
			end)
		elseif not u129 then
			u130 = pcall

			local v131, v132 = u130(function()
				local animation: Animation = Instance.new("Animation")

				animation.AnimationId = p26

				return v128:LoadAnimation(animation)
			end)

			if not v131 or not v132 then
				return
			end

			u129 = v132
			p25.trackCache[p26] = u129
		end

		p25.tracks[p26] = u129
		p25.trackSpeeds = p25.trackSpeeds or {}

		local v133 = p27 ~= 0 and p27 or 1

		p25.trackSpeeds[p26] = v133
		pcall(function()
			u129.Looped = p29 ~= false

			if p30 then
				for _, v in ipairs(Enum.AnimationPriority:GetEnumItems()) do
					if v.Value == p30 then
						u129.Priority = v

						break
					end
				end
			end

			u129:Play(0.1)
			u129:AdjustSpeed(v133 * (p25.timeScale or 1))

			if p28 and p28 > 0 then
				u129.TimePosition = p28
			end
		end)
		startMirrors(p25, p26, p29 ~= false, p30, v133, p28)

		return
	end
end
function module.SetTimeScale(p31, p32)
	if not p31 then
	elseif typeof(p32) == "number" and p32 == p32 then
		local u136 = math.max(p32, 0)

		if p31.timeScale and math.abs(p31.timeScale - u136) < 0.001 then
			return
		end

		p31.timeScale = u136

		if not p31.tracks then
			return
		end

		for k, v in pairs(p31.tracks) do
			local v139 = p31.trackSpeeds and p31.trackSpeeds[k] or 1

			pcall(function()
				v:AdjustSpeed(v139 * u136)
			end)

			local v140 = mirrorTracksFor(p31, k)

			for _, iterValue in ipairs(v140) do
				pcall(function()
					iterValue:AdjustSpeed(v139 * u136)
				end)
			end
		end

		return
	end
end
function module.StopAnim(p33, p34)
	if not p33 or not p33.tracks then
		return
	end

	local v145 = p33.tracks[p34]

	if not v145 then
		return
	end

	p33.tracks[p34] = nil

	if p33.trackSpeeds then
		p33.trackSpeeds[p34] = nil
	end

	pcall(function()
		v145:Stop(0.1)
	end)

	local v146 = mirrorTracksFor(p33, p34)

	for _, v in ipairs(v146) do
		pcall(function()
			v:Stop(0.1)
		end)
	end
end
function module.StopAllAnims(p35)
	if not p35 or not p35.tracks then
		return
	end

	for k, v in pairs(p35.tracks) do
		pcall(function()
			v:Stop(0)
		end)
		p35.tracks[k] = nil
	end

	p35.trackSpeeds = {}

	local v152 = allMirrorTracks(p35)

	for _, v in ipairs(v152) do
		pcall(function()
			v:Stop(0)
		end)
	end
end
local function setHidden(p36, p37)
	if p37 == p36.hidden then
		return
	end

	p36.hidden = p37

	for _, v in ipairs(p36.parts) do
		if v.Parent then
			v.Transparency = if p37 then 1 else p36.baseTransparency[v] or 0
		end
	end
end
function module.SetFirstPersonHidden(p38, p39)
	if p38 and p39 ~= p38.fpHidden then
		p38.fpHidden = p39

		for _, v in ipairs(p38.parts) do
			if v.Parent then
				local u163: boolean = true

				if v.Name ~= "Left Arm" then
					u163 = v.Name == "Right Arm"
				end

				v.LocalTransparencyModifier = if p39 and not u163 then 1 else 0
			end
		end

		return
	end
end

module.SetHidden = setHidden

local function clearRagdoll(p40)
	if not p40 or not p40.model then
		return
	end

	p40.released = false
	p40.deathDir = nil

	for _, v in ipairs(p40.model:GetDescendants()) do
		if not v:IsA("BallSocketConstraint") and not v:IsA("NoCollisionConstraint") then
			if v:IsA("Attachment") and v.Name:sub(1, 7) == "TorsoTo" then
				pcall(function()
					v:Destroy()
				end)
			elseif v:IsA("Motor6D") then
				v.Enabled = true
			end
		else
			pcall(function()
				v:Destroy()
			end)
		end
	end

	for _, v in ipairs(p40.parts) do
		if v.Parent then
			for _, iterValue in ipairs(v:GetChildren()) do
				if iterValue:IsA("WeldConstraint") then
					pcall(function()
						iterValue:Destroy()
					end)
				end
			end
		end
	end

	if p40.joints then
		for _, v in pairs(p40.joints) do
			if v.motor and v.motor.Parent then
				v.motor.Enabled = true
				v.motor.C0 = v.c0
			end
		end
	end

	p40.swingApplied = false

	local humanoid = p40.model:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.EvaluateStateMachine = false
		humanoid.BreakJointsOnDeath = false
		humanoid.AutoRotate = true
		pcall(function()
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end

	for _, v in ipairs(p40.parts) do
		if v.Parent then
			v.Anchored = v.Name == "HumanoidRootPart"
			v.Massless = true
			v.CanCollide = false
			v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end

module.ClearRagdoll = clearRagdoll

local function rebuildWeaponRigs(p41)
	if not p41 or not p41.model or not p41.rigsDirty then
		return
	end

	p41.rigsDirty = nil

	for _, v in ipairs(t3) do
		local v = p41.model:FindFirstChild(v)

		if v then
			pcall(function()
				v:Destroy()
			end)
		end
	end

	pcall(function()
		p41.model:SetAttribute("EnableKnifeRig", nil)
		p41.model:SetAttribute("EnableRevolverRig", nil)
	end)
	p41.currentWeapon = -1
end

local parkour_names: {[any]: any} = {
	[replayFormat.STATE_CROUCHING] = "Crouching",
	[replayFormat.STATE_SLIDING] = "Sliding"
}

module.PARKOUR_NAMES = parkour_names

function module.Apply(p42, p43, p44, p45)
	if not p42 or not p42.root then
		return
	end

	syncRigMirrors(p42)

	local v184 = bit32.band(p43.sflags, replayFormat.S_ALIVE)
	local vector3 = Vector3.new(p43.x, p43.y, p43.z)
	local n1 = p44 + vector3
	local vectorValue

	if v184 == 0 then
		if not p42.released then
			p42.released = true
			p42.rigsDirty = true

			local humanoid = p42.model:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.EvaluateStateMachine = true
				humanoid.BreakJointsOnDeath = false
			end

			for _, v in ipairs(p42.parts) do
				if v.Parent then
					v.Anchored = false
					v.Massless = false
					v.CanCollide = v.Name ~= "HumanoidRootPart"
				end
			end

			if not p42.model:FindFirstChild("TorsoToHead0", true) then
				if p42.deathDir and p42.deathDir.Magnitude > 0.01 then
					local ok, result = pcall(function()
						return finisherVelocity.Get("", p42.deathDir.Unit)
					end)

					vectorValue = ok and typeof(result) == "Vector3" and result or p42.deathDir.Unit * 70
				elseif p42.lastPos and p45 > 0 then
					vectorValue = (n1 - p42.lastPos) / p45
				else
					vectorValue = Vector3.new(0, 0, 0)
				end

				pcall(ragdoll, p42.model, vectorValue)

				if p42.root then
					pcall(function()
						p42.root.AssemblyLinearVelocity = vectorValue
					end)
				end
			end
		end

		p42.lastPos = n1

		return
	end

	if p42.released then
		local roundResetPending = p42.roundResetPending

		p42.roundResetPending = nil

		if roundResetPending then
			vectorValue = p42
			module.ResetForRound(vectorValue)
		else
			vectorValue = p42
			clearRagdoll(vectorValue)
		end

		vectorValue = p42
		rebuildWeaponRigs(vectorValue)
	end

	vectorValue = bit32.band
	vectorValue = vectorValue(p43.sflags, replayFormat.S_WEAPON_MASK)

	local v194 = bit32.rshift(vectorValue, replayFormat.S_WEAPON_SHIFT)

	vectorValue = module
	vectorValue = vectorValue.SetWeapon
	vectorValue(p42, v194)

	local cFrame = CFrame.new(n1)
	local v196 = CFrame.fromEulerAnglesYXZ(p43.bodyPitch or 0, p43.camYaw, p43.bodyRoll or 0)

	vectorValue = cFrame * v196
	p42.root.CFrame = vectorValue
	vectorValue = 0

	if p42.lastPos and p45 > 0 then
		local n3 = n1 - p42.lastPos

		vectorValue = Vector3.new(n3.X, 0, n3.Z).Magnitude / p45
	end

	p42.lastPos = n1

	if p42.root then
		local root = p42.root
		local n4 = n1 - (p42.prevPos or n1)
		local v200 = math.max(p45, 0.004166666666666667)

		root.AssemblyLinearVelocity = n4 / v200
		p42.prevPos = n1
	end

	n1 = parkour_names[p43.state]

	if p42.lastParkour ~= n1 then
		p42.lastParkour = n1
		p42.model:SetAttribute("ParkourState", n1)
	end

	n1 = math.clamp(vectorValue / 24, 0, 1)
	vectorValue = false

	if p42.tracks ~= nil then
		vectorValue = next(p42.tracks) ~= nil
	end

	if vectorValue then
		if p42.swingApplied then
			p42.swingApplied = false

			for _, v in pairs(p42.joints) do
				v.motor.C0 = v.c0
			end
		end

		return
	end

	p42.swingApplied = true
	vectorValue = n1 * 0.9
	p42.phase = p42.phase + p45 * 1.6 * 3.141592653589793 * 2 * (n1 + 0.4)
	n1 = math.sin(p42.phase) * vectorValue
	vectorValue = function(p46, p47)
		local v236 = p42.joints[p46]

		if v236 then
			local motor = v236.motor
			local c0 = v236.c0
			local v239 = CFrame.Angles(p47, 0, 0)

			motor.C0 = c0 * v239
		end
	end

	local v203 = p42.joints["Right Hip"]

	if v203 then
		local motor = v203.motor
		local c0 = v203.c0
		local v206 = CFrame.Angles(n1, 0, 0)

		motor.C0 = c0 * v206
	end

	v196 = p42.joints["Left Hip"]

	if v196 then
		local v207 = v196.motor
		local v208 = v196.c0
		local v209 = CFrame.Angles(-n1, 0, 0)

		v207.C0 = v208 * v209
	end

	v203 = math.clamp(p43.pitch, -1.2, 1.2)

	if v194 ~= replayFormat.WEAPON_NONE then
		local v210 = p42.joints["Right Shoulder"]

		if v210 then
			local v211 = v210.motor
			local v212 = v210.c0
			local v213 = CFrame.Angles(-1.5707963267948966 - v203, 0, 0)

			v211.C0 = v212 * v213
		end

		v210 = p42.joints["Left Shoulder"]

		if v210 then
			local v214 = v210.motor
			local v215 = v210.c0
			local v216 = CFrame.Angles(-n1 * 0.5, 0, 0)

			v214.C0 = v215 * v216

			return
		end
	else
		local v217 = p42.joints["Right Shoulder"]

		if v217 then
			local v218 = v217.motor
			local v219 = v217.c0
			local v220 = CFrame.Angles(-n1, 0, 0)

			v218.C0 = v219 * v220
		end

		local v221 = p42.joints["Left Shoulder"]

		if v221 then
			local v222 = v221.motor
			local v223 = v221.c0
			local v224 = CFrame.Angles(n1, 0, 0)

			v222.C0 = v223 * v224
		end
	end
end
function module.ResetForSeek(p48)
	if not p48 or not p48.model then
		return
	end

	module.StopAllAnims(p48)
	p48.deathDir = nil
	p48.lastParkour = nil
	p48.currentWeapon = nil
	clearRagdoll(p48)
	p48.roundResetPending = nil
	p48.hidden = nil
	setHidden(p48, false)
end
function module.ResetForRound(p49)
	if not p49 or not p49.model then
		return
	end

	module.StopAllAnims(p49)
	clearRagdoll(p49)
	rebuildWeaponRigs(p49)
	p49.roundResetPending = nil
	p49.lastPos = nil
	p49.prevPos = nil
	p49.phase = 0
	p49.lastParkour = nil
	p49.model:SetAttribute("ParkourState", nil)
	p49.currentWeapon = -1
	p49.hidden = nil
	setHidden(p49, false)
end
function module.MarkRoundBoundary(p50)
	if not p50 or not p50.model then
		return
	end

	if p50.released then
		p50.roundResetPending = true

		return
	end

	module.ResetForRound(p50)
end

return module
