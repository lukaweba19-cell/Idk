-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local currencyGiftRequest: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("CurrencyGiftRequest")
local u5 = nil
local u6 = nil
local t1: {[any]: any} = {}
local u8 = nil
local u9: boolean = false

local function setNestedText(p1, p2, text)
	local foundChild = p1:FindFirstChild(p2)

	if foundChild and foundChild:IsA("TextLabel") then
		foundChild.Text = text
	end
end
local function headshotUrl(p4)
	if p4 <= 0 then
		return ""
	end

	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p4)
end
local function clearTiles()
	for _, v in ipairs(t1) do
		v:Destroy()
	end

	table.clear(t1)
end
local function resolve()
	if u5 then
		return u5
	end

	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		error("[GiftPicker] client-only module required from a server context", 2)
	end

	u6 = LocalPlayer

	local giftingMenu: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("GiftingMenu")
	local v24: Instance = giftingMenu:WaitForChild("GiftingMenu")
	local scrollingFrame: Instance = v24:WaitForChild("Content"):WaitForChild("ScrollingFrame")
	local giftText: Instance = v24:WaitForChild("GiftText")
	local textBox: Instance = v24:WaitForChild("SearchBar"):WaitForChild("TextBox")
	local closeButton: Instance = v24:WaitForChild("CloseButton")
	local clone = nil

	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("ImageButton") and v.Name == "PlayerGift" then
			clone = v:Clone()

			break
		end
	end

	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("ImageButton") and v.Name == "PlayerGift" then
			v:Destroy()
		end
	end

	local t3: {[any]: any} = {
		root = giftingMenu,
		inner = v24,
		scroll = scrollingFrame,
		text = giftText,
		search = textBox,
		close = closeButton,
		template = clone
	}

	u5 = t3

	return t3
end

local module: {[any]: any} = {
	Populate = function(p5)
		local v36 = resolve()

		for _, v in ipairs(t1) do
			v:Destroy()
		end

		table.clear(t1)

		local v39 = u8
		local template = v36.template

		if v39 and template then
			local v41 = if p5 then p5:lower() else nil

			for _, v in ipairs(players:GetPlayers()) do
				if v ~= u6 and (not v41 or v41 == "" or v.DisplayName:lower():find(v41, 1, true) or v.Name:lower():find(v41, 1, true)) then
					local clone = template:Clone()

					clone.Name = "Player_" .. v.Name
					clone.Visible = true

					local display = clone:FindFirstChild("Display")
					local username = clone:FindFirstChild("Username")
					local headshot = clone:FindFirstChild("Headshot")
					local gift = clone:FindFirstChild("Gift")

					if display then
						display.Text = v.DisplayName
					end

					if username then
						username.Text = "@" .. v.Name
					end

					if headshot then
						task.spawn(function()
							local vUserId = v.UserId
							local image = if vUserId <= 0 then "" else ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(vUserId)

							if image ~= "" and headshot.Parent then
								headshot.Image = image
							end
						end)
					end

					if gift then
						local u49 = false

						if v39.ownedBy then
							local ok, result = pcall(v39.ownedBy, v)

							u49 = ok and result == true
						end

						if u49 then
							uiFramework.setButtonDisabled(gift)

							local textLabel = gift:FindFirstChild("TextLabel")

							if textLabel and textLabel:IsA("TextLabel") then
								textLabel.Text = "OWNED"
							end
						else
							gift.MouseButton1Click:Connect(function()
								currencyGiftRequest:FireServer(v39.productId, v.UserId)
							end)
						end
					end

					clone.Parent = v36.scroll
					table.insert(t1, clone)
				end
			end

			return
		end
	end,
	Close = function()
		local v53 = resolve()

		v53.root.Visible = false
		v53.inner.Visible = false
		v53.search.Text = ""

		for _, v in ipairs(t1) do
			v:Destroy()
		end

		table.clear(t1)
		v53 = u8
		u8 = nil

		if v53 and v53.onClose then
			task.spawn(v53.onClose)
		end
	end
}

function module.Open(p6)
	if type(p6) == "table" then
		if type(p6.productId) == "number" and p6.productId ~= 0 then
			local v57 = resolve()

			if not u9 then
				u9 = true
				v57.close.MouseButton1Click:Connect(function()
					module.Close()
				end)
				v57.search:GetPropertyChangedSignal("Text"):Connect(function()
					if not v57.inner.Visible then
						return
					end

					module.Populate(v57.search.Text)
				end)
			end

			u8 = p6
			v57.text.Text = "Gifting " .. (p6.displayName or "this") .. " to"
			v57.search.Text = ""
			module.Populate(nil)
			v57.root.Visible = true
			v57.inner.Visible = true

			if p6.onOpen then
				task.spawn(p6.onOpen)
			end

			return true
		end

		return false
	end

	return false
end
function module.IsOpen()
	return u8 ~= nil
end

return module
