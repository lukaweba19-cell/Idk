-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local LocalPlayer: Player = players.LocalPlayer
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(replicatedStorageExtensions:WaitForChild("InputCategorizer"))
local v12: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(v12:WaitForChild("InputMap"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local stunModule = require(shared:WaitForChild("StunModule"))
local util: Instance = replicatedStorage:WaitForChild("Util")

require(util:WaitForChild("Maid"))

local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(replicatedStorageShared:WaitForChild("ViewedPlayer"))
local userInputService: UserInputService = game:GetService("UserInputService")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local replicatedStorageBindables: Instance = replicatedStorage:WaitForChild("Bindables")
local abilities_Request: Instance = remotes:WaitForChild("Abilities_Request")
local abilities_Push: Instance = remotes:WaitForChild("Abilities_Push")
local t1: {[any]: any} = { ["1"] = "Ability1", ["2"] = "Ability2" }
local t2: {[any]: any} = { Ability1 = "1", Ability2 = "2" }
local t3: {[any]: any} = { Knife = "Knife", Revolver = "Gun" }
local t4: {[any]: any} = { Knife = "Knife", Gun = "Revolver" }
local u28 = nil
local u29 = nil
local v30 = UDim2.fromScale(0, -0.1)
local t5: {[any]: any} = { "Knife", "Gun" }
local t6: {[any]: any} = { "Ability1", "Ability2" }
local t7: {[any]: any} = {
	Ability1 = "CastAbility1",
	Ability2 = "CastAbility2",
	Knife = "EquipKnife",
	Gun = "EquipRevolver"
}
local t8: {[any]: any} = {}
local scriptParent: Instance = script.Parent
local scriptParentParent: Instance = scriptParent.Parent
local killedBy: Instance = scriptParentParent:WaitForChild("KilledBy")
local t9: {[any]: any} = {}
local t10: {[any]: any} = {}

local function viewedWeaponAttr(p1)
	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter

	if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
		local attributeValue = viewedPlayerOverrideCharacter:GetAttribute(p1)

		if attributeValue == nil then
			return nil
		end

		return attributeValue
	end

	return viewedPlayer.Player:GetAttribute(p1)
end
local function buildWeaponSlot(p2)
	local s1: string = if (t4[p2] or p2) == "Knife" then "KnifeRarity" else "RevolverRarity"
	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter
	local attributeValue

	if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
		local attributeValue2 = viewedPlayerOverrideCharacter:GetAttribute(s1)

		attributeValue = if attributeValue2 == nil then nil else attributeValue2
	else
		attributeValue = viewedPlayer.Player:GetAttribute(s1)
	end

	if typeof(attributeValue) ~= "string" or attributeValue == "" then
		attributeValue = "Common"
	end

	local uiFrameworkCreateItemCell = uiFramework.createItemCell
	local v113 = t7[p2]
	local foundChild: Instance = scriptParent:FindFirstChild(p2)
	local v115, v116 = uiFrameworkCreateItemCell(attributeValue, { keybindAction = v113, replaces = foundChild, selectedOffset = v30 })
	local icon = v115:FindFirstChild("Icon")

	if icon then
		icon.Name = "WeaponIcon"
	end

	t9[p2] = v115
	t10[p2] = v116
end
local function getAbilityType(p3)
	local v119 = p3 and abilityCatalog.Get(p3)

	if v119 then
		return v119.Type
	end

	return nil
end
local function buildAbilitySlot(p4, p5)
	local foundChild: Instance = scriptParent:FindFirstChild(p4)

	if not foundChild then
		return
	end

	local v123 = p5 and abilityCatalog.Get(p5)
	local v124 = if v123 then v123.Type else nil

	v123 = nil

	local v125 = p5 and abilityCatalog.Get(p5)

	if v125 then
		v123 = v125.Icon
	end

	local v126, v127 = uiFramework.createAbilityCell(v124, {
		hasCooldown = true,
		keybindAction = t7[p4],
		replaces = foundChild,
		icon = v123
	})

	t9[p4] = v126
	t10[p4] = v127
end

local t11: {[any]: any} = {}

local function hookSlotClick(p6)
	local v129 = t9[p6]

	if not v129 then
		return
	end

	v129.InputBegan:Connect(function(input)
		local v385 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[p6]

		if v385 then
			v385()
		end
	end)
end

buildWeaponSlot("Knife")
buildWeaponSlot("Gun")

local ability1: Instance = scriptParent:FindFirstChild("Ability1")

if ability1 then
	local v47, v48 = uiFramework.createAbilityCell(nil, {
		hasCooldown = true,
		keybindAction = t7.Ability1,
		replaces = ability1,
		icon = nil
	})

	t9.Ability1 = v47
	t10.Ability1 = v48
end

local ability2: Instance = scriptParent:FindFirstChild("Ability2")

if ability2 then
	local v50, v51 = uiFramework.createAbilityCell(nil, {
		hasCooldown = true,
		keybindAction = t7.Ability2,
		replaces = ability2,
		icon = nil
	})

	t9.Ability2 = v50
	t10.Ability2 = v51
end

buildAbilitySlot = function()
	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		if typeof(spectating) == "number" and spectating ~= 0 then
			return true
		end

		return false
	end

	return true
end

local function isSpectating()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local u132: boolean = false

	if typeof(spectating) == "number" then
		u132 = spectating ~= 0
	end

	return u132
end
local function setSlotInteractivity(p8)
	for _, v in ipairs({ "Ability1", "Ability2", "Knife", "Gun" }) do
		local v136 = t9[v]

		if v136 then
			v136.Active = p8
			v136.Interactable = p8
		end
	end
end
local function refreshAbilitiesVisible()
	local u137

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u137 = typeof(spectating) == "number" and spectating ~= 0
	else
		u137 = true
	end

	scriptParent.Visible = u137 and not killedBy.Visible

	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local u140: boolean = false

	if typeof(spectating) == "number" then
		u140 = spectating ~= 0
	end

	setSlotInteractivity(not u140)
end

killedBy:GetPropertyChangedSignal("Visible"):Connect(refreshAbilitiesVisible)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refreshAbilitiesVisible)
LocalPlayer:GetAttributeChangedSignal("BackpackEnabled"):Connect(refreshAbilitiesVisible)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refreshAbilitiesVisible)

