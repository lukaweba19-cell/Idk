-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local soundService: SoundService = game:GetService("SoundService")
local emoteProps: Instance = replicatedStorage:WaitForChild("EmoteProps")
local cFrame = CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)

local function playFxSound(p3, parent)
	if parent and typeof(p3.Sound) == "number" then
		local emoteFxSound: Sound = Instance.new("Sound")

		emoteFxSound.Name = "EmoteFxSound"
		emoteFxSound.SoundId = "rbxassetid://" .. p3.Sound

		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local numberValue: number? = tonumber(p3.SoundVolume)
		local typeName: string = typeof(sfxVolume)

		emoteFxSound.Volume = (numberValue or 0.5) * (if typeName == "number" then sfxVolume else 1)
		emoteFxSound.Parent = parent
		emoteFxSound.Ended:Once(function()
			emoteFxSound:Destroy()
		end)
		emoteFxSound:Play()
		task.delay(15, function()
			if emoteFxSound.Parent then
				emoteFxSound:Destroy()
			end
		end)

		return
	end
end

local color3 = Color3.fromRGB(96, 196, 72)
local t1: {[any]: any} = {
	"Torso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
	"UpperTorso",
	"LowerTorso",
	"LeftUpperArm",
	"LeftLowerArm",
	"LeftHand",
	"RightUpperArm",
	"RightLowerArm",
	"RightHand",
	"LeftUpperLeg",
	"LeftLowerLeg",
	"LeftFoot",
	"RightUpperLeg",
	"RightLowerLeg",
	"RightFoot"
}
local object = setmetatable({}, { __mode = "k" })

local module: {[any]: any} = {
	Attach = function(parent, p2)
		local foundChild: Instance = emoteProps:FindFirstChild(p2)

		if not foundChild then
			return nil
		end

		local part0 = parent:FindFirstChild("Right Arm") or parent:FindFirstChild("RightHand")

		if not part0 or not part0:IsA("BasePart") then
			return nil
		end

		local clone: Instance = foundChild:Clone()
		local v23 = nil

		if clone:IsA("BasePart") then
			v23 = clone
		elseif clone:IsA("Model") then
			v23 = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
		end

		if not v23 then
			clone:Destroy()

			return nil
		end

		local gripC0: Instance = foundChild:FindFirstChild("GripC0")
		local c0 = if gripC0 and gripC0:IsA("CFrameValue") then gripC0.Value else cFrame

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = false
				v.CanCollide = false
				v.CanQuery = false
				v.CanTouch = false
				v.Massless = true
			end
		end

		if clone:IsA("BasePart") then
			clone.Anchored = false
			clone.CanCollide = false
			clone.CanQuery = false
			clone.CanTouch = false
			clone.Massless = true
		end

		local cFrame2 = part0.CFrame * c0

		if clone:IsA("Model") then
			local v29 = v23.CFrame:Inverse()
			local pivot = clone:GetPivot()

			clone:PivotTo(cFrame2 * (v29 * pivot))
		else
			v23.CFrame = cFrame2
		end

		local emotePropGrip: Weld = Instance.new("Weld")

		emotePropGrip.Name = "EmotePropGrip"
		emotePropGrip.Part0 = part0
		emotePropGrip.Part1 = v23
		emotePropGrip.C0 = c0
		emotePropGrip.C1 = CFrame.new()
		emotePropGrip.Parent = v23
		clone.Name = "EmoteProp_" .. p2
		clone.Parent = parent

		return clone
	end,
	HasCue = function(p10)
		local u33: boolean = false

		if p10 ~= nil then
			u33 = true

			if typeof(p10.Prop) ~= "table" then
				u33 = typeof(p10.Fx) == "table"
			end
		end

		return u33
	end
}

