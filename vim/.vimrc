let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set path+=.** number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10 lazyredraw

" Wildmenu settings
set wildmenu wildignorecase wildmode=longest:full,full wildoptions=fuzzy,pum
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildignore+=**/node_modules/**,**/.git/**

set undofile undodir=~/.vim/undo " undo settings
set shortmess-=S " show count of search results

set showtabline=0 signcolumn=yes smartindent mouse=a " qol
set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab " normalize tabs
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
set laststatus=2 statusline=%f%m%r%h%w\ %=%l:%c\ (%L\ lines)

let rg_globs = [
			\ '!**/.git/*',
			\ '!**/node_modules/*',
			\ '!**/package-lock.json',
			\ '!**/yarn.lock',
			\ '!tags',
			\ '!*.js',
			\ '!*.css',
			\ '!*.map'
			\]

let &grepprg = 'rg --vimgrep --no-heading --smart-case --hidden ' .
			\ join(map(rg_globs, '"--glob \"".v:val."\""'), ' ')
set grepformat=%f:%l:%c:%m

nmap <leader>w <C-W>
nnoremap - :Explore<CR>
nnoremap <leader>b :buffer<Space>
" Default :find
nnoremap <leader>f :find<Space>

" Add space while not leaving normal mode
nnoremap [<space> mzO<Esc>`z
nnoremap ]<space> mzo<Esc>`z

nnoremap Q :call ToggleQuickFix()<CR>
nnoremap <silent> <leader>/ :call <SID>RGPrompt()<CR>
vnoremap <silent>* <ESC>:call VisualSearch('/')<CR>/<CR>
vnoremap <silent># <ESC>:call VisualSearch('?')<CR>?<CR>
nnoremap <leader>C :!ctags -R .<CR><CR>

" Quickfix navigation
nnoremap <silent> <F1> :cprev<CR>
nnoremap <silent> <F2> :cnext<CR>
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

nnoremap <leader>h :help <C-R><C-W><CR>
nnoremap <leader>s :%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>
vnoremap s "zy:%s/<C-R>z/<C-R>z/gI<Left><Left><Left>
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y
nnoremap <silent> <Esc> :noh<CR>
nnoremap <silent> <leader>R :source ~/.vimrc<CR>

" todo: make :checktime after lazygit is closed
nnoremap <leader>l :silent !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redraw!<CR>
set autoread
" au FocusGained,BufEnter * :checktime

" <Tab> / <S-Tab> autocomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" :
			\ <SID>has_words_before() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"
" Code: navigation (ctags and ripgrep), toggle comments
"
nnoremap <silent> gd :call <SID>GdTagsElseNormal()<CR>
nnoremap <silent> gr :call <SID>ReferencesRgWord()<CR>
nnoremap <silent> K :call <SID>ReferencesRgWord()<CR>

" Use a visual-mode mapping; <C-u> removes the automatic '<,'> range
vnoremap <silent> <leader>* :<C-u>call <SID>ReferencesRgVisual()<CR>
vnoremap <silent> K :<C-u>call <SID>ReferencesRgVisual()<CR>

" Toggle comment on <space>c
nnoremap <silent> <leader>c :call <SID>ToggleCommentLine()<CR>
xnoremap <silent> <leader>c :<C-u>call <SID>ToggleCommentVisual()<CR>

"
" Git gutter signs
"
set signcolumn=yes
set updatetime=100
let g:gitgutter_enabled = 1

" optional but great
nnoremap ]g <Plug>(GitGutterNextHunk)
nnoremap [g <Plug>(GitGutterPrevHunk)
nnoremap <leader>gh <Plug>(GitGutterPreviewHunk)
nnoremap <leader>gr <Plug>(GitGutterUndoHunk)
nnoremap <leader>gs <Plug>(GitGutterStageHunk)
onoremap ih <Plug>(GitGutterTextObjectInnerPending)
onoremap ah <Plug>(GitGutterTextObjectOuterPending)
xnoremap ih <Plug>(GitGutterTextObjectInnerVisual)
xnoremap ah <Plug>(GitGutterTextObjectOuterVisual)
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '▁'
source ~/.vim/vimrc.d/utils.vim
