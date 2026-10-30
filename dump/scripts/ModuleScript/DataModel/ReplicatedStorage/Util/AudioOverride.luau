-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local soundService: SoundService = game:GetService("SoundService")
local tweenService: TweenService = game:GetService("TweenService")
local u3 = nil
local u4 = nil
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local u7 = nil
local connection = nil
local t3: {[any]: any} = {}

local function getSfxVolume()
	local sfxVolume: any = soundService:GetAttribute("SFXVolume")

	if typeof(sfxVolume) == "number" then
		return (math.clamp(sfxVolume, 0, 1))
	end

	return 1
end
local function ensureMapSfxGroup()
	if u7 and u7.Parent then
		return u7
	end

	local mapSFX: SoundGroup = Instance.new("SoundGroup")

	mapSFX.Name = "MapSFX"

	local sfxVolume: any = soundService:GetAttribute("SFXVolume")

	mapSFX.Volume = if typeof(sfxVolume) == "number" then math.clamp(sfxVolume, 0, 1) else 1
	mapSFX.Parent = soundService
	u7 = mapSFX

	if not connection then
		connection = soundService:GetAttributeChangedSignal("SFXVolume"):Connect(function()
			if u7 and u7.Parent then
				local v60 = u7
				local sfxVolume2: any = soundService:GetAttribute("SFXVolume")
				local v62

				if typeof(sfxVolume2) == "number" then
					v62 = math.clamp(sfxVolume2, 0, 1)
				else
					v62 = 1
				end

				v60.Volume = v62
			end
		end)
	end

	return u7
end
local function assignSoundToMapSfx(p1, p2)
	if t3[p1] then
		return
	end

	if p2 and p1:IsDescendantOf(p2) then
		return
	end

	if p1.SoundGroup then
		return
	end

	p1.SoundGroup = ensureMapSfxGroup()
	t3[p1] = true
end
local function restoreSoundGroups()
	for iterKey in pairs(t3) do
		if iterKey.Parent then
			pcall(function()
				iterKey.SoundGroup = nil
			end)
		end
	end

	table.clear(t3)
end
local function destroyMapSfxGroup()
	if u7 and u7.Parent then
		u7:Destroy()
	end

	u7 = nil
end
local function getContainer()
	local __MapAudio: Instance = soundService:FindFirstChild("__MapAudio")

	if __MapAudio and __MapAudio:IsA("Folder") then
		return __MapAudio
	end

	local __MapAudio: Folder = Instance.new("Folder")

	__MapAudio.Name = "__MapAudio"
	__MapAudio.Parent = soundService

	return __MapAudio
end
local function disconnectAll()
	for _, v in ipairs(t1) do
		pcall(function()
			v:Disconnect()
		end)
	end

	table.clear(t1)
	u4 = nil
end
local function takeSnapshotOnce()
	if u3 then
		return
	end

	local t5: {[any]: any} = {}

	for _, v in ipairs(soundService:GetChildren()) do
		if v.Name ~= "__MapAudio" then
			table.insert(t5, v:Clone())
		end
	end

	u3 = { children = t5 }
end
local function restoreSnapshot()
	local v35 = u3

	if not v35 then
		return
	end

	for _, v in ipairs(soundService:GetChildren()) do
		v:Destroy()
	end

	for _, v in ipairs(v35.children) do
		v.Parent = soundService
	end

	u3 = nil
end
local function stopAndClearClones(p3)
	local v41 = p3 or 0

	for _, v in ipairs(t2) do
		if v.Parent then
			if v41 > 0 then
				local tweenInfo = TweenInfo.new(v41, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(v, tweenInfo, { Volume = 0 }):Play()
				task.delay(v41, function()
					if v.Parent then
						pcall(function()
							v:Stop()
						end)
						v:Destroy()
					end
				end)
			else
				pcall(function()
					v:Stop()
				end)
				v:Destroy()
			end
		end
	end

	table.clear(t2)
end
local function applyChildrenFromFolder(p4)
	local fadeOut = p4:GetAttribute("FadeOut")
	local numberValue: number? = tonumber(fadeOut or 0)

	stopAndClearClones(numberValue or 0)

	local __MapAudio: Instance = soundService:FindFirstChild("__MapAudio")
	local v49

	if __MapAudio and __MapAudio:IsA("Folder") then
		v49 = __MapAudio
	else
		local __MapAudio: Folder = Instance.new("Folder")

		__MapAudio.Name = "__MapAudio"
		__MapAudio.Parent = soundService
		v49 = __MapAudio
	end

	for _, v in ipairs(p4:GetChildren()) do
		if v:IsA("Sound") then
			local clone = v:Clone()

			clone.Parent = v49

			if clone:GetAttribute("ForceLooped") ~= false then
				clone.Looped = true
			end

			local fadeIn = p4:GetAttribute("FadeIn")
			local cloneVolume = clone.Volume

			if typeof(fadeIn) == "number" and fadeIn > 0 then
				clone.Volume = 0
				clone:Play()

				local tweenInfo = TweenInfo.new(fadeIn, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(clone, tweenInfo, { Volume = cloneVolume }):Play()
			else
				clone:Play()
			end

			table.insert(t2, clone)
		else
			local clone = v:Clone()

			clone.Parent = v49
		end
	end
end

local module: {[any]: any} = {}

function module.ApplyFromMap(p5)
	task.spawn(function()
		local audioSettings = p5:WaitForChild("AudioSettings", 10)

		if not p5.Parent then
			return
		end

		if not audioSettings or not audioSettings:IsA("Folder") then
			return
		end

		if u4 and audioSettings ~= u4 then
			module.Clear()
		end

		takeSnapshotOnce()
		u4 = audioSettings
		applyChildrenFromFolder(audioSettings)
		ensureMapSfxGroup()

		for _, v in ipairs(p5:GetDescendants()) do
			if v:IsA("Sound") and not t3[v] and (not audioSettings or not v:IsDescendantOf(audioSettings)) and not v.SoundGroup then
				v.SoundGroup = ensureMapSfxGroup()
				t3[v] = true
			end
		end

		table.insert(t1, p5.DescendantAdded:Connect(function(p6)
			if p6:IsA("Sound") then
				local v67 = audioSettings

				if t3[p6] then
					return
				end

				if v67 and p6:IsDescendantOf(v67) then
					return
				end

				if p6.SoundGroup then
					return
				end

				p6.SoundGroup = ensureMapSfxGroup()
				t3[p6] = true

				return
			end
		end))
		table.insert(t1, audioSettings.ChildAdded:Connect(function()
			if u4 ~= audioSettings then
				return
			end

			applyChildrenFromFolder(audioSettings)
		end))
		table.insert(t1, audioSettings.ChildRemoved:Connect(function()
			if u4 ~= audioSettings then
				return
			end

			applyChildrenFromFolder(audioSettings)
		end))
	end)
end
function module.Clear()
	disconnectAll()
	stopAndClearClones(0)
	restoreSoundGroups()

	if u7 and u7.Parent then
		u7:Destroy()
	end

	u7 = nil

	local __MapAudio: Instance = soundService:FindFirstChild("__MapAudio")

	if __MapAudio then
		__MapAudio:Destroy()
	end

	restoreSnapshot()
end

return module
