-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local soundService: SoundService = game:GetService("SoundService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))
local LocalPlayer: Player = players.LocalPlayer
local v8: Instance = replicatedStorage:WaitForChild("MatchRemotes"):WaitForChild("State")
local bgMusic: Instance = workspace:WaitForChild("BGMusic")

local function musicDuck()
	local musicDuck: any = soundService:GetAttribute("MusicDuck")

	return typeof(musicDuck) == "number" and math.clamp(musicDuck, 0, 1) or 1
end

local musicPad: Instance = workspace:FindFirstChild("MusicPad")
local musicShop: Instance = workspace:FindFirstChild("MusicShop")
local musicClan: Instance = workspace:FindFirstChild("MusicClan")
local v14 = tradingPlazaGate.IsTradingPlaza()
local n1
local n2
local n3
local u22
local u24
local n4
local n5
local u30

if v14 then
	local bgMusicVolume = bgMusic.Volume

	local function plazaMusicMult()
		local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")
		local typeName: string = typeof(musicVolumeMultiplier)
		local musicDuck: any = soundService:GetAttribute("MusicDuck")
		local v91 = typeof(musicDuck) == "number" and math.clamp(musicDuck, 0, 1) or 1

		return (typeName == "number" and musicVolumeMultiplier or 1) * v91
	end

	local tradingTunes: Instance = workspace:WaitForChild("Lobby"):WaitForChild("TradingTunes", 30)
	local t1: {[any]: any} = {}

	local function addTrack(p1)
		if p1.SoundId == "" then
			return
		end

		local soundId = p1.SoundId
		local playbackSpeed = p1.PlaybackSpeed
		local name = p1.Name
		local volume = p1.Volume
		local v97 = math.max(0.01, bgMusicVolume)
		local v98 = math.clamp(volume / v97, 0, 2)

		table.insert(t1, { Id = soundId, Speed = playbackSpeed, Name = name, Gain = v98 })
	end

	if tradingTunes then
		if tradingTunes:IsA("Sound") then
			addTrack(tradingTunes)
		end

		for _, v in ipairs(tradingTunes:GetChildren()) do
			if v:IsA("Sound") then
				addTrack(v)
			end
		end
	end

	n1 = 1
	n2 = 0

	local t2: {[any]: any} = {}

	local function pickNext()
		if #t1 <= 1 then
			return 1
		end

		local t6: {[any]: any} = {}

		for i = 1, #t1 do
			if not t2[i] and i ~= n2 then
				table.insert(t6, i)
			end
		end

		if #t6 == 0 then
			for i = 1, #t1 do
				if not t2[i] then
					table.insert(t6, i)
				end
			end
		end

		if #t6 == 0 then
			return (math.max(1, n2))
		end

		local randomNumber = math.random(1, #t6)

		return t6[randomNumber]
	end
	local function loadTrack(p2)
		n2 = p2

		local v104 = t1[p2]

		n1 = v104.Gain
		bgMusic.SoundId = v104.Id
		bgMusic.PlaybackSpeed = v104.Speed
		bgMusic.TimePosition = 0
	end

	if #t1 > 0 then
		local v40 = pickNext()

		n2 = v40

		local v41 = t1[v40]

		n1 = v41.Gain
		bgMusic.SoundId = v41.Id
		bgMusic.PlaybackSpeed = v41.Speed
		bgMusic.TimePosition = 0
	else
		warn("[BGMusicController] Trading Plaza: TradingTunes missing or has no SoundId; keeping default looped track.")
	end

	bgMusic.Looped = #t1 <= 1

	local inspectHUD: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("InspectHUD")
	local inspectMuffle: EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

	inspectMuffle.Name = "InspectMuffle"
	inspectMuffle.HighGain = 0
	inspectMuffle.MidGain = 0
	inspectMuffle.LowGain = 0

	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local u45 = false
	local u46 = nil

	n3 = 0

	local function setMuffle(p3)
		if p3 == u45 then
			return
		end

		u45 = p3
		n3 += 1

		local v106 = n3

		if u46 then
			pcall(function()
				u46:Cancel()
			end)
		end

		if p3 then
			inspectMuffle.Parent = bgMusic
			u46 = tweenService:Create(inspectMuffle, tweenInfo, { HighGain = -80, MidGain = -30 })
			u46:Play()

			return
		end

		u46 = tweenService:Create(inspectMuffle, tweenInfo, { HighGain = 0, MidGain = 0 })
		u46.Completed:Connect(function()
			if v106 == n3 then
				inspectMuffle.Parent = nil
			end
		end)
		u46:Play()
	end
	local function inShootingRange()
		return LocalPlayer:GetAttribute("InMatch") == true
	end

	u22 = nil

	local function applyPlazaState()
		local v107 = inspectHUD.Enabled

		if v107 then
			v107 = LocalPlayer:GetAttribute("InMatch") ~= true
		end

		setMuffle(v107)

		if u22 then
			pcall(function()
				u22:Cancel()
			end)
		end

		local n2

		if LocalPlayer:GetAttribute("InMatch") == true then
			n2 = 0
		else
			local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")
			local typeName: string = typeof(musicVolumeMultiplier)
			local musicDuck: any = soundService:GetAttribute("MusicDuck")
			local v112 = typeof(musicDuck) == "number" and math.clamp(musicDuck, 0, 1) or 1

			n2 = bgMusicVolume * ((typeName == "number" and musicVolumeMultiplier or 1) * v112) * n1
		end

		local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		u22 = tweenService:Create(bgMusic, tweenInfo2, { Volume = n2 })
		u22:Play()
	end

	soundService:GetAttributeChangedSignal("MusicVolumeMultiplier"):Connect(applyPlazaState)
	soundService:GetAttributeChangedSignal("MusicDuck"):Connect(applyPlazaState)
	inspectHUD:GetPropertyChangedSignal("Enabled"):Connect(applyPlazaState)
	LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(applyPlazaState)
	u24 = false
	n4 = 0
	n5 = 0
	u30 = nil

	local function playCurrent()
		n4 += 1

		local v114 = n4

		n5 = os.clock()
		bgMusic.Looped = #t1 <= 1
		print(("[BGMusicController] plaza now playing '%s' (%d/%d)"):format(t1[n2] and t1[n2].Name or "?", n2, #t1))
		bgMusic:Play()
		task.spawn(function()
			local v268 = t1[n2] and t1[n2].Name or "?"
			local n1 = os.clock() + 8

			while v114 == n4 and not bgMusic.IsLoaded and n1 > os.clock() do
				task.wait(0.25)
			end

			if v114 ~= n4 then
				return
			end

			if not bgMusic.IsLoaded then
				warn(("[BGMusicController] plaza track '%s' (%s) did not load in 8s; skipping it this session"):format(v268, bgMusic.SoundId))
				t2[n2] = true
				u30()

				return
			end

			local n3 = bgMusic.TimeLength - bgMusic.TimePosition
			local v271 = math.max(0.1, bgMusic.PlaybackSpeed)

			n1 = n3 / v271

			if n1 > 0 then
				task.wait(n1 + 2)
			end

			if v114 == n4 and not bgMusic.IsPlaying then
				u30()
			end
		end)
	end

	u30 = function()
		local v115 = pickNext()

		n2 = v115

		local v116 = t1[v115]

		n1 = v116.Gain
		bgMusic.SoundId = v116.Id
		bgMusic.PlaybackSpeed = v116.Speed
		bgMusic.TimePosition = 0
		applyPlazaState()
		playCurrent()
	end

	if #t1 > 1 then
		bgMusic.Ended:Connect(function()
			if u24 then
				u30()
			end
		end)
		task.spawn(function()
			while true do
				task.wait(2)

				if u24 and bgMusic.IsLoaded and not bgMusic.IsPlaying and os.clock() - n5 > 3 then
					u30()
				end
			end
		end)
	end

	task.delay(1, function()
		repeat
			task.wait()
		until LocalPlayer:GetAttribute("DataReady")

		bgMusic.TimePosition = 0

		local n2

		if LocalPlayer:GetAttribute("InMatch") == true then
			n2 = 0
		else
			local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")
			local typeName: string = typeof(musicVolumeMultiplier)
			local musicDuck: any = soundService:GetAttribute("MusicDuck")
			local v121 = typeof(musicDuck) == "number" and math.clamp(musicDuck, 0, 1) or 1

			n2 = bgMusicVolume * ((typeName == "number" and musicVolumeMultiplier or 1) * v121) * n1
		end

		bgMusic.Volume = n2

		local v122 = inspectHUD.Enabled

		if v122 then
			v122 = LocalPlayer:GetAttribute("InMatch") ~= true
		end

		setMuffle(v122)
		u24 = true

		if #t1 > 1 then
			playCurrent()

			return
		end

		bgMusic:Play()
	end)

	return
end

local bgMusicSoundId = bgMusic.SoundId
local u52 = nil
local volume = bgMusic.Volume
local n6: number = 0
local u55 = nil
local u56 = nil

n1 = false
n2 = false

if musicPad then
	musicPad.Looped = true
	musicPad.Volume = 0
end

if musicShop then
	musicShop.Looped = true
	musicShop.Volume = 0
end

if musicClan then
	musicClan.Looped = true
	musicClan.Volume = 0
end

bgMusic.Looped = true
task.delay(1, function()
	repeat
		task.wait()
	until LocalPlayer:GetAttribute("DataReady")

	bgMusic.TimePosition = 0
	bgMusic:Play()

	if musicPad then
		musicPad.TimePosition = 0
		musicPad:Play()
	end

	if musicShop then
		musicShop.TimePosition = 0
		musicShop:Play()
	end

	if musicClan then
		musicClan.TimePosition = 0
		musicClan:Play()
	end
end)

local function normalizeSoundId(p4)
	if typeof(p4) ~= "string" then
		if typeof(p4) == "number" then
			return ("rbxassetid://%d"):format(p4)
		end

		return nil
	end

	if p4 == "" then
		return ""
	end

	if string.find(p4, "rbxassetid://", 1, true) then
		return p4
	end

	local numberValue: number? = tonumber(p4)

	if numberValue then
		return ("rbxassetid://%d"):format(numberValue)
	end

	return p4
end
local function getMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	return typeof(matchId) == "string" and matchId or nil
end
local function inRealMatch()
	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")
		local v127 = typeof(matchId) == "string" and matchId or nil

		if v127 and v127 ~= "PRACTICE" then
			local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
			local u129: boolean = true

			if matchSide ~= "A" then
				u129 = matchSide == "B"
			end

			return u129
		end

		return false
	end

	return false
end
local function inPractice()
	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		return (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
	end

	return false
end

u45 = function()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u132: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u132 = lobbySpectateMatchId ~= ""
	end

	return u132
end
u46 = function()
	if u55 then
		pcall(function()
			u55:Cancel()
		end)
		u55 = nil
	end
end
n3 = function(p5, p6)
	if u55 then
		pcall(function()
			u55:Cancel()
		end)
		u55 = nil
	end

	local tweenInfo = TweenInfo.new(p6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v136: Tween = tweenService:Create(bgMusic, tweenInfo, { Volume = p5 })

	u55 = v136
	v136:Play()

	return v136
end

local function hardRestart()
	bgMusic.TimePosition = 0
	bgMusic:Play()
end
local function applySoundIdWithFade(p7, p8)
	if p8 == u52 then
		return
	end

	u52 = p8

	if p7 == bgMusic.SoundId then
		return
	end

	n6 += 1

	local v139: number = n6

	n3(0, 0.2)
	task.delay(0.2, function()
		if v139 ~= n6 then
			return
		end

		bgMusic.SoundId = p7
		bgMusic.TimePosition = 0
		bgMusic:Play()

		local v272 = n3
		local musicMult = getMusicMult()

		v272(volume * musicMult, 0.2)
	end)
end

u22 = function()
	local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")
	local typeName: string = typeof(musicVolumeMultiplier)
	local musicDuck: any = soundService:GetAttribute("MusicDuck")
	local v143 = typeof(musicDuck) == "number" and math.clamp(musicDuck, 0, 1) or 1

	return (typeName == "number" and musicVolumeMultiplier or 1) * v143
end
getMusicMult = u22
u22 = {}

local function cancelZoneTweens()
	for _, v in ipairs(u22) do
		pcall(function()
			v:Cancel()
		end)
	end

	table.clear(u22)
end

u24 = function(p9, p10, p11, p12)
	local tweenInfo = TweenInfo.new(p11, p12 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v151: Tween = tweenService:Create(p9, tweenInfo, { Volume = p10 })

	table.insert(u22, v151)
	v151.Completed:Connect(function()
		for i, v in ipairs(u22) do
			if v == v151 then
				table.remove(u22, i)

				return
			end
		end
	end)
	v151:Play()
end
n4 = function()
	if musicPad and musicPad.Volume > 0 then
		u24(musicPad, 0, 0.2)
	end

	if musicShop and musicShop.Volume > 0 then
		u24(musicShop, 0, 0.2)
	end

	if musicClan and musicClan.Volume > 0 then
		u24(musicClan, 0, 0.2)
	end

	u56 = nil
end
n5 = function(p13)
	if p13 == u56 then
		return
	end

	local v153: Instance = if u56 == "pad" and musicPad then musicPad else if u56 == "shop" and musicShop then musicShop else if u56 == "clan" and musicClan then musicClan else bgMusic
	local v154: Instance = if p13 == "pad" and musicPad then musicPad else if p13 == "shop" and musicShop then musicShop else if p13 == "clan" and musicClan then musicClan else bgMusic

	u56 = p13

	if v154 == bgMusic and bgMusic.SoundId ~= bgMusicSoundId then
		bgMusic.SoundId = bgMusicSoundId
		bgMusic:Play()
	end

	if v154 ~= v153 then
		local timeLength = v154.TimeLength

		v154.TimePosition = timeLength > 0 and v153.TimePosition % timeLength or v153.TimePosition
	end

	cancelZoneTweens()

	local musicMult = getMusicMult()

	u24(v153, 0, 0.6, Enum.EasingStyle.Linear)
	u24(v154, volume * musicMult, 0.6, Enum.EasingStyle.Linear)
end
u30 = {}

local function isZonePartName(p14)
	local u158: boolean = true

	if p14 ~= "Pad1" then
		u158 = true

		if p14 ~= "Pad2" then
			u158 = true

			if p14 ~= "ShopFloor" then
				u158 = true

				if p14 ~= "EffectFloor" then
					u158 = p14 == "ClanFloor"
				end
			end
		end
	end

	return u158
end

local t3: {[any]: any} = {
	workspace:WaitForChild("Lobby"),
	workspace:WaitForChild("DuelStations")
};

(function()
	u30 = {}

	for _, v in ipairs(t3) do
		for _, iterValue in ipairs(v:GetDescendants()) do
			if iterValue:IsA("BasePart") then
				local v163 = iterValue.Name
				local u164: boolean = true

				if v163 ~= "Pad1" then
					u164 = true

					if v163 ~= "Pad2" then
						u164 = true

						if v163 ~= "ShopFloor" then
							u164 = true

							if v163 ~= "EffectFloor" then
								u164 = v163 == "ClanFloor"
							end
						end
					end
				end

				if u164 then
					table.insert(u30, iterValue)
				end
			end
		end
	end
end)()

for _, v in ipairs(t3) do
	v.DescendantAdded:Connect(function(p15)
		if p15:IsA("BasePart") then
			local v166 = p15.Name
			local u167: boolean = true

			if v166 ~= "Pad1" then
				u167 = true

				if v166 ~= "Pad2" then
					u167 = true

					if v166 ~= "ShopFloor" then
						u167 = true

						if v166 ~= "EffectFloor" then
							u167 = v166 == "ClanFloor"
						end
					end
				end
			end

			if u167 then
				table.insert(u30, p15)
			end
		end
	end)
	v.DescendantRemoving:Connect(function(p16)
		for i, iterValue in ipairs(u30) do
			if iterValue == p16 then
				table.remove(u30, i)

				return
			end
		end
	end)
end

local function getPlayerZone()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return nil
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return nil
	end

	local humanoidRootPartPosition = humanoidRootPart.Position

	for _, v in ipairs(u30) do
		local vSize = v.Size
		local v177 = v.CFrame:PointToObjectSpace(humanoidRootPartPosition)

		if math.abs(v177.X) <= vSize.X / 2 and math.abs(v177.Z) <= vSize.Z / 2 and v177.Y >= -(vSize.Y / 2) and v177.Y <= vSize.Y / 2 + 40 then
			local vName = v.Name

			if vName == "Pad1" or vName == "Pad2" then
				return "pad"
			end

			if vName == "ClanFloor" then
				return "clan"
			end

			return "shop"
		end
	end

	return nil
end
local function isMMQueued()
	return LocalPlayer:GetAttribute("MMQueued") == true
end
local function getDesiredZone()
	if LocalPlayer:GetAttribute("MMQueued") == true then
		return "pad"
	end

	return (getPlayerZone())
end
local function applyCurrentVolume()
	cancelZoneTweens()

	local musicMult = getMusicMult()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u181: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u181 = lobbySpectateMatchId ~= ""
	end

	local v182: boolean = false

	if u181 then
		local u183

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v185 = typeof(matchId) == "string" and matchId or nil

			if v185 and v185 ~= "PRACTICE" then
				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

				u183 = true

				if matchSide ~= "A" then
					u183 = matchSide == "B"
				end
			else
				u183 = false
			end
		else
			u183 = false
		end

		if not u183 then
			local u187

			if LocalPlayer:GetAttribute("InMatch") == true then
				local matchId: any = LocalPlayer:GetAttribute("MatchId")

				u187 = (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
			else
				u187 = false
			end

			if not u187 then
				bgMusic.Volume = 0
				v182 = true
			end
		end
	end

	local u190

	if not v182 then
		u190 = nil

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")

			u190 = (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
		else
			u190 = false
		end

		if not u190 then
			local u192

			if LocalPlayer:GetAttribute("InMatch") == true then
				local matchId: any = LocalPlayer:GetAttribute("MatchId")
				local v194 = typeof(matchId) == "string" and matchId or nil

				if v194 and v194 ~= "PRACTICE" then
					local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

					u192 = true

					if matchSide ~= "A" then
						u192 = matchSide == "B"
					end
				else
					u192 = false
				end
			else
				u192 = false
			end

			if not u192 or not n2 then
				if u56 == "pad" and musicPad then
					musicPad.Volume = volume * musicMult
					bgMusic.Volume = 0

					if musicShop then
						musicShop.Volume = 0
					end

					if musicClan then
						musicClan.Volume = 0

						return
					end
				elseif u56 == "shop" and musicShop then
					musicShop.Volume = volume * musicMult
					bgMusic.Volume = 0

					if musicPad then
						musicPad.Volume = 0
					end

					if musicClan then
						musicClan.Volume = 0

						return
					end
				elseif u56 == "clan" and musicClan then
					musicClan.Volume = volume * musicMult
					bgMusic.Volume = 0

					if musicPad then
						musicPad.Volume = 0
					end

					if musicShop then
						musicShop.Volume = 0

						return
					end
				else
					bgMusic.Volume = volume * musicMult

					if musicPad then
						musicPad.Volume = 0
					end

					if musicShop then
						musicShop.Volume = 0
					end

					if musicClan then
						musicClan.Volume = 0
					end
				end

				return
			end
		end

		bgMusic.Volume = volume * musicMult
	end

	if musicPad then
		musicPad.Volume = 0
	end

	if musicShop then
		musicShop.Volume = 0
	end

	if musicClan then
		musicClan.Volume = 0

		return
	end
end

soundService:GetAttributeChangedSignal("MusicVolumeMultiplier"):Connect(applyCurrentVolume)
soundService:GetAttributeChangedSignal("MusicDuck"):Connect(applyCurrentVolume)

local playerGuiInspectHUD: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("InspectHUD")
local t4: {[any]: any} = {}
local t5: {[any]: any} = { bgMusic }

if musicPad then
	table.insert(t5, musicPad)
end

if musicShop then
	table.insert(t5, musicShop)
end

if musicClan then
	table.insert(t5, musicClan)
end

for _, v in ipairs(t5) do
	local equalizerSoundEffect: EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

	equalizerSoundEffect.Name = "InspectMuffle"
	equalizerSoundEffect.HighGain = 0
	equalizerSoundEffect.MidGain = 0
	equalizerSoundEffect.LowGain = 0
	table.insert(t4, { eq = equalizerSoundEffect, sound = v })
end

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u79 = false
local n7: number = 0

local function setInspectMuffle(p17)
	if p17 == u79 then
		return
	end

	u79 = p17
	n7 += 1

	local v197: number = n7

	for _, v in ipairs(t4) do
		local vEq = v.eq

		if p17 then
			vEq.Parent = v.sound
			tweenService:Create(vEq, tweenInfo, { HighGain = -80, MidGain = -30 }):Play()
		else
			local v201: Tween = tweenService:Create(vEq, tweenInfo, { HighGain = 0, MidGain = 0 })

			v201.Completed:Connect(function()
				if v197 == n7 then
					vEq.Parent = nil
				end
			end)
			v201:Play()
		end
	end
end

playerGuiInspectHUD:GetPropertyChangedSignal("Enabled"):Connect(function()
	n1 = playerGuiInspectHUD.Enabled
	setInspectMuffle(n1)
end)
task.spawn(function()
	local u202

	while true do
		task.wait(0.3)

		local inMatch
		local matchId
		local typeName
		local v206
		local matchSide
		local u208
		local lobbySpectateMatchId
		local u210
		local typeName3
		local inMatch2
		local matchId2
		local typeName2
		local v215
		local matchSide2
		local u217
		local mmQueued
		local s1

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId3: any = LocalPlayer:GetAttribute("MatchId")

			u202 = (typeof(matchId3) == "string" and matchId3 or nil) == "PRACTICE"

			if not u202 then
				inMatch = LocalPlayer:GetAttribute("InMatch")

				if inMatch == true then
					matchId = LocalPlayer:GetAttribute("MatchId")
					typeName = typeof(matchId)
					v206 = typeName == "string" and matchId or nil

					if v206 and v206 ~= "PRACTICE" then
						matchSide = LocalPlayer:GetAttribute("MatchSide")
						u208 = true

						if matchSide ~= "A" then
							u208 = matchSide == "B"
						end
					else
						u208 = false
					end
				else
					u208 = false
				end

				if not u208 or not n2 then
					lobbySpectateMatchId = LocalPlayer:GetAttribute("LobbySpectateMatchId")
					u210 = false
					typeName3 = typeof(lobbySpectateMatchId)

					if typeName3 == "string" then
						u210 = lobbySpectateMatchId ~= ""
					end

					if not u210 then
						inMatch2 = LocalPlayer:GetAttribute("InMatch")

						if inMatch2 == true then
							matchId2 = LocalPlayer:GetAttribute("MatchId")
							typeName2 = typeof(matchId2)
							v215 = typeName2 == "string" and matchId2 or nil

							if v215 and v215 ~= "PRACTICE" then
								matchSide2 = LocalPlayer:GetAttribute("MatchSide")
								u217 = true

								if matchSide2 ~= "A" then
									u217 = matchSide2 == "B"
								end
							else
								u217 = false
							end
						else
							u217 = false
						end

						if not u217 and LocalPlayer:GetAttribute("VotingPhase") ~= true then
							mmQueued = LocalPlayer:GetAttribute("MMQueued")
							s1 = if mmQueued == true then "pad" else getPlayerZone()

							if s1 == u56 then
								continue
							end

							n5(s1)
						end

						continue
					end
				end
			end

			if u56 == nil then
				continue
			end

			n4()

			continue
		end

		local u202 = false

		if true then
			local u208

			if LocalPlayer:GetAttribute("InMatch") == true then
				local matchId = LocalPlayer:GetAttribute("MatchId")
				local v206 = typeof(matchId) == "string" and matchId or nil

				if v206 and v206 ~= "PRACTICE" then
					local matchSide = LocalPlayer:GetAttribute("MatchSide")

					u208 = true

					if matchSide ~= "A" then
						u208 = matchSide == "B"
					end
				else
					u208 = false
				end
			else
				u208 = false
			end

			if not u208 or not n2 then
				local lobbySpectateMatchId = LocalPlayer:GetAttribute("LobbySpectateMatchId")
				local u210 = false

				if typeof(lobbySpectateMatchId) == "string" then
					u210 = lobbySpectateMatchId ~= ""
				end

				if not u210 then
					local u217

					if LocalPlayer:GetAttribute("InMatch") == true then
						local matchId2 = LocalPlayer:GetAttribute("MatchId")
						local v215 = typeof(matchId2) == "string" and matchId2 or nil

						if v215 and v215 ~= "PRACTICE" then
							local matchSide2 = LocalPlayer:GetAttribute("MatchSide")

							u217 = true

							if matchSide2 ~= "A" then
								u217 = matchSide2 == "B"
							end
						else
							u217 = false
						end
					else
						u217 = false
					end

					if not u217 and LocalPlayer:GetAttribute("VotingPhase") ~= true then
						local s1 = if LocalPlayer:GetAttribute("MMQueued") == true then "pad" else getPlayerZone()

						if s1 == u56 then
							continue
						end

						n5(s1)
					end

					continue
				end
			end
		end

		if u56 ~= nil then
			n4()
		end
	end
end)

local function setToEmpty()
	applySoundIdWithFade("", "empty")
end
local function setToDefault()
	applySoundIdWithFade(bgMusicSoundId, "default")
end
local function setToPractice()
	applySoundIdWithFade("rbxassetid://97013308889970", "practice")
end
local function applyForPayload(p18)
	if typeof(p18) == "table" then
		local v222 = normalizeSoundId(p18.mapMusicId)

		if v222 == nil then
			applySoundIdWithFade("", "empty")

			return
		end

		applySoundIdWithFade(v222, "id:" .. v222)

		return
	end

	applySoundIdWithFade("", "empty")
end
local function refreshFromAttrs()
	local u223

	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		u223 = (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
	else
		u223 = false
	end

	if u223 then
		n2 = false
		n4()
		applySoundIdWithFade("rbxassetid://97013308889970", "practice")

		return
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
	local u226: boolean = false

	if typeof(lobbySpectateMatchId) == "string" then
		u226 = lobbySpectateMatchId ~= ""
	end

	if u226 then
		local u227

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v229 = typeof(matchId) == "string" and matchId or nil

			if v229 and v229 ~= "PRACTICE" then
				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

				u227 = true

				if matchSide ~= "A" then
					u227 = matchSide == "B"
				end
			else
				u227 = false
			end
		else
			u227 = false
		end

		if not u227 then
			n4()

			if u55 then
				pcall(function()
					u55:Cancel()
				end)
				u55 = nil
			end

			bgMusic.Volume = 0

			return
		end
	end

	if LocalPlayer:GetAttribute("VotingPhase") ~= true then
		local u231

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v233 = typeof(matchId) == "string" and matchId or nil

			if v233 and v233 ~= "PRACTICE" then
				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

				u231 = true

				if matchSide ~= "A" then
					u231 = matchSide == "B"
				end
			else
				u231 = false
			end
		else
			u231 = false
		end

		if not u231 then
			if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
				return
			end

			if bgMusic.SoundId ~= bgMusicSoundId then
				bgMusic.SoundId = bgMusicSoundId
				bgMusic:Play()
			end

			u52 = nil

			local s1 = if LocalPlayer:GetAttribute("MMQueued") == true then "pad" else getPlayerZone()

			if s1 ~= u56 then
				n5(s1)
			elseif s1 == nil then
				local musicMult = getMusicMult()
				local n1 = volume * musicMult

				if math.abs(bgMusic.Volume - n1) > 0.01 then
					u24(bgMusic, n1, 0.2)
				end
			end

			return
		end
	end

	if not n2 then
		n5("pad")
	end
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(refreshFromAttrs)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshFromAttrs)
LocalPlayer:GetAttributeChangedSignal("MatchSide"):Connect(refreshFromAttrs)
LocalPlayer:GetAttributeChangedSignal("VotingPhase"):Connect(refreshFromAttrs)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(refreshFromAttrs)
LocalPlayer:GetAttributeChangedSignal("MMQueued"):Connect(function()
	local u238

	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		u238 = (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
	else
		u238 = false
	end

	if not u238 then
		local u240

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v242 = typeof(matchId) == "string" and matchId or nil

			if v242 and v242 ~= "PRACTICE" then
				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

				u240 = true

				if matchSide ~= "A" then
					u240 = matchSide == "B"
				end
			else
				u240 = false
			end
		else
			u240 = false
		end

		if not u240 then
			local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
			local u245 = false

			if typeof(lobbySpectateMatchId) == "string" then
				u245 = lobbySpectateMatchId ~= ""
			end

			if u245 then
				return
			end

			if LocalPlayer:GetAttribute("VotingPhase") == true then
				return
			end

			if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
				return
			end

			u245 = n5

			local s1 = if LocalPlayer:GetAttribute("MMQueued") == true then "pad" else getPlayerZone()

			u245(s1)

			return
		end

		return
	end
end)
LocalPlayer:GetAttributeChangedSignal("_WinScreenOpen"):Connect(function()
	if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
		return
	end

	local u247

	if LocalPlayer:GetAttribute("InMatch") == true then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		u247 = (typeof(matchId) == "string" and matchId or nil) == "PRACTICE"
	else
		u247 = false
	end

	if not u247 then
		local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
		local u250: boolean = false

		if typeof(lobbySpectateMatchId) == "string" then
			u250 = lobbySpectateMatchId ~= ""
		end

		if not u250 then
			local u251

			if LocalPlayer:GetAttribute("InMatch") == true then
				local matchId: any = LocalPlayer:GetAttribute("MatchId")
				local v253 = typeof(matchId) == "string" and matchId or nil

				if v253 and v253 ~= "PRACTICE" then
					local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

					u251 = true

					if matchSide ~= "A" then
						u251 = matchSide == "B"
					end
				else
					u251 = false
				end
			else
				u251 = false
			end

			if u251 then
				return
			end

			if LocalPlayer:GetAttribute("VotingPhase") == true then
				return
			end

			refreshFromAttrs()

			return
		end

		return
	end
end)
v8.OnClientEvent:Connect(function(p19, p20)
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local v258 = typeof(matchId) == "string" and matchId or nil

	if v258 and p19 == v258 then
		local u259

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId2: any = LocalPlayer:GetAttribute("MatchId")

			u259 = (typeof(matchId2) == "string" and matchId2 or nil) == "PRACTICE"
		else
			u259 = false
		end

		if u259 then
			applySoundIdWithFade("rbxassetid://97013308889970", "practice")

			return
		end

		local u261

		if LocalPlayer:GetAttribute("InMatch") == true then
			local matchId3: any = LocalPlayer:GetAttribute("MatchId")
			local v263 = typeof(matchId3) == "string" and matchId3 or nil

			if v263 and v263 ~= "PRACTICE" then
				local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

				u261 = true

				if matchSide ~= "A" then
					u261 = matchSide == "B"
				end
			else
				u261 = false
			end
		else
			u261 = false
		end

		if not u261 then
			applySoundIdWithFade(bgMusicSoundId, "default")

			return
		end

		local v265 = typeof(p20) == "table" and p20.t or nil

		if v265 == "MatchStarted" or v265 == "RoundLoading" then
			n2 = false
			n5("pad")
		elseif v265 == "SkillSelect" or v265 == "Countdown" then
			n2 = false

			if (typeof(p20) == "table" and tonumber(p20.round) or 1) == 1 then
				n5("pad")

				return
			end

			n4()

			if bgMusic.Volume > 0 then
				u24(bgMusic, 0, 0.2)

				return
			end
		elseif v265 == "CountdownTick" then
			local v266 = typeof(p20) == "table" and tonumber(p20.left) or 0

			if v266 <= 2 and musicPad and musicPad.Volume > 0.05 then
				cancelZoneTweens()
				u24(musicPad, 0, v266 * 0.9)

				return
			end
		else
			if v265 == "RoundLive" then
				n2 = true
				n4()

				if typeof(p20) == "table" then
					local v267 = normalizeSoundId(p20.mapMusicId)

					if v267 == nil then
						applySoundIdWithFade("", "empty")
					else
						applySoundIdWithFade(v267, "id:" .. v267)
					end
				else
					applySoundIdWithFade("", "empty")
				end

				return
			end

			if v265 == "MatchEnded" then
				n2 = false
				task.spawn(function()
					local v276 = os.clock()

					while true do
						if LocalPlayer:GetAttribute("_WinScreenOpen") ~= true or not (os.clock() - v276 < 600) then
							break
						end

						task.wait()
					end

					v276 = if LocalPlayer:GetAttribute("MMQueued") == true then "pad" else getPlayerZone()

					if v276 == nil then
						applySoundIdWithFade(bgMusicSoundId, "default")

						return
					end

					if bgMusic.SoundId ~= bgMusicSoundId then
						bgMusic.SoundId = bgMusicSoundId
						bgMusic:Play()
					end

					u52 = nil
					n5(v276)
				end)
			end
		end

		return
	end
end)
refreshFromAttrs()
