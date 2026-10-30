-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local scriptParent: Instance = script.Parent
local killCard: Instance = scriptParent:WaitForChild("KillCard")
local headshot: Instance = killCard:WaitForChild("Headshot")
local playerName: Instance = killCard:WaitForChild("PlayerName")
local displayName: Instance = killCard:WaitForChild("DisplayName")
local playerLevel: Instance = killCard:WaitForChild("PlayerLevel")
local weapon: Instance = killCard:WaitForChild("Weapon")
local v12: Instance = weapon:WaitForChild("Weapon")
local weaponName: Instance = v12:WaitForChild("WeaponName")
local pattern: Instance = weapon:WaitForChild("Pattern")
local patternImageColor3 = pattern.ImageColor3
local weaponBackgroundColor3 = weapon.BackgroundColor3

scriptParent.Visible = false

local function safeStr(p1)
	return typeof(p1) == "string" and p1 or ""
end
local function safeNum(p2)
	return typeof(p2) == "number" and p2 or nil
end
local function getHeadshotUrl(p3)
	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p3)
end
local function hide()
	scriptParent.Visible = false
end
local function show()
	scriptParent.Visible = true
end
local function waitForKillerAttrs(p4)
	local v30 = os.clock()

	while true do
		if not (os.clock() - v30 < 2.5) then
			break
		end

		local killerUserId = p4:GetAttribute("KillerUserId")
		local v32 = typeof(killerUserId) == "number" and killerUserId or nil
		local diedToWeapon = p4:GetAttribute("DiedToWeapon")
		local v34 = typeof(diedToWeapon) == "string" and diedToWeapon or ""

		if v32 and v34 ~= "" then
			return v32, v34
		end

		local u35: boolean = false

		local connection = p4:GetAttributeChangedSignal("KillerUserId"):Connect(function()
			u35 = true
		end)

		local connection2 = p4:GetAttributeChangedSignal("DiedToWeapon"):Connect(function()
			u35 = true
		end)

		local v38 = os.clock()

		while not u35 and os.clock() - v38 < 0.25 do
			task.wait()
		end

		connection:Disconnect()
		connection2:Disconnect()
	end

	return nil, nil
end
local function fillCard(player, p6)
	playerName.Text = player.DisplayName

	if player.DisplayName ~= player.Name then
		displayName.Text = "@" .. player.Name
		displayName.Visible = true
	else
		displayName.Visible = false
	end

	local level = player:GetAttribute("Level")

	if typeof(level) == "number" then
		playerLevel.Text = ("Lv. %d"):format((math.floor(level)))
	else
		playerLevel.Text = "Lv. ?"
	end

	headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)

	local attributeValue = player:GetAttribute(if p6 == "Knife" then "KnifeIcon" else "RevolverIcon")

	if typeof(attributeValue) == "string" and attributeValue ~= "" then
		v12.Image = attributeValue
		v12.ImageTransparency = 0
	else
		v12.Image = ""
		v12.ImageTransparency = 1
	end

	local attributeValue2 = player:GetAttribute(if p6 == "Knife" then "KnifeName" else "RevolverName")

	if typeof(attributeValue2) == "string" and attributeValue2 ~= "" then
		weaponName.Text = string.upper(attributeValue2)
	else
		weaponName.Text = string.upper(p6)
	end

	local attributeValue3 = player:GetAttribute(if p6 == "Knife" then "KnifeRarity" else "RevolverRarity")
	local v45 = typeof(attributeValue3) == "string" and attributeValue3 ~= "" and attributeValue3 or "Common"

	pattern.ImageColor3 = uiFramework.applyRarityColor(patternImageColor3, v45)
	weapon.BackgroundColor3 = uiFramework.applyRarityColor(weaponBackgroundColor3, v45)
end

local n1: number = 0

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		n1 += 1
		scriptParent.Visible = false
	end
end)

if LocalPlayer.Character then
	local Character: Model = LocalPlayer.Character

	n1 += 1
	scriptParent.Visible = false
	Character:WaitForChild("Humanoid").Died:Connect(function()
		n1 += 1

		local v47: number = n1
		local v48, v49 = waitForKillerAttrs(Character)

		if v47 ~= n1 then
		elseif v48 and v49 then
			local player: Player = players:GetPlayerByUserId(v48)

			if not player then
				return
			end

			fillCard(player, v49)
			scriptParent.Visible = true

			return
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function(character: Model)
	n1 += 1
	scriptParent.Visible = false
	character:WaitForChild("Humanoid").Died:Connect(function()
		n1 += 1

		local v52: number = n1
		local v53, v54 = waitForKillerAttrs(character)

		if v52 ~= n1 then
		elseif v53 and v54 then
			local player: Player = players:GetPlayerByUserId(v53)

			if not player then
				return
			end

			fillCard(player, v54)
			scriptParent.Visible = true

			return
		end
	end)
end)
