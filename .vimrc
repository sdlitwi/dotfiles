if has ("win32")
	set shell=cmd
	set shellcmdflag=/c
	set nocompatible
	behave mswin
	set diffexpr=MyDiff()
	call plug#begin('$USERPROFILE/vimfiles/plugged')
else
	set shell=sh
	call plug#begin('~/.vim/plugged')
endif

"plugins
Plug 'Raimondi/delimitMate'
Plug 'pangloss/vim-javascript'
Plug 'nathanaelkane/vim-indent-guides'
"npm install -g jshint
Plug 'scrooloose/syntastic'
Plug 'jelera/vim-javascript-syntax'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'ervandew/supertab'

call plug#end()

"settings
syntax on
filetype plugin indent on
set background=dark
colorscheme solarized
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

"plugin specific settings
let NERDTreeShowHidden=1
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']
let g:NERDTreeWinPos = "right"
let g:superTabDefaultCompletionType = "context"

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

"set GUI specific options                     
if has("gui_running")
	  if has("gui_gtk2")
		      set guifont=Inconsolata\ 12
		        elseif has("gui_macvim")
				        set guifont=Consolas:h14
						set background=dark
                        set guioptions-=L
                        set guioptions-=r
                        set guioptions-=T
                        set fu
			    elseif has("gui_win32")
					    set guifont=Consolas:h14:cANSI
                        set guioptions-=L
                        set guioptions-=r
                        set guioptions-=T
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
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*
      let g:syntastic_enable_signs=1
      set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

"windows diff
function MyDiff()
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
