local M = {}

local function search_current(strict)
  local current_word = vim.fn.expand("<cword>")
  if current_word == "" then
    return
  end

  local search_pattern = current_word
  if strict then
    search_pattern = "\\<" .. search_pattern .. "\\>"
  end

  -- Sets highlight
  vim.fn.setreg("/", search_pattern)
  vim.opt.hlsearch = true

  -- Sets cursor to the first character of the current_word
  -- (for next search conviniece).
  vim.fn.search(search_pattern, "ce")
  vim.fn.search(search_pattern, "cb")
end

M.search = function()
  search_current(false)
end

M.search_strict = function()
  search_current(true)
end

return M
