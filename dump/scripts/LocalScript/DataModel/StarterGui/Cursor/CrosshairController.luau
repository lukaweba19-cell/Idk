-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local fovController = require(shared:WaitForChild("FOVController"))
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("UserInputService")

local LocalPlayer: Player = players.LocalPlayer
local hit: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("Hit")
local remotesHit: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Hit")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local damageNotification = require(util:WaitForChild("DamageNotification"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local crosshair = require(replicatedStorageShared:WaitForChild("Crosshair"))
local v15: Instance = replicatedStorage:WaitForChild("Shared")
local crosshairSettings = require(v15:WaitForChild("CrosshairSettings"))
local v17: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(v17:WaitForChild("ViewedPlayer"))
local v19: Instance = replicatedStorage:WaitForChild("Shared")
local thirdPerson = require(v19:WaitForChild("ThirdPerson"))
local v21: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(v21:WaitForChild("WeaponRigUtil"))
local crosshairComponent = require(script:WaitForChild("CrosshairComponent"))
local controlList = require(script:WaitForChild("ControlList"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local aimMagnetism = require(replicatedStorageExtensions:WaitForChild("AimMagnetism"))
local v29: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(v29:WaitForChild("InputMap"))
local scriptParent: Instance = script.Parent
local centerDot: Instance = scriptParent:WaitForChild("CenterDot")

centerDot.Visible = true

local dot: Instance = centerDot:WaitForChild("Dot")
local outline: Instance = dot:WaitForChild("Outline")
local shadow: Instance = dot:WaitForChild("Shadow")
local outlineTransparency = outline.Transparency

local function resolveStyleUserId()
	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		return nil
	end

	local v79 = viewedPlayer.GetSpecTargetUserId()

	if v79 == nil then
		return nil
	end

	if crosshairSettings.getStyleFor(v79) == nil then
		return nil
	end

	return v79
end
local function effectiveStyle()
	local v80

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v80 = nil
	else
		local v81 = viewedPlayer.GetSpecTargetUserId()

		v80 = if v81 == nil then nil else if crosshairSettings.getStyleFor(v81) == nil then nil else v81
	end

	if v80 == nil then
		return crosshairSettings.getActive()
	end

	return (crosshairSettings.getStyleFor(v80))
end
local function dotRestTargets()
	return crosshairSettings.dotRestTransparencies(effectiveStyle())
end
local function tweenDotVisual(p1)
	local v83, v84 = crosshairSettings.dotRestTransparencies(effectiveStyle())

	tweenService:Create(dot, TweenInfo.new(0.2), {
		BackgroundTransparency = if p1 then 1 else v83
	}):Play()
	tweenService:Create(outline, TweenInfo.new(0.2), {
		Transparency = if p1 then 1 else outlineTransparency
	}):Play()
	tweenService:Create(shadow, TweenInfo.new(0.2), {
		Transparency = if p1 then 1 else v84
	}):Play()
end

local v41: Instance = replicatedStorage:WaitForChild("Shared")
local radialCooldown = require(v41:WaitForChild("RadialCooldown"))
local centerDotRadialCooldown: Instance = centerDot:WaitForChild("RadialCooldown")

centerDotRadialCooldown.Visible = false

local function doStartRadial(p2)
	radialCooldown.CancelRadial(centerDotRadialCooldown)

	local radialCooldownRadialStart = radialCooldown.RadialStart
	local color3 = Color3.fromRGB(0, 255, 0)
	local color32 = Color3.fromRGB(255, 0, 0)

	radialCooldownRadialStart(centerDotRadialCooldown, p2, { autoHide = true, startColor = color3, endColor = color32 })
end

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")

bindables:WaitForChild("StartPendingRadial").Event:Connect(function(p3)
	if typeof(p3) == "number" and p3 > 0 then
		doStartRadial(p3)
	end
end)
bindables:WaitForChild("CancelPendingRadial").Event:Connect(function()
	radialCooldown.CancelRadial(centerDotRadialCooldown)
	centerDotRadialCooldown.Visible = false
end)

local circle: Instance = centerDot:WaitForChild("Circle")

circle.Visible = false

local n1 = circle.AbsoluteSize.X / 2
local v48 = crosshairComponent.create(centerDot:WaitForChild("Frame"))

v48:setVisibleAnimated(false)

local hitmark: Instance = scriptParent:WaitForChild("Hitmark")
local u50 = false
local u51 = false
local n2: number = 0
local v53 = UDim2.fromOffset(32, 32)
local v54 = UDim2.fromOffset(78, 78)
local v55 = UDim2.fromOffset(64, 64)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function killAll()
	for _, v in ipairs(t1) do
		if v then
			pcall(function()
				v:Cancel()
			end)
			pcall(function()
				v:Destroy()
			end)
		end
	end

	table.clear(t1)

	for _, v in ipairs(t2) do
		if v then
			task.cancel(v)
		end
	end

	table.clear(t2)
end
local function makeTween(p4, p5, p6)
	local v97: Tween = tweenService:Create(p4, p5, p6)

	table.insert(t1, v97)

	return v97
end
local function delayTracked(p7, p8)
	local v100 = task.delay(p7, p8)

	table.insert(t2, v100)

	return v100
end
local function spawnTracked(p9)
	local v102 = task.spawn(p9)

	table.insert(t2, v102)

	return v102
end

local n3 = 1
local u63 = nil

local function resetKillStreak()
	n3 = 1
	u63 = nil
end
local function updInMatch()
	local inMatch: any = LocalPlayer:GetAttribute("InMatch")
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if LocalPlayer:GetAttribute("WieldedPreviewActive") == true then
		scriptParent.Enabled = true

		return
	end

	if spectating then
		scriptParent.Enabled = true

		return
	end

	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")).Health <= 0 then
		scriptParent.Enabled = false

		return
	end

	scriptParent.Enabled = inMatch == true
end

if LocalPlayer.Character then
	LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
		n3 = 1
		u63 = nil
		updInMatch()
	end)
	updInMatch()
end

LocalPlayer.CharacterAdded:Connect(function(character: Model)
	character:WaitForChild("Humanoid").Died:Connect(function()
		n3 = 1
		u63 = nil
		updInMatch()
	end)
	updInMatch()
end)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(updInMatch)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(updInMatch)
LocalPlayer:GetAttributeChangedSignal("WieldedPreviewActive"):Connect(updInMatch)
updInMatch()

local function hitEvent(p11, p12, p13, p14, _, p16, p17)
	if not p11 then
		return
	end

	local v113 = if p11:IsA("Model") then p11:FindFirstChild("Torso") else p11

	if not v113 then
		return
	end

	if p11:GetAttribute("Decoy") then
		return
	end

	local v114 = p11:FindFirstChildWhichIsA("Humanoid") and p11.Humanoid.Health <= 0

	if p14 or v114 then
		u63 = os.clock()
		sound:Play("Misc.Kill", workspace, nil, n3)

		if n3 < 3.5 then
			n3 = math.min(n3 + 0.1, 3.5)
		end
	end

	v114 = typeof(p12) == "string"

	local n1 = if p13 then 1 else 0

	if v114 then
		n1 = 3
	end

	if p17 == "Flammable" then
		n1 = 4
	elseif p17 == "Frost" then
		n1 = 5
	end

	local t4: {[any]: any} = {
		anchor = v113,
		amount = p12,
		raw = if v114 then 100 else p12,
		mode = n1
	}

	n1 = damageNotification.new(t4.anchor, t4.amount, t4.raw, t4.mode, t4.upvals, p13 == true)

	if n1 then
		n1:Display()
	end

	if v114 then
		sound:Play("Misc.HitmarkerParry", workspace)
	elseif p13 then
		sound:Play("Misc.HitmarkerHead", workspace)
	else
		sound:Play("Misc.Hitmarker", workspace)
	end

	if p16 then
		return
	end

	local screenHit: Instance = scriptParent:FindFirstChild("ScreenHit")

	if screenHit then
		local clone: Instance = screenHit:Clone()

		clone.Visible = true
		clone.ImageTransparency = 0

		local normal: Instance = clone:FindFirstChild("Normal")
		local headshot: Instance = clone:FindFirstChild("Headshot")

		if p13 then
			if normal then
				normal.Enabled = false
			end

			if headshot then
				headshot.Enabled = true
			end
		else
			if normal then
				normal.Enabled = true
			end

			if headshot then
				headshot.Enabled = false
			end
		end

		clone.Parent = scriptParent

		local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v122: Tween = tweenService:Create(clone, tweenInfo, { ImageTransparency = 1 })

		v122:Play()
		v122.Completed:Once(function()
			clone:Destroy()
		end)
	end

	killAll()
	hitmark.Visible = true
	hitmark.ImageTransparency = 0
	hitmark.Rotation = 0
	hitmark.Size = v53

	if v114 then
		hitmark.Red.Enabled = false
		hitmark.Gold.Enabled = false
		hitmark.Cyan.Enabled = true
	elseif p13 then
		hitmark.Red.Enabled = false
		hitmark.Gold.Enabled = true
		hitmark.Cyan.Enabled = false
	else
		hitmark.Red.Enabled = true
		hitmark.Gold.Enabled = false
		hitmark.Cyan.Enabled = false
	end

	local v123 = task.spawn(function()
		fovController.Push("hitpunch", -5, 0.05)
		task.wait(0.05)
		fovController.Push("hitpunch", 5, 0.05)
		task.wait(0.05)
		fovController.Pop("hitpunch", 0.25)

		local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v218: Tween = tweenService:Create(hitmark, tweenInfo, { Rotation = 20, Size = v54 })

		table.insert(t1, v218)
		v218:Play()

		local v219 = task.delay(0.08, function()
			local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local v221: Tween = tweenService:Create(hitmark, tweenInfo2, { Rotation = 120, Size = v55 })

			table.insert(t1, v221)
			v221:Play()
		end)

		table.insert(t2, v219)
		v219 = task.delay(0.14, function()
			local tweenInfo3 = TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			local v223: Tween = tweenService:Create(hitmark, tweenInfo3, { ImageTransparency = 1, Rotation = 240 })

			table.insert(t1, v223)
			v223:Play()
		end)
		table.insert(t2, v219)
	end)

	table.insert(t2, v123)
end

hit.Event:Connect(hitEvent)
remotesHit.OnClientEvent:Connect(hitEvent)

local u67 = nil
local u68 = false

hitEvent = function()
	if not thirdPerson.IsEnabled() then
	elseif viewedPlayer.GetSpecTargetUserId() == nil then
		if LocalPlayer:GetAttribute("FreecamActive") == true then
			return false
		end

		return true
	end

	return false
end

local function applyLiveStyle()
	local v124

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v124 = nil
	else
		local v125 = viewedPlayer.GetSpecTargetUserId()

		v124 = if v125 == nil then nil else if crosshairSettings.getStyleFor(v125) == nil then nil else v125
	end

	local v126 = if v124 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v124)

	v48:applyStyle(v126)
	v48:applyVisibleState(u50)
	crosshairSettings.applyDot(dot, v126)

	if u68 then
		dot.BackgroundTransparency = 1
		shadow.Transparency = 1
	end
