-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(replicatedStorage.Util.Debris)

local waitForExpectedDescendants = require(replicatedStorage.Util.WaitForExpectedDescendants)
local t1: {[any]: any} = {}
local v5: boolean = runService:IsServer()
local v6: boolean = runService:IsRunning()

function createModel()
	local persistentParts: Model = Instance.new("Model")

	persistentParts.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
	persistentParts.Name = "PersistentParts"
	persistentParts.Parent = workspace.Bin
	persistentParts.AncestryChanged:Once(function()
		if not persistentParts.Parent then
			createModel()
		end
	end)

	local __PersistentRoot: Part = Instance.new("Part")

	__PersistentRoot.Name = "__PersistentRoot"
	__PersistentRoot.Size = Vector3.new(0.1, 0.1, 0.1)
	__PersistentRoot.Anchored = true
	__PersistentRoot.CanCollide = false
	__PersistentRoot.CanQuery = false
	__PersistentRoot.Transparency = 1
	__PersistentRoot.Position = Vector3.new(0, 10000, 0)
	__PersistentRoot.Parent = persistentParts
end

if v5 and v6 then
	createModel()
end

if v5 and v6 then
	Instance.new("Folder", replicatedStorage).Name = "StreamedQueue"
	task.spawn(function()
		while true do
			if not task.wait(1) then
				break
			end

			for k, v in pairs(t1) do
				pcall(function()
					local v58 = v[2]
					local typeName: string = typeof(v58)
					local v60 = ("bad type: %*"):format((typeof(v58)))

					assert(typeName == "number", v60)

					local v61 = os.clock()

					if v58 < v61 then
						t1[k] = nil

						local v62 = v[1]

						if typeof(v62) == "Instance" and v62.Parent then
							v62:Destroy()
						end

						v62 = v[3]

						if typeof(v62) == "RBXScriptConnection" then
							v62:Disconnect()
						end
					end
				end)
			end
		end
	end)
elseif v6 then
	task.spawn(function()
		local streamedQueue: Instance = replicatedStorage:WaitForChild("StreamedQueue")

		local function FixObj(p1)
			p1:GetAttributeChangedSignal("Destroyed"):Connect(function()
				if p1:GetAttribute("Destroyed") then
					if p1:IsA("ObjectValue") and p1.Value then
						p1.Value:Destroy()
						p1.Value = nil
					end

					task.delay(10, function()
						p1:Destroy()
					end)
				end
			end)
			p1.AncestryChanged:Connect(function(_, p3)
				if not p3 then
					task.delay(10, function()
						p1:Destroy()
					end)
				end
			end)
		end

		for _, v in pairs(streamedQueue:GetChildren()) do
			FixObj(v)
		end

		streamedQueue.ChildAdded:Connect(FixObj)
	end)
end

function DecodeObj(list, p5)
	if list[5] then
		waitForExpectedDescendants(list[5], 5, true)

		return list[5]
	end

	local n1 = os.clock() + (if p5 then 10 else 2)

	tick()

	local childName = list[1]
	local typeName: string = typeof(childName)

	assert(typeName == "string")

	local replicatedStorageStreamedQueue = replicatedStorage.StreamedQueue
	local v24 = os.clock()
	local v25 = replicatedStorageStreamedQueue:WaitForChild(childName, n1 - v24)

	if not v25 then
		return list[5]
	end

	if v25:GetAttribute("Destroyed") then
		return list[5]
	end

	if v25.Value then
		waitForExpectedDescendants(v25.Value, 5, true)

		return v25.Value
	end

	local v26 = coroutine.running()

	tick()

	local connection = v25.Changed:Connect(function(_)
		coroutine.resume(v26)
	end)

	local taskDelay = task.delay
	local v29 = os.clock()
	local v30 = taskDelay(n1 - v29, coroutine.resume, v26)

	coroutine.yield()
	connection:Disconnect()
	pcall(task.cancel, v30)

	if v25.Value and not v25:GetAttribute("Destroyed") then
		waitForExpectedDescendants(v25.Value, 5, true)

		return v25.Value
	end

	return list[5]
end

local t2: {[any]: any} = { Model = true, Folder = true, Part = true, MeshPart = true }
local t3: {[any]: any} = { [workspace.Characters] = true }
local t4: {[any]: any} = {
	HumanoidRootPart = true,
	Head = true,
	LowerTorso = true,
	UpperTorso = true,
	LeftUpperArm = true,
	RightUpperArm = true,
	LeftLowerArm = true,
	RightLowerArm = true,
	LeftLowerLeg = true,
	RightLowerLeg = true,
	LeftUpperLeg = true,
	RightUpperLeg = true,
	LeftHand = true,
	RightHand = true,
	LeftFoot = true,
	RightFoot = true
}

