-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local caseOpenFX: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("CaseOpenFX")
local caseOpens: Instance = replicatedStorage:WaitForChild("FX"):WaitForChild("CaseOpens")
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local caseStripSeq = require(shared:WaitForChild("CaseStripSeq"))
local caseSpinFeel = require(shared:WaitForChild("CaseSpinFeel"))
local v13 = caseSpinFeel.ScrollDecayRate()
local n1 = 1 / math.max(caseSpinFeel.CentrePulseIn.Time, 0.001)
local n2 = caseSpinFeel.CardHeightScale * 0.88
local n3 = n2 * 0.396551724137931
local n4 = n3 + caseSpinFeel.CardGapPerCard * n3
local rarityColors = rarity.Colors

n3 = function(p1)
	return typeof(p1) == "string" and rarityColors[p1] ~= nil and p1 or "Common"
end

local t1: {[any]: any} = { radius = 50, volume = 0.4 }
local u20 = nil

task.spawn(function()
	local ok, result = pcall(function()
		return require(replicatedStorage:WaitForChild("Sound"))
	end)

	if ok then
		u20 = result
	end
end)
task.spawn(function()
	local fx: Instance = replicatedStorage:FindFirstChild("FX")

	if fx then
		fx:WaitForChild("CaseFillerPools", 30)
	end

	if not caseStripSeq.Ready() then
		warn("[CaseOpenFX] no CaseFillerPools; mini-spinner disabled")
	end
end)

local t2: {[any]: any} = {
	RegularCase = true,
	PremiumCase = true,
	FinishersCase = true,
	SpaceCase = true,
	HallowsCase = true
}
local animation: Animation = Instance.new("Animation")

animation.AnimationId = "rbxassetid://85334013557263"
animation.Parent = script

local t3: {[any]: any} = { FinishersCase = "rbxassetid://80994313995054" }
local t4: {[any]: any} = {}

local function getOpenAnim(p2)
	local animationId = t3[p2] or "rbxassetid://109105990542453"
	local v63 = t4[animationId]

	if not v63 then
		v63 = Instance.new("Animation")
		v63.AnimationId = animationId
		v63.Parent = script
		t4[animationId] = v63
	end

	return v63
end
local function shortestAngleDiff(p3, p4)
	local n1 = (p4 - p3) % 6.283185307179586

	if n1 > 3.141592653589793 then
		n1 -= 6.283185307179586
	end

	return n1
end

local t5: {[any]: any} = {}
local connection = nil
local n5 = 0

local function keyOf(p5, p6)
	return p5 .. "_" .. p6
end
local function pickLandXZ(p7)
	local t8: {[any]: any} = {}

	for _, v in pairs(t5) do
		if v.landXZ then
			table.insert(t8, v.landXZ)
		end
	end

	local v73 = nil
	local n1 = -1

	for _ = 1, 16 do
		local n2 = math.random() * 6.283185307179586
		local n3 = 3 * (0.85 + math.random() * 0.6) + #t8 * 0.8
		local sine = math.sin(n2)
		local cosine = math.cos(n2)
		local vector3 = Vector3.new(sine * n3, 0, cosine * n3)
		local n4 = p7 + vector3

		n3 = math.huge

		for _, v in ipairs(t8) do
			local n5 = n4.X - v.X
			local n6 = n4.Z - v.Z
			local squareRoot = math.sqrt(n5 * n5 + n6 * n6)

			if n3 > squareRoot then
				n3 = squareRoot
			end
		end

		if n3 >= 3 then
			return n4
		end

		if n1 < n3 then
			n1 = n3
			v73 = n4
		end
	end

	return v73 or p7 + Vector3.new(3, 0, 0)
end
local function cleanup(p8)
	if p8 == t5[p8.key] then
		t5[p8.key] = nil
	end

	if p8.dead then
		return
	end

	p8.dead = true

	if p8.fallbackThread then
		pcall(task.cancel, p8.fallbackThread)
	end

	if p8.cleanupThread then
		pcall(task.cancel, p8.cleanupThread)
	end

	for _, v in ipairs(p8.tracks) do
		pcall(function()
			v:Stop(0)
		end)
		pcall(function()
			v:Destroy()
		end)
	end

	table.clear(p8.tracks)

	if p8.spinner then
		n5 = math.max(0, n5 - 1)

		if p8.spinner.gui then
			p8.spinner.gui:Destroy()
		end

		p8.spinner = nil
	end

	if p8.billboard then
		p8.billboard:Destroy()
		p8.billboard = nil
	end

	if p8.model then
		p8.model:Destroy()
		p8.model = nil
	end

	if next(t5) == nil and connection then
		connection:Disconnect()
		connection = nil
	end
