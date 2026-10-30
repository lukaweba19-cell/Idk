-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

local function splitList(p1)
	local t2: {[any]: any} = {}

	if typeof(p1) == "string" then
		for iterValue in p1:gmatch("[^,%s]+") do
			table.insert(t2, iterValue)
		end

		return t2
	end

	return t2
end

local module: {[any]: any} = {
	ATTR_LIST = "HeldVariants",
	ATTR_MARKER = "HeldVariantMarker",
	ATTR_SWAP_ON = "HeldVariantSwapOn",
	ATTR_HIDE_ON = "HeldVariantHideOn",
	ATTR_CURRENT = "HeldVariant",
	RIG_NAMES = { "KnifeRig", "KnifeRig_L", "KnifeRig_R" }
}

function module.IsVariantRoot(p2)
	return p2 ~= nil and typeof(p2:GetAttribute(module.ATTR_LIST)) == "string"
end
function module.List(p3)
	return (splitList(p3:GetAttribute(module.ATTR_LIST)))
end
local function setShown(p4, p5)
	local transparency: number = if p5 then 0 else 1

	if p4:IsA("BasePart") then
		p4.Transparency = transparency
	end

	for _, v in ipairs(p4:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = transparency
		end
	end
end
function module.Show(p6, p7)
	for _, v in ipairs(module.List(p6)) do
		local v2 = p6:FindFirstChild(v)

		if v2 then
			setShown(v2, v == p7)
		end
	end
end
function module.Pick(p8, p9)
	local v25 = module.List(p8)

	if #v25 == 0 then
		return nil
	end

	local t3 = {}

	for _, v in ipairs(v25) do
		if v ~= p9 then
			table.insert(t3, v)
		end
	end

	if #t3 == 0 then
		t3 = v25
	end

	local randomNumber = math.random(1, #t3)

	return t3[randomNumber]
end
function module.Refill(p10)
	local attributeValue = p10:GetAttribute(module.ATTR_CURRENT)
	local pick = module.Pick
	local typeName: string = typeof(attributeValue)
	local v34 = pick(p10, if typeName == "string" then attributeValue else nil)

	if not v34 then
		return nil
	end

	local heldVariantEmpty = p10:GetAttribute("HeldVariantEmpty")

	p10:SetAttribute("HeldVariantRefilled", heldVariantEmpty == true)
	p10:SetAttribute("HeldVariantPrev", attributeValue)
	p10:SetAttribute(module.ATTR_CURRENT, v34)
	p10:SetAttribute("HeldVariantChangedAt", os.clock())
	p10:SetAttribute("HeldVariantEmpty", false)
	module.Show(p10, v34)

	return v34
end
function module.Empty(p11)
	local v37 = os.clock()

	p11:SetAttribute("HeldVariantEmpty", true)
	p11:SetAttribute("HeldVariantEmptyAt", v37)
	module.Show(p11, nil)
	task.delay(1.5, function()
		if p11.Parent and p11:GetAttribute("HeldVariantEmpty") == true and p11:GetAttribute("HeldVariantEmptyAt") == v37 then
			module.Refill(p11)
		end
	end)
end
function module.Thrown(p12)
	local attributeValue = p12:GetAttribute(module.ATTR_CURRENT)
	local heldVariantPrev = p12:GetAttribute("HeldVariantPrev")
	local heldVariantChangedAt = p12:GetAttribute("HeldVariantChangedAt")

	if p12:GetAttribute("HeldVariantEmpty") == true or p12:GetAttribute("HeldVariantRefilled") ~= true or typeof(heldVariantPrev) ~= "string" or typeof(heldVariantChangedAt) ~= "number" or not (os.clock() - heldVariantChangedAt < 0.4) then
		if typeof(attributeValue) == "string" then
			return attributeValue
		end

		return nil
	end

	return heldVariantPrev
end
function module.FindRoot(p13)
	if not p13 then
		return nil
	end

	for _, v in ipairs(module.RIG_NAMES) do
		local v = p13:FindFirstChild(v)
		local knifeRoot = v and v:FindFirstChild("KnifeRoot")

		if knifeRoot and knifeRoot:IsA("BasePart") and module.IsVariantRoot(knifeRoot) then
			return knifeRoot
		end
	end

	return nil
end

local u5 = nil

function module.FindRootForUser(p14)
	local LocalPlayer: Player = players.LocalPlayer
	local v49 = LocalPlayer and p14 == LocalPlayer.UserId and u5 and u5.Parent and LocalPlayer:GetAttribute("InMatch") ~= true and module.FindRoot(u5)

	if v49 then
		return v49
	end

	if typeof(p14) == "number" then
		local player: Player = players:GetPlayerByUserId(p14)

		return player and module.FindRoot(player.Character) or nil
	end

	return nil
end
local function rootsOf(p15)
	local t4: {[any]: any} = {}

	for _, v in ipairs(module.RIG_NAMES) do
		local v = p15:FindFirstChild(v)
		local knifeRoot = v and v:FindFirstChild("KnifeRoot")

		if knifeRoot and knifeRoot:IsA("BasePart") and module.IsVariantRoot(knifeRoot) then
			table.insert(t4, knifeRoot)
		end
	end

	return t4
end
local function initRig(p16)
	local knifeRoot = p16:FindFirstChild("KnifeRoot")

	if knifeRoot and module.IsVariantRoot(knifeRoot) and knifeRoot:GetAttribute(module.ATTR_CURRENT) == nil then
		module.Refill(knifeRoot)
	end
end
function module.Watch(character, p18)
	local t5: {[any]: any} = {}

	if p18 then
		u5 = character
	end

	for _, v in ipairs(character:GetChildren()) do
		if table.find(module.RIG_NAMES, v.Name) then
			local knifeRoot = v:FindFirstChild("KnifeRoot")

			if knifeRoot and module.IsVariantRoot(knifeRoot) and knifeRoot:GetAttribute(module.ATTR_CURRENT) == nil then
				module.Refill(knifeRoot)
			end
		end
	end

	table.insert(t5, character.ChildAdded:Connect(function(p19)
		if table.find(module.RIG_NAMES, p19.Name) then
			task.defer(initRig, p19)
		end
	end))

	local function onTrack(p20)
		local v72 = rootsOf(character)

		if #v72 == 0 then
			return
		end

		local animation = p20.Animation
		local v74 = animation and animation.AnimationId:match("%d+")

		if not v74 then
			return
		end

		for _, v in ipairs(v72) do
			local tableFind = table.find
			local v78 = splitList(v:GetAttribute(module.ATTR_HIDE_ON))

			if tableFind(v78, v74) then
				module.Empty(v)
			end

			local attributeValue = v:GetAttribute(module.ATTR_MARKER)

			if typeof(attributeValue) == "string" and table.find(splitList(v:GetAttribute(module.ATTR_SWAP_ON)), v74) then
				local connection = p20:GetMarkerReachedSignal(attributeValue):Connect(function()
					if v.Parent then
						module.Refill(v)
					end
				end)

				p20.Ended:Once(function()
					connection:Disconnect()
				end)

				local taskDelay = task.delay
				local v82 = math.max(p20.Length, 1)

				taskDelay(v82 + 3, function()
					connection:Disconnect()
				end)
			end
		end
	end
	local function bindAnimator(p21)
		if p21:IsA("Animator") then
			table.insert(t5, p21.AnimationPlayed:Connect(onTrack))
		end
	end
	local function bindHumanoid(p22)
		local animator = p22:FindFirstChildOfClass("Animator")

		if not animator then
			local connection = nil

			connection = p22.ChildAdded:Connect(function(p23)
				if p23:IsA("Animator") then
					connection:Disconnect()

					if p23:IsA("Animator") then
						table.insert(t5, p23.AnimationPlayed:Connect(onTrack))
					end
				end
			end)
			table.insert(t5, connection)
		elseif animator:IsA("Animator") then
			table.insert(t5, animator.AnimationPlayed:Connect(onTrack))

			return
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		bindHumanoid(humanoid)
	else
		local connection = nil

		connection = character.ChildAdded:Connect(function(p24)
			if p24:IsA("Humanoid") then
				connection:Disconnect()
				bindHumanoid(p24)
			end
		end)
		table.insert(t5, connection)
	end

	return function()
		for _, v in ipairs(t5) do
			v:Disconnect()
		end

		table.clear(t5)

		if u5 == character then
			u5 = nil
		end
	end
end

return module
