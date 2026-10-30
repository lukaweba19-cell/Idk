-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local boothClient = require(shared:WaitForChild("BoothClient"))

require(shared:WaitForChild("Rarity"))

local v5 = replicatedStorage:WaitForChild("Signs", 30) and replicatedStorage.Signs:FindFirstChild("SignRig")

if v5 == nil then
	warn("[SignWatcher] ReplicatedStorage.Signs.SignRig missing")

	return
end

local holdC0 = v5:FindFirstChild("HoldC0")
local v7 = if holdC0 then holdC0.Value else CFrame.new(0, 0.5, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0)
local cFrame = CFrame.new()
local u9 = nil
local u10 = nil

local function setHoldPose(character, p2)
	if not p2 or character == nil then
		if u9 then
			pcall(function()
				u9:Stop(0.15)
			end)
			u9 = nil
		end

		u10 = nil

		return
	end

	if u9 and character == u10 and u9.IsPlaying then
		return
	end

	if u9 then
		pcall(function()
			u9:Stop(0)
		end)
	end

	u9 = nil

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local v33 = humanoid

	if v33 then
		v33 = humanoid:FindFirstChildOfClass("Animator") or humanoid
	end

	if v33 == nil then
		return
	end

	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = "rbxassetid://182393478"

	local ok, result = pcall(function()
		return v33:LoadAnimation(animation)
	end)

	if ok and result ~= nil then
		result.Priority = Enum.AnimationPriority.Action
		result.Looped = true
		result:Play(0.15)
		u9 = result
		u10 = character

		return
	end
end

local t1: {[any]: any} = {}
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")

local function boothRenderer()
	local boothSignRender: Instance = bindables:FindFirstChild("BoothSignRender")

	if boothSignRender and boothSignRender:IsA("BindableFunction") then
		return boothSignRender
	end

	return nil
end
local function heldKey(player, p4)
	return ("Held_%d_%s"):format(player.UserId, p4)
end
local function clearBoothBoards(p5)
	local boothSignRender: Instance = bindables:FindFirstChild("BoothSignRender")
	local v42 = if boothSignRender and boothSignRender:IsA("BindableFunction") then boothSignRender else nil

	if v42 == nil then
		return
	end

	for _, v in ipairs({ "Face", "Back" }) do
		pcall(function()
			v42:Invoke("Clear", heldKey(p5, v))
		end)
	end
end

local color3 = Color3.new(1, 1, 1)
local color32 = Color3.fromRGB(255, 72, 72)
local color33 = Color3.fromRGB(86, 156, 255)

local function findBoothFor(p6)
	local v46 = boothClient.GetSnapshot()

	if typeof(v46) == "table" then
		for _, v in ipairs(v46) do
			if p6 == v.OwnerUserId then
				return v
			end
		end

		return nil
	end

	return nil
end

local t2: {[any]: any} = { Red = color32, White = Color3.new(1, 1, 1), Blue = color33 }

