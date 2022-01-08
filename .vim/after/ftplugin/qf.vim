" after/ftplugin/qf.vim

setlocal nowrap

setlocal number norelativenumber
setlocal signcolumn=no
setlocal foldcolumn=0
setlocal numberwidth=2

" thanks mityu
" from https://github.com/mityu/dotfiles/blob/master/dot_vim/runtime/ftplugin/qf.vim
" via thinca's blog

" use QFEnter plugin
" nnoremap <buffer> <CR> <CR>
nnoremap <buffer> o <CR>zz<C-w>p
" use vim-toggle-quickfix plugin
" nnoremap <buffer> <silent> q <C-w>q
