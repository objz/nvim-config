local dap = require("dap")
local dapui = require("dapui")

local M = {}

M.setup = function()
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, noremap = true })
  end

  map("n", "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
  map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "Conditional Breakpoint")
  map("n", "<leader>dc", dap.continue, "Continue")
  map("n", "<leader>di", dap.step_into, "Step Into")
  map("n", "<leader>do", dap.step_over, "Step Over")
  map("n", "<leader>dO", dap.step_out, "Step Out")
  map("n", "<leader>dr", dap.repl.open, "Open REPL")
  map("n", "<leader>dl", dap.run_last, "Run Last")
  map("n", "<leader>dt", dap.terminate, "Terminate")
  map("n", "<leader>du", dapui.toggle, "Toggle UI")
  map("n", "<leader>dh", require("dap.ui.widgets").hover, "Hover")
  map("n", "<leader>de", function() require("dapui").eval() end, "Evaluate")

  require("mason-nvim-dap").setup({
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      "codelldb", 
    },
  })
end

M.setup()

return M
