let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10 lazyredraw
set path+=** wildmenu wildignorecase wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.bak,*.pyc,*.swp,*.zip,*.tar.gz,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set grepformat=%f:%l:%c:%m undofile undodir=~/.vim/undo

set showtabline=0 signcolumn=yes smartindent mouse=a " qol
set tabstop=8 softtabstop=4 shiftwidth=4 noexpandtab " normalize tabs
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p') | endif
set laststatus=2 statusline=%f%m%r%h%w\ %=%l:%c\ (%L\ lines)

nmap <leader>w <C-W>
nnoremap - :Explore<CR>
nnoremap <leader>f :find *
nnoremap <leader>b :buffer *
nnoremap [<space> mzO<Esc>`z
nnoremap ]<space> mzo<Esc>`z
nnoremap Q :call ToggleQuickFix()<CR>
nnoremap <silent> <leader>/ :call <SID>RGPrompt()<CR>
vnoremap <silent>* <ESC>:call VisualSearch('/')<CR>/<CR>
vnoremap <silent># <ESC>:call VisualSearch('?')<CR>?<CR>
nnoremap <leader>C :!ctags -R .<CR><CR>
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
nnoremap <leader>R :source ~/.vimrc<CR>

" todo: make :checktime after lazygit is closed
nnoremap <leader>l :silent !tmux new-window -n lazygit 'cd $(git rev-parse --show-toplevel 2>/dev/null \|\| pwd) && lazygit; tmux kill-window'<CR>:redraw!<CR>
set autoread
" au FocusGained,BufEnter * :checktime

" <Tab> / <S-Tab> autocomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" :
      \ <SID>has_words_before() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> gd :call <SID>GdTagsElseNormal()<CR>
nnoremap <silent> gr :call <SID>ReferencesRgWord()<CR>
nnoremap <silent> K :call <SID>ReferencesRgWord()<CR>
" Use a visual-mode mapping; <C-u> removes the automatic '<,'> range
vnoremap <silent> <leader>* :<C-u>call <SID>ReferencesRgVisual()<CR>
vnoremap <silent> K :<C-u>call <SID>ReferencesRgVisual()<CR>

function! s:RGPrompt() abort
  if !executable('rg')
    echoerr "rg not found"
    return
  endif

  let l:pat = input('rg> ')
  if empty(l:pat) | return | endif

  " Put the pattern in the shell command safely; rg receives it as-is
  execute 'silent grep! ' . shellescape(l:pat)
  redraw!
  cwindow
endfunction

function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

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



" todo: auto update file after lazygit

function! s:has_words_before() abort
  let col = col('.') - 1
  return col > 0 && getline('.')[col - 1] !~# '\s'
endfunction

function! s:GdTagsElseNormal() abort
  let l:sym = expand('<cword>')

  " If an exact tag exists, jump via tags
  if exists('*taglist') && !empty(taglist('^' . escape(l:sym, '\') . '$'))
    execute "normal! \<C-]>"
    return
  endif

  " Otherwise keep Vim's default gd behavior
  execute "normal! gd"
endfunction

" Use ripgrep to search for references of word under cursor (whole word) into quickfix
function! s:ReferencesRgWord() abort
  if !executable('rg')
    echoerr "ripgrep (rg) not found in PATH"
    return
  endif

  let l:word = expand('<cword>')
  let l:pat  = '\b' . escape(l:word, '\') . '\b'
  let l:cmd  = 'rg --vimgrep --smart-case --hidden --glob "!.git/*" -n ' . shellescape(l:pat) . ' .'

  cexpr systemlist(l:cmd)
  if empty(getqflist())
    echo "No references: " . l:word
  else
    copen
  endif
endfunction

" Visual references: uses the current visual selection
function! s:ReferencesRgVisual() abort
  if !executable('rg')
    echoerr "ripgrep (rg) not found in PATH"
    return
  endif

  " Save + yank selection (reselect with gv in case we're not currently in Visual)
  let l:save_reg = getreg('z')
  let l:save_typ = getregtype('z')

  silent! normal! gv"zy

  let l:text = getreg('z')
  call setreg('z', l:save_reg, l:save_typ)

  " Trim and sanity-check
  let l:text = substitute(l:text, '^\s\+|\s\+$', '', 'g')
  if empty(l:text)
    echo "Empty selection"
    return
  endif

  let l:cmd = 'rg --multiline --vimgrep --smart-case --hidden --glob "!**/.git/*" -n '
        \ . shellescape(l:text) . ' .'

  cexpr systemlist(l:cmd)
  if empty(getqflist())
    echo "No matches"
  else
    copen
  endif
endfunction
