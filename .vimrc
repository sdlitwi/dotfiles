if has ("win32")
    set shell=cmd
	set shellcmdflag=/c
    set nocompatible
    set lines=999 columns=999
	set clipboard=exclude:.*
    au GUIEnter * simalt ~x
	source $VIMRUNTIME/mswin.vim "additional windows tweaks
    behave mswin
    set diffexpr=MyDiff()
	call plug#begin('$VIMRUNTIME/plugged')
else
    set shell=sh
    call plug#begin('~/.vim/plugged')
endif

"plugins
Plug 'Raimondi/delimitMate'
Plug 'pangloss/vim-javascript'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/syntastic', {'on': 'SyntasticCheck'}"npm install -g jshint csslint
Plug 'jelera/vim-javascript-syntax'
Plug 'scrooloose/nerdtree', { 'on':   ['NERDTreeToggle', 'NERDTreeFind', 'NERDTree']  }"defer loading of NERDTree
Plug 'ervandew/supertab'
Plug 'OrangeT/vim-csharp'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'Yggdroot/indentLine'
Plug 'dkprice/vim-easygrep'

"git plugins
Plug 'airblade/vim-gitgutter
Plug 'Xuyuanp/nerdtree-git-plugin
Plug 'tpope/vim-fugitive

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
set omnifunc=syntaxcomplete#Complete
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
set foldmethod=syntax   
set foldnestmax=1
set nofoldenable
set foldlevel=1
set noerrorbells
set novisualbell

autocmd BufRead,BufWritePre *.sh normal gg=G "indent on save

"plugin specific settings
let NERDTreeShowHidden=1
"autocmd VimEnter * NERDTree "open NERDTree on start
"autocmd VimEnter * wincmd p "focus current file on start
"autocmd BufWinEnter * NERDTreeMirror "show NERDTree on all tabs
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
let g:NERDTreeWinPos = "right"
let g:superTabDefaultCompletionType = "context"
let g:ctrlp_working_path_mode = 'ra'

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
    if exists("t:NERDTreeBufName")
        if bufwinnr(t:NERDTreeBufName) != -1
            if winnr("$") == 1
                q
            endif
        endif
    endif
endfunction

"reload config when saving
if has ('autocmd') " Remain compatible with earlier versions
    augroup vimrc     " Source vim configuration upon save
        autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
        autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    augroup END
endif " has autocmd"

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
" from https://github.com/spf13/spf13-vim/blob/master/.vimrc
if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} "  Git Hotness
    set statusline+=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_enable_signs=1
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
