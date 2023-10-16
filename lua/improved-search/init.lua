-- The file exports all the module functionality.

local jump = require("improved-search.jump")
local current_word = require("improved-search.current-word")
local search = require("improved-search.search")

return {
  stable_next = jump.next,
  stable_previous = jump.previous,

  current_word = current_word.search,
  current_word_strict = current_word.search_strict,

  in_place = search.search_in_place,
  forward = search.search_forward,
  backward = search.search_backward,

  in_place_strict = search.search_in_place_strict,
  forward_strict = search.search_forward_strict,
  backward_strict = search.search_backward_strict,
}