end
local function buildModel(p9)
	local foundChild: Instance = caseOpens:FindFirstChild(p9)

	if not foundChild or not foundChild:IsA("Model") then
		return nil
	end

	local clone: Instance = foundChild:Clone()
	local playAnimation: Instance = clone:FindFirstChild("PlayAnimation")

	if playAnimation then
		playAnimation:Destroy()
	end

	local animSaves: Instance = clone:FindFirstChild("AnimSaves")

	if animSaves then
		animSaves:Destroy()
	end

	local caseRoot: Instance = clone:FindFirstChild("CaseRoot")

	if not caseRoot or not caseRoot:IsA("BasePart") then
		clone:Destroy()

		return nil
	end

	clone.PrimaryPart = caseRoot
	clone:ScaleTo(0.4)

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = v == caseRoot
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
		end
	end

	local animationController = clone:FindFirstChildOfClass("AnimationController")

	if not animationController then
		animationController = Instance.new("AnimationController")
		animationController.Parent = clone
	end

	local animator = animationController:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = animationController
	end

	return clone, caseRoot, animator
end
local function buildBillboard(parent, p11)
	local caseRewardBillboard: BillboardGui = Instance.new("BillboardGui")

	caseRewardBillboard.Name = "CaseRewardBillboard"
	caseRewardBillboard.Adornee = parent
	caseRewardBillboard.Size = UDim2.fromScale(2.2, 2.2)
	caseRewardBillboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	caseRewardBillboard.AlwaysOnTop = false
	caseRewardBillboard.LightInfluence = 0
	caseRewardBillboard.MaxDistance = 110
	caseRewardBillboard.ResetOnSpawn = false
	caseRewardBillboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local canvasGroup: CanvasGroup = Instance.new("CanvasGroup")

	canvasGroup.BackgroundTransparency = 1
	canvasGroup.Size = UDim2.fromScale(1, 1)
	canvasGroup.GroupTransparency = 1
	canvasGroup.Parent = caseRewardBillboard

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Scale = 0.6
	uiScale.Parent = canvasGroup

	local uiFrameworkCreateItemCell = uiFramework.createItemCell
	local rarity = p11.Rarity
	local typeName: string = typeof(rarity)
	local v108 = uiFrameworkCreateItemCell(typeName == "string" and rarityColors[rarity] ~= nil and rarity or "Common", { icon = p11.Icon })

	v108.Size = UDim2.fromScale(1, 1)
	v108.Position = UDim2.fromScale(0.5, 0.5)
	v108.AnchorPoint = Vector2.new(0.5, 0.5)
	v108.Active = false
	v108.Parent = canvasGroup
	caseRewardBillboard.Parent = parent

	return caseRewardBillboard, canvasGroup, uiScale
end
local function buildRing(p12, p13)
	local v111, v112, v113 = caseStripSeq.Build(p12, p13, 64)

	if v112 and v113 then
		for i = 1, 64 do
			local v115 = v113[i]

			v113[i] = typeof(v115) == "string" and rarityColors[v115] ~= nil and v115 or "Common"
		end

		return v112, v113, v111
	end

	return nil, nil, nil
end
local function makeCell(p14, parent)
	local card = uiFramework.createItemCell(p14, { icon = "rbxasset://textures/ui/GuiImagePlaceholder.png" })

	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Size = UDim2.fromScale(1, n2)
	card.ZIndex = 2

	local uiAspectRatioConstraint = card:FindFirstChildOfClass("UIAspectRatioConstraint")

	if not uiAspectRatioConstraint then
		uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		uiAspectRatioConstraint.Parent = card
	end

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	card.Active = false
	card.Interactable = false
	card.Selectable = false
	card.AutoButtonColor = false
	card.Visible = false
	card.Parent = parent

	return card
