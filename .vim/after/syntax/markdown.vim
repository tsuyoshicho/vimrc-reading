scriptencoding utf-8

" from https://chitoku.jp/computers/markdown-line-break-on-vim
" markdown paragraph sep conceal
syn match markdownLineBreak " \{2,\}$" conceal cchar=↵
hi def link markdownLineBreak Comment

" EOF

