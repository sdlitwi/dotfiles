"plugins
call plug#begin('$HOME/.vim/plugins')
Plug 'altercation/vim-colors-solarized'         "solarized color scheme
Plug 'scrooloose/nerdtree'                      "file tree
Plug 'Raimondi/delimitMate'                     "auto close brackets, etc.
Plug 'editorconfig/editorconfig-vim'            "editorconfig support (requires python)
Plug 'w0rp/ale'                                 "async syntax checking, for vim 8.0+ (requires node for some types, ex: npm i -g eslint tslint htmllint prettier)
Plug 'Chiel92/vim-autoformat'                   "beutify/auto format (requires node for some types, ex: npm -i js-beautify fixjson typescript-formatter)
Plug 'vim-airline/vim-airline'                  "improved status line, works with ale
Plug 'vim-airline/vim-airline-themes'           "airline themes
Plug 'airblade/vim-gitgutter'                   "git diff in gutter
Plug 'tpope/vim-fugitive'                       "git wrapper (run git commands, etc.)
Plug 'OrangeT/vim-csharp'                       "C# and .Net MVC syntax highlighting
Plug 'pangloss/vim-javascript'                  "javascript syntax highlighting
Plug 'othree/javascript-libraries-syntax.vim'   "javascript library syntax highlighting
Plug 'leafgarland/typescript-vim'               "typescript syntax highlighting
Plug 'Yggdroot/indentLine'                      "vertial indent lines for spaces
call plug#end()

"function key mapping
"F1 - help/documentation
"F2 - toggle NERDTree
"F3 - auto format
"F4 - toogle solarized background color (light/dark)
"F11- toggle fullscreen
map <F2> : NERDTreeToggle <cr>
map <F3> : Autoformat<CR>
call togglebg#map("<F4>")
map <F11> :call ToggleFullscreen()<CR>

"settings
syntax on
set lines=75
set columns=150
filetype plugin indent on
set encoding=utf-8
set number                "line numbers
set relativenumber        "relative line numbers
set guicursor+=a:blinkon0 "steady cursor
set shiftwidth=2          "tab spaces
set tabstop=2             "tab spaces
set autoread              "auto read files on outside change
set ignorecase            "ignore case when searching
set smartcase             "use case if search contains uppercase
set hlsearch              "when there is a previous search pattern, highlight all its matches.
set incsearch             "show matches while typing
set showmatch             "jump to match if match on screen
set nobackup              "don't backup overwritten file
set nowb                  "no backup before overwrite
set noswapfile            "no swap file for buffer
set expandtab             "spaces instead of tabs
set smarttab              "align with spaces instead of tabs
set laststatus=2          "always show status line
set cursorline            "highlight current line"
set backspace=indent,eol,start "allow backspace over indent,end of line, line start
set whichwrap+=<,>,h,l    "wrap to beginning/end of line on move
set autoindent            "copy indent from current line when starting a new line
set nowrap                "don't wrap text
set mouse=a               "enable mouse for all modes
set history=1000          "length of command history
set foldmethod=syntax     "fold by syntax
set foldnestmax=1         "max nest fold 1 level
set foldlevel=1           "fold 1 level
set nofoldenable          "
set noerrorbells          "disable bell sound
set novisualbell          "disable bell flash
set list listchars=tab:>-,trail:·,precedes:«,extends:» "show invisble chars
set wildmenu              "command line completion
set wildmode=longest:list,full "list matches unless only once match
set ssop+=resize,winpos,winsize,curdir,folds,tabpages "session save options
set completeopt=longest,menuone "auto completion options
set background=dark

"gui settings
if has("gui_running")
  set guitablabel=%M\ %t
  "hide menu and scroll bars
  set guioptions-=L
  set guioptions-=r
  set guioptions-=T
  set guioptions-=m
  "gui specific settings
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
    clipboard=unnamedplus
  elseif has("gui_macvim")
    set guifont=Consolas:h12
    set fu
    clipboard=unnamedplus
  elseif has("gui_win32")
    set guifont=Consolas:h12:cANSI
    set t_Co=256
    set guioptions+=e
    set clipboard=unnamed
  endif
endif

"plugin specific settings
colorscheme solarized
let g:airline_theme='solarized'
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
let g:used_javascript_libs = 'jquery,angularjs,react,vue'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"os specific settings
if has ("win32")
  set nocompatible
  set clipboard=exclude:.*
  source $VIMRUNTIME/mswin.vim "additional windows tweaks
  behave mswin
  set diffexpr=MyDiff()
else
  set shell=sh
endif

"automatic commands
au WinEnter * call s:CloseIfOnlyNerdTreeLeft()
au VimLeave * call SaveSession()
au VimEnter * nested :call LoadSession()

" close all open buffers on entering a window if the only buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

"load session if session file exists and starting tab has no buffer
function! LoadSession()
  if (bufname("%") == "" && filereadable($HOME . "/.vim_session "))
    if bufname("%") == ""
      source ~/.vim_session
    endif
  else
    echo "No session loaded."
  endif
endfunction

"close items and save session to user home if active tab has no buffer
function! SaveSession()
  if bufname("%") != ""
    NERDTreeClose
    mksession! ~/.vim_session
  endif
endfunction

"toggle full screen
let fullScreened = 0
function! ToggleFullscreen()
  if g:fullScreened == 0
    let g:fullScreened = 1
    simalt ~x
  else
    let g:fullScreened = 0
    simalt ~r
  endif
endfunction

"windows diff
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