end
local function acquireCell(p16, p17)
	local v122 = p16.pool[p17]
	local v124

	if v122 then
		local n1: number = #v122

		if n1 > 0 then
			local v125 = v122[n1]

			v122[n1] = nil

			return v125
		end

		v124 = makeCell(p17, p16.track)

		return v124
	end

	v124 = makeCell(p17, p16.track)

	return v124
end
local function releaseCell(p18, p19, p20)
	p20.Visible = false

	local t9 = p18.pool[p19]

	if not t9 then
		t9 = {}
		p18.pool[p19] = t9
	end

	if #t9 >= 3 then
		p20:Destroy()

		return
	end

	table.insert(t9, p20)
end
local function destroySpinner(p21)
	local spinner = p21.spinner

	if not spinner then
		return
	end

	p21.spinner = nil
	n5 = math.max(0, n5 - 1)

	if spinner.gui then
		spinner.gui:Destroy()
	end
end
local function buildSpinner(p22, parent, p24, p25)
	if n5 >= 6 then
	elseif typeof(p24) == "string" and typeof(p25) == "number" then
		local v136, v137, v138 = buildRing(p24, p25)

		if v136 and v137 then
			local caseSpinnerBillboard: BillboardGui = Instance.new("BillboardGui")

			caseSpinnerBillboard.Name = "CaseSpinnerBillboard"
			caseSpinnerBillboard.Adornee = parent
			caseSpinnerBillboard.Size = UDim2.fromScale(2.9, 1.15)
			caseSpinnerBillboard.StudsOffsetWorldSpace = Vector3.new(0, 2.9, 0)
			caseSpinnerBillboard.AlwaysOnTop = false
			caseSpinnerBillboard.LightInfluence = 0
			caseSpinnerBillboard.MaxDistance = 80
			caseSpinnerBillboard.ResetOnSpawn = false
			caseSpinnerBillboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			local track: Frame = Instance.new("Frame")

			track.Name = "Track"
			track.AnchorPoint = Vector2.new(0.5, 0.5)
			track.Position = UDim2.fromScale(0.5, 0.5)
			track.Size = UDim2.fromScale(1, 1)
			track.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
			track.BackgroundTransparency = 0.25
			track.BorderSizePixel = 0
			track.ClipsDescendants = true
			track.Active = false
			track.ZIndex = 1
			track.Parent = caseSpinnerBillboard

			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(0.12, 0)
			uiCorner.Parent = track

			local uiScale: UIScale = Instance.new("UIScale")

			uiScale.Scale = 0
			uiScale.Parent = track

			local v143 = table.create(7)
			local v144 = table.create(7)

			for i = 1, 7 do
				v143[i] = { cell = nil, icon = nil, scale = nil, rarity = nil }
				v144[i] = math.huge
			end

			local marker: Frame = Instance.new("Frame")

			marker.Name = "Marker"
			marker.AnchorPoint = Vector2.new(0.5, 0.5)
			marker.Position = UDim2.fromScale(0.5, 0.5)
			marker.Size = UDim2.fromScale(0.014, 1)
			marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			marker.BackgroundTransparency = 0.35
			marker.BorderSizePixel = 0
			marker.Active = false
			marker.ZIndex = 6
			marker.Parent = track
			caseSpinnerBillboard.Parent = parent
			p22.spinner = {
				centreIdx = nil,
				centreSlot = nil,
				pulseTween = nil,
				gui = caseSpinnerBillboard,
				track = track,
				trackScale = uiScale,
				cards = v143,
				cardIdx = v144,
				ringIcons = v136,
				ringRarities = v137,
				pool = {},
				hood = v138
			}
			n5 += 1

			local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			tweenService:Create(uiScale, tweenInfo, { Scale = 1 }):Play()

			return true
		end

		return false
	end

	return false
