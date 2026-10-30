-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "julysettier",
	Description = "Force your FourthOfJulyEvent CurrentTier (1-7). Use 6 to preview the hidden FinalReward (bonus tier) reveal; 7 = event complete (tier 6 shows as Completed). Clears your active tier task.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "tier",
		Description = "Tier to jump to (1-6, or 7 for all-claimed)."
	} }
}
