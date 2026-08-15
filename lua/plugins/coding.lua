return {
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.lib" },
        build = function() require('blink.cmp').build():wait(60000) end,
        opts = {
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            signature = { enabled = true },
        },
        opts_extend = {
            "sources.default",
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            require("config.lsp.setup")
            require("config.lsp.jdtls")
        end,
    },

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        opts = {
            ensure_installed = {
                "jdtls",
                "kotlin_language_server",
                "rust_analyzer",
                "lua_ls",
                "bashls",
                "jsonls",
                "yamlls",
                "marksman",
            },
            -- v2 renamed this; leaving it as `automatic_installation` silently enabled
            -- rust_analyzer/jdtls a second time on top of rustaceanvim and nvim-jdtls.
            automatic_enable = {
                exclude = { "rust_analyzer", "jdtls" },
            },
        },
    },

    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            use_diagnostic_signs = true,
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cS", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
        },
    },

    { "mfussenegger/nvim-jdtls", lazy = true },

    {
        "mrcjkb/rustaceanvim",
        version = "^9",
        lazy = false,
        config = function()
            require("config.lsp.rust")
        end,
    },
}
