-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local commonUtils: Instance = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local cameraWrapper = require(commonUtils:WaitForChild("CameraWrapper"))
local connectionUtil = require(commonUtils:WaitForChild("ConnectionUtil"))
local v5 = flagUtil.getUserFlag("UserRaycastUpdateAPI2")
local v6 = flagUtil.getUserFlag("UserCurrentCameraUpdate2")
local v7 = flagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local v8 = if v6 then cameraWrapper.new() else nil
local Workspace

if v6 then
	Workspace = nil
else
	Workspace = game
	Workspace = Workspace.Workspace
	Workspace = Workspace.CurrentCamera
end

if v6 then
	v8:Enable()
end

local mathMin = math.min
local mathTan = math.tan
local mathRad = math.rad
local rayNew = Ray.new
local raycastParams = RaycastParams.new()

raycastParams.IgnoreWater = true
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.RespectCanCollide = true

local raycastParams2 = RaycastParams.new()

raycastParams2.IgnoreWater = true
raycastParams2.FilterType = Enum.RaycastFilterType.Include

if v7 then
	connectionUtil.new()
end

local function getTotalTransparency(p1)
	return 1 - (1 - p1.Transparency) * (1 - p1.LocalTransparencyModifier)
end

v7 = function(p2, p3)
	for i = #p2, p3 + 1, -1 do
		p2[i] = nil
	end
end

local u17 = nil
local u18 = nil
local u20

if v6 then
	local function updateProjection()
		local v40 = v8:getCamera()
		local v41 = mathRad(v40.FieldOfView)
		local viewportSize = v40.ViewportSize

		v40 = viewportSize.X / viewportSize.Y
		u18 = mathTan(v41 / 2) * 2
		u17 = v40 * u18
	end

	v8:Connect("FieldOfView", updateProjection)
	v8:Connect("ViewportSize", updateProjection)

	local v21 = v8:getCamera()
	local v22 = mathRad(v21.FieldOfView)
	local viewportSize = v21.ViewportSize

	v21 = viewportSize.X / viewportSize.Y
	u18 = mathTan(v22 / 2) * 2
	u17 = v21 * u18
	u20 = v8:getCamera().NearPlaneZ
	v8:Connect("NearPlaneZ", function()
		u20 = v8:getCamera().NearPlaneZ
	end)
else
	local function v23()
		local v43 = mathRad(Workspace.FieldOfView)
		local workspaceViewportSize = Workspace.ViewportSize
		local n1 = workspaceViewportSize.X / workspaceViewportSize.Y

		u18 = mathTan(v43 / 2) * 2
		u17 = n1 * u18
	end

	Workspace:GetPropertyChangedSignal("FieldOfView"):Connect(v23)
	Workspace:GetPropertyChangedSignal("ViewportSize"):Connect(v23)

	local v24 = mathRad(Workspace.FieldOfView)
	local workspaceViewportSize = Workspace.ViewportSize
	local n1 = workspaceViewportSize.X / workspaceViewportSize.Y

	u18 = mathTan(v24 / 2) * 2
	u17 = n1 * u18
	u20 = Workspace.NearPlaneZ
	Workspace:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
		u20 = Workspace.NearPlaneZ
	end)
end

local t1: {[any]: any} = { workspace:WaitForChild("Bin"), workspace:WaitForChild("Characters") }
local u28 = nil
local RootPart = nil

if v6 then
	v8:Connect("CameraSubject", function()
		local cameraSubject = v8:getCamera().CameraSubject

		if cameraSubject and cameraSubject:IsA("Humanoid") then
			RootPart = cameraSubject.RootPart

			return
		end

		if cameraSubject and cameraSubject:IsA("BasePart") then
			RootPart = cameraSubject

			return
		end

		RootPart = nil
	end)
else
	Workspace:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		local workspaceCameraSubject = Workspace.CameraSubject

		if workspaceCameraSubject:IsA("Humanoid") then
			RootPart = workspaceCameraSubject.RootPart

			return
		end

		if workspaceCameraSubject:IsA("BasePart") then
			RootPart = workspaceCameraSubject

			return
		end

		RootPart = nil
	end)
end

