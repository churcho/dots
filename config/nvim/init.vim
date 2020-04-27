if &compatible
  set nocompatible        " If called from vim, make sure it's nocompatible
endif

" support mouse operations (click, scroll, etc)
" also prevents copying line # when using mouse
" actually scrap that, disable mouse everywhere
if has('mouse')
  set mouse-=a
endi

colorscheme ibhagwan      " set our custom color scheme

set ruler                 " show line,col at the nvim cmdline
set showmode              " show current mode (insert, etc) under the cmdline
set showcmd               " show current command under the cmd line
set cmdheight=1           " cmdline height
set laststatus=2          " 2 = always show status line (filename, etc)
set scrolloff=3           " min number of lines to keep between cursor and screen edge
set number                " show the number ruler
set relativenumber        " show relative numbers in the ruler
set splitbelow splitright " splits open bottom right

if has('nvim')
  set cursorline          " Show a line where the current cursor is
  set wildoptions=pum     " Show completion items using the pop-up-menu (pum)
" set pumblend=8          " Give the pum some transparency

  highlight PmenuSel blend=0

  " Make sure the terminal buffer has no numbers and no sign column
  autocmd TermOpen * :setlocal signcolumn=no nonumber norelativenumber
endif

" Enable 24 bit colors if we can
if (has("termguicolors"))
  "set termguicolors
  syntax on
else
  set t_Co=8
endif

"show the current unicode character value in the statusline
"https://vim.fandom.com/wiki/Showing_the_ASCII_value_of_the_current_character
"set statusline=%02n:%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" invisible characters to use on ':set list'
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:␣
set showbreak=↪\
" find out which char you want using the below
" `xfd -fn -xos4-terminus-medium-r-normal--32-320-72-72-c-160-iso10646-1`
" `xfd -fa "InputMono Nerd Font"`
" special chars can be inputed in nvim with the sequence
" `ctrl-v, u, xxxx` xxxx being the char hex code
" 0x2587=▇
" 0x2591=░
" 0x2592=▒
" 0x21bb=↻
" 0x21b5=↵
" 0x2192=→
"set listchars=tab:→\ ,eol:↵,nbsp:▒,trail:•,extends:⟩,precedes:⟨,space:▇
"set showbreak=↻\
set wrap breakindent    " start wrapped lines indented
set linebreak           " do not break words on wrap

" default <tab> behavior
set expandtab smarttab tabstop=2 softtabstop=2 shiftwidth=2

" searching
set hlsearch            " highlight all text matching current search pattern
set incsearch           " show search matches as you type
set ignorecase          " ignore case on search
set smartcase           " case sensitive when search includes uppercase
set showmatch           " highlight matching [{()}]
set splitbelow          " open new splits on the bottom
set splitright          " open new splits on the right"
set inccommand=nosplit  " show search and replace in real time
set autoread            " reread a file if it's changed outside of vim
set wrapscan            " begin search from top of the file when nothng is found
set cpoptions+=x        " stay at seach item when <esc>

" vim clipboard copies to system clipboard
" unnamed     = use the * register (cmd-s paste in our term)
" unnamedplus = use the + register (cmd-v paste in our term)
set clipboard=unnamedplus

" text formatting
set encoding=utf-8

set wildmenu            " visual autocomplete for the command menu
set lazyredraw          " redraw only when we need to.
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
"set colorcolumn=80     " mark column 80
set modelines=1         " read a modeline on the last line of the file
set autoindent          " autoindent
set smartindent         " add <tab> depending on syntax (C/C++)
"set diffopt+=vertical  " :Gdiffsplit vertical split (vim-fugitive)
                        " use :Gvdiffsplit :Ghdiffsplit

" show menu even for one item do not auto select/insert
" IMPORTANT: :help Ncm2PopupOpen for more information
 set completeopt=noinsert,menuone,noselect


" recommended settings for coc.vim
set hidden              " TextEdit might fail if hidden is not set.
set nobackup            " Some servers have issues with backup files, see #649:
set nowritebackup       " https://github.com/neoclide/coc.nvim/issues/649
"set cmdheight=2        " Give more space for displaying messages.

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved. We set this individually for code files
"set signcolumn=yes

" Python setup
if has('nvim')
  let g:python_host_prog  = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
endif


" Keybinds
source ~/.config/nvim/keymap.vim

" Filetypes
source ~/.config/nvim/filetypes.vim

" Plugins
source ~/.config/nvim/plugins.vim

" disable auto commenting, must be last line as plugins may overwrite
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
