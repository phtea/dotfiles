let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set path+=.** number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10 lazyredraw

" Wildmenu settings
set wildmenu wildignorecase wildmode=longest:full,full wildoptions=fuzzy,pum
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildignore+=**/node_modules/**,**/.git/**
set completeopt=menu,menuone,preview

set undofile undodir=~/.vim/undo " undo settings
set shortmess-=S " show count of search results

set showtabline=0 signcolumn=yes smartindent mouse=a " qol
set tabstop=2 shiftwidth=2 scrolloff=10 " tabs management
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
nnoremap <silent> <leader>/ :call MyUtilsRGPrompt()<CR>
vnoremap <silent>* <ESC>:call VisualSearch('/')<CR>/<CR>
vnoremap <silent># <ESC>:call VisualSearch('?')<CR>?<CR>
nnoremap <leader>C :!ctags -R .<CR><CR>
nnoremap <expr> <leader>m MakeAndRun()

function! MakeAndRun() abort
  let l:cmd = input('Makeprg: ', &makeprg, 'shellcmd')
  if empty(l:cmd)
    return ''
  endif
  let &makeprg = l:cmd
  return ":make\<CR>:copen\<CR>"
endfunction

" Quickfix navigation
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

nnoremap <leader>h :help <C-R><C-W><CR>
nnoremap <leader>s :%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>
vnoremap <leader>s "zy:%s/<C-R>z/<C-R>z/gIc<Left><Left><Left><Left>
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y
nnoremap <silent> <Esc> :noh<CR>
nnoremap <silent> <leader>R :source ~/.vimrc<CR>

" TODO: make :checktime after lazygit is closed
nnoremap <leader>l :silent !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redraw!<CR>
set autoread
" au FocusGained,BufEnter * :checktime

" <Tab> / <S-Tab> autocomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" :
			\ MyUtilshas_words_before() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"
" Code: navigation (ctags and ripgrep), toggle comments
"
nnoremap <silent> gd :call MyUtilsGdTagsElseNormal()<CR>
nnoremap <silent> gr :call MyUtilsReferencesRgWord()<CR>
nnoremap <silent> K :call MyUtilsReferencesRgWord()<CR>

" Use a visual-mode mapping; <C-u> removes the automatic '<,'> range
vnoremap <silent> <leader>* :<C-u>call MyUtilsReferencesRgVisual()<CR>
vnoremap <silent> K :<C-u>call MyUtilsReferencesRgVisual()<CR>

" Toggle comment on <space>c
nnoremap <silent> <leader>c :call MyUtilsToggleCommentLine()<CR>
xnoremap <silent> <leader>c :<C-u>call MyUtilsToggleCommentVisual()<CR>

" Load custom code here
source ~/.vim/vimrc.d/utils.vim
