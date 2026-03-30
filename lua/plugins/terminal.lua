return {
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "TermExec", "ToggleTermToggleAll" },
        keys = {
            { "<F6>",       "<cmd>ToggleTerm<cr>",                            desc = "Toggle Terminal",  mode = { "n", "t" } },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",            desc = "Float Terminal" },
            { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
            {
                "<leader>ta",
                function()
                    require("toggleterm.terminal").Terminal:new():toggle()
                end,
                desc = "New Terminal",
            },
            {
                "<leader>ts",
                function()
                    local terms = require("toggleterm.terminal").get_all(true)
                    if #terms == 0 then
                        vim.notify("No terminals open", vim.log.levels.INFO)
                        return
                    end
                    vim.ui.select(terms, {
                        prompt = "Select Terminal",
                        format_item = function(term)
                            return string.format("#%d: %s", term.id, term.display_name or term.name or "terminal")
                        end,
                    }, function(choice)
                        if choice then choice:toggle() end
                    end)
                end,
                desc = "Select Terminal",
            },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
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
        "sudo-tee/opencode.nvim",
        cmd = "Opencode",
        keys = {
            { "<leader>og", function() require("opencode.api").toggle() end,     desc = "Toggle OpenCode" },
        },
        config = function()
            require("opencode").setup()
        end,
    },
}
