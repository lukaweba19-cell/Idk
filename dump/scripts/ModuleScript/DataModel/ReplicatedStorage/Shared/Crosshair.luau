-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local crosshairSync: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("CrosshairSync")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(shared:WaitForChild("ViewedPlayer"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local crosshairSettings = require(replicatedStorageShared:WaitForChild("CrosshairSettings"))
local v9: Instance = replicatedStorage:WaitForChild("Shared")
local scopeTypes = require(v9:WaitForChild("ScopeTypes"))
local u11 = true
local u12: boolean = false
local n1 = 0
local u14: boolean = false
local scopeTypesValid_scopes = scopeTypes.VALID_SCOPES
local scopeTypesIsFullOverlayScope = scopeTypes.IsFullOverlayScope
local scopeTypesIsValidScope = scopeTypes.IsValidScope
local u18 = nil
local u19: boolean = false
local n2: number = 0
local n3 = 2
local n4 = 0
local color3 = Color3.new(1, 1, 1)
local t1: {[any]: any} = {}
local viewedPlayerGetSpecTargetUserId = viewedPlayer.GetSpecTargetUserId
local t2: {[any]: any} = {
	Enabled = true,
	Aiming = false,
	Spread = 0,
	IsGun = false,
	ADS = nil,
	TwoHanded = false,
	Reloading = 0,
	ReloadingDuration = 2,
	AmmoCount = 0,
	AmmoTint = Color3.new(1, 1, 1)
}

local function getOrCreateState(p1)
	local v35 = t1[p1]

	if v35 then
		return v35
	end

	v35 = {
		Enabled = t2.Enabled,
		Aiming = t2.Aiming,
		Spread = t2.Spread,
		IsGun = t2.IsGun,
		ADS = t2.ADS,
		TwoHanded = t2.TwoHanded,
		Reloading = t2.Reloading,
		ReloadingDuration = t2.ReloadingDuration,
		AmmoCount = t2.AmmoCount,
		AmmoTint = t2.AmmoTint
	}
	t1[p1] = v35

	return v35
end
local function effectiveState()
	local v36 = viewedPlayerGetSpecTargetUserId()

	if v36 == nil then
		return {
			Enabled = u11,
			Aiming = u12,
			Spread = n1,
			IsGun = u14,
			ADS = u18,
			TwoHanded = u19,
			Reloading = n2,
			ReloadingDuration = n3,
			AmmoCount = n4,
			AmmoTint = color3
		}
	end

	return (getOrCreateState(v36))
end
local function sendPatch(p2)
	crosshairSync:FireServer("Patch", p2)
end
local function handleInbound(p14, p15, p16)
	if p14 == "PatchFrom" then
		if typeof(p15) == "number" then
			if typeof(p16) == "table" then
				local v41 = getOrCreateState(p15)

				if p16.Enabled ~= nil then
					v41.Enabled = if p16.Enabled == true then true else nil
				end

				if p16.Aiming ~= nil then
					v41.Aiming = p16.Aiming == true
				end

				if p16.IsGun ~= nil then
					v41.IsGun = p16.IsGun == true
				end

				if p16.ADS ~= nil then
					v41.ADS = typeof(p16.ADS) == "string" and scopeTypesValid_scopes[p16.ADS] and p16.ADS or nil
				end

				if p16.TwoHanded ~= nil then
					v41.TwoHanded = p16.TwoHanded == true
				end

				if p16.Spread ~= nil and typeof(p16.Spread) == "number" then
					v41.Spread = p16.Spread
				end

				if p16.Reloading ~= nil and typeof(p16.Reloading) == "number" then
					v41.Reloading = p16.Reloading
				end

				if p16.ReloadingDuration ~= nil and typeof(p16.ReloadingDuration) == "number" then
					v41.ReloadingDuration = p16.ReloadingDuration
				end

				if p16.AmmoCount ~= nil and typeof(p16.AmmoCount) == "number" then
					v41.AmmoCount = p16.AmmoCount
				end

				if p16.AmmoTint ~= nil and typeof(p16.AmmoTint) == "Color3" then
					v41.AmmoTint = p16.AmmoTint
				end

				return
			end

			return
		end
	elseif p14 == "SnapshotRequest" then
		if typeof(p15) == "number" then
			crosshairSync:FireServer("SnapshotResponse", p15, {
				Enabled = if u11 == true then true else false,
				Aiming = u12,
				Spread = n1,
				IsGun = u14,
				ADS = u18 or "",
				TwoHanded = u19,
				Reloading = n2,
				ReloadingDuration = n3,
				AmmoCount = n4,
				AmmoTint = color3
			})

			return
		end
	elseif p14 == "Snapshot" then
		if typeof(p15) == "number" then
			if typeof(p16) == "table" then
				local v42 = getOrCreateState(p15)

				v42.Enabled = if p16.Enabled == true then true else nil
				v42.Aiming = p16.Aiming == true
				v42.IsGun = p16.IsGun == true
				v42.ADS = typeof(p16.ADS) == "string" and scopeTypesValid_scopes[p16.ADS] and p16.ADS or nil
				v42.TwoHanded = p16.TwoHanded == true
				v42.Spread = typeof(p16.Spread) == "number" and p16.Spread or 0
				v42.Reloading = typeof(p16.Reloading) == "number" and p16.Reloading or 0
				v42.ReloadingDuration = typeof(p16.ReloadingDuration) == "number" and p16.ReloadingDuration > 0 and p16.ReloadingDuration or 2
				v42.AmmoCount = typeof(p16.AmmoCount) == "number" and p16.AmmoCount or 0
				v42.AmmoTint = typeof(p16.AmmoTint) == "Color3" and p16.AmmoTint or Color3.new(1, 1, 1)

				return
			end

			return
		end
	elseif p14 == "StyleFrom" then
		if typeof(p15) == "number" then
			if typeof(p16) == "table" then
				crosshairSettings.setStyleFor(p15, p16)

				return
			end

			return
		end

		return
	end
end

crosshairSync.OnClientEvent:Connect(handleInbound)
players.PlayerRemoving:Connect(function(player: Player)
	t1[player.UserId] = nil
	crosshairSettings.clearStyleFor(player.UserId)
end)

local module: {[any]: any} = {
	IsFullOverlayScope = scopeTypesIsFullOverlayScope,
	IsValidScope = scopeTypesIsValidScope,
	SetEnabled = function(p3)
		u11 = if p3 then true else nil
		crosshairSync:FireServer("Patch", {
			Enabled = if u11 == true then true else false
		})
	end,
	SetAiming = function(p4)
		u12 = p4 == true
		crosshairSync:FireServer("Patch", { Aiming = u12 })
	end,
	SetSpread = function(p5)
		n1 = typeof(p5) == "number" and p5 or 0
		crosshairSync:FireServer("Patch", { Spread = n1 })
	end,
	SetIsGun = function(p6)
		u14 = p6 == true
		crosshairSync:FireServer("Patch", { IsGun = u14 })
	end,
	SetADS = function(p7, p8)
		if p7 then
			u18 = if typeof(p7) == "string" and scopeTypesValid_scopes[p7] then p7 else if typeof(p8) == "string" and scopeTypesValid_scopes[p8] then p8 else "Focus"
		else
			u18 = nil
		end

		crosshairSync:FireServer("Patch", { ADS = u18 or "" })
	end,
	SetTwoHanded = function(p9)
		u19 = p9 == true
		crosshairSync:FireServer("Patch", { TwoHanded = u19 })
	end,
	SetReloading = function(p10, p11)
		if p10 then
			n2 = workspace:GetServerTimeNow()

			if typeof(p11) == "number" and p11 > 0 then
				n3 = p11
			end
		else
			n2 = 0
		end

		crosshairSync:FireServer("Patch", { Reloading = n2, ReloadingDuration = n3 })
	end,
	SetAmmoCount = function(p12)
		n4 = typeof(p12) == "number" and p12 > 0 and math.floor(p12) or 0
		crosshairSync:FireServer("Patch", { AmmoCount = n4 })
	end,
	SetAmmoTint = function(p13)
		color3 = typeof(p13) == "Color3" and p13 or Color3.new(1, 1, 1)
		crosshairSync:FireServer("Patch", { AmmoTint = color3 })
	end,
	__ReplayInvoke = function(p17, p18, p19)
		handleInbound(p17, p18, p19)
	end
}

LocalPlayer.CharacterRemoving:Connect(function()
	module.SetADS(false)
	module.SetAiming(false)
	module.SetSpread(0)
	module.SetTwoHanded(false)
	module.SetReloading(false)
	module.SetAmmoCount(0)
end)

local u32 = nil

local function requestSnapshotFor(p21)
	crosshairSync:FireServer("RequestSnapshot", p21)
end

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local v59 = viewedPlayerGetSpecTargetUserId()
	local v60 = u32

	if v59 ~= v60 then
		u32 = v59
	end

	if v59 ~= v60 and v59 ~= nil then
		crosshairSync:FireServer("RequestSnapshot", v59)
	end
end)
setmetatable(module, {
	__index = function(_, p23)
		if p23 == "Enabled" or p23 == "Aiming" or p23 == "Spread" or p23 == "IsGun" or p23 == "ADS" or p23 == "TwoHanded" or p23 == "Reloading" or p23 == "ReloadingDuration" or p23 == "AmmoCount" or p23 == "AmmoTint" then
			return effectiveState()[p23]
		end

		return nil
	end,
	__newindex = function(_, p25, p26)
		if p25 == "Enabled" then
			module.SetEnabled(p26)

			return
		end

		if p25 == "Aiming" then
			module.SetAiming(p26)

			return
		end

		if p25 == "Spread" then
			module.SetSpread(p26)

			return
		end

		if p25 == "IsGun" then
			module.SetIsGun(p26)

			return
		end

		if p25 == "ADS" then
			module.SetADS(p26)

			return
		end

		if p25 == "TwoHanded" then
			module.SetTwoHanded(p26)

			return
		end

		if p25 == "Reloading" then
			module.SetReloading(p26)

			return
		end

		if p25 == "AmmoCount" then
			module.SetAmmoCount(p26)

			return
		end

		if p25 == "AmmoTint" then
			module.SetAmmoTint(p26)

			return
		end

		rawset(module, p25, p26)
	end
})

return module
