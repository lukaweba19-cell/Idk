-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local abilityCastBroadcast: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("AbilityCastBroadcast")
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
local abilities: Instance = replicatedStorage:WaitForChild("Abilities")
local t1: {[any]: any} = {}

local function getClientModule(p1)
	local v18 = t1[p1]

	if v18 == nil then
		local foundChild: Instance = abilities:FindFirstChild(p1 .. "Client")

		if not foundChild or not foundChild:IsA("ModuleScript") then
			t1[p1] = false

			return nil
		end

		local ok, result = pcall(require, foundChild)

		if not ok then
			warn("SpectateAbilityVFX: require failed:", p1, result)
			t1[p1] = false

			return nil
		end

		t1[p1] = result

		return result
	end

	return v18 ~= false and v18 or nil
end

local u10 = nil
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))

local function cleanupForUser(p2)
	abilityVFXCleanup.CleanupAll(p2)
end

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	if u10 then
		abilityVFXCleanup.CleanupAll(u10)
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		u10 = spectating

		return
	end

	u10 = nil
end)

local function handleCast(p3, p4)
	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating == p3 then
		local t2 = players:GetPlayerByUserId(p3)

		if not t2 then
			local shared: Instance = replicatedStorage:WaitForChild("Shared")
			local character = require(shared:WaitForChild("ViewedPlayer")).GetCharacter()

			if not character or character == LocalPlayer.Character then
				return
			end

			t2 = {
				UserId = p3,
				Character = character,
				GetAttribute = function(_, p6)
					return character:GetAttribute(p6)
				end,
				IsA = function(_, p8)
					return p8 == "Player"
				end
			}
		end

		local v30 = getClientModule(p4)

		if v30 and typeof(v30) == "table" and typeof(v30.Cast) == "function" then
			local v31 = abilityCatalog.Get(p4)

			if (not v31 or v31.Type ~= "Character") and v30.SpectatorSafe ~= true then
				return
			end

			task.spawn(function()
				local ok, result = pcall(v30.Cast, t2)

				if not ok then
					warn("SpectateAbilityVFX: Cast error for", p4, result)
				end
			end)

			return
		end

		return
	end
end

abilityCastBroadcast.OnClientEvent:Connect(handleCast)

local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
local replayAbilityCast: Instance = bindables and bindables:FindFirstChild("ReplayAbilityCast")

if replayAbilityCast and replayAbilityCast:IsA("BindableEvent") then
	replayAbilityCast.Event:Connect(handleCast)
end
