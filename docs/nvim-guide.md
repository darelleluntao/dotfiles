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

## Maintenance

```vim
:Lazy
:Lazy sync
:Mason
:checkhealth vim.lsp
:TSUpdate
```
