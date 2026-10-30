-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1: {[any]: any} = { "LeftPage", "RightPage" }
local color3 = Color3.fromRGB(255, 0, 0)
local color32 = Color3.fromRGB(0, 255, 0)
local color33 = Color3.fromRGB(0, 255, 255)
local color34 = Color3.fromRGB(255, 0, 255)
local v8 = table.concat({
	"note dump                      -- full client + server diagnostic",
	"note write <text>              -- paint the right page now, no delay",
	"note blank                     -- clear both pages",
	"note gui <prop> <value>        -- live-tweak both pages (see below)",
	"note gui show                  -- max-visibility preset + page markers",
	"note gui slab true             -- show the Write PARTS as neon slabs",
	"note gui reset                 -- restore every prop from the template",
	"note log <count>               -- fill the left page over the real remote",
	"note kill <name>               -- fake a kill of that name: list + sentence",
	"note fit                       -- read the current page fit",
	"note fit <flow%> <stack%>      -- resize the text block live, then repaint",
	"note fit reset                 -- back to the shipped fit",
	"note pos <x%> <y%>             -- move where the text STARTS on the page",
	"note clip <true|false>         -- clip the pages to the Write part's canvas",
	"note outcome <kind>            -- kill | decoy | unlogged | hit | miss",
	"note push                      -- force the real server equip-push",
	"",
	"gui props: enabled alwaysontop zoffset ppu light bright",
	"           bg textsize scaled rotation color slab",
	"colors:    black white red lime cyan magenta"
}, "\n")

local function writePart(p1)
	if not p1 then
		return nil
	end

	for _, v in ipairs(p1:GetChildren()) do
		if v.Name == "Write" and v:IsA("BasePart") then
			return v
		end
	end

	return nil
end
local function ownRig()
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v31 = localPlayerCharacter

	if v31 then
		v31 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	return v31 and v31:IsA("Model") and v31 or nil
end
local function resolve(p2, p3)
	if not p2 then
		return nil, nil, nil, nil
	end

	local revolverRoot = p2:FindFirstChild("RevolverRoot")
	local v35 = revolverRoot and revolverRoot:FindFirstChild(p3)
	local v36 = writePart(v35)
	local surfaceGui = v36 and v36:FindFirstChildWhichIsA("SurfaceGui")
	local textLabel = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

	return v35, v36, surfaceGui, textLabel
end
local function templateSide(p4)
	local revolvers: Instance = replicatedStorage:FindFirstChild("Revolvers")
	local murderNote: Instance = revolvers and revolvers:FindFirstChild("MurderNote")

	return resolve(murderNote, p4)
end
local function toBool(p5)
	local v43 = typeof(p5) == "string" and string.lower(p5) or ""

	if v43 == "true" or v43 == "1" or v43 == "on" or v43 == "yes" then
		return true
	end

	if v43 == "false" or v43 == "0" or v43 == "off" or v43 == "no" then
		return false
	end

	return nil
end
local function toNum(p6)
	return (tonumber(p6))
end
local function realCanvas(p7, p8)
	if not p7 or not p8 then
		return nil
	end

	if p8.SizingMode == Enum.SurfaceGuiSizingMode.FixedSize then
		return p8.CanvasSize.X, p8.CanvasSize.Y, "FixedSize"
	end

	local v47 = p7.Size
	local face = p8.Face
	local v49
	local v50

	if face == Enum.NormalId.Front or face == Enum.NormalId.Back then
		v49 = v47.X
		v50 = v47.Y
	elseif face == Enum.NormalId.Left or face == Enum.NormalId.Right then
		v49 = v47.Z
		v50 = v47.Y
	else
		v49 = v47.X
		v50 = v47.Z
	end

	return v49 * p8.PixelsPerStud, v50 * p8.PixelsPerStud, "PixelsPerStud"
end
local function short(p9, p10)
	if typeof(p9) == "string" then
		if p9 == "" then
			return "<empty>"
		end

		if p10 >= #p9 then
			return p9
		end

		return string.sub(p9, 1, p10) .. "..."
	end

	return "<nil>"
