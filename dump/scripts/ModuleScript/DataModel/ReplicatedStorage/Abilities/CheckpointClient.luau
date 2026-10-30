-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
local hologram = require(script:WaitForChild("Hologram"))
local u8: boolean = abilityCatalog.CHECKPOINT_MODE == "Orb"
local color3 = Color3.fromRGB(255, 214, 64)
local color32 = Color3.fromRGB(80, 230, 110)
local color33 = Color3.fromRGB(240, 60, 60)
local t1: {[any]: any} = {
	PARAMS = {
		rewindSeconds = 3,
		maxRewindSeconds = 6,
		minDistance = 4,
		jumpDistance = 20,
		jumpSpeed = 400,
		ghostTransparency = 0.25,
		ghostFadeStart = 4,
		ghostFadeFull = 10,
		flashTransparency = 0.15,
		flashTime = 0.45,
		colorSelf = color3,
		colorAlly = color32,
		colorEnemy = color33
	}
}
local params = t1.PARAMS

t1.ATTR_SECONDS = "CheckpointRewindSeconds"
t1.ATTR_GHOST = "CheckpointGhost"
t1.ATTR_GHOST_TRANSPARENCY = "CheckpointGhostTransparency"
t1.ATTR_TRAIL = "CheckpointRewindTrail"

function t1.RewindSeconds()
	local attributeValue: any = workspace:GetAttribute(t1.ATTR_SECONDS)

	if typeof(attributeValue) == "number" and attributeValue == attributeValue then
		return (math.clamp(attributeValue, 0.5, params.maxRewindSeconds))
	end

	return params.rewindSeconds
end
function t1.ColorFor(p1, p2)
	local LocalPlayer: Player = players.LocalPlayer

	if LocalPlayer and p1 == LocalPlayer.UserId then
		return params.colorSelf
	end

	local v36 = LocalPlayer and LocalPlayer:GetAttribute("MatchSide")

	if typeof(v36) == "string" and v36 == p2 then
		return params.colorAlly
	end

	return params.colorEnemy
end
local function ghostTransparency()
	local attributeValue: any = workspace:GetAttribute(t1.ATTR_GHOST_TRANSPARENCY)

	if typeof(attributeValue) == "number" and attributeValue == attributeValue then
		return (math.clamp(attributeValue, 0, 0.95))
	end

	return params.ghostTransparency
end

local LocalPlayer: Player = players.LocalPlayer
local t2 = {}
local n1: number = 1
local u18 = nil
local u19 = nil
local n2 = 0

local function resetHistory()
	t2 = {}
	n1 = 1
end
local function liveBody()
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local humanoid = localPlayerCharacter and localPlayerCharacter:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = localPlayerCharacter and localPlayerCharacter:FindFirstChild("HumanoidRootPart")

	if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return nil, nil
	end

	return humanoid, humanoidRootPart
end
local function eligible(p3, p4)
	if LocalPlayer:GetAttribute("InMatch") == true then
		if LocalPlayer:GetAttribute("MatchId") == nil then
			return false
		end

		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		if typeof(spectating) == "number" and spectating ~= 0 then
			return false
		end

		if p3:GetAttribute("Frozen") == true then
			return false
		end

		if not not p4.Anchored or not p4:IsDescendantOf(workspace) then
			return false
		end

		return true
	end

	return false
end
local function record()
	local v44, v45 = liveBody()

	if not v44 or not v45 or not eligible(v44, v45) then
		if #t2 > 0 then
			t2 = {}
			n1 = 1
		end

		u18 = nil
		u19 = nil

		return
	end

	local v46 = os.clock()
	local cFrame = v45.CFrame
	local v48 = cFrame.Position

	if v45 ~= u18 or u19 and (v48 - u19).Magnitude > params.jumpDistance and (v48 - u19).Magnitude / math.max(v46 - n2, 0.004166666666666667) > params.jumpSpeed then
		t2 = {}
		n1 = 1
	end

	u18 = v45
	u19 = v48
	n2 = v46
	table.insert(t2, { t = v46, cf = cFrame })

	local v49 = t1.RewindSeconds()

	v48 = v46 - (v49 + 0.25)

	local n3: number = #t2

	while n3 > n1 and v48 >= t2[n1 + 1].t do
		n1 += 1
	end

	if n1 > 240 then
		t2 = table.move(t2, n1, n3, 1, {})
		n1 = 1
	end