local u55

if LocalPlayer:GetAttribute("MatchId") == nil then
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	u55 = typeof(spectating) == "number" and spectating ~= 0
else
	u55 = true
end

scriptParent.Visible = u55 and not killedBy.Visible

local spectating: any = LocalPlayer:GetAttribute("Spectating")
local u58: boolean = false

if typeof(spectating) == "number" then
	u58 = spectating ~= 0
end

setSlotInteractivity(not u58)

local abilities: Instance = replicatedStorage:WaitForChild("Abilities")
local t12: {[any]: any} = {}

local function getClientModule(p9)
	if not abilityCatalog.Get(p9) then
		return nil
	end

	local v142 = t12[p9]

	if v142 == nil then
		local foundChild: Instance = abilities:FindFirstChild(p9 .. "Client")

		if not foundChild or not foundChild:IsA("ModuleScript") then
			t12[p9] = false

			return nil
		end

		local ok, result = pcall(require, foundChild)

		if not ok then
			warn("Client ability require failed:", p9, result)
			t12[p9] = false

			return nil
		end

		t12[p9] = result

		return result
	end

	return v142 ~= false and v142 or nil
end
local function runClientCast(p10, _)
	local v148 = getClientModule(p10)

	if not v148 then
		return
	end

	if typeof(v148) == "table" and typeof(v148.Cast) == "function" then
		local ok, result = pcall(v148.Cast, LocalPlayer)

		if not ok then
			warn("Client Cast error:", p10, result)

			return nil
		end

		return result
	end

	return nil
end

local u63 = nil

local function rebuildAbilitySlot(p12, p13)
	local v153 = t9[p12]

	if not v153 then
		return
	end

	local v154 = p13 and abilityCatalog.Get(p13)
	local v155 = if v154 then v154.Type else nil

	v154 = nil

	local v156 = p13 and abilityCatalog.Get(p13)

	if v156 then
		v154 = v156.Icon
	end

	local v157, v158 = uiFramework.createAbilityCell(v155, {
		hasCooldown = true,
		keybindAction = t7[p12],
		replaces = v153,
		icon = v154
	})

	t9[p12] = v157
	t10[p12] = v158

	local v159 = t9[p12]

	if v159 then
		v159.InputBegan:Connect(function(input)
			local v387 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[p12]

			if v387 then
				v387()
			end
		end)
	end

	local spectating2: any = LocalPlayer:GetAttribute("Spectating")

	v155 = false

	if typeof(spectating2) == "number" then
		v155 = spectating2 ~= 0
	end

	v157.Active = not v155
	v157.Interactable = not v155
	v155 = not v154 and v157:FindFirstChild("AbilityIcon")

	if v155 then
		v155.Image = ""
		v155.ImageTransparency = 1
	end

	if u28 then
		u28(p12)
	end
end
local function applyAbilitySlot(p15, p16)
	local v163 = t1[p15]

	if not v163 then
		return
	end

	rebuildAbilitySlot(v163, p16)
end
local function applySnapshot(p17)
	local cooldownEndsAt: {[any]: any} = { ["1"] = 0, ["2"] = 0 }
	local cooldownRemaining = p17.CooldownRemaining

	if cooldownRemaining then
		for _, v in ipairs({ "1", "2" }) do
			local v169 = cooldownRemaining[v]

			if typeof(v169) == "number" and v169 > 0 then
				cooldownEndsAt[v] = os.clock() + v169
			end
		end
	end

	local pendingSlots = p17.PendingSlots

	if pendingSlots then
		for _, v in ipairs({ "1", "2" }) do
			if pendingSlots[v] then
				cooldownEndsAt[v] = math.huge
			end
		end
	end

	p17.CooldownRemaining = nil
	p17.CooldownEndsAt = cooldownEndsAt
	u63 = p17

	local v173 = t1["1"]

	if v173 then
		rebuildAbilitySlot(v173, p17.Equipped["1"])
	end

	v173 = t1["2"]

	if v173 then
		rebuildAbilitySlot(v173, p17.Equipped["2"])
	end

	for _, v in ipairs({ "1", "2" }) do
		local v176 = t1[v]

		if v176 then
			if pendingSlots and pendingSlots[v] then
				local v177 = t10[v176]

				if v177 then
					v177:playPending()
				end

				publishCooldownState(v, math.huge)
			else
				local v178 = cooldownEndsAt[v]
				local v179 = os.clock()

				if v178 > v179 then
					local v180 = t10[v176]

					if v180 then
						local v181 = os.clock()

						v180:playCooldown(v178 - v181)
					end

					local v182 = os.clock()

					publishCooldownState(v, v178 - v182)
				else
					local v183 = t10[v176]

					if v183 then
						v183:clearCooldown()
					end

					publishCooldownState(v, 0)
				end
			end
		end
	end

	publishAbilityInfo()
