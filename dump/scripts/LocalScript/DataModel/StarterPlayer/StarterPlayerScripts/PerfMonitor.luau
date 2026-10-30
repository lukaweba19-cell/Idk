-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local perfStats: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PerfStats")
local t1: {[any]: any} = {
	BodyVelocity = true,
	BodyPosition = true,
	BodyGyro = true,
	BodyForce = true,
	BodyThrust = true,
	BodyAngularVelocity = true,
	LinearVelocity = true,
	AlignPosition = true,
	AlignOrientation = true,
	VectorForce = true,
	AngularVelocity = true
}
local t2: {[any]: any} = { DriveLV = true, CameraAlignOrientation = true }
local t3: {[any]: any} = {
	"rayfield",
	"orion",
	"kavo",
	"fluent",
	"linoria",
	"venyx",
	"wally",
	"infinite yield",
	"infiniteyield",
	"dex",
	"simplespy",
	"hydroxide",
	"fates",
	"sirius",
	"darkhub",
	"owlhub"
}
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}

local function flag(p1, p2)
	local v23 = os.clock()

	if t5[p1] and v23 - t5[p1] < 60 then
		return
	end

	t5[p1] = v23

	if #t4 < 8 then
		local v24: {[any]: any} = t4
		local v25 = string.sub(p2, 1, 80)

		table.insert(v24, { k = p1, x = v25 })
	end
end

local n1: number = 0
local n2: number = 0

runService.Heartbeat:Connect(function(deltaTime: number)
	n1 += 1
	n2 += deltaTime
end)

local function send(p4)
	if #t4 == 0 and not p4 then
		return
	end

	local v28 = n2 > 0 and math.floor(n1 / n2 + 0.5) or 0

	n1 = 0
	n2 = 0

	local v29: {[any]: any} = t4
	t4 = {}
	pcall(function()
		perfStats:FireServer({ fps = v28, f = v29 })
	end)
end
local function isLiveEnemyChar(character)
	if not character or not character:IsA("Model") then
		return false, nil
	end

	local v31: Player = players:GetPlayerFromCharacter(character)

	if v31 and v31 ~= LocalPlayer then
		local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
		local matchSide2: any = v31:GetAttribute("MatchSide")

		if typeof(matchSide) == "string" and typeof(matchSide2) == "string" and matchSide ~= matchSide2 then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local matchId2: any = v31:GetAttribute("MatchId")

			if matchId ~= matchId2 then
			elseif character:GetAttribute("FinisherActive") == true then
			elseif character:FindFirstChildOfClass("Humanoid") and not (character:FindFirstChildOfClass("Humanoid").Health <= 0) then
				return true, v31
			end

			return false, nil
		end

		return false, nil
	end

	return false, nil
end
local function modelOf(p6)
	while p6 and p6 ~= workspace do
		if p6:IsA("Model") and players:GetPlayerFromCharacter(p6) then
			return p6
		end

		p6 = p6.Parent
	end

	return nil
end

local t6: {[any]: any} = {}

workspace.DescendantAdded:Connect(function(descendant: Instance)
	if descendant:IsA("Highlight") and string.sub(descendant.Name, 1, 2) ~= "__" then
		t6[descendant] = os.clock()
	end
end)

local function scanEsp(p8)
	if LocalPlayer:GetAttribute("XRay") == true or LocalPlayer:GetAttribute("ReplayXRay") == true then
		return
	end

	if LocalPlayer:GetAttribute("Spectating") == true or typeof((LocalPlayer:GetAttribute("Spectating"))) == "number" then
		return
	end

	for k, v in pairs(t6) do
		if not k.Parent then
			t6[k] = nil
		elseif k.Enabled and p8 - v >= 5 then
			local v41 = modelOf(k.Adornee)

			if not v41 then
				v41 = modelOf(k.Parent)
			end

			local v42, v43 = isLiveEnemyChar(v41)

			if v42 and v43 then
				local kName = k.Name
				local text: string = tostring(k.DepthMode.Name)
				local floored = math.floor(p8 - v)

				flag("esp", ("%s on enemy, depth=%s, %ds"):format(kName, text, floored))
			end
		end
	end
