-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local workspace: Workspace = game:GetService("Workspace")
local t1: {[any]: any} = {
	Vector2.new(0, 0),
	Vector2.new(128, 0),
	Vector2.new(256, 0),
	Vector2.new(384, 0),
	Vector2.new(0, 256),
	Vector2.new(128, 256),
	Vector2.new(256, 256),
	Vector2.new(384, 256)
}
local n1: number = #t1
local color3 = Color3.fromRGB(255, 207, 0)
local color32 = Color3.fromRGB(255, 120, 0)
local color33 = Color3.fromRGB(255, 40, 40)
local color34 = Color3.fromRGB(160, 40, 200)
local color35 = Color3.fromRGB(40, 100, 255)
local t2: {[any]: any} = {
	{ streak = 1, color = color3 },
	{ streak = 30, color = color32 },
	{ streak = 100, color = color33 },
	{ streak = 200, color = color34 },
	{ streak = 500, color = color35 }
}
local n2: number = #t2

local function rampColor(p1)
	if p1 <= t2[1].streak then
		return t2[1].color
	end

	for i = 2, n2 do
		local v20 = t2[i]

		if p1 <= v20.streak then
			local v21 = t2[i - 1]

			return v21.color:Lerp(v20.color, (p1 - v21.streak) / (v20.streak - v21.streak))
		end
	end

	return t2[n2].color
end

local object = setmetatable({}, { __mode = "k" })

local function registerFlame(p2)
	local flame = p2:FindFirstChild("Flame")

	if not flame or not flame:IsA("ImageLabel") then
		return
	end

	if object[flame] then
		return
	end

	local label = p2:FindFirstChild("Label")
	local uiStroke = label and label:FindFirstChild("UIStroke")

	flame.ImageRectSize = Vector2.new(128, 256)
	object[flame] = {
		flame = flame,
		label = label and label:IsA("TextLabel") and label or nil,
		stroke = uiStroke and uiStroke:IsA("UIStroke") and uiStroke or nil
	}
end
local function scanOverhead(p3)
	if p3:IsA("BillboardGui") and p3.Name == "OVERHEAD" then
		local headFlame = p3:FindFirstChild("HeadFlame")

		if headFlame then
			registerFlame(headFlame)

			return
		end

		local connection = nil

		connection = p3.ChildAdded:Connect(function(p4)
			if p4.Name == "HeadFlame" then
				if connection then
					connection:Disconnect()
				end

				registerFlame(p4)
			end
		end)

		return
	end
end

workspace:WaitForChild("Characters").DescendantAdded:Connect(function(p5: Instance)
	if p5:IsA("BillboardGui") and p5.Name == "OVERHEAD" then
		scanOverhead(p5)
	end
end)

for _, v in ipairs(workspace.Characters:GetDescendants()) do
	if v:IsA("BillboardGui") and v.Name == "OVERHEAD" then
		scanOverhead(v)
	end
end

local n3: number = 1

task.spawn(function()
	while true do
		n3 = n3 % n1 + 1

		local imageRectOffset = t1[n3]

		for k, v in pairs(object) do
			local vFlame = v.flame

			if vFlame.Parent and vFlame:IsDescendantOf(workspace) then
				vFlame.ImageRectOffset = imageRectOffset

				local v34 = v.label and tonumber(v.label.Text) or 2
				local imageColor3 = rampColor(v34 or 2)

				vFlame.ImageColor3 = imageColor3

				if v.stroke then
					v.stroke.Color = Color3.new(imageColor3.R * 0.5686274509803921, imageColor3.G * 0.5686274509803921, imageColor3.B * 0.5686274509803921)
				end
			else
				object[k] = nil
			end
		end

		task.wait(0.05)
	end
end)
