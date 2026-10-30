-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local soundService: SoundService = game:GetService("SoundService")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local lighting: Lighting = game:GetService("Lighting")

game:GetService("HttpService")

local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local hud: Instance = playerGui:WaitForChild("HUD")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local fovController = require(shared:WaitForChild("FOVController"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")

require(replicatedStorageShared:WaitForChild("GameFlags"))

local v13: Instance = replicatedStorage:WaitForChild("Shared")
local tradePublicFlags = require(v13:WaitForChild("TradePublicFlags"))
local v15: Instance = replicatedStorage:WaitForChild("Shared")
local settings = require(v15:WaitForChild("Settings"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local mobileTouchController = require(replicatedStorageExtensions:WaitForChild("MobileTouchController"))
local v22: Instance = replicatedStorage:WaitForChild("Shared")
local controlLayout = require(v22:WaitForChild("ControlLayout"))
local v24: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(v24:WaitForChild("TradingPlazaGate"))
local noobifyMeshStash: Folder = Instance.new("Folder", game.ReplicatedStorage)

noobifyMeshStash.Name = "NoobifyMeshStash"

local updateSettings: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("UpdateSettings")
local closeSettings: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("CloseSettings")
local settingsWindow: Instance = hud:WaitForChild("SettingsWindow")
local content: Instance = settingsWindow:WaitForChild("Content")
local scrollingFrame: Instance = content:WaitForChild("ScrollingFrame")
local closeButton: Instance = settingsWindow:WaitForChild("CloseButton")

scrollingFrame.SelectionGroup = true
scrollingFrame.Selectable = false

local uiListLayout: Instance = scrollingFrame:FindFirstChildWhichIsA("UIListLayout")
local v34 = if uiListLayout then uiListLayout.Padding.Scale else 0

scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if uiListLayout then
		local uDimNew = UDim.new
		local rounded = math.round(v34 * scrollingFrame.AbsoluteSize.Y)

		uiListLayout.Padding = uDimNew(0, rounded)
	end
end)

if uiListLayout then
	local uDimNew = UDim.new
	local rounded = math.round(v34 * scrollingFrame.AbsoluteSize.Y)

	uiListLayout.Padding = uDimNew(0, rounded)
end

local v37 = table.clone(settings)
local u38: boolean = false
local u39: boolean = false

local function queueSave()
	if u39 then
		return
	end

	u39 = true
	task.delay(0.3, function()
		u39 = false
		updateSettings:FireServer("Update", v37)
	end)
end

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v42: Instance = replicatedStorage:WaitForChild("Extensions")

local v43 = require(v42:WaitForChild("GamepadSliderController")).new({
	actionPrefix = "Settings",
	scrollFrame = scrollingFrame,
	windowFrame = settingsWindow,
	closeButton = closeButton,
	closeFn = function()
		closeSettings:Fire()
	end
})

settingsWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if not settingsWindow.Visible then
		v43:deactivate()
	elseif inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		task.defer(function()
			v43:activate()
		end)

		return
	end
end)
inputCategorizer.lastInputCategoryChanged:Connect(function(p1)
	if not settingsWindow.Visible then
		return
	end

	if p1 == inputCategorizer.InputCategory.Gamepad then
		task.defer(function()
			v43:activate()
		end)

		return
	end

	v43:deactivate()
end)

local function wireSlider(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
	local barContainer = p2:WaitForChild("BarContainer")
	local bar = barContainer:WaitForChild("Bar")
	local knob = bar:FindFirstChild("Knob")
	local uiFrameworkWireSlider = uiFramework.wireSlider
	local value = p2:FindFirstChild("Value")
	local v139 = uiFrameworkWireSlider({
		barContainer = barContainer,
		innerBar = bar,
		knob = knob,
		valueLabel = value,
		min = p3,
		max = p4,
		default = p5,
		getValue = p6,
		setValue = p7,
		onChange = queueSave,
		isPercent = p8,
		snapValue = p9,
		formatSuffix = p10,
		normalizeDefault = p11
	})

	v43:addSlider(p2, v139.adjustByDelta)

	return v139.refresh
end
local function wireToggle(p12, _, p14, p15)
	local toggle = p12:WaitForChild("Toggle")
	local circle = toggle:WaitForChild("Circle")
	local equipStroke = toggle:FindFirstChild("EquipStroke")
	local defaultStroke = toggle:FindFirstChild("DefaultStroke")
	local u148 = nil
	local u149 = nil

	for _, v in ipairs(toggle:GetChildren()) do
		if v:IsA("UIGradient") then
			if equipStroke and v.Enabled == equipStroke.Enabled then
				u148 = v
			else
				u149 = v
			end
		end
	end

	local function setVisual(enabled)
		local uDim2 = UDim2.new(if enabled then 0.965 else 0.481, 0, 0.5, 0)

		tweenService:Create(circle, tweenInfo, { Position = uDim2 }):Play()

		if u148 then
			u148.Enabled = enabled
		end

		if u149 then
			u149.Enabled = not enabled
		end

		if equipStroke then
			equipStroke.Enabled = enabled
		end

		if defaultStroke then
			defaultStroke.Enabled = not enabled
		end
	end

	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local u309: boolean = not p14()

			p15(u309)
			setVisual(u309)

			if u39 then
				return
			end

			u39 = true
			task.delay(0.3, function()
				u39 = false
				updateSettings:FireServer("Update", v37)
			end)

			return
		end
	end)
	v43:addToggle(p12, function()
		local u310: boolean = not p14()

		p15(u310)
		setVisual(u310)

		if u39 then
			return
		end

		u39 = true
		task.delay(0.3, function()
			u39 = false
			updateSettings:FireServer("Update", v37)
		end)
	end)
	setVisual(p14())

	return function()
		setVisual(p14())
	end
end
local function applyDisableFinishers()
	soundService:SetAttribute("DisableFinishers", v37.DisableFinishers)
end
local function applyDisableFPEffects()
	LocalPlayer:SetAttribute("DisableFPEffects", v37.DisableFPEffects)
end

local t1: {[any]: any} = {}

local function collectMusicSounds()
	table.clear(t1)

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Sound") and v.Parent and v.Parent.Name == "AudioSettings" and v.Name == "Background" then
			table.insert(t1, v)
		end
	end
end

local t2: {[any]: any} = {}

local function applyMusicVolume()
	local n1 = v37.MusicVolume / 100

	soundService:SetAttribute("MusicVolumeMultiplier", n1)

	for _, v in ipairs(t1) do
		if t2[v] == nil then
			t2[v] = v.Volume
		end

		v.Volume = t2[v] * n1
	end
end
local function applySFXVolume()
	soundService:SetAttribute("SFXVolume", v37.SFXVolume / 100)
end

local t3: {[any]: any} = {}

local function applyLowVFX()
	local lowVFX = v37.LowVFX

	for _, v in ipairs(replicatedStorage:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			local emitCount = v:GetAttribute("EmitCount")

			if typeof(emitCount) == "number" then
				if t3[v] == nil then
					t3[v] = emitCount
				end

				if lowVFX then
					local roundedUp = math.ceil(t3[v] / 3)

					v:SetAttribute("EmitCount", roundedUp)
				else
					v:SetAttribute("EmitCount", t3[v])
				end
			end
		end
	end
end

local t4: {[any]: any} = { [Enum.Material.Neon] = true }
local t5: {[any]: any} = { DevelopmentGrid = true }
local t6: {[any]: any} = {}
local t7: {[any]: any} = {}
local __LocalDisabledSurfaceAppearances: Folder = Instance.new("Folder")

__LocalDisabledSurfaceAppearances.Name = "__LocalDisabledSurfaceAppearances"
__LocalDisabledSurfaceAppearances.Parent = replicatedStorage

local t8: {[any]: any} = {}
local characters: Instance = workspace:WaitForChild("Characters")

if characters then
	table.insert(t8, characters)
end

local bin: Instance = workspace:WaitForChild("Bin")

if bin then
	table.insert(t8, bin)
end

local function isExcluded(p18)
	for _, v in ipairs(t8) do
		if p18:IsDescendantOf(v) then
			return true
		end
	end

	return false
end
local function cacheOnce(p19, p20, p21)
	local t17 = t6[p19]

	if not t17 then
		t17 = {}
		t6[p19] = t17
	end

	if t17[p20] == nil then
		t17[p20] = p21
	end
end
local function restoreCached(p22, p23, p24)
	local v173 = t6[p22]

	return v173 and v173[p23] ~= nil and v173[p23] or p24
end
local function applyTextureOverride(p25, p26)
	local v176, v177, v178 = ipairs(t8)
	local v179: boolean = false
	local u180

	for iterFirst, iterSecond in v176, v177, v178 do
		if p25:IsDescendantOf(iterSecond) then
			u180 = true
			v179 = true

			break
		end
	end

	if not v179 then
		u180 = false
	end

	if u180 then
		return
	end

	if p25:IsA("BasePart") and not t5[p25.MaterialVariant] and not t4[p25.Material] then
		local material = p25.Material
		local t18 = t6[p25]

		if not t18 then
			t18 = {}
			t6[p25] = t18
		end

		if t18.Material == nil then
			t18.Material = material
		end

		local materialVariant = p25.MaterialVariant

		t18 = t6[p25]

		if not t18 then
			t18 = {}
			t6[p25] = t18
		end

		if t18.MaterialVariant == nil then
			t18.MaterialVariant = materialVariant
		end

		if p26 then
			p25.Material = Enum.Material.SmoothPlastic
			p25.MaterialVariant = ""
		else
			local v186 = t6[p25]

			p25.Material = v186 and v186.Material ~= nil and v186.Material or p25.Material
			v186 = t6[p25]
			p25.MaterialVariant = v186 and v186.MaterialVariant ~= nil and v186.MaterialVariant or p25.MaterialVariant
		end
	end

	if p25:IsA("Texture") then
		local transparency = p25.Transparency
		local t19 = t6[p25]

		if not t19 then
			t19 = {}
			t6[p25] = t19
		end

		if t19.Transparency == nil then
			t19.Transparency = transparency
		end

		local n1

		if p26 then
			n1 = 1
		else
			local v190 = t6[p25]

			n1 = v190 and v190.Transparency ~= nil and v190.Transparency or p25.Transparency
		end

		p25.Transparency = n1
	end

	if not p25:IsA("SurfaceAppearance") then
		return
	end

	if p26 then
		if t7[p25] == nil then
			t7[p25] = p25.Parent
		end

		p25.Parent = __LocalDisabledSurfaceAppearances

		return
	end

	local parent = t7[p25]

	if parent and parent.Parent then
		p25.Parent = parent

		return
	end

	p25.Parent = __LocalDisabledSurfaceAppearances
end

local connection = nil

local function applyLowTextures()
	local disableTextures = v37.DisableTextures

	LocalPlayer:SetAttribute("DisableTextures", disableTextures)

	for _, v in ipairs(workspace.Game:GetDescendants()) do
		applyTextureOverride(v, disableTextures)
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	lighting.GlobalShadows = not disableTextures

	if disableTextures then
		connection = workspace.Game.DescendantAdded:Connect(function(p27)
			applyTextureOverride(p27, true)
		end)

		return
	end

	for k, v in pairs(t7) do
		if k.Parent == __LocalDisabledSurfaceAppearances and v and v.Parent then
			k.Parent = v
		end
	end
end

local color3 = Color3.fromRGB(255, 226, 0)
local color32 = Color3.fromRGB(255, 0, 0)
local color33 = Color3.fromRGB(0, 0, 0)
local t9: {[any]: any} = {}
local t10: {[any]: any} = {}
local t11: {[any]: any} = {}

local function cacheProp(p28, p29, p30)
	local t20 = t9[p28]

	if not t20 then
		t20 = {}
		t9[p28] = t20
	end

	if t20[p29] == nil then
		t20[p29] = p30
	end
end
local function limbColor(p31)
	local lowerText = p31:lower()

	if lowerText == "head" or lowerText:find("arm") or lowerText:find("hand") then
		return color3
	end

	if lowerText:find("torso") then
		return color32
	end

	if not lowerText:find("leg") and not lowerText:find("foot") then
		return nil
	end

	return color33
end
local function noobInstance(value, p33)
	if value:IsA("ObjectValue") and value.Name == "CharacterMeshProxy" then
		if not p33 and value.Value then
			value.Value.Parent = value.Parent
			value:Destroy()
		end

		return
	end

	if not value:IsA("BasePart") or not value.Parent:IsA("Accessory") then
		if value:IsA("CharacterMesh") then
			if p33 then
				local parent = value.Parent
				local characterMeshProxy: ObjectValue = Instance.new("ObjectValue")

				characterMeshProxy.Name = "CharacterMeshProxy"
				characterMeshProxy.Parent = parent
				characterMeshProxy.Value = value
				value.Parent = noobifyMeshStash
				characterMeshProxy.AncestryChanged:Connect(function(child: Instance, parent: Instance)
					if parent == nil and value.Parent == noobifyMeshStash then
						value:Destroy()
					end
				end)
				value.AncestryChanged:Connect(function(_, p37)
					if characterMeshProxy.Parent == parent and p37 ~= parent then
						characterMeshProxy:Destroy()
					end
				end)
			end

			return
		end

		if value:IsA("Shirt") then
			local shirtTemplate = value.ShirtTemplate
			local t21 = t9[value]

			if not t21 then
				t21 = {}
				t9[value] = t21
			end

			if t21.ShirtTemplate == nil then
				t21.ShirtTemplate = shirtTemplate
			end

			value.ShirtTemplate = if p33 then "" else t9[value] and t9[value].ShirtTemplate or value.ShirtTemplate

			return
		end

		if value:IsA("Pants") then
			local pantsTemplate = value.PantsTemplate
			local t22 = t9[value]

			if not t22 then
				t22 = {}
				t9[value] = t22
			end

			if t22.PantsTemplate == nil then
				t22.PantsTemplate = pantsTemplate
			end

			value.PantsTemplate = if p33 then "" else t9[value] and t9[value].PantsTemplate or value.PantsTemplate

			return
		end

		if value:IsA("ShirtGraphic") then
			local graphic = value.Graphic
			local t23 = t9[value]

			if not t23 then
				t23 = {}
				t9[value] = t23
			end

			if t23.Graphic == nil then
				t23.Graphic = graphic
			end

			value.Graphic = if p33 then "" else t9[value] and t9[value].Graphic or value.Graphic

			return
		end

		if not value:IsA("Decal") then
			if value:IsA("Texture") then
				local transparency = value.Transparency
				local t24 = t9[value]

				if not t24 then
					t24 = {}
					t9[value] = t24
				end

				if t24.Transparency == nil then
					t24.Transparency = transparency
				end

				value.Transparency = if p33 then 1 else t9[value] and t9[value].Transparency or value.Transparency

				return
			end

			local v215 = value:IsA("BasePart") and limbColor(value.Name)

			if v215 then
				local valueColor = value.Color
				local t25 = t9[value]

				if not t25 then
					t25 = {}
					t9[value] = t25
				end

				if t25.Color == nil then
					t25.Color = valueColor
				end

				value.Color = p33 and v215 or t9[value] and t9[value].Color or value.Color
			end

			return
		end

		if value.Name == "face" and value.Parent and value.Parent.Name == "Head" then
			local texture = value.Texture
			local t26 = t9[value]

			if not t26 then
				t26 = {}
				t9[value] = t26
			end

			if t26.Texture == nil then
				t26.Texture = texture
			end

			value.Texture = if p33 then "rbxasset://textures/face.png" else t9[value] and t9[value].Texture or value.Texture

			return
		end

		local valueTransparency = value.Transparency
		local t27 = t9[value]

		if not t27 then
			t27 = {}
			t9[value] = t27
		end

		if t27.Transparency == nil then
			t27.Transparency = valueTransparency
		end

		value.Transparency = if p33 then 1 else t9[value] and t9[value].Transparency or value.Transparency

		return
	end

	if p33 then
		if not value:GetAttribute("OriginalHandleTransparency") then
			value:SetAttribute("OriginalHandleTransparency", value.Transparency)
		end

		value.Transparency = 1

		return
	end

	local originalHandleTransparency = value:GetAttribute("OriginalHandleTransparency")

	if originalHandleTransparency then
		value.Transparency = originalHandleTransparency
	end
end
local function shouldNoobifyChar(p38)
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "PRACTICE" then
		local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

		if matchSide == nil then
			return false
		end

		local v226: Player = players:GetPlayerFromCharacter(p38)
		local matchId2
		local matchSide2

		if v226 then
			if v226 == LocalPlayer then
				return false
			end

			matchId2 = v226:GetAttribute("MatchId")
			matchSide2 = v226:GetAttribute("MatchSide")
		elseif p38:GetAttribute("Decoy") then
			local decoyOwnerUserId = p38:GetAttribute("DecoyOwnerUserId")

			if typeof(decoyOwnerUserId) ~= "number" or decoyOwnerUserId == LocalPlayer.UserId then
				return false
			end

			local player: Player = players:GetPlayerByUserId(decoyOwnerUserId)

			if not player then
				return false
			end

			matchId2 = player:GetAttribute("MatchId")
			matchSide2 = player:GetAttribute("MatchSide")
		else
			if not p38:GetAttribute("BotMatchBot") then
				return false
			end

			matchId2 = p38:GetAttribute("MatchId")
			matchSide2 = p38:GetAttribute("MatchSide")
		end

		if matchId2 ~= matchId then
			return false
		end

		if matchSide2 == nil or matchSide2 == matchSide then
			return false
		end

		return true
	end

	return false
end
local function applyDisableAvatars()
	local noobifyAvatars = v37.NoobifyAvatars

	for _, v in ipairs(t10) do
		v:Disconnect()
	end

	t10 = {}

	if noobifyAvatars then
		local function hookChar(p39)
			task.wait()

			if not p39.Parent or not v37.NoobifyAvatars then
				return
			end

			local v317 = t11[p39]

			if v317 then
				v317:Disconnect()
			end

			t11[p39] = p39.DescendantAdded:Connect(function(p40)
				if v37.NoobifyAvatars and shouldNoobifyChar(p39) then
					noobInstance(p40, true)
				end
			end)

			local function tryNoobify()
				for iterFirst, iterSecond in p39:GetDescendants() do
					if v37.NoobifyAvatars and shouldNoobifyChar(p39) then
						noobInstance(iterSecond, true)
					end
				end
			end

			for iterFirst, iterSecond in p39:GetDescendants() do
				if v37.NoobifyAvatars and shouldNoobifyChar(p39) then
					noobInstance(iterSecond, true)
				end
			end

			local v321: Player = players:GetPlayerFromCharacter(p39)

			if v321 then
				t11[v321] = v321.CharacterAppearanceLoaded:Connect(function()
					task.wait()
					task.wait()

					for iterFirst, iterSecond in p39:GetDescendants() do
						if v37.NoobifyAvatars and shouldNoobifyChar(p39) then
							noobInstance(iterSecond, true)
						end
					end
				end)
			end
		end

		for _, v in ipairs(workspace.Characters:GetChildren()) do
			if v:IsA("Model") then
				task.spawn(hookChar, v)
			end
		end

		table.insert(t10, workspace.Characters.ChildAdded:Connect(function(p41)
			if p41:IsA("Model") then
				task.spawn(hookChar, p41)
			end
		end))
		table.insert(t10, workspace.Characters.ChildRemoved:Connect(function(p42)
			if p42:IsA("Model") then
				local v324 = t11[p42]

				if v324 then
					v324:Disconnect()
				end

				t11[p42] = nil
				v324 = players:GetPlayerFromCharacter(p42)

				if v324 then
					local v325 = t11[v324]

					if v325 then
						v325:Disconnect()
					end

					t11[v324] = nil
				end
			end
		end))

		return
	end

	for k, v in pairs(t11) do
		if k:IsDescendantOf(workspace) then
			task.spawn(function()
				for iterFirst, iterSecond in k:GetDescendants() do
					noobInstance(iterSecond, false)
				end
			end)
		end

		v:Disconnect()
	end

	t11 = {}

	for k, v in pairs(t9) do
		if k.Parent then
			for k2, iterValue in pairs(v) do
				pcall(function()
					k[k2] = iterValue
				end)
			end
		end
	end

	t9 = {}
end
local function applyFOV()
	fovController.SetBase(v37.FieldOfView)
end
local function applyScopedSensitivity()
	LocalPlayer:SetAttribute("ScopedSensitivity", v37.ScopedSensitivity / 100)
end
local function applyAimAssist()
	LocalPlayer:SetAttribute("AimAssist", v37.AimAssist)
end
local function applySensitivity()
	LocalPlayer:SetAttribute("MobileSensitivity", v37.Sensitivity / 100)
end
local function refreshSensitivityVisibility()
	local sensitivity: Instance = scrollingFrame:FindFirstChild("Sensitivity")

	if not sensitivity then
		return
	end

	local settingDesc: Instance = sensitivity:FindFirstChild("SettingDesc")
	local barContainer: Instance = sensitivity:FindFirstChild("BarContainer")
	local value: Instance = sensitivity:FindFirstChild("Value")
	local visible: boolean = inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Touch

	if settingDesc then
		settingDesc.Visible = not visible
	end

	if barContainer then
		barContainer.Visible = visible
	end

	if value then
		value.Visible = visible
	end
end
local function applyAutoShoot()
	LocalPlayer:SetAttribute("AutoShoot", v37.AutoShoot)
end
local function applySpectateCrosshair()
	LocalPlayer:SetAttribute("SpectateCrosshair", v37.SpectateCrosshair)
end
local function applyKnifeKillcam()
	LocalPlayer:SetAttribute("KnifeKillcam", v37.KnifeKillcam)
end
local function applyHideSignBar()
	LocalPlayer:SetAttribute("HideSignBar", v37.HideSignBar == true)
end
local function applyAllEffects()
	applyMusicVolume()
	soundService:SetAttribute("SFXVolume", v37.SFXVolume / 100)
	soundService:SetAttribute("DisableFinishers", v37.DisableFinishers)
	applyLowVFX()
	applyLowTextures()
	applyDisableAvatars()
	fovController.SetBase(v37.FieldOfView)
	LocalPlayer:SetAttribute("AutoShoot", v37.AutoShoot)
	LocalPlayer:SetAttribute("ScopedSensitivity", v37.ScopedSensitivity / 100)
	LocalPlayer:SetAttribute("AimAssist", v37.AimAssist)
	LocalPlayer:SetAttribute("MobileSensitivity", v37.Sensitivity / 100)
	mobileTouchController:setControlOffsets(v37.ControlOffsets)
	mobileTouchController:setControlScales(v37.ControlScales)
	LocalPlayer:SetAttribute("DisableFPEffects", v37.DisableFPEffects)
	LocalPlayer:SetAttribute("SpectateCrosshair", v37.SpectateCrosshair)
	LocalPlayer:SetAttribute("KnifeKillcam", v37.KnifeKillcam)
	LocalPlayer:SetAttribute("HideSignBar", v37.HideSignBar == true)
end

local u90 = nil
local u91 = nil
local t12: {[any]: any} = {}
local t13: {[any]: any} = {}
local t14: {[any]: any} = {}

local function isInMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u249: boolean = false

	if typeof(matchId) == "string" then
		u249 = matchId ~= ""
	end

	return u249
end
local function closeEditControls()
	for _, v in ipairs(t12) do
		v:Disconnect()
	end

	table.clear(t12)

	if u91 then
		u91.weaponGui:Destroy()
		u91.persistentGui:Destroy()
		u91 = nil
	end

	if u90 then
		u90.Enabled = false
	end

	hud.Enabled = true
end
local function openEditControls()
	if not userInputService.TouchEnabled then
		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u253: boolean = false

	if typeof(matchId) == "string" then
		u253 = matchId ~= ""
	end

	if u253 then
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "Must be in Lobby to edit controls",
			duration = 3
		})

		return
	end

	hud.Enabled = false
	u90 = playerGui:WaitForChild("EditControls")
	u90.Enabled = true
	t13 = {}

	if v37.ControlOffsets then
		for k, v in pairs(v37.ControlOffsets) do
			t13[k] = { X = v.X, Y = v.Y }
		end
	end

	t14 = {}

	if v37.ControlScales then
		for k, v in pairs(v37.ControlScales) do
			t14[k] = v
		end
	end

	for _, v in ipairs(t12) do
		v:Disconnect()
	end

	table.clear(t12)

	if u91 then
		u91.weaponGui:Destroy()
		u91.persistentGui:Destroy()
		u91 = nil
	end

	u91 = mobileTouchController:buildEditPreview()

	local v260 = mobileTouchController:getDefaultPositions()

	for k, v in pairs(u91.buttons) do
		local v263 = t13[k]

		if v263 then
			v.Position = UDim2.new(v.Position.X.Scale + v263.X, v.Position.X.Offset, v.Position.Y.Scale + v263.Y, v.Position.Y.Offset)
		end

		v263 = t14[k]

		if v263 then
			mobileTouchController:setButtonScale(v, v263)
		end
	end

	local u264 = nil
	local u265 = nil
	local u266 = nil
	local u267 = nil
	local vPosition = nil
	local vParent = nil
	local u270 = nil
	local u271 = nil
	local u272 = nil
	local u273 = nil
	local n1 = 1
	local n2 = 1

	local function clearDrag()
		u264 = nil
		u265 = nil
		u266 = nil
		u267 = nil
		vPosition = nil
		vParent = nil
	end

	for k, v in pairs(u91.buttons) do
		table.insert(t12, v.InputBegan:Connect(function(input)
			if not u264 and not u270 then
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					u264 = v
					u265 = k
					u266 = input
					u267 = input.Position
					vPosition = v.Position
					vParent = v.Parent
				end

				return
			end
		end))
	end

	for k, v in pairs(u91.buttons) do
		local controlLayoutRESIZE_HANDLE_NAME = v:FindFirstChild(controlLayout.RESIZE_HANDLE_NAME)

		if controlLayoutRESIZE_HANDLE_NAME and controlLayoutRESIZE_HANDLE_NAME:IsA("ImageButton") then
			table.insert(t12, controlLayoutRESIZE_HANDLE_NAME.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					if input == u266 then
						u264 = nil
						u265 = nil
						u266 = nil
						u267 = nil
						vPosition = nil
						vParent = nil
					end

					if u270 then
						return
					end

					u270 = v
					u271 = k
					u272 = input
					u273 = input.Position
					n1 = t14[k] or 1

					local CurrentCamera: Camera = workspace.CurrentCamera

					n2 = math.max(1, (if CurrentCamera then CurrentCamera.ViewportSize.Y else 720) * 0.35)

					return
				end
			end))
		end
	end

	table.insert(t12, userInputService.InputChanged:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
			if not u270 or not u271 or not u273 then
				if not u264 then
					return
				end

				if input.UserInputType == Enum.UserInputType.Touch and u266 and input ~= u266 then
					return
				end

				if not u267 or not vPosition or not vParent then
					return
				end

				local vParentAbsoluteSize = vParent.AbsoluteSize

				if vParentAbsoluteSize.X == 0 or vParentAbsoluteSize.Y == 0 then
					return
				end

				local n3 = input.Position - u267
				local vector2 = Vector2.new(n3.X / vParentAbsoluteSize.X, n3.Y / vParentAbsoluteSize.Y)

				u264.Position = UDim2.new(vPosition.X.Scale + vector2.X, vPosition.X.Offset, vPosition.Y.Scale + vector2.Y, vPosition.Y.Offset)

				return
			end

			if input.UserInputType == Enum.UserInputType.Touch and u272 and input ~= u272 then
				return
			end

			local n4 = input.Position - u273

			n4 = math.clamp(n1 + -(n4.X + n4.Y) / n2, controlLayout.MIN_SCALE, controlLayout.MAX_SCALE)
			mobileTouchController:setButtonScale(u270, n4)
			t14[u271] = n4

			return
		end
	end))
	table.insert(t12, userInputService.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		elseif u270 and u271 then
			local v337 = t14[u271]

			if v337 and math.abs(v337 - 1) < 0.01 then
				t14[u271] = nil
				mobileTouchController:setButtonScale(u270, 1)
			end

			u270 = nil
			u271 = nil
			u272 = nil
			u273 = nil
		elseif u264 and u265 then
			local v338 = v260[u265]

			if v338 then
				local n1 = u264.Position.X.Scale - v338.X.Scale
				local n2 = u264.Position.Y.Scale - v338.Y.Scale

				if math.abs(n1) < 0.001 and math.abs(n2) < 0.001 then
					t13[u265] = nil
				else
					t13[u265] = { X = n1, Y = n2 }
				end
			end

			u264 = nil
			u265 = nil
			u266 = nil
			u267 = nil
			vPosition = nil
			vParent = nil
		end
	end))

	local save = u90:FindFirstChild("Save")
	local reset = u90:FindFirstChild("Reset")

	if save then
		table.insert(t12, save.MouseButton1Click:Connect(function()
			local u341: boolean = false

			for iterKey in pairs(t13) do
				u341 = true

				break
			end

			local u343: boolean = false

			for iterKey2 in pairs(t14) do
				u343 = true

				break
			end

			v37.ControlOffsets = u341 and t13 or nil
			v37.ControlScales = u343 and t14 or nil

			if not u39 then
				u39 = true
				task.delay(0.3, function()
					u39 = false
					updateSettings:FireServer("Update", v37)
				end)
			end

			mobileTouchController:setControlOffsets(u341 and t13 or nil)
			mobileTouchController:setControlScales(u343 and t14 or nil)
			closeEditControls()
		end))
	end

	if reset then
		table.insert(t12, reset.MouseButton1Click:Connect(function()
			t13 = {}
			t14 = {}

			for k, v in pairs(u91.buttons) do
				local v347 = v260[k]

				if v347 then
					v.Position = v347
				end

				mobileTouchController:setButtonScale(v, 1)
			end
		end))
	end
