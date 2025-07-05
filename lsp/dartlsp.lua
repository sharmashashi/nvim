local function is_dart_project()
	local result = vim.fn.glob("pubspec.yaml") ~= ""
	return result
end

if is_dart_project() then
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	require("lspconfig").dartls.setup({
		capabilities = capabilities,
	})
end
