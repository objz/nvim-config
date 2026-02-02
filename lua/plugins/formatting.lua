return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua",
                "black",
                "isort",
                "prettierd",
                "shfmt",
                "google-java-format",
                "ktlint",
                "eslint_d",
                "pylint",
                "markdownlint",
                "shellcheck",
            },
            auto_update = true,
            run_on_start = true,
        },
    },

    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
                bash = { "shfmt" },
                rust = { "rustfmt" },
                java = { "google-java-format" },
                kotlin = { "ktlint" },
            },
            -- format_on_save = function(bufnr)
            --   local ignore_filetypes = { "sql", "java" }
            --   if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            --     return
            --   end
            --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            --     return
            --   end
            --   local bufname = vim.api.nvim_buf_get_name(bufnr)
            --   if bufname:match("/node_modules/") then
            --     return
            --   end
            --   return { timeout_ms = 500, lsp_fallback = true }
            -- end,
        },
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                python = { "pylint" },
                markdown = { "markdownlint" },
                bash = { "shellcheck" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
