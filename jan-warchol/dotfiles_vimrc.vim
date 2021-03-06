" SEARCHING ============================================================

set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching

" Ensure 8 lines of context is visible when jumping between search matches.
" I think it's better than mapping n to nzz (centering screen on every match).
nnoremap <silent> n :set scrolloff=8<CR>n:set scrolloff=2<CR>
nnoremap <silent> N :set scrolloff=8<CR>N:set scrolloff=2<CR>
nnoremap <silent> * :set scrolloff=8<CR>*:set scrolloff=2<CR>
nnoremap <silent> # :set scrolloff=8<CR>#:set scrolloff=2<CR>
" Center *first* search match (http://vi.stackexchange.com/q/10775/836)
cnoremap <expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>zz' : '<CR>'

" Search highlighting
set hlsearch


 
" BEHAVIOUR ============================================================

" more intuitive placement of new vertical and horizontal splits
set splitbelow
set splitright

" autoresize splits on window resize (so that they are equal size)
autocmd VimResized * wincmd =

set expandtab
set tabstop=8
set shiftwidth=2

" enable mouse support. This makes scrolling behave normally (moves content
" instead od moving cursor) and lets user select text with mouse.
set mouse=a

"Enable middle mouse button clipboard support
set guioptions+=a

" Allow having multiple files with unsaved changes opened simultaneously
set hidden

" new undo item when pressed CR
inoremap <CR> <C-G>u<CR>

" check for outside changes of the file more often
autocmd CursorHold * checktime

" enable persistent undo (remember changes after closing file)
set undofile

" save all temporary vim files to ~/.vim, rather than pollute projects with
" them. Note the // at the end (for storing full paths of edited files).
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undo//
set viminfo+=n$HOME/data/viminfo-$DISAMBIG_SUFFIX



" PLUGINS ==============================================================

" Manage plugins with Vim-Plug (github.com/junegunn/vim-plug)
call plug#begin('~/.vim/plugged')
" Let's get the obvious out of the way
Plug 'tpope/vim-sensible'

" Appearance -----------------------------------------------------------
Plug 'altercation/vim-colors-solarized'  " not used, just for comparison
Plug 'berdandy/ansiesc.vim'  " defines 'AnsiEsc' command that evaluates Ansi color codes
Plug 'ap/vim-css-color'  " display approximation of hex color codes inside vim
Plug 'posva/vim-vue'  " syntax highlighting for JavaScript framework Vue
Plug 'chase/vim-ansible-yaml'  " syntax highlighting for Ansible
Plug 'derekwyatt/vim-scala'  " syntax highlighting for scala
Plug 'lepture/vim-jinja'  " syntax highlighting for Jinja
Plug 'vim-scripts/SyntaxAttr.vim'  " for debugging syntax highlighting
Plug 'jeffkreeftmeijer/vim-numbertoggle'  " relative line numbers in normal, absolute in insert
let g:UseNumberToggleTrigger=0  " don't overwrite C-n mapping
Plug 'vim-scripts/vim-airline'
let g:airline#extensions#branch#displayed_head_limit = 18

" General behavior -----------------------------------------------------
Plug 'Carpetsmoker/auto_autoread.vim' " autodetect changes in file (bugged, needs enabling)

" Navigation/motions ---------------------------------------------------
Plug 'jeetsukumaran/vim-indentwise'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'  " required by vim-easyclip (and useful on its own)
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_keys = 'hlnrasetoiygqwdfujbk:,.34-xzcmvp'
" TODO: make easymotion don't try so many words so that i don't loose
" single-letter shortcuts
" also, I think I want to replace default F and T bindings with easymotion!

Plug 'junegunn/vim-easy-align'  " better than godlygeek/tabular

" Make register behaviour more resonable
Plug 'svermeulen/vim-easyclip'  " requires repeat.vim

Plug 'ktonga/vim-follow-my-lead'
let g:fml_all_sources = 1
call plug#end()



