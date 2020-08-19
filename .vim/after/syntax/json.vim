scriptencoding utf-8

" json comment
" like key //.+
syn match jsonKeywordMatchCommentKey /"\/\/\([^"]\|\\\"\)*"[[:blank:]\r\n]*\:/  contains=jsonKeywordCommentKey
if has('conceal') && get(g:, 'vim_json_syntax_conceal', 0) == 1
  syn region jsonKeywordCommentKey oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ conceal cchar=/ contains=jsonEscape contained
  " syn region jsonKeywordCommentKey oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ conceal cchar=/ contains=jsonEscape nextgroup=jsonStringCommentValue skipwhite contained
else
  syn region jsonKeywordCommentKey oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=jsonEscape contained
  " syn region jsonKeywordCommentKey oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=jsonEscape nextgroup=jsonStringCommentValue skipwhite contained
endif

" not right work
" need { commentkey : commntvalue } commentvalue only link Comment
" syn match jsonStringMatchCommentValue /"\([^"]\|\\\"\)\+"\ze[[:blank:]\r\n]*[,}\]]/ contains=jsonStringCommentValue
" if has('conceal') && get(g:, 'vim_json_syntax_conceal', 0) == 1
"   syn region jsonStringCommentValue oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ concealends contains=jsonEscape contained
" else
"   syn region jsonStringCommentValue oneline matchgroup=jsonQuote start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=jsonEscape contained
" endif

hi def link jsonKeywordCommentKey Comment
" hi def link jsonStringCommentValue Comment

" EOF

