-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local effect = require(replicatedStorage:WaitForChild("Effect"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local misc = require(util:WaitForChild("Misc"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local destructibles = require(shared:WaitForChild("Destructibles"))

return {
	Fire = function(p1, p2, p3, p4)
		local revolverRig = p4:FindFirstChild("RevolverRig")
		local revolverRoot = revolverRig and revolverRig:FindFirstChild("RevolverRoot")
		local v13 = (p2 - p1).Magnitude

		if v13 < 0.05 then
			v13 = 0.05
		end

		local s1: string = "BulletEffects." .. (p3 or "Default")

		if not effect.find(s1) then
			s1 = "BulletEffects.Default"
		end

		local __BulletTracer: Part = Instance.new("Part")

		__BulletTracer.Name = "__BulletTracer"
		__BulletTracer.Anchored = true
		__BulletTracer.CanCollide = false
		__BulletTracer.CanQuery = false
		__BulletTracer.CanTouch = false
		__BulletTracer.Massless = true
		__BulletTracer.Material = Enum.Material.Neon
		__BulletTracer.Color = Color3.new(1, 1, 0.3)
		__BulletTracer.Transparency = 1
		__BulletTracer.Size = Vector3.new(0.2, 0.2, v13)

		local v16 = CFrame.lookAt(p1, p2)
		local cFrame = CFrame.new(0, 0, -v13 / 2)

		__BulletTracer.CFrame = v16 * cFrame

		local attachment: Attachment = Instance.new("Attachment")

		attachment.CFrame = CFrame.new(0, 0, v13 / 2)
		attachment.Parent = __BulletTracer

		local attachment2: Attachment = Instance.new("Attachment")

		attachment2.CFrame = CFrame.new(0, 0, -v13 / 2)
		attachment2.Parent = __BulletTracer
		__BulletTracer.Parent = workspace.Bin
		task.delay(3, function()
			__BulletTracer:Destroy()
		end)
		effect.new(s1):replicate({
			GunRoot = revolverRoot,
			Part = __BulletTracer,
			Attachment0 = attachment,
			Attachment1 = attachment2,
			CFrame = __BulletTracer.CFrame,
			Origin = p1,
			HitPos = p2,
			Length = v13
		})
	end,
	WallHit = function(p5, p6, p7, p8)
		if destructibles.GetHitKind(p5) == "none" then
			local s1: string = "BulletEffects." .. (p8 or "Default") .. ".WallHit"

			if not effect.find(s1) then
				s1 = "BulletEffects.Default.WallHit"
			end

			local v25 = effect.new(s1)
			local v26 = misc.RayToCFrame(p5, p6, p7)

			v25:replicate({
				CFrame = v26,
				Color = Color3.new(1, 1, 1),
				ExtraColor = Color3.new(1, 1, 1),
				HitPart = p5,
				Position = p6,
				Normal = p7
			})

			return
		end
	end
}
