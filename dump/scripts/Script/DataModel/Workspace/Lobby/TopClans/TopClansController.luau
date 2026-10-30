-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local scriptParent: Instance = script.Parent
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local clanImage = require(shared:WaitForChild("ClanImage"))
local commas = require(shared:WaitForChild("ClanRosterUI")).commas
local requestClanView: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("RequestClanView")
local u7 = nil
local t1 = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}

local function titleFor(p1)
	local text: string = tostring(p1.Name or "Clan")
	local text2: string = tostring(p1.DisplayTag or "")

	if text2 == "" or text2 == text then
		return text
	end

	return text .. " [" .. text2 .. "]"
end
local function statLabel(p2, p3)
	local foundChild = p2:FindFirstChild(p3)
	local roundedBox = foundChild and foundChild:FindFirstChild("RoundedBox")
	local v23 = roundedBox

	if v23 then
		v23 = roundedBox:FindFirstChild("StatText")
	end

	if v23 and v23:IsA("TextLabel") then
		return v23
	end

	return nil
end
local function bindPrompt(p4, p5)
	if t3[p4] then
		return
	end

	t3[p4] = true
	p4.Triggered:Connect(function()
		local v53 = t2[p5]

		if v53 then
			requestClanView:Fire({ clanId = v53 })
		end
	end)
end
local function apply()
	local guiParts: Instance = scriptParent:FindFirstChild("GuiParts")

	for i = 1, 5 do
		local v28 = t1[i]
		local v29: Instance = guiParts and guiParts:FindFirstChild("Place" .. i)
		local billboardGui: Instance = v29 and v29:FindFirstChildWhichIsA("BillboardGui")

		if billboardGui then
			billboardGui.Enabled = v28 ~= nil

			local v31 = v28

			if v31 then
				v31 = billboardGui:FindFirstChild("Background")
			end

			if v31 then
				local title = v31:FindFirstChild("Title")

				if title and title:IsA("TextLabel") then
					local text: string = tostring(v28.Name or "Clan")
					local text3: string = tostring(v28.DisplayTag or "")

					title.Text = if text3 == "" or text3 == text then text else text .. " [" .. text3 .. "]"
				end

				local leftStatBox = v31:FindFirstChild("LeftStatBox")
				local roundedBox = leftStatBox and leftStatBox:FindFirstChild("RoundedBox")
				local v37 = roundedBox

				if v37 then
					v37 = roundedBox:FindFirstChild("StatText")
				end

				local v38 = if v37 and v37:IsA("TextLabel") then v37 else nil

				if v38 then
					v38.Text = commas(v28.Kills or 0)
				end

				local rightStatBox = v31:FindFirstChild("RightStatBox")
				local rightStatBoxRoundedBox = rightStatBox and rightStatBox:FindFirstChild("RoundedBox")

				v37 = rightStatBoxRoundedBox

				if v37 then
					v37 = rightStatBoxRoundedBox:FindFirstChild("StatText")
				end

				v38 = if v37 and v37:IsA("TextLabel") then v37 else nil

				if v38 then
					v38.Text = commas(v28.Streak or 0)
				end
			end
		end

		local foundChild: Instance = scriptParent:FindFirstChild("Group" .. i)

		if foundChild then
			local img: Instance = foundChild:FindFirstChild("Img")
			local clanEmblem: Instance = img and img:FindFirstChild("ClanEmblem")

			if clanEmblem and clanEmblem:IsA("SurfaceGui") then
				clanEmblem.Enabled = v28 ~= nil

				local emblem: Instance = clanEmblem:FindFirstChild("Emblem")

				if v28 and emblem and emblem:IsA("ImageLabel") and emblem:GetAttribute("PodiumClanId") ~= v28.ClanId then
					emblem:SetAttribute("PodiumClanId", v28.ClanId)
					clanImage.apply(emblem, v28.ImageId)
				end
			end

			local viewClanProximityPart: Instance = foundChild:FindFirstChild("ViewClanProximityPart")
			local proximityPrompt: Instance = viewClanProximityPart and viewClanProximityPart:FindFirstChildWhichIsA("ProximityPrompt")

			if not proximityPrompt then
				continue
			end

			if not t3[proximityPrompt] then
				t3[proximityPrompt] = true
				proximityPrompt.Triggered:Connect(function()
					local v54 = t2[i]

					if v54 then
						requestClanView:Fire({ clanId = v54 })
					end
				end)
			end

			t2[i] = v28 and v28.ClanId or nil
			proximityPrompt.ObjectText = v28 and tostring(v28.Name or "") or ""
			proximityPrompt.Enabled = v28 ~= nil
		end
	end
end
local function fetchOnce()
	local v47 = u7

	if not v47 then
		return false
	end

	local ok, result = pcall(function()
		return v47:InvokeServer("GetPodium")
	end)

	if ok and typeof(result) == "table" then
		t1 = result
		apply()

		return #result > 0
	end

	return false
end

task.spawn(function()
	apply()

	local remotes: Instance = replicatedStorage:WaitForChild("Remotes", 30)
	local clanLeaderboard: Instance = remotes and remotes:WaitForChild("ClanLeaderboard", 30)

	if clanLeaderboard and clanLeaderboard:IsA("RemoteFunction") then
		u7 = clanLeaderboard

		local n1: number = 0

		while true do
			if not not fetchOnce() or not (n1 < 8) then
				break
			end

			n1 += 1
			task.wait(15)
		end

		task.spawn(function()
			while true do
				task.wait(10)
				apply()
			end
		end)

		while true do
			task.wait(180)
			fetchOnce()
		end
	end

	warn("[TopClans] ClanLeaderboard remote unavailable; podium left empty")
end)