local function render(p7, player)
	local signHeld = player:GetAttribute("SignHeld")
	local v52

	if signHeld == "Booth" then
		local boothSignRender: Instance = bindables:FindFirstChild("BoothSignRender")

		v52 = if boothSignRender and boothSignRender:IsA("BindableFunction") then boothSignRender else nil
	else
		v52 = nil
	end

	local u54: boolean = false

	if v52 then
		for _, v in ipairs({ "Face", "Back" }) do
			local v3 = p7:FindFirstChild(v)

			if v3 and v3:IsA("BasePart") then
				local ok, result = pcall(function()
					local v137 = ("Held_%d_%s"):format(player.UserId, v)

					return v52:Invoke("Render", v137, v3, player.UserId, v3.Size.X / v3.Size.Y, 0.66)
				end)

				if ok and result then
					u54 = true
				end
			end
		end
	end

	if signHeld ~= "Booth" or not v52 then
		clearBoothBoards(player)
	end

	for _, v in ipairs({ "Face", "Back" }) do
		local v = p7:FindFirstChild(v)
		local display = v and v:FindFirstChild("Display")

		if display and display:IsA("SurfaceGui") then
			display.Enabled = not u54
		end
	end

	if u54 then
		return
	end

	for _, v in ipairs({ "Face", "Back" }) do
		local v2 = p7:FindFirstChild(v)
		local v67 = v2 and v2:FindFirstChild("Display") and v2.Display:FindFirstChild("Root")

		if v67 ~= nil then
			local title = v67:FindFirstChild("Title")
			local body = v67:FindFirstChild("Body")
			local sub = v67:FindFirstChild("Sub")
			local icon = v67:FindFirstChild("Icon")

			local function setText(p9, text, textColor3)
				if p9 == nil then
					return
				end

				p9.Text = text

				if textColor3 then
					p9.TextColor3 = textColor3
				end
			end

			if signHeld == "Booth" then
				local userId = player.UserId
				local v74 = boothClient.GetSnapshot()
				local v75

				if typeof(v74) == "table" then
					local v76, v77, v78 = ipairs(v74)
					local v79: boolean = false

					for iterFirst, iterSecond in v76, v77, v78 do
						if userId == iterSecond.OwnerUserId then
							v75 = iterSecond
							v79 = true

							break
						end
					end

					if not v79 then
						v75 = nil
					end
				else
					v75 = nil
				end

				local textColor3 = color3

				if title ~= nil then
					title.Text = "MY BOOTH"

					if textColor3 then
						title.TextColor3 = textColor3
					end
				end

				if icon then
					icon.Visible = false
				end

				if body then
					body.Position = UDim2.fromScale(0.03, 0.24)
					body.Size = UDim2.fromScale(0.94, 0.5)
				end

				if v75 then
					local numberValue = tonumber(v75.ListingCount)

					if not numberValue then
						numberValue = #(v75.Listings or {})
					end

					local text: string = tostring(v75.Id)

					if body ~= nil then
						body.Text = text

						if Color3.new(1, 1, 1) then
							body.TextColor3 = Color3.new(1, 1, 1)
						end
					end

					local s1 = if numberValue == 1 then "1 item listed" else ("%d items listed"):format(numberValue)

					if sub ~= nil then
						sub.Text = s1
					end
				else
					if body ~= nil then
						body.Text = "NO BOOTH"

						if Color3.new(1, 1, 1) then
							body.TextColor3 = Color3.new(1, 1, 1)
						end
					end

					if sub ~= nil then
						sub.Text = "Claim one at a stand!"
					end
				end
			elseif signHeld == "Wanted" then
				local v86 = color3

				if title ~= nil then
					title.Text = "LOOKING FOR"

					if v86 then
						title.TextColor3 = v86
					end
				end

				local signWantRarity = player:GetAttribute("SignWantRarity")

				tostring(signWantRarity or "Common")

				local signWantIcon = player:GetAttribute("SignWantIcon")

				if icon then
					icon.Image = if typeof(signWantIcon) == "string" then signWantIcon else ""
					icon.Visible = icon.Image ~= ""
					icon.Position = UDim2.fromScale(0.5, 0.59)
					icon.Size = UDim2.fromScale(0.8, 0.8)
				end

				if body ~= nil then
					body.Text = ""
				end

				if sub ~= nil then
					sub.Text = ""
				end
			elseif signHeld == "Text" then
				if title ~= nil then
					title.Text = ""
				end

				if sub ~= nil then
					sub.Text = ""
				end

				if icon then
					icon.Visible = false
				end

				local signTextColor = player:GetAttribute("SignTextColor")
				local text: string = tostring(signTextColor or "White")

				if body then
					body.Position = UDim2.fromScale(0.05, 0.1)
					body.Size = UDim2.fromScale(0.9, 0.8)
				end

				local signText = player:GetAttribute("SignText")
				local text2: string = tostring(signText or "")
				local v93 = t2[text] or Color3.new(1, 1, 1)

				if body ~= nil then
					body.Text = text2

					if v93 then
						body.TextColor3 = v93
					end
				end
			else
				if title ~= nil then
					title.Text = ""
				end

				if body ~= nil then
					body.Text = ""
				end

				if sub ~= nil then
					sub.Text = ""
				end

				if icon then
					icon.Visible = false
				end
			end
		end
	end
