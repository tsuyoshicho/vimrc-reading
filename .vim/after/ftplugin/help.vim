" after/ftplugin/help.vim
" based on https://thinca.hatenablog.com/entry/20110903/1314982646

if &l:buftype !=# 'help'
  " help file edit
  setlocal list tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab textwidth=78
  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
else
  " reading help
  setlocal nofoldenable
endif