end
local function isOnCooldown(p18)
	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if humanoid and not (humanoid.Health <= 0) and humanoid.WalkSpeed ~= 0 then
		if stunModule.IsStunned(Character) then
			return true
		end

		if not humanoid:IsDescendantOf(workspace) then
			warn("nice bug buddy, nice try")

			return true
		end

		if not u63 then
			return false
		end

		local v187 = u63.CooldownEndsAt[p18]
		local u188: boolean = false

		if typeof(v187) == "number" then
			local v189 = os.clock()

			u188 = v187 > v189
		end

		return u188
	end

	return true
end
local function canUseInputs()
	if workspace:GetAttribute("LoadingScreenCompleted") == true then
		local u190

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating3: any = LocalPlayer:GetAttribute("Spectating")

			u190 = typeof(spectating3) == "number" and spectating3 ~= 0
		else
			u190 = true
		end

		if not u190 then
		elseif LocalPlayer:GetAttribute("InMatch") == true then
			if LocalPlayer:GetAttribute("BackpackEnabled") == true then
				if LocalPlayer:GetAttribute("Spectating") then
					return false
				end

				return true
			end

			return false
		end

		return false
	end

	return false
end

local u69 = nil

local function invokeTryCast(p19, p20)
	local u194 = nil
	local u195: boolean = false

	task.spawn(function()
		local ok, result = pcall(function()
			return abilities_Request:InvokeServer("TryCast", { slot = p19, clientInfo = p20 })
		end)

		if ok then
			u194 = result
		end

		u195 = true
	end)

	local n1 = os.clock() + 5

	while not u195 and n1 > os.clock() do
		task.wait()
	end

	if not u195 then
		warn("[Abilities] TryCast InvokeServer timed out for slot", p19, "-- likely mobile app backgrounded during in-flight call")
	end

	return u194
end
local function tryRecast(p21, p22, p23)
	local function deny()
		local v390 = t10[p23]

		if v390 then
			v390:fxDeny()
		end
	end

	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not humanoid or humanoid.Health <= 0 or humanoid.WalkSpeed == 0 or not humanoid:IsDescendantOf(workspace) then
		local v203 = t10[p23]

		if v203 then
			v203:fxDeny()
		end

		return
	end

	if stunModule.IsStunned(Character) then
		local v204 = t10[p23]

		if v204 then
			v204:fxDeny()
		end

		return
	end

	local v205 = getClientModule(p22)

	if v205 and typeof(v205) == "table" and typeof(v205.Recast) == "function" then
		local ok, result = pcall(v205.Recast, LocalPlayer)

		if not ok then
			warn("Client Recast error:", p22, result)

			local v208 = t10[p23]

			if v208 then
				v208:fxDeny()
			end

			return
		end

		if result == nil or result == -1 then
			local v209 = t10[p23]

			if v209 then
				v209:fxDeny()
			end

			return
		end

		local v210 = t10[p23]

		if v210 then
			v210:fxCastPop()
		end

		v210 = invokeTryCast(p21, { result })

		if typeof(v210) == "table" and v210.ok == true and typeof(v210.cooldownDuration) == "number" then
			local cooldownDuration = v210.cooldownDuration

			if u63 then
				u63.CooldownEndsAt[p21] = os.clock() + cooldownDuration
			end

			local v212 = t10[p23]

			if v212 then
				v212:playCooldown(cooldownDuration)
			end

			publishCooldownState(p21, cooldownDuration)

			return
		end

		local v213 = t10[p23]

		if v213 then
			v213:fxDeny()
		end

		return
	end

	local v214 = t10[p23]

	if v214 then
		v214:fxDeny()
	end
end
local function tryCast(p24)
	if u69 and coroutine.status(u69) ~= "dead" then
		return
	end

	u69 = coroutine.create(function()
		if not u63 then
			return
		end

		local v391 = u63.Equipped[p24]

		if not v391 then
			return
		end

		if not canUseInputs() then
			return
		end

		local v392 = t1[p24]

		if not v392 then
			return
		end

		if abilityCatalog.Get(v391) and abilityCatalog.Get(v391).Recastable == true and u63.CooldownEndsAt[p24] == math.huge then
			tryRecast(p24, v391, v392)

			return
		end

		if isOnCooldown(p24) then
			local v393 = t10[v392]

			if v393 then
				v393:fxDeny()
			end

			return
		end

		local v394 = abilityCatalog.Get(v391)
		local v395 = v394 and v394.IsPending == true
		v394 = { runClientCast(v391, p24) }

		if v394[1] == -1 then
			local v396 = t10[v392]

			if v396 then
				v396:fxDeny()
			end

			return
		end

		local v397 = t10[v392]

		if v397 then
			v397:fxCastPop()
		end

		u63.CooldownEndsAt[p24] = os.clock() + math.huge

		if v395 then
			local v398 = t10[v392]

			if v398 then
				v398:playPending()
			end
		else
			local v399 = t10[v392]

			if v399 then
				v399:playCooldown(math.huge)
			end
		end

		publishCooldownState(p24, math.huge)

		local v400 = invokeTryCast(p24, v394)

		if v395 and typeof(v400) == "table" and v400.ok == true and v400.isPending == true then
			return
		end

		u63.CooldownEndsAt[p24] = os.clock() + 0
		v395 = t10[v392]

		if v395 then
			v395:playCooldown(0)
		end

		publishCooldownState(p24, 0)

		if typeof(v400) == "table" and v400.ok == true then
			local cooldownDuration = v400.cooldownDuration

			u63.CooldownEndsAt[p24] = os.clock() + cooldownDuration

			local v402 = t10[v392]

			if v402 then
				v402:playCooldown(cooldownDuration)
			end

			publishCooldownState(p24, cooldownDuration)

			return
		end

		v394 = t10[v392]

		if v394 then
			v394:fxDeny()
		end

		u63.CooldownEndsAt[p24] = os.clock() + 1

		local v403 = t10[v392]

		if v403 then
			v403:playCooldown(1)
		end

		publishCooldownState(p24, 1)
	end)
	task.spawn(u69)

	while true do
		if coroutine.status(u69) == "dead" then
			break
		end

		task.wait()
	end

	u69 = nil
