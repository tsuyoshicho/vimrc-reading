" runtimepath update
" let &runtimepath =  &runtimepath . ',' . expand('D:/Data/ReposWork/git/vital-test')
" let &runtimepath =  &runtimepath . ',' . expand('D:/Data/ReposWork/git/vital-globe')
let &runtimepath =  &runtimepath . ',' . expand('D:\Data\ReposWork\git\vital-codec')
let &runtimepath =  &runtimepath . ',' . expand('D:\Data\ReposWork\git\vital-Builder')
let &runtimepath =  &runtimepath . ',' . expand('D:\Data\ReposWork\git\vital.vim\test\_testdata\vital\datatest')
let &runtimepath =  &runtimepath . ',' . expand('D:\Data\ReposWork\git\tmp')

" test function and command
function! s:testrun() abort
  " echo 'test not set'
  " or test write to below
  echo 'test run'

  let s:GUID = g:V.import('ID.GUID')
  let guid = s:GUID.generate()
  echomsg 'GUID:' . guid

  let guid_dec = s:GUID.decode(guid)
  echomsg 'decode:' . string(guid_dec)
endfunction

command! TestRun call <SID>testrun()

