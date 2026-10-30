-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local booth: Instance = remotes:WaitForChild("Booth")
local boothEvent: Instance = remotes:WaitForChild("BoothEvent")
local LocalPlayer: Player = players.LocalPlayer
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local bindableEventEvent = bindableEvent.Event
local bindableEvent2: BindableEvent = Instance.new("BindableEvent")
local t1: {[any]: any} = { snapshot = nil, config = nil, enabled = false, refreshing = false }

local module: {[any]: any} = {
	Changed = bindableEventEvent,
	Sale = bindableEvent2.Event,
	Invoke = function(p1, p2, p3, p4)
		local v18, v19, v20 = pcall(booth.InvokeServer, booth, p1, p2, p3, p4)

		if not v18 then
			return false, "Network hiccup -- please try again."
		end

		return v19 == true, v20
	end,
	IsEnabled = function()
		return t1.enabled
	end,
	GetSnapshot = function()
		return t1.snapshot
	end,
	GetConfig = function()
		return t1.config
	end,
	FindBooth = function(p5)
		local snapshot = t1.snapshot

		if snapshot == nil then
			return nil
		end

		for _, v in ipairs(snapshot) do
			if p5 == v.Id then
				return v
			end
		end

		return nil
	end,
	Signature = function(p6)
		if p6 == nil then
			return ""
		end

		local text: string = tostring(p6.Id)
		local text2: string = tostring(p6.OwnerUserId)
		local text3: string = tostring(p6.OwnerName)
		local text4: string = tostring(p6.OwnerDisplayName)
		local text5: string = tostring(p6.TokensSold)
		local t3: {[any]: any} = { text, text2, text3, text4, text5 }

		for _, v in ipairs(p6.Listings or {}) do
			local t4 = v.Meta or {}
			local tableConcat = table.concat
			local text6: string = tostring(v.Lid)
			local text7: string = tostring(v.Kind)
			local text8: string = tostring(v.ItemId)
			local text9: string = tostring(v.Price)
			local text10: string = tostring(v.Count)
			local text11: string = tostring(v.InFlight)
			local text12: string = tostring(v.Serial)
			local text13: string = tostring(t4.RAP)
			local text14: string = tostring(t4.RapEstimate)
			local text15: string = tostring(t4.RapProjected)
			local text16: string = tostring(t4.RapConfidence)
			local text17: string = tostring(t4.GlobalCopies)

			table.insert(t3, tableConcat({
				text6,
				text7,
				text8,
				text9,
				text10,
				text11,
				text12,
				text13,
				text14,
				text15,
				text16,
				text17
			}, ","))
		end

		return table.concat(t3, ";")
	end,
	MyBooth = function()
		local snapshot = t1.snapshot

		if snapshot == nil then
			return nil
		end

		for _, v in ipairs(snapshot) do
			if v.OwnerUserId == LocalPlayer.UserId then
				return v
			end
		end

		return nil
	end
}

function module.Refresh()
	if t1.refreshing then
		return
	end

	t1.refreshing = true
	task.spawn(function()
		local v60, v61 = module.Invoke("GetBooths")

		t1.enabled = v60
		t1.snapshot = if v60 then v61 else nil

		if v60 and t1.config == nil then
			local v62, v63 = module.Invoke("GetConfig")

			if v62 then
				t1.config = v63
			end
		end

		t1.refreshing = false
		bindableEvent:Fire()
	end)
end
function module.RefreshConfig()
	task.spawn(function()
		local v64, v65 = module.Invoke("GetConfig")

		if v64 then
			t1.config = v65
			bindableEvent:Fire()
		end
	end)
end
function module.PreviewSplit(p7)
	local config = t1.config
	local v53 = if config == nil or typeof(config.TakeRateBP) ~= "number" then 100 else config.TakeRateBP
	local floored = math.floor(p7)
	local v55 = math.max(0, floored)

	if v53 <= 0 then
		return v55, 0
	end

	local floored2 = math.floor(v55 * (10000 - v53) / 10000)

	return floored2, v55 - floored2
end

boothEvent.OnClientEvent:Connect(function(p8)
	if typeof(p8) ~= "table" then
	elseif p8.Action == "Booths" and typeof(p8.Booths) == "table" then
		t1.snapshot = p8.Booths
		t1.enabled = true
		bindableEvent:Fire()
	elseif p8.Action == "Sale" and typeof(p8.BoothId) == "string" then
		local boothId = p8.BoothId
		local numberValue: number? = tonumber(p8.Price)

		bindableEvent2:Fire(boothId, numberValue or 0)
	end
end)

if tradingPlazaGate.IsTradingPlaza() then
	task.defer(module.Refresh)
end

return module