end

local u70 = nil

local function refreshStyleIfSourceChanged()
	local v127

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v127 = nil
	else
		local v128 = viewedPlayer.GetSpecTargetUserId()

		v127 = if v128 == nil then nil else if crosshairSettings.getStyleFor(v128) == nil then nil else v128
	end

	if v127 ~= u70 then
		u70 = v127

		local v129

		if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
			v129 = nil
		else
			local v130 = viewedPlayer.GetSpecTargetUserId()

			v129 = if v130 == nil then nil else if crosshairSettings.getStyleFor(v130) == nil then nil else v130
		end

		local v131 = if v129 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v129)

		v48:applyStyle(v131)
		v48:applyVisibleState(u50)
		crosshairSettings.applyDot(dot, v131)

		if u68 then
			dot.BackgroundTransparency = 1
			shadow.Transparency = 1
		end
	end
end

crosshairSettings.changedSignal():Connect(function()
	local v132

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v132 = nil
	else
		local v133 = viewedPlayer.GetSpecTargetUserId()

		v132 = if v133 == nil then nil else if crosshairSettings.getStyleFor(v133) == nil then nil else v133
	end

	u70 = v132

	local v134

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v134 = nil
	else
		local v135 = viewedPlayer.GetSpecTargetUserId()

		v134 = if v135 == nil then nil else if crosshairSettings.getStyleFor(v135) == nil then nil else v135
	end

	local v136 = if v134 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v134)

	v48:applyStyle(v136)
	v48:applyVisibleState(u50)
	crosshairSettings.applyDot(dot, v136)

	if u68 then
		dot.BackgroundTransparency = 1
		shadow.Transparency = 1
	end
