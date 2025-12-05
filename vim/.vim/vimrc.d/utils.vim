" Autocompletion
function! MyUtilshas_words_before() abort
  let col = col('.') - 1
  return col > 0 && getline('.')[col - 1] !~# '\s'
endfunction

" Ripgrep
function! MyUtilsRGPrompt() abort
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

function! MyUtilsGdTagsElseNormal() abort
	let l:sym = expand('<cword>')

	" If an exact tag exists, jump via tags
	if exists('*taglist') && !empty(taglist('^' . escape(l:sym, '\') . '$'))
		execute "normal! \<C-]>"
		return
	endif

	" Otherwise keep Vim's default gd behavior
	execute "normal! gd"
endfunction

"
" Ripgrep
"
" Use ripgrep to search for references of word under cursor (whole word) into quickfix
function! MyUtilsReferencesRgWord() abort
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
		let @/=l:word
	endif
endfunction

" Visual references: uses the current visual selection
function! MyUtilsReferencesRgVisual() abort
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
		let @/=l:text
	endif
endfunction

"
" Comments
"
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
function! MyUtilsToggleCommentRange(l1, l2) abort
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

function! MyUtilsToggleCommentLine() abort
	call <SID>ToggleCommentRange(line('.'), line('.'))
endfunction

function! MyUtilsToggleCommentVisual() abort
	" visual range is provided by '< and '>
	call <SID>ToggleCommentRange(line("'<"), line("'>"))
endfunction

"
" QUICKFIX LIST
"
" Enhanced version with proper escaping and visual feedback
augroup quickfix_filter
	autocmd!
	autocmd FileType qf nnoremap <buffer> <leader>d :call FilterQuickfix('delete')<CR>
	autocmd FileType qf nnoremap <buffer> <leader>k :call FilterQuickfix('keep')<CR>
augroup END

function! FilterQuickfix(action) abort
	let search_pattern = @/
	if empty(search_pattern) 
		echo "No search pattern"
		return 
	endif

	let qflist = getqflist()
	if empty(qflist)
		echo "Quickfix is empty"
		return 
	endif

	let original_count = len(qflist)
	let filtered = []

	for entry in qflist
		" Get filename from bufnr
		let filename = has_key(entry, 'bufnr') ? bufname(entry.bufnr) : ''
		let text = get(entry, 'text', '')

		" Use the pattern as-is (user typed regex)
		" =~? is case-insensitive matching
		let matches = (!empty(filename) && filename =~? search_pattern) ||
					\ (!empty(text) && text =~? search_pattern)

		" Add to filtered list based on action
		if (a:action ==# 'delete' && !matches) || (a:action ==# 'keep' && matches)
			call add(filtered, entry)
		endif
	endfor

	let new_count = len(filtered)
	if new_count == original_count
		echo "No changes"
		return
	endif

	call setqflist(filtered, 'r')

	let change = abs(original_count - new_count)
	echo (a:action ==# 'delete' ? 'Removed ' : 'Kept ') . change . ' entries'
endfunction

function! MyUtilsRefreshQuickfixWindow() abort
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

"
" ---- fd-powered smart file opener with completion ----
"
if executable('fd')
  function! MyUtilsFdComplete(ArgLead, CmdLine, CursorPos) abort
    let l:cmd = 'fd --hidden --follow --full-path --type f -- '
          \ . shellescape(a:ArgLead) . ' .'
    let l:res = systemlist(l:cmd)
    return map(l:res, {_, v -> v =~# '^\./' ? v[2:] : v})
  endfunction

  function! MyUtilsSmartFdOpen(query) abort
    let l:cmd = 'fd --hidden --follow --full-path --type f -- '
          \ . shellescape(a:query) . ' .'
    let l:matches = systemlist(l:cmd)

    if empty(l:matches)
      echohl WarningMsg | echom 'F: no matches for: ' . a:query | echohl None
      return
    endif

    call map(l:matches, {_, v -> v =~# '^\./' ? v[2:] : v})

    if len(l:matches) == 1
      execute 'edit ' . fnameescape(l:matches[0])
      return
    endif

    call setqflist(map(l:matches, {_, v -> {'filename': v}}), 'r')
    copen
    cc
  endfunction

  command! -nargs=1 -complete=customlist,MyUtilsFdComplete F call MyUtilsSmartFdOpen(<q-args>)
  nnoremap <leader>f :F<Space>
endif
