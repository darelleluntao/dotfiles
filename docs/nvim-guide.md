# Neovim guide

## File explorer

- `<Space>n` toggles Neo-tree.
- `<Space>o` focuses Neo-tree.

## Completion

- `<C-Space>` opens completion manually.
- `<Tab>` selects the next item or jumps through a snippet.
- `<S-Tab>` selects the previous item or jumps backward.
- `<CR>` confirms the selected completion.

## LSP

These mappings are buffer-local and work after a language server attaches:

- `gd` go to definition
- `gD` go to declaration
- `gi` go to implementation
- `gr` references
- `K` hover documentation
- `<Space>rn` rename symbol
- `<Space>ca` code action
- `<Space>df` format buffer
- `[d` and `]d` move through diagnostics

## Git changes

Neovim uses `gitsigns.nvim` to show Git changes directly in the editor gutter:

- `│` added or changed unstaged lines
- `┃` added or changed staged lines
- `_`, `‾`, and `~` deleted or changed/deleted lines
- `┆` untracked lines

Common mappings:

- `]c` next Git hunk
- `[c` previous Git hunk
- `<Space>hp` preview current hunk
- `<Space>hb` show full blame for current line
- `<Space>hB` toggle inline blame
- `<Space>hs` stage current hunk or visual selection
- `<Space>hr` reset current hunk or visual selection
- `<Space>hS` stage the whole buffer
- `<Space>hu` undo staged hunk
- `<Space>hR` reset the whole buffer
- `<Space>hd` diff current file against index
- `<Space>hD` diff current file against previous revision

## Maintenance

```vim
:Lazy
:Lazy sync
:Mason
:checkhealth vim.lsp
:TSUpdate
```
