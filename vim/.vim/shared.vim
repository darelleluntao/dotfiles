" Shared Vim/Neovim core configuration.
" Keep this file compatible with both Vim 9+ and Neovim.

scriptencoding utf-8

" Leader keys
let mapleader = "\<Space>"
let maplocalleader = ","

" Compatibility and filetype behavior
set nocompatible
filetype plugin indent on
syntax enable

" UI
set number
set relativenumber
set signcolumn=yes
set cursorline
set ruler
set showcmd
set laststatus=2
set scrolloff=8
set sidescrolloff=8
set colorcolumn=100
set termguicolors
set background=dark

" Themes
" Srcery is installed as a native package at:
"   ~/.vim/pack/themes/start/srcery-vim
" Keep fallbacks built in so startup remains reliable if the package is absent.
let g:srcery_italic = 1
let g:srcery_bold = 1
let g:srcery_underline = 1
let g:commutr_theme_index = 0
let g:commutr_dark_themes = ['srcery', 'catppuccin', 'habamax', 'retrobox', 'desert']
let g:commutr_light_themes = ['lunaperche', 'morning', 'shine']

function! s:ApplyFirstTheme(themes, background) abort
  execute 'set background=' . a:background
  for l:theme in a:themes
    try
      execute 'colorscheme ' . l:theme
      let g:colors_name = l:theme
      return l:theme
    catch /^Vim\%((\a\+)\)\=:E185/
    endtry
  endfor
  return ''
endfunction

function! s:ThemeDark() abort
  call s:ApplyFirstTheme(g:commutr_dark_themes, 'dark')
endfunction

function! s:ThemeLight() abort
  call s:ApplyFirstTheme(g:commutr_light_themes, 'light')
endfunction

function! s:ThemeCycle() abort
  let l:themes = g:commutr_dark_themes + g:commutr_light_themes
  for l:attempt in range(0, len(l:themes) - 1)
    let g:commutr_theme_index = (g:commutr_theme_index + 1) % len(l:themes)
    let l:theme = l:themes[g:commutr_theme_index]
    try
      execute 'colorscheme ' . l:theme
      if index(g:commutr_light_themes, l:theme) >= 0
        set background=light
      else
        set background=dark
      endif
      echo 'Theme: ' . l:theme
      return
    catch /^Vim\%((\a\+)\)\=:E185/
    endtry
  endfor
  echo 'No configured themes are available.'
endfunction

function! s:ThemeList() abort
  echo 'Dark: ' . join(g:commutr_dark_themes, ', ')
  echo 'Light: ' . join(g:commutr_light_themes, ', ')
  echo 'Current: ' . get(g:, 'colors_name', 'unknown')
endfunction

command! ThemeDark call <SID>ThemeDark()
command! ThemeLight call <SID>ThemeLight()
command! ThemeCycle call <SID>ThemeCycle()
command! ThemeList call <SID>ThemeList()

nnoremap <leader>td :ThemeDark<CR>
nnoremap <leader>tl :ThemeLight<CR>
nnoremap <leader>tt :ThemeCycle<CR>
nnoremap <leader>ts :ThemeList<CR>

call s:ThemeDark()

" Editing
set hidden
set confirm
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamedplus
set virtualedit=block
set splitbelow
set splitright
set updatetime=300
set timeoutlen=500

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set autoindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <silent> <leader>h :nohlsearch<CR>

" Completion and command line
set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect

" Files and backups
set undofile
set swapfile
set backup
set writebackup
set autoread

if has('nvim')
  let s:data_dir = stdpath('data')
  let s:state_dir = stdpath('state')
  execute 'set undodir=' . fnameescape(s:state_dir . '/undo//')
  execute 'set directory=' . fnameescape(s:state_dir . '/swap//')
  execute 'set backupdir=' . fnameescape(s:state_dir . '/backup//')
else
  let s:vim_state = expand('~/.vim/state')
  execute 'set undodir=' . fnameescape(s:vim_state . '/undo//')
  execute 'set directory=' . fnameescape(s:vim_state . '/swap//')
  execute 'set backupdir=' . fnameescape(s:vim_state . '/backup//')
endif

" Create state directories if missing.
for s:dir in [&undodir, &directory, &backupdir]
  let s:path = substitute(s:dir, '//$', '', '')
  if !isdirectory(s:path)
    call mkdir(s:path, 'p', 0700)
  endif
endfor

" Whitespace visibility, off by default.
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:␣
nnoremap <leader>l :set list!<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer and file workflow
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>x :bdelete<CR>
nnoremap <leader>e :Explore<CR>

" Keep visual selection after indenting.
xnoremap < <gv
xnoremap > >gv

" Move selected lines.
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv

" Better paste over selection without replacing the default register.
xnoremap <leader>p "_dP

" Quickfix/location list navigation.
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

" fzf integration when available. Homebrew's fzf plugin provides :FZF.
if executable('fzf') && filereadable('/opt/homebrew/opt/fzf/plugin/fzf.vim')
  set runtimepath+=/opt/homebrew/opt/fzf
  runtime plugin/fzf.vim
  nnoremap <leader>f :FZF<CR>
  nnoremap <leader>b :buffers<CR>:buffer<Space>
endif

" ripgrep integration when available.
if executable('rg')
  command! -nargs=+ Rg silent grep! <args>|copen
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
  nnoremap <leader>r :Rg<Space>
endif

" netrw defaults for a usable built-in file browser.
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Per-language indentation.
augroup shared_filetypes
  autocmd!
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType markdown setlocal wrap linebreak spell textwidth=100
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END
