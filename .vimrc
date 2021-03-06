if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-rails'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-fugitive'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }
  Plug 'majutsushi/tagbar'
  Plug 'mcchrish/nnn.vim'
  Plug 'ludovicchabant/vim-gutentags'
  " Plug 'sheerun/vim-polyglot'
call plug#end()

filetype plugin indent on
" set number
set wildmenu wildmode=longest:full,full
set list listchars=tab:»\ ,trail:•
set autoindent expandtab smarttab
set shiftwidth=2 softtabstop=2 tabstop=2
set hlsearch ignorecase incsearch
set nobackup noswapfile nowritebackup hidden
set undofile undolevels=5000 undodir=$HOME/.VIM_UNDO_FILES
syntax off
set t_Co=0

" Filetype
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd FileType typescript setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab

let mapleader = " "
nmap <Leader>s *:%s/<C-R><C-W>/
nmap <Leader>d :bd<CR>
nmap <Leader>w :%s/\s\+$//e<CR>
nmap <silent><Leader>n :nohlsearch<CR>
nmap <Tab> :b#<CR>
nmap <Leader>c :e <C-R>=expand('%:p:h')<CR>/
nmap <Leader>r :!mv % <C-R>=expand('%:p')<CR>
nmap <Leader>y :!cp % <C-R>=expand('%:p:h')<CR>/
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>z :CocFix<CR>
nmap <leader>e :NnnPicker %:p:h<CR>
nmap <C-t> :TagbarToggle<CR>
nmap <Leader>p :FZF<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>
nmap <Leader>f :PrettierAsync<CR>
nmap \ :Ag<Space>
nmap \| :Ag <C-R><C-W><CR>
nmap Y y$
nmap n nzz
nmap N Nzz
nmap * *N
nmap # #n
nmap Q <NOP>

" Gutentags
let g:gutentags_cache_dir = expand('~/.ctags_cache_dir')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Ag
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore --hidden', <bang>0)

" Tagbar
let g:tagbar_width = 60
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


" NNN
let g:nnn#set_default_mappings = 0
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

" Auto create dir when save new file
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

" Jump to last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

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
