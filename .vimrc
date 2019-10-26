" vimrc
" vim:fenc=utf-8 ff=unix ft=vim foldmethod=marker

" intro
" setup {{{
set encoding=utf-8
scriptencoding utf-8
" UTF-8のチェック

" no effect
" http://qiita.com/yu_suke1994/items/e0a19574994a57c8fe17
" set nocompatible
" but setup below
if &compatible
  set nocompatible
endif

" コマンドグループ初期化
augroup MyAutoGroup
  autocmd!
augroup END

" Windows check
let s:is_windows = has('win32') || has('win64') " later as historical ==|| has('win16') || has('win95')==
let s:is_cygwin  = has('win32unix')

" }}}

" plugin manager before setup {{{
" プラグイン処理前に実施
" http://qiita.com/andouf/items/bdec492185e3a4f78ae2
" if s:is_windows
"   set shellslash
" endif
if s:is_windows && exists('&completeslash')
  set completeslash=slash
endif

" 初期値削除
set tags=

" <Leader>はプラグイン内でマッピングする際に展開してしまうので
" based on https://rcmdnk.com/blog/2014/05/03/computer-vim-octopress/
" based on https://whileimautomaton.net/2007/04/19221500
" mapleader (<Leader>) (default is \)
let mapleader = ","
let maplocalleader  = ";"
" use \ as , instead
nnoremap <Subleader> <Nop>
map \ <Subleader>
" f,tでの移動の逆にする機能が設定されているので、保持はする
nnoremap <Subleader>, ,


if s:is_cygwin
  " Git for Windows(MSYS2)にも対応のため、Windowsは手動で強制再設定
  " * $HOMEは定義済み(MSYS2では再定義される)
  " * $GNUPGHOME はパスがWindows表記であるとして、再設定する
  let $GNUPGHOME = expand($HOME . '/.gnupg')

  " * $XDG_ はパスがWindows表記であるとして、再設定する
  let $XDG_CACHE_HOME = expand($HOME . '/.cache')
  let $XDG_CONFIG_HOME = expand($HOME . '/.config')
endif

" plugin
" dein 設定前の設定

" }}}

" dein settings {{{
" dein自体の自動インストール

" renew for dein.vim
" based on
" http://qiita.com/kawaz/items/ee725f6214f91337b42b
" http://qiita.com/delphinus35/items/00ff2c0ba972c6e41542
" http://qiita.com/hanaclover/items/f45250b55e2298c4ac5a

let g:dein = {}
let g:dein.dir = {}

" プラグインが実際にインストールされるディレクトリ
let s:cache_home = empty($XDG_CACHE_HOME) ? expand($HOME . '/.cache') : expand($XDG_CACHE_HOME)

let g:dein.dir.plugins = expand(s:cache_home . '/dein')
" 問題がある時用固定パス
" let g:dein.dir.plugins = expand('~/.cache/dein')

" dein.vim 本体
let g:dein.dir.install = expand(g:dein.dir.plugins . '/repos/github.com/Shougo/dein.vim')

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(g:dein.dir.install)
    call system('git clone https://github.com/Shougo/dein.vim ' . g:dein.dir.install)
  endif
  let &runtimepath = g:dein.dir.install . "," . &runtimepath
endif

" 設定開始
if dein#load_state(g:dein.dir.plugins)
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル(後述)を用意しておく
  let s:rc_dir    = expand($HOME . '/.vim/rc')
  let s:toml      = s:rc_dir . '/dein.toml'
  let s:lazy_toml = s:rc_dir . '/dein_lazy.toml'

  call dein#begin(g:dein.dir.plugins, [$MYVIMRC, s:toml, s:lazy_toml])
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" call source
call dein#call_hook('source')
" set post source at non-lazy plugin
autocmd MyAutoGroup VimEnter * call dein#call_hook('post_source')

" もし、未インストールものものがあったらインストール
if (0 == v:vim_did_enter) && dein#check_install()
  call dein#install()
endif
" }}}

" plugin manager after setup {{{
" runtime path setup
"  at last
"   add ~/.vim
let &runtimepath =  &runtimepath . ',' . expand($HOME . '/.vim')

filetype plugin indent on

" option

" based on http://wonderwall.hatenablog.com/entry/2016/03/18/235125
" based on https://qiita.com/sizucca/items/40f291463a40feb4cd02
" based on https://qiita.com/marrontan619/items/541a1374e1ac672977e6
" based on https://qiita.com/godai0505/items/91860a9d3012355ca1bd
" based on https://vim-jp.org/vim-users-jp/2010/02/17/Hack-125.html
" syntax enable
syntax on

" }}}

" option setting refer https://github.com/mopp/dotfiles/blob/master/.vimrc

