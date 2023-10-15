--# selene: allow(unused_variable)
--# selene: allow(unscoped_variables)

-- Define Improved_search_operator
require("improved-search.search-operator")

local jump = require("improved-search.jump")

local M = {}

local invoke = function(strict, do_after)
  Improved_search_operator_behavior = {
    strict = strict,
    do_after = do_after
  }
  vim.go.operatorfunc = "v:lua.Improved_search_operator"
  vim.api.nvim_feedkeys("g@", "n", false)
end

M.search_current = function()
  invoke(false, nil)
end

-- "g*" in visual mode, that can search multiline-pattern
M.search_next = function()
  local saved_count = vim.v.count1
  invoke(false, function()
    jump.next(saved_count)
  end)
end

-- "g#" in visual mode, that can search multiline-pattern
M.search_previous = function()
  local saved_count = vim.v.count1
  invoke(false, function()
    jump.previous(saved_count)
  end)
end

M.search_current_strict = function()
  invoke(true, nil)
end

-- "*" in visual mode, that can search multiline-pattern
M.search_next_strict = function()
  local saved_count = vim.v.count1
  invoke(true, function()
    jump.next(saved_count)
  end)
end

-- "#" in visual mode, that can search multiline-pattern
M.search_previous_strict = function()
  local saved_count = vim.v.count1
  invoke(true, function()
    jump.previous(saved_count)
  end)
end

return M
