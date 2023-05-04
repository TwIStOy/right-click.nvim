local M = {}

local default_config = {
  highlight = {
    normal = nil,
    key = "@variable.builtin",
  },
  popup = {
    border = {
      style = "single",
      highlight = "FloatBorder",
      padding = { top = 0, bottom = 0, left = 1, right = 1 },
    },
    win_options = {
      winblend = 0,
      winhighlight = "NormalSB:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine",
    },
  },
  expandable_sign = " ▶",
}

M.config = {}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", default_config, opts or {})
end

return M
