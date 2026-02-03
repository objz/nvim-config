vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
      end

      map("n", "<leader>cM", function() vim.cmd.RustLsp("expandMacro") end, "Expand Macro")
      map("n", "<leader>cE", function() vim.cmd.RustLsp("explainError") end, "Explain Error")
      map("n", "<leader>cB", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
      map("n", "<leader>cU", function() vim.cmd.RustLsp("runnables") end, "Runnables")
      map("n", "<leader>cC", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
      map("n", "<leader>cP", function() vim.cmd.RustLsp("parentModule") end, "Parent Module")
    end,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = true,
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        files = {
          excludeDirs = {
            ".direnv",
            ".git",
            ".github",
            ".gitlab",
            "bin",
            "node_modules",
            "target",
            "venv",
            ".venv",
          },
        },
      },
    },
  },
  dap = {
    adapter = require("config.dap.rust").adapter,
  },
}
