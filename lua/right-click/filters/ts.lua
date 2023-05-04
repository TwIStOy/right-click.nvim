local M = {}

function M.ts_attached(buf, _, _)
  local highlighter = require("vim.treesitter.highlighter")
  if highlighter.active[buf] then
    return true
  else
    return false
  end
end

return M