end)

if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
	u70 = nil
else
	local v72 = viewedPlayer.GetSpecTargetUserId()

	u70 = if v72 == nil then nil else if crosshairSettings.getStyleFor(v72) == nil then nil else v72
end

local v73

if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
	v73 = nil
else
	local v74 = viewedPlayer.GetSpecTargetUserId()

	v73 = if v74 == nil then nil else if crosshairSettings.getStyleFor(v74) == nil then nil else v74
end

local v75 = if v73 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v73)

v48:applyStyle(v75)
v48:applyVisibleState(u50)
crosshairSettings.applyDot(dot, v75)

if u68 then
	dot.BackgroundTransparency = 1
	shadow.Transparency = 1
end

local t3: {[any]: any} = {}

inputMap.changed:Connect(function()
	table.clear(t3)
end)

local function addHint(p18, p19, p20, p21, p22)
	local v142, v143 = inputMap.primaryDisplay(p19)

	if v142 == nil and not p22 then
		return
	end

	table.insert(p18, {
		Keybind = v142 or "",
		MouseTemplate = v143,
		Label = p20,
		GamepadKeyCode = p21,
		gamepadOnly = p22
	})
end
local function controlListFor(p23)
	local v145 = t3[p23]

	if v145 then
		return v145
	end

	v145 = {}
	local gamepadBindingsSlide = gamepadBindings.Slide
	local v147, v148 = inputMap.primaryDisplay("Crouch")

	if v147 ~= nil then
		table.insert(v145, {
			Label = "Crouch / Slide",
			gamepadOnly = nil,
			Keybind = v147 or "",
			MouseTemplate = v148,
			GamepadKeyCode = gamepadBindingsSlide
		})
	end

	local gamepadBindingsInspect = gamepadBindings.Inspect
	local v150, v151 = inputMap.primaryDisplay("Inspect")

	if v150 ~= nil then
		table.insert(v145, {
			Label = "Inspect",
			gamepadOnly = nil,
			Keybind = v150 or "",
			MouseTemplate = v151,
			GamepadKeyCode = gamepadBindingsInspect
		})
	end

	local gamepadBindingsScoreboard = gamepadBindings.Scoreboard
	local v153, v154 = inputMap.primaryDisplay("Scoreboard")

	table.insert(v145, {
		Label = "Scoreboard",
		gamepadOnly = true,
		Keybind = v153 or "",
		MouseTemplate = v154,
		GamepadKeyCode = gamepadBindingsScoreboard
	})
	table.insert(v145, {
		Keybind = "",
		Label = "Select Player",
		gamepadOnly = true,
		GamepadKeyCode = gamepadBindings.ScoreboardFocus
	})

	if p23 == "Knife" then
		local gamepadBindingsFire = gamepadBindings.Fire
		local v156, v157 = inputMap.primaryDisplay("Attack")

		if v156 ~= nil then
			table.insert(v145, {
				Label = "Stab / Hold to Throw",
				gamepadOnly = nil,
				Keybind = v156 or "",
				MouseTemplate = v157,
				GamepadKeyCode = gamepadBindingsFire
			})
		end
	elseif p23 == "Revolver" then
		local fire = gamepadBindings.Fire
		local v159, v160 = inputMap.primaryDisplay("Attack")

		if v159 ~= nil then
			table.insert(v145, {
				Label = "Shoot",
				gamepadOnly = nil,
				Keybind = v159 or "",
				MouseTemplate = v160,
				GamepadKeyCode = fire
			})
		end

		local gamepadBindingsAds = gamepadBindings.ADS
		local v162, v163 = inputMap.primaryDisplay("Aim")

		if v162 ~= nil then
			table.insert(v145, {
				Label = "Aim",
				gamepadOnly = nil,
				Keybind = v162 or "",
				MouseTemplate = v163,
				GamepadKeyCode = gamepadBindingsAds
			})
		end
	end

	local v164 = inputMap.primaryText("EquipKnife")
	local v165 = inputMap.primaryText("EquipRevolver")

	table.insert(v145, {
		Label = "Swap Weapon",
		gamepadOnly = true,
		Keybind = if v164 and v165 then v164 .. "/" .. v165 else v164 or v165 or "",
		GamepadKeyCode = gamepadBindings.SwapWeapon
	})
	t3[p23] = v145

	return v145
