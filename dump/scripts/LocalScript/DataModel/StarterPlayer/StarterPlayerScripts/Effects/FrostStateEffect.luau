-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

game:GetService("RunService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local slowModule = require(shared:WaitForChild("SlowModule"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(replicatedStorageShared:WaitForChild("ViewedPlayer"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local debris = require(util:WaitForChild("Debris"))
local LocalPlayer: Player = players.LocalPlayer
local characters: Instance = workspace:WaitForChild("Characters")
local t1: {[any]: any} = {}

local function isLocalCharacter(p1)
	return viewedPlayer.IsViewed(p1)
end
local function getBodyParticleTemplates()
	local fx: Instance = replicatedStorage:FindFirstChild("FX")

	if not fx then
		return nil
	end

	local statusEffects: Instance = fx:FindFirstChild("StatusEffects")

	if not statusEffects then
		return nil
	end

	local frost: Instance = statusEffects:FindFirstChild("Frost")

	if frost and frost:IsA("Folder") then
		return frost
	end

	return nil
end
local function isFrostBodyLimb(p2)
	if not p2:IsA("BasePart") then
		return false
	end

	if p2.Name == "HumanoidRootPart" then
		return false
	end

	return true
end
local function spawnBodyVfx(p3)
	local fx: Instance = replicatedStorage:FindFirstChild("FX")
	local v40

	if not fx then
		v40 = nil
	else
		local statusEffects: Instance = fx:FindFirstChild("StatusEffects")

		if not statusEffects then
			v40 = nil
		else
			local frost: Instance = statusEffects:FindFirstChild("Frost")

			v40 = if frost and frost:IsA("Folder") then frost else nil
		end
	end

	if not v40 then
		return
	end

	p3.bodyParticles = {}

	for _, v in ipairs(p3.character:GetChildren()) do
		if if not v:IsA("BasePart") then false else v.Name ~= "HumanoidRootPart" then
			for _, iterValue in ipairs(v40:GetChildren()) do
				if iterValue:IsA("ParticleEmitter") then
					local clone = iterValue:Clone()

					clone.Name = "FROSTVFX_BODY"
					clone.Parent = v
					table.insert(p3.bodyParticles, clone)
				end
			end
		end
	end
end
local function updateBodyVfxIntensity(_, _)
end
local function destroyBodyVfx(p6)
	local bodyParticles = p6.bodyParticles

	if not bodyParticles then
		return
	end

	p6.bodyParticles = nil

	for _, v in ipairs(bodyParticles) do
		if v.Parent then
			v.Enabled = false
			debris:AddItem(v, v.Lifetime.Max + 0.15)
		end
	end
end

local t2: {[any]: any} = { 0.9, 0.3, 0 }
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function frostTransparencyForStacks(p7)
	if p7 <= 0 then
		return 1
	end

	if p7 >= 3 then
		return t2[3]
	end

	return t2[p7] or 1
end
local function getOverlayRefs()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return nil, nil
	end

	local overlay: Instance = playerGui:FindFirstChild("Overlay")

	if not overlay then
		return nil, nil
	end

	local frost: Instance = overlay:FindFirstChild("Frost")

	if not frost or not frost:IsA("ImageLabel") then
		return nil, nil
	end

	local layer = frost:FindFirstChild("Layer")

	if layer and not layer:IsA("ImageLabel") then
		layer = nil
	end

	return frost, layer
end
local function cancelScreenTweens(p8)
	if p8.frostTween then
		p8.frostTween:Cancel()
		p8.frostTween = nil
	end

	if p8.layerTween then
		p8.layerTween:Cancel()
		p8.layerTween = nil
	end
end

local u24 = nil

local function spawnScreenVfx(p9)
	if not viewedPlayer.IsViewed(p9.character) then
		return
	end

	u24(p9, p9.lastStacks)
end

u24 = function(p10, p11)
	if not viewedPlayer.IsViewed(p10.character) then
		return
	end

	local v63, v64 = getOverlayRefs()

	if not v63 then
		return
	end

	if p10.frostTween then
		p10.frostTween:Cancel()
		p10.frostTween = nil
	end

	if p10.layerTween then
		p10.layerTween:Cancel()
		p10.layerTween = nil
	end

	p10.frostTween = tweenService:Create(v63, tweenInfo, {
		ImageTransparency = if p11 <= 0 then 1 else if p11 >= 3 then t2[3] else t2[p11] or 1
	})
	p10.frostTween:Play()

	if v64 then
		p10.layerTween = tweenService:Create(v64, tweenInfo, { ImageTransparency = 0 })
		p10.layerTween:Play()
	end
end

local function destroyScreenVfx(p12)
	if p12.frostTween then
		p12.frostTween:Cancel()
		p12.frostTween = nil
	end

	if p12.layerTween then
		p12.layerTween:Cancel()
		p12.layerTween = nil
	end

	local v66, v67 = getOverlayRefs()

	if not v66 then
		return
	end

	p12.frostTween = tweenService:Create(v66, tweenInfo, { ImageTransparency = 1 })
	p12.frostTween:Play()

	if v67 then
		p12.layerTween = tweenService:Create(v67, tweenInfo, { ImageTransparency = 1 })
		p12.layerTween:Play()
	end
end
local function destroyState(p13)
	local v69 = t1[p13]

	if not v69 then
		return
	end

	if v69.attrConn then
		v69.attrConn:Disconnect()
	end

	if v69.stacksConn then
		v69.stacksConn:Disconnect()
	end

	if v69.diedConn then
		v69.diedConn:Disconnect()
	end

	if v69.ancestryConn then
		v69.ancestryConn:Disconnect()
	end

	destroyBodyVfx(v69)
	destroyScreenVfx(v69)
	t1[p13] = nil
end
local function ensureState(p14)
	local v71 = t1[p14]

	if v71 then
		return v71
	end

	v71 = {
		attrConn = nil,
		stacksConn = nil,
		diedConn = nil,
		ancestryConn = nil,
		lastStacks = 0,
		character = p14
	}
	t1[p14] = v71

	return v71
end
local function refreshCharacter(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	humanoid = humanoid and humanoid.Health > 0

	if humanoid then
		humanoid = slowModule.IsFrosted(character)
	end

	local v74 = humanoid and slowModule.GetFrostStacks(character) or 0
	local v75 = t1[character]

	if humanoid then
		if not v75 then
			local v76 = t1[character]
			local t3

			if v76 then
				t3 = v76
			else
				local t4: {[any]: any} = {
					attrConn = nil,
					stacksConn = nil,
					diedConn = nil,
					ancestryConn = nil,
					lastStacks = 0,
					character = character
				}

				t1[character] = t4
				t3 = t4
			end

			if not t3 then
				return
			end

			t3.lastStacks = v74
			spawnBodyVfx(t3)

			if not viewedPlayer.IsViewed(t3.character) then
				return
			end

			u24(t3, t3.lastStacks)

			return
		end

		if v74 ~= v75.lastStacks then
			v75.lastStacks = v74
			u24(v75, v74)

			return
		end
	elseif v75 then
		destroyState(character)
	end
end
local function hookCharacter(character)
	if t1[character] then
		return
	end

	local connection = character:GetAttributeChangedSignal("Frosted"):Connect(function()
		refreshCharacter(character)
	end)

	local connection2 = character:GetAttributeChangedSignal("FrostStacks"):Connect(function()
		refreshCharacter(character)
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local connection3 = nil

	if humanoid then
		connection3 = humanoid.Died:Connect(function()
			destroyState(character)
		end)
	end

	local connection4 = nil

	connection4 = character.AncestryChanged:Connect(function(_, p18)
		if p18 == nil then
			connection:Disconnect()
			connection2:Disconnect()

			if connection3 then
				connection3:Disconnect()
			end

			if connection4 then
				connection4:Disconnect()
			end

			destroyState(character)
		end
	end)
	refreshCharacter(character)
end

for _, v in ipairs(characters:GetChildren()) do
	if v:IsA("Model") then
		hookCharacter(v)
	end
end

characters.ChildAdded:Connect(function(p19: Instance)
	if p19:IsA("Model") then
		hookCharacter(p19)
	end
end)
characters.ChildRemoved:Connect(function(p20: Instance)
	if p20:IsA("Model") then
		destroyState(p20)
	end
end)
task.spawn(function()
	while true do
		task.wait(2)

		for k, _ in pairs(t1) do
			if not k:IsDescendantOf(workspace) then
				destroyState(k)
			end
		end
	end
end)
