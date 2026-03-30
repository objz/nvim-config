return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "TermExec", "TermNew", "TermSelect", "ToggleTermToggleAll" },
        keys = {
            { "<F6>",       "<cmd>ToggleTerm<cr>",                            desc = "Toggle Terminal",  mode = { "n", "t" } },
            { "<leader>tt", "<cmd>ToggleTerm<cr>",                            desc = "Toggle Terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",            desc = "Float Terminal" },
            { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
            { "<leader>ta", "<cmd>TermNew<cr>",                               desc = "New Terminal" },
            { "<leader>ts", "<cmd>TermSelect<cr>",                            desc = "Select Terminal" },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = "horizontal",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            vim.api.nvim_create_autocmd("TermOpen", {
                pattern = "term://*toggleterm#*",
                callback = function()
                    local map_opts = { buffer = 0, silent = true }
                    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], map_opts)
                    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
                    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
                    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
                    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
                end,
            })
        end,
    },

    {
        "nickjvandyke/opencode.nvim",
        version = "*",
        keys = {
            { "<leader>oo", function() require("opencode").toggle() end,       desc = "Toggle OpenCode",  mode = { "n", "t" } },
            { "<leader>oa", function() require("opencode").ask("@this: ") end, desc = "Ask OpenCode",     mode = { "n", "x" } },
            { "<leader>os", function() require("opencode").select() end,       desc = "OpenCode Actions", mode = { "n", "x" } },
        },
        init = function()
            vim.o.autoread = true
        end,
    },
}
