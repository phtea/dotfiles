let mapleader = " "
colorscheme habamax
set path+=** nocompatible number relativenumber tabstop=2 shiftwidth=2 expandtab ttimeoutlen=50 shortmess-=S showtabline=0
set smartcase ignorecase smartindent hlsearch incsearch mouse=a undodir=~/.vim/undo// undofile noswapfile nolz
nnoremap - :Explore<CR>
nnoremap <Esc> :nohlsearch<CR>
nnoremap <leader>x :enew\|setl buftype=nofile bufhidden=wipe\|0r !
nnoremap Q :cbuffer \| copen \| wincmd p<CR>
nnoremap <F1> :cprev<CR>
nnoremap <F2> :cnext<CR>
