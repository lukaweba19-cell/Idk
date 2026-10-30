-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local u2 = nil
local vectorValue = Vector3.new(0, 0, 0)
local vectorValue2 = Vector3.new(1, 0, 0)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function track(p1)
	if p1:IsA("BasePart") and t1[p1] == nil then
		t1[p1] = p1.CFrame
	end
end
local function untrack(p2)
	if p2:IsA("BasePart") then
		t1[p2] = nil
	end
end
local function bind(p3)
	for key, value in t2 do
		value:Disconnect()
	end

	table.clear(t2)
	table.clear(t1)
	u2 = p3

	local pivot = p3:GetPivot()

	vectorValue = pivot.Position
	vectorValue2 = pivot.RightVector

	for iterFirst, iterSecond in p3:GetDescendants() do
		if iterSecond:IsA("BasePart") and t1[iterSecond] == nil then
			t1[iterSecond] = iterSecond.CFrame
		end
	end

	table.insert(t2, p3.DescendantAdded:Connect(track))
	table.insert(t2, p3.DescendantRemoving:Connect(untrack))
end
local function find()
	local lobby: Instance = workspace:FindFirstChild("Lobby")
	local wheel: Instance = lobby and lobby:FindFirstChild("Wheel")
	local v23: Instance = wheel

	if v23 then
		v23 = wheel:FindFirstChild("SpinWheel")
	end

	if v23 and v23:IsA("Model") then
		return v23
	end

	return nil
end

task.spawn(function()
	local lobby
	local v25
	local v26
	local spinWheel
	local v28
	local v29

	while true do
		lobby = workspace:FindFirstChild("Lobby")
		v25 = lobby and lobby:FindFirstChild("Wheel")
		v26 = v25

		if v26 then
			spinWheel = v25:FindFirstChild("SpinWheel")
			v26 = spinWheel
		end

		v28 = v26 and v26:IsA("Model")
		v29 = if v28 then v26 else nil

		if v29 and v29 ~= u2 then
			bind(v29)
		end

		task.wait(2)

		continue
	end
end)

local t3: {[any]: any} = {}
local t4: {[any]: any} = {}

runService.RenderStepped:Connect(function()
	local v30 = u2

	if not v30 or not v30.Parent then
		return
	end

	if workspace.CurrentCamera and (workspace.CurrentCamera.CFrame.Position - vectorValue).Magnitude > 400 then
		return
	end

	local v31 = os.clock()

	v30 = math.rad(v31 * 12 % 360)

	local cFrame = CFrame.new(vectorValue)
	local v33 = CFrame.fromAxisAngle(vectorValue2, v30)
	local cFrame2 = CFrame.new(-vectorValue)

	table.clear(t3)
	table.clear(t4)

	for key, value in t1 do
		if key.Parent then
			table.insert(t3, key)
			table.insert(t4, cFrame * v33 * cFrame2 * value)
		end
	end

	if #t3 > 0 then
		workspace:BulkMoveTo(t3, t4, Enum.BulkMoveMode.FireCFrameChanged)
	end
end)