end
local function findToolByName(p25, p26)
	for _, v in ipairs(p25:GetChildren()) do
		if v:IsA("Tool") and p26 == v.Name then
			return v
		end
	end

	return nil
end
local function getEquippedToolName(p27)
	for _, v in ipairs(p27:GetChildren()) do
		if v:IsA("Tool") then
			return v.Name
		end
	end

	return nil
end

local u75 = nil

local function setSelectedWeaponSlot(p28)
	for _, v in ipairs(t5) do
		local v226 = t10[v]

		if v226 then
			v226:setSelected(v == p28)
		end

		if u29 then
			u29(v, v == p28)
		end
	end

	u75 = p28
end
local function equipWeapon(p29)
	if not canUseInputs() then
		return
	end

	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local v229 = t3[p29]
	local v230 = getEquippedToolName(Character)

	if p29 == v230 then
		setSelectedWeaponSlot(v229)

		return
	end

	local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	local backpack: Instance = LocalPlayer:FindFirstChildOfClass("Backpack")

	if not backpack then
		return
	end

	local v233 = findToolByName(backpack, p29) or findToolByName(Character, p29)

	if not v233 then
		local v234 = t10[v229 or ""]

		if v234 then
			v234:fxDeny()
		end

		return
	end

	if not humanoid:IsDescendantOf(workspace) then
		warn("nice bug buddy, nice try")

		return
	end

	humanoid:EquipTool(v233)
	setSelectedWeaponSlot(v229)
end
local function syncSelectedFromCharacter(p30)
	if p30:GetAttribute("ReplayActor") == true then
		if p30:GetAttribute("EnableRevolverRig") == true then
			setSelectedWeaponSlot("Gun")

			return
		end

		if p30:GetAttribute("EnableKnifeRig") == true then
			setSelectedWeaponSlot("Knife")
		end

		return
	end

	local v236 = getEquippedToolName(p30)
	local v237 = v236 and t3[v236]

	if v237 then
		setSelectedWeaponSlot(v237)
	end
end
local function hookCharacter(p31)
	syncSelectedFromCharacter(p31)
	p31.ChildAdded:Connect(function(p32)
		if p32:IsA("Tool") then
			syncSelectedFromCharacter(p31)
		end
	end)
	p31.ChildRemoved:Connect(function(p33)
		if p33:IsA("Tool") then
			task.defer(function()
				syncSelectedFromCharacter(p31)
			end)
		end
	end)
end

if LocalPlayer.Character then
	hookCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(hookCharacter)
inputMap.bind("CastAbility1", function(p34)
	if p34 == Enum.UserInputState.Begin then
		tryCast("1")
	end

	return Enum.ContextActionResult.Pass
end)
inputMap.bind("CastAbility2", function(p35)
	if p35 == Enum.UserInputState.Begin then
		tryCast("2")
	end

	return Enum.ContextActionResult.Pass
end)
inputMap.bind("EquipKnife", function(p36)
	if p36 == Enum.UserInputState.Begin then
		equipWeapon("Knife")
	end

	return Enum.ContextActionResult.Pass
end)
inputMap.bind("EquipRevolver", function(p37)
	if p37 == Enum.UserInputState.Begin then
		equipWeapon("Revolver")
	end

	return Enum.ContextActionResult.Pass
end)
contextActionService:BindAction("Gamepad_Cast1", function(_, p39)
	if p39 == Enum.UserInputState.Begin then
		tryCast("1")
	end

	return Enum.ContextActionResult.Pass
end, false, gamepadBindings.CastAbility1)
contextActionService:BindAction("Gamepad_Cast2", function(_, p41)
	if p41 == Enum.UserInputState.Begin then
		tryCast("2")
	end

	return Enum.ContextActionResult.Pass
end, false, gamepadBindings.CastAbility2)
contextActionService:BindAction("Gamepad_SwapWeapon", function(_, p43)
	if p43 == Enum.UserInputState.Begin then
		if not canUseInputs() then
			return Enum.ContextActionResult.Pass
		end

		local Character: Model = LocalPlayer.Character

		if not Character then
			return Enum.ContextActionResult.Pass
		end

		if getEquippedToolName(Character) == "Knife" then
			equipWeapon("Revolver")
		else
			equipWeapon("Knife")
		end

		return Enum.ContextActionResult.Pass
	end

	return Enum.ContextActionResult.Pass
end, false, gamepadBindings.SwapWeapon)

local u80: boolean = false

hookCharacter = function()
	return LocalPlayer:GetAttribute("ScoreboardFocused") == true
