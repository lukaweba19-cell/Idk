-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local collectionService: CollectionService = game:GetService("CollectionService")
local v3 = require("../mod/attributes")
local v4 = require("../mod/tween")

require("../types")

local v5 = require("../mod/utility")
local v6 = require("../pkg/Promise")
local random = Random.new()
local u8 = nil

local function selectRandomSound(p1)
	local v13 = v3.get(p1, "SoundPoolTag", "")

	if v13 == "" then
		return p1
	end

	local t1: {[any]: any} = {}
	local t2: {[any]: any} = {}
	local n1 = 0

	for iterFirst, iterSecond in collectionService:GetTagged(v13), nil, nil do
		if iterSecond:IsA("Sound") then
			table.insert(t2, iterSecond)

			local v19 = v3.get(iterSecond, "SoundPoolWeight", 1)

			table.insert(t1, v19)
			n1 += v19
		end
	end

	if #t2 == 0 then
		return p1
	end

	local v21

	if n1 > 0 then
		local v22 = random:NextNumber()
		local n2 = 0

		for key, value in t1 do
			n2 += value

			if v22 * n1 <= n2 then
				return t2[key]
			end
		end

		v21 = random:NextInteger(1, #t2)

		return t2[v21]
	end

	v21 = random:NextInteger(1, #t2)

	return t2[v21]
end
local function createSoundClone(p2, p3, p4)
	local clone = p3:Clone()

	for iterFirst, iterSecond in clone:GetTags() do
		clone:RemoveTag(iterSecond)
	end

	local parent = p2:FindFirstAncestorWhichIsA("BasePart")
	local part = nil

	if not v5.PLUGIN_CONTEXT then
		if parent then
			clone.Parent = parent
		else
			clone.Parent = workspace.Terrain
		end

		table.insert(p4, clone)
	elseif parent then
		part = Instance.new("Part")
		part.Name = "SoundEmitter"
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, 1)
		part.CFrame = parent.CFrame
		part.Parent = u8
		clone.Parent = part
		table.insert(p4, part)
	else
		clone.Parent = u8
		table.insert(p4, clone)
	end

	return clone, part
end
local function playSingleSound(p5, p6, p7, p8, p9, p10)
	local u39 = p7.PlaybackSpeed
	local v40 = v3.get(p6, "Volume_End", p7.Volume)
	local volume = v3.get(p6, "Volume_Start", p7.Volume)

	p7.Volume = volume

	if volume ~= v40 then
		local v42 = v3.get(p6, "Volume_Duration", p7.TimeLength)
		local fromParams = v4.fromParams
		local v44 = v3.get(p6, "Volume_Curve", v5.default_bezier)

		table.insert(p9, fromParams(v44, v42, function(p11, p12)
			p7.Volume = v5.lerp(volume, v40, p11)

			return p12 * u39
		end))
	else
		p7.Volume = volume
	end

	local v45 = v3.get(p6, "Speed_End", p7.PlaybackSpeed)
	local playbackSpeed = v3.get(p6, "Speed_Start", p7.PlaybackSpeed)

	u39 = playbackSpeed

	local u47 = nil

	if playbackSpeed ~= v45 then
		local v48 = v3.get(p6, "Speed_Duration", p7.TimeLength)
		local v49 = v4.fromParams
		local v50 = v3.get(p6, "Speed_Curve", v5.default_bezier)

		u47 = v49(v50, v48, function(p13, p14)
			u39 = v5.lerp(playbackSpeed, v45, p13)
			p7.PlaybackSpeed = u39

			return p14
		end)
		table.insert(p9, u47)
	else
		p7.PlaybackSpeed = playbackSpeed
	end

	local v51 = v3.get(p6, "RollOff_End", p7.RollOffMinDistance)
	local v52 = v3.get(p6, "RollOff_Start", p7.RollOffMinDistance)

	if v52 ~= v51 then
		local v53 = v3.get(p6, "RollOff_Duration", p7.TimeLength)
		local v54 = v4.fromParams
		local v55 = v3.get(p6, "RollOff_Curve", v5.default_bezier)

		table.insert(p9, v54(v55, v53, function(p15, p16)
			p7.RollOffMinDistance = v5.lerp(v52, v51, p15)

			return p16 * u39
		end, u47))
	end

	if p7.PlayOnRemove and not v5.PLUGIN_CONTEXT then
		p7:Destroy()
	else
		p7:Play()
	end

	local v56 = p8 and p5:FindFirstAncestorWhichIsA("BasePart")

	if v56 then
		table.insert(p9, runService.Heartbeat:Connect(function()
			if p8.Parent then
				p8.CFrame = v56.CFrame
			end
		end))
	end

	if p10 > 0 then
		task.wait(p10)
		p7:Stop()
	else
		v4.timer(p7.TimeLength, function(p17, p18)
			if p7.PlaybackSpeed > 0 or p18 > 0 and u47 and u47.Connected then
				return p17 * p7.PlaybackSpeed
			end

			return nil
		end, u47, p9)
	end

	return u47
end

return {
	init = function()
		if not v5.PLUGIN_CONTEXT then
			return
		end

		local v57: Instance = script:FindFirstAncestorOfClass("Plugin")

		if not v57 then
			return
		end

		u8 = v57:CreateDockWidgetPluginGui("VFXForgeSoundPlayer", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 200, 100, 100, 50))

		if u8 then
			u8.Name = "VFXForgeSoundPlayer"
		end
	end,
	deinit = function()
		if u8 then
			u8:Destroy()
			u8 = nil
		end
	end,
	emit = function(p19, p20)
		if p19.Playing then
			p19:Stop()
		end

		local v60 = v3.get(p19, "SoundPoolIsSource", false)
		local v61 = v3.get(p19, "SoundPoolInheritAttributes", false)

		if v61 then
			p19 = not v60 and selectRandomSound(p19) or p19
		end

		local v62 = v3.get(p19, "EmitDelay", 0)
		local v63 = v3.get(p19, "EmitDuration", 0)
		local v64 = v3.get(p19, "EmitCount", 1)
		local v65 = v3.getRange(p19, "EmitInterval", NumberRange.new(0, 0))
		local v66 = v3.get(p19, "RepeatCount", 1)
		local v67 = v3.getRange(p19, "RepeatInterval", NumberRange.new(0, 0))

		task.wait(v62)
		v62 = {}

		for i = 1, v64 do
			local v69 = v61 and p19 or not v60 and selectRandomSound(p19) or p19

			if v69 then
				local v70 = if v61 and v69 ~= p19 then v69 else p19

				for j = 1, v66 do
					table.insert(v62, v6.new(function(p21)
						local v81, v82 = createSoundClone(p19, v69, p20)

						playSingleSound(p19, v70, v81, v82, p20, v63)

						if v82 then
							v82:Destroy()
						else
							v81:Destroy()
						end

						p21()
					end))

					if v66 > j and v67.Max > 0 then
						task.wait(random:NextNumber(v67.Min, v67.Max))
					end
				end

				if not (v64 > i) or not (v65.Max > 0) then
					continue
				end

				task.wait(random:NextNumber(v65.Min, v65.Max))
			end
		end

		v6.all(v62):await()
	end
}
