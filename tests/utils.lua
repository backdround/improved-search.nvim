local M = {}

M.set_current_buffer = function(text)
  text = text or ""
  local lines = vim.fn.split(text, "\n")

  -- Clear current buffer
  local last_line_index = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(0, 0, last_line_index, true, {})

  -- Remove first line if empty
  if lines[1] and lines[1]:match("^[%s]*$") then
    table.remove(lines, 1)
  end

  -- Remove last line if empty
  if lines[#lines] and lines[#lines]:match("^[%s]*$") then
    table.remove(lines, #lines)
  end

  -- Find minimal prepending space gap
  local min_prepending_gap = lines[1]:match("^[%s]*"):len()
  for _, line in pairs(lines) do
    local prepending_gap = line:match("^[%s]*"):len()
    if prepending_gap > 0 and prepending_gap < min_prepending_gap then
      min_prepending_gap = prepending_gap
    end
  end

  -- Remove the prepending space gap
  for i, line in pairs(lines) do
    lines[i] = line:sub(min_prepending_gap + 1)
  end

  vim.api.nvim_buf_set_lines(0, 0, 1, true, lines)
end


M.set_cursor = function(line, column)
  vim.api.nvim_win_set_cursor(0, {line, column})
end

M.feedkeys = function(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_feedkeys(keys, "nx", false)
end

return M
