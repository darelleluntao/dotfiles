" Neovim entry point. Shared behavior lives in ~/.vim/shared.vim.

set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set packpath^=~/.vim
set packpath+=~/.vim/after

if filereadable(expand('~/.vim/shared.vim'))
  source ~/.vim/shared.vim
endif

" Neovim-only baseline. Each layer is loaded defensively: on a bare server an
" old Neovim or a missing binary should degrade to a working editor, not abort
" startup with a stack trace on every launch.
if has('nvim')
  set inccommand=split
lua <<EOF
  for _, layer in ipairs({ "plugins", "ide", "lsp" }) do
    local ok, err = pcall(require, layer)
    if not ok then
      vim.schedule(function()
        vim.notify(
          ("dotfiles: '%s' layer failed to load: %s"):format(layer, err),
          vim.log.levels.WARN
        )
      end)
    end
  end
EOF
endif
