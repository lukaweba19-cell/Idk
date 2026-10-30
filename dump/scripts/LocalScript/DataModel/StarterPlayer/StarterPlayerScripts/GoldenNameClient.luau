-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace: Workspace = game:GetService("Workspace")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local seasonPassGate = require(shared:WaitForChild("SeasonPassGate"))
local color3 = Color3.fromRGB(255, 236, 150)
local color32 = Color3.fromRGB(184, 128, 20)
local color33 = Color3.fromRGB(240, 200, 90)
local color34 = Color3.fromRGB(255, 110, 100)
local color35 = Color3.fromRGB(190, 16, 28)
local color36 = Color3.fromRGB(232, 48, 52)

local function hex(p1)
	local stringFormat = string.format
	local floored = math.floor(p1.R * 255 + 0.5)
	local floored2 = math.floor(p1.G * 255 + 0.5)
	local floored3 = math.floor(p1.B * 255 + 0.5)

	return stringFormat("#%02X%02X%02X", floored, floored2, floored3)
end
local function makePalette(p2, p3, p4, p5)
	local v45 = table.create(60)

	for i = 0, 59 do
		local cosine = math.cos(i / 60 * 3.141592653589793 * 2)
		local v48 = p3:Lerp(p4, (cosine + 1) * 0.5)
		local stringFormat = string.format
		local floored = math.floor(v48.R * 255 + 0.5)
		local floored4 = math.floor(v48.G * 255 + 0.5)
		local floored5 = math.floor(v48.B * 255 + 0.5)

		v45[i + 1] = stringFormat("#%02X%02X%02X", floored, floored4, floored5)
	end

	local v53 = string.format
	local floored6 = math.floor(p5.R * 255 + 0.5)
	local floored7 = math.floor(p5.G * 255 + 0.5)
	local floored8 = math.floor(p5.B * 255 + 0.5)
	local v57 = v53("#%02X%02X%02X", floored6, floored7, floored8)

	return { key = p2, ramp = v45, staticOpen = "<font color=\"" .. v57 .. "\">" }
end

local v16 = makePalette("gold", color32, color3, color33)
local v17 = makePalette("red", color35, color34, color36)

makePalette = function(p6)
	return (p6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function buildFrames(p7, p8)
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}

	if pcall(function()
		for iterFirst, iterSecond in utf8.codes(p7) do
			table.insert(t6, iterSecond)

			local replacedText = utf8.char(iterSecond):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

			table.insert(t5, replacedText)
		end
	end) and #t5 ~= 0 then
		local n1: number = #t5
		local v64 = table.create(60)

		for i = 0, 59 do
			local v66 = table.create(n1)

			for j = 1, n1 do
				if t6[j] == 57344 then
					v66[j] = t5[j]
				else
					local ramp = p8.ramp
					local floored = math.floor(((j - 1) / n1 - i / 60) % 1 * 60)

					v66[j] = "<font color=\"" .. ramp[floored % 60 + 1] .. "\">" .. t5[j] .. "</font>"
				end
			end

			v64[i + 1] = table.concat(v66)
		end

		return v64
	end

	return nil
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function getFrames(p9, p10)
	local s1 = p10.key .. ":" .. p9
	local v73 = t1[s1]

	if v73 then
		return v73
	end

	v73 = buildFrames(p9, p10)

	if not v73 then
		return nil
	end

	t1[s1] = v73
	table.insert(t2, s1)
	s1 = #t2 > 16 and table.remove(t2, 1)

	if s1 then
		t1[s1] = nil
	end

	return v73
end

local t3: {[any]: any} = {}
local t4: {[any]: any} = {}

local function resolvePlate(player)
	local Character = player.Character

	if not Character then
		return nil, nil
	end

	local overhead = Character:FindFirstChild("OVERHEAD")

	if not overhead or not overhead:IsA("BillboardGui") or not overhead.Enabled then
		return nil, nil
	end

	local name = overhead:FindFirstChild("Name")
	local v78 = name

	if v78 then
		v78 = name:FindFirstChild("NameLabel")
	end

	if not v78 or not v78:IsA("TextLabel") then
		return nil, nil
	end

	local v79 = Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
	local v80 = v79 and v79:IsA("BasePart")

	return v78, v80 and v79 or nil
end
local function applyStatic(p12, p13, p14)
	local staticOpen = p14.staticOpen
	local replacedText = p13:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local text: string = staticOpen .. replacedText .. "</font>"

	if p12.Text ~= text then
		p12.Text = text
	end
end
local function restore(p15, text)
	if p15.Parent then
		p15.Text = text
	end
end
local function paletteFor(p17, p18)
	if p17:GetAttribute("ContentCreator") == true then
		return v17
	end

	if p18 and p17:GetAttribute("SeasonPassPremium") == true then
		return v16
	end

	return nil
