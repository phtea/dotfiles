let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10
set path+=** wildmenu wildignorecase wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set grepformat=%f:%l:%c:%m undofile undodir=~/.vim/undo
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --glob "!**/.git/*" --glob "!**/node_modules/*" --glob "!**/package-lock.json" --glob "!**/yarn.lock"'

nmap <leader>w <C-W>
nnoremap - :Ex<CR>
nnoremap <leader>f :find 
nnoremap <leader>b :buffer 
command! -nargs=+ -complete=file Grep execute 'sil grep! <args>' | redraw! | cwindow " :Grep -> search in all files
command! -nargs=+ Ggrep execute 'sil grep! <args> `git ls-files`' | redraw! | cwindow " :Ggrep -> search in tracked files
nnoremap <leader>/ :Grep 
nnoremap <leader>S :Grep -w <C-R><C-W><CR><C-W>k:cdo s/\<<C-R><C-W>\>/<C-R><C-W>/gc<Left><Left><Left>
nnoremap <leader>8 :Grep <C-R><C-W><CR>
nnoremap <leader>* :Ggrep <C-R><C-W><CR>
vnoremap <leader>8 "ay:Grep <C-R>a<CR>
vnoremap <leader>* "ay:Ggrep <C-R>a<CR>
vnoremap S "zy:Grep -w <C-R>z<CR><C-W>k:cdo s/<C-R>z/<C-R>z/gc<Left><Left><Left>
nnoremap Q <nop>
vnoremap * "ay/\V<C-R>a<CR>
nnoremap <F1> :cp<CR>
nnoremap <F2> :cn<CR>
nnoremap <leader>h :help <C-R><C-W><CR>
nnoremap <leader>s :%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>
vnoremap s "zy:%s/<C-R>z/<C-R>z/gI<Left><Left><Left>
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y
nnoremap <Esc> :noh<CR>
nnoremap <leader>l :silent !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redraw!<CR>
nnoremap <leader>R :so ~/.vimrc<CR>
