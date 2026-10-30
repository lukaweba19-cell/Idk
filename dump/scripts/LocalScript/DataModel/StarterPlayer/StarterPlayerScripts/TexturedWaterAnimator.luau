-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local n1 = 0
local connection = nil

local function addTexture(p1)
	if t2[p1] then
		return
	end

	t2[p1] = true
	table.insert(t1, {
		texture = p1,
		baseU = p1.OffsetStudsU,
		baseV = p1.OffsetStudsV,
		phase = #t1 * 0.7 % 6.283185307179586
	})
end
local function removeTexture(p2)
	if not t2[p2] then
		return
	end

	t2[p2] = nil

	for i = #t1, 1, -1 do
		if p2 == t1[i].texture then
			table.remove(t1, i)

			return
		end
	end
end
local function onPartAdded(p3)
	for _, v in ipairs(p3:GetChildren()) do
		if v:IsA("Texture") and not t2[v] then
			t2[v] = true
			table.insert(t1, {
				texture = v,
				baseU = v.OffsetStudsU,
				baseV = v.OffsetStudsV,
				phase = #t1 * 0.7 % 6.283185307179586
			})
		end
	end

	if not t3[p3] then
		t3[p3] = p3.ChildAdded:Connect(function(p4)
			if not p4:IsA("Texture") then
				return
			end

			if t2[p4] then
				return
			end

			t2[p4] = true
			table.insert(t1, {
				texture = p4,
				baseU = p4.OffsetStudsU,
				baseV = p4.OffsetStudsV,
				phase = #t1 * 0.7 % 6.283185307179586
			})
		end)
	end
end
local function step(p6)
	if LocalPlayer:GetAttribute("InMatch") then
		return
	end

	n1 += p6

	for i = #t1, 1, -1 do
		local v24 = t1[i]
		local texture = v24.texture

		if texture.Parent == nil then
			table.remove(t1, i)
			t2[texture] = nil
		else
			local n5 = v24.baseU + n1 * 4
			local n2 = v24.baseV + n1 * 2.8
			local sine = math.sin(n1 * 0.15707963267948966 + v24.phase)
			local n3 = n5 + sine * 6.366197723675814
			local cosine = math.cos(n1 * 0.15707963267948966 * 0.75 + v24.phase)
			local n4 = n2 + cosine * 6.366197723675814 * 0.6
			local textureStudsPerTileU = texture.StudsPerTileU
			local textureStudsPerTileV = texture.StudsPerTileV

			if textureStudsPerTileU > 0 then
				n3 %= textureStudsPerTileU
			end

			if textureStudsPerTileV > 0 then
				n4 %= textureStudsPerTileV
			end

			texture.OffsetStudsU = n3
			texture.OffsetStudsV = n4
		end
	end

	if #t1 == 0 and connection then
		connection:Disconnect()
		connection = nil
	end
end
local function ensureRunning()
	if not connection and #t1 ~= 0 then
		connection = runService.Heartbeat:Connect(step)

		return
	end
end

for _, v in ipairs(collectionService:GetTagged("TexturedWaterPart")) do
	onPartAdded(v)
end

if not connection and #t1 ~= 0 then
	connection = runService.Heartbeat:Connect(step)
end

collectionService:GetInstanceAddedSignal("TexturedWaterPart"):Connect(function(p7)
	onPartAdded(p7)

	if connection then
		return
	end

	if #t1 == 0 then
		return
	end

	connection = runService.Heartbeat:Connect(step)
end)
collectionService:GetInstanceRemovedSignal("TexturedWaterPart"):Connect(function(p5)
	local v36 = t3[p5]

	if v36 then
		v36:Disconnect()
		t3[p5] = nil
	end

	for _, v in ipairs(p5:GetChildren()) do
		if v:IsA("Texture") then
			removeTexture(v)
		end
	end
end)
