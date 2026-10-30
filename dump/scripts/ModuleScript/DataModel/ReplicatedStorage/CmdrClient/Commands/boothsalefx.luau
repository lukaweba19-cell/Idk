-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	Name = "boothsalefx",
	Description = "MD [DEV] only: preview the booth sale particles + sound for a given price at the nearest stand (or a BoothId).",
	Group = "Admin",
	Args = {
		{
			Type = "integer",
			Name = "price",
			Description = "Sale price in Trade Tokens (picks the tier)."
		},
		{
			Type = "string",
			Name = "boothId",
			Description = "Stand to play at, e.g. B03. Default: nearest bound stand.",
			Optional = true
		}
	},
	ClientRun = function(_, p2, p3)
		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		if not require(shared:WaitForChild("Universe")).IsDev() then
			return "boothsalefx only runs in the MD [DEV] universe."
		end

		local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
		local boothSaleFXPreview: Instance = bindables and bindables:FindFirstChild("BoothSaleFXPreview")

		if not boothSaleFXPreview or not boothSaleFXPreview:IsA("BindableEvent") then
			return "BoothSaleFXPreview bindable not found -- are you on a plaza server with BoothWorldController running?"
		end

		boothSaleFXPreview:Fire({
			Price = p2,
			BoothId = if p3 == nil or p3 == "" then nil else p3
		})

		return ("Playing the %d-token sale effect%s."):format(p2, if p3 == nil or p3 == "" then " at the nearest stand" else " at " .. p3)
	end
}
