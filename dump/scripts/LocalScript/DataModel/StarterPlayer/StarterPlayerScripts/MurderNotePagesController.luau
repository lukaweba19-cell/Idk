-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local notePages = require(shared:WaitForChild("NotePages"))
local notePagesRenderer = require(shared:WaitForChild("NotePagesRenderer"))
local LocalPlayer: Player = players.LocalPlayer
local murderNoteSync: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("MurderNoteSync")
local murderNoteShot: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("MurderNoteShot")
local t1 = {}

local function myRig()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return nil
	end

	local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

	return revolverRig and revolverRig:IsA("Model") and revolverRig or nil
end
local function paintOwn()
	local Character: Model = LocalPlayer.Character
	local v21

	if not Character then
		v21 = nil
	else
		local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

		v21 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
	end

	if not v21 or not notePagesRenderer.IsNote(v21) then
		return
	end

	notePagesRenderer.SetLogNames(v21, t1)
end

murderNoteSync.OnClientEvent:Connect(function(p1)
	if typeof(p1) == "table" then
		if typeof(p1.names) == "table" then
			t1 = p1.names

			local Character: Model = LocalPlayer.Character
			local v25

			if not Character then
				v25 = nil
			else
				local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

				v25 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
			end

			if v25 and notePagesRenderer.IsNote(v25) then
				notePagesRenderer.SetLogNames(v25, t1)
			end
		end

		local write = p1.write

		if typeof(write) == "table" then
			local Character: Model = LocalPlayer.Character
			local v29

			if not Character then
				v29 = nil
			else
				local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

				v29 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
			end

			if v29 then
				local notePagesRightPageText = notePages.RightPageText
				local text: string = tostring(write.outcome)
				local v33 = notePagesRightPageText(text, write.name, write.seed)
				local taskDelay = task.delay
				local v35 = notePages.WriteDelay(nil)

				taskDelay(v35, function()
					local notePagesRendererWriteRight = notePagesRenderer.WriteRight
					local Character2: Model = LocalPlayer.Character
					local v51

					if not Character2 then
						v51 = nil
					else
						local revolverRig: Instance = Character2:FindFirstChild("RevolverRig")

						v51 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
					end

					notePagesRendererWriteRight(v51, v33)
				end)
			end
		end

		return
	end
end)
murderNoteShot.Event:Connect(function(p2)
	if typeof(p2) ~= "string" then
	elseif p2 == "hit" or p2 == "miss" then
		local v37 = notePages.RightPageText(p2)
		local taskDelay = task.delay
		local v39 = notePages.WriteDelay(nil)

		taskDelay(v39, function()
			local notePagesRendererWriteRight = notePagesRenderer.WriteRight
			local Character: Model = LocalPlayer.Character
			local v55

			if not Character then
				v55 = nil
			else
				local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

				v55 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
			end

			notePagesRendererWriteRight(v55, v37)
		end)

		return
	end
end)

local t2: {[any]: any} = {}

local function considerRig(p3)
	if not p3:IsA("Model") or p3.Name ~= "RevolverRig" then
		return
	end

	if t2[p3] then
		return
	end

	if not notePagesRenderer.IsNote(p3) then
		return
	end

	t2[p3] = true

	if p3.Parent == LocalPlayer.Character then
		notePagesRenderer.SetLogNames(p3, t1)
		notePagesRenderer.WriteRight(p3, "")

		return
	end

	notePagesRenderer.Blank(p3)
end
local function watchCharacter(p4)
	if not p4:IsA("Model") then
		return
	end

	for _, v in ipairs(p4:GetChildren()) do
		considerRig(v)
	end

	p4.ChildAdded:Connect(considerRig)
end

local characters: Instance = workspace:WaitForChild("Characters")

for _, v in ipairs(characters:GetChildren()) do
	watchCharacter(v)
end

characters.ChildAdded:Connect(watchCharacter)
LocalPlayer.CharacterAdded:Connect(function(character: Model)
	watchCharacter(character)
	task.defer(paintOwn)
end)

if LocalPlayer.Character then
	watchCharacter(LocalPlayer.Character)
end

LocalPlayer:GetAttributeChangedSignal("RevolverSkin"):Connect(function()
	task.defer(paintOwn)
end)
_G.MurderNotePages = {
	PaintPreview = function(p6)
		if not p6 or not notePagesRenderer.IsNote(p6) then
			return
		end

		notePagesRenderer.SetLogNames(p6, t1)
		notePagesRenderer.WriteRight(p6, "")
	end,
	Repaint = function()
		local Character: Model = LocalPlayer.Character
		local v47

		if not Character then
			v47 = nil
		else
			local revolverRig: Instance = Character:FindFirstChild("RevolverRig")

			v47 = revolverRig and revolverRig:IsA("Model") and revolverRig or nil
		end

		if v47 then
			if not notePagesRenderer.IsNote(v47) then
				return
			end

			notePagesRenderer.SetLogNames(v47, t1)

			return
		end
	end
}
