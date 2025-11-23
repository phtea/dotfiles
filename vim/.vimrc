let mapleader = " "
syntax on
colo habamax
lan en_US.UTF-8
se nu rnu sc is hls hid noswapfile ttm=50 so=10
se pa+=** wmnu wic wig+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
se gfm=%f:%l:%c:%m udf udir=~/.vim/undo
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif

nn - :Ex<CR>
nn <leader>f :find 
nn <leader>/ :Grep 
vn * "ay/\V<C-R>a<CR>
nn <M-j> :cn<CR>
nn <M-k> :cp<CR>
nn <F2> :cn<CR>
nn <F1> :cp<CR>
nn <leader>s :%s/\<<C-R><C-w>\>/<C-R><C-w>/gI<Left><Left><Left>
vn s "zy:%s/<C-R>z/<C-R>z/gI<Left><Left><Left>
nn <leader>S :Grep -w <C-R><C-W><CR><C-w>k:cdo s/\<<C-R><C-w>\>/<C-R><C-w>/gc<Left><Left><Left>
vn S "zy:Grep -w <C-R>z<CR><C-w>k:cdo s/<C-R>z/<C-R>z/gc<Left><Left><Left>
let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --glob "!**/.git/*" --glob "!**/node_modules/*" --glob "!**/package-lock.json" --glob "!**/yarn.lock"'
com! -nargs=+ -complete=file Grep execute 'sil grep! <args>' | redr! | cw " :Grep -> search in all files
com! -nargs=+ Ggrep execute 'sil grep! <args> `git ls-files`' | redr! | cw " :Ggrep -> search in tracked files
nn <leader>8 :Grep <C-R><C-W><CR>
nn <leader>* :Ggrep <C-R><C-W><CR>
vn <leader>8 "ay:Grep <C-R>a<CR>
vn <leader>* "ay:Ggrep <C-R>a<CR>
nn Y y$
nn <leader>y "+y
nn <leader>Y "+y$
vn <leader>y "+y
nn <Esc> :noh<CR>
nn Q <nop>
nm <leader>w <C-w>
nn <leader>l :sil !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redr!<CR>
nn <leader>R :so ~/.vimrc<CR>
