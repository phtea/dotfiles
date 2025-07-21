let mapleader = " "
syntax on
colo habamax
lan en_US.UTF-8
set nu rnu sc is hls hid ttm=50 so=10
set pa+=** wmnu wic wig+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set grepformat=%f:%l:%c:%m

nn - :Ex<CR>
nn <leader>f :find 
nn <leader>/ :Grep 
nn <leader>v :vimgrep //**<Left><Left><Left>
nn <leader>V :vimgrep //** .**<Left><Left><Left><Left><Left><Left><Left>
nn n nzzzv
nn N Nzzzv
nn <C-d> <C-d>zz
nn <C-u> <C-u>zz
nn <A-j> :cnext<CR>
nn <A-k> :cprev<CR>
nn <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
vn s "zy:%s/<C-r>z/<C-r>z/gI<Left><Left><Left>
nn <leader>S :Grep -w <C-R><C-W><CR><C-w>k:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>
vn S "zy:Grep -w <C-r>z<CR><C-w>k:cdo s/<C-r>z/<C-r>z/gc<Left><Left><Left>
let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --glob "!**/.git/*" --glob "!**/node_modules/*" --glob "!**/package-lock.json" --glob "!**/yarn.lock"'
com! -nargs=+ -complete=file Grep execute 'silent grep! <args>' | redr! | cw " search in all files
com! -nargs=+ Ggrep execute 'silent grep! <args> `git ls-files`' | redr! | cw " search in tracked files
nn <leader>8 :Grep <C-R><C-W><CR>
nn <leader>* :Ggrep <C-R><C-W><CR>
nn <C-h> <C-w>h
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l
nn Y y$
nn <leader>y "+y
nn <leader>Y "+y$
vn <leader> "+y
nn <Esc> :nohlsearch<CR>
nn Q <nop>
cno w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

set undofile undodir=~/.vim/undo
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
