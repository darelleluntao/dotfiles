" Vim entry point. Shared behavior lives in ~/.vim/shared.vim.

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after

if filereadable(expand('~/.vim/shared.vim'))
  source ~/.vim/shared.vim
endif

" Vim-only polish.
if exists('+belloff')
  set belloff=all
endif
