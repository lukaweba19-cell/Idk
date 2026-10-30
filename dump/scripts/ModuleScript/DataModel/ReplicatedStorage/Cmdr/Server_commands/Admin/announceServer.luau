-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local textService: TextService = game:GetService("TextService")
local players: Players = game:GetService("Players")
local chat: Chat = game:GetService("Chat")

return function(p1, p2)
	local v6: TextFilterResult = textService:FilterStringAsync(p2, p1.Executor.UserId, Enum.TextFilterContext.PublicChat)

	for _, v in ipairs(players:GetPlayers()) do
		if chat:CanUsersChatAsync(p1.Executor.UserId, v.UserId) then
			local v9: string = v6:GetChatForUserAsync(v.UserId)

			p1:SendEvent(v, "Message", v9, p1.Executor)
		end
	end

	return "Created announcement."
end
