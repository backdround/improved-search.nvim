-- The file describes functions for a user that provide search operators
-- with different behaviours.

--# selene: allow(unused_variable)
--# selene: allow(unscoped_variables)

-- Define global search operator.
require("improved-search.search-operator")

local jump = require("improved-search.jump")

local M = {}

---Performs search operator with the given behaviour
---@param strict boolean whether search strict pattern (with word-boundaries) or not.
---@param do_after function | nil function that is performed after the search operator.
local invoke = function(strict, do_after)
  Improved_search_operator_behaviour = {
    strict = strict,
    do_after = do_after
  }
  vim.go.operatorfunc = "v:lua.Improved_search_operator"
  vim.api.nvim_feedkeys("g@", "n", false)
end

---Invoke search operator.
M.search_current = function()
  invoke(false, nil)
end

---Invoke search operator and search next pattern like "g*".
M.search_next = function()
  local saved_count = vim.v.count1
  invoke(false, function()
    jump.next(saved_count)
  end)
end

---Invoke search operator and search previous pattern like "g#".
M.search_previous = function()
  local saved_count = vim.v.count1
  invoke(false, function()
    jump.previous(saved_count)
  end)
end

---Invoke strict (with word-boundaries) search operator.
M.search_current_strict = function()
  invoke(true, nil)
end

---Invoke strict (with word-boundaries) search operator and search next pattern
---like "*".
M.search_next_strict = function()
  local saved_count = vim.v.count1
  invoke(true, function()
    jump.next(saved_count)
  end)
end

---Invoke strict (with word-boundaries) search operator and search previous
---pattern like "#".
M.search_previous_strict = function()
  local saved_count = vim.v.count1
  invoke(true, function()
    jump.previous(saved_count)
  end)
end

return M