end

local t15: {[any]: any} = {}

local function init()
	local v284 = wireSlider(scrollingFrame.MusicVolume, 0, 100, 100, function()
		return v37.MusicVolume
	end, function(musicVolume)
		v37.MusicVolume = musicVolume
		applyMusicVolume()
	end, true, nil)

	table.insert(t15, v284)
	v284 = wireSlider(scrollingFrame.SFXVolume, 0, 100, 100, function()
		return v37.SFXVolume
	end, function(sFXVolume)
		v37.SFXVolume = sFXVolume
		soundService:SetAttribute("SFXVolume", v37.SFXVolume / 100)
	end, true, nil)
	table.insert(t15, v284)
	v284 = wireToggle(scrollingFrame.LowTextures, false, function()
		return v37.DisableTextures
	end, function(disableTextures)
		v37.DisableTextures = disableTextures
		applyLowTextures()
	end)
	table.insert(t15, v284)
	v284 = wireToggle(scrollingFrame.LowVFX, false, function()
		return v37.LowVFX
	end, function(lowVFX)
		v37.LowVFX = lowVFX
		applyLowVFX()
	end)
	table.insert(t15, v284)
	v284 = wireToggle(scrollingFrame.DisableAvatars, false, function()
		return v37.NoobifyAvatars
	end, function(noobifyAvatars)
		v37.NoobifyAvatars = noobifyAvatars
		applyDisableAvatars()
	end)
	table.insert(t15, v284)
	v284 = wireToggle(scrollingFrame.DisableFinishers, false, function()
		return v37.DisableFinishers
	end, function(disableFinishers)
		v37.DisableFinishers = disableFinishers
		soundService:SetAttribute("DisableFinishers", v37.DisableFinishers)
	end)
	table.insert(t15, v284)

	local hideSignBar: Instance = scrollingFrame:FindFirstChild("HideSignBar")

	if hideSignBar and hideSignBar:IsA("Frame") then
		hideSignBar.Visible = tradingPlazaGate.IsTradingPlaza()

		local v286 = wireToggle(hideSignBar, false, function()
			return v37.HideSignBar == true
		end, function(hideSignBar)
			v37.HideSignBar = hideSignBar
			LocalPlayer:SetAttribute("HideSignBar", v37.HideSignBar == true)
		end)

		table.insert(t15, v286)
	end

	v284 = wireToggle(scrollingFrame.DisableFPEffects, false, function()
		return v37.DisableFPEffects
	end, function(disableFPEffects)
		v37.DisableFPEffects = disableFPEffects
		LocalPlayer:SetAttribute("DisableFPEffects", v37.DisableFPEffects)
	end)
	table.insert(t15, v284)
	v284 = wireSlider(scrollingFrame.FoV, 50, 100, 70, function()
		return v37.FieldOfView
	end, function(fieldOfView)
		v37.FieldOfView = fieldOfView
		fovController.SetBase(v37.FieldOfView)
	end, false, 70, nil, true)
	table.insert(t15, v284)
	v284 = wireSlider(scrollingFrame.ScopedSensitivity, 10, 100, 75, function()
		return v37.ScopedSensitivity
	end, function(scopedSensitivity)
		v37.ScopedSensitivity = scopedSensitivity
		LocalPlayer:SetAttribute("ScopedSensitivity", v37.ScopedSensitivity / 100)
	end, false, 75, "x")
	table.insert(t15, v284)

	local v287 = wireSlider(scrollingFrame.Sensitivity, 25, 400, 100, function()
		return v37.Sensitivity
	end, function(sensitivity)
		v37.Sensitivity = sensitivity
		LocalPlayer:SetAttribute("MobileSensitivity", v37.Sensitivity / 100)
	end, false, 100, nil, true)

	table.insert(t15, v287)
	refreshSensitivityVisibility()
	inputCategorizer.lastInputCategoryChanged:Connect(refreshSensitivityVisibility)

	local v288 = wireToggle(scrollingFrame.TradeRequests, true, function()
		return v37.TradeRequests
	end, function(tradeRequests)
		v37.TradeRequests = tradeRequests
		LocalPlayer:SetAttribute("TradeRequests", tradeRequests)
	end)

	table.insert(t15, v288)

	local gameFlags: Instance = replicatedStorage:WaitForChild("Shared"):WaitForChild("GameFlags")

	scrollingFrame.TradeRequests.Visible = gameFlags:GetAttribute("TradingEnabled") == true
	gameFlags:GetAttributeChangedSignal("TradingEnabled"):Connect(function()
		scrollingFrame.TradeRequests.Visible = gameFlags:GetAttribute("TradingEnabled") == true
	end)

	local v290 = wireToggle(scrollingFrame.DuelRequests, true, function()
		return v37.DuelRequests
	end, function(duelRequests)
		v37.DuelRequests = duelRequests
		LocalPlayer:SetAttribute("DuelRequests", duelRequests)
	end)

	table.insert(t15, v290)
	v290 = wireToggle(scrollingFrame.TradeHistoryPublic, true, function()
		return v37.TradeHistoryPublic
	end, function(tradeHistoryPublic)
		v37.TradeHistoryPublic = tradeHistoryPublic
		LocalPlayer:SetAttribute("TradeHistoryPublic", tradeHistoryPublic)
	end)
	table.insert(t15, v290)
	scrollingFrame.TradeHistoryPublic.Visible = tradePublicFlags.TradeHistoryPublic()
	tradePublicFlags.OnChanged("TradeHistoryPublic", function()
		scrollingFrame.TradeHistoryPublic.Visible = tradePublicFlags.TradeHistoryPublic()
	end)
	v290 = wireToggle(scrollingFrame.AutoShoot, false, function()
		return v37.AutoShoot
	end, function(autoShoot)
		v37.AutoShoot = autoShoot
		LocalPlayer:SetAttribute("AutoShoot", v37.AutoShoot)
	end)
	table.insert(t15, v290)
	v290 = wireToggle(scrollingFrame.AimAssist, true, function()
		return v37.AimAssist
	end, function(aimAssist)
		v37.AimAssist = aimAssist
		LocalPlayer:SetAttribute("AimAssist", v37.AimAssist)
	end)
	table.insert(t15, v290)
	v290 = wireToggle(scrollingFrame.SpectateCrosshair, true, function()
		return v37.SpectateCrosshair
	end, function(spectateCrosshair)
		v37.SpectateCrosshair = spectateCrosshair
		LocalPlayer:SetAttribute("SpectateCrosshair", v37.SpectateCrosshair)
	end)
	table.insert(t15, v290)
	v290 = wireToggle(scrollingFrame.KnifeKillcam, true, function()
		return v37.KnifeKillcam
	end, function(knifeKillcam)
		v37.KnifeKillcam = knifeKillcam
		LocalPlayer:SetAttribute("KnifeKillcam", v37.KnifeKillcam)
	end)
	table.insert(t15, v290)

	local editControls: Instance = scrollingFrame:FindFirstChild("EditControls")
	local openBtn: Instance = editControls and editControls:FindFirstChild("OpenBtn")

	if openBtn then
		if userInputService.TouchEnabled then
			openBtn.MouseButton1Click:Connect(function()
				openEditControls()
			end)
			v43:addButton(editControls, function()
				openEditControls()
			end)
		else
			uiFramework.setButtonDisabled(openBtn)
		end
	end

	v43:rechain()
