-- change split buff focus
-- command mode on esc on shell
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

function hoverDocumentation()
	local custom_border = {
		{ "╭", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╮", "FloatBorder" },
		{ "│", "FloatBorder" },
		{ "╯", "FloatBorder" },
		{ "─", "FloatBorder" },
		{ "╰", "FloatBorder" },
		{ "│", "FloatBorder" },
	}

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = custom_border,
	})

	vim.lsp.buf.hover()
end
