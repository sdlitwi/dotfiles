if has ("win32")
    set shell=cmd
    set shellcmdflag=/c
    set nocompatible
    set lines=999 columns=999
    set clipboard=exclude:.*
    source $VIMRUNTIME/mswin.vim "additional windows tweaks
    behave mswin
    set diffexpr=MyDiff()
    call plug#begin('$VIMRUNTIME/plugged')
else
    set shell=sh
    call plug#begin('~/.vim/plugged')
endif

"plugins
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
Plug 'altercation/vim-colors-solarized'     "solarized color scheme
Plug 'jelera/vim-javascript-syntax'         "improved javascript syntax highlighting
Plug 'OrangeT/vim-csharp'                   "improved C# and .Net MVC syntax highlighting
Plug 'Yggdroot/indentLine'                  "vertial indent lines for spaces
call plug#end()

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

call togglebg#map("<F5>") "toogle solarized background color (light/dark)

"status line
if has('statusline')
    set laststatus=2
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%#warningmsg#
    set statusline+=%*
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
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
