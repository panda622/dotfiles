call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'prettier/vim-prettier'
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'sheerun/vim-polyglot'
  Plug 'morhetz/gruvbox'
call plug#end()

syntax on
filetype plugin indent on
set wildmenu wildmode=longest:full,full
set list listchars=tab:»\ ,trail:•
set autoindent expandtab
set shiftwidth=2 softtabstop=2 tabstop=2
set hlsearch ignorecase incsearch
set nobackup noswapfile nowritebackup
set undolevels=5000 undodir=$HOME/.VIM_UNDO_FILES
colors gruvbox

autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
autocmd FileType typescript setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab

" Plugins config
let mapleader = " "
nmap <Leader>s :%s/<C-R><C-W>/
nmap <Leader>d :bd<CR>
nmap <Leader>w :%s/\s\+$//e<CR>
nmap <silent><Leader>n :nohlsearch<CR>
nmap <Tab> :b#<CR>
nmap Q <NOP>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>z :CocFix<CR>

nmap <C-t> :TagbarToggle<CR>

let g:gutentags_cache_dir = "~/.ctags_cache_dir"

nmap <Leader>p :FZF<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>

nnoremap <Leader>f :PrettierAsync<CR>

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--path-to-ignore ~/.ignore --hidden', <bang>0)

nmap \ :Ag<Space>
nmap \| :Ag <C-R><C-W><CR>

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

" 2. Jump to last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