end
local function refresh(player)
	local Character = player.Character

	if Character == nil then
		return
	end

	local signHeld = player:GetAttribute("SignHeld")
	local foundChild = Character:FindFirstChild("Right Arm")
	local tool = Character:FindFirstChildOfClass("Tool")
	local u99 = false

	if typeof(signHeld) == "string" then
		u99 = false

		if foundChild ~= nil then
			u99 = foundChild:IsA("BasePart") and tool == nil
		end
	end

	local v100 = t1[player]

	if v100 and (v100.Parent == nil or v100.PrimaryPart == nil) then
		v100:Destroy()
		v100 = nil
		t1[player] = nil
	end

	if v100 then
		local v101 = v100.PrimaryPart

		if v101 then
			v101 = v100.PrimaryPart:FindFirstChild("SignGrip")
		end

		if v101 == nil or not v101:IsA("Weld") or foundChild ~= v101.Part0 then
			v100:Destroy()
			v100 = nil
			t1[player] = nil
		end
	end

	if player == players.LocalPlayer then
		setHoldPose(Character, u99)
	end

	if not u99 then
		if v100 then
			v100:Destroy()
		end

		t1[player] = nil
		clearBoothBoards(player)

		return
	end

	if v100 == nil then
		local clone = v5:Clone()

		clone.Name = ("%s_%d"):format("SignRig", player.UserId)

		local holdC02 = clone:FindFirstChild("HoldC0")

		if holdC02 then
			holdC02:Destroy()
		end

		local clonePrimaryPart = clone.PrimaryPart
		local n1 = foundChild.CFrame * v7
		local v106 = cFrame:Inverse()
		local v107 = clonePrimaryPart.CFrame:Inverse()

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("BasePart") then
				v.CFrame = n1 * v106 * v107 * v.CFrame
			end
		end

		local signGrip: Weld = Instance.new("Weld")

		signGrip.Name = "SignGrip"
		signGrip.Part0 = foundChild
		signGrip.Part1 = clonePrimaryPart
		signGrip.C0 = v7
		signGrip.C1 = cFrame
		signGrip.Parent = clonePrimaryPart
		clone.Parent = workspace
		v100 = clone
		t1[player] = clone
	end

	render(v100, player)
end

local t3: {[any]: any} = {}

local function bindCharacter(p13, p14)
	local v113 = t3[p13]

	if v113 == nil then
		return
	end

	table.insert(v113, p14.ChildAdded:Connect(function(p15)
		if p15:IsA("Tool") or p15.Name == "Right Arm" then
			task.defer(refresh, p13)
		end
	end))
	table.insert(v113, p14.ChildRemoved:Connect(function(p16)
		if p16:IsA("Tool") then
			task.defer(refresh, p13)
		end
	end))
	task.defer(refresh, p13)
end
local function bind(player)
	local t5: {[any]: any} = {}

	t3[player] = t5

	for _, v in ipairs({
		"SignHeld",
		"SignWantKind",
		"SignWantItem",
		"SignWantName",
		"SignWantIcon",
		"SignWantRarity",
		"SignText",
		"SignTextColor"
	}) do
		local v118 = player:GetAttributeChangedSignal(v)

		table.insert(t5, v118:Connect(function()
			refresh(player)
		end))
	end

	table.insert(t5, player.CharacterAdded:Connect(function(p18)
		bindCharacter(player, p18)
	end))
	table.insert(t5, player.CharacterRemoving:Connect(function()
		local v144 = t1[player]

		if v144 then
			v144:Destroy()
		end

		t1[player] = nil
		clearBoothBoards(player)
	end))

	if player.Character then
		bindCharacter(player, player.Character)
	end
end

for _, v in ipairs(players:GetPlayers()) do
	bind(v)
end

players.PlayerAdded:Connect(bind)
players.PlayerRemoving:Connect(function(player: Player)
	clearBoothBoards(player)

	local v120 = t1[player]

	if v120 then
		v120:Destroy()
	end

	t1[player] = nil
	v120 = t3[player]

	if v120 then
		for _, v in ipairs(v120) do
			v:Disconnect()
		end

		t3[player] = nil
	end
end)

local t4: {[any]: any} = {}

boothClient.Changed:Connect(function()
	for k, _ in pairs(t3) do
		if k:GetAttribute("SignHeld") == "Booth" then
			local boothClientSignature = boothClient.Signature
			local kUserId = k.UserId
			local v127 = boothClient.GetSnapshot()
			local v128

			if typeof(v127) == "table" then
				local v129, v130, v131 = ipairs(v127)
				local v132: boolean = false

				for iterFirst, iterSecond in v129, v130, v131 do
					if kUserId == iterSecond.OwnerUserId then
						v128 = iterSecond
						v132 = true

						break
					end
				end

				if not v132 then
					v128 = nil
				end
			else
				v128 = nil
			end

			local v135 = boothClientSignature(v128)

			if t4[k] ~= v135 then
				t4[k] = v135
				refresh(k)
			end
		else
			t4[k] = nil
		end
	end
end)
players.PlayerRemoving:Connect(function(player: Player)
	t4[player] = nil
end)
