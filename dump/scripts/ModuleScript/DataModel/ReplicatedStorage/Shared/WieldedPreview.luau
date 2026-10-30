-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(shared:WaitForChild("WeaponRigUtil"))
local inspectFX = require(shared:WaitForChild("InspectFX"))
local weaponOffhand = require(shared:WaitForChild("WeaponOffhand"))
local heldVariants = require(shared:WaitForChild("HeldVariants"))
local u10 = nil
local viewmodelArms = require(shared:WaitForChild("ViewmodelArms"))
local bulletTracer = require(shared:WaitForChild("BulletTracer"))
local playerState = require(shared:WaitForChild("PlayerState"))
local fovController = require(shared:WaitForChild("FOVController"))
local crosshair = require(shared:WaitForChild("Crosshair"))
local adsWeaponFX = require(shared:WaitForChild("AdsWeaponFX"))
local revolverTiming = require(shared:WaitForChild("RevolverTiming"))
local knifeTiming = require(shared:WaitForChild("KnifeTiming"))
local fixedEffects = require(shared:WaitForChild("FixedEffects"))
local anims = require(replicatedStorage:WaitForChild("Anims"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local effect = require(replicatedStorage:WaitForChild("Effect"))
local spawnKnife: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("SpawnKnife")
local LocalPlayer: Player = players.LocalPlayer
local n1 = Enum.RenderPriority.Camera.Value + 2

local function hasController()
	return userInputService.GamepadEnabled
end

local t1: {[any]: any} = { "KnifeRig", "KnifeRig_L", "KnifeRig_R", "RevolverRig" }
local t2: {[any]: any} = {
	"Knife_HandAttach",
	"Knife_HandAttach_L",
	"Knife_HandAttach_R",
	"Revolver_HandAttach",
	"Knife_HipAttach_R",
	"Revolver_HipAttach_L"
}
local u29 = nil
local u30 = nil
local u31 = nil
local u32 = nil
local u33 = nil
local u34 = nil
local u35 = nil
local u36 = nil
local u37 = nil
local t3: {[any]: any} = {}
local u39 = false
local u40 = false
local n2 = 0
local n3 = 1
local n4 = 0
local n5 = 0
local n6 = 0
local u46: boolean = false
local n7 = 0
local n8: number = 0
local u49: boolean = false
local u50 = nil
local u51 = nil
local connection = nil
local u53 = nil
local u54 = nil
local n9: number = 0
local n10: number = 0
local u57 = nil
local u58: boolean = false
local n11 = 0
local u60 = nil
local u61 = nil
local u62 = nil
local n12 = 0
local n13: number = 0
local u65: boolean = false
local u66: boolean = false

local function sourceBody()
	local Character: Model = LocalPlayer.Character

	if Character and Character:FindFirstChild("Right Arm") and Character:FindFirstChild("Left Arm") and Character:FindFirstChild("Torso") and Character.Archivable then
		local ok, result = pcall(function()
			return Character:Clone()
		end)

		if ok and result then
			return result
		end
	end

	local dummy: Instance = replicatedStorage:FindFirstChild("Dummy")

	if dummy and dummy:IsA("Model") then
		return dummy:Clone()
	end

	return nil
end
local function prepareBody(character)
	for _, v in ipairs(t1) do
		local v = character:FindFirstChild(v)

		if v then
			v:Destroy()
		end
	end

	for _, v in ipairs(t2) do
		weaponRigUtil.DetachMotor(character, v)
	end

	weaponOffhand.Detach(character)

	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("Tool") or v:IsA("Accessory") or v:IsA("LuaSourceContainer") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ForceField") then
			v:Destroy()
		end
	end

	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = v.Name == "HumanoidRootPart"
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
			v.CastShadow = false

			if v.Name ~= "Left Arm" and v.Name ~= "Right Arm" then
				v.Transparency = 1
			end
		elseif (v:IsA("Decal") or v:IsA("Texture")) and v.Parent and v.Parent.Name ~= "Left Arm" and v.Parent.Name ~= "Right Arm" then
			v.Transparency = 1
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.EvaluateStateMachine = false
		humanoid.BreakJointsOnDeath = false
		humanoid.RequiresNeck = false
		humanoid.AutoRotate = false
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	end
end
local function placeBody(p2, p3)
	local humanoidRootPart = p2:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return
	end

	local v111, v112, v113 = p3:ToEulerAnglesYXZ()
	local cFrame = CFrame.new(p3.Position - Vector3.new(0, 1.6, 0))
	local v115 = CFrame.Angles(0, v112, 0)

	humanoidRootPart.CFrame = cFrame * v115
end
local function playEquipEffect(p4)
	local v117 = u30
	local v118 = u32

	if not v117 or not v117.Parent then
		return
	end

	local text: string = tostring(u33)
	local text2: string = tostring(u34)
	local v121 = ("EquipEffects.%s.%s"):format(text, text2)

	if not effect.find(v121) then
		return
	end

	local ok, result = pcall(function()
		if u33 == "Revolver" then
			local primaryPart = v117.PrimaryPart

			if not primaryPart then
				return
			end

			local v240 = primaryPart:QueryDescendants("MeshPart#Revolver")[1] or primaryPart

			effect.new(v121):replicate({
				Model = v117,
				Revolver = v240,
				Position = v118 and v118.Position or v240.Position,
				Root = v118,
				Toggle = p4
			})

			return
		end

		local boundingBox = v117:FindFirstChild("BoundingBox")
		local v242 = v117:QueryDescendants("MeshPart#Blade")[1]

		if v242 then
			boundingBox = v242
		end

		if not boundingBox then
			return
		end

		effect.new(v121):replicate({
			Model = v117,
			Knife = boundingBox,
			Position = v118 and v118.Position or boundingBox.Position,
			Root = v118,
			Toggle = p4
		})
	end)

	if not ok then
		warn("[WieldedPreview] Equip effect failed:", v121, result)
	end
end
local function playShotVFX()
	local v124 = u30
	local v125 = u29
	local CurrentCamera: Camera = workspace.CurrentCamera

	if v124 and v125 and CurrentCamera then
		local foundChild = v124:FindFirstChild("RevolverMuzzle", true)
		local v128

		if foundChild and foundChild:IsA("Attachment") then
			v128 = foundChild.WorldPosition
		else
			local v129 = u31

			if not v129 then
				return
			end

			v128 = v129.rightArm.Position
		end

		local n1 = CurrentCamera.CFrame.LookVector * 300
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true
		raycastParams.FilterDescendantsInstances = { workspace.Bin, workspace.Characters }

		local v132 = workspace:Raycast(v128, n1, raycastParams)
		local v133 = v132 and v132.Position or v128 + n1

		n1 = fixedEffects.For(fixedEffects.REVOLVER, u34)
		bulletTracer.Fire(v128, v133, n1, v125)

		if v132 then
			bulletTracer.WallHit(v132.Instance, v132.Position, v132.Normal, n1)
		end

		return
	end
end
local function animCategory()
	if u33 == "Revolver" then
		return "Revolvers"
	end

	return "Knives"
end
local function resolveTrack(p5)
	if not u35 then
		return nil
	end

	local s1: string = if u33 == "Revolver" then "Revolvers" else "Knives"
	local v136 = u35
	local text: string = tostring(u34)
	local v138 = v136:Get(("%s.%s.%s"):format(s1, text, p5))

	if not v138 then
		v138 = u35:Get(("%s.Default.%s"):format(s1, p5))
	end

	return v138
end
local function playPreviewSound(p6, p7)
	local v141 = u32

	if not v141 or not v141.Parent then
		return nil
	end

	local s1: string = if u33 == "Revolver" then "Revolver" else "Knife"

	if u33 == "Revolver" and p6 == "Reload" then
		local text: string = tostring(u34)
		local v144 = sound:Find(("Revolver.%s"):format(text))

		if v144 and not v144:FindFirstChild("Reload") then
			return nil
		end
	end

	local text: string = tostring(u34)
	local u146 = ("%s.%s.%s"):format(s1, text, p6)

	if not sound:Find(u146) then
		u146 = ("%s.Default.%s"):format(s1, p6)
	end

	if not sound:Find(u146) then
		return nil
	end

	if u33 == "Revolver" and p6 == "Shoot" then
		local text3: string = tostring(u34)
		local v148 = sound:Find(("Revolver.%s"):format(text3))

		if v148 and v148:FindFirstChild("Shoot") and not v148:FindFirstChild("Reload") then
			p7 = nil
		end
	end

	local ok, result = pcall(function()
		return sound:Play(u146, v141, nil, nil, nil, p7)
	end)

	return ok and result or nil
end
local function setTwoHanded(p8)
	u40 = p8

	local v152 = u31

	if not v152 then
		return
	end

	v152.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
end
local function refreshTwoHanded()
	u40 = u40

	local v153 = u31

	if not v153 then
		return
	end

	v153.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
end
local function clearMarkers()
	for i = #t3, 1, -1 do
		t3[i]:Disconnect()
		t3[i] = nil
	end
end
local function playOneShot(p9)
	for i = #t3, 1, -1 do
		t3[i]:Disconnect()
		t3[i] = nil
	end

	if u57 then
		if not u57.Destroyed then
			u57:Destroy()
		end

		u57 = nil
	end

	if u37 then
		pcall(function()
			u37:Stop(0)
		end)
		u37 = nil
	end

	u40 = false

	local v157 = u31

	if v157 then
		v157.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
	end

	local v158 = resolveTrack(p9)

	if not v158 then
		return nil
	end

	v158.Looped = false
	v158.Priority = Enum.AnimationPriority.Action2
	v158:Play()
	knifeTiming.ApplyAnimSpeed(v158)
	u37 = v158
	t3[#t3 + 1] = v158:GetMarkerReachedSignal("ArmVisible"):Connect(function()
		if u37 == v158 then
			u40 = true

			local v243 = u31

			if not v243 then
				return
			end

			v243.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1

			return
		end
	end)
	t3[#t3 + 1] = v158:GetMarkerReachedSignal("ArmInvisible"):Connect(function()
		if u37 == v158 then
			u40 = false

			local v244 = u31

			if not v244 then
				return
			end

			v244.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1

			return
		end
	end)
	t3[#t3 + 1] = v158.Stopped:Connect(function()
		if u37 == v158 then
			u37 = nil
			u40 = false

			local v245 = u31

			if not v245 then
				return
			end

			v245.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1

			return
		end
	end)

	return v158
end
local function nextComboAnim()
	local v159, v160, v161 = knifeTiming.NextCombo(n3, n4, os.clock())

	n3 = v160
	n4 = v161

	return v159
end
local function stopCharge()
	if u51 then
		u51:Disconnect()
		u51 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if u65 then
		crosshair.SetSpread(0)
		crosshair.SetAiming(false)
	end

	u49 = false

	if u50 then
		pcall(function()
			u50:Stop(0)
		end)
		u50 = nil
	end

	if u53 and not u53.Destroyed then
		u53:FadeOut(0.1)
		u53 = nil
	end
end
local function startCharge()
	local v162 = resolveTrack("ThrowCharge")
	local v163 = resolveTrack("ThrowChargeHold")

	if v162 and v163 then
		u49 = true
		u50 = v162
		v162.Looped = false
		v162.Priority = Enum.AnimationPriority.Action2

		local v164 = v162.Length

		if v164 <= 0 then
			v164 = knifeTiming.CHARGE_DUR
		end

		u51 = v162.Stopped:Once(function()
			if not u49 then
				return
			end

			v163.Looped = true
			v163.Priority = Enum.AnimationPriority.Action2
			v163:Play()
			u50 = v163
			u53 = playPreviewSound("ChargeReady")
		end)
		v162:Play(nil, nil, v164 / knifeTiming.CHARGE_DUR * 1.01)
		playPreviewSound("ChargeStart")

		if u65 then
			crosshair.SetAiming(true)
			crosshair.SetSpread(knifeTiming.MAX_SPREAD)

			local v165 = os.clock()

			connection = runService.RenderStepped:Connect(function()
				if not u49 then
					return
				end

				local v246 = os.clock()
				local v247 = math.clamp((v246 - v165) / knifeTiming.CHARGE_DUR, 0, 1)

				crosshair.SetSpread((1 - v247) * knifeTiming.MAX_SPREAD)
			end)
		end

		return
	end
end
local function doThrow(p10)
	playOneShot("Throw")

	if u53 and not u53.Destroyed then
		u53:FadeOut(0.15)
		u53 = nil
	end

	u54 = playPreviewSound("Throw")

	local CurrentCamera: Camera = workspace.CurrentCamera
	local v168 = u31

	if CurrentCamera and v168 then
		n9 += 1

		local v169 = v168.rightArm.Position
		local n1 = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 300
		local n2: number = n9 + 1000000000
		local localPlayerUserId = LocalPlayer.UserId
		local v173 = u34
		local v174 = fixedEffects.For(fixedEffects.KNIFE, u34)

		spawnKnife:Fire({
			toolName = "Knife",
			visualOnly = true,
			origin = v169,
			target = n1,
			id = n2,
			ownerUserId = localPlayerUserId,
			skin = v173,
			throwEffect = v174,
			power = p10
		})
	end

	local v175 = u30

	if not v175 then
		return
	end

	n10 += 1

	local v176: number = n10

	weaponRigUtil.SetRigVisible(v175, false, false)
	weaponOffhand.SetVisible(v175, false, false, true)
	task.delay(knifeTiming.THROW_HIDE_SEC, function()
		if n10 ~= v176 then
			return
		end

		if u30 ~= v175 or not v175.Parent then
			return
		end

		weaponRigUtil.SetRigVisible(v175, true, true)
	end)
end
local function setScopedHidden(p11)
	local v178 = u31

	if v178 then
		v178.leftArm.LocalTransparencyModifier = if p11 then 1 else 0
		v178.rightArm.LocalTransparencyModifier = if p11 then 1 else 0
	end

	weaponRigUtil.SetRigVisible(u30, not p11, not p11)
end
local function enterADS()
	if not u58 and u33 == "Revolver" then
		if os.clock() < n12 then
			return
		end

		u58 = true

		for i = #t3, 1, -1 do
			t3[i]:Disconnect()
			t3[i] = nil
		end

		if u37 then
			pcall(function()
				u37:Stop(0.1)
			end)
			u37 = nil
		end

		if u36 then
			pcall(function()
				u36:Stop(0.1)
			end)
		end

		u40 = u40

		local v180 = u31

		if v180 then
			v180.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
		end

		u61 = resolveTrack("ADSLeftArm")

		if u61 then
			u61.Looped = true
			u61.Priority = Enum.AnimationPriority.Action2
			u61:Play()
		end

		u60 = resolveTrack("ADS")

		if u60 then
			u60.Looped = true
			u60.Priority = Enum.AnimationPriority.Action2
			u60:Play()
		end

		u62 = weaponRigUtil.GetScopeType(u30)

		if u65 then
			crosshair.SetADS(true, u62)
		end

		if crosshair.IsFullOverlayScope(u62) then
			local v181 = u31

			if v181 then
				v181.leftArm.LocalTransparencyModifier = 1
				v181.rightArm.LocalTransparencyModifier = 1
			end

			weaponRigUtil.SetRigVisible(u30, false, false)
		end

		adsWeaponFX.Hide("Preview", u30)
		fovController.Push("ads", -45, 0.15)

		return
	end
end
local function exitADS()
	if not u58 then
		return
	end

	u58 = false

	if u65 then
		crosshair.SetADS(false)
	end

	if crosshair.IsFullOverlayScope(u62) then
		local v182 = u31

		if v182 then
			v182.leftArm.LocalTransparencyModifier = 0
			v182.rightArm.LocalTransparencyModifier = 0
		end

		weaponRigUtil.SetRigVisible(u30, true, true)
	end

	u62 = nil

	if u60 then
		pcall(function()
			u60:Stop(0.2)
		end)
		u60 = nil
	end

	if u61 then
		pcall(function()
			u61:Stop(0.2)
		end)
		u61 = nil
	end

	if u36 then
		pcall(function()
			u36:Play(0.2)
		end)
	end

	u40 = false

	local v183 = u31

	if v183 then
		v183.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
	end

	fovController.Pop("ads", 0.2)
	adsWeaponFX.Restore("Preview")
end
local function viewmodelOffset()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local hud: Instance = playerGui and playerGui:FindFirstChild("HUD")
	local v186: Instance = hud

	if v186 then
		v186 = hud:FindFirstChild("Camera")
	end

	local v187 = v186 and v186:GetAttribute("ViewmodelOffset")

	if typeof(v187) == "Vector3" then
		return v187
	end

	return Vector3.new(0, 0, 0.5)
end
local function step(p12)
	local v189 = u31
	local v190 = u29

	if not v189 or not v190 or not v190.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local currentCameraCFrame: CFrame = CurrentCamera.CFrame
	local v193, v194, v195 = currentCameraCFrame:ToEulerAnglesYXZ()

	n11 = viewmodelArms.StepAdsAlpha(n11, if u58 then 1 else 0, p12)

	local viewmodelArmsHoldCFrame = viewmodelArms.HoldCFrame
	local t5: {[any]: any} = { torsoZ = 0, cameraCF = currentCameraCFrame, torsoY = v194 }
	local viewmodelArmsAdsLift = viewmodelArms.AdsLift
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v200 = playerGui

	if v200 then
		v200 = playerGui:FindFirstChild("HUD")
	end

	local v201: Instance = v200

	if v201 then
		v201 = v200:FindFirstChild("Camera")
	end

	v200 = v201

	if v200 then
		v200 = v201:GetAttribute("ViewmodelOffset")
	end

	local typeName: string = typeof(v200)

	t5.viewmodelOffset = viewmodelArmsAdsLift(if typeName == "Vector3" then v200 else Vector3.new(0, 0, 0.5), n11)
	t5.adsCorrection = viewmodelArms.AdsCorrection(v190, n11)

	local v203 = viewmodelArmsHoldCFrame(t5)

	viewmodelArms.Pose(v189, v203, viewmodelArms.ArmsWidth(v190, u33 == "Revolver"))
end
local function bind()
	if u66 then
		return
	end

	runService:BindToRenderStep("InspectWieldedArms", n1, step)
	u66 = true
end
local function unbind()
	if not u66 then
		return
	end

	runService:UnbindFromRenderStep("InspectWieldedArms")
	u66 = false
end

local module: {[any]: any} = {
	Stop = function()
		if u66 then
			runService:UnbindFromRenderStep("InspectWieldedArms")
			u66 = false
		end

		for i = #t3, 1, -1 do
			t3[i]:Disconnect()
			t3[i] = nil
		end

		exitADS()
		stopCharge()
		u46 = false
		n8 += 1
		n10 += 1
		n11 = 0
		n13 += 1
		n12 = 0
		n6 = 0

		if u65 then
			crosshair.SetReloading(false)
			crosshair.SetSpread(0)
			crosshair.SetAiming(false)
			crosshair.IsGun = false
		end

		u65 = false

		if u57 then
			if not u57.Destroyed then
				u57:Destroy()
			end

			u57 = nil
		end

		if u54 and not u54.Destroyed then
			u54:FadeOut(0.1)
		end

		u54 = nil
		playEquipEffect(false)
		playerState.WieldedPreviewActive = false

		if u37 then
			pcall(function()
				u37:Stop(0)
			end)
			u37 = nil
		end

		if u36 then
			pcall(function()
				u36:Stop(0)
			end)
			u36 = nil
		end

		if u10 then
			u10()
			u10 = nil
		end

		if u29 then
			u29:Destroy()
			u29 = nil
		end

		u30 = nil
		u31 = nil
		u32 = nil
		u35 = nil
		u33 = nil
		u34 = nil
		u39 = false
		u40 = false
		n3 = 1
		n4 = 0
		n5 = 0
	end
}

function module.Start(p13, p14, parent)
	module.Stop()

	if p13 == "Knife" or p13 == "Revolver" then
		local __WieldedPreview = sourceBody()

		if not __WieldedPreview then
			warn("[WieldedPreview] No body available for preview")

			return false
		end

		__WieldedPreview.Name = "__WieldedPreview"
		prepareBody(__WieldedPreview)

		local torso = __WieldedPreview:FindFirstChild("Torso")
		local foundChild = __WieldedPreview:FindFirstChild("Left Arm")
		local foundChild2 = __WieldedPreview:FindFirstChild("Right Arm")
		local leftShoulder = torso and torso:FindFirstChild("Left Shoulder")
		local rightShoulder = torso and torso:FindFirstChild("Right Shoulder")
		local humanoidRootPart = __WieldedPreview:FindFirstChild("HumanoidRootPart")

		if torso and foundChild and foundChild2 and leftShoulder and rightShoulder and humanoidRootPart then
			u33 = p13
			u34 = p14
			u32 = humanoidRootPart
			n2 = foundChild.Transparency
			__WieldedPreview.PrimaryPart = humanoidRootPart
			placeBody(__WieldedPreview, workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.identity)
			__WieldedPreview.Parent = parent
			u29 = __WieldedPreview
			playerState.WieldedPreviewActive = true
			u65 = LocalPlayer:GetAttribute("InMatch") ~= true

			if u65 then
				crosshair.IsGun = p13 == "Revolver"
				crosshair.SetAiming(p13 == "Revolver")
				crosshair.SetSpread(0)
				crosshair.SetReloading(false)
			end

			u31 = {
				character = __WieldedPreview,
				torso = torso,
				leftArm = foundChild,
				rightArm = foundChild2,
				leftShoulder = leftShoulder,
				rightShoulder = rightShoulder
			}
			local u215

			if p13 == "Revolver" then
				u215 = weaponRigUtil.ApplyRevolverSkin(__WieldedPreview, p14, foundChild2, "Revolver_HandAttach")
			else
				u215 = weaponRigUtil.ApplyKnifeSkin(__WieldedPreview, p14, foundChild2, "Knife_HandAttach")
			end

			if not u215 then
				warn("[WieldedPreview] Missing rig template:", p13, p14)
				module.Stop()

				return false
			end

			u30 = u215
			weaponRigUtil.ApplyClanLabels(u215, LocalPlayer)
			weaponOffhand.Attach(__WieldedPreview, u215)
			u10 = heldVariants.Watch(__WieldedPreview, true)

			local _GMurderNotePages = _G.MurderNotePages

			if _GMurderNotePages and _GMurderNotePages.PaintPreview then
				pcall(function()
					_GMurderNotePages.PaintPreview(u215)
				end)
			end

			weaponRigUtil.EnsureNoCollide(u215)

			for _, v in ipairs(u215:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CastShadow = false
				end
			end

			local foundChild3 = u215:FindFirstChild("AlwaysTwoHanded", true)
			local u220 = false

			if foundChild3 ~= nil then
				u220 = foundChild3:IsA("BoolValue") and foundChild3.Value == true
			end

			u39 = u220
			u40 = false

			local v221 = u31

			if v221 then
				v221.leftArm.Transparency = if u40 or u39 or u58 then n2 else 1
			end

			u35 = anims.new(__WieldedPreview)
			u36 = resolveTrack("Idle")

			if u36 then
				u36.Looped = true
				u36.Priority = Enum.AnimationPriority.Action
				u36:Play()
			end

			playEquipEffect(true)
			playOneShot("Equip")

			if not userInputService.GamepadEnabled then
				playPreviewSound("Equip", 0.05)
			end

			local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
			local v223: Instance = bindables

			if v223 then
				v223 = bindables:FindFirstChild("AnimateSkins")
			end

			if v223 and v223:IsA("BindableEvent") then
				v223:Fire(__WieldedPreview)
			end

			if not u66 then
				runService:BindToRenderStep("InspectWieldedArms", n1, step)
				u66 = true
			end

			return true
		end

		warn("[WieldedPreview] Body is missing R6 arm joints")
		__WieldedPreview:Destroy()

		return false
	end

	return false
end
local function startReload(p16)
	n13 += 1

	local v225: number = n13

	if u65 then
		crosshair.SetReloading(true, revolverTiming.SHOT_COOLDOWN)
		task.delay(revolverTiming.SHOT_COOLDOWN, function()
			if n13 ~= v225 then
				return
			end

			crosshair.SetReloading(false)
		end)
	end

	local u226: boolean = false

	local function fire()
		if u226 or n13 ~= v225 then
			return
		end

		if not u29 or not u29.Parent then
			return
		end

		u226 = true
		playPreviewSound("Reload", 0.04)
	end

	if p16 then
		t3[#t3 + 1] = p16:GetMarkerReachedSignal("ReloadSound"):Connect(fire)
	end

	task.delay(revolverTiming.RELOAD_SOUND_FALLBACK, fire)
end
local function attack()
	if not u29 or not u29.Parent then
		return
	end

	local v228 = os.clock()

	if u33 ~= "Revolver" then
		if v228 - n5 < knifeTiming.MELEE_COOLDOWN then
			return
		end

		n5 = v228

		local v229, v230, v231 = knifeTiming.NextCombo(n3, n4, os.clock())

		n3 = v230
		n4 = v231
		playOneShot(v229)
		playPreviewSound("Swing", 0.175)

		return
	end

	if v228 < n12 then
		return
	end

	n12 = v228 + revolverTiming.SHOT_COOLDOWN

	local v232 = playOneShot("Shoot")

	playPreviewSound("Shoot", 0.12)
	playShotVFX()
	startReload(v232)

	if u65 then
		crosshair.SetSpread(0.3)
		task.delay(0.1, function()
			crosshair.SetSpread(0)
		end)
	end
end
function module.PrimaryDown()
	if not u29 or not u29.Parent then
		return
	end

	if u46 then
		return
	end

	if u33 == "Revolver" then
		if os.clock() < n12 then
			return
		end

		exitADS()
		attack()

		return
	end

	u46 = true
	n7 = os.clock()
	n8 += 1

	local v233: number = n8

	task.spawn(function()
		while u46 and n8 == v233 do
			local v248 = os.clock()

			if v248 - n7 >= knifeTiming.HOLD_TO_THROW_SEC and v248 >= n6 then
				if u46 and n8 == v233 then
					startCharge()
				end

				return
			end

			task.wait()
		end
	end)
end
function module.PrimaryUp()
	if not u46 then
		return
	end

	u46 = false
	n8 += 1

	local n1 = os.clock() - n7
	local v235: boolean = u49

	stopCharge()

	if not (n1 >= knifeTiming.HOLD_TO_THROW_SEC) then
		attack()

		return
	end

	if v235 then
		n6 = os.clock() + knifeTiming.THROW_COOLDOWN

		local v236 = math.clamp(n1 / knifeTiming.CHARGE_DUR, 0, 1)

		doThrow(v236)

		return
	end

	attack()
end
function module.SecondaryDown()
	if not u29 or not u29.Parent then
		return
	end

	enterADS()
end
function module.SecondaryUp()
	exitADS()
end
function module.Inspect()
	if not u29 or not u29.Parent then
		return
	end

	if u46 then
		return
	end

	if u58 then
		return
	end

	if u33 == "Revolver" then
		if os.clock() < n12 then
			return
		end
	elseif os.clock() - n5 < knifeTiming.MELEE_COOLDOWN then
		return
	end

	local v237 = playOneShot("Inspect")

	if not v237 then
		return
	end

	inspectFX.Play(u30, v237)

	local v238 = playPreviewSound("Inspect")

	if not v238 then
		return
	end

	u57 = v238
	v237.Stopped:Once(function()
		if u57 ~= v238 then
			return
		end

		u57 = nil

		if not v238.Destroyed then
			v238:FadeOut(0.3)
		end
	end)
end
function module.IsActive()
	return u29 ~= nil and u29.Parent ~= nil
end
function module.IsAiming()
	return u58
end

return module
