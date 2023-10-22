local h = require("tests.helpers")

require("tests.custom-asserts").register()

local function silent_stable_next(count)
  local template = "silent! lua require('improved-search').stable_next(%s)"
  vim.cmd(template:format(count))
end

local function silent_stable_previous(count)
  local template = "silent! lua require('improved-search').stable_previous(%s)"
  vim.cmd(template:format(count))
end

describe("stable", function()
  describe("next", function()
    it("should jump forward after forward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 5)
      h.normal("/aaaa<cr>")
      silent_stable_next()
      assert.cursor_at(2, 5)
    end)

    it("should jump forward after backward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("?aaaa<cr>")
      silent_stable_next()
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
      silent_stable_next()
      assert.cursor_at(2, 15)
    end)

    it("should respect passed as argument count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(1, 0)
      h.normal("/aaaa<cr>")
      silent_stable_next(3)
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
      silent_stable_previous()
      assert.cursor_at(1, 15)
    end)

    it("should jump backward after backward search", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("?aaaa<cr>")
      silent_stable_previous()
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
      silent_stable_previous()
      assert.cursor_at(1, 5)
    end)

    it("should respect passed as argument count", function()
      h.set_current_buffer([[
        bbbb aaaa bbbb aaaa
        bbbb aaaa bbbb aaaa
      ]])
      h.set_cursor(2, 5)
      h.normal("/aaaa<cr>")
      silent_stable_previous(3)
      assert.cursor_at(1, 5)
    end)
  end)
end)
