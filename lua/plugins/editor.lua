return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter",
    opts = function()
      local excluded = {
        noice = true,
        notify = true,
        alpha = true,
        dashboard = true,
        ["neo-tree"] = true,
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

      local function disable(_, buf)
        local ft = vim.bo[buf].filetype
        local bt = vim.bo[buf].buftype
        return bt ~= "" or excluded[ft]
      end

      return {
        highlight = {
          enable = true,
          disable = disable,
        },
        indent = {
          enable = true,
          disable = disable,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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

      vim.keymap.set("n", ".", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle line comment", noremap = false })
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
    opts = { useDefaultKeymaps = true },
  },
}
