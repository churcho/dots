" {{{ Keymaps
"

" map leader as <space>
nnoremap <Space> <nop>
let mapleader ="\<Space>"

" by default `d` is a "cut" and copies the text into the unnamed register
" which in our case is the clipboard, bind <space>-d to "real delete" op
" we remap x,c and s to as "real delete" (i.e. no copy to register)
" <space>-p paste over selected text in visual mode (no copy to register)
" <space>-v and <space>-s are used to mimc term cmd-v and cmd-s pastes
" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
xnoremap <leader>p "_dP
nnoremap <leader>v "+p
xnoremap <leader>v "+p
nnoremap <leader>s "*p
xnoremap <leader>s "*p
" s|ss|S is also mapped "real delete"
" x|c do not copy deleted text to register
nnoremap s <nop>
nnoremap s "_d
xnoremap s "_d
nnoremap S "_D
xnoremap S "_D
nnoremap ss "_dd
nnoremap x "_x
xnoremap x "_x
nnoremap c "_c
xnoremap c "_c
nnoremap C "_C
xnoremap C "_C
nnoremap cc "_cc

" Fix some common typos
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Beginning and end of line
imap <C-a> <home>
imap <C-e> <end>
cmap <C-a> <home>
cmap <C-e> <end>

" Control-S Save
nmap <C-S> :w<cr>
vmap <C-S> <esc>:w<cr>
imap <C-S> <esc>:w<cr>

" keep visual selection when (de)indenting
vmap < <gv
vmap > >gv

" move along visual lines, not numbered ones
nnoremap j gj
nnoremap k gk
nnoremap ^ g^
nnoremap $ g$
vnoremap j gj
vnoremap k gk
vnoremap ^ g^
vnoremap $ g$

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" more <C-w> split shortcuts
" <space>-up    - max split height
" <space>-right - max split width
" <space>-left  - normalize split sizes
" <space>-down  - normalize split sizes
" <space>-o     - close all splits but current
" <space>-R     - swap top/bottom or left/right
" <space>-T     - detach current split to a tab
noremap <silent> <C-S-Up> :resize +4<CR>
noremap <silent> <C-S-Down> :resize -4<CR>
noremap <silent> <C-S-Left> :vertical resize -4<CR>
noremap <silent> <C-S-Right> :vertical resize +4<CR>
noremap <silent> <leader><Up> <C-w>_
noremap <silent> <leader><Down> <C-w>=
noremap <silent> <leader><Right> <C-w>\|
noremap <silent> <leader><Left> <C-w>=
noremap <silent> <leader>o <C-w>o
noremap <silent> <leader>R <C-w>R
noremap <silent> <leader>T <C-w>T
noremap <silent> <leader>N :new<CR>


" Tab management
nnoremap <C-Left>           :tabprevious<CR>
nnoremap <C-Right>          :tabnext<CR>
nnoremap <silent> <A-Left>  :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Toggle all buffers into tabs with <Space>-t
let notabs = 0
nnoremap <silent> <Leader>t
  \ :let notabs=!notabs<CR>
  \ :if notabs<CR>:tabo<CR> 
  \ :else<CR>:tab ball<CR>:tabn<CR>
  \ :endif<CR>


" Turn off search matches with double-<Escape>
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Toggle display of `listchars`
nnoremap <silent> <leader>l <Esc>:set list!<CR><Esc>

" Toggle colored column at 81
nnoremap <silent> <leader>; :execute "set colorcolumn="
                \ . (&colorcolumn == "" ? "81" : "")<CR>


" }}}
"
" {{{ popup menu options (auto-complete)
"

" remap j,k for navigation inside popup menus
" we utilize v:completed_item so we can continue typing
" before any item is selected (before <tab> or arrows were used)
inoremap <expr>j (pumvisible()?(empty(v:completed_item)?'j':"\<C-n>"):'j')
inoremap <expr>k (pumvisible()?(empty(v:completed_item)?'k':"\<C-p>"):'k')

