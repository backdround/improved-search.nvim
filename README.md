# Improved-search.nvim
It's a neovim plugin that improves and adds some search abilities.

It provides:
- **stable jump** to next / previous search pattern (regardless of the last
search direction)
- search the **word under the cursor** without moving (like `*` or `#`)
- search operator:
  - search selected text provided by **visual mode** (visual selection +
operator)
  - search selected text provided by **a motion** (operator + motion)
  - it all works for **multiline** search

---
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

---
### Functions and operators
- `stable_next` / `stable_previous` - stable search motions (for "n/x/o" modes)

- `current_word{_strict}` - in-place current word search (for "n" mode)

- `in_place{_strict}` / `forward{_strict}` / `backward{_strict}` -
search operators (for "n/x/o" modes)

<br>
Functions with `_strict` postfix add word boundaries (`\<` and `\>`) for all
search patterns.

---
### Limitations:
  - Correct search text in **visual block mode** isn't implemented.
