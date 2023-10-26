# Improved-search.nvim
It's a Neovim plugin that improves the search experience.

It provides:

- **stable** **jump** to next / previous search pattern (regardless of the last
search direction)
- search the **word** under the **cursor** without moving (like `*` or `#`)
- search operator:
  - search text selected in **visual** **mode** (visual selection +
operator)
  - search text provided by **a** **motion** (operator + motion)
  - it all works for a **multiline** search.

<!-- panvimdoc-ignore-start -->

### Preview
#### Search selected text
![selection_search](https://github.com/backdround/improved-search.nvim/assets/17349169/5f94a5aa-f315-4e72-be15-37452b2016c8)

#### Current word search in place
![current_word](https://github.com/backdround/improved-search.nvim/assets/17349169/3220fbc7-ad4e-48e3-8cb4-0df820fcb861)

#### Stable next / previous
![2023-10-16_07-55](https://github.com/backdround/improved-search.nvim/assets/17349169/a3a4942d-5a67-4d22-8d78-d33c48375c92)

---

<!-- panvimdoc-ignore-end -->

### Configuration example
```lua
local search = require("improved-search")

-- Search next / previous.
vim.keymap.set({"n", "x", "o"}, "n", search.stable_next)
vim.keymap.set({"n", "x", "o"}, "N", search.stable_previous)

-- Search current word without moving.
vim.keymap.set("n", "!", search.current_word)

-- Search selected text in visual mode
vim.keymap.set("x", "!", search.in_place) -- search selection without moving
vim.keymap.set("x", "*", search.forward)  -- search selection forward
vim.keymap.set("x", "#", search.backward) -- search selection backward

-- Search by motion in place
vim.keymap.set("n", "|", search.in_place)
-- You can also use search.forward / search.backward for motion selection.
```

<!-- panvimdoc-ignore-start -->

---

<!-- panvimdoc-ignore-end -->

### Functions and operators
| function / operator | modes | description |
| --- | --- | --- |
| stable_next | n, x, o | Search next pattern (regardless of a previous search direction)|
| stable_previous | n, x, o | Search previous pattern (regardless of a previous search direction)|
| current_word[_strict] | n | Search current word in-place |
| in_place[_strict] | n, x, o | In-place search operator |
| forward[_strict] | n, x, o | Forward search operator |
| backward[_strict] | n, x, o | Backward search operator |

- `_strict` postfix means that a search operator / function uses a pattern with
word boundaries. In other words, the pattern is encapsulated with `\<` and `\>`.

<!-- panvimdoc-ignore-start -->

---

<!-- panvimdoc-ignore-end -->

### Limitations:
- Search text that is selected by **visual block mode** isn't work as expected.
