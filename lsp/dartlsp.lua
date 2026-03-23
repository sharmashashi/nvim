local function is_dart_project()
	local result = vim.fn.glob("pubspec.yaml") ~= ""
	return result
end

if is_dart_project() then
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- Add folding range capability for ufo plugin
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	require("lspconfig").dartls.setup({
		capabilities = capabilities,
	})
end
