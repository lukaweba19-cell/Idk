-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("TextService")

local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local killFeed_Push: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("KillFeed_Push")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

require(shared:WaitForChild("Rarity"))

local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local icons = require(replicatedStorageShared:WaitForChild("Icons"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local iconsKillTypes = icons.KillTypes

local function sameSide(p1, p2)
	if p1 and p2 then
		local matchSide = p1:GetAttribute("MatchSide")
		local matchSide2 = p2:GetAttribute("MatchSide")

		if typeof(matchSide) == "string" and typeof(matchSide2) == "string" then
			return matchSide == matchSide2
		end

		return false
	end

	return false
end
local function displayNameOf(p3)
	if p3:IsA("Player") then
		return p3.DisplayName
	end

	local displayName = p3:GetAttribute("DisplayName")

	return typeof(displayName) == "string" and displayName ~= "" and displayName or p3.Name
end

local t1: {[any]: any} = {
	bg = Color3.new(0.192, 0.647, 0.243),
	stroke = Color3.new(0.082, 0.439, 0.11),
	border = Color3.new(0.514, 0.839, 0.51)
}
local t2: {[any]: any} = {
	bg = Color3.new(0.749, 0.188, 0.188),
	stroke = Color3.new(0.675, 0.22, 0.22),
	border = Color3.new(0.839, 0.529, 0.529)
}

local function colorsForMe(p4)
	if not p4 then
		return t2
	end

	if p4 == LocalPlayer then
		return t1
	end

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

	if (not matchSide or matchSide == "") and typeof((LocalPlayer:GetAttribute("Spectating"))) == "number" and LocalPlayer:GetAttribute("Spectating") ~= 0 then
		return p4:GetAttribute("MatchSide") == "A" and t1 or t2
	end

	local v43: Player = LocalPlayer
	local u44

	if p4 and v43 then
		local matchSide3 = p4:GetAttribute("MatchSide")
		local matchSide4: any = v43:GetAttribute("MatchSide")

		u44 = if typeof(matchSide3) == "string" and typeof(matchSide4) == "string" then matchSide3 == matchSide4 else false
	else
		u44 = false
	end

	return u44 and t1 or t2
end
local function applyPlayerColors(p5, p6)
	local label = p5:FindFirstChild("Label")

	if not label then
		return
	end

	label.BackgroundColor3 = p6.bg

	local uiStroke = label:FindFirstChild("UIStroke")

	if uiStroke then
		uiStroke.Color = p6.stroke
	end

	local uiStrokeBorder = label:FindFirstChild("UIStrokeBorder")

	if uiStrokeBorder then
		uiStrokeBorder.Color = p6.border
	end
end
local function waitForUi()
	local globalKillFeed: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("GlobalKillFeed")

	globalKillFeed.ClipsDescendants = false
	globalKillFeed.Visible = true

	return globalKillFeed
end

local globalKillFeed: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("GlobalKillFeed")

globalKillFeed.ClipsDescendants = false
globalKillFeed.Visible = true

local killBarTemplate: Instance = globalKillFeed:WaitForChild("KillBarTemplate")

local function captureAlpha(p7)
	local t5: {[any]: any} = {
		bg = {},
		img = {},
		txt = {},
		stroke = {}
	}

	local function cap(p8)
		if p8:IsA("Frame") then
			t5.bg[p8] = p8.BackgroundTransparency

			return
		end

		if not p8:IsA("ImageLabel") and not p8:IsA("ImageButton") then
			if not p8:IsA("TextLabel") and not p8:IsA("TextButton") and not p8:IsA("TextBox") then
				if p8:IsA("UIStroke") then
					t5.stroke[p8] = p8.Transparency
				end

				return
			end

			t5.bg[p8] = p8.BackgroundTransparency
			t5.txt[p8] = p8.TextTransparency

			return
		end

		t5.bg[p8] = p8.BackgroundTransparency
		t5.img[p8] = p8.ImageTransparency
	end

	cap(p7)

	for _, v in ipairs(p7:GetDescendants()) do
		cap(v)
	end

	return t5
end
local function applyAlpha(p9, p10)
	for k, v in pairs(p9.bg) do
		if k.Parent then
			k.BackgroundTransparency = v + (1 - v) * p10
		end
	end

	for k, v in pairs(p9.img) do
		if k.Parent then
			k.ImageTransparency = v + (1 - v) * p10
		end
	end

	for k, v in pairs(p9.txt) do
		if k.Parent then
			k.TextTransparency = v + (1 - v) * p10
		end
	end

	for k, v in pairs(p9.stroke) do
		if k.Parent then
			k.Transparency = v + (1 - v) * p10
		end
	end
end
local function getOrMakeScale(parent)
	local __uiScale = parent:FindFirstChild("__UIScale")

	if __uiScale and __uiScale:IsA("UIScale") then
		return __uiScale
	end

	local __uiScale: UIScale = Instance.new("UIScale")

	__uiScale.Name = "__UIScale"
	__uiScale.Scale = 1
	__uiScale.Parent = parent

	return __uiScale
end
local function popIn(parent)
	local v72 = captureAlpha(parent)

	applyAlpha(v72, 1)

	local v73 = parent.Position

	parent.Position = v73 + UDim2.new(0, 18, 0, 0)
	parent.Visible = true

	local __uiScale = parent:FindFirstChild("__UIScale")

	if not __uiScale or not __uiScale:IsA("UIScale") then
		__uiScale = Instance.new("UIScale")
		__uiScale.Name = "__UIScale"
		__uiScale.Scale = 1
		__uiScale.Parent = parent
	end

	__uiScale.Scale = 0.92

	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(parent, tweenInfo, { Position = v73 }):Play()

	local tweenInfo2 = TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	v73 = tweenService:Create(__uiScale, tweenInfo2, { Scale = 1.12 })

	local tweenInfo3 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v78: Tween = tweenService:Create(__uiScale, tweenInfo3, { Scale = 1 })

	v73:Play()
	v73.Completed:Connect(function()
		if __uiScale.Parent then
			v78:Play()
		end
	end)

	local v79 = os.clock()

	task.spawn(function()
		while parent.Parent do
			local v169 = os.clock()
			local v170 = math.clamp((v169 - v79) / 0.14, 0, 1)

			applyAlpha(v72, 1 - v170)

			if v170 >= 1 then
				break
			end

			task.wait()
		end
	end)
end
local function measureTextWidth(p13)
	runService.Heartbeat:Wait()

	return p13.TextBounds.X
end
local function resizeNameFrame(p14)
	local label = p14:FindFirstChild("Label")

	if not label then
		return
	end

	runService.Heartbeat:Wait()

	local v83 = p14.Parent and p14.Parent.AbsoluteSize.X or 300

	if v83 <= 0 then
		v83 = 300
	end

	local v84 = math.clamp((label.TextBounds.X + 12 + 6) / v83, 0.2, 1)

	p14.Size = UDim2.new(v84, 0, 1, 0)
end

local t3: {[any]: any} = { "Headshot", "Backstab", "Longshot" }

local function hasType(p15, p16)
	for _, v in ipairs(p15) do
		if typeof(v) ~= "table" or typeof(v.id) ~= "string" then
			if typeof(v) == "string" and v == p16 then
				return true
			end
		elseif p16 == v.id then
			return true
		end
	end

	return false
end
local function populateWeaponSlot(p17, p18, p19)
	for _, v in ipairs(p17:GetChildren()) do
		if v.Name == "WeaponTile" then
			v:Destroy()
		end
	end

	if p18 == "" then
		return
	end

	local uiFrameworkCreateItemCell = uiFramework.createItemCell
	local v95 = UDim2.fromScale(1, 1)
	local v96, v97 = uiFrameworkCreateItemCell(p19, {
		name = "WeaponTile",
		interactable = false,
		selectable = false,
		active = false,
		icon = p18,
		size = v95,
		parent = p17
	})

	v96.Visible = true
end

local t4: {[any]: any} = {}

local function trimMaxRows()
	while #t4 > 7 do
		local v98 = table.remove(t4, 1)

		if v98 and v98.ui and v98.ui.Parent then
			local v99 = captureAlpha(v98.ui)
			local v100 = os.clock()

			task.spawn(function()
				while v98.ui.Parent do
					local v171 = os.clock()
					local v172 = math.clamp((v171 - v100) / 0.16, 0, 1)

					applyAlpha(v99, v172)

					if v172 >= 1 then
						break
					end

					task.wait()
				end

				if v98.ui.Parent then
					v98.ui:Destroy()
				end
			end)
		end
	end
end
local function spawnRow(p20)
	local v102 = nil
	local killer = p20.killer
	local u104: boolean = false
	local v105
	local matchId

	if typeof(killer) == "Instance" then
		if killer:IsA("Player") then
			v105 = killer.DisplayName
		else
			local displayName = killer:GetAttribute("DisplayName")

			v105 = typeof(displayName) == "string" and displayName ~= "" and displayName or killer.Name
		end

		v102 = killer
		matchId = killer:GetAttribute("MatchId")
	else
		if typeof(killer) ~= "table" then
			return
		end

		v105 = killer.Name
		matchId = killer.MatchId

		if killer.Model and killer.Model:GetAttribute("MatchSide") == LocalPlayer:GetAttribute("MatchSide") then
			u104 = true
		end
	end

	local u108: boolean = p20.replayResolved == true
	local matchId2: any = LocalPlayer:GetAttribute("MatchId")
	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local v111 = typeof(spectating) == "number" and spectating ~= 0 and players:GetPlayerByUserId(spectating) or nil
	local v112 = v111 and v111:GetAttribute("MatchId") or nil
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if matchId2 == matchId or v112 == matchId or lobbySpectateMatchId == matchId then
		local victim = p20.victim

		if typeof(victim) == "table" and typeof(victim.name) == "string" then
			local victimName = victim.name
			local u116: boolean = false
			local foundChild

			if u108 then
				foundChild = typeof(p20.victimRef) == "Instance" and p20.victimRef or nil
			else
				foundChild = players:FindFirstChild(victimName)

				if not foundChild then
					for _, v in pairs(workspace.Characters:GetChildren()) do
						if v:IsA("Model") and victimName == v.Name and v:GetAttribute("MatchId") == LocalPlayer:GetAttribute("MatchId") and v:GetAttribute("MatchSide") == LocalPlayer:GetAttribute("MatchSide") then
							u116 = true

							break
						end
					end
				end
			end

			local t6 = p20.types

			if typeof(t6) ~= "table" then
				t6 = {}
			end

			local assister = nil

			if typeof(p20.assister) == "Instance" then
				assister = p20.assister
			end

			local v122 = typeof(p20.weaponIcon) == "string" and p20.weaponIcon or ""
			local v123 = typeof(p20.weaponRarity) == "string" and p20.weaponRarity or "Common"
			local clone: Instance = killBarTemplate:Clone()

			clone.Name = "KillBar_" .. v105
			clone.Visible = true
			clone.Parent = globalKillFeed

			local killerFrame: Instance = clone:FindFirstChild("KillerFrame")

			if killerFrame then
				local label: Instance = killerFrame:FindFirstChild("Label")

				if label then
					local v127

					if v102 then
						if v102:IsA("Player") then
							v127 = v102.DisplayName
						else
							local displayName = v102:GetAttribute("DisplayName")

							v127 = typeof(displayName) == "string" and displayName ~= "" and displayName or v102.Name
						end

						if not v127 then
							v127 = v105
						end
					else
						v127 = v105
					end

					label.Text = v127
				end

				local v129 = colorsForMe(u104 and LocalPlayer or v102)
				local label2: Instance = killerFrame:FindFirstChild("Label")

				if label2 then
					label2.BackgroundColor3 = v129.bg

					local uiStroke: Instance = label2:FindFirstChild("UIStroke")

					if uiStroke then
						uiStroke.Color = v129.stroke
					end

					local uiStrokeBorder: Instance = label2:FindFirstChild("UIStrokeBorder")

					if uiStrokeBorder then
						uiStrokeBorder.Color = v129.border
					end
				end
			end

			local u133: boolean = p20.selfElim == true
			local killedFrame: Instance = clone:FindFirstChild("KilledFrame")

			if killedFrame then
				local label: Instance = killedFrame:FindFirstChild("Label")

				if label then
					local v136

					if foundChild then
						if foundChild:IsA("Player") then
							v136 = foundChild.DisplayName
						else
							local displayName = foundChild:GetAttribute("DisplayName")

							v136 = typeof(displayName) == "string" and displayName ~= "" and displayName or foundChild.Name
						end

						if not v136 then
							v136 = victimName
						end
					else
						v136 = victimName
					end

					label.Text = v136
				end

				local v138 = colorsForMe(u116 and LocalPlayer or foundChild)
				local label3: Instance = killedFrame:FindFirstChild("Label")

				if label3 then
					label3.BackgroundColor3 = v138.bg

					local uiStroke: Instance = label3:FindFirstChild("UIStroke")

					if uiStroke then
						uiStroke.Color = v138.stroke
					end

					local uiStrokeBorder: Instance = label3:FindFirstChild("UIStrokeBorder")

					if uiStrokeBorder then
						uiStrokeBorder.Color = v138.border
					end
				end
			end

			local plusFrame: Instance = clone:FindFirstChild("PlusFrame")
			local killerAssistFrame: Instance = clone:FindFirstChild("KillerAssistFrame")

			if assister then
				if plusFrame then
					plusFrame.Visible = true
				end

				if killerAssistFrame then
					killerAssistFrame.Visible = true

					local label: Instance = killerAssistFrame:FindFirstChild("Label")

					if label then
						local v145

						if assister:IsA("Player") then
							v145 = assister.DisplayName
						else
							local displayName = assister:GetAttribute("DisplayName")

							v145 = typeof(displayName) == "string" and displayName ~= "" and displayName or assister.Name
						end

						label.Text = v145
					end

					local v147 = colorsForMe(assister)
					local label4: Instance = killerAssistFrame:FindFirstChild("Label")

					if label4 then
						label4.BackgroundColor3 = v147.bg

						local uiStroke: Instance = label4:FindFirstChild("UIStroke")

						if uiStroke then
							uiStroke.Color = v147.stroke
						end

						local uiStrokeBorder: Instance = label4:FindFirstChild("UIStrokeBorder")

						if uiStrokeBorder then
							uiStrokeBorder.Color = v147.border
						end
					end
				end
			else
				if plusFrame then
					plusFrame.Visible = false
				end

				if killerAssistFrame then
					killerAssistFrame.Visible = false
				end
			end

			local slot: Instance = clone:FindFirstChild("SLOT")

			if slot then
				if u133 then
					slot.Visible = false
				else
					slot.Visible = true
					populateWeaponSlot(slot, v122, v123)
				end
			end

			local killTypeIcon: Instance = clone:FindFirstChild("KillTypeIcon")
			local t7: {[any]: any} = {}

			for _, v in ipairs(t3) do
				if hasType(t6, v) then
					table.insert(t7, v)
				end
			end

			if not u133 then
				if #t7 ~= 0 then
					if #t7 ~= 1 then
						if killTypeIcon then
							killTypeIcon.Image = iconsKillTypes[t7[1]] or ""
							killTypeIcon.Visible = true

							for i = 2, #t7 do
								local clone2: Instance = killTypeIcon:Clone()

								clone2.Image = iconsKillTypes[t7[i]] or ""
								clone2.LayoutOrder = killTypeIcon.LayoutOrder + i - 1
								clone2.Parent = clone
							end
						end
					elseif killTypeIcon then
						killTypeIcon.Image = iconsKillTypes[t7[1]] or ""
						killTypeIcon.Visible = true
					end
				elseif killTypeIcon then
					killTypeIcon:Destroy()
				end
			elseif killTypeIcon then
				killTypeIcon.Image = iconsKillTypes.Kill or killTypeIcon.Image
				killTypeIcon.Visible = true
			end

			if killerFrame then
				resizeNameFrame(killerFrame)
			end

			if killedFrame then
				resizeNameFrame(killedFrame)
			end

			if assister and killerAssistFrame then
				resizeNameFrame(killerAssistFrame)
			end

			popIn(clone)

			local v158 = os.clock()

			table.insert(t4, { ui = clone, expiresAt = v158 + 4 })
			trimMaxRows()

			return
		end

		return
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)

		local v159 = os.clock()

		for i = #t4, 1, -1 do
			local v161 = t4[i]

			if not v161.ui or not v161.ui.Parent then
				table.remove(t4, i)
			elseif v159 >= v161.expiresAt then
				table.remove(t4, i)

				local ui = v161.ui
				local v163 = captureAlpha(ui)
				local uiPosition = ui.Position
				local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

				tweenService:Create(ui, tweenInfo, { Position = uiPosition + UDim2.new(0, 18, 0, 0) }):Play()

				local v166 = os.clock()

				task.spawn(function()
					while ui.Parent do
						local v173 = os.clock()
						local v174 = math.clamp((v173 - v166) / 0.18, 0, 1)

						applyAlpha(v163, v174)

						if v174 >= 1 then
							break
						end

						task.wait()
					end

					if ui.Parent then
						ui:Destroy()
					end
				end)
			end
		end

		continue
	end
end)

local function handleGlobalKillFeed(p21)
	if typeof(p21) ~= "table" then
		return
	end

	if not p21.killer then
		return
	end

	spawnRow(p21)
end

killFeed_Push.OnClientEvent:Connect(handleGlobalKillFeed)

local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")

bindables = bindables and bindables:FindFirstChild("ReplayGlobalKillFeed")

if bindables and bindables:IsA("BindableEvent") then
	bindables.Event:Connect(handleGlobalKillFeed)
end
