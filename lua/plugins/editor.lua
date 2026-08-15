return {
    {
        -- `main` is the default branch now; its API is setup/install + vim.treesitter.start
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
            -- puts mason's bin (and with it the tree-sitter CLI) on PATH before we install
            "williamboman/mason.nvim",
        },
        config = function()
            require("nvim-treesitter").setup()

            local ensure_installed = {
                "bash", "c", "css", "diff", "gitcommit", "gitignore", "html", "java", "javascript",
                "json", "kotlin", "lua", "luadoc", "markdown", "markdown_inline", "python",
                "query", "regex", "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
            }
            -- the `main` branch builds parsers with the tree-sitter CLI (mason installs it)
            if vim.fn.executable("tree-sitter") == 0 then
                vim.notify("tree-sitter CLI missing; run :MasonInstall tree-sitter-cli", vim.log.levels.WARN)
            else
                local installed = require("nvim-treesitter.config").get_installed("parsers")
                local missing = vim.tbl_filter(function(lang)
                    return not vim.tbl_contains(installed, lang)
                end, ensure_installed)
                if #missing > 0 then
                    require("nvim-treesitter").install(missing)
                end
            end

            local excluded = {
                noice = true,
                notify = true,
                alpha = true,
                dashboard = true,
                ["neo-tree"] = true,
                ["neo-tree-popup"] = true,
                Trouble = true,
                trouble = true,
                lazy = true,
                mason = true,
                help = true,
                checkhealth = true,
                man = true,
                lspinfo = true,
                qf = true,
                query = true,
                TelescopePrompt = true,
                TelescopeResults = true,
                terminal = true,
                toggleterm = true,
                themery = true,
                [""] = true,
            }

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
                callback = function(event)
                    local buf, ft = event.buf, vim.bo[event.buf].filetype
                    if excluded[ft] or vim.bo[buf].buftype ~= "" then
                        return
                    end
                    -- pcall covers both bundled and nvim-treesitter parsers, and no parser at all
                    if not pcall(vim.treesitter.start, buf) then
                        return
                    end
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
        },
    },

    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
            })
        end,
    },

    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("Comment").setup()

            vim.keymap.set("n", ".", "<Plug>(comment_toggle_linewise_current)",
                { desc = "Toggle line comment", noremap = false })
            vim.keymap.set("v", ".", "gc", { desc = "Toggle block comment", noremap = false, remap = true })
        end,
    },

    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
        end,
    },

    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        opts = { keymaps = { useDefaults = true } },
    },
}
