-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "replaymenu",
	Description = "Show the replay control menu on its own, with no replay running, to check its styling and layout. This is the panel mobile and console get in place of the keyboard shortcuts; PC keeps the shortcuts. The rows respond but do nothing -- there is no playback behind them. `close` dismisses it, and so does the panel's own Leave Replay row.",
	Group = "Admin",
	Aliases = { "rmenu" },
	Args = { {
		Type = "string",
		Name = "action",
		Description = "open | close",
		Default = "open"
	} }
}
