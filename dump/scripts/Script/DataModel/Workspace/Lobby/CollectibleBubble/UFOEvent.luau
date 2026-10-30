-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local players: Players = game:GetService("Players")
local debris: Debris = game:GetService("Debris")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local ufoEventTimeline = require(shared:WaitForChild("UFOEventTimeline"))
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local bubble: Instance = scriptParent:WaitForChild("Bubble")
local ufo: Instance = replicatedStorage:WaitForChild("UFO", 30)

if ufo == nil then
	warn("[UFOEvent] ReplicatedStorage.UFO missing -- delivery cinematic disabled")

	return
end

local ufoPortal: Instance = replicatedStorage:WaitForChild("UFOPortal", 30)
local ufoStrafe: Instance = replicatedStorage:WaitForChild("UFOStrafe", 30)

if ufoStrafe == nil then
	warn("[UFOEvent] ReplicatedStorage.UFOStrafe missing -- the strafe will have no targets")
end

if ufoPortal == nil then
	warn("[UFOEvent] ReplicatedStorage.UFOPortal missing -- the saucer will appear without its portal")
end

local color3 = Color3.fromRGB(100, 49, 188)
local color32 = Color3.fromRGB(80, 255, 60)
local t1: {[any]: any} = { 1, 7, 0.05, 0.6 }
local t2: {[any]: any} = { 3.2, 5, 0.05, 1.8 }
local n1 = ufoEventTimeline.PRE_ROLL + 3
local t3: {[any]: any} = {
	Name = "Arrive",
	Id = "rbxassetid://138441729132747",
	Volume = 2.2,
	At = ufoEventTimeline.ARRIVE_AT - 8
}
local t4: {[any]: any} = {
	Name = "StrafeCharge",
	Id = "rbxassetid://85564364632042",
	Volume = 1.5,
	At = ufoEventTimeline.STRAFE_CHARGE_AT
}
local t5: {[any]: any} = {
	Name = "StrafeReady",
	Id = "rbxassetid://138980583408901",
	Volume = 1.5,
	At = ufoEventTimeline.STRAFE_READY_AT
}
local t6: {[any]: any} = {
	Name = "UltraA",
	Id = "rbxassetid://122783322605726",
	Volume = 1.5,
	At = ufoEventTimeline.ULTRA_PREP_AT
}
local t7 = {
	Name = "UltraB",
	Id = "rbxassetid://98956298189347",
	Volume = 1.5,
	At = ufoEventTimeline.ULTRA_PREP_AT
}
local t8 = {
	Name = "BeamOn",
	Id = "rbxassetid://103936797076087",
	Volume = 1.5,
	At = ufoEventTimeline.BEAM_AT
}
local t9 = {
	Name = "DropA",
	Id = "rbxassetid://125548416064331",
	Volume = 1.5,
	At = ufoEventTimeline.SHOW_AT
}
local t10 = {
	Name = "DropB",
	Id = "rbxassetid://89830245511743",
	Volume = 1.5,
	At = ufoEventTimeline.SHOW_AT
}
local t11 = {
	Name = "Lower",
	Id = "rbxassetid://76364533358515",
	Volume = 1.5,
	At = ufoEventTimeline.SHOW_AT
}
local soundService: SoundService = game:GetService("SoundService")
local t12: {[any]: any} = {
	ENGINE = "rbxassetid://122649009006870",
	ENGINE_VOLUME = 2.5,
	PORTAL_SPAWN = "rbxassetid://118922543947996",
	PORTAL_SPAWN_VOLUME = 3,
	PORTAL_EXIT = "rbxassetid://92567554554056",
	PORTAL_EXIT_VOLUME = 2.5,
	PORTAL_MIN = 300,
	PORTAL_MAX = 2500,
	RUMBLE = "rbxassetid://91848237125403",
	RUMBLE_BURST = 1.6,
	RUMBLE_SETTLE = 4,
	RUMBLE_MIN = 0.1,
	RUMBLE_MAX = 0.7,
	SHOT = "rbxassetid://8561500387",
	SHOT_VOLUME = 1.5,
	IMPACT = "rbxassetid://109671418379503",
	IMPACT_VOLUME = 0.35,
	LAND_GAS = "rbxassetid://101794759859120",
	LAND_GAS_VOLUME = 0.5,
	WIDE_MIN = 80,
	WIDE_MAX = 1200,
	CUES = {
		t3,
		t4,
		t5,
		t6,
		t7,
		t8,
		t9,
		t10,
		t11
	},
	SHOT_PITCH = { 0.8, 0.7, 0.75 },
	IMPACT_PITCH = { 0.95, 0.85, 1.05 }
}

task.spawn(function()
	local contentProvider: ContentProvider = game:GetService("ContentProvider")
	local t14: {[any]: any} = {
		t12.ENGINE,
		t12.PORTAL_SPAWN,
		t12.PORTAL_EXIT,
		t12.RUMBLE,
		t12.LAND_GAS,
		t12.SHOT,
		t12.IMPACT
	}

	for _, v in ipairs(t12.CUES) do
		table.insert(t14, v.Id)
	end

	local t15: {[any]: any} = {}

	for _, v in ipairs(t14) do
		local sound: Sound = Instance.new("Sound")

		sound.SoundId = v
		table.insert(t15, sound)
	end

	pcall(function()
		contentProvider:PreloadAsync(t15)
	end)

	for _, v in ipairs(t15) do
		v:Destroy()
	end
end)

local alienSky: Instance = replicatedStorage:WaitForChild("AlienSky", 30)
local color33 = Color3.fromRGB(150, 0, 209)
local color34 = Color3.fromRGB(150, 0, 209)
local t13: {[any]: any} = { Density = 0.3, Color = color33, Decay = color34 }
local n2 = ufoEventTimeline.BEAM_GROW + 1
local ufoEventTimelineFly_out = ufoEventTimeline.FLY_OUT
local colorSequenceNew = ColorSequence.new
local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 95, 255))
local colorSequence = colorSequenceNew({
	colorSequenceKeypoint,
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 25, 130))
})

