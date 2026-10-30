-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local module: {[any]: any} = {}

module.__index = module

local parent = replicatedStorage:FindFirstChild("Game") or Instance.new("Folder")

parent.Name = "Game"
parent.Parent = replicatedStorage

local remotes = parent:FindFirstChild("Remotes")

if not remotes then
	remotes = Instance.new("Folder")
end

remotes.Name = "Remotes"
remotes.Parent = parent

local pingRF = remotes:FindFirstChild("PingRF")

if not pingRF then
	pingRF = Instance.new("RemoteFunction")
	pingRF.Name = "PingRF"
	pingRF.Parent = remotes
end

local pingHeartbeat = remotes:FindFirstChild("PingHeartbeat")

if not pingHeartbeat then
	pingHeartbeat = Instance.new("RemoteEvent")
	pingHeartbeat.Name = "PingHeartbeat"
	pingHeartbeat.Parent = remotes
end

if runService:IsServer() then
	local t2: {[any]: any} = {}

	function pingRF.OnServerInvoke(_)
		return workspace:GetServerTimeNow()
	end

	pingHeartbeat.OnServerEvent:Connect(function(p2, _)
		local v20 = os.clock()
		local v21 = t2[p2]

		if not v21 then
			return
		end

		if v20 - v21.lastHeartbeatTime > 2 and v20 - v21.joinTime > 3 then
			v21.spikeUntil = v20 + 3
		end

		v21.lastHeartbeatTime = v20

		local networkPing = p2:GetNetworkPing()

		v21.smoothedRTT = v21.smoothedRTT * 0.7 + 0.3 * (networkPing * 2)
	end)
	players.PlayerAdded:Connect(function(player: Player)
		local v24 = os.clock()
		local v25 = os.clock()

		t2[player] = {
			smoothedRTT = 0.1,
			spikeUntil = 0,
			lastHeartbeatTime = v24,
			joinTime = v25
		}
	end)
	players.PlayerRemoving:Connect(function(player: Player)
		t2[player] = nil
	end)

	for _, v in ipairs(players:GetPlayers()) do
		if not t2[v] then
			local v12 = os.clock()
			local v13 = os.clock()

			t2[v] = {
				smoothedRTT = 0.1,
				spikeUntil = 0,
				lastHeartbeatTime = v12,
				joinTime = v13
			}
		end
	end

	function module.GetPing(p6)
		local v28 = t2[p6]

		if not v28 then
			return 0
		end

		return v28.smoothedRTT
	end
	function module.IsLagging(p7)
		local v30 = t2[p7]

		if not v30 then
			return false
		end

		local v31 = os.clock()

		if v31 - v30.lastHeartbeatTime > 2 and v31 - v30.joinTime > 3 then
			return true
		end

		if v31 < v30.spikeUntil then
			return true
		end

		return false
	end
	function module.GetTimeSinceResponse(p8)
		local v33 = t2[p8]

		if not v33 then
			return 999
		end

		return os.clock() - v33.lastHeartbeatTime
	end

	return module
end

local n1 = 0
local n2 = 0
local n3 = 0

function module.Sample()
	local v34 = os.clock()
	local v35 = pingRF:InvokeServer()
	local v36 = os.clock()
	local v37 = math.max(0, v36 - v34)

	n1 = n1 * 0.5 + v37 * 0.5
	n2 = n1 * 0.5

	local n4 = v35 + n2

	v36 = os.clock()
	n3 = n4 - v36
end
function module.GetRTT()
	return n1
end
function module.GetHalfRTT()
	return n2
end
function module.ServerClockNow()
	return os.clock() + n3
end

task.spawn(function()
	while true do
		task.wait(0.5)
		pcall(function()
			pingHeartbeat:FireServer(os.clock())
		end)
	end
end)
task.spawn(function()
	while true do
		if not task.wait(2) then
			break
		end

		pcall(module.Sample)
	end
end)

return module
