" ======================================================================
"
" search.vim - 文本、定义查找与跳转
"    - F2 Grip光标下单词
"
" Author: zhiyuan
" GitHub: https://github.com/ZhiyuanLck
" Creation Time: 2018-08-14 13:42:06
" Last Modified: 2018-08-14 17:05:14
"
" ======================================================================

command -nargs=1 Sd execute "py3 print([(s.trigger, s.location) for s in UltiSnips_Manager._snips('<args>', True)])"

" 查看tex源码
function! LookTeXSource(name)
  if executable('kpsewhere') != 1
    return
  endif
  let path = system('kpsewhere '.a:name)
  if match(path, 'texmf-dist') != -1
    exec 'tabedit '.path
  else
    echoerr 'file '.a:name.' not found!'
  endif
endfunction


" 查看tex文档
function! LookTeXDoc(name)
  if executable('texdoc') != 1
    return
  endif
  exec "AsyncRun -silent texdoc ".a:name
endfunction

function s:look_tex_map()
  nnoremap <silent><space>st :call LookTeXSource(input('TeX文件名: '))<cr>
  nnoremap <silent><space>ss :call LookTeXSource(expand('<cword>').'.sty')<cr>
  nnoremap <silent><space>sc :call LookTeXSource(expand('<cword>').'.cls')<cr>
  nnoremap <silent><space>sd :call LookTeXSource(expand('<cword>').'.dtx')<cr>
  nnoremap <silent><space>di :call LookTeXDoc(input('TeX doc name: '))<cr>
  nnoremap <silent><space>dc :call LookTeXDoc(expand('<cword>'))<cr>
endfunction

augroup SearchTeX
  au!
  au BufNewFile,BufRead *.tex,*.sty,*.cls,*.dtx call <SID>look_tex_map()
augroup END

" 查看脚本载入顺序
function! CheckLoad()
  let out = execute('scriptnames')
  exec 'tabnew | setlocal buftype=nofile | setlocal hidden | 0put=out'
endfunction

command! CheckLoad call CheckLoad()

" 查看高亮组
function! s:show_highlight()
  let id = synID(line('.'), col('.'), 1)
  let hg = id->synIDattr('name')
  let link = id->synIDtrans()->synIDattr('name')
  if hg != ''
    exec "highlight ".hg
    if link !=# hg
      exec "highlight ".link
    endif
  endif
endfunction
nnoremap <silent><F3> :call <sid>show_highlight()<CR>
inoremap <silent><F3> <cmd>call <sid>show_highlight()<CR>
function! s:show_syn_stack()
  let syn_stack = []
  for id in synstack(line("."), col("."))
    call add(syn_stack, synIDattr(id, "name"))
  endfor
  echom syn_stack
endfunction
nnoremap <S-F3> :call <SID>show_syn_stack()<CR>
inoremap <S-F3> <ESC>:call <SID>show_syn_stack()<CR>

" help命令
command! -nargs=? H vert bo help <args>@en
