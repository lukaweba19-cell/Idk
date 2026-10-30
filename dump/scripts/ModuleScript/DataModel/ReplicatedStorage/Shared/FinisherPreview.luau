-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local ragdoll = require(replicatedStorage.Shared:WaitForChild("Ragdoll"))
local finisherVelocity = require(replicatedStorage.Shared:WaitForChild("FinisherVelocity"))
local effect = require(replicatedStorage:WaitForChild("Effect"))
local dummy: Instance = replicatedStorage:WaitForChild("Dummy")
local root: Instance = workspace:WaitForChild("FinisherPreviewRoom"):WaitForChild("Root")

replicatedStorage:WaitForChild("Effect"):WaitForChild("Container"):WaitForChild("KillEffects")

local u7 = nil
local u8 = nil
local u9 = nil
local n1: number = 0

local function clearDummy()
	if u7 then
		u7:Destroy()
		u7 = nil
	end
end
local function spawnAndPlay(p1, p2)
	if u7 then
		u7:Destroy()
		u7 = nil
	end

	local clone: Instance = dummy:Clone()

	clone.Name = "__FinisherPreviewDummy"

	local rootCFrame = root.CFrame
	local cFrame = CFrame.new(rootCFrame.Position, rootCFrame.Position - rootCFrame.LookVector)

	clone:PivotTo(cFrame)

	local humanoid: Instance = clone:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.BreakJointsOnDeath = false
	end

	clone.Parent = workspace.Bin
	u7 = clone

	if p2 ~= n1 then
		return
	end

	task.wait(0.3)

	if p2 ~= n1 then
		if u7 then
			u7:Destroy()
			u7 = nil
		end

		return
	end

	local v21 = finisherVelocity.Get(p1, rootCFrame.LookVector)

	if humanoid then
		humanoid.Health = 0
	end

	local humanoidRootPart: Instance = clone:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.CanCollide = false

		local rootJoint: Instance = humanoidRootPart:FindFirstChild("RootJoint")

		if rootJoint then
			rootJoint.Enabled = false
		end
	end

	task.spawn(function()
		ragdoll(clone, v21)
	end)

	local v24 = p1 == "MurderNote" and require(replicatedStorage.Shared.MurderNoteCatalog).NextTestSeed() or math.random(1, 1073741824)

	task.spawn(function()
		effect.new("KillEffects." .. p1):play({ __SilenceError = true, Character = clone, Seed = v24 })
	end)

	local v25, v26, v27, v28 = finisherVelocity.HasDelayedRagdoll(p1, humanoidRootPart and humanoidRootPart.CFrame, v24)

	if v28 and humanoidRootPart then
		humanoidRootPart.Anchored = true
	end

	if v25 and v26 and v27 then
		task.delay(v26, function()
			if u7 == clone and n1 == p2 then
				if v28 and humanoidRootPart then
					humanoidRootPart.Anchored = false
				end

				task.spawn(function()
					ragdoll(clone, v27)
				end)
			end
		end)
	end

	local v29, v30, v31, v32 = finisherVelocity.HasLimbExplosion(p1, v24)

	if v29 then
		local t2 = v32 or {}

		t2.delay = v30
		t2.stagger = v31
		finisherVelocity.PerformLimbExplosion(clone, t2)
	end
end
local function runLoop(p3, p4)
	while p4 == n1 do
		spawnAndPlay(p3, p4)

		if p4 ~= n1 then
			break
		end

		local n2 = 0

		while n2 < 5 and p4 == n1 do
			local v37 = task.wait()

			n2 += v37
		end
	end
end

local module: {[any]: any} = {
	replay = function()
		if not u8 then
			return
		end

		n1 += 1

		local v38: number = n1

		if u9 then
			task.cancel(u9)
			u9 = nil
		end

		u9 = task.spawn(function()
			runLoop(u8, v38)
		end)
	end
}

function module.start(p5)
	module.stop()
	u8 = p5
	n1 += 1

	local v40: number = n1

	u9 = task.spawn(function()
		runLoop(p5, v40)
	end)
end
function module.stop()
	n1 += 1
	u8 = nil

	if u9 then
		task.cancel(u9)
		u9 = nil
	end

	if u7 then
		u7:Destroy()
		u7 = nil
	end
end
function module.getCameraSubject()
	return root
end

return module
