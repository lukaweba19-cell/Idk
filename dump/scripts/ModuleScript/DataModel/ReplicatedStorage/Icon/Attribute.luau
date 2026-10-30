-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
task.defer(function()
	local runService: RunService = game:GetService("RunService")
	local version = require(script.Parent.VERSION)
	local v3 = version.getAppVersion()
	local v4 = version.getLatestVersion()
	local v5 = version.isUpToDate()

	if not runService:IsStudio() then
		local v6 = ("🍍 Running TopbarPlus %* by @ForeverHD & HD Admin"):format(v3)

		print(v6)
	end

	if not v5 then
		local v7 = ("A new version of TopbarPlus (%*) is available: https://devforum.roblox.com/t/topbarplus/1017485"):format(v4)

		warn(v7)
	end
end)

return {}