end
contextActionService:BindActionAtPriority("Gamepad_EquipKnife", function(_, p45, input)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
		return Enum.ContextActionResult.Pass
	end

	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		return Enum.ContextActionResult.Pass
	end

	if p45 == Enum.UserInputState.Begin then
		equipWeapon("Knife")
	end

	return Enum.ContextActionResult.Sink
end, false, 3000, gamepadBindings.EquipKnife)
contextActionService:BindActionAtPriority("Gamepad_EquipRevolver", function(_, p48, input)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
		return Enum.ContextActionResult.Pass
	end

	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		return Enum.ContextActionResult.Pass
	end

	if p48 == Enum.UserInputState.Begin then
		equipWeapon("Revolver")
	end

	return Enum.ContextActionResult.Sink
end, false, 3000, gamepadBindings.EquipRevolver)
contextActionService:BindActionAtPriority("Gamepad_Scoreboard", function(_, p51, input)
	if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
		return Enum.ContextActionResult.Pass
	end

	if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
		return Enum.ContextActionResult.Pass
	end

	local toggleMatchLeaderboard: Instance = replicatedStorage:WaitForChild("Bindables"):FindFirstChild("ToggleMatchLeaderboard")

	if p51 ~= Enum.UserInputState.Begin then
		if (p51 == Enum.UserInputState.End or p51 == Enum.UserInputState.Cancel) and u80 then
			u80 = false

			if toggleMatchLeaderboard then
				toggleMatchLeaderboard:Fire(false)
			end

			local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

			LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) - 1)
		end
	elseif not u80 then
		u80 = true

		if toggleMatchLeaderboard then
			toggleMatchLeaderboard:Fire(true)
		end

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	end

	return Enum.ContextActionResult.Sink
end, false, 3000, gamepadBindings.Scoreboard)
contextActionService:BindActionAtPriority("Gamepad_Inspect", function(_, p54, input)
	if input.UserInputType == Enum.UserInputType.Gamepad1 or input.UserInputType == Enum.UserInputType.Gamepad2 or input.UserInputType == Enum.UserInputType.Gamepad3 or input.UserInputType == Enum.UserInputType.Gamepad4 then
		if LocalPlayer:GetAttribute("ScoreboardFocused") == true then
			return Enum.ContextActionResult.Pass
		end

		if p54 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		if scriptParentParent.ChangeAbilities.Visible then
			LocalPlayer:SetAttribute("GamepadOpenAbilities", tick())

			return Enum.ContextActionResult.Sink
		end

		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
			LocalPlayer:SetAttribute("GamepadInspect", tick())

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end

	return Enum.ContextActionResult.Pass
end, false, 3000, gamepadBindings.Inspect)

function t11.Ability1()
	tryCast("1")
end
function t11.Ability2()
	tryCast("2")
end
function t11.Knife()
	equipWeapon("Knife")
end
function t11.Gun()
	equipWeapon("Revolver")
end

local castAbility1: Instance = replicatedStorageBindables:WaitForChild("CastAbility1")
local castAbility2: Instance = replicatedStorageBindables:WaitForChild("CastAbility2")

castAbility1.Event:Connect(function()
	tryCast("1")
end)
castAbility2.Event:Connect(function()
	tryCast("2")
end)

function publishAbilityInfo()
	if not u63 then
		LocalPlayer:SetAttribute("Ability1Icon", "")
		LocalPlayer:SetAttribute("Ability2Icon", "")
		LocalPlayer:SetAttribute("Ability1Id", "")
		LocalPlayer:SetAttribute("Ability2Id", "")

		return
	end

	for _, v in ipairs({ "1", "2" }) do
		local v267 = u63.Equipped[v]
		local s1 = ""

		if v267 then
			local v269 = abilityCatalog.Get(v267)

			if v269 then
				s1 = v269.Icon
			end
		end

		LocalPlayer:SetAttribute("Ability" .. v .. "Icon", s1)
		LocalPlayer:SetAttribute("Ability" .. v .. "Id", v267 or "")
	end
end
function publishCooldownState(p56, p57)
	local s1: string = "Ability" .. p56

	LocalPlayer:SetAttribute(s1 .. "CooldownDuration", p57)
	LocalPlayer:SetAttribute(s1 .. "CooldownStartedAt", os.clock())
end

local v83 = t9.Ability1

if v83 then
	local s1: string = "Ability1"

	v83.InputBegan:Connect(function(input)
		local v274 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[s1]

		if v274 then
			v274()
		end
	end)
end

local v85 = t9.Ability2

if v85 then
	local s2: string = "Ability2"

	v85.InputBegan:Connect(function(input)
		local v276 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[s2]

		if v276 then
			v276()
		end
	end)
end

local knife = t9.Knife

if knife then
	local s3: string = "Knife"

	knife.InputBegan:Connect(function(input)
		local v278 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[s3]

		if v278 then
			v278()
		end
	end)
end

local gun = t9.Gun

if gun then
	local s4: string = "Gun"

	gun.InputBegan:Connect(function(input)
		local v280 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[s4]

		if v280 then
			v280()
		end
	end)
end

local t13: {[any]: any} = {}
local t14: {[any]: any} = {
	Ability1 = gamepadBindings.CastAbility1,
	Ability2 = gamepadBindings.CastAbility2,
	Knife = gamepadBindings.EquipKnife,
	Gun = gamepadBindings.EquipRevolver
}

u28 = function(p62)
	local v282 = t9[p62]

	if not v282 then
		return
	end

	local keybind = v282:FindFirstChild("Keybind")

	if not keybind then
		return
	end

	local gamepadIcon = keybind:FindFirstChild("GamepadIcon")

	if gamepadIcon then
		gamepadIcon:Destroy()
	end

	local v285 = t14[p62]

	if not v285 then
		return
	end

	local gamepadIcon: ImageLabel = Instance.new("ImageLabel")

	gamepadIcon.Name = "GamepadIcon"
	gamepadIcon.Size = UDim2.fromScale(0.9, 0.9)
	gamepadIcon.Position = UDim2.fromScale(0.5, 0.5)
	gamepadIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	gamepadIcon.BackgroundTransparency = 1
	gamepadIcon.ScaleType = Enum.ScaleType.Fit
	gamepadIcon.ZIndex = keybind.ZIndex + 1
	gamepadIcon.ImageColor3 = Color3.new(1, 1, 1)

	local ok, result = pcall(function()
		return userInputService:GetImageForKeyCode(v285)
	end)

	if ok and result ~= "" then
		gamepadIcon.Image = result
	end

	gamepadIcon.Parent = keybind
	t13[p62] = gamepadIcon
	updateGamepadKeybindVisibility()
