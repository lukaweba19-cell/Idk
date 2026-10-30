-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local duelStations: Instance = workspace:WaitForChild("DuelStations")
local object = setmetatable({}, { __mode = "k" })
local t1: {[any]: any} = {}
local u5 = nil

local function findBoardGui(p1)
	for _, v in ipairs(p1:GetDescendants()) do
		if v.Name == "PlayerSurfaceGui" and v:IsA("SurfaceGui") then
			return v
		end
	end

	return nil
end
local function collectRows(p2)
	local t2: {[any]: any} = {}

	for _, v in ipairs(p2:GetChildren()) do
		if v:IsA("Frame") then
			for _, iterValue in ipairs(v:GetChildren()) do
				if iterValue.Name == "PlayerIcon" and iterValue:IsA("GuiObject") then
					table.insert(t2, iterValue)
				end
			end
		end
	end

	return t2
end
local function boardFor(p3)
	local v27 = object[p3]

	if v27 and v27.Gui.Parent ~= nil and v27.Rows[1] ~= nil and v27.Rows[1].Parent ~= nil then
		return v27
	end

	v27 = findBoardGui(p3)

	if not v27 then
		object[p3] = nil

		return nil
	end

	local v28 = collectRows(v27)

	if #v28 == 0 then
		object[p3] = nil

		return nil
	end

	local t3: {[any]: any} = { Gui = v27, Rows = v28 }

	object[p3] = t3

	for _, v in ipairs(v28) do
		v:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
			u5()
		end)
	end

	return t3
end
local function ensureSpinner(parent)
	local loading = parent:FindFirstChild("Loading")

	if loading and loading:IsA("ImageLabel") then
		return loading
	end

	local loading: ImageLabel = Instance.new("ImageLabel")

	loading.Name = "Loading"
	loading.Image = "rbxassetid://119638529177405"
	loading.BackgroundTransparency = 1
	loading.ScaleType = Enum.ScaleType.Fit
	loading.AnchorPoint = Vector2.new(0.5, 0.5)
	loading.Position = UDim2.fromScale(0.5, 0.5)
	loading.SizeConstraint = Enum.SizeConstraint.RelativeYY
	loading.Size = UDim2.fromScale(0.5, 0.5)
	loading.ZIndex = 0
	loading.Visible = false
	loading.Parent = parent

	return loading
end

local n1: number = 0
local connection = nil

local function stopSpin()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end
local function startSpin()
	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 = (n1 + deltaTime * 360) % 360

		for i = #t1, 1, -1 do
			local v55 = t1[i]

			if v55.Parent == nil then
				table.remove(t1, i)
			else
				v55.Rotation = n1
			end
		end

		if #t1 == 0 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end
local function reconcile()
	table.clear(t1)

	for _, v in ipairs(duelStations:GetChildren()) do
		if v:IsA("Model") or v:IsA("Folder") then
			local v37 = boardFor(v)

			if v37 then
				local rows = v37.Rows
				local n2: number = 0

				for _, iterValue in ipairs(rows) do
					if typeof(iterValue:GetAttribute("OwnerUserId")) == "number" then
						n2 += 1
					end
				end

				local u42: boolean = n2 > 0 and n2 < #rows

				for _, iterValue2 in ipairs(rows) do
					local v45 = ensureSpinner(iterValue2)
					local u46: boolean = u42

					if u46 then
						u46 = typeof(iterValue2:GetAttribute("OwnerUserId")) ~= "number"
					end

					v45.Visible = u46

					if u46 then
						v45.Rotation = n1
						table.insert(t1, v45)
					end
				end
			end
		end
	end
end
local function runReconcile()
	local ok, result = pcall(reconcile)

	if not ok then
		warn("[DuelBoardSpinner] reconcile failed:", result)
	end

	if not (#t1 > 0) then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		return
	end

	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 = (n1 + deltaTime * 360) % 360

		for i = #t1, 1, -1 do
			local v58 = t1[i]

			if v58.Parent == nil then
				table.remove(t1, i)
			else
				v58.Rotation = n1
			end
		end

		if #t1 == 0 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

local u16: boolean = false

u5 = function()
	if u16 then
		return
	end

	u16 = true
	task.defer(function()
		u16 = false

		local ok, result = pcall(reconcile)

		if not ok then
			warn("[DuelBoardSpinner] reconcile failed:", result)
		end

		if not (#t1 > 0) then
			if connection then
				connection:Disconnect()
				connection = nil
			end

			return
		end

		if connection then
			return
		end

		connection = runService.Heartbeat:Connect(function(deltaTime: number)
			n1 = (n1 + deltaTime * 360) % 360

			for i = #t1, 1, -1 do
				local v63 = t1[i]

				if v63.Parent == nil then
					table.remove(t1, i)
				else
					v63.Rotation = n1
				end
			end

			if #t1 == 0 and connection then
				connection:Disconnect()
				connection = nil
			end
		end)
	end)
end
task.spawn(function()
	local v49
	local v50
	local v51
	local connection2

	while true do
		v49, v50 = pcall(reconcile)

		if not v49 then
			warn("[DuelBoardSpinner] reconcile failed:", v50)
		end

		if #t1 > 0 then
			if connection then
			else
				v51 = function(deltaTime: number)
					n1 = (n1 + deltaTime * 360) % 360

					for i = #t1, 1, -1 do
						local v58 = t1[i]

						if v58.Parent == nil then
							table.remove(t1, i)
						else
							v58.Rotation = n1
						end
					end

					if #t1 == 0 and connection then
						connection:Disconnect()
						connection = nil
					end
				end
				connection2 = runService.Heartbeat:Connect(v51)
				connection = connection2
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end

		task.wait(0.25)

		continue
	end
end)
