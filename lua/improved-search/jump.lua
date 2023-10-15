local M = {}

local function normal(...)
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


M.next = function(count)
  if not count then
    count = vim.v.count1
  end

  if vim.v.searchforward == 1 then
    normal(count .. "n")
  else
    normal(count .. "N")
  end
end

M.previous = function(count)
  if not count then
    count = vim.v.count1
  end

  if vim.v.searchforward == 0 then
    normal(count .. "n")
  else
    normal(count .. "N")
  end
end

return M
