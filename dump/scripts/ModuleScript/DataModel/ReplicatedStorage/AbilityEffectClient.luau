-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local abilityEffectUtil = require(script:WaitForChild("AbilityEffectUtil"))
local abilityEffectSync: Instance = replicatedStorage:WaitForChild("Remotes"):FindFirstChild("AbilityEffectSync")
local LocalPlayer: Player = players.LocalPlayer
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local startPendingRadial: Instance = bindables:WaitForChild("StartPendingRadial")
local cancelPendingRadial: Instance = bindables:WaitForChild("CancelPendingRadial")
local t1: {[any]: any} = {}
local u10 = nil
local t2: {[any]: any} = {}

local function now()
	return workspace:GetServerTimeNow()
end
local function attrNameFor(p1)
	local s1: string = "KnifeEffects."

	if p1.appliesTo == "bullet" then
		s1 = "RevolverEffects."
	end

	return s1 .. p1.id .. ".ExpiresAt"
end
local function cleanup(p2)
	local v21: number = workspace:GetServerTimeNow()

	for k, v in pairs(t1) do
		if p2 or v.expiresAt ~= nil and v21 > v.expiresAt or v.usesLeft <= 0 then
			t1[k] = nil

			if k == u10 then
				u10 = nil
			end

			local s1: string = "KnifeEffects."

			if v.appliesTo == "bullet" then
				s1 = "RevolverEffects."
			end

			LocalPlayer:SetAttribute(s1 .. v.id .. ".ExpiresAt", nil)
		end
	end
end
local function scheduleExpiry(p3)
	if not p3.expiresAt then
		return
	end

	local n1 = (t2[p3.effectKey] or 0) + 1

	t2[p3.effectKey] = n1

	local expiresAt = p3.expiresAt
	local v28: number = workspace:GetServerTimeNow()
	local v29 = math.max(0, expiresAt - v28)

	task.delay(v29 + 0.016666666666666666, function()
		if t2[p3.effectKey] ~= n1 then
			return
		end

		local v65 = t1[p3.effectKey]

		if not v65 then
			return
		end

		if v65.expiresAt and workspace:GetServerTimeNow() < v65.expiresAt and v65.usesLeft > 0 then
			return
		end

		t1[p3.effectKey] = nil

		if u10 == p3.effectKey then
			u10 = nil
		end

		local s1: string = "KnifeEffects."

		if v65.appliesTo == "bullet" then
			s1 = "RevolverEffects."
		end

		LocalPlayer:SetAttribute(s1 .. v65.id .. ".ExpiresAt", nil)
	end)
end
local function finalizePredicted(p4)
	if p4.duration then
		local v31: number = workspace:GetServerTimeNow()
		local v32 = math.max(0, p4.duration)

		p4.expiresAt = v31 + v32
	else
		p4.expiresAt = nil
	end

	p4.grantedAt = os.clock()
	t1[p4.effectKey] = p4
	u10 = p4.effectKey

	local s1: string = "KnifeEffects."

	if p4.appliesTo == "bullet" then
		s1 = "RevolverEffects."
	end

	LocalPlayer:SetAttribute(s1 .. p4.id .. ".ExpiresAt", p4.expiresAt or math.huge)
	scheduleExpiry(p4)
end

local module: {[any]: any} = {
	PredictGrant = function(p5)
		cleanup(true)
		finalizePredicted(p5)

		if typeof(p5.duration) == "number" and p5.duration > 0 then
			startPendingRadial:Fire(p5.duration)
		end
	end,
	ClearAll = function()
		local u35: boolean = false

		for _, v in pairs(t1) do
			local s1: string = "KnifeEffects."

			if v.appliesTo == "bullet" then
				s1 = "RevolverEffects."
			end

			LocalPlayer:SetAttribute(s1 .. v.id .. ".ExpiresAt", nil)

			if typeof(v.duration) == "number" and v.duration > 0 then
				u35 = true
			end
		end

		table.clear(t1)
		table.clear(t2)
		u10 = nil

		if u35 then
			cancelPendingRadial:Fire()
		end
	end,
	Get = function(p6)
		cleanup(false)

		return t1[p6]
	end,
	GetLatest = function()
		cleanup(false)

		return u10 and t1[u10] or nil
	end,
	GetActiveFor = function(p7, p8)
		cleanup(false)

		local v42 = nil
		local n1 = -math.huge

		for _, v in pairs(t1) do
			if p8 == v.id and p7 == v.appliesTo then
				local v46 = v.expiresAt or math.huge

				if n1 < v46 then
					v42 = v
					n1 = v46
				end
			end
		end

		return v42
	end,
	Consume = function(p9)
		local v48 = t1[p9]

		if not v48 then
			return
		end

		v48.usesLeft = v48.usesLeft - 1

		if v48.usesLeft <= 0 then
			t1[p9] = nil

			if p9 == u10 then
				u10 = nil
			end

			local s1: string = "KnifeEffects."

			if v48.appliesTo == "bullet" then
				s1 = "RevolverEffects."
			end

			LocalPlayer:SetAttribute(s1 .. v48.id .. ".ExpiresAt", nil)

			if typeof(v48.duration) == "number" and v48.duration > 0 then
				cancelPendingRadial:Fire()
			end
		end
	end,
	ClearKey = function(p10)
		local v51 = t1[p10]

		if not v51 then
			return
		end

		t1[p10] = nil
		t2[p10] = nil

		if p10 == u10 then
			u10 = nil
		end

		local s1: string = "KnifeEffects."

		if v51.appliesTo == "bullet" then
			s1 = "RevolverEffects."
		end

		LocalPlayer:SetAttribute(s1 .. v51.id .. ".ExpiresAt", nil)

		if typeof(v51.duration) == "number" and v51.duration > 0 then
			cancelPendingRadial:Fire()
		end
	end
}

function module.ClearPendingForKind(p11)
	local v54 = os.clock()
	local t4: {[any]: any} = {}

	for k, v in pairs(t1) do
		if p11 == v.appliesTo and (typeof(v.grantedAt) ~= "number" or not (v54 - v.grantedAt < 0.2)) then
			table.insert(t4, k)
		end
	end

	for _, v in ipairs(t4) do
		module.ClearKey(v)
	end
end

if abilityEffectSync then
	abilityEffectSync.OnClientEvent:Connect(function(p12)
		module.__ReplayInvoke(p12)
	end)
end

function module.__ReplayInvoke(p13)
	if typeof(p13) ~= "table" then
	elseif p13.clear == true then
		local effectKey = p13.effectKey

		if typeof(effectKey) == "number" then
			local v63 = t1[effectKey]

			if v63 then
				t1[effectKey] = nil
				t2[effectKey] = nil

				if effectKey == u10 then
					u10 = nil
				end

				local s1: string = "KnifeEffects."

				if v63.appliesTo == "bullet" then
					s1 = "RevolverEffects."
				end

				LocalPlayer:SetAttribute(s1 .. v63.id .. ".ExpiresAt", nil)

				if typeof(v63.duration) == "number" and v63.duration > 0 then
					cancelPendingRadial:Fire()

					return
				end
			end
		else
			module.ClearAll()
		end
	elseif typeof(p13.effectKey) == "number" then
		return
	end
end
function module.MakeEffectKey()
	return abilityEffectUtil.makeEffectKey(LocalPlayer.UserId, math.random(1, 2147483647))
end

return module
