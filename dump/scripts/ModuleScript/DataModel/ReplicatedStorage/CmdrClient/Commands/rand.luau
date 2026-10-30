-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rand",
	Description = "Returns a random number between min and max",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "integer",
			Name = "First number",
			Description = "If second number is nil, random number is between 1 and this value. If second number is provided, number is between this number and the second number."
		},
		{
			Type = "integer",
			Name = "Second number",
			Description = "The upper bound.",
			Optional = true
		}
	},
	Run = function(_, p2, p3)
		local v4 = p3 and math.random(p2, p3) or math.random(p2)

		return (tostring(v4))
	end
}
