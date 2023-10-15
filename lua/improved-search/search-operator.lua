--# selene: allow(unscoped_variables)
--# selene: allow(unused_variable)

local function get_mark(mark)
  return unpack(vim.api.nvim_buf_get_mark(0, mark))
end

local function get_visual_selection_range(selection_type)
  local start_row, start_column = get_mark("[")
  local end_row, end_column = get_mark("]")

  if selection_type == "line" then
    return vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)
  elseif selection_type == "char" then
    return vim.api.nvim_buf_get_text(
      0,
      start_row - 1,
      start_column,
      end_row - 1,
      end_column + 1,
      {}
    )
  elseif selection_type == "block" then
    local selected_lines =
      vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)
    for i, line in ipairs(selected_lines) do
      selected_lines[i] = line:sub(start_column + 1, end_column + 1)
    end
    return selected_lines
  end
end

Improved_search_operator_behavior = {
  strict = false,
  do_after = nil,
}

function Improved_search_operator(selection_type)
  -- Leaves visual mode
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)

  -- Gets text to search
  local selected_lines = get_visual_selection_range(selection_type)

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
  if selection_type == "line" then
    pattern_to_search = "^" .. pattern_to_search .. "\\n"
  elseif selection_type == "block" then
    pattern_to_search = ".*" .. table.concat(selected_lines, ".*\\n.*") .. ".*"
  end

  if Improved_search_operator_behavior.strict then
    pattern_to_search = "\\<" .. pattern_to_search .. "\\>"
  end

  -- Sets cursor to left part of selected text (for next search conviniece)
  local start_row, start_column = get_mark("[")
  vim.api.nvim_win_set_cursor(0, { start_row, start_column })

  -- Sets the selected text as a search text
  vim.fn.setreg("/", pattern_to_search)
  vim.opt.hlsearch = true

  if Improved_search_operator_behavior.do_after then
    Improved_search_operator_behavior.do_after()
  end
end
