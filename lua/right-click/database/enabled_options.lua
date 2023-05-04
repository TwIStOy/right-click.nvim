---@class SectionEnabledOptions
---@field filetype table|string|nil expected filetype(s) for this section to be enabled
---@field filename table|string|nil expected filename(s) for this section to be enabled
---@field others nil|fun(number,string,string):boolean other options to match
local SectionEnabledOptions = {}

local function expect_in(filter)
  if filter == nil then
    return function()
      return true
    end
  end
  if type(filter) == "string" then
    return function(filetype)
      return filetype == filter
    end
  end
  if type(filter) == "table" and vim.tbl_isarray(filter) then
    return function(filetype)
      return vim.list_contains(filter, filetype)
    end
  end
end

---@param opts SectionEnabledOptions
return function(opts)
  if opts == nil then
    return function()
      return true
    end
  end

  local filetype = expect_in(opts.filetype)
  local filename = expect_in(opts.filename)
  local others = opts.others
  return function(buf, ft, fn)
    return filetype(ft)
      and filename(fn)
      and (others == nil or others(buf, ft, fn))
  end
end
