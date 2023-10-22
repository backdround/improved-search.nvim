local search = require("improved-search")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("stable", function()
  describe("next", function()
    it("should jump forward after forward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 5)
      h.normal("/aaaa<cr>")
      search.stable_next()
      assert.cursor_at(2, 5)
    end)

    it("should jump forward after backward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("?aaaa<cr>")
      search.stable_next()
      assert.cursor_at(2, 5)
    end)

    it("should respect v:count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 0)
      h.normal("/aaaa<cr>")
      h.normal("3") -- set v.count
      search.stable_next()
      assert.cursor_at(2, 15)
    end)

    it("should respect passed as argument count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 0)
      h.normal("/aaaa<cr>")
      search.stable_next(3)
      assert.cursor_at(2, 15)
    end)
  end)

  describe("previous", function()
    it("should jump backward after forward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 15)
      h.normal("/aaaa<cr>")
      search.stable_previous()
      assert.cursor_at(1, 15)
    end)

    it("should jump backward after backward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("?aaaa<cr>")
      search.stable_previous()
      assert.cursor_at(1, 5)
    end)

    it("should respect v:count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("/aaaa<cr>")
      h.normal("3") -- set v.count
      search.stable_previous()
      assert.cursor_at(1, 5)
    end)

    it("should respect passed as argument count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("/aaaa<cr>")
      search.stable_previous(3)
      assert.cursor_at(1, 5)
    end)
  end)
end)
