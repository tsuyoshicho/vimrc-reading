" gvimrc
" vim:fenc=utf-8 ff=unix ft=vim

set encoding=utf-8
scriptencoding utf-8
" UTF-8のチェック

" Windows check
let s:is_windows = has('win32') || has('win64') " later as historical ==|| has('win16') || has('win95')==
" Mac check
let s:is_mac = has('mac')

" see http://qiita.com/janus_wel/items/86082f69190f40df09e8
" display & information
set lines=25        " typical
set columns=90      " margin for 'number' and 'foldcolumn'
set linespace=0

if s:is_mac
  " MacVim $VIM/gvimrc overwrites my .vimrc settings
  " set cmdheight=1
  set cmdheight=2
endif

" set guioptions-=c    " Do not show GUI components
"                      " (GUI dialog change to console dialog)
set guioptions-=T    " show no GUI Toolbar(disable)
set guioptions+=k    " keep GUI Window size at scrollbar adding/removing

" based on http://blog.remora.cx/2010/03/vim-proggy-and-osaka-fonts.html
set ambiwidth=double " override ambiwidth

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
if has('unix') || s:is_mac
  " Unix と Mac の共通設定

  " Unix
  if has('unix')
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

set printoptions&
" syntax:a, duplex:long, wrap:y
set printoptions+=number:y   " line number:yes
set printoptions+=formfeed:y " linefeed:next page

" turn off disabling IM at entering input mode
if exists('&imdisableactivate')
  set noimdisableactivate
endif

" http://qiita.com/enomotok_/items/9d38b716fe883675d35b
" http://kaworu.jpn.org/kaworu/2008-03-07-1.php
" use SKK (nathancorvussolis/corvusskk) setting in .vimrc
" set iminsert=0
" set imsearch=-1

" Vitsual bell status update. (bell and visutal bell need not opt eixsts
" belloff)
if exists('&belloff')
  set noerrorbells
  set visualbell
  set t_vb=
endif

" EOF
