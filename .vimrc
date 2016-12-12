"WINDOWS - rename TO _vimrc and place in %userprofile%
"requires git to be installed (also curl for macOS/Linux)
if has ("win32")
    set nocompatible
    set lines=999 columns=999
    set clipboard=exclude:.*
    source $VIMRUNTIME/mswin.vim "additional windows tweaks
    behave mswin
    set diffexpr=MyDiff()
    "install vim-plug if missing
    if !isdirectory($HOME.'/vimfiles/autoload')
        call mkdir($HOME.'/vimfiles/autoload', "p")
    endif
    if empty(glob('$HOME/vimfiles/autoload/plug.vim'))
        silent !git clone https://github.com/junegunn/vim-plug.git \%userprofile\%/vimfiles/autoload
        silent !move /vimfiles/autoload/vim-plug/plug.vim \%userprofile\%/vimfiles/autoload/plug.vim 
        silent !rd \%userprofile\%/vimfiles/autoload/vim-plug/
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
    "create plugin directory if missing
    if !isdirectory($HOME.'/.vim/plugged')
        call mkdir($HOME.'/.vim/plugged', "p")
    endif
    call plug#begin('$HOME/.vim/plugged')
else
    set shell=sh
    "install vim-plug if missing
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
    "create plugin directory if missing
    if !isdirectory('~/.vim/plugged')
        call mkdir('~/.vim/plugged', "p")
    endif
    call plug#begin('~/.vim/plugged')
endif

"plugins
Plug 'altercation/vim-colors-solarized'     "solarized color scheme
Plug 'jelera/vim-javascript-syntax'         "improved javascript syntax highlighting
Plug 'OrangeT/vim-csharp'                   "improved C# and .Net MVC syntax highlighting
Plug 'Yggdroot/indentLine'                  "vertial indent lines for spaces
call plug#end()

"function key mapping
"F1 - help/documentation
"F2 - save session
"F3 - load session
"F4 - toogle solarized background color (light/dark)
map <F2> :mksession! ~/.vim_session <cr>
map <F3> :source ~/.vim_session <cr>
call togglebg#map("<F4>")

"settings
syntax on
filetype plugin indent on
set number
set relativenumber
set guicursor+=a:blinkon0
set shiftwidth=4
set tabstop=4
set updatetime=250
set autoread
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
set encoding=utf8
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set laststatus=2
set cursorline
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set autoindent
set nowrap
set mouse=a
set history=1000 
set undofile
set undolevels=1000
set undoreload=10000
set noundofile
set foldmethod=syntax   
set foldnestmax=1
set nofoldenable
set foldlevel=1
set noerrorbells
set novisualbell
set list listchars=tab:»·,trail:·
set wildmenu
set wildmode=longest:list,full
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize

"set GUI specific options
if has("gui_running")
    set guitablabel=%M\ %t
    set guioptions-=L
    set guioptions-=r
    set guioptions-=T
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Consolas:h14
        set background=dark
        colorscheme solarized
        set fu
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
        set background=light
        colorscheme solarized
        set t_Co=256
        au GUIEnter * simalt ~x
        set guioptions+=e
    endif
endif

"status line
if has('statusline')
    set laststatus=2
    set statusline=%-.50F     " Full path to file, 50 characters max
    set statusline+=\ (%n) " buffer number
    set statusline+=\ %([%M%R%H%W]\ %) " Modified, Read-only, Help, and Preview flags
    set statusline+=\ %y " Filetype
    set statusline+=\ %=%< " Right-align and start truncation
    set statusline+=\ [%04l/%04L\ %03c] " Show current line number, total lines, current column
    set statusline+=\ %p%% " Percentage through file in lines
endif

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
