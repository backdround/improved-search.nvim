local M = {}

M.normal = function(...)
  local cmd = {
    cmd = "normal",
    bang = true,
    args = { ... },
  }

  local success, err = pcall(vim.api.nvim_cmd, cmd, {})

  -- Prints error without file context
  if not success then
    err = err:gsub(".*Vim[^:]*:", "", 1)
    vim.api.nvim_err_writeln(err)
  end
end

M.get_mark = function(mark)
  local line, column = unpack(vim.api.nvim_buf_get_mark(0, mark))

  -- Checks that column unsigned(-1)
  local line_string = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  if column > line_string:len() then
    column = line_string:len()
  end

  return line - 1, column
end

M.get_visual_selection_range = function()
  local start_row, start_column = M.get_mark("<")
  local end_row, end_column = M.get_mark(">")
  local selected_lines = vim.api.nvim_buf_get_text(
    0,
    start_row,
    start_column,
    end_row,
    end_column + 1,
    {}
  )
  return selected_lines
end

return M
