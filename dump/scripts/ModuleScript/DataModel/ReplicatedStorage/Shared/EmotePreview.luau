-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local soundService: SoundService = game:GetService("SoundService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local players: Players = game:GetService("Players")
local emoteCatalog = require(script.Parent:WaitForChild("EmoteCatalog"))
local emoteClient = require(script.Parent:WaitForChild("EmoteClient"))
local emoteProps = require(script.Parent:WaitForChild("EmoteProps"))
local color3 = Color3.fromRGB(159, 161, 172)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local emotePreviewCache: Folder = Instance.new("Folder")

emotePreviewCache.Name = "EmotePreviewCache"
emotePreviewCache.Parent = soundService

local t3: {[any]: any} = {}

for k, v in pairs(emoteCatalog.Defs) do
	if typeof(v.Anim) == "number" and v.Anim > 0 then
		local animation: Animation = Instance.new("Animation")

		animation.Name = "Anim_" .. k
		animation.AnimationId = "rbxassetid://" .. tostring(v.Anim)
		animation.Parent = emotePreviewCache
		t2[k] = animation
		table.insert(t3, animation)
	end

	local t4 = if typeof(v.Sfx) == "number" then { v.Sfx } else if typeof(v.Sfx) == "table" then v.Sfx else {}

	for i, iterValue in ipairs(t4) do
		local sound: Sound = Instance.new("Sound")

		sound.Name = "Sfx_" .. k .. "_" .. i
		sound.SoundId = "rbxassetid://" .. tostring(iterValue)
		sound.Volume = 0
		sound.Parent = emotePreviewCache
		t1[k] = t1[k] or {}
		table.insert(t1[k], sound)
		table.insert(t3, sound)
	end
end

task.spawn(function()
	pcall(function()
		contentProvider:PreloadAsync(t3)
	end)
end)

local function sfxMult()
	local sfxVolume: any = soundService:GetAttribute("SFXVolume")

	if typeof(sfxVolume) == "number" then
		return sfxVolume
	end

	return 1
end

local u22 = nil
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local module: {[any]: any} = { AvatarChanged = bindableEvent.Event }
local t6: {[any]: any} = {
	KnifeRig = true,
	KnifeRig_L = true,
	KnifeRig_R = true,
	RevolverRig = true
}

local function prepRig(character)
	for _, v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = 0
			v.CastShadow = false
			v.Anchored = false
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
		end
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.Anchored = true
		character.PrimaryPart = humanoidRootPart
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff

		if not humanoid:FindFirstChildOfClass("Animator") then
			local animator: Animator = Instance.new("Animator")

			animator.Parent = humanoid
		end
	end
end
local function captureAvatar(character)
	if not character or not character.Parent then
		return
	end

	if not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
		return
	end

	local archivable = character.Archivable

	character.Archivable = true

	local ok, result = pcall(character.Clone, character)

	character.Archivable = archivable

	if ok and result then
		result.Name = "EmotePreviewAvatar"

		for _, v in ipairs(result:GetDescendants()) do
			if v.Parent ~= nil and (v:IsA("LuaSourceContainer") or v:IsA("Sound") or v:IsA("Tool") or v:IsA("ForceField") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Highlight") or v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or t6[v.Name] or v.Name:sub(1, 10) == "EmoteProp_") then
				v:Destroy()
			end
		end

		for iterKey in pairs(result:GetAttributes()) do
			result:SetAttribute(iterKey, nil)
		end

		if u22 then
			u22:Destroy()
		end

		u22 = result
		bindableEvent:Fire()

		return
	end
end

local u28: boolean = false
local LocalPlayer: Player = players.LocalPlayer

if LocalPlayer.Character then
	local Character: Model = LocalPlayer.Character

	task.defer(function()
		if not u28 and Character.Parent then
			captureAvatar(Character)
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function(character: Model)
	task.defer(function()
		if not u28 and character.Parent then
			captureAvatar(character)
		end
	end)
end)
LocalPlayer.CharacterAppearanceLoaded:Connect(function(character: Model)
	if not u28 then
		captureAvatar(character)
	end
end)

local function adoptServerAvatar(p5)
	if not p5:IsA("Model") then
		return
	end

	local clone = p5:Clone()

	clone.Name = "EmotePreviewAvatar"

	if u22 then
		u22:Destroy()
	end

	u22 = clone
	u28 = true
	bindableEvent:Fire()
end

task.spawn(function()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
	local emoteAvatar: Instance = playerGui:FindFirstChild("EmoteAvatar")

	if emoteAvatar and emoteAvatar:IsA("Model") then
		local clone: Instance = emoteAvatar:Clone()

		clone.Name = "EmotePreviewAvatar"

		if u22 then
			u22:Destroy()
		end

		u22 = clone
		u28 = true
		bindableEvent:Fire()
	end

	playerGui.ChildAdded:Connect(function(p6: Instance)
		if p6.Name == "EmoteAvatar" then
			if not p6:IsA("Model") then
				return
			end

			local clone: Instance = p6:Clone()

			clone.Name = "EmotePreviewAvatar"

			if u22 then
				u22:Destroy()
			end

			u22 = clone
			u28 = true
			bindableEvent:Fire()

			return
		end
	end)
end)

local function buildGreyRig()
	local clone: Instance = replicatedStorage:WaitForChild("Dummy"):Clone()

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("Accessory") or v:IsA("Clothing") or v:IsA("BodyColors") or v:IsA("Decal") or v:IsA("Script") or v:IsA("LocalScript") or v:IsA("TouchTransmitter") then
			v:Destroy()
		end
	end

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Color = color3
			v.Material = Enum.Material.SmoothPlastic
		end
	end

	return clone
end
function module.BuildRig(p7)
	local emotePreviewRig = if p7 and u22 then u22:Clone() else buildGreyRig()

	emotePreviewRig.Name = "EmotePreviewRig"
	prepRig(emotePreviewRig)

	return emotePreviewRig
end

local u33 = nil
local n1: number = 0

function module.StopStage()
	local v72 = u33

	if not v72 then
		return
	end

	u33 = nil
	n1 += 1

	if v72.sound then
		v72.sound:Stop()
		v72.sound:Destroy()
	end

	if v72.cancelProp then
		v72.cancelProp()
	end

	if v72.track then
		v72.track:Stop(0)
	end

	if v72.rig then
		v72.rig:Destroy()
	end

	if typeof(v72.def.MusicDuck) == "number" then
		emoteClient.DuckMusic(nil)
	end
end
function module.StartStage(p8, p9, p10)
	module.StopStage()

	local v76 = emoteCatalog.Get(p9)

	if not v76 then
		return
	end

	n1 += 1

	local v77 = n1
	local emotePreviewRig = if u22 then u22:Clone() else buildGreyRig()

	emotePreviewRig.Name = "EmotePreviewRig"
	prepRig(emotePreviewRig)
	emotePreviewRig:PivotTo(p8)
	emotePreviewRig.Parent = p10 or workspace:FindFirstChild("Bin") or workspace

	local t8: {[any]: any} = {
		track = nil,
		sound = nil,
		rig = emotePreviewRig,
		def = v76,
		session = v77
	}

	u33 = t8
	v77 = t1[v76.Id]

	local v80 = v77

	if v80 then
		local randomNumber = math.random(1, #v77)

		v80 = v77[randomNumber]
	end

	if v80 then
		local clone = v80:Clone()

		clone.Name = "EmoteStageSfx"

		local v83 = v76.SfxVolume or 0.5
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local typeName: string = typeof(sfxVolume)

		clone.Volume = v83 * (if typeName == "number" then sfxVolume else 1)

		local v86 = v76.Loop

		if v86 then
			v86 = typeof(v76.SfxFadeOutAt) ~= "number"
		end

		clone.Looped = v86
		clone.PlaybackSpeed = if typeof(v76.SfxPitch) == "number" then v76.SfxPitch else 1
		clone.Parent = emotePreviewRig:FindFirstChild("HumanoidRootPart") or emotePreviewRig
		t8.sound = clone
	end

	local function play()
		if u33 ~= t8 then
			return
		end

		local track = t8.track

		if not track then
			return
		end

		track:Play(0.1, 1, emoteCatalog.AnimSpeed(v76))

		if emoteProps.HasCue(v76) then
			if t8.cancelProp then
				t8.cancelProp()
			end

			t8.cancelProp = emoteProps.Cue(emotePreviewRig, v76, function()
				return u33 == t8
			end)
		end

		if t8.sound then
			t8.sound.TimePosition = 0
			t8.sound:Play()
		end

		if typeof(v76.MusicDuck) == "number" then
			emoteClient.DuckMusic(v76.MusicDuck)
		end
	end

	task.spawn(function()
		local v150 = t2[v76.Id]
		local humanoid = emotePreviewRig:FindFirstChildOfClass("Humanoid")
		local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

		if v150 and animator then
			local ok, result = pcall(function()
				return animator:LoadAnimation(v150)
			end)

			if ok and result and u33 == t8 then
				result.Priority = Enum.AnimationPriority.Action
				result.Looped = v76.Loop
				t8.track = result

				if not v76.Loop then
					result.Stopped:Connect(function()
						if u33 ~= t8 then
							return
						end

						task.delay(1.5, play)
					end)
				elseif emoteProps.HasCue(v76) then
					result.DidLoop:Connect(function()
						if u33 ~= t8 then
							return
						end

						if t8.cancelProp then
							t8.cancelProp()
						end

						t8.cancelProp = emoteProps.Cue(emotePreviewRig, v76, function()
							return u33 == t8
						end)
					end)
				end

				play()

				return
			end

			return
		end
	end)
end
local function hostOnScreen(p11)
	if not p11.Parent then
		return false
	end

	local v89 = p11

	while v89 do
		if v89:IsA("ScreenGui") then
			return v89.Enabled and v89:IsDescendantOf(players.LocalPlayer)
		end

		if v89:IsA("GuiObject") and not v89.Visible then
			return false
		end

		v89 = v89.Parent
	end

	return false
end

local t7: {[any]: any} = {}

t7.__index = t7

local function stopSound(p12)
	if p12.sound then
		p12.sound:Stop()
	end

	if p12.opts.duck and typeof(p12.def.MusicDuck) == "number" then
		emoteClient.DuckMusic(nil)
	end
end
local function startSound(p13)
	local sound = p13.sound

	if not sound then
		return
	end

	local sfxVolume: any = soundService:GetAttribute("SFXVolume")
	local v94 = if typeof(sfxVolume) == "number" then sfxVolume else 1

	if v94 <= 0 then
		return
	end

	sound.Volume = (p13.def.SfxVolume or 0.5) * v94 * 0.5
	sound.TimePosition = 0

	local sfxFadeOutAt = p13.def.SfxFadeOutAt

	if typeof(sfxFadeOutAt) == "number" and sfxFadeOutAt > 0 then
		p13.fadeGen = (p13.fadeGen or 0) + 1

		local fadeGen = p13.fadeGen
		local v97 = if typeof(p13.def.SfxFadeTime) == "number" then p13.def.SfxFadeTime else 0.5
		local taskDelay = task.delay
		local v99 = emoteCatalog.AnimSpeed(p13.def)

		taskDelay(sfxFadeOutAt / v99, function()
			if p13.alive and fadeGen == p13.fadeGen then
				local tweenService: TweenService = game:GetService("TweenService")
				local tweenInfo = TweenInfo.new(v97, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(sound, tweenInfo, { Volume = 0 }):Play()

				return
			end
		end)
	end

	v94 = if typeof(p13.def.SfxPitch) == "number" then p13.def.SfxPitch else 1
	sound.PlaybackSpeed = v94

	local sfxPitchVar = p13.def.SfxPitchVar

	if typeof(sfxPitchVar) == "number" and sfxPitchVar > 0 then
		local randomNumber = math.random()

		sound.PlaybackSpeed = v94 * (1 + (randomNumber * 2 - 1) * sfxPitchVar)
	end

	sound:Play()

	if p13.opts.duck and typeof(p13.def.MusicDuck) == "number" then
		emoteClient.DuckMusic(p13.def.MusicDuck)
	end
end
local function freezeTime(p14)
	local length = p14.Length

	if length > 0 then
		return length * 0.35
	end

	return 0
end
local function cueHandleProp(p15)
	if p15.cancelProp then
		p15.cancelProp()
	end

	p15.cancelProp = emoteProps.Cue(p15.rig, p15.def, function()
		local v157 = p15.alive

		if v157 then
			v157 = false

			if p15.mode == "play" then
				v157 = p15.visible
			end
		end

		return v157
	end, if p15.sound then p15.sound.Parent else nil)
end
local function applyMode(p16)
	local track = p16.track

	if not track then
	elseif p16.mode == "play" and p16.visible then
		if track.IsPlaying then
			track:AdjustSpeed(emoteCatalog.AnimSpeed(p16.def))
		else
			track:Play(0.1, 1, emoteCatalog.AnimSpeed(p16.def))
		end

		startSound(p16)

		if emoteProps.HasCue(p16.def) then
			cueHandleProp(p16)

			return
		end
	else
		if p16.mode == "freeze" or p16.mode == "play" and not p16.visible then
			if p16.sound then
				p16.sound:Stop()
			end

			if p16.opts.duck and typeof(p16.def.MusicDuck) == "number" then
				emoteClient.DuckMusic(nil)
			end

			if p16.cancelProp then
				p16.cancelProp()
				p16.cancelProp = nil
			end

			if not track.IsPlaying then
				track:Play(0)
			end

			local trackLength = track.Length

			track.TimePosition = if trackLength > 0 then trackLength * 0.35 else 0
			track:AdjustSpeed(0)

			return
		end

		if p16.sound then
			p16.sound:Stop()
		end

		if p16.opts.duck and typeof(p16.def.MusicDuck) == "number" then
			emoteClient.DuckMusic(nil)
		end

		if p16.cancelProp then
			p16.cancelProp()
			p16.cancelProp = nil
		end

		track:Stop(0)
	end
end
function t7.play(p17)
	if not p17.alive then
		return
	end

	p17.mode = "play"
	applyMode(p17)
end
function t7.freeze(p18)
	if not p18.alive then
		return
	end

	p18.mode = "freeze"
	applyMode(p18)
end
function t7.stop(p19)
	if not p19.alive then
		return
	end

	p19.mode = "stop"
	applyMode(p19)
end
function t7.isAlive(p20)
	return p20.alive
end
function t7.destroy(p21)
	if not p21.alive then
		return
	end

	p21.alive = false

	for _, v in ipairs(p21.conns) do
		v:Disconnect()
	end

	table.clear(p21.conns)

	if p21.sound then
		p21.sound:Stop()
	end

	if p21.opts.duck and typeof(p21.def.MusicDuck) == "number" then
		emoteClient.DuckMusic(nil)
	end

	if p21.cancelProp then
		p21.cancelProp()
		p21.cancelProp = nil
	end

	if p21.track then
		p21.track:Stop(0)
	end

	if p21.viewport then
		p21.viewport:Destroy()
	end

	local v115 = p21.opts.hideIcon and p21.host.Parent and p21.host:FindFirstChild("Icon")

	if v115 and v115:IsA("GuiObject") then
		v115.Visible = true
	end
end
function module.new(parent, p23, p24)
	local v119 = emoteCatalog.Get(p23)

	if not v119 then
		return nil
	end

	local t9 = p24 or {}
	local v121 = t9.hideIcon and parent:FindFirstChild("Icon")

	if v121 and v121:IsA("GuiObject") then
		v121.Visible = false
	end

	local emotePreview: ViewportFrame = Instance.new("ViewportFrame")

	emotePreview.Name = "EmotePreview"
	emotePreview.BackgroundTransparency = 1
	emotePreview.BorderSizePixel = 0
	emotePreview.Size = UDim2.fromScale(1, 1)
	emotePreview.Position = UDim2.fromScale(0.5, 0.5)
	emotePreview.AnchorPoint = Vector2.new(0.5, 0.5)
	emotePreview.ZIndex = t9.zindex or 3
	emotePreview.Ambient = Color3.fromRGB(170, 170, 175)
	emotePreview.LightColor = Color3.fromRGB(255, 255, 255)
	emotePreview.LightDirection = Vector3.new(-0.6, -1, -0.8)
	emotePreview.Parent = parent

	local worldModel: WorldModel = Instance.new("WorldModel")

	worldModel.Parent = emotePreview

	local emotePreviewRig = if t9.avatar == true and u22 then u22:Clone() else buildGreyRig()

	emotePreviewRig.Name = "EmotePreviewRig"
	prepRig(emotePreviewRig)

	local v125 = CFrame.Angles(0, 3.141592653589793, 0)

	emotePreviewRig:PivotTo(CFrame.new(0, 0, 0) * v125)
	emotePreviewRig.Parent = worldModel

	local camera: Camera = Instance.new("Camera")

	camera.FieldOfView = 45
	camera.CFrame = CFrame.lookAt(Vector3.new(0, -0.1, 9.5), Vector3.new(0, -0.35, 0))
	camera.Parent = emotePreview
	emotePreview.CurrentCamera = camera

	local v127 = if t9.loop == nil then v119.Loop else t9.loop
	local t10: {[any]: any} = {
		track = nil,
		sound = nil,
		alive = true,
		visible = true,
		viewport = emotePreview,
		def = v119,
		host = parent,
		opts = t9,
		rig = emotePreviewRig,
		mode = if t9.autoplay == false then "freeze" else "play",
		conns = {},
		loop = v127
	}
	local object = setmetatable(t10, t7)

	if t9.sound then
		local v130 = t1[v119.Id]
		local v131 = v130

		if v131 then
			local randomNumber = math.random(1, #v130)

			v131 = v130[randomNumber]
		end

		if v131 then
			local clone = v131:Clone()

			clone.Name = "EmotePreviewSfx"

			local v134 = v119.SfxVolume or 0.5
			local sfxVolume: any = soundService:GetAttribute("SFXVolume")
			local typeName: string = typeof(sfxVolume)

			clone.Volume = v134 * (if typeName == "number" then sfxVolume else 1) * 0.5

			local v137 = v127

			if v137 then
				v137 = typeof(v119.SfxFadeOutAt) ~= "number"
			end

			clone.Looped = v137
			clone.Parent = emotePreview
			t10.sound = clone

			local sfxPitchVar = v119.SfxPitchVar

			if typeof(sfxPitchVar) == "number" and sfxPitchVar > 0 then
				local v139 = if typeof(v119.SfxPitch) == "number" then v119.SfxPitch else 1

				table.insert(t10.conns, clone.DidLoop:Connect(function()
					local randomNumber = math.random()

					clone.PlaybackSpeed = v139 * (1 + (randomNumber * 2 - 1) * sfxPitchVar)
				end))
			end
		end
	end

	table.insert(t10.conns, parent.Destroying:Connect(function()
		object:destroy()
	end))

	if t9.watch then
		local n1: number = 0

		table.insert(t10.conns, runService.Heartbeat:Connect(function(deltaTime: number)
			n1 += deltaTime

			if n1 < 0.25 then
				return
			end

			n1 = 0

			if not t10.alive then
				return
			end

			if not parent.Parent or not emotePreview.Parent then
				object:destroy()

				return
			end

			local v160 = hostOnScreen(parent)

			if v160 ~= t10.visible then
				t10.visible = v160
				applyMode(t10)
			end
		end))
	end

	task.spawn(function()
		local v161 = t2[v119.Id]

		if not v161 then
			return
		end

		local humanoid = emotePreviewRig:FindFirstChildOfClass("Humanoid")
		local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

		if not animator then
			return
		end

		local ok, result = pcall(function()
			return animator:LoadAnimation(v161)
		end)

		if not ok or not result then
			warn("[EmotePreview] LoadAnimation failed for", v119.Id, result)

			return
		end

		if not t10.alive then
			return
		end

		result.Priority = Enum.AnimationPriority.Action
		result.Looped = v127
		t10.track = result

		if typeof(v119.SfxFadeOutAt) == "number" then
			table.insert(t10.conns, result.DidLoop:Connect(function()
				if t10.alive and t10.mode == "play" and t10.visible then
					startSound(t10)
				end
			end))
		end

		if v127 and emoteProps.HasCue(v119) then
			table.insert(t10.conns, result.DidLoop:Connect(function()
				if t10.alive and t10.mode == "play" and t10.visible then
					cueHandleProp(t10)
				end
			end))
		end

		if not v127 then
			table.insert(t10.conns, result.Stopped:Connect(function()
				if not t10.alive or t10.mode ~= "play" or not t10.visible then
					return
				end

				task.delay(1.5, function()
					if t10.alive and t10.mode == "play" and t10.visible then
						applyMode(t10)
					end
				end)
			end))
		end

		applyMode(t10)

		if t10.mode == "freeze" and result.Length <= 0 then
			task.delay(0.5, function()
				if t10.alive and t10.mode == "freeze" then
					applyMode(t10)
				end
			end)
		end
	end)

	return object
end

local u42 = nil
local u43 = nil

function module.stop()
	local v141 = u42

	u42 = nil
	u43 = nil

	if v141 then
		v141:destroy()
	end
end
function module.show(p26, p27)
	local v144 = emoteCatalog.Get(p27)

	if not v144 then
		module.stop()

		return
	end

	local v145 = u42

	if v145 and v145:isAlive() and p26 == u43 and v145.def.Id == v144.Id and p26.Parent then
		return
	end

	module.stop()
	u42 = module.new(p26, p27, {
		sound = true,
		duck = true,
		autoplay = true,
		hideIcon = true,
		watch = true,
		avatar = true
	})
	u43 = p26
end
function module.isActive()
	local u146 = false

	if u42 ~= nil then
		u146 = u42:isAlive()
	end

	return u146
end

return module
