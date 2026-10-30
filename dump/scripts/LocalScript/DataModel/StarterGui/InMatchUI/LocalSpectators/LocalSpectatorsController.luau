-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local amount: Instance = scriptParent:WaitForChild("Frame"):WaitForChild("Amount")

scriptParent.Visible = false

local function aliveAndPlaying()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" then
		if LocalPlayer:GetAttribute("Alive") == false then
			return false
		end

		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		if typeof(spectating) == "number" and spectating ~= 0 then
			return false
		end

		return true
	end

	return false
end
local function countSpectatingMe()
	local localPlayerUserId = LocalPlayer.UserId
	local n1: number = 0

	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer and localPlayerUserId == v:GetAttribute("Spectating") then
			n1 += 1
		end
	end

	return n1
end
local function refresh()
	if not aliveAndPlaying() then
		scriptParent.Visible = false

		return
	end

	local v19 = countSpectatingMe()

	if v19 > 0 then
		amount.Text = tostring(v19)
		scriptParent.Visible = true

		return
	end

	scriptParent.Visible = false
end

local t1: {[any]: any} = {}

local function trackPlayer(p1)
	if t1[p1] then
		return
	end

	t1[p1] = p1:GetAttributeChangedSignal("Spectating"):Connect(refresh)
end

for _, v in ipairs(players:GetPlayers()) do
	if not t1[v] then
		t1[v] = v:GetAttributeChangedSignal("Spectating"):Connect(refresh)
	end
end

players.PlayerAdded:Connect(function(player: Player)
	if not t1[player] then
		t1[player] = player:GetAttributeChangedSignal("Spectating"):Connect(refresh)
	end

	if not aliveAndPlaying() then
		scriptParent.Visible = false

		return
	end

	local v22 = countSpectatingMe()

	if v22 > 0 then
		amount.Text = tostring(v22)
		scriptParent.Visible = true

		return
	end

	scriptParent.Visible = false
end)
players.PlayerRemoving:Connect(function(player: Player)
	local v24 = t1[player]

	if v24 then
		v24:Disconnect()
		t1[player] = nil
	end

	if not aliveAndPlaying() then
		scriptParent.Visible = false

		return
	end

	v24 = countSpectatingMe()

	if v24 > 0 then
		amount.Text = tostring(v24)
		scriptParent.Visible = true

		return
	end

	scriptParent.Visible = false
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(refresh)
LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(refresh)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(refresh)

if not aliveAndPlaying() then
	scriptParent.Visible = false

	return
end

local v12 = countSpectatingMe()

if v12 > 0 then
	amount.Text = tostring(v12)
	scriptParent.Visible = true

	return
end

scriptParent.Visible = false
