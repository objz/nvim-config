vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        local hl = vim.hl or vim.highlight
        local highlight_op = hl.hl_op or hl.on_yank
        highlight_op({ timeout = 200 })
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

do
    local lsp_progress_tokens = {}

    vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
            local value = ev.data.params.value or {}
            local token = ev.data.params.token
            local client_id = ev.data.client_id
            local key = client_id .. ":" .. tostring(token)

            if value.kind == "begin" then
                lsp_progress_tokens[key] = { pct = 0, title = value.title or "" }
            elseif value.kind == "report" then
                if lsp_progress_tokens[key] then
                    lsp_progress_tokens[key].pct = value.percentage or lsp_progress_tokens[key].pct
                end
            elseif value.kind == "end" then
                lsp_progress_tokens[key] = nil
            end

            local total, count = 0, 0
            for _, v in pairs(lsp_progress_tokens) do
                total = total + (v.pct or 0)
                count = count + 1
            end

            local is_done = count == 0
            local pct = is_done and 100 or (count > 0 and math.floor(total / count) or 0)
            local msg = is_done and "done" or (value.title or value.message or "loading")
            if #msg > 40 then
                msg = msg:sub(1, 37) .. "..."
            end

            vim.api.nvim_echo({ { msg } }, false, {
                source = "lsp",
                id = "lsp-progress",
                kind = "progress",
                title = "LSP",
                status = is_done and "success" or "running",
                percent = pct,
            })
        end,
    })
end
