" Plugin
call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  " Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  " Plug 'dense-analysis/ale'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'rking/ag.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'robertmeta/nofrils'
  Plug 'morhetz/gruvbox'
  Plug 'jaredgorski/SpaceCamp'
  Plug ' NLKNguyen/papercolor-theme'
  Plug 'majutsushi/tagbar'
  " Plug 'ludovicchabant/vim-gutentags'
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
set tabstop=2 shiftwidth=2 noexpandtab ai
set ignorecase incsearch hlsearch
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set updatetime=300
set background=dark
colorscheme gruvbox
" Maping
let mapleader = " "
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>e :Explore<CR>
nnoremap <silent><Leader>n :nohlsearch<CR>
nnoremap <Leader>w :%s/\s\+$//e<CR>
nnoremap <Tab> :b#<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
autocmd BufRead,BufNewFile *.ts setlocal shiftwidth=2 softtabstop=2 noexpandtab

let g:neoterm_default_mod = 'botright'
let g:neoterm_autojump = 1
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
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Lightline
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" FZF
nnoremap <Leader>p :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader><Space> :BLines<CR>
imap <c-x><c-w> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)

" Ale
" let g:ale_set_highlights = 0
" let g:ale_linters = {
" \   'javascript': ['eslint'],
" \   'typescript': ['tslint'],
" \   'ruby': [],
" \}

" Prettier
" let g:prettier#exec_cmd_async = 1
" let g:prettier#config#print_width = 80
" let g:prettier#config#tab_width = 2
" let g:prettier#config#use_tabs = 'true'
" let g:prettier#config#semi = 'true'
" let g:prettier#config#single_quote = 'false'
" let g:prettier#config#bracket_spacing = 'true'
" let g:prettier#config#jsx_bracket_same_line = 'false'
" let g:prettier#config#trailing_comma = 'none'
" let g:prettier#config#parser = 'babylon'
" let g:prettier#config#config_precedence = 'prefer-file'
" let g:prettier#config#prose_wrap = 'preserve'
" let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
" autocmd BufWritePre *.jsx,*.ts,*.tsx PrettierAsync

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"

" Ag searcher
nnoremap \ :Ag 
nnoremap \| :Ag <C-R><C-W>

" Tagbar
nmap <C-t> :TagbarToggle<CR>

command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
