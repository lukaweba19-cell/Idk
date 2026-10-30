-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = players.LocalPlayer
local scriptParent: Instance = script.Parent
local mapImage: Instance = scriptParent:WaitForChild("MapImage")
local statusLabel: Instance = scriptParent:WaitForChild("Footer"):WaitForChild("StatusLabel")
local mapName: Instance = scriptParent:WaitForChild("VoteResult"):WaitForChild("MapName")

scriptParent.Visible = false

local v8 = replicatedStorage:WaitForChild("MatchRemotes"):WaitForChild("State")
local t1: {[any]: any} = {}
local winner = nil
local u11 = nil
local u12 = nil
local u13: boolean = false
local u14 = nil

local function isMyMatch(p1)
	local matchId = LocalPlayer:GetAttribute("MatchId")
	local u29: boolean = false

	if typeof(matchId) == "string" then
		u29 = false

		if matchId == p1 then
			u29 = matchId ~= "PRACTICE"
		end
	end

	return u29
end
local function parseFriendlyFromRenamed(p2)
	if typeof(p2) == "string" then
		return string.match(p2, "^MatchMap_(.+)_%d+_%d+$")
	end

	return nil
end
local function updateStatusLabel()
	if not scriptParent.Visible then
		return
	end

	if not u13 then
		return
	end

	local v31 = u14

	if v31 then
		statusLabel.Text = string.format("Waiting for players to load (%d/%d)", v31.loaded, v31.total)

		return
	end

	statusLabel.Text = "Waiting for players to load..."
end
local function reset()
	u12 = nil
	u13 = false
	u14 = nil
end
local function hide()
	scriptParent.Visible = false
	u12 = nil
	u13 = false
	u14 = nil
end
local function tryDismiss()
	if not scriptParent.Visible then
		return
	end

	if not u13 then
		return
	end

	local v32 = u14

	if not v32 then
	elseif v32.complete or v32.loaded >= v32.total then
		scriptParent.Visible = false
		u12 = nil
		u13 = false
		u14 = nil
	end
end
local function runLocalAssetLoad(p3, childName)
	local game: Instance = workspace:WaitForChild("Game", 10)

	if game and p3 == u12 then
		local v36: Instance = game:WaitForChild(childName, 10)

		if v36 and p3 == u12 then
			local descendantCount = v36:GetAttribute("DescendantCount")

			if typeof(descendantCount) ~= "number" or descendantCount <= 0 then
				local descendants = v36:GetDescendants()

				descendantCount = math.max(1, #descendants)
			end

			local v39 = os.clock()

			while p3 == u12 and os.clock() - v39 < 20 do
				local n1: number = #v36:GetDescendants()
				local v41 = math.min(n1, descendantCount)

				statusLabel.Text = string.format("Loading assets... (%d/%d)", v41, descendantCount)

				if n1 >= descendantCount * 0.99 then
					break
				end

				task.wait(0.1)
			end

			u13 = true

			return
		end

		u13 = true

		return
	end

	u13 = true
end
local function onMapVoteStart(p5, p6)
	u11 = p5

	if typeof(p6.options) == "table" then
		for _, v in ipairs(p6.options) do
			if typeof(v) == "table" and typeof(v.name) == "string" and typeof(v.image) == "string" then
				t1[v.name] = v.image
			end
		end

		return
	end
end
local function onMapVoteEnd(p7, p8)
	if p8.aborted == true then
		u11 = nil
		winner = nil

		return
	end

	if typeof(p8.winner) == "string" then
		winner = p8.winner
	end

	if p7 ~= u11 then
		return
	end

	local text = winner or ""

	if text == "" then
		return
	end

	mapName.Text = text

	local image = t1[text]

	if typeof(image) == "string" and image ~= "" then
		mapImage.Image = image
	end

	statusLabel.Text = "Loading assets..."
	scriptParent.Visible = true
	u12 = p7
	u13 = false
	u14 = nil
end
local function onMatchStarted(p9, p10)
	local matchId = LocalPlayer:GetAttribute("MatchId")
	local u53 = false

	if typeof(matchId) == "string" then
		u53 = false

		if matchId == p9 then
			u53 = matchId ~= "PRACTICE"
		end
	end

	if not u53 then
		return
	end

	u53 = winner
	winner = nil

	if not u53 or u53 == "" then
		local mapName2 = p10.mapName

		u53 = if typeof(mapName2) == "string" then string.match(mapName2, "^MatchMap_(.+)_%d+_%d+$") else nil
	end

	if not u53 then
		u53 = ""
	end

	local v55 = typeof(p10.mapName) == "string" and p10.mapName or ""

	u12 = p9
	u13 = false
	u14 = nil
	mapName.Text = u53

	local v56 = t1[u53]

	if typeof(v56) ~= "string" or v56 == "" then
		v56 = p10.mapImage
	end

	if typeof(v56) == "string" and v56 ~= "" then
		mapImage.Image = v56
	end

	statusLabel.Text = "Loading assets..."
	scriptParent.Visible = true
	task.spawn(function()
		runLocalAssetLoad(p9, v55)

		if u12 == p9 then
			if scriptParent.Visible and u13 then
				local v65 = u14

				if v65 then
					statusLabel.Text = string.format("Waiting for players to load (%d/%d)", v65.loaded, v65.total)
				else
					statusLabel.Text = "Waiting for players to load..."
				end
			end

			if not scriptParent.Visible then
				return
			end

			if not u13 then
				return
			end

			local v66 = u14

			if not v66 then
			elseif v66.complete or v66.loaded >= v66.total then
				scriptParent.Visible = false
				u12 = nil
				u13 = false
				u14 = nil
			end

			return
		end
	end)
end
local function onClientLoadProgress(p11, p12)
	if p11 ~= u12 then
		return
	end

	u14 = {
		loaded = typeof(p12.loaded) == "number" and p12.loaded or 0,
		total = typeof(p12.total) == "number" and p12.total or 0,
		complete = p12.complete == true
	}

	if scriptParent.Visible and u13 then
		local v59 = u14

		if v59 then
			statusLabel.Text = string.format("Waiting for players to load (%d/%d)", v59.loaded, v59.total)
		else
			statusLabel.Text = "Waiting for players to load..."
		end
	end

	if not scriptParent.Visible then
		return
	end

	if not u13 then
		return
	end

	local v60 = u14

	if not v60 then
	elseif v60.complete or v60.loaded >= v60.total then
		scriptParent.Visible = false
		u12 = nil
		u13 = false
		u14 = nil
	end
end
local function onMatchEnded(p13)
	if p13 == u12 then
		scriptParent.Visible = false
		u12 = nil
		u13 = false
		u14 = nil
	end
end

v8.OnClientEvent:Connect(function(p14, p15)
	if typeof(p15) == "table" then
		local t = p15.t

		if t == "MapVoteStart" then
			onMapVoteStart(p14, p15)
		elseif t == "MapVoteEnd" then
			onMapVoteEnd(p14, p15)
		elseif t == "MatchStarted" then
			onMatchStarted(p14, p15)
		elseif t == "ClientLoadProgress" then
			onClientLoadProgress(p14, p15)
		elseif t == "MatchEnded" and p14 == u12 then
			scriptParent.Visible = false
			u12 = nil
			u13 = false
			u14 = nil
		end

		return
	end
end)
LocalPlayer.CharacterAdded:Connect(function()
	if scriptParent.Visible then
		scriptParent.Visible = false
		u12 = nil
		u13 = false
		u14 = nil
	end
end)
