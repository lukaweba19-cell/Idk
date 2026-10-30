-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local soundService: SoundService = game:GetService("SoundService")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local debris: Debris = game:GetService("Debris")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local fovController = require(shared:WaitForChild("FOVController"))
local collectibleSerial = require(shared:WaitForChild("CollectibleSerial"))
local module: {[any]: any} = { ITEM_ID = "EvilSniper" }

function module.Handles(p1)
	local u30: boolean = false

	if typeof(p1) == "table" then
		u30 = p1.ItemId == module.ITEM_ID
	end

	return u30
end

module.AUDIO = {
	Music = { Id = 115108698479650, Volume = 2 },
	Rise = { Id = nil, Volume = 0.9 },
	Breach = { Id = nil, Volume = 0.8 },
	Ignite = { Id = nil, Volume = 0.5 },
	Chain = { Id = nil, Volume = 0.8 },
	Charge = { Id = nil, Volume = 0.9 },
	Explode = { Id = nil, Volume = 1 },
	Reveal = { Id = nil, Volume = 0.8 }
}
module.TRACK_OFFSET = 1
module.T = {
	BLACK_IN = 0.4,
	BLACK_HOLD = 0.2,
	FADE_IN = 0.6,
	RISE = 2.6,
	EMERGE = 1.5,
	CHAINS = 1.7,
	BUILD = 2.4,
	SETTLE = 0.9,
	HINT_DELAY = 1.6,
	FADE_OUT = 0.45,
	AUTO_CONTINUE = 25
}
task.spawn(function()
	local t2: {[any]: any} = {}

	for _, v in pairs(module.AUDIO) do
		if v.Id then
			local text: string = tostring(v.Id)

			table.insert(t2, "rbxassetid://" .. text)
		end
	end

	if #t2 > 0 then
		pcall(function()
			contentProvider:PreloadAsync(t2)
		end)
	end
end)

local cFrame = CFrame.new(40000, 0, 40000)
local v15 = CFrame.Angles(0, 0, 1.5707963267948966)
local color3 = Color3.new(1, 1, 1)
local color32 = Color3.fromRGB(255, 36, 36)
local color33 = Color3.fromRGB(150, 0, 8)

local function clamp01(p2)
	return (math.clamp(p2, 0, 1))
end
local function smooth(p3)
	local v37 = math.clamp(p3, 0, 1)

	return v37 * v37 * (3 - v37 * 2)
end
local function outCubic(p4)
	return 1 - (1 - math.clamp(p4, 0, 1)) ^ 3
end
local function inOutCubic(p5)
	local v40 = math.clamp(p5, 0, 1)

	if v40 < 0.5 then
		return v40 ^ 3 * 4
	end

	return 1 - (v40 * -2 + 2) ^ 3 / 2
end
local function outBack(p6)
	local v42 = math.clamp(p6, 0, 1)

	return (v42 - 1) ^ 3 * 2.70158 + 1 + (v42 - 1) ^ 2 * 1.70158
end
local function inert(p7)
	p7.Anchored = true
	p7.CanCollide = false
	p7.CanQuery = false
	p7.CanTouch = false
	p7.CastShadow = false
end
local function scaleEmitter(p8, p9)
	local t3: {[any]: any} = {}

	for _, v in ipairs(p8.Size.Keypoints) do
		table.insert(t3, NumberSequenceKeypoint.new(v.Time, v.Value * p9, v.Envelope * p9))
	end

	p8.Size = NumberSequence.new(t3)
end
local function emitAll(p10, p11)
	for _, v in ipairs(p10:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			if p11 then
				scaleEmitter(v, p11)
			end

			local numberValue: number? = tonumber(v:GetAttribute("EmitCount"))

			v:Emit(numberValue or 25)
		end
	end
end
local function redden(p12)
	for _, v in ipairs(p12:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local colorSequenceNew = ColorSequence.new

			v.Color = colorSequenceNew({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 100)),
				ColorSequenceKeypoint.new(0.35, color32),
				ColorSequenceKeypoint.new(1, color33)
			})
		elseif v:IsA("Light") then
			v.Color = color32
		end
	end
end
local function damnationKit()
	local fx: Instance = replicatedStorage:FindFirstChild("FX")
	local killEffects: Instance = fx and fx:FindFirstChild("KillEffects")
	local v60: Instance = killEffects

	if v60 then
		v60 = killEffects:FindFirstChild("Damnation")
	end

	return v60 and v60:FindFirstChild("Mesh")
