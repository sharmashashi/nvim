return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>e",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>gi",
			"<cmd>Trouble lsp_implementations toggle<cr>",
			desc = "Go to Implementations",
		},
		{
			"<leader>gd",
			"<cmd>Trouble lsp_definitions toggle<cr>",
			desc = "Go to Definitions",
		},
		{
			"<leader>li",
			"<cmd>Trouble lsp_references toggle<cr>",
			desc = "Go to Usage",
		},
	},
}
