-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local v2: boolean = game:GetService("RunService"):IsServer()

local module: {[any]: any} = {
	IsStunned = function(p1)
		if not p1 then
			return false
		end

		local stunned = p1:GetAttribute("Stunned")

		if typeof(stunned) == "number" then
			local v6: number = workspace:GetServerTimeNow()

			return stunned > v6
		end

		return false
	end,
	GetStunExpiry = function(p2)
		if not p2 then
			return nil
		end

		local stunned = p2:GetAttribute("Stunned")

		if typeof(stunned) == "number" then
			local v9: number = workspace:GetServerTimeNow()

			if stunned <= v9 then
				return nil
			end

			return stunned
		end

		return nil
	end
}

function module.GetRemainingTime(p3)
	local v11 = module.GetStunExpiry(p3)

	if not v11 then
		return 0
	end

	local v12: number = workspace:GetServerTimeNow()

	return (math.max(0, v11 - v12))
end
function module.ApplyStun(character, p5, p6)
	assert(v2, "StunModule.ApplyStun must be called on the server")

	local v16 = p5 or 1.5
	local n1 = workspace:GetServerTimeNow() + v16

	character:SetAttribute("Stunned", n1)

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and not (humanoid.Health <= 0) then
		humanoid.WalkSpeed = 4
		humanoid.JumpHeight = 0
		character:SetAttribute("ParkourState", nil)

		local hit: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Hit")

		if p6 then
			hit:FireClient(p6, character, "STUNNED!")
		end

		task.delay(v16 + 0.05, function()
			local stunned = character:GetAttribute("Stunned")

			if typeof(stunned) == "number" and math.abs(stunned - n1) < 0.01 then
				module.ClearStun(character)
			end
		end)

		return
	end
end
function module.ClearStun(character)
	assert(v2, "StunModule.ClearStun must be called on the server")
	character:SetAttribute("Stunned", nil)

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and not (humanoid.Health <= 0) then
		local matchWalkSpeed = humanoid:GetAttribute("MatchWalkSpeed")
		local matchJumpHeight = humanoid:GetAttribute("MatchJumpHeight")

		if humanoid:GetAttribute("Frozen") then
			return
		end

		humanoid.WalkSpeed = matchWalkSpeed or 24
		humanoid.JumpHeight = matchJumpHeight or 4

		return
	end
end

return module
