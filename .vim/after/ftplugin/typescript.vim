" after/ftplugin/typescript.vim

function! s:is_deno() abort
  if finddir('node_modules', expand('%:p:h') . ';') ==# ''
    let b:quickrun_config = get(b:, 'quickrun_config', {})
    let b:quickrun_config['typescript'] = extend({
      \  'type': 'typescript/deno',
      \}, get(g:quickrun_config, 'typescript', {}), "keep")
  endif
  call setenv('NO_COLOR', 1)
endfunction

call s:is_deno()

