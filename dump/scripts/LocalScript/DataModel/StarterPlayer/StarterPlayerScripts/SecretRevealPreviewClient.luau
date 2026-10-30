-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local secretReveal = require(shared:WaitForChild("SecretReveal"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local devilsSightReveal = require(replicatedStorageShared:WaitForChild("DevilsSightReveal"))
local secretRevealPreview: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("SecretRevealPreview")
local u7: boolean = false

secretRevealPreview.OnClientEvent:Connect(function(p1)
	if not u7 and typeof(p1) == "table" then
		u7 = true

		local v9 = devilsSightReveal.Handles(p1)
		local ok, result = pcall((if v9 then devilsSightReveal else secretReveal).Play, p1)

		u7 = false

		if not ok then
			local text: string = tostring(result)

			warn("[SecretRevealPreview] " .. text)
		end

		return
	end
end)
