-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local keybindSettings = require(shared:WaitForChild("KeybindSettings"))
local updateSettings: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("UpdateSettings")
local u7 = keybindSettings.newState()
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local u12: boolean = false
local u13 = false
local bindableEvent: BindableEvent = Instance.new("BindableEvent")

local function physicalCount(p1)
	local n1: number = 0

	for _, v in ipairs(u7[p1] or {}) do
		local v33 = keybindSettings.resolve(v)

		if typeof(v33) == "EnumItem" then
			if v33.EnumType == Enum.KeyCode then
				if userInputService:IsKeyDown(v33) then
					n1 += 1
				end
			elseif v33.EnumType == Enum.UserInputType then
				local ok, result = pcall(function()
					return userInputService:IsMouseButtonPressed(v33)
				end)

				if ok and result then
					n1 += 1
				end
			end
		end
	end

	local v36 = keybindSettings.Defs[p1]

	if v36 and v36.gamepad and userInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) and userInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, v36.gamepad) then
		n1 += 1
	end

	return n1
end
local function step(p2, p3, p4, p5)
	if u13 then
		return p3.result
	end

	local v41 = t2[p2] or 0

	if p4 == Enum.UserInputState.Begin then
		if p5 == nil then
			t3[p2] = (t3[p2] or 0) + 1
		elseif v41 > 0 then
			local v42 = physicalCount(p2)
			local n1 = math.max(v42 - 1, 0) + (t3[p2] or 0)

			if v41 > n1 then
				v41 = n1
			end
		end

		t2[p2] = v41 + 1

		if v41 == 0 then
			return p3.fn(p4, p5)
		end
	elseif p4 == Enum.UserInputState.End or p4 == Enum.UserInputState.Cancel then
		if p5 == nil then
			t3[p2] = math.max((t3[p2] or 0) - 1, 0)
		end

		if v41 <= 0 then
			t2[p2] = 0
			t3[p2] = 0

			return p3.result
		end

		if p3.releaseOnFirstKeyUp then
			t2[p2] = 0
			t3[p2] = 0

			return p3.fn(Enum.UserInputState.End, p5)
		end

		local n2 = v41 - 1

		t2[p2] = n2

		if n2 == 0 then
			t3[p2] = 0

			return p3.fn(Enum.UserInputState.End, p5)
		end
	end

	return p3.result
end
local function wrap(p6, p7)
	return function(_, p9, p10)
		return step(p6, p7, p9, p10)
	end
end
local function keysFor(p11)
	local v48 = keybindSettings.Defs[p11]

	if not v48 then
		return {}
	end

	local t6: {[any]: any} = {}

	for _, v in ipairs(u7[p11] or {}) do
		local v52 = keybindSettings.resolve(v)

		if v52 then
			table.insert(t6, v52)
		end
	end

	if v48.gamepad then
		table.insert(t6, v48.gamepad)
	end

	return t6
end
local function unregister(p12)
	if not t4[p12] then
		return
	end

	contextActionService:UnbindAction("MDBind_" .. p12)
	t4[p12] = nil
end
local function register(p13)
	local v55 = t1[p13]

	if not v55 then
		return
	end

	if v55.manual then
		return
	end

	local v56 = keysFor(p13)

	if #v56 == 0 then
		return
	end

	local s1: string = "MDBind_" .. p13

	local function v58(_, p15, p16)
		return step(p13, v55, p15, p16)
	end

	if v55.priority then
		contextActionService:BindActionAtPriority(s1, v58, false, v55.priority, table.unpack(v56))
	else
		contextActionService:BindAction(s1, v58, false, table.unpack(v56))
	end

	t4[p13] = true
end
local function releaseHeld(p17)
	if (t2[p17] or 0) <= 0 then
		t2[p17] = 0
		t3[p17] = 0

		return
	end

	t2[p17] = 0
	t3[p17] = 0

	local v60 = t1[p17]

	if not v60 then
		return
	end

	local ok, result = pcall(v60.fn, Enum.UserInputState.End, nil)

	if not ok then
		local stringFormat = string.format
		local text: string = tostring(result)

		warn(stringFormat("[InputMap] release handler errored for %s: %s", p17, text))
	end
