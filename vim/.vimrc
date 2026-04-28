language en_US.utf8 " language
colorscheme habamax " colorscheme

set nocompatible path=.,** number tabstop=2 shiftwidth=2 expandtab ttimeoutlen=50 shortmess-=S " ui
set smartcase ignorecase smartindent hlsearch incsearch " search
set undodir=~/.vim/undo// undofile noswapfile " file
set wildmenu wildignorecase wildmode=longest:full,full wildoptions=fuzzy,pum " commandline

" Keymaps
nn - :E<CR>
nn <Esc> :noh<CR>
nn <Space>x :ene\|setl bt=nofile bh=wipe\|0r !
nn <Space>f :Find<Space>
nn <Space>/ :Rg<Space>
nn Q :cb\|cope\|winc p<CR>
nn <F1> :cp<CR>
nn <F2> :cn<CR>

" Helper commands
com! -nargs=* Find cal setqflist(map(systemlist('rg --no-ignore --files | rg -- ' . shellescape(<q-args>)), '{"filename": v:val, "lnum": 1, "col": 1}'), 'r') | cw | cfirst
com! -nargs=* Rg exe 'cex system("rg --no-ignore --vimgrep " . shellescape(<q-args>))' | cw | cfirst

" Install manually:
" git clone https://github.com/azabiong/vim-highlighter ~/.vim/pack/plugins/start/vim-highlighter
packadd vim-highlighter
nn n <Cmd>call HiSearch('n')<CR>
nn N <Cmd>call HiSearch('N')<CR>