end
local function refreshAll()
	for _, v in ipairs(t15) do
		v()
	end
end

closeButton.MouseButton1Click:Connect(function()
	closeSettings:Fire()
end)

local contentCrosshair: Instance = settingsWindow:WaitForChild("ContentCrosshair")
local contentHotkeys: Instance = settingsWindow:WaitForChild("ContentHotkeys")
local navigator: Instance = settingsWindow:WaitForChild("Navigator")
local navigatorSettings: Instance = navigator:WaitForChild("Settings")
local crosshair: Instance = navigator:WaitForChild("Crosshair")
local hotkeys: Instance = navigator:WaitForChild("Hotkeys")
local imageLabel: Instance = navigatorSettings:WaitForChild("ImageLabel")
local textLabel: Instance = navigatorSettings:WaitForChild("TextLabel")
local crosshairImageLabel: Instance = crosshair:WaitForChild("ImageLabel")
local crosshairTextLabel: Instance = crosshair:WaitForChild("TextLabel")
local hotkeysImageLabel: Instance = hotkeys:WaitForChild("ImageLabel")
local hotkeysTextLabel: Instance = hotkeys:WaitForChild("TextLabel")
local textLabelTextColor3 = textLabel.TextColor3
local crosshairTextLabelTextColor3 = crosshairTextLabel.TextColor3
local t16: {[any]: any} = {
	{
		button = navigatorSettings,
		panel = content,
		icon = imageLabel,
		text = textLabel,
		selIcon = Color3.new(1, 1, 1)
	},
	{
		button = crosshair,
		panel = contentCrosshair,
		icon = crosshairImageLabel,
		text = crosshairTextLabel,
		selIcon = crosshairImageLabel.ImageColor3
	},
	{
		button = hotkeys,
		panel = contentHotkeys,
		icon = hotkeysImageLabel,
		text = hotkeysTextLabel,
		selIcon = Color3.new(1, 1, 1)
	}
}

