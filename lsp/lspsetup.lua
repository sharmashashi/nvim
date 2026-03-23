require("mason").setup()
require("mason-lspconfig").setup()

-- Add folding range capability for ufo plugin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

require 'lspconfig'.lua_ls.setup({ capabilities = capabilities })
require 'lspconfig'.pylsp.setup({ capabilities = capabilities })
require 'lspconfig'.ruby_lsp.setup({ capabilities = capabilities })
require 'lspconfig'.ts_ls.setup({ capabilities = capabilities })
require 'lspconfig'.bashls.setup({ capabilities = capabilities })
require 'lspconfig'.kotlin_language_server.setup({ capabilities = capabilities })
require 'lspconfig'.swift_mesonls.setup({ capabilities = capabilities })
require 'lspconfig'.clangd.setup({ capabilities = capabilities })
require("lsp.dartlsp")
require("lspconfig").lemminx.setup({ capabilities = capabilities })
