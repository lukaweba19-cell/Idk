-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1: boolean = game:GetService("RunService"):IsServer()
local v2: boolean = game:GetService("RunService"):IsClient()

workspace:WaitForChild("Bin"):WaitForChild("Sounds")

local shared = game.ReplicatedStorage:WaitForChild("Shared")
local playerState = require(shared:WaitForChild("PlayerState"))
local util = game.ReplicatedStorage:WaitForChild("Util")
local debris = require(util:WaitForChild("Debris"))
local tweenService: TweenService = game:GetService("TweenService")

local function getLocation(p1)
	local foundChild = nil

	for iterValue in string.gmatch(p1, "([^.]+)") do
		foundChild = (foundChild or script):FindFirstChild(iterValue)
	end

	return foundChild
end

local t1: {[any]: any} = {}

t1.__index = t1

local u10 = nil

local function replayCapture(p2, p3, p4)
	if not v1 then
		return
	end

	pcall(function()
		if u10 == nil then
			local replayRecorder: Instance = game:GetService("ServerStorage"):FindFirstChild("ReplayRecorder")

			u10 = replayRecorder and require(replayRecorder) or false
		end

		if u10 then
			u10.CaptureBroadcast(p2, p3, p4)
		end
	end)
end

local u12 = nil

local function replayScale(p5)
	if not playerState.ReplayActive then
		return
	end

	pcall(function()
		if u12 == nil then
			local shared: Instance = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
			local replayTimeScale: Instance = shared and shared:FindFirstChild("ReplayTimeScale")

			u12 = replayTimeScale and require(replayTimeScale) or false
		end

		if u12 then
			u12.Track(p5)
		end
	end)
end
function t1.__ReplayInvoke(p6, ...)
	local v22 = ...

	if typeof(v22) == "Instance" then
		local object = setmetatable({ Instance = v22 }, { __index = t1 })

		object[p6](object, select(2, ...))

		return
	end

	local object = setmetatable({ Instance = nil }, { __index = t1 })

	object[p6](object, ...)
end
function t1.Find(_, p8)
	return (getLocation(p8))
end
function t1.Play(_, p10, p11, p12: number, p13, volume, p15)
	if v1 then
		local v34 = p11
		local t2: {[any]: any} = {
			"Play",
			p10,
			p11,
			p12,
			p13,
			volume,
			p15
		}

		if v1 then
			local s1: string = "Sound"

			pcall(function()
				if u10 == nil then
					local replayRecorder: Instance = game:GetService("ServerStorage"):FindFirstChild("ReplayRecorder")

					u10 = replayRecorder and require(replayRecorder) or false
				end

				if u10 then
					u10.CaptureBroadcast(s1, v34, t2)
				end
			end)
		end

		game.ReplicatedStorage.Remotes.Sound:FireAllClients("Play", p10, p11, p12, p13, volume, p15)

		return
	end

	local v37 = getLocation(p10)

	if v37 then
		if v37:IsA("Folder") then
			local children = v37:GetChildren()
			local mathRandom = math.random
			local v40 = v37:GetChildren()
			local v41 = mathRandom(1, #v40)

			v37 = children[v41]
		end

		if p11 then
			if typeof(p11) == "CFrame" then
				p11 = p11.p
			end

			if typeof(p11) == "Vector3" then
				local v42 = p11

				p11 = Instance.new("Attachment")
				p11.Name = "3DSound_" .. p10
				p11.Position = v42
				p11.Parent = workspace.Terrain
				p11.ChildRemoved:Connect(function()
					p11:Destroy()
				end)
			end
		end

		local clone = v37:Clone()
		local playbackSpeed = p13 or v37.PlaybackSpeed

		if p15 then
			local randomNumber = math.random()

			clone.PlaybackSpeed = playbackSpeed + (randomNumber * 2 - 1) * p15
		else
			clone.PlaybackSpeed = playbackSpeed
		end

		if volume then
			clone.Volume = volume
		end

		local sfxVolume: any = game:GetService("SoundService"):GetAttribute("SFXVolume")

		if typeof(sfxVolume) == "number" then
			clone.Volume = clone.Volume * sfxVolume
		end

		if v37.Name == "Throw" or v37.Name == "Swing" then
			p12 = 75
		end

		if p12 then
			clone.RollOffMinDistance = p12 * 0.1
			clone.RollOffMaxDistance = p12
		end

		clone.RollOffMode = "LinearSquare"
		clone.Parent = p11 or sounds

		local object = setmetatable({ Instance = clone }, { __index = t1 })

		if not clone.Looped then
			clone.Ended:Connect(function()
				object:Destroy()
			end)
		end

		if playerState.ReplayActive then
			pcall(function()
				if u12 == nil then
					local shared: Instance = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
					local replayTimeScale: Instance = shared and shared:FindFirstChild("ReplayTimeScale")

					u12 = replayTimeScale and require(replayTimeScale) or false
				end

				if u12 then
					u12.Track(clone)
				end
			end)
		end

		clone:Play()

		return object, clone
	end

	return (setmetatable({ Destroyed = true }, { __index = t1 }))
end
function t1.PlayToClient(_, p17, ...)
	if v1 then
		game.ReplicatedStorage.Remotes.Sound:FireClient(p17, "Play", ...)
	end
end
function t1.Destroy(p18)
	if typeof(p18) == "Instance" then
		p18 = setmetatable({ Instance = p18 }, { __index = t1 })
	end

	if p18.Destroyed then
		return
	end

	p18.Destroyed = true

	local instance = p18.Instance

	instance:Stop()

	if instance.Parent and instance:IsDescendantOf(sounds) and instance.Parent:IsA("Attachment") then
		instance.Parent:Destroy()

		return
	end

	pcall(function()
		instance:Destroy()
	end)
end
function t1.FadeOut(p19, p20)
	if typeof(p19) == "Instance" then
		p19 = setmetatable({ Instance = p19 }, { __index = t1 })
	end

	if p19.Destroyed then
		return
	end

	local instance = p19.Instance

	if not instance.Parent then
	elseif v2 then
		local tweenInfo = TweenInfo.new(p20, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local v56: Tween = tweenService:Create(instance, tweenInfo, { Volume = 0 })

		v56.Completed:connect(function()
			p19.Destroy(instance)
		end)
		v56:Play()
	elseif v1 then
		local t3: {[any]: any} = { "FadeOut", instance, p20 }

		if v1 then
			local s1: string = "Sound"

			pcall(function()
				if u10 == nil then
					local replayRecorder: Instance = game:GetService("ServerStorage"):FindFirstChild("ReplayRecorder")

					u10 = replayRecorder and require(replayRecorder) or false
				end

				if u10 then
					u10.CaptureBroadcast(s1, instance, t3)
				end
			end)
		end

		game.ReplicatedStorage.Remotes.Sound:FireAllClients("FadeOut", instance, p20)
		debris:AddItem(function()
			p19.Destroy(instance)
		end, p20)
	end
end

if v2 then
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sound").OnClientEvent:connect(function(p21, ...)
		if p21 == "Play" and playerState.InLobby() then
			return
		end

		local v60 = ...

		if typeof(v60) == "Instance" then
			local object = setmetatable({ Instance = v60 }, { __index = t1 })

			object[p21](object, select(2, ...))

			return
		end

		local object = setmetatable({ Instance = nil }, { __index = t1 })

		object[p21](object, ...)
	end)

	return t1
end

if v1 then
	return (setmetatable({}, {
		__index = function(_, p23)
			return t1[p23]
		end
	}))
end
