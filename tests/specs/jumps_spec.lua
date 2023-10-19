local search = require("improved-search")
local u = require("tests.utils")

require("tests.custom-asserts").register()

describe("stable", function()
  describe("next", function()
    it("should jump forward after forward search", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(1, 5)
      u.feedkeys("/aaaa<cr>")
      search.stable_next()
      assert.cursor_at(2, 5)
    end)

    it("should jump forward after backward search", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(2, 5)
      u.feedkeys("?aaaa<cr>")
      search.stable_next()
      assert.cursor_at(2, 5)
    end)

    it("should respect v:count", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(1, 0)
      u.feedkeys("/aaaa<cr>")
      u.feedkeys("3") -- set v.count
      search.stable_next()
      assert.cursor_at(2, 15)
    end)

    it("should respect passed as argument count", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(1, 0)
      u.feedkeys("/aaaa<cr>")
      search.stable_next(3)
      assert.cursor_at(2, 15)
    end)
  end)

  describe("previous", function()
    it("should jump backward after forward search", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(1, 15)
      u.feedkeys("/aaaa<cr>")
      search.stable_previous()
      assert.cursor_at(1, 15)
    end)

    it("should jump backward after backward search", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(2, 5)
      u.feedkeys("?aaaa<cr>")
      search.stable_previous()
      assert.cursor_at(1, 5)
    end)

    it("should respect v:count", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(2, 5)
      u.feedkeys("/aaaa<cr>")
      u.feedkeys("3") -- set v.count
      search.stable_previous()
      assert.cursor_at(1, 5)
    end)

    it("should respect passed as argument count", function()
      u.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      u.set_cursor(2, 5)
      u.feedkeys("/aaaa<cr>")
      search.stable_previous(3)
      assert.cursor_at(1, 5)
    end)
  end)
end)
