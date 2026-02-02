vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close with q",
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = { "help", "qf", "man", "notify", "lspinfo", "startuptime", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Resize splits on terminal resize",
  group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Go to last cursor position",
  group = vim.api.nvim_create_augroup("last-position", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if file changed outside Neovim",
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  command = "checktime",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Disable diagnostics in insert mode",
  group = vim.api.nvim_create_augroup("diagnostics-insert", { clear = true }),
  callback = function(event)
    vim.diagnostic.hide(nil, event.buf)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Enable diagnostics when leaving insert mode",
  group = vim.api.nvim_create_augroup("diagnostics-insert", { clear = false }),
  callback = function(event)
    vim.diagnostic.show(nil, event.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto-create directories on save",
  group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
