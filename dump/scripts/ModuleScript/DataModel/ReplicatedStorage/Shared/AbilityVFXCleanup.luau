-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local t1: {[any]: any} = {}

local function doCleanup(p1)
	if p1.cleaned then
		return
	end

	p1.cleaned = true

	if p1.diedConn then
		p1.diedConn:Disconnect()
		p1.diedConn = nil
	end

	if p1.respawnConn then
		p1.respawnConn:Disconnect()
		p1.respawnConn = nil
	end

	local ok, result = pcall(p1.onCleanup)

	if not ok then
		warn("[AbilityVFXCleanup] cleanup error for", p1.key, "userId", p1.userId, ":", result)
	end

	local v8 = t1[p1.userId]

	if v8 then
		v8[p1.key] = nil

		if next(v8) == nil then
			t1[p1.userId] = nil
		end
	end
end

local module: {[any]: any} = {}

function module.Track(p2, p3, p4)
	module.Cleanup(p2, p3)

	local t3: {[any]: any} = { cleaned = false, key = p3, userId = p2, onCleanup = p4.onCleanup }

	if not t1[p2] then
		t1[p2] = {}
	end

	t1[p2][p3] = t3

	local player: Player = players:GetPlayerByUserId(p2)

	if player then
		local Character: Model = player.Character
		local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health > 0 then
			t3.diedConn = humanoid.Died:Once(function()
				doCleanup(t3)
			end)
		end

		t3.respawnConn = player.CharacterAdded:Once(function()
			doCleanup(t3)
		end)
	end

	if p4.duration then
		local duration = p4.duration

		task.spawn(function()
			task.wait(duration)
			doCleanup(t3)
		end)
	end
end
function module.Cleanup(p5, p6)
	local v19 = t1[p5]

	if not v19 then
		return
	end

	local v20 = v19[p6]

	if not v20 then
		return
	end

	doCleanup(v20)
end
function module.CleanupAll(p7)
	local v22 = t1[p7]

	if not v22 then
		return
	end

	local t4: {[any]: any} = {}

	for iterKey in pairs(v22) do
		table.insert(t4, iterKey)
	end

	for _, v in ipairs(t4) do
		local v27 = v22[v]

		if v27 then
			doCleanup(v27)
		end
	end
end

return module