end
function module.Play(p13, p14)
	local t4 = p14 or {}
	local t = module.T
	local t5 = if typeof(p13) == "table" then p13 else {}
	local scene: Instance = script:FindFirstChild("Scene")
	local CurrentCamera: Camera = workspace.CurrentCamera

	if scene and scene:IsA("Model") and CurrentCamera then
		local playerGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui")
		local __DevilsSightReveal: ScreenGui = Instance.new("ScreenGui")

		__DevilsSightReveal.Name = "__DevilsSightReveal"
		__DevilsSightReveal.IgnoreGuiInset = true
		__DevilsSightReveal.ScreenInsets = Enum.ScreenInsets.None
		__DevilsSightReveal.ResetOnSpawn = false
		__DevilsSightReveal.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		__DevilsSightReveal.DisplayOrder = 210
		__DevilsSightReveal.Parent = playerGui

		local function frame(zIndex, backgroundColor3)
			local frame: Frame = Instance.new("Frame")

			frame.BorderSizePixel = 0
			frame.BackgroundColor3 = backgroundColor3
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.fromScale(1, 1)
			frame.ZIndex = zIndex
			frame.Parent = __DevilsSightReveal

			return frame
		end

		local textButton: TextButton = Instance.new("TextButton")

		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.BackgroundTransparency = 1
		textButton.Size = UDim2.fromScale(1, 1)
		textButton.ZIndex = 1
		textButton:AddTag("BlacklistHover")
		textButton.Parent = __DevilsSightReveal

		local frame5: Frame = Instance.new("Frame")

		frame5.BorderSizePixel = 0
		frame5.BackgroundColor3 = color3
		frame5.BackgroundTransparency = 1
		frame5.Size = UDim2.fromScale(1, 1)
		frame5.ZIndex = 28
		frame5.Parent = __DevilsSightReveal

		local frame2: Frame = Instance.new("Frame")

		frame2.BorderSizePixel = 0
		frame2.BackgroundColor3 = Color3.new(0, 0, 0)
		frame2.BackgroundTransparency = 1
		frame2.Size = UDim2.fromScale(1, 1)
		frame2.ZIndex = 30
		frame2.Parent = __DevilsSightReveal

		local frame3: Frame = Instance.new("Frame")

		frame3.BorderSizePixel = 0
		frame3.BackgroundColor3 = Color3.new(0, 0, 0)
		frame3.BackgroundTransparency = 1
		frame3.Size = UDim2.fromScale(1, 1)
		frame3.ZIndex = 20
		frame3.Parent = __DevilsSightReveal
		frame3.BackgroundTransparency = 0
		frame3.Size = UDim2.fromScale(1, 0.11)
		frame3.Position = UDim2.fromScale(0, -0.11)

		local frame4: Frame = Instance.new("Frame")

		frame4.BorderSizePixel = 0
		frame4.BackgroundColor3 = Color3.new(0, 0, 0)
		frame4.BackgroundTransparency = 1
		frame4.Size = UDim2.fromScale(1, 1)
		frame4.ZIndex = 20
		frame4.Parent = __DevilsSightReveal
		frame4.BackgroundTransparency = 0
		frame4.AnchorPoint = Vector2.new(0, 1)
		frame4.Size = UDim2.fromScale(1, 0.11)
		frame4.Position = UDim2.fromScale(0, 1.11)

		local spinner: Instance = playerGui:FindFirstChild("Spinner")

		spinner = spinner and spinner:FindFirstChild("Title", true)

		local v77 = if spinner and spinner:IsA("TextLabel") then spinner.FontFace else Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

		frame = function(text, p18, p19)
			local textLabel: TextLabel = Instance.new("TextLabel")

			textLabel.BackgroundTransparency = 1
			textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			textLabel.Position = UDim2.fromScale(0.5, p18)
			textLabel.Size = UDim2.fromScale(0.8, p19)
			textLabel.TextScaled = true
			textLabel.FontFace = v77
			textLabel.TextColor3 = color3
			textLabel.TextTransparency = 1
			textLabel.Text = text
			textLabel.ZIndex = 25

			local uiStroke: UIStroke = Instance.new("UIStroke")

			uiStroke.Thickness = 3
			uiStroke.Transparency = 1
			uiStroke.Parent = textLabel

			local uiScale: UIScale = Instance.new("UIScale")

			uiScale.Parent = textLabel
			textLabel.Parent = __DevilsSightReveal

			return textLabel, uiStroke, uiScale
		end

		local v78 = collectibleSerial.Format(t5.Serial, t5.MaxSupply)
		local stringUpper = string.upper
		local text: string = tostring(t5.Name or t5.ItemId or "Devil's Sight")
		local v81 = stringUpper(text)
		local v82, v83, v84 = frame(v81, 0.75, 0.1)

		pcall(function()
			rarity.ApplyTextGradient(v82, "Collectible")
		end)

		local s1: string = if v78 then "   " .. v78 else ""
		local v86, v87, v88 = frame("COLLECTIBLE" .. s1, 0.835, 0.045)

		pcall(function()
			v86.TextColor3 = rarity.GetColor("Collectible")
		end)

		local v89, v90 = frame("- Tap Anywhere to Continue -", 0.93, 0.032)
		local t6: {[any]: any} = {}
		local t7: {[any]: any} = {}

		for k, v in pairs(module.AUDIO) do
			if v.Id then
				local sound: Sound = Instance.new("Sound")

				sound.Name = "DS_" .. k
				sound.SoundId = "rbxassetid://" .. tostring(v.Id)
				sound.Parent = __DevilsSightReveal
				t6[k] = sound
				table.insert(t7, sound)
			end
		end

		if #t7 > 0 then
			task.spawn(function()
				pcall(function()
					contentProvider:PreloadAsync(t7)
				end)
			end)
		end

		local function volumeFor(p20)
			local v244 = module.AUDIO[p20]

			if v244 then
				return v244.Volume
			end

			return 1
		end
		local function play(p21, p22)
			local v247 = t6[p21]

			if not v247 then
				return
			end

			if p22 then
				local clone = v247:Clone()
				local v249 = module.AUDIO[p21]

				clone.Volume = if v249 then v249.Volume else 1
				clone.Parent = __DevilsSightReveal
				clone:Play()
				debris:AddItem(clone, 6)

				return
			end

			local v250 = module.AUDIO[p21]

			v247.Volume = if v250 then v250.Volume else 1
			v247.TimePosition = 0
			v247:Play()
		end

		local numberValue = tonumber(module.TRACK_OFFSET) or 0
		local music = t6.Music
		local u100: boolean = music ~= nil
		local n1 = 0
		local clone: Instance = scene:Clone()

		clone.Name = "__DevilsSightScene"
		clone:PivotTo(cFrame)
		clone.Parent = workspace

		local markers: Instance = clone:FindFirstChild("Markers")

		local function mk(p23)
			local v252: Instance = markers and markers:FindFirstChild(p23)

			if v252 and v252:IsA("BasePart") then
				return v252.CFrame
			end

			return cFrame
		end

		local camStart: Instance = markers and markers:FindFirstChild("CamStart")
		local v106 = if camStart and camStart:IsA("BasePart") then camStart.CFrame else cFrame
		local camBreach: Instance = markers and markers:FindFirstChild("CamBreach")
		local v108 = if camBreach and camBreach:IsA("BasePart") then camBreach.CFrame else cFrame
		local camWide: Instance = markers and markers:FindFirstChild("CamWide")
		local v110 = if camWide and camWide:IsA("BasePart") then camWide.CFrame else cFrame
		local camPush: Instance = markers and markers:FindFirstChild("CamPush")
		local v112 = if camPush and camPush:IsA("BasePart") then camPush.CFrame else cFrame
		local camHero: Instance = markers and markers:FindFirstChild("CamHero")
		local v114 = if camHero and camHero:IsA("BasePart") then camHero.CFrame else cFrame
		local sniperMount: Instance = markers and markers:FindFirstChild("SniperMount")
		local v116 = (if sniperMount and sniperMount:IsA("BasePart") then sniperMount.CFrame else cFrame).Position

		mk = markers

		if mk then
			mk = markers:FindFirstChild("RevealSpot")
		end

		local spotLight = mk and mk:FindFirstChildOfClass("SpotLight")

		mk = markers

		if mk then
			mk = markers:FindFirstChild("RevealKey")
		end

		local pointLight = mk and mk:FindFirstChildOfClass("PointLight")
		local fx: Instance = clone:FindFirstChild("FX")
		local statueLight: Instance = fx and fx:FindFirstChild("StatueLight")
		local v121: Instance = statueLight

		if v121 then
			v121 = statueLight:FindFirstChildOfClass("PointLight")
		end

		local v122 = if v121 then v121.Brightness else 0
		local cFrameY = cFrame.Y
		local n2 = cFrame.Y - 10
		local lava: Instance = clone:FindFirstChild("Lava")
		local sea: Instance = lava and lava:FindFirstChild("Sea")

		if sea and sea:IsA("BasePart") then
			n2 = sea.Position.Y + sea.Size.Y / 2
		end

		local filterDescendantsInstances: {[any]: any} = {}

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") and v.Transparency < 0.95 then
				local u130: boolean = false
				local vParent = v.Parent

				while vParent and vParent ~= clone do
					if vParent.Name == "Markers" or vParent.Name == "ChainAnchors" or vParent.Name == "FX" then
						u130 = true

						break
					end

					vParent = vParent.Parent
				end

				if not u130 then
					v.CanQuery = true
					table.insert(filterDescendantsInstances, v)
				end
			end
		end

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Include
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances

		local t9: {[any]: any} = {}
		local t10: {[any]: any} = {}

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") and v:GetAttribute("IgniteOrder") then
				table.insert(t9, v)

				for _, iterValue in ipairs(v:GetChildren()) do
					if iterValue:IsA("ParticleEmitter") or iterValue:IsA("Light") then
						iterValue.Enabled = false
					end
				end
			elseif v.Name == "RimFire" then
				table.insert(t10, v)
			end
		end

		table.sort(t9, function(p24, p25)
			local numberValue2: number? = tonumber(p24:GetAttribute("IgniteOrder"))
			local numberValue3: number? = tonumber(p25:GetAttribute("IgniteOrder"))

			return (numberValue2 or 0) < (numberValue3 or 0)
		end)

		local u139 = nil
		local u140 = nil
		local cFrame2 = CFrame.new()
		local n3 = 4.5
		local revolvers: Instance = replicatedStorage:FindFirstChild("Revolvers")
		local v144: Instance = revolvers and revolvers:FindFirstChild(module.ITEM_ID)

		if v144 and v144:IsA("Model") then
			local clone2: Instance = v144:Clone()

			for _, v in ipairs(clone2:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Anchored = true
					v.CanCollide = false
					v.CanQuery = false
					v.CanTouch = false
					v.CastShadow = false
				elseif v:IsA("LuaSourceContainer") then
					v:Destroy()
				end
			end

			pcall(function()
				local v257 = clone2:GetScale()

				clone2:ScaleTo(v257 * 2.2)
			end)

			local cFrame3 = CFrame.new(v116)
			local v149 = CFrame.Angles(0, 1.5707963267948966, 0)

			clone2:PivotTo(cFrame3 * v149)

			local v150, v151 = clone2:GetBoundingBox()
			local pivot = clone2:GetPivot()

			clone2:PivotTo(pivot + (v116 - v150.Position))

			local cFrame4 = CFrame.new(v116)

			cFrame2 = cFrame4:ToObjectSpace(clone2:GetPivot())
			n3 = math.max(v151.X, v151.Z) * 0.31
			clone2.Parent = clone

			local highlight: Highlight = Instance.new("Highlight")

			highlight.FillColor = Color3.new(0, 0, 0)
			highlight.FillTransparency = 0
			highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
			highlight.OutlineTransparency = 0
			highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			highlight.Adornee = clone2
			highlight.Parent = clone2
			u139 = clone2
			u140 = highlight
		end

		local fx2: Instance = replicatedStorage:FindFirstChild("FX")
		local killEffects: Instance = fx2 and fx2:FindFirstChild("KillEffects")
		local v157: Instance = killEffects

		if v157 then
			v157 = killEffects:FindFirstChild("Damnation")
		end

		v144 = v157

		if v144 then
			v144 = v157:FindFirstChild("Mesh")
		end

		local chain: Instance = v144 and v144:FindFirstChild("Chain")
		local link: Instance = chain and chain:FindFirstChild("Link")
		local cuff: Instance = chain and chain:FindFirstChild("Cuff")
		local v161: Instance = v144

		if v161 then
			v161 = v144:FindFirstChild("Explosion")
		end

		local ground: Instance = v144 and v144:FindFirstChild("Ground")
		local tRise = t.RISE
		local n4 = tRise + t.EMERGE
		local n5 = n4 + t.CHAINS
		local n6 = n5 + t.BUILD
		local n7 = n6 + t.HINT_DELAY
		local chains: Folder = Instance.new("Folder")

		chains.Name = "Chains"
		chains.Parent = clone

		local t11: {[any]: any} = {}
		local t12: {[any]: any} = {}
		local t13: {[any]: any} = {}
		local chainAnchors: Instance = clone:FindFirstChild("ChainAnchors")

		if chainAnchors then
			for _, v in ipairs(chainAnchors:GetChildren()) do
				if v:IsA("BasePart") then
					table.insert(t13, v)
				end
			end
		end

		table.sort(t13, function(p26, p27)
			return p26.Name < p27.Name
		end)

		if link and link:IsA("BasePart") then
			local n8 = link.Size.Y * 2 * 0.72

			for _, v in ipairs(t13) do
				local n9 = v.Position + Vector3.new(0, 0.1, 0)
				local n10: number = if n9.X > v116.X + 1 then 1 else if n9.X < v116.X - 1 then -1 else 0
				local vector3 = Vector3.new(n10 * n3, -0.35, 0)
				local n11 = v116 + vector3
				local unit = (n11 - n9).Unit
				local floored = math.floor((n11 - n9).Magnitude / n8)
				n11 = {}

				for i = 1, math.max(2, floored) do
					local clone3: Instance = link:Clone()

					clone3.Size = link.Size * 2
					clone3.Anchored = true
					clone3.CanCollide = false
					clone3.CanQuery = false
					clone3.CanTouch = false
					clone3.CastShadow = false

					local n12 = n9 + unit * n8 * (i - 0.5)
					local v187 = CFrame.lookAt(n12, n12 + unit)
					local v188 = CFrame.Angles(-1.5707963267948966, 0, 0)
					local v189 = CFrame.Angles(0, i % 2 * 3.141592653589793 / 2, 0)
					local cFrame5 = v187 * v188 * v189

					clone3.CFrame = cFrame5
					clone3.Parent = chains
					n11[i] = {
						vel = Vector3.new(0, 0, 0),
						spin = Vector3.new(0, 0, 0),
						bounces = 0,
						resting = false,
						part = clone3,
						base = cFrame5,
						rot = cFrame5.Rotation
					}
				end

				local v191 = unit:Cross(Vector3.new(0, 1, 0))

				table.insert(t11, { links = n11, anchor = v, side = n10, perp = v191.Unit })
				v.Transparency = 0

				for _, iterValue2 in ipairs(v:GetChildren()) do
					if iterValue2:IsA("ParticleEmitter") or iterValue2:IsA("Light") then
						iterValue2.Enabled = true
					end
				end
			end
		end

		if cuff and cuff:IsA("BasePart") then
			for _, v in ipairs({ -1, 0, 1 }) do
				local clone4: Instance = cuff:Clone()

				clone4.Size = cuff.Size * 1.5
				clone4.Anchored = true
				clone4.CanCollide = false
				clone4.CanQuery = false
				clone4.CanTouch = false
				clone4.CastShadow = false

				local cFrameNew = CFrame.new
				local vector3 = Vector3.new(v * n3, 0, 0)
				local v199 = cFrameNew(v116 + vector3)
				local v200 = CFrame.Angles(0, 1.5707963267948966, 0)

				clone4.CFrame = v199 * v200
				clone4.Parent = chains
				t12[v] = clone4
			end
		end

		local __DevilsSightGrade: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		__DevilsSightGrade.Name = "__DevilsSightGrade"
		__DevilsSightGrade.Brightness = -0.03
		__DevilsSightGrade.Contrast = 0.18
		__DevilsSightGrade.Saturation = 0.05
		__DevilsSightGrade.TintColor = Color3.fromRGB(255, 226, 218)
		__DevilsSightGrade.Enabled = false
		__DevilsSightGrade.Parent = CurrentCamera

		local currentCameraCameraType: Enum.CameraType = CurrentCamera.CameraType
		local currentCameraCameraSubject: Instance = CurrentCamera.CameraSubject
		local currentCameraCFrame: CFrame = CurrentCamera.CFrame
		local u205: boolean = false
		local t14: {[any]: any} = {}
		local musicDuck: any = soundService:GetAttribute("MusicDuck")
		local u208: boolean = false

		local function takeover()
			for _, v in ipairs(playerGui:GetChildren()) do
				if v:IsA("ScreenGui") and v ~= __DevilsSightReveal and v.Enabled then
					v.Enabled = false
					table.insert(t14, v)
				end
			end

			u205 = true
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.CFrame = v106
			pcall(function()
				local fovControllerPush = fovController.Push
				local v436 = fovController.GetBase()

				fovControllerPush("DevilsSight", 62 - v436, 0)
			end)
			__DevilsSightGrade.Enabled = true
			frame3.Position = UDim2.fromScale(0, 0)
			frame4.Position = UDim2.fromScale(0, 1)

			local rise = t6.Rise

			if not rise then
				return
			end

			local v263 = module.AUDIO.Rise

			rise.Volume = if v263 then v263.Volume else 1
			rise.TimePosition = 0
			rise:Play()
		end
		local function restore()
			if u205 then
				u205 = false
				pcall(function()
					fovController.Pop("DevilsSightPunch", 0)
				end)
				pcall(function()
					fovController.Pop("DevilsSight", 0)
				end)
				CurrentCamera.CameraType = currentCameraCameraType
				CurrentCamera.CameraSubject = currentCameraCameraSubject

				if currentCameraCameraType == Enum.CameraType.Scriptable then
					CurrentCamera.CFrame = currentCameraCFrame
				end
			end

			for _, v in ipairs(t14) do
				if v.Parent then
					v.Enabled = true
				end
			end

			table.clear(t14)

			if u208 then
				u208 = false
				soundService:SetAttribute("MusicDuck", musicDuck)
			end

			pcall(function()
				__DevilsSightGrade:Destroy()
			end)
			pcall(function()
				clone:Destroy()
			end)
		end

		local t15: {[any]: any} = {}

		local function once(p28, p29)
			if t15[p28] then
				return
			end

			t15[p28] = true

			local ok, result = pcall(p29)

			if not ok then
				local text2: string = tostring(result)

				warn("[DevilsSightReveal] " .. p28 .. ": " .. text2)
			end
		end

		local t16: {[any]: any} = {}

		local function shockwave(p30, p31, p32, p33)
			local part: Part = Instance.new("Part")

			part.Shape = Enum.PartType.Cylinder
			part.Material = Enum.Material.Neon
			part.Color = p31
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Transparency = 1
			part.Size = Vector3.new(0.2, 2, 2)
			part.CFrame = CFrame.new(v116.X, cFrameY + 0.45, v116.Z) * v15
			part.Parent = clone
			table.insert(t16, { part = part, at = p30, dur = p33, maxR = p32 })
		end

		local t17: {[any]: any} = {}
		local u216 = nil
		local u217 = nil
		local n14 = 0
		local n15 = 0

		local function snap(p34)
			if u140 then
				u140:Destroy()
			end

			if v161 and v161:IsA("BasePart") then
				local clone5: Instance = v161:Clone()

				clone5.Anchored = true
				clone5.CanCollide = false
				clone5.CanQuery = false
				clone5.CanTouch = false
				clone5.CastShadow = false
				clone5.Transparency = 1
				clone5.CFrame = CFrame.new(v116)
				clone5.Parent = clone
				redden(clone5)
				emitAll(clone5, 2.2)

				local pointLight: Instance = clone5:FindFirstChildOfClass("PointLight")

				if pointLight then
					pointLight.Enabled = true
					pointLight.Brightness = 10
					pointLight.Range = 45
					tweenService:Create(pointLight, TweenInfo.new(1.4), { Brightness = 0 }):Play()
				end
			end

			if ground and ground:IsA("BasePart") then
				local clone6: Instance = ground:Clone()

				clone6.Anchored = true
				clone6.CanCollide = false
				clone6.CanQuery = false
				clone6.CanTouch = false
				clone6.CastShadow = false
				clone6.Transparency = 1
				clone6.CFrame = CFrame.new(v116.X, cFrameY + 0.3, v116.Z)
				clone6.Parent = clone
				redden(clone6)
				emitAll(clone6, 3)
			end

			shockwave(p34, color32, 46, 0.7)
			shockwave(p34 + 0.08, color33, 38, 0.8)

			local random = Random.new()

			local function fling(p35, p36)
				local n1 = p35.Position - v116
				local vector3 = Vector3.new(n1.X, 0, n1.Z)
				local v441

				if vector3.Magnitude > 0.01 then
					v441 = vector3.Unit
				else
					local v442 = random:NextNumber(-1, 1)

					v441 = Vector3.new(v442, 0, random:NextNumber(-1, 1)).Unit
				end

				n1 = p36 or {
					vel = Vector3.new(0, 0, 0),
					spin = Vector3.new(0, 0, 0),
					bounces = 0,
					resting = false,
					part = p35,
					base = p35.CFrame,
					rot = p35.CFrame.Rotation
				}

				local v443 = random:NextNumber(14, 32)
				local v444 = random:NextNumber(10, 28)
				local vector32 = Vector3.new(0, v444, 0)

				n1.vel = v441 * v443 + vector32
				n1.rot = p35.CFrame.Rotation

				local v446 = random:NextNumber(-12, 12)

				v443 = random:NextNumber(-12, 12)
				n1.spin = Vector3.new(v446, v443, random:NextNumber(-12, 12))
				p35.Transparency = 0
				table.insert(t17, n1)
			end

			for _, v in ipairs(t11) do
				for _, iterValue in ipairs(v.links) do
					if iterValue.part.Transparency < 1 then
						fling(iterValue.part, iterValue)
					end
				end
			end

			for _, v in pairs(t12) do
				if v.Transparency < 1 then
					fling(v, nil)
				end
			end

			for _, v in ipairs(t9) do
				emitAll(v)
			end

			n15 = 1.4
			pcall(function()
				fovController.Push("DevilsSightPunch", 9, 0)
				task.delay(0.06, function()
					pcall(function()
						fovController.Pop("DevilsSightPunch", 0.8)
					end)
				end)
			end)

			local explode = t6.Explode

			if explode then
				local v291 = module.AUDIO.Explode

				explode.Volume = if v291 then v291.Volume else 1
				explode.TimePosition = 0
				explode:Play()
			end

			local reveal = t6.Reveal

			if reveal then
				local v293 = module.AUDIO.Reveal

				reveal.Volume = if v293 then v293.Volume else 1
				reveal.TimePosition = 0
				reveal:Play()
			end

			if t4.onReveal then
				task.spawn(t4.onReveal)
			end
		end

		local n16 = 0
		local n17 = -1
		local u223 = nil
		local u224: boolean = false
		local u225: boolean = false
		local v226 = coroutine.running()

		textButton.MouseButton1Click:Connect(function()
			if u223 == nil and n17 >= n7 then
				u223 = n16
			end
		end)

		local connection = userInputService.InputBegan:Connect(function(input: InputObject)
			local keyCode: Enum.KeyCode = input.KeyCode

			if (keyCode == Enum.KeyCode.ButtonA or keyCode == Enum.KeyCode.ButtonB or keyCode == Enum.KeyCode.Return or keyCode == Enum.KeyCode.Space) and u223 == nil and n17 >= n7 then
				u223 = n16
			end
		end)

		local connection2 = nil

		local function finish()
			if u225 then
				return
			end

			u225 = true

			if connection2 then
				connection2:Disconnect()
			end

			connection:Disconnect()
			restore()
			pcall(function()
				__DevilsSightReveal:Destroy()
			end)

			if coroutine.status(v226) == "suspended" then
				task.spawn(v226)
			end
		end
		local function update(p38)
			if u100 and music and music.IsPlaying then
				local n26 = numberValue + music.TimePosition - n16

				if n26 < -0.12 then
					n1 += p38

					if n1 > 3 then
						u100 = false
					end

					p38 = 0
				else
					n1 = 0

					local v298 = math.clamp(n26, -0.05, 0.25)

					p38 = math.max(0, p38 + v298 * 0.2)
				end
			end

			n16 += p38

			if numberValue > 0 and n16 >= numberValue then
				local function v299()
					local music = t6.Music

					if not music then
						return
					end

					local v448 = module.AUDIO.Music

					music.Volume = if v448 then v448.Volume else 1
					music.TimePosition = 0
					music:Play()
				end

				if not t15.track then
					t15.track = true

					local ok, result = pcall(v299)

					if not ok then
						local text3: string = tostring(result)

						warn("[DevilsSightReveal] " .. "track" .. ": " .. text3)
					end
				end
			end

			if n17 < 0 then
				frame2.BackgroundTransparency = 1 - math.clamp(n16 / t.BLACK_IN, 0, 1)

				if n16 >= t.BLACK_IN and not t15.takeover then
					t15.takeover = true

					local ok, result = pcall(takeover)

					if not ok then
						local text4: string = tostring(result)

						warn("[DevilsSightReveal] " .. "takeover" .. ": " .. text4)
					end
				end

				if n16 < t.BLACK_IN + t.BLACK_HOLD then
					return
				end

				n17 = 0
			else
				n17 += p38
			end

			if u223 then
				local n27 = (n16 - u223) / t.FADE_OUT

				if t6.Music then
					local music2 = t6.Music
					local v308 = module.AUDIO.Music
					local v309 = if v308 then v308.Volume else 1
					local v310 = math.clamp(n27, 0, 1)

					music2.Volume = v309 * (1 - v310)
				end

				if n27 < 1 then
					frame2.BackgroundTransparency = 1 - n27
				elseif not u224 then
					u224 = true
					frame2.BackgroundTransparency = 0
					restore()

					for _, v in ipairs({ v82, v86, v89 }) do
						v.Visible = false
					end

					frame3.Visible = false
					frame4.Visible = false
				elseif n27 < 2 then
					frame2.BackgroundTransparency = n27 - 1
				else
					finish()
				end

				if u224 then
					return
				end
			else
				frame2.BackgroundTransparency = math.clamp(n17 / t.FADE_IN, 0, 1)
			end

			local n3 = 0
			local n28

			if n17 < tRise then
				local n29 = n17 / t.RISE
				local v316 = v106.Position
				local v317 = v108.Position
				local v318 = math.clamp(n29, 0, 1)
				local v319 = v316:Lerp(v317, if v318 < 0.5 then v318 ^ 3 * 4 else 1 - (v318 * -2 + 2) ^ 3 / 2)
				local rotation = v106.Rotation
				local v321 = v108.Rotation
				local v322 = math.clamp((n29 - 0.62) / 0.38, 0, 1)
				local v323 = rotation:Lerp(v321, v322 * v322 * (3 - v322 * 2))
				local cFrame5 = CFrame.new(v319)
				local cFrameAngles = CFrame.Angles
				local sine = math.sin(n29 * 3.141592653589793)
				local cFrame = cFrameAngles(0, 0, sine * 0.22)

				n28 = cFrame5 * v323 * cFrame
				n3 = math.sin(n29 * 3.141592653589793) * 0.12 + 0.06

				if v319.Y >= n2 then
					local function v328()
						u216 = n17
						frame5.BackgroundColor3 = color32

						for _, v in ipairs(t10) do
							emitAll(v)
						end

						local breach = t6.Breach

						if not breach then
							return
						end

						local v452 = module.AUDIO.Breach

						breach.Volume = if v452 then v452.Volume else 1
						breach.TimePosition = 0
						breach:Play()
					end

					if not t15.breach then
						t15.breach = true

						local ok, result = pcall(v328)

						if not ok then
							local text5: string = tostring(result)

							warn("[DevilsSightReveal] " .. "breach" .. ": " .. text5)
						end
					end
				end
			elseif n17 < n4 then
				local v332 = math.clamp((n17 - tRise) / t.EMERGE, 0, 1)

				n28 = v108:Lerp(v110, 1 - (1 - v332) ^ 3)
			elseif n17 < n5 then
				local v333 = math.clamp((n17 - n4) / t.CHAINS, 0, 1)

				n28 = v110:Lerp(v112, if v333 < 0.5 then v333 ^ 3 * 4 else 1 - (v333 * -2 + 2) ^ 3 / 2)
			elseif n17 < n6 then
				local n30 = (n17 - n5) / t.BUILD
				local v334 = math.clamp(n30, 0, 1)
				local n31 = if v334 < 0.5 then v334 ^ 3 * 4 else 1 - (v334 * -2 + 2) ^ 3 / 2

				v334 = v112.Position - v116

				local n8 = (v114.Position - v116) * 1.2
				local v337 = math.atan2(v334.X, v334.Z)
				local v338 = math.atan2(n8.X, n8.Z)
				local magnitude = Vector2.new(v334.X, v334.Z).Magnitude
				local vector2 = Vector2.new(n8.X, n8.Z)
				local n9 = v337 + (v338 - v337) * n31

				v338 = magnitude + (vector2.Magnitude - magnitude) * n31

				local sine = math.sin(n9)
				local n10 = v334.Y + (n8.Y - v334.Y) * n31
				local cosine = math.cos(n9)
				local vector3 = Vector3.new(sine * v338, n10, cosine * v338)

				n28 = CFrame.lookAt(v116 + vector3, v116)
				u217 = n28
				n3 = 0.06 + 0.5 * n30 ^ 1.6
			else
				local v346 = u217 or v114
				local n11 = 1 - (1 - math.clamp((n17 - n6) / t.SETTLE, 0, 1)) ^ 3
				local sine = math.sin((n17 - n6) * 0.5)
				local v348 = v346:Lerp(v114, n11)
				local cFrame6 = CFrame.new(sine * 0.6 * n11, 0, 0)
				local cFrameLookAt = CFrame.lookAt
				local vector3 = Vector3.new(0, n11 * 0.6, 0)

				n28 = cFrameLookAt((v348 * cFrame6).Position, v116 + vector3)
			end

			n15 = math.max(0, n15 - p38 * 2.2)

			local n12 = n3 + n15

			if n12 > 0 then
				local cFrameNew = CFrame.new
				local v354 = math.noise(n16 * 17, 0.3)
				local v355 = math.noise(n16 * 17, 7.1)
				local v356 = cFrameNew(v354 * n12, v355 * n12, 0)
				local angles = CFrame.Angles
				local v358 = math.noise(n16 * 11, 3.7)
				local v359 = angles(0, 0, v358 * n12 * 0.05)

				n28 = n28 * v356 * v359
			end

			if u205 then
				CurrentCamera.CFrame = n28
			end

			for i, v in ipairs(t9) do
				if n17 >= tRise + 0.2 + (i - 1) * 0.14 then
					local s1: string = "ignite" .. i

					local function v363()
						for _, iterValue in ipairs(v:GetChildren()) do
							if iterValue:IsA("ParticleEmitter") then
								iterValue.Enabled = true
								iterValue:Emit(12)
							elseif iterValue:IsA("Light") then
								iterValue.Enabled = true
							end
						end

						local ignite = t6.Ignite

						if not ignite then
							return
						end

						local clone7 = ignite:Clone()
						local v457 = module.AUDIO.Ignite

						clone7.Volume = if v457 then v457.Volume else 1
						clone7.Parent = __DevilsSightReveal
						clone7:Play()
						debris:AddItem(clone7, 6)
					end

					if not t15[s1] then
						t15[s1] = true

						local ok, result = pcall(v363)

						if not ok then
							local text6: string = tostring(result)

							warn("[DevilsSightReveal] " .. s1 .. ": " .. text6)
						end
					end
				end
			end

			if n17 >= n5 and n17 < n6 then
				local n13 = (n17 - n5) / t.BUILD

				local function v368()
					local charge = t6.Charge

					if charge then
						local v459 = module.AUDIO.Charge

						charge.Volume = if v459 then v459.Volume else 1
						charge.TimePosition = 0
						charge:Play()
					end

					local chain = t6.Chain

					if not chain then
						return
					end

					local v461 = module.AUDIO.Chain

					chain.Volume = if v461 then v461.Volume else 1
					chain.TimePosition = 0
					chain:Play()
				end

				if not t15.charge then
					t15.charge = true

					local ok, result = pcall(v368)

					if not ok then
						local text7: string = tostring(result)

						warn("[DevilsSightReveal] " .. "charge" .. ": " .. text7)
					end
				end

				for i, v in ipairs(t11) do
					for i2, iterValue in ipairs(v.links) do
						local v376 = math.noise(i2 * 0.7, n17 * 14, i)
						local n32 = (0.04 + 0.22 * n13 ^ 1.5) * v376
						local v378 = iterValue.part
						local n33 = iterValue.base + v.perp * n32
						local vector3 = Vector3.new(0, n32 * 0.5, 0)

						v378.CFrame = n33 + vector3
					end
				end
			end

			if n17 >= n6 then
				local function v381()
					snap(n17)
				end

				if not t15.snap then
					t15.snap = true

					local ok, result = pcall(v381)

					if not ok then
						local text8: string = tostring(result)

						warn("[DevilsSightReveal] " .. "snap" .. ": " .. text8)
					end
				end

				local n34 = n17 - n6

				v381 = math.clamp(n34 / 0.4, 0, 1)

				if spotLight then
					spotLight.Brightness = v381 * 6
				end

				if pointLight then
					pointLight.Brightness = v381 * 4
				end

				if v121 then
					v121.Brightness = v122 * (1 - v381 * 0.7)
				end

				for _, v in ipairs(t11) do
					local pointLight2 = v.anchor:FindFirstChildOfClass("PointLight")

					if pointLight2 then
						pointLight2.Brightness = 2 - v381 * 1.3
					end

					v.anchor.Transparency = v381 * 0.5
				end

				v381 = 1 - (1 - math.clamp((n34 - 0.3) / 0.5, 0, 1)) ^ 3
				frame3.Position = UDim2.fromScale(0, v381 * -0.11)
				frame4.Position = UDim2.fromScale(0, v381 * 0.11 + 1)
			end

			if u139 then
				local cFrame7 = CFrame.new()
				local n35

				if n17 < n6 then
					local sine = math.sin(n17 * 1.6)
					local vector3 = Vector3.new(0, sine * 0.15, 0)

					n35 = v116 + vector3

					if n17 >= n5 then
						local n18 = (n17 - n5) / t.BUILD
						local v395 = math.noise(n17 * 25, 1)
						local v396 = math.noise(n17 * 25, 2)
						local vector33 = Vector3.new(v395, v396, math.noise(n17 * 25, 3))

						n35 += vector33 * 0.28 * n18 ^ 1.6
					end
				else
					local n19 = n17 - n6
					local v398 = math.clamp(n19 / 1.4, 0, 1)
					local v399 = math.max(0, n19 - 1.4)
					local sine = math.sin(v399 * 0.9)

					v399 = math.clamp((n19 - 1.4) / 0.8, 0, 1)
					n14 = 6.283185307179586 * (1 - (1 - v398) ^ 3) + sine * 0.35 * v399

					local v401 = math.clamp(n19 / 0.6, 0, 1)
					local sine2 = math.sin(n19 * 1.4)
					local vector3 = Vector3.new(0, (1 - (1 - v401) ^ 3) * 0.6 + sine2 * 0.12, 0)

					n35 = v116 + vector3
					cFrame7 = CFrame.Angles(0, n14, 0)
				end

				local v404 = u139
				local cFrame8 = CFrame.new(n35)

				v404:PivotTo(cFrame8 * cFrame7 * cFrame2)
			end

			for _, v in ipairs(t17) do
				if not v.resting then
					local vVel = v.vel
					local vector3 = Vector3.new(0, p38 * 90, 0)

					v.vel = vVel - vector3

					local v410 = v.part.Position
					local n20 = v410 + v.vel * p38
					local v412 = workspace:Raycast(v410, n20 - v410, raycastParams)

					if v412 and v412.Normal.Y > 0.5 and v.vel.Y < 0 then
						n20 = v412.Position + Vector3.new(0, 0.3, 0)
						v.bounces = v.bounces + 1
						v.vel = Vector3.new(v.vel.X * 0.55, -v.vel.Y * 0.32, v.vel.Z * 0.55)
						v.spin = v.spin * 0.5

						if v.bounces >= 3 or math.abs(v.vel.Y) < 2 then
							v.resting = true
						end
					elseif n20.Y < cFrameY - 80 then
						v.resting = true
						v.part.Transparency = 1
					end

					local vRot = v.rot
					local v414 = CFrame.Angles(v.spin.X * p38, v.spin.Y * p38, v.spin.Z * p38)

					v.rot = vRot * v414
					v.part.CFrame = CFrame.new(n20) * v.rot
				end
			end

			for _, v in ipairs(t16) do
				local n21 = (n17 - v.at) / v.dur

				if n21 >= 0 and n21 <= 1 then
					local n22 = v.maxR * 2
					local v419 = math.clamp(n21, 0, 1)
					local n23 = n22 * (1 - (1 - v419) ^ 3) + 2

					v.part.Size = Vector3.new(0.2, n23, n23)
					v.part.Transparency = n21 * 0.65 + 0.35
				elseif n21 > 1 then
					v.part.Transparency = 1
				end
			end

			local n24 = 1

			if u216 then
				local v422 = math.clamp((n17 - u216) / 0.4, 0, 1)

				n24 = math.min(n24, v422 * 0.55 + 0.45)
			end

			if n17 >= n6 then
				frame5.BackgroundColor3 = color32

				local v423 = math.clamp((n17 - n6) / 0.55, 0, 1)

				n24 = math.min(n24, v423 * 0.85 + 0.15)
			end

			frame5.BackgroundTransparency = n24

			if n17 >= n6 then
				local n25 = n17 - n6
				local v425 = if u223 then math.clamp((n16 - u223) / t.FADE_OUT, 0, 1) else 0
				local v426 = math.clamp((n25 - 0.5) / 0.45, 0, 1)
				local v427 = math.clamp((n25 - 0.7) / 0.45, 0, 1)
				local v428 = math.clamp(v426, 0, 1)

				v84.Scale = ((v428 - 1) ^ 3 * 2.70158 + 1 + (v428 - 1) ^ 2 * 1.70158) * 0.4 + 0.6
				v428 = math.clamp(v427, 0, 1)
				v88.Scale = ((v428 - 1) ^ 3 * 2.70158 + 1 + (v428 - 1) ^ 2 * 1.70158) * 0.4 + 0.6
				v82.TextTransparency = math.clamp(1 - v426 + v425, 0, 1)
				v83.Transparency = v82.TextTransparency
				v86.TextTransparency = math.clamp(1 - v427 + v425, 0, 1)
				v87.Transparency = v86.TextTransparency

				if n17 >= n7 then
					local v429 = math.clamp((n17 - n7) / 0.4, 0, 1)
					local sine = math.sin((n17 - n7) * 3)

					v89.TextTransparency = math.clamp(1 - v429 + (sine * 0.5 + 0.5) * 0.15 + v425, 0, 1)
					v90.Transparency = v89.TextTransparency

					if n17 >= n7 + t.AUTO_CONTINUE and u223 == nil and n17 >= n7 then
						u223 = n16
					end
				end
			end
		end

		if music and not music.IsLoaded then
			local v231 = os.clock()

			while not music.IsLoaded and os.clock() - v231 < 2 do
				task.wait()
			end
		end

		u208 = true
		soundService:SetAttribute("MusicDuck", 0)

		if numberValue <= 0 then
			local v232 = t6.Music

			if v232 then
				local v233 = module.AUDIO.Music

				v232.Volume = if v233 then v233.Volume else 1
				v232.TimePosition = 0
				v232:Play()
			end

			if music and numberValue < 0 then
				music.TimePosition = -numberValue
			end
		end

		connection2 = runService.RenderStepped:Connect(function(deltaTime: number)
			if u225 then
				return
			end

			local ok, result = pcall(update, deltaTime)

			if not ok then
				local text9: string = tostring(result)

				warn("[DevilsSightReveal] aborted: " .. text9)

				if t4.onReveal and not t15.snap then
					t15.snap = true
					task.spawn(t4.onReveal)
				end

				finish()
			end
		end)

		if not u225 then
			coroutine.yield()
		end

		return
	end

	warn("[DevilsSightReveal] no Scene model or camera; skipped")

	if t4.onReveal then
		t4.onReveal()
	end
end

return module
