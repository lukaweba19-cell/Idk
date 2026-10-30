-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local frames = require(script.Frames)
local numberValue: NumberValue = Instance.new("NumberValue")

numberValue.Value = 0.12

local t1: {[any]: any} = {
	Steepness = 0.044000000000000004,
	Wavelength = 210,
	Direction = Vector2.new(-6, -3)
}

game:GetService("RunService").Heartbeat:Connect(function()
	local n1: number = workspace:GetServerTimeNow() % 10

	t1.Steepness = 0.12 * (1 - ((n1 <= 5 and n1 or 10 - n1) / 5) ^ 2)
end)
numberValue.Changed:connect(function()
	t1.Steepness = numberValue.Value
end)

local v4 = math

local object = setmetatable({}, {
	__index = function(_, p2)
		return v4[p2]
	end
})

function object.dist(p3, p4)
	return object.sqrt((p3.X - p4.X) ^ 2 + (p3.Y - p4.Y) ^ 2)
end
function object.round(p5, p6)
	return object.floor(p5 * 10 ^ (p6 or 0) + 0.5) / 10 ^ (p6 or 0)
end

object.right = object.rad(90)
object.straight = object.rad(180)

function object.polar(p7, p8)
	if p8 then
		p7 = Vector2.new(p7, p8)
	end

	local vector2New = Vector2.new
	local v22 = object.sqrt(p7.X ^ 2 + p7.Y ^ 2)
	local vector2 = vector2New(v22, object.atan(p7.Y / p7.X))

	if p7.X < 0 then
		if p7.Y > 0 then
			return Vector2.new(vector2.X, vector2.Y + object.straight)
		end

		if p7.Y < 0 then
			return Vector2.new(vector2.X, vector2.Y + object.straight)
		end

		return Vector2.new(vector2.X, object.straight)
	end

	if p7.X > 0 then
		if p7.Y > 0 then
			return vector2
		end

		if p7.Y < 0 then
			return Vector2.new(vector2.X, object.pi * 2 + vector2.Y)
		end

		return Vector2.new(vector2.X, 0)
	end

	if p7.Y > 0 then
		return Vector2.new(vector2.X, object.right)
	end

	if p7.Y < 0 then
		return Vector2.new(vector2.X, object.right + object.straight)
	end

	return Vector2.new(0, object.straight * 2)
end
function object.cartesian(p9, p10)
	if p10 then
		p9 = Vector2.new(p9, p10)
	end

	local vector2New = Vector2.new
	local n1 = object.cos(p9.Y) * p9.X
	local v28 = object.sin(p9.Y)

	return vector2New(n1, v28 * p9.X)
end
local function float(p11)
	local v30, v31 = object.modf(p11)

	if v31 == 0 then
		return v30 .. ".0"
	end

	return p11
end
function normalize(p12)
	return 1 / object.sqrt(p12:Dot(p12)) * p12
end
function Wave(p13, p14, p15)
	local steepness = p13.Steepness
	local n1 = 2 * object.pi / p13.Wavelength
	local v38 = object.sqrt(35 / n1)
	local v39 = normalize(p13.Direction)
	local v40 = v39:Dot(Vector2.new(p14.x, p14.z))
	local n2 = n1 * (v40 - v38 * p15)
	local n3 = steepness / n1
	local x = v39.x
	local v44 = object.cos(n2)
	local v45 = object.sin(n2)
	local y = v39.y
	local v47 = object.cos(n2)
	local vector3 = Vector3.new(x * (n3 * v44), n3 * v45, y * (n3 * v47))

	return vector3
end

local seaTriangles: Folder = Instance.new("Folder")

seaTriangles.Name = "SeaTriangles"
seaTriangles.Parent = workspace.Bin

local __SeaTriangle: WedgePart = Instance.new("WedgePart")

__SeaTriangle.Name = "__SeaTriangle"
__SeaTriangle.Anchored = true
__SeaTriangle.TopSurface = Enum.SurfaceType.Smooth
__SeaTriangle.BottomSurface = Enum.SurfaceType.Smooth
__SeaTriangle.CanCollide = false
__SeaTriangle.Transparency = 1

local module: {[any]: any} = {}