end

function updateGamepadKeybindVisibility()
	local v289 = inputCategorizer.getLastInputCategory()
	local visible: boolean = v289 == inputCategorizer.InputCategory.Gamepad
	local u291: boolean = v289 == inputCategorizer.InputCategory.Touch

	for k, v in pairs(t13) do
		v.Visible = visible

		local v294 = t9[k]

		if v294 then
			local keybind = v294:FindFirstChild("Keybind")

			if keybind then
				keybind.Visible = not u291

				local keyBind = keybind:FindFirstChild("KeyBind")

				if keyBind then
					keyBind.Visible = not visible and not u291
				end
			end
		end
	end
end

u29 = function(p63, p64)
	local v299 = t13[p63]

	if v299 then
		v299.ImageColor3 = if p64 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)
	end
end

for _, v in ipairs({ "Ability1", "Ability2", "Knife", "Gun" }) do
	u28(v)
end

inputCategorizer.lastInputCategoryChanged:Connect(function()
	updateGamepadKeybindVisibility()
end)

local function handleAbilityPush(p65, player)
	if p65 == "Snapshot" then
		local userId = player.UserId

		if typeof(userId) == "number" and not viewedPlayer.IsViewedUserId(userId) then
			return
		end

		applySnapshot(player)

		local u303

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating4: any = LocalPlayer:GetAttribute("Spectating")

			u303 = typeof(spectating4) == "number" and spectating4 ~= 0
		else
			u303 = true
		end

		scriptParent.Visible = u303 and not killedBy.Visible

		local spectating5: any = LocalPlayer:GetAttribute("Spectating")
		local u306: boolean = false

		if typeof(spectating5) == "number" then
			u306 = spectating5 ~= 0
		end

		setSlotInteractivity(not u306)
	elseif p65 == "Cooldown" then
		if u63 and player and (player.slot == "1" or player.slot == "2") then
			local slot = player.slot
			local v308 = t1[slot]

			if v308 and typeof(player.cooldownEndsAt) == "number" then
				local v309 = typeof(player.cooldownDuration) == "number" and player.cooldownDuration or 0

				u63.CooldownEndsAt[slot] = os.clock() + v309

				if v309 <= 0 then
					local v310 = t10[v308]

					if v310 then
						v310:clearCooldown()
					end

					local v311 = t10[v308]

					if v311 then
						v311:fxReady()
					end
				else
					local v312 = t10[v308]

					if v312 then
						v312:playCooldown(v309)
					end
				end

				publishCooldownState(slot, v309)
			end
		end
	elseif p65 == "Pending" then
		local playerSlot = player.slot
		local v314 = u63 and player and (player.slot == "1" or player.slot == "2") and t1[playerSlot]

		if v314 then
			u63.CooldownEndsAt[playerSlot] = math.huge

			local v315 = t10[v314]

			if v315 then
				v315:playPending()
			end

			publishCooldownState(playerSlot, math.huge)
		end

		return
	end
end

abilities_Push.OnClientEvent:Connect(handleAbilityPush)

local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
local replayAbilityPanel: Instance = bindables and bindables:FindFirstChild("ReplayAbilityPanel")

if replayAbilityPanel and replayAbilityPanel:IsA("BindableEvent") then
	replayAbilityPanel.Event:Connect(handleAbilityPush)
end

handleAbilityPush = abilities_Request:InvokeServer("GetSnapshot", nil)

if typeof(handleAbilityPush) == "table" then
	applySnapshot(handleAbilityPush)
end

handleAbilityPush = function(p67, p68)
	local v318 = t9[p67]

	if not v318 then
		return
	end

	local weaponIcon = v318:FindFirstChild("WeaponIcon")

	if not weaponIcon then
		return
	end

	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter
	local attributeValue

	if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
		local attributeValue2 = viewedPlayerOverrideCharacter:GetAttribute(p68)

		attributeValue = if attributeValue2 == nil then nil else attributeValue2
	else
		attributeValue = viewedPlayer.Player:GetAttribute(p68)
	end

	if typeof(attributeValue) == "string" and attributeValue ~= "" then
		weaponIcon.Image = attributeValue
		weaponIcon.ImageTransparency = 0

		return
	end

	weaponIcon.Image = ""
	weaponIcon.ImageTransparency = 1
end

local function refreshWeaponIcons()
	local knife = t9.Knife

	if knife then
		local weaponIcon = knife:FindFirstChild("WeaponIcon")

		if weaponIcon then
			local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter
			local knifeIcon

			if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
				local knifeIcon2 = viewedPlayerOverrideCharacter:GetAttribute("KnifeIcon")

				knifeIcon = if knifeIcon2 == nil then nil else knifeIcon2
			else
				knifeIcon = viewedPlayer.Player:GetAttribute("KnifeIcon")
			end

			if typeof(knifeIcon) == "string" and knifeIcon ~= "" then
				weaponIcon.Image = knifeIcon
				weaponIcon.ImageTransparency = 0
			else
				weaponIcon.Image = ""
				weaponIcon.ImageTransparency = 1
			end
		end
	end

	local gun = t9.Gun

	if not gun then
		return
	end

	local weaponIcon = gun:FindFirstChild("WeaponIcon")

	if not weaponIcon then
		return
	end

	local overrideCharacter = viewedPlayer.OverrideCharacter
	local revolverIcon

	if overrideCharacter and overrideCharacter.Parent then
		local revolverIcon2 = overrideCharacter:GetAttribute("RevolverIcon")

		revolverIcon = if revolverIcon2 == nil then nil else revolverIcon2
	else
		revolverIcon = viewedPlayer.Player:GetAttribute("RevolverIcon")
	end

	if typeof(revolverIcon) == "string" and revolverIcon ~= "" then
		weaponIcon.Image = revolverIcon
		weaponIcon.ImageTransparency = 0

		return
	end

	weaponIcon.Image = ""
	weaponIcon.ImageTransparency = 1
