-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local reviewRequest: Instance = remotes:WaitForChild("ReviewRequest")
local reviewPush: Instance = remotes:WaitForChild("ReviewPush")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local replayReviewControl: Instance = bindables:WaitForChild("ReplayReviewControl")
local replayReviewState: Instance = bindables:WaitForChild("ReplayReviewState")
local uiFramework = nil

pcall(function()
	uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
end)

local uDim2 = UDim2.new(0.985, 0, 0.46, 0)
local v12 = UDim2.fromScale(0.34, 0.76)
local u13 = nil
local u14: boolean = false
local u15: boolean = false
local n1 = 0
local u17 = false
local n2: number = 0
local n3 = 6
local n4: number = 0

local function stripScripts(p1)
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("LuaSourceContainer") then
			v:Destroy()
		end
	end
end
local function setCaption(p2, text)
	if not p2 then
		return
	end

	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("TextLabel") and text ~= v.Text then
			v.Text = text
		end
	end

	if p2:IsA("TextLabel") and text ~= p2.Text then
		p2.Text = text
	end
end
local function setRowLabel(p4, text)
	local settingName = p4:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") then
		settingName.Text = text
		settingName.TextWrapped = true
	end
end
local function build()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local playerGuiHud: Instance = playerGui and playerGui:FindFirstChild("HUD")
	local settingsWindow: Instance = playerGuiHud and playerGuiHud:FindFirstChild("SettingsWindow")

	if not settingsWindow then
		return nil
	end

	local ok, result = pcall(function()
		return settingsWindow:Clone()
	end)

	if not ok or not result or not result:IsA("GuiObject") then
		return nil
	end

	stripScripts(result)

	local content = result:FindFirstChild("Content")
	local contentHotkeys = result:FindFirstChild("ContentHotkeys")
	local scrollingFrame = contentHotkeys and contentHotkeys:FindFirstChild("ScrollingFrame")
	local contentScrollingFrame = content and content:FindFirstChild("ScrollingFrame")
	local hud: Instance = game:GetService("StarterGui"):FindFirstChild("HUD")

	hud = hud and hud:FindFirstChild("SettingsWindow")
	hud = hud and hud:FindFirstChild("Content")
	hud = hud and hud:FindFirstChild("ScrollingFrame")

	local v61 = hud and hud:FindFirstChild("EditControls") or contentScrollingFrame and contentScrollingFrame:FindFirstChild("EditControls")
	local gameplayHeader = contentScrollingFrame and contentScrollingFrame:FindFirstChild("GameplayHeader")

	if content and contentHotkeys and scrollingFrame and scrollingFrame:IsA("ScrollingFrame") and v61 and gameplayHeader then
		local clone = v61:Clone()
		local clone2 = gameplayHeader:Clone()
		local navigator = result:FindFirstChild("Navigator")

		if navigator then
			navigator:Destroy()
		end

		content:Destroy()

		local contentCrosshair = result:FindFirstChild("ContentCrosshair")

		if contentCrosshair then
			contentCrosshair:Destroy()
		end

		contentHotkeys.Visible = true

		for _, v in ipairs(scrollingFrame:GetChildren()) do
			if v:IsA("GuiObject") then
				v:Destroy()
			end
		end

		local header = result:FindFirstChild("Header")
		local v70 = header

		if v70 then
			v70 = header:FindFirstChild("TextLabel")
		end

		if v70 and v70:IsA("TextLabel") then
			v70.Text = "REVIEW"
		end

		local reviewPanel: ScreenGui = Instance.new("ScreenGui")

		reviewPanel.Name = "ReviewPanel"
		reviewPanel.ResetOnSpawn = false
		reviewPanel.DisplayOrder = 95
		reviewPanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		reviewPanel.Enabled = false
		reviewPanel.Parent = playerGui
		result.Name = "ReviewWindow"
		result.AnchorPoint = Vector2.new(1, 0.5)
		result.Position = uDim2
		result.Size = v12

		local uiAspectRatioConstraint = result:FindFirstChildOfClass("UIAspectRatioConstraint")

		if uiAspectRatioConstraint then
			uiAspectRatioConstraint:Destroy()
		end

		result.Visible = true

		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Scale = 1
		uiScale.Parent = result
		result.Parent = reviewPanel

		local t1: {[any]: any} = {
			order = 0,
			gui = reviewPanel,
			window = result,
			list = scrollingFrame,
			rows = {},
			buttons = {}
		}

		local function nextOrder()
			local v113: {[any]: any} = t1

			v113.order = v113.order + 1

			return t1.order
		end
		local function sizeRow(p6)
			if p6:IsA("GuiObject") then
				p6.Size = UDim2.new(p6.Size.X.Scale, p6.Size.X.Offset, 0.078, 0)
			end
		end
		function t1.header(text)
			local clone3 = clone2:Clone()
			local v117: {[any]: any} = t1

			v117.order = v117.order + 1
			clone3.LayoutOrder = t1.order

			if clone3:IsA("GuiObject") then
				clone3.Size = UDim2.new(clone3.Size.X.Scale, clone3.Size.X.Offset, 0.078, 0)
			end

			for _, v in ipairs(clone3:GetDescendants()) do
				if v:IsA("TextLabel") then
					v.Text = text
				end
			end

			clone3.Parent = scrollingFrame

			return clone3
		end
		function t1.info(p8, text)
			local clone4 = clone:Clone()

			clone4.Name = "Info_" .. p8

			local v123: {[any]: any} = t1

			v123.order = v123.order + 1
			clone4.LayoutOrder = t1.order

			if clone4:IsA("GuiObject") then
				clone4.Size = UDim2.new(clone4.Size.X.Scale, clone4.Size.X.Offset, 0.078, 0)
			end

			local openBtn = clone4:FindFirstChild("OpenBtn")

			if openBtn and openBtn:IsA("GuiObject") then
				openBtn.Visible = false
			end

			local settingName = clone4:FindFirstChild("SettingName")

			if settingName and settingName:IsA("TextLabel") then
				settingName.Size = UDim2.new(1, -20, settingName.Size.Y.Scale, settingName.Size.Y.Offset)
			end

			local settingName2 = clone4:FindFirstChild("SettingName")

			if settingName2 and settingName2:IsA("TextLabel") then
				settingName2.Text = text
				settingName2.TextWrapped = true
			end

			clone4.Parent = scrollingFrame
			t1.rows[p8] = clone4

			return clone4
		end
		function t1.setInfo(p10, text)
			local v129 = t1.rows[p10]
			local settingName = v129 and v129:FindFirstChild("SettingName")

			if settingName and settingName:IsA("TextLabel") then
				settingName.Text = text
				settingName.TextWrapped = true
			end
		end
		function t1.button(p12, text, p14, p15)
			local clone5 = clone:Clone()

			clone5.Name = "Row_" .. p12

			local v136: {[any]: any} = t1

			v136.order = v136.order + 1
			clone5.LayoutOrder = t1.order

			if clone5:IsA("GuiObject") then
				clone5.Size = UDim2.new(clone5.Size.X.Scale, clone5.Size.X.Offset, 0.078, 0)
			end

			local settingName = clone5:FindFirstChild("SettingName")

			if settingName and settingName:IsA("TextLabel") then
				settingName.Text = text
				settingName.TextWrapped = true
			end

			local openBtn = clone5:FindFirstChild("OpenBtn")

			setCaption(openBtn, p14)

			if openBtn and openBtn:IsA("GuiButton") then
				openBtn.Active = true
				openBtn.Interactable = true
			end

			if openBtn and openBtn:IsA("GuiObject") then
				openBtn.Size = UDim2.new(0.27, 0, openBtn.Size.Y.Scale, openBtn.Size.Y.Offset)
				openBtn.Position = UDim2.new(0.85, 0, openBtn.Position.Y.Scale, openBtn.Position.Y.Offset)
			end

			local settingName3 = clone5:FindFirstChild("SettingName")

			if settingName3 and settingName3:IsA("GuiObject") then
				settingName3.Size = UDim2.new(0.6699999999999999, 0, settingName3.Size.Y.Scale, settingName3.Size.Y.Offset)
			end

			if openBtn and openBtn:IsA("GuiButton") then
				openBtn.MouseButton1Click:Connect(p15)
				t1.buttons[p12] = openBtn
			end

			clone5.Parent = scrollingFrame

			return clone5
		end
		function t1.enable(p16, p17)
			local v142 = t1.buttons[p16]

			if not v142 or not uiFramework then
				return
			end

			pcall(function()
				if p17 then
					uiFramework.setButtonEnabled(v142)

					return
				end

				uiFramework.setButtonDisabled(v142)
			end)
		end

		t1.closeButton = result:FindFirstChild("CloseButton")

		return t1
	end

	result:Destroy()

	return nil
