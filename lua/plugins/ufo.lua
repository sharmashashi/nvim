return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'FileType',
    config = function()
        -- Set up fold options
        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        -- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'

        -- Setup ufo with LSP provider
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }
        vim.g.ufo_capabilities = capabilities

        require('ufo').setup({
            open_fold_hl_timeout = 150,
            close_fold_kinds_for_ft = {
                default = { 'imports', 'comment' },
            },
            provider_selector = function(bufnr, filetype, buftype)
                return { 'lsp', 'indent' }
            end,
        })

        -- Keymaps for folding
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { noremap = true })
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { noremap = true })
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { noremap = true })
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { noremap = true })

        -- Preview on K key, fallback to hover
        vim.keymap.set('n', 'K', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                vim.lsp.buf.hover()
            end
        end, { noremap = true })
    end,
}
