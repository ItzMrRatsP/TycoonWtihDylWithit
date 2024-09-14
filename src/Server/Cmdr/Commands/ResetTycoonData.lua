return {
	Name = "resetTycoon",
	Aliases = { "reset" },
	Description = "Reset data for players!",
	Group = "DefaultAdmin",
	Args = {
		{
			Type = "players",
			Name = "target",
			Description = "The players you want to affect.",
		},
	},
}
