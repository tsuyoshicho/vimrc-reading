" gvimrc
" vim:ft=vim foldmethod=marker

scriptencoding utf-8

" Windows check
let s:is_windows = has('win32')
" Mac check
let s:is_mac     = has('mac')
" Unix check
let s:is_unix    = has('unix')

" see http://qiita.com/janus_wel/items/86082f69190f40df09e8
" display & information
" typical
" margin for 'number' and 'foldcolumn'
set lines=25
set columns=90
set linespace=0

if s:is_mac
  " MacVim $VIM/gvimrc overwrites my .vimrc settings
  " set cmdheight=1
  set cmdheight=2
endif

" " Do not show GUI components
" " (GUI dialog change to console dialog)
" set guioptions-=c

" show no GUI Toolbar(disable)
set guioptions-=T
" keep GUI Window size at scrollbar adding/removing
set guioptions+=k

" other GUI component settings
set scrollfocus

" based on http://blog.remora.cx/2010/03/vim-proggy-and-osaka-fonts.html
" override ambiwidth
" set ambiwidth=double
" comment out, because plugin 'vim-ambiwidth' are adjusted characters.

if s:is_windows && has('directx')
  " Windows DirectX
  set renderoptions=type:directx,renmode:5,geom:1,taamode:1
endif

" no way to use a mouse
" set mouse=
" set nomousefocus
" set mousehide

" FontとOSごとの設定例
" based on http://auewe.hatenablog.com/entry/2013/05/06/200425
if s:is_unix || s:is_mac
  " Unix と Mac の共通設定

  " Unix
  if s:is_unix
    set guifont=Cica:h12,Myrica:h12
    " set printfont=Myrica:h9
    set printfont=Cica:h9
  endif

  " Mac
  if s:is_mac
    set guifont=Cica:h12,Myrica:h12,VL\ Gothic:h12
    " set printfont=Myrica:h9
    set printfont=Cica:h9
  endif
endif

if s:is_windows
  " Windows
  " first powerline patched
  " When VL Gothic isn't found in the system, use MS Gothic.
  set guifont=Cica:h12:cSHIFTJIS:qDRAFT,Myrica:h12:cSHIFTJIS:qDRAFT,VL_Gothic:h12:cSHIFTJIS:qDRAFT,MS_Gothic:h12:cSHIFTJIS:qDRAFT
  " set printfont=Myrica:h9:cSHIFTJIS:qDRAFT
  set printfont=Cica:h9:cSHIFTJIS:qDRAFT
endif

" printer option
" set printheader="%<%f%h%m%=Page %N"

" default: syntax:a, duplex:long, wrap:y
set printoptions&
" line number:yes
set printoptions+=number:y
" linefeed:next page
set printoptions+=formfeed:y

" turn off disabling IM at entering input mode
if exists('&imdisableactivate')
  set noimdisableactivate
endif

" http://qiita.com/enomotok_/items/9d38b716fe883675d35b
" http://kaworu.jpn.org/kaworu/2008-03-07-1.php
" use SKK (nathancorvussolis/corvusskk) setting in .vimrc
" set iminsert=0
" set imsearch=-1

" error status overwrite.
if exists('+belloff')
  set belloff&
endif
set visualbell

" EOF
