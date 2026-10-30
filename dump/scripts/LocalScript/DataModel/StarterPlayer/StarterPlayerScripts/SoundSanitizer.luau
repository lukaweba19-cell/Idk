-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local object = setmetatable({}, { __mode = "k" })

local function warnOnce(p1, p2)
	local v20 = p1.Name
	local v21 = os.clock()

	if v21 < (t1[v20] or -math.huge) + 2 then
		return
	end

	t1[v20] = v21

	local v22 = p1:GetFullName()

	warn(("[SoundSanitizer] %s: %s"):format(v22, p2))
end
local function isLive(p3)
	return p3.Playing or p3.IsPlaying
end
local function sanitize(p4)
	if t2[p4] then
		return
	end

	if not p4.Parent then
		return
	end

	if not p4.Playing and not p4.IsPlaying then
		return
	end

	t2[p4] = true

	local v25 = p4.RollOffMinDistance
	local rollOffMaxDistance = p4.RollOffMaxDistance
	local playbackSpeed = p4.PlaybackSpeed

	if v25 ~= v25 or v25 < 0 then
		v25 = 0
	end

	local v28 = math.max(0.001, v25 + 0.001)

	if rollOffMaxDistance ~= rollOffMaxDistance or rollOffMaxDistance < v28 then
		local text: string = tostring(rollOffMaxDistance)
		local text2: string = tostring(v28)
		local text3: string = tostring(v25)
		local v32 = ("RollOffMaxDistance %s -> %s (min %s)"):format(text, text2, text3)
		local v33 = p4.Name
		local v34 = os.clock()

		if not (v34 < (t1[v33] or -math.huge) + 2) then
			t1[v33] = v34

			local v35 = p4:GetFullName()

			warn(("[SoundSanitizer] %s: %s"):format(v35, v32))
		end

		p4.RollOffMaxDistance = v28
	end

	if playbackSpeed ~= playbackSpeed or playbackSpeed <= 0 then
		local text: string = tostring(playbackSpeed)
		local text4: string = tostring(0.01)
		local v38 = ("PlaybackSpeed %s -> %s"):format(text, text4)
		local v39 = p4.Name
		local v40 = os.clock()

		if not (v40 < (t1[v39] or -math.huge) + 2) then
			t1[v39] = v40

			local v41 = p4:GetFullName()

			warn(("[SoundSanitizer] %s: %s"):format(v41, v38))
		end

		p4.PlaybackSpeed = 0.01
	end

	t2[p4] = nil
end
local function hook(p5)
	if object[p5] then
		return
	end

	object[p5] = true

	local function onChange()
		local v54 = p5

		if v54.Playing or v54.IsPlaying then
			sanitize(p5)
		end
	end

	p5.Played:Connect(onChange)
	p5.Resumed:Connect(onChange)
	p5:GetPropertyChangedSignal("Playing"):Connect(onChange)
	p5:GetPropertyChangedSignal("RollOffMaxDistance"):Connect(onChange)
	p5:GetPropertyChangedSignal("RollOffMinDistance"):Connect(onChange)
	p5:GetPropertyChangedSignal("PlaybackSpeed"):Connect(onChange)

	if p5.Playing or p5.IsPlaying then
		sanitize(p5)
	end
end

local n1: number = 0

for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("Sound") then
		hook(v)
		n1 += 1
	end
end

local n2: number = 0
local n3: number = 0
local n4 = 0
local n5 = -math.huge
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local playerState = require(shared:WaitForChild("PlayerState"))
local t3: {[any]: any} = {}

game.DescendantAdded:Connect(function(descendant: Instance)
	n2 += 1

	if playerState.ReplayActive then
		return
	end

	if descendant:IsA("Sound") then
		table.insert(t3, descendant)
	end
end)
game:GetService("RunService").Heartbeat:Connect(function()
	local v45 = os.clock()
	local v46 = math.min(#t3, 40)

	if v46 > 0 then
		for i = 1, v46 do
			local v48 = t3[i]

			if v48.Parent then
				n3 += 1
				hook(v48)
			end
		end

		local n1: number = #t3

		table.move(t3, v46 + 1, n1, 1)

		for i = n1, n1 - v46 + 1, -1 do
			t3[i] = nil
		end
	end

	local v51: number = n4
	local v52 = os.clock()

	n4 = v51 + (v52 - v45) * 1000

	if n2 >= 1500 or n4 >= 4 then
		local v53 = os.clock()

		if v53 - n5 >= 5 then
			n5 = v53
			warn(("[SoundSanitizer] busy frame: %d instances added, %d sounds hooked, %.1fms hooking, %d queued"):format(n2, n3, n4, #t3))
		end
	end

	n2 = 0
	n3 = 0
	n4 = 0
end)
print(("[SoundSanitizer] armed (%d sounds hooked)"):format(n1))