" ##############################################################編集系############################################################## {{{
" Edit. {{{
" 矩形はフリーカーソル、行末の1文字先まで -> 自由にカーソルを移動できるように
" 挿入あり
set virtualedit=all " insert,block,onemore

" tag case rel ignorecase , smartcase
set tagcase=followscs

" inc/dec operation
" 0123を10進扱いする、bin/hexは生かす
set nrformats-=octal
" }}}

" Conceal. {{{
" 表示量の初期値
" indentLine default setting 2
set conceallevel=2

" 状態表示
" n ノーマルモード
" v ビジュアルモード
" i 挿入モード
" c コマンドライン編集 ('incsearch' 用)
" indentLine default setting inc
set concealcursor=nc
" }}}

" Indent. {{{
" 自動インデントを有効化する
set autoindent
set smartindent
" 桁溢れインデントの設定
set breakindent
set breakindentopt=min:50,shift:4,sbr

" set whichwrap=b,s,h,l,<,>,[,]
set wrap           " the longer line is wrapped
set wrapmargin=8
set linebreak      " wrap at 'breakat'
"set breakat=\      " break point for linebreak (default " ^I!@*-+;:,./?")
set showbreak=+\   " set showbreak

" Tab文字を半角スペースにする
set expandtab
" Tabの幅（スペースいくつ分）
set tabstop=2
" ソフトタブ展開数(0はtabstopに同じ)
set softtabstop=0
" 自動インデントの幅
set shiftwidth=2
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set shiftround
set smarttab

let s:skk = 0
if s:skk
  " https://qiita.com/sgur/items/aa443bc2aed6fe0eb138
  " use SKK (nathancorvussolis/corvusskk)
  set iminsert=2
  set imsearch=2
  set imcmdline
else
  " http://qiita.com/enomotok_/items/9d38b716fe883675d35b
  " http://kaworu.jpn.org/kaworu/2008-03-07-1.php
  set iminsert=0
  set imsearch=-1
endif

"バックスペースキーで行頭を削除する
set backspace=indent,eol,start

" }}}

" Diff. {{{
" based on http://nanasi.jp/articles/howto/diff/diffopt.html
set diffopt=internal
set diffopt+=vertical
set diffopt+=filler
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram

" }}}

" Tags. {{{
let s:home = ''
if has('path_extra')
  let s:home = ';' . expand($HOME)
endif
execute 'set tags+=./tags' . s:home
execute 'set tags+=./TAGS' . s:home

