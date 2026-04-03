return {
	"nickjvandyke/opencode.nvim",
	version = "*", -- Latest stable release
	dependencies = {
		{
			-- `snacks.nvim` integration is recommended, but optional
			---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(...) return require("opencode")
							.snacks_picker_send(...) end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any; goto definition on the type or field for details
		}

		vim.o.autoread = true -- Required for `opts.events.reload`

		-- Keymaps using <leader>o prefix (consistent with keymapping.lua style)
		vim.keymap.set({ "n", "x" }, "<leader>oa",
			function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Opencode: ask" })
		vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
			{ desc = "Opencode: select action" })
		vim.keymap.set("n", "<leader>ot", function() require("opencode").toggle() end,
			{ desc = "Opencode: toggle" })

		vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
			{ desc = "Opencode: add range", expr = true })
		vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
			{ desc = "Opencode: add line", expr = true })

		vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,
			{ desc = "Opencode: scroll up" })
		vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end,
			{ desc = "Opencode: scroll down" })
	end,
}
