let mapleader = " "
syntax enable
colorscheme habamax
language en_US.UTF-8
set path+=** number relativenumber showcmd incsearch hlsearch hidden noswapfile ignorecase smartcase ttimeoutlen=50 scrolloff=10 lazyredraw

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
nnoremap <leader>f :find 
nnoremap <leader>b :buffer 

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

" Toggle comment on <space>c
nnoremap <silent> <leader>c :call <SID>ToggleCommentLine()<CR>
xnoremap <silent> <leader>c :<C-u>call <SID>ToggleCommentVisual()<CR>

" Util functions
function! s:RGPrompt() abort
  if !executable('rg')
    echoerr 'rg not found'
    return
  endif

  let l:pat = input('rg> ')
  if empty(l:pat) | return | endif

  cexpr systemlist(&grepprg . ' ' . shellescape(l:pat) . ' .')
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
	let l:cmd = &grepprg . ' -n ' . shellescape(l:pat) . ' .'

	cexpr systemlist(l:cmd)
	if empty(getqflist())
		echo "No references: " . l:word
	else
		cwindow
		let @/ = l:word
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

  let l:cmd = &grepprg . ' --multiline ' . shellescape(l:text) . ' .'
  cexpr systemlist(l:cmd)
  if empty(getqflist())
    echo "No matches"
  else
		cwindow
		let @/ = l:text
  endif
endfunction

augroup LineCommentStrings
  autocmd!
  " Shell / config
  autocmd FileType sh,bash,zsh setlocal commentstring=#\ %s
  autocmd FileType conf,config,dosini setlocal commentstring=#\ %s
  autocmd FileType yaml setlocal commentstring=#\ %s
  autocmd FileType toml setlocal commentstring=#\ %s

  " Ruby / Python
  autocmd FileType ruby,eruby setlocal commentstring=#\ %s
  autocmd FileType python setlocal commentstring=#\ %s

  " JS/TS + friends
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal commentstring=//\ %s
  autocmd FileType jsonc setlocal commentstring=//\ %s

  " Web
  autocmd FileType css,scss,less setlocal commentstring=//\ %s

  " Go / Rust / C-family
  autocmd FileType go,rust,c,cpp,objc,objcpp,java,kotlin,scala setlocal commentstring=//\ %s

  " Lua
  autocmd FileType lua setlocal commentstring=--\ %s

  " Vimscript
  autocmd FileType vim setlocal commentstring=\"\ %s

  " Elixir / Erlang
  autocmd FileType elixir setlocal commentstring=#\ %s
  autocmd FileType erlang setlocal commentstring=%\ %s

  " Haskell
  autocmd FileType haskell setlocal commentstring=--\ %s

  " SQL
  autocmd FileType sql setlocal commentstring=--\ %s

  " Markdown (HTML comments are least surprising)
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
augroup END

" Toggle comment for line / visual selection using 'commentstring'
function! s:ToggleCommentRange(l1, l2) abort
  let cs = &commentstring
  if empty(cs) || cs !~ '%s'
    echoerr "No commentstring for this filetype"
    return
  endif

  let pre = substitute(cs, '%s.*$', '', '')
  let suf = substitute(cs, '^.*%s', '', '')

  " escape for very-magic regex usage below
  let pre_esc = escape(pre, '\.^$~[]*\/')
  let suf_esc = escape(suf, '\.^$~[]*\/')

  " Check if all non-empty lines are already commented
  let all_commented = 1
  for lnum in range(a:l1, a:l2)
    let line = getline(lnum)
    if line =~ '^\s*$' | continue | endif
    if line !~ '^\s*' . pre_esc . '.*' . suf_esc . '\s*$'
      let all_commented = 0
      break
    endif
  endfor

  if all_commented
    " Uncomment
    for lnum in range(a:l1, a:l2)
      let line = getline(lnum)
      if line =~ '^\s*$' | continue | endif
      let line = substitute(line, '^\(\s*\)' . pre_esc . '\s\?', '\1', '')
      if !empty(suf)
        let line = substitute(line, '\s\?' . suf_esc . '\s*$', '', '')
      endif
      call setline(lnum, line)
    endfor
  else
    " Comment
    for lnum in range(a:l1, a:l2)
      let line = getline(lnum)
      if line =~ '^\s*$' | continue | endif
      let indent = matchstr(line, '^\s*')
      let body = line[len(indent):]
      call setline(lnum, indent . pre . body . suf)
    endfor
  endif
endfunction

function! s:ToggleCommentLine() abort
  call <SID>ToggleCommentRange(line('.'), line('.'))
endfunction

function! s:ToggleCommentVisual() abort
  " visual range is provided by '< and '>
  call <SID>ToggleCommentRange(line("'<"), line("'>"))
endfunction

" Enhanced version with proper escaping and visual feedback
augroup quickfix_filter
  autocmd!
  autocmd FileType qf nnoremap <buffer> <leader>d :call FilterQuickfix('delete')<CR>
  autocmd FileType qf nnoremap <buffer> <leader>k :call FilterQuickfix('keep')<CR>
augroup END

function! FilterQuickfix(action) abort
  " Get the current search pattern
  let search_pattern = @/
  
  if empty(search_pattern)
    return
  endif
  
  " Escape the pattern for use in filter()
  let escaped_pattern = escape(search_pattern, '\"')
  
  " Get current quickfix list
  let qflist = getqflist()
  
  if empty(qflist)
    return
  endif
  
  let original_count = len(qflist)
  
  if a:action ==# 'delete'
    " Delete entries that match the search pattern (case-insensitive)
    let filtered = filter(copy(qflist), 
          \ 'tolower(v:val.text) !~? "' . escaped_pattern . '"')
    let action_text = 'deleted'
  else " 'keep'
    " Keep only entries that match the search pattern (case-insensitive)
    let filtered = filter(copy(qflist), 
          \ 'tolower(v:val.text) =~? "' . escaped_pattern . '"')
    let action_text = 'kept'
  endif
  
  let new_count = len(filtered)
  
  if new_count == original_count
    return
  endif
  
  " Update the quickfix list
  call setqflist(filtered, 'r')
  
  " Show quickfix window with updated list
  call s:RefreshQuickfixWindow()
endfunction

function! s:RefreshQuickfixWindow() abort
  " If we're in a quickfix window, refresh it
  if &buftype ==# 'quickfix'
    " Save current position
    let saved_view = winsaveview()
    
    " Refresh the list
    cclose
    copen
    
    " Restore position if possible
    if line('.') <= line('$')
      call winrestview(saved_view)
    endif
  endif
endfunction
