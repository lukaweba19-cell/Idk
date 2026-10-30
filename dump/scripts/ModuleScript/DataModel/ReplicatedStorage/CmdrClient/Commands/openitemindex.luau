-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	Name = "openitemindex",
	Description = "Open the item index (every tradeable item + RAP). Run again to close it.",
	Group = "Admin",
	Aliases = { "itemindex" },
	Args = {},
	ClientRun = function(_)
		local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
		local openItemIndex: Instance = bindables and bindables:FindFirstChild("OpenItemIndex")

		if not openItemIndex or not openItemIndex:IsA("BindableEvent") then
			return "OpenItemIndex bindable not found -- is IndexWindowController running?"
		end

		openItemIndex:Fire({ Toggle = true })

		return "Item index toggled."
	end
}