t7 = function(p1)
	local v79 = math.clamp(p1, 0, 1)

	if v79 < 0.5 then
		return v79 ^ 5 * 16
	end

	return 1 - (v79 * -2 + 2) ^ 5 / 2
end
t8 = function(p2)
	local v81 = math.clamp(p2, 0, 1)

	return -(math.cos(3.141592653589793 * v81) - 1) / 2
end
t9 = function(p3)
	return 1 - (1 - math.clamp(p3, 0, 1)) ^ 3
end
t10 = function(p4)
	local v84 = math.clamp(p4, 0, 1)

	return v84 * v84
end
t11 = function(p5)
	local v86 = math.clamp(p5, 0, 1)

	return (v86 - 1) ^ 3 * 2.70158 + 1 + (v86 - 1) ^ 2 * 1.70158
end

local u40 = nil
local n3 = ufoEventTimeline.HOVER - ufoEventTimeline.START

n3 = Vector3.new(n3.X, 0, n3.Z)

local u42 = if n3.Magnitude > 0 then n3.Unit else Vector3.new(0, 0, -1)

n3 = function()
	return LocalPlayer:GetAttribute("InMatch") == true
end

local function matchOwnsLighting()
	if LocalPlayer:GetAttribute("InMatch") == true then
		return true
	end

	if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		return true
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" and lobbySpectateMatchId ~= "PRACTICE" then
		return true
	end

	return false
end

local u44

if LocalPlayer:GetAttribute("InMatch") == true or LocalPlayer:GetAttribute("_WinScreenOpen") == true then
	u44 = true
else
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	u44 = typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" and lobbySpectateMatchId ~= "PRACTICE"
end

local u46 = if u44 then nil else -math.huge

local function refreshLightingOwner()
	local u88

	if LocalPlayer:GetAttribute("InMatch") == true or LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		u88 = true
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		u88 = typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" and lobbySpectateMatchId ~= "PRACTICE"
	end

	if u88 then
		u46 = nil
	elseif u46 == nil then
		u46 = os.clock()
	end
end

for _, v in ipairs({ "InMatch", "_WinScreenOpen", "LobbySpectateMatchId" }) do
	LocalPlayer:GetAttributeChangedSignal(v):Connect(refreshLightingOwner)
end

refreshLightingOwner = function()
	local v90 = u46

	return v90 ~= nil and os.clock() - v90 >= 1
end

local function makeSound(parent, soundId, looped, volume, rollOffMinDistance, rollOffMaxDistance)
	local sound: Sound = Instance.new("Sound")

	sound.SoundId = soundId
	sound.Volume = volume
	sound.Looped = looped
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = rollOffMinDistance
	sound.RollOffMaxDistance = rollOffMaxDistance
	sound.Parent = parent

	return sound
end
local function playCue(p12, p13)
	local anchor = p12.anchor
	local soundId = p13.Id
	local volume = p13.Volume or 1
	local wide_min = t12.WIDE_MIN
	local wide_max = t12.WIDE_MAX
	local sound: Sound = Instance.new("Sound")

	sound.SoundId = soundId
	sound.Volume = volume
	sound.Looped = false
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = wide_min
	sound.RollOffMaxDistance = wide_max
	sound.Parent = anchor
	sound.Name = "Cue_" .. p13.Name
	sound:Play()
	debris:AddItem(sound, 30)
end
local function cameraShake()
	local v106 = _G.Shared and _G.Shared.CamShaker

	if v106 == nil then
		return
	end

	pcall(function()
		v106:ShakeOnce(0.9, 5, 0.1, 1.4)
	end)
end
local function makeSmoke(parent, rate, p16, p17, speed, spreadAngle, emissionDirection)
	local particleEmitter: ParticleEmitter = Instance.new("ParticleEmitter")

	particleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
	particleEmitter.Color = colorSequence

	local numberSequenceNew = NumberSequence.new
	local numberSequenceKeypoint = NumberSequenceKeypoint.new(0, p16)

	particleEmitter.Size = numberSequenceNew({ numberSequenceKeypoint, NumberSequenceKeypoint.new(1, p17) })
	particleEmitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.7),
		NumberSequenceKeypoint.new(0.3, 0.45),
		NumberSequenceKeypoint.new(1, 1)
	})
	particleEmitter.Lifetime = NumberRange.new(2, 3.5)
	particleEmitter.Speed = speed
	particleEmitter.SpreadAngle = spreadAngle
	particleEmitter.EmissionDirection = emissionDirection
	particleEmitter.Rotation = NumberRange.new(-180, 180)
	particleEmitter.RotSpeed = NumberRange.new(-25, 25)
	particleEmitter.Drag = 1.5
	particleEmitter.LightEmission = 0.25
	particleEmitter.LightInfluence = 0.3
	particleEmitter.Rate = rate
	particleEmitter.Enabled = false
	particleEmitter.Parent = parent

	return particleEmitter
