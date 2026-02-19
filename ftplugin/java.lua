-- Find root directory for the project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java-workspace/' .. project_name

-- Configuration for jdtls (eclipse.jdt.ls)
local config = {
    -- The command to start the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        -- Using Homebrew OpenJDK (Java 25)
        '/opt/homebrew/opt/openjdk/bin/java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- 💀 Replace this with the path to your jdtls installation
        -- Example for Homebrew on macOS:
        -- '-jar', '/opt/homebrew/Cellar/jdtls/VERSION/libexec/plugins/org.eclipse.equinox.launcher_VERSION.jar',
        -- '-configuration', '/opt/homebrew/Cellar/jdtls/VERSION/libexec/config_mac',

        -- Example for Linux:
        -- '-jar', '/path/to/jdtls/plugins/org.eclipse.equinox.launcher_VERSION.jar',
        -- '-configuration', '/path/to/jdtls/config_linux',

        '-jar', vim.fn.glob('/opt/homebrew/opt/jdtls/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', '/opt/homebrew/opt/jdtls/libexec/config_mac_arm',

        '-data', workspace_dir,
    },

    -- Root directory detection
    -- See: https://neovim.io/doc/user/lsp.html#vim.lsp.start()
    root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                useBlocks = true,
            },
            -- Configure different Java runtimes if needed
            -- configuration = {
            -- 	runtimes = {
            -- 		{
            -- 			name = "JavaSE-11",
            -- 			path = "/usr/lib/jvm/java-11-openjdk/",
            -- 		},
            -- 		{
            -- 			name = "JavaSE-17",
            -- 			path = "/usr/lib/jvm/java-17-openjdk/",
            -- 		},
            -- 	}
            -- }
        }
    },

    -- Language server `initializationOptions`
    -- You'll need to extend `bundles` with the path to jar files
    -- if you want to use additional eclipse.jdt.ls plugins like java-debug.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    init_options = {
        bundles = {}
    },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

-- Set up key mappings for jdtls
local opts = { noremap = true, silent = true, buffer = true }

-- Organize imports
vim.keymap.set('n', '<leader>jo', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)

-- Extract variable
vim.keymap.set('n', '<leader>jv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
vim.keymap.set('v', '<leader>jv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)

-- Extract constant
vim.keymap.set('n', '<leader>jc', "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
vim.keymap.set('v', '<leader>jc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)

-- Extract method
vim.keymap.set('v', '<leader>jm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

-- Test class/method (if using nvim-dap)
vim.keymap.set('n', '<leader>jt', "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
vim.keymap.set('n', '<leader>jn', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
