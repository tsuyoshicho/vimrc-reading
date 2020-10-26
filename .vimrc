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
  " vint: next-line -ProhibitSetNoCompatible
  set nocompatible
endif

" コマンドグループ初期化
augroup MyAutoGroup
  autocmd!
augroup END

" Windows check
let s:is_windows = has('win32') || has('win64') " later as historical ==|| has('win16') || has('win95')==
let s:is_cygwin  = has('win32unix')
let s:is_mac     = has('mac')

" }}}

" plugin manager before setup {{{
" プラグイン処理前に実施
" http://qiita.com/andouf/items/bdec492185e3a4f78ae2
" if s:is_windows
"   set shellslash
" endif
if s:is_windows && exists('+completeslash')
  set completeslash=slash
endif

" 初期値削除(プラグインで設定もあるので、ここでやる)
set tags=

" <Leader>はプラグイン内でマッピングする際に展開してしまうので
" based on https://rcmdnk.com/blog/2014/05/03/computer-vim-octopress/
" based on https://whileimautomaton.net/2007/04/19221500
" mapleader (<Leader>) (default is \)
let g:mapleader = ','
let g:maplocalleader  = ';'
" use \ as , instead
nnoremap <Subleader> <Nop>
map \ <Subleader>
" f,tでの移動の逆にする機能が設定されているので、保持はする
nnoremap <Subleader>, ,
nnoremap <Subleader>; ;

" user setting {{{
let g:user = {
  \  'name'     : 'Tsuyoshi CHO',
  \  'email'    : 'Tsuyoshi.CHO@Gmail.com',
  \  'devemail' : 'Tsuyoshi.CHO+develop@Gmail.com',
  \}

" common function
let g:user.function = {}

" dll search target glob
function! g:user.function.mkdir(dir) abort " {{{
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction " }}}

" dll search target glob
function! g:user.function.dllsearch(cmd, relpath, dllglob) abort " {{{
  if executable(a:cmd)
    let path = exepath(a:cmd)
    " unstable globpath?
    let dll = glob(fnamemodify(path, ':h') . '/' . a:relpath . '/' . a:dllglob,   v:false,  v:true)
    if len(dll) > 0
      return fnamemodify(dll[0], ':p')
    else
      return ''
    endif
  endif
endfunction " }}}