end
local function rebindAll()
	for iterKey in pairs(t1) do
		if t4[iterKey] then
			contextActionService:UnbindAction("MDBind_" .. iterKey)
			t4[iterKey] = nil
		end

		releaseHeld(iterKey)
		register(iterKey)
	end
end

local module: {[any]: any} = {
	changed = bindableEvent.Event,
	reconcile = function()
		for iterKey in pairs(t1) do
			if (t2[iterKey] or 0) > (t3[iterKey] or 0) and physicalCount(iterKey) == 0 then
				releaseHeld(iterKey)
			end
		end
	end
}

userInputService.TextBoxFocusReleased:Connect(function()
	module.reconcile()
end)
userInputService.WindowFocused:Connect(function()
	module.reconcile()
end)

function module.bind(p18, p19, p20)
	if not keybindSettings.Defs[p18] then
		local text: string = tostring(p18)

		warn("[InputMap] bind() for unknown action: " .. text)

		return
	end

	if t4[p18] then
		contextActionService:UnbindAction("MDBind_" .. p18)
		t4[p18] = nil
	end

	t1[p18] = {
		fn = p19,
		result = p20 and p20.result or Enum.ContextActionResult.Pass,
		priority = p20 and p20.priority,
		manual = p20 and p20.manual,
		releaseOnFirstKeyUp = p20 and p20.releaseOnFirstKeyUp
	}
	t2[p18] = 0
	t3[p18] = 0
	register(p18)
end
function module.unbind(p21, p22)
	local v73 = t1[p21]

	if p22 == nil or v73 == nil or p22 == v73.fn then
		if t4[p21] then
			contextActionService:UnbindAction("MDBind_" .. p21)
			t4[p21] = nil
		end

		t1[p21] = nil
		t2[p21] = nil
		t3[p21] = nil

		return
	end
end
function module.isDown(p23)
	return (t2[p23] or 0) > 0
end
local function inputIdentity(input)
	local userInputType = input.UserInputType

	if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.MouseButton2 or userInputType == Enum.UserInputType.MouseButton3 then
		return userInputType
	end

	return input.KeyCode
end
function module.matches(p25, input)
	if u13 then
		return false
	end

	local userInputType = input.UserInputType
	local v80 = if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.MouseButton2 or userInputType == Enum.UserInputType.MouseButton3 then userInputType else input.KeyCode

	if v80 == nil or v80 == Enum.KeyCode.Unknown then
		return false
	end

	for _, v in ipairs(u7[p25] or {}) do
		local v83 = keybindSettings.resolve(v)

		if v80 == v83 then
			return true
		end
	end

	local v84 = keybindSettings.Defs[p25]

	return v84 ~= nil and v84.gamepad ~= nil and v80 == v84.gamepad
end
function module.nameFor(input)
	local userInputType = input.UserInputType
	local v87 = if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.MouseButton2 or userInputType == Enum.UserInputType.MouseButton3 then userInputType else input.KeyCode

	if typeof(v87) == "EnumItem" then
		if keybindSettings.ALLOWED[v87.Name] == nil then
			return nil
		end

		return v87.Name
	end

	return nil
end
function module.setCapturing(p28)
	if p28 == u13 then
		return
	end

	if p28 then
		for iterKey in pairs(t1) do
			releaseHeld(iterKey)
		end
	end

	u13 = p28
end
function module.isCapturing()
	return u13
end
function module.handleInput(p29, p30, p31)
	local v93 = t1[p29]

	if not v93 then
		return false
	end

	if not module.matches(p29, p30) then
		return false
	end

	step(p29, v93, p31, p30)

	return true
end
function module.isPhysicallyDown(p32)
	return physicalCount(p32) > 0
end
function module.seedHeld(p33)
	if t1[p33] and (t2[p33] or 0) == 0 then
		t2[p33] = 1
	end
end
function module.fire(p34, p35)
	local v98 = t1[p34]

	if not v98 then
		return
	end

	step(p34, v98, p35, nil)
end
function module.tap(p36)
	module.fire(p36, Enum.UserInputState.Begin)
	module.fire(p36, Enum.UserInputState.End)
end
function module.forceRelease(p37)
	if not t1[p37] then
		return
	end

	releaseHeld(p37)