end

local connection = nil
local n1 = -1

local function step()
	local v91 = os.clock()
	local n2 = math.floor(v91 % 2 / 2 * 60) % 60 + 1

	if n2 == n1 then
		return
	end

	n1 = n2

	for i = #t4, 1, -1 do
		local v94 = t4[i]

		if v94.label.Parent == nil then
			table.remove(t4, i)
		else
			v94.label.Text = v94.frames[n2]
		end
	end

	if #t4 == 0 and connection then
		connection:Disconnect()
		connection = nil
	end
end
local function ensureRenderLoop()
	if #t4 > 0 and not connection then
		n1 = -1
		connection = runService.RenderStepped:Connect(step)
	end
end
local function rankPass()
	local v95 = seasonPassGate.IsEnabled()
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local currentCameraCFrame: CFrame = CurrentCamera.CFrame
	local currentCameraCFramePosition = currentCameraCFrame.Position
	local currentCameraCFrameLookVector = currentCameraCFrame.LookVector
	local t7: {[any]: any} = {}
	local t8 = nil
	local t9: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		local v105 = if v:GetAttribute("ContentCreator") == true then v17 else if v95 and v:GetAttribute("SeasonPassPremium") == true then v16 else nil

		if v105 then
			local v106, v107 = resolvePlate(v)

			if v106 and v106.Text ~= "" then
				local v108 = t3[v106]

				if not v108 then
					v108 = v106.Text
					t3[v106] = v108
				end

				t9[v106] = true

				local t10: {[any]: any} = { dist = 0, label = v106, plain = v108, palette = v105 }

				if v == LocalPlayer then
					t8 = t10
				elseif v107 then
					local n2 = v107.Position - currentCameraCFramePosition
					local magnitude = n2.Magnitude

					if magnitude <= 150 and n2:Dot(currentCameraCFrameLookVector) > 0 then
						t10.dist = magnitude
						table.insert(t7, t10)
					else
						local staticOpen = v105.staticOpen
						local replacedText = v108:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
						local text: string = staticOpen .. replacedText .. "</font>"

						if v106.Text ~= text then
							v106.Text = text
						end
					end
				else
					local v115 = v105.staticOpen
					local replacedText = v108:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
					local s2: string = v115 .. replacedText .. "</font>"

					if v106.Text ~= s2 then
						v106.Text = s2
					end
				end
			end
		end
	end

	table.sort(t7, function(p19, p20)
		return p19.dist < p20.dist
	end)
	table.clear(t4)

	local function admit(p21)
		local plain = p21.plain
		local palette = p21.palette
		local s1: string = palette.key .. ":" .. plain
		local v141 = t1[s1]
		local v142

		if v141 then
			v142 = v141
		else
			local v143 = buildFrames(plain, palette)

			if not v143 then
				v142 = nil
			else
				t1[s1] = v143
				table.insert(t2, s1)

				local v144 = #t2 > 16 and table.remove(t2, 1)

				if v144 then
					t1[v144] = nil
				end

				v142 = v143
			end
		end

		if v142 then
			table.insert(t4, { label = p21.label, frames = v142 })

			return
		end

		local label = p21.label
		local staticOpen = p21.palette.staticOpen
		local replacedText = p21.plain:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

		v141 = staticOpen .. replacedText .. "</font>"

		if label.Text ~= v141 then
			label.Text = v141
		end
	end

	if t8 then
		admit(t8)
	end

	for i, v in ipairs(t7) do
		if i <= 8 then
			admit(v)
		else
			local vLabel = v.label
			local v122 = v.palette.staticOpen
			local replacedText = v.plain:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			local s3: string = v122 .. replacedText .. "</font>"

			if vLabel.Text ~= s3 then
				vLabel.Text = s3
			end
		end
	end

	for k, v in pairs(t3) do
		if not t9[k] then
			if k.Parent then
				k.Text = v
			end

			t3[k] = nil
		end
	end

	if #t4 > 0 and not connection then
		n1 = -1
		connection = runService.RenderStepped:Connect(step)
	end
end
local function watchStyle(p22)
	local function rerank()
		task.defer(rankPass)
	end

	p22:GetAttributeChangedSignal("SeasonPassPremium"):Connect(rerank)
	p22:GetAttributeChangedSignal("ContentCreator"):Connect(rerank)
end

players.PlayerAdded:Connect(watchStyle)

for _, v in ipairs(players:GetPlayers()) do
	watchStyle(v)
end

seasonPassGate.Changed():Connect(function()
	task.defer(rankPass)
end)
task.spawn(function()
	local v129
	local v130
	local text

	while true do
		v129, v130 = pcall(rankPass)

		if not v129 then
			text = tostring(v130)
			warn("[GoldenName] rank pass failed: " .. text)
		end

		task.wait(0.25)

		continue
	end
end)