function module.new(p16)
	local object2 = setmetatable({}, { __index = module })

	object2.Origin = p16 or Vector3.new(613.505, 670.462, -3226.88)
	object2.Detail = 2
	object2.DistanceBetweenPoints = 300
	object2.YCoordinate = p16.Y + 7.20799999999997
	object2.Points = {}

	local seaPlanes: Model = Instance.new("Model", seaTriangles)

	seaPlanes.Name = "SeaPlanes"
	object2.Planes = seaPlanes

	for i = (object2.Detail - 1) / -2, (object2.Detail - 1) / 2 do
		for j = (object2.Detail - 1) / -2, (object2.Detail - 1) / 2 do
			local clone = game.ReplicatedStorage.FX.Plane:Clone()

			clone.Parent = seaPlanes

			local n1 = clone.Size.X / 8

			for _, v in pairs(clone:GetChildren()) do
				if v:IsA("Bone") then
					object2.Points[i * 8 + v.Position.X / n1] = object2.Points[i * 8 + v.Position.X / n1] or {}
					object2.Points[i * 8 + v.Position.X / n1][j * 8 + v.Position.Z / n1] = object2.Points[i * 8 + v.Position.X / n1][j * 8 + v.Position.Z / n1] or {}
					table.insert(object2.Points[i * 8 + v.Position.X / n1][j * 8 + v.Position.Z / n1], v)
				end
			end
		end
	end

	object2.Wedges = {}
	object2.Model = Instance.new("Model", workspace.Bin)

	for i = 1, 8 do
		object2.Wedges[i] = {}
		object2.Wedges[i][1] = __SeaTriangle:Clone()
		object2.Wedges[i][2] = __SeaTriangle:Clone()
	end

	object2.SeaPlanes = seaPlanes
	object2.Last = tick()
	object2.CurrentFrame = 1

	return object2
end
function module.draw3dTriangle(p17, p18, p19, p20, p21)
	local t5 = {
		{ longest = p20 - p18, other = p19 - p18, origin = p18 },
		{ longest = p18 - p19, other = p20 - p19, origin = p19 },
		{ longest = p19 - p20, other = p18 - p20, origin = p20 }
	}
	local v65 = t5[1]

	for i = 2, #t5 do
		if t5[i].longest.magnitude > v65.longest.magnitude then
			v65 = t5[i]
		end
	end

	t5 = object.acos(v65.longest.unit:Dot(v65.other.unit))

	local n1 = object.cos(t5) * v65.other.magnitude
	local n2 = v65.longest.magnitude - n1
	local n3 = object.sin(t5) * v65.other.magnitude

	t5 = v65.origin + v65.other * 0.5

	local n4 = v65.origin + v65.longest + (v65.other - v65.longest) * 0.5
	local unit = v65.longest:Cross(v65.other).unit
	local v72 = unit:Cross(v65.longest).unit
	local v73 = v65.longest.unit
	local cFrame = CFrame.new(t5.x, t5.y, t5.z, -unit.x, v72.x, v73.x, -unit.y, v72.y, v73.y, -unit.z, v72.z, v73.z)
	local cFrame2 = CFrame.new(n4.x, n4.y, n4.z, unit.x, v72.x, -v73.x, unit.y, v72.y, -v73.y, unit.z, v72.z, -v73.z)
	local v76 = p17.Wedges[p21][1]

	v76.Size = Vector3.new(0, n3, n1)
	v76.CFrame = cFrame
	v76.Parent = seaTriangles
	v76 = p17.Wedges[p21][2]
	v76.Size = Vector3.new(0, n3, n2)
	v76.CFrame = cFrame2
	v76.Parent = seaTriangles
end

local t3: {[any]: any} = {
	Steepness = 0.026000000000000002,
	Wavelength = 240,
	Direction = Vector2.new(1, 0)
}
local t4: {[any]: any} = {
	Steepness = 0.026000000000000002,
	Wavelength = 270,
	Direction = Vector2.new(1, 2)
}