end
local function entryAt(p26, p27)
	local spinner = p26.spinner
	local winnerIndex = p26.winnerIndex
	local n1

	if winnerIndex then
		local n2 = p27 - winnerIndex

		if n2 == 0 then
			local icon = p26.reward.Icon
			local rarity = p26.reward.Rarity
			local typeName: string = typeof(rarity)

			return icon ~= "" and icon or "rbxasset://textures/ui/GuiImagePlaceholder.png", typeName == "string" and rarityColors[rarity] ~= nil and rarity or "Common"
		end

		local spinnerHood = spinner.hood
		local v158 = spinnerHood and spinnerHood[n2]

		if v158 then
			local v159 = v158.Icon
			local v160 = v158.Rarity
			local typeName: string = typeof(v160)

			return v159, typeName == "string" and rarityColors[v160] ~= nil and v160 or "Common"
		end

		n1 = p27 % #spinner.ringIcons + 1

		return spinner.ringIcons[n1], spinner.ringRarities[n1]
	end

	n1 = p27 % #spinner.ringIcons + 1

	return spinner.ringIcons[n1], spinner.ringRarities[n1]
end
local function renderStrip(p28)
	local spinner = p28.spinner

	if not spinner then
		return
	end

	local spinOffset = p28.spinOffset
	local floored = math.floor(spinOffset)

	for i = 1, 7 do
		local n3 = floored - 4 + i
		local v168 = spinner.cards[i]

		if spinner.cardIdx[i] ~= n3 then
			spinner.cardIdx[i] = n3

			local v169, v170 = entryAt(p28, n3)

			if v170 ~= v168.rarity then
				local cell = v168.cell
				local rarity = v168.rarity

				if cell and rarity then
					cell.Visible = false

					local t10 = spinner.pool[rarity]

					if not t10 then
						t10 = {}
						spinner.pool[rarity] = t10
					end

					if #t10 >= 3 then
						cell:Destroy()
					else
						table.insert(t10, cell)
					end
				end

				local v174 = spinner.pool[v170]
				local n2

				if v174 then
					n2 = #v174
				end

				local v176

				if not v174 or not (n2 > 0) then
					v176 = makeCell(v170, spinner.track)
				else
					local v177 = v174[n2]

					v174[n2] = nil
					v176 = v177
				end

				v168.cell = v176
				v168.rarity = v170
				v168.icon = v176:FindFirstChild("Icon")
				v168.scale = v176:FindFirstChildOfClass("UIScale")
				v176.Visible = true
			end

			if v168.icon then
				v168.icon.Image = v169
			end

			local scale = v168.scale

			if scale and scale.Scale ~= 1 then
				scale.Scale = 1
			end
		end

		local v179 = v168.cell

		if v179 then
			v179.Position = UDim2.fromScale(0.5 + (n3 - spinOffset) * n4, 0.5)
		end
	end

	if p28.spinVel <= n1 then
		local rounded = math.round(spinOffset)

		if spinner.centreIdx ~= rounded then
			spinner.centreIdx = rounded

			if spinner.pulseTween then
				spinner.pulseTween:Cancel()
				spinner.pulseTween = nil
			end

			local spinnerCentreSlot = spinner.centreSlot

			if spinnerCentreSlot then
				local v182 = spinner.cards[spinnerCentreSlot].scale

				if v182 then
					tweenService:Create(v182, caseSpinFeel.CentrePulseOut, { Scale = 1 }):Play()
				end
			end

			spinner.centreSlot = nil

			for i = 1, 7 do
				if rounded == spinner.cardIdx[i] then
					local v184 = spinner.cards[i].scale

					if not v184 then
						break
					end

					spinner.centreSlot = i
					spinner.pulseTween = tweenService:Create(v184, caseSpinFeel.CentrePulseIn, { Scale = caseSpinFeel.CentreCardScale })
					spinner.pulseTween:Play()

					return
				end
			end

			return
		end

		return
	end
end

local n6 = 0
local t6: {[any]: any} = {
	Common = { radius = 35, volume = 0.3 },
	Uncommon = { radius = 35, volume = 0.3 },
	Rare = { radius = 50, volume = 0.4 },
	Epic = { radius = 60, volume = 0.45 },
	Legendary = { radius = 80, volume = 0.55 },
	Secret = { radius = 95, volume = 0.65 },
	Collectible = { radius = 95, volume = 0.65 },
	Exclusive = { radius = 80, volume = 0.55 }
}

