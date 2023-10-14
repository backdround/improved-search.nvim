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
  return unpack(vim.api.nvim_buf_get_mark(0, mark))
end

M.get_visual_selection_range = function(selection_type)
  local start_row, start_column = M.get_mark("[")
  local end_row, end_column = M.get_mark("]")

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

return M