function module.UpdatePoints(p22, _)
	local n1 = p22.Origin * Vector3.new(1, 0, 1)
	local vector3 = Vector3.new(0, p22.YCoordinate, 0)
	local n2 = n1 + vector3
	local n3 = object.floor(n2.X / p22.DistanceBetweenPoints + 0.5) * p22.DistanceBetweenPoints
	local yCoordinate = p22.YCoordinate
	local v84 = object.floor(n2.Z / p22.DistanceBetweenPoints + 0.5)
	local vector32 = Vector3.new(n3, yCoordinate, v84 * p22.DistanceBetweenPoints)
	n3 = {}

	for i = -1, 1 do
		for j = -1, 1 do
			local vector33 = Vector3.new(vector32.X + i * p22.DistanceBetweenPoints, 0, vector32.Z + j * p22.DistanceBetweenPoints)
			local v89 = Wave(t1, vector33, p22.dt)
			local v90 = Wave(t3, vector33, p22.dt)
			local v91 = Wave(t4, vector33, p22.dt)

			n3[i] = n3[i] or {}
			n3[i][j] = vector33 + v89 + v90 + v91
		end
	end

	p22:draw3dTriangle(n3[0][1], n3[0][0], n3[-1][1], 1)
	p22:draw3dTriangle(n3[-1][0], n3[0][0], n3[-1][1], 2)
	p22:draw3dTriangle(n3[1][0], n3[1][1], n3[0][1], 3)
	p22:draw3dTriangle(n3[1][0], n3[0][0], n3[0][1], 4)
	p22:draw3dTriangle(n3[0][0], n3[1][-1], n3[1][0], 5)
	p22:draw3dTriangle(n3[0][0], n3[1][-1], n3[0][-1], 6)
	p22:draw3dTriangle(n3[0][0], n3[-1][0], n3[0][-1], 7)
	p22:draw3dTriangle(n3[-1][-1], n3[-1][0], n3[0][-1], 8)

	local n4 = object.floor(n2.X / (p22.DistanceBetweenPoints * 8) + 0.5) * (p22.DistanceBetweenPoints * 8)
	local v93 = p22.YCoordinate
	local v94 = object.floor(n2.Z / (p22.DistanceBetweenPoints * 8) + 0.5)
	local vector34 = Vector3.new(n4, v93, v94 * (p22.DistanceBetweenPoints * 8))
	n3 = {}
	local vector32X = vector32.X

	for k, v in pairs(p22.Points) do
		for k2, iterValue in pairs(v) do
			local vector2 = Vector2.new(k * p22.DistanceBetweenPoints, k2 * p22.DistanceBetweenPoints)

			if object.abs(k) == 20 or object.abs(k2) == 20 then
				vector2 *= 500
			end

			local vector35 = Vector3.new(vector2.X, 0, vector2.Y)

			vector35 = vector34 + vector35

			local v103 = Wave(t1, vector35, p22.dt)
			local v104 = Wave(t3, vector35, p22.dt)
			local v105 = Wave(t4, vector35, p22.dt)

			for _, iterValue2 in pairs(iterValue) do
				iterValue2.WorldPosition = vector35 + v103 + v104 + v105
			end
		end
	end
end
function module.Play(p24)
	p24.Conn = game:GetService("RunService").RenderStepped:connect(function(_)
		p24.dt = workspace:GetServerTimeNow() * 0.75

		if tick() - p24.Last >= 0.022222222222222223 then
			p24.Last = tick()
			p24:UpdatePoints()

			local v115 = p24

			v115.CurrentFrame = v115.CurrentFrame + 0.75

			if p24.CurrentFrame > #frames.ColorFrames then
				p24.CurrentFrame = 1
			end

			for _, v in pairs(p24.Planes:GetChildren()) do
				v.Texture.StudsPerTileU = 0.97782
				v.Texture.StudsPerTileV = 0.97782

				local vShine = v.Shine
				local objectSin = object.sin
				local timestamp = tick()

				vShine.StudsPerTileU = 0.97782 + objectSin(timestamp * 0.3) * 0.04

				local shine = v.Shine
				local v122 = object.sin
				local timestamp2 = tick()

				shine.StudsPerTileV = 0.97782 + v122(timestamp2 * 0.3) * 0.04
			end
		end
	end)
end
function module.Stop(p26)
	if p26.Conn then
		p26.Conn:Disconnect()
	end

	if p26.Model then
		p26.Model:Destroy()
		p26.Model = nil
	end

	if p26.SeaPlanes then
		p26.SeaPlanes:Destroy()
		p26.SeaPlanes = nil
	end

	if p26.Wedges then
		for _, v in pairs(p26.Wedges) do
			for _, iterValue in pairs(v) do
				iterValue:Destroy()
			end
		end

		p26.Wedges = nil
	end
end

return module
