-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	Name = "booth",
	Description = "Trading booth harness: status | claim | release | list | unlist | buy | announce | demo | open. Fully gated by BOOTH_SYSTEM_ENABLED (announce: by the announcer's own keys). demo = phantom stall stocked from the real catalogue (DEV universe only) so one tester can see the buyer side; open = open a booth's window from anywhere (client-side).",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "status | claim | release | list | unlist | buy | announce (preview the sale chat line) | demo (seed a phantom stall, or 'clear') | open (open a booth's window)"
		},
		{
			Type = "string",
			Name = "a",
			Description = "list: Kind (Knife/Revolver/Finisher/Crate) | unlist: listing id | buy: booth id (e.g. B01) | announce: price | demo: booth id (default: first vacant) or 'clear' | open: booth id",
			Optional = true
		},
		{
			Type = "string",
			Name = "b",
			Description = "list: InstanceId or CrateId | buy: listing id | announce: Kind (default Knife) | demo: listing count (default 8)",
			Optional = true
		},
		{
			Type = "string",
			Name = "c",
			Description = "list: price (Crate: count,price e.g. 3,500) | announce: ItemId (default MidnightKatana)",
			Optional = true
		}
	},
	ClientRun = function(_, p2, p3)
		if string.lower(p2 or "") ~= "open" then
			return nil
		end

		if p3 == nil or p3 == "" then
			return "Usage: booth open <boothId>   (e.g. booth open B01, or booth open 1)"
		end

		local upperText = string.upper(p3)
		local numberValue: number? = tonumber(upperText)

		if numberValue ~= nil then
			upperText = ("B%02d"):format(numberValue)
		end

		local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
		local openBoothWindow: Instance = bindables and bindables:FindFirstChild("OpenBoothWindow")

		if not openBoothWindow or not openBoothWindow:IsA("BindableEvent") then
			return "OpenBoothWindow bindable not found -- is BoothWindowController running?"
		end

		openBoothWindow:Fire({ BoothId = upperText })

		return "Opening " .. upperText .. "."
	end
}
