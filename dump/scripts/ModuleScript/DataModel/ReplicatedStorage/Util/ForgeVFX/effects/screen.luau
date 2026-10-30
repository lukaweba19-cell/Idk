-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("../mod/attributes")

require("../types")

local v3 = require("../mod/utility")

return {
	emit = function(p1, p2)
		if not p1:GetAttribute("Enabled") then
			return
		end

		local v6 = v2.get(p1, "PartScale", Vector3.new(1, 1, 1))
		local v7 = v2.get(p1, "PartDistance", 1.5)
		local v8 = v2.get(p1, "OffsetPosition", Vector3.new(0, 0, 0))
		local n1 = v2.get(p1, "OffsetRotation", Vector3.new(0, 0, 0)) * v3.DEG_TO_RAD
		local cFrame = p1.CFrame
		local v11 = p1.Size
		local collisionGroup = p1.CollisionGroup

		p1.CollisionGroup = "ForgeMouseIgnore"
		table.insert(p2, function()
			p1.Size = v11
			p1.CFrame = cFrame
			p1.CollisionGroup = collisionGroup ~= "" and collisionGroup or "Default"
		end)

		local function frame()
			local CurrentCamera: Camera = workspace.CurrentCamera
			local v16 = math.rad(CurrentCamera.FieldOfView / 2)
			local n2 = math.tan(v16) * v7 * 2

			v16 = CurrentCamera.ViewportSize.X / CurrentCamera.ViewportSize.Y * n2

			local currentCameraCFrame: CFrame = CurrentCamera.CFrame
			local cFrame = CFrame.new(0, 0, -v7)

			p1.Size = Vector3.new(v16, n2, p1.Size.Z) * v6

			local cFrame2 = CFrame.new(v8)
			local v21 = CFrame.fromOrientation(n1.x, n1.y, n1.z)

			p1.CFrame = currentCameraCFrame * cFrame * cFrame2 * v21
		end

		if not runService:IsRunning() then
			table.insert(p2, runService.RenderStepped:Connect(frame))
		else
			local v14 = v3.getRandomId()

			runService:BindToRenderStep(v14, Enum.RenderPriority.Last.Value + 2 + p2.depth, frame)
			table.insert(p2, function()
				runService:UnbindFromRenderStep(v14)
			end)
		end

		return true
	end
}
