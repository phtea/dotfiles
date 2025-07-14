" Leader key
let mapleader = " "

syntax on
colorscheme slate
highlight Normal ctermbg=NONE guibg=NONE
highlight NormalNC ctermbg=NONE guibg=NONE

set ttimeoutlen=50
set scrolloff=10

" Options
language en_US.UTF-8
set number
set rnu
set showcmd
set incsearch
set hlsearch

" Open netrw in parent directory with '-'
nnoremap - :Ex<CR>

" Finding files
set path+=**
set wildmenu
set wildignorecase
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
nnoremap <leader>f :find 
nnoremap <leader>/ :Grep 

" Move what's selected
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" When joining lines keep cursor on same place
nnoremap J mzJ`z

" Center searches
nnoremap n nzzzv
nnoremap N Nzzzv

" Substitute current word in this file
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Navigation half-page with centering
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Grep with ripgrep (rg)
let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --glob "!**/.git/*" --glob "!**/node_modules/*" --glob "!**/package-lock.json" --glob "!**/yarn.lock"'
set grepformat=%f:%l:%c:%m

command! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redraw! | cwindow " search in all files
command! -nargs=+ Ggrep execute 'silent grep! <args> `git ls-files`' | redraw! | cwindow " search in tracked files

" Search word under cursor with Ggrep (<leader>*)
nnoremap <leader>8 :Grep <C-R><C-W><CR>
nnoremap <leader>* :Ggrep <C-R><C-W><CR>

" Easier navigation between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quickfix list navigation
nnoremap ]c :cnext<CR>
nnoremap [c :cprev<CR>

" Copy/paste with system buffer (+clipboard needed)
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
vnoremap <leader> "+y

" Hide highlight
nnoremap <Esc> :nohlsearch<CR>

" Misc
nnoremap Q <nop>

" Enable persistent undo
set undofile undodir=~/.vim/undo
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