local t3: {[any]: any} = {
	BrewHead = function(parent, p6, p7)
		local head = parent:FindFirstChild("Head")

		if not head or not head:IsA("BasePart") then
			return function()
			end
		end

		local v38 = object[head]

		if v38 then
			v38(true)
		end

		local numberValue = tonumber(p6.Scale) or 1.6
		local v40 = if typeof(p6.Color) == "Color3" then p6.Color else color3
		local headSize = head.Size
		local t4: {[any]: any} = {}

		for _, v in ipairs(t1) do
			local v = parent:FindFirstChild(v)

			if v and v:IsA("BasePart") then
				table.insert(t4, { part = v, orig = v.Color })
			end
		end

		local clone = head:Clone()

		for _, v in ipairs(clone:GetChildren()) do
			if not v:IsA("DataModelMesh") and not v:IsA("Decal") then
				v:Destroy()
			end
		end

		local specialMesh = clone:FindFirstChildOfClass("SpecialMesh")

		if specialMesh then
			specialMesh.TextureId = ""
		end

		if clone:IsA("MeshPart") then
			pcall(function()
				clone.TextureID = ""
			end)
		end

		clone.Name = "EmoteBrewHead"
		clone.Anchored = false
		clone.CanCollide = false
		clone.CanQuery = false
		clone.CanTouch = false
		clone.Massless = true
		clone.CFrame = head.CFrame

		local cloneColor = clone.Color
		local specialMesh2 = clone:FindFirstChildOfClass("SpecialMesh")
		local u52: boolean = specialMesh2 ~= nil and specialMesh2.MeshType == Enum.MeshType.FileMesh
		local v53 = if specialMesh2 then specialMesh2.Scale else Vector3.new(1, 1, 1)
		local emoteBrewHeadWeld: Weld = Instance.new("Weld")

		emoteBrewHeadWeld.Name = "EmoteBrewHeadWeld"
		emoteBrewHeadWeld.Part0 = head
		emoteBrewHeadWeld.Part1 = clone
		emoteBrewHeadWeld.Parent = clone
		clone.Parent = parent

		local t5: {[any]: any} = { { inst = head, orig = head.Transparency } }

		for _, v in ipairs(head:GetChildren()) do
			if v:IsA("Decal") then
				table.insert(t5, { inst = v, orig = v.Transparency })
			end
		end

		for _, v in ipairs(t5) do
			v.inst.Transparency = 1
		end

		local function restore()
			clone:Destroy()

			for _, v in ipairs(t5) do
				if v.inst.Parent then
					v.inst.Transparency = v.orig
				end
			end

			for _, v in ipairs(t4) do
				if v.part.Parent then
					v.part.Color = v.orig
				end
			end
		end

		local numberValue2: NumberValue = Instance.new("NumberValue")

		numberValue2.Changed:Connect(function(p8: number)
			if not clone.Parent then
				return
			end

			local n1 = 1 + (numberValue - 1) * p8

			clone.Size = headSize * n1

			if u52 and specialMesh2 then
				specialMesh2.Scale = v53 * n1
			end

			emoteBrewHeadWeld.C0 = CFrame.new(0, (n1 - 1) * headSize.Y / 2, 0)
			n1 = math.clamp(p8, 0, 1)
			clone.Color = cloneColor:Lerp(v40, n1)

			for _, v in ipairs(t4) do
				if v.part.Parent then
					v.part.Color = v.orig:Lerp(v40, n1)
				end
			end
		end)

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local v63: Tween = tweenService:Create(numberValue2, tweenInfo, { Value = 1 })

		v63:Play()
		playFxSound(p6, p7)

		local u64: boolean = false

		local function revert(p9)
			if u64 then
				return
			end

			u64 = true

			if object[head] == revert then
				object[head] = nil
			end

			v63:Cancel()

			if not not p9 or not head.Parent or not clone.Parent then
				numberValue2:Destroy()
				restore()

				return
			end

			local tweenInfo2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local v91: Tween = tweenService:Create(numberValue2, tweenInfo2, { Value = 0 })

			v91.Completed:Once(function()
				numberValue2:Destroy()
				restore()
			end)
			v91:Play()
		end

		object[head] = revert

		return revert
	end
}

function module.Cue(p11, p12, p13, p14)
	local t6: {[any]: any} = { prop = nil, revert = nil }
	local u71: boolean = false

	local function clearProp()
		if t6.prop then
			t6.prop:Destroy()
			t6.prop = nil
		end
	end

	local v73 = if p12 and typeof(p12.AnimSpeed) == "number" and p12.AnimSpeed > 0 then p12.AnimSpeed else 1
	local prop = p12 and p12.Prop

	if typeof(prop) == "table" and typeof(prop.Name) == "string" then
		local n1 = (tonumber(prop.AttachAt) or 0) / v73
		local n2

		if tonumber(prop.DetachAt) then
			n2 = tonumber(prop.DetachAt) / v73
		else
			n2 = nil
		end

		task.delay(n1, function()
			if not not u71 or not p13() or not p11.Parent then
				return
			end

			if t6.prop then
				t6.prop:Destroy()
				t6.prop = nil
			end

			t6.prop = module.Attach(p11, prop.Name)

			if n2 then
				local taskDelay = task.delay
				local v93 = math.max(0, n2 - n1)

				taskDelay(v93, function()
					if u71 then
					elseif t6.prop then
						t6.prop:Destroy()
						t6.prop = nil
					end
				end)
			end
		end)
	end

	local fx = p12 and p12.Fx
	local v78 = if typeof(fx) == "table" and typeof(fx.Name) == "string" then t3[fx.Name] else nil

	if v78 then
		local taskDelay = task.delay
		local numberValue: number? = tonumber(fx.At)

		taskDelay((numberValue or 0) / v73, function()
			if not not u71 or not p13() or not p11.Parent then
				return
			end

			if t6.revert then
				t6.revert(true)
			end

			local v94 = p14

			if not v94 and p11:IsDescendantOf(workspace) then
				v94 = p11:FindFirstChild("Head") or p11:FindFirstChild("HumanoidRootPart") or p11
			end

			t6.revert = v78(p11, fx, v94)
		end)
	end

	return function()
		u71 = true

		if t6.prop then
			t6.prop:Destroy()
			t6.prop = nil
		end

		if t6.revert then
			t6.revert()
			t6.revert = nil
		end
	end
end

return module
