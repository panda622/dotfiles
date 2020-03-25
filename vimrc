call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'

  " Colors stuff
  Plug 'ryanoasis/vim-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'Yggdroot/indentLine'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ayu-theme/ayu-vim'
call plug#end()

" Basic
filetype plugin indent on
syntax on
set encoding=utf-8
set undolevels=5000
set undodir=$HOME/.VIM_UNDO_FILES
set undofile
set noswapfile
set dictionary=/usr/share/dict/words
set number
set hidden
set scrolloff=5
set tabstop=4 shiftwidth=4 noexpandtab ai
set ignorecase incsearch hlsearch
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set updatetime=300
set clipboard=unnamedplus
set background=dark
colorscheme ayu
set mouse=a

" Maping
let mapleader = " "
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>e :Explore<CR>
nnoremap <silent><Leader>n :nohlsearch<CR>
nnoremap <Leader>w :%s/\s\+$//e<CR>
nnoremap <Tab> :b#<CR>
nnoremap <Leader>c :e <C-R>=expand('%:p:h')<CR>/
nnoremap <Leader>r :!mv <C-R>=expand('%:p:h')<CR>/
nnoremap <Leader>f :PrettierAsync<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap L $
nnoremap H ^
nnoremap Y y$

" Custom Funcion Vim
" 1. Auto create dir when save new file
  function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
      let dir=fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction
  augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
  augroup END

" 2. Jump to last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Plugin Config
" NERDTree
let g:NERDTreeWinSize=50
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" FZF
nnoremap <Leader>p :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>g :GFiles?<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader><Space> :BLines<CR>
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"

" Ag searcher
nnoremap \ :Ag<CR>
nnoremap \| :Ag <C-R><C-W><CR>

" Tagbar
nmap <C-t> :TagbarToggle<CR>

" For typescript
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }
" Cocvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>z :CocFix<CR>

" Gutentags
let g:gutentags_cache_dir = "~/.ctags_cache_dir"

if has("gui_running")
	set guifont=Menlo:h14
end

" Vim airline
let g:airline_theme='ayu_dark'
let g:airline#extensions#tabline#enabled = 1
