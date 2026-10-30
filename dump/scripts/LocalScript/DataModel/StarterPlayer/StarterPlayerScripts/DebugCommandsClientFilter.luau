-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local textChatService: TextChatService = game:GetService("TextChatService")
local LocalPlayer: Player = players.LocalPlayer

local function isAuthorized()
	return LocalPlayer:GetAttribute("DebugAuthorized") == true
end
local function isGenerated(p1)
	local v9 = p1:IsA("TextChatCommand")

	if v9 then
		v9 = p1:GetAttribute("GeneratedByChatCommands") == true
	end

	return v9
end
local function removeGeneratedCommands()
	local textChatDebugCommands: Instance = textChatService:FindFirstChild("TextChatDebugCommands")

	if not textChatDebugCommands then
		return
	end

	for _, v in ipairs(textChatDebugCommands:GetChildren()) do
		local v13 = v:IsA("TextChatCommand")

		if v13 then
			v13 = v:GetAttribute("GeneratedByChatCommands") == true
		end

		if v13 then
			v:Destroy()
		end
	end
end

local n1 = os.clock() + 5

while true do
	if LocalPlayer:GetAttribute("DebugAuthorized") ~= nil or not (n1 > os.clock()) then
		break
	end

	task.wait(0.1)
end

if LocalPlayer:GetAttribute("DebugAuthorized") ~= true then
	removeGeneratedCommands()
	textChatService:WaitForChild("TextChatDebugCommands").ChildAdded:Connect(function(p2: Instance)
		if LocalPlayer:GetAttribute("DebugAuthorized") ~= true then
			local v15: boolean = p2:IsA("TextChatCommand")

			if v15 then
				v15 = p2:GetAttribute("GeneratedByChatCommands") == true
			end

			if v15 then
				p2:Destroy()
			end
		end
	end)
end
