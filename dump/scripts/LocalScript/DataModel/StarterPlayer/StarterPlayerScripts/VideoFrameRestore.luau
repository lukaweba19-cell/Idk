-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local playerGui: Instance = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

for _, v in ipairs(playerGui:GetDescendants()) do
	if v:IsA("VideoFrame") then
		local videoId = v:GetAttribute("VideoId")

		if typeof(videoId) == "string" and videoId ~= "" and videoId ~= v.Video then
			v.Video = videoId
		end
	end
end

playerGui.DescendantAdded:Connect(function(p1: Instance)
	if not p1:IsA("VideoFrame") then
		return
	end

	local videoId: any = p1:GetAttribute("VideoId")

	if typeof(videoId) == "string" and videoId ~= "" then
		if videoId ~= p1.Video then
			p1.Video = videoId
		end

		return
	end
end)
