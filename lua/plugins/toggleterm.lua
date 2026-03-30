return {
	'akinsho/toggleterm.nvim',
	config = function()
		require("toggleterm").setup {
--			size = 20 | function(term)
--				if term.direction == "horizontal" then
--					return 15
--				elseif term.direction == "vertical" then
--					return vim.o.columns * 0.4
--				end
--			end,
			direction = 'float',
			open_mapping = [[<c-ft]],
			float_opts = {
				border = 'curved'
			}
		}
	end
}
