-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local soundService: SoundService = game:GetService("SoundService")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local emoteCatalog = require(shared:WaitForChild("EmoteCatalog"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local thirdPerson = require(replicatedStorageShared:WaitForChild("ThirdPerson"))
local v12: Instance = replicatedStorage:WaitForChild("Shared")
local emoteProps = require(v12:WaitForChild("EmoteProps"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local emote: Instance = remotes:WaitForChild("Emote")
local emoteEvent: Instance = remotes:WaitForChild("EmoteEvent")
local LocalPlayer: Player = players.LocalPlayer
local emoteCatalogSlots = emoteCatalog.SLOTS
local t1: {[any]: any} = {}
local u20: boolean = false
local bindableEvent: BindableEvent = Instance.new("BindableEvent")

local function setLoadout(p3)
	local t9: {[any]: any} = {}

	if typeof(p3) == "table" then
		for k, v in pairs(p3) do
			local numberValue: number? = tonumber(k)

			if numberValue and typeof(v) == "table" and typeof(v.InstanceId) == "string" and typeof(v.ItemId) == "string" then
				t9[numberValue] = { InstanceId = v.InstanceId, ItemId = v.ItemId }
			end
		end
	end

	t1 = t9
	bindableEvent:Fire()
end
local function invoke(p4, p5)
	local v64, v65, v66 = pcall(emote.InvokeServer, emote, p4, p5)

	if not v64 then
		return false, "Network hiccup"
	end

	return v65 == true, v66
end

local module: {[any]: any} = {
	SLOTS = emoteCatalogSlots,
	Changed = bindableEvent.Event,
	GetLoadout = function()
		return t1
	end,
	SlotEntry = function(p1)
		return t1[p1]
	end,
	SlotOfInstance = function(p2)
		for k, v in pairs(t1) do
			if p2 == v.InstanceId then
				return k
			end
		end

		return nil
	end,
	IsEnabled = function()
		return u20
	end,
	Refresh = function()
		task.spawn(function()
			local v222, v223, v224 = pcall(emote.InvokeServer, emote, "GetState", nil)
			local u225
			local s1

			if not v222 then
				u225 = false
				s1 = "Network hiccup"
			else
				u225 = v223 == true
				s1 = v224
			end

			if u225 and typeof(s1) == "table" then
				u20 = s1.Enabled == true
				setLoadout(s1.Loadout)
			end
		end)
	end,
	Equip = function(p6, p7)
		local v73, v74, v75 = pcall(emote.InvokeServer, emote, "Equip", { Slot = p6, InstanceId = p7 })
		local u76
		local s1

		if not v73 then
			u76 = false
			s1 = "Network hiccup"
		else
			u76 = v74 == true
			s1 = v75
		end

		local u78 = u76

		if u76 then
			return u78, nil
		end

		local text: string = tostring(s1)

		return u78, text
	end,
	Unequip = function(p8)
		local v81, v82, v83 = pcall(emote.InvokeServer, emote, "Unequip", { Slot = p8 })
		local u84
		local s1

		if not v81 then
			u84 = false
			s1 = "Network hiccup"
		else
			u84 = v82 == true
			s1 = v83
		end

		local u86 = u84

		if u84 then
			return u86, nil
		end

		local text: string = tostring(s1)

		return u86, text
	end,
	RequestPlay = function(p9)
		local v89, v90, v91 = pcall(emote.InvokeServer, emote, "Play", { Slot = p9 })
		local u92
		local s1

		if not v89 then
			u92 = false
			s1 = "Network hiccup"
		else
			u92 = v90 == true
			s1 = v91
		end

		local u94 = u92

		if u92 then
			return u94, nil
		end

		local text: string = tostring(s1)

		return u94, text
	end,
	RequestStop = function()
		task.spawn(function()
			local v227, v228, v229 = pcall(emote.InvokeServer, emote, "Stop", nil)
		end)
	end
}

local t3: {[any]: any} = {}

for k, v in pairs(emoteCatalog.Defs) do
	if typeof(v.Anim) == "number" and v.Anim > 0 then
		local animation: Animation = Instance.new("Animation")

		animation.Name = "Emote_" .. k
		animation.AnimationId = "rbxassetid://" .. tostring(v.Anim)
		t3[k] = animation
	end
end

task.spawn(function()
	local t10: {[any]: any} = {}

	for _, v in pairs(t3) do
		table.insert(t10, v)
	end

	pcall(function()
		contentProvider:PreloadAsync(t10)
	end)
end)

local t4: {[any]: any} = {}

local function trackFor(character, p11)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return nil
	end

	local t11 = t4[character]

	if t11 == nil then
		t11 = {}
		t4[character] = t11
		character.AncestryChanged:Connect(function(_, p13)
			if p13 == nil then
				t4[character] = nil
			end
		end)
	end

	local v103 = t11[p11]

	if v103 then
		return v103
	end

	local v104 = t3[p11]

	if not v104 then
		return nil
	end

	local v105 = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

	local ok, result = pcall(function()
		return v105:LoadAnimation(v104)
	end)

	if ok and result ~= nil then
		result.Priority = Enum.AnimationPriority.Action
		t11[p11] = result

		return v103 or result
	end

	warn("[EmoteClient] LoadAnimation failed for", p11, result)

	return nil
end
local function preloadLocal()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	task.spawn(function()
		Character:WaitForChild("Humanoid", 10)

		for _, v in pairs(t1) do
			trackFor(Character, v.ItemId)
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	task.defer(preloadLocal)
end)
module.Changed:Connect(preloadLocal)

local u32 = nil
local u33 = nil
local u34 = nil
local u35: boolean = false

local function killDuckTween()
	if u32 then
		u32:Cancel()
		u32 = nil
	end

	if u33 then
		u33:Destroy()
		u33 = nil
	end
end
local function ownsAttribute()
	local musicDuck: any = soundService:GetAttribute("MusicDuck")

	if u34 == nil then
		return musicDuck == nil
	end

	local u110: boolean = false

	if typeof(musicDuck) == "number" then
		u110 = math.abs(musicDuck - u34) < 0.0001
	end

	return u110
end
local function tweenDuck(value, p15, p16)
	if u32 then
		u32:Cancel()
		u32 = nil
	end

	if u33 then
		u33:Destroy()
		u33 = nil
	end

	local musicDuck = soundService:GetAttribute("MusicDuck")

	if typeof(musicDuck) ~= "number" then
		musicDuck = 1
	end

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = musicDuck
	numberValue.Changed:Connect(function(p17: number)
		u34 = p17
		soundService:SetAttribute("MusicDuck", p17)
	end)
	u33 = numberValue

	local tweenInfo = TweenInfo.new(p15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v117: Tween = tweenService:Create(numberValue, tweenInfo, { Value = value })

	u32 = v117
	v117.Completed:Once(function(p18)
		if u32 == v117 then
			u32 = nil

			if u33 == numberValue then
				u33 = nil
			end

			numberValue:Destroy()

			if p18 == Enum.PlaybackState.Completed then
				u34 = value
				soundService:SetAttribute("MusicDuck", value)

				if p16 then
					p16()
				end
			end
		end
	end)
	v117:Play()
end
local function duckMusic(p19)
	if p19 ~= nil then
		if not u35 then
			local musicDuck: any = soundService:GetAttribute("MusicDuck")
			local u120

			if u34 == nil then
				u120 = musicDuck == nil
			else
				u120 = false

				if typeof(musicDuck) == "number" then
					u120 = math.abs(musicDuck - u34) < 0.0001
				end
			end

			if not u120 then
				return
			end

			u35 = true
			tweenDuck(p19, 0.4)

			return
		end

		u35 = true
		tweenDuck(p19, 0.4)

		return
	end

	if not u35 then
		return
	end

	local musicDuck: any = soundService:GetAttribute("MusicDuck")
	local u122

	if u34 == nil then
		u122 = musicDuck == nil
	else
		u122 = false

		if typeof(musicDuck) == "number" then
			u122 = math.abs(musicDuck - u34) < 0.0001
		end
	end

	if not u122 then
		u35 = false
		u34 = nil

		if u32 then
			u32:Cancel()
			u32 = nil
		end

		if u33 then
			u33:Destroy()
			u33 = nil
		end

		return
	end

	tweenDuck(1, 0.6, function()
		u35 = false
		u34 = nil
		soundService:SetAttribute("MusicDuck", nil)
	end)
end
function module.DuckMusic(p20)
	if p20 ~= nil then
		local v124 = math.clamp(p20, 0, 1)

		duckMusic(v124)

		return
	end

	if not u35 then
		return
	end

	local musicDuck: any = soundService:GetAttribute("MusicDuck")
	local u126

	if u34 == nil then
		u126 = musicDuck == nil
	else
		u126 = false

		if typeof(musicDuck) == "number" then
			u126 = math.abs(musicDuck - u34) < 0.0001
		end
	end

	if not u126 then
		u35 = false
		u34 = nil

		if u32 then
			u32:Cancel()
			u32 = nil
		end

		if u33 then
			u33:Destroy()
			u33 = nil

			return
		end
	else
		tweenDuck(1, 0.6, function()
			u35 = false
			u34 = nil
			soundService:SetAttribute("MusicDuck", nil)
		end)
	end
end

local t5: {[any]: any} = {}

local function isMusicEmote(p21)
	return typeof(p21.MusicDuck) == "number"
end
local function localEmoting()
	local Character: Model = LocalPlayer.Character
	local v129 = Character and t5[Character]
	local u130 = false

	if v129 ~= nil then
		u130 = v129.exclusive
	end

	return u130
end
local function updateMix()
	local Character: Model = LocalPlayer.Character
	local Character2: Model = LocalPlayer.Character
	local v133 = Character2 and t5[Character2]
	local u134 = false

	if v133 ~= nil then
		u134 = v133.exclusive
	end

	local CFramePosition = nil

	v133 = Character and (Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart"))

	if v133 and v133:IsA("BasePart") then
		CFramePosition = v133.Position
	elseif workspace.CurrentCamera then
		CFramePosition = workspace.CurrentCamera.CFrame.Position
	end

	v133 = nil

	local n1 = math.huge

	if not u134 and CFramePosition then
		for k, v in pairs(t5) do
			if k ~= Character and v.exclusive and v.sound then
				local v139 = k.PrimaryPart or k:FindFirstChild("HumanoidRootPart")
				local v140 = if v139 and v139:IsA("BasePart") then (v139.Position - CFramePosition).Magnitude else math.huge

				if n1 > v140 then
					v133 = v
					n1 = v140
				end
			end
		end
	end

	for k, v in pairs(t5) do
		local vSound = v.sound

		if k ~= Character and vSound and not v.mixLock then
			if u134 then
				vSound.Volume = 0
			elseif v.exclusive and v ~= v133 then
				vSound.Volume = v.baseVolume * 0.12
			else
				vSound.Volume = v.baseVolume
			end
		end
	end
end
local function u44()
	while true do
		task.wait(0.25)

		local v144: boolean = false

		if next(t5) == nil then
		else
			updateMix()
		end

		v144 = true

		if v144 then
			for _, v in ipairs(players:GetPlayers()) do
				local Character = v.Character

				if Character and Character:GetAttribute("EmoteHideWeapons") == true and t5[Character] == nil then
					pcall(function()
						Character:SetAttribute("EmoteHideWeapons", nil)
					end)
				end
			end
		end
	end
end

task.spawn(u44)

local t6: {[any]: any} = { "EnableKnifeRig", "EnableRevolverRig" }

u44 = false

local u46 = nil
local t7: {[any]: any} = { Distance = 5.5, Shoulder = 1.2, Height = 0.8 }
local u48 = nil

local function cameraOut()
	if LocalPlayer:GetAttribute("InMatch") == true then
		if thirdPerson.IsEnabled() then
			return
		end

		u48 = {
			Distance = thirdPerson.Distance,
			Shoulder = thirdPerson.Shoulder,
			Height = thirdPerson.Height
		}
		thirdPerson.Distance = 5.5
		thirdPerson.Shoulder = 1.2
		thirdPerson.Height = 0.8
		thirdPerson.SetEnabled(true)
		u44 = true

		return
	end
end
local function cameraBack()
	if not u44 then
		return
	end

	u44 = false
	thirdPerson.SetEnabled(false)

	if u48 then
		thirdPerson.Distance = u48.Distance
		thirdPerson.Shoulder = u48.Shoulder
		thirdPerson.Height = u48.Height
		u48 = nil
	end
end
function module.IsLocalActive()
	local Character: Model = LocalPlayer.Character

	return Character ~= nil and t5[Character] ~= nil
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	if LocalPlayer:GetAttribute("InMatch") == true then
		return
	end

	if not u44 then
		return
	end

	u44 = false
	thirdPerson.SetEnabled(false)

	if u48 then
		thirdPerson.Distance = u48.Distance
		thirdPerson.Shoulder = u48.Shoulder
		thirdPerson.Height = u48.Height
		u48 = nil
	end
end)
LocalPlayer.CharacterAdded:Connect(function()
	u46 = nil

	if not u44 then
		return
	end

	u44 = false
	thirdPerson.SetEnabled(false)

	if u48 then
		thirdPerson.Distance = u48.Distance
		thirdPerson.Shoulder = u48.Shoulder
		thirdPerson.Height = u48.Height
		u48 = nil
	end
end)
LocalPlayer.CharacterRemoving:Connect(function()
	if not u44 then
		return
	end

	u44 = false
	thirdPerson.SetEnabled(false)

	if u48 then
		thirdPerson.Distance = u48.Distance
		thirdPerson.Shoulder = u48.Shoulder
		thirdPerson.Height = u48.Height
		u48 = nil
	end
end)

local t8: {[any]: any} = {}

local function endLinger(p22)
	local v150 = t8[p22]

	if v150 then
		v150()
	end
end
local function lingerFx(character, p24, p25)
	local v154 = t8[character]

	if v154 then
		v154()
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local u157: boolean = character == LocalPlayer.Character
	local v158 = os.clock()
	local u159: boolean = false
	local connection = nil

	local function finish()
		if u159 then
			return
		end

		u159 = true

		if connection then
			connection:Disconnect()
		end

		if t8[character] == finish then
			t8[character] = nil
		end

		p24()
	end

	t8[character] = finish
	connection = runService.Heartbeat:Connect(function()
		if not (os.clock() - v158 >= p25) and character.Parent and humanoid and not (humanoid.Health <= 0) then
			if not u157 then
				if humanoidRootPart and (Vector3.new(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z).Magnitude > 2 or math.abs(humanoidRootPart.AssemblyLinearVelocity.Y) > 6) then
					if u159 then
						return
					end

					u159 = true

					if connection then
						connection:Disconnect()
					end

					if t8[character] == finish then
						t8[character] = nil
					end

					p24()
				end
			elseif humanoid.MoveDirection.Magnitude >= 0.35 or humanoid.Jump then
				if u159 then
					return
				end

				u159 = true

				if connection then
					connection:Disconnect()
				end

				if t8[character] == finish then
					t8[character] = nil
				end

				p24()

				return
			end

			return
		end

		if u159 then
			return
		end

		u159 = true

		if connection then
			connection:Disconnect()
		end

		if t8[character] == finish then
			t8[character] = nil
		end

		p24()
	end)
end
local function stopOn(p26)
	local v163 = t5[p26]

	if not v163 then
		return
	end

	t5[p26] = nil
	pcall(function()
		p26:SetAttribute("EmoteHideWeapons", nil)
	end)

	for _, v in ipairs(v163.conns) do
		v:Disconnect()
	end

	if v163.cancelProp then
		local v166 = emoteCatalog.Get(v163.id)
		local v167 = v166 and typeof(v166.Fx) == "table" and tonumber(v166.Fx.HoldAfter) or nil
		local u168: boolean = false

		pcall(function()
			u168 = v163.track.Length > 0 and v163.track.TimePosition >= v163.track.Length - 0.6
		end)

		if v167 and v167 > 0 and (not not v163.naturalEnd or not not u168) then
			lingerFx(p26, v163.cancelProp, v167)
		else
			v163.cancelProp()
		end
	end

	pcall(function()
		v163.track:Stop(0.15)
	end)

	if v163.sound then
		local sound = v163.sound
		local v170 = emoteCatalog.Get(v163.id)

		if v163.naturalEnd and v170 and v170.SfxTail == true and sound.IsPlaying then
			sound.Ended:Once(function()
				sound:Destroy()
			end)
			task.delay(15, function()
				if sound.Parent then
					sound:Destroy()
				end
			end)
		else
			pcall(function()
				sound:Stop()
			end)
			task.delay(0.1, function()
				sound:Destroy()
			end)
		end
	end

	if p26 == LocalPlayer.Character or p26 == u46 then
		if p26 == u46 then
			u46 = nil
		end

		pcall(function()
			p26:SetAttribute("Emoting", nil)
		end)
		pcall(function()
			v163.hum:SetAttribute("EmoteSpeedMult", nil)
		end)

		local v171 = emoteCatalog.Get(v163.id)

		if v171 and v171.MusicDuck ~= nil and u35 then
			local musicDuck: any = soundService:GetAttribute("MusicDuck")
			local u173

			if u34 == nil then
				u173 = musicDuck == nil
			else
				u173 = false

				if typeof(musicDuck) == "number" then
					u173 = math.abs(musicDuck - u34) < 0.0001
				end
			end

			if not u173 then
				u35 = false
				u34 = nil

				if u32 then
					u32:Cancel()
					u32 = nil
				end

				if u33 then
					u33:Destroy()
					u33 = nil
				end
			else
				tweenDuck(1, 0.6, function()
					u35 = false
					u34 = nil
					soundService:SetAttribute("MusicDuck", nil)
				end)
			end
		end

		if u44 then
			u44 = false
			thirdPerson.SetEnabled(false)

			if u48 then
				thirdPerson.Distance = u48.Distance
				thirdPerson.Shoulder = u48.Shoulder
				thirdPerson.Height = u48.Height
				u48 = nil
			end
		end

		updateMix()
	end
end
function module.StopLocal()
	local Character: Model = LocalPlayer.Character

	if Character and t5[Character] then
		stopOn(Character)
		module.RequestStop()
	end
end
local function resolveSfx(p27, p28)
	local sfx = p27.Sfx

	if typeof(sfx) == "number" then
		return sfx
	end

	if typeof(sfx) == "table" and #sfx > 0 then
		local v178 = if typeof(p28) == "number" then math.floor(p28) else 1

		if v178 < 1 or v178 > #sfx then
			v178 = 1
		end

		return sfx[v178]
	end

	return nil
end
local function playOn(character, p30, p31)
	local v182 = emoteCatalog.Get(p30)

	if not v182 then
		return
	end

	stopOn(character)

	local v183 = t8[character]

	if v183 then
		v183()
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and not (humanoid.Health <= 0) then
		local v185 = trackFor(character, p30)

		if not v185 then
			return
		end

		local u186: boolean = character == LocalPlayer.Character

		v185.Looped = v182.Loop

		local t12: {[any]: any} = {}
		local t13: {[any]: any} = {
			sound = nil,
			id = p30,
			track = v185,
			baseVolume = v182.SfxVolume or 0.5,
			exclusive = typeof(v182.MusicDuck) == "number",
			conns = t12,
			hum = humanoid
		}

		t5[character] = t13
		pcall(function()
			character:SetAttribute("EmoteHideWeapons", true)
		end)
		v185:Play(0.1, 1, emoteCatalog.AnimSpeed(v182))

		if emoteProps.HasCue(v182) then
			local function isLive()
				return t5[character] == t13
			end
			local function cueProp()
				if t13.cancelProp then
					t13.cancelProp()
				end

				t13.cancelProp = emoteProps.Cue(character, v182, isLive)
			end

			if t13.cancelProp then
				t13.cancelProp()
			end

			t13.cancelProp = emoteProps.Cue(character, v182, isLive)

			if v182.Loop then
				table.insert(t12, v185.DidLoop:Connect(cueProp))
			end
		end

		local sfx = v182.Sfx
		local v192

		if typeof(sfx) == "number" then
			v192 = sfx
		elseif typeof(sfx) == "table" and #sfx > 0 then
			local v193 = if typeof(p31) == "number" then math.floor(p31) else 1

			if v193 < 1 or v193 > #sfx then
				v193 = 1
			end

			v192 = sfx[v193]
		else
			v192 = nil
		end

		if v192 then
			local parent = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart

			if parent then
				local sound: Sound = Instance.new("Sound")

				sound.Name = "EmoteSfx_" .. p30
				sound.SoundId = "rbxassetid://" .. tostring(v192)
				sound.Volume = t13.baseVolume
				sound.Looped = v182.Loop
				sound.RollOffMaxDistance = 60
				sound.Parent = parent

				local playbackSpeed = if typeof(v182.SfxPitch) == "number" then v182.SfxPitch else 1

				sound.PlaybackSpeed = playbackSpeed

				local sfxPitchVar = v182.SfxPitchVar

				if typeof(sfxPitchVar) == "number" and sfxPitchVar > 0 then
					local randomNumber = math.random()

					sound.PlaybackSpeed = playbackSpeed * (1 + (randomNumber * 2 - 1) * sfxPitchVar)
					table.insert(t12, sound.DidLoop:Connect(function()
						local randomNumber2 = math.random()

						sound.PlaybackSpeed = playbackSpeed * (1 + (randomNumber2 * 2 - 1) * sfxPitchVar)
					end))
				end

				t13.sound = sound

				local sfxFadeOutAt = v182.SfxFadeOutAt

				if typeof(sfxFadeOutAt) == "number" and sfxFadeOutAt > 0 then
					sound.Looped = false

					local v200 = if typeof(v182.SfxFadeTime) == "number" then v182.SfxFadeTime else 0.5
					local n1: number = 0

					local function cue()
						n1 += 1

						local v237: number = n1

						t13.mixLock = false
						sound.Volume = t13.baseVolume
						sound.TimePosition = 0
						sound:Play()
						updateMix()

						local taskDelay = task.delay
						local v239 = emoteCatalog.AnimSpeed(v182)

						taskDelay(sfxFadeOutAt / v239, function()
							if v237 == n1 and t5[character] == t13 then
								t13.mixLock = true

								local tweenInfo = TweenInfo.new(v200, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

								tweenService:Create(sound, tweenInfo, { Volume = 0 }):Play()

								return
							end
						end)
					end

					cue()
					table.insert(t12, v185.DidLoop:Connect(cue))
				else
					sound:Play()
					updateMix()
				end
			end
		end

		if u186 then
			u46 = character
			pcall(function()
				character:SetAttribute("Emoting", true)
			end)

			if t13.exclusive then
				updateMix()
			end

			if v182.Walkable then
				humanoid:SetAttribute("EmoteSpeedMult", emoteCatalog.WALK_MULT)
			end

			if typeof(v182.MusicDuck) == "number" then
				local v203 = math.clamp(v182.MusicDuck, 0, 1)

				duckMusic(v203)
			end

			cameraOut()
		end

		local function cancel()
			if t5[character] ~= t13 then
				return
			end

			if u186 then
				module.StopLocal()

				return
			end

			stopOn(character)
		end

		if not v182.Walkable then
			local v205 = os.clock()
			local n2: number = 0
			local u207: boolean = userInputService:GetLastInputType() == Enum.UserInputType.Gamepad1

			table.insert(t12, runService.Heartbeat:Connect(function(deltaTime: number)
				if t5[character] ~= t13 then
					return
				end

				local magnitude = humanoid.MoveDirection.Magnitude

				if magnitude < 0.35 then
					n2 = 0

					return
				end

				if u207 and os.clock() - v205 < 0.4 then
					return
				end

				if magnitude >= 0.75 then
					if t5[character] ~= t13 then
						return
					end

					if u186 then
						module.StopLocal()

						return
					end

					stopOn(character)

					return
				end

				n2 += deltaTime

				if n2 >= 0.2 then
					if t5[character] ~= t13 then
						return
					end

					if u186 then
						module.StopLocal()

						return
					end

					stopOn(character)

					return
				end
			end))
		end

		table.insert(t12, humanoid.StateChanged:Connect(function(_, p34)
			if p34 == Enum.HumanoidStateType.Jumping or p34 == Enum.HumanoidStateType.Dead then
				if t5[character] ~= t13 then
					return
				end

				if u186 then
					module.StopLocal()

					return
				end

				stopOn(character)
			elseif p34 == Enum.HumanoidStateType.Freefall then
				task.delay(0.35, function()
					if t5[character] == t13 and humanoid.Parent and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
						if t5[character] ~= t13 then
							return
						end

						if u186 then
							module.StopLocal()

							return
						end

						stopOn(character)

						return
					end
				end)
			end
		end))

		local v208 = character:GetAttributeChangedSignal("Sliding")

		table.insert(t12, v208:Connect(function()
			if character:GetAttribute("Sliding") == true then
				if t5[character] ~= t13 then
					return
				end

				if u186 then
					module.StopLocal()

					return
				end

				stopOn(character)

				return
			end
		end))

		for _, v in ipairs(t6) do
			local v211 = character:GetAttributeChangedSignal(v)

			table.insert(t12, v211:Connect(cancel))
		end

		table.insert(t12, character.ChildAdded:Connect(function(p35)
			if p35:IsA("Tool") then
				if t5[character] ~= t13 then
					return
				end

				if u186 then
					module.StopLocal()

					return
				end

				stopOn(character)

				return
			end
		end))
		table.insert(t12, character.ChildRemoved:Connect(function(p36)
			if p36:IsA("Tool") then
				if t5[character] ~= t13 then
					return
				end

				if u186 then
					module.StopLocal()

					return
				end

				stopOn(character)

				return
			end
		end))
		table.insert(t12, character.AncestryChanged:Connect(function(_, p38)
			if p38 == nil then
				stopOn(character)
			end
		end))
		table.insert(t12, v185.Stopped:Connect(function()
			if t5[character] == t13 then
				t13.naturalEnd = true

				if u186 then
					module.StopLocal()

					return
				end

				stopOn(character)

				return
			end
		end))

		return
	end
end
function module.IsPlayingLocal()
	local Character: Model = LocalPlayer.Character

	return Character ~= nil and t5[Character] ~= nil
end

emoteEvent.OnClientEvent:Connect(function(player)
	if typeof(player) ~= "table" then
	elseif player.Action == "Loadout" then
		setLoadout(player.Loadout)
	elseif player.Action == "Play" then
		local numberValue: number? = tonumber(player.UserId)
		local player2: Player = players:GetPlayerByUserId(numberValue or 0)
		local playerCharacter = player2 and player2.Character

		if playerCharacter and typeof(player.ItemId) == "string" then
			local itemId = player.ItemId
			local numberValue2: number? = tonumber(player.Variant)

			playOn(playerCharacter, itemId, numberValue2)

			return
		end
	elseif player.Action == "Stop" then
		local numberValue: number? = tonumber(player.UserId)
		local v220: Player = players:GetPlayerByUserId(numberValue or 0)
		local character = v220 and v220.Character

		if character then
			stopOn(character)
		end
	end
end)
module.Refresh()
LocalPlayer:GetAttributeChangedSignal("DataReady"):Connect(function()
	if LocalPlayer:GetAttribute("DataReady") then
		module.Refresh()
	end
end)

return module
