-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local LocalPlayer: Player = players.LocalPlayer
local weaponAuthDebugDraw: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("WeaponAuthDebugDraw", math.huge)
local weaponAuthDebugAdornments: Folder = Instance.new("Folder")

weaponAuthDebugAdornments.Name = "WeaponAuthDebugAdornments"
weaponAuthDebugAdornments.Parent = LocalPlayer:WaitForChild("PlayerGui")

local color3 = Color3.fromRGB(245, 245, 245)
local color32 = Color3.fromRGB(255, 60, 60)
local color33 = Color3.fromRGB(60, 235, 110)
local color34 = Color3.fromRGB(255, 215, 0)

local function box(cFrame, p2, color3, transparency)
	local boxHandleAdornment: BoxHandleAdornment = Instance.new("BoxHandleAdornment")

	boxHandleAdornment.Adornee = workspace.Terrain
	boxHandleAdornment.CFrame = cFrame
	boxHandleAdornment.Size = p2
	boxHandleAdornment.Color3 = color3
	boxHandleAdornment.Transparency = transparency
	boxHandleAdornment.AlwaysOnTop = true
	boxHandleAdornment.ZIndex = 1
	boxHandleAdornment.Parent = weaponAuthDebugAdornments

	return boxHandleAdornment
end
local function label(cFrame, text, textColor3)
	local part: Part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Size = Vector3.new(0.05, 0.05, 0.05)
	part.CFrame = cFrame
	part.Parent = weaponAuthDebugAdornments

	local billboardGui: BillboardGui = Instance.new("BillboardGui")

	billboardGui.Size = UDim2.fromOffset(150, 18)
	billboardGui.StudsOffset = Vector3.new(0, 1.6, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = part

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = textColor3
	textLabel.TextStrokeTransparency = 0
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.Code
	textLabel.Parent = billboardGui

	return part
end

local t1: {[any]: any} = { live = color3, legacy = color32, stamped = color33, aim = color34 }

weaponAuthDebugDraw.OnClientEvent:Connect(function(p8)
	if typeof(p8) == "table" then
		local t2: {[any]: any} = {}

		if typeof(p8.liveCf) == "CFrame" and typeof(p8.liveSize) == "Vector3" then
			local liveCf = p8.liveCf
			local liveSize = p8.liveSize
			local live = t1.live
			local boxHandleAdornment: BoxHandleAdornment = Instance.new("BoxHandleAdornment")

			boxHandleAdornment.Adornee = workspace.Terrain
			boxHandleAdornment.CFrame = liveCf
			boxHandleAdornment.Size = liveSize
			boxHandleAdornment.Color3 = live
			boxHandleAdornment.Transparency = 0.75
			boxHandleAdornment.AlwaysOnTop = true
			boxHandleAdornment.ZIndex = 1
			boxHandleAdornment.Parent = weaponAuthDebugAdornments
			table.insert(t2, boxHandleAdornment)
		end

		if typeof(p8.legacyCf) == "CFrame" and typeof(p8.legacySize) == "Vector3" then
			local legacyCf = p8.legacyCf
			local legacySize = p8.legacySize
			local legacy = t1.legacy
			local boxHandleAdornment: BoxHandleAdornment = Instance.new("BoxHandleAdornment")

			boxHandleAdornment.Adornee = workspace.Terrain
			boxHandleAdornment.CFrame = legacyCf
			boxHandleAdornment.Size = legacySize
			boxHandleAdornment.Color3 = legacy
			boxHandleAdornment.Transparency = 0.45
			boxHandleAdornment.AlwaysOnTop = true
			boxHandleAdornment.ZIndex = 1
			boxHandleAdornment.Parent = weaponAuthDebugAdornments
			table.insert(t2, boxHandleAdornment)

			local v34 = label(p8.legacyCf, "LEGACY", t1.legacy)

			table.insert(t2, v34)
		end

		if typeof(p8.stampedCf) == "CFrame" and typeof(p8.stampedSize) == "Vector3" then
			local stampedCf = p8.stampedCf
			local stampedSize = p8.stampedSize
			local stamped = t1.stamped
			local boxHandleAdornment: BoxHandleAdornment = Instance.new("BoxHandleAdornment")

			boxHandleAdornment.Adornee = workspace.Terrain
			boxHandleAdornment.CFrame = stampedCf
			boxHandleAdornment.Size = stampedSize
			boxHandleAdornment.Color3 = stamped
			boxHandleAdornment.Transparency = 0.45
			boxHandleAdornment.AlwaysOnTop = true
			boxHandleAdornment.ZIndex = 1
			boxHandleAdornment.Parent = weaponAuthDebugAdornments
			table.insert(t2, boxHandleAdornment)

			local v39 = label(p8.stampedCf, "STAMPED", t1.stamped)

			table.insert(t2, v39)
		end

		if typeof(p8.aimFrom) == "Vector3" and typeof(p8.aimTo) == "Vector3" then
			local n1 = p8.aimTo - p8.aimFrom
			local magnitude = n1.Magnitude

			if magnitude > 0.1 then
				local cFrame = CFrame.lookAt(p8.aimFrom + n1 * 0.5, p8.aimTo)
				local vector3 = Vector3.new(0.06, 0.06, magnitude)
				local aim = t1.aim
				local boxHandleAdornment: BoxHandleAdornment = Instance.new("BoxHandleAdornment")

				boxHandleAdornment.Adornee = workspace.Terrain
				boxHandleAdornment.CFrame = cFrame
				boxHandleAdornment.Size = vector3
				boxHandleAdornment.Color3 = aim
				boxHandleAdornment.Transparency = 0.5
				boxHandleAdornment.AlwaysOnTop = true
				boxHandleAdornment.ZIndex = 1
				boxHandleAdornment.Parent = weaponAuthDebugAdornments
				table.insert(t2, boxHandleAdornment)
			end
		end

		if typeof(p8.bucket) == "string" and typeof(p8.legacyCf) == "CFrame" then
			local v46 = label(p8.legacyCf * CFrame.new(0, 1.4, 0), p8.bucket, t1.live)

			table.insert(t2, v46)
		end

		local v47 = typeof(p8.ttl) == "number" and math.clamp(p8.ttl, 0.1, 20) or 2

		task.delay(v47, function()
			for _, v in ipairs(t2) do
				if v and v.Parent then
					v:Destroy()
				end
			end
		end)

		return
	end
end)
