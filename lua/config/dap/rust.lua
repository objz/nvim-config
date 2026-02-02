local M = {}

M.adapter = function()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
  if not vim.uv.fs_stat(mason_path) then
    vim.notify("codelldb is not installed. Run :MasonInstall codelldb", vim.log.levels.WARN)
    return nil
  end

  local extension_path = mason_path .. "/extension/"
  
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

  local cfg = require("rustaceanvim.config")
  return cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
end

return M
