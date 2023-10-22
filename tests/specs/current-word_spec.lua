local search = require("improved-search")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("current-word", function()
  describe("non-strict", function()
    it("should set the current word as a pattern", function()
      h.set_current_buffer([[
        several words
        here
      ]])
      h.set_cursor(1, 9)
      search.current_word()
      local current_pattern = vim.fn.getreg("/")
      assert.equals(current_pattern, "words")
    end)

    it("should set the cursor at the start of the current word", function()
      h.set_current_buffer([[
        several words
      ]])
      h.set_cursor(1, 3)
      search.current_word()
      assert.cursor_at(1, 0)
    end)
  end)

  describe("strict", function()
    it("should set the current word with boundaries as a pattern", function()
      h.set_current_buffer([[
        several words
        here
      ]])
      h.set_cursor(1, 9)
      search.current_word_strict()
      local current_pattern = vim.fn.getreg("/")
      assert.equals(current_pattern, "\\<words\\>")
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
