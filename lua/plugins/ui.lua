return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  /' __` __`\ ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \ /\ \/\ \/\ \]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/ \/_/\/_/\/_/]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Find Text", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  Config", ":cd " .. vim.fn.stdpath("config") .. " <CR>:Telescope find_files<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
      dashboard.section.footer.val = nvim_version_info

      dashboard.config.opts.noautocmd = true
      vim.cmd([[autocmd User AlphaReady echo 'ready']])

      alpha.setup(dashboard.config)
    end,
  },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "sonokai",
          "tokyonight",
          "catppuccin",
          "kanagawa",
          "rose-pine",
          "nightfox",
          "nord",
          "dracula",
          "github_dark",
          "onedark",
          "darkplus",
          "vscode",
          "gruvbox",
          "everforest",
          "edge",
          "gruvbox-material",
          "material",
        },
        livePreview = true,
      })
    end,
  },

  { "sainnhe/sonokai", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "lunarvim/darkplus.nvim", lazy = true },
  { "Mofiqul/vscode.nvim", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "sainnhe/edge", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    },
    opts = {
      options = {
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { Error = " ", Warn = " ", Info = " ", Hint = " " }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      icons = {
        group = "",
        separator = " ",
        breadcrumb = " ",
        ellipsis = " ",
        colors = true,
      },
      spec = {
        { "<leader>f", group = "Find", desc = "Search and navigate", icon = { cat = "extension", name = "md" } },
        { "<leader>c", group = "Code", desc = "LSP actions", icon = { cat = "extension", name = "sh" } },
        { "<leader>cj", group = "Java", desc = "JDTLS actions", icon = { cat = "extension", name = "java" } },
        { "<leader>cu", group = "Rust", desc = "Rust tools", icon = { cat = "extension", name = "rs" } },
        { "<leader>d", group = "Debug", desc = "Debugging", icon = { cat = "extension", name = "json" } },
        { "<leader>g", group = "Git", desc = "Git actions", icon = { cat = "extension", name = "diff" } },
        { "<leader>S", group = "Session", desc = "Session management", icon = { cat = "extension", name = "vim" } },
        { "<leader>v", group = "View", desc = "Window and layout", icon = { cat = "extension", name = "png" } },
        { "<leader>x", group = "Diagnostics", desc = "Diagnostics lists", icon = { cat = "extension", name = "log" } },
        { "<leader>u", group = "UI", desc = "Interface options", icon = { cat = "extension", name = "vim" } },
        { "<leader>b", hidden = true },
        { "<leader>t", hidden = true },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            any = {
              { find = "nvim%-treesitter" },
              { find = "Compiling parser" },
              { find = "Downloading tree%-sitter" },
              { find = "Language installed" },
            },
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = {
      default = true,
      strict = true,
    },
  },
}
