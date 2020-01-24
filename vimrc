" Plugin
call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'dense-analysis/ale'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'rking/ag.vim' 
  Plug 'itchyny/lightline.vim'
  Plug 'morhetz/gruvbox'
call plug#end()

" Basic
filetype plugin indent on
set noswapfile
syntax on
set hidden number
set scrolloff=5
set tabstop=2 shiftwidth=2 expandtab ai
set ignorecase incsearch hlsearch
set background=dark
colorscheme gruvbox

" Maping
let mapleader = " "
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>e :Explore<CR>
nnoremap <Leader>n :nohlsearch<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

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
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Lightline
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" FZF
nnoremap <Leader>p :Files<CR>
nnoremap <Leader>b :Buffers<CR>

" Ale
let g:ale_set_highlights = 0
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'ruby': [],
\}

" Prettier
let g:prettier#exec_cmd_async = 1
let g:prettier#config#print_width = 80
let g:prettier#config#tab_width = 2
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#semi = 'true'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#trailing_comma = 'none'
let g:prettier#config#parser = 'babylon'
let g:prettier#config#config_precedence = 'prefer-file'
let g:prettier#config#prose_wrap = 'preserve'
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