end

runService.Heartbeat:Connect(function(deltaTime: number)
	local v167

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v167 = nil
	else
		local v168 = viewedPlayer.GetSpecTargetUserId()

		v167 = if v168 == nil then nil else if crosshairSettings.getStyleFor(v168) == nil then nil else v168
	end

	if v167 ~= u70 then
		u70 = v167

		local v169

		if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
			v169 = nil
		else
			local v170 = viewedPlayer.GetSpecTargetUserId()

			v169 = if v170 == nil then nil else if crosshairSettings.getStyleFor(v170) == nil then nil else v170
		end

		local v171 = if v169 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v169)

		v48:applyStyle(v171)
		v48:applyVisibleState(u50)
		crosshairSettings.applyDot(dot, v171)

		if u68 then
			dot.BackgroundTransparency = 1
			shadow.Transparency = 1
		end
	end

	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v173 = localPlayerCharacter and localPlayerCharacter:FindFirstChildWhichIsA("Tool") or nil

	if v173 then
		local controlListSetList = controlList.setList
		local v175 = controlListFor(v173.Name)

		controlListSetList(v175)
	else
		controlList.setList(nil)
	end

	if u63 ~= nil and os.clock() - u63 >= 4 then
		n3 = 1
		u63 = nil
	end

	n2 += deltaTime

	if not crosshair or not crosshair.Spread then
		return
	end

	if crosshair.IsGun then
		v48.spring.Speed = 23
		v48.spring.Damper = 0.6
	else
		v48.spring.Speed = 19
		v48.spring.Damper = 1.1
	end

	local v176

	if LocalPlayer:GetAttribute("SpectateCrosshair") == false then
		v176 = nil
	else
		local v177 = viewedPlayer.GetSpecTargetUserId()

		v176 = if v177 == nil then nil else if crosshairSettings.getStyleFor(v177) == nil then nil else v177
	end

	local v178 = if v176 == nil then crosshairSettings.getActive() else crosshairSettings.getStyleFor(v176)
	local v179 = crosshair.Spread

	if crosshair.IsGun and v178.StaticGunCrosshair == true then
		v179 = 0
	end

	v48.gapScale = if crosshair.ADS == nil or not (if not thirdPerson.IsEnabled() then false else if viewedPlayer.GetSpecTargetUserId() == nil then LocalPlayer:GetAttribute("FreecamActive") ~= true else false) then 1 else 0.45
	v48:update(v179, n2)

	local v180 = crosshair.Enabled and scriptParent.Enabled

	if v180 then
		v180 = (LocalPlayer:GetAttribute("MouseUnlocked") or 0) == 0
	end

	if v180 ~= u51 then
		v48:setVisible(v180)

		if not v180 then
			u50 = false
		end

		u51 = v180
	end

	local v181 = crosshair.Aiming
	local v182 = viewedPlayer.GetCharacter()
	local v183 = v173

	if v182 ~= LocalPlayer.Character then
		v183 = v182 and v182:FindFirstChildWhichIsA("Tool") or nil
	end

	if not v181 and v178.ShowKnifeLines == true and v183 and v183.Name == "Knife" then
		v181 = true
	end

	local crosshairAds = crosshair.ADS

	v178 = crosshairAds

	if crosshair.IsFullOverlayScope(v178) and (if not thirdPerson.IsEnabled() then false else if viewedPlayer.GetSpecTargetUserId() == nil then LocalPlayer:GetAttribute("FreecamActive") ~= true else false) then
		v178 = "Focus"
	end

	v173 = crosshairAds ~= nil and not (if not thirdPerson.IsEnabled() then false else if viewedPlayer.GetSpecTargetUserId() == nil then LocalPlayer:GetAttribute("FreecamActive") ~= true else false)

	if v173 ~= u68 then
		u68 = v173
		tweenDotVisual(v173)
	end

	if v178 ~= u67 then
		if u67 == "SniperScope" then
			tweenService:Create(scriptParent.SniperScope, TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()

			for _, v in ipairs(scriptParent.SniperScope:GetDescendants()) do
				if v:IsA("Frame") then
					tweenService:Create(v, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
				end
			end
		elseif u67 == "MagicCircle" then
			tweenService:Create(scriptParent.MagicCircle, TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()

			for _, v in ipairs(scriptParent.MagicCircle:GetDescendants()) do
				if v:IsA("Frame") then
					tweenService:Create(v, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
				end
			end
		elseif u67 == "Focus" then
			tweenService:Create(scriptParent.Focus, TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()
		end

		if v178 then
			if not u67 then
				local revolverRig = v182 and v182:FindFirstChild("RevolverRig")
				local weaponRigUtilGetADSSound = weaponRigUtil.GetADSSound
				local v191 = if revolverRig and revolverRig:IsA("Model") then revolverRig else nil
				local v192 = weaponRigUtilGetADSSound(v191)

				sound:Play(v192 or "Misc.ADS", workspace)
			end

			if v178 == "SniperScope" then
				tweenService:Create(scriptParent.SniperScope, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play()

				for _, v in ipairs(scriptParent.SniperScope:GetDescendants()) do
					if v:IsA("Frame") then
						tweenService:Create(v, TweenInfo.new(0.2), { BackgroundTransparency = 0.35 }):Play()
					end
				end
			elseif v178 == "MagicCircle" then
				tweenService:Create(scriptParent.MagicCircle, TweenInfo.new(0.2), { ImageTransparency = 0 }):Play()

				for _, v in ipairs(scriptParent.MagicCircle:GetDescendants()) do
					if v:IsA("Frame") then
						tweenService:Create(v, TweenInfo.new(0.2), { BackgroundTransparency = 0.35 }):Play()
					end
				end
			else
				tweenService:Create(scriptParent.Focus, TweenInfo.new(0.2), { ImageTransparency = 0.25 }):Play()
			end
		end

		u67 = v178
	end

	if u67 and not (if not thirdPerson.IsEnabled() then false else if viewedPlayer.GetSpecTargetUserId() == nil then LocalPlayer:GetAttribute("FreecamActive") ~= true else false) then
		v181 = false
	end

	local v197 = crosshair.AmmoCount
	local v198 = crosshair.AmmoTint

	if typeof(v197) ~= "number" then
		v197 = 0
	end

	if typeof(v198) ~= "Color3" then
		v198 = Color3.new(1, 1, 1)
	end

	local ammo = scriptParent.CenterDot.Ammo
	local visible: boolean = v197 > 0

	if visible ~= ammo.Visible then
		ammo.Visible = visible
	end

	if visible then
		local text: string = tostring(v197)

		if ammo.Text ~= text then
			ammo.Text = text
		end

		ammo.TextColor3 = v198
	end

	scriptParent.CenterDot.Cooldown.ImageColor3 = v198

	if not visible and not crosshair.Reloading or not crosshair.IsGun then
		scriptParent.CenterDot.Cooldown.Visible = false
	else
		local v202 = crosshair.ReloadingDuration

		if typeof(v202) ~= "number" or v202 <= 0 then
			v202 = 2
		end

		local v203: number = workspace:GetServerTimeNow()
		local v204 = math.clamp((v203 - crosshair.Reloading) / v202, 0, 1)

		if not visible and not (v204 < 1) then
			scriptParent.CenterDot.Cooldown.Visible = false
		else
			local n4 = 1 - v204
			local uiGradient = scriptParent.CenterDot.Cooldown.UIGradient
			local numberSequenceNew = NumberSequence.new
			local numberSequenceKeypoint = NumberSequenceKeypoint.new(n4, 0.7)
			local numberSequenceKeypointNew = NumberSequenceKeypoint.new
			local v210 = math.min(1, n4 + 0.00001)
			local v211 = numberSequenceKeypointNew(v210, 0)

			uiGradient.Transparency = numberSequenceNew({
				NumberSequenceKeypoint.new(0, 0.7),
				numberSequenceKeypoint,
				v211,
				NumberSequenceKeypoint.new(1, 0)
			})
			scriptParent.CenterDot.Cooldown.Visible = true
		end
	end

	if v181 ~= u50 then
		v48:setVisibleAnimated(v181)
		tweenService:Create(circle, TweenInfo.new(0.1), {
			ImageTransparency = if v181 then 0 else 1
		}):Play()
		u50 = v181
	end

	if aimMagnetism:isActive() then
		scriptParent.CenterDot.Frame.Visible = false
		circle.Visible = true

		if not u67 then
			n1 = circle.AbsoluteSize.X / 2
			aimMagnetism:setBaseFOV(workspace.CurrentCamera.FieldOfView)
		end

		aimMagnetism:setReticleRadius(n1)

		local u212: boolean = false

		if typeof(crosshair.AmmoCount) == "number" then
			u212 = crosshair.AmmoCount > 0
		end

		local color3

		if scriptParent.CenterDot.Cooldown.Visible and not u212 then
			color3 = Color3.new(1, 1, 1)
		elseif crosshair.IsGun then
			color3 = aimMagnetism:isSecuredHit() and Color3.fromRGB(255, 51, 51) or Color3.new(1, 1, 1)
		elseif aimMagnetism:hasTarget() then
			local v214 = aimMagnetism:getTargetDistance()
			local v215 = math.max(v214, 1)
			local v216 = math.clamp(30 / v215, 0, 1)

			color3 = Color3.new(1, 1 - v216 * 0.8, 1 - v216 * 0.8)
		else
			color3 = Color3.new(1, 1, 1)
		end

		circle.ImageColor3 = color3
	else
		scriptParent.CenterDot.Frame.Visible = true
		circle.Visible = false
	end

	n2 = 0
end)
