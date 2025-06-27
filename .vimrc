" Leader key
let mapleader = ","

" Options
language en_US.UTF-8 " Forced English language
set number " Show line numbers
set showcmd " Show command in bottom right
set incsearch " Highlight as you type search
set hlsearch " Highlight all matches

" Finding files
set path+=**
set wildmenu
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz
nnoremap <leader>ff :find 
nnoremap <leader>fg :Grep 

" Grep with ripgrep (rg)
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m
command! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redraw! | cwindow " search in all files
command! -nargs=+ Ggrep execute 'silent grep! <args> `git ls-files`' | redraw! | cwindow " search in tracked files
" Search word under cursor with Ggrep (<leader>*)
nnoremap <leader>* :Ggrep <C-R><C-W><CR>

" Easier navigation between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Space: copy to + register (visual mode)
vnoremap <Space> "+y
" Space+p: paste from + register (normal mode)
nnoremap <Space>p "+p
" Clear search highlight with <leader><Space>
nnoremap <leader><Space> :nohlsearch<CR>

" Enable persistent undo
set undofile undodir=~/.vim/undo
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
