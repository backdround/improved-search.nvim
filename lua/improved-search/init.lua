local utils = require("improved-search.utils")

local function search_current_word_without_moving()
  local current_word = vim.fn.expand("<cword>")
  if current_word == "" then
    return
  end

  -- Sets highlight
  vim.fn.setreg("/", current_word)
  vim.opt.hlsearch = true

  -- Sets cursor to the first character of the current_word
  -- (for next search conviniece).
  vim.fn.search(current_word, "ce")
  vim.fn.search(current_word, "cb")
end

local function search_stable_next()
  if vim.v.searchforward == 1 then
    utils.normal(vim.v.count1 .. "n")
  else
    utils.normal(vim.v.count1 .. "N")
  end
end

local function search_stable_previous()
  if vim.v.searchforward == 0 then
    utils.normal(vim.v.count1 .. "n")
  else
    utils.normal(vim.v.count1 .. "N")
  end
end

local function search_selected_text()
  -- Leaves visual mode
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)

  -- Gets text to search
  local selected_lines = utils.get_visual_selection_range()

  local special_symbols = "^$\\"
  if vim.api.nvim_get_option("magic") then
    special_symbols = "*^$.~[]\\"
  end

  for index, line in ipairs(selected_lines) do
    selected_lines[index] = vim.fn.escape(line, special_symbols)
  end
  local text_to_search = table.concat(selected_lines, "\\n")

  -- Sets cursor to left part of selected text (for next search conviniece)
  local start_row, start_column = utils.get_mark("<")
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_column })

  -- Sets the selected text as a search text
  vim.fn.setreg("/", text_to_search)
  vim.opt.hlsearch = true
end

-- "*" in visual mode, that can search multiline-pattern
local function search_selected_text_next()
  search_selected_text()
  search_stable_next()
end

-- "#" in visual mode, that can search multiline-pattern
local function search_selected_text_previous()
  search_selected_text()
  search_stable_previous()
end

return {
  current_word_without_moving = search_current_word_without_moving,
  stable_next = search_stable_next,
  stable_previous = search_stable_previous,
  selected_text = search_selected_text,
  selected_text_next = search_selected_text_next,
  selected_text_previous = search_selected_text_previous,
}