local function playRevealSound(p29)
	if p29.soundPlayed then
		return
	end

	p29.soundPlayed = true

	if not u20 then
		return
	end

	if p29.userId == LocalPlayer.UserId then
		return
	end

	local landPos = p29.landPos

	if not landPos then
		return
	end

	local rarity2 = p29.reward.Rarity
	local v188 = t6[rarity2] or t1
	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera and (CurrentCamera.CFrame.Position - landPos):Dot(CurrentCamera.CFrame.Position - landPos) > v188.radius * v188.radius then
		return
	end

	if n6 >= 3 and (rarity.Order[rarity2] or 1) < 5 then
		return
	end

	local s1: string = "Crate." .. rarity2

	if not u20:Find(s1) then
		s1 = "Crate.Legendary"
	end

	local v191, v192, v193 = pcall(function()
		return u20:Play(s1, landPos, v188.radius, nil, v188.volume)
	end)

	if v191 and typeof(v193) == "Instance" then
		n6 += 1

		local u194: boolean = false

		local function release()
			if u194 then
				return
			end

			u194 = true
			n6 = math.max(0, n6 - 1)
		end

		v193.Ended:Connect(release)
		v193.Destroying:Connect(release)

		local timeLength = v193.TimeLength

		task.delay((timeLength > 0 and timeLength or 5) + 1, release)

		return
	end
end
local function showRewardBillboard(p30)
	if not p30.dead and not p30.billboard then
		local caseRoot = p30.caseRoot

		if not caseRoot then
			return
		end

		playRevealSound(p30)

		local v199, v200, v201 = buildBillboard(caseRoot, p30.reward)

		p30.billboard = v199

		local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(v199, tweenInfo, { StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0) }):Play()

		local tweenInfo2 = TweenInfo.new(0.36000000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v200, tweenInfo2, { GroupTransparency = 0 }):Play()

		local tweenInfo3 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(v201, tweenInfo3, { Scale = 1 }):Play()

		return
	end
end
local function finishSpinner(p31)
	local spinner = p31.spinner

	if spinner and not p31.dead then
		renderStrip(p31)
		playRevealSound(p31)

		if spinner.pulseTween then
			spinner.pulseTween:Cancel()
			spinner.pulseTween = nil
		end

		spinner.centreSlot = nil

		for i = 1, 7 do
			if spinner.cardIdx[i] == p31.winnerIndex then
				local scale = spinner.cards[i].scale

				if not scale then
					break
				end

				local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

				tweenService:Create(scale, tweenInfo, { Scale = 1.22 }):Play()

				break
			end
		end

		task.delay(0.12, function()
			if p31.dead then
				local v315 = p31
				local spinner = v315.spinner

				if not spinner then
					return
				end

				v315.spinner = nil
				n5 = math.max(0, n5 - 1)

				if spinner.gui then
					spinner.gui:Destroy()
				end

				return
			end

			local v317 = p31.spinner

			if v317 then
				local trackScale = v317.trackScale
				local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

				tweenService:Create(trackScale, tweenInfo, { Scale = 0 }):Play()

				local track = v317.track
				local tweenInfo4 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

				tweenService:Create(track, tweenInfo4, { BackgroundTransparency = 1 }):Play()
				task.delay(0.18, function()
					local v328 = p31
					local spinner = v328.spinner

					if not spinner then
						return
					end

					v328.spinner = nil
					n5 = math.max(0, n5 - 1)

					if spinner.gui then
						spinner.gui:Destroy()
					end
				end)
			end

			showRewardBillboard(p31)
		end)

		return
	end

	showRewardBillboard(p31)
