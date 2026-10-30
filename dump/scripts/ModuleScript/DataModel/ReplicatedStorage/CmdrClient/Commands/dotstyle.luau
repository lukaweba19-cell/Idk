-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

local function applyStyle(p1, p2)
	if not p1 or not p1:IsA("ImageLabel") then
		return false
	end

	local dot = p1:FindFirstChild("Dot")

	if not dot then
		return false
	end

	p1.Image = if p2 then "rbxassetid://129927082921020" else ""
	p1.ImageTransparency = 0
	dot.Visible = not p2

	return true
end

return {
	Name = "dotstyle",
	Description = "A/B the crosshair dot: 'image' = old baked asset, 'vector' = new UIShadow dot. No arg = toggle.",
	Group = "ContentCreator",
	Aliases = { "dot" },
	Args = { {
		Type = "string",
		Name = "style",
		Description = "image (old) | vector (new). Omit to toggle.",
		Optional = true
	} },
	ClientRun = function(_, p4)
		local LocalPlayer: Player = players.LocalPlayer
		local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local v10 = playerGui

		if v10 then
			v10 = playerGui:FindFirstChild("Cursor")
		end

		local centerDot = v10 and v10:FindFirstChild("CenterDot")

		if not centerDot then
			return "Cursor.CenterDot not found."
		end

		local dot = centerDot:FindFirstChild("Dot")

		if not dot then
			return "Vector 'Dot' child missing on CenterDot -- nothing to toggle."
		end

		local v13 = typeof(p4) == "string" and string.lower(p4) or nil
		local v14

		if v13 == nil or v13 == "" then
			v14 = dot.Visible
		elseif v13 == "image" or v13 == "old" then
			v14 = true
		else
			if v13 ~= "vector" and v13 ~= "new" then
				return "Unknown style '" .. tostring(p4) .. "'. Use image | vector, or no arg to toggle."
			end

			v14 = false
		end

		if centerDot and centerDot:IsA("ImageLabel") then
			local dot2 = centerDot:FindFirstChild("Dot")

			if dot2 then
				centerDot.Image = if v14 then "rbxassetid://129927082921020" else ""
				centerDot.ImageTransparency = 0
				dot2.Visible = not v14
			end
		end

		local v16 = playerGui

		if v16 then
			v16 = playerGui:FindFirstChild("HUD")
		end

		local v17 = v16

		if v17 then
			v17 = v16:FindFirstChild("SettingsWindow")
		end

		v16 = v17

		if v16 then
			v16 = v17:FindFirstChild("ContentCrosshair")
		end

		v17 = v16

		if v17 then
			v17 = v16:FindFirstChild("Preview")
		end

		local v18 = v17 and v17:FindFirstChild("CenterDot")

		if v18 and v18:IsA("ImageLabel") then
			local dot3 = v18:FindFirstChild("Dot")

			if dot3 then
				v18.Image = if v14 then "rbxassetid://129927082921020" else ""
				v18.ImageTransparency = 0
				dot3.Visible = not v14
			end
		end

		if v14 then
			return "Dot style: IMAGE (old baked asset). Note: ADS dot-fade only works on the vector dot -- compare at hip fire."
		end

		return "Dot style: VECTOR (Frame + UIStroke + UIShadow)."
	end
}
