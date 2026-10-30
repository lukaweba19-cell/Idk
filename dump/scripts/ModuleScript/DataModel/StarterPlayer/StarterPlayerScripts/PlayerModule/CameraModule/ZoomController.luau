-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local popper = require(script:WaitForChild("Popper"))
local mathClamp = math.clamp
local mathExp = math.exp
local mathMin = math.min
local mathMax = math.max
local CameraMinZoomDistance = nil
local CameraMaxZoomDistance = nil
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

assert(LocalPlayer)

local function updateBounds()
	CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
	CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
end

CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds)
LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds)

local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4)
	local v18 = mathClamp(p2, p3, p4)

	return (setmetatable({ v = 0, freq = p1, x = v18, minValue = p3, maxValue = p4, goal = v18 }, t1))
end
function t1.Step(p5, p6)
	local n1 = p5.freq * 2 * 3.141592653589793
	local v = p5.v
	local minValue = p5.minValue
	local maxValue = p5.maxValue
	local goal = p5.goal
	local n2 = goal - p5.x
	local n3 = n1 * p6
	local v28 = mathExp(-n3)
	local n4 = goal + (v * p6 - n2 * (n3 + 1)) * v28
	local n5 = ((n2 * n1 - v) * n3 + v) * v28

	if minValue > n4 then
		n4 = minValue
		n5 = 0
	elseif maxValue < n4 then
		n4 = maxValue
		n5 = 0
	end

	p5.x = n4
	p5.v = n5

	return n4
end

local v11 = t1.new(4.5, 12.5, 0.5, CameraMaxZoomDistance)

local function stepTargetZoom(p7, p8, p9, p10)
	local v35 = mathClamp(p7 + p8 * (p7 * 0.0375 + 1), p9, p10)

	if v35 < 1 then
		v35 = p8 <= 0 and p9 or 1
	end

	return v35
end

local n1 = 0

return {
	Update = function(p11, p12, p13)
		local n2 = math.huge

		if v11.goal > 1 then
			local x = v11.x
			local goal = v11.goal
			local v42: number = n1
			local v43 = CameraMinZoomDistance
			local v44 = mathClamp(goal + v42 * (goal * 0.0375 + 1), v43, CameraMaxZoomDistance)

			if v44 < 1 then
				v44 = v42 <= 0 and v43 or 1
			end

			local v45 = mathMax(x, v44)

			n2 = popper(p12 * CFrame.new(0, 0, 0.5), v45 - 0.5, p13) + 0.5
		end

		v11.minValue = 0.5
		v11.maxValue = mathMin(CameraMaxZoomDistance, n2)

		return v11:Step(p11)
	end,
	GetZoomRadius = function()
		return v11.x
	end,
	SetZoomParameters = function(p14, p15)
		v11.goal = p14
		n1 = p15
	end,
	ReleaseSpring = function()
		v11.x = v11.goal
		v11.v = 0
	end
}