end

local u25 = nil

local function status(p18)
	if u13 then
		u13.setInfo("status", p18)
	end
end
local function setVotes(p19)
	u17 = p19

	if not u13 then
		return
	end

	for _, v in ipairs({ "BLATANT", "SUS", "CANTTELL" }) do
		u13.enable(v, p19)
	end
end
local function armUnlock(p20)
	n2 += 1

	local v82: number = n2

	setVotes(false)
	task.delay(p20, function()
		if v82 == n2 and u14 then
			setVotes(true)

			if u13 then
				u13.setInfo("status", "Vote when ready, or NEXT CLIP / KEEP WATCHING.")
			end
		end
	end)
end

local s1 = ""
local s2 = ""

local function refreshTop()
	if u13 then
		u13.setInfo("case", s1 .. (s2 ~= "" and "  ·  " .. s2 or ""))
	end
end
local function showCase(p21)
	if not u13 then
		return
	end

	local t2 = p21.case or {}
	local v85 = typeof(t2.why) == "table" and table.concat(t2.why, "  ·  ") or ""
	local s3 = if t2.audit then " (second opinion)" else (tonumber(t2.streak) or 0) > 0 and (" (SUS %d/3)"):format(t2.streak) or ""

	s1 = ("Case %d%s"):format(tonumber(t2.caseNo) or 0, s3)

	if u13 then
		u13.setInfo("case", s1 .. (s2 ~= "" and "  ·  " .. s2 or ""))
	end

	u13.setInfo("why", "Why: " .. (v85 ~= "" and v85 or "no notes"))
