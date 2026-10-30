-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local httpService: HttpService = game:GetService("HttpService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local windowBlur = require(replicatedStorage.Shared:WaitForChild("WindowBlur"))
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local readyBtn: Instance = scriptParent:WaitForChild("ReadyBtn")
local uiGradient: Instance = readyBtn:FindFirstChildOfClass("UIGradient")
local textLabel: Instance = readyBtn:FindFirstChild("TextLabel")
local duelStationReady: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("DuelStationReady")
local duelStations: Instance = workspace:WaitForChild("DuelStations")
local t1: {[any]: any} = {
	gradient = if uiGradient then uiGradient.Color else nil,
	shadow = v14
}
local v14 = if textLabel then textLabel.TextColor3 else Color3.new(0, 0, 0)
local t2: {[any]: any} = { green = t1 }
local colorSequenceNew = ColorSequence.new
local color3 = Color3.fromRGB(255, 226, 140)

v14 = colorSequenceNew(color3, Color3.fromRGB(214, 139, 0))

local color32 = Color3.fromRGB(122, 70, 0)

t2.amber = { gradient = v14, shadow = color32 }

local v19 = ColorSequence.new
local color33 = Color3.fromRGB(205, 205, 205)

v14 = v19(color33, Color3.fromRGB(120, 120, 120))

local color34 = Color3.fromRGB(60, 60, 60)

t2.grey = { gradient = v14, shadow = color34 }

local function setLook(p1, text)
	local v38 = t2[p1]

	if uiGradient and v38.gradient then
		uiGradient.Color = v38.gradient
	end

	if textLabel then
		textLabel.TextColor3 = v38.shadow
	end

	for iterFirst, iterSecond in readyBtn:GetDescendants() do
		if iterSecond:IsA("TextLabel") then
			iterSecond.Text = text
		end
	end
end
local function decode(p3)
	if typeof(p3) == "string" and p3 ~= "" then
		local ok, result = pcall(httpService.JSONDecode, httpService, p3)

		if ok and typeof(result) == "table" then
			local t4: {[any]: any} = {}

			for _, v in ipairs(result) do
				if typeof(v) == "number" then
					local floored = math.floor(v)

					table.insert(t4, floored)
				end
			end

			return t4
		end

		return {}
	end

	return {}
end
local function myStation()
	for iterFirst, iterSecond in duelStations:GetChildren() do
		local tableFind = table.find
		local v51 = decode(iterSecond:GetAttribute("QueueA"))

		if tableFind(v51, LocalPlayer.UserId) then
			return iterSecond, "A"
		end

		local v52 = table.find

		v51 = decode(iterSecond:GetAttribute("QueueB"))

		if v52(v51, LocalPlayer.UserId) then
			return iterSecond, "B"
		end
	end

	return nil, nil
end

local u25 = false
local u26 = nil
local u27: boolean = false
local u28: boolean = false

local function popIn()
	local popInScale = scriptParent:FindFirstChild("PopInScale")

	if not popInScale then
		local popInScale2: UIScale = Instance.new("UIScale")

		popInScale2.Name = "PopInScale"
		popInScale2.Parent = scriptParent
		popInScale = popInScale2
	end

	local v55 = popInScale

	v55.Scale = 0.85

	local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(v55, tweenInfo, { Scale = 1 }):Play()
end
local function refresh()
	local v57 = nil
	local v58 = nil

	if LocalPlayer:GetAttribute("DuelStationQueued") == true and LocalPlayer:GetAttribute("InMatch") ~= true then
		local v59, v60 = myStation()

		v57 = v59
		v58 = v60
	end

	u26 = v57

	local u61: boolean = v57 ~= nil and v58 ~= nil and v58 == v57:GetAttribute("ShortSide")
	local visible: boolean = u61 and not u25

	scriptParent.Visible = visible

	if visible and not u28 then
		popIn()
	end

	u28 = visible

	if u61 and v57 then
		local v63 = decode(v57:GetAttribute(if v58 == "A" then "QueueA" else "QueueB"))
		local v64 = decode(v57:GetAttribute("ReadyIds"))

		u27 = table.find(v64, LocalPlayer.UserId) ~= nil

		if v57:GetAttribute("Starting") == true then
			setLook("grey", "STARTING")

			return
		end

		if u27 then
			local n1: number = 0

			for _, v in ipairs(v63) do
				if table.find(v64, v) then
					n1 += 1
				end
			end

			setLook("amber", ("WAITING %d/%d"):format(n1, #v63))

			return
		end

		setLook("green", "READY")

		return
	end

	u27 = false
end

local n1 = 0

readyBtn.Activated:Connect(function()
	local v68 = u26

	if v68 and v68:GetAttribute("Starting") ~= true then
		if os.clock() - n1 < 0.3 then
			return
		end

		n1 = os.clock()
		duelStationReady:FireServer(not u27)

		return
	end
end)

local t3: {[any]: any} = { "QueueA", "QueueB", "ShortSide", "ReadyIds", "Starting" }

local function hookStation(p4)
	for key, value in t3 do
		p4:GetAttributeChangedSignal(value):Connect(refresh)
	end
end

for iterFirst, iterSecond in duelStations:GetChildren() do
	hookStation(iterSecond)
end

duelStations.ChildAdded:Connect(function(p5: Instance)
	hookStation(p5)
	refresh()
end)
LocalPlayer:GetAttributeChangedSignal("DuelStationQueued"):Connect(refresh)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(refresh)
windowBlur.onActiveChanged(function(p6)
	u25 = p6
	refresh()
end)
refresh()
