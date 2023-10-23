local search = require("improved-search")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

local function get_preset(cursor_line, cursor_column)
  local preset = function()
    h.set_current_buffer([[
      text to search
      text to search
      text to search
      text to search
    ]])
    vim.fn.setreg("/", "")
    h.set_cursor(cursor_line, cursor_column)

    local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(escape, "nx", false)
  end
  return preset
end

describe("search-operator", function()
  describe("in_place", function()
    before_each(get_preset(1, 8))

    it("should set the motion as a search pattern", function()
      search.in_place()
      vim.api.nvim_feedkeys("2b", "nx", false)
      assert.search_pattern("text to ")
    end)

    it("should set visual selection as a search pattern", function()
      vim.api.nvim_feedkeys("v2b", "nx", false)
      search.in_place()
      vim.api.nvim_feedkeys("", "x", false)
      assert.search_pattern("text to s")
    end)

    it("should place the cursor to the start of the pattern", function()
      search.in_place()
      vim.api.nvim_feedkeys("2b", "nx", false)
      assert.cursor_at(1, 0)
    end)

    it("should set multiline motion as a search pattern", function()
      search.in_place()
      vim.api.nvim_feedkeys("2e", "nx", false)
      assert.search_pattern("search\\ntext")
    end)

    it("should respect strict postfix", function()
      search.in_place_strict()
      vim.api.nvim_feedkeys("2b", "nx", false)
      assert.search_pattern("\\<text to \\>")
    end)
  end)

  describe("forward", function()
    before_each(get_preset(1, 0))

    describe("normal mode", function()
      it("should jump forward after pattern selection", function()
        search.forward()
        vim.api.nvim_feedkeys("2e", "nx", false)
        assert.search_pattern("text to")
        assert.cursor_at(2, 0)
      end)

      it("should respect v:count", function()
        vim.api.nvim_feedkeys("3", "nx", false)
        search.forward()
        vim.api.nvim_feedkeys("2e", "nx", false)
        assert.search_pattern("text to")
        assert.cursor_at(4, 0)
      end)
    end)

    describe("visual mode", function()
      it("should jump forward after pattern selection", function()
        vim.api.nvim_feedkeys("v2e", "nx", false)
        h.perform_through_keymap(search.forward)
        assert.search_pattern("text to")
        assert.cursor_at(2, 0)
      end)

      it("should respect v:count", function()
        vim.api.nvim_feedkeys("v2e", "nx", false)
        vim.api.nvim_feedkeys("3", "n", false)
        h.perform_through_keymap(search.forward)
        assert.search_pattern("text to")
        assert.cursor_at(4, 0)
      end)
    end)
  end)

  describe("backward", function()
    before_each(get_preset(4, 0))

    describe("normal mode", function()
      it("should jump backward after pattern selection", function()
        search.backward()
        vim.api.nvim_feedkeys("2e", "nx", false)
        assert.search_pattern("text to")
        assert.cursor_at(3, 0)
      end)

      it("should respect v:count", function()
        vim.api.nvim_feedkeys("3", "nx", false)
        search.backward()
        vim.api.nvim_feedkeys("2e", "nx", false)
        assert.search_pattern("text to")
        assert.cursor_at(1, 0)
      end)
    end)

    describe("visual mode", function()
      it("should jump backward after pattern selection", function()
        vim.api.nvim_feedkeys("v2e", "nx", false)
        h.perform_through_keymap(search.backward)
        assert.search_pattern("text to")
        assert.cursor_at(3, 0)
      end)

      it("should respect v:count", function()
        vim.api.nvim_feedkeys("v2e", "nx", false)
        vim.api.nvim_feedkeys("3", "n", false)
        h.perform_through_keymap(search.backward)
        assert.search_pattern("text to")
        assert.cursor_at(1, 0)
      end)
    end)
  end)
end)
