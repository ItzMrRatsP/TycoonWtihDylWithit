return {
	Name = "setMoney",
	Aliases = { "sm" },
	Description = "Set money for players.",
	Group = "DefaultAdmin",
	Args = {
		{
			Type = "players",
			Name = "target",
			Description = "The players you want to affect.",
		},
		{
			Type = "number", -- lol
			Name = "Amount",
			Description = "How much money to set to.",
		},
	},
}