end
local function clientDump()
	local LocalPlayer: Player = players.LocalPlayer
	local t4: {[any]: any} = {}
	local t5: {[any]: any} = {}

	local function add(p11)
		table.insert(t4, p11)
	end

	table.insert(t4, "===== note dump : CLIENT =====")

	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local LocalPlayer2: Player = players.LocalPlayer
	local localPlayer2Character = LocalPlayer2 and LocalPlayer2.Character
	local v60 = localPlayer2Character

	if v60 then
		v60 = localPlayer2Character:FindFirstChild("RevolverRig")
	end

	local v61 = v60 and v60:IsA("Model") and v60 or nil

	v60 = ("character=%s  RevolverRig=%s"):format(if localPlayerCharacter then "yes" else "MISSING", if v61 then "yes" else "MISSING")
	table.insert(t4, v60)
	v60 = LocalPlayer

	if v60 then
		v60 = LocalPlayer:GetAttribute("DisableFPEffects") == true
	end

	local v62 = LocalPlayer and LocalPlayer:GetAttribute("RevolverSkin")
	local text: string = tostring(v62)
	local v64 = localPlayerCharacter and localPlayerCharacter:GetAttribute("EnableRevolverRig")
	local text2: string = tostring(v64)
	local v66 = ("RevolverSkin=%s  EnableRevolverRig=%s"):format(text, text2)

	table.insert(t4, v66)

	local text3: string = tostring(v60)

	v64 = v61 and v61:GetAttribute("ClientVisible")

	local text4: string = tostring(v64)

	v66 = ("DisableFPEffects=%s  rig.ClientVisible=%s"):format(text3, text4)
	table.insert(t4, v66)

	if not v61 then
		table.insert(t4, "No RevolverRig -- equip a revolver first (`rev me MurderNote MurderNote`).")

		return table.concat(t4, "\n")
	end

	table.insert(t4, "")
	table.insert(t4, "-- Template (this client's copy) --")

	local revolvers: Instance = replicatedStorage:FindFirstChild("Revolvers")
	local murderNote: Instance = revolvers and revolvers:FindFirstChild("MurderNote")

	if not murderNote then
		table.insert(t4, "Revolvers.MurderNote NOT FOUND on this client.")
		table.insert(t5, "the MurderNote template is missing from this client entirely.")
	else
		local revolverRoot: Instance = murderNote:FindFirstChild("RevolverRoot")
		local offhand: Instance = murderNote:FindFirstChild("Offhand")
		local t6: {[any]: any} = {}
		local t7: {[any]: any} = {}

		for _, v in ipairs({
			{ "Offhand", offhand },
			{ "Offhand.Pen", offhand and offhand:FindFirstChild("Pen") },
			{ "RevolverRoot", revolverRoot },
			{ "Equip", revolverRoot and revolverRoot:FindFirstChild("Equip") },
			{ "Unequip", revolverRoot and revolverRoot:FindFirstChild("Unequip") },
			{
				"AlwaysTwoHanded",
				revolverRoot and revolverRoot:FindFirstChild("AlwaysTwoHanded")
			},
			{
				"StaticOnHip",
				revolverRoot and revolverRoot:FindFirstChild("StaticOnHip")
			},
			{ "LeftPage", revolverRoot and revolverRoot:FindFirstChild("LeftPage") },
			{
				"RightPage",
				revolverRoot and revolverRoot:FindFirstChild("RightPage")
			}
		}) do
			t7[#t7 + 1] = v[1] .. "=" .. (if v[2] then "ok" else "GONE")

			if not v[2] then
				t6[#t6 + 1] = v[1]
			end
		end

		local v77 = table.concat(t7, "  ")

		table.insert(t4, v77)

		if #t6 > 0 then
			local v78 = ("TEMPLATE is missing %d piece(s): %s. A re-import wipes exactly "):format(#t6, table.concat(t6, ", "))

			table.insert(t5, v78 .. "these, because they are added in Studio and are not part of the export. " .. "Restore them on the template -- repairing the rig alone will not hold.")
		end

		local t8: {[any]: any} = {}

		for _, v in ipairs(murderNote:GetChildren()) do
			if not v61:FindFirstChild(v.Name) then
				t8[#t8 + 1] = v.Name
			end
		end

		if #t8 > 0 then
			local v82 = ("your RIG is missing %s that the template HAS -- it was cloned "):format(table.concat(t8, ", "))

			table.insert(t5, v82 .. "before that replicated. Reconcile should repair this on the next equip change; " .. "if it does not, the reconcile pass is not running.")
		end
	end

	table.insert(t4, "")
	table.insert(t4, "-- Offhand --")

	local offhand = v61:FindFirstChild("Offhand")
	local pen = offhand and offhand:FindFirstChild("Pen")
	local leftArm = localPlayerCharacter and localPlayerCharacter:FindFirstChild("Left Arm")

	v62 = nil

	local t9 = localPlayerCharacter and localPlayerCharacter:GetDescendants() or {}

	for _, v in ipairs(t9) do
		if v:IsA("Motor6D") and v.Name == "Offhand_Pen" then
			v62 = v
		end
	end

	v64 = ("Offhand=%s  Pen=%s  LeftArm=%s  Offhand_Pen motor=%s"):format(if offhand then "ok" else "MISSING", if pen then "ok" else "MISSING", if leftArm then "ok" else "MISSING", if v62 then "ok" else "MISSING")
	table.insert(t4, v64)

	if not offhand then
		table.insert(t5, "rig has no Offhand model -- the template was re-imported and wiped its config. This has happened before; restore Offhand/Pen/Equip.")
	elseif not leftArm then
		table.insert(t5, "no Left Arm on the character -- the quill has nothing to weld to.")
	elseif not v62 then
		table.insert(t5, "no Offhand_Pen motor -- Attach never bound the quill, so nothing is holding it and it has fallen out of the world.")
	elseif pen and pen:IsA("BasePart") and leftArm:IsA("BasePart") then
		local magnitude = (pen.Position - leftArm.Position).Magnitude
		local text5: string = tostring(pen.LocalTransparencyModifier)
		local text6: string = tostring(pen.Transparency)
		local v92 = ("pen dist from Left Arm=%.2f studs  ltm=%s  transparency=%s"):format(magnitude, text5, text6)

		table.insert(t4, v92)
		v92 = ("motor P0=%s  P1=%s  parent=%s"):format(v62.Part0 and v62.Part0.Name or "NIL", v62.Part1 and v62.Part1.Name or "NIL", v62.Parent and v62.Parent.Name or "NIL")
		table.insert(t4, v92)

		if magnitude > 4 then
			local v93 = ("the quill is %.1f studs from the Left Arm -- it is welded to "):format(magnitude)

			table.insert(t5, v93 .. "nothing, or to the wrong thing.")
		end

		if pen.LocalTransparencyModifier >= 1 then
			table.insert(t5, "the quill is bound and in place but LocalTransparencyModifier is 1 -- it is being HIDDEN, not lost. That is the OffhandVisible rule, not the weld.")
		end
	end

	for _, v in ipairs(t1) do
		local v96, v97, v98, v99 = resolve(v61, v)

		table.insert(t4, "")
		table.insert(t4, "-- " .. v .. " --")

		local v100 = ("page=%s  writePart=%s  surfaceGui=%s  textLabel=%s"):format(if v96 then "ok" else "MISSING", if v97 then "ok" else "MISSING", if v98 then "ok" else "MISSING", if v99 then "ok" else "MISSING")

		table.insert(t4, v100)

		if not v98 then
			table.insert(t5, v .. ": no SurfaceGui -- the model was re-imported or renamed.")
		else
			local adornee = v98.Adornee
			local u102 = true

			if adornee ~= nil then
				u102 = adornee:IsDescendantOf(v61)
			end

			local text7: string = tostring(v98.Enabled)
			local text8: string = tostring(v98.AlwaysOnTop)
			local text9: string = tostring(v98.ZOffset)
			local v106 = ("enabled=%s  alwaysOnTop=%s  zOffset=%s  face=%s"):format(text7, text8, text9, v98.Face.Name)

			table.insert(t4, v106)

			local text10: string = tostring(v98.LightInfluence)
			local text11: string = tostring(v98.Brightness)
			local text12: string = tostring(v98.MaxDistance)

			v106 = ("light=%s  brightness=%s  maxDist=%s  adornee=%s"):format(text10, text11, text12, if u102 then "in-rig" else "OFF-RIG!")
			table.insert(t4, v106)

			local v110, v111, v112 = realCanvas(v97, v98)

			if v110 then
				local floored = math.floor(v110)
				local floored2 = math.floor(v111)
				local text13: string = tostring(v98.PixelsPerStud)
				local floored3 = math.floor(v98.CanvasSize.X)
				local floored4 = math.floor(v98.CanvasSize.Y)
				local v118 = ("canvas=%dx%d px (%s, ppu=%s)  authored CanvasSize=%dx%d"):format(floored, floored2, v112, text13, floored3, floored4)

				table.insert(t4, v118)

				if v112 == "PixelsPerStud" and (v98.CanvasSize.X ~= 0 or v98.CanvasSize.Y ~= 0) and math.abs(v110 - v98.CanvasSize.X) > 1 then
					local floored5 = math.floor(v110)

					table.insert(t5, v .. ": real canvas is " .. floored5 .. "px wide but the label was authored against " .. v98.CanvasSize.X .. "px.")
				end
			end

			if v97 then
				local text14: string = tostring(v97.Transparency)
				local text15: string = tostring(v97.LocalTransparencyModifier)
				local text16: string = tostring(v97.Size)
				local v123 = ("writePart transparency=%s  localTransparencyMod=%s  size=%s"):format(text14, text15, text16)

				table.insert(t4, v123)

				local revolverRoot = v61:FindFirstChild("RevolverRoot")

				if revolverRoot and revolverRoot:IsA("BasePart") then
					local v125 = v96 and v96:IsA("BasePart") and (v96.Position - revolverRoot.Position).Magnitude or -1
					local v126 = (v97.Position - revolverRoot.Position).Magnitude
					local v127 = ("dist from RevolverRoot: page=%.2f  write=%.2f studs"):format(v125, v126)

					table.insert(t4, v127)

					if v126 > 4 then
						local v128 = (": Write part is %.1f studs from RevolverRoot -- "):format(v126)

						table.insert(t5, v .. v128 .. "it has come off the book. The RigidConstraint to the PAGE bone is not holding, " .. "so the text is being drawn off in space. THIS is the bug, not the gui settings.")
					end
				end

				v123 = nil

				local t10 = v96 and v96:GetChildren() or {}

				for _, iterValue in ipairs(t10) do
					if iterValue:IsA("RigidConstraint") then
						v123 = iterValue
					end
				end

				if v123 then
					local attachment1 = v123.Attachment1
					local u133 = false

					if attachment1 ~= nil then
						u133 = attachment1:IsDescendantOf(v61)
					end

					local v134 = ("rigidConstraint enabled=%s  a0=%s  a1=%s"):format(tostring(v123.Enabled), if v123.Attachment0 then "ok" else "NIL", u133 and "ok (" .. attachment1.ClassName .. ")" or (if attachment1 then "OFF-RIG!" else "NIL"))

					table.insert(t4, v134)

					if not v123.Enabled then
						table.insert(t5, v .. ": RigidConstraint is disabled -- the page is unanchored from the book.")
					end

					if not u133 then
						table.insert(t5, v .. ": RigidConstraint.Attachment1 does not resolve into the rig.")
					end
				else
					table.insert(t5, v .. ": no RigidConstraint -- nothing is holding this page to the book.")
				end
			end

			if v99 then
				local v135 = v99.Text
				local v136 = ("text=%q"):format(if typeof(v135) == "string" then if v135 == "" then "<empty>" else if #v135 <= 70 then v135 else string.sub(v135, 1, 70) .. "..." else "<nil>")

				table.insert(t4, v136)

				local text17: string = tostring(v99.Visible)
				local text18: string = tostring(v99.TextTransparency)
				local text19: string = tostring(v99.BackgroundTransparency)

				v136 = ("visible=%s  textTransparency=%s  bgTransparency=%s"):format(text17, text18, text19)
				table.insert(t4, v136)

				local text20: string = tostring(v99.TextScaled)
				local text21: string = tostring(v99.TextSize)
				local text22: string = tostring(v99.Rotation)
				local text23: string = tostring(v99.TextColor3)

				v136 = ("scaled=%s  textSize=%s  rotation=%s  color=%s"):format(text20, text21, text22, text23)
				table.insert(t4, v136)

				local text24: string = tostring(v99.Size)
				local text25: string = tostring(v99.Position)
				local text26: string = tostring(v99.TextWrapped)

				v136 = ("size=%s  pos=%s  wrapped=%s"):format(text24, text25, text26)
				table.insert(t4, v136)

				if v110 then
					local n1 = v99.Size.X.Scale * v110 + v99.Size.X.Offset
					local n2 = v99.Size.Y.Scale * v111 + v99.Size.Y.Offset
					local textSize = v99.TextSize
					local v150 = math.max(v99.LineHeight, 0.01)
					local n3 = textSize * v150
					local notePageFitted = v99:GetAttribute("NotePageFitted")
					local floored = math.floor(n1)
					local floored6 = math.floor(n2)
					local floored7 = math.floor(n2 / n3)
					local v156 = math.max(1, floored7)
					local floored8 = math.floor(n3)
					local v158 = ("fitted=%s  textBox=%dx%d px  holds %d line(s) of %dpx"):format(if notePageFitted then "yes" else "NO", floored, floored6, v156, floored8)

					table.insert(t4, v158)
					n2 = math.abs((v99.Rotation % 180 + 180) % 180 - 90) < 45 and v111 or v110

					if n1 > n2 + 1 then
						local floored9 = math.floor(n1)
						local floored10 = math.floor(n2)
						local v161 = (": text wraps at %dpx but only %dpx of page "):format(floored9, floored10)

						table.insert(t5, v .. v161 .. "runs that way -- every line overhangs the paper. The renderer's fit did not apply.")
					end
				end

				if v99.TextTransparency >= 1 then
					table.insert(t5, v .. ": TextTransparency is 1 -- a fade completed and never reset.")
				end

				if not v99.Visible then
					table.insert(t5, v .. ": TextLabel.Visible is false.")
				end
			end

			if not v98.Enabled then
				table.insert(t5, v .. ": SurfaceGui.Enabled is FALSE.")
			end

			if not u102 then
				local v162 = adornee and adornee:GetFullName() or "?"

				table.insert(t5, v .. ": Adornee points outside the rig (" .. v162 .. ").")
			end
		end
	end

	if v60 then
		table.insert(t5, "DisableFPEffects is ON -- WeaponRigUtil.SetRigVisible buckets SurfaceGui with particles and will set Enabled=false on both pages in first person. Turn the setting off (or `note gui enabled true`) to confirm.")
	end

	table.insert(t4, "")

	if #t5 == 0 then
		table.insert(t4, "No render-side problems found. If the pages are still blank the text is not being REQUESTED -- see the server half below, and try `note write hello`.")
	else
		table.insert(t4, "SUSPECTS:")

		for i, v in ipairs(t5) do
			local v165 = ("  %d. %s"):format(i, v)

			table.insert(t4, v165)
		end
	end

	return table.concat(t4, "\n")
end

local t2: {[any]: any} = {
	enabled = true,
	alwaysontop = true,
	zoffset = true,
	ppu = true,
	light = true,
	bright = true,
	bg = true,
	textsize = true,
	scaled = true,
	rotation = true,
	color = true,
	slab = true
}
local t3: {[any]: any} = {
	black = Color3.new(0, 0, 0),
	white = Color3.new(1, 1, 1),
	red = color3,
	lime = color32,
	cyan = color33,
	magenta = color34
}

local function applyProp(p12, p13)
	if not t2[p12] then
		return "Unknown gui prop '" .. tostring(p12) .. "'.\n" .. v8
	end

	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v170 = localPlayerCharacter

	if v170 then
		v170 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v171 = v170 and v170:IsA("Model") and v170 or nil

	if not v171 then
		return "No RevolverRig on your character."
	end

	v170 = 0

	for _, v in ipairs(t1) do
		local v174, v175, v176, v177 = resolve(v171, v)

		if v176 then
			if p12 == "enabled" then
				local v178 = typeof(p13) == "string" and string.lower(p13) or ""
				local enabled = if v178 == "true" or v178 == "1" or v178 == "on" or v178 == "yes" then true else if v178 == "false" or v178 == "0" or v178 == "off" or v178 == "no" then false else nil

				if enabled == nil then
					return "enabled needs true|false."
				end

				v176.Enabled = enabled
			elseif p12 == "alwaysontop" then
				local v180 = typeof(p13) == "string" and string.lower(p13) or ""
				local alwaysOnTop = if v180 == "true" or v180 == "1" or v180 == "on" or v180 == "yes" then true else if v180 == "false" or v180 == "0" or v180 == "off" or v180 == "no" then false else nil

				if alwaysOnTop == nil then
					return "alwaysontop needs true|false."
				end

				v176.AlwaysOnTop = alwaysOnTop
			elseif p12 == "zoffset" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "zoffset needs a number."
				end

				v176.ZOffset = numberValue
			elseif p12 == "ppu" then
				local numberValue: number? = tonumber(p13)

				if not numberValue or numberValue <= 0 then
					return "ppu needs a positive number."
				end

				v176.PixelsPerStud = numberValue
			elseif p12 == "light" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "light needs 0..1."
				end

				v176.LightInfluence = math.clamp(numberValue, 0, 1)
			elseif p12 == "bright" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "bright needs a number."
				end

				v176.Brightness = numberValue
			elseif p12 == "slab" then
				local v186 = typeof(p13) == "string" and string.lower(p13) or ""
				local u187 = if v186 == "true" or v186 == "1" or v186 == "on" or v186 == "yes" then true else if v186 == "false" or v186 == "0" or v186 == "off" or v186 == "no" then false else nil

				if u187 == nil then
					return "slab needs true|false."
				end

				if v175 then
					v175.Transparency = if u187 then 0 else 1
					v175.Material = u187 and Enum.Material.Neon or Enum.Material.Plastic
					v175.Color = v == "LeftPage" and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(0, 255, 255)
					v175.LocalTransparencyModifier = 0
				end
			elseif v177 == nil then
				continue
			elseif p12 == "bg" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "bg needs 0..1."
				end

				v177.BackgroundTransparency = math.clamp(numberValue, 0, 1)
			elseif p12 == "textsize" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "textsize needs a number."
				end

				v177.TextSize = numberValue
			elseif p12 == "scaled" then
				local v190 = typeof(p13) == "string" and string.lower(p13) or ""
				local textScaled = if v190 == "true" or v190 == "1" or v190 == "on" or v190 == "yes" then true else if v190 == "false" or v190 == "0" or v190 == "off" or v190 == "no" then false else nil

				if textScaled == nil then
					return "scaled needs true|false."
				end

				v177.TextScaled = textScaled
			elseif p12 == "rotation" then
				local numberValue: number? = tonumber(p13)

				if not numberValue then
					return "rotation needs degrees."
				end

				v177.Rotation = numberValue
			else
				if p12 ~= "color" then
					return "Unknown gui prop '" .. tostring(p12) .. "'.\n" .. v8
				end

				local stringLower = string.lower
				local text: string = tostring(p13)
				local v195 = stringLower(text)
				local textColor3 = t3[v195]

				if not textColor3 then
					return "color must be one of: black white red lime cyan magenta."
				end

				v177.TextColor3 = textColor3
				v177.TextTransparency = 0
			end

			v170 += 1
		end
	end

	if v170 == 0 then
		return "Found the rig but no page SurfaceGuis -- run `note dump`."
	end

	local text: string = tostring(p13)

	return ("Set %s=%s on %d page(s). Local only; a respawn or skin swap reverts it."):format(p12, text, v170)
end
local function applyShow()
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v200 = localPlayerCharacter

	if v200 then
		v200 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v201 = v200 and v200:IsA("Model") and v200 or nil

	if not v201 then
		return "No RevolverRig on your character."
	end

	pcall(function()
		require(replicatedStorage.Shared.NotePagesRenderer).Blank(v201)
	end)
	v200 = 0

	for _, v in ipairs(t1) do
		local v204, v205, v206, v207 = resolve(v201, v)

		if v206 then
			v206.Enabled = true
			v206.AlwaysOnTop = true
			v206.LightInfluence = 0
			v206.Brightness = 1

			if v207 then
				v207.Visible = true
				v207.BackgroundTransparency = 0.5
				v207.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
				v207.TextColor3 = t3.red
				v207.TextTransparency = 0
				v207.TextScaled = true
				v207.Text = if v == "LeftPage" then "LEFT PAGE" else "RIGHT PAGE"
			end

			v200 += 1
		end
	end

	if v200 == 0 then
		return "Found the rig but no page SurfaceGuis -- run `note dump`."
	end

	local tableConcat = table.concat
	local v209 = ("Show preset applied to %d page(s): AlwaysOnTop, unlit, scaled red text on a "):format(v200)

	return tableConcat({
		v209 .. "blue 50%-opaque canvas.",
		"",
		"Read it like this:",
		"  blue rectangles in the right place, text readable -> render is fine, the",
		"      problem is upstream (nothing is asking for text). Try `note outcome kill`.",
		"  rectangles visible only NOW that AlwaysOnTop is on -> the book mesh was",
		"      occluding them. Fix with ZOffset or by nudging the Write parts out.",
		"  rectangles in the wrong place / edge-on -> the Write parts or the gui Face",
		"      are wrong. That one is Felku's.",
		"  no rectangles at all -> the gui is not reaching the screen. `note dump`.",
		"",
		"`note gui reset` puts everything back from the template."
	}, "\n")
end
local function applyFit(p14, p15)
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v214 = localPlayerCharacter

	if v214 then
		v214 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v215 = v214 and v214:IsA("Model") and v214 or nil

	if not v215 then
		return "No RevolverRig on your character."
	end

	local notePagesRenderer = require(replicatedStorage.Shared.NotePagesRenderer)

	if not notePagesRenderer.IsNote(v215) then
		return "Your RevolverRig has no note pages -- you are not holding the MurderNote."
	end

	local v217 = typeof(p14) == "string" and string.lower(p14) or ""
	local u218: boolean = false

	if v217 == "reset" then
		notePagesRenderer.FILL.Flow = notePagesRenderer.DEFAULT_FILL.Flow
		notePagesRenderer.FILL.LeftPage = notePagesRenderer.DEFAULT_FILL.LeftPage
		notePagesRenderer.FILL.RightPage = notePagesRenderer.DEFAULT_FILL.RightPage
		u218 = true
	elseif v217 ~= "" then
		local numberValue: number? = tonumber(p14)
		local numberValue2: number? = tonumber(p15)

		if not numberValue or not numberValue2 then
			return "note fit <flow%> <stack%>  e.g. `note fit 50 30`.\nBare `note fit` reads the current one; `note fit reset` restores it."
		end

		notePagesRenderer.FILL.Flow = math.clamp(numberValue, 5, 200) / 100
		notePagesRenderer.FILL.LeftPage = math.clamp(numberValue2, 5, 200) / 100
		notePagesRenderer.FILL.RightPage = math.clamp(numberValue2, 5, 200) / 100
		u218 = true
	end

	if u218 then
		notePagesRenderer.Refit(v215)

		local _GMurderNotePages = _G.MurderNotePages

		if _GMurderNotePages and _GMurderNotePages.Repaint then
			pcall(_GMurderNotePages.Repaint)
		end

		task.wait(0.25)
	end

	local t11: {[any]: any} = {}

	local function add(p16)
		table.insert(t11, p16)
	end

	local floored = math.floor(notePagesRenderer.FILL.Flow * 100 + 0.5)
	local floored11 = math.floor(notePagesRenderer.FILL.LeftPage * 100 + 0.5)
	local floored12 = math.floor(notePagesRenderer.FILL.StartX * 100 + 0.5)
	local floored13 = math.floor(notePagesRenderer.FILL.StartY * 100 + 0.5)
	local text: string = tostring(notePagesRenderer.FILL.Clip == true)
	local v229 = ("fit: flow=%d%%  stack=%d%%  start=(%d%%, %d%%)  clip=%s"):format(floored, floored11, floored12, floored13, text)

	table.insert(t11, v229)

	local floored14 = math.floor(notePagesRenderer.DEFAULT_FILL.Flow * 100 + 0.5)
	local floored15 = math.floor(notePagesRenderer.DEFAULT_FILL.LeftPage * 100 + 0.5)
	local floored16 = math.floor(notePagesRenderer.DEFAULT_FILL.StartX * 100 + 0.5)
	local floored17 = math.floor(notePagesRenderer.DEFAULT_FILL.StartY * 100 + 0.5)

	v229 = ("     shipped: flow=%d%% stack=%d%% start=(%d%%, %d%%)"):format(floored14, floored15, floored16, floored17)
	table.insert(t11, v229)

	for _, v in ipairs(t1) do
		local v236, v237, v238 = notePagesRenderer.LabelBox(v215, v)

		if v236 then
			local textSize = v236.TextSize
			local v240 = math.max(v236.LineHeight, 0.01)
			local n1 = textSize * v240
			local floored18 = math.floor(v237)
			local floored19 = math.floor(v238)
			local floored20 = math.floor(v238 / n1)
			local v245 = math.max(1, floored20)
			local floored21 = math.floor(n1)
			local v247 = ("  %-9s wraps at %dpx, stacks %dpx -> %d line(s) of %dpx"):format(v, floored18, floored19, v245, floored21)

			table.insert(t11, v247)
		end
	end

	v229 = notePagesRenderer.Label(v215, "LeftPage")
	v214 = v229 and v229.Text or ""
	v229 = 0

	if v214 ~= "" and not v214:find("%(empty%)") then
		v229 = select(2, v214:gsub(", ", "")) + 1
	end

	local v248 = ("  left page is showing %d name(s)"):format(v229)

	table.insert(t11, v248)

	if not u218 then
		table.insert(t11, "")
		table.insert(t11, "Tune with `note fit <flow%> <stack%>`, e.g. `note fit 50 30`. Load the page")
		table.insert(t11, "first with `note log 34` so there is something to overflow.")
	end

	return table.concat(t11, "\n")
end
local function applyPos(p17, p18)
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v253 = localPlayerCharacter

	if v253 then
		v253 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v254 = v253 and v253:IsA("Model") and v253 or nil

	if not v254 then
		return "No RevolverRig on your character."
	end

	local notePagesRenderer = require(replicatedStorage.Shared.NotePagesRenderer)

	if not notePagesRenderer.IsNote(v254) then
		return "Your RevolverRig has no note pages -- you are not holding the MurderNote."
	end

	local v256 = typeof(p17) == "string" and string.lower(p17) or ""

	if v256 == "" then
		local floored = math.floor(notePagesRenderer.FILL.StartX * 100 + 0.5)
		local floored22 = math.floor(notePagesRenderer.FILL.StartY * 100 + 0.5)

		return ("Text starts at x=%d%% y=%d%%. Move it with `note pos <x%%> <y%%>`; x is the "):format(floored, floored22) .. "VERTICAL one on this page."
	end

	if v256 == "reset" then
		notePagesRenderer.FILL.StartX = notePagesRenderer.DEFAULT_FILL.StartX
		notePagesRenderer.FILL.StartY = notePagesRenderer.DEFAULT_FILL.StartY
	else
		local numberValue: number? = tonumber(p17)
		local numberValue3: number? = tonumber(p18)

		if not numberValue or not numberValue3 then
			return "note pos <x%> <y%>  e.g. `note pos 6 125`. `note pos reset` restores."
		end

		notePagesRenderer.FILL.StartX = math.clamp(numberValue, -200, 300) / 100
		notePagesRenderer.FILL.StartY = math.clamp(numberValue3, -200, 300) / 100
	end

	notePagesRenderer.Refit(v254)

	local _GMurderNotePages = _G.MurderNotePages

	if _GMurderNotePages and _GMurderNotePages.Repaint then
		pcall(_GMurderNotePages.Repaint)
	end

	task.wait(0.25)

	local floored = math.floor(notePagesRenderer.FILL.StartX * 100 + 0.5)
	local floored23 = math.floor(notePagesRenderer.FILL.StartY * 100 + 0.5)

	return ("Text now starts at x=%d%% y=%d%%. `note fit` shows the resulting box."):format(floored, floored23)
end
local function applyClipCmd(p19)
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v267 = localPlayerCharacter

	if v267 then
		v267 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v268 = v267 and v267:IsA("Model") and v267 or nil

	if not v268 then
		return "No RevolverRig on your character."
	end

	local notePagesRenderer = require(replicatedStorage.Shared.NotePagesRenderer)

	if not notePagesRenderer.IsNote(v268) then
		return "Your RevolverRig has no note pages -- you are not holding the MurderNote."
	end

	local v270 = typeof(p19) == "string" and string.lower(p19) or ""
	local u271 = if v270 == "true" or v270 == "1" or v270 == "on" or v270 == "yes" then true else if v270 == "false" or v270 == "0" or v270 == "off" or v270 == "no" then false else nil

	if u271 == nil then
		return ("clip is currently %s. Set it with `note clip true|false`."):format((tostring(notePagesRenderer.FILL.Clip == true)))
	end

	notePagesRenderer.FILL.Clip = u271
	notePagesRenderer.Refit(v268)

	local _GMurderNotePages = _G.MurderNotePages

	if _GMurderNotePages and _GMurderNotePages.Repaint then
		pcall(_GMurderNotePages.Repaint)
	end

	task.wait(0.25)

	if u271 then
		return table.concat({
			"Clip ON -- both labels are now inside a canvas-sized frame with",
			"ClipsDescendants. Note that the flag on the TextLabel itself does nothing:",
			"a GuiObject clips its descendants, not its own text.",
			"",
			"If names are now cut off mid-letter at the sides, that confirms the paper is",
			"WIDER than the Write part and clipping is the wrong tool. `note clip false`."
		}, "\n")
	end

	return "Clip OFF -- labels are back directly under the SurfaceGui."
end
local function applyReset()
	local LocalPlayer: Player = players.LocalPlayer
	local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
	local v275 = localPlayerCharacter

	if v275 then
		v275 = localPlayerCharacter:FindFirstChild("RevolverRig")
	end

	local v276 = v275 and v275:IsA("Model") and v275 or nil

	if not v276 then
		return "No RevolverRig on your character."
	end

	v275 = 0

	for _, v in ipairs(t1) do
		local v279, v280, v281, v282 = resolve(v276, v)
		local revolvers: Instance = replicatedStorage:FindFirstChild("Revolvers")
		local v284: Instance = revolvers

		if v284 then
			v284 = revolvers:FindFirstChild("MurderNote")
		end

		local v285, v286, v287, v288 = resolve(v284, v)
		local v289 = v287
		local v290 = v288

		if v281 and v289 then
			v281.Enabled = v289.Enabled
			v281.AlwaysOnTop = v289.AlwaysOnTop
			v281.ZOffset = v289.ZOffset
			v281.PixelsPerStud = v289.PixelsPerStud
			v281.LightInfluence = v289.LightInfluence
			v281.Brightness = v289.Brightness

			if v282 and v290 then
				v288 = nil
				v282:SetAttribute("NotePageFitted", v288)
				v282.Visible = v290.Visible
				v282.BackgroundTransparency = v290.BackgroundTransparency
				v282.BackgroundColor3 = v290.BackgroundColor3
				v282.TextColor3 = v290.TextColor3
				v282.TextTransparency = 0
				v282.TextScaled = v290.TextScaled
				v282.TextSize = v290.TextSize
				v282.Rotation = v290.Rotation
				v282.Text = ""
			end

			v275 += 1
		end
	end

	if v275 == 0 then
		return "Nothing to reset -- no page SurfaceGuis found."
	end

	return ("Restored %d page(s) from ReplicatedStorage.Revolvers.MurderNote. Pages left blank."):format(v275)
end

return {
	Name = "note",
	Description = "Debug the MurderNote's written pages: diagnose, force text, and live-tweak the page SurfaceGuis.",
	Group = "Admin",
	Aliases = { "murdernote", "mn" },
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "dump | write | blank | gui | fit | pos | clip | log | kill | outcome | push. Omit for help.",
			Optional = true
		},
		{
			Type = "string",
			Name = "a",
			Description = "write: the text (quote it). gui: the prop. outcome: the kind. log: the count. kill: the name. fit: flow%.",
			Optional = true
		},
		{
			Type = "string",
			Name = "b",
			Description = "gui: the value. outcome kill: the victim name. fit: stack%.",
			Optional = true
		}
	},
	ClientRun = function(p20, p21, p22, p23)
		local v295 = typeof(p21) == "string" and string.lower(p21) or ""

		if v295 == "" or v295 == "help" then
			return v8
		end

		if v295 == "dump" then
			local ok, result = pcall(clientDump)
			local v298 = ok and result

			if not v298 then
				v298 = "client dump failed: " .. tostring(result)
			end

			local v299 = ok and Color3.fromRGB(190, 210, 255) or Color3.fromRGB(255, 120, 120)

			p20:Reply(v298, v299)

			return nil
		end

		if v295 == "write" then
			local LocalPlayer: Player = players.LocalPlayer
			local localPlayerCharacter = LocalPlayer and LocalPlayer.Character
			local v302 = localPlayerCharacter

			if v302 then
				v302 = localPlayerCharacter:FindFirstChild("RevolverRig")
			end

			local v303 = v302 and v302:IsA("Model") and v302 or nil

			if not v303 then
				return "No RevolverRig on your character."
			end

			local notePagesRenderer = require(replicatedStorage.Shared.NotePagesRenderer)

			if not notePagesRenderer.IsNote(v303) then
				return "Your RevolverRig has no note pages -- you are not holding the MurderNote."
			end

			local v305 = typeof(p22) == "string" and p22 ~= "" and p22 or "THE QUICK BROWN FOX"

			notePagesRenderer.WriteRight(v303, v305)

			return ("Wrote %q to the right page. Real hold/fade applies -- it clears in ~3s."):format(v305)
		end

		if v295 == "blank" or v295 == "clear" then
			local LocalPlayer: Player = players.LocalPlayer
			local v307 = LocalPlayer and LocalPlayer.Character
			local v308 = v307

			if v308 then
				v308 = v307:FindFirstChild("RevolverRig")
			end

			local v309 = v308 and v308:IsA("Model") and v308 or nil

			if not v309 then
				return "No RevolverRig on your character."
			end

			require(replicatedStorage.Shared.NotePagesRenderer).Blank(v309)

			return "Both pages blanked."
		end

		if v295 == "gui" then
			local v310 = typeof(p22) == "string" and string.lower(p22) or ""

			if v310 == "" then
				return v8
			end

			if v310 == "show" then
				return applyShow()
			end

			if v310 == "reset" then
				return applyReset()
			end

			return applyProp(v310, p23)
		end

		if v295 == "fit" then
			return applyFit(p22, p23)
		end

		if v295 == "pos" then
			return applyPos(p22, p23)
		end

		if v295 == "clip" then
			return applyClipCmd(p22)
		end

		if v295 == "outcome" then
			local v311 = typeof(p22) == "string" and string.lower(p22) or ""

			if v311 == "hit" or v311 == "miss" then
				local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
				local murderNoteShot: Instance = bindables and bindables:FindFirstChild("MurderNoteShot")

				if not murderNoteShot then
					return "Bindables.MurderNoteShot is missing."
				end

				murderNoteShot:Fire(v311)

				return ("Fired MurderNoteShot(%q) -- the same bindable RevolverClient uses. "):format(v311) .. "Text lands after NotePages.WriteDelay (~0.5s)."
			end

			return nil
		end

		if v295 == "log" or v295 == "kill" or v295 == "push" then
			return nil
		end

		return "Unknown action '" .. tostring(p21) .. "'.\n" .. v8
	end
}