" <Tab> to enter menu and also select first item
inoremap <expr><Tab> (pumvisible()?
  \ (empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")

" <Esc> to close popup menus and delete selection
" <ctrl-c> will revert selection and switch to normal mode
inoremap <expr> <Esc> (pumvisible() ? "\<c-e>" : "\<Esc>")
inoremap <expr> <c-c> (pumvisible() ? "\<c-e>\<c-c>" : "\<c-c>")

" Make up/down arrows behave in completion popups
" without this they move/down but v:completed_item remains empty
inoremap <expr> <down> (pumvisible() ? "\<C-n>" : "\<down>")
inoremap <expr> <up>   (pumvisible() ? "\<C-p>" : "\<up>")

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <Tab> already mapped above, this mapping from coc is not useful
" as it is cumbersome and prevents tabbing after a word, we keep
" our own <Tab> mapping and use <S-Tab> for coc expand instead
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
inoremap <expr><S-TAB> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" }}}
"
" {{{ Plugin Keymaps
"

" Below doesn't work with nvim, we use the suda plugin instead
" Allow saving of files as sudo when I forgot to start vim using sudo.
"cmap w!! w !sudo tee > /dev/null %

" Suda plugin: `w!!` to write as root
cmap w!! w suda://%

" Previm plugin
map <silent> <leader>M <Esc>:PrevimOpen<CR>

" vim-fugitive
map <silent> <leader>uu <Esc>:Git<CR>
map <silent> <leader>ul <Esc>:Git log<CR>
map <silent> <leader>us <Esc>:Git status<CR>
map <silent> <leader>ud <Esc>:Git diff<CR>
map <silent> <leader>uy <Esc>:Git difftool<CR>
map <silent> <leader>ui <Esc>:Git mergetool<CR>
map <silent> <leader>uh <Esc>:Ghdiffsplit<CR>
map <silent> <leader>uv <Esc>:Gvdiffsplit<CR>

" coc-explorer, presets are defined in plugins.vim
map <leader>e :CocCommand explorer<CR>
nmap <leader>nd :CocCommand explorer --preset .nvim<CR>
nmap <leader>nf :CocCommand explorer --preset floating<CR>


" === Denite shorcuts === "
"   ;         - Browse currently open buffers in normal mode
"   <leader>b - Browse currently open buffers in insert mode (filter)
"   <leader>m - Browse current marks (output of :marks)
"   <leader>j - Browse current jumplist (output of :jumps)
"   <leader>w - Browse list of files in current directory
"   <leader>f - Search current directory for occurences of given term and close window if no results
"   <leader>g - Search current directory for occurences of word under cursor
nmap <silent> ; :Denite buffer<CR>
nmap <leader>m :Denite mark<CR>
nmap <leader>j :Denite jump<CR>
nmap <leader>b :Denite buffer<CR>i
nmap <leader>w :DeniteBufferDir file/rec<CR>
nnoremap <leader>f :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>g :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o> or <C-c>  - Switch to normal mode inside of search results
"   <Esc>           - Exit denite window in any mode
"   <CR>            - Open currently selected file in any mode
"   <C-t>           - Open currently selected file in a new tab
"   <C-v>           - Open currently selected file a vertical split
"   <C-h>           - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  imap <silent><buffer> <C-c>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected buffer
"   q or <Esc>  - Quit Denite window
"   i or <C-o>  - Switch to insert mode inside of filter prompt
"   d           - Delete currenly selected buffer
"   p           - Preview currently selected buffer
"   t           - Open currently selected buffer in a new tab
"   v           - Open currently selected buffer in a vertical split
"   b           - Open currently selected buffer in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> ;
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> t
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> b
  \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
endfunction


" === coc.nvim === "
" F12    <leader>d    - Jump to definition of current symbol
" S-F12  <leader>r    - Jump to references of current symbol
"        <leader>y    - Jump to typedef of current symbol
"        <leader>i    - Jump to implementation of current symbol
"        <leader>cr   - Rename current word
"        <leader>.    - Code action current line
"        <leader>,    - Autofix current line error
"        <leader>a    - Code action selected region
"                       ex: `<leader>aap` for current paragraph
"        <leader>z    - Format selection region
"        <leader>cx   - List all Coc commands
"        <leader>F    - Fuzzy search current project symbols
"        <leader>cf   - Fuzzy search current project symbols
"        <leader>S    - Fuzzy search current document symbols 
"        <leader>cs   - Fuzzy search current document symbols 
"        <leader>ca   - Show all project diagnostics
"        <leader>C    - Resume last Coc action
"        <leader>x    - Resume last Coc action
"       `[c` | `]c`   - diagnostics next/prev
"        <leader>-/   - show documentation in preview window
"        <leader>-?   - show func signature in preview window
nmap <F12>      <Plug>(coc-definition)
nmap <S-F12>    <Plug>(coc-references)
nmap <leader>d  <Plug>(coc-definition)
nmap <leader>r  <Plug>(coc-references)
nmap <leader>y  <Plug>(coc-type-definition)
nmap <leader>i  <Plug>(coc-implementation)
nmap <leader>cr <Plug>(coc-rename)
nmap <leader>.  <Plug>(coc-codeaction)
nmap <leader>,  <Plug>(coc-fix-current)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
xmap <leader>z  <Plug>(coc-format-selected)
nmap <leader>z  <Plug>(coc-format-selected)
nnoremap <leader>cx :<C-u>CocList -N --normal --top commands<cr>
nnoremap <leader>F  :<C-u>CocList -I -N --top symbols<CR>
nnoremap <leader>cf :<C-u>CocList -I -N --top symbols<CR>
nnoremap <leader>S  :<C-u>CocList -N --top outline<cr>
nnoremap <leader>cs :<C-u>CocList -N --top outline<cr>
nnoremap <leader>ca :<C-u>CocList -N --top --normal diagnostics<cr>
nnoremap <leader>C  :<C-u>CocListResume<CR>
nnoremap <leader>x  :<C-u>CocListResume<CR>
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nnoremap <leader>? :call CocAction("showSignatureHelp")<CR>
nnoremap <leader>/ :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" }}}