" local vimrc load setting
function! g:user.function.load_setting(loc) abort " {{{
  let path = expand(escape(a:loc, ' '), 'p')
  let files = glob(path . '/*.vim', 1, 1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction " }}}

" dll setup
if has('python3_dynamic')
  " unstable
  let s:pycmd     = 'python3'
  let s:pyrelpath = '../lib'
  let s:pydllglob = 'libpython3*.so'
  if s:is_windows
    let s:pycmd     = 'python'
    let s:pyrelpath = '.'
    let s:pydllglob = 'python3?*.dll'
  elseif s:is_mac
    " unstable
    let s:pydllglob = 'libpython3*.dylib'
  endif

  let &pythonthreedll = g:user.function.dllsearch(s:pycmd, s:pyrelpath, s:pydllglob)
  unlet s:pycmd s:pyrelpath s:pydllglob
endif

let g:user.template = {}
let g:user.template.colorscheme = {
  \ 'name'       : '',
  \ 'background' : '',
  \ 'lightline'  : '',
  \ 'airline'    : '',
  \ 'clap'       : '',
  \ 'mode'       : [],
  \ }
let g:user.template['colorscheme_mode'] = ['16', '256', 'termguicolors', 'gui']

let g:user.location = {}
let g:user.location.tz        = 'Asia/Tokyo'
let g:user.location.timeshift = 0
let g:user.location.latitude  = 35
let g:user.location.longitude = 140
let g:user.location.city      = 'Tokyo'
let g:user.location.cityid    = '1850147'

" Tokyo      https://openweathermap.org/city/1850147
" Hadano     https://openweathermap.org/city/1863431
" Sagamihara https://openweathermap.org/city/1853295
" Shinagawa  https://openweathermap.org/city/1850144

let g:user.git = {}
let g:user.git.name  = g:user.name
let g:user.git.email = g:user.email

let g:user.plugin = {}

let g:user.rootmarker = {}
let g:user.rootmarker.dirs = [
  \  'RCS',
  \  'SCCS',
  \  'CVS',
  \  '.git',
  \  '.svn',
  \  '.hg',
  \  '.bzr',
  \  '_darcs',
  \  '.venv',
  \]
let g:user.rootmarker.files = [
  \  'Rakefile',
  \  'package.json',
  \  'pom.xml',
  \  'project.clj',
  \  'Pipfile',
  \  'compile_commands.json',
  \  '.git'
  \]
" .git file use in separate .git/ dir or worktree
let g:user.rootmarker.fileglob = [
  \  '*.csproj',
  \  '*.sln',
  \]

if s:is_cygwin
  " Git for Windows(MSYS2)にも対応のため、Windowsは手動で強制再設定
  " * $HOMEは定義済み(MSYS2では再定義される)
  " * $GNUPGHOME はパスがWindows表記であるとして、再設定する
  let $GNUPGHOME = expand($HOME . '/.gnupg')

  " * $XDG_ はパスがWindows表記であるとして、再設定する
  let $XDG_CACHE_HOME  = expand($HOME . '/.cache')
  let $XDG_CONFIG_HOME = expand($HOME . '/.config')
  let $XDG_DATA_HOME   = expand($HOME . '/.local/share')
endif

let g:user.dir = {}
let g:user.dir = extend({
  \  'vim'         : expand($HOME . '/.vim')
  \}, g:user.dir)
let g:user.dir = extend({
  \  'undo'        : expand(g:user.dir.vim . '/undo'  ),
  \  'backup'      : expand(g:user.dir.vim . '/backup'),
  \  'swap'        : expand(g:user.dir.vim . '/swap'  ),
  \  'view'        : expand(g:user.dir.vim . '/view'  ),
  \}, g:user.dir)
let g:user.dir = extend({
  \  'cache_home'  : expand(empty($XDG_CACHE_HOME)  ? ($HOME . '/.cache')       : $XDG_CACHE_HOME ),
  \  'config_home' : expand(empty($XDG_CONFIG_HOME) ? ($HOME . '/.config')      : $XDG_CONFIG_HOME),
  \  'data_home'   : expand(empty($XDG_DATA_HOME)   ? ($HOME . '/.local/share') : $XDG_DATA_HOME  ),
  \}, g:user.dir)

" check and mkdir
call map(copy(g:user.dir), { _, v -> g:user.function.mkdir(v) } )

let g:user.system = {}
let g:user.system.windows = s:is_windows ? v:true : v:false
let g:user.system.cygwin  = s:is_cygwin  ? v:true : v:false
let g:user.system.mac     = s:is_mac     ? v:true : v:false

unlet s:is_windows s:is_cygwin s:is_mac
let g:user.system.arch = 'x86_64' " heuristic
if exists('$NUMBER_OF_PROCESSORS')
  if $PROCESSOR_ARCHITECTURE =~? 'AMD64'
    let g:user.system.arch = 'x86_64'
  elseif $PROCESSOR_ARCHITECTURE =~? 'x86'
    let g:user.system.arch = 'x86'
  elseif $PROCESSOR_ARCHITECTURE =~? 'ARM64'
    let g:user.system.arch = 'arm64'
  endif
elseif executable('uname')
  let s:unamem = systemlist('uname --machine')[0]
  if s:unamem =~? 'x86_64'
    let g:user.system.arch = 'x86_64'
  elseif s:unamem =~? 'i686'
    let g:user.system.arch = 'x86'
  elseif s:unamem =~? 'aarch64'
    let g:user.system.arch = 'arm64'
  endif
  unlet s:unamem
endif

if g:user.system.windows
  let g:user.dir.tools = expand('c:/tools')
else
  let g:user.dir.tools = expand($HOME . '/tools')
endif
let g:user.dir.dictionary = expand(g:user.dir.tools . '/dictionary')

let g:user.colorscheme = []

let g:user.system.cpunum = 2 " heuristic
if exists('$NUMBER_OF_PROCESSORS')
  let g:user.system.cpunum = str2nr($NUMBER_OF_PROCESSORS)
elseif executable('nproc')
  let g:user.system.cpunum = str2nr(systemlist('nproc --all')[0])
endif

" }}}

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
let g:dein.dir  = {}
let g:dein.file = {}

" プラグインが実際にインストールされるディレクトリ
let g:dein.dir.plugins = expand(g:user.dir.cache_home . '/dein')
call g:user.function.mkdir(g:dein.dir.plugins)
" 問題がある時用固定パス
" let g:dein.dir.plugins = expand('~/.cache/dein')

" dein.vim 本体
let g:dein.dir.install = expand(g:dein.dir.plugins . '/repos/github.com/Shougo/dein.vim')

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(g:dein.dir.install)
    call system('git clone https://github.com/Shougo/dein.vim ' . g:dein.dir.install)
  endif
  let &runtimepath = g:dein.dir.install . ',' . &runtimepath
endif

" 設定開始
let g:dein.dir.rc                = expand(g:user.dir.vim . '/rc')
let g:dein.file.toml = {
  \  g:dein.dir.rc . '/colorscheme.toml' : {'lazy': 0},
  \  g:dein.dir.rc . '/dein.toml'        : {'lazy': 0},
  \  g:dein.dir.rc . '/dein_lazy.toml'   : {'lazy': 1},
  \}

" setting for dein
let g:dein#install_max_processes = g:user.system.cpunum

if dein#load_state(g:dein.dir.plugins)
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル(後述)を用意しておく

  call dein#begin(g:dein.dir.plugins, keys(g:dein.file.toml))

  " TOML を読み込み、キャッシュしておく
  call map(deepcopy(g:dein.file.toml), { k, v -> dein#load_toml(k, v) })

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" call source
call dein#call_hook('source')
" set post source at non-lazy plugin
autocmd MyAutoGroup VimEnter * nested call dein#call_hook('post_source')

" もし、未インストールものものがあったらインストール
if (0 == v:vim_did_enter) && dein#check_install()
  call dein#install()
endif
" もし、不要なものがあったら、削除
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
unlet s:removed_plugins
" }}}

" plugin manager after setup {{{
" runtime path setup
"  at last
"   add ~/.vim
let &runtimepath =  &runtimepath . ',' . g:user.dir.vim
let &runtimepath =  &runtimepath . ',' . g:user.dir.vim . '/after'

" option

" based on http://wonderwall.hatenablog.com/entry/2016/03/18/235125
" based on https://qiita.com/sizucca/items/40f291463a40feb4cd02
" based on https://qiita.com/marrontan619/items/541a1374e1ac672977e6
" based on https://qiita.com/godai0505/items/91860a9d3012355ca1bd
" based on https://vim-jp.org/vim-users-jp/2010/02/17/Hack-125.html
" syntax enable
syntax on

filetype plugin indent on

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
set nrformats&
set nrformats-=octal
if has('patch-8.2.0860')
  " 符合なし
  set nrformats+=unsigned
endif

" 行連結で変なことをさせない
" from https://github.com/cohama/.vim/blob/master/init.vim
set nojoinspaces
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
" thanks lambdalisue
set copyindent
set preserveindent
" 桁溢れインデントの設定
set breakindent
set breakindentopt=min:50,shift:4,sbr

set wrap           " the longer line is wrapped
set wrapmargin=8
set linebreak      " wrap at 'breakat'
"set breakat=\      " break point for linebreak (default " ^I!@*-+;:,./?")
" set showbreak=+\
set showbreak=↪   " set break char

" Tab文字を半角スペースにする
set expandtab
" Tabの幅
" koron さんの解説
" * ts/tabstop      物理的なタブ文字の展開幅
" * sw/shiftwidth   論理的な1インデントの幅
" * sts/softtabstop ユーザーがタブ文字を入力・削除しようとしたときの操作幅
" tyru さん設定を流用、タブを巨大にして強調する
" タブの値 (表示はいくつ分?)
set tabstop=8
" タブの値 (自動インデントの幅)
set shiftwidth=2
" thanks lambdalisue
set shiftround
" ソフトタブ展開数 (0は無効、-1はshiftwidthに同じ)
set softtabstop=-1
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけに整理される
set smarttab
set shiftround

" vim script pre-escape continue line indent
" to indent/vim

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
unlet s:skk

"バックスペースキーで行頭を削除する
set backspace=indent,eol,start

" }}}

" Diff. {{{
" based on http://nanasi.jp/articles/howto/diff/diffopt.html
" thanks lambdalisue
if has('vim-8.0.1361') || has('nvim')
  set diffopt&
    \ diffopt+=internal
    \ diffopt+=filler
    \ diffopt+=closeoff
    \ diffopt+=vertical
    \ diffopt+=hiddenoff
    \ diffopt+=indent-heuristic
    \ diffopt+=algorithm:histogram
endif

" }}}

" Tags. {{{
let s:home = ''
if has('path_extra')
  let s:home = ';$HOME'
endif
execute 'set tags+=./tags' . s:home
execute 'set tags+=./TAGS' . s:home
unlet s:home

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
" タグの戻りを[に割り当て / ESC 同等なのでつらい
" <leader>esc とする
nnoremap <silent> <Leader><C-[> :pop<CR>
" }}}

" History {{{
" undo
" http://qiita.com/tamanobi/items/8f013cce36881af8cee3
if has('persistent_undo')
  let &undodir = g:user.dir.undo
  set undofile
  " set undolevels=1000 " default
endif
" set viewoptions=cursor,folds

set history=2000

" mru 200,register 50lines,10KBytes hlsearch disable viminfo file:$HOME/.vim/info
set viminfo='200,<50,s10,h,rA:,rB:,n$HOME/.vim/info
" }}}

" Safety. {{{
" 変更後終了時エラーではなく確認を求める
set confirm

" バックアップファイルを作らない
set nobackup
let &backupdir = g:user.dir.backup . '//'  " // use fullpath

" backupは上書き時だけつくって、成功で削除
" from https://github.com/cohama/.vim/blob/master/init.vim
" on だと guard が複数回実行されてしまう問題がある
set nowritebackup

" スワップファイルを作らない -> 作るがROで対応
" -> thinca さんのIFを移植(ROでコマンドでRecover/Delete)
" set noswapfile
let &directory = g:user.dir.swap . '//'  " // use fullpath
" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
" autocmd MyAutoGroup SwapExists * let v:swapchoice = 'o'

" Swap
" from thinca/config
" setglobal swapfile
" augroup vimrc-swapfile
"   autocmd!
augroup MyAutoGroup
  autocmd SwapExists * nested call s:on_SwapExists()
augroup END

function! s:on_SwapExists() abort " {{{
  if !filereadable(expand('<afile>'))
    let v:swapchoice = 'd'
    return
  endif
  let v:swapchoice = get(b:, 'swapfile_choice', 'o')
  unlet! b:swapfile_choice
  if v:swapchoice !=# 'd'
    let b:swapfile_exists = 1
  endif
endfunction " }}}

command! SwapfileRecovery call s:swapfile_recovery()
command! SwapfileDelete call s:swapfile_delete()

function! s:swapfile_recovery() abort " {{{
  if get(b:, 'swapfile_exists', 0)
    let b:swapfile_choice = 'r'
    unlet b:swapfile_exists
    edit
  endif
endfunction " }}}

function! s:swapfile_delete() abort " {{{
  if get(b:, 'swapfile_exists', 0)
    let b:swapfile_choice = 'd'
    unlet b:swapfile_exists
    edit
  endif
endfunction " }}}

" 編集中のファイルが変更されたら自動で読み直す
set autoread

augroup MyAutoGroup
  " based on https://vim-jp.org/vim-users-jp/2011/03/12/Hack-206.html
  " window move to autoread
  autocmd WinEnter * nested checktime

  " based on https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim
  " Run checktime in buffers, but avoiding the "Command Line" (q:) window
  autocmd CursorHold * nested if getcmdwintype() == '' | checktime | endif

  " set nopaste をできるだけ維持
  " from https://github.com/cohama/.vim/blob/master/init.vim
  autocmd InsertLeave * nested set nopaste
augroup END

" バッファが編集中でもその他のファイルを開けるように
" based on https://qiita.com/qtamaki/items/4da4ead3f2f9a525591a
set hidden

" }}}

" Fileformat. {{{

" Fixed encoding/format
augroup MyAutoGroup
  " temp off
  " toml spec. : utf-8 only
  " autocmd BufRead *.toml nested setlocal fileencoding=utf-8
augroup END

" }}}

" }}}

" ##############################################################検索系############################################################## {{{
" Search. {{{

" see imsearch in Indent setting...

" 検索したときのハイライトをつける
set hlsearch

" No HiLight. {{{
" Ctrl-L で検索ハイライトを消す
" nnoremap <silent> <C-l> <C-l>:nohlsearch<CR>
" based on https://postd.cc/vim-galore-4/

function! s:nohl_plugin() abort
  call s:plugin_status_update()
  if g:user.plugin.quickhl
    QuickhlManualReset
  endif
  if g:user.plugin.anzu
    call anzu#clear_search_status()
  endif
endfunction

function! s:nohl_update() abort
  call s:plugin_status_update()
  diffupdate
  syntax sync fromstart
  redraw!
endfunction

" nohlsearch は autocmd/user funcから呼べない(消えない)ため直にマッピングする
nnoremap <silent> <C-L>         :<C-u>nohlsearch<CR>:call <SID>nohl_plugin()<CR>:call <SID>nohl_update()<CR><C-L>
nnoremap <silent> <Leader><C-L> :<C-u>nohlsearch<CR>:call <SID>nohl_update()<CR><C-L>
" }}}

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" set if need
" set path=.,/usr/local/include,/usr/include,./include

" search with magic/very magic...
" https://vim-jp.slack.com/archives/C03C4RC9F/p1553041020188200
nnoremap /  /\v
nnoremap g/ /
" nnoremap * *N / use plugin
" nnoremap g* g*N / use plugin

" }}}
" }}}

" ##############################################################表示系############################################################## {{{
" Appearance. {{{
" 再描画を遅延させる
set lazyredraw

" ターミナルのタイトルをセットする
set title
" intro off
" complete msg off
set shortmess&
  \ shortmess+=I
  \ shortmess+=c

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
set ruler
set number
" http://cohama.hateblo.jp/entry/2013/10/07/020453
set relativenumber
nnoremap <silent> <F3> :<C-u>setlocal relativenumber!<CR>

function! s:relativenumber_toggle(mode) abort " {{{
  let recovery = a:mode ==? 'recovery'

  if recovery
    " if backup value is relativenumber is active, re-active
    let &l:relativenumber    = get(w:,'relativenumber', 1)
    unlet! w:relativenumber
  else
    let w:relativenumber = &l:relativenumber " backup
    let onoff = a:mode ==? 'on'
    if onoff
      setlocal relativenumber
    else
      setlocal norelativenumber
    endif
  endif
endfunction " }}}
augroup MyAutoGroup
  autocmd WinLeave,InsertEnter * nested call s:relativenumber_toggle('off')
  autocmd WinEnter,InsertLeave * nested call s:relativenumber_toggle('recovery')
augroup END

" 入力中のコマンドをステータスに表示す
set showcmd

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
  autocmd VimEnter,BufWinEnter,WinEnter * nested
        \ setlocal cursorline cursorcolumn
  autocmd WinLeave                      * nested
        \ setlocal nocursorline nocursorcolumn
  " based on https://postd.cc/vim-galore-4/
  " edit off
  " if cursorlineopt support: Enter only show number/Leave show both
  if exists('+cursorlineopt')
    autocmd InsertEnter * nested setlocal cursorlineopt=number
    autocmd InsertLeave * nested setlocal cursorlineopt=both
  else
    autocmd InsertEnter * nested setlocal nocursorline
    autocmd InsertLeave * nested setlocal cursorline
  endif
  autocmd InsertEnter * nested setlocal nocursorcolumn
  autocmd InsertLeave * nested setlocal cursorcolumn
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

" based on https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim
" リサイズしたらウィンドウの境界整理
augroup MyAutoGroup
  autocmd VimResized * nested :wincmd =
augroup END

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
set display=lastline,uhex
set synmaxcol=512

" }}}

" View. {{{
let &viewdir = g:user.dir.view
" " from muramount/conf_files
" " ファイル全般に設定
" " augroup General
" "  autocmd!
" augroup MyAutoGroup
"  " 設定の保存と復元
"  autocmd BufWinLeave * nested silent mkview
"  autocmd BufWinEnter * nested silent loadview
" augroup END

" based on http://blog.serverkurabe.com/vim-split-window
" 新しいウィンドウを下に開く
set splitbelow
" 新しいウィンドウを右に開く
" set splitright

" 基本はタブで開いて、他のタブにあっても既存を使う
set switchbuf=usetab,newtab
if dein#tap('QFEnter')
  " QFEnterプラグインがあるなら、その設定を優先
  set switchbuf=
endif

" Tab数拡張
set tabpagemax=99

" 境界
" set fillchars="vert:|,fold: ,diff:・"

" }}}

" Cursor Pos. {{{
" from :help last-position-jump
autocmd MyAutoGroup BufReadPost * nested
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" }}}

" Cursor Style. {{{
" from https://github.com/mnishz/dotfiles/blob/0673fc0ecb85501787cc0c002303456e068f3374/.vimrc#L55-L63
if &term =~# 'xterm'
  " インサートモードでのカーソル切り替え
  let &t_ti = &t_ti . "\e[1 q"
  let &t_SI = &t_SI . "\e[5 q"
  let &t_EI = &t_EI . "\e[1 q"
  let &t_te = &t_te . "\e[0 q"
endif
" }}}

" File Potition. {{{
" augroup MyAutoGroup
"   autocmd BufEnter,BufReadPost * echo 'buffer pwd:' getcwd(0,0)
" augroup END
" }}}

" }}}

" ##############################################################移動系############################################################## {{{
" Command/Find Window. {{{

" based on https://qiita.com/KeitaNakamura/items/a289822827c8655b2dcd
set scrolloff=3
set sidescrolloff=3

" set whichwrap=b,s,h,l,<,>,[,]

" gg/G and other keep column
set nostartofline
" }}}

" }}}

" ##############################################################その他############################################################## {{{
" Command/Find Window. {{{

" cmdwinheight default 7
autocmd MyAutoGroup VimEnter,VimResized * nested let &cmdwinheight = min([(&lines/4), 10])

" based on https://qiita.com/monaqa/items/e22e6f72308652fc81e2
augroup MyAutoGroup
  " 行数を非表示
  " signcolumn を非表示
  " foldcolumn 0
" selective like CmdwinEnter [:\/\?=]
  autocmd CmdwinEnter * nested
    \   setlocal nonumber norelativenumber
    \ | setlocal signcolumn=no
    \ | setlocal foldcolumn=0
  " q で終了
  " in mapping
augroup END
" }}}

" Folding. {{{
" overwrite at plugin
" set foldenable
" set foldcolumn=1
" set foldmethod=indent
" set foldtext=Mopp_fold_text()
" set foldmarker=\ {{{,\ }}}

" from https://github.com/choplin/dotfiles/blob/master/_vimrc
" ft-vim_fold {{{
" augroup foldmethod-expr
"   autocmd!
augroup MyAutoGroup
  autocmd InsertEnter * nested if &l:foldmethod ==# 'expr'
  \                   |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
  \                   |   setlocal foldmethod=manual foldexpr=0
  \                   | endif
  autocmd InsertLeave * nested if exists('b:foldinfo')
  \                   |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
  \                   | endif
augroup END
" }}}

" }}}

" Terminal/Shell. {{{
" if (1 == g:user.system.windows) && (0 == g:user.system.cygwin)
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

set ttyfast
" based on https://qiita.com/k2nakamura/items/fa19806a041d0429fc9f
" Do not wait more than 100 ms for keys
" thanks lambdalisue
set timeout
set ttimeout
set ttimeoutlen=100

" }}}

" Others. {{{
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
" Disable annoying bells
" thanks lambdalisue
set noerrorbells
set novisualbell t_vb=
set belloff=all

" フォーマットを有効にする
set formatoptions=tcmBjroq2l]

" reset matchparis
set matchpairs&
  \  matchpairs+=<:>

" updatetime need plugin setting
" let &updatetime=??
" }}}

" Completion {{{
" オムニ補完の設定(insertモードでCtrl+oで候補を出す、Ctrl+n Ctrl+pで選択、Ctrl+yで確定)
" based on https://vim-jp.org/vim-users-jp/2009/11/01/Hack-96.html
" 注意: この内容は:filetype onよりも後に記述すること。
autocmd MyAutoGroup FileType * nested if &l:omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif

" 補完設定
" based on https://postd.cc/vim-galore-4/
" fast search
" set complete as default
" disable scanning included files
" disable searching tags
set complete&
  \ complete-=i
  \ complete-=t

" base menuone or menu
set completeopt=menuone
if has('patch-8.1.1882')
  set completeopt+=popup
else
  set completeopt+=preview
endif
set completeopt+=noselect
set completeopt+=noinsert

" ファイルパスの@を利用可能にする
" = は使われないはずなので除外
set isfname&
  \ isfname+=@-@
  \ isfname-==

" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
set pumheight=10
set pumwidth=20
set wildmenu
set wildmode=longest:full,full
set wildignorecase
" add char/charm need wilder.nvim
set wildcharm=<Tab>

" 辞書
" see http://nanasi.jp/articles/howto/config/dictionary.html

let s:dictfile = expand(g:user.dir.vim . '/dict/look/words', ':p')
if g:user.system.windows
  let s:dictfile = expand(g:user.dir.dictionary . '/look/words', ':p')
endif
if filereadable(s:dictfile)
  let &dictionary = s:dictfile
endif

" spell check
set spell
" add spell completion
set complete+=kspell
set spelllang=en_us,cjk
if exists('+spelloptions')
  set spelloptions=camel
endif
let &spellfile = expand(g:user.dir.vim . '/dict/spell.' . &encoding . '.add')
autocmd MyAutoGroup VimEnter,VimResized * nested let &spellsuggest = 'best,' . string(min([(&lines/4), 10]))
let g:spell_clean_limit = 120 * 60 " unit sec

" see reedes/vim-lexical: Build on Vim’s spell/thes/dict completion https://github.com/reedes/vim-lexical
let s:thesaurus  = expand(g:user.dir.vim . '/dict/mthesaur.txt', ':p')
if g:user.system.windows
  let s:thesaurus = expand(g:user.dir.dictionary . '/mthesaur.txt', ':p')
endif
if filereadable(s:thesaurus)
  let &thesaurus = s:thesaurus
endif
" add thesaurus completion
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

function! s:popup_select(rawchar, ...) abort " {{{
  let result = ''
  call s:plugin_status_update()
  if g:user.plugin.asyncomplete
    let result = result . asyncomplete#close_popup()
    if a:0
      let result = result . a:1
    endif
  else
    let result = result . a:rawchar
  endif
  return result
endfunction " }}}

function! s:popup_cancel(rawchar, ...) abort " {{{
  let result = ''
  call s:plugin_status_update()
  if g:user.plugin.asyncomplete
    let result = result . asyncomplete#cancel_popup()
    if a:0
      let result = result . a:1
    endif
  else
    let result = result . a:rawchar
  endif
  return result
endfunction " }}}

function! s:insert_char(rawchar, charname) abort " {{{
  let result = ''
  call s:plugin_status_update()
  if g:user.plugin.lexima
    let result = result . lexima#expand(a:charname, 'i')
  else
    let result = result . a:rawchar
  endif
  return result
endfunction " }}}

function! s:imap_setup() abort " {{{
  inoremap <expr><silent> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr><silent> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr><silent> <CR>
    \ pumvisible() ? <SID>popup_select("\<C-y>"            ) : <SID>insert_char("\<CR>",    '<' . 'CR'    . '>')
  inoremap <expr><silent> <Space>
    \ pumvisible() ? <SID>popup_cancel("\<C-e>", "\<Space>") : <SID>insert_char("\<Space>", '<' . 'Space' . '>')
  inoremap <expr><silent> <C-y>
    \ pumvisible() ? <SID>popup_select("\<C-y>"            ) : "\<C-y>"
  inoremap <expr><silent> <C-e>
    \ pumvisible() ? <SID>popup_cancel("\<C-e>"            ) : "\<C-e>"
endfunction " }}}
autocmd MyAutoGroup VimEnter * nested call s:imap_setup()

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
let s:clipboard = has('clipboard')
if s:clipboard && (has('gui') || has('xterm_clipboard'))
  set clipboard&
  if g:user.system.windows
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
function! s:clip_text(data) abort " {{{
  let @0=a:data
  let @"=a:data
  if s:clipboard
    let @*=a:data
  endif
endfunction " }}}
nnoremap <C-g> :call <SID>clip_text(fnamemodify(expand('%'), ':p'))<CR><C-g>

" }}}

" Colorscheme. {{{
" setup in dein.vim toml
" and add Restore t_Co setting
" http://qiita.com/msmhrt/items/486658cd251302e2edf6
" keep default : https://ysk24ok.github.io/2017/02/05/vim_256color.html

if !exists('s:saved_t_Co')
  let s:saved_t_Co=&t_Co
endif

" 256色モード at console
if !has('gui_running')
  set t_Co=16
  if stridx($TERM, 'xterm-256color') >= 0
    " xterm 256が定義ずみの場合
    set t_Co=256
    if has('termguicolors')
      set termguicolors
    endif
  elseif (g:user.system.windows && ($ConEmuANSI ==? 'ON'))
    " xterm 256が定義されてないがWindowsでConEmuで256有効の場合
    " http://e8l.hatenablog.com/entry/2016/03/16/230018
    " http://yanor.net/wiki/?Windows-%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%2FConEmu%2FANSI%E3%82%B5%E3%83%9D%E3%83%BC%E3%83%88%2FVim%E3%81%AE256%E8%89%B2%E5%AF%BE%E5%BF%9C
    " https://conemu.github.io/en/VimXterm.html
    " ConEmu Vim Support color
    set term=xterm
    set t_Co=256
    " let &t_AB="\e[48;5;%dm"
    " let &t_AF="\e[38;5;%dm"
    if has('termguicolors')
      set termguicolors
    endif

    " https://conemu.github.io/en/VimXterm.html#Vim-scrolling-using-mouse-Wheel
    " with mouse
    " set mouse=a
    " thanks lambdalisue
    set mouse=nvchr
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
augroup MyAutoGroup
  if s:saved_t_Co == 8
    autocmd VimLeave * nested let &t_Co = 256
  else
    autocmd VimLeave * nested let &t_Co = 8
  endif
  autocmd VimLeave * nested let &t_Co = s:saved_t_Co
augroup END

" カラー設定(?)
augroup MyAutoGroup
  " vimdiff config
  " http://qiita.com/takaakikasai/items/b46a0b8c94e476e57e31
  " vimdiffの色設定
  " autocmd ColorScheme,VimEnter * nested highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
  " autocmd ColorScheme,VimEnter * nested highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
  " autocmd ColorScheme,VimEnter * nested highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
  " autocmd ColorScheme,VimEnter * nested highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

  " based on https://thinca.hatenablog.com/entry/20160214/1455415240
  " autocmd ColorScheme,VimEnter * nested highlight ZenSpace ctermbg=Red guibg=Red

  " based on http://secret-garden.hatenablog.com/entry/2016/08/16/000149
  autocmd ColorScheme,VimEnter * nested highlight link EndOfBuffer Ignore

  " based on http://qiita.com/svjunic/items/f987d51ed3fc078fa27e
  " based on http://d.hatena.ne.jp/ryochack/20111029/1319913548
  " based on https://qiita.com/KeitaNakamura/items/a289822827c8655b2dcd

  " autocmd ColorScheme,VimEnter * nested highlight Comment ctermfg=103
  " autocmd ColorScheme,VimEnter * nested highlight CursorLine term=none cterm=none ctermbg=17 guibg=236

  " based on https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim

  " Highlight VCS conflict markers
  " match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  " autocmd BufRead,BufNewFile * nested syntax match MyConflictMarker #^\(<\|=\|>\)\{7\}\([^=].\+\)\?$# |
  "\                                   highlight link MyConflictMarker Todo
  " experimental
augroup END

" 'cursorlineopt' setting in autocmd

" }}}

" Help. {{{
" overwrite vim-jp help plugin
" set helplang=ja

" help
" based on http://haya14busa.com/reading-vim-help/
" Open Vim internal help by K command default
" currently K map vim-ref
set keywordprg=:help
augroup MyAutoGroup
  " FileType vim force overwrite
  autocmd FileType vim nested setlocal keywordprg=:help
augroup END

augroup MyAutoGroup
  " 行数を非表示
  " signcolumn を非表示
  " foldcolumn 2
  autocmd FileType
    \ help nested if &l:buftype ==# 'help'
    \ |             setlocal nonumber norelativenumber
    \ |             setlocal signcolumn=no
    \ |             setlocal foldcolumn=2
    \ |           endif
  " q で終了
  " in mapping
augroup END

" from kuuote's vimrc
" helpのタグ移動を楽にするやつ
augroup MyAutoGroup
  autocmd FileType
    \ help nested if &l:buftype ==# 'help'
    \ |             nnoremap <buffer> <CR> <C-]>
    \ |             nnoremap <buffer> <BS> <C-T>
    \ |           endif
augroup END

" }}}

" Quickfix/Location. {{{

augroup MyAutoGroup
  " 行数は絶対行
  " signcolumn を非表示
  " foldcolumn 0
  " numberwidth 2
  autocmd FileType
    \ qf nested setlocal number norelativenumber
    \ |         setlocal signcolumn=no
    \ |         setlocal foldcolumn=0
    \ |         setlocal numberwidth=2
  " q で終了
  " in plugin?
augroup END

" }}}

" Grep. {{{
" 外部grepに使うプログラム設定
if executable('jvgrep')
  set grepprg=jvgrep\ --no-color\ -inCRrI
  set grepformat=%f:%l:%c:%m
elseif executable('pt')
  set grepprg=pt\ --nocolor\ --nogroup\ --column\ --output-encode\ euc\ -e\ -S
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ -a\ --vimgrep\ -S
  set grepformat=%f:%l:%c:%m
elseif executable('grep')
  set grepprg=grep\ -Hnr\ -I\ --exclude-dir=.svn\ --exclude-dir=.git\ --exclude-dir=CVS
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m
endif

augroup MyAutoGroup
  " based on
  " https://qiita.com/yuku_t/items/0c1aff03949cb1b8fe6b
  " https://kaworu.jpn.org/kaworu/2008-06-07-1.php
   " autocmd QuickFixCmdPost * nested cwindow
   autocmd QuickFixCmdPost make,grep,grepadd,vimgrep,helpgrep nested cwindow
augroup END

" }}}

" Encode detection. {{{
" *** 今必要かは微妙だが、悪さはしてないのでそのまま ***
"lang config
" from http://www.kawaz.jp/pukiwiki/?vim#cb691f26

" 文字コードの自動認識
" if &encoding !=# 'utf-8'
"   " vint: next-line -ProhibitEncodingOptionAfterScriptEncoding
"   set encoding=japan
"   set fileencoding=japan
" endif
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
    " let &fileencodings = &fileencodings .','. s:fileencodings_default
    " 今はUTF-8が基本なので調整
    let &fileencodings = 'ucs-bom,utf-8,' . &fileencodings . 'utf-16,utf-16le,default,cp1250,latin1'
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
  function! s:au_recheck_fenc() " {{{
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction " }}}
  autocmd MyAutoGroup BufReadPost * nested call <SID>au_recheck_fenc()
endif

" " simplify
" set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le,default,cp1250,latin1

" 改行コードの自動認識
if g:user.system.windows
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif
" □とか○の文字があってもカーソル位置がずれないようにする
" set ambiwidth=double
" 有用だがlightlineのpowerlineフォント設定とぶつかるので、外す(singleとする)
" thanks lambdalisue
set emoji               " use double in unicode emoji characters
set ambiwidth=single    " use single in ambiguous characters
" GUIは平気なので、gvimrcでdoubleに上書きしている
" }}}

" FileType detecion. {{{
" 必要なら独立させる inside '~/.vim/ftdetect/<type>.vim'

augroup MyAutoGroup
  " ssh config
  autocmd BufNewFile,BufRead */.ssh/conf.d/*.conf nested setf sshconfig
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

" same key
"   <C-i> == <Tab>
"   <C-m> == <Enter>
"   <C-[> == <ESC>
" see http://rbtnn.hateblo.jp/entry/2014/11/30/174749

" ################# キーマップ #######################
" based on https://qiita.com/subebe/items/5de3fa64be91b7d4e0f2
" Tab op key.
nnoremap    [Tab] <Nop>
if get(g:, 'clever_f_not_overwrites_standard_mappings', 0) || dein#tap('vim-eft')
  " overwrite stop : use t
  nmap    t [Tab]
else
  " overwrite : use <space>t
  nmap    <Space>t [Tab]
endif
" Tab jump
for s:n in range(1, 9)
  execute 'nnoremap <silent> [Tab]' . s:n  ':<C-u>tabnext'. s:n .'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

nnoremap <silent> [Tab]c :tablast \| tabnew<CR>
" tc 新しいタブを一番右に作る

if dein#tap('vim-startify')
  nnoremap <silent> [Tab]h :tablast \| tabnew \| Startify<CR>
  " th 新しいタブを一番右に作る startifyを実行
endif

nnoremap <silent> [Tab]x :tabclose<CR>
" tx タブを閉じる
nnoremap <silent> [Tab]n :tabnext<CR>
" tn 次のタブ
nnoremap <silent> [Tab]p :tabprevious<CR>
" tp 前のタブ

"矢印キーでは表示行単位で行移動する
nnoremap <UP>   gk
nnoremap <DOWN> gj
vnoremap <UP>   gk
vnoremap <DOWN> gj

" ctrlで行固定移動
nnoremap <C-j> <C-e>j
nnoremap <C-k> <C-y>k

" 2文字で先頭/末尾移動
noremap <Space>H 0
noremap <Space>h ^
noremap <Space>l g_
noremap <Space>L $

" speed save & exit
nnoremap <space>w :w<CR>
nnoremap <space>q :q<CR>

" o/O use Add last return
nnoremap o A<CR>
" O use original, many pattern are OK
" nnoremap O
"
" from https://github.com/yukiycino-dotfiles/dotfiles/blob/master/.vimrc
" " Automatically indent with i and A
" nnoremap <expr> i len(getline('.')) ? "i" : "cc"
" nnoremap <expr> A len(getline('.')) ? "A" : "cc"

" Yでカーソル位置から行末までヤンクする
" C,Dはc$,d$と等しいのに対してYはなぜかyyとなっている
" see https://itchyny.hatenablog.com/entry/2014/12/25/090000
" thanks lambdalisue and ku/thinca
vnoremap v <Esc>0v$
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
" setup in cutlass(future)
" s use easymotion

" " based on https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim
" " QuickFix navigation
" nnoremap ]q :cnext<CR>
" nnoremap [q :cprevious<CR>
"
" " Location list navigation
" nnoremap ]l :lnext<CR>
" nnoremap [l :lprevious<CR>
" same mapping in unimpaired

" mapping esc at insert mode
inoremap <C-g> <ESC>

" based on http://deris.hatenablog.jp/entry/2013/05/02/192415
" 誤操作すると困るキーを無効化する

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" exモード
" プラグインで使うため、そちらで上書き
" nnoremap Q <Nop>
"
" based on https://github.com/jspitkin/dot-files/blob/master/.vimrc
" Redo
nnoremap U <C-R>

" from 0Delta/vimrc
" (shift)Tab でインデント
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv

" Switch between the last two files
" nnoremap <tab><tab> <c-^>

" based on https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim
" Move visual block
" vnoremap mJ :m '>+1<CR>gv=gv
" vnoremap mK :m '<-2<CR>gv=gv
" vim-move / vim-submode cover this move

" コマンドラインで単語移動
" based skanehira/dotfiles
cnoremap <c-b> <S-Left>
cnoremap <c-f> <S-Right>
cnoremap <c-a> <Home>
" cnoremap <c-e> <End> is default mapping

" based on https://postd.cc/vim-galore-4/
" nを前方へ、Nを後方へと固定
" nnoremap <expr> n  'Nn'[v:searchforward]
" nnoremap <expr> N  'nN'[v:searchforward]
" use anzu plugin and setting aggregate

" 先頭が現在のコマンドラインと一致するコマンドラインを呼び出し
" thanks lambdalisue
cnoremap <C-p>  <Up>
cnoremap <C-n>  <Down>
cnoremap <Up>   <C-p>
cnoremap <Down> <C-n>

" 念のため、pasteモードのトグルの設定はする
" set pastetoggle=<F12>
" use goyo plugin

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
autocmd MyAutoGroup FileType help nested if &l:buftype ==# 'help' | nnoremap <buffer> q <C-w>c | endif
autocmd MyAutoGroup FileType git-status,git-log nested nnoremap <buffer> q <C-w>c
" command window
" selective like CmdwinEnter [:\/\?=]
autocmd MyAutoGroup CmdwinEnter * nested nnoremap <buffer> q <C-w>c

" autocmd MyAutoGroup FileType qf nested nnoremap <buffer> q <C-w>c

" cmdwin other setting
" remap cr (plugin cr mapping clear)
autocmd MyAutoGroup CmdwinEnter * nested nnoremap <buffer> <CR> <CR>

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

" syntax/ftplugin/indent and other buildin plugin {{{
" syntax/sh.vim
let g:is_posix = 1

" syntax/python.vim
let g:python_highlight_all = 1

" syntax/synload.vim
" syntax/doxygen.vim
let g:load_doxygen_syntax = 1
let g:doxygen_enhanced_color = 1
" doxygenErrorComment
" doxygenLinkError

" syntax/yaml.vim
let g:yaml_schema = 'json'

" indent/vim.vim
" in runtime : default shiftwidth() * 3
" see:
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
" https://twitter.com/_tyru_/status/1206884044509569026
let g:vim_indent_cont = 0

" plugin/zipPlugin.vim
" Zip plugin settings
" Only accept *.zip. The plugin causes too many troubles.
let g:zipPlugin_ext = '*.zip'
" }}}

" netrw {{{
" based on http://blog.tojiru.net/article/234400966.html

" Disable netrw
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

" -- setting --

" netrwは常にtree view
let g:netrw_liststyle = 3

" " CVSと.で始まるファイルは表示しない
" let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'

" ヘッダを非表示にする
" let g:netrw_banner=0
" サイズを(K,M,G)で表示する
" let g:netrw_sizestyle="H"

" 日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
let g:netrw_timefmt='%Y/%m/%d(%a) %H:%M:%S'

" previewを右に(alto=1で下右に)
let g:netrw_preview = 1

" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1
" }}}

" Kaoriya Plugin {{{
" (とりあえずOff)設定
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
function! s:plugin_status_update() abort
  let g:user.plugin['quickhl']      = dein#is_sourced('vim-quickhl')
  let g:user.plugin['anzu']         = dein#is_sourced('vim-anzu')
  let g:user.plugin['asyncomplete'] = dein#is_sourced('asyncomplete.vim')
  let g:user.plugin['lexima']       = dein#is_sourced('lexima.vim')
endfunction

function! s:plugin_status_update_and_redefine() abort
  call s:plugin_status_update()
  function! s:plugin_status_update() abort
  endfunction
endfunction

autocmd MyAutoGroup VimEnter * nested call s:plugin_status_update_and_redefine()

function! s:echo_syntax(status) abort " {{{
  if a:status
    redraw | echon synIDattr(synID(line('.'), col('.'), 0), 'name')
  endif
endfunction " }}}

" function! s:set_syntax_echo_status(status) abort {{{
"   let b:SyntaxEchoStatus = a:status
" endfunction " }}}

" util not work yet
function! s:buffer_num() abort " {{{
  let bufmax = bufnr('$')
  let buflist = filter(range(1,bufmax), {i,v -> bufexists(v)})
  let bufnum = len(buflist)

  return bufnum
endfunction " }}}

function! s:tab_num() abort " {{{
  return tabpagenr('$')
endfunction " }}}

function! s:expand_all_buffer_to_tab() abort " {{{
  let save_hidden = &hidden
  set hidden
  silent tabonly!
  silent only!
  bufdo tab split

  " remove last if 2 or more tabs(first buffer dup)
  silent tabclose! $

  let &hidden = save_hidden
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
  echo '====== Tab Page Info ======'
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

" from https://github.com/cohama/.vim/blob/master/init.vim
" 現在のバッファが空っぽならば :drop それ以外なら :tab drop になるコマンド
function! s:smart_drop(tabedit_args) abort " {{{

  if expand('%') == '' && !&modified
    let drop_cmd = 'drop '
  else
    let drop_cmd = 'tab drop '
  endif
  silent execute drop_cmd . a:tabedit_args
endfunction " }}}

" thanks lambdalisue
" keep wait import from
" create dir if nothing
" s:auto_mkdir
" https://github.com/lambdalisue/dotfiles/blob/02549431364232b051cc8bdb5b124e9e75256a6b/nvim/init.vim#L422-L449
"
" clear register data
" s:clear_register()
" https://github.com/lambdalisue/dotfiles/blob/02549431364232b051cc8bdb5b124e9e75256a6b/nvim/init.vim#L500-L506

" }}}

" command {{{

" from https://github.com/cohama/.vim/blob/master/init.vim
" フォーマット変えて開き直す系 {{{
command! Utf8  edit ++enc=utf-8 %
command! Cp932 edit ++enc=cp932 %
command! Unix  edit ++ff=unix   %
command! Dos   edit ++ff=dos    %

command! AsUtf8 set fenc=utf-8 | w
" 追加
command! AsDos  set ff=dos     | w
command! AsUnix set ff=unix    | w
" }}}

" from https://github.com/cohama/.vim/blob/master/init.vim
" 現在のバッファが空っぽならば :drop それ以外なら :tab drop になるコマンド {{{
command! -nargs=* SmartDrop call <SID>smart_drop(<q-args>)
" }}}

" command! SyntaxEchoEnable  :call <SID>set_syntax_echo_status(1)
" command! SyntaxEchoDisable :call <SID>set_syntax_echo_status(0)
command! SyntaxEcho        call <SID>echo_syntax(1)
command! BufferToTab       call <SID>expand_all_buffer_to_tab()
" see http://koturn.hatenablog.com/entry/2018/02/13/000000
command! -bar TabInfo      call <SID>show_tab_info()

" see https://github.com/rinx/dotfiles/blob/master/vimrc
function! s:toggle_option(optname) abort " {{{
  execute 'set ' . a:optname . '!'
  echo ''
  redraw
  execute 'set ' . a:optname . '?'
endfunction " }}}
command! -nargs=1 -complete=option ToggleOption call <SID>toggle_option(<q-args>)
" }}}

" autocmd {{{
" augroup MyAutoGroup
"   autocmd CursorMoved * nested call <SID>echo_syntax(get(b:, 'SyntaxEchoStatus', 0))
" augroup END
" }}}

" local setting {{{
" load non init vimrc setting in .vim/rc/
call g:user.function.load_setting(g:dein.dir.rc)

" }}}

" testing {{{
" template
" " runtimepath update
" let &runtimepath =  &runtimepath . ',' . expand('')
"
" " test function and command
" function! s:testrun() abort " {{{
"   echo 'test not set'
"   " or test write to below
"   " echo 'test run'
"   " let s:V = vital#of('vital')
"   " echo "test result:"
" endfunction " }}}
"
" command! TestRun call <SID>testrun()
" }}}

" }}}
" EOF
