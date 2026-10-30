-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local module: {[any]: any} = {}
local LocalPlayer: Player = players.LocalPlayer
local fovSync = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FOVSync")
local n1 = 70
local t2: {[any]: any} = {}
local u8 = nil
local t3: {[any]: any} = {}
local u10 = nil

local function getSpectateTarget()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 and spectating ~= LocalPlayer.UserId then
		return spectating
	end

	return nil
end
local function sumOffsets(p1)
	local n1 = 0

	for _, v in pairs(p1) do
		n1 += v
	end

	return n1
end
local function snapshotOffsets()
	local t6: {[any]: any} = {}

	for k, v in pairs(t2) do
		t6[k] = v
	end

	return t6
end

local t4: {[any]: any} = {}
local t5: {[any]: any} = {}

for _, v in ipairs(Enum.EasingStyle:GetEnumItems()) do
	t4[v] = v.Name
	t5[v.Name] = v
end

local function sendPatch(p2, p3)
	local t7: {[any]: any} = {}

	for k, v in pairs(t2) do
		t7[k] = v
	end

	fovSync:FireServer("Patch", {
		offsets = t7,
		tweenTime = p2 or 0.2,
		tweenStyle = p3 and t4[p3] or nil
	})
end
local function tweenFOV(p4, p5)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local fieldOfView = module.GetTarget()

	if u8 then
		u8:Cancel()
	end

	if p4 <= 0 then
		CurrentCamera.FieldOfView = fieldOfView

		return
	end

	local tweenInfo = TweenInfo.new(p4, p5 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	u8 = tweenService:Create(CurrentCamera, tweenInfo, { FieldOfView = fieldOfView })
	u8:Play()
end
function module.SetBase(p6)
	local floored = math.floor(p6)

	n1 = math.clamp(floored, 40, 120)
	module._Apply(0.2)
end
function module.GetBase()
	return n1
end
function module.GetTarget()
	if u10 then
		local v41 = t3[u10]
		local v42 = n1
		local n3

		if v41 then
			n3 = 0

			for _, v in pairs(v41) do
				n3 += v
			end

			if not n3 then
				n3 = 0
			end
		else
			n3 = 0
		end

		return v42 + n3
	end

	local v46 = n1
	local n2 = 0

	for _, v in pairs(t2) do
		n2 += v
	end

	return v46 + n2
end
function module.Push(p7, p8, p9, p10)
	t2[p7] = p8

	local v54 = p9 or 0.2
	local t8: {[any]: any} = {}

	for k, v in pairs(t2) do
		t8[k] = v
	end

	fovSync:FireServer("Patch", {
		offsets = t8,
		tweenTime = v54 or 0.2,
		tweenStyle = p10 and t4[p10] or nil
	})

	if not u10 then
		tweenFOV(v54, p10)
	end
end
function module.Set(p11, p12)
	t2[p11] = p12
end
function module.Remove(p13)
	t2[p13] = nil
end
function module.Pop(p14, p15, p16)
	if t2[p14] == nil then
		return
	end

	t2[p14] = nil

	local v64 = p15 or 0.2
	local t9: {[any]: any} = {}

	for k, v in pairs(t2) do
		t9[k] = v
	end

	fovSync:FireServer("Patch", {
		offsets = t9,
		tweenTime = v64 or 0.2,
		tweenStyle = p16 and t4[p16] or nil
	})

	if not u10 then
		tweenFOV(v64, p16)
	end
end
function module.PopAll(p17)
	table.clear(t2)

	local v69 = p17 or 0.2
	local t10: {[any]: any} = {}

	for k, v in pairs(t2) do
		t10[k] = v
	end

	fovSync:FireServer("Patch", { tweenStyle = nil, offsets = t10, tweenTime = v69 or 0.2 })

	if not u10 then
		tweenFOV(v69)
	end
end
function module._Apply(p18, p19)
	local t11: {[any]: any} = {}

	for k, v in pairs(t2) do
		t11[k] = v
	end

	fovSync:FireServer("Patch", {
		offsets = t11,
		tweenTime = p18 or 0.2,
		tweenStyle = p19 and t4[p19] or nil
	})
	tweenFOV(p18, p19)
end
local function handleInbound(p20, p21, p22)
	if p20 == "PatchFrom" then
		if typeof(p21) == "number" and typeof(p22) == "table" then
			if typeof(p22.offsets) == "table" then
				t3[p21] = p22.offsets

				if p21 == u10 then
					local v81 = typeof(p22.tweenTime) == "number" and p22.tweenTime or 0.2
					local typeName: string = typeof(p22.tweenStyle)

					tweenFOV(v81, typeName == "string" and t5[p22.tweenStyle] or nil)
				end

				return
			end

			return
		end
	elseif p20 == "SnapshotRequest" then
		if typeof(p21) == "number" then
			local t12: {[any]: any} = {}

			for k, v in pairs(t2) do
				t12[k] = v
			end

			fovSync:FireServer("SnapshotResponse", p21, { tweenTime = 0.15, offsets = t12 })

			return
		end
	elseif p20 == "Snapshot" then
		if typeof(p21) == "number" and typeof(p22) == "table" then
			if typeof(p22.offsets) == "table" then
				t3[p21] = p22.offsets

				if p21 == u10 then
					local typeName: string = typeof(p22.tweenTime)

					tweenFOV(typeName == "number" and p22.tweenTime or 0.15)
				end

				return
			end

			return
		end

		return
	end
end

fovSync.OnClientEvent:Connect(handleInbound)

function module.__ReplayInvoke(p23, p24, p25)
	handleInbound(p23, p24, p25)
end

LocalPlayer.CharacterAdded:Connect(function()
	if u10 then
		return
	end

	table.clear(t2)

	local t13 = {}

	for k, v in pairs(t2) do
		t13[k] = v
	end

	fovSync:FireServer("Patch", { tweenTime = 0, tweenStyle = nil, offsets = t13 })

	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	t13 = module.GetTarget()

	if u8 then
		u8:Cancel()
	end

	CurrentCamera.FieldOfView = t13
end)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local v95 = if typeof(spectating) == "number" and spectating ~= 0 and spectating ~= LocalPlayer.UserId then spectating else nil

	if v95 ~= u10 then
		u10 = v95

		if v95 then
			fovSync:FireServer("RequestSnapshot", v95)
			tweenFOV(0.15)

			return
		end

		tweenFOV(0.2)

		return
	end
end)

return module
