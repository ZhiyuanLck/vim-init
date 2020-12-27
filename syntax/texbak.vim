function! s:tex_cluster_add(groups)
  let clusters = [
    \ 'texCmdGroup', 'texEnvGroup', 'texFoldGroup',
    \ 'texBoldGroup', 'texItalGroup',
    \ 'texMatchGroup', 'texMatchNMGroup',
    \ 'texStyleGroup', 'texPreambleMatchGroup',
    \ 'texMathMatchGroup', 'texMathZoneGroup'
    \]
  for cluster in clusters
    exec 'syn cluster '.cluster.' add='.a:groups
  endfor
endfunction

" call <SID>tex_cluster_add('texExplSignature')

" syn clear texStatement
syn match texStatement /\\[a-zA-Z@_:]\+/ contained contains=texExplStatement,texExplSignature

call TexNewMathZone("A","displaymath",1)
call TexNewMathZone("B","eqnarray",1)
call TexNewMathZone("C","equation",1)
call TexNewMathZone('AmsA', 'align', 1)
call TexNewMathZone('AmsB', 'alignat', 1)
call TexNewMathZone('AmsD', 'flalign', 1)
call TexNewMathZone('AmsC', 'gather', 1)
call TexNewMathZone('AmsD', 'multline', 1)
call TexNewMathZone('AmsE', 'xalignat', 1)
call TexNewMathZone('AmsF', 'xxalignat', 0)
call TexNewMathZone('AmsG', 'mathpar', 1)

syn match texExplStatement /\\[a-zA-Z_]\+/ contained nextgroup=texExplSignature
highlight link texExplStatement texStatement

syn match texExplSignature /:[NncVvoxefTFpwD]*/ contained
highlight texExplSignature ctermfg=38

syn match texOption /\v(\\)@<!#+[1-9]/ contained
highlight texOption ctermfg=176
