-- Telescope
-- Configure keymaps for telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>p", builtin.find_files, {})
vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})

vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", {})
vim.keymap.set("n", "<leader>hd", ":lua hoverDocumentation()<CR>", {})
-- NvimTree
-- Toggle NvimTree
vim.api.nvim_set_keymap("n", "<leader>t", ":NvimTreeToggle<CR>", {
	noremap = true,
	silent = true,
})
-- Refresh NvimTree
vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", {
	noremap = true,
	silent = true,
})

-- Flutter

-- Command to trigger running all Flutter tools
vim.api.nvim_set_keymap("n", "<leader>far", ":lua flutter_attach_setup()<CR>", {
	noremap = true,
	silent = true,
})
--vim.api.nvim_set_keymap("n", "<leader>fr", ":lua flutter_hot_reload()<CR>", {
--noremap = true,
--silent = true,
--})
--vim.api.nvim_set_keymap("n", "<leader>ffr", ":lua flutter_hot_restart()<CR>", {
--noremap = true,
--silent = true,
--})
--vim.api.nvim_set_keymap("n", "<leader>faq", ":lua flutter_quit_app()<CR>", {
--noremap = true,
--silent = true,
--})
vim.api.nvim_set_keymap("n", "<leader>fe", ":lua show_flutter_emulators()<CR>", { noremap = true, silent = true })

-- Clear search
vim.api.nvim_set_keymap("n", "<leader>cs", ":nohlsearch<CR>", {})

-- dap
vim.api.nvim_set_keymap("n", "<leader>br", ":lua require'dap'.toggle_breakpoint()<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>dc", ":lua start_dap()<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>do", ":lua require'dapui'.toggle()<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>faq", ":lua require'dap'.terminate()<CR>", {})

-- window resize
vim.api.nvim_set_keymap("n", "<leader>-", ":vertical resize -5<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>=", ":vertical resize +5<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>rj", ":horizontal resize +5<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>rk", ":horizontal resize -5<CR>", {})
---
vim.api.nvim_set_keymap("n", "<leader>w", "<C-w>w", {
	noremap = true,
	silent = true,
})

---formatting
vim.api.nvim_set_keymap("n", "<Leader>df", [[:lua vim.lsp.buf.format()<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>ft", ":Lspsaga term_toggle<CR>", {
	noremap = true,
	silent = true,
})
-- load previous/last buffer
vim.api.nvim_set_keymap("n", "<leader>ll", ":b#<CR>", {
	noremap = true,
	silent = true,
})

-- CodeCompanion
vim.api.nvim_set_keymap("n", "<leader>ch", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true })
