local EnabledOptions = require("right-click.database.enabled_options")

---@class SectionDB
---@field sections table<number,SectionInfo>
local Db = {}

---@class NewSectionOptions
---@field index number|nil
---@field items table<number,MenuItemOptions>
---@field enabled SectionEnabledOptions|nil
local NewSectionOptions = {}

---@class SectionInfo
---@field index number|nil
---@field items table<number,MenuItemOptions>
---@field enabled fun(number,string,string):boolean
local SectionInfo = {}

---@param opts NewSectionOptions
function Db:add_section(opts)
  local info = {
    index = opts.index,
    items = opts.items,
    enabled = EnabledOptions(opts.enabled),
  }
  setmetatable(info, { __index = SectionInfo })
  self.sections[#self.sections + 1] = info
end

function Db:show()
  local ContextMenu = require("right-click.components.menu")
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo.filetype
  local filename = vim.fn.expand("%:t")
  ---@type SectionInfo[]
  local opts = {}
  for _, section in ipairs(self.sections) do
    if section.enabled(buf, ft, filename) then
      table.insert(opts, section)
    end
  end
  table.sort(opts, function(a, b)
    local a_index = a.index or 0
    local b_index = b.index or 0
    return a_index < b_index
  end)
  local res = {}
  for _, section in ipairs(opts) do
    if #res > 0 then
      table.insert(res, { "---" })
    end
    vim.list_extend(res, section.items)
  end
  if #res > 0 then
    local menu = ContextMenu(res)
    menu:as_nui_menu():mount()
  else
    vim.notify("No right-click menu items available")
  end
end

local M = {}

function M.new_db()
  local db = {
    sections = {},
  }
  setmetatable(db, { __index = Db })
  return db
end

return M
