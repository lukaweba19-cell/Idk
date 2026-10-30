-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")

if workspace:GetAttribute("NewTestRig") == true then
	local shared: Instance = replicatedStorage:WaitForChild("Shared")
	local newRigPreview = require(shared:WaitForChild("NewRigPreview"))
	local revrig: Instance = workspace:FindFirstChild("revrig")

	if not revrig or not revrig:IsA("Model") then
		warn("[NewRigPreview] workspace.revrig not found -- nothing to preview.")

		return
	end

	local animSaves: Instance = revrig:FindFirstChild("AnimSaves")

	if not animSaves then
		warn("[NewRigPreview] revrig has no AnimSaves folder.")

		return
	end

	local LocalPlayer: Player = players.LocalPlayer
	local CurrentCamera: Camera = workspace.CurrentCamera
	local u11: boolean = workspace:GetAttribute("NewRigCameraFX") == true
	local t1: {[any]: any} = {}
	local t2: {[any]: any} = {}

	for _, v in ipairs({ "idle", "equip", "shoot&reload", "inspect" }) do
		local v2: Instance = animSaves:FindFirstChild(v)

		if v2 and v2:IsA("KeyframeSequence") then
			local v17, v18 = newRigPreview.BuildClip(v2, revrig)

			table.insert(t1, v17)
			t2[v] = v18
		end
	end

	if #t1 == 0 then
		warn("[NewRigPreview] no KeyframeSequences found under revrig.AnimSaves.")

		return
	end

	local v19 = newRigPreview.New(revrig)
	local n1 = 1
	local n2 = 0
	local n3 = 1
	local u23: boolean = false
	local CameraType = nil
	local cameraBone: Instance = revrig:FindFirstChild("CameraBone")
	local u26 = nil

	local function hideCameraBone()
		if cameraBone and cameraBone:IsA("BasePart") and u26 == nil then
			u26 = cameraBone.Transparency
			cameraBone.LocalTransparencyModifier = 1
		end
	end
	local function restoreCameraBone()
		if cameraBone and cameraBone:IsA("BasePart") and u26 ~= nil then
			cameraBone.LocalTransparencyModifier = 0
			cameraBone.Transparency = u26
			u26 = nil
		end
	end
	local function describe()
		local v33 = t1[n1]
		local t3 = t2[v33.name] or {}
		local n2: number = 0

		for iterKey in pairs(v33.tracks) do
			n2 += 1
		end

		local stringFormat = string.format
		local name = v33.name
		local length = v33.length
		local v40: number = n3
		local s1: string = if u23 then "ON" else "off"
		local s2 = #t3 > 0 and "  [dead tracks: " .. table.concat(t3, ", ") .. "]" or ""

		print(stringFormat("[NewRigPreview] '%s'  %.2fs  %d tracks  speed=%.2fx  camerabone=%s%s", name, length, n2, v40, s1, s2))
	end
	local function selectClip(p1)
		if not t1[p1] then
			return
		end

		n1 = p1
		n2 = 0
		v19:Load(t1[p1])
		describe()
	end
	local function releaseCamera()
		if CameraType then
			CurrentCamera.CameraType = CameraType
			CameraType = nil
		end

		local Character: Model = LocalPlayer.Character
		local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			CurrentCamera.CameraSubject = humanoid
		end
	end
	local function toggleCameraBone()
		if not u11 then
			print("[NewRigPreview] camera FX are disabled (workspace.NewRigCameraFX is not true).")

			return
		end

		u23 = not u23

		if u23 then
			CameraType = CurrentCamera.CameraType
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
		else
			if CameraType then
				CurrentCamera.CameraType = CameraType
				CameraType = nil
			end

			local Character: Model = LocalPlayer.Character
			local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				CurrentCamera.CameraSubject = humanoid
			end
		end

		describe()
	end

	userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
			local keyCode: Enum.KeyCode = input.KeyCode

			if keyCode ~= Enum.KeyCode.One then
				if keyCode ~= Enum.KeyCode.Two then
					if keyCode ~= Enum.KeyCode.Three then
						if keyCode ~= Enum.KeyCode.Four then
							if keyCode ~= Enum.KeyCode.C then
								if keyCode == Enum.KeyCode.LeftBracket then
									n3 = math.max(0.1, n3 - 0.25)
									describe()
								elseif keyCode == Enum.KeyCode.RightBracket then
									n3 = math.min(4, n3 + 0.25)
									describe()
								elseif keyCode == Enum.KeyCode.Zero then
									if u23 then
										if not u11 then
											print("[NewRigPreview] camera FX are disabled (workspace.NewRigCameraFX is not true).")
										else
											u23 = not u23

											if u23 then
												CameraType = CurrentCamera.CameraType
												CurrentCamera.CameraType = Enum.CameraType.Scriptable
											else
												if CameraType then
													CurrentCamera.CameraType = CameraType
													CameraType = nil
												end

												local Character: Model = LocalPlayer.Character
												local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

												if humanoid then
													CurrentCamera.CameraSubject = humanoid
												end
											end

											describe()
										end
									end

									if cameraBone and cameraBone:IsA("BasePart") and u26 ~= nil then
										cameraBone.LocalTransparencyModifier = 0
										cameraBone.Transparency = u26
										u26 = nil
									end

									v19:Stop()
									print("[NewRigPreview] stopped, joints restored. Press 1-4 to start again.")
								end

								return
							end

							if not u11 then
								print("[NewRigPreview] camera FX are disabled (workspace.NewRigCameraFX is not true).")

								return
							end

							u23 = not u23

							if u23 then
								CameraType = CurrentCamera.CameraType
								CurrentCamera.CameraType = Enum.CameraType.Scriptable
							else
								if CameraType then
									CurrentCamera.CameraType = CameraType
									CameraType = nil
								end

								local Character: Model = LocalPlayer.Character
								local characterHumanoid = Character and Character:FindFirstChildOfClass("Humanoid")

								if characterHumanoid then
									CurrentCamera.CameraSubject = characterHumanoid
								end
							end

							describe()

							return
						end

						if not t1[4] then
							return
						end

						n1 = 4
						n2 = 0
						v19:Load(t1[4])
						describe()

						return
					end

					if not t1[3] then
						return
					end

					n1 = 3
					n2 = 0
					v19:Load(t1[3])
					describe()

					return
				end

				if not t1[2] then
					return
				end

				n1 = 2
				n2 = 0
				v19:Load(t1[2])
				describe()

				return
			end

			if not t1[1] then
				return
			end

			n1 = 1
			n2 = 0
			v19:Load(t1[1])
			describe()

			return
		end
	end)
	runService.PreRender:Connect(function(deltaTimeRender: number)
		local clip = v19.clip

		if not clip then
			return
		end

		if clip.length > 0 then
			n2 = (n2 + deltaTimeRender * n3) % clip.length
		end

		v19:Sample(n2, not u11)

		local cFrame = u23 and u11 and v19:GetCameraBoneCFrame()

		if cFrame then
			CurrentCamera.CFrame = cFrame
		end
	end)
	LocalPlayer.CharacterRemoving:Connect(function()
		if u23 then
			u23 = false

			if CameraType then
				CurrentCamera.CameraType = CameraType
				CameraType = nil
			end

			local Character: Model = LocalPlayer.Character
			local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				CurrentCamera.CameraSubject = humanoid
			end
		end

		if cameraBone and cameraBone:IsA("BasePart") and u26 ~= nil then
			cameraBone.LocalTransparencyModifier = 0
			cameraBone.Transparency = u26
			u26 = nil
		end

		v19:Stop()
	end)

	if cameraBone and cameraBone:IsA("BasePart") and u26 == nil then
		u26 = cameraBone.Transparency
		cameraBone.LocalTransparencyModifier = 1
	end

	print("===== NewRigPreview active (workspace.NewTestRig is on) =====")
	print("  1 idle   2 equip   3 shoot&reload   4 inspect")
	print("  [ ] slow down / speed up      0  stop and restore")

	if u11 then
		print("  C  toggle camera bone driving the camera")
	else
		print("  camera FX: DISABLED (workspace.NewRigCameraFX = false)")
	end

	if t1[1] then
		n1 = 1
		n2 = 0
		v19:Load(t1[1])
		describe()
	end

	return
end
