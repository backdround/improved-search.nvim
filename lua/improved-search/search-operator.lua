-- The purpose of the file is to define the global "search operator"

--# selene: allow(unscoped_variables)
--# selene: allow(unused_variable)

---Provides the position of the given mark.
---@param mark string a vim's mark name.
---@return number line
---@return number column
local function get_mark(mark)
  return unpack(vim.api.nvim_buf_get_mark(0, mark))
end

---Provides selected by the operator lines
---@param motion_type "line" | "char" | "block" a user's motion type over text.
---@return string[] @ subjected lines
local function get_subjected_lines(motion_type)
  local start_line, start_column = get_mark("[")
  local end_line, end_column = get_mark("]")

  if motion_type == "line" then
    return vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)

  elseif motion_type == "char" then
    return vim.api.nvim_buf_get_text(
      0,
      start_line - 1,
      start_column,
      end_line - 1,
      end_column + 1,
      {}
    )

  elseif motion_type == "block" then
    local selected_lines =
      vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
    for i, line in ipairs(selected_lines) do
      selected_lines[i] = line:sub(start_column + 1, end_column + 1)
    end
    return selected_lines
  end

  error("Unknown line's selection type: " .. motion_type)
end

---@class Search_operator_behavior It's a global search operator configuration.
---@field strict boolean whether search strict pattern (with word-boundaries) or not.
---@field do_after function | nil function that is performed after the search operator.
Improved_search_operator_behaviour = {
  strict = false,
  do_after = nil,
}

---Search operator. It searchs a pattern of text that is given by a motion.
---@param motion_type "line" | "char" | "block" a user's motion type over text.                                       .
function Improved_search_operator(motion_type)
  -- Leave visual mode
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)

  -- Get text to search
  local selected_lines = get_subjected_lines(motion_type)

  -- Choose special symbols to escape
  local special_symbols = "^$\\"
  if vim.api.nvim_get_option("magic") then
    special_symbols = "*^$.~[]\\"
  end

  -- Escape all special_symbols
  for index, line in ipairs(selected_lines) do
    selected_lines[index] = vim.fn.escape(line, special_symbols)
  end

  -- Join all lines to text for the searching
  local pattern_to_search = table.concat(selected_lines, "\\n")
  if motion_type == "line" then
    pattern_to_search = "^" .. pattern_to_search .. "\\n"
  elseif motion_type == "block" then
    pattern_to_search = ".*" .. table.concat(selected_lines, ".*\\n.*") .. ".*"
  end

  -- Use strict pattern search.
  if Improved_search_operator_behaviour.strict then
    pattern_to_search = "\\<" .. pattern_to_search .. "\\>"
  end

  -- Set cursor to left part of selected text (for next search conviniece)
  local start_row, start_column = get_mark("[")
  vim.api.nvim_win_set_cursor(0, { start_row, start_column })

  -- Set the selected text as a search text
  vim.fn.setreg("/", pattern_to_search)
  vim.opt.hlsearch = true

  if Improved_search_operator_behaviour.do_after then
    Improved_search_operator_behaviour.do_after()
  end
end