end
local function target(p5)
	local n6: number = #t2

	if n6 == 0 or n6 < n1 then
		return nil
	end

	local v53 = t1.RewindSeconds()
	local n2 = p5 - v53

	v53 = t2[n1]

	if n2 <= v53.t then
		return v53.cf
	end

	local v55: number = n1
	local n3: number = n6

	while v55 < n3 do
		local n4: number = (v55 + n3 + 1) // 2

		if n2 >= t2[n4].t then
			v55 = n4
		else
			n3 = n4 - 1
		end
	end

	local v58 = t2[v55]
	local v59 = t2[v55 + 1]

	if not v59 then
		return v58.cf
	end

	local cf = v58.cf
	local v61 = v59.cf
	local n5 = n2 - v58.t
	local v63 = math.max(v59.t - v58.t, 0.000001)
	local v64 = math.clamp(n5 / v63, 0, 1)

	return cf:Lerp(v61, v64)
end

local u26 = nil

local function checkpointSlot()
	for iterFirst, value in { "1", "2" }, nil, nil do
		if LocalPlayer:GetAttribute("Ability" .. value .. "Id") == "Checkpoint" then
			return value
		end
	end

	return nil
end
local function slotReady(p6)
	local attributeValue: any = LocalPlayer:GetAttribute("Ability" .. p6 .. "CooldownDuration")
	local attributeValue2: any = LocalPlayer:GetAttribute("Ability" .. p6 .. "CooldownStartedAt")

	if typeof(attributeValue) == "number" and typeof(attributeValue2) == "number" then
		local v70 = os.clock()

		return attributeValue2 + attributeValue <= v70
	end

	return true
end
local function hideGhost()
	local v71 = u26

	if v71 and v71.holo.model.Parent then
		v71.holo.model.Parent = nil
	end
end
local function updateGhost()
	local v72, v73 = liveBody()
	local v74 = nil
	local n1 = 0
	local v76 = v72 and v73 and workspace:GetAttribute(t1.ATTR_GHOST) ~= false and eligible(v72, v73) and checkpointSlot()

	if v76 and (if typeof((LocalPlayer:GetAttribute("Ability" .. v76 .. "CooldownDuration"))) == "number" and typeof((LocalPlayer:GetAttribute("Ability" .. v76 .. "CooldownStartedAt"))) == "number" then LocalPlayer:GetAttribute("Ability" .. v76 .. "CooldownStartedAt") + LocalPlayer:GetAttribute("Ability" .. v76 .. "CooldownDuration") <= os.clock() else true) then
		v74 = target(os.clock())

		if v74 then
			n1 = math.clamp(((v74.Position - v73.Position).Magnitude - params.ghostFadeStart) / (params.ghostFadeFull - params.ghostFadeStart), 0, 1)
		end
	end

	if n1 <= 0 or not v74 or not v73 then
		local v77 = u26

		if v77 and v77.holo.model.Parent then
			v77.holo.model.Parent = nil
		end

		return
	end

	v76 = v73.Parent

	local t3 = u26

	if not t3 or v76 ~= t3.char then
		if t3 then
			t3.holo.model:Destroy()
		end

		u26 = nil

		local hologramBuild = hologram.Build
		local paramsColorSelf = params.colorSelf
		local attributeValue: any = workspace:GetAttribute(t1.ATTR_GHOST_TRANSPARENCY)
		local v82 = if typeof(attributeValue) == "number" and attributeValue == attributeValue then math.clamp(attributeValue, 0, 0.95) else params.ghostTransparency
		local v83 = hologramBuild(v76, paramsColorSelf, v82)

		if not v83 then
			return
		end

		t3 = { alpha = -1, holo = v83, char = v76 }
		u26 = t3
	end

	v76 = t3

	local attributeValue: any = workspace:GetAttribute(t1.ATTR_GHOST_TRANSPARENCY)

	t3 = if typeof(attributeValue) == "number" and attributeValue == attributeValue then math.clamp(attributeValue, 0, 0.95) else params.ghostTransparency

	if t3 ~= v76.holo.base then
		v76.holo.base = t3
		v76.alpha = -1
	end

	if math.abs(v76.alpha - n1) > 0.02 or n1 >= 1 and v76.alpha < 1 then
		hologram.SetFade(v76.holo, n1)
		v76.alpha = n1
	end

	local model = v76.holo.model

	model:PivotTo(v74)
	v76 = workspace:FindFirstChild("Bin") or workspace

	if v76 ~= model.Parent then
		model.Parent = v76
	end
