function OpenDefaultShell()
	vim.cmd("set splitright")
	vim.cmd(":vsplit | term")
end

vim.api.nvim_set_keymap("n", "<Leader>sh", ":lua OpenDefaultShell()<CR>", { noremap = true, silent = true })
