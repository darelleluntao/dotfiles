" Neovim entry point. Shared behavior lives in ~/.vim/shared.vim.

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set packpath^=~/.vim
set packpath+=~/.vim/after

if filereadable(expand('~/.vim/shared.vim'))
  source ~/.vim/shared.vim
endif

" Neovim-only baseline. Plugin/LSP layers can be added after Neovim is installed.
if has('nvim')
  set inccommand=split
  lua require('plugins')
  lua require('ide')
  lua require('lsp')
endif
