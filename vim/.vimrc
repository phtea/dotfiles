let mapleader = " "

set path+=** nocompatible number relativenumber tabstop=2 shiftwidth=2 expandtab ttimeoutlen=50 shortmess-=S showtabline=0
set smartcase ignorecase noswapfile undofile signcolumn=yes completeopt=menuone,noinsert hlsearch incsearch smartindent mouse=a
colorscheme habamax

nnoremap <leader>w <C-w>
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
nnoremap Y y$
nnoremap <Esc> :noh<CR>
nnoremap <F1> :cprev<CR>
nnoremap <F2> :cnext<CR>
nnoremap <leader>x :enew\|setl buftype=nofile bufhidden=wipe\|0r !
nnoremap <leader>/ :enew\|setl buftype=nofile bufhidden=wipe\|0r !rg --vimgrep ''<Left>
nnoremap Q :cwindow<CR>
nnoremap <C-q> :cbuffer<CR>
nnoremap - :Explore<CR>
