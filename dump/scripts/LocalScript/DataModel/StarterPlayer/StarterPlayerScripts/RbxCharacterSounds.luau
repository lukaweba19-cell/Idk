-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local soundService: SoundService = game:GetService("SoundService")
local atomicBinding = require(script:WaitForChild("AtomicBinding"))

local function loadFlag(p1)
	local ok, result = pcall(function()
		return UserSettings():IsUserFeatureEnabled(p1)
	end)

	return ok and result
end

local s1: string = "UserSoundsUseRelativeVelocity2"

local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled(s1)
end)

local v9 = ok and result
local s2: string = "UserNewCharacterSoundsApi3"

local ok2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled(s2)
end)

local v13 = ok2 and result2
local s3: string = "UserFixCharSoundsEmitters"

local ok3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled(s3)
end)

local v17 = ok3 and result3
local s4: string = "UserFixCharSoundsEmitterRootPart"

local ok4, result4 = pcall(function()
	return UserSettings():IsUserFeatureEnabled(s4)
end)

local v21 = ok4 and result4

local function map(p2, p3, p4, p5, p6)
	return (p2 - p3) * (p6 - p5) / (p4 - p3) + p5
end
local function getRelativeVelocity(p7, p8)
	if not p7 then
		return p8
	end

	local v48 = p7.ActiveController

	if v48 then
		v48 = p7.ActiveController:IsA("GroundController") and p7.GroundSensor or p7.ActiveController:IsA("ClimbController") and p7.ClimbSensor
	end

	if v48 and v48.SensedPart then
		local v49 = v48.SensedPart:GetVelocityAtPosition(p7.RootPart.Position)

		return p8 - v49
	end

	return p8
end
local function playSound(p9, p10)
	if not p10 then
		p9.TimePosition = 0
	end

	if v13 and p9:IsA("AudioPlayer") then
		p9:Play()

		return
	end

	p9.Playing = true
end
local function stopSound(p11)
	if v13 and p11:IsA("AudioPlayer") then
		p11:Stop()

		return
	end

	p11.Playing = false
end
local function playSoundIf(p12, playing)
	if v13 and p12:IsA("AudioPlayer") then
		if p12.IsPlaying and not playing then
			p12:Stop()

			return
		end

		if not p12.IsPlaying and playing then
			p12:Play()

			return
		end
	else
		p12.Playing = playing
	end
end
local function setSoundLooped(p14, p15)
	if v13 and p14:IsA("AudioPlayer") then
		p14.Looping = p15

		return
	end

	p14.Looped = p15
end
local function shallowCopy(p16)
	local t4: {[any]: any} = {}

	for k, v in pairs(p16) do
		t4[k] = v
	end

	return t4
end

local t1: {[any]: any} = {
	Climbing = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looped = true
	},
	Died = { SoundId = "rbxasset://sounds/uuhhh.mp3" },
	FreeFalling = { SoundId = "rbxasset://sounds/action_falling.ogg", Looped = true },
	GettingUp = { SoundId = "rbxasset://sounds/action_get_up.mp3" },
	Jumping = { SoundId = "rbxasset://sounds/action_jump.mp3" },
	Landing = { SoundId = "rbxasset://sounds/action_jump_land.mp3" },
	Running = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looped = true,
		Pitch = 1.85
	},
	Splash = { SoundId = "rbxasset://sounds/impact_water.mp3" },
	Swimming = {
		SoundId = "rbxasset://sounds/action_swim.mp3",
		Looped = true,
		Pitch = 1.6
	}
}
local t2: {[any]: any} = {
	Climbing = {
		AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looping = true
	},
	Died = { AssetId = "rbxasset://sounds/uuhhh.mp3" },
	FreeFalling = { AssetId = "rbxasset://sounds/action_falling.ogg", Looping = true },
	GettingUp = { AssetId = "rbxasset://sounds/action_get_up.mp3" },
	Jumping = { AssetId = "rbxasset://sounds/action_jump.mp3" },
	Landing = { AssetId = "rbxasset://sounds/action_jump_land.mp3" },
	Running = {
		AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looping = true,
		PlaybackSpeed = 1.85
	},
	Splash = { AssetId = "rbxasset://sounds/impact_water.mp3" },
	Swimming = {
		AssetId = "rbxasset://sounds/action_swim.mp3",
		Looping = true,
		PlaybackSpeed = 1.6
	}
}

