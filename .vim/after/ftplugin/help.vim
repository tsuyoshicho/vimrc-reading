" after/ftplugin/help.vim
" based on https://thinca.hatenablog.com/entry/20110903/1314982646

augroup vimrc_init_help
  autocmd!
augroup END

if &l:buftype !=# 'help'
  " help file edit
  setlocal list tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab textwidth=78
  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
  setlocal nofoldenable

    " thanks 4513CHO
    " from https://github.com/4513ECHO/dotfiles/blob/main/config/vim/after/ftplugin/help.vim
    hi link helpBar Special
    hi link helpBacktick Special
    hi link helpStar Special
    hi link helpIgnore Special
    autocmd vimrc_init_help ColorScheme <buffer>
    \   hi link helpBar Special
    \ | hi link helpBacktick Special
    \ | hi link helpStar Special
    \ | hi link helpIgnore Special
else
  " reading help
  setlocal nofoldenable
endif
