colo wildcharm
language en_US.UTF-8 " Make sure vim's lang is set to EN 

" Finding files
set path+=**
set wildmenu

set number                     " Show line numbers
set showcmd                   " Show command in bottom right
set incsearch                 " Highlight as you type search
set hlsearch                  " Highlight all matches

" Leader key
let mapleader = ","

" Easier navigation between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Grep with ripgrep (rg)
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m
command! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redraw! | cwindow

" Git-aware grep: search only in tracked files
command! -nargs=+ Ggrep execute 'silent grep! <args> `git ls-files`' | redraw! | cwindow

" Visual Mode: Space to copy to + register
vnoremap <Space> "+y

" Normal Mode: Space+p to paste from + register
nnoremap <Space> "+

" Clear search highlight with <leader><Space>
nnoremap <leader><Space> :nohlsearch<CR>

" Search word under cursor with Ggrep (<leader>*)
nnoremap <leader>* :Ggrep <C-R><C-W><CR>

" Quickfix navigation
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
