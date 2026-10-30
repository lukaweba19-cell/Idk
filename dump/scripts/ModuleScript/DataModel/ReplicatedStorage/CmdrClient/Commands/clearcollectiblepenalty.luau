-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "clearcollectiblepenalty",
	Description = "Clear the pre-drop-snipe lockout (PenUntil) on a collectible for one or more players. For a legitimate buyer who was penalised during a reveal window and is STILL blocked after sales opened -- lowering PENALTY_BASE/CAP does not release them, because PenUntil is written as an absolute deadline at the moment of the offence.",
	Group = "Admin",
	Aliases = { "clearpenalty" },
	Args = {
		{
			Type = "collectibleKey",
			Name = "collectible",
			Description = "<Type>:<ItemId>, e.g. Knife:MurderNote."
		},
		{
			Type = "players",
			Name = "players",
			Description = "Player(s) to clear. Use * for everyone currently in this server."
		}
	}
}
