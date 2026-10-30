-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local scriptParent: Instance = script.Parent

if not scriptParent:IsA("BasePart") then
	return
end

LocalPlayer:GetAttributeChangedSignal("ETClaimed"):Connect(function()
	if LocalPlayer:GetAttribute("ETClaimed") == true then
		scriptParent:Destroy()
	end
end)

if LocalPlayer:GetAttribute("ETClaimed") == true then
	scriptParent:Destroy()
end

local foundChild: Instance = scriptParent:FindFirstChild("Countdown", true)

if foundChild == nil or not foundChild:IsA("TextLabel") then
	return
end

local function render()
	local expiresAt: any = scriptParent:GetAttribute("ExpiresAt")

	if typeof(expiresAt) == "number" then
		local v6: number = workspace:GetServerTimeNow()
		local roundedUp = math.ceil(expiresAt - v6)
		local v8 = math.max(0, roundedUp)

		foundChild.Text = ("EXPIRES IN %02d:%02d"):format(v8 // 60, v8 % 60)

		return
	end
end

task.spawn(function()
	while scriptParent.Parent ~= nil do
		local expiresAt: any = scriptParent:GetAttribute("ExpiresAt")

		if typeof(expiresAt) == "number" then
			local v10: number = workspace:GetServerTimeNow()
			local roundedUp = math.ceil(expiresAt - v10)
			local v12 = math.max(0, roundedUp)

			foundChild.Text = ("EXPIRES IN %02d:%02d"):format(v12 // 60, v12 % 60)
		end

		task.wait(0.5)
	end
end)
