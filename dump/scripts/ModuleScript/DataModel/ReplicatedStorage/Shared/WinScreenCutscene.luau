-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(shared:WaitForChild("WeaponRigUtil"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local fovController = require(replicatedStorageShared:WaitForChild("FOVController"))
local winScreenRig: Instance = script:WaitForChild("WinScreenRig")
local t1: {[any]: any} = { "MVP", "Plr2", "Plr3", "Plr4" }
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local u14: boolean = false;

(function()
	if u14 then
		return
	end

	u14 = true

	local animations: Instance = winScreenRig:FindFirstChild("Animations")

	if not animations then
		return
	end

	local t5: {[any]: any} = {}

	for _, v in ipairs(animations:GetChildren()) do
		for _, iterValue in ipairs(v:GetChildren()) do
			if iterValue:IsA("Animation") then
				table.insert(t5, iterValue)
			end
		end
	end

	if #t5 > 0 then
		task.spawn(function()
			contentProvider:PreloadAsync(t5)
		end)
	end
end)()

local function applyAvatarAppearance(character, p2)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		warn("[WinScreenCutscene] hum failed for userId", p2)

		return
	end

	local ok, result = pcall(function()
		return players:GetHumanoidDescriptionFromUserIdAsync(p2)
	end)

	if ok and result then
		for _, v in ipairs(character:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
				v:Destroy()
			end
		end

		local ok2, result2 = pcall(function()
			humanoid:ApplyDescriptionResetAsync(result)
		end)

		if not ok2 then
			warn("[WinScreenCutscene] ApplyDescription failed for userId", p2, ":", result2)
		end

		return
	end

	warn("[WinScreenCutscene] GetHumanoidDescriptionFromUserId failed for userId", p2, ":", result)
end
local function applyWeaponSkins(p3, p4, p5, p6)
	local foundChild = p3:FindFirstChild("Right Arm")
	local foundChild2 = p3:FindFirstChild("Left Arm")

	if foundChild then
		local v48 = weaponRigUtil.ApplyKnifeSkin(p3, p4 and p4 ~= "" and p4 or "Default", foundChild, "Knife_HandAttach")

		weaponRigUtil.ApplyClanLabels(v48, p6)
	end

	if foundChild2 then
		local v49 = weaponRigUtil.ApplyRevolverSkin(p3, p5 and p5 ~= "" and p5 or "Default", foundChild2, "Gun_HandAttach")

		weaponRigUtil.ApplyClanLabels(v49, p6)
	end
end

local u17 = nil
local connection = nil
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local CameraType = nil
local FieldOfView = nil
local u24 = nil
local u25: boolean = false

local function cleanup()
	local v50 = u17

	u17 = nil
	u24 = nil
	u25 = false

	for _, v in ipairs(t2) do
		v:Stop(0)
		v:Destroy()
	end

	table.clear(t2)
	table.clear(t3)
	table.clear(t4)

	if connection then
		connection:Disconnect()
		connection = nil
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		if CameraType then
			CurrentCamera.CameraType = CameraType
			CameraType = nil
		end

		if FieldOfView then
			CurrentCamera.FieldOfView = FieldOfView
			FieldOfView = nil
		end

		fovController._Apply(0)
	end

	if v50 then
		v50:Destroy()
	end

	local LocalPlayer = game.Players.LocalPlayer
	local cutsceneFadeGui = LocalPlayer.PlayerGui:FindFirstChild("CutsceneFadeGui")
	local cutsceneVignetteGui = LocalPlayer.PlayerGui:FindFirstChild("CutsceneVignetteGui")
	local vignette = cutsceneVignetteGui and cutsceneVignetteGui:FindFirstChild("Vignette")

	if vignette then
		vignette.Visible = false
	end

	local cutsceneFade = cutsceneFadeGui and cutsceneFadeGui:FindFirstChild("CutsceneFade")

	if cutsceneFade then
		cutsceneFade.BackgroundTransparency = 1
		cutsceneFade.Visible = false
	end

	local winCutsceneDOF = game.Lighting:FindFirstChild("WinCutsceneDOF")

	if winCutsceneDOF then
		winCutsceneDOF.Enabled = false
	end
end

return {
	PlayCutscene = function(p7, p8, p9, p10)
		if u17 then
			cleanup()
		end

		local v64 = math.clamp(#p8, 1, 4)
		local t6: {[any]: any} = {}

		for i, v in ipairs(p8) do
			if i > 4 then
				break
			end

			t6[i] = players:GetPlayerByUserId(v.UserId)
		end

		local LocalPlayer: Player = players.LocalPlayer
		local cutsceneFade = LocalPlayer.PlayerGui:WaitForChild("CutsceneFadeGui"):FindFirstChild("CutsceneFade")

		if cutsceneFade then
			cutsceneFade.BackgroundTransparency = 0
			cutsceneFade.Visible = true
		end

		local CurrentCamera: Camera = workspace.CurrentCamera

		if CurrentCamera then
			CameraType = CurrentCamera.CameraType
			FieldOfView = CurrentCamera.FieldOfView
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.FieldOfView = 30
		end

		local currentCameraCFrame = CurrentCamera and CurrentCamera.CFrame

		connection = runService.RenderStepped:Connect(function()
			local CurrentCamera2: Camera = workspace.CurrentCamera

			if CurrentCamera2 then
				CurrentCamera2.CameraType = Enum.CameraType.Scriptable

				if currentCameraCFrame then
					CurrentCamera2.CFrame = currentCameraCFrame
				end

				CurrentCamera2.FieldOfView = 30
			end
		end)

		local t7: {[any]: any} = {}
		local v73 = script:FindFirstChild("Misc") and script.Misc:FindFirstChild("WinScreen")

		if not v73 then
			local sound: Instance = replicatedStorage:FindFirstChild("Sound")

			if sound then
				local misc2: Instance = sound:FindFirstChild("Misc")

				v73 = misc2 and misc2:FindFirstChild("WinScreen")
			end
		end

		if v73 then
			table.insert(t7, v73)
		end

		for _, v in ipairs(winScreenRig:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Sound") or v:IsA("Decal") or v:IsA("Texture") then
				table.insert(t7, v)
			end
		end

		local cutsceneVignetteGui = LocalPlayer.PlayerGui:WaitForChild("CutsceneVignetteGui")
		local vignette = cutsceneVignetteGui:FindFirstChild("Vignette")

		if vignette then
			table.insert(t7, vignette)
		end

		if #t7 > 0 then
			task.spawn(function()
				contentProvider:PreloadAsync(t7)
			end)
		end

		u24 = p9
		u25 = false

		local clone: Instance = winScreenRig:Clone()

		clone.Name = "WinScreenRig_Active"
		clone:PivotTo(p7 + Vector3.new(0, -500, 0))
		clone.Parent = workspace
		u17 = clone

		local vignette2 = cutsceneVignetteGui:FindFirstChild("Vignette")

		if vignette2 then
			vignette2.Visible = true
		end

		local winCutsceneDOF = game.Lighting:FindFirstChild("WinCutsceneDOF")

		if winCutsceneDOF then
			winCutsceneDOF.Enabled = true
		end

		for i = v64 + 1, #t1 do
			local foundChild: Instance = clone:FindFirstChild(t1[i])

			if foundChild then
				foundChild:Destroy()
			end
		end

		local animations: Instance = clone:FindFirstChild("Animations")

		for i = 1, v64 do
			local foundChild3: Instance = clone:FindFirstChild(t1[i])

			if foundChild3 then
				local player = p8[i]
				local u89: boolean = false

				local v90 = task.spawn(function()
					applyAvatarAppearance(foundChild3, player.UserId)
					u89 = true
				end)

				local n1 = 0

				while not u89 and n1 < 5 do
					local v92 = task.wait()

					n1 += v92
				end

				if not u89 then
					task.cancel(v90)
					warn("[WinScreenCutscene] applyAvatarAppearance timed out for userId", player.UserId, "- skipping avatar")
				end

				applyWeaponSkins(foundChild3, player.KnifeSkin, player.RevolverSkin, t6[i])
			end
		end

		if clone ~= u17 then
			clone:Destroy()

			return
		end

		clone:PivotTo(p7)

		for i = 1, v64 do
			local v94 = t1[i]
			local foundChild4: Instance = clone:FindFirstChild(v94)

			if foundChild4 then
				local humanoid: Instance = foundChild4:FindFirstChildOfClass("Humanoid")

				if not humanoid then
					continue
				end

				local animator: Instance = humanoid:FindFirstChildOfClass("Animator")

				if not animator then
					continue
				end

				local v98 = animations

				if v98 then
					v98 = animations:FindFirstChild(v94)
				end

				if not v98 then
					continue
				end

				local start: Instance = v98:FindFirstChild("Start")
				local idle: Instance = v98:FindFirstChild("Idle")

				if not start then
					continue
				end

				v98 = animator:LoadAnimation(start)
				v98.Looped = false
				v98.Priority = Enum.AnimationPriority.Action4
				v98:GetMarkerReachedSignal("Shoot"):Connect(function()
					local revolverRig: Instance = foundChild4:FindFirstChild("RevolverRig")

					if revolverRig then
						misc.EmitAll(revolverRig)

						local cam: Instance = clone:FindFirstChild("Cam")

						misc.EmitAll(cam.GlassShatter)
						cam.GlassShatter.SurfaceGui.Enabled = true
						task.spawn(function()
							task.spawn(function()
								local depthOfFieldEffect: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

								depthOfFieldEffect.FarIntensity = 1
								depthOfFieldEffect.FocusDistance = 50
								depthOfFieldEffect.InFocusRadius = 0
								depthOfFieldEffect.NearIntensity = 0
								depthOfFieldEffect.Parent = game.Lighting

								local tweenInfo = TweenInfo.new(0.033, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

								tweenService:Create(depthOfFieldEffect, tweenInfo, {
									FarIntensity = 0.68,
									FocusDistance = 5.84,
									InFocusRadius = 0,
									NearIntensity = 0.018
								}):Play()
								task.wait(0.033)

								local tweenInfo2 = TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

								tweenService:Create(depthOfFieldEffect, tweenInfo2, {
									FarIntensity = 0,
									FocusDistance = 0,
									InFocusRadius = 0,
									NearIntensity = 0
								}):Play()
								task.wait(0.8)
								depthOfFieldEffect:Destroy()
							end)

							local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

							colorCorrectionEffect.Parent = game.Lighting
							debris:AddItem(colorCorrectionEffect, 1)

							local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							local color3 = Color3.fromRGB(255, 249, 212)

							tweenService:Create(colorCorrectionEffect, tweenInfo, { Brightness = 1, Saturation = -0.2, Contrast = 3, TintColor = color3 }):Play()
							task.wait(0.1)

							local tweenInfo3 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							local color32 = Color3.fromRGB(255, 255, 255)

							tweenService:Create(colorCorrectionEffect, tweenInfo3, { Brightness = 0.4, Saturation = 0, Contrast = 1, TintColor = color32 }):Play()
							task.wait(0.1)

							local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							local color33 = Color3.fromRGB(255, 255, 255)

							tweenService:Create(colorCorrectionEffect, tweenInfo4, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color33 }):Play()
						end)
						task.spawn(function()
							task.wait(0.6)

							if not cam:FindFirstChild("GlassShatter") then
								return
							end

							local imageLabel = cam.GlassShatter.SurfaceGui.ImageLabel
							local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

							tweenService:Create(imageLabel, tweenInfo, { ImageTransparency = 1 }):Play()
						end)
					end
				end)
				table.insert(t2, v98)
				table.insert(t3, v98)
				v98:Play(0)
				task.delay(0.05, function()
					game.StarterGui.CutsceneVignetteGui.Vignette.ImageTransparency = 0
				end)

				if not idle then
					continue
				end

				local animationTrack = animator:LoadAnimation(idle)

				animationTrack.Looped = true
				animationTrack.Priority = Enum.AnimationPriority.Action4
				table.insert(t2, animationTrack)
				table.insert(t4, animationTrack)
				v98.Stopped:Once(function()
					if u17 == clone then
						animationTrack:Play(0)

						if i == 1 and not u25 and u24 then
							u25 = true
							u24()
						end
					end
				end)
			end
		end

		local cam: Instance = clone:FindFirstChild("Cam")
		local camera: Instance = animations and animations:FindFirstChild("Camera")

		if cam and camera then
			local animationController: Instance = cam:FindFirstChildOfClass("AnimationController")
			local animationControllerAnimator: Instance = animationController and animationController:FindFirstChildOfClass("Animator")

			if animationControllerAnimator then
				local s1: string = "_" .. tostring(v64) .. "Player"
				local foundChild5: Instance = camera:FindFirstChild("Start" .. s1)
				local foundChild6: Instance = camera:FindFirstChild("Idle" .. s1)

				if foundChild5 then
					local v109 = animationControllerAnimator:LoadAnimation(foundChild5)

					v109.Looped = false
					v109.Priority = Enum.AnimationPriority.Action4
					table.insert(t2, v109)
					table.insert(t3, v109)
					v109:Play(0)

					if foundChild6 then
						local v110 = animationControllerAnimator:LoadAnimation(foundChild6)

						v110.Looped = true
						v110.Priority = Enum.AnimationPriority.Action4
						table.insert(t2, v110)
						table.insert(t4, v110)
						v109.Stopped:Once(function()
							if u17 == clone then
								v110:Play(0)
							end
						end)
					end
				end
			end
		end

		local camPart: Instance = cam and cam:FindFirstChild("CamPart")

		if camPart then
			if connection then
				connection:Disconnect()
				connection = nil
			end

			connection = runService.RenderStepped:Connect(function()
				local CurrentCamera3: Camera = workspace.CurrentCamera

				if CurrentCamera3 and camPart and camPart.Parent then
					CurrentCamera3.CameraType = Enum.CameraType.Scriptable
					CurrentCamera3.CFrame = camPart.CFrame
					CurrentCamera3.FieldOfView = 30
				end
			end)
		end

		if p10 then
			p10()
		end

		if cutsceneFade then
			task.delay(0.1, function()
				if u17 ~= clone then
					return
				end

				local function hide()
					if not cutsceneFade.Visible then
						return
					end

					local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad)

					tweenService:Create(cutsceneFade, tweenInfo, { BackgroundTransparency = 1 }):Play()
					task.delay(0.4, function()
						cutsceneFade.Visible = false
					end)
				end

				hide()
				task.delay(7, hide)
			end)
		end
	end,
	SkipToIdle = function()
		if not u17 then
			return
		end

		for _, v in ipairs(t3) do
			v:Stop(0)
		end

		for _, v in ipairs(t4) do
			if not v.IsPlaying then
				v:Play(0)
			end
		end

		if not u25 and u24 then
			u25 = true
			u24()
		end
	end,
	StopCutscene = function()
		cleanup()
	end
}