end
local function scanHitboxes()
	for _, v in ipairs(players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character then
			for _, iterValue in ipairs({ "HumanoidRootPart", "Head" }) do
				local v2 = v.Character:FindFirstChild(iterValue)

				if v2 and v2:IsA("BasePart") then
					local v52 = v2.Size

					if math.max(v52.X, v52.Y, v52.Z) > 3.1 then
						flag("hitbox", ("%s %.1fx%.1fx%.1f"):format(iterValue, v52.X, v52.Y, v52.Z))

						return
					end
				end
			end
		end
	end
end
local function watchCharacter(p9)
	p9.DescendantAdded:Connect(function(p10)
		if t1[p10.ClassName] and not t2[p10.Name] then
			flag("mover", p10.ClassName .. " " .. p10.Name)
		end
	end)

	local humanoid = p9:WaitForChild("Humanoid", 10)

	if not humanoid or not humanoid:IsA("Humanoid") then
		return
	end

	humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed > 50 then
			flag("walkspeed", ("WalkSpeed %.0f"):format(humanoid.WalkSpeed))
		end
	end)
	humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
		local numberValue: number? = tonumber(humanoid:GetAttribute("MatchJumpHeight"))
		local humanoidJumpHeight = humanoid.JumpHeight
		local v80 = math.max((numberValue or 7.2) * 3, 25)

		if humanoidJumpHeight > v80 then
			flag("jump", ("JumpHeight %.0f"):format(humanoid.JumpHeight))
		end
	end)
	humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if humanoid.UseJumpPower and humanoid.JumpPower > 150 then
			flag("jump", ("JumpPower %.0f"):format(humanoid.JumpPower))
		end
	end)
	humanoid:GetPropertyChangedSignal("HipHeight"):Connect(function()
		if humanoid.HipHeight > 3 then
			flag("hipheight", ("HipHeight %.1f"):format(humanoid.HipHeight))
		end
	end)
end

if LocalPlayer.Character then
	task.spawn(watchCharacter, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(watchCharacter)
workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
	local workspaceGravity: number = workspace.Gravity

	if workspaceGravity < 70 or workspaceGravity > 200 then
		flag("gravity", ("Gravity %.0f"):format(workspaceGravity))
	end
end)

local function checkGui(p11)
	if not p11:IsA("ScreenGui") then
		return
	end

	local lowerText = string.lower(p11.Name)

	for _, v in ipairs(t3) do
		if string.find(lowerText, v, 1, true) then
			flag("gui", p11.Name)

			return
		end
	end
end

task.spawn(function()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui", 30)

	if not playerGui then
		return
	end

	for _, v in ipairs(playerGui:GetChildren()) do
		checkGui(v)
	end

	playerGui.ChildAdded:Connect(checkGui)
end)
task.spawn(function()
	local playerScripts: Instance = LocalPlayer:WaitForChild("PlayerScripts", 30)

	if not playerScripts then
		return
	end

	local antiCheat: Instance = playerScripts:WaitForChild("AntiCheat", 30)

	if not antiCheat then
		local v65 = os.clock()

		if t5.decoy_missing and v65 - t5.decoy_missing < 60 then
			return
		end

		t5.decoy_missing = v65

		if #t4 < 8 then
			table.insert(t4, { k = "decoy_missing", x = "AntiCheat never arrived" })
		end

		return
	end

	antiCheat.AncestryChanged:Connect(function()
		if not antiCheat:IsDescendantOf(game) then
			local v81 = os.clock()

			if t5.decoy_removed and v81 - t5.decoy_removed < 60 then
				return
			end

			t5.decoy_removed = v81

			if #t4 < 8 then
				table.insert(t4, { k = "decoy_removed", x = "AntiCheat deleted" })
			end

			return
		end
	end)

	if antiCheat:IsA("LocalScript") then
		antiCheat:GetPropertyChangedSignal("Enabled"):Connect(function()
			if not antiCheat.Enabled then
				local v82 = os.clock()

				if t5.decoy_disabled and v82 - t5.decoy_disabled < 60 then
					return
				end

				t5.decoy_disabled = v82

				if #t4 < 8 then
					table.insert(t4, { k = "decoy_disabled", x = "AntiCheat disabled" })
				end

				return
			end
		end)
	end

	while true do
		task.wait(10)

		if not antiCheat:IsDescendantOf(game) then
			break
		end

		local t: any = antiCheat:GetAttribute("t")

		if typeof(t) == "number" and os.clock() - t > 15 then
			local v67 = os.clock()
			local v68 = ("AntiCheat silent %ds"):format((math.floor(v67 - t)))
			local v69 = os.clock()

			if not t5.decoy_stale or not (v69 - t5.decoy_stale < 60) then
				t5.decoy_stale = v69

				if #t4 < 8 then
					local v70: {[any]: any} = t4
					local v71 = string.sub(v68, 1, 80)

					table.insert(v70, { k = "decoy_stale", x = v71 })
				end
			end
		end
	end

	local v72 = os.clock()

	if t5.decoy_removed and v72 - t5.decoy_removed < 60 then
		return
	end

	t5.decoy_removed = v72

	if #t4 < 8 then
		table.insert(t4, { k = "decoy_removed", x = "AntiCheat gone" })

		return
	end
end)
task.spawn(function()
	local n1
	local v74
	local v75
	local u76

	n1 = 0
	v74 = os.clock()

	while true do
		task.wait(2)
		v75 = os.clock()

		if v75 - n1 >= 2 then
			n1 = v75
			pcall(scanEsp, v75)
			pcall(scanHitboxes)
		end

		u76 = v75 - v74 >= 20

		if u76 then
			v74 = v75
		end

		send(u76)

		continue
	end
end)