end
local function doReveal(p32)
	if p32.dead or p32.revealed then
		return
	end

	if p32.phase == "Landed" then
		p32.revealed = true

		if p32.fallbackThread then
			pcall(task.cancel, p32.fallbackThread)
			p32.fallbackThread = nil
		end

		for _, v in ipairs(p32.tracks) do
			pcall(function()
				v:Stop(0.1)
			end)
		end

		local animator = p32.animator

		if animator and p32.caseRoot then
			local animationId = t3[p32.modelName] or "rbxassetid://109105990542453"
			local v215 = t4[animationId]

			if not v215 then
				v215 = Instance.new("Animation")
				v215.AnimationId = animationId
				v215.Parent = script
				t4[animationId] = v215
			end

			local v216 = animator:LoadAnimation(v215)

			v216.Looped = false
			v216.Priority = Enum.AnimationPriority.Action
			v216:Play()
			table.insert(p32.tracks, v216)

			if p32.spinner then
				p32.winnerIndex = math.floor(p32.spinOffset) + 8
				p32.revealPending = true
			else
				showRewardBillboard(p32)
			end

			local v217 = v216.Length

			if v217 <= 0 then
				v217 = 3
			end

			v216 = 0

			if p32.spinner then
				local v218 = math.max(p32.spinVel, 11)

				v216 = 4 / v218 + 12 / v218 + 0.12
			end

			p32.cleanupThread = task.delay(v217 + 1 + v216, function()
				if p32.dead then
					return
				end

				p32.phase = "Sinking"

				local canvasGroup = p32.billboard and p32.billboard:FindFirstChildOfClass("CanvasGroup")

				if canvasGroup then
					local tweenInfo = TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

					tweenService:Create(canvasGroup, tweenInfo, { GroupTransparency = 1 }):Play()
				end

				local caseRoot = p32.caseRoot

				if caseRoot then
					local n1 = caseRoot.CFrame - Vector3.new(0, 4, 0)
					local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local v327: Tween = tweenService:Create(caseRoot, tweenInfo, { CFrame = n1 })

					v327:Play()
					v327.Completed:Wait()
				else
					task.wait(0.6)
				end

				cleanup(p32)
			end)

			return
		end

		return
	end

	p32.pendingReveal = true
end
local function land(p33)
	local caseRoot = p33.caseRoot
	local animator = p33.animator
	local landPos = p33.landPos

	if caseRoot and animator and landPos then
		p33.currentYaw = p33.startYaw

		local cFrame = CFrame.new(landPos)
		local v224 = CFrame.Angles(0, p33.currentYaw, 0)

		caseRoot.CFrame = cFrame * v224

		local animationTrack = animator:LoadAnimation(animation)

		animationTrack.Looped = true
		animationTrack.Priority = Enum.AnimationPriority.Action
		animationTrack:Play()
		table.insert(p33.tracks, animationTrack)
		p33.phase = "Landed"

		if p33.pendingReveal then
			doReveal(p33)
		end

		return
	end
end
local function stepArc(p34, p35)
	local model = p34.model
	local landPos = p34.landPos

	if model and landPos then
		p34.arcElapsed = p34.arcElapsed + p35

		local v230 = math.clamp(p34.arcElapsed / 0.2, 0, 1)
		local v231 = p34.startPos:Lerp(landPos, v230)
		local sine = math.sin(3.141592653589793 * v230)
		local n1 = p34.startYaw + p34.spinDir * 6.283185307179586 * v230
		local cFrame = CFrame.new(v231.X, v231.Y + sine * 4, v231.Z)
		local v235 = CFrame.Angles(0, n1, 0)

		model:PivotTo(cFrame * v235)

		if v230 >= 1 then
			land(p34)
		end

		return
	end
end
local function stepFace(p36, p37)
	local caseRoot = p36.caseRoot
	local landPos = p36.landPos

	if caseRoot and landPos then
		local v240 = players:GetPlayerByUserId(p36.userId)
		local character = v240 and v240.Character

		v240 = character

		if v240 then
			v240 = character:FindFirstChild("HumanoidRootPart")
		end

		if not v240 or not v240:IsA("BasePart") then
			return
		end

		local n1 = v240.Position - landPos

		n1 = Vector3.new(n1.X, 0, n1.Z)

		if n1.Magnitude < 0.001 then
			return
		end

		local currentYaw = p36.currentYaw
		local n2 = (math.atan2(n1.X, n1.Z) - p36.decalLocalAngle + 0 - p36.currentYaw) % 6.283185307179586

		if n2 > 3.141592653589793 then
			n2 -= 6.283185307179586
		end

		local v245 = math.clamp(p37 * 10, 0, 1)

		p36.currentYaw = currentYaw + n2 * v245

		local cFrame = CFrame.new(landPos)

		n2 = CFrame.Angles(0, p36.currentYaw, 0)
		caseRoot.CFrame = cFrame * n2

		return
	end
