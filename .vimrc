set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'mkitt/tabline.vim'
" Vim airline
Plugin 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#tabnr_formatter = 2
let g:airline#extensions#tabline#show_tab_nr = 1

Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : ['#(whoami)', '#(uptime | cut -d " " -f 1,2,3)'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(date)',
      \'y'    : ['%R', '%a', '%Y'],
      \'z'    : '#H'}

let g:tmuxline_powerline_separators = 0

"Syntax Check
Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_loc_list_height=3
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
highlight SyntasticErrorSign guifg=white guibg=red
set signcolumn=yes
highlight SyntasticError guibg=#2f0000

Plugin 'airblade/vim-gitgutter'
let g:gitgutter_realtime = 1
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-surround'


Plugin 'mileszs/ack.vim'

"" seagray plugin theme
"call plug#begin('~/.vim/plugged')
"Plug 'nightsense/seagrey'
"call plug#end()

"colorscheme seagrey-dark

" THEME darcula
"Plugin 'dracula/vim'
"syntax on
"color dracula
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'gregsexton/matchtag'
Plugin 'ryanoasis/vim-devicons'
set encoding=utf8
let g:airline_powerline_fonts = 1
set guifont=Nerd\ Font:h11
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'

Plugin 'terryma/vim-smooth-scroll'
Plugin 'yggdroot/indentline'
let g:indentLine_enabled = 1
"Plugin 'nathanaelkane/vim-indent-guides'
"let g:indent_guides_enable_on_vim_startup = 1
Plugin 'bronson/vim-trailing-whitespace'

Plugin 'scrooloose/nerdtree'

Plugin 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
Plugin 'ervandew/supertab'
Plugin '2072/PHP-Indenting-for-VIm'
Plugin 'stanangeloff/php.vim'
" Plugin 'valloric/youcompleteme'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-ragtag'
let g:ragtag_global_maps = 1
"Plugin 'terryma/vim-multiple-cursors'

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<c-tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:enable_bold_font = 1
let g:enable_italic_font = 1
set background=dark
colorscheme hybrid_material

Plugin 'kristijanhusak/vim-hybrid-material'
let g:airline_theme = "hybrid"


syntax on

"set background=light
"colorscheme hybrid_material
" Always show statusline

set laststatus=2

execute pathogen#infect()

" Nerdtree Settings
autocmd VimEnter * NERDTree | wincmd p
map <C-n> :NERDTreeToggle<CR>

set t_Co=256
set mouse-=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

"ctrl p
set runtimepath^=~/.vim/bundle/ctrlp.vim
set number
set pastetoggle=<F3>
set tabstop=4
set mouse=a
