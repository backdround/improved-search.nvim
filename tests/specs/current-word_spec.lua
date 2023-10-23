local search = require("improved-search")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

local function preset()
  h.set_current_buffer([[
    several words
    here
  ]])
  vim.fn.setreg("/", "")
  h.set_cursor(1, 0)

  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)
end

describe("current-word", function()
  before_each(preset)

  describe("non-strict", function()
    it("should set the current word as a pattern", function()
      h.set_cursor(1, 9)
      search.current_word()
      assert.search_pattern("words")
    end)

    it("should set the cursor at the start of the current word", function()
      h.set_cursor(1, 3)
      search.current_word()
      assert.cursor_at(1, 0)
    end)
  end)

  describe("strict", function()
    it("should set the current word with boundaries as a pattern", function()
      h.set_cursor(1, 9)
      search.current_word_strict()
      assert.search_pattern("\\<words\\>")
    end)

    it("should set the cursor at the start of the current word", function()
      h.set_current_buffer([[
        several words
      ]])
      h.set_cursor(1, 3)
      search.current_word_strict()
      assert.cursor_at(1, 0)
    end)
  end)
end)