end
local function stepSpinner(p38, p39, p40, p41)
	if not p38.spinner then
		return
	end

	local caseRoot = p38.caseRoot

	if not caseRoot then
		return
	end

	if p38.settling then
		p38.settleElapsed = p38.settleElapsed + p39

		local v252 = math.clamp(p38.settleElapsed / p38.settleDur, 0, 1)
		local n1 = 1 - v252

		p38.spinOffset = p38.settleFrom + (p38.settleTo - p38.settleFrom) * (1 - n1 * n1 * n1)

		local n2 = (p38.settleTo - p38.settleFrom) * 3 * n1 * n1
		local v255 = math.max(p38.settleDur, 0.001)

		p38.spinVel = n2 / v255

		if v252 >= 1 and not p38.settleDone then
			p38.settleDone = true
			p38.settling = false
			p38.spinOffset = p38.settleTo
			finishSpinner(p38)

			return
		end
	elseif not p38.settleDone then
		local u256: boolean = not p38.revealPending

		if u256 then
			u256 = os.clock() < p38.scrollStartClock
		end

		if u256 then
			p38.spinVel = 0
		else
			p38.scrollElapsed = p38.scrollElapsed + p39

			local v257 = math.exp(v13 * p38.scrollElapsed)

			p38.spinVel = math.max(11, v257 * 44)
			p38.spinOffset = p38.spinOffset + p38.spinVel * p39

			local v258 = p38.revealPending and p38.winnerIndex

			if v258 and v258 - p38.spinOffset <= 4 then
				local n3 = v258 - p38.spinOffset

				p38.revealPending = false
				p38.settleFrom = p38.spinOffset
				p38.settleTo = v258

				local v260 = math.max(p38.spinVel, 0.001)

				p38.settleDur = math.clamp(3 * n3 / v260, 0.45, 1.6)
				p38.settleElapsed = 0
				p38.settleDone = false
				p38.settling = true
			end
		end
	end

	local n4 = caseRoot.Position - p40

	if n4:Dot(p41) <= 0 then
		return
	end

	if n4:Dot(n4) > 8100 then
		return
	end

	renderStrip(p38)
end
local function stepAll(p42)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v264 = CurrentCamera and CurrentCamera.CFrame or CFrame.identity
	local v265 = v264.Position
	local lookVector = v264.LookVector

	for _, v in pairs(t5) do
		if not v.dead then
			if v.phase == "Arc" then
				stepArc(v, p42)
			elseif v.phase == "Landed" then
				stepFace(v, p42)
				stepSpinner(v, p42, v265, lookVector)
			end
		end
	end
end
local function ensureRenderLoop()
	if connection then
		return
	end

	connection = runService.RenderStepped:Connect(stepAll)
end

local t7: {[any]: any} = {
	[Enum.NormalId.Front] = Vector3.new(0, 0, -1),
	[Enum.NormalId.Back] = Vector3.new(0, 0, 1),
	[Enum.NormalId.Right] = Vector3.new(1, 0, 0),
	[Enum.NormalId.Left] = Vector3.new(-1, 0, 0),
	[Enum.NormalId.Top] = Vector3.new(0, 1, 0),
	[Enum.NormalId.Bottom] = Vector3.new(0, -1, 0)
}

