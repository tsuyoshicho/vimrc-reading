" thanks kawarimidoll
" from https://zenn.dev/kawarimidoll/articles/8abb570dac523f

function! s:sort_qf(a, b) abort
  return a:a.lnum > a:b.lnum ? 1 : -1
endfunction

function! s:markdown_outline() abort
  let fname = @%
  let cur_nr = winnr()
  if get(g:, 'markdown_outline_output_qf', 0)
    " qf
    let grep_cmd = 'vimgrep'
    let grepadd_cmd = 'vimgrepadd'
    let close_cmd = 'cclose'
    let open_cmd = 'copen'
    let Getlist_func = function('getqflist')
    let Setlist_func = function('setqflist')
  else
    " loclist
    let grep_cmd = 'lvimgrep'
    let grepadd_cmd = 'lvimgrepadd'
    let close_cmd = 'lclose'
    let open_cmd = 'lopen'
    let Getlist_func = function('getloclist', [cur_nr])
    let Setlist_func = function('setloclist', [cur_nr])
  endif

  " # heading
  execute grep_cmd '/^#\{1,6} .*$/j' fname

  " heading
  " ===
  execute grepadd_cmd '/\zs\S\+\ze\n[=-]\+$/j' fname

  let qflist = Getlist_func()
  if len(qflist) == 0
    call execute(close_cmd)
    return
  endif

  " recover current window(synID work only current window)
  call win_gotoid(win_getid(cur_nr))
  call filter(qflist,
  \ 'synIDattr(synID(v:val.lnum, v:val.col, 1), "name") != "markdownCodeBlock"'
  \ )
  call sort(qflist, 's:sort_qf')
  call Setlist_func(qflist)
  call Setlist_func([], 'r', {'title': fname .. ' TOC'})
  call execute(open_cmd)
endfunction

nnoremap <buffer> gO <Cmd>call <sid>markdown_outline()<CR>

" EOF
