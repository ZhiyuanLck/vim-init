syn cluster texCmdGroup add=texExplSignature
syn cluster texEnvGroup add=texExplSignature
syn cluster texFoldGroup add=texExplSignature
syn cluster texBoldGroup add=texExplSignature
syn cluster texItalGroup add=texExplSignature
syn cluster texMatchGroup add=texExplSignature
syn cluster texMatchNMGroup add=texExplSignature
syn cluster texStyleGroup add=texExplSignature
syn cluster texPreambleMatchGroup add=texExplSignature
syn cluster texMathMatchGroup add=texExplSignature
syn cluster texMathZoneGroup add=texExplSignature
syn clear texStatement
syn match texStatement /\\[a-zA-Z@_]/ contains=texExplStatement

syn match texExplStatement /\\[a-zA-Z_]\+/ contained
    \ contains=texExplFunction,texExplSignature
highlight link texExplStatement texStatement

" syn match texExplFunction /.*:/ contained
" highlight link texExplFunction texExplStatement

syn match texExplSignature /:[NncVvoxefTFpwD]*/
highlight texExplSignature ctermfg=38


syn clear texOption
syn match texOption "\v(\\)@<!#+[1-9]"
highlight texOption ctermfg=176
