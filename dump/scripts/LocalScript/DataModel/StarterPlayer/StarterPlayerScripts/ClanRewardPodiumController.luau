-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local clanRewardPeriod = require(shared:WaitForChild("ClanRewardPeriod"))
local eventTimer = require(shared:WaitForChild("EventTimer"))
local weaponRigUtil = require(shared:WaitForChild("WeaponRigUtil"))
local u6 = nil
local t1 = {}
local t2: {[any]: any} = {}

local function currentPodium()
	local lobby: Instance = workspace:FindFirstChild("Lobby")

	return lobby and lobby:FindFirstChild("TopClansPodium")
end
local function timerLabel(p1)
	local beam = p1:FindFirstChild("beam")
	local part = beam and beam:FindFirstChild("Part")
	local v21 = part

	if v21 then
		v21 = part:FindFirstChildWhichIsA("BillboardGui")
	end

	local background = v21 and v21:FindFirstChild("Background")

	v21 = background

	if v21 then
		v21 = background:FindFirstChild("ResetTimer")
	end

	if v21 and v21:IsA("TextLabel") then
		return v21
	end

	return nil
end
local function renderCountdown(p2, p3)
	local v25 = t2[p2]

	if v25 == nil then
		v25 = p2.Text
		t2[p2] = v25
	end

	local v26 = eventTimer.formatWeeks(p3)
	local v27, v28, v29, v30, v31 = v25:match("^(.-)(<font[^>]*>)(.-)(</font>)(.*)$")

	if v28 then
		p2.Text = v27 .. v28 .. v26 .. v30 .. v31

		return
	end

	p2.Text = "Resets in " .. v26
end

local t3: {[any]: any} = { "ClanTag", "ClanRank", "ClanName" }

local function displayRow()
	for _, v in ipairs(t1) do
		local vRank = v.Rank

		if typeof(vRank) == "number" and vRank <= clanRewardPeriod.TOP_CLANS and (v.Kills or 0) >= clanRewardPeriod.MIN_KILLS then
			return v
		end
	end

	return nil
end
local function applyWeapons(p4)
	local weapons = p4:FindFirstChild("Weapons")

	if not weapons then
		return
	end

	local v37 = displayRow()

	for _, v in ipairs(weapons:GetChildren()) do
		if v:IsA("Model") then
			if v37 then
				local text: string = tostring(v37.DisplayTag or v37.Tag or "")

				v:SetAttribute("ClanTag", text)
				v:SetAttribute("ClanRank", v37.Rank)

				local text2: string = tostring(v37.Name or "")

				v:SetAttribute("ClanName", text2)
			else
				for _, iterValue in ipairs(t3) do
					v:SetAttribute(iterValue, nil)
				end
			end

			weaponRigUtil.ApplyClanLabels(v, v)
		end
	end
end
local function apply()
	local lobby: Instance = workspace:FindFirstChild("Lobby")
	local v45: Instance = lobby

	if v45 then
		v45 = lobby:FindFirstChild("TopClansPodium")
	end

	if not v45 then
		return
	end

	local v46 = timerLabel(v45)

	if v46 then
		local v47 = clanRewardPeriod.SecondsUntilReset()
		local v48 = t2[v46]

		if v48 == nil then
			v48 = v46.Text
			t2[v46] = v48
		end

		local v49 = eventTimer.formatWeeks(v47)
		local v50, v51, v52, v53, v54 = v48:match("^(.-)(<font[^>]*>)(.-)(</font>)(.*)$")

		if v51 then
			v46.Text = v50 .. v51 .. v49 .. v53 .. v54
		else
			v46.Text = "Resets in " .. v49
		end
	end

	applyWeapons(v45)
end
local function fetchOnce()
	local v55 = u6

	if not v55 then
		return false
	end

	local ok, result = pcall(function()
		return v55:InvokeServer("GetPodium")
	end)

	if ok and typeof(result) == "table" then
		t1 = result

		local lobby: Instance = workspace:FindFirstChild("Lobby")
		local v59: Instance = lobby

		if v59 then
			v59 = lobby:FindFirstChild("TopClansPodium")
		end

		if v59 then
			local v60 = timerLabel(v59)

			if v60 then
				local v61 = clanRewardPeriod.SecondsUntilReset()
				local v62 = t2[v60]

				if v62 == nil then
					v62 = v60.Text
					t2[v60] = v62
				end

				local v63 = eventTimer.formatWeeks(v61)
				local v64, v65, v66, v67, v68 = v62:match("^(.-)(<font[^>]*>)(.-)(</font>)(.*)$")

				if v65 then
					v60.Text = v64 .. v65 .. v63 .. v67 .. v68
				else
					v60.Text = "Resets in " .. v63
				end
			end

			applyWeapons(v59)
		end

		return #result > 0
	end

	return false
end

task.spawn(function()
	local lobby: Instance = workspace:FindFirstChild("Lobby")
	local v70: Instance = lobby

	if v70 then
		v70 = lobby:FindFirstChild("TopClansPodium")
	end

	if v70 then
		local v71 = timerLabel(v70)

		if v71 then
			local v72 = clanRewardPeriod.SecondsUntilReset()
			local v73 = t2[v71]

			if v73 == nil then
				v73 = v71.Text
				t2[v71] = v73
			end

			local v74 = eventTimer.formatWeeks(v72)
			local v75, v76, v77, v78, v79 = v73:match("^(.-)(<font[^>]*>)(.-)(</font>)(.*)$")

			if v76 then
				v71.Text = v75 .. v76 .. v74 .. v78 .. v79
			else
				v71.Text = "Resets in " .. v74
			end
		end

		applyWeapons(v70)
	end

	task.spawn(function()
		local lobby2
		local v84
		local topClansPodium
		local v86
		local v87
		local v88
		local v89
		local v90
		local v91
		local v92
		local v93
		local v94

		while true do
			task.wait(1)
			lobby2 = workspace:FindFirstChild("Lobby")
			v84 = lobby2

			if v84 then
				topClansPodium = lobby2:FindFirstChild("TopClansPodium")
				v84 = topClansPodium
			end

			if not v84 then
			else
				v86 = timerLabel(v84)

				if v86 then
					v87 = clanRewardPeriod.SecondsUntilReset()
					v88 = t2[v86]

					if v88 == nil then
						v88 = v86.Text
						t2[v86] = v88
					end

					v89 = eventTimer.formatWeeks(v87)
					v90, v91, v92, v93, v94 = v88:match("^(.-)(<font[^>]*>)(.-)(</font>)(.*)$")

					if v91 then
						v86.Text = v90 .. v91 .. v89 .. v93 .. v94
					else
						v86.Text = "Resets in " .. v89
					end
				end

				applyWeapons(v84)
			end

			continue
		end
	end)

	local remotes: Instance = replicatedStorage:WaitForChild("Remotes", 30)
	local clanLeaderboard: Instance = remotes and remotes:WaitForChild("ClanLeaderboard", 30)

	if clanLeaderboard and clanLeaderboard:IsA("RemoteFunction") then
		u6 = clanLeaderboard

		local n1: number = 0

		while true do
			if not not fetchOnce() or not (n1 < 8) then
				break
			end

			n1 += 1
			task.wait(15)
		end

		while true do
			task.wait(180)
			fetchOnce()
		end
	end

	warn("[ClanRewardPodium] ClanLeaderboard remote unavailable; weapons left blank")
end)