end
local function showClip(p22)
	if u13 and typeof(p22) == "table" then
		local v88 = (tonumber(p22.matches) or 1) > 1 and (", match %d/%d"):format(p22.match, p22.matches) or ""
		local v89 = p22.index or 1
		local v90 = p22.count or 1
		local text: string = tostring(p22.label or "")

		s2 = ("clip %d/%d: %s%s"):format(v89, v90, text, v88)

		if u13 then
			u13.setInfo("case", s1 .. (s2 ~= "" and "  ·  " .. s2 or ""))
		end

		return
	end
end
local function closePanel()
	u14 = false
	n4 += 1
	n2 += 1

	if u13 then
		u13.gui.Enabled = false
	end
end
local function loadNext(p23)
	if u15 then
		return
	end

	n4 += 1

	if u13 then
		u13.setInfo("status", "Loading the next case...")
	end

	setVotes(false)

	local v93 = u25(p23 or "next")

	if not u14 then
	elseif typeof(v93) == "table" then
		if v93.ok then
			n3 = tonumber(v93.minWatch) or n3
			showCase(v93)
			showClip(v93.clip)

			local v94 = ("Watch the clip. Voting opens in %ds."):format(n3)

			if u13 then
				u13.setInfo("status", v94)
			end

			v94 = n3
			n2 += 1

			local v95: number = n2

			setVotes(false)
			task.delay(v94, function()
				if v95 == n2 and u14 then
					setVotes(true)

					if u13 then
						u13.setInfo("status", "Vote when ready, or NEXT CLIP / KEEP WATCHING.")
					end
				end
			end)

			return
		end

		if v93.empty then
			s1 = "No cases waiting"
			s2 = ""

			if u13 then
				u13.setInfo("case", s1 .. (s2 ~= "" and "  ·  " .. s2 or ""))
			end

			u13.setInfo("why", "")

			local text: string = tostring(v93.err)

			if u13 then
				u13.setInfo("status", text)
			end

			n4 += 1

			local v97: number = n4

			task.delay(30, function()
				if v97 == n4 and u14 then
					loadNext()
				end
			end)

			return
		end

		local text: string = tostring(v93.err)

		if u13 then
			u13.setInfo("status", text)
		end
	elseif u13 then
		u13.setInfo("status", "No answer from the server. Press NEXT CASE to try again.")
	end
end

u25 = function(p24, p25)
	u15 = true
	n1 = os.clock() + 8

	local ok, result = pcall(function()
		return reviewRequest:InvokeServer(p24, p25)
	end)

	u15 = false
	n1 = os.clock() + 3

	if not ok then
		return nil
	end

	return result
end