" SANE CLIPBOARD =======================================================

" Requires svermeulen/vim-easyclip plugin and +clipboard. See also
" http://vimcasts.org/blog/2013/11/registers-the-good-the-bad-and-the-ugly-parts/

" Automatically use system-wide clipboard (the one tied to Ctrl-C/X/V; use
" 'unnamed' for middle-mouse-button clipboard)
set clipboard=unnamedplus

" save clipboard register on exit and suspend - http://stackoverflow.com/a/9381778/2058424
autocmd VimLeave * call system("xsel -ib", getreg('+'))
noremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>

" Map s to substitute (replacement motion, no need for extra register)
let g:EasyClipUseSubstituteDefaults = 1

" Restore d as cutting operator. This is not ideal (I still don't have a
" convenient way to delete without putting in clipboard), but the alternative
" (replacing one of Vim's default mappings, like x or m, or using a longer
" mapping, like <Leader>d) sounds worse.
let g:EasyClipUseCutDefaults = 0
nmap d <Plug>MoveMotionPlug
xmap d <Plug>MoveMotionXPlug
nmap dd <Plug>MoveMotionLinePlug



" COMMANDS AND TEXT OBJECTS ============================================

if exists('textobj#user#plugin')
  call textobj#user#plugin('yaml', {
  \   'dictvalue': {
  \     'pattern': '\(: \)\@<=.*$',
  \     'select': ['ay', 'iy'],
  \   },
  \ })
endif

" MAPPINGS =============================================================

let mapleader = "\<Space>"

nmap <Leader>se :call SyntaxAttr()<CR>
map <Leader> <Plug>(easymotion-prefix)

" Fuzzy-find in dotfiles
command! -bang -nargs=? -complete=dir DotFiles call
  \ fzf#vim#files(<q-args>,
  \     {'source': "ls-dotfiles"},
  \     <bang>0)

" FZF
nmap <Leader><Tab> :Buffers<CR>

nmap <Leader>on :FilteredFiles<CR>
nmap <Leader>oa :Files<CR>
nmap <Leader>oh :FilteredFiles ~<CR>
nmap <Leader>oe :Files /etc<CR>
nmap <Leader>og :GFiles<CR>
nmap <Leader>od :DotFiles<CR>

nmap <Leader>ow :Windows<CR>


" consistency ----------------------------------------------------------

" open new file in horizontal/vertical split. By default there is only mapping
" for horizontal split (<C-W>n).
nnoremap <C-W>nx :new<CR>
nnoremap <C-W>nv :vnew<CR>

" Nawigate splits. This is such an important task that there really should be
" a first-level mapping for it.
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j


" navigation -----------------------------------------------------------

" don't move cursor when leaving insert mode
" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
" http://stackoverflow.com/a/17054564/2058424
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
set virtualedit=onemore


" other ----------------------------------------------------------------
nnoremap <Leader>v :source $MYVIMRC<CR><C-L>
" Automatically reload .vimrc after writing it
autocmd BufWritePost .vimrc source %

set pastetoggle=<F5>

" search for visually selected text. Note the no-magic setting!
vnoremap // "vy/\V<C-R>v<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" unused keys ----------------------------------------------------------
" I keep a list to remember what I still have available.
map , <Nop>
map - <Nop>
map _ <Nop>
" remember that <tab> == <C-I>
map <tab> <Nop>
map <C-O> <Nop>
" default K binding is useless...
map K <Nop>
map \ <Nop>
" Leader: a c d h j l m p q u x y z

" Remap jumping in movement history, for 2 purposes:
" - to free Ctrl-O and Ctrl-I (and Tab, which is hardwired to Ctrl-I)
" - to make the movement more intuitive (key to the right moves forward)
nnoremap <C-N><C-O> <C-I>
nnoremap <C-N><C-I> <C-O>


" OTHER SETTINGS =======================================================

" colorscheme must be set after Vim-plug finishes its work
colorscheme selenized

