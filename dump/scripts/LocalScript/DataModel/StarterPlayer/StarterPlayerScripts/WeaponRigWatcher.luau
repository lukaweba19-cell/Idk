-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponRigUtil = require(shared:WaitForChild("WeaponRigUtil"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local weaponOffhand = require(replicatedStorageShared:WaitForChild("WeaponOffhand"))
local v10: Instance = replicatedStorage:WaitForChild("Shared")
local paintbrushColors = require(v10:WaitForChild("PaintbrushColors"))
local v12: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(v12:WaitForChild("ViewedPlayer"))
local v14: Instance = replicatedStorage:WaitForChild("Shared")
local crosshair = require(v14:WaitForChild("Crosshair"))
local v16: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(v16:WaitForChild("PlayerState"))
local LocalPlayer: Player = players.LocalPlayer
local viewedPlayerGetSpecTargetUserId = viewedPlayer.GetSpecTargetUserId

replicatedStorage:WaitForChild("Knives")
replicatedStorage:WaitForChild("Revolvers")

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local effect = require(replicatedStorage:WaitForChild("Effect"))
local setKnifeHideUntil: Instance = bindables:WaitForChild("SetKnifeHideUntil")
local knifeRigHideUntil: Instance = remotes:WaitForChild("KnifeRigHideUntil")
local t1: {[any]: any} = { "ClanTag", "ClanRank", "ClanName" }

local function isFirstPerson()
	local playerStateCameraFirstPerson = playerState.CameraFirstPerson

	if playerStateCameraFirstPerson == nil then
		local CurrentCamera: Camera = workspace.CurrentCamera

		if not CurrentCamera then
			return false
		end

		if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
			return true
		end

		return (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 1
	end

	return playerStateCameraFirstPerson
end
local function shouldHideHipForUserId(p1)
	local playerStateCameraFirstPerson = playerState.CameraFirstPerson
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not (if playerStateCameraFirstPerson == nil then if not CurrentCamera then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 1 else playerStateCameraFirstPerson) then
		return false
	end

	if p1 == LocalPlayer.UserId then
		return true
	end

	if viewedPlayerGetSpecTargetUserId() and p1 == viewedPlayerGetSpecTargetUserId() then
		return true
	end

	return false
end
local function isSniperScopedForUserId(p2)
	local v90 = viewedPlayerGetSpecTargetUserId()

	if v90 ~= nil then
		if p2 ~= v90 then
			return false
		end
	elseif p2 ~= LocalPlayer.UserId then
		return false
	end

	return crosshair.IsFullOverlayScope(crosshair.ADS)
end
local function now()
	return workspace:GetServerTimeNow()
end
local function waitForPart(p3, p4, p5)
	local v94 = os.clock()

	while true do
		local v95 = os.clock()

		if not (p5 > v95 - v94) then
			break
		end

		if p3.Parent == nil then
			return nil
		end

		local foundChild = p3:FindFirstChild(p4)

		if foundChild and foundChild:IsA("BasePart") then
			return foundChild
		end

		task.wait(0.03)
	end

	return nil
end
local function ensureNoCollide(p6)
	weaponRigUtil.EnsureNoCollide(p6)
end
local function isFPEffectsDisabled()
	return LocalPlayer:GetAttribute("DisableFPEffects") == true
end
local function setRigLocalVisible(p7, p8)
	if not p7 then
		return
	end

	local playerStateCameraFirstPerson = playerState.CameraFirstPerson
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v102 = p8 and (if playerStateCameraFirstPerson == nil then if not CurrentCamera then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 1 else playerStateCameraFirstPerson)

	if v102 then
		v102 = LocalPlayer:GetAttribute("DisableFPEffects") == true
	end

	weaponRigUtil.SetRigVisible(p7, p8, p8 and not v102)
end
local function getKnifeTemplate(p9)
	return weaponRigUtil.GetKnifeTemplate(p9)
end
local function getRevolverTemplate(p10)
	return weaponRigUtil.GetRevolverTemplate(p10)
end
local function getRootPartFromRig(p11, p12)
	return weaponRigUtil.GetRootPart(p11, p12)
end
local function findMotorAnywhere(p13, p14)
	for _, v in ipairs(p13:GetDescendants()) do
		if v:IsA("Motor6D") and p14 == v.Name then
			return v
		end
	end

	return nil
end
local function ensureMotor(p15, name)
	local v113 = findMotorAnywhere(p15, name)

	if v113 then
		return v113
	end

	local motor6D: Motor6D = Instance.new("Motor6D")

	motor6D.Name = name

	return motor6D
end
local function detachMotor(p17, p18)
	local v117 = findMotorAnywhere(p17, p18)

	if v117 then
		v117.Part0 = nil
		v117.Part1 = nil
		v117.Parent = nil
	end
end
local function bindMotor(p19, name, parent, part1, c0, c1)
	local v124 = findMotorAnywhere(p19, name)
	local v125

	if v124 then
		v125 = v124
	else
		local motor6D: Motor6D = Instance.new("Motor6D")

		motor6D.Name = name
		v125 = motor6D
	end

	v125.Part0 = parent
	v125.Part1 = part1
	v125.C0 = c0
	v125.C1 = c1

	if parent ~= v125.Parent then
		v125.Parent = parent
	end
end
local function ensureRigFromTemplate(parent, name, p27, p28)
	local foundChild = parent:FindFirstChild(name)

	if foundChild and foundChild:IsA("Model") then
		local primaryPart = weaponRigUtil.GetRootPart(foundChild, p28)

		if primaryPart then
			foundChild.PrimaryPart = primaryPart
			weaponRigUtil.EnsureNoCollide(foundChild)

			return foundChild, primaryPart
		end

		foundChild:Destroy()
	end

	local clone = p27:Clone()

	clone.Name = name
	clone.Parent = parent

	local v134 = weaponRigUtil.GetRootPart(clone, p28)

	if not v134 then
		warn(("Rig %q missing root part (%s/PrimaryPart/any BasePart)"):format(name, p28))

		local part: Part = Instance.new("Part")

		part.Transparency = 1
		part.CanCollide = false
		part.Anchored = true
		part.Parent = clone
		clone.PrimaryPart = part

		return clone, part
	end

	clone.PrimaryPart = v134
	weaponRigUtil.EnsureNoCollide(clone)

	return clone, v134
end
local function hasToolEquipped(p29, p30)
	local tool = p29:FindFirstChildWhichIsA("Tool")

	if tool and tool:GetAttribute(p30) == true then
		return true
	end

	if p29:GetAttribute("BotMatchBot") == true then
		return p29:GetAttribute(p30) == true
	end

	return false
end
local function isInMatch(p31)
	return p31:GetAttribute("InMatch") == true
end

isInMatch = function(p32, p33)
	local foundChild = p32:FindFirstChild(p33)

	if foundChild and (not not foundChild:IsA("Weld") or not not foundChild:IsA("Motor6D")) then
		return foundChild.C0, foundChild.C1
	end

	return nil, nil
end

local function knifeHandC0(p34)
	local cFrame = CFrame.new(0, -p34.Size.Y / 2, 0)
	local v145 = CFrame.Angles(-1.5707963267948966, 0, 0)

	return cFrame * v145
end
local function knifeHandC1()
	return CFrame.new(0, -1, -0.1)
end
local function revolverHandC0(p35)
	local cFrame = CFrame.new(0, -p35.Size.Y / 2 + 0.15, -0.35)
	local v148 = CFrame.Angles(-1.5707963267948966, 0, 0)

	return cFrame * v148
end
local function revolverHandC1()
	return CFrame.new(0, 0, 0)
end
local function knifeHipC0_R()
	return CFrame.new(1.100000023841858, -1.25, 0.25, 1, 0, 0, 0, -0.4999999701976776, -0.866025447845459, 0, 0.866025447845459, -0.4999999701976776)
end
local function revolverHipC0_L()
	return CFrame.new(-1.100000023841858, -0.5, -0.6000000238418579, 1, 0, 0, 0, -0.4999999701976776, 0.866025447845459, 0, -0.866025447845459, -0.4999999701976776)
end
local function hipC1()
	return CFrame.identity
end
local function knifeShotgunHandC0(p36, p37, p38)
	local v152 = p38

	if not v152 then
		local cFrame = CFrame.new(0, -p37.Size.Y / 2, 0)
		local v154 = CFrame.Angles(-1.5707963267948966, 0, 0)

		v152 = cFrame * v154
	end

	local cFrame = CFrame.new(if p36 == "R" then -0.325 else 0.325, 0, 0)
	local v156 = CFrame.Angles(0, if p36 == "L" then -0.24434609527920614 else 0.24434609527920614, if p36 == "L" then -0.17453292519943295 else 0.17453292519943295)

	return v152 * cFrame * v156
end
local function isShotgunActiveForPlayer(p39)
	local attributeValue = p39:GetAttribute(if p39 == LocalPlayer then "KnifeEffects.Shotgun.ExpiresAt" else "SERVER_KnifeEffects.Shotgun.ExpiresAt")
	local u159: boolean = false

	if typeof(attributeValue) == "number" then
		local v160: number = workspace:GetServerTimeNow()

		u159 = attributeValue > v160
	end

	return u159
end
local function normalizeEffectAttrName(p40, p41)
	if not p40:find("Effects.", 1, true) then
		return nil
	end

	if not p40:match("%.ExpiresAt$") then
		return nil
	end

	if not p41 then
		p40 = p40:gsub("^SERVER_", "")
	elseif p40:find("SERVER_", 1, true) then
		return nil
	end

	return (p40:gsub("%.ExpiresAt$", ""))
end
local function hasController()
	return userInputService.GamepadEnabled
end

local t2: {[any]: any} = {}

local function disconnectAll(p42)
	for _, v in ipairs(p42) do
		v:Disconnect()
	end

	table.clear(p42)
end
local function shouldAck(p43)
	if typeof(p43) == "string" then
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		if p43 == matchId then
			return true
		end

		if p43 == LocalPlayer:GetAttribute("LobbySpectateMatchId") then
			return true
		end

		return false
	end

	return false
end
local function copyNearCamera(p44, p45)
	local boundingBox = p44:FindFirstChild("BoundingBox")
	local CurrentCamera: Camera = workspace.CurrentCamera

	if boundingBox and boundingBox:IsA("BasePart") and CurrentCamera then
		local v172 = boundingBox.CFrame:PointToObjectSpace(CurrentCamera.CFrame.Position)
		local n1 = boundingBox.Size * 0.5
		local v174 = v172:Max(-n1):Min(n1)

		return (v172 - v174).Magnitude < (if p45 then 0.05 else 0) + 0.3
	end

	return false
end
local function syncCopyNearCamera(p46, p47)
	if not p46 then
		return
	end

	local u177: boolean = p46:GetAttribute("NearCameraHidden") == true
	local v178 = p47 and copyNearCamera(p46, u177)

	if v178 ~= u177 then
		p46:SetAttribute("NearCameraHidden", if v178 then true else nil)

		local u179: boolean = not v178

		if not p46 then
			return
		end

		local playerStateCameraFirstPerson = playerState.CameraFirstPerson
		local CurrentCamera: Camera = workspace.CurrentCamera
		local u182 = u179 and (if playerStateCameraFirstPerson == nil then if not CurrentCamera then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 1 else playerStateCameraFirstPerson)

		if u182 then
			u182 = LocalPlayer:GetAttribute("DisableFPEffects") == true
		end

		weaponRigUtil.SetRigVisible(p46, u179, u179 and not u182)

		return
	end
end
local function applyVisibility(p48)
	if p48.player ~= LocalPlayer and not (if typeof((p48.player:GetAttribute("MatchId"))) == "string" then if p48.player:GetAttribute("MatchId") == LocalPlayer:GetAttribute("MatchId") then true else p48.player:GetAttribute("MatchId") == LocalPlayer:GetAttribute("LobbySpectateMatchId") else false) then
		return
	end

	local userId = p48.player.UserId
	local playerStateCameraFirstPerson = playerState.CameraFirstPerson
	local CurrentCamera: Camera = workspace.CurrentCamera
	local u187

	if not (if playerStateCameraFirstPerson == nil then if not CurrentCamera then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude <= 1 else playerStateCameraFirstPerson) then
		u187 = false
	elseif userId == LocalPlayer.UserId then
		u187 = true
	else
		local v188 = viewedPlayerGetSpecTargetUserId()

		u187 = if v188 and userId == v188 then true else false
	end

	local u189: boolean = p48.character:GetAttribute("EmoteHideWeapons") == true
	local u190: boolean = workspace:GetServerTimeNow() >= p48.hideUntil
	local u191: boolean = u190 and (not u187 or not p48.knifeOnHip) and not u189

	if p48.knifeRig and u191 ~= p48.knifeRig:GetAttribute("ClientVisible") then
		p48.knifeRig:SetAttribute("ClientVisible", u191)

		local knifeRig = p48.knifeRig

		if knifeRig then
			local cameraFirstPerson = playerState.CameraFirstPerson
			local CurrentCamera2: Camera = workspace.CurrentCamera
			local u195 = u191 and (if cameraFirstPerson == nil then if not CurrentCamera2 then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera2.CFrame.Position - CurrentCamera2.Focus.Position).Magnitude <= 1 else cameraFirstPerson)

			if u195 then
				u195 = LocalPlayer:GetAttribute("DisableFPEffects") == true
			end

			weaponRigUtil.SetRigVisible(knifeRig, u191, u191 and not u195)
		end

		p48.knifeRig:SetAttribute("OffhandVisible", nil)
	end

	local u196: boolean = u191 and not p48.knifeOnHip
	local u197 = (u191 and p48.knifeOnHip) == true

	u191 = not u190 and not p48.knifeOnHip and not u189

	if p48.knifeRig and (u196 ~= p48.knifeRig:GetAttribute("OffhandVisible") or u197 ~= p48.knifeRig:GetAttribute("OffhandHolstered") or u191 ~= p48.knifeRig:GetAttribute("OffhandThrowHeld")) then
		p48.knifeRig:SetAttribute("OffhandVisible", u196)
		p48.knifeRig:SetAttribute("OffhandHolstered", u197)
		p48.knifeRig:SetAttribute("OffhandThrowHeld", u191)
		weaponOffhand.SetVisible(p48.knifeRig, u196, u197, u191)
	end

	u197 = u187
	syncCopyNearCamera(p48.knifeRigL, u197)
	syncCopyNearCamera(p48.knifeRigR, u197)
	u197 = u187 and not p48.revolverOnHip

	local u198
	local v199
	local v200
	local CurrentCamera3
	local u202
	local u203
	local u204

	if u197 then
		local v205 = p48.player.UserId
		local v206 = viewedPlayerGetSpecTargetUserId()

		if v206 ~= nil then
			if v205 ~= v206 then
				u197 = false
			else
				do
					u197 = crosshair.IsFullOverlayScope(crosshair.ADS)
					u198 = (not u187 or not p48.revolverOnHip) and not u197 and not u189

					if p48.revolverRig and u198 ~= p48.revolverRig:GetAttribute("ClientVisible") then
						p48.revolverRig:SetAttribute("ClientVisible", u198)
						v199 = p48.revolverRig

						if v199 then
							v200 = playerState.CameraFirstPerson
							CurrentCamera3 = workspace.CurrentCamera
							u202 = u198 and (if v200 == nil then if not CurrentCamera3 then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera3.CFrame.Position - CurrentCamera3.Focus.Position).Magnitude <= 1 else v200)

							if u202 then
								u202 = LocalPlayer:GetAttribute("DisableFPEffects") == true
							end

							weaponRigUtil.SetRigVisible(v199, u198, u198 and not u202)
						end

						p48.revolverRig:SetAttribute("OffhandVisible", nil)
					end

					u203 = u198 and not p48.revolverOnHip
					u204 = (u198 and p48.revolverOnHip) == true

					if p48.revolverRig and (u203 ~= p48.revolverRig:GetAttribute("OffhandVisible") or u204 ~= p48.revolverRig:GetAttribute("OffhandHolstered")) then
						p48.revolverRig:SetAttribute("OffhandVisible", u203)
						p48.revolverRig:SetAttribute("OffhandHolstered", u204)
						weaponOffhand.SetVisible(p48.revolverRig, u203, u204)
					end

					return
				end
			end
		elseif v205 ~= LocalPlayer.UserId then
			u197 = false
		else
			u197 = crosshair.IsFullOverlayScope(crosshair.ADS)
		end
	end

	local u198 = (not u187 or not p48.revolverOnHip) and not u197 and not u189

	if p48.revolverRig and u198 ~= p48.revolverRig:GetAttribute("ClientVisible") then
		p48.revolverRig:SetAttribute("ClientVisible", u198)

		local v199 = p48.revolverRig

		if v199 then
			local v200 = playerState.CameraFirstPerson
			local CurrentCamera3 = workspace.CurrentCamera
			local u202 = u198 and (if v200 == nil then if not CurrentCamera3 then false else if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then true else (CurrentCamera3.CFrame.Position - CurrentCamera3.Focus.Position).Magnitude <= 1 else v200)

			if u202 then
				u202 = LocalPlayer:GetAttribute("DisableFPEffects") == true
			end

			weaponRigUtil.SetRigVisible(v199, u198, u198 and not u202)
		end

		p48.revolverRig:SetAttribute("OffhandVisible", nil)
	end

	local u203 = u198 and not p48.revolverOnHip
	local u204 = (u198 and p48.revolverOnHip) == true

	if p48.revolverRig and (u203 ~= p48.revolverRig:GetAttribute("OffhandVisible") or u204 ~= p48.revolverRig:GetAttribute("OffhandHolstered")) then
		p48.revolverRig:SetAttribute("OffhandVisible", u203)
		p48.revolverRig:SetAttribute("OffhandHolstered", u204)
		weaponOffhand.SetVisible(p48.revolverRig, u203, u204)
	end
end
local function applyHideUntil(p49, p50, p51)
	for _, v in pairs(t2) do
		if p49 == v.player.UserId and p51 >= v.hideNonce then
			v.hideNonce = p51
			v.hideUntil = p50
			applyVisibility(v)
		end
	end
end
local function ensureSkins(p52)
	local knifeSkin = p52.player:GetAttribute("KnifeSkin")

	if typeof(knifeSkin) ~= "string" or knifeSkin == "" then
		knifeSkin = "Default"
	end

	local revolverSkin = p52.player:GetAttribute("RevolverSkin")

	if typeof(revolverSkin) ~= "string" or revolverSkin == "" then
		revolverSkin = "Default"
	end

	if knifeSkin ~= p52.lastKnifeSkin or not p52.knifeRig or not p52.knifeRig.Parent then
		local v215 = weaponRigUtil.GetKnifeTemplate(knifeSkin)

		if v215 then
			if p52.knifeRig then
				p52.knifeRig:Destroy()
			end

			local v216, v217 = ensureRigFromTemplate(p52.character, "KnifeRig", v215, "KnifeRoot")

			p52.knifeRig = v216
			p52.knifeRoot = v217
			weaponRigUtil.ApplyClanLabels(p52.knifeRig, p52.player)

			local paintbrushColorsTint = paintbrushColors.Tint
			local knifeRig = p52.knifeRig
			local v220 = p52.knifePaint or paintbrushColors.Current(p52.player)

			paintbrushColorsTint(knifeRig, v220)

			if p52.knifeRigL then
				p52.knifeRigL:Destroy()
				p52.knifeRigL = nil
				p52.knifeRootL = nil
			end

			if p52.knifeRigR then
				p52.knifeRigR:Destroy()
				p52.knifeRigR = nil
				p52.knifeRootR = nil
			end

			local v221 = findMotorAnywhere(p52.character, "Knife_HandAttach_L")

			if v221 then
				v221.Part0 = nil
				v221.Part1 = nil
				v221.Parent = nil
			end

			v221 = findMotorAnywhere(p52.character, "Knife_HandAttach_R")

			if v221 then
				v221.Part0 = nil
				v221.Part1 = nil
				v221.Parent = nil
			end

			p52.lastKnifeSkin = knifeSkin
		else
			warn("Missing knife template:", knifeSkin)
		end
	end

	if revolverSkin ~= p52.lastRevolverSkin or not p52.revolverRig or not p52.revolverRig.Parent then
		local v222 = weaponRigUtil.GetRevolverTemplate(revolverSkin)

		if v222 then
			if p52.revolverRig then
				p52.revolverRig:Destroy()
			end

			local v223, v224 = ensureRigFromTemplate(p52.character, "RevolverRig", v222, "RevolverRoot")

			p52.revolverRig = v223
			p52.revolverRoot = v224
			weaponRigUtil.ApplyClanLabels(p52.revolverRig, p52.player)
			p52.lastRevolverSkin = revolverSkin
		else
			warn("Missing revolver template:", revolverSkin)
		end
	end

	if p52.revolverRig and p52.revolverRig.Parent then
		local v225 = weaponRigUtil.GetRevolverTemplate(revolverSkin)

		if v225 and weaponRigUtil.ReconcileFromTemplate(p52.revolverRig, v225) > 0 then
			weaponRigUtil.ApplyClanLabels(p52.revolverRig, p52.player)
		end
	end

	if p52.knifeRig and p52.knifeRig.Parent then
		local v226 = weaponRigUtil.GetKnifeTemplate(knifeSkin)

		if v226 and weaponRigUtil.ReconcileFromTemplate(p52.knifeRig, v226) > 0 then
			weaponRigUtil.ApplyClanLabels(p52.knifeRig, p52.player)

			local tint = paintbrushColors.Tint
			local v228 = p52.knifeRig
			local v229 = p52.knifePaint or paintbrushColors.Current(p52.player)

			tint(v228, v229)
		end
	end
end
local function refreshClanLabels(p53)
	weaponRigUtil.ApplyClanLabels(p53.knifeRig, p53.player)
	weaponRigUtil.ApplyClanLabels(p53.knifeRigL, p53.player)
	weaponRigUtil.ApplyClanLabels(p53.knifeRigR, p53.player)
	weaponRigUtil.ApplyClanLabels(p53.revolverRig, p53.player)
end
local function ensureShotgunRigsIfNeeded(p54)
	if p54.knifeRigL and p54.knifeRigR and p54.knifeRootL and p54.knifeRootR then
		return
	end

	local v232 = weaponRigUtil.GetKnifeTemplate(p54.lastKnifeSkin)

	if not v232 then
		return
	end

	local v233, v234 = ensureRigFromTemplate(p54.character, "KnifeRig_L", v232, "KnifeRoot")

	p54.knifeRigL = v233
	p54.knifeRootL = v234

	local v235, v236 = ensureRigFromTemplate(p54.character, "KnifeRig_R", v232, "KnifeRoot")

	p54.knifeRigR = v235
	p54.knifeRootR = v236
	weaponRigUtil.ApplyClanLabels(p54.knifeRigL, p54.player)
	weaponRigUtil.ApplyClanLabels(p54.knifeRigR, p54.player)
	paintbrushColors.Tint(p54.knifeRigL, p54.knifePaint)
	paintbrushColors.Tint(p54.knifeRigR, p54.knifePaint)
end
local function detachKnifeMountMotors(p55)
	if p55.knifeRig then
		weaponOffhand.Detach(p55.character, p55.knifeRig)
	end

	local v238 = findMotorAnywhere(p55.character, "Knife_HandAttach")

	if v238 then
		v238.Part0 = nil
		v238.Part1 = nil
		v238.Parent = nil
	end

	v238 = findMotorAnywhere(p55.character, "Knife_HipAttach_R")

	if v238 then
		v238.Part0 = nil
		v238.Part1 = nil
		v238.Parent = nil
	end

	v238 = findMotorAnywhere(p55.character, "Knife_HandAttach_L")

	if v238 then
		v238.Part0 = nil
		v238.Part1 = nil
		v238.Parent = nil
	end

	v238 = findMotorAnywhere(p55.character, "Knife_HandAttach_R")

	if v238 then
		v238.Part0 = nil
		v238.Part1 = nil
		v238.Parent = nil
	end
end
local function detachRevolverMountMotors(p56)
	local v240 = findMotorAnywhere(p56.character, "Revolver_HandAttach")

	if v240 then
		v240.Part0 = nil
		v240.Part1 = nil
		v240.Parent = nil
	end

	v240 = findMotorAnywhere(p56.character, "Revolver_HipAttach_L")

	if v240 then
		v240.Part0 = nil
		v240.Part1 = nil
		v240.Parent = nil
	end

	weaponOffhand.Detach(p56.character)
end
local function motorIsBoundTo(p57, p58, p59)
	return p57 ~= nil and p58 == p57.Parent and p58 == p57.Part0 and p59 == p57.Part1
end
local function ensureMotorBound(p60, name, parent, part1, c0, c1)
	local v250 = findMotorAnywhere(p60.character, name)
	local v251

	if v250 then
		v251 = v250
	else
		local motor6D: Motor6D = Instance.new("Motor6D")

		motor6D.Name = name
		v251 = motor6D
	end

	if v251 ~= nil and parent == v251.Parent and parent == v251.Part0 and part1 == v251.Part1 then
		v251.C0 = c0
		v251.C1 = c1

		return
	end

	v251.Part0 = parent
	v251.Part1 = part1
	v251.C0 = c0
	v251.C1 = c1
	v251.Parent = parent
end
local function ensureMotorDetached(p66, p67)
	local v255 = findMotorAnywhere(p66.character, p67)

	if not v255 then
		return
	end

	v255.Part0 = nil
	v255.Part1 = nil
	v255.Parent = nil
end

local default: Instance = replicatedStorage:WaitForChild("Anims"):WaitForChild("Default")

local function resolveRigIdleAnim(p68, p69)
	local foundChild: Instance = default:FindFirstChild(p68)

	if not foundChild then
		return nil
	end

	local v259: Instance = foundChild:FindFirstChild(p69) or foundChild:FindFirstChild("Default")
	local v260: Instance = v259

	if v260 then
		v260 = v259:FindFirstChild("Idle")
	end

	if v260 and v260:IsA("Animation") then
		return v260
	end

	return nil
end
local function syncOneHipIdle(p70, p71)
	local v263 = if p71 then p70.knifeRig else p70.revolverRig
	local v264 = if p71 then p70.knifeOnHip else p70.revolverOnHip
	local u265 = if p71 then p70.knifeHipIdleTrack else p70.revolverHipIdleTrack
	local v266 = if p71 then p70.knifeHipIdleRig else p70.revolverHipIdleRig

	if u265 and v266 ~= v263 then
		pcall(function()
			u265:Stop(0)
		end)
		u265 = nil
		v266 = nil
	end

	local u267: boolean = v263 ~= nil and v263.Parent ~= nil

	if u267 and v264 then
		u267 = not weaponRigUtil.IsStaticOnHip(v263)
	elseif u267 then
		u267 = p70.character ~= LocalPlayer.Character and p70.character:GetAttribute("ReplayActor") ~= true
	end

	if u267 and not u265 and v263 then
		local foundChild = v263:FindFirstChildWhichIsA("AnimationController", true)
		local animator = foundChild and foundChild:FindFirstChildWhichIsA("Animator")
		local v270 = if animator then resolveRigIdleAnim(if p71 then "Knives" else "Revolvers", if p71 then p70.lastKnifeSkin else p70.lastRevolverSkin) else nil

		if animator and v270 then
			local ok, result = pcall(function()
				return animator:LoadAnimation(v270)
			end)

			if ok and result then
				result.Looped = true
				result.Priority = Enum.AnimationPriority.Idle
				u265 = result
				v266 = v263
			end
		end
	end

	if u265 then
		if u267 and not u265.IsPlaying then
			u265:Play()
		elseif not u267 and u265.IsPlaying then
			u265:Stop(0)
		end
	end

	if v264 and v263 and v263.Parent and weaponRigUtil.IsStaticOnHip(v263) then
		weaponRigUtil.ResetToBindPose(v263)
		runService.Heartbeat:Once(function()
			if v263.Parent then
				weaponRigUtil.ResetToBindPose(v263)
			end
		end)
	end

	if p71 then
		p70.knifeHipIdleTrack = u265
		p70.knifeHipIdleRig = v266
	else
		p70.revolverHipIdleTrack = u265
		p70.revolverHipIdleRig = v266
	end
end
local function syncHipIdles(p72)
	syncOneHipIdle(p72, true)
	syncOneHipIdle(p72, false)
end

local t3: {[any]: any} = {}

local function attachOffhandWithRetry(p73)
	local n1 = (t3[p73.character] or 0) + 1

	t3[p73.character] = n1

	if weaponOffhand.Attach(p73.character, p73.revolverRig, p73.leftArm) > 0 then
		return
	end

	if not weaponOffhand.Has(p73.revolverRig) then
		return
	end

	local n2 = os.clock() + 5

	task.spawn(function()
		while true do
			if not (os.clock() < n2) then
				break
			end

			runService.Heartbeat:Wait()

			if t3[p73.character] ~= n1 then
				return
			end

			if not p73.character.Parent then
				return
			end

			local revolverRig = p73.revolverRig

			if not revolverRig or not revolverRig.Parent then
				return
			end

			if p73.revolverOnHip then
				return
			end

			if weaponOffhand.Attach(p73.character, revolverRig, p73.leftArm) > 0 then
				return
			end
		end
	end)
end
local function updateAttachments(p74)
	ensureSkins(p74)

	local character = p74.character
	local tool = character:FindFirstChildWhichIsA("Tool")
	local u280: boolean = if tool and tool:GetAttribute("EnableKnifeRig") == true then true else if character:GetAttribute("BotMatchBot") == true then character:GetAttribute("EnableKnifeRig") == true else false
	local v281 = p74.character
	local tool2 = v281:FindFirstChildWhichIsA("Tool")
	local u283: boolean = if tool2 and tool2:GetAttribute("EnableRevolverRig") == true then true else if v281:GetAttribute("BotMatchBot") == true then v281:GetAttribute("EnableRevolverRig") == true else false
	local player = p74.player
	local attributeValue = player:GetAttribute(if player == LocalPlayer then "KnifeEffects.Shotgun.ExpiresAt" else "SERVER_KnifeEffects.Shotgun.ExpiresAt")
	local u286: boolean = false

	if typeof(attributeValue) == "number" then
		local v287: number = workspace:GetServerTimeNow()

		u286 = attributeValue > v287
	end

	local knifeRoot = p74.knifeRoot
	local revolverRoot = p74.revolverRoot

	if knifeRoot and revolverRoot then
		if p74.knifeRig then
			p74.knifeRig:SetAttribute("ClientVisible", nil)
		end

		if p74.revolverRig then
			p74.revolverRig:SetAttribute("ClientVisible", nil)
		end

		local u290 = u283 and not u280

		if u280 then
			local equip = knifeRoot:FindFirstChild("Equip")
			local v292
			local v293

			if equip and (not not equip:IsA("Weld") or not not equip:IsA("Motor6D")) then
				v292 = equip.C0
				v293 = equip.C1
			else
				v292 = nil
				v293 = nil
			end

			local v294 = v292

			if not v294 then
				local cFrame = CFrame.new(0, -p74.rightArm.Size.Y / 2, 0)
				local v296 = CFrame.Angles(-1.5707963267948966, 0, 0)

				v294 = cFrame * v296
			end

			local v297 = v293

			if not v297 then
				v297 = CFrame.new(0, -1, -0.1)
			end

			local rightArm = p74.rightArm
			local v299 = findMotorAnywhere(p74.character, "Knife_HandAttach")
			local v300

			if v299 then
				v300 = v299
			else
				local knife_HandAttach: Motor6D = Instance.new("Motor6D")

				knife_HandAttach.Name = "Knife_HandAttach"
				v300 = knife_HandAttach
			end

			if v300 ~= nil and rightArm == v300.Parent and rightArm == v300.Part0 and knifeRoot == v300.Part1 then
				v300.C0 = v294
				v300.C1 = v297
			else
				v300.Part0 = rightArm
				v300.Part1 = knifeRoot
				v300.C0 = v294
				v300.C1 = v297
				v300.Parent = rightArm
			end

			v297 = findMotorAnywhere(p74.character, "Knife_HipAttach_R")

			if v297 then
				v297.Part0 = nil
				v297.Part1 = nil
				v297.Parent = nil
			end

			p74.knifeOnHip = false
		else
			local unequip = knifeRoot:FindFirstChild("Unequip")
			local v303
			local v304

			if unequip and (not not unequip:IsA("Weld") or not not unequip:IsA("Motor6D")) then
				v303 = unequip.C0
				v304 = unequip.C1
			else
				v303 = nil
				v304 = nil
			end

			local torso = p74.torso
			local c0 = v303 or CFrame.new(1.100000023841858, -1.25, 0.25, 1, 0, 0, 0, -0.4999999701976776, -0.866025447845459, 0, 0.866025447845459, -0.4999999701976776)
			local c1 = v304 or CFrame.identity
			local v308 = findMotorAnywhere(p74.character, "Knife_HipAttach_R")
			local v309

			if v308 then
				v309 = v308
			else
				local knife_HipAttach_R: Motor6D = Instance.new("Motor6D")

				knife_HipAttach_R.Name = "Knife_HipAttach_R"
				v309 = knife_HipAttach_R
			end

			if v309 ~= nil and torso == v309.Parent and torso == v309.Part0 and knifeRoot == v309.Part1 then
				v309.C0 = c0
				v309.C1 = c1
			else
				v309.Part0 = torso
				v309.Part1 = knifeRoot
				v309.C0 = c0
				v309.C1 = c1
				v309.Parent = torso
			end

			local v311 = findMotorAnywhere(p74.character, "Knife_HandAttach")

			if v311 then
				v311.Part0 = nil
				v311.Part1 = nil
				v311.Parent = nil
			end

			p74.knifeOnHip = true
		end

		if u280 then
			if weaponOffhand.Has(p74.knifeRig) then
				weaponOffhand.Attach(p74.character, p74.knifeRig, p74.rightArm)
			end
		elseif p74.knifeRig then
			weaponOffhand.Detach(p74.character, p74.knifeRig)
		end

		if u290 then
			local equip = revolverRoot:FindFirstChild("Equip")
			local v313
			local v314

			if equip and (not not equip:IsA("Weld") or not not equip:IsA("Motor6D")) then
				v313 = equip.C0
				v314 = equip.C1
			else
				v313 = nil
				v314 = nil
			end

			local v315 = v313

			if not v315 then
				local cFrame = CFrame.new(0, -p74.rightArm.Size.Y / 2 + 0.15, -0.35)
				local v317 = CFrame.Angles(-1.5707963267948966, 0, 0)

				v315 = cFrame * v317
			end

			local v318 = v314

			if not v318 then
				v318 = CFrame.new(0, 0, 0)
			end

			local parent = p74.rightArm
			local v320 = findMotorAnywhere(p74.character, "Revolver_HandAttach")
			local v321

			if v320 then
				v321 = v320
			else
				local revolver_HandAttach: Motor6D = Instance.new("Motor6D")

				revolver_HandAttach.Name = "Revolver_HandAttach"
				v321 = revolver_HandAttach
			end

			if v321 ~= nil and parent == v321.Parent and parent == v321.Part0 and revolverRoot == v321.Part1 then
				v321.C0 = v315
				v321.C1 = v318
			else
				v321.Part0 = parent
				v321.Part1 = revolverRoot
				v321.C0 = v315
				v321.C1 = v318
				v321.Parent = parent
			end

			v318 = findMotorAnywhere(p74.character, "Revolver_HipAttach_L")

			if v318 then
				v318.Part0 = nil
				v318.Part1 = nil
				v318.Parent = nil
			end

			p74.revolverOnHip = false
			attachOffhandWithRetry(p74)
		else
			local unequip = revolverRoot:FindFirstChild("Unequip")
			local v324
			local v325

			if unequip and (not not unequip:IsA("Weld") or not not unequip:IsA("Motor6D")) then
				v324 = unequip.C0
				v325 = unequip.C1
			else
				v324 = nil
				v325 = nil
			end

			local part0 = p74.torso
			local v327 = v324 or CFrame.new(-1.100000023841858, -0.5, -0.6000000238418579, 1, 0, 0, 0, -0.4999999701976776, 0.866025447845459, 0, -0.866025447845459, -0.4999999701976776)
			local v328 = v325 or CFrame.identity
			local v329 = findMotorAnywhere(p74.character, "Revolver_HipAttach_L")
			local v330

			if v329 then
				v330 = v329
			else
				local revolver_HipAttach_L: Motor6D = Instance.new("Motor6D")

				revolver_HipAttach_L.Name = "Revolver_HipAttach_L"
				v330 = revolver_HipAttach_L
			end

			if v330 ~= nil and part0 == v330.Parent and part0 == v330.Part0 and revolverRoot == v330.Part1 then
				v330.C0 = v327
				v330.C1 = v328
			else
				v330.Part0 = part0
				v330.Part1 = revolverRoot
				v330.C0 = v327
				v330.C1 = v328
				v330.Parent = part0
			end

			local v332 = findMotorAnywhere(p74.character, "Revolver_HandAttach")

			if v332 then
				v332.Part0 = nil
				v332.Part1 = nil
				v332.Parent = nil
			end

			p74.revolverOnHip = true
			weaponOffhand.Detach(p74.character, p74.revolverRig)
		end

		if u286 and u280 then
			ensureShotgunRigsIfNeeded(p74)

			if p74.knifeRootL and p74.knifeRootR then
				local equip = p74.knifeRootL:FindFirstChild("Equip")
				local v334

				if equip and (not not equip:IsA("Weld") or not not equip:IsA("Motor6D")) then
					v334 = equip.C0

					local equipC1 = equip.C1
				else
					v334 = nil
				end

				local equip2 = p74.knifeRootR:FindFirstChild("Equip")
				local v337

				if equip2 and (not not equip2:IsA("Weld") or not not equip2:IsA("Motor6D")) then
					v337 = equip2.C0

					local equip2C1 = equip2.C1
				else
					v337 = nil
				end

				local equip3 = p74.knifeRootL:FindFirstChild("Equip")
				local equip3C0 = equip3.C0
				local v341 = if equip3 and (not not equip3:IsA("Weld") or not not equip3:IsA("Motor6D")) then equip3.C1 else nil
				local equip4 = p74.knifeRootR:FindFirstChild("Equip")
				local equip4C0 = equip4.C0
				local v344 = if equip4 and (not not equip4:IsA("Weld") or not not equip4:IsA("Motor6D")) then equip4.C1 else nil
				local v345 = p74.rightArm
				local knifeRootL = p74.knifeRootL
				local v347 = v334

				if not v347 then
					local cFrame = CFrame.new(0, -p74.rightArm.Size.Y / 2, 0)
					local v349 = CFrame.Angles(-1.5707963267948966, 0, 0)

					v347 = cFrame * v349
				end

				local v350 = CFrame.Angles(0, -0.24434609527920614, -0.17453292519943295)
				local n1 = v347 * CFrame.new(0.325, 0, 0) * v350
				local v352 = v341 or CFrame.new(0, -1, -0.1)
				local v353 = findMotorAnywhere(p74.character, "Knife_HandAttach_L")
				local v354

				if v353 then
					v354 = v353
				else
					local knife_HandAttach_L: Motor6D = Instance.new("Motor6D")

					knife_HandAttach_L.Name = "Knife_HandAttach_L"
					v354 = knife_HandAttach_L
				end

				if v354 ~= nil and v345 == v354.Parent and v345 == v354.Part0 and knifeRootL == v354.Part1 then
					v354.C0 = n1
					v354.C1 = v352
				else
					v354.Part0 = v345
					v354.Part1 = knifeRootL
					v354.C0 = n1
					v354.C1 = v352
					v354.Parent = v345
				end

				local v356 = p74.rightArm
				local knifeRootR = p74.knifeRootR

				v341 = v337

				if not v341 then
					local cFrame = CFrame.new(0, -p74.rightArm.Size.Y / 2, 0)
					local v359 = CFrame.Angles(-1.5707963267948966, 0, 0)

					v341 = cFrame * v359
				end

				v350 = CFrame.Angles(0, 0.24434609527920614, 0.17453292519943295)
				n1 = v341 * CFrame.new(-0.325, 0, 0) * v350
				v352 = v344 or CFrame.new(0, -1, -0.1)
				v350 = findMotorAnywhere(p74.character, "Knife_HandAttach_R")

				local v360

				if v350 then
					v360 = v350
				else
					local knife_HandAttach_R: Motor6D = Instance.new("Motor6D")

					knife_HandAttach_R.Name = "Knife_HandAttach_R"
					v360 = knife_HandAttach_R
				end

				if v360 ~= nil and v356 == v360.Parent and v356 == v360.Part0 and knifeRootR == v360.Part1 then
					v360.C0 = n1
					v360.C1 = v352
				else
					v360.Part0 = v356
					v360.Part1 = knifeRootR
					v360.C0 = n1
					v360.C1 = v352
					v360.Parent = v356
				end
			end
		else
			local v362 = findMotorAnywhere(p74.character, "Knife_HandAttach_L")

			if v362 then
				v362.Part0 = nil
				v362.Part1 = nil
				v362.Parent = nil
			end

			v362 = findMotorAnywhere(p74.character, "Knife_HandAttach_R")

			if v362 then
				v362.Part0 = nil
				v362.Part1 = nil
				v362.Parent = nil
			end

			if p74.knifeRigL then
				p74.knifeRigL:Destroy()
				p74.knifeRigL = nil
			end

			if p74.knifeRigR then
				p74.knifeRigR:Destroy()
				p74.knifeRigR = nil
			end
		end

		applyVisibility(p74)

		if u280 and not p74.lastKnifeEquipped then
			p74.knifePaint = paintbrushColors.Current(p74.player)
			paintbrushColors.Tint(p74.knifeRig, p74.knifePaint)
			paintbrushColors.Tint(p74.knifeRigL, p74.knifePaint)
			paintbrushColors.Tint(p74.knifeRigR, p74.knifePaint)
		end

		u290 = viewedPlayerGetSpecTargetUserId()

		local v363 = (p74.player == players.LocalPlayer or u290 and p74.player and u290 == p74.player.UserId) and p74.character:FindFirstChild("HumanoidRootPart")

		if v363 then
			local u364: boolean = true

			if u280 and (not not p74.character:GetAttribute("Reflecting") or not not p74.character:GetAttribute("ClientReflecting")) then
				u364 = false
			end

			if p74.character:GetAttribute("Decoy") then
				u364 = false
			end

			if u283 then
				local humanoid = p74.character:FindFirstChildOfClass("Humanoid")
				local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

				if animator then
					for _, v in ipairs(animator:GetPlayingAnimationTracks()) do
						if v.Name == "Shoot" or v.Name == "Barrage" then
							u364 = false

							break
						end
					end
				end
			end

			if u364 and (u280 and not p74.lastKnifeEquipped or u283 and not p74.lastRevolverEquipped) and not p74.mutedFirstEquipOnSpawn and userInputService.GamepadEnabled then
				p74.mutedFirstEquipOnSpawn = true
				u364 = false
			end

			if u280 and not p74.lastKnifeEquipped then
				local knifeSkin = p74.player:GetAttribute("KnifeSkin")
				local s1: string = "Knife." .. tostring(knifeSkin or "Default") .. ".Equip"
				local knifePaint = p74.knifePaint

				if knifePaint and sound:Find(s1 .. knifePaint) then
					s1 ..= knifePaint
				end

				if not sound:Find(s1) then
					s1 = "Knife.Default.Equip"
				end

				if p74.lastPlayedWeaponSound then
					p74.lastPlayedWeaponSound:Destroy()
				end

				if u364 then
					p74.lastPlayedWeaponSound = sound:Play(s1, v363)
				end
			end

			if u283 and not p74.lastRevolverEquipped then
				local revolverSkin = p74.player:GetAttribute("RevolverSkin")
				local s2: string = "Revolver." .. tostring(revolverSkin or "Default") .. ".Equip"

				if not sound:Find(s2) then
					s2 = "Revolver.Default.Equip"
				end

				if p74.lastPlayedWeaponSound then
					p74.lastPlayedWeaponSound:Destroy()
				end

				if u364 then
					p74.lastPlayedWeaponSound = sound:Play(s2, v363)
				end
			end
		end

		p74.lastKnifeEquipped = u280
		p74.lastRevolverEquipped = u283
		syncOneHipIdle(p74, true)
		syncOneHipIdle(p74, false)

		return
	end
end
local function bindCharacter(p75, p76)
	local foundChild = p76:FindFirstChild("Right Arm")

	if not foundChild or not foundChild:IsA("BasePart") then
		foundChild = waitForPart(p76, "Right Arm", 10)
	end

	if not foundChild then
		return
	end

	local torso = p76:FindFirstChild("Torso")

	if not torso or not torso:IsA("BasePart") then
		torso = waitForPart(p76, "Torso", 10)
	end

	if not torso then
		return
	end

	local foundChild2 = p76:FindFirstChild("Left Arm")

	if not foundChild2 or not foundChild2:IsA("BasePart") then
		foundChild2 = waitForPart(p76, "Left Arm", 10)
	end

	local t4: {[any]: any} = {
		knifeRig = nil,
		knifeRigL = nil,
		knifeRigR = nil,
		revolverRig = nil,
		knifeRoot = nil,
		knifeRootL = nil,
		knifeRootR = nil,
		revolverRoot = nil,
		knifeOnHip = false,
		revolverOnHip = false,
		hideUntil = 0,
		hideNonce = -1,
		lastKnifeSkin = "",
		lastRevolverSkin = "",
		lastKnifeEquipped = false,
		lastRevolverEquipped = false,
		lastShotgunActive = false,
		lastPlayedWeaponSound = nil,
		mutedFirstEquipOnSpawn = false,
		knifePaint = nil,
		player = p75,
		character = p76,
		rightArm = foundChild,
		leftArm = foundChild2,
		torso = torso,
		maid = {}
	}

	t2[p76] = t4

	local maid = t4.maid
	local v381 = p75:GetAttributeChangedSignal("KnifeSkin")

	table.insert(maid, v381:Connect(function()
		updateAttachments(t4)
	end))

	local v382 = t4.maid

	v381 = p75:GetAttributeChangedSignal("RevolverSkin")
	table.insert(v382, v381:Connect(function()
		updateAttachments(t4)
	end))

	local v383 = t4.maid

	v381 = p75:GetAttributeChangedSignal("InMatch")
	table.insert(v383, v381:Connect(function()
		updateAttachments(t4)
	end))

	for _, v in ipairs(t1) do
		local v386 = t4.maid
		local v387 = p75:GetAttributeChangedSignal(v)

		table.insert(v386, v387:Connect(function()
			local v418: {[any]: any} = t4

			weaponRigUtil.ApplyClanLabels(v418.knifeRig, v418.player)
			weaponRigUtil.ApplyClanLabels(v418.knifeRigL, v418.player)
			weaponRigUtil.ApplyClanLabels(v418.knifeRigR, v418.player)
			weaponRigUtil.ApplyClanLabels(v418.revolverRig, v418.player)
		end))
	end

	if p76:GetAttribute("BotMatchBot") == true then
		local v388 = t4.maid
		local v389 = p76:GetAttributeChangedSignal("EnableKnifeRig")

		table.insert(v388, v389:Connect(function()
			updateAttachments(t4)
		end))

		local v390 = t4.maid

		v389 = p76:GetAttributeChangedSignal("EnableRevolverRig")
		table.insert(v390, v389:Connect(function()
			updateAttachments(t4)
		end))
	end

	local function playEffect(p77, p78, p79)
		local v422 = p75.Character and p75.Character:FindFirstChild("HumanoidRootPart")

		if p78 == "Revolver" then
			local v423 = t4.revolverRig and t4.revolverRig.PrimaryPart or nil

			if not v423 then
				return
			end

			t4.revolverRig:SetAttribute("ClientVisible", nil)

			local v424 = v423:QueryDescendants("MeshPart#Revolver")[1] or v423

			effect.new(p77):replicate({
				Model = t4.revolverRig,
				Revolver = v424,
				Position = v422 and v422.Position or v424.Position,
				Root = v422,
				Toggle = p79
			})
		elseif p78 == "Knife" then
			local v425 = t4.knifeRig and t4.knifeRig:FindFirstChild("BoundingBox") or nil

			if not v425 then
				return
			end

			local v426 = t4.knifeRig:QueryDescendants("MeshPart#Blade")[1]

			if v426 then
				v425 = v426
			end

			t4.knifeRig:SetAttribute("ClientVisible", nil)
			effect.new(p77):replicate({
				Model = t4.knifeRig,
				Knife = v425,
				Position = v422 and v422.Position or v425.Position,
				Root = v422,
				Toggle = p79
			})

			return
		end
	end
	local function handleTool(p80, p81)
		local s1 = "Default"

		if p80.Name == "Revolver" then
			local revolverSkin = p75:GetAttribute("RevolverSkin")

			if revolverSkin then
				s1 = revolverSkin
			end
		else
			local v431 = p80.Name == "Knife" and p75:GetAttribute("KnifeSkin")

			if v431 then
				s1 = v431
			end
		end

		local s2: string = "EquipEffects." .. p80.Name .. "." .. s1

		if effect.find(s2) then
			playEffect(s2, p80.Name, p81)
		end
	end

	table.insert(t4.maid, p76.ChildAdded:Connect(function(p82)
		task.wait()

		if p82:IsA("Tool") then
			updateAttachments(t4)
			handleTool(p82, true)
		end
	end))
	table.insert(t4.maid, p76.ChildRemoved:Connect(function(p83)
		task.wait()

		if p83:IsA("Tool") then
			updateAttachments(t4)
			handleTool(p83, false)
		end
	end))

	local function handleRigEquip(p84, p85)
		local attributeValue = p75:GetAttribute(if p84 == "Revolver" then "RevolverSkin" else "KnifeSkin")

		if typeof(attributeValue) ~= "string" or attributeValue == "" then
			attributeValue = "Default"
		end

		local s1: string = "EquipEffects." .. p84 .. "." .. attributeValue

		if effect.find(s1) then
			playEffect(s1, p84, p85)
		end
	end

	local v394 = t4.maid

	v381 = p76:GetAttributeChangedSignal("EnableKnifeRig")
	table.insert(v394, v381:Connect(function()
		local enableKnifeRig = p76:GetAttribute("EnableKnifeRig")
		local knifeSkin = p75:GetAttribute("KnifeSkin")

		if typeof(knifeSkin) ~= "string" or knifeSkin == "" then
			knifeSkin = "Default"
		end

		local s1: string = "EquipEffects." .. "Knife" .. "." .. knifeSkin

		if effect.find(s1) then
			playEffect(s1, "Knife", enableKnifeRig == true)
		end
	end))

	local v395 = t4.maid

	v381 = p76:GetAttributeChangedSignal("EnableRevolverRig")
	table.insert(v395, v381:Connect(function()
		local enableRevolverRig = p76:GetAttribute("EnableRevolverRig")
		local revolverSkin = p75:GetAttribute("RevolverSkin")

		if typeof(revolverSkin) ~= "string" or revolverSkin == "" then
			revolverSkin = "Default"
		end

		local s1: string = "EquipEffects." .. "Revolver" .. "." .. revolverSkin

		if effect.find(s1) then
			playEffect(s1, "Revolver", enableRevolverRig == true)
		end
	end))

	local v396 = t4.maid

	v381 = p75:GetAttributeChangedSignal("KnifeEffects.Shotgun.ExpiresAt")
	table.insert(v396, v381:Connect(function()
		if p75 == LocalPlayer then
			updateAttachments(t4)
		end
	end))

	local v397 = t4.maid

	v381 = p75:GetAttributeChangedSignal("SERVER_KnifeEffects.Shotgun.ExpiresAt")
	table.insert(v397, v381:Connect(function()
		if p75 ~= LocalPlayer then
			updateAttachments(t4)
		end
	end))
	table.insert(t4.maid, p75.AttributeChanged:Connect(function(p86)
		local v446 = normalizeEffectAttrName(p86, p75 == LocalPlayer)

		if not v446 then
			return
		end

		if not effect.find(v446) then
			return
		end

		if t4.character ~= p75.Character then
			return
		end

		local attributeValue = p75:GetAttribute(p86)
		local u448: boolean = false

		if typeof(attributeValue) == "number" then
			local v449: number = workspace:GetServerTimeNow()

			u448 = attributeValue > v449
		end

		if u448 then
			local userId = p75.UserId

			for _, v in pairs(t2) do
				if userId == v.player.UserId then
					applyHideUntil(p75.UserId, 0, v.hideNonce)

					break
				end
			end
		end

		if p75.Character then
			local attributeValue2 = p75.Character:GetAttribute(v446)

			if u448 == attributeValue2 then
				return
			end

			p75.Character:SetAttribute(v446, u448)
		end

		if v446 == "KnifeEffects.Shotgun" then
			updateAttachments(t4)
		end

		if v446:match("RevolverEffects") then
			playEffect(v446, "Revolver", u448)

			return
		end

		playEffect(v446, "Knife", u448)
	end))
	table.insert(t4.maid, p76.AncestryChanged:Connect(function(_, p88)
		if p88 == nil then
			local maid = t4.maid

			for _, v in ipairs(maid) do
				v:Disconnect()
			end

			table.clear(maid)
			detachKnifeMountMotors(t4)

			local v459: {[any]: any} = t4
			local v460 = findMotorAnywhere(v459.character, "Revolver_HandAttach")

			if v460 then
				v460.Part0 = nil
				v460.Part1 = nil
				v460.Parent = nil
			end

			v460 = findMotorAnywhere(v459.character, "Revolver_HipAttach_L")

			if v460 then
				v460.Part0 = nil
				v460.Part1 = nil
				v460.Parent = nil
			end

			weaponOffhand.Detach(v459.character)
			t2[p76] = nil
			t3[p76] = nil
		end
	end))
	updateAttachments(t4)
end

for _, v in ipairs(players:GetPlayers()) do
	if v.Character then
		bindCharacter(v, v.Character)
	end

	v.CharacterAdded:Connect(function(p91)
		bindCharacter(v, p91)
	end)
end

players.PlayerAdded:Connect(function(player: Player)
	if player.Character then
		bindCharacter(player, player.Character)
	end

	player.CharacterAdded:Connect(function(p90: Model)
		bindCharacter(player, p90)
	end)
end)

local function makeBotPlayerProxy(character)
	return {
		UserId = character:GetAttribute("BotUserId") or -1,
		Character = character,
		GetAttribute = function(_, p94)
			return character:GetAttribute(p94)
		end,
		GetAttributeChangedSignal = function(_, p96)
			return character:GetAttributeChangedSignal(p96)
		end,
		AttributeChanged = character.AttributeChanged,
		IsA = function(_, p98)
			return p98 == "Player"
		end
	}
end
local function tryBindDecoy(p99)
	if not p99:IsA("Model") then
		return
	end

	local v402 = p99:GetAttribute("Decoy") and players:FindFirstChild(p99.Name)

	if v402 then
		bindCharacter(v402, p99)

		return
	end

	if p99:GetAttribute("BotMatchBot") == true then
		local v403 = makeBotPlayerProxy(p99)

		bindCharacter(v403, p99)
	end
end

workspace.Characters.ChildAdded:Connect(function(p100)
	tryBindDecoy(p100)
end)

for _, v in ipairs(workspace.Characters:GetChildren()) do
	tryBindDecoy(v)
end

setKnifeHideUntil.Event:Connect(function(p101, p102, p103)
	if typeof(p101) == "number" then
		if typeof(p102) == "number" then
			local typeName: string = typeof(p103)

			applyHideUntil(p101, p102, typeName == "number" and p103 or 0)

			return
		end

		return
	end
end)
knifeRigHideUntil.OnClientEvent:Connect(function(p104)
	if typeof(p104) == "table" then
		local userId = p104.userId
		local hideUntil = p104.hideUntil
		local v412 = p104.nonce

		if typeof(userId) == "number" then
			if typeof(hideUntil) == "number" then
				if typeof(v412) ~= "number" then
					v412 = 0
				end

				applyHideUntil(userId, hideUntil, v412)

				return
			end

			return
		end

		return
	end
end)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	for _, v in pairs(t2) do
		if v.knifeRig or v.revolverRig then
			applyVisibility(v)
		end
	end
end)
runService.Heartbeat:Connect(function()
	for _, v in pairs(t2) do
		if v.knifeRig or v.revolverRig then
			applyVisibility(v)
		end
	end
end)
