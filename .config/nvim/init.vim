" Enable syntax highlighting and line numbers
syntax on                          " Turn on syntax highlighting
set number                         " Show line numbers
set relativenumber                 " Show relative line numbers

" Set indentation and tabs
set tabstop=4                      " Number of spaces a <Tab> in the file counts for
set shiftwidth=4                   " Number of spaces to use for each step of (auto)indent
set expandtab                      " Use spaces instead of tabs
set autoindent                     " Maintain indent of current line
set smartindent                    " Automatically indent new lines

" Enable line wrapping and search settings
set wrap                           " Enable line wrapping
set ignorecase                     " Ignore case when searching
set smartcase                      " Override ignorecase if search includes capital letters
set incsearch                      " Show matches as you type
set hlsearch                       " Highlight search matches

" Display settings
" set cursorline                     " Highlight the current line
set showcmd                        " Display incomplete commands
set wildmenu                       " Enhanced command line completion
set scrolloff=8                    " Keep 8 lines visible above/below cursor when scrolling

" Enable mouse support and clipboard
set mouse=a                        " Enable mouse usage in all modes
set clipboard+=unnamedplus          " Use system clipboard for copy-paste

" Better backspacing and undo options
set backspace=indent,eol,start     " Make backspace more powerful
set undofile
set undodir=~/.local/share/nvim/undo

" Status line and color scheme
set laststatus=2                   " Always show the status line
set ruler                          " Show cursor position in the status line
colorscheme slate                  " Set color scheme (you can choose another)
set background=dark                " Preferred background for better contrast

" Split window preferences
set splitbelow                     " Horizontal splits open below
set splitright                     " Vertical splits open to the right

" Basic key mappings for productivity
nnoremap <Space> :nohlsearch<CR>   " Clear search highlights with <Space>
nnoremap <C-n> :bn<CR>             " Move to the next buffer with Ctrl+n
nnoremap <C-p> :bp<CR>             " Move to the previous buffer with Ctrl+p
vnoremap <C-c> :silent w !clip.exe<CR>

" Enable filetype plugins and indentation
filetype plugin indent on          " Enable filetype-specific plugins and indentation
