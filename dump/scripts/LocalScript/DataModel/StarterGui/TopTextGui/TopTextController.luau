-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared")
local config = require(matchmakingShared:WaitForChild("Config"))
local sound = require(replicatedStorage:WaitForChild("Sound"))

print("TopTextController [rev: settext-visible]")

local isReservedServer: Instance = matchmakingShared:WaitForChild("IsReservedServer", 5)
local u6: boolean = isReservedServer ~= nil and isReservedServer.Value == true

print("Got reservedFlag")

local scriptParent: Instance = script.Parent
local frame: Instance = scriptParent:WaitForChild("Frame")
local textLabel: Instance = frame:WaitForChild("TextLabel")
local v10: Instance = textLabel:WaitForChild("TextLabel")
local u11 = nil
local n1 = 0
local u13 = nil

local function isWarmupPhase(p1)
	local u22: boolean = true

	if p1 ~= config.WarmupPhase.Boarding then
		u22 = p1 == config.WarmupPhase.Countdown
	end

	return u22
end
local function setText(text)
	textLabel.Text = text
	v10.Text = text

	local v24 = u11
	local u25: boolean = true

	if v24 ~= config.WarmupPhase.Boarding then
		u25 = v24 == config.WarmupPhase.Countdown
	end

	frame.Visible = u25

	if frame.Visible then
		n1 = os.clock()
	end
end

local u16: boolean = false

local function render(p3)
	local phase = p3 and p3.phase

	print("render", phase)
	u11 = phase

	if phase ~= config.WarmupPhase.Countdown then
		u13 = nil
	end

	if phase == config.WarmupPhase.Boarding then
		local numberValue: number? = tonumber(p3.arrived)
		local numberValue2: number? = tonumber(p3.expected)
		local text = ("Waiting for players<br/>(%d/%d)"):format(numberValue or 0, numberValue2 or 0)

		textLabel.Text = text
		v10.Text = text

		local v31 = u11
		local u32: boolean = true

		if v31 ~= config.WarmupPhase.Boarding then
			u32 = v31 == config.WarmupPhase.Countdown
		end

		frame.Visible = u32

		if frame.Visible then
			n1 = os.clock()

			return
		end
	elseif phase == config.WarmupPhase.Countdown then
		local numberValue = tonumber(p3.seconds) or 0
		local v34 = ("Match begins in...<br/>%d"):format(numberValue)

		textLabel.Text = v34
		v10.Text = v34

		local v35 = u11
		local u36: boolean = true

		if v35 ~= config.WarmupPhase.Boarding then
			u36 = v35 == config.WarmupPhase.Countdown
		end

		frame.Visible = u36

		if frame.Visible then
			n1 = os.clock()
		end

		if numberValue >= 1 and numberValue <= 3 and numberValue ~= u13 then
			u13 = numberValue
			pcall(function()
				sound:Play("Misc.TimerTick", workspace)
			end)

			return
		end
	else
		u16 = false
		frame.Visible = false
	end
end

local v18 = nil
local u19 = nil
local remotes: Instance = matchmakingShared:WaitForChild("Remotes", 5)

if remotes then
	v18 = remotes:WaitForChild("WarmupStatus", 5)
	u19 = remotes:WaitForChild("GetWarmupState", 5)
end

print("Got remotes")

if v18 then
	v18.OnClientEvent:Connect(function(p4)
		print("receivedPush")
		u16 = true
		render(p4)
	end)
end

frame.Visible = false
task.spawn(function()
	while true do
		task.wait(1)

		if frame.Visible then
			local v38 = u11
			local u39: boolean = true

			if v38 ~= config.WarmupPhase.Boarding then
				u39 = v38 == config.WarmupPhase.Countdown
			end

			if u39 and not (os.clock() - n1 > 6) then
				continue
			end

			frame.Visible = false
		end
	end
end)
scriptParent:GetPropertyChangedSignal("Enabled"):Connect(function()
	local text: string = tostring(scriptParent.Enabled)

	print(("[TTG] Enabled -> %s | %s"):format(text, debug.traceback("", 2)))
end)
frame:GetPropertyChangedSignal("Visible"):Connect(function()
	print("[TTG] frame.Visible ->", frame.Visible)
end)
scriptParent.AncestryChanged:Connect(function(_: Instance, p6: Instance)
	local v43 = p6 and p6:GetFullName() or "nil"

	print("[TTG] gui reparented ->", v43)
end)
task.spawn(function()
	if not u6 then
		return
	end

	if not u19 then
		return
	end

	local v44 = u19

	local ok, result = pcall(function()
		return v44:InvokeServer()
	end)

	print("InvokeServer", ok, u16, result and result.phase)

	if ok and not u16 then
		render(result)
	end
end)
