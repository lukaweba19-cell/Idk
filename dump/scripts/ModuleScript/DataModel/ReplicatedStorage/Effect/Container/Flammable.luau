-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local CurrentCamera: Camera = workspace.CurrentCamera
local workspaceBin = workspace.Bin
local sound = require(game.ReplicatedStorage.Sound)

require(game.ReplicatedStorage.Util.ScaleParticle)

local misc = require(game.ReplicatedStorage.Util.Misc)

require(game.ReplicatedStorage.Util.Debris)

local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local viewedPlayer = require(game.ReplicatedStorage.Shared.ViewedPlayer)

local function viewerSide()
	local viewedPlayerOverrideCharacter = viewedPlayer.OverrideCharacter

	if viewedPlayerOverrideCharacter and viewedPlayerOverrideCharacter.Parent then
		local matchSide = viewedPlayerOverrideCharacter:GetAttribute("MatchSide")

		if typeof(matchSide) == "string" and matchSide ~= "" then
			return matchSide
		end
	end

	local viewedPlayerPlayer = viewedPlayer.Player
	local v19 = viewedPlayerPlayer and viewedPlayerPlayer:GetAttribute("MatchSide")

	if typeof(v19) == "string" and v19 ~= "" then
		return v19
	end

	local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")

	if typeof(lobbySpectateTeam) == "string" and lobbySpectateTeam ~= "" then
		return lobbySpectateTeam
	end

	return nil
end
local function fireSide(p4)
	local senderUserId = p4.SenderUserId

	if typeof(senderUserId) ~= "number" then
		return nil
	end

	if senderUserId == LocalPlayer.UserId and not viewedPlayer.IsSpectating() then
		return "friendly"
	end

	if not viewedPlayer.OverrideCharacter and viewedPlayer.Player and senderUserId == viewedPlayer.Player.UserId then
		return "friendly"
	end

	local senderSide = p4.SenderSide
	local v24 = viewerSide()

	if typeof(senderSide) ~= "string" or senderSide == "" or not v24 then
		if senderUserId == LocalPlayer.UserId then
			return "friendly"
		end
	elseif senderSide == v24 then
		return "friendly"
	end

	return "enemy"
end
local function recolor(p5, p6)
	local v27, v28, v29 = p5:ToHSV()

	if v28 < 0.15 then
		return p5
	end

	local n1 = if v27 > 0.5 then v27 - 1 else v27

	return Color3.fromHSV((if p6 == "friendly" then 0.33 - n1 * 0.8 else n1 * 0.35) % 1, v28, v29)
end
local function recolorSeq(p7, p8)
	local v33 = table.create(#p7.Keypoints)

	for iterFirst, iterSecond in p7.Keypoints, nil, nil do
		v33[iterFirst] = ColorSequenceKeypoint.new(iterSecond.Time, recolor(iterSecond.Value, p8))
	end

	return ColorSequence.new(v33)
end

return function(p9)
	local _
	local cFrame = p9.CFrame
	local t1 = p9.FlameParts
	local duration = p9.Duration
	local isLocal = p9.IsLocal
	local v42 = cFrame.Position

	if (CurrentCamera.CFrame.p - v42).magnitude > 1000 then
		return
	end

	if not t1 or #t1 == 0 then
		t1 = {}
		local tiles = p9.Tiles

		if typeof(tiles) == "table" then
			local v44 = typeof(p9.TileSize) == "Vector3" and p9.TileSize or Vector3.new(8, 2, 8)

			for iterFirst, iterSecond in tiles do
				if typeof(iterSecond) == "CFrame" then
					local flameTileFX: Part = Instance.new("Part")

					flameTileFX.Name = "FlameTileFX"
					flameTileFX.Size = v44
					flameTileFX.CFrame = iterSecond + v42
					flameTileFX.Anchored = true
					flameTileFX.CanCollide = false
					flameTileFX.CanQuery = false
					flameTileFX.CanTouch = false
					flameTileFX.Transparency = 1
					flameTileFX:SetAttribute("FromAbilityCast", true)
					flameTileFX.Parent = workspaceBin
					_ = flameTileFX
					table.insert(t1, _)
				end
			end
		end
	end

	v42 = fireSide(p9)

	local firePart = game.ReplicatedStorage.FX.AbilityFX.Flammable.FirePart
	local t2: {[any]: any} = {}

	if v42 then
		for iterFirst2, iterSecond2 in firePart:GetChildren() do
			if iterSecond2:IsA("ParticleEmitter") then
				t2[iterSecond2] = recolorSeq(iterSecond2.Color, v42)
			end
		end
	end

	for key, value in t1 do
		value.Transparency = 1

		for _, v in pairs(firePart:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				local clone = v:Clone()

				clone.Name = "FLAMES"

				if t2[v] then
					clone.Color = t2[v]
				end

				clone.Parent = value
			end
		end
	end

	local clone = game.ReplicatedStorage.FX.AbilityFX.Flammable.Explode:Clone()

	if v42 then
		for iterFirst3, iterSecond3 in clone:GetDescendants() do
			if iterSecond3:IsA("ParticleEmitter") then
				iterSecond3.Color = recolorSeq(iterSecond3.Color, v42)
			elseif iterSecond3:IsA("Light") then
				local v59 = iterSecond3.Color
				local v60, _, v61 = v59:ToHSV()
				local color3

				if _ < 0.15 then
					color3 = v59
				else
					local n1 = if v60 > 0.5 then v60 - 1 else v60

					color3 = Color3.fromHSV((if v42 == "friendly" then 0.33 - n1 * 0.8 else n1 * 0.35) % 1, _, v61)
				end

				iterSecond3.Color = color3

				if v42 == "friendly" then
					iterSecond3.Brightness = iterSecond3.Brightness * 0.25

					if iterSecond3:IsA("PointLight") or iterSecond3:IsA("SpotLight") then
						iterSecond3.Range = iterSecond3.Range * 0.7
					end
				end
			end
		end
	end

	clone:SetAttribute("FromAbilityCast", true)
	clone.Parent = workspace.Bin
	clone.CFrame = cFrame
	misc.EmitAll(clone)
	sound:Play("Abilities.FlammableExplode", clone)

	local v64 = sound:Play("Abilities.FlammableLoop", clone)
	local pointLight = clone.Light.PointLight
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0, Range = 10 }):Play()
	task.wait(duration - 0.6)

	for key2, value2 in t1 do
		for iterFirst4, iterSecond4 in value2:GetChildren() do
			if iterSecond4:IsA("ParticleEmitter") then
				iterSecond4.Enabled = false
			end
		end
	end

	pcall(function()
		v64:FadeOut(0.5)
	end)
	task.delay(1.5, function()
		clone:Destroy()

		for key, value in t1 do
			pcall(function()
				value:Destroy()
			end)
		end

		t1 = nil
	end)
end
