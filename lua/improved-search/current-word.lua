-- The file describes functions that search a word that is under the cursor
-- without moving. they work like "*" or "#", but won't move the cursor to
-- any directon.

local M = {}

---Search a word that is under the cursor (like "*" or "#", but without moving).
---@param strict boolean whether or not use '\<' and '\>' in the search pattern.
local function search_current(strict)
  local current_word = vim.fn.expand("<cword>")
  if current_word == "" then
    return
  end

  local search_pattern = current_word
  if strict then
    search_pattern = "\\<" .. search_pattern .. "\\>"
  end

  -- Set highlight
  vim.fn.setreg("/", search_pattern)
  vim.opt.hlsearch = true

  -- Set cursor to the first character of the current_word
  -- (for next search conviniece).
  vim.fn.search(search_pattern, "ce")
  vim.fn.search(search_pattern, "cb")
end

---Search a non-strict word (without word boundaries) that is under the cursor.
---It works like "g*" or "g#", but won't move the cursor.
M.search = function()
  search_current(false)
end

---Search a strict word (with word boundaries) that is under the cursor.
---It works like "*" or "#", but won't move the cursor.
M.search_strict = function()
  search_current(true)
end

return M
