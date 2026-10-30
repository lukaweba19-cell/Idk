-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	Name = "rapspoofall",
	Description = "MD [DEV] demo only: fake RAP values + graphs for every item in YOUR item index (nothing saved or sent). rapspoofall on [days=14] | rapspoofall off. Real entries for one item: rapspoof.",
	Group = "Admin",
	Args = {
		{ Type = "string", Name = "action", Description = "on | off" },
		{
			Type = "integer",
			Name = "days",
			Description = "on: days of history in the graph (1-30).",
			Default = 14
		}
	},
	ClientRun = function(_, p2, p3)
		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		if not require(shared:WaitForChild("Universe")).IsDev() then
			return "rapspoofall only runs in the MD [DEV] universe."
		end

		local lowerText = string.lower(p2 or "")

		if lowerText == "on" or lowerText == "off" then
			local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
			local itemIndexSpoof: Instance = bindables and bindables:FindFirstChild("ItemIndexSpoof")

			if not itemIndexSpoof or not itemIndexSpoof:IsA("BindableEvent") then
				return "ItemIndexSpoof bindable not found -- is IndexWindowController running?"
			end

			itemIndexSpoof:Fire({
				On = if lowerText == "on" then true else false,
				Days = p3
			})

			if lowerText == "on" then
				local numberValue: number? = tonumber(p3)
				local floored = math.floor(numberValue or 14)

				return ("Item index spoofed for you: random RAP per item, %d-day graphs. Open it with openitemindex; `rapspoofall off` restores real data."):format((math.clamp(floored, 1, 30)))
			end

			return "Item index spoof off; real RAP data restored."
		end

		return "usage: rapspoofall on [days] | rapspoofall off"
	end
}
