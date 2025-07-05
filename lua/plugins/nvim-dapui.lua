return {
	"rcarriga/nvim-dap-ui",
	requires = { "mfussenegger/nvim-dap" },
	config = function()
		require("dapui").setup({
			layouts = {
				--{
					--elements = { "breakpoints", "scopes" },
					--position = "right",
					--size = 0.15,
				--},
				{
					elements = { "repl" },
					position = "right",
					size = 0.25,
				},
			},
		})
	end,
}
