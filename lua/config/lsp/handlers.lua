local M = {}

--- blink.cmp completion + nvim-file-operations workspace/*Files support
M.capabilities = function()
    return require("blink.cmp").get_lsp_capabilities(
        require("nvim-file-operations.config").default_capabilities()
    )
end

M.setup = function()
    vim.o.winborder = "rounded"

    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            source = true,
            header = "",
            prefix = "",
        },
    })
end

return M
