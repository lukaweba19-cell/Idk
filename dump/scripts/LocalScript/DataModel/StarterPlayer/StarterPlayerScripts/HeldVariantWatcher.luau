-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local heldVariants = require(shared:WaitForChild("HeldVariants"))
local t1: {[any]: any} = {}

local function unwatch(p1)
	local v13 = t1[p1]

	t1[p1] = nil

	if v13 then
		v13()
	end
end
local function watch(p2)
	if p2:IsA("Model") and not t1[p2] then
		t1[p2] = heldVariants.Watch(p2)
		p2.AncestryChanged:Connect(function()
			if not p2:IsDescendantOf(game) then
				local v16 = p2
				local v17 = t1[v16]

				t1[v16] = nil

				if v17 then
					v17()
				end
			end
		end)

		return
	end
end

for _, v in ipairs(players:GetPlayers()) do
	if v.Character then
		watch(v.Character)
	end

	v.CharacterAdded:Connect(watch)
end

players.PlayerAdded:Connect(function(player: Player)
	if player.Character then
		watch(player.Character)
	end

	player.CharacterAdded:Connect(watch)
end)

local characters: Instance = workspace:WaitForChild("Characters", 30)

if characters then
	for _, v in ipairs(characters:GetChildren()) do
		watch(v)
	end

	characters.ChildAdded:Connect(watch)
end
