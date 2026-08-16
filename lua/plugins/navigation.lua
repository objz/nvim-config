return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            "s1n7ax/nvim-window-picker",
        },
        init = function()
            -- lazy-loaded plugins miss `nvim <dir>`, so load it ourselves in that case
            if vim.fn.argc(-1) == 1 then
                local stat = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        keys = {
            { "<leader>e",  "<cmd>Neotree toggle reveal left<cr>",       desc = "Explorer" },
            { "<leader>E",  "<cmd>Neotree focus reveal left<cr>",        desc = "Explorer (focus file)" },
            { "<leader>fe", "<cmd>Neotree float reveal<cr>",             desc = "Explorer (float)" },
            { "<leader>ge", "<cmd>Neotree git_status left toggle<cr>",   desc = "Git Explorer" },
            { "<leader>be", "<cmd>Neotree buffers left toggle<cr>",      desc = "Buffer Explorer" },
        },
        opts = {
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_diagnostics = true,
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                hijack_netrw_behavior = "open_current",
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
            },
            window = {
                width = 32,
                mappings = {
                    -- <space> is the leader key; neo-tree grabs it by default
                    ["<space>"] = "none",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    -- <cr>/s/S keep neo-tree's defaults; the window picker stays on its
                    -- default `w`, since picking fails when the tree is the only window
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["O"] = "system_open",
                },
            },
            commands = {
                system_open = function(state)
                    vim.ui.open(state.tree:get_node().path)
                end,
            },
            default_component_configs = {
                indent = { with_expanders = true },
            },
        },
    },

    {
        "Crysthamus/nvim-file-operations",
        event = "VeryLazy",
        dependencies = {
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("nvim-file-operations").setup()
        end,
    },

    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        opts = {
            filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                bo = {
                    filetype = { "neo-tree", "neo-tree-popup", "notify" },
                    buftype = { "terminal", "quickfix" },
                },
            },
        },
        config = function(_, opts)
            require("window-picker").setup(opts)
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                enabled = vim.fn.executable("make") == 1,
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help Pages" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent Files" },
            { "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                   desc = "Keymaps" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>",               desc = "Grep Word" },
            { "<leader>gc", "<cmd>Telescope git_commits<cr>",               desc = "Git Commits" },
            { "<leader>gt", "<cmd>Telescope git_status<cr>",                desc = "Git Status" },
        },
        opts = {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                mappings = {
                    i = {
                        ["<C-j>"] = function(...)
                            return require("telescope.actions").move_selection_next(...)
                        end,
                        ["<C-k>"] = function(...)
                            return require("telescope.actions").move_selection_previous(...)
                        end,
                    },
                },
            },
        },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
}