function EncodeObj2(value)
	if t1[value] then
		t1[value][2] = os.clock() + 15

		local v32 = t1[value][1]
		local typeName: string = typeof(v32)

		assert(typeName == "Instance")

		return { v32.Name, 1, "__StreamedObject", false, value }
	end

	if not value:IsDescendantOf(workspace.Game) and not value:IsDescendantOf(workspace.Lobby) then
		local u34 = value:FindFirstChild("Humanoid") ~= nil

		if u34 == false and value.Parent and t4[value.Name] and value.Parent:FindFirstChild("Humanoid") then
			u34 = true
		end

		if u34 == false and t2[value.ClassName] and not t3[value.Parent] then
			local connection2 = nil
			local descendants = value:GetDescendants()
			local n1: number = #descendants

			if n1 >= 1 then
				local t5: {[any]: any} = {}
				local t6: {[any]: any} = {}

				for _, v in pairs(descendants) do
					if v:IsA("TouchTransmitter") then
						n1 -= 1
					else
						if not t5[v.Name] then
							table.insert(t6, v.Name)
						end

						t5[v.Name] = (t5[v.Name] or 0) + 1
					end
				end

				if not (n1 <= 0) then
					local encodedJson: string = game:GetService("HttpService"):JSONEncode(t6)

					value:SetAttribute("ExpectedDescendantsNames", encodedJson)
					value:SetAttribute("ExpectedDescendants", n1)

					local connection = value.DescendantRemoving:Connect(function(p8)
						local v66 = t5[p8.Name]

						if v66 then
							if v66 <= 1 then
								t5[p8.Name] = nil

								local v67 = table.find(t6, p8.Name)

								if v67 then
									table.remove(t6, v67)
								end

								encodedJson = game:GetService("HttpService"):JSONEncode(t6)
								value:SetAttribute("ExpectedDescendantsNames", encodedJson)
							else
								local v68: {[any]: any} = t5
								local v69 = p8.Name

								v68[v69] = v68[v69] - 1
							end
						end

						n1 -= 1
						value:SetAttribute("ExpectedDescendants", nil)
						value:SetAttribute("ExpectedDescendants", n1)
						value:SetAttribute("ExpectedDescendantsNames", nil)
						value:SetAttribute("ExpectedDescendantsNames", encodedJson)
					end)

					connection2 = value.AncestryChanged:Connect(function(_, p10)
						if p10 == nil or not p10:IsDescendantOf(workspace) then
							value:SetAttribute("ExpectedDescendants", nil)
							connection:Disconnect()
							connection2:Disconnect()
						end
					end)
					task.delay(15, function()
						pcall(function()
							connection:Disconnect()
						end)
						pcall(function()
							connection2:Disconnect()
						end)
					end)
				end
			end
		end

		u34 = game:GetService("HttpService"):GenerateGUID(false)

		if value:IsA("BasePart") and value.Parent == workspace.Bin then
			value.Parent = workspace.Bin.PersistentParts
		end

		local objectValue: ObjectValue = Instance.new("ObjectValue")

		objectValue:SetAttribute("Destroyed", false)
		objectValue.Name = u34
		objectValue.Value = value
		objectValue.Parent = replicatedStorage.StreamedQueue

		if value:IsA("Model") and value.ModelStreamingMode == Enum.ModelStreamingMode.Default then
			value.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
		end

		local v45 = value.Destroying:Once(function()
			objectValue:SetAttribute("Destroyed", true)
			task.delay(10, function()
				value:Destroy()
			end)
			t1[value][2] = os.clock() + 10
			t1[value][3] = nil
		end)

		local v46 = os.clock()

		t1[value] = { objectValue, v46 + 15, v45 }
		u34 = t1[value][1]

		local typeName: string = typeof(u34)

		assert(typeName == "Instance")

		return { u34.Name, 1, "__StreamedObject", false, value }
	end

	return value
end

return function(list, p12, _, _)
	if v5 then
		if typeof(list) == "table" then
			local t7: {[any]: any} = {}

			local function recurse(p15)
				local t8 = t7[p15] or {}

				for k, v in pairs(p15) do
					if typeof(v) == "Instance" then
						t8[k] = EncodeObj2(v)
					elseif typeof(v) ~= "table" then
						t8[k] = v
					elseif t7[v] then
						t8[k] = t7[v]
					else
						t7[v] = {}
						t8[k] = recurse(v)
					end
				end

				return t8
			end

			return (recurse(list))
		end

		if typeof(list) == "Instance" then
			return EncodeObj2(list)
		end

		return list
	end

	if typeof(list) ~= "table" then
		return list
	end

	if list[3] == "__StreamedObject" then
		return DecodeObj(list, p12)
	end

	local n1: number = 0
	local n2: number = 0
	local v56 = coroutine.running()

	local function v57(p16)
		for k, v in pairs(p16) do
			if typeof(v) == "table" then
				if v[3] == "__StreamedObject" then
					n1 += 1
					math.random(1, 1000000)
					task.spawn(function()
						local typeName: string = typeof(v)

						assert(typeName == "table")
						p16[k] = DecodeObj(v, p12)
						n2 += 1
						coroutine.resume(v56)
					end)
				else
					v57(v)
				end
			end
		end
	end

	v57(list)

	if n1 == n2 then
		return list
	end

	repeat
		coroutine.yield()
	until n1 == n2

	return list
end
