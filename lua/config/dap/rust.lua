local M = {}

M.adapter = function()
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
    if not vim.uv.fs_stat(mason_path) then
        vim.notify("codelldb is not installed. Run :MasonInstall codelldb", vim.log.levels.WARN)
        return false
    end

    local extension_path = mason_path .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    return {
        type = "server",
        port = "${port}",
        host = "127.0.0.1",
        executable = {
            command = codelldb_path,
            args = { "--liblldb", liblldb_path, "--port", "${port}" },
        },
    }
end

return M