if has('path_extra')
  set tags+=./**2/tags
  set tags+=./**2/TAGS
endif

set tags+=tags
set tags+=TAGS

" タグ先複数選択を常に
nnoremap <C-]> g<C-]>
" if dein#tap('ctrlp.vim')
"   " ctrlp
"   nnoremap <C-]> :CtrlPTag<CR>
" endif
" タグの戻りを[に割り当て
nnoremap <C-[> :pop<CR>
" }}}

" History {{{
" undo
" http://qiita.com/tamanobi/items/8f013cce36881af8cee3
if has('persistent_undo')
  let &undodir = expand($HOME . '/.vim/undo', ':p') . '//' " // use fullpath
  set undofile
  " set undolevels=1000 " default
endif
" set viewoptions=cursor,folds

" set history=2048

" mru 200,register 50lines,10KBytes hlsearch disable viminfo file:$HOME/.vim/info
set viminfo='200,<50,s10,h,rA:,rB:,n$HOME/.vim/info
" }}}

" Safety. {{{
" バックアップファイルを作らない
set nobackup
let &backupdir = expand($HOME . '/.vim/backup') . '//' " // use fullpath

" スワップファイルを作らない -> 作るがROで対応
" set noswapfile
let &directory = expand($HOME . '/.vim/swap') . '//' " // use fullpath
" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
autocmd MyAutoGroup SwapExists * let v:swapchoice = 'o'

set writebackup

" 編集中のファイルが変更されたら自動で読み直す
set autoread
" based on https://vim-jp.org/vim-users-jp/2011/03/12/Hack-206.html
" window move to autoread
autocmd MyAutoGroup WinEnter * checktime

" バッファが編集中でもその他のファイルを開けるように
" based on https://qiita.com/qtamaki/items/4da4ead3f2f9a525591a
set hidden

" }}}
" }}}

" ##############################################################検索系############################################################## {{{
" Search. {{{

" see imsearch in Indent setting...

" 検索したときのハイライトをつける
set hlsearch
" Ctrl-L で検索ハイライトを消す
" nnoremap <silent> <C-l> <C-l>:nohlsearch<CR>
" based on https://postd.cc/vim-galore-4/
nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR>:redraw!<CR><C-L>
if dein#tap('vim-quickhl')
  nnoremap <silent> <Leader><C-L> :QuickhlManualReset<CR>:nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR>:redraw!<CR><C-L>
else
  nnoremap <silent> <Leader><C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR>:redraw!<CR><C-L>
endif

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" set if need
" set path=.,/usr/local/include,/usr/include,./include

" search with magic/very magic...
" https://vim-jp.slack.com/archives/C03C4RC9F/p1553041020188200
nnoremap /  /\v

" }}}
" }}}

" ##############################################################表示系############################################################## {{{
" Appearance. {{{
" 再描画を遅延させる
set lazyredraw

" ターミナルのタイトルをセットする
set title
" intro off
set shortmess+=I

" モード表示
set showmode
" lightline support mode; disable showmode
" set noshowmode

" 括弧入力時の対応する括弧を表示
set showmatch
" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
set matchtime=1

set modeline

"ルーラー,行番号を表示
set number
set ruler
" http://cohama.hateblo.jp/entry/2013/10/07/020453
set relativenumber
nnoremap <silent> <F3> :<C-u>setlocal relativenumber!<CR>
augroup toggle_relative_number
  autocmd!
  autocmd InsertEnter * :setlocal norelativenumber
  autocmd InsertLeave * :setlocal relativenumber
augroup END

" 入力中のコマンドをステータスに表示す
set showcmd

" based on https://qiita.com/KeitaNakamura/items/a289822827c8655b2dcd
set scrolloff=3

" 現在のカーソルの色をつける
" 現在の行を強調表示
" set cursorline
" -> 個別に
" 現在の列を強調表示（縦）
" set cursorcolumn
" -> 個別に
"
" Old Color setting in Colorscheme.

" カレントウィンドウにのみ罫線を引く(ここで制御)
" based on http://vimblog.hatenablog.com/entry/vimrc_autocmd_examples
augroup MyAutoGroup
  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorcolumn
  autocmd WinLeave * setlocal nocursorline
  autocmd WinLeave * setlocal nocursorcolumn
  " based on https://postd.cc/vim-galore-4/
  " edit off
  " if cursorlineopt support: Enter only show number/Leave show both
  if exists('&cursorlineopt')
    autocmd InsertEnter * setlocal cursorlineopt=number
  else
    autocmd InsertEnter * setlocal nocursorline
  endif
  autocmd InsertEnter * setlocal nocursorcolumn
  if exists('&cursorlineopt')
    autocmd InsertLeave * setlocal cursorlineopt=both
  else
    autocmd InsertLeave * setlocal cursorline
  endif
  autocmd InsertLeave * setlocal cursorcolumn
augroup END

" gitgutter sign support
set signcolumn=yes
if has('patch-8.1.1712')
  " if support sign in number, set number
  set signcolumn=number
  let &numberwidth += 2
endif

" カレントディレクトリをファイルの位置に自動移動
" use plugin
" set autochdir

" http://qiita.com/jnchito/items/5141b3b01bced9f7f48f
" http://inari.hatenablog.com/entry/2014/05/05/231307
" 以下に切り替え(plugin)
" http://d.hatena.ne.jp/thinca/20160214/1455415240
" http://sixeight.hatenablog.com/entry/20080529/1212079410
" http://www.dotapon.sakura.ne.jp/blog/?p=323
" http://qiita.com/ayakix/items/0bdf09239501b4e47b43
" https://qiita.com/tmsanrinsha/items/d6c11f2b7788eb24c776
""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
" スペースやEOLなどについても設定
set list
" set listchars=tab:>\ ,eol:\ ,trail:_,nbsp:%,extends:~,precedes:~
set listchars=tab:»-,eol:\ ,trail:･,nbsp:⍽,extends:»,precedes:«
" 下の設定だとindent-lineの記号表示とぶつかる問題がある

" ステータスラインの設定
" cmdheightは各タブに値が保持されるのでtabdoする必要がある
tabdo set cmdheight=1
set laststatus=2

" Anywhere SID.
function! s:SID_PREFIX() abort " {{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction " }}}

" Set tabline.
function! s:my_tabline() abort "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ?  'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'.  s:SID_PREFIX() .  'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" set statusline (encode,CRLF)
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" plugin overwrite (tab,status lightline after load overwrite)

" set conceallevel=2

" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
set display=lastline
set synmaxcol=512

" }}}
" }}}

" ##############################################################その他############################################################## {{{
" Folding. {{{
" overwrite at plugin
" set foldenable
" set foldcolumn=1
" set foldmethod=indent
" set foldtext=Mopp_fold_text()
" set foldmarker=\ {{{,\ }}}
" }}}

" Terminal/Shell. {{{
" if (1 == s:is_windows) && (0 == s:is_cygwin)
"   let path_prefix='C:\tools\nyagos'
"   let exec_name='nyagos.exe'
"
"   if has('win64')
"     let arch='amd64'
"   else " has('win32')
"     let arch='386'
"   endif
"
"   let path=path_prefix . '\' . arch . '\' . exec_name
"   if executable(path)
"     " echomsg 'shell test:' . path
"     let &shell=path
"     set shellcmdflag=-c
"     set shellquote=
"     set shellxquote=
"     set shellxescape=
"   endif
" endif

" based on https://qiita.com/k2nakamura/items/fa19806a041d0429fc9f
set ttimeoutlen=10
" }}}

" Others. {{{
" based on http://blog.serverkurabe.com/vim-split-window
" 新しいウィンドウを下に開く
set splitbelow
" 新しいウィンドウを右に開く
" set splitright

" Tab数拡張
set tabpagemax=99

" based on https://postd.cc/vim-galore-4/
" カーソルスタイル
" 一部動かない所があるので、一旦off
" if empty($TMUX)
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"   let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" else
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"   let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
" endif

" ビジュアルベル
" set visualbell
" based on https://postd.cc/vim-galore-4/
set belloff=all

" フォーマットを有効にする
set formatoptions=tcqmBjro

set matchpairs+=<:>

" updatetime need plugin setting
" let &updatetime=??
" }}}

" Completion {{{
" オムニ補完の設定(insertモードでCtrl+oで候補を出す、Ctrl+n Ctrl+pで選択、Ctrl+yで確定)
" based on https://vim-jp.org/vim-users-jp/2009/11/01/Hack-96.html
" 注意: この内容は:filetype onよりも後に記述すること。
autocmd MyAutoGroup FileType * if &l:omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif

" 補完設定
" set complete as default
set complete&
" based on https://postd.cc/vim-galore-4/
" fast search
set complete-=i   " disable scanning included files
set complete-=t   " disable searching tags

set completeopt=menuone,noselect,noinsert
set completeopt+=preview
if has('patch-8.1.1882')
  set completeopt-=preview
  set completeopt+=popup
endif

" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
set pumheight=10
set pumwidth=20
set wildmenu
set wildmode=longest:full,full
set wildignorecase

" 辞書
" see http://nanasi.jp/articles/howto/config/dictionary.html

let s:dictfile = expand($HOME . '/.vim/dict/look/words', ':p')
if s:is_windows
  let s:dictfile = expand('c:/tools/dictionary/look/words', ':p')
endif
if filereadable(s:dictfile)
  let &dictionary = s:dictfile
endif

" spell check
set spell
set complete+=kspell
set spelllang=en_us,cjk
let &spellfile = expand($HOME . '/.vim/dict/spell.' . &encoding . '.add')
let &spellsuggest = 'best,' . string(min([(&lines/2), 10]))
autocmd MyAutoGroup VimResized * let &spellsuggest = 'best,' . string(min([(&lines/2), 10]))
let g:spell_clean_limit = 120 * 60 " unit sec

" see reedes/vim-lexical: Build on Vim’s spell/thes/dict completion https://github.com/reedes/vim-lexical
let s:thesaurus  = expand($HOME . '/.vim/dict/mthesaur.txt', ':p')
if s:is_windows
  let s:thesaurus = expand('c:/tools/dictionary/mthesaur.txt', ':p')
endif
if filereadable(s:thesaurus)
  let &thesaurus = s:thesaurus
endif
set complete+=s

" based on http://koturn.hatenablog.com/entry/2018/02/10/170000
" 補完の補助表示
" 入力キーの辞書
let s:compl_key_dict = {
      \ char2nr("\<C-l>"): "\<C-x>\<C-l>",
      \ char2nr("\<C-n>"): "\<C-x>\<C-n>",
      \ char2nr("\<C-p>"): "\<C-x>\<C-p>",
      \ char2nr("\<C-k>"): "\<C-x>\<C-k>",
      \ char2nr("\<C-t>"): "\<C-x>\<C-t>",
      \ char2nr("\<C-i>"): "\<C-x>\<C-i>",
      \ char2nr("\<C-]>"): "\<C-x>\<C-]>",
      \ char2nr("\<C-f>"): "\<C-x>\<C-f>",
      \ char2nr("\<C-d>"): "\<C-x>\<C-d>",
      \ char2nr("\<C-v>"): "\<C-x>\<C-v>",
      \ char2nr("\<C-u>"): "\<C-x>\<C-u>",
      \ char2nr("\<C-e>"): "\<C-x>\<C-e>",
      \ char2nr("\<C-o>"): "\<C-x>\<C-o>",
      \ char2nr('s'): "\<C-x>s",
      \ char2nr("\<C-s>"): "\<C-x>s"
      \}
" 表示メッセージ
let s:hint_i_ctrl_x_msg = join([
      \ '<C-l>: While lines',
      \ '<C-n>: keywords in the current file',
      \ "<C-k>: keywords in 'dictionary'",
      \ "<C-t>: keywords in 'thesaurus'",
      \ '<C-i>: keywords in the current and included files',
      \ '<C-]>: tags',
      \ '<C-f>: file names',
      \ '<C-d>: definitions or macros',
      \ '<C-v>: Vim command-line',
      \ "<C-u>: User defined completion ('completefunc')",
      \ "<C-e>: plugin emoji completion ('kyuhi/vim-emoji-complete')",
      \ "<C-o>: omni completion ('omnifunc')",
      \ "s: Spelling suggestions ('spell') - overwrite to surround"
      \], "\n")
function! s:hint_i_ctrl_x() abort " {{{
  echo s:hint_i_ctrl_x_msg
  let c = getchar()
  return get(s:compl_key_dict, c, nr2char(c))
endfunction " }}}

inoremap <expr> <C-x>  <SID>hint_i_ctrl_x()

function! s:popup_select(default) abort
  if dein#tap('asyncomplete.vim')
    return asyncomplete#close_popup()
  else
    return a:default
  endif
endfunction

function! s:popup_cancel(default) abort
  if dein#tap('asyncomplete.vim')
    return asyncomplete#cancel_popup()
  else
    return a:default
  endif
endfunction

inoremap <expr> <Tab>        pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab>      pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>         pumvisible() ? <SID>popup_select("\<C-y>") : "\<CR>"
inoremap <expr> <Space>      pumvisible() ? <SID>popup_cancel("\<C-e>") : "\<Space>"
inoremap <expr> <C-y>        pumvisible() ? <SID>popup_select("\<C-y>") : "\<C-y>"
inoremap <expr> <C-e>        pumvisible() ? <SID>popup_cancel("\<C-e>") : "\<C-e>"

" }}}

" Configs for default scripts. {{{
" let g:lisp_rainbow = 1
" let g:lisp_instring = 1
" let g:lispsyntax_clisp = 1
" let g:c_syntax_for_h = 1
" let g:tex_conceal = ''
" let g:tex_flavor = 'latex'
" }}}

" Clipboard. {{{
" based on https://qiita.com/janus_wel/items/86082f69190f40df09e8
" and http://pocke.hatenablog.com/entry/2014/10/26/145646
if has('clipboard') && (has('gui') || has('xterm_clipboard'))
  set clipboard&
  if s:is_windows
    set clipboard^=unnamed
  elseif has('gui_runnning')
    " x window system あり
    set clipboard^=unnamedplus
    " autoselectはデフォルト値にある
  else
    " x window system なし
    set clipboard^=unnamed
    " autoselectはデフォルト値にある
  endif
endif

" see https://qiita.com/miyanokomiya/items/03d19bca87d4b2f176c4
" current file path to register and display
function! ClipText(data)
  let @0=a:data
  let @"=a:data
  let @*=a:data
endfunction
nnoremap <C-g> :call ClipText(fnamemodify(expand('%'), ':p'))<CR><C-g>

" }}}

" Colorscheme. {{{
" setup in dein.vim toml
" and add Restore t_Co setting
" http://qiita.com/msmhrt/items/486658cd251302e2edf6
" keep default : https://ysk24ok.github.io/2017/02/05/vim_256color.html

let s:saved_t_Co=&t_Co

" 256色モード at console
if !has('gui_running')
  set t_Co=16
  if stridx($TERM, "xterm-256color") >= 0
    " xterm 256が定義ずみの場合
    set t_Co=256
    if has('termguicolors')
      set termguicolors
    endif
  elseif (s:is_windows && ($ConEmuANSI == 'ON'))
    " xterm 256が定義されてないがWindowsでConEmuで256有効の場合
    " http://e8l.hatenablog.com/entry/2016/03/16/230018
    " http://yanor.net/wiki/?Windows-%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%2FConEmu%2FANSI%E3%82%B5%E3%83%9D%E3%83%BC%E3%83%88%2FVim%E3%81%AE256%E8%89%B2%E5%AF%BE%E5%BF%9C
    " https://conemu.github.io/en/VimXterm.html
    " ConEmu Vim Support color
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    " https://conemu.github.io/en/VimXterm.html#Vim-scrolling-using-mouse-Wheel
    " with mouse
    set mouse=a
  elseif (has('vtp') && has('vcon'))
    " Windows 10 color enable
    " currently off true color
    set t_Co=256
    if has('termguicolors')
      set termguicolors
    endif
  endif
endif

" Restore t_Co for less command after vim quit
augroup restore_t_Co
  autocmd!
  if s:saved_t_Co == 8
    autocmd VimLeave * let &t_Co = 256
  else
    autocmd VimLeave * let &t_Co = 8
  endif
  autocmd VimLeave * let &t_Co = s:saved_t_Co
augroup END

" カラー設定(?)
augroup vimrc-highlight
  autocmd!
  " vimdiff config
  " http://qiita.com/takaakikasai/items/b46a0b8c94e476e57e31
  " vimdiffの色設定
  " autocmd ColorScheme * highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
  " autocmd ColorScheme * highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
  " autocmd ColorScheme * highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
  " autocmd ColorScheme * highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

  " based on https://thinca.hatenablog.com/entry/20160214/1455415240
  " autocmd ColorScheme * highlight ZenSpace ctermbg=Red guibg=Red

  " based on http://secret-garden.hatenablog.com/entry/2016/08/16/000149
  autocmd ColorScheme * highlight link EndOfBuffer Ignore

  " based on http://qiita.com/svjunic/items/f987d51ed3fc078fa27e
  " based on http://d.hatena.ne.jp/ryochack/20111029/1319913548
  " based on https://qiita.com/KeitaNakamura/items/a289822827c8655b2dcd

  " autocmd ColorScheme * highlight Comment ctermfg=103
  " autocmd ColorScheme * highlight CursorLine term=none cterm=none ctermbg=17 guibg=236

augroup END

" 'cursorlineopt' setting in autocmd

" }}}

" Help. {{{
" overwrite vim-jp help plugin
" set helplang=ja

" help
" based on http://haya14busa.com/reading-vim-help/
set keywordprg=:help " Open Vim internal help by K command
" }}}

" Grep. {{{
" 外部grepに使うプログラム設定
if executable('jvgrep')
  set grepprg=jvgrep\ --no-color\ -inCRrI
  set grepformat=%f:%l:%c:%m
elseif executable('pt')
  set grepprg=pt\ --nocolor\ --nogroup\ --column\ -e\ -S
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ -a\ --vimgrep\ -S
  set grepformat=%f:%l:%c:%m
elseif executable('grep')
  set grepprg=grep\ -Hnr\ -I\ --exclude-dir=.svn\ --exclude-dir=.git\ --exclude-dir=CVS
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
endif

augroup MyAutoGroup
  " based on https://qiita.com/yuku_t/items/0c1aff03949cb1b8fe6b
   autocmd QuickFixCmdPost grep cwindow
   autocmd QuickFixCmdPost vimgrep cwindow
augroup END

" }}}

" Encode detection. {{{
" *** 今必要かは微妙だが、悪さはしてないのでそのまま ***
"lang config
" from http://www.kawaz.jp/pukiwiki/?vim#cb691f26

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC() " {{{
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction " }}}
  autocmd MyAutoGroup BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
if s:is_windows
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  " set ambiwidth=double
  " 有用だがlightlineのpowerlineフォント設定とぶつかるので、外す(singleとする)
  set ambiwidth=single
  " GUIは平気なので、gvimrcでdoubleに上書きしている
endif
" }}}

" FileType detecion. {{{
" 必要なら独立させる inside '~/.vim/ftdetect/<type>.vim'

augroup MyAutoGroup
  " ssh config
  autocmd BufNewFile,BufRead */.ssh/conf.d/*.conf  setf sshconfig
augroup END

" }}}

" }}}

" Mappings. {{{
"---------------------------------------------------------------------------"
" Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator |
"------------------|--------|--------|---------|--------|--------|----------|
" map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |
" nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |
" vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |
" omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |
" xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |
" smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |
" map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |
" imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |
" cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |
"---------------------------------------------------------------------------"

" ################# キーマップ #######################
" based on https://qiita.com/subebe/items/5de3fa64be91b7d4e0f2
" Tab op key.
nnoremap    [Tab] <Nop>
if exists('g:clever_f_not_overwrites_standard_mappings') && g:clever_f_not_overwrites_standard_mappings
  " overwrite stop : use t
  nmap    t [Tab]
else
  " overwrite : use <space>t
  nmap    <Space>t [Tab]
endif
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tab]'.n ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tab]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る

if dein#tap('vim-startify')
  map <silent> [Tab]h :tablast <bar> tabnew <bar> Startify<CR>
  " th 新しいタブを一番右に作る startifyを実行
endif

map <silent> [Tab]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tab]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tab]p :tabprevious<CR>
" tp 前のタブ

"矢印キーでは表示行単位で行移動する
nnoremap <UP> gk
nnoremap <DOWN> gj
vnoremap <UP> gk
vnoremap <DOWN> gj

" ctrlで行固定移動
nnoremap <C-j> <C-e>j
nnoremap <C-k> <C-y>k

" Yでカーソル位置から行末までヤンクする
" C,Dはc$,d$と等しいのに対してYはなぜかyyとなっている
" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
nnoremap Y y$

" x,s でレジスタを汚染しない

" x,Xでカーソル文字を削除する際レジスタを汚さない
" ビジュアルモードで選択すればヤンクしないdとして使用できる
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X

" s,Sでカーソル文字を削除する際レジスタを汚さない設定
" ビジュアルモードで選択すればヤンクしないcとして使用できる
nnoremap s "_s
vnoremap s "_s
nnoremap S "_S
vnoremap S "_S
" s use easymotion

" based on http://deris.hatenablog.jp/entry/2013/05/02/192415
" 誤操作すると困るキーを無効化する

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" exモード
nnoremap Q <Nop>

" from 0Delta/vimrc
" (shift)Tab でインデント
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >>
vnoremap <S-Tab> <<

" コマンドラインで単語移動
" based skanehira/dotfiles
cnoremap <c-b> <S-Left>
cnoremap <c-f> <S-Right>
cnoremap <c-a> <Home>

" based on https://postd.cc/vim-galore-4/
" nを前方へ、Nを後方へと固定
" nnoremap <expr> n  'Nn'[v:searchforward]
" nnoremap <expr> N  'nN'[v:searchforward]
" use anzu plugin and setting aggregate

" 先頭が現在のコマンドラインと一致するコマンドラインを呼び出し
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>

" 念のため、pasteモードのトグルの設定はする
set pastetoggle=<F12>

" prev setting:xxx see yyy
" let mapleader = ","
" nnoremap <Subleader> <Nop>
" F3 toggle rel-number
" C-L refresh and hl clear, diff update, syntax resync
" C-],C-[ tag jump multi/pop
"
" inoremap
" <C-x>     completion menu
" <Tab>     completion select down
" <S-Tab>   completion select down
" <S-CR>    completion select done
" <S-Space> completion select cancel

" q readonly is close(small setting)
" help and other readonly popup window : q is close
autocmd MyAutoGroup FileType help nnoremap <buffer> q <C-w>c
autocmd MyAutoGroup FileType git-status,git-log nnoremap <buffer> q <C-w>c

" autocmd MyAutoGroup FileType qf nnoremap <buffer> q <C-w>c

" tc/tn/tb/tx/t1-9 TAB setting
" }}}

" plugin設定 {{{
" Turn off default plugins. {{{
" let g:loaded_2html_plugin = 1
" let g:loaded_gzip = 1
" let g:loaded_rrhelper = 1
" let g:loaded_tar = 1
" let g:loaded_tarPlugin = 1
" let g:loaded_vimballPlugin = 1
" let g:loaded_zip = 1
" let g:loaded_zipPlugin = 1
" let g:loaded_matchparen = 1
" }}}

" syntax buildin plugin {{{
" ft-posix-synax
let g:is_posix = 1

" ft-python-syntax
let python_highlight_all = 1

" doxygen-syntax
let g:load_doxygen_syntax = 1
let g:doxygen_enhanced_color = 1
" doxygenErrorComment
" doxygenLinkError

" ft-yaml-syntax
let g:yaml_schema = 'json'
" }}}

" netrw {{{
" based on http://blog.tojiru.net/article/234400966.html

" netrwは常にtree view
let g:netrw_liststyle = 3

" " CVSと.で始まるファイルは表示しない
" let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'

" ヘッダを非表示にする
" let g:netrw_banner=0
" サイズを(K,M,G)で表示する
" let g:netrw_sizestyle="H"

" 日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"

" previewを右に(alto=1で下右に)
let g:netrw_preview = 1

" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1
" }}}

" Kaoriya Plugin(とりあえずOff)設定 {{{
" http://kaworu.jpn.org/vim/Windows%E3%81%ABvim%E3%81%AE%E7%92%B0%E5%A2%83%E3%82%92%E6%A7%8B%E7%AF%89%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95#KaoriYa.E7.89.88Vim.E3.81.AE.E3.83.80.E3.82.A6.E3.83.B3.E3.83.AD.E3.83.BC.E3.83.89
if has('kaoriya')
  let g:no_vimrc_example         = 0
  let g:vimrc_local_finish       = 1
  let g:gvimrc_local_finish      = 1

  "$VIM/plugins/kaoriya/autodate.vim
  let g:plugin_autodate_disable  = 1
  "$VIM/plugins/kaoriya/cmdex.vim
  let g:plugin_cmdex_disable     = 1
  "$VIM/plugins/kaoriya/dicwin.vim
  let g:plugin_dicwin_disable    = 1
  "$VIMRUNTIME/plugin/format.vim
  let g:plugin_format_disable    = 1
  "$VIM/plugins/kaoriya/hz_ja.vim
  let g:plugin_hz_ja_disable     = 1
  "$VIM/plugins/kaoriya/scrnmode.vim
  let g:plugin_scrnmode_disable  = 1
  "$VIM/plugins/kaoriya/verifyenc.vim
  let g:plugin_verifyenc_disable = 1
endif
" }}}


" 各プラグイン設定は .vim/rc/dein.tomlに記載

""""""""""""""""""""""""""""""
" local setting ./.vimrc.local load script
" based on https://qiita.com/kaityo256/items/cb76c3f73753fe921e7b
" to plugin
""""""""""""""""""""""""""""""
" }}}

" カスタム処理 {{{
" プラグイン化を考えること

" function {{{
function! s:EchoSyntax(status) abort " {{{
  if a:status
    redraw | echon synIDattr(synID(line('.'), col('.'), 0), 'name')
  endif
endfunction " }}}

" function! s:SetSyntaxEchoStatus(status) abort {{{
"   let b:SyntaxEchoStatus = a:status
" endfunction " }}}

function! s:ExpandAllBufferToTab() abort " {{{
  silent tabonly
  silent wincmd o
  bufdo tab split
  " タブが1つじゃなければ、多重オープンされているバッファを処理する必要がある
  " if 0
  "   tablast  " 最初の1つは最後にいっているので、それを選択
  "   tabclose " close
  " endif
endfunction " }}}

" see http://koturn.hatenablog.com/entry/2018/02/13/000000
" Window IDからバッファ番号を引く逆引き辞書を作成
function! s:create_winid2bufnr_dict() abort " {{{
  let winid2bufnr_dict = {}
  for bnr in filter(range(1, bufnr('$')), 'v:val')
    for wid in win_findbuf(bnr)
      let winid2bufnr_dict[wid] = bnr
    endfor
  endfor
  return winid2bufnr_dict
endfunction " }}}

function! s:show_tab_info() abort " {{{
  echo "====== Tab Page Info ======"
  let current_tnr = tabpagenr()
  let winid2bufnr_dict = s:create_winid2bufnr_dict()
  for tnr in range(1, tabpagenr('$'))
    let current_winnr = tabpagewinnr(tnr)
    echo (tnr == current_tnr ? '>' : ' ') 'Tab:' tnr
    echo '    Buffer number | Window Number | Window ID | Buffer Name'
    for wininfo in map(map(range(1, tabpagewinnr(tnr, '$')), '{"wnr": v:val, "wid": win_getid(v:val, tnr)}'), 'extend(v:val, {"bnr": winid2bufnr_dict[v:val.wid]})')
      echo '   ' (wininfo.wnr == current_winnr ? '*' : ' ') printf('%11d | %13d | %9d | %s', wininfo.bnr, wininfo.wnr, wininfo.wid, bufname(wininfo.bnr))
    endfor
  endfor
endfunction " }}}
" }}}

" command {{{
" command! SyntaxEchoEnable  :call <SID>SetSyntaxEchoStatus(1)
" command! SyntaxEchoDisable :call <SID>SetSyntaxEchoStatus(0)
command! SyntaxEcho        call <SID>EchoSyntax(1)
command! BufferToTab       call <SID>ExpandAllBufferToTab()
" see http://koturn.hatenablog.com/entry/2018/02/13/000000
command! -bar TabInfo      call <SID>show_tab_info()

" see https://github.com/rinx/dotfiles/blob/master/vimrc
function! s:toggle_option(optname) abort
  execute 'set ' . a:optname . '!'
  echo ''
  redraw
  execute 'set ' . a:optname . '?'
endfunction
command! -nargs=1 -complete=option ToggleOption call <SID>toggle_option(<q-args>)
" }}}

" autocmd {{{
" augroup syntaxecho
"   autocmd!
"   autocmd CursorMoved call <SID>EchoSyntax(get(b:, 'SyntaxEchoStatus', 0))
" augroup END
" }}}

" local setting {{{
" load non init vimrc setting in .vim/rc/
function! s:vimrc_load_noninit_setting(loc)
  let files = glob(expand(escape(a:loc, ' ')) . '*.vim', 1, 1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

call s:vimrc_load_noninit_setting($HOME . '/.vim/rc/')
" }}}

" testing {{{
" template
" " runtimepath update
" let &runtimepath =  &runtimepath . ',' . expand('')
"
" " test function and command
" function! s:testrun() abort
"   echo 'test not set'
"   " or test write to below
"   " echo 'test run'
"   " let s:V = vital#of('vital')
"   " echo "test result:"
" endfunction
"
" command! TestRun call <SID>testrun()
" }}}

" }}}
" EOF
