-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local starterGui: StarterGui = game:GetService("StarterGui")
local u2: boolean = false
local module: {[any]: any} = {}

function module.setCameraModeToastEnabled(p1)
	if not p1 and not u2 then
		return
	end

	if not u2 then
		u2 = true
	end

	if not p1 then
		module.setCameraModeToastOpen(false)
	end
end
function module.setCameraModeToastOpen(p2)
	assert(u2)

	if p2 then
		starterGui:SetCore("SendNotification", {
			Title = "Camera Control Enabled",
			Text = "Right click to toggle",
			Duration = 3
		})
	end
end

return module
