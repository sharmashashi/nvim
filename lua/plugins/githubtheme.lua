-- Or with configuration
return {
	'projekt0n/github-nvim-theme',
	name = 'github-theme',
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- Default options
		require('github-theme').setup({
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath('cache') .. '/github-theme',
				compile_file_suffix = '_compiled', -- Compiled file suffix
				hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
				hide_nc_statusline = true, -- Override the underline style for non-active statuslines
				transparent = false, -- Disable setting bg (make neovim's background transparent)
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = true, -- Non focused panes set to alternative background
				module_default = true, -- Default enable value for modules
				styles = { -- Style to be applied to different syntax groups
					comments = 'underdashed', -- Value is any valid attr-list value `:help attr-list`
					functions = 'italic',
					keywords = 'italic,bold',
					variables = 'NONE',
					conditionals = 'NONE',
					constants = 'NONE',
					numbers = 'NONE',
					operators = 'NONE',
					strings = 'NONE',
					types = 'bold',
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				darken = { -- Darken floating windows and sidebar-like windows
					floats = true,
					sidebars = {
						enable = true,
						list = {}, -- Apply dark background to specific windows
					},
				},
				modules = { -- List of various plugins and additional options
					-- ...
				},
			},
			palettes = {},
			specs = {},
			groups = {
			},
		})

		vim.cmd('colorscheme github_dark_colorblind')
	end,
}