local function vote(p26)
	if u17 and not u15 then
		setVotes(false)

		if u13 then
			u13.setInfo("status", "Saving your vote...")
		end

		local v104 = u25("vote", p26)

		if typeof(v104) ~= "table" or not v104.ok then
			local v105 = typeof(v104) == "table" and tostring(v104.err) or "Vote not saved. Try again."

			if u13 then
				u13.setInfo("status", v105)
			end

			setVotes(true)

			return
		end

		local text: string = tostring(v104.outcome)
		local u107: boolean = v104.mode ~= 2
		local t3: {[any]: any} = {
			cleared = "CAN'T TELL saved. Case closed for now.",
			already_decided = "Someone decided this case while you watched. Vote not counted.",
			already_voted = "You already voted on this case.",
			blatant = if u107 then "BLATANT saved (practice mode: nobody was banned)." else "BLATANT: banned.",
			sus = if u107 then "SUS: 3 mods agreed (practice mode: nobody was banned)." else "SUS: 3 mods agreed, banned."
		}

		v104 = t3[text]

		if not v104 then
			v104 = text:find("^sus ") and "SUS saved (" .. text:sub(5) .. " in a row)." or "Saved: " .. text
		end

		if u13 then
			u13.setInfo("status", v104)
		end

		task.wait(0.6)

		if u14 then
			loadNext()
		end
	elseif not u17 and u13 then
		u13.setInfo("status", "Watch a little more first; voting opens in a moment.")
	end
end
local function anotherClip()
	if u15 then
		return
	end

	if u13 then
		u13.setInfo("status", "Finding their next moment...")
	end

	local v109 = u25("clip")

	if typeof(v109) ~= "table" then
		if u13 then
			u13.setInfo("status", "No answer from the server.")
		end

		return
	end

	if not v109.ok then
		local text: string = tostring(v109.err)

		if u13 then
			u13.setInfo("status", text)
		end

		return
	end

	showClip(v109.clip)

	if typeof(v109.seek) == "table" then
		replayReviewControl:Fire("seek", v109.seek.startMs, v109.seek.endMs, v109.seek.followSlot)
	end

	if u13 then
		u13.setInfo("status", if u17 then "Next clip playing. Vote any time." else "Next clip playing.")
	end
end
local function keepWatching()
	replayReviewControl:Fire("keep")

	if u13 then
		u13.setInfo("status", "Playing on. Use the replay controls (Space pauses), or vote any time.")
	end
end
local function stop()
	u14 = false
	n4 += 1
	n2 += 1

	if u13 then
		u13.gui.Enabled = false
	end

	task.spawn(u25, "stop")
end
local function ensurePanel()
	if u13 then
		return true
	end

	u13 = build()

	if not u13 then
		return false
	end

	u13.info("case", "Case")
	u13.info("status", "")
	u13.header("YOUR CALL")
	u13.button("BLATANT", "Obvious: spinbot, kill-all, flying. 1 vote bans.", "BLATANT", function()
		vote("BLATANT")
	end)
	u13.button("SUS", "90%+ sure. Bans after 3 mods agree.", "SUS", function()
		vote("SUS")
	end)
	u13.button("CANTTELL", "Not sure, or looks legit.", "CAN'T TELL", function()
		vote("CANTTELL")
	end)
	u13.button("CLIP", "Their next suspicious moment.", "NEXT CLIP", anotherClip)
	u13.button("KEEP", "Keep playing past the clip.", "KEEP WATCHING", keepWatching)
	u13.button("SKIP", "Broken replay / nothing to judge.", "NEXT CASE", function()
		loadNext("skip")
	end)
	u13.button("STOP", "Done for now.", "STOP", stop)
	u13.info("why", "")

	if u13.closeButton and u13.closeButton:IsA("GuiButton") then
		u13.closeButton.MouseButton1Click:Connect(stop)
	end

	return true
end

reviewPush.OnClientEvent:Connect(function(p27)
	if typeof(p27) ~= "table" then
	elseif p27.open then
		if not ensurePanel() then
			warn("[ReviewController] could not build the review panel (HUD.SettingsWindow missing?)")

			return
		end

		u14 = true
		u13.gui.Enabled = true
		setVotes(false)
		loadNext()
	elseif p27.close then
		u14 = false
		n4 += 1
		n2 += 1

		if u13 then
			u13.gui.Enabled = false
		end
	end
end)
replayReviewState.Event:Connect(function(p28)
	if not u14 then
	elseif p28 == "clipEnded" then
		n2 += 1
		setVotes(true)

		if u13 then
			u13.setInfo("status", "Clip over. Vote, or NEXT CLIP / KEEP WATCHING.")

			return
		end
	elseif p28 == "closed" then
		if u15 or os.clock() < n1 then
			return
		end

		task.delay(1.5, function()
			if u14 and not u15 and os.clock() >= n1 then
				u14 = false
				n4 += 1
				n2 += 1

				if u13 then
					u13.gui.Enabled = false
				end

				task.spawn(u25, "stop")
			end
		end)
	end
end)
