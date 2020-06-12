call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'

  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-solargraph', {'do': 'yarn install --frozen-lockfile'}

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mcchrish/nnn.vim'
  Plug 'prettier/vim-prettier', { 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

  " Colors stuff
  Plug 'morhetz/gruvbox'
  Plug 'sheerun/vim-polyglot'
  Plug 'fatih/molokai'

  Plug 'xolox/vim-notes'
  Plug 'xolox/vim-misc'
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
set scrolloff=5 ls=2
" set tabstop=4 shiftwidth=4 noexpandtab ai
set noexpandtab shiftwidth=4 tabstop=4 ai
set ignorecase incsearch hlsearch
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set updatetime=300
" set clipboard=unnamedplus
set termguicolors
" let g:gruvbox_contrast_light='medium'
set background=dark
colorscheme molokai
set mouse=a

autocmd BufNewFile,BufRead *.ts set syntax=javascript
autocmd BufNewFile,BufRead *.tsx set syntax=javascript

" Maping
let mapleader = " "
nnoremap <Leader>dd :bd<CR>
nnoremap <silent><Leader>n :nohlsearch<CR>
nnoremap <Leader>w :%s/\s\+$//e<CR>
nnoremap <Tab> :b#<CR>
nnoremap <Leader>c :e <C-R>=expand('%:p:h')<CR>/
nnoremap <Leader>y :!cp % <C-R>=expand('%:p:h')<CR>/
nnoremap <Leader>r :!mv % <C-R>=expand('%:p')<CR>
nnoremap <Leader>f :PrettierAsync<CR>
nnoremap <Leader>s *:%s/<C-R><C-W>/
nnoremap n nzz
nnoremap N Nzz
" nnoremap * *N
" nnoremap # #n
nnoremap L $
nnoremap H ^
nnoremap Y y$
nnoremap Q <NOP>

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
let g:NERDTreeWinSize=40
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" FZF
nnoremap <Leader>p :call fzf#run(fzf#wrap({'source': 'git ls-files', 'sink': 'e'}))<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader><Space> :BLines<CR>
set rtp+=~/.fzf
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
      \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
      \   <bang>0)

let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
let g:fzf_layout = { 'window': 'enew' }

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"

" Ag searcher
nnoremap \ :Rg<CR>
nnoremap \| :Rg <C-R><C-W><CR>

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
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>z :CocFix<CR>

" Gutentags
let g:gutentags_cache_dir = "~/.ctags_cache_dir"

" NNN
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
nnoremap <leader>e :NnnPicker '%:p:h'<CR>

augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType javascript setlocal noexpandtab shiftwidth=4 tabstop=4
augroup END

" Auto load
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
set autoread 
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Notes
let g:notes_directories = ['~/Dropbox/english-docs']
let g:notes_suffix = '.txt'