end
function module.displayFor(p38)
	if p38 == nil then
		return nil, nil
	end

	local v102 = keybindSettings.MOUSE_TEMPLATE[p38]
	local v103 = keybindSettings.SHORT_NAMES[p38]

	if v103 then
		return v103, v102
	end

	local v104 = keybindSettings.resolve(p38)

	if typeof(v104) == "EnumItem" and v104.EnumType == Enum.KeyCode then
		local ok, result = pcall(function()
			return userInputService:GetStringForKeyCode(v104)
		end)

		if ok and typeof(result) == "string" and result ~= "" then
			return string.upper(result), v102
		end

		return p38, v102
	end

	return p38, v102
end
function module.getBindings(p39)
	return table.clone(u7[p39] or {})
end
function module.primaryDisplay(p40)
	return module.displayFor((u7[p40] or {})[1])
end
function module.primaryText(p41)
	return (module.primaryDisplay(p41))
end
function module.getState()
	local t7: {[any]: any} = {}

	for k, v in pairs(u7) do
		t7[k] = table.clone(v)
	end

	return t7
end
function module.isHydrated()
	return u12
end

local u25: boolean = false

local function queueSave()
	if u25 then
		return
	end

	u25 = true
	task.delay(0.5, function()
		u25 = false
		updateSettings:FireServer("UpdateKeybinds", u7)
	end)
end
local function commit()
	u7 = keybindSettings.sanitize(u7)
	rebindAll()
	bindableEvent:Fire()

	if u25 then
		return
	end

	u25 = true
	task.delay(0.5, function()
		u25 = false
		updateSettings:FireServer("UpdateKeybinds", u7)
	end)
end
local function clearConflicts(p42, p43)
	local v115 = keybindSettings.findConflict(u7, p42, p43)

	while v115 do
		local v116 = u7[v115]

		for i = #v116, 1, -1 do
			if p43 == v116[i] then
				table.remove(v116, i)
			end
		end

		v115 = keybindSettings.findConflict(u7, p42, p43)
	end
end
function module.setBinding(p44, p45, p46)
	if not keybindSettings.isRebindable(p44) then
	elseif p45 ~= 1 and p45 ~= 2 then
	elseif p46 == nil or keybindSettings.isValid(p46) then
		local v121 = u7[p44]

		if not v121 then
			return false
		end

		if p46 ~= nil then
			clearConflicts(p44, p46)

			for i = #v121, 1, -1 do
				if p46 == v121[i] then
					table.remove(v121, i)
				end
			end

			if p45 <= #v121 then
				v121[p45] = p46
			else
				table.insert(v121, p46)
			end
		elseif v121[p45] then
			table.remove(v121, p45)
		end

		u7 = keybindSettings.sanitize(u7)
		rebindAll()
		bindableEvent:Fire()

		if not u25 then
			u25 = true
			task.delay(0.5, function()
				u25 = false
				updateSettings:FireServer("UpdateKeybinds", u7)
			end)
		end

		return true
	end

	return false
end
function module.resetAction(p47)
	if not keybindSettings.isRebindable(p47) then
		return false
	end

	local v124 = keybindSettings.defaultsFor(p47)

	for _, v in ipairs(v124) do
		clearConflicts(p47, v)
	end

	u7[p47] = v124
	u7 = keybindSettings.sanitize(u7)
	rebindAll()
	bindableEvent:Fire()

	if not u25 then
		u25 = true
		task.delay(0.5, function()
			u25 = false
			updateSettings:FireServer("UpdateKeybinds", u7)
		end)
	end

	return true
end
function module.resetAll()
	u7 = keybindSettings.newState()
	u7 = keybindSettings.sanitize(u7)
	rebindAll()
	bindableEvent:Fire()

	if u25 then
		return
	end

	u25 = true
	task.delay(0.5, function()
		u25 = false
		updateSettings:FireServer("UpdateKeybinds", u7)
	end)
end

updateSettings.OnClientEvent:Connect(function(p48, p49)
	if p48 == "SyncKeybinds" then
		u7 = keybindSettings.sanitize(p49)
		u12 = true
		rebindAll()
		bindableEvent:Fire()

		return
	end
end)
task.spawn(function()
	local n1: number = 0

	while not u12 and n1 < 30 do
		updateSettings:FireServer("RequestKeybinds")
		n1 += 1
		task.wait(1)
	end
end)

return module
