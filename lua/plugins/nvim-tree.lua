return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				side = "left",
				width = 30,
				preserve_window_proportions = true,
				--float = {
				--enable = true
				--}
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
			git = {
				ignore = false,
			},
		})
	end,
}
