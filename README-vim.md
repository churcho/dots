# iBhagwan's (n)vim cheatsheet

\*\*This cheatsheet was inspired by [Hackjutsu's Vim cheatsheet](https://github.com/hackjutsu/vim-cheatsheet).

I've been using vi for over 20 years but always limited it's use for basically only editing \*nix system config files, recently I (re-)discovered (n)vim as the magical editor that it is and decided to make it my main editor for coding, writing markdown and the likes so down the rabbit hole I went. The more I researched the more I fell in love with the software, the below is the accumulation of all my notes and findings.

The cheatsheet assumes at least minimal understanding of motions and operators, to better understand motions, operators and how it all comes together in what is referred to as "the vim language" I highly recommend reading [Jim Denis's stackoverflow answer: Your problem with Vim is that you don't grok vi](https://gist.github.com/nifl/1178878).

Note that everything below works with vanilla vim/nvim and does not require the use of any plugins. I am not opposed to plugins and even use a few which I find extremely helpful but as a philosophy I try to use as much built-in functionality (with minimal keymap changes) as I can before turning to plugins. As you can see below there is **so much** you can do with vanilla Vim that I decided to leave plugins out of the scope of this document.

**Thanks to [/u/-romainl-](https://www.reddit.com/user/-romainl-/) for [his great feedback](https://www.reddit.com/r/vim/comments/gha79v/i_wrote_an_advanced_comprehensive_cheatsheet_for/fq7qeop?utm_source=share&utm_medium=web2x) correcting previous inaccuracies.**


### Table of contents:

- [Saving & Exiting Vim](#saving-exiting-vim)
- [NORMAL mode navigation](#normal-mode-navigation)
- [INSERT mode](#insert-mode)
- [NORMAL mode editing](#normal-mode-editing)
- [Cut, copy & paste](#cut-copy-and-paste)
- [Text Objects](#text-objects)
- [VISUAL mode selections](#visual-mode-selections)
- [VISUAL mode operations](#visual-mode-operations)
- [Search and replace](#search-and-replace)
- [Searching multiple files](#searching-multiple-files)
- [Macros](#macros)
- [Marks](#marks)
- [Files and Windows](#files-and-windows)
- [Tabs](#tabs)
- [Terminal](#term)
- [Spellcheck](#spellcheck)
- [Misc Commands](#misc-commands)
- [Ctrl-R and the Expression Register](#ctrl-r-and-the-expression-register)

## <a id="saving-exiting-vim">Saving & Exiting Vim</a>
```vim
:w              " write the current file
:wq {file}      " write to {file} and quit
:w {file}       " write to {file}
:saveas {file}  " write to {file}
:w !sudo tee %  " write the current file using sudo
:wq or :x or ZZ " write the current file and quit
:q              " quit (fails if there are unsaved changes)
:q! or ZQ       " quit and throw away unsaved changes
```

## <a id="normal-mode-navigation">NORMAL mode navigation</a>
```vim
    k           " up
h       l       " left-right
    j           " down
```
```vim
+               " move to start of line below
-               " move to start of line above
H               " move to top of screen    [H]igh
M               " move to middle of screen [M]iddle
L               " move to bottom of screen [L]ow
w               " jump forwards to the start of a word
W               " jump forwards to the start of a word (words can contain punctuation)
e               " jump forwards to the end of a word
E               " jump forwards to the end of a word (words can contain punctuation)
ge              " jump backwards to the end of a word
gE              " jump backwards to the end of a word (words can contain punctuation)
b               " jump backwards to the start of a word
B               " jump backwards to the start of a word (words can contain punctuation)
0               " jump to the start of the line
^               " jump to the first non-blank character of the line
$               " jump to the end of the line
g_              " jump to the last non-blank character of the line
gg              " go to the first line of the document
G               " go to the last line of the document
{count}G        " go to line number {count}
f{char}         " jump to next occurrence of character {char}
F{char}         " jump to previous occurrence of character {char}
t{char}         " jump to (t)ill (one char before) next occurrence of {char}
T{char}         " jump to (t)ill (one char before) previous occurrence of {char}
{               " jump to previous paragraph (or function/block, when editing code)
}               " jump to next paragraph (or function/block, when editing code)
%               " jump to matching parenthesis ([{}])
zz or z.        " center screen on cursor
zb              " scroll the screen so the cursor is at the (b)ottom
zt              " scroll the screen so the cursor is at the (t)op
<ctrl-b>        " move back one full screen
<ctrl-f>        " move forward one full screen
<ctrl-d>        " move forward 1/2 a screen
<ctrl-u>        " move back 1/2 a screen
<ctrl-e>        " scroll the screen up
<ctrl-y>        " scroll the screen down
<ctrl-o>        " jump to previous location in :jumps
<ctrl-i>        " jump to next location in :jumps
``              " jump to last known location (automatic mark)
```

**Note:** When navigating lines with `hjkl^$`, if a line is too long and is wrapped, pressing `j` will move down to the next line even if the current line is wrapping 2 or more lines, to go down 1 "visual" line use `gj` instead. The `g` prefix works the same for other navigation commands `hjkl^$` (`g^` and `g$` for start and end of visual line). A very useful mapping is to map `<up><down>` or `jk` to move by visual lines as long as they aren't prefixed with {count} so we can still use up and down motions (e.g. `10j`) for whole lines:

```
nnoremap <expr> <Down> (v:count == 0 ? 'g<down>' : '<down>')
vnoremap <expr> <Down> (v:count == 0 ? 'g<down>' : '<down>')
nnoremap <expr> <Up> (v:count == 0 ? 'g<up>' : '<up>')
vnoremap <expr> <Up> (v:count == 0 ? 'g<up>' : '<up>')
```

## <a id="insert-mode">INSERT mode</a>
```vim
<Esc>           " exit insert mode
<ctrl-c>        " exit insert mode
i               " insert before the cursor
I               " insert at the beginning of the line
a               " insert (append) after the cursor
A               " insert (append) at the end of the line
o               " append (open) a new line below the current line
O               " append (open) a new line above the current line
```
### When in INSERT mode (most work also in ex mode):
```vim
<ctrl-u>        " delete to line start or delete newline (on empty lines)
<ctrl-d>        " delete from start of line to first non-blank character
<ctrl-y>        " put text from the above line column
<ctrl-w>        " delete a word backwards
<ctrl-r>{reg}   " put register {reg}
```

**Note:** Any NORMAL mode operator can be run from INSERT mode by using `<ctrl-o>{op}` or `<alt+{op}>` (only works on some keyboards). Alternatively, if we're in ex mode we can use `:norm {cmd}`. For example: say we want to append text at the end of the line we can simply press `<alt+A>` or `<ctrl-o>A` which will take us to the end of the line, all without leaving INSERT mode. The same can be achieved from ex mode with `<Esc>:norm A`, even though the latter isn't useful for this specific example it can be useful in many other cases where more complex commands are required (e.g. using the `global` command: `:g/regex/norm >>` will indent all lines matching the regex)

## <a id="normal-mode-editing">NORMAL mode editing</a>
```vim
u               " undo
U               " undo all changes to current line
<ctrl-r>        " redo
.               " repeat last edit
{count}.        " repeat last edit {count} times
```
```vim
x               " delete a single character (on cursor)
X               " delete a single character (before cursor)
r               " replace a single character
R               " enter REPLACE mode, cursor overwrites everything
~               " switch case a single character
J               " join line below to the current one (with space)
gJ              " join line below to the current one (no space)
dd              " delete (cut) entire line 
dw              " delete (cut) to the next word
cc              " change (replace) entire line
cw              " change (replace) to the end of the current word
caw             " change (replace) the current word (including spaces)
ciw             " change (replace) the current word (not including spaces)
ce              " change (replace) forwards to the end of a word
cb              " change (replace) backwards to the start of a word
c0              " change (replace) to the start of the line
c$              " change (replace) to the end of the line
C               " change (replace) to the end of the line
s               " delete character and substitute text
S               " delete line and substitute text (same as cc)
xp              " transpose two letters (delete and paste)
ylxp            " transpose two letters (yank, delete and paste)
vyxp            " transpose two letters (yank, delete and paste)
>>              " indent current line right
<<              " indent current line left
<ctrl-a>        " find number in current line and increment by 1
<ctrl-x>        " find number in current line and decrement by 1
{count}:        " will translate {count} to :{range} in ex mode
```

**Notes:**
- All (c)hange commands end with the editor in INSERT mode

- All double-char commands (i.e. `dd`, `cc`, `yy`, etc) can be thought of as a shortcut to `0{operator}V$` (we use `<shift-v>` to switch to linewise VISUAL mode so that `$` will include the EOL), the breakdown is as follows:
```vim
    0           " go to the start of the line
    {operator}  " {operator} of your choice
    V           " enter linewise VISUAL mode
    $           " go the end of the line
```

- The above can also be combined with a {count} prefix, for example 2dd will delete 2 lines below. A similar result could also be achieved using the full expression of the operator and motion: `{operator}{count}{motion}`, i.e. `d1j` will delete 2 lines down (cursor line + 1 down) and `y2w` will yank 2 words forward. In similar fashion the VISUAL mode operator `v` can be used, e.g. `vi}` will visually select everything inside the curly braces.

## <a id="cut-copy-and-paste">Cut, copy and paste</a>
```vim
p               " (p)ut or (p)aste clipboard after cursor
P               " (p)ut or (p)aste clipboard before cursor
yy              " yank (copy) a line
{count}yy       " yank (copy) {count} lines
yl              " yank a single character (l = to the right)
vy              " yank a single character (using VISUAL mode)
yw              " yank (copy) to the next word
yiw             " yank (copy) (i)nner word (entire word)
yaw             " yank (copy) (a) word (entire word, including spaces
y$              " yank (copy) to end of line
dd              " delete (cut) a line
{count}dd       " delete (cut) {count} lines
dw              " delete (cut) to the next word
D               " delete (cut) to the end of the line
d$              " delete (cut) to the end of the line
d^              " delete (cut) to the first non-blank character of the line
d0              " delete (cut) to the beginning of the line
x               " delete (cut) character
"+p             " paste the `+` register (the clipboard)
"{reg}p         " paste {reg} (:registers)
"{reg}yy        " yank current line into {reg} (:registers)
"_dd            " delete line into the 'blackhole' register (no clipboard)
```
Copy paste using ex mode:
```vim
:{range}co{line}    " copy {range} to {line}
:-2co .             " copy line 2 above cursor to line below cursor
:+2co 0             " copy line 2 below cursor to start of file
:.,$co $            " copy all lines from the cursor to end of file to end of file
:1,3co 5            " copy lines 1-3 to below line 5
```

**Notes:**
- To paste a register directly from INSERT or ex mode use `<ctrl-r>` followed by a register name.

- By default the `Y` command is mapped to `yy` (yank line) which isn't consisnt with the behaviors of `C` and `D` (from cursor to end of line), a very useful mapping for both NORMAL and VISUAL mode is:

```vim
    nnoremap Y y$
    xnoremap Y <Esc>y$gv
```

- By default all modification operators `dcx` copy the modified text to the unnamed `"` register (unless `set clipboard` was set) which can be confusing at first. For example, let's say we want to overwrite a word with yanked text, we would naturally do `ciw<Esc>p` or `ciw<ctrl-r>"` only to find out the same word would be pasted (and not our yanked text), to work around that we can tell the `c` operator to copy the text into the 'blackhole' register instead: `"_ciw`. A few useful mappings for my leader key (by default `\`, personally I use `\<space>`) are below, so if I want to change a word without it polluting my registers I would run `<leader>bciw`, similarly if I wish to delete a line I would run `<leader>dd`:

```vim
    nnoremap <leader>b "_
    nnoremap <leader>d "_d
    nnoremap <leader>D "_D
    nnoremap <leader>dd "_dd
    xnoremap <leader>b "_
    xnoremap <leader>D "_D
    xnoremap <leader>D "_D
    xnoremap <leader>x "_x
```

## <a id="text-objects">Text Objects</a></a>
```vim
aw              " a word (includes surrounding white space
iw              " inner word (does not include surrounding white space)
as              " a sentence
is              " inner sentence
ap              " a paragraph
ip              " inner paragraph
a"              " a double quoted string
i"              " inner double quoted string
a'              " a single quoted string
i'              " inner single quoted string
a`              " a back quoted string
i`              " inner back quoted string
a) or ab        " a parenthesized block
i) or ib        " inner parenthesized block
a]              " a bracketed block
i]              " inner bracketed block
a} or aB        " a brace block
i} or iB        " inner brace block
at              " a tag block e.g. <a></a>
it              " inner tag block e.g. <a></a>
a>              " a single tag
i>              " inner single tag
gn              " next occurrence of search pattern
```
**Notes:**
- Text objects can be used with any operator, e.g. `dit` will delete "some text" from `<a>some text</a>` and `yat` will copy the entire tag into the clipboard. For more information [Jared Caroll's: Vim Text Objects: The Definitive Guide](https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/).

- `gn` is a very useful text object, few examples: `cgn` will change the next search pattern match, `vgn` will visually select all text from the cursor to the next match. For more information read [Bennet Hardwick's blog: 8 Vim tips and tricks for advanced beginners](https://bennetthardwick.com/blog/2019-01-06-beginner-advanced-vim-tips-and-tricks/).

## <a id="visual-mode-selections">VISUAL mode selections</a>
```vim
<Esc>           " exit visual mode
<ctrl-c>        " exit visual mode
v               " start VISUAL mode in 'character' mode
V               " start VISUAL mode in 'line' mode
<ctrl-v>        " start VISUAL mode in 'block' mode
o               " move to other end of marked area
O               " move to other corner of block
$               " select to end of line (include newline)
g_              " select to end of line (exclude newline)
aw              " select a word
ab              " select a block with ()
aB              " select a block with {}
ib              " select inner block with ()
iB              " select inner block with {}
gv              " NORMAL mode: reselect last visual selection
```

**Notes:**
- The above are just some of the available commands as any text object or motion can be used, e.g. `viw` will visually select current word or `vat` will select an entire tag: `<a>some text</a>`

- A neat trick you can do with VISUAL mode is using visual modes as motion operators, If you perform `d2j`, it will delete all three lines. That’s because `j` is a linewise motion. If you instead pressed `d<c-V>2j`, it would convert the motion to blockwise and delete just the column characters instead. For more information read [Hillel Wayne's blog: At least one Vim trick you might not know](https://www.hillelwayne.com/post/intermediate-vim/).

## <a id="visual-mode-operations">VISUAL mode operations</a>
```vim
~               " switch case
d               " delete
c               " change
y               " yank
>               " indent right 
<               " indent left 
!               " filter through external command 
=               " filter through 'equalprg' option command 
gq              " format lines to 'textwidth' length 
gu              " make selection lower-case
gU              " make selection UPPER-case
{num}g<ctrl-a>  " increment current selection by {num}
{num}g<ctrl-a>  " decrement current selection by {num}
```

**Notes:**
- If you want to preform an {ex} command on visual selection press `:` (with selected visuals), vim will automatically prefix your ex command with the visual range `:'<,'>` so you can execute any command on the selected text, e.g. `:'<,'>norm @q` will execute macro `q` on all visually selected lines.

- When indenting (or any other operation) in VISUAL mode with `<>` you will find that once indented you lose the current selection, to visually reselect the text you can use `gv`, so to indent while keeping current selection use `<gv` and `>gv` respectively. Personally I never want to lose my selection when indenting hence I use the below mappings in my [keymap.vim](common/config/nvim/keymap.vim):

```vim
vmap < <gv
vmap > >gv
```

## <a id="search-and-replace">Search and replace</a>
```vim
#                           " search word under cursor backward
*                           " search word under cursor forward
/pattern                    " search for pattern
/pattern/{n}                " go to {-+n}th line below/above the match
?pattern                    " search backward for pattern
/<CR>                       " repeat search in same direction
?<CR>                       " repeat search in opposite direction
n                           " repeat search in same direction
N                           " repeat search in opposite direction
:noh                        " remove highlighting of search matches
:s/old/new/                 " replace first occurrence of old with new
:s/old/new/g                " replace all old with new throughout line ('globally')
:%s/old/new/g               " replace all old with new throughout file ('globally')
:%s/old/new/gc              " replace all old with new throughout file with confirmations
:%s/old/'&'/g               " surround all occurrences of old with ' (i.e. 'old')
:{range} s/old/new/         " replace all old with in {range} (e.g. `:10,20s/...`)
:{num},$ s/old/new/         " replace all old with new from line {num} to last line
:g/regex/{ex}               " run :{ex} for every line matching regex
:g!/regex/{ex}              " run :{ex} for every line NOT matching regex
:v/regex/{ex}               " same as above, shortcut to `:g!`
:g/regex/y {reg}            " copy all matching line to register {reg}
                            " capitalize {reg} to append instead
```

**Notes:**

- For more information on the different `.../g` modifiers read `:help s_flags`

- The `g` and `v` ex commands are extremely useful, few examples: `:g/pattern/d` or `:g/pattern/norm dd` will delete all lines matching `pattern`, you can also supply a range to the command: `:g/pattern/-1d` will delete one line above all lines matching `pattern`, same can be achieved with `:g/pattern/norm 1jdd`

- `:y {reg}` copies the range to the register {reg}. If {reg} is a capital letter register, this appends to the existing register, i.e. if we do `let @a = '' | %g/regex/y A` it will copy all lines matching regex in the entire file to register a. We can then copy the register to the system clipboard with `let @+ = @a`.

- Important note regarding the use of `:s` vs `:g`: `s` is a shortcut for `substitute` and `g` is a shortcut for `global`, therefore `s` should be used when doing search and replace (substitution) and `g` should be used when you'd like to execute a command for every match (not necessarily substitution), each has it's strength and it's a matter of using the right tool for the job. Example: say we wanted to substitute `bar` with `blah` for every line containing `foo`, we could achieve the same result with both but as you can see the `g` command would be a better fit in this case:

```vim
    g/foo/s/bar/blah/g  

    :%s/foo/\=substitute(getline('.'), 'bar','blah','g')
```
## <a id="searching-multiple-files">Searching multiple files</a>
```vim
:vimgrep /pattern/ {file} " search for pattern in multiple files
:copen                    " open the 'quickfix` window containing all matches
:cn                       " jump to the next match
:cp                       " jump to the previous match
```

## <a id="macros">Macros</a>
```vim
q{a-z}                  " start recording macro to register {a-z}
q                       " stop macro recording
@{a-z}                  " execute macro {a-z}
{count}@{a-z}           " execute macro {a-z} on {count} lines
@@                      " repeat execution of last macro
:'<,'>normal @q         " execute macro `q` on visual selection
"{a-z}p                 " paste macro {a-z} (register)
"{a-z}y$                " yank into macro {a-z} to end of line
```

**Notes:**
- Macros are essentially just a saved series of keystrokes, if you’re recording a macro and make a mistake, don’t start over, instead, undo it and keep going normally, using macro `q` as an example (recorded with `qq`), once you’re finished with the macro, press `"qp` to paste it to an empty line, remove the mistaken keystrokes and the undo and copy it back into the `q` register with `"qy$`.

- Don’t leave undos in your macro. If you undo in a macro to correct a mistake, always be sure to manually remove the mistake and the undo from the macro. In replay mode, an undo will undo the entire macro up until that point, erasing all of your hard work and bleeding the macro out into the rest of your text.

- The above was taken from [Hillel Wayne's blog: Vim Macro Tricks](https://www.hillelwayne.com/vim-macro-trickz/).

## <a id="marks">Marks</a>
```vim
:marks          " list current marks
m{a-z,A-Z}      " set mark at cursor position
                " {a-z} = local file marks
                " {A=Z} = cross file marks
'{a-z,A-Z}      " goto first non-blank character in mark {a-z,A-Z}
`{a-z,A-Z}      " goto exact cursor position of mark {a-z,A-Z}
```

## <a id="files-and-windows">Files and Windows</a>
```vim
:e {file}       " edit a file in a new buffer
:find {file}    " find and open file in &path (set path?)
gf              " find and open the file under the cursor
:cd %:h         " change pwd to folder of current buffer (all buffers)
:lcd %:h        " change pwd to folder of current buffer (local buffer)
:ls             " list all open buffers
:bnext or :bn   " go to the next buffer
:bprev or :bp   " go to the previous buffer
:bd             " delete a buffer (close a file)
:sp {file}      " open a file in a new buffer and split window
:vsp {file}     " open a file in a new buffer and vertically split window
:windo {ex}     " run :{ex} on all windows (e.g. :windo q - quits all windows)
:bufdo {ex}     " same as above for buffers
:on             " make current window the 'only' window (close all others)
<ctrl-w>o       " same as `:on` above
<ctrl-w>w       " jump to next window
<ctrl-w>r       " swap windows 
<ctrl-w>q       " quit a window
<ctrl-w>s       " split window horizontally
<ctrl-w>v       " split window vertically
<ctrl-w>h       " move cursor to the left window (vertical split)
<ctrl-w>l       " move cursor to the right window (vertical split)
<ctrl-w>j       " move cursor to the window below (horizontal split)
<ctrl-w>k       " move cursor to the window above (horizontal split)
<ctrl-^>        " jump to previous buffer
<ctrl-g>        " display filename of current buffer (file)
1<ctrl-g>       " display full path of current buffer (file)
2<ctrl-g>       " display buf # and full path of current buffer (file)
```

**Notes:**
- `:bufdo` and `:windo` can be used for multiple file/window operations, for example to search and replace in all open buffers you can run `:bufdo %s/old/new/g`

- `:find` and `gf` are both dependent on the `&path` variable which by default contains `.` which is the current working directory (`:pwd`), for said commands to be effective be sure to always open Vim from your project directory or use `cd` to change Vim's working directory (best done using `cd %:h`). If you would like `:find` and `gf` to find files recursively in all folders specified by `&path` be sure `path` contains `**`. Use `:set path+=**` if you wish to add `**` to the current `&path`. Personally, I define my path as: `set path=.,,,$PWD/**` (search current directory and project directory recursively).


## <a id="tabs">Tabs</a>
```vim
:tabnew or :tabnew {file}   " open a file in a new tab
<ctrl-w>T                   " move the current split window into its own tab
gt or :tabnext or :tabn     " goto to the next tab
gT or :tabprev or :tabp     " goto to the previous tab
{num}gt                     " goto to tab {num}
:tabmove {num}              " move current tab to the {num}th position (indexed from 0)
:tabclose or :tabc          " close the current tab and all its windows
:tabonly or :tabo           " close all tabs except for the current one
:tabdo {ex}                 " run :{ex} on all tabs (e.g. :tabdo q - closes all opened tabs)
```

## <a id="term">Terminal</a>
### Vim:
```vim
:term                       " open terminal window inside vim (default shell)
:term zsh                   " open terminal window inside vim (zsh)
:vert term zsh              " opens a new terminal in a horizontal split (zsh)
```
### Neovim:
```vim
:term                       " open terminal window inside vim
:split term://zsh           " opens a new terminal in a horizontal split
:vsplit term://zsh          " opens a new terminal in a vertical split
:new term://bash            " alternates for above commands
:vnew term://bash           " alternates for above commands
<ctrl-\> <ctrl-N>           " go back to NORMAL mode
```
### Both:
```vim
<ctrl-z>                    " suspend vim to background, `fg` in term to resume
:sus[pend][!] or st[op][!]  " suspend vim (equal to ctrl-z) if `!` is specified
                            " vim will write changes to all buffers before suspend
```

## <a id="spellcheck">Spellcheck</a>
```vim
:set spell                  " enable spellcheck for current buffer
:set nospell                " disable spellcheck for current buffer
:set spelllang={lang}       " set spellcheck lang, i.e. `en_us`
[s                          " find previous misspelled word
]s                          " find next misspelled word
z=                          " see spellcheck suggestions
zg                          " add current word to dictionary
```

## <a id="misc-commands">Misc commands</a>
```vim
:help {keyword}             " view help for {keyword}
:helpgrep {keyword}         " help search for {keyword}, open results with :cwindow
:read {file}                " read {file} below the cursor
:!{cmd}                     " execute shell command {cmd}
:read !{cmd}                " read output of {cmd} below cursor
:<ctrl-f> or q:             " enter command line window, <ctrl-c> or :q to exit
q/ or q?                    " same as above but for searches
:echo &{opt}                " echo Vim option to command line (expand values)
:set {opt}?                 " echo Vim option to commend line (no expand)
```

## <a id="ctrl-r-and-the-expression-register">Ctrl-R and the Expression Register</a>

The expression register (`=`) is used to evaluate expressions and can be accessed using `"=` from NORMAL and VISUAL modes and  `<ctrl-r>` from INSERT and ex command modes, it is very useful to insert registers and other input into the command line or directly to the document when you don't want to leave INSERT mode (useful so you can repeat the entire edit with `.`):

### INSERT and ex modes:
```vim
<Esc>:registers             " list registers and their values
<Esc>:put={expr}            " put value of {expr}<cr> into buffer
<ctrl-r>{reg}               " put register {reg}
<ctrl-r>={expr}             " put the value of {expr}
<ctrl-r>=[1,2,3]            " put 1<cr>2<cr>3<cr>
:<ctrl-r><ctrl-w>           " put word under cursor
:<ctrl-r><ctrl-a>           " put WORD under cursor (includes punctuation)
:<ctrl-r><ctrl-l>           " put current cursor line
:<ctrl-r><ctrl-f>           " put file path under cursor (does not expand ~)
:<ctrl-r><ctrl-p>           " put file path under cursor (expands ~)
```

### NORMAL and VISUAL modes:
```vim
"={expr}                    " evaluate {expr} into the expression register
"={expr}p                   " evaluate {expr} and paste (also saved in the register)
"={expr}P                   " save as above, paste before the cursor
```

**Notes:**
- For more information on evaluating expressions `:help expression`. For even more information read [Aaron Bieber's: Master Vim Registers With Ctrl R](https://blog.aaronbieber.com/2013/12/03/master-vim-registers-with-ctrl-r.html) and watch [Vimcasts: Simple calculations with Vim's expression register calculations with Vim's expression register](http://vimcasts.org/episodes/simple-calculations-with-vims-expression-register/)

- When inserting a register with `<ctrl-r>{reg}` and then repeating the edit with `.` you will find out that same text will be entered even if the register contents has changed, to have the actual command enter the `.` register we need to use `<ctrl-r><ctrl-o>{reg}` instead. Best shown with an example, say we have the below text and we wish to add parens around the text

```vim
    one           " we want to change this to => (one)
    two           " we want to change this to => (two)
```

  We can modify the first line using `ciw(<ctrl-r>+)` which will result in "(one)" but when we repeat the action for "two" the result would still be "(one)" as the actual text is saved in the register. To circumvent this we can use `ciw(<ctrl-r><ctrl-o>+)` instead which inserts the actual command `^R^O+` into the register, that way when we repeat the action with `.` the result would be as expected "(two)".

