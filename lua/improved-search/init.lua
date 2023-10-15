-- The file exports all the module functionality.

local jump = require("improved-search.jump")
local current_word = require("improved-search.current-word")
local search = require("improved-search.search")

return {
  stable_next = jump.next,
  stable_previous = jump.previous,

  current_word = current_word.search,
  current_word_strict = current_word.search_strict,

  current = search.search_current,
  next = search.search_next,
  previous = search.search_previous,

  current_strict = search.search_current_strict,
  next_strict = search.search_next_strict,
  previous_strict = search.search_previous_strict,
}
