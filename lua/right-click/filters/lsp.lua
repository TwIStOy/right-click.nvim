local M = {}

function M.lsp_attached(buf, _, _)
  local clients = vim.lsp.get_active_clients {
    bufnr = buf,
  }
  return #clients > 0
end

return M