end
local function rebuildWeaponSlot(p69)
	local v334 = t9[p69]

	if not v334 then
		return
	end

	local s1 = if (t4[p69] or p69) == "Knife" then "KnifeRarity" else "RevolverRarity"
	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter
	local attributeValue

	if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
		local attributeValue2 = viewedPlayerOverrideCharacter:GetAttribute(s1)

		attributeValue = if attributeValue2 == nil then nil else attributeValue2
	else
		attributeValue = viewedPlayer.Player:GetAttribute(s1)
	end

	if typeof(attributeValue) ~= "string" or attributeValue == "" then
		attributeValue = "Common"
	end

	local v339, v340 = uiFramework.createItemCell(attributeValue, { keybindAction = t7[p69], replaces = v334, selectedOffset = v30 })
	local icon = v339:FindFirstChild("Icon")

	if icon then
		icon.Name = "WeaponIcon"
	end

	t9[p69] = v339
	t10[p69] = v340
	s1 = t9[p69]

	if s1 then
		s1.InputBegan:Connect(function(input)
			local v407 = (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and t11[p69]

			if v407 then
				v407()
			end
		end)
	end

	local spectating6: any = LocalPlayer:GetAttribute("Spectating")
	local u343: boolean = false

	if typeof(spectating6) == "number" then
		u343 = spectating6 ~= 0
	end

	v339.Active = not u343
	v339.Interactable = not u343

	local s2: string = if p69 == "Knife" then "KnifeIcon" else "RevolverIcon"
	local v345 = t9[p69]

	if v345 then
		local weaponIcon = v345:FindFirstChild("WeaponIcon")

		if weaponIcon then
			local overrideCharacter = viewedPlayer.OverrideCharacter
			local attributeValue

			if overrideCharacter and overrideCharacter.Parent then
				local attributeValue3 = overrideCharacter:GetAttribute(s2)

				attributeValue = if attributeValue3 == nil then nil else attributeValue3
			else
				attributeValue = viewedPlayer.Player:GetAttribute(s2)
			end

			if typeof(attributeValue) == "string" and attributeValue ~= "" then
				weaponIcon.Image = attributeValue
				weaponIcon.ImageTransparency = 0
			else
				weaponIcon.Image = ""
				weaponIcon.ImageTransparency = 1
			end
		end
	end

	if u28 then
		u28(p69)
	end

	if p69 == u75 then
		v340:setSelected(true)

		if u29 then
			u29(p69, true)
		end
	end
end
local function disconnectViewed()
	for _, v in ipairs(t8) do
		v:Disconnect()
	end

	t8 = {}
end
local function applyViewedTarget()
	local viewedPlayerPlayer = viewedPlayer.Player

	if viewedPlayer.OverrideCharacter == nil then
		local ability1Id = viewedPlayerPlayer:GetAttribute("Ability1Id")
		local ability2Id = viewedPlayerPlayer:GetAttribute("Ability2Id")
		local v355 = typeof(ability1Id) == "string" and ability1Id ~= "" and ability1Id or nil
		local v356 = typeof(ability2Id) == "string" and ability2Id ~= "" and ability2Id or nil
		local v357 = t1["1"]

		if v357 then
			rebuildAbilitySlot(v357, v355)
		end

		v357 = t1["2"]

		if v357 then
			rebuildAbilitySlot(v357, v356)
		end

		if viewedPlayer.IsSpectating() then
			for _, v in ipairs({ "1", "2" }) do
				local v360 = if v == "1" then v355 else v356
				local s1 = ""

				if v360 then
					local v362 = abilityCatalog.Get(v360)

					if v362 then
						s1 = v362.Icon
					end
				end

				LocalPlayer:SetAttribute("Ability" .. v .. "Icon", s1)
				LocalPlayer:SetAttribute("Ability" .. v .. "Id", v360 or "")
			end
		end
	end

	rebuildWeaponSlot("Knife")
	rebuildWeaponSlot("Gun")

	local knife = t9.Knife

	if knife then
		local weaponIcon = knife:FindFirstChild("WeaponIcon")

		if weaponIcon then
			local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter
			local knifeIcon

			if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
				local knifeIcon2 = viewedPlayerOverrideCharacter:GetAttribute("KnifeIcon")

				knifeIcon = if knifeIcon2 == nil then nil else knifeIcon2
			else
				knifeIcon = viewedPlayer.Player:GetAttribute("KnifeIcon")
			end

			if typeof(knifeIcon) == "string" and knifeIcon ~= "" then
				weaponIcon.Image = knifeIcon
				weaponIcon.ImageTransparency = 0
			else
				weaponIcon.Image = ""
				weaponIcon.ImageTransparency = 1
			end
		end
	end

	local gun = t9.Gun

	if gun then
		local weaponIcon = gun:FindFirstChild("WeaponIcon")

		if weaponIcon then
			local overrideCharacter = viewedPlayer.OverrideCharacter
			local revolverIcon

			if overrideCharacter and overrideCharacter.Parent then
				local revolverIcon2 = overrideCharacter:GetAttribute("RevolverIcon")

				revolverIcon = if revolverIcon2 == nil then nil else revolverIcon2
			else
				revolverIcon = viewedPlayer.Player:GetAttribute("RevolverIcon")
			end

			if typeof(revolverIcon) == "string" and revolverIcon ~= "" then
				weaponIcon.Image = revolverIcon
				weaponIcon.ImageTransparency = 0
			else
				weaponIcon.Image = ""
				weaponIcon.ImageTransparency = 1
			end
		end
	end

	local v373 = viewedPlayer.GetCharacter()

	if v373 then
		syncSelectedFromCharacter(v373)
	end
end
local function bindViewedAttributes()
	local viewedPlayerPlayer = viewedPlayer.Player
	local v375: {[any]: any} = t8
	local v376 = viewedPlayerPlayer:GetAttributeChangedSignal("KnifeRarity")

	table.insert(v375, v376:Connect(function()
		rebuildWeaponSlot("Knife")
	end))
	v375 = t8
	v376 = viewedPlayerPlayer:GetAttributeChangedSignal("RevolverRarity")
	table.insert(v375, v376:Connect(function()
		rebuildWeaponSlot("Gun")
	end))
	v375 = t8
	v376 = viewedPlayerPlayer:GetAttributeChangedSignal("KnifeIcon")
	table.insert(v375, v376:Connect(refreshWeaponIcons))
	v375 = t8
	v376 = viewedPlayerPlayer:GetAttributeChangedSignal("RevolverIcon")
	table.insert(v375, v376:Connect(refreshWeaponIcons))

	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter

	if viewedPlayerOverrideCharacter then
		local function syncOverride()
			if viewedPlayer.OverrideCharacter ~= viewedPlayerOverrideCharacter then
				return
			end

			syncSelectedFromCharacter(viewedPlayerOverrideCharacter)
		end

		local v379: {[any]: any} = t8
		local v380 = viewedPlayerOverrideCharacter:GetAttributeChangedSignal("EnableKnifeRig")

		table.insert(v379, v380:Connect(syncOverride))
		v379 = t8
		v380 = viewedPlayerOverrideCharacter:GetAttributeChangedSignal("EnableRevolverRig")
		table.insert(v379, v380:Connect(syncOverride))
	end

	if viewedPlayer.IsSpectating() then
		local v381: {[any]: any} = t8
		local v382 = viewedPlayerPlayer:GetAttributeChangedSignal("Ability1Id")

		table.insert(v381, v382:Connect(applyViewedTarget))
		v381 = t8
		v382 = viewedPlayerPlayer:GetAttributeChangedSignal("Ability2Id")
		table.insert(v381, v382:Connect(applyViewedTarget))

		local function hookViewedChar(p71)
			local v409 = getEquippedToolName(p71)
			local v410 = v409 and t3[v409]

			if v410 then
				setSelectedWeaponSlot(v410)
			end

			table.insert(t8, p71.ChildAdded:Connect(function(p72)
				if not p72:IsA("Tool") then
					return
				end

				task.defer(function()
					if viewedPlayer.Player ~= viewedPlayerPlayer then
						return
					end

					local v421 = t3[p72.Name]

					if v421 then
						setSelectedWeaponSlot(v421)
					end
				end)
			end))
			table.insert(t8, p71.ChildRemoved:Connect(function(p73)
				if not p73:IsA("Tool") then
					return
				end

				task.defer(function()
					if viewedPlayer.Player ~= viewedPlayerPlayer then
						return
					end

					local v422 = getEquippedToolName(p71)
					local v423 = v422 and t3[v422]

					if v423 then
						setSelectedWeaponSlot(v423)
					end
				end)
			end))
		end

		if viewedPlayerPlayer.Character then
			hookViewedChar(viewedPlayerPlayer.Character)
		end

		table.insert(t8, viewedPlayerPlayer.CharacterAdded:Connect(function(p74)
			if viewedPlayer.Player ~= viewedPlayerPlayer then
				return
			end

			hookViewedChar(p74)
			task.defer(function()
				if viewedPlayer.Player ~= viewedPlayerPlayer then
					return
				end

				applyViewedTarget()
			end)
		end))
	end
end
local function rebindViewed()
	disconnectViewed()
	bindViewedAttributes()
end

viewedPlayer.Changed:Connect(function()
	disconnectViewed()
	bindViewedAttributes()
	applyViewedTarget()

	if not viewedPlayer.IsSpectating() then
		task.spawn(function()
			local ok, result = pcall(function()
				return abilities_Request:InvokeServer("GetSnapshot", nil)
			end)

			if not ok then
			elseif viewedPlayer.IsSpectating() then
			elseif typeof(result) == "table" then
				local resultUserId = result.UserId

				if typeof(resultUserId) == "number" and resultUserId ~= LocalPlayer.UserId then
					return
				end

				applySnapshot(result)

				local u415

				if LocalPlayer:GetAttribute("MatchId") == nil then
					local spectating7: any = LocalPlayer:GetAttribute("Spectating")

					u415 = typeof(spectating7) == "number" and spectating7 ~= 0
				else
					u415 = true
				end

				scriptParent.Visible = u415 and not killedBy.Visible

				local spectating8: any = LocalPlayer:GetAttribute("Spectating")
				local u418: boolean = false

				if typeof(spectating8) == "number" then
					u418 = spectating8 ~= 0
				end

				setSlotInteractivity(not u418)

				return
			end
		end)
	end
end)
bindViewedAttributes()
applyViewedTarget()
