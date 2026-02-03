require("config.lsp.handlers").setup()

local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
})

local servers = {
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh" },
  },

  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },

  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml" },
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },

  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "md" },
  },

  kotlin_language_server = {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true, noremap = true })
    end

    map("n", "<leader>cd", vim.lsp.buf.definition, "Go to Definition")
    map("n", "<leader>cD", vim.lsp.buf.declaration, "Go to Declaration")
    map("n", "<leader>ci", vim.lsp.buf.implementation, "Go to Implementation")
    map("n", "<leader>ct", vim.lsp.buf.type_definition, "Type Definition")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>ch", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature Help")
    map("n", "<leader>cR", vim.lsp.buf.references, "References")

    map("n", "<leader>cw", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

    map("n", "<leader>xn", vim.diagnostic.goto_next, "Next Diagnostic")
      map("n", "<leader>xp", vim.diagnostic.goto_prev, "Previous Diagnostic")

      if client and client.supports_method and client.supports_method("textDocument/inlayHint") then
        map("n", "<leader>uh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, "Toggle Inlay Hints")
      end

    if client and client.supports_method and client.supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("LSPHighlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
