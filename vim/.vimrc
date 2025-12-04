let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10
set path+=** wildmenu wildignorecase wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set grepformat=%f:%l:%c:%m undofile undodir=~/.vim/undo

set showtabline=0 signcolumn=yes smartindent mouse=a " qol
set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab " normalize tabs
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --glob "!**/.git/*" --glob "!**/node_modules/*" --glob "!**/package-lock.json" --glob "!**/yarn.lock"'

nmap <leader>w <C-W>
nnoremap - :Ex<CR>
nnoremap <leader>f :find *
nnoremap <leader>b :buffer *
command! -nargs=+ -complete=file Grep execute 'sil grep! <args>' | redraw! | cwindow " search in all files
command! -nargs=+ Ggrep execute 'sil grep! <args> `git ls-files`' | redraw! | cwindow " search in tracked files
nnoremap <leader>/ :Grep 
nnoremap <leader>S :Grep -w <C-R><C-W><CR><C-W>k:cdo s/\<<C-R><C-W>\>/<C-R><C-W>/gc<Left><Left><Left>
nnoremap <leader>* :Ggrep <C-R><C-W><CR>
vnoremap <leader>* "ay:Ggrep <C-R>a<CR>
vnoremap S "zy:Grep -w <C-R>z<CR><C-W>k:cdo s/<C-R>z/<C-R>z/gc<Left><Left><Left>
nnoremap Q :call ToggleQuickFix()<CR>
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
nnoremap K :Ggrep "\b<C-R><C-W>\b"<cr>:cw<cr>

nnoremap [<space> m0O<Esc>`0
nnoremap ]<space> m0o<Esc>`0

vnoremap <silent>* <ESC>:call VisualSearch('/')<CR>/<CR>
vnoremap <silent># <ESC>:call VisualSearch('?')<CR>?<CR>

function! VisualSearch(dirrection)
    let l:register=@@
    normal! gvy
    let l:search=escape(@@, '$.*/\[]')
    if a:dirrection=='/'
	execute 'normal! /'.l:search
    else
	execute 'normal! ?'.l:search
    endif
    let @/=l:search
    normal! gV
    let @@=l:register
endfunction

nnoremap <leader>c :!ctags -R .<cr><cr>

nnoremap <silent> <F1> :cprev<CR>
nnoremap <silent> <F2> :cnext<CR>
nnoremap <leader>h :help <C-R><C-W><CR>
nnoremap <leader>s :%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>
vnoremap s "zy:%s/<C-R>z/<C-R>z/gI<Left><Left><Left>
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y
nnoremap <silent> <Esc> :noh<CR>
nnoremap <leader>l :silent !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redraw!<CR>
nnoremap <leader>R :source ~/.vimrc<CR>

" todo: show current file used
"set autoread
"au FocusGained,BufEnter * :checktime

" todo: auto update file after lazygit

" Autocomplete on <Tab>/<Shift-Tab> !
function! s:has_words_before() abort
  let col = col('.') - 1
  return col > 0 && getline('.')[col - 1] !~# '\s'
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" :
      \ <SID>has_words_before() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
