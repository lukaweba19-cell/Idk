-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(shared:WaitForChild("WeaponRigUtil"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local packCatalog = require(replicatedStorageShared:WaitForChild("PackCatalog"))
local v8: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(v8:WaitForChild("TraitText"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local packRequest: Instance = remotes:WaitForChild("PackRequest")
local packPush: Instance = remotes:WaitForChild("PackPush")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local openShop: Instance = bindables:WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = remotes:WaitForChild("ShopOpenAnalytics")
local inspectItem: Instance = bindables:WaitForChild("InspectItem")
local packColorPrompt: Instance = bindables:WaitForChild("PackColorPrompt")
local t1: {[any]: any} = {
	PackPodium = "ReleasePack",
	MegalodonPodium = "MegalodonBundle",
	MermaidPodium = "MermaidBundle",
	Premium1Podium = "MidnightBundle",
	Premium2Podium = "NinjaBundle"
}

local function podiumContainers()
	local t5: {[any]: any} = { workspace }
	local lobby: Instance = workspace:FindFirstChild("Lobby")

	if lobby then
		table.insert(t5, lobby)
	end

	return t5
end

local t2: {[any]: any} = {}

local function resolveWeaponSkins(p1)
	local s1 = "Default"
	local s2 = "Default"

	if p1 then
		for _, v in ipairs(p1.Rewards) do
			if v.Kind == "Knife" then
				s1 = v.ItemId or "Default"
			elseif v.Kind == "Revolver" then
				s2 = v.ItemId or "Default"
			end
		end
	end

	return s1, s2
end
local function applyAvatarAppearance(character, p3)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		warn("[PackPodiumController] No Humanoid found")

		return
	end

	local ok, result = pcall(function()
		return players:GetHumanoidDescriptionFromUserIdAsync(p3)
	end)

	if ok and result then
		for _, v in ipairs(character:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
				v:Destroy()
			end
		end

		local ok2, result2 = pcall(function()
			humanoid:ApplyDescriptionResetAsync(result)
		end)

		if not ok2 then
			warn("[PackPodiumController] ApplyDescription failed:", result2)
		end

		return
	end

	warn("[PackPodiumController] GetHumanoidDescriptionFromUserId failed:", result)
end
local function applyWeaponSkins(p4, p5, p6)
	local foundChild = p4:FindFirstChild("Right Arm")
	local foundChild2 = p4:FindFirstChild("Left Arm")

	if foundChild then
		weaponRigUtil.ApplyKnifeSkin(p4, p5, foundChild, "Knife_HandAttach")
	end

	if foundChild2 then
		weaponRigUtil.ApplyRevolverSkin(p4, p6, foundChild2, "Gun_HandAttach")
	end
end
local function playIdleAnimation(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local idle = character:FindFirstChild("Idle")

	if not idle or not idle:IsA("Animation") then
		warn("[PackPodiumController] No Idle animation found on Noob")

		return
	end

	local animationTrack = animator:LoadAnimation(idle)

	animationTrack.Looped = true
	animationTrack.Priority = Enum.AnimationPriority.Action4
	animationTrack:Play(0)
end
local function updatePromptVisibility(p8)
	local packDef = p8.packDef

	if not packDef then
		return
	end

	if packCatalog.IsExpired(packDef) then
		if p8.prompt then
			p8.prompt.Enabled = false
		end

		return
	end

	local packDefPurchaseLimit = packDef.PurchaseLimit

	if packDefPurchaseLimit > 0 and packDefPurchaseLimit <= p8.purchaseCount then
		p8.owned = true

		if p8.prompt then
			p8.prompt.Enabled = false

			return
		end
	else
		p8.owned = false

		if p8.prompt then
			p8.prompt.Enabled = true
		end
	end
end

local t3: {[any]: any} = {}

local function commaFormat(p9)
	local floored = math.floor(p9)
	local text = tostring(floored)

	repeat
		local v82, v83 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v82
	until v83 == 0

	return text
end
local function applyPromptText(p10)
	local prompt = p10.prompt
	local packDef = p10.packDef

	if prompt and packDef then
		local v87 = t3[packDef.Id]

		if v87 then
			local v88 = utf8.char(57346)
			local v89 = commaFormat(v87)

			prompt.ObjectText = v88 .. " " .. v89

			return
		end

		prompt.ObjectText = packDef.DisplayName

		return
	end
end
local function formatPackTimer(p11)
	if p11 <= 0 then
		return "EXPIRED"
	end

	local floored = math.floor(p11 / 86400)
	local floored2 = math.floor(p11 % 86400 / 3600)
	local floored3 = math.floor(p11 % 3600 / 60)

	if floored > 0 then
		return floored .. "d " .. floored2 .. "h " .. floored3 .. "m"
	end

	if floored2 > 0 then
		return floored2 .. "h " .. floored3 .. "m"
	end

	return floored3 .. "m " .. p11 % 60 .. "s"
end
local function resolvePreviewFinisher(p12, p13)
	local previewFinisher = p12:GetAttribute("PreviewFinisher")

	if typeof(previewFinisher) == "string" and previewFinisher ~= "" then
		return previewFinisher
	end

	if p13 then
		for _, v in ipairs(p13.Rewards) do
			if typeof(v.Finisher) == "string" and v.Finisher ~= "" then
				return v.Finisher
			end
		end

		return nil
	end

	return nil
end
local function prettifyId(p14)
	return (p14:gsub("(%l)(%u)", "%1 %2"))
end
local function initPodium(parent)
	local v101 = parent:GetAttribute("PackId") or t1[parent.Name] or "ReleasePack"
	local v102 = packCatalog.Get(v101)

	if not v102 then
		local v103 = parent:GetFullName()

		warn("[PackPodiumController] Pack '" .. v101 .. "' not found in PackCatalog for " .. v103)

		return nil
	end

	local v104, v105 = resolveWeaponSkins(v102)
	local noob = parent:FindFirstChild("Noob")
	local clone = nil
	local humanoidRootPart = nil

	if noob then
		clone = noob:Clone()
		clone.Name = "Noob"

		local pivot = noob:GetPivot()

		noob:Destroy()
		clone.Parent = parent
		clone:PivotTo(pivot)
		humanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.Anchored = true
		end
	end

	v101 = nil

	local promptPart = parent:FindFirstChild("PromptPart")

	if promptPart and promptPart:IsA("BasePart") then
		v101 = promptPart
	end

	if not v101 then
		v101 = humanoidRootPart
	end

	if not v101 then
		for _, v in ipairs(parent:GetChildren()) do
			if v:IsA("BasePart") and v:FindFirstChildOfClass("BillboardGui") then
				v101 = v

				break
			end
		end
	end

	if not v101 then
		v101 = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
	end

	local proximityPrompt = nil

	if v101 then
		proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.ObjectText = v102.DisplayName
		proximityPrompt.ActionText = "Purchase"
		proximityPrompt.HoldDuration = 0
		proximityPrompt.MaxActivationDistance = 10
		proximityPrompt.RequiresLineOfSight = false
		proximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
		proximityPrompt.Parent = v101
	end

	if v101 and (v102.PreviewItems or (if v114 then nil else resolvePreviewFinisher(parent, v102))) then
		local previewPrompt: ProximityPrompt = Instance.new("ProximityPrompt")

		previewPrompt.Name = "PreviewPrompt"
		previewPrompt.ObjectText = ""
		previewPrompt.ActionText = "Preview"
		previewPrompt.KeyboardKeyCode = Enum.KeyCode.Q
		previewPrompt.GamepadKeyCode = Enum.KeyCode.ButtonY
		previewPrompt.HoldDuration = 0
		previewPrompt.MaxActivationDistance = 10
		previewPrompt.RequiresLineOfSight = false
		previewPrompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
		previewPrompt.UIOffset = Vector2.new(0, -76)
		previewPrompt.Parent = v101
		previewPrompt.Triggered:Connect(function(playerWhoTriggered: Player)
			if playerWhoTriggered ~= LocalPlayer then
				return
			end

			if v114 then
				inspectItem:Fire({ Items = v114 })

				return
			end

			if not v159 then
				return
			end

			local previewFinisherRarity = parent:GetAttribute("PreviewFinisherRarity")
			local replacedText = v159:gsub("(%l)(%u)", "%1 %2")

			inspectItem:Fire({
				Kind = "Finisher",
				ItemId = v159,
				Name = replacedText,
				Rarity = if typeof(previewFinisherRarity) == "string" then previewFinisherRarity else "Legendary"
			})
		end)
	end

	v101 = nil

	for _, v in ipairs(parent:GetChildren()) do
		if v:IsA("BasePart") then
			local billboardGui = v:FindFirstChild("BillboardGui")
			local title = billboardGui and billboardGui:FindFirstChild("Title")
			local v120 = title

			if v120 then
				v120 = title:FindFirstChild("TimeLeft")
			end

			if v120 and v120:IsA("TextLabel") then
				v101 = v120

				break
			end
		end
	end

	for _, v in ipairs(parent:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "Chance" then
			traitText.Bind(v, v.Text)
		end
	end

	local t6: {[any]: any} = {
		owned = false,
		purchaseCount = 0,
		podium = parent,
		packDef = v102,
		noob = clone,
		hrp = humanoidRootPart,
		prompt = proximityPrompt,
		timeLeftLabel = v101,
		knifeSkin = v104,
		revolverSkin = v105
	}

	if proximityPrompt then
		proximityPrompt.Triggered:Connect(function(p17)
			if p17 ~= LocalPlayer then
			elseif not t6.owned and not packCatalog.IsExpired(v102) then
				if packCatalog.HasColors(v102) then
					packColorPrompt:Fire(v102.Id)

					return
				end

				openShop:Fire(v102.Id)
				shopOpenAnalytics:FireServer("PackPodium")
				currencyBuyRequest:FireServer(v102.BuyProductId)

				return
			end
		end)
	end

	local prompt = t6.prompt
	local packDef = t6.packDef

	if not prompt then
		return t6
	end

	if not packDef then
		return t6
	end

	clone = t3[packDef.Id]

	if clone then
		local v126 = utf8.char(57346)
		local v127 = commaFormat(clone)

		prompt.ObjectText = v126 .. " " .. v127

		return t6
	end

	prompt.ObjectText = packDef.DisplayName

	return t6
end

local n1 = os.clock() + 30

local function anyPodiumPresent()
	local t7: {[any]: any} = { workspace }
	local lobby: Instance = workspace:FindFirstChild("Lobby")

	if lobby then
		table.insert(t7, lobby)
	end

	for _, v in ipairs(t7) do
		for iterKey in pairs(t1) do
			if v:FindFirstChild(iterKey) then
				return true
			end
		end
	end

	return false
end

while true do
	if not not anyPodiumPresent() or not (n1 > os.clock()) then
		break
	end

	task.wait(0.25)
end

task.wait(0.5)
anyPodiumPresent = { workspace }
local lobby: Instance = workspace:FindFirstChild("Lobby")

if lobby then
	table.insert(anyPodiumPresent, lobby)
end

for _, v in ipairs(anyPodiumPresent) do
	for _, iterValue in ipairs(v:GetChildren()) do
		if t1[iterValue.Name] and iterValue:IsA("Model") then
			local v41 = initPodium(iterValue)

			if v41 then
				table.insert(t2, v41)
			end
		end
	end
end

anyPodiumPresent = { workspace }
local lobby2: Instance = workspace:FindFirstChild("Lobby")

if lobby2 then
	table.insert(anyPodiumPresent, lobby2)
end

for _, v in ipairs(anyPodiumPresent) do
	v.ChildAdded:Connect(function(p18)
		local v134 = t1[p18.Name] and p18:IsA("Model") and initPodium(p18)

		if v134 then
			table.insert(t2, v134)
			task.spawn(function()
				if v134.noob then
					applyAvatarAppearance(v134.noob, LocalPlayer.UserId)

					if v134.hrp then
						v134.hrp.Anchored = true
					end

					applyWeaponSkins(v134.noob, v134.knifeSkin, v134.revolverSkin)
					playIdleAnimation(v134.noob)
				end

				updatePromptVisibility(v134)
			end)
		end
	end)
end

if #t2 == 0 then
	warn("[PackPodiumController] No podium models found in Workspace or Workspace.Lobby (PackPodium / MegalodonPodium / MermaidPodium / Premium1Podium / Premium2Podium)")

	return
end

local function applyPackState(p19)
	if typeof(p19) == "table" then
		if typeof(p19.RobuxPrices) == "table" then
			for k, v in pairs(p19.RobuxPrices) do
				if typeof(k) == "string" and typeof(v) == "number" and v > 0 then
					t3[k] = v
				end
			end
		end

		local v138 = if typeof(p19.OwnedPacks) == "table" then p19.OwnedPacks else nil

		for _, v in ipairs(t2) do
			if v.packDef then
				if v138 then
					local v141 = v138[v.packDef.Id]

					v.purchaseCount = if typeof(v141) == "number" then v141 else if v141 == true then 1 else 0
				end

				local vPrompt = v.prompt
				local vPackDef = v.packDef

				if vPrompt and vPackDef then
					local v144 = t3[vPackDef.Id]

					if v144 then
						local v145 = utf8.char(57346)
						local v146 = commaFormat(v144)

						vPrompt.ObjectText = v145 .. " " .. v146
					else
						vPrompt.ObjectText = vPackDef.DisplayName
					end
				end

				updatePromptVisibility(v)
			end
		end

		return
	end
end

packPush.OnClientEvent:Connect(applyPackState)

local t4: {[any]: any} = {}

for _, v in ipairs(t2) do
	if v.packDef then
		local v49 = v.packDef.Id

		if not t4[v49] then
			t4[v49] = true
			LocalPlayer:GetAttributeChangedSignal("OwnsPack_" .. v49):Connect(function()
				for _, iterValue in ipairs(t2) do
					if iterValue.packDef and iterValue.packDef.Id == v49 then
						updatePromptVisibility(iterValue)
					end
				end
			end)
		end
	end
end

task.spawn(function()
	for _, v in ipairs(t2) do
		if v.noob then
			applyAvatarAppearance(v.noob, LocalPlayer.UserId)

			if v.hrp then
				v.hrp.Anchored = true
			end

			applyWeaponSkins(v.noob, v.knifeSkin, v.revolverSkin)
			playIdleAnimation(v.noob)
		end
	end

	local ok, result = pcall(function()
		return packRequest:InvokeServer("GetState")
	end)

	if ok and typeof(result) == "table" then
		applyPackState(result)

		return
	end

	for _, v in ipairs(t2) do
		updatePromptVisibility(v)
	end
end)
task.spawn(function()
	while true do
		for _, v in ipairs(t2) do
			if v.timeLeftLabel and v.packDef then
				local v157 = packCatalog.GetTimeRemaining(v.packDef)

				v.timeLeftLabel.Text = formatPackTimer(v157)

				if v157 <= 86400 and v157 > 0 then
					v.timeLeftLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
				elseif v157 <= 0 then
					v.timeLeftLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					updatePromptVisibility(v)
				else
					v.timeLeftLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
		end

		task.wait(1)
	end
end)
