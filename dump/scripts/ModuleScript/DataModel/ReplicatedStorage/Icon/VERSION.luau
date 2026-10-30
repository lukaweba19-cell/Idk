-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = { appVersion = "v3.4.0", latestVersion = nil }

function module.getLatestVersion()
	local latestVersion = module.latestVersion

	if latestVersion then
		return latestVersion
	end

	while true do
		local ok, result = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(117501901079852)
		end)

		if ok and result then
			break
		end

		task.wait(1)
	end

	local v5 = string.match(result.Name, "^TopbarPlus (.*)$")

	if v5 then
		v5 = v5:gsub("%s+", "")
	end

	module.latestVersion = v5

	return v5
end
function module.getAppVersion()
	return module.appVersion
end
function module.isUpToDate()
	local v6 = module.getLatestVersion()
	local v7 = module.getAppVersion()

	return v6 ~= nil and v6 == v7
end

return module