local function beginEffect(p43, p44, p45, p46, p47, p48, p49)
	local v276 = players:GetPlayerByUserId(p43)
	local character = v276 and v276.Character

	v276 = character

	if v276 then
		v276 = character:FindFirstChild("HumanoidRootPart")
	end

	if not v276 or not v276:IsA("BasePart") then
		return
	end

	local v278, v279, v280 = buildModel(p44)

	if v278 and v279 and v280 then
		local t11: {[any]: any} = {
			key = p43 .. "_" .. p46,
			userId = p43,
			modelName = p44,
			token = p46,
			reward = {
				Rarity = typeof(p45) == "table" and typeof(p45.Rarity) == "string" and p45.Rarity or "Common",
				Icon = typeof(p45) == "table" and typeof(p45.Icon) == "string" and p45.Icon or "",
				Name = typeof(p45) == "table" and typeof(p45.Name) == "string" and p45.Name or ""
			},
			model = v278,
			caseRoot = v279,
			animator = v280,
			tracks = {},
			landXZ = nil,
			landPos = nil,
			billboard = nil,
			revealed = false,
			pendingReveal = false,
			dead = false,
			fallbackThread = nil,
			cleanupThread = nil,
			phase = "Arc",
			arcElapsed = 0,
			startPos = Vector3.new(0, 0, 0),
			startYaw = 0,
			spinDir = 1,
			currentYaw = 0,
			decalLocalAngle = 0,
			spinner = nil,
			spinOffset = 8,
			scrollStartClock = 0,
			scrollElapsed = 0,
			spinVel = 44,
			winnerIndex = nil,
			settling = false,
			settleFrom = 0,
			settleTo = 0,
			settleDur = 1,
			settleElapsed = 0,
			settleDone = false,
			revealPending = false,
			soundPlayed = false
		}

		t5[t11.key] = t11

		local n1 = math.random() * 6.283185307179586
		local randomNumber = math.random()
		local n2 = v276.Position + Vector3.new(0, 2, 0)
		local v285 = pickLandXZ(v276.Position)

		t11.landXZ = v285

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { character, v278 }

		local v287 = workspace:Raycast(v285 + Vector3.new(0, 6, 0), Vector3.new(0, -50, 0), raycastParams)
		local v288 = v287 and v287.Position.Y or v276.Position.Y - 2.5
		local v289, v290 = v278:GetBoundingBox()
		local pivot = v278:GetPivot()
		local vector3 = Vector3.new(v285.X, v288 + (pivot.Position.Y - (v289.Position.Y - v290.Y / 2)), v285.Z)
		local n3 = 0
		local decalPart = v278:FindFirstChild("DecalPart")

		if decalPart and decalPart:IsA("BasePart") then
			local decal = decalPart:FindFirstChildOfClass("Decal")
			local v296 = decalPart.CFrame:VectorToWorldSpace(t7[decal and decal.Face or Enum.NormalId.Front] or Vector3.new(0, 0, -1))
			local v297 = v279.CFrame:VectorToObjectSpace(v296)

			v297 = Vector3.new(v297.X, 0, v297.Z)

			if v297.Magnitude > 0.001 then
				local unit = v297.Unit

				n3 = math.atan2(unit.X, unit.Z)
			end
		end

		local cFrame = CFrame.new(n2)
		local v300 = CFrame.Angles(0, n1, 0)

		v278:PivotTo(cFrame * v300)
		v278.Parent = workspace
		t11.startPos = n2
		t11.startYaw = n1
		t11.spinDir = if randomNumber < 0.5 then 1 else -1
		t11.currentYaw = n1
		t11.decalLocalAngle = n3
		t11.landPos = vector3
		buildSpinner(t11, v279, p47, p48)
		t11.scrollStartClock = os.clock() + (p49 and caseSpinFeel.IntroLead or 0)
		t11.fallbackThread = task.delay(24, function()
			cleanup(t11)
		end)

		if connection then
			return
		end

		connection = runService.RenderStepped:Connect(stepAll)

		return
	end
end

caseOpenFX.OnClientEvent:Connect(function(p50, p51)
	if typeof(p50) == "string" and typeof(p51) == "table" then
		local openerUserId = p51.OpenerUserId
		local token = p51.Token

		if typeof(openerUserId) ~= "number" or typeof(token) ~= "number" then
			return
		end

		if p50 == "Begin" then
			local model = p51.Model

			if typeof(model) ~= "string" or not t2[model] then
				return
			end

			local v306 = typeof(p51.CrateId) == "string" and p51.CrateId or nil
			local typeName: string = typeof(p51.Seed)

			beginEffect(openerUserId, model, p51.Reward, token, v306, typeName == "number" and p51.Seed or nil, p51.Intro == true)

			return
		end

		local v308 = p50 == "Reveal" and t5[openerUserId .. "_" .. token]

		if v308 then
			doReveal(v308)
		end

		return
	end
end)
players.PlayerRemoving:Connect(function(player: Player)
	local t12: {[any]: any} = {}

	for _, v in pairs(t5) do
		if v.userId == player.UserId then
			table.insert(t12, v)
		end
	end

	for _, v in ipairs(t12) do
		cleanup(v)
	end
end)
