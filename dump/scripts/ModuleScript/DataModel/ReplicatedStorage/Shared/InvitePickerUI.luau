-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local playerRequestSend: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerRequestSend")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local clanRosterUI = require(shared:WaitForChild("ClanRosterUI"))

local ok, result = pcall(function()
	return require(replicatedStorage:WaitForChild("Sound"))
end)

local function notifyError(p1)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p1 })
	end
end
local function notifySuccess(p2)
	if _G.Notify then
		_G.Notify({
			notifType = "SuccessNotification",
			topText = "Success!",
			bottomText = p2
		})
	end
end
local function grabTemplate(p3)
	for _, v in ipairs(p3:GetChildren()) do
		if v:IsA("Frame") and v.Name == "PlayerCard_Template" then
			v.Visible = false

			return v
		end
	end

	return nil
end

return {
	new = function(p4)
		local scrollingFrame = p4.scrollingFrame
		local u19: boolean = p4.showStats == true
		local v20 = grabTemplate(scrollingFrame)
		local t1: {[any]: any} = {}
		local t2: {[any]: any} = {}
		local t3: {[any]: any} = {}
		local t4 = {}
		local u25: boolean = false
		local n1: number = 0

		local function clearCards()
			for _, v in ipairs(scrollingFrame:GetChildren()) do
				if v:IsA("GuiObject") and v ~= v20 and v.Name ~= "PADDINGFIX" then
					v:Destroy()
				end
			end
		end
		local function ensureFriendCached(player)
			local userId = player.UserId

			if t2[userId] ~= nil then
				return
			end

			if userId <= 0 then
				t2[userId] = false

				return
			end

			local ok2, result2 = pcall(function()
				return LocalPlayer:IsFriendsWith(userId)
			end)

			t2[userId] = ok2 and result2 == true
		end
		local function wireAccept(p6, player)
			local function setSent(p8)
				p6.Interactable = not p8
				p6.AutoButtonColor = not p8

				local imageLabel = p6:FindFirstChild("ImageLabel")

				if imageLabel and imageLabel:IsA("ImageLabel") then
					imageLabel.ImageTransparency = if p8 then 0.6 else 0
				end
			end

			local v42 = t1[player.UserId]
			local u43: boolean = v42 ~= nil and os.clock() - v42 < p4.cooldown

			p6.Interactable = not u43
			p6.AutoButtonColor = not u43

			local imageLabel = p6:FindFirstChild("ImageLabel")

			if imageLabel and imageLabel:IsA("ImageLabel") then
				imageLabel.ImageTransparency = if u43 then 0.6 else 0
			end

			p6.MouseButton1Click:Connect(function()
				if not p6.Interactable then
					return
				end

				if not p4.canInvite() then
					if _G.Notify then
						_G.Notify({
							notifType = "FailNotification",
							errorMessage = "You can't invite right now."
						})
					end

					return
				end

				p6.Interactable = false
				p6.AutoButtonColor = false

				local imageLabel2 = p6:FindFirstChild("ImageLabel")

				if imageLabel2 and imageLabel2:IsA("ImageLabel") then
					imageLabel2.ImageTransparency = 0.6
				end

				t1[player.UserId] = os.clock()

				local ok3, result3 = pcall(function()
					return playerRequestSend:InvokeServer({ Type = p4.requestType, TargetUserId = player.UserId })
				end)

				if ok3 and result3 == true then
					local v80 = p4.successText(player)

					if _G.Notify then
						_G.Notify({
							notifType = "SuccessNotification",
							topText = "Success!",
							bottomText = v80
						})
					end

					task.delay(p4.cooldown, function()
						local v88 = t1[player.UserId]

						if v88 and os.clock() - v88 >= p4.cooldown then
							t1[player.UserId] = nil

							if p6.Parent then
								p6.Interactable = true
								p6.AutoButtonColor = true

								local imageLabel3 = p6:FindFirstChild("ImageLabel")

								if imageLabel3 and imageLabel3:IsA("ImageLabel") then
									imageLabel3.ImageTransparency = 0
								end
							end
						end
					end)

					return
				end

				t1[player.UserId] = nil
				p6.Interactable = true
				p6.AutoButtonColor = true

				local imageLabel4 = p6:FindFirstChild("ImageLabel")

				if imageLabel4 and imageLabel4:IsA("ImageLabel") then
					imageLabel4.ImageTransparency = 0
				end

				local typeName: string = typeof(result3)

				if _G.Notify then
					_G.Notify({
						notifType = "FailNotification",
						errorMessage = typeName == "string" and result3 or "Couldn't send the invite."
					})
				end
			end)
		end
		local function makeCard(player)
			if not v20 then
				return
			end

			local clone = v20:Clone()

			clone.Name = "InviteCard"
			clone.Visible = true

			local username = clone:FindFirstChild("Username")

			if username and username:IsA("TextLabel") then
				username.Text = player.DisplayName
			end

			local rank = clone:FindFirstChild("Rank")
			local contributions = clone:FindFirstChild("Contributions")

			if u19 then
				if rank and rank:IsA("TextLabel") then
					local level = player:GetAttribute("Level")

					rank.Text = "Level " .. tostring(level or 1)
				end

				if contributions then
					local kills = contributions:FindFirstChild("Kills")

					if kills and kills:IsA("TextLabel") then
						local clanRosterUICommas = clanRosterUI.commas
						local kills2 = player:GetAttribute("Kills")

						kills.Text = "💀 Clan Kills: <b>" .. clanRosterUICommas(kills2 or 0) .. "</b>"
					end

					local streak = contributions:FindFirstChild("Streak")

					if streak and streak:IsA("TextLabel") then
						local winStreak = player:GetAttribute("WinStreak")

						streak.Text = "🔥 Streak: <b>" .. tostring(winStreak or 0) .. "</b>"
					end
				end
			else
				if rank and rank:IsA("GuiObject") then
					rank.Visible = false
				end

				if contributions and contributions:IsA("GuiObject") then
					contributions.Visible = false
				end
			end

			local playerDisplay = clone:FindFirstChild("PlayerDisplay")

			if playerDisplay and playerDisplay:IsA("ImageLabel") then
				clanRosterUI.applyAvatar(playerDisplay, player.UserId)
			end

			local buttons = clone:FindFirstChild("Buttons")
			local v58 = buttons

			if v58 then
				v58 = buttons:FindFirstChild("AcceptButton")
			end

			local rejectButton = buttons and buttons:FindFirstChild("RejectButton")

			if rejectButton and rejectButton:IsA("GuiObject") then
				rejectButton.Visible = false
			end

			if v58 and v58:IsA("TextButton") then
				wireAccept(v58, player)
			end

			clone.Parent = scrollingFrame
		end
		local function doRender()
			n1 += 1

			local v60: number = n1

			if not p4.canInvite() then
				clearCards()

				return
			end

			local t5: {[any]: any} = {}

			for _, v in ipairs(players:GetPlayers()) do
				if p4.isInvitable(v) then
					table.insert(t5, v)
				end
			end

			for _, v in ipairs(t5) do
				local vUserId = v.UserId

				if t2[vUserId] == nil then
					if vUserId <= 0 then
						t2[vUserId] = false
					else
						local ok4, result4 = pcall(function()
							return LocalPlayer:IsFriendsWith(vUserId)
						end)

						t2[vUserId] = ok4 and result4 == true
					end
				end
			end

			if v60 ~= n1 then
				return
			end

			table.sort(t5, function(player, player2)
				local u85: boolean = t2[player.UserId] == true

				if u85 ~= (t2[player2.UserId] == true) then
					return u85
				end

				local lowerText = player.DisplayName:lower()
				local lowerText2 = player2.DisplayName:lower()

				return lowerText < lowerText2
			end)
			clearCards()

			for _, v in ipairs(t5) do
				if v.Parent == players and p4.isInvitable(v) then
					makeCard(v)
				end
			end
		end
		local function rerender()
			task.spawn(doRender)
		end

		return {
			open = function()
				if u25 then
					task.spawn(doRender)

					return
				end

				u25 = true
				task.spawn(doRender)
				table.insert(t3, players.PlayerAdded:Connect(function()
					if u25 then
						task.spawn(doRender)
					end
				end))
				table.insert(t3, players.PlayerRemoving:Connect(function()
					if u25 then
						task.defer(rerender)
					end
				end))

				if p4.bindLiveSignals then
					t4 = p4.bindLiveSignals(function()
						if u25 then
							task.spawn(doRender)
						end
					end) or {}
				end
			end,
			close = function()
				u25 = false

				for _, v in ipairs(t3) do
					v:Disconnect()
				end

				table.clear(t3)

				for _, v in ipairs(t4) do
					v:Disconnect()
				end

				table.clear(t4)
			end,
			render = rerender
		}
	end
}
