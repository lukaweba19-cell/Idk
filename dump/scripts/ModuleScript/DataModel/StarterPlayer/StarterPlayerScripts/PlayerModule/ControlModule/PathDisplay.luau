-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v2 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI2")
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local module: {[any]: any} = {
	spacing = 8,
	image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
	imageSize = Vector2.new(2, 2)
}
local t2 = {}
local t3: {[any]: any} = {}
local pathDisplayPoints: Model = Instance.new("Model")

pathDisplayPoints.Name = "PathDisplayPoints"

local pathDisplayAdornee: Part = Instance.new("Part")

pathDisplayAdornee.Anchored = true
pathDisplayAdornee.CanCollide = false
pathDisplayAdornee.Transparency = 1
pathDisplayAdornee.Name = "PathDisplayAdornee"
pathDisplayAdornee.CFrame = CFrame.new(0, 0, 0)
pathDisplayAdornee.Parent = pathDisplayPoints

local t4: {[any]: any} = {}
local n1: number = 30

for i = 1, n1 do
	local imageHandleAdornment: ImageHandleAdornment = Instance.new("ImageHandleAdornment")

	imageHandleAdornment.Archivable = false
	imageHandleAdornment.Adornee = pathDisplayAdornee
	imageHandleAdornment.Image = module.image
	imageHandleAdornment.Size = module.imageSize
	t4[i] = imageHandleAdornment
end

local function retrieveFromPool()
	local v16 = t4[1]

	if not v16 then
		return nil
	end

	t4[1] = t4[n1]
	t4[n1] = nil
	n1 -= 1

	return v16
end
local function returnToPool(p1)
	n1 += 1
	t4[n1] = p1
end
local function renderPoint(p2, _)
	if n1 == 0 then
		return nil
	end

	local v20 = t4[1]
	local v21

	if not v20 then
		v21 = nil
	else
		t4[1] = t4[n1]
		t4[n1] = nil
		n1 -= 1
		v21 = v20
	end

	if v2 then
		raycastParams.FilterDescendantsInstances = { game.Players.LocalPlayer.Character, workspace.CurrentCamera }

		local v22 = workspace:Raycast(p2 + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0), raycastParams)

		if not v22 then
			return nil
		end

		v21.CFrame = CFrame.lookAlong(v22.Position, v22.Normal)
		v21.Parent = pathDisplayPoints

		return v21
	end

	local ray = Ray.new(p2 + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0))
	local v24, v25, v26 = workspace:FindPartOnRayWithIgnoreList(ray, { game.Players.LocalPlayer.Character, workspace.CurrentCamera })

	if not v24 then
		return nil
	end

	v21.CFrame = CFrame.new(v25, v25 + v26)
	v21.Parent = pathDisplayPoints

	return v21
end
function module.setCurrentPoints(p4)
	if typeof(p4) == "table" then
		t2 = p4

		return
	end

	t2 = {}
end
function module.clearRenderedPath()
	for _, v in ipairs(t3) do
		v.Parent = nil
		n1 += 1
		t4[n1] = v
	end

	t3 = {}
	pathDisplayPoints.Parent = nil
end
function module.renderPath()
	module.clearRenderedPath()

	if t2 and #t2 ~= 0 then
		local n1: number = #t2
		local n2 = 0

		t3[1] = renderPoint(t2[n1], true)

		if not t3[1] then
			return
		end

		while true do
			local v32 = t2[n1]

			if n1 < 2 then
				break
			end

			local n3 = t2[n1 - 1] - v32
			local magnitude = n3.magnitude

			if n2 > magnitude then
				n2 -= magnitude
				n1 -= 1
			else
				local v35 = renderPoint(v32 + n3.unit * n2, false)

				if v35 then
					t3[#t3 + 1] = v35
				end

				n2 += module.spacing
			end
		end

		pathDisplayPoints.Parent = workspace.CurrentCamera

		return
	end
end

return module
