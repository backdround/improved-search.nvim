local search = require("improved-search")
local u = require("tests.utils")

require("tests.custom-asserts").register()

describe("current-word", function()
  describe("non-strict", function()
    it("should set the current word as a pattern", function()
      u.set_current_buffer([[
        several words
        here
      ]])
      u.set_cursor(1, 9)
      search.current_word()
      local current_pattern = vim.fn.getreg("/")
      assert.equal(current_pattern, "words")
    end)

    it("should set the cursor at the start of the current word", function()
      u.set_current_buffer([[
        several words
      ]])
      u.set_cursor(1, 3)
      search.current_word()
      assert.cursor_at(1, 0)
    end)
  end)

  describe("strict", function()
    it("should set the current word with boundaries as a pattern", function()
      u.set_current_buffer([[
        several words
        here
      ]])
      u.set_cursor(1, 9)
      search.current_word_strict()
      local current_pattern = vim.fn.getreg("/")
      assert.equal(current_pattern, "\\<words\\>")
    end)

    it("should set the cursor at the start of the current word", function()
      u.set_current_buffer([[
        several words
      ]])
      u.set_cursor(1, 3)
      search.current_word_strict()
      assert.cursor_at(1, 0)
    end)
  end)
end)