end
local function setNight(p21, p22, p23)
	if p21.nightTween then
		p21.nightTween:Cancel()
		p21.nightTween = nil
	end

	local n1 = if p22 then 0 else p21.dayClock

	p21.nightApplied = p22

	local tweenInfo = TweenInfo.new(p23, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local v122: Tween = tweenService:Create(lighting, tweenInfo, { ClockTime = n1 })

	p21.nightTween = v122
	v122:Play()
end
local function setAlienSky(p24, p25)
	if not p25 then
		if p24.alienSky then
			p24.alienSky:Destroy()
			p24.alienSky = nil
		end

		if p24.originalSky and p24.originalSky.Parent == nil then
			if lighting:FindFirstChildOfClass("Sky") == nil then
				p24.originalSky.Parent = lighting
			else
				p24.originalSky:Destroy()
			end
		end

		p24.originalSky = nil
	elseif p24.alienSky == nil and alienSky ~= nil then
		local sky: Instance = lighting:FindFirstChildOfClass("Sky")

		if sky then
			p24.originalSky = sky
			sky.Parent = nil
		end

		local clone: Instance = alienSky:Clone()

		clone.Name = "UFO_AlienSky"
		clone.Parent = lighting
		p24.alienSky = clone

		return
	end
end
local function setAtmosphere(p26, p27, p28)
	if p27 == p26.atmoState then
		return
	end

	local atmosphere: Instance = lighting:FindFirstChildOfClass("Atmosphere")

	if atmosphere == nil then
		return
	end

	p26.atmoState = p27

	if p26.atmoTween then
		p26.atmoTween:Cancel()
		p26.atmoTween = nil
	end

	if p27 and p26.atmoOriginal == nil then
		p26.atmoOriginal = {
			Density = atmosphere.Density,
			Color = atmosphere.Color,
			Decay = atmosphere.Decay
		}
	end

	local v131 = if p27 then t13 else p26.atmoOriginal

	if v131 == nil then
		return
	end

	if p28 then
		atmosphere.Density = v131.Density
		atmosphere.Color = v131.Color
		atmosphere.Decay = v131.Decay

		return
	end

	local tweenInfo = TweenInfo.new(if p27 then 2.5 else 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local v133: Tween = tweenService:Create(atmosphere, tweenInfo, { Density = v131.Density, Color = v131.Color, Decay = v131.Decay })

	p26.atmoTween = v133
	v133:Play()
end
local function setSaucerShown(p29, enabled)
	if enabled == p29.saucerShown then
		return
	end

	p29.saucerShown = enabled

	for _, v in ipairs(p29.model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = if enabled then 0 else 1
		elseif v:IsA("Light") then
			v.Enabled = enabled
		end
	end
end
local function shake(p31, p32, p33, p34)
	local v142
	local u143
	local CurrentCamera
	local n1
	local v146
	local v147
	local n2
	local v149

	v142 = _G.Shared and _G.Shared.CamShaker

	if v142 == nil then
	else
		u143 = p31[1]

		if p32 == nil or p33 == nil or p34 == nil then
			v149 = function()
				v142:ShakeOnce(u143, p31[2], p31[3], p31[4])
			end
			pcall(v149)
		else
			CurrentCamera = workspace.CurrentCamera
			n1 = ((if CurrentCamera then CurrentCamera.CFrame.Position else p32) - p32).Magnitude - p33
			v146 = math.max(1, p34 - p33)
			v147 = math.clamp(n1 / v146, 0, 1)
			n2 = 1 - v147

			if n2 <= 0.02 then
			else
				u143 *= n2
				v149 = function()
					v142:ShakeOnce(u143, p31[2], p31[3], p31[4])
				end
				pcall(v149)
			end
		end
	end
end
local function shotBeam(p35, p36, p37, p38)
	local n1 = p36 - p35
	local magnitude = n1.Magnitude

	if magnitude < 1 then
		return
	end

	local ufo_Shot: Part = Instance.new("Part")

	ufo_Shot.Name = "UFO_Shot"
	ufo_Shot.Shape = Enum.PartType.Cylinder
	ufo_Shot.Material = Enum.Material.Neon
	ufo_Shot.Color = color32
	ufo_Shot.Transparency = 0.1
	ufo_Shot.Anchored = true
	ufo_Shot.CanCollide = false
	ufo_Shot.CanQuery = false
	ufo_Shot.CanTouch = false
	ufo_Shot.CastShadow = false
	ufo_Shot.Size = Vector3.new(magnitude, p37, p37)

	local v157 = CFrame.lookAt(p35 + n1 / 2, p36)
	local v158 = CFrame.Angles(0, 1.5707963267948966, 0)

	ufo_Shot.CFrame = v157 * v158
	ufo_Shot.Parent = workspace

	local tweenInfo = TweenInfo.new(p38, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	tweenService:Create(ufo_Shot, tweenInfo, { Transparency = 1 }):Play()
	debris:AddItem(ufo_Shot, p38 + 0.1)
end
local function fadeOut(p39, p40)
	local function fadePart(p41)
		local tweenInfo = TweenInfo.new(p40)

		tweenService:Create(p41, tweenInfo, { Transparency = 1 }):Play()
	end

	if p39:IsA("BasePart") then
		local tweenInfo = TweenInfo.new(p40)

		tweenService:Create(p39, tweenInfo, { Transparency = 1 }):Play()
	end

	for _, v in ipairs(p39:GetDescendants()) do
		if v:IsA("BasePart") then
			local tweenInfo = TweenInfo.new(p40)

			tweenService:Create(v, tweenInfo, { Transparency = 1 }):Play()
		elseif v:IsA("Light") then
			local tweenInfo = TweenInfo.new(p40)

			tweenService:Create(v, tweenInfo, { Brightness = 0 }):Play()
		elseif v:IsA("ParticleEmitter") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v.Enabled = false
		end
	end

	debris:AddItem(p39, p40 + 0.2)
end
local function fireShot(p42, p43, p44)
	local v171: Instance = ufoStrafe and ufoStrafe:FindFirstChild("Hit" .. p43)

	if v171 == nil or not v171:IsA("BasePart") then
		return
	end

	shotBeam(p44, v171.Position, 4, 0.45)

	local clone: Instance = v171:Clone()

	clone.Name = "UFO_Hit" .. p43
	clone.Parent = workspace
	table.insert(p42.temp, clone)

	local anchor = p42.anchor
	local shot = t12.SHOT
	local shot_volume = t12.SHOT_VOLUME
	local wide_min = t12.WIDE_MIN
	local wide_max = t12.WIDE_MAX
	local sound: Sound = Instance.new("Sound")

	sound.SoundId = shot
	sound.Volume = shot_volume
	sound.Looped = false
	sound.RollOffMode = Enum.RollOffMode.InverseTapered
	sound.RollOffMinDistance = wide_min
	sound.RollOffMaxDistance = wide_max
	sound.Parent = anchor
	sound.Name = "Shot" .. p43
	sound.PlaybackSpeed = t12.SHOT_PITCH[p43] or 1
	sound:Play()
	debris:AddItem(sound, 30)

	local soundId = t12.IMPACT
	local impact_volume = t12.IMPACT_VOLUME
	local rollOffMinDistance = t12.WIDE_MIN
	local rollOffMaxDistance = t12.WIDE_MAX
	local impact: Sound = Instance.new("Sound")

	impact.SoundId = soundId
	impact.Volume = impact_volume
	impact.Looped = false
	impact.RollOffMode = Enum.RollOffMode.InverseTapered
	impact.RollOffMinDistance = rollOffMinDistance
	impact.RollOffMaxDistance = rollOffMaxDistance
	impact.Parent = clone
	impact.Name = "Impact"
	impact.PlaybackSpeed = t12.IMPACT_PITCH[p43] or 1
	impact:Play()
	shake(t1, v171.Position, 60, 260)
	task.delay(1.5, function()
		if clone.Parent ~= nil then
			fadeOut(clone, 3)
		end
	end)
end
local function fireUltra(_, p46)
	local alienSpawn: Instance = ufoStrafe and ufoStrafe:FindFirstChild("AlienSpawn")

	if alienSpawn == nil or not alienSpawn:IsA("BasePart") then
		return
	end

	shotBeam(p46, alienSpawn.Position, 11, 1.3)
	shake(t2, alienSpawn.Position, 90, 420)

	local ufo_UltraFlash: Part = Instance.new("Part")

	ufo_UltraFlash.Name = "UFO_UltraFlash"
	ufo_UltraFlash.Transparency = 1
	ufo_UltraFlash.Anchored = true
	ufo_UltraFlash.CanCollide = false
	ufo_UltraFlash.CanQuery = false
	ufo_UltraFlash.CanTouch = false
	ufo_UltraFlash.Size = Vector3.new(1, 1, 1)
	ufo_UltraFlash.CFrame = CFrame.new(alienSpawn.Position)

	local pointLight: PointLight = Instance.new("PointLight")

	pointLight.Color = color32
	pointLight.Brightness = 12
	pointLight.Range = 120
	pointLight.Shadows = false
	pointLight.Parent = ufo_UltraFlash
	ufo_UltraFlash.Parent = workspace

	local tweenInfo = TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	debris:AddItem(ufo_UltraFlash, 2)
end
local function ensureCharge(p47)
	local charge = p47.charge

	if charge and charge.Parent then
		return charge
	end

	local ufo_Charge: Part = Instance.new("Part")

	ufo_Charge.Name = "UFO_Charge"
	ufo_Charge.Shape = Enum.PartType.Ball
	ufo_Charge.Material = Enum.Material.Neon
	ufo_Charge.Color = color32
	ufo_Charge.Transparency = 0.25
	ufo_Charge.Anchored = true
	ufo_Charge.CanCollide = false
	ufo_Charge.CanQuery = false
	ufo_Charge.CanTouch = false
	ufo_Charge.CastShadow = false
	ufo_Charge.Size = Vector3.new(1, 1, 1)

	local pointLight: PointLight = Instance.new("PointLight")

	pointLight.Color = color32
	pointLight.Brightness = 4
	pointLight.Range = 60
	pointLight.Shadows = false
	pointLight.Parent = ufo_Charge
	ufo_Charge.Parent = workspace
	p47.charge = ufo_Charge
	table.insert(p47.temp, ufo_Charge)

	return ufo_Charge
end
local function stop()
	local v194 = u40

	u40 = nil

	if v194 then
		v194.conn:Disconnect()

		if v194.nightTween then
			v194.nightTween:Cancel()
		end

		if v194.nightApplied then
			lighting.ClockTime = v194.dayClock
		end

		if v194.alienSky then
			v194.alienSky:Destroy()
			v194.alienSky = nil
		end

		if v194.originalSky and v194.originalSky.Parent == nil then
			if lighting:FindFirstChildOfClass("Sky") == nil then
				v194.originalSky.Parent = lighting
			else
				v194.originalSky:Destroy()
			end
		end

		v194.originalSky = nil

		if v194.atmoState ~= false then
			local atmosphere: Instance = lighting:FindFirstChildOfClass("Atmosphere")

			if atmosphere ~= nil then
				v194.atmoState = false

				if v194.atmoTween then
					v194.atmoTween:Cancel()
					v194.atmoTween = nil
				end

				local atmoOriginal = v194.atmoOriginal

				if atmoOriginal ~= nil then
					atmosphere.Density = atmoOriginal.Density
					atmosphere.Color = atmoOriginal.Color
					atmosphere.Decay = atmoOriginal.Decay
				end
			end
		end

		v194.model:Destroy()
		v194.beam:Destroy()
		v194.foot:Destroy()

		if v194.portal then
			v194.portal:Destroy()
		end

		for _, v in ipairs(v194.temp) do
			v:Destroy()
		end
	end

	bubble:SetAttribute("UfoLift", nil)
	soundService:SetAttribute("MusicDuck", nil)
end
local function step()
	local v199 = u40

	if v199 == nil then
		return
	end

	local n13 = workspace:GetServerTimeNow() - v199.startAt

	if n13 >= ufoEventTimeline.TOTAL or not bubble.Parent then
		stop()

		return
	end

	if n13 < 0 then
		return
	end

	local portal = v199.portal

	if portal then
		local n14 = 1

		if n13 < 0.8 then
			local v203 = math.clamp(n13 / 0.8, 0, 1)

			n14 = (v203 - 1) ^ 3 * 2.70158 + 1 + (v203 - 1) ^ 2 * 1.70158
		elseif n13 >= n1 then
			local v204 = math.clamp((n13 - n1) / 0.6, 0, 1)

			n14 = 1 - v204 * v204
		end

		if n14 <= 0.02 then
			portal:Destroy()
			v199.portal = nil
		else
			portal.Size = Vector3.new(v199.portalSize.X * n14, v199.portalSize.Y, v199.portalSize.Z * n14)

			local portalBase = v199.portalBase
			local cFrameAngles = CFrame.Angles
			local v207 = math.rad(30 * n13)
			local v208 = cFrameAngles(0, v207, 0)

			portal.CFrame = portalBase * v208
		end
	end

	local v210

	if n13 < ufoEventTimeline.ARRIVE_AT then
		local ufoEventTimelineStart = ufoEventTimeline.START
		local ufoEventTimelineHover = ufoEventTimeline.HOVER
		local v213 = math.clamp((n13 - ufoEventTimeline.PRE_ROLL) / ufoEventTimeline.FLY_IN, 0, 1)

		v210 = ufoEventTimelineStart:Lerp(ufoEventTimelineHover, if v213 < 0.5 then v213 ^ 5 * 16 else 1 - (v213 * -2 + 2) ^ 5 / 2)
	elseif n13 < ufoEventTimeline.LEAVE_AT then
		local hover = ufoEventTimeline.HOVER
		local sine = math.sin(n13 * 1.3)
		local vector3 = Vector3.new(0, sine * 1.2, 0)

		v210 = hover + vector3
	else
		local v217 = math.clamp((n13 - ufoEventTimeline.LEAVE_AT) / ufoEventTimeline.FLY_OUT, 0, 1)
		local n3 = v217 * v217

		v217 = ufoEventTimeline.HOVER + u42 * (n3 * 700)

		local vector3 = Vector3.new(0, n3 * 180, 0)

		v210 = v217 + vector3
	end

	local v219 = math.rad(40 * n13)
	local model = v199.model
	local cFrame = CFrame.new(v210)
	local v222 = CFrame.Angles(0, v219, 0)

	model:PivotTo(cFrame * v222 * v199.rotation)
	setSaucerShown(v199, n13 >= ufoEventTimeline.PRE_ROLL)
	v219 = if n13 < ufoEventTimeline.PRE_ROLL then 0.12 else (1 - (1 - math.clamp((n13 - ufoEventTimeline.PRE_ROLL) / 1.6, 0, 1)) ^ 3) * 0.88 + 0.12

	if math.abs(v219 - v199.scale) > 0.002 then
		v199.scale = v219
		v199.model:ScaleTo(v219)
	end

	local n4

	if n13 < t12.RUMBLE_SETTLE then
		local rumble_burst = t12.RUMBLE_BURST
		local n5 = t12.RUMBLE_MIN - t12.RUMBLE_BURST
		local v226 = math.clamp(n13 / t12.RUMBLE_SETTLE, 0, 1)

		n4 = rumble_burst + n5 * (1 - (1 - v226) ^ 3)
	elseif n13 < ufoEventTimeline.ARRIVE_AT then
		local rumble_min = t12.RUMBLE_MIN
		local n6 = t12.RUMBLE_MAX - t12.RUMBLE_MIN
		local v228 = math.clamp((n13 - ufoEventTimeline.PRE_ROLL) / ufoEventTimeline.FLY_IN, 0, 1)

		n4 = rumble_min + n6 * (if v228 < 0.5 then v228 ^ 5 * 16 else 1 - (v228 * -2 + 2) ^ 5 / 2)
	else
		n4 = if n13 < ufoEventTimeline.LEAVE_AT then t12.RUMBLE_MAX else t12.RUMBLE_MAX * (1 - math.clamp((n13 - ufoEventTimeline.LEAVE_AT) / ufoEventTimeline.FLY_OUT, 0, 1))
	end

	v199.rumble.Volume = n4

	local n7 = v210.Y + v199.bottomOffset

	v219 = math.max(0, n7 - v199.groundY)

	local n8 = 0

	if n13 >= ufoEventTimeline.BEAM_AT and n13 < ufoEventTimeline.SHOW_AT then
		local v231 = math.clamp((n13 - ufoEventTimeline.BEAM_AT) / ufoEventTimeline.BEAM_GROW, 0, 1)

		n8 = v219 * (1 - (1 - v231) ^ 3)
	elseif n13 >= ufoEventTimeline.SHOW_AT and n13 < ufoEventTimeline.LANDED_AT + ufoEventTimeline.HOLD then
		n8 = v219
	elseif n13 >= ufoEventTimeline.LANDED_AT + ufoEventTimeline.HOLD and n13 < ufoEventTimeline.LEAVE_AT then
		n8 = v219 * (1 - (n13 - (ufoEventTimeline.LANDED_AT + ufoEventTimeline.HOLD)) / ufoEventTimeline.BEAM_SHRINK)
	end

	local u232 = n8 > 0.5

	if not u232 then
		v199.beam.Transparency = 1
	else
		v199.beam.Size = Vector3.new(n8, 22, 22)

		local beam = v199.beam
		local cFrame2 = CFrame.new(v210.X, n7 - n8 / 2, v210.Z)
		local v235 = CFrame.Angles(0, 0, 1.5707963267948966)

		beam.CFrame = cFrame2 * v235
		v199.beam.Transparency = math.sin(n13 * 6) * 0.08 + 0.55
	end

	v199.beamSmoke.Enabled = u232

	local beamLight = v199.beam:FindFirstChild("BeamLight")

	if beamLight and beamLight:IsA("PointLight") then
		beamLight.Enabled = u232
	end

	v199.foot.CFrame = CFrame.new(v210.X, v199.groundY + 0.5, v210.Z)
	v222 = u232

	if v222 then
		v222 = false

		if n8 >= v219 * 0.9 then
			v222 = n13 < ufoEventTimeline.LANDED_AT
		end
	end

	v199.footSmoke.Enabled = v222

	local footLight = v199.foot:FindFirstChild("FootLight")

	if footLight and footLight:IsA("PointLight") then
		footLight.Enabled = u232
		footLight.Brightness = math.clamp(if v219 > 0 then n8 / v219 else 0, 0, 1) * 8
	end

	local n9 = n7 - bubble.Size.Y / 2 - v199.restCentreY

	u232 = nil

	if n13 < ufoEventTimeline.SHOW_AT then
		u232 = n9
	elseif n13 < ufoEventTimeline.LANDED_AT then
		local v239 = math.clamp((n13 - ufoEventTimeline.SHOW_AT) / ufoEventTimeline.DROP, 0, 1)
		local cosine = math.cos(3.141592653589793 * v239)

		u232 = n9 * (1 - -(cosine - 1) / 2)
	end

	bubble:SetAttribute("UfoLift", u232)

	local n10 = if LocalPlayer:GetAttribute("InMatch") == true then 1 else if n13 < 1.5 then 1 - -(math.cos(3.141592653589793 * math.clamp(n13 / 1.5, 0, 1)) - 1) / 2 else if n13 < ufoEventTimeline.TOTAL - 3 then 0 else -(math.cos(3.141592653589793 * math.clamp((n13 - (ufoEventTimeline.TOTAL - 3)) / 3, 0, 1)) - 1) / 2

	n9 = os.clock()

	if n9 - v199.duckWroteAt >= 0.1 or n10 == 1 or n10 == 0 then
		v199.duckWroteAt = n9

		if soundService:GetAttribute("MusicDuck") ~= n10 then
			soundService:SetAttribute("MusicDuck", n10)
		end
	end

	local vector3 = Vector3.new(v210.X, n7, v210.Z)

	for i, v in ipairs(ufoEventTimeline.SHOT_AT) do
		local s1: string = "Shot" .. i

		if not v199.fired[s1] and n13 >= v then
			v199.fired[s1] = true

			if n13 - v < 1.5 then
				fireShot(v199, i, vector3)
			end
		end
	end

	if n13 >= ufoEventTimeline.ULTRA_PREP_AT and n13 < ufoEventTimeline.ALIEN_AT then
		local n11 = (n13 - ufoEventTimeline.ULTRA_PREP_AT) / ufoEventTimeline.ULTRA_FIRE_DELAY
		local v247 = ensureCharge(v199)
		local n12 = 0.5 + 8.5 * (n11 * n11)

		v247.Size = Vector3.new(n12, n12, n12)

		local cFrameNew = CFrame.new
		local vector32 = Vector3.new(0, n12 / 2, 0)

		v247.CFrame = cFrameNew(vector3 - vector32)
		v247.Transparency = math.sin(n13 * 20) * 0.1 + 0.25
	elseif v199.charge and v199.charge.Parent then
		v199.charge:Destroy()
		v199.charge = nil
	end

	if not v199.fired.Ultra and n13 >= ufoEventTimeline.ALIEN_AT then
		v199.fired.Ultra = true

		if n13 - ufoEventTimeline.ALIEN_AT < 1.5 then
			fireUltra(v199, vector3)
		end
	end

	if not v199.fired.Landed and n13 >= ufoEventTimeline.LANDED_AT then
		v199.fired.Landed = true

		if n13 - ufoEventTimeline.LANDED_AT < 1.5 then
			v199.landSmoke:Emit(45)

			local foot = v199.foot
			local land_gas = t12.LAND_GAS
			local land_gas_volume = t12.LAND_GAS_VOLUME
			local wide_min = t12.WIDE_MIN
			local wide_max = t12.WIDE_MAX
			local landGas: Sound = Instance.new("Sound")

			landGas.SoundId = land_gas
			landGas.Volume = land_gas_volume
			landGas.Looped = false
			landGas.RollOffMode = Enum.RollOffMode.InverseTapered
			landGas.RollOffMinDistance = wide_min
			landGas.RollOffMaxDistance = wide_max
			landGas.Parent = foot
			landGas.Name = "LandGas"
			landGas:Play()
			debris:AddItem(landGas, 30)
		end
	end

	v199.landSmoke.Enabled = n13 >= ufoEventTimeline.LANDED_AT and n13 < ufoEventTimeline.LANDED_AT + 3

	if not v199.fired.PortalExit and n13 >= ufoEventTimeline.PRE_ROLL then
		v199.fired.PortalExit = true

		if n13 - ufoEventTimeline.PRE_ROLL < 1.5 then
			local parent = v199.portal or v199.anchor
			local portal_exit = t12.PORTAL_EXIT
			local portal_exit_volume = t12.PORTAL_EXIT_VOLUME
			local portal_min = t12.PORTAL_MIN
			local portal_max = t12.PORTAL_MAX
			local portalExit: Sound = Instance.new("Sound")

			portalExit.SoundId = portal_exit
			portalExit.Volume = portal_exit_volume
			portalExit.Looped = false
			portalExit.RollOffMode = Enum.RollOffMode.InverseTapered
			portalExit.RollOffMinDistance = portal_min
			portalExit.RollOffMaxDistance = portal_max
			portalExit.Parent = parent
			portalExit.Name = "PortalExit"
			portalExit:Play()

			local taskDelay = task.delay
			local v264 = math.max(0, n1 - n13 - 0.1)

			taskDelay(v264, function()
				if portalExit.Parent ~= nil and portalExit.Parent ~= v199.anchor then
					portalExit.Parent = v199.anchor
				end
			end)
			debris:AddItem(portalExit, 30)
		end
	end

	for _, v in ipairs(t12.CUES) do
		if not v199.fired[v.Name] and n13 >= v.At then
			v199.fired[v.Name] = true

			if n13 - v.At < 1.5 then
				local anchor = v199.anchor
				local vId = v.Id
				local volume = v.Volume or 1
				local rollOffMinDistance = t12.WIDE_MIN
				local rollOffMaxDistance = t12.WIDE_MAX
				local sound: Sound = Instance.new("Sound")

				sound.SoundId = vId
				sound.Volume = volume
				sound.Looped = false
				sound.RollOffMode = Enum.RollOffMode.InverseTapered
				sound.RollOffMinDistance = rollOffMinDistance
				sound.RollOffMaxDistance = rollOffMaxDistance
				sound.Parent = anchor
				sound.Name = "Cue_" .. v.Name
				sound:Play()
				debris:AddItem(sound, 30)
			end
		end
	end

	v222 = u46
	n10 = v222 ~= nil and os.clock() - v222 >= 1

	if not n10 then
		if v199.alienSky then
			v199.alienSky:Destroy()
			v199.alienSky = nil
		end

		if v199.originalSky and v199.originalSky.Parent == nil then
			if lighting:FindFirstChildOfClass("Sky") == nil then
				v199.originalSky.Parent = lighting
			else
				v199.originalSky:Destroy()
			end
		end

		v199.originalSky = nil

		if v199.atmoState ~= false then
			local atmosphere: Instance = lighting:FindFirstChildOfClass("Atmosphere")

			if atmosphere ~= nil then
				v199.atmoState = false

				if v199.atmoTween then
					v199.atmoTween:Cancel()
					v199.atmoTween = nil
				end

				local atmoOriginal = v199.atmoOriginal

				if atmoOriginal ~= nil then
					atmosphere.Density = atmoOriginal.Density
					atmosphere.Color = atmoOriginal.Color
					atmosphere.Decay = atmoOriginal.Decay
				end
			end
		end
	else
		setAlienSky(v199, n13 < ufoEventTimeline.TOTAL - 1.5)
		setAtmosphere(v199, n13 < ufoEventTimeline.TOTAL - 3)
	end

	if n10 then
		if not v199.fired.NightIn and n13 >= ufoEventTimeline.BEAM_AT and n13 < ufoEventTimeline.LEAVE_AT then
			v199.fired.NightIn = true
			v199.dayClock = lighting.ClockTime
			setNight(v199, true, n2)
		end

		if not v199.fired.NightOut and n13 >= ufoEventTimeline.LEAVE_AT then
			v199.fired.NightOut = true

			if v199.nightApplied then
				setNight(v199, false, ufoEventTimelineFly_out)
			end
		end
	elseif v199.nightApplied then
		if v199.nightTween then
			v199.nightTween:Cancel()
			v199.nightTween = nil
		end

		lighting.ClockTime = v199.dayClock
		v199.nightApplied = false
		v199.fired.NightIn = true
		v199.fired.NightOut = true

		return
	end
end
local function start(p48)
	stop()

	local clone: Instance = ufo:Clone()

	clone.Name = "UFO_Delivery"
	clone.Parent = workspace

	local pivot = clone:GetPivot()
	local v278, v279 = clone:GetBoundingBox()
	local n1 = v278.Position.Y - v279.Y / 2 - pivot.Position.Y
	local v281 = clone.PrimaryPart

	if not v281 then
		v281 = clone:FindFirstChildWhichIsA("BasePart")
	end

	local ufo_TractorBeam: Part = Instance.new("Part")

	ufo_TractorBeam.Name = "UFO_TractorBeam"
	ufo_TractorBeam.Shape = Enum.PartType.Cylinder
	ufo_TractorBeam.Material = Enum.Material.Neon
	ufo_TractorBeam.Color = color3
	ufo_TractorBeam.Transparency = 1
	ufo_TractorBeam.Anchored = true
	ufo_TractorBeam.CanCollide = false
	ufo_TractorBeam.CanQuery = false
	ufo_TractorBeam.CanTouch = false
	ufo_TractorBeam.CastShadow = false
	ufo_TractorBeam.Size = Vector3.new(1, 22, 22)
	ufo_TractorBeam.Parent = workspace

	local beamLight: PointLight = Instance.new("PointLight")

	beamLight.Name = "BeamLight"
	beamLight.Color = color3
	beamLight.Brightness = 6
	beamLight.Range = 120
	beamLight.Shadows = false
	beamLight.Enabled = false
	beamLight.Parent = ufo_TractorBeam

	local ufo_BeamFoot: Part = Instance.new("Part")

	ufo_BeamFoot.Name = "UFO_BeamFoot"
	ufo_BeamFoot.Transparency = 1
	ufo_BeamFoot.Anchored = true
	ufo_BeamFoot.CanCollide = false
	ufo_BeamFoot.CanQuery = false
	ufo_BeamFoot.CanTouch = false
	ufo_BeamFoot.CastShadow = false
	ufo_BeamFoot.Size = Vector3.new(17.6, 1, 17.6)
	ufo_BeamFoot.Parent = workspace

	local footLight: PointLight = Instance.new("PointLight")

	footLight.Name = "FootLight"
	footLight.Color = color3
	footLight.Brightness = 8
	footLight.Range = 120
	footLight.Shadows = false
	footLight.Enabled = false
	footLight.Parent = ufo_BeamFoot

	local beamSmoke = makeSmoke(ufo_TractorBeam, 22, 5, 9, NumberRange.new(2, 5), Vector2.new(15, 15), Enum.NormalId.Right)

	beamSmoke.Name = "BeamSmoke"
	beamSmoke.Shape = Enum.ParticleEmitterShape.Box
	beamSmoke.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume

	local footSmoke = makeSmoke(ufo_BeamFoot, 45, 6, 12, NumberRange.new(8, 14), Vector2.new(85, 85), Enum.NormalId.Top)

	footSmoke.Name = "FootSmoke"
	footSmoke.Acceleration = Vector3.new(0, 2, 0)
	footSmoke.Shape = Enum.ParticleEmitterShape.Disc
	footSmoke.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume

	local landSmoke = makeSmoke(ufo_BeamFoot, 40, 7, 15, NumberRange.new(10, 18), Vector2.new(80, 80), Enum.NormalId.Top)

	landSmoke.Name = "LandSmoke"
	landSmoke.Lifetime = NumberRange.new(2.5, 4)
	landSmoke.Acceleration = Vector3.new(0, 1, 0)

	local colorSequenceNew = ColorSequence.new
	local colorSequenceKeypoint2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(205, 140, 255))

	landSmoke.Color = colorSequenceNew({
		colorSequenceKeypoint2,
		ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 150))
	})
	landSmoke.Shape = Enum.ParticleEmitterShape.Disc
	landSmoke.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume

	local v291 = nil
	local cFrame = CFrame.new()
	local vectorValue = Vector3.new(1, 1, 1)

	if ufoPortal then
		local clone2: Instance = ufoPortal:Clone()

		clone2.Name = "UFO_Portal"
		cFrame = clone2.CFrame
		vectorValue = clone2.Size
		clone2.Size = Vector3.new(vectorValue.X * 0.02, vectorValue.Y, vectorValue.Z * 0.02)
		clone2.Parent = workspace
		v291 = clone2

		local portal_spawn = t12.PORTAL_SPAWN
		local portal_spawn_volume = t12.PORTAL_SPAWN_VOLUME
		local portal_min = t12.PORTAL_MIN
		local portal_max = t12.PORTAL_MAX
		local portalSpawn: Sound = Instance.new("Sound")

		portalSpawn.SoundId = portal_spawn
		portalSpawn.Volume = portal_spawn_volume
		portalSpawn.Looped = false
		portalSpawn.RollOffMode = Enum.RollOffMode.InverseTapered
		portalSpawn.RollOffMinDistance = portal_min
		portalSpawn.RollOffMaxDistance = portal_max
		portalSpawn.Parent = clone2
		portalSpawn.Name = "PortalSpawn"
		portalSpawn:Play()
	end

	local u300

	if LocalPlayer:GetAttribute("InMatch") == true or LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		u300 = true
	else
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

		u300 = typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" and lobbySpectateMatchId ~= "PRACTICE"
	end

	if not u300 and workspace:GetServerTimeNow() - p48 < 1.5 and (_G.Shared and _G.Shared.CamShaker) ~= nil then
		pcall(function()
			v319:ShakeOnce(0.9, 5, 0.1, 1.4)
		end)
	end

	local soundId = t12.ENGINE
	local engine_volume = t12.ENGINE_VOLUME
	local wide_min = t12.WIDE_MIN
	local wide_max = t12.WIDE_MAX
	local engine: Sound = Instance.new("Sound")

	engine.SoundId = soundId
	engine.Volume = engine_volume
	engine.Looped = true
	engine.RollOffMode = Enum.RollOffMode.InverseTapered
	engine.RollOffMinDistance = wide_min
	engine.RollOffMaxDistance = wide_max
	engine.Parent = v281
	engine.Name = "Engine"
	engine:Play()

	local v307 = t12.RUMBLE
	local rumble_burst = t12.RUMBLE_BURST
	local rollOffMinDistance = t12.WIDE_MIN
	local rollOffMaxDistance = t12.WIDE_MAX
	local rumble: Sound = Instance.new("Sound")

	rumble.SoundId = v307
	rumble.Volume = rumble_burst
	rumble.Looped = true
	rumble.RollOffMode = Enum.RollOffMode.InverseTapered
	rumble.RollOffMinDistance = rollOffMinDistance
	rumble.RollOffMaxDistance = rollOffMaxDistance
	rumble.Parent = v281
	rumble.Name = "Rumble"
	rumble:Play()

	local y = bubble.Position.Y
	local numberValue: number? = tonumber(bubble:GetAttribute("UfoLift"))
	local n2 = y - (numberValue or 0)
	local connection = runService.RenderStepped:Connect(step)
	u40 = {
		saucerShown = nil,
		scale = 1,
		duckWroteAt = -math.huge,
		charge = nil,
		nightTween = nil,
		nightApplied = false,
		originalSky = nil,
		alienSky = nil,
		atmoOriginal = nil,
		atmoTween = nil,
		atmoState = nil,
		model = clone,
		anchor = v281,
		beam = ufo_TractorBeam,
		foot = ufo_BeamFoot,
		beamSmoke = beamSmoke,
		footSmoke = footSmoke,
		landSmoke = landSmoke,
		engine = engine,
		rumble = rumble,
		portal = v291,
		portalBase = cFrame,
		portalSize = vectorValue,
		conn = connection,
		startAt = p48,
		rotation = pivot.Rotation,
		bottomOffset = n1,
		groundY = n2 - bubble.Size.Y / 2,
		restCentreY = n2,
		fired = {},
		temp = {},
		dayClock = lighting.ClockTime
	}
	step()
end
local function sync()
	local attributeValue: any = scriptParent:GetAttribute(ufoEventTimeline.ATTR)

	if typeof(attributeValue) == "number" then
		if workspace:GetServerTimeNow() - attributeValue >= ufoEventTimeline.TOTAL then
			stop()
		elseif u40 == nil or attributeValue ~= u40.startAt then
			start(attributeValue)

			return
		end

		return
	end

	stop()
end

scriptParent:GetAttributeChangedSignal(ufoEventTimeline.ATTR):Connect(sync)
sync()
