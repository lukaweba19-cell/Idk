-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local assetService: AssetService = game:GetService("AssetService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local workspace: Workspace = game:GetService("Workspace")
local animatedSkins = require(replicatedStorage.Shared.AnimatedSkins)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

for _, v in ipairs(animatedSkins) do
	v.frameCount = #v.frames
	v.fps = v.fps or 8
	v.elapsed = 0
	v.frame = 1
	t1[v.base] = v

	for _, iterValue in ipairs(v.frames) do
		t2[#t2 + 1] = iterValue
	end
end

local t3: {[any]: any} = {}

local function unregister(p1)
	local v38 = t3[p1]

	if not v38 then
		return
	end

	if v38.cleanupConn then
		v38.cleanupConn:Disconnect()
	end

	t3[p1] = nil
end
local function register(p2)
	if not p2:IsA("MeshPart") then
		return
	end

	if t3[p2] then
		return
	end

	local v40 = t1[p2.TextureID]

	if not v40 then
		return
	end

	local connection = p2.AncestryChanged:Connect(function(_, p4)
		if p4 == nil then
			local v106 = p2
			local v107 = t3[v106]

			if not v107 then
				return
			end

			if v107.cleanupConn then
				v107.cleanupConn:Disconnect()
			end

			t3[v106] = nil

			return
		end
	end)

	t3[p2] = { lastFrame = 0, entry = v40, cleanupConn = connection }
end

local animatedSkinsWaves = animatedSkins.Waves
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}
local object = setmetatable({}, { __mode = "k" })
local n1: number = 0

local function shiftInto(p5, p6)
	if p5.vertical then
		local n1 = p5.h * p5.rowBytes
		local n2 = p6 % p5.h * p5.rowBytes

		buffer.copy(p5.frame, 0, p5.src, n2, n1 - n2)
		buffer.copy(p5.frame, n1 - n2, p5.src, 0, n2)
	else
		local n3 = p6 % p5.w * 4

		for i = 0, p5.h - 1 do
			local n4 = i * p5.rowBytes

			buffer.copy(p5.frame, n4, p5.src, n4 + n3, p5.rowBytes - n3)
			buffer.copy(p5.frame, n4 + p5.rowBytes - n3, p5.src, n4, n3)
		end
	end

	local img = p5.img
	local vector2Zero = Vector2.zero
	local vector2 = Vector2.new(p5.w, p5.h)

	img:WritePixelsBuffer(vector2Zero, vector2, p5.frame)
end
local function makeRainbowScroller(p7)
	local n1: number = if p7 then 16 else 256
	local n2: number = if p7 then 256 else 16
	local u55 = nil

	if pcall(function()
		local vector2 = Vector2.new(n1, n2)

		u55 = assetService:CreateEditableImage({ Size = vector2 })
	end) and u55 ~= nil then
		local v56 = buffer.create(n1 * n2 * 4)

		for i = 0, n2 - 1 do
			for j = 0, n1 - 1 do
				local color3 = Color3.fromHSV(if p7 then i / n2 else j / n1, 1, 1)
				local n3: number = (i * n1 + j) * 4
				local floored = math.floor(color3.R * 255 + 0.5)

				buffer.writeu8(v56, n3, floored)

				local floored2 = math.floor(color3.G * 255 + 0.5)

				buffer.writeu8(v56, n3 + 1, floored2)

				local floored3 = math.floor(color3.B * 255 + 0.5)

				buffer.writeu8(v56, n3 + 2, floored3)
				buffer.writeu8(v56, n3 + 3, 255)
			end
		end

		local t6: {[any]: any} = {
			img = u55,
			src = v56,
			frame = buffer.create(n1 * n2 * 4),
			w = n1,
			h = n2,
			rowBytes = n1 * 4,
			vertical = p7
		}

		shiftInto(t6, 0)
		table.insert(t4, t6)

		return t6
	end

	warn("[AnimatedSkins] CreateEditableImage unavailable -- rainbow waves disabled")

	return nil
end

local u23 = nil
local u24 = nil
local u25 = nil

if animatedSkinsWaves then
	u23 = makeRainbowScroller(animatedSkinsWaves.scrollV == true)

	if u23 then
		local v26 = makeRainbowScroller(animatedSkinsWaves.scrollV ~= true)

		u24 = Content.fromObject(u23.img)

		if v26 then
			u25 = Content.fromObject(v26.img)
		else
			u25 = u24
		end
	end
end

makeRainbowScroller = function(p8, p9)
	local v67 = p8.Size

	if p9 == Enum.NormalId.Top or p9 == Enum.NormalId.Bottom then
		return v67.X, v67.Z
	end

	if p9 == Enum.NormalId.Front or p9 == Enum.NormalId.Back then
		return v67.X, v67.Y
	end

	return v67.Z, v67.Y
end

local function hookWaveDecal(p10, parent)
	if object[p10] then
		return
	end

	if p10.Name == "RainbowFace" or string.sub(p10.Name, -7) == "_Scroll" then
		return
	end

	object[p10] = true

	local u70: boolean = animatedSkinsWaves.decalScrollV == true

	if p10:IsA("Texture") then
		local v71 = math.max(0.001, p10.StudsPerTileU)
		local v72 = math.max(0.001, p10.StudsPerTileV)

		table.insert(t5, { tex = p10, vertical = u70, tileU = v71, tileV = v72 })

		return
	end

	if not p10:IsA("Decal") then
		return
	end

	local face = p10.Face
	local parentSize = parent.Size
	local v75
	local v76

	if face == Enum.NormalId.Top or face == Enum.NormalId.Bottom then
		v75 = parentSize.X
		v76 = parentSize.Z
	elseif face == Enum.NormalId.Front or face == Enum.NormalId.Back then
		v75 = parentSize.X
		v76 = parentSize.Y
	else
		v75 = parentSize.Z
		v76 = parentSize.Y
	end

	local texture: Texture = Instance.new("Texture")

	texture.Name = p10.Name .. "_Scroll"
	texture.Texture = p10.Texture
	texture.Face = p10.Face
	texture.Color3 = p10.Color3
	texture.Transparency = p10.Transparency
	texture.ZIndex = p10.ZIndex
	texture.StudsPerTileU = v75
	texture.StudsPerTileV = v76
	texture.Parent = parent
	p10.Transparency = 1
	table.insert(t5, { tex = texture, vertical = u70, tileU = v75, tileV = v76 })
end
local function registerWave(parent)
	if u23 == nil then
		return
	end

	if not parent:IsA("Decal") and not parent:IsA("Texture") then
		if not parent:IsA("BasePart") then
			return
		end

		if parent.Name ~= "Animate" and parent.Name ~= "Animate2" then
			return
		end

		if object[parent] then
			return
		end

		object[parent] = true

		local v79 = if parent.Name == "Animate2" then u25 else u24

		if parent:IsA("MeshPart") then
			local surfaceAppearance = parent:FindFirstChildOfClass("SurfaceAppearance")

			if surfaceAppearance then
				surfaceAppearance:Destroy()
			end

			pcall(function()
				parent.TextureContent = v79
			end)

			return
		end

		for _, v in ipairs(Enum.NormalId:GetEnumItems()) do
			local rainbowFace: Decal = Instance.new("Decal")

			rainbowFace.Name = "RainbowFace"
			rainbowFace.Face = v

			if not pcall(function()
				rainbowFace.TextureContent = v79
			end) then
				rainbowFace:Destroy()

				return
			end

			rainbowFace.Parent = parent
		end

		return
	end

	local parentParent = parent.Parent

	if parentParent and parentParent:IsA("BasePart") and (parentParent.Name == "Animate" or parentParent.Name == "Animate2") then
		hookWaveDecal(parent, parentParent)
	end
end
local function onDescendant(p13)
	register(p13)
	registerWave(p13)
end
local function scanSubtree(p14)
	register(p14)
	registerWave(p14)

	for _, v in ipairs(p14:GetDescendants()) do
		register(v)
		registerWave(v)
	end
end

local characters: Instance = workspace:WaitForChild("Characters")

characters.DescendantAdded:Connect(onDescendant)

for _, v in ipairs(characters:GetDescendants()) do
	register(v)
	registerWave(v)
end

local finisherPreviewRoom: Instance = workspace:WaitForChild("FinisherPreviewRoom", 10)

if finisherPreviewRoom then
	finisherPreviewRoom.DescendantAdded:Connect(onDescendant)

	for _, v in ipairs(finisherPreviewRoom:GetDescendants()) do
		register(v)
		registerWave(v)
	end
end

replicatedStorage:WaitForChild("Bindables"):WaitForChild("AnimateSkins").Event:Connect(function(p15)
	if typeof(p15) == "Instance" then
		register(p15)
		registerWave(p15)

		for _, v in ipairs(p15:GetDescendants()) do
			register(v)
			registerWave(v)
		end
	end
end)
pcall(function()
	contentProvider:PreloadAsync(t2)
end)
runService.Heartbeat:Connect(function(deltaTime: number)
	if u23 ~= nil then
		n1 += deltaTime

		if n1 >= 1 / animatedSkinsWaves.fps then
			n1 = 0

			local n2 = os.clock() * animatedSkinsWaves.speed

			for _, v in ipairs(t4) do
				local floored = math.floor(n2 * (if v.vertical then v.h else v.w))

				shiftInto(v, floored)
			end

			for i = #t5, 1, -1 do
				local v98 = t5[i]

				if not v98.tex.Parent then
					table.remove(t5, i)
				elseif v98.vertical then
					v98.tex.OffsetStudsV = -(n2 * v98.tileV % v98.tileV)
				else
					v98.tex.OffsetStudsU = -(n2 * v98.tileU % v98.tileU)
				end
			end
		end
	end

	for _, v in ipairs(animatedSkins) do
		v.elapsed = v.elapsed + deltaTime
		v.frame = math.floor(v.elapsed * v.fps) % v.frameCount + 1
	end

	for k, v in pairs(t3) do
		if k:IsDescendantOf(workspace) then
			local vEntry = v.entry

			if v.lastFrame ~= vEntry.frame then
				v.lastFrame = vEntry.frame
				k.TextureID = vEntry.frames[vEntry.frame]
			end
		end
	end
end)
