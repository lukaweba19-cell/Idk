-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function msg(...)
	return (("[Forge Emit API]: %*"):format((table.concat({ ... }, " "))))
end

return {
	error = function(...)
		error(msg(..., "\n"))
	end,
	warn = function(...)
		warn(msg(...))
		warn(msg(debug.traceback("stack trace:")))
	end,
	info = function(...)
		print(msg(...))
	end
}