local v31 = atomicBinding.new({ humanoid = "Humanoid", rootPart = "HumanoidRootPart" }, function(p17)
	local humanoid = p17.humanoid
	local rootPart = p17.rootPart
	local audioEmitter = nil
	local controllerManager = nil

	if v9 then
		controllerManager = humanoid.Parent:FindFirstChild("ControllerManager")
	end

	local t5: {[any]: any} = {}

	if v13 and soundService.CharacterSoundsUseNewApi == Enum.RolloutState.Enabled then
		local Character = nil
		local RootPart = nil

		if not v17 then
			Character = players.LocalPlayer.Character
		elseif v21 then
			RootPart = humanoid.RootPart or humanoid.Parent
		else
			RootPart = humanoid.RootPart
		end

		local t6: {[any]: any} = {}
		local n1: number = 5

		while n1 < 150 do
			t6[n1] = 5 / n1
			n1 *= 1.25
		end

		t6[150] = 0

		if v17 then
			audioEmitter = Instance.new("AudioEmitter", RootPart)
		else
			audioEmitter = Instance.new("AudioEmitter", Character)
		end

		audioEmitter.Name = "RbxCharacterSoundsEmitter"
		audioEmitter:SetDistanceAttenuation(t6)

		for k, v in pairs(t2) do
			local audioPlayer: AudioPlayer = Instance.new("AudioPlayer")
			local wire: Wire = Instance.new("Wire")

			audioPlayer.Name = k
			wire.Name = k .. "Wire"
			audioPlayer.Archivable = false
			audioPlayer.Volume = 0.65

			for k2, iterValue in pairs(v) do
				audioPlayer[k2] = iterValue
			end

			audioPlayer.Parent = rootPart
			wire.Parent = audioPlayer
			wire.SourceInstance = audioPlayer
			wire.TargetInstance = audioEmitter
			t5[k] = audioPlayer
		end
	else
		for k, v in pairs(t1) do
			local sound: Sound = Instance.new("Sound")

			sound.Name = k
			sound.Archivable = false
			sound.RollOffMinDistance = 5
			sound.RollOffMaxDistance = 150
			sound.Volume = 0.65

			for k3, iterValue2 in pairs(v) do
				sound[k3] = iterValue2
			end

			sound.Parent = rootPart
			t5[k] = sound
		end
	end

	local t7: {[any]: any} = {}

	local function stopPlayingLoopedSounds(p18)
		local t12: {[any]: any} = {}

		for k, v in pairs(t7) do
			t12[k] = v
		end

		for iterKey in pairs(t12) do
			if iterKey ~= (p18 or nil) then
				if v13 and iterKey:IsA("AudioPlayer") then
					iterKey:Stop()
				else
					iterKey.Playing = false
				end

				t7[iterKey] = nil
			end
		end
	end

	local t8: {[any]: any} = {
		[Enum.HumanoidStateType.FallingDown] = function()
			stopPlayingLoopedSounds()
		end,
		[Enum.HumanoidStateType.GettingUp] = function()
			stopPlayingLoopedSounds()

			local gettingUp = t5.GettingUp

			gettingUp.TimePosition = 0

			if v13 and gettingUp:IsA("AudioPlayer") then
				gettingUp:Play()

				return
			end

			gettingUp.Playing = true
		end,
		[Enum.HumanoidStateType.Jumping] = function()
			stopPlayingLoopedSounds()

			local jumping = t5.Jumping

			jumping.TimePosition = 0

			if v13 and jumping:IsA("AudioPlayer") then
				jumping:Play()

				return
			end

			jumping.Playing = true
		end,
		[Enum.HumanoidStateType.Swimming] = function()
			local absoluteValue = math.abs(rootPart.AssemblyLinearVelocity.Y)

			if absoluteValue > 0.1 then
				t5.Splash.Volume = math.clamp((absoluteValue - 100) * 0.72 / 250 + 0.28, 0, 1)

				local splash = t5.Splash

				splash.TimePosition = 0

				if v13 and splash:IsA("AudioPlayer") then
					splash:Play()
				else
					splash.Playing = true
				end
			end

			stopPlayingLoopedSounds(t5.Swimming)

			local swimming = t5.Swimming

			if v13 and swimming:IsA("AudioPlayer") then
				swimming:Play()
			else
				swimming.Playing = true
			end

			t7[t5.Swimming] = true
		end,
		[Enum.HumanoidStateType.Freefall] = function()
			t5.FreeFalling.Volume = 0
			stopPlayingLoopedSounds(t5.FreeFalling)

			local freeFalling = t5.FreeFalling

			if v13 and freeFalling:IsA("AudioPlayer") then
				freeFalling.Looping = true
			else
				freeFalling.Looped = true
			end

			if t5.FreeFalling:IsA("Sound") then
				t5.FreeFalling.PlaybackRegionsEnabled = true
			end

			t5.FreeFalling.LoopRegion = NumberRange.new(2, 9)

			local v114 = t5.FreeFalling

			v114.TimePosition = 0

			if v13 and v114:IsA("AudioPlayer") then
				v114:Play()
			else
				v114.Playing = true
			end

			t7[t5.FreeFalling] = true
		end,
		[Enum.HumanoidStateType.Landed] = function()
			stopPlayingLoopedSounds()

			local absoluteValue = math.abs(rootPart.AssemblyLinearVelocity.Y)

			if absoluteValue > 75 then
				t5.Landing.Volume = math.clamp((absoluteValue - 50) * 1 / 50 + 0, 0, 1)

				local landing = t5.Landing

				landing.TimePosition = 0

				if v13 and landing:IsA("AudioPlayer") then
					landing:Play()

					return
				end

				landing.Playing = true

				return
			end
		end,
		[Enum.HumanoidStateType.Running] = function()
			stopPlayingLoopedSounds(t5.Running)

			local running = t5.Running

			if v13 and running:IsA("AudioPlayer") then
				running:Play()
			else
				running.Playing = true
			end

			t7[t5.Running] = true
		end,
		[Enum.HumanoidStateType.Climbing] = function()
			local climbing = t5.Climbing
			local rootPartAssemblyLinearVelocity = rootPart.AssemblyLinearVelocity
			local v120 = if v9 then getRelativeVelocity(controllerManager, rootPartAssemblyLinearVelocity) else rootPartAssemblyLinearVelocity

			if math.abs(v120.Y) > 0.1 then
				if v13 and climbing:IsA("AudioPlayer") then
					climbing:Play()
				else
					climbing.Playing = true
				end

				stopPlayingLoopedSounds(climbing)
			else
				stopPlayingLoopedSounds()
			end

			t7[climbing] = true
		end,
		[Enum.HumanoidStateType.Seated] = function()
			stopPlayingLoopedSounds()
		end,
		[Enum.HumanoidStateType.Dead] = function()
			stopPlayingLoopedSounds()

			local died = t5.Died

			died.TimePosition = 0

			if v13 and died:IsA("AudioPlayer") then
				died:Play()

				return
			end

			died.Playing = true
		end
	}

	local t9: {[any]: any} = {
		[t5.Climbing] = function(_, p20, p21)
			local playing: boolean = (if v9 then getRelativeVelocity(controllerManager, p21) else p21).Magnitude > 0.1

			if v13 and p20:IsA("AudioPlayer") then
				if p20.IsPlaying and not playing then
					p20:Stop()

					return
				end

				if not p20.IsPlaying and playing then
					p20:Play()

					return
				end
			else
				p20.Playing = playing
			end
		end,
		[t5.FreeFalling] = function(p22, p23, p24)
			if p24.Magnitude > 75 then
				p23.Volume = math.clamp(p23.Volume + p22 * 0.9, 0, 1)

				return
			end

			p23.Volume = 0
		end,
		[t5.Running] = function(_, p26, p27)
			local playing: boolean = p27.Magnitude > 0.5 and humanoid.MoveDirection.Magnitude > 0.5

			if v13 and p26:IsA("AudioPlayer") then
				if p26.IsPlaying and not playing then
					p26:Stop()

					return
				end

				if not p26.IsPlaying and playing then
					p26:Play()

					return
				end
			else
				p26.Playing = playing
			end
		end
	}

	local runningNoPhysics = Enum.HumanoidStateType.RunningNoPhysics
	local running = Enum.HumanoidStateType.Running
	local v88 = humanoid:GetState()
	local t10: {[any]: any} = { [runningNoPhysics] = running }
	local u90 = t10[v88] or humanoid:GetState()

	v88 = function(p28)
		local v134 = t8[p28]

		if v134 then
			v134()
		end

		u90 = p28
	end

	local v91 = u90
	local v92 = t8[v91]

	if v92 then
		v92()
	end

	u90 = v91

	local connection = humanoid.StateChanged:Connect(function(_, p30)
		local v137 = t10[p30] or p30

		if v137 ~= u90 then
			local v138 = t8[v137]

			if v138 then
				v138()
			end

			u90 = v137
		end
	end)

	local connection2 = runService.Stepped:Connect(function(time: number, deltaTime: number)
		for iterKey in pairs(t7) do
			local v142 = t9[iterKey]

			if v142 then
				v142(deltaTime, iterKey, rootPart.AssemblyLinearVelocity)
			end
		end
	end)

	return function()
		connection:Disconnect()
		connection2:Disconnect()

		if v21 and audioEmitter then
			audioEmitter:Destroy()
		end

		for _, v in pairs(t5) do
			v:Destroy()
		end

		table.clear(t5)
	end
end)

local t3: {[any]: any} = {}

local function characterAdded(p33)
	v31:bindRoot(p33)
end
local function characterRemoving(p34)
	v31:unbindRoot(p34)
end
local function playerAdded(player)
	local t11 = t3[player]

	if not t11 then
		t11 = {}
		t3[player] = t11
	end

	if player.Character then
		v31:bindRoot(player.Character)
	end

	table.insert(t11, player.CharacterAdded:Connect(characterAdded))
	table.insert(t11, player.CharacterRemoving:Connect(characterRemoving))
end

for _, v in ipairs(players:GetPlayers()) do
	task.spawn(playerAdded, v)
end

players.PlayerAdded:Connect(playerAdded)
players.PlayerRemoving:Connect(function(player: Player)
	local v100 = t3[player]

	if v100 then
		for _, v in ipairs(v100) do
			v:Disconnect()
		end

		t3[player] = nil
	end

	if player.Character then
		v31:unbindRoot(player.Character)
	end
end)
