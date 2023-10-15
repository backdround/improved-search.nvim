-- The file describes functions that allows a user to jump to a next or a
-- previous search pattern. It works like "n" or "N", but it doesn't depend on
-- last search direction.

local M = {}

---It's vim's "normal!" command
---@param ... any default vim's maps
local function normal(...)
  local cmd = {
    cmd = "normal",
    bang = true,
    args = { ... },
  }

  local success, err = pcall(vim.api.nvim_cmd, cmd, {})

  -- Print error without file context
  if not success then
    err = err:gsub(".*Vim[^:]*:", "", 1)
    vim.api.nvim_err_writeln(err)
  end
end

---Search next pattern. It's like "n", but doesn't depend on last
---search direction and thus always searchs forward.
---@param count number count of jumps. by default uses vim.v.count1.
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

---Search previous pattern. It's like "N", but doesn't depend on last
---search direction and thus always searchs backward.
---@param count number count of jumps. by default uses vim.v.count1.
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
