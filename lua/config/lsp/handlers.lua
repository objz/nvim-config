local M = {}

M.setup = function()
    local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
    }

    for type, icon in pairs(signs) do
        local name = "DiagnosticSign" .. type
        vim.fn.sign_define(name, { texthl = name, text = icon, numhl = "" })
    end

    vim.o.winborder = "rounded"

    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
        },
    })
end

return M