end
local function flash()
	local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local overlay = playerGui and playerGui:FindFirstChild("Overlay")
	local v88 = overlay

	if v88 then
		v88 = overlay:FindFirstChild("CheckpointUser")
	end

	local tweenInfo = TweenInfo.new(params.flashTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	if v88 and v88:IsA("ImageLabel") then
		v88.ImageTransparency = params.flashTransparency
		tweenService:Create(v88, tweenInfo, { ImageTransparency = 1 }):Play()
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		local checkpointRewindFlash: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		checkpointRewindFlash.Name = "CheckpointRewindFlash"
		checkpointRewindFlash.Saturation = -0.6
		checkpointRewindFlash.Contrast = 0.15
		checkpointRewindFlash.TintColor = Color3.fromRGB(255, 240, 205)
		checkpointRewindFlash.Parent = CurrentCamera

		local v92: Tween = tweenService:Create(checkpointRewindFlash, tweenInfo, { Saturation = 0, Contrast = 0, TintColor = Color3.new(1, 1, 1) })

		v92.Completed:Connect(function()
			checkpointRewindFlash:Destroy()
		end)
		v92:Play()
		task.delay(params.flashTime + 1, function()
			if checkpointRewindFlash.Parent then
				checkpointRewindFlash:Destroy()
			end
		end)
	end
end

if not u8 and runService:IsClient() and LocalPlayer then
	runService.Heartbeat:Connect(record)
	runService.RenderStepped:Connect(updateGhost)
	LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(resetHistory)
end

function t1.Cast(p7)
	if p7 ~= LocalPlayer then
		task.spawn(flash)

		return nil
	end

	local v94, v95 = liveBody()

	if v94 and v95 and not v95.Anchored then
		local v96 = target(os.clock())

		if not v96 then
			return -1
		end

		local v97 = v95.Position
		local v98 = v96.Position

		if (v98 - v97).Magnitude < params.minDistance then
			return -1
		end

		v95.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		v95.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		v95.CFrame = CFrame.new(v98) * v95.CFrame.Rotation
		v96 = v95.Parent

		if v96 then
			v96 = v95.Parent:FindFirstChild("MovementController")
		end

		local rewind = v96 and v96:FindFirstChild("Rewind")

		if rewind and rewind:IsA("BindableEvent") then
			rewind:Fire()
		end

		t2 = {}
		n1 = 1
		u19 = v98
		n2 = os.clock()

		local v100 = u26

		if v100 and v100.holo.model.Parent then
			v100.holo.model.Parent = nil
		end

		local sound = require(replicatedStorage:WaitForChild("Sound"))
		local v102 = sound:Find("Abilities.CheckpointTeleport")

		sound:Play(if v102 then "Abilities.CheckpointTeleport" else "Abilities.PortalTP", v95)
		task.spawn(flash)

		return { v98, v97 }
	end

	return -1
end

return if u8 then require(script:WaitForChild("Orb")) else t1