local function canOcclude(p4)
	local u49
	local v50
	local v51
	local v52

	if p4.Name == "BlockWindow" then
		u49 = false
		v50 = u28
		v51 = p4:GetRootPart()

		if v50 == (v51 or p4) then
		else
			v52 = p4:IsA("TrussPart")
			u49 = not v52
		end
	else
		u49 = false

		if 1 - (1 - p4.Transparency) * (1 - p4.LocalTransparencyModifier) < 0.25 then
			if not v5 then
				u49 = p4.CanCollide

				if u49 then
					u49 = false
					v50 = u28
					v51 = p4:GetRootPart()

					if v50 == (v51 or p4) then
					else
						v52 = p4:IsA("TrussPart")
						u49 = not v52
					end
				end
			else
				u49 = false
				v50 = u28
				v51 = p4:GetRootPart()

				if v50 == (v51 or p4) then
				else
					v52 = p4:IsA("TrussPart")
					u49 = not v52
				end
			end
		end
	end

	return u49
end
local function getCollisionPoint(p5, p6)
	local v55
	local n1
	local v57
	local v58
	local v59
	local v60
	local v61
	local state: number = 0

	while true do
		if state == 0 then
			state = if v5 then 1 else 4
		elseif state == 1 then
			raycastParams.FilterDescendantsInstances = t1
			v55 = workspace:Raycast(p5, p6, raycastParams)
			state = if v55 then 2 else 15
		elseif state == 2 then
			return v55.Position, true
		elseif state == 3 then
			state = 3
		elseif state == 4 then
			n1 = #t1
			state = 5
		elseif state == 5 then
			v57 = rayNew(p5, p6)
			v58, v59 = workspace:FindPartOnRayWithIgnoreList(v57, t1, false, true)
			state = if v58 then 6 else 11
		elseif state == 6 then
			state = if v58.CanCollide then 7 else 10
		elseif state == 7 then
			v60 = t1

			for i = #v60, n1 + 1, -1 do
				v60[i] = nil
			end

			state = 9
		elseif state == 9 then
			return v59, true
		elseif state == 10 then
			t1[#t1 + 1] = v58
			state = 11
		elseif state == 11 then
			state = if v58 then 12 else 13
		elseif state == 12 then
			state = 5
		elseif state == 13 then
			v61 = t1

			for i = #v61, n1 + 1, -1 do
				v61[i] = nil
			end

			state = 15
		elseif state == 15 then
			return p5 + p6, false
		elseif state == 16 then
			return
		end
	end
end
local function queryPoint(p7, p8, p9, p10)
	debug.profilebegin("queryPoint")

	local n1: number = #t1
	local n2 = p9 + u20
	local n3 = p7 + p8 * n2
	local n4 = math.huge
	local n5 = math.huge
	local v73 = p7
	local n6: number = 0

	if v5 then
		raycastParams.FilterDescendantsInstances = t1

		while true do
			local v75 = workspace:Raycast(v73, n3 - v73, raycastParams)

			if not v75 then
				break
			end

			n6 += 1

			local instance = v75.Instance
			local v77 = v75.Position
			local magnitude = (v77 - p7).Magnitude

			if n6 >= 64 then
				n5 = magnitude
			else
				local u79

				if instance.Name == "BlockWindow" then
					u79 = false

					local v80 = u28
					local v81 = instance:GetRootPart()

					if v80 ~= (v81 or instance) then
						u79 = not instance:IsA("TrussPart")
					end
				else
					u79 = false

					if 1 - (1 - instance.Transparency) * (1 - instance.LocalTransparencyModifier) < 0.25 then
						if not v5 then
							u79 = instance.CanCollide

							if u79 then
								do
									u79 = false

									local v80 = u28
									local v81 = instance:GetRootPart()

									if v80 ~= (v81 or instance) then
										u79 = not instance:IsA("TrussPart")
									end
								end
							end
						else
							do
								u79 = false

								local v80 = u28
								local v81 = instance:GetRootPart()

								if v80 ~= (v81 or instance) then
									u79 = not instance:IsA("TrussPart")
								end
							end
						end
					end
				end

				if u79 then
					raycastParams2.FilterDescendantsInstances = { instance }

					if workspace:Raycast(n3, v77 - n3, raycastParams2) then
						if if p10 then workspace:Raycast(p10, n3 - p10, raycastParams2) or workspace:Raycast(n3, p10 - n3, raycastParams2) else false then
							n5 = magnitude
						elseif n2 < n4 then
							n4 = magnitude
						end
					else
						n5 = magnitude
					end
				end
			end

			raycastParams:AddToFilter(instance)
			v73 = v77 - p8 * 0.001

			if n5 < math.huge or not instance then
				break
			end
		end
	else
		while true do
			local v82 = rayNew(v73, n3 - v73)
			local v83, v84 = workspace:FindPartOnRayWithIgnoreList(v82, t1, false, true)

			n6 += 1

			if v83 then
				local u85: boolean = n6 >= 64
				local u86

				if v83.Name == "BlockWindow" then
					u86 = false

					local v87 = u28
					local v88 = v83:GetRootPart()

					if v87 ~= (v88 or v83) then
						u86 = not v83:IsA("TrussPart")
					end
				else
					u86 = false

					if 1 - (1 - v83.Transparency) * (1 - v83.LocalTransparencyModifier) < 0.25 then
						if not v5 then
							u86 = v83.CanCollide

							if u86 then
								do
									u86 = false

									local v87 = u28
									local v88 = v83:GetRootPart()

									if v87 ~= (v88 or v83) then
										u86 = not v83:IsA("TrussPart")
									end
								end
							end
						else
							do
								u86 = false

								local v87 = u28
								local v88 = v83:GetRootPart()

								if v87 ~= (v88 or v83) then
									u86 = not v83:IsA("TrussPart")
								end
							end
						end
					end
				end

				if u86 or u85 then
					local v89 = rayNew(n3, v84 - n3)
					local t3: {[any]: any} = { v83 }
					local v91 = (v84 - p7).Magnitude

					if workspace:FindPartOnRayWithWhitelist(v89, t3, true) and not u85 then
						local u92 = false

						if p10 then
							local v93 = rayNew(p10, n3 - p10)
							local v94 = workspace:FindPartOnRayWithWhitelist(v93, t3, true)

							if not v94 then
								local v95 = rayNew(n3, p10 - n3)

								v94 = workspace:FindPartOnRayWithWhitelist(v95, t3, true)
							end

							u92 = v94
						end

						if u92 then
							n5 = v91
						elseif n2 < n4 then
							n4 = v91
						end
					else
						n5 = v91
					end
				end

				t1[#t1 + 1] = v83
				v73 = v84 - p8 * 0.001
			end

			if n5 < math.huge or not v83 then
				break
			end
		end

		local v96: {[any]: any} = t1

		for i = #v96, n1 + 1, -1 do
			v96[i] = nil
		end
	end

	debug.profileend()

	return n4 - u20, n5 - u20
end
local function queryViewport(p11, p12)
	debug.profilebegin("queryViewport")

	local p = p11.p
	local rightVector = p11.rightVector
	local upVector = p11.upVector
	local n1 = -p11.lookVector

	Workspace = if v6 then v8:getCamera() else Workspace

	local workspaceViewportSize = Workspace.ViewportSize
	local n2 = math.huge
	local n3 = math.huge

	for i = 0, 1 do
		local n4 = rightVector * ((i - 0.5) * u17)

		for j = 0, 1 do
			local n5 = p + u20 * (n4 + upVector * ((j - 0.5) * u18))
			local v111 = Workspace:ViewportPointToRay(workspaceViewportSize.x * i, workspaceViewportSize.y * j)
			local v112, v113 = queryPoint(n5, n1, p12, v111.Origin)

			if n2 > v113 then
				n2 = v113
			end

			if n3 > v112 then
				n3 = v112
			end
		end
	end

	debug.profileend()

	return n3, n2
end

local t2: {[any]: any} = {
	Vector2.new(0.4, 0),
	Vector2.new(-0.4, 0),
	Vector2.new(0, -0.4),
	Vector2.new(0, 0.4),
	Vector2.new(0, 0.2)
}

local function testPromotion(p13, p14, p15)
	debug.profilebegin("testPromotion")

	local p = p13.p
	local rightVector = p13.rightVector
	local upVector = p13.upVector
	local n1 = -p13.lookVector

	debug.profilebegin("extrapolate")

	local v121 = getCollisionPoint(p, p15.posVelocity * 1.25)

	for i = 0, mathMin(1.25, p15.rotVelocity.magnitude + (v121 - p).Magnitude / p15.posVelocity.magnitude), 0.0625 do
		local v123 = p15.extrapolate(i)
		local v124 = queryPoint(v123.p, -v123.lookVector, p14)

		if p14 <= v124 then
			return false
		end
	end

	debug.profileend()
	debug.profilebegin("testOffsets")

	for _, v in ipairs(t2) do
		local v127 = getCollisionPoint(p, rightVector * v.x + upVector * v.y)

		if queryPoint(v127, (p + n1 * p14 - v127).Unit, p14) == math.huge then
			return false
		end
	end

	debug.profileend()
	debug.profileend()

	return true
end

return function(p16, p17, p18)
	debug.profilebegin("popper")
	u28 = RootPart and RootPart:GetRootPart() or RootPart

	local v131 = p17
	local v132, v133 = queryViewport(p16, p17)

	if v131 > v133 then
		v131 = v133
	end

	if v131 > v132 and testPromotion(p16, p17, p18) then
		v131 = v132
	end

	u28 = nil
	debug.profileend()

	return v131
end