local function setTab(p65)
	for i, v in ipairs(t16) do
		local u298: boolean = i == p65

		v.panel.Visible = u298
		v.icon.ImageColor3 = if u298 then v.selIcon else textLabelTextColor3
		v.text.TextColor3 = if u298 then crosshairTextLabelTextColor3 else textLabelTextColor3
	end
end

for i, v in ipairs(t16) do
	v.button.Activated:Connect(function()
		setTab(i)
	end)
end

local userInputServiceKeyboardEnabled: boolean = userInputService.KeyboardEnabled

hotkeys.Visible = userInputServiceKeyboardEnabled

if not userInputServiceKeyboardEnabled and contentHotkeys.Visible then
	setTab(1)
end

userInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
	local userInputServiceKeyboardEnabled: boolean = userInputService.KeyboardEnabled

	hotkeys.Visible = userInputServiceKeyboardEnabled

	if not userInputServiceKeyboardEnabled and contentHotkeys.Visible then
		setTab(1)
	end
end)

local selectionImageObject = v43:getSelectionImage()

navigatorSettings.Selectable = true
navigatorSettings.SelectionImageObject = selectionImageObject
crosshair.Selectable = true
crosshair.SelectionImageObject = selectionImageObject
hotkeys.Selectable = true
hotkeys.SelectionImageObject = selectionImageObject
closeButton.NextSelectionUp = navigatorSettings
navigatorSettings.NextSelectionUp = navigatorSettings
navigatorSettings.NextSelectionDown = crosshair
navigatorSettings.NextSelectionLeft = navigatorSettings
navigatorSettings.NextSelectionRight = closeButton
crosshair.NextSelectionUp = navigatorSettings
crosshair.NextSelectionDown = hotkeys
crosshair.NextSelectionLeft = crosshair
crosshair.NextSelectionRight = closeButton
hotkeys.NextSelectionUp = crosshair
hotkeys.NextSelectionDown = hotkeys
hotkeys.NextSelectionLeft = hotkeys
hotkeys.NextSelectionRight = closeButton
setTab(1)
settingsWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if settingsWindow.Visible then
		setTab(1)
	end
end)
updateSettings.OnClientEvent:Connect(function(p66, p67)
	if p66 == "Sync" and typeof(p67) == "table" then
		for k, v in pairs(p67) do
			v37[k] = v
		end

		if not u38 then
			u38 = true
			init()
			applyAllEffects()

			return
		end

		for _, v in ipairs(t15) do
			v()
		end

		applyAllEffects()

		return
	end
end)
task.spawn(function()
	while not u38 do
		updateSettings:FireServer("Request")
		task.wait(1)
	end
end)
task.defer(function()
	collectMusicSounds()

	if u38 then
		applyMusicVolume()
	end

	workspace.DescendantAdded:Connect(function(descendant: Instance)
		if descendant:IsA("Sound") and descendant.Name == "Background" and descendant.Parent and descendant.Parent.Name == "AudioSettings" then
			table.insert(t1, descendant)

			if t2[descendant] == nil then
				t2[descendant] = descendant.Volume
			end

			descendant.Volume = t2[descendant] * (v37.MusicVolume / 100)
		end
	end)
end)
