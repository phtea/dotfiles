language en_US.utf8 " language
colorscheme habamax " colorscheme

set nocompatible path=.,** number relativenumber tabstop=2 shiftwidth=2 expandtab ttimeoutlen=50 shortmess-=S " ui
set smartcase ignorecase smartindent hlsearch incsearch " search
set undodir=~/.vim/undo// undofile noswapfile " enable undo file but disable swap files
set wildmenu wildignorecase wildmode=longest:full,full wildoptions=fuzzy,pum " command-line
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-messages grepformat=%f:%l:%c:%m " grep settings
  com! -nargs=* Find cal setqflist(map(systemlist('rg --no-ignore --files | rg -- ' . shellescape(<q-args>)), '{"filename": v:val, "lnum": 1, "col": 1}'), 'r') | cw | cfir
endif

nn <Esc> :noh<CR>
nn <Space>x :ene\|setl bt=nofile bh=wipe\|0r !
nn <Space>/ :grep<Space>
nn <Space>f :Find<Space>
nn <F1> :cp<CR>
nn <F2> :cn<CR>
