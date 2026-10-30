-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local universe = require(script.Parent:WaitForChild("Universe"))
local module: {[any]: any} = { ConfigKey = "SEASON_PASS_ENABLED", Attribute = "SEASON_PASS_ENABLED" }

function module.IsEnabled()
	return script:GetAttribute(module.Attribute) == true
end
function module.Changed()
	return script:GetAttributeChangedSignal(module.Attribute)
end

if runService:IsServer() then
	local seasonPassConfig = require(script.Parent:WaitForChild("SeasonPassConfig"))
	local u5: boolean = true

	local function apply()
		local u8 = if universe.IsDev() then true else u5 and seasonPassConfig.IsLaunched()

		script:SetAttribute(module.Attribute, u8)
	end

	local u7 = if universe.IsDev() then true else u5 and seasonPassConfig.IsLaunched()

	script:SetAttribute(module.Attribute, u7)

	if not universe.IsDev() and not seasonPassConfig.IsLaunched() then
		task.spawn(function()
			while true do
				if seasonPassConfig.IsLaunched() then
					break
				end

				task.wait(30)
			end

			local u9 = if universe.IsDev() then true else u5 and seasonPassConfig.IsLaunched()

			script:SetAttribute(module.Attribute, u9)

			local attribute = module.Attribute
			local text: string = tostring(module.IsEnabled())

			print(("[SeasonPassGate] launch epoch reached; %s = %s"):format(attribute, text))
		end)
	end

	task.spawn(function()
		local ok, result = pcall(function()
			local serverStorage: ServerStorage = game:GetService("ServerStorage")

			return require(serverStorage:WaitForChild("ConfigService"))
		end)

		if ok and type(result) == "table" then
			result.handleConfigUpdate(module.ConfigKey, function(p1)
				u5 = p1 ~= false

				local u16 = if universe.IsDev() then true else u5 and seasonPassConfig.IsLaunched()

				script:SetAttribute(module.Attribute, u16)
			end)

			return
		end

		warn("[SeasonPassGate] ConfigService unavailable; running on the launch epoch alone.")
	end)
end

return module
