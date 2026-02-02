local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<C-Up>", "<Cmd>resize -2<CR>", opts)
keymap("n", "<C-Down>", "<Cmd>resize +2<CR>", opts)
keymap("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", opts)

keymap("n", "H", "^", { desc = "Go to start of line" })
keymap("n", "L", "$", { desc = "Go to end of line" })
keymap("v", "H", "^", { desc = "Go to start of line" })
keymap("v", "L", "$", { desc = "Go to end of line" })

keymap("n", "<M-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer", noremap = true, silent = true })
keymap("n", "<M-l>", "<Cmd>bnext<CR>", { desc = "Next buffer", noremap = true, silent = true })
keymap("n", "<M-Left>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", noremap = true, silent = true })
keymap("n", "<M-Right>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", noremap = true, silent = true })
keymap("n", "<M-q>", function()
  require("mini.bufremove").delete(0, true)
end, { desc = "Delete buffer (force)", noremap = true, silent = true })

keymap("n", "<S-j>", "5j", { desc = "Scroll 5 lines down", noremap = true, silent = true })
keymap("n", "<S-k>", "5k", { desc = "Scroll 5 lines up", noremap = true, silent = true })

keymap("n", "<M-j>", "<Cmd>m .+1<CR>==", { desc = "Move line down", noremap = true, silent = true })
keymap("n", "<M-k>", "<Cmd>m .-2<CR>==", { desc = "Move line up", noremap = true, silent = true })
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down", noremap = true, silent = true })
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up", noremap = true, silent = true })

keymap("n", "<M-o>", "mao<ESC>`a", { desc = "New line below", noremap = true, silent = true })
keymap("n", "<M-O>", "maO<ESC>`a", { desc = "New line above", noremap = true, silent = true })

keymap("n", "|", "za", { desc = "Toggle fold", noremap = true, silent = true })

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "d", '"_d', { desc = "Delete without copying", noremap = true })
keymap("n", "D", '"_D', { desc = "Delete to end without copying", noremap = true })
keymap("n", "dd", '"_dd', { desc = "Delete line without copying", noremap = true })
keymap("n", "c", '"_c', { desc = "Change without copying", noremap = true })
keymap("n", "C", '"_C', { desc = "Change to end without copying", noremap = true })
keymap("n", "cc", '"_cc', { desc = "Change line without copying", noremap = true })

keymap("v", "v", "^o$", { desc = "Select current line", noremap = true, silent = true })
keymap("v", "x", '"+d', { desc = "Cut to system clipboard", noremap = true, silent = true })
keymap("v", "y", '"+y', { desc = "Copy to system clipboard", noremap = true, silent = true })
keymap("v", "p", '"+p', { desc = "Paste from system clipboard", noremap = true, silent = true })

keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

keymap("n", "<leader>h", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight", noremap = true, silent = true })

keymap("n", "<C-s>", "<Cmd>wall<CR>", { desc = "Save all files", noremap = true, silent = true })

keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

keymap("n", "<leader>vq", "<Cmd>q<CR>", { desc = "Quit", noremap = true, silent = true })
keymap("n", "<leader>vQ", "<Cmd>qa!<CR>", { desc = "Quit all without saving", noremap = true, silent = true })

keymap("n", "<leader>vv", "<Cmd>vsplit<CR>", { desc = "Split vertically", noremap = true, silent = true })
keymap("n", "<leader>vh", "<Cmd>split<CR>", { desc = "Split horizontally", noremap = true, silent = true })
keymap("n", "<leader>vs", "<Cmd>split<CR>", { desc = "Split window", noremap = true, silent = true })
keymap("n", "<leader>vx", "<Cmd>close<CR>", { desc = "Close split", noremap = true, silent = true })

keymap("n", "<leader>to", "<Cmd>tabnew<CR>", { desc = "New tab", noremap = true, silent = true })
keymap("n", "<leader>tx", "<Cmd>tabclose<CR>", { desc = "Close tab", noremap = true, silent = true })
keymap("n", "<leader>tn", "<Cmd>tabn<CR>", { desc = "Next tab", noremap = true, silent = true })
keymap("n", "<leader>tp", "<Cmd>tabp<CR>", { desc = "Previous tab", noremap = true, silent = true })

keymap("i", "<C-b>", "<C-o>b", { desc = "Move to previous word", noremap = true, silent = true })
keymap("i", "<C-w>", "<C-o>w", { desc = "Move to next word", noremap = true, silent = true })
keymap("i", "<C-c>", '<C-o>"_ciw', { desc = "Change word", noremap = true, silent = true })
keymap("i", "<C-d>", '<C-o>"_diw', { desc = "Delete word", noremap = true, silent = true })
keymap("i", "<M-j>", "<ESC><Cmd>m .+1<CR>==gi", { desc = "Move line down", noremap = true, silent = true })
keymap("i", "<M-k>", "<ESC><Cmd>m .-2<CR>==gi", { desc = "Move line up", noremap = true, silent = true })
