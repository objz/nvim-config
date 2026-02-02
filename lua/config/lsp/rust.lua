vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
      end

      map("n", "<leader>cua", function() vim.cmd.RustLsp("codeAction") end, "[Rust] Code Action")
      map("n", "<leader>cuh", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "[Rust] Hover Actions")
      map("n", "<leader>cue", function() vim.cmd.RustLsp("expandMacro") end, "[Rust] Expand Macro")
      map("n", "<leader>cuE", function() vim.cmd.RustLsp("explainError") end, "[Rust] Explain Error")
      map("n", "<leader>cud", function() vim.cmd.RustLsp("debuggables") end, "[Rust] Debuggables")
      map("n", "<leader>cur", function() vim.cmd.RustLsp("runnables") end, "[Rust] Runnables")
      map("n", "<leader>cuc", function() vim.cmd.RustLsp("openCargo") end, "[Rust] Open Cargo.toml")
      map("n", "<leader>cup", function() vim.cmd.RustLsp("parentModule") end, "[Rust] Parent Module")
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

