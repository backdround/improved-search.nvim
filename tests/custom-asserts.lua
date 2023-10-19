local assert = require("luassert")
local say = require("say")

local function cursor_at(_, arguments)
  local line = arguments[1]
  local column = arguments[2]

  local cursor_position = vim.api.nvim_win_get_cursor(0)

  -- Prepare arguments for assert output
  table.insert(arguments, 1, cursor_position[1])
  table.insert(arguments, 2, cursor_position[2])
  arguments.nofmt = { 1, 2, 3, 4 }

  if line == cursor_position[1] and column == cursor_position[2] then
    return true
  end
  return false
end

local register = function()
  say:set_namespace("en")
  say:set(
    "assertion.cursor_at",
    "Expected the cursor to be at the position." ..
    "\nReal:\n { %s, %s }\nExpected:\n { %s, %s }"
  )
  assert:register(
    "assertion",
    "cursor_at",
    cursor_at,
    "assertion.cursor_at"
  )
end

return {
  register = register,
}
