-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local LocalPlayer: Player = players.LocalPlayer
local playerRequestSend: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerRequestSend")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local inspectItem: Instance = bindables:WaitForChild("InspectItem")
local requestPlayerCard: Instance = bindables:WaitForChild("RequestPlayerCard")
local requestClanView: Instance = bindables:WaitForChild("RequestClanView")
local openInventoryForPlayer: Instance = bindables:FindFirstChild("OpenInventoryForPlayer")
local openTradeHistoryForPlayer: Instance = bindables:FindFirstChild("OpenTradeHistoryForPlayer")
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")

require(replicatedStorageShared:WaitForChild("Rarity"))

local v17: Instance = replicatedStorage:WaitForChild("Shared")
local hoverInfoModule = require(v17:WaitForChild("HoverInfoModule"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local v20: Instance = replicatedStorage:WaitForChild("Shared")
local gameFlags = require(v20:WaitForChild("GameFlags"))
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local clanCatalog = require(catalogs:WaitForChild("ClanCatalog"))
local v24: Instance = replicatedStorage:WaitForChild("Shared")
local clanImage = require(v24:WaitForChild("ClanImage"))
local v26: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(v26:WaitForChild("TraitText"))
local v28: Instance = replicatedStorage:WaitForChild("Shared")
local tradePublicFlags = require(v28:WaitForChild("TradePublicFlags"))

local function getHud()
	return (LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"))
end

local playerCard: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("PlayerCard")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local playerCardPosition = playerCard.Position
local uDim2 = UDim2.new(playerCardPosition.X.Scale, playerCardPosition.X.Offset, playerCardPosition.Y.Scale + 1, playerCardPosition.Y.Offset)
local u36 = nil

playerCard.Visible = false
playerCard.Position = uDim2

local header: Instance = playerCard:WaitForChild("Header")
local playerDisplayName: Instance = header:WaitForChild("PlayerDisplayName")
local playerName: Instance = header:WaitForChild("PlayerName")
local playerLevel: Instance = header:WaitForChild("LevelStar"):WaitForChild("PlayerLevel")
local playerTemplate: Instance = header:WaitForChild("PlayerTemplate")
local headshot: Instance = playerTemplate:WaitForChild("Headshot")
local clan: Instance = header:WaitForChild("Clan")
local clanName: Instance = clan:WaitForChild("ClanName")
local role: Instance = clan:WaitForChild("Role")
local options: Instance = playerCard:WaitForChild("Options")
local v47: Instance = replicatedStorage:WaitForChild("Shared")

if require(v47:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	for _, v in ipairs({ "DUEL", "INVITE" }) do
		local v: Instance = options:FindFirstChild(v)

		if v and v:IsA("GuiObject") then
			v.Visible = false
		end
	end

	local history: Instance = options:FindFirstChild("HISTORY")

	if history and history:IsA("GuiObject") then
		history.Visible = tradePublicFlags.TradeHistoryPublic()
		tradePublicFlags.OnChanged("TradeHistoryPublic", function()
			history.Visible = tradePublicFlags.TradeHistoryPublic()
		end)
	end
end

local function setOptionsEnabled(p1)
	for _, v in ipairs(options:GetChildren()) do
		if v:IsA("TextButton") then
			if p1 then
				uiFramework.setButtonEnabled(v)
			else
				uiFramework.setButtonDisabled(v)
			end
		end
	end
end

local closeButton: Instance = playerCard:WaitForChild("CloseButton")
local items: Instance = playerCard:WaitForChild("Items")
local stats: Instance = items:WaitForChild("Stats")
local streak: Instance = stats:WaitForChild("Streak")
local wins: Instance = stats:WaitForChild("Wins")
local kills: Instance = stats:WaitForChild("Kills")

local function getStatValue(p2, childName)
	return (p2:WaitForChild(childName):WaitForChild("ImageLabel"):WaitForChild("Value"))
end

local v60: Instance = streak:WaitForChild("WinstreakStat"):WaitForChild("ImageLabel"):WaitForChild("Value")
local v61: Instance = wins:WaitForChild("WinsStat"):WaitForChild("ImageLabel"):WaitForChild("Value")
local v62: Instance = kills:WaitForChild("TotalKillsStat"):WaitForChild("ImageLabel"):WaitForChild("Value")
local weapons: Instance = items:WaitForChild("Weapons")
local knife: Instance = weapons:WaitForChild("Knife")
local gun: Instance = weapons:WaitForChild("Gun")

local function cacheSlotBaseColors(p4)
	local uiStroke = p4:FindFirstChildOfClass("UIStroke")
	local sunburst = p4:FindFirstChild("Sunburst")
	local rarity = p4:FindFirstChild("Rarity")
	local uiGradient = p4:FindFirstChildOfClass("UIGradient")

	return {
		bg = p4.BackgroundColor3,
		stroke = uiStroke and uiStroke.Color or Color3.new(1, 1, 1),
		sunburst = sunburst and sunburst.ImageColor3 or Color3.new(1, 1, 1),
		rarityText = rarity and rarity.TextColor3 or Color3.new(1, 1, 1),
		gradient = uiGradient
	}
end

local v67 = cacheSlotBaseColors(knife)
local v68 = cacheSlotBaseColors(gun)
local v69 = hoverInfoModule.create(playerCard)

local function headshotUrl(p5)
	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p5)
end
local function fmtNum(p6)
	local typeName: string = typeof(p6)

	return (tostring(typeName == "number" and p6 or 0))
end
local function renderWeaponSlot(p7, p8, image, p10, p11, _, _, _)
	local text = typeof(p10) == "string" and p10 ~= "" and p10 or "Common"
	local icon = p7:FindFirstChild("Icon")

	if icon then
		if image and image ~= "" then
			icon.Image = image
			icon.ImageTransparency = 0
		else
			icon.Image = ""
			icon.ImageTransparency = 1
		end
	end

	local itemName = p7:FindFirstChild("ItemName")

	if itemName then
		traitText.Bind(itemName, p11)
	end

	local rarity = p7:FindFirstChild("Rarity")

	if rarity then
		rarity.Text = text
		rarity.TextColor3 = uiFramework.applyRarityColor(p8.rarityText, text)
	end

	p7.BackgroundColor3 = uiFramework.applyRarityColor(p8.bg, text)

	local uiStroke = p7:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		uiStroke.Color = uiFramework.applyRarityColor(p8.stroke, text)
	end

	local sunburst = p7:FindFirstChild("Sunburst")

	if sunburst then
		sunburst.ImageColor3 = uiFramework.applyRarityColor(p8.sunburst, text)
		sunburst.Visible = text ~= "Common"

		if sunburst.Visible and not sunburst:GetAttribute("Spinning") then
			sunburst:SetAttribute("Spinning", true)

			local connection = nil

			connection = runService.Heartbeat:Connect(function(deltaTime: number)
				if not sunburst:IsDescendantOf(game) then
					connection:Disconnect()

					return
				end

				sunburst.Rotation = (sunburst.Rotation + deltaTime * 15) % 360
			end)
		end
	end
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function clearWeaponHoverConns()
	for _, v in ipairs(t1) do
		v:Disconnect()
	end

	table.clear(t1)

	for _, v in ipairs(t2) do
		v.disconnect()
	end

	table.clear(t2)
end
local function wireWeaponHover(p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26)
	local v129 = typeof(p17) == "string" and p17 ~= "" and p17 or "Common"

	local v130 = hoverInfoModule.bind(v69, p16, function()
		return {
			Name = p18 or "Unknown",
			Rarity = v129,
			GlobalCopies = p19,
			Serial = p25,
			MaxSupply = p26,
			SourceButton = p16,
			FinisherName = p22,
			FinisherIcon = p23,
			FinisherRarity = p24,
			Kind = p20,
			ItemId = p21
		}
	end)

	table.insert(t2, v130)

	if p20 and p21 and (p20 == "Knife" or p20 == "Revolver") then
		table.insert(t1, p16.MouseButton1Click:Connect(function()
			if v130.tapConsumed() then
				return
			end

			hoverInfoModule.hide(v69)
			inspectItem:Fire({
				Kind = p20,
				ItemId = p21,
				Name = p18 or "Unknown",
				Rarity = v129,
				GlobalCopies = p19,
				Serial = p25,
				MaxSupply = p26
			})
		end))
	end
end

local t3: {[any]: any} = {}
local u78 = nil

local function disconnectAll()
	for _, v in ipairs(t3) do
		v:Disconnect()
	end

	table.clear(t3)
	clearWeaponHoverConns()
end
local function hookAttribute(p27, p28, p29)
	local v136 = p27:GetAttributeChangedSignal(p28)

	table.insert(t3, v136:Connect(p29))
end
local function applyWeaponSlot(p30, p31, p32, p33)
	local attributeValue = p32:GetAttribute(if p33 == "Knife" then "KnifeIcon" else "RevolverIcon")
	local attributeValue2 = p32:GetAttribute(if p33 == "Knife" then "KnifeRarity" else "RevolverRarity")
	local attributeValue3 = p32:GetAttribute(if p33 == "Knife" then "KnifeName" else "RevolverName")
	local attributeValue4 = p32:GetAttribute(if p33 == "Knife" then "KnifeGlobalCopies" else "RevolverGlobalCopies")
	local attributeValue5 = p32:GetAttribute(if p33 == "Knife" then "KnifeSkin" else "RevolverSkin")
	local attributeValue6 = p32:GetAttribute(if p33 == "Knife" then "KnifeFinisherName" else "RevolverFinisherName")
	local attributeValue7 = p32:GetAttribute(if p33 == "Knife" then "KnifeFinisherIcon" else "RevolverFinisherIcon")
	local attributeValue8 = p32:GetAttribute(if p33 == "Knife" then "KnifeFinisherRarity" else "RevolverFinisherRarity")
	local attributeValue9 = p32:GetAttribute(if p33 == "Knife" then "KnifeSerial" else "RevolverSerial")
	local attributeValue10 = p32:GetAttribute(if p33 == "Knife" then "KnifeMaxSupply" else "RevolverMaxSupply")

	renderWeaponSlot(p30, p31, attributeValue, attributeValue2, attributeValue3, attributeValue4, p33, attributeValue5)
	wireWeaponHover(p30, attributeValue2, attributeValue3, attributeValue4, p33, attributeValue5, attributeValue6, attributeValue7, attributeValue8, attributeValue9, attributeValue10)
end
local function updateClanDisplay(p34)
	local clanName2 = p34:GetAttribute("ClanName")

	if typeof(clanName2) == "string" and clanName2 ~= "" then
		clanName.Text = clanName2
		clanImage.apply(clan, p34:GetAttribute("ClanImageId"))

		local clanRole = p34:GetAttribute("ClanRole")

		role.Text = typeof(clanRole) == "string" and clanRole ~= "" and clanCatalog.GetRoleLabel(clanRole) or ""
		clan.Visible = true

		return
	end

	clan.Visible = false
end
local function applyAll(player)
	playerDisplayName.Text = player.DisplayName
	playerName.Text = "@" .. player.Name

	local level = player:GetAttribute("Level")
	local typeName: string = typeof(level)

	playerLevel.Text = tostring(typeName == "number" and level or 0)
	headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(player.UserId)
	updateClanDisplay(player)

	local winStreak = player:GetAttribute("WinStreak")
	local typeName2: string = typeof(winStreak)

	v60.Text = tostring(typeName2 == "number" and winStreak or 0)

	local wins = player:GetAttribute("Wins")
	local typeName3: string = typeof(wins)

	v61.Text = tostring(typeName3 == "number" and wins or 0)

	local kills = player:GetAttribute("Kills")
	local typeName4: string = typeof(kills)

	v62.Text = tostring(typeName4 == "number" and kills or 0)
	clearWeaponHoverConns()
	applyWeaponSlot(knife, v67, player, "Knife")
	applyWeaponSlot(gun, v68, player, "Revolver")
end
local function closeCard()
	hoverInfoModule.hide(v69)
	disconnectAll()
	u78 = nil
	windowBlur.hide("PlayerCard")

	if u36 then
		u36:Cancel()
	end

	u36 = tweenService:Create(playerCard, tweenInfo2, { Position = uDim2 })
	u36:Play()
	u36.Completed:Once(function()
		if not u78 then
			playerCard.Visible = false
		end
	end)
end
local function openCard(p36)
	if LocalPlayer:GetAttribute("DailyGiftsOpen") then
		return
	end

	if p36 == u78 and playerCard.Visible then
		return
	end

	closeCard()
	u78 = p36

	if u36 then
		u36:Cancel()
	end

	playerCard.Position = uDim2
	playerCard.Visible = true
	u36 = tweenService:Create(playerCard, tweenInfo, { Position = playerCardPosition })
	u36:Play()
	activeWindowChanged:Fire("PlayerCard")
	windowBlur.show("PlayerCard")
	applyAll(p36)

	local trade: Instance = options:FindFirstChild("TRADE")
	local comingSoonIndicator: Instance = trade and trade:FindFirstChild("ComingSoonIndicator")

	if comingSoonIndicator and comingSoonIndicator:IsA("GuiObject") then
		comingSoonIndicator.Visible = not gameFlags.TradingEnabled
	end

	if p36 == LocalPlayer then
		setOptionsEnabled(false)

		local history: Instance = options:FindFirstChild("HISTORY")

		if history and history:IsA("TextButton") then
			uiFramework.setButtonEnabled(history)
		end
	else
		setOptionsEnabled(true)

		local function updatePrivacyButtons()
			if u78 ~= p36 then
				return
			end

			for _, v in ipairs(options:GetChildren()) do
				if v:IsA("TextButton") then
					if v.Name ~= "TRADE" then
						if v.Name == "DUEL" then
							if p36:GetAttribute("DuelRequests") == false then
								uiFramework.setButtonDisabled(v)
							else
								uiFramework.setButtonEnabled(v)
							end
						elseif v.Name == "HISTORY" then
							if p36:GetAttribute("TradeHistoryPublic") == false then
								uiFramework.setButtonDisabled(v)
							else
								uiFramework.setButtonEnabled(v)
							end
						elseif v.Name == "CLAN" then
							if LocalPlayer:GetAttribute("ClanTag") == nil or p36:GetAttribute("ClanTag") ~= nil then
								uiFramework.setButtonDisabled(v)
							else
								uiFramework.setButtonEnabled(v)
							end
						end
					elseif gameFlags.TradingEnabled and p36:GetAttribute("TradeRequests") ~= false then
						uiFramework.setButtonEnabled(v)
					else
						uiFramework.setButtonDisabled(v)
					end
				end
			end
		end

		updatePrivacyButtons()

		local v168 = p36:GetAttributeChangedSignal("TradeRequests")

		table.insert(t3, v168:Connect(updatePrivacyButtons))
		v168 = p36:GetAttributeChangedSignal("DuelRequests")
		table.insert(t3, v168:Connect(updatePrivacyButtons))
		v168 = p36:GetAttributeChangedSignal("TradeHistoryPublic")
		table.insert(t3, v168:Connect(updatePrivacyButtons))
		v168 = p36:GetAttributeChangedSignal("ClanTag")
		table.insert(t3, v168:Connect(updatePrivacyButtons))
	end

	local function refreshClan()
		if u78 == p36 then
			updateClanDisplay(p36)
		end
	end

	local v170 = p36:GetAttributeChangedSignal("ClanName")

	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("ClanImageId")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("ClanRole")
	table.insert(t3, v170:Connect(refreshClan))

	local v171 = p36:GetAttributeChangedSignal("Level")

	table.insert(t3, v171:Connect(function()
		if u78 == p36 then
			local level = p36:GetAttribute("Level")
			local typeName: string = typeof(level)

			playerLevel.Text = tostring(typeName == "number" and level or 0)
		end
	end))
	v171 = p36:GetAttributeChangedSignal("WinStreak")
	table.insert(t3, v171:Connect(function()
		if u78 == p36 then
			local winStreak = p36:GetAttribute("WinStreak")
			local typeName: string = typeof(winStreak)

			v60.Text = tostring(typeName == "number" and winStreak or 0)
		end
	end))
	v171 = p36:GetAttributeChangedSignal("Wins")
	table.insert(t3, v171:Connect(function()
		if u78 == p36 then
			local wins = p36:GetAttribute("Wins")
			local typeName: string = typeof(wins)

			v61.Text = tostring(typeName == "number" and wins or 0)
		end
	end))
	v171 = p36:GetAttributeChangedSignal("Kills")
	table.insert(t3, v171:Connect(function()
		if u78 == p36 then
			local kills = p36:GetAttribute("Kills")
			local typeName: string = typeof(kills)

			v62.Text = tostring(typeName == "number" and kills or 0)
		end
	end))
	refreshClan = function()
		if u78 ~= p36 then
			return
		end

		clearWeaponHoverConns()
		applyWeaponSlot(knife, v67, p36, "Knife")
		applyWeaponSlot(gun, v68, p36, "Revolver")
	end
	v170 = p36:GetAttributeChangedSignal("KnifeIcon")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("KnifeRarity")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("KnifeName")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("KnifeGlobalCopies")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("KnifeSerial")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("KnifeMaxSupply")
	table.insert(t3, v170:Connect(refreshClan))
	refreshClan = function()
		if u78 ~= p36 then
			return
		end

		clearWeaponHoverConns()
		applyWeaponSlot(knife, v67, p36, "Knife")
		applyWeaponSlot(gun, v68, p36, "Revolver")
	end
	v170 = p36:GetAttributeChangedSignal("RevolverIcon")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("RevolverRarity")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("RevolverName")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("RevolverGlobalCopies")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("RevolverSerial")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetAttributeChangedSignal("RevolverMaxSupply")
	table.insert(t3, v170:Connect(refreshClan))
	v170 = p36:GetPropertyChangedSignal("DisplayName")
	table.insert(t3, v170:Connect(function()
		if u78 == p36 then
			playerDisplayName.Text = p36.DisplayName
		end
	end))
end

closeButton.MouseButton1Click:Connect(closeCard)
clan.Active = true
clan.Selectable = true
clan.AutoButtonColor = false
clan.Activated:Connect(function()
	local player = u78

	if not player then
		return
	end

	if player:GetAttribute("ClanName") == nil then
		return
	end

	requestClanView:Fire(player.UserId)
end)
playerTemplate.Active = false
playerTemplate.AutoButtonColor = false
playerTemplate.Selectable = false;
(function()
	for _, v in ipairs(options:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Click:Connect(function()
				if not v.Interactable then
					return
				end

				local v189 = u78
				local vName = v.Name

				closeCard()

				if not v189 then
				elseif vName == "ITEMS" then
					if openInventoryForPlayer then
						openInventoryForPlayer:Fire(v189)
					end
				elseif vName == "HISTORY" then
					if openTradeHistoryForPlayer then
						openTradeHistoryForPlayer:Fire(v189)
					end
				elseif vName == "TRADE" or vName == "DUEL" or vName == "INVITE" or vName == "CLAN" then
					local t4: {[any]: any} = {
						TRADE = "Trade",
						DUEL = "Duel",
						INVITE = "Party",
						CLAN = "ClanInvite"
					}
					local v192 = t4[vName]

					if not v192 then
						return
					end

					local ok, result = pcall(function()
						return playerRequestSend:InvokeServer({ Type = v192, TargetUserId = v189.UserId })
					end)

					if result == nil or not ok then
						_G.Notify({
							notifType = "FailNotification",
							errorMessage = "An error has occurred."
						})

						return
					end

					if result == true then
						_G.Notify({
							notifType = "SuccessNotification",
							topText = "Request Sent!",
							bottomText = "Sent " .. v192 .. " request."
						})

						return
					end

					local _GNotify = _G.Notify
					local text: string = tostring(result)

					_GNotify({ notifType = "FailNotification", errorMessage = text })

					return
				end
			end)
		end
	end
end)()
requestPlayerCard.Event:Connect(function(p37)
	local foundChild = nil

	if typeof(p37) == "Instance" and p37:IsA("Player") then
		foundChild = p37
	elseif typeof(p37) == "number" then
		foundChild = players:GetPlayerByUserId(p37)
	elseif typeof(p37) == "string" then
		foundChild = players:FindFirstChild(p37)
	end

	if not foundChild then
		return
	end

	openCard(foundChild)
end)
activeWindowChanged.Event:Connect(function(p38)
	if p38 ~= "PlayerCard" and playerCard.Visible then
		closeCard()
	end
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	if playerCard.Visible then
		closeCard()
	end
end)
